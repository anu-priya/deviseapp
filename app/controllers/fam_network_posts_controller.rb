class FamNetworkPostsController < ApplicationController
  # GET /fam_network_posts
  # GET /fam_network_posts.json
  before_filter :authenticate_user
  require 'fileutils'
  def index
    @fam_network_posts = FamNetworkPost.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fam_network_posts }
    end
  end


  def create_fam_post
    # @users = params[:send_to].split(',')
    @get_current_url = request.env['HTTP_HOST']
    params[:fam_network] = cookies[:fam_network] 
    @mode=params[:mode] if !params[:mode].nil? 
    cookies[:msg_act]="create_msg"
    @fam_post = Message.new
    @post_msg = @fam_post.messageSave(params[:subject_text],nil,params[:messager_image],'fam_network',cookies[:fam_network])
    @ttl_fam_users = ContactUser.find_by_sql("select * FROM contact_users
                                        INNER JOIN contact_user_groups as fam
                                        ON contact_users.contact_id = fam.contact_user_id and fam.fam_accept_status=true and fam.contact_group_id='#{cookies[:fam_network]}'")
    #@fam_users = @ttl_fam_users.map(&:contact_email)
    @fam_users_ids = @ttl_fam_users.map(&:contact_id)
    @fam_users=[]
    @fam_users= params[:send_to].split(",") if !params[:send_to].nil?
    @fam_netwrok_group = ContactGroup.where("group_id =#{cookies[:fam_network]}").last
    #@fam_users << params[:send_to] if !params[:send_to].nil?
    #@fam_users << User.find(@fam_netwrok_group.user_id).email_address if @fam_netwrok_group && @fam_netwrok_group.user_id && !@fam_netwrok_group.user_id.nil?
    #~ @fam_users = @fam_users.reject{|a| a==current_user.email_address}
    if @post_msg && @post_msg.message_id && @post_msg.message_id.present?
      thrd = @post_msg.msgFileSave(current_user, params[:message_text], @fam_users, params[:for_reply_type],fwd=[],false,@get_current_url,'fam_network')
      dir = "#{Rails.root}/public/temp_message_upload/#{current_user.user_id}"
      FileUtils.remove_dir dir, true if File.exists?(dir)
      #~ MessageThread.send_notification_network(@fam_users_ids,current_user,thrd)
    end
    #    @fam_users.each do |f|
    #      if !f.contact_email.nil? && f.contact_email!=""
    #        if "#{current_user.email_address}" != "#{f.contact_email}"
    #          FamNetworkMailer.delay(queue: "Send message", priority: 2, run_at: 10.seconds.from_now).fam_create_network_mail(to_user,@fam_netwrok_group,@get_current_url)
    #   end
    #      end
    #    end
    # @result = FamtivityNetworkMailer.delay(queue: "Fam Network", priority: 2, run_at: 10.seconds.from_now).fam_create_network_mail(current_user,@fam_netwrok_group,"assada")
    #~ if @fam_users.length >0
    #~ @fam_users.each do |s|
    #~ if s.contact_email!="" && !s.contact_email.nil?
    #~ if s.fam_accept_user_id != current_user.user_id.to_s
    #~ @result = FamtivityNetworkMailer.delay(queue: "Fam Network", priority: 2, run_at: 10.seconds.from_now).fam_create_post_network_mail(s,@fam_netwrok_group,"assada")
    #~ end
    #~ end
    #~ end
    #~ end if !@fam_users.nil?
    cookies.delete :fam_network
    respond_to do |format|
      format.js
    end
    #render :text => true
  end
  
  #Post Reply in Fam network page
  def reply_fam_post
	  if params[:message_id] && params[:reply_post] && params[:message_id].present? && params[:reply_post].present?
      @get_current_url = request.env['HTTP_HOST']
      @message = Message.find(params[:message_id])
      #~ @message_threads = @message.message_threads
		  if @message && !@message.nil?
			@ttl_fam_users =  ContactUser.find_by_sql("select * FROM contact_users
							INNER JOIN contact_user_groups as fam
							ON contact_users.contact_id = fam.contact_user_id and fam.fam_accept_status=true and fam.contact_group_id='#{@message.contact_group_id}'")
			@fam_users = @ttl_fam_users.map(&:contact_email)
			@fam_users_ids = @ttl_fam_users.map(&:contact_id)
			@fam_netwrok_group = ContactGroup.where("group_id =#{@message.contact_group_id}").last
			@fam << User.find(@fam_netwrok_group.user_id).email_address if @fam_netwrok_group && @fam_netwrok_group.user_id && !@fam_netwrok_group.user_id.nil?
			
      #~ @fam_users = @fam_users.reject{|a| a==current_user.email_address}
			thrd = @message.msgFileSave(current_user, params[:reply_post], @fam_users,'reply',fwd_files=[],false,@get_current_url,'fam_network')
			@message_threads = MessageThread.find_by_sql("select mt.* from message_threads as mt left join message_thread_viewers as mv on mt.thread_id=mv.message_thread_id where(mt.message_id=#{@message.message_id} and ((mt.posted_by=#{current_user.user_id} and mt.msg_flag=true) or mv.user_id=#{current_user.user_id})) order by mt.posted_on asc").uniq
			render :partial=>'/fam_networks/fam_network_thread_details',:locals => {:message_threads => @message_threads,:fam_network => @message, :curr_user => current_user}
			dir = "#{Rails.root}/public/temp_message_upload/#{current_user.user_id}"
			FileUtils.remove_dir(dir, force = true) if dir && !dir.nil? && File.exists?(dir)
			#~ MessageThread.send_notification_network(@fam_users_ids,current_user,thrd)
      else
			  render :text=>false
      end
	  else
      render :text=>false
	  end
  end
  
  
  #Delete Post in Fam network page
  def delete_fam_post
    if params[:thrd_id] && params[:thrd_id].present? && !params[:thrd_id].nil?
      result = MessageThread.deleteMsgThrd(params[:thrd_id],current_user)
      @message = Message.find(result[0])
      @last_msg = result[1]
      @message_threads  = MessageThread.find_by_sql("select mt.* from message_threads as mt left join message_thread_viewers as mv on mt.thread_id=mv.message_thread_id where(mt.message_id=#{result[0]} and ((mt.posted_by=#{current_user.user_id} and mt.msg_flag=true) or mv.user_id=#{current_user.user_id})) order by mt.posted_on asc").uniq if result && result[0] && result[0].present? && !result[0].nil?
      #~ render :text => true
      #~ render :partial=>'/fam_networks/fam_network_thread_details',:locals => {:message_threads => @message_threads,:fam_network => @message, :curr_user => current_user}
    end
  end
  

  def download_network_post_files
    fam_network = FamPost.where("fam_post_id='#{params[:id]}'").last
    if params[:mode]=="I"
      fam_image = fam_network.fam_network_posts.where("fam_network_posts.fam_file_type='I'")
    elsif params[:mode] == "D"
      fam_image = fam_network.fam_network_posts.where("fam_network_posts.fam_file_type='D'")
    end
    dir_name = "#{Rails.root}/public/system/network_zip"
    unless File.directory?(dir_name)
      Dir.mkdir "#{Rails.root}/public/system/network_zip"
    end
    path = "#{Rails.root}/public/system/network_zip/network_files_#{current_user.user_id}.zip"
    File.delete(path) if File.file?(path)
    Zip::ZipFile.open(path, Zip::ZipFile::CREATE) { |zipfile|
      fam_image.each do |attachment|
        zipfile.add( attachment.fam_net_post_file_name, attachment.fam_net_post.path)
      end
    }
    if fam_image && fam_image.present? && File.exists?(path)
      send_file path, :type => 'application/zip', :disposition => 'attachment', :filename => "network_files_#{current_user.user_id}.zip"
    else
      redirect_to "/"
    end
  
  end

  def add_to_temp_fampost
    FileUtils.mkdir("#{Rails.root}/public/temp_post_upload", :mode => 0770) if !File.exists?("#{Rails.root}/public/temp_post_upload")
    if params[:fam_file_type] == "I"
      orig_dir = FileUtils.mkdir("#{Rails.root}/public/temp_post_upload/Images", :mode => 0770) if !File.exists?("#{Rails.root}/public/temp_post_upload/Images")
      dir = "#{Rails.root}/public/temp_post_upload/Images/#{current_user.user_id}"
    elsif params[:fam_file_type] == "D"
      orig_dir = FileUtils.mkdir("#{Rails.root}/public/temp_post_upload/Document", :mode => 0770) if !File.exists?("#{Rails.root}/public/temp_post_upload/Document")
      dir = "#{Rails.root}/public/temp_post_upload/Document/#{current_user.user_id}"
    end
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
  


  # GET /fam_network_posts/1
  # GET /fam_network_posts/1.json
  def show
    @fam_network_post = FamNetworkPost.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fam_network_post }
    end
  end

  # GET /fam_network_posts/new
  # GET /fam_network_posts/new.json
  def new
    @fam_network_post = FamNetworkPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fam_network_post }
    end
  end

  # GET /fam_network_posts/1/edit
  def edit
    @fam_network_post = FamNetworkPost.find(params[:id])
  end

  # POST /fam_network_posts
  # POST /fam_network_posts.json
  def create
    @fam_network_post = FamNetworkPost.new(params[:fam_network_post])

    respond_to do |format|
      if @fam_network_post.save
        format.html { redirect_to @fam_network_post, notice: 'Fam network post was successfully created.' }
        format.json { render json: @fam_network_post, status: :created, location: @fam_network_post }
      else
        format.html { render action: "new" }
        format.json { render json: @fam_network_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fam_network_posts/1
  # PUT /fam_network_posts/1.json
  def update
    @fam_network_post = FamNetworkPost.find(params[:id])

    respond_to do |format|
      if @fam_network_post.update_attributes(params[:fam_network_post])
        format.html { redirect_to @fam_network_post, notice: 'Fam network post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fam_network_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fam_network_posts/1
  # DELETE /fam_network_posts/1.json
  def destroy
    @fam_network_post = FamNetworkPost.find(params[:id])
    @fam_network_post.destroy

    respond_to do |format|
      format.html { redirect_to fam_network_posts_url }
      format.json { head :no_content }
    end
  end
  
  

end
