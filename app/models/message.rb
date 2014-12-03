class Message < ActiveRecord::Base
  require 'send_sms'
  has_many :message_threads

  has_attached_file :message_card, :styles => { :thumb=>"190x190>", :small => "82x100>", :medium => "190x324>" }, :default_url => "/assets/default/message_card_default.png",
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"

  #To save message_thread, message_viewers, message_files from message controller
  def msgFileSave(cur_user,cmt,to_users,rep_mode,fwd_files,show_msg_card,url,type)
    @to=to_users.collect{|x| x.strip}
    @to_users= @to.uniq if !@to.nil?
    if @to_users && @to_users.present?
      @msg_thread = self.message_threads.new
      @msg_thread.content =  cmt
      @msg_thread.posted_by =  cur_user.user_id
      @msg_thread.posted_email =  cur_user.email_address
      @msg_thread.receivers_email = @to_users.join(',')
      @msg_thread.reply_mode = rep_mode
      @msg_thread.posted_on = Time.now
      @msg_thread.created_at = Time.now
      @msg_thread.modified_date = Time.now
      @msg_thread.show_card = true if show_msg_card && !show_msg_card.nil? && show_msg_card=='1'
      @msg_thread.save
    
      @to_users && @to_users.each do |u|
        if u.present? && !u.nil? && u!=''
          user = User.where('email_address=?',u).last
          @thrd_viewer = MessageThreadViewer.new
          @thrd_viewer.message_thread_id = @msg_thread.thread_id
          @thrd_viewer.user_email = u
          @thrd_viewer.user_id = user.user_id if !user.nil? && user.present?
          @thrd_viewer.sent_type = 'to'
          @thrd_viewer.created_at = Time.now
          @thrd_viewer.updated_at = Time.now
          @thrd_viewer.save
        end
      end
      @files = Dir.glob("#{Rails.root}/public/temp_message_upload/#{cur_user.user_id}/*")
      if rep_mode && rep_mode=='forward' && fwd_files && fwd_files.present? && !fwd_files.nil?
        fwd_files.each do |old_f|
          @files << old_f if old_f && !old_f.nil? && old_f.present?
        end
      end
      Message.msgAttachmentsSave(@files,@msg_thread.thread_id,type,nil) #MessageFiles save
   
    @to_users && @to_users.each do |to_user|
      to_user=to_user.gsub(/ /, '')
      usr=User.where("email_address=?",to_user).last
      if type=="fam_network"
       @fam_netwrok_group = ContactGroup.where("group_id=#{self.contact_group_id}").last
       @contact_user=ContactUser.where("contact_email=? and user_id=?",to_user,@fam_netwrok_group.user_id).last if !@fam_netwrok_group.nil? && @fam_netwrok_group.present?
       creater=User.where("user_id=?",@fam_netwrok_group.user_id).last if !@fam_netwrok_group.nil? && @fam_netwrok_group.present?
       @owner=ContactGroup.where("group_id=#{self.contact_group_id} and user_id=#{usr.user_id}").last if !usr.nil? && usr.present?
      end
          if (("#{cur_user.email_address}" != "#{to_user}")&&(to_user!="")&&(type=="fam_network"))
            if !@contact_user
              if !creater.nil? && creater.present? && !creater.email_address.nil? && creater.email_address !=to_user
              contactSave(to_user,cur_user)
              contactGroupSave(self.contact_group_id,cur_user,@contact_user.contact_id)
              end
            else
              @group_user= ContactUserGroup.where("contact_user_id=? and contact_group_id=?",@contact_user.contact_id,self.contact_group_id).last
              if !@group_user
              contactGroupSave(self.contact_group_id,cur_user,@contact_user.contact_id)
              end
           end
         end
        if type=="fam_network" && usr.nil? && !usr.present?
          if (("#{cur_user.email_address}" != "#{to_user}")&&(to_user!=""))
             if !@contact_user
                contactSave(to_user,cur_user)
              end
                  #non_member
                  MessageMailer.delay(queue: "Send message", priority: 2, run_at: 10.seconds.from_now).send_message_to_famnetwork(to_user,self,cur_user,url,@group_user.contact_user_id,@group_user.contact_group_id,@contact_user)
              end
        elsif type=="fam_network"
                 if (("#{cur_user.email_address}" != "#{to_user}")&&(to_user!=""))
                    user = User.where("email_address=?",to_user).last
                    user_prof = user.user_profile if user && user.present? && !user.nil?
                    result  = ParentNotificationDetail.find_by_sql("select p.* from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id  where pn.notify_action='4' and lower(pn.notify_status)='active'and p.user_id=#{user.user_id}") if user && user.present?
                      if @msg_thread && @msg_thread.content       
                              if !result.present?
                                @fam_friend=ContactUserGroup.where("contact_group_id ='#{self.contact_group_id}'and contact_user_id='#{@group_user.contact_user_id}'and fam_accept_status=true").last if !@group_user.nil? && !@group_user.contact_user_id.nil?
                                if !@owner.nil? && @owner.present?
                                  FamtivityNetworkMailer.delay(queue: "Send message", priority: 2, run_at: 10.seconds.from_now).fam_create_network_mail(to_user,@fam_netwrok_group,url,cur_user,@msg_thread.content,self) 
                                elsif !@fam_friend.nil? && @fam_friend.present?
                                   FamtivityNetworkMailer.delay(queue: "Send message", priority: 2, run_at: 10.seconds.from_now).fam_create_network_mail(to_user,@fam_netwrok_group,url,cur_user,@msg_thread.content,self) 
                                else
                                  FamtivityNetworkMailer.delay(queue: "Fam Network Friend", priority: 2, run_at: 10.seconds.from_now).network_friend_invite_mail(cur_user,@fam_netwrok_group,to_user,url,user,@contact_user.contact_id,@msg_thread.content)
                                end
                              elsif (result && result.present? && result.last.notify_flag?) 
                                @fam_friend=ContactUserGroup.where("contact_group_id ='#{self.contact_group_id}'and contact_user_id='#{@group_user.contact_user_id}'and fam_accept_status=true").last if !@group_user.nil? && !@group_user.contact_user_id.nil?
                                if !@owner.nil? && @owner.present?
                                  FamtivityNetworkMailer.delay(queue: "Send message", priority: 2, run_at: 10.seconds.from_now).fam_create_network_mail(to_user,@fam_netwrok_group,url,cur_user,@msg_thread.content,self) 
                                elsif !@fam_friend.nil? && @fam_friend.present?
                                   FamtivityNetworkMailer.delay(queue: "Send message", priority: 2, run_at: 10.seconds.from_now).fam_create_network_mail(to_user,@fam_netwrok_group,url,cur_user,@msg_thread.content,self) 
                                else
                                  FamtivityNetworkMailer.delay(queue: "Fam Network Friend", priority: 2, run_at: 10.seconds.from_now).network_friend_invite_mail(cur_user,@fam_netwrok_group,to_user,url,user,@contact_user.contact_id,@msg_thread.content)
                                end         
                              end
                      end   
                    to_snd_sms  = ParentNotificationDetail.find_by_sql("select p.* from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id  where pn.notify_action='4' and lower(pn.notify_status)='active'and p.user_id=#{user.user_id}") if user && user.present?
                    #To send sms
                    SendSMS.send_sms_to_users(user,cur_user,to_snd_sms.last.parent_notify_id,'parent',@msg_thread,url) if to_snd_sms && to_snd_sms.present? && to_snd_sms.last.notify_by_sms && user && user_prof && user_prof.sms_mobile_num && user_prof.sms_mobile_num.present?
                end
        else
          MessageMailer.delay(queue: "Send message", priority: 2, run_at: 10.seconds.from_now).send_message_to_viewers(to_user,self,cur_user,url)
        end
  end
    @msg_thread
    end
  end

  def contactSave(to_user,cur_user)
    user=User.where("email_address=?",to_user).last
    if to_user !=cur_user.email_address
      name = to_user.split("@")
      @contact_user=ContactUser.new
      @contact_user.contact_name = name[0] if !name.nil?
      @contact_user.contact_email = to_user
      @contact_user.user_id = cur_user.user_id if cur_user
      @contact_user.inserted_date = Time.now
      @contact_user.modified_date = Time.now
      @contact_user.contact_type = 'famtivity'
      if !user.nil? && user.present?
        @contact_user.contact_user_type="member"
      else
        @contact_user.contact_user_type="non_member"
      end
      @contact_user.save 
      return @contact_user
    end
  end
  def contactGroupSave(contact_group_id,cur_user,contact_id)
    if !contact_group_id.nil? && contact_group_id.present?
      @group_user = ContactUserGroup.new
      @group_user.user_id = cur_user.user_id if cur_user
      @group_user.contact_user_id = contact_id 
      @group_user.contact_group_id = contact_group_id
      @group_user.inserted_date = Time.now
      @group_user.modified_date = Time.now
      @group_user.save
      return @group_user
    end
  end

  #To save message
  def messageSave(sub,mode,card_file,type,fam_group_id)
    message = self
    message.subject = sub
    message.status = 'sent'
    message.user_mode =mode
    message.message_type = type
    message.message_card = card_file
    message.contact_group_id = fam_group_id
    message.created_at = Time.now
    message.updated_at = Time.now
    message.save
    message
  end

  #To save message file
  def self.msgAttachmentsSave(all_files,thrd_id,type,img_type)
    all_files && all_files.each do |fil|
      #~ file_name =  File.basename(fil)
      msg_files = MessageFile.new
      msg_files.message_thread_id = thrd_id
      file = File.open(fil)
      msg_files.message_file=file
      msg_files.file_type = img_type
      msg_files.created_at = Time.now
      msg_files.updated_at = Time.now
      msg_files.save
      #~ if msg_files.save
      #~ if type=='message'
      #~ orig_dir = Dir.mkdir("#{Rails.root}/public/system/message_files") if !File.exists?("#{Rails.root}/public/system/message_files")
            #~ cp_dir = "#{Rails.root}/public/system/message_files/#{thrd_id}"
            #~ Dir.mkdir(cp_dir) if !File.exists?(cp_dir)
            #~ FileUtils.cp(fil, cp_dir)
            #~ end
            #~ end
          end
        end

      end