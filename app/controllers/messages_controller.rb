class MessagesController < ApplicationController
	
  before_filter :authenticate_user, :browser_timezone
  before_filter :clear_temp_photo, :only=>[:new,:reply_message_form,:index,:message_thread_listing]
  require 'fileutils'
  require 'send_sms'
  layout "message", only: [:index,:new,:reply_message_form]
  def index	  
    cookies[:message]=""
    if !cookies[:msg_act].nil? &&cookies[:msg_act]=="create_msg"
        @create_msg=true
    end
    @unread = MessageThreadViewer.where("user_id=? and read_status=?",current_user.user_id,false)
    #@unread = MessageThreadViewer.where("user_id=?",current_user.user_id)
    @msg_list =  Message.find_by_sql("select * from messages as m left join message_threads as mt on m.message_id=mt.message_id
 left join message_thread_viewers as mv on mt.thread_id=mv.message_thread_id where ((mt.posted_by=#{current_user.user_id} and mt.msg_flag=true )
  or (mv.user_id=#{current_user.user_id} and mv.msg_thread_flag=true)) order by m.message_id desc").uniq
   @first_mess=params[:rep_id]
    if @msg_list && @msg_list.present? && !@msg_list.nil?
      @first_mess = ((params[:rep_id] && params[:rep_id].present?) ? Message.find(params[:rep_id]) : Message.find(@msg_list.first.message_id))
      @mess_threads = MessageThread.find_by_sql("select mt.* from message_threads as mt left join message_thread_viewers as mv on mt.thread_id=mv.message_thread_id where(mt.message_id=#{@first_mess.message_id} and ((mt.posted_by=#{current_user.user_id} and mt.msg_flag=true) or mv.user_id=#{current_user.user_id})) order by mt.posted_on asc").uniq if @first_mess && @first_mess.present? && !@first_mess.nil?
      @mode = params[:mode]
    end
    cookies[:msg_act]=""
  end
 
 
  def new

    if !params[:mode].nil? && params[:mode].present?
      @mode=params[:mode]
    else
      @mode="parent"
    end
    if !params[:frm_group].nil? && params[:frm_group].present?
      fam=[]
      @famgroup=params[:frm_group].split(',')
      !@famgroup.nil? && @famgroup.each do |f|
        famgroup=ContactUserGroup.where("contact_group_id=?",f).map(&:contact_user_id) 
        fam<<famgroup if !famgroup.nil? && famgroup.present?
      end
      @fam=fam.uniq if !fam.nil? && fam.present?
    end
    owngroup=[]
    @fam_group=@fam.flatten if !@fam.nil? && @fam.present?
    !@fam_group.nil? && @fam_group.each do |fg|
        email=ContactUser.where("contact_id=? and contact_email!=?",fg,"").map(&:contact_email) 
        owngroup<< email if !email.nil? && email.present?
      end
      @owngroup=owngroup.uniq if !owngroup.nil? && owngroup.present?
    if !params[:frm_contacts].nil? && params[:frm_contacts].present?
      con=[]
      @contact=params[:frm_contacts].split(',')
      !@contact.nil? && @contact.each do |c|
        email=ContactUser.where("contact_id=? and contact_email!=?",c,"").map(&:contact_email) 
        con<< email if !email.nil? && email.present?
      end
    end
   @con=con.uniq if !con.nil? && con.present?
  if !@owngroup.nil? && @owngroup.present? && !@con.nil? && @con.present?
    selected_emails=@owngroup+@con 
  elsif !@owngroup.nil? && @owngroup.present?
    selected_emails=@owngroup
  elsif !@con.nil? && @con.present?
    selected_emails=@con
  end
  @selected_emails= selected_emails.uniq if !selected_emails.nil? && selected_emails.present? 
    @c_url= params[:c_url]
    @contact_group = ContactGroup.find(params[:users]) if !params[:users].nil? && params[:users]!="all"
    @all_contact=ContactUser.where("user_id=? and contact_email!=?",current_user.user_id,"").map(&:contact_email) if !params[:users].nil? && params[:users]=="all"
    if @contact_group
      @ss=@contact_group.contact_users
      @friends=[]
      @ss.each do |s|
        @friends << s.contact_email if s.contact_email
      end
      elsif @all_contact
        @friends=@all_contact
    end
  end


  def create
    if params[:send_to] && !params[:send_to].nil? && params[:send_to].present?
      @users = params[:send_to].gsub(/\s+/, "").strip.split(',').map!(&:downcase).uniq
      # @users = params[:send_to].split(',')
      @message = Message.new
      @get_current_url = request.env['HTTP_HOST']
      #This below method  is from Message model to save message alone
      @s_msg = @message.messageSave(params[:subject],params[:pmode],params[:messager_image],'message',nil)
      #This below method  is from Message model to save message_thread,message_files,viewers
      cookies[:msg_act]="create_msg"
      if @s_msg && @s_msg.message_id && @s_msg.message_id.present?
	      msg_thrd = @s_msg.msgFileSave(current_user, params[:cmt], @users,params[:for_reply_type],fwd=[],params[:show_msg_card],@get_current_url,'message')
	      dir = "#{Rails.root}/public/temp_message_upload/#{current_user.user_id}"
	      FileUtils.remove_dir dir, true if File.exists?(dir)
	      render :text => true
      else
	      render :text => false
      end
    end
  end

  #Auto Populating email to send message
  def message_email
    params[:query] = params[:query].blank? ? "" : params[:query]
    @user_mails = []
    @user_emails = ContactUser.where("user_id=?",current_user.user_id)
    @groups =  ContactGroup.where("user_id=?",current_user.user_id)
    @user_emails.each do |email|
      if !email.contact_email.blank?
        if(!params[:query].blank? && !email.contact_email.downcase.scan(params[:query].downcase).blank?)
          @user_mails << {"id" => email.contact_id,"label" => email.contact_email,"value" => email.contact_email}
        end
      end
    end
    @groups.each do |group|
      if (!group.group_name.blank? && !group.contact_users.empty? && group.contact_users.present?)
        if(!params[:query].blank? && !group.group_name.downcase.scan(params[:query].downcase).blank?)
          @user_mails << {"id" => group.group_id,"label" => group.group_name,"value" => group.group_name}
        end
      end
    end
    @user_mails = @user_mails.flatten.uniq
    render :json => @user_mails
  end
 
  #To add the multiple uploaded files to temp folder
  def add_to_temp
    orig_dir = FileUtils.mkdir("#{Rails.root}/public/temp_message_upload",0755) if !File.exists?("#{Rails.root}/public/temp_message_upload")
    dir = "#{Rails.root}/public/temp_message_upload/#{current_user.user_id}"
    if params[:myfile] && params[:myfile].present? && !params[:myfile].nil? && params[:myfile].original_filename && params[:myfile].original_filename.present? && !params[:myfile].original_filename.nil? && params[:myfile].original_filename!=''
		  Dir.mkdir(dir,0755)  if !File.exists?(dir)
		  f_name = params[:myfile].original_filename.split('.')
		  renamed_file_path="#{dir}/#{f_name[0]}_#{Time.now.strftime('%y%m%d%H%M%S')}.#{f_name[1]}"
		  FileUtils.cp(params[:myfile].tempfile, renamed_file_path) 
		  render :text=>true
    else
      render :text=>false
    end
  end
 
  #Ajax call for each message click
  def message_thread_listing
     @msgtype=params[:msgtype] if !params[:msgtype].nil?
    if !params[:count].nil? && params[:count].present?
      @unread = MessageThreadViewer.where("user_id=? and read_status=? and msg_thread_flag=?",current_user.user_id,false,true)
      @msg_count=@unread.count
      render :text=>@msg_count
    else
      @first_mess = Message.find(params[:message_id])
      th_id = @first_mess.message_threads.map(&:thread_id)
      th_id.each do |read|
        @read = MessageThreadViewer.where("message_thread_id=? and user_id=?",read,current_user.user_id)
        @read.update_all(:read_status=>true) if !@read.nil?
      end if !th_id.nil?
      @mode = params[:user_mode]
      @mess_threads = MessageThread.find_by_sql("select mt.* from message_threads as mt left join message_thread_viewers as mv on mt.thread_id=mv.message_thread_id where(mt.message_id=#{@first_mess.message_id} and ((mt.posted_by=#{current_user.user_id} and mt.msg_flag=true) or mv.user_id=#{current_user.user_id})) order by mt.posted_on asc").uniq if @first_mess && @first_mess.present? && !@first_mess.nil?
      render :partial => 'message_thread_list' 
    end
  end
 
  #To delete message
  def message_delete
    if params['msg_ids'] && params['msg_ids'].present? && !params['msg_ids'].nil? && params['msg_ids']!='' && params['user_id'] && params['user_id'].present? && !params['user_id'].nil? && params['user_id']!=''
      m_ids = params['msg_ids'].gsub(/\s+/, "").strip.split(',')
      m_ids = m_ids.reject{|a| a.nil? || a==''}
      thrds = MessageThread.where("message_id in (?) and posted_by=?",m_ids,params['user_id'])
      thread_ids =  MessageThread.where("message_id in (?)",m_ids).map(&:thread_id)
      viewers = MessageThreadViewer.where("message_thread_id in (?) and user_id=?",thread_ids,params['user_id'])
      thrds.update_all(:msg_flag => false)
      viewers.update_all(:msg_thread_flag => false)
      @msg_list =  Message.find_by_sql("select * from messages as m left join message_threads as mt on m.message_id=mt.message_id
		 left join message_thread_viewers as mv on mt.thread_id=mv.message_thread_id where ((mt.posted_by=#{current_user.user_id} and mt.msg_flag=true )
		  or (mv.user_id=#{current_user.user_id} and mv.msg_thread_flag=true)) order by m.message_id desc").uniq
      if @msg_list && @msg_list.present? && !@msg_list.nil?
        @first_mess = ((params[:rep_id] && params[:rep_id].present?) ? Message.find(params[:rep_id]) : Message.find(@msg_list.first.message_id))
        @mess_threads = MessageThread.find_by_sql("select mt.* from message_threads as mt left join message_thread_viewers as mv on mt.thread_id=mv.message_thread_id where(mt.message_id=#{@first_mess.message_id} and ((mt.posted_by=#{current_user.user_id} and mt.msg_flag=true) or mv.user_id=#{current_user.user_id}))").uniq if @first_mess && @first_mess.present? && !@first_mess.nil?
        @mode = params[:mode]
      end
      @return= "true"
    else
      @return="false"
    end
    respond_to do |format|
      format.js
      format.html
    end

  end
 
  #To delete message_thread
  def message_thread_delete
    if params[:msg_thrd_id] && params[:msg_thrd_id].present? && !params[:msg_thrd_id].nil?
      result = MessageThread.deleteMsgThrd(params[:msg_thrd_id],current_user)
      @msg_list =  Message.find_by_sql("select * from messages as m left join message_threads as mt on m.message_id=mt.message_id
		 left join message_thread_viewers as mv on mt.thread_id=mv.message_thread_id where ((mt.posted_by=#{current_user.user_id} and mt.msg_flag=true )
		  or (mv.user_id=#{current_user.user_id} and mv.msg_thread_flag=true)) order by m.message_id desc").uniq
      @msg_id = result[0]
      last_msg =  result[1]
      if @msg_list && @msg_list.present? && !@msg_list.nil?
        @first_mess = ((params[:rep_id] && params[:rep_id].present?) ? Message.find(params[:rep_id]) : Message.find(@msg_list.first.message_id))
        @mess_threads = MessageThread.find_by_sql("select mt.* from message_threads as mt left join message_thread_viewers as mv on mt.thread_id=mv.message_thread_id where(mt.message_id=#{@first_mess.message_id} and ((mt.posted_by=#{current_user.user_id} and mt.msg_flag=true) or mv.user_id=#{current_user.user_id}))").uniq if @first_mess && @first_mess.present? && !@first_mess.nil?
        @mode = params[:mode]
      end
      @return= 'true'+'$'+last_msg
      #render :text=> 'true'+'$'+last_msg
	    respond_to do |format|
	      format.js
	      format.html
	    end
    end
  end
 
  #Reply message form new
  def reply_message_form
    @type = params[:type]
    @mode = params[:mode]
    @thrd_id = params[:thr_id]
    if @thrd_id && @thrd_id.present? && !@thrd_id.nil? && @type && @type.present? && !@type.nil?
      @user_emails = ContactUser.where("user_id=?",current_user.user_id).map(&:contact_email)
      @group = ContactGroup.where("user_id=?",current_user.user_id).map(&:group_name)
      @user_emails = (@user_emails << @group).flatten.uniq
      @msg_thrd = MessageThread.find(@thrd_id)
      @msg = @msg_thrd.message
      from_user = User.find(@msg_thrd.posted_by).email_address if @msg_thrd && @msg_thrd.present? && !@msg_thrd.nil?
      viewers = @msg_thrd.receivers_email.gsub(/\s+/, "").strip.split(',') if @msg_thrd && @msg_thrd.present? && !@msg_thrd.nil? && @msg_thrd.receivers_email && @msg_thrd.receivers_email.present? && !@msg_thrd.receivers_email.nil?
      @res_viewer=[]
      if  (current_user.user_id == @msg_thrd.posted_by) && (@type=='reply' || @type=='reply_all')
        viewers << from_user if ((viewers.count==1 && viewers[0]==current_user.email_address && (@type=='reply_all' || @type=='reply')) )
        @res_viewer = viewers
      elsif  (current_user.user_id != @msg_thrd.posted_by && @type=='reply_all')
			  @res_viewer =  viewers.reject{|em| em==current_user.email_address || em==''} if viewers && viewers.present? && !viewers.nil?
			  @res_viewer << from_user
			  #~ @res_viewer << from_user if (viewers.count==1 && viewers[0]==current_user.email_address) 
      elsif  (current_user.user_id != @msg_thrd.posted_by && @type=='reply')
        @res_viewer << from_user
      elsif (@type=='forward')
				@files = @msg_thrd.message_files
      end
			@res_viewer = @res_viewer.uniq.to_s.gsub('"','').gsub("[","").gsub("]","") if @res_viewer && @res_viewer.present? && !@res_viewer.nil?
    end
  end
 
  #Reply message create
  def reply_message_create
    if params[:send_to] && !params[:send_to].nil? && params[:send_to].present?
      @old_msg_thrd = MessageThread.find(params[:for_reply_thrd_id])
      @old_msg = @old_msg_thrd.message
      
      @users = params[:send_to].gsub(/\s+/, "").strip.split(',').map!(&:downcase).uniq
      
      if params[:messager_image] && params[:messager_image].present? && !params[:messager_image].nil?
        test_img = params[:messager_image]
      else
        test_img = File.open(@old_msg.message_card.path) if @old_msg && @old_msg.message_card && !@old_msg.message_card.nil? && @old_msg.message_card.present?
      end
      fwd_files=[]
      if (params[:for_reply_type] && params[:for_reply_type].present? && !params[:for_reply_type].nil? && params[:for_reply_type]=='forward') #Forward Message
	@chk_sub = params[:subject].eql?(@old_msg.subject)
	if !@chk_sub #Forward Message new thread based on subject changes as in gmail
		@msg = Message.new
		#This below method  is from Message model to save message alone
		@message = @msg.messageSave(params[:subject],params[:pmode],test_img,'message',nil)
        else 
		@message =  @old_msg_thrd.message
	end 
		old_msg_file_ids = @old_msg_thrd.message_files.map(&:message_file_id) if @old_msg_thrd.message_files && @old_msg_thrd.message_files.present?
		#Forward Message - Attachments
		if params[:forward_msg_del] &&  params[:forward_msg_del].present? &&  !params[:forward_msg_del].nil? && params[:forward_msg_del]!=""
		  new_msg_file_ids =  params[:forward_msg_del].split(',').map(&:to_i)
		  final_ids = old_msg_file_ids-new_msg_file_ids
		else
		  final_ids = old_msg_file_ids if old_msg_file_ids && !old_msg_file_ids.nil? && old_msg_file_ids.present?
		end
		final_ids && final_ids.each do |old_f|
		  if old_f && !old_f.nil? && old_f.present?
		    old_msg_f = MessageFile.find(old_f)
		    #~ f_path = File.read(old_msg_f.message_file.path)
		    fwd_files << old_msg_f.message_file.path
		  end
		end
      else #reply & reply to all - Message
        @message =  @old_msg_thrd.message
      end

      @get_current_url = request.env['HTTP_HOST']
      #This below method  is from Message model
      @message.msgFileSave(current_user, params[:cmt], @users,params[:for_reply_type],fwd_files,params[:show_msg_card],@get_current_url,'message')

      dir = "#{Rails.root}/public/temp_message_upload/#{current_user.user_id}"
      FileUtils.remove_dir dir, true if File.exists?(dir)
      cookies[:msg_act]="create_msg"
      render :text => true
    end
  end
  
  
  #Chat Reply
  def chat_reply
	   if params[:message_id] && !params[:message_id].nil? && params[:message_id].present?
		         #~ @users = params[:send_to].gsub(/\s+/, "").strip.split(',').uniq
			 #~ @old_msg_thrd = MessageThread.find(params[:for_reply_thrd_id])
			 @message = Message.find(params[:message_id])
			 @m_thrds = @message.message_threads
			 @users = []
			 if @message.message_type=='message'
				 #~ posted_bys = @m_thrds.map(&:posted_by).uniq
				 #~ @first_users = User.where("user_id in (?)",posted_bys).map(&:email_address).uniq if posted_bys && posted_bys.present?
				 @first_users = @m_thrds.map(&:posted_email).uniq
				 @users << @first_users if @first_users && @first_users.present?			 
				 @m_thrds.each do |thrd|
					 @users << thrd.receivers_email.split(',')
				 end
				 @users = @users.flatten.reject{|x| x==current_user.email_address} if !(@users.count==1 && @users.first.email_address==current_user.email_address)
			 elsif @message.message_type=='fam_network'
				@users =  ContactUser.find_by_sql("select * FROM contact_users
                                        INNER JOIN contact_user_groups as fam
                                        ON contact_users.contact_id = fam.contact_user_id and fam.fam_accept_status=true and fam.contact_group_id='#{@message.contact_group_id}'").map(&:contact_email)
				@fam_netwrok_group = ContactGroup.where("group_id =#{@message.contact_group_id}").last
			       @users << User.find(@fam_netwrok_group.user_id).email_address if @fam_netwrok_group && @fam_netwrok_group.user_id && !@fam_netwrok_group.user_id.nil?
			 end
       @users = @users.flatten.uniq
			 #@users = @users.flatten.uniq.reject{|u| u==current_user.email_address}
			 test_img = File.open(@message.message_card.path) if @message && @message.message_card && !@message.message_card.nil? && @message.message_card.present? && File.exists?(@message.message_card.path)
			@get_current_url = request.env['HTTP_HOST']
			#This below method  is from Message model
			msg_thrd = @message.msgFileSave(current_user, params[:cmt], @users.uniq,params[:for_reply_type],fwd_files=[],params[:show_msg_card],@get_current_url,@message.message_type)
			dir = "#{Rails.root}/public/temp_message_upload/#{current_user.user_id}"
			FileUtils.remove_dir dir, true if File.exists?(dir)
			message_thread_listing
	   end
  end
  
  
  
  #download message files 
  def download_message_files
    if !params[:id].nil?
      @ids = eval(params[:id])
      @id_class_name = @ids.class.to_s
      #Single file download
      if @id_class_name=='Fixnum'
        p_file = MessageFile.where("message_file_id=?",@ids).first
        path = "#{p_file.message_file.path}"
        #Multifile download
      else
        p_file = MessageFile.where("message_file_id in (?)",@ids)
        dir_name = "#{Rails.root}/public/system/zips"
        unless File.directory?(dir_name)
          Dir.mkdir "#{Rails.root}/public/system/zips"
        end

        path = "#{Rails.root}/public/system/zips/message_files_#{current_user.user_id}.zip"
        File.delete(path) if File.file?(path)

        Zip::ZipFile.open(path, Zip::ZipFile::CREATE) { |zipfile|
          p_file.each do |attachment|
            zipfile.add( attachment.message_file_file_name, attachment.message_file.path)
          end
        }
      end
      if p_file && p_file.present? && File.exists?(path)
        if @id_class_name == 'Fixnum'
          send_file path, :x_sendfile=>true,  :disposition => "attachment"
        else
		      send_file path, :type => 'application/zip', :disposition => 'attachment', :filename => "message_files_#{current_user.user_id}.zip"
        end
      else
        redirect_to "/messages?mode=#{params[:mode]}"
      end
    end
  end
 
  #To get group users in autocomplete
  def get_group_users
    if params[:user_data] && params[:user_data].present? && !params[:user_data].nil?
      final_users=''
      contact_group = ContactGroup.where("lower(group_name)=? and user_id=?",params[:user_data].downcase,current_user.user_id).last
      group_users = contact_group.contact_user_groups.map(&:contact_user_id) if contact_group && contact_group.present?
      group_users && group_users.select { |group_u|
        a = ContactUser.find(group_u) if group_u && !group_u.nil?
        final_users = ((final_users=='') ? (final_users+a.contact_email) : (final_users+','+a.contact_email)) if a && !a.nil? && a.contact_email && !a.contact_email.nil?
      }
      render :text => final_users
    end
  end
  
#Adding mobile number and send verification code
def add_mobile_send_code
	if params[:resend] && params[:resend].present?
		user_prof = current_user.user_profile
		if (params[:mobile_num] && params[:mobile_num].present?) || (params[:resend]=='true')
			mobile_no = (params[:resend]=='true') ? user_prof.sms_mobile_num : params[:mobile_num]
			code = (1..8).map{|i| ('a'..'z').to_a[rand(26)]}.join
			chk_old = (user_prof.sms_mobile_num && params[:mobile_num]==user_prof.sms_mobile_num) ? true : false
			if (!chk_old && (params[:chk_add_rem]=='add' || params[:resend]=='true'))
				user_prof.update_attributes(sms_mobile_num: mobile_no, sms_verify_code: code, sms_notify_status: false) 
			elsif (params[:chk_add_rem]=='remove')
				chk_update = user_prof.update_attributes(sms_mobile_num: '', sms_verify_code: '', sms_notify_status: false)
				pn_notify = ParentNotification.where("user_id=? and notify_by_sms=? ",current_user.user_id,true)
				pn_notify.update_all(:notify_by_sms=>false) if !pn_notify.nil? && chk_update
			end
		end
		@get_current_url = request.env['HTTP_HOST']
		SendSMS.send_sms_to_users(current_user,current_user,nil,nil,user_prof,@get_current_url) if (params[:chk_add_rem]!='remove' && user_prof.sms_mobile_num && user_prof.sms_mobile_num.present?)
		if params[:mobile_num] && params[:mobile_num].present?
			if chk_old && params[:chk_add_rem]=='add'
				render :text => false
			else
				#~ render :partial => '/user_profiles/mob_num_settings', :locals => {:number => user_prof.sms_mobile_num, :status => user_prof.sms_notify_status}
				render :text => true
			end
		else
			render :text => true
		end
	end
end

#verify code
def mobile_code_verification
	if params[:code_verify] && params[:code_verify].present?
		user_prof = current_user.user_profile
		if params[:code_verify] == user_prof.sms_verify_code
			user_prof.update_attributes(sms_notify_status: true)
	
#To check the check boxes in settings page - fam_network
	p_notify_ids = [4,7]
	p_notify_type = 'fam_network'
	p_notify_ids && p_notify_ids.each do |p_noti|
	  provider_notify_default=ParentNotification.find_by_parent_notify_id_and_user_id("#{p_noti}", "#{current_user.user_id}") if p_noti && !p_noti.nil? && !current_user.nil?
          if provider_notify_default
            provider_notify_default.update_attributes(:parent_notify_id=>p_noti, :notify_flag=>true, :notify_type=>p_notify_type,:notify_by_sms=>true) if !provider_notify_default.nil?
          else
            provider_notify_default_detail = ParentNotification.create(:user_id => current_user.user_id, :parent_notify_id =>p_noti, :notify_flag=>true, :notify_type=>p_notify_type, :inserted_date =>Time.now, :modified_date =>Time.now,:notify_by_sms=>true)
          end
        end
#To check the check boxes in settings page - fam_network	

			
			render :text => user_prof.sms_mobile_num
		else
			render :text => false
		end
	end
end

 
  private
  #To clear temp photo folder for multiple file upload
  def clear_temp_photo
	 	dir = "#{Rails.root}/public/temp_message_upload/#{current_user.user_id}"
		FileUtils.remove_dir dir, true if File.exists?(dir)
  end
	

  #Detecting the user's time zone using js and store in cookie
	def browser_timezone
	  @time_zone  = cookies["browser.timezone"].blank? ? Time.zone : cookies["browser.timezone"]
	end

end
