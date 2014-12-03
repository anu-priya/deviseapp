require 'open-uri'
class UserMailer < ActionMailer::Base
	helper ApplicationHelper
	helper ActivityDetailHelper
	helper FormsHelper
	helper LandingHelper
  require 'base64'
  layout 'email'
  $dollar="25.00"
  #~ default "from" => "support@famtivity.com" #live use this
  #$proleads_email='eileen@famtivity.com,support@famtivity.com,admin@famtivity.com'  #live use this
  $activity_image = "" #if we use s3 empty this path
  #$famadmin_email='eileen@famtivity.com,support@famtivity.com,sofia@i-waves.com'  #famtivity.com
  #~ $admin_user_deleted='support@famtivity.com,eileen@famtivity.com,heidi@famtivity.com'  #account deletion
  #$school_admin ='support@famtivity.com,kristen@famtivity.com,eileen@famtivity.com,heidi@famtivity.com' #Notification to School Program Registration and User Account Deletion
   #$activation_cc ='eileen@famtivity.com' #partner activation link to eileen also
  #$admin_bcc='support@famtivity.com,admin@famtivity.com'  #live bcc mail to admin 
  $proleads_email="urajkumar@i-waves.com,rrajasekar@i-waves.com,sithankumar@i-waves.com,ambika@i-waves.com"  #if live uncomment this
  default "from" => "no-reply@famtivity.com" #for sendgrid default message
  $image_global_path = 'http://dev.famtivity.com:8080/'
  $image_global_path_wap='http://dev.famtivity.com:3004/' 
  $famadmin_email='ambika@i-waves.com,urajkumar@i-waves.com,sathishkumarm@i-waves.com,maheswaran@i-waves.com' #local  
  $admin_user_deleted='ambika@i-waves.com,urajkumar@i-waves.com,sathishkumarm@i-waves.com,maheswaran@i-waves.com' #local 
  $school_admin = 'sithankumar@i-waves.com'
  $admin_bcc='sithankumar@i-waves.com'
  $tbl_image_path = "/var/www/famtivity_addplus/public"  
  $activation_cc = 'ambika@i-waves.com'
  #send a mail to support team about the provider account active status
  def provider_account_details(user_list)
    headers['X-No-Spam'] = 'True'
    @users_list = user_list
    mail(:to => "sathishkumarm@i-waves.com,urajkumar@i-waves.com,ambika@i-waves.com", :subject => "Famtivity | Provider's account activates list")
  end
  
  #auto renewal process to famtivity
  def autorenewal_report_to_famtivity(rusers,gusers)
    headers['X-No-Spam'] = 'True'
    @users_list = rusers #renewal users list
    @grace_users_list = gusers #grace period users list
    mail(:to => "urajkumar@i-waves.com,ambika@i-waves.com", :subject => "Auto-renewal process user's reports to support team")
  end

  #sent a mail to deleted user after delete the account
  def hello_world(to)
    headers['X-No-Spam'] = 'True'
    mail(:to => to, :bcc=>"urajkumar@i-waves.com", :from=>"sithankumar@i-waves.com", :subject => "Respond Email Test | Famtivity")
  end  
  #sent a mail to deleted user after delete the account
  def user_account_deleted(user)
    headers['X-No-Spam'] = 'True'
    @user = user
    mail(:to => @user.email_address, :subject => "Account Deletion Notification")
  end  
  
  #sent a mail to deleted user after delete the account
  def school_register_toadmin(user,urls)
    headers['X-No-Spam'] = 'True'
    @user = user
    @url = "http://#{urls}/user_activate?email=#{user.email_address}"
    mail(:to => "#{$school_admin}", :subject => "School registration")
  end  
  
  #sent a mail to register user
  def school_register_to_provider(user)
    headers['X-No-Spam'] = 'True'
    @user = user
    mail(:to => user.email_address, :subject => "School registration")
  end  
  
  #sent a mail to deleted user after delete the account
  def user_account_deleted_admin(user)
    headers['X-No-Spam'] = 'True'
    @user = user
    mail(:to => "#{$admin_user_deleted}", :subject => "Account Deletion Notification")
  end  
  
  #sent a mail to deleted user after delete the account
  def user_account_deactivated(user)
    headers['X-No-Spam'] = 'True'
    @user = user
    mail(:to => @user.email_address, :subject => "Account Deactivate Notification")
  end 
  
  #sent a mail to register user after transaction
  def autorenewal_success_to_famtivity(user,uamt)
    headers['X-No-Spam'] = 'True'
    @user = user
    @uamount = uamt
    mail(:to => "#{$famadmin_email}", :subject => "Auto-Renewal Payment Confirmation!")
  end 
  
  #sent a mail to register user after transaction
  def autorenewal_failure_to_famtivity(user,uamt,fmsg)
    headers['X-No-Spam'] = 'True'
    @user = user
    @uamount = uamt
    @failure_msg = fmsg
    mail(:to => "#{$famadmin_email}", :subject => "Auto-Renewal Failure Notification")
  end 
  
  #sent a mail to register user after transaction
  def autorenewal_success_to_provider(user,uamt)
    headers['X-No-Spam'] = 'True'
    @user = user
    @uamount = uamt
    if !@user.nil? && @user!='' && @user.user_flag==TRUE #send a mail to provider
      mail(:to => @user.email_address, :subject => "Auto-Renewal Payment Confirmation!")
    else #send a mail to admin 
      mail(:to => "#{$famadmin_email}", :subject => "Auto-Renewal Payment Confirmation!")
    end
  end 
  
  #sent a mail to register user after transaction
  def autorenewal_failure_to_provider(user,uamt,fmsg)
    headers['X-No-Spam'] = 'True'
    @user = user
    @uamount = uamt
    @failure_msg = fmsg
    if !@user.nil? && @user!='' && @user.user_flag==TRUE #send a mail to provider
      mail(:to => @user.email_address, :subject => "Auto-Renewal Failure Notification")
    else #send a mail to admin 
      mail(:to => "#{$famadmin_email}", :subject => "Auto-Renewal Failure Notification")
    end
  end 
  
  #sent a mail to register user after 30 days over for renewal
  def provider_renewal_alert(user)
    headers['X-No-Spam'] = 'True'
    @user = user
    if !@user.nil? && @user!='' && @user.user_flag==TRUE #send a mail to provider
      mail(:to => @user.email_address, :subject => "Famtivity | Notification to provider about plan Extension!")
    else #send a mail to admin 
      mail(:to => "#{$famadmin_email}", :subject => "Famtivity | Notification to provider about plan Extension!")
    end
  end
  
  #sent a mail to register user after 30 days over for renewal
  def provider_saleslimit_alert(user)
    headers['X-No-Spam'] = 'True'
    @user = user
    if !@user.nil? && @user!='' && @user.user_flag==TRUE #send a mail to provider
      mail(:to => @user.email_address, :subject => "Famtivity | Notification to provider about sale limit!")
    else #send a mail to admin 
      mail(:to => "#{$famadmin_email}", :subject => "Famtivity | Notification to provider about sale limit!")
    end
  end
  
  def register_user(user,urlr,flag)
    headers['X-No-Spam'] = 'True'
    @user = user
    @image_url = urlr
    @url = (flag==true) ? "http://#{urlr}/user_activate?email=#{user.email_address}&curated_flag=true"  : "http://#{urlr}/user_activate?email=#{user.email_address}"
    if user.is_partner == true
	mail(:to => user.email_address, :bcc => "#{$activation_cc},sithankumar@i-waves.com,durgadevi@i-waves.com", :subject => "Activate Your Famtivity Account!")
    else
	mail(:to => user.email_address, :subject => "Activate Your Famtivity Account!")
    end
  end
  
  def resend_activation(user)
    headers['X-No-Spam'] = 'True'
    @user = user
    @url ="#{$image_global_path}user_activate?email=#{user.email_address}"
    mail(:to => 'ambika@i-waves.com', :subject => "Activate Your Famtivity Account!")
  end
  
  
  #sent a mail to register user after transaction
  def register_user_transaction(user,uamt)
    headers['X-No-Spam'] = 'True'
    @user = user
    @uamount = uamt
    if !@user.nil? && @user!='' && @user.user_flag==TRUE #send a mail to provider
      mail(:to => @user.email_address, :subject => "Payment Confirmation!")
    else #send a mail to admin 
      mail(:to => "#{$famadmin_email}", :subject => "Payment Confirmation!")
    end
  end
  #if curator register as provider send mail to Elieen
  def curator_msg_admin(user,urlr)
    headers['X-No-Spam'] = 'True'
    @user = user
    @image_url = urlr    
    @url = "http://#{urlr}/user_activate?email=#{user.email_address}&curated_flag=true"
    mail(:to =>"#{$famadmin_email}", :subject => "Curator Provider Register in Famtivity") 
  end
  def curated_user_activities(user,urlr)
    @user = user
    @image_url = "http://#{urlr}"
    mail(:to => user.email_address, :subject => "Welcome to Famtivity!")
  end
  
  #curator activation mail to famtivity team
  def curator_actinfo_tofam(user,urlr)
    @user = user
    @image_url = "http://#{urlr}"
    mail(:to => "#{$proleads_email}", :subject => "Famtivity | Curator Provider #{@user.user_name.titlecase} has taken ownership")
  end

  def parent_register_user_pass(user,urlr)
    @user = user
    @image_url = urlr
    @url = "http://#{urlr}/user_activate?email=#{user.email_address}"
    mail(:to => user.email_address, :subject => "Welcome to Famtivity!")
  end
  
  def parent_register_user(user,urlr)
    @user = user
    @image_url = "http://#{urlr}"
    @url = "http://#{urlr}/user_activate?email=#{user.email_address}"
    before_check = Activity.find_by_sql("select distinct act.* from activities act left join activity_prices p on act.activity_id=p.activity_id left join activity_discount_prices d on d.activity_price_id=p.activity_price_id where cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and ((act.price_type='1') or (act.price_type='2')) and(lower(d.discount_type)='early bird discount' and date(d.discount_valid) >= '#{Time.now.strftime("%Y-%m-%d")}') or (lower(d.discount_type)!='early bird discount' and lower(act.active_status)='active') order by act.activity_id desc")
    
    act_free = Activity.get_upcoming_activities(before_check)
    #p act_free
    #@sell_pro_mail =Activity.find_by_sql("select act.* from activities act left join users u on act.user_id=u.user_id where lower(u.user_plan)='sell' and lower(active_status)='active' and cleaned=true and lower(created_by)='provider' order by activity_id desc")
    @spmail = act_free.sample(3)
    mail(:to => user.email_address, :subject => "Activate Your Famtivity Account!")
  end
  
  def parent_user_resend_activation(user,urlr)
    @user = user
    @image_url = urlr
    @url = "http://#{urlr}/user_activate?email=#{user.email_address}"
    # @sell_pro_mail =Activity.find_by_sql("select act.* from activities act left join users u on act.user_id=u.user_id where lower(u.user_plan)='sell' and lower(active_status)='active' and cleaned=true and lower(created_by)='provider' order by activity_id desc")
    #@spmail = @sell_pro_mail.sample(3)
    before_check = Activity.find_by_sql("select distinct act.* from activities act left join activity_prices p on act.activity_id=p.activity_id left join activity_discount_prices d on d.activity_price_id=p.activity_price_id where cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and ((act.price_type='1') or (act.price_type='2')) and(lower(d.discount_type)='early bird discount' and date(d.discount_valid) >= '#{Time.now.strftime("%Y-%m-%d")}') or (lower(d.discount_type)!='early bird discount' and lower(act.active_status)='active') order by act.activity_id desc")
    act_free = Activity.get_upcoming_activities(before_check)
    @spmail = act_free.sample(3)
    mail(:to => user.email_address, :subject => "Activate Your Famtivity Account!")
  end

  def change_email_address(user,urlr,utype)
    @utype=utype
    @user = user
    @image_url = urlr
    user_id   = Base64.encode64("#{user.user_id}")
    @en_utype = Base64.encode64("#{utype}")
    @url = "http://#{urlr}/email_activate?uid=#{user_id}&utype=#{@en_utype}"
    mail(:to => user.new_email_address, :subject => "Change Email Address!")
  end

  def change_email_success(user,urlr,oldemail,utype)
    @utype=utype
    @oldemail=oldemail
    @user = user
    @image_url = urlr
    #~ mail(:to => user.email_address, :subject => "Change Email Success!") # flow changes by rajkumar
    mail(:to => "#{oldemail},#{@user.email_address}", :subject => "Change Email Success!")
  end

  def famtivity_welcome(user,urlr,amt)
    @user = user
    @image_url = "http://#{urlr}"
    @amt = amt
    @url = "http://#{urlr}/user_activate?email=#{user.email_address}"
    #@sell_pro_mail =Activity.find_by_sql("select act.* from activities act left join activity_prices p on act.activity_id=p.activity_id left join activity_discount_prices d on d.activity_price_id=p.activity_price_id left join activity_schedules act_sch on act.activity_id=act_sch.activity_id left join users u on act.user_id=u.user_id where act_sch.expiration_date >= '#{Date.today}' and lower(u.user_plan)='sell' and lower(active_status)='active' and cleaned=true and lower(created_by)='provider' and (((act.price_type='1' or act.price_type='2')and(lower(d.discount_type)='early bird discount')) or (act.discount_eligible IS NOT NULL)) order by activity_id desc")
    @sell_pro_mail =Activity.find_by_sql("select act.* from activities act left join activity_prices p on act.activity_id=p.activity_id left join activity_discount_prices d on d.activity_price_id=p.activity_price_id left join activity_schedules act_sch on act.activity_id=act_sch.activity_id left join users u on act.user_id=u.user_id where act_sch.expiration_date >= '#{Date.today}' and lower(u.user_plan)='sell' and lower(active_status)='active' and cleaned=true and lower(created_by)='provider' and (act.price_type='1' or act.price_type='2') and (((lower(d.discount_type)='early bird discount')) or (act.discount_eligible IS NOT NULL)) order by activity_id desc")
    @spmail = @sell_pro_mail.sample(3)
    mail(:to => user.email_address, :subject => "Welcome to Famtivity!")
  end


  def contact_us(email,name,urlr,phone,msg,user_type)
    headers['X-No-Spam'] = 'True'
    @user = email
    @image_url = urlr
    @user_type = user_type
    @msg=msg
    @name=name
    @phone=phone
    mail(:to => 'support@famtivity.com', :subject => "Famtivity | Contact us", :from => email)
  end

  def beta_feedback(subject,msg,name,email,urlr)
    headers['X-No-Spam'] = 'True'
    @name = name
    @email = email
    @image_url = urlr
    @msg=msg
    mail(:to => 'support@famtivity.com', :subject => "#{subject}", :from => email)
  end

  def beta_feedback_image(subject,msg,name,email,urlr,image_url)
    headers['X-No-Spam'] = 'True'
    @name = name
    @email = email
    @image_url = urlr
    attachments['image.png'] = image_url
    @msg=msg
    mail(:to => 'support@famtivity.com', :subject => "#{subject}", :from => email)
  end

  def admin_user_mail(activity,email_id,url,message)
    headers['X-No-Spam'] = 'True'
    @activity = activity
    @msg = message
    @image_url = url
    mail(:to => email_id, :bcc=>$admin_bcc, :subject => "Famtivity Admin - Raised Flag for an Activity")
  end

  def share_activity_mail(user,activity,urls,msg,to,subject,mode)
    headers['X-No-Spam'] = 'True'
    @user = user
    @user_mode = mode
    @activity = activity
    @act_user = User.find_by_user_id(activity.user_id)
    @msg = msg
    @to=to
    # @image_url = urls
    @image_url = "http://#{urls}"
    mail(:to => to, :from=>@user.email_address, :subject => subject)
  end
  
  #get info template
  def get_information_mail(user,activity,activity_user,urls,msg,to,subject)
    headers['X-No-Spam'] = 'True'
    @user = user
    @activity = activity
    @activity_user = activity_user
    @msg = msg
    @image_url = urls
    mail(:to => to, :from=>@user.email_address, :subject => subject)
  end
  
  #sending a mail to the free activity creater for free activity (provider or parent) 
  def provider_attend_activity_free(user,activity_user,to,activity,urls)
    headers['X-No-Spam'] = 'True'
    @user_name = (user.class.to_s=='User') ? user.user_name : user.guest_name
    @activity_user = activity_user
    @activity = activity
    @image_url = urls
    enc_uid   = Base64.encode64("#{@activity_user.user_id}")
    enc_aid   = Base64.encode64("#{@activity.activity_id}")
    enc_a_name   = Base64.encode64("#{@activity.activity_name}")
    @attendies_url = "http://#{urls}/attendies?uid=#{enc_uid}&aid=#{enc_aid}&aname=#{enc_a_name}"
    mail(:to => to, :subject => "#{@user_name.capitalize} Is Attending #{@activity.activity_name}")
  end
  
  #sending a mail to the activity creater for sell through user
  def provider_attend_activity_sell(user,activity_user,to,activity,urls,tick_number)
    headers['X-No-Spam'] = 'True'
    @user = user
    @u_type = user.class.to_s
    @user_name = ((@u_type=='User') ? user.user_name : user.guest_name)
    @u_id = ((@u_type=='User') ? user.user_id : user.guest_id)
    @email = ((@u_type=='User') ? user.email_address : user.guest_email)
    @activity_user = activity_user
    @activity = activity
    @image_url = urls
    @tick_number = tick_number
    enc_uid   = Base64.encode64("#{@u_id}")
    enc_aid   = Base64.encode64("#{@activity.activity_id}")
    enc_a_name   = Base64.encode64("#{@activity.activity_name}")
    enc_a_email   = Base64.encode64("#{@email}")
    @attendies_url = "http://#{urls}/attendies?uid=#{enc_uid}&aid=#{enc_aid}&aname=#{enc_a_name}&act_type=attendies"
    mail(:to => to, :subject => "#{@user_name.capitalize} Is Attending #{@activity.activity_name}")
  end
  
  #contact provider template
  def provider_contact_price(user,activity,activity_user,urls,msg,to)
    headers['X-No-Spam'] = 'True'
    @user = user
    @activity = activity
    @activity_user = activity_user
    @msg = msg
    @image_url = urls
    mail(:to => to, :from=>@user.email_address, :subject => "Request for activity price details")
  end

  #issue report about the page
  def page_issue_report(host,u_agent,path,info,to)
    headers['X-No-Spam'] = 'True'
    @host = host
    @u_agent = u_agent
    @path = path
    @info = info
    mail(:to => to, :subject =>"Error Information details")
  end

  def send_password(username_usr,email_usr,password_usr,url)
    headers['X-No-Spam'] = 'True'
    @username_usr = username_usr
    @email_usr = email_usr
    @password_usr = password_usr
    @image_url = url
    @body = '<p>Hi '+ "#{@username_usr}" +',<br/><br/>Your password is <strong>'+ Base64.decode64("#{@password_usr}") +'</strong><br/><br/>Thanks</p>'

    mail(:to => email_usr, :subject => "Your Famtivity Password")

  end
  
  def delete_activity_mail(user,activity,urls,to)
    headers['X-No-Spam'] = 'True'
    @user = user
    @activity = activity
    @image_url = "http://#{urls}"   
    mail(:to => to, :subject => "#{@activity.activity_name} Deleted Successfully")
  end

  def delete_activity_schedule_mail(user,activity,delete_schedule,urls,to)
    headers['X-No-Spam'] = 'True'
    @delete_schedule=delete_schedule
    @user = user
    @activity = activity
    @image_url = "http://#{urls}"   
    mail(:to => to, :subject => "#{@activity.activity_name} Deleted Successfully")
  end
  
  #send a mail while activity status changed
  def activity_status_mail(user,activity,urls,msg,to,subject)
    headers['X-No-Spam'] = 'True'
    @user = user
    @activity = activity
    @msg = msg
    @image_url = urls
    mail(:to => to, :subject => subject)
  end
  
  #send a mail while changed the password
  def change_password_mail(user,urls,msg,to,subject)
    headers['X-No-Spam'] = 'True'
    @user = user
    @msg = msg
    @image_url = urls
    mail(:to => to, :subject => "Change password details")
  end
  
  #send a mail while changed the password
  def curator_upgrade_info(user)
    headers['X-No-Spam'] = 'True'
    @user = user
    mail(:to => "#{$famadmin_email}", :subject => "Curator upgrade information")
  end
  
  
  #send a mail while changed the password
  def transaction_fail_mail(user,urls,msg,to,subject)
    headers['X-No-Spam'] = 'True'
    @user = user
    @msg = msg
    @image_url = urls
    mail(:to => to, :subject => "Transaction Fail!")
  end
  
  
  #send a mail while changed the password
  def someone_followme(user,f_user,to,urls)
    headers['X-No-Spam'] = 'True'
    @user = user
    @f_user = f_user
    @image_url = urls
    mail(:to => to, :subject => "#{@user.user_name.capitalize} is now following you!")
  end
  
  #send a mail while changed the password
  def following_user_mail(user,current_user,activity,urls,msg,to,subject)
    headers['X-No-Spam'] = 'True'
    @user = user
    @activity=activity
    @c_user=current_user
    @msg = msg
    @image_url = "http://#{urls}"
    mail(:to => to, :subject => "#{@c_user.user_name.titlecase} just added a Famtivity Activity")
  end

  def following_user_mail_provider(to,name,current_user,activity,urls,msg,subject)
    headers['X-No-Spam'] = 'True'
    @name = name
    @activity=activity
    @c_user=current_user
    @msg = msg
    @image_url = "http://#{urls}"
    mail(:to => to, :subject => "#{@c_user.user_name.titlecase} just added a Famtivity Activity")
  end

  #send a mail while changed the password
  def following_user_create_mail(user,current_user,activity,urls,msg,to,subject)
    headers['X-No-Spam'] = 'True'
    @user = user
    @activity=activity
    @c_user=current_user
    @msg = msg
    @image_url = urls
    mail(:to => to, :subject => "#{@c_user.user_name.titlecase} just added a Famtivity Activity")
  end
  
  #send a mail while cancel the schedule
  def cancel_activity_mail_to_provider(name,user_name,activity,urls,msg,to,subject)
    headers['X-No-Spam'] = 'True'
    @name=name
    @user = user_name
    @activity = activity
    @msg = msg
    @image_url = urls
    mail(:to => to, :subject => "Famtivity - Delete Activity")
  end

  #send a mail while cancel the schedule
  def cancel_activity_mail_to_parent(name,activity,urls,to,activity_user)
    headers['X-No-Spam'] = 'True'
    @name=name
    @activity = activity
    @activity_user = activity_user
    @image_url ="http://#{urls}"
    mail(:to => to, :subject => "#{@activity.activity_name} Details Have Changed")
  end

  #support user mail
  def support_user_mail(user,to,urls,subject)
    headers['X-No-Spam'] = 'True'
    @user=user
    @image_url = urls
    mail(:to => to, :subject => "Support form to User")
  end
  
  #if user not logged? in to send mail to them.
  def support_nouser_mail(to,urls,subject)
    headers['X-No-Spam'] = 'True'
    @image_url = urls
    mail(:to => to, :subject => "Support form to Non User")
  end
  
  #sending a mail to the support team.
  def support_team_mail(image,to,email,label,message,urls,subject,support_type)
    headers['X-No-Spam'] = 'True'
    if urls.present? && image.present?  && image!=''
      @url = "http://#{urls}/#{image}"
    else
      @url=''
    end
    @image=image
    @email=email
    @label=label
    @message=message
    @image_url = urls
    @s_type=support_type
    mail(:to => to, :subject => "Support mail from User")
  end
  
  
  #def edit_activity_mail(user,activity,urls,msg,to,subject)
  # headers['X-No-Spam'] = 'True'
  #~ @new_activity = activity_old
  # @user=user
  # @activity = activity
  # @msg = msg
  #@image_url = "http://#{urls}"
  # mail(:to => to, :subject => "Your Updated Activity Details - #{@activity.activity_name}")
  # end
  
  #send a mail while editing the activity by the provider
  def edit_activity_provider_mail(user,activity,urls,to,plan)
    headers['X-No-Spam'] = 'True'
    #~ @new_activity = activity_old
    @user=user
    @plan =  plan
    @activity = activity
    @image_url = "http://#{urls}"
    mail(:to => to, :subject => "#{@activity.activity_name} has been edited")
  end
  
  #send mail to attendies for provider activity edit
  def edit_provider_participant_mail(user,activity,urls,to)
    headers['X-No-Spam'] = 'True'
    #~ @new_activity = activity_old
    @user=user
    @activity = activity   
    @act_user = User.find_by_user_id(activity.user_id) if activity && activity.present?
    @image_url = "http://#{urls}"
    mail(:to => to, :subject => "Your Updated #{@activity.activity_name} Details")
  end
  
  #send a mail while editing the activity by the parent
  def edit_activity_parent_mail(user,activity,urls,to)
    headers['X-No-Spam'] = 'True'
    #~ @new_activity = activity_old
    @user=user
    @activity = activity
    @image_url = "http://#{urls}"
    mail(:to => to, :subject => "#{@activity.activity_name} has been edited")
  end
  
  #send mail to attendies for parent activity edit
  def edit_parent_participant_mail(user,activity,urls,to)
    headers['X-No-Spam'] = 'True'
    #~ @new_activity = activity_old
    @user=user
    @activity = activity
    @act_user = User.find_by_user_id(activity.user_id) if activity && activity.present?
    @image_url = "http://#{urls}"
    mail(:to => to, :subject => "Your Updated #{@activity.activity_name} Details")
  end
  
  #send a mail while editing the profile  by the provider.
  def provider_edit_profile_mail(user,urls,to,subject)
    headers['X-No-Spam'] = 'True'
    #~ @new_activity = activity_old
    @user=user
    @image_url = urls
    mail(:to => to, :subject => "Edit profile details")
  end
  
  #send a mail while creating  the activity  by the provider.
  def provider_create_activity_mail(user,activity,to,subject,plan,urls)
    headers['X-No-Spam'] = 'True'
    @user=user
    @plan =  plan
    @activity = activity
    @image_url = "http://#{urls}"
    mail(:to => to, :subject => "Famtivity Activity Added - #{@activity.activity_name}")
  end

  #send a mail while creating  the activity  by the parent.
  def parent_create_activity_mail(user,activity,to,subject,plan,urls)
    headers['X-No-Spam'] = 'True'
    @user=user
    @plan =  plan
    @activity = activity
    @image_url = "http://#{urls}"
    mail(:to => to, :subject => "Famtivity Activity Added - #{@activity.activity_name}")
  end
  
  #send a mail while editing the account details  by the provider.
  def provider_accountdetails_mail(user,urls,to,subject)
    headers['X-No-Spam'] = 'True'
    #~ @new_activity = activity_old
    @user=user
    @image_url = urls
    mail(:to => to, :subject => "Edit account details")
  end

  #sending mail to the invite your provider
  def invite_provider_mail(to,urls,subject,p_name,provider_name,utype_parent,invite_user)
    headers['X-No-Spam'] = 'True'
    en_user_id = Base64.encode64("#{invite_user.user_id}")
    #~ added  attend_track param for analytic tracking
    if utype_parent
      @i_url = "http://#{urls}?become_provider=yes&sent_user_email=#{to}&attend_track=true&sent_user=#{en_user_id}"
    else
      @i_url = "http://#{urls}?provider_reg=true&sent_user_email=#{to}&attend_track=true&sent_user=#{en_user_id}"
    end
    @image_url = urls
    @parent_name = p_name
    @provider_name = provider_name
    @utype_parent = utype_parent
    mail(:to => to, :from=>invite_user.email_address, :subject => "#{@parent_name.capitalize} has invited you to join Famtivity")
  end

  #sending mail for the ticket
  def ticket_send_mail(total_count_amount,activity,msg,urls,to,subject,ticket_number,user,participants)
    headers['X-No-Spam'] = 'True'
    @activity = activity
    @total_count_amount = total_count_amount
    @ticket_number = ticket_number
    @image_url = "http://#{urls}"
    @user = user
    @act_user = User.find_by_user_id(activity.user_id) if activity && activity.present?
    @msg = msg
    @participants = participants
    mail(:to => to, :subject => "Your Ticket Detail") 
  end 

  #sending mail for the ticket
  def ticket_send_mail_new_api(total_count_amount,activity,msg,to_add,act_user,ticket_number,user,participants)
    headers['X-No-Spam'] = 'True'
    @activity = activity
    @total_count_amount = total_count_amount
    @ticket_number = ticket_number
    @user = user
    @act_user = act_user
    @msg = msg
    @participants = participants
    mail(:to => to_add, :subject => "Your Ticket Detail") 
  end
  
  #sending mail for the payment process
  def after_payment_mail(total_count_amount,activity,urls,user,ticket_number,trans,to,credit_num)
    headers['X-No-Spam'] = 'True'
    @activity = activity
    @amount = total_count_amount
    @ticket_number = ticket_number
    @image_url = "http://#{urls}"
    @user = user
    @trans = trans
    @cred_num = credit_num
    mail(:to =>to, :subject => "Payment Confirmation")
  end 

  #after payment send mail to parent
  def after_payment_new_api(user,email,activity,trans,status,amount,ticket_code,card_last)
     headers['X-No-Spam'] = 'True'
     @user = user
     @activity = activity
     @trans = trans     
     @status = status
     @amount = amount
     @ticket_code = ticket_code
     @card_last = card_last
     mail(:to =>email, :subject => "Payment Confirmation")    
  end
  
  #sending mail if entire amount paid by promo_code or discount_dollar
  def payment_by_promo_discount(total_count,activity,urls,user,ticket_number,promo_amount,discount_dollar_amt,current_balance,actt_price,to)
    headers['X-No-Spam'] = 'True'
    @activity = activity
    @amount = total_count
    @ticket_number = ticket_number
    @image_url = "http://#{urls}"
    @user = user
    @amount =actt_price
    #~ @parti = participants
    @promo = promo_amount
    @dis_amt = discount_dollar_amt
    @current_bal = current_balance
    mail(:to =>to, :subject => "Payment Confirmation")
  end
  

  def free_downgrade_mail(user,to,urlr)
    headers['X-No-Spam'] = 'True'
    @image_url = urlr
    @user = user
    mail(:to => user.email_address, :subject => "Famtivity Basic Market Plan")
  end

  def sponcor_downgrade_mail(user,to,urlr)
    headers['X-No-Spam'] = 'True'
    @image_url = urlr
    @user = user
    mail(:to => user.email_address, :subject => "Famtivity Ad Sponsor Plan")
  end

  def sponcor_upgrade_mail(user,to,urlr)
    headers['X-No-Spam'] = 'True'
    @image_url = urlr
    @user = user
    mail(:to => user.email_address, :subject => "Upgrade to Famtivity Ad Sponsor Plan")
  end


  def plan_renewal_mail(user,to,urlr,nplan)
    headers['X-No-Spam'] = 'True'
    @image_url = urlr
    @user = user
    @nplan = nplan
    mail(:to => user.email_address, :subject => "Renewal to Famtivity #{@nplan}")
  end

  def sell_upgrade_mail(user,to,urlr,nplan,user_plan,plan_amount,current_amt,old_plan)
    headers['X-No-Spam'] = 'True'
    @image_url = urlr
    @user = user
    @nplan = nplan
    @user_plan = user_plan
    @plan_amount = plan_amount
    @current_amt = current_amt
    @old_plan = old_plan
    mail(:to => user.email_address, :subject => "Famtivity Plan Upgrade Confirmation")
  end

  def sell_downgrade_mail(user,to,urlr,nplan)
    headers['X-No-Spam'] = 'True'
    @image_url = urlr
    @user = user
    @nplan = nplan
    mail(:to => user.email_address, :subject => "Downgrade to Famtivity #{@nplan}")
  end

  def contact_register(user,urlr,to,contact,name)
    #~ added  attend_track param for analytic tracking
    @url = "http://#{urlr}/contact_activate?cid=#{contact}&attend_track=true"
    @user = user
    @name = name
    @image_path = "http://#{urlr}"
    #mail(:to => to, :subject => "#{@user.user_name.titlecase} invites you to join Famtivity")
    mail(:to => to, :from=>@user.email_address, :subject => "#{@user.user_name.titlecase} invites you to join Famtivity!")
    
  end


  def group_invite(user,subject,urlr,to,contact)
    @url = "http://#{urlr}/contact_activate?cid=#{contact}"
    @user = user
    mail(:to => to, :subject => "Welcome to Famtivity!")
  end

  def contact_invite(user,urlr,to,contact)
    #~ added  attend_track param for analytic tracking
    @url = "http://#{urlr}/contact_activate?cid=#{contact}&attend_track=true"
    @user = user
    @image_path = "http://#{urlr}"
    # mail(:to => to, :subject => "#{@user.user_name.titlecase} invites you to join Famtivity")
    mail(:to => to, :from=>@user.email_address, :subject => "#{@user.user_name.titlecase} invites you to join Famtivity!")
  end

  def send_message(user,subject,message,to )
    @user = user
    @message = message
    mail(:to => to, :from=>@user.email_address, :subject => subject)
  end

  def send_image_message(user,subject,message,files,to, urlr, name)
    @name = name
    @user = user
    @message = message
    files && files.each do |attach_file|
      if File.exists?("#{attach_file}")
        file_name =  File.basename(attach_file)
        attachments["#{file_name}"] = File.read("#{attach_file}")
      end
    end
    #attachments['image.png'] = image_url
    mail(:to => to, :from=>@user.email_address, :subject => subject)
    # Remove attachment folder after mail sent
    dir = "#{Rails.root}/public/contact_users_upload/#{@user.user_id}"
    FileUtils.remove_dir dir, true if File.exists?(dir)
  end

  def accept_email(to,uname, cname)  
    @contact_name = cname
    @user_name = uname
    mail(:to => to, :subject => "#{@contact_name} accepted your invite!")
  end
  
  #monthly budget amount is expire send mail to provider
  def monthly_budget_provider(user)
    @user = user    
    mail(:to => @user.email_address, :subject => "Famtivity - Monthly Budget")
  end 
  
  def become_provider_user(user,urlr,plan)
    headers['X-No-Spam'] = 'True'
    @user = user
    @plan = plan
    @image_url = urlr
    mail(:to => user.email_address, :subject => "You are Now an Activity Provider on Famtivity!")
  end
  
  def friend_request(contact,from_user,url)
    @to_user = contact
    @from_user = from_user
    @url = "http://#{url}/contact_activate?cid=#{contact.contact_id}"
    @image_path = "http://#{url}"
    mail(:to =>@to_user.contact_email, :from=>@from_user.email_address, :subject => "#{@from_user.user_name.titlecase} invites you to join as a friend on Famtivity!")
  end
  
  def friend_request_fam_member(contact,from_user,url)
    @to_user = contact
    @from_user = from_user
    sent_user_id = Base64.encode64("#{@from_user.user_id}")
    @url = "http://#{url}/fam_member_activate?c_email=#{contact.email_address}&sent_user=#{sent_user_id}&sent_user_email=#{@to_user}"
    @image_path = "http://#{url}"
    mail(:to =>@to_user.email_address, :from=>@from_user.email_address, :subject => "#{@from_user.user_name.titlecase} invites you to join as a friend on Famtivity!")
  end
  
  def invite_to_join_famtivity(to_email,from_user,message,url)
    @to_user = to_email
    @from_user = from_user
    @message = message
    en_user_id = Base64.encode64("#{@from_user.user_id}")
    #~ added  attend_track param for analytic tracking
    @url = "http://#{url}/register?parent_reg=true&sent_user=#{en_user_id}&sent_user_email=#{ @to_user}&attend_track=true"
    @image_path = "http://#{url}"
    #~ mail(:to =>@to_user, :subject => "#{@from_user.user_name.titlecase} invites you to join famtivity.")
    #mail(:to =>@to_user, :subject => "Join my network in Famtivity!")
    mail(:to =>@to_user, :from=>@from_user.email_address, :subject => "#{@from_user.user_name.titlecase} invites you to join Famtivity!")
  end
  
  #invite a manger for famtivity
  def invite_to_manager(to_email,activity,from_user,message,url,muid)
    @act = activity
    @to_user = to_email
    @from_user = from_user
    @message = message
    en_user_id = Base64.encode64("#{@from_user.user_id}")
    en_muid = Base64.encode64("#{muid}")
    @url = "http://#{url}/invite_manager_accept?sent_user=#{en_user_id}&sent_user_email=#{ @to_user}&muid=#{en_muid}"
    @image_path = "http://#{url}"
    mail(:to =>@to_user, :from=>@from_user.email_address, :subject => "#{@from_user.user_name.titlecase} invites you as manager to join famtivity.")
  end
  
  #assign a manger for famtivity
  def assign_to_manager(managerid,activity,from_user,umid,url)
    @user = User.find(managerid) if !managerid.nil?
    @activity = activity
    @from_user = from_user
    mgr_record = Base64.encode64("#{umid}")
    en_user_id = Base64.encode64("#{@from_user.user_id}")
    @url = "http://#{url}/assign_manager_accept?sent_user=#{en_user_id}&sent_user_email=#{@user.email_address}&mrecord=#{mgr_record}"
    @image_url = "http://#{url}"
    mail(:to =>@user.email_address, :from=>@from_user.email_address, :subject => "#{@from_user.user_name.titlecase} assigned you as manager to join famtivity.")
  end

  def invite_attendies_mail(activity,cuser,schedule,url,to,sh_price,invite_id,msg)
    headers['X-No-Spam'] = 'True'
    @sh_price=sh_price
    @to=to
    @cuser = cuser
    @activity = activity
    @schedule = schedule
    @msg = msg
    @act_user = User.find_by_user_id(activity.user_id) if activity && activity.present?
    en_user_id = Base64.encode64("#{@cuser.user_id}")
    find_u = User.where("email_address=?",to).first
    to_inv_id = Base64.encode64("#{invite_id}")
    @url = (find_u && find_u.present?) ?  "http://#{url}/invite_attendees_accept?inv_attend_id=#{to_inv_id}" : "http://#{url}?parent_reg=true&sent_user=#{en_user_id}&sent_user_email=#{@to}&mail=invite_attendies"
    @image_url = "http://#{url}"
    mail(:to =>@to, :from=>@cuser.email_address, :subject => "Famtivity | Invite Attendees.")
  end
  
  #accept a manger for famtivity
  def accept_manager(prouser,activity,m_user,url)
    @user = prouser
    @activity = activity
    @m_user = m_user
    @image_url = "http://#{url}"
    mail(:to =>@user.email_address, :subject => "Famtivity | #{@m_user.user_name.titlecase} accepted your assigned activity.")
  end
  
  #accept a manger for famtivity
  def manager_permission_changes(prouser,activity,mid)
    @user = prouser
    @activity = activity
    @m_user = User.find(mid) if !mid.nil?
    mail(:to =>@m_user.email_address, :subject => "Famtivity | #{@user.user_name.titlecase} changed your access permission.")
  end
  
  #invite a manger for famtivity to join
  def invite_manager_to_join(to_email,activity,from_user,message,url)
    @act = activity
    @to_user = to_email
    @from_user = from_user
    @message = message
    en_user_id = Base64.encode64("#{@from_user.user_id}")
    @url = "http://#{url}?parent_reg=true&imanager=true&sent_user=#{en_user_id}&sent_user_email=#{ @to_user}"
    @image_path = "http://#{url}"
    mail(:to =>@to_user, :from=>@from_user.email_address, :subject => "#{@from_user.user_name.titlecase} invites you as manager to join famtivity.")
  end
  
  #invite a manger for famtivity to join by rajkumar
  def accepted_status_to_manager(to_email,activity,pro_user,url)
    @act = activity
    @to_user = to_email
    @from_user = pro_user
    @image_path = "http://#{url}"
    mail(:to =>@to_user, :subject => "Famtivity | Successfully accepted #{@from_user.user_name.titlecase} manager invitation")
  end
  
  #invite a manger for famtivity to join by rajkumar
  def accepted_status_to_provider(to_email,activity,from_user,url)
    @act = activity
    @to_user = to_email
    @from_user = from_user
    mgr_actid = Base64.encode64("#{@act.activity_id}") if !@act.nil?
    @url = "http://#{url}?mgrapt=true&macid=#{mgr_actid}"
    mail(:to =>@to_user.email_address, :subject => "Famtivity | Your manager invitation accepted successfully")
  end
  
  #sent a mail to registered user by rajkumar
  def joined_manager_accepted(accept_usr,invited_user)
    @to_user = accept_usr
    @invited_user = invited_user
    mail(:to =>@to_user.email_address, :subject => "Famtivity | Manager invitation accepted while register!")
  end
  
  #sent a mail to registered user status to provider by rajkumar
  def joined_mgr_acpted_to_provider(accept_usr,invited_user)
    @to_user = invited_user
    @accept_user = accept_usr
    mail(:to =>@to_user.email_address, :subject => "Famtivity | Your manager invitation accepted while register by #{@accept_user.user_name.titlecase}!")
  end
  
  def ack_user_discount(invited_user,credits)
    @to_user = User.where('user_id=?',credits.user_id).first
    @invited_user = invited_user
    @credits = credits
    mail(:to =>@to_user.email_address, :subject => "You have received $#{credits.credit_amount.to_i} discount credits from Famtivity!")    
  end


  #send a mail to provider
  def message_to_provider(cuser,puser,acty,urls,msg)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser
    @activity = acty
    @msg = msg
    @image_url = urls
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag==TRUE #send a mail to provider
      mail(:to => @puser.email_address,:bcc=>$admin_bcc, :from=>@cuser.email_address, :subject => "Famtivity - Request for more activity details")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :from=>@cuser.email_address, :subject => "Famtivity - Request for more activity details")
    end
  end
  
  #send a mail to provider
  def trans_msgtoprovider(cuser,puser,acty,urls,msg)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser
    @activity = acty
    @msg = msg
    @image_url = urls
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag==TRUE #send a mail to provider
      mail(:to => @puser.email_address, :bcc=>$admin_bcc, :from=>@cuser.email_address, :subject => "Request for more activity details")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :from=>@cuser.email_address, :subject => "Request for more activity details")
    end
  end
  
  def trans_msgto_sellpro(cuser,puser,acty,urls)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser
    @activity = acty  
    @image_url = urls
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag==TRUE #send a mail to provider
      mail(:to => @puser.email_address, :from=>@cuser.email_address, :subject => "Famtivity - You have been contacted about your activity")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :from=>@cuser.email_address, :subject => "Famtivity - You have been contacted about your activity")
    end
  end
  
  #send a mail to provider
  def beforeln_msg_toprovider(cuser,puser,acty,urls,msg)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser
    @activity = acty
    @msg = msg
    @image_url = urls
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag==TRUE #send a mail to provider
      mail(:to => @puser.email_address, :bcc=>$admin_bcc, :from=>@cuser, :subject => "Famtivity - Request for more activity details")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :from=>@cuser, :subject => "Famtivity - Request for more activity details")
    end
  end
  
  #send a mail to provider
  def beforeln_msg_to_cardprovider(cuser,puser,urls,msg)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser
    @msg = msg
    @image_url = urls
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag==TRUE #send a mail to provider
      mail(:to => @puser.email_address, :bcc=>$admin_bcc, :from=>@cuser, :subject => "Famtivity - Request for more activity details")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :from=>@cuser, :subject => "Famtivity - Request for more activity details")
    end
  end
  
  
  #send a mail to provider
  def incorrect_mailto_pro(cuser,puser,acty,urls)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser
    @activity = acty
    @image_url = urls
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag==TRUE #send a mail to provider
      mail(:to => @puser.email_address, :subject => "Famtivity - Your credit card details seem to be incorrect")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :subject => "Famtivity - Your credit card details seem to be incorrect")
    end
  end
  
  #send a mail to provider for sell through plan
  def incorrect_mailto_pro_forsell(cuser,puser,acty,urls)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser
    @activity = acty
    @image_url = urls
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag==TRUE #send a mail to provider
      mail(:to => @puser.email_address, :subject => "Famtivity - Your credit card details seem to be incorrect")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :subject => "Famtivity - Your credit card details seem to be incorrect")
    end
  end
  
  #send a mail to provider
  def incorrect_mailto_fam(cuser,puser,acty,urls)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser
    @activity = acty
    @image_url = urls
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag==TRUE #send a mail to provider
      mail(:to => @puser.email_address, :subject => "Famtivity - Provider credit card details have been entered incorrectly")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :subject => "Famtivity - Provider credit card details have been entered incorrectly")
    end
  end
  
  #send a mail to provider for sell through plan
  def incorrect_mailto_fam_forsell(cuser,puser,acty,urls)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser
    @activity = acty
    @image_url = urls
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag==TRUE #send a mail to provider
      mail(:to => @puser.email_address, :subject => "Famtivity - Provider credit card details have been entered incorrectly")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :subject => "Famtivity - Provider credit card details have been entered incorrectly")
    end
  end
  
  
  #send a mail to famtivity about the credit card details
  def nocrdcrt_det_to_fam(cuser,puser,acty,urls)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser
    @activity = acty
    @image_url = urls
    mail(:to => "#{$proleads_email}", :subject => "Famtivity - Please assist provider with uploading credit card details")
  end
  
  #send a mail to famtivity about the credit card details
  def nocrdcrt_det_to_fam_forsell(cuser,puser,acty,urls)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser
    @activity = acty
    @image_url = urls
    mail(:to => "#{$proleads_email}", :subject => "Famtivity - Please assist provider with uploading credit card details")
  end
  
  #send a mail to famtivity about the credit card details
  def nocrdcrt_det_to_pro(cuser,puser,acty,urls)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser
    @activity = acty
    @image_url = urls
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag==TRUE #send a mail to provider
      mail(:to => @puser.email_address, :subject => "Famtivity - Please register your credit card details")
    else
      mail(:to => "#{$proleads_email}", :subject => "Famtivity - Please register your credit card details")
    end
  end
  
  #send a mail to provider about the credit card details
  def nocrdcrt_det_to_pro_forsell(cuser,puser,acty,urls)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser
    @activity = acty
    @image_url = urls
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag==TRUE #send a mail to provider
      mail(:to => @puser.email_address, :subject => "Famtivity - Please register your credit card details")
    else
      mail(:to => "#{$proleads_email}", :subject => "Famtivity - Please register your credit card details")
    end
  end

  def message_to_provider_curator(cuser,puser,urls,msg)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser
    @msg = msg
    @image_url = urls
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag==TRUE #send a mail to provider
      mail(:to => @puser.email_address, :bcc=>$admin_bcc, :from=>@cuser.email_address, :subject => "Request for more activity details")
    else #send a mail to admin
      mail(:to => "#{$proleads_email}", :from=>@cuser.email_address, :subject => "Request for more activity details")
    end
  end
  
  #school represent flow - send activity to representative
  def activity_represent_invite_mail(school_repr,new_activity,to_user,sent_user,urls,request)
    @activity = new_activity
    @sent_user = sent_user
    @to_user = to_user
    @rep_share = school_repr.share
    @ven_share = (100-@rep_share.to_f)
    @image_path = "http://#{urls}"
    @url = "#{@image_path}/activate_representative_activity?school_rep=#{school_repr.school_rep_id}"
    @req = request
    mail(:to => to_user.email_address, :from=>@sent_user.email_address, :subject => "Represent the Activity")  
  end
  
  
  #Activity network send message
  def send_message_to_networks(emails,subject,message,user)
    @message = message
    @user = user
    @email = emails
    mail(:to => emails, :from=>@user.email_address, :subject => subject)
  end
  
  
  #parent fill the required form send mail to provider
  def require_form_mail(current_user,activity,actuser,form)
    headers['X-No-Spam'] = 'True'
    @parent = current_user
    @activity=activity
    @actuser=actuser
    @form = form
    mail(:to =>actuser.email_address, :subject => "#{current_user.user_name} has completed the form")
  end
  #parent edit the filled form send mail to provider
  def require_form_edit_toprovider(current_user,activity,actuser,form)
    headers['X-No-Spam'] = 'True'
    @parent = current_user
    @activity=activity
    @actuser=actuser
    @form = form
    mail(:to =>actuser.email_address, :subject => "#{current_user.user_name} has edit the form")
  end
  
  #provider edit the attendees form send mail to parent
  def require_form_edit_mail(current_user,activity,parentuser,form,part_name)
    headers['X-No-Spam'] = 'True'
    @provider = current_user
    @activity=activity
    @parentuser=parentuser
    if (parentuser.class.to_s=='User')
	    @u_email = parentuser.email_address
	    @u_name = parentuser.user_name
    else
	    @u_email = parentuser.guest_email
	    @u_name = parentuser.guest_name
    end
    @form = form
    @part_name = part_name
    mail(:to =>@u_email, :subject => "#{current_user.user_name} has update the form")
  end

   
  #web service mail methods  
  def register_user_api(user)   
    headers['X-No-Spam'] = 'True' 
    @user = user  
    #@url = "http://#{url}/user_activate?email=#{user.email_address}"
    @url = "#{$image_global_path}user_activate?email=#{user.email_address}"
    email_with_name = "#{user.user_name} <#{user.email_address}>"    
    #@sell_pro_mail =Activity.find_by_sql("select act.* from activities act left join users u on act.user_id=u.user_id where lower(u.user_plan)='sell' and lower(active_status)='active' and cleaned=true and lower(created_by)='provider' order by activity_id desc")
    #@spmail = @sell_pro_mail.sample(3)      
    before_check = Activity.find_by_sql("select distinct act.* from activities act left join activity_prices p on act.activity_id=p.activity_id left join activity_discount_prices d on d.activity_price_id=p.activity_price_id where cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and ((act.price_type='1') or (act.price_type='2')) and(lower(d.discount_type)='early bird discount' and date(d.discount_valid) >= '#{Time.now.strftime("%Y-%m-%d")}') or (lower(d.discount_type)!='early bird discount' and lower(act.active_status)='active') order by act.activity_id desc")
    act_free = Activity.get_upcoming_activities(before_check)
    #p act_free
    if !act_free.nil?
      act_free =Activity.find_by_sql("select act.* from activities act left join users u on act.user_id=u.user_id where lower(u.user_plan)='sell' and lower(active_status)='active' and cleaned=true and lower(created_by)='provider' order by activity_id desc")
    end
    @spmail = act_free.sample(3)
    mail(:to => email_with_name, :subject => "Activate Your Famtivity Account!") 
  
  end
  #curator user activation
  def curated_user_activities_api(user)
    @user = user
    mail(:to => user.email_address, :subject => "Welcome to Famtivity!")
  end
	#curator activation mail to famtivity team
  def curator_actinfo_tofam_api(user)
    @user = user
    mail(:to => "#{$proleads_email}", :subject => "Famtivity | Curator Provider #{@user.user_name.titlecase} has taken ownership")
  end
  #welcome email to registered user
  def famtivity_welcome_api(user,amt)
    @user = user
    @amt = amt
    @sell_pro_mail =Activity.find_by_sql("select act.* from activities act left join users u on act.user_id=u.user_id where lower(u.user_plan)='sell' and lower(active_status)='active' and cleaned=true and lower(created_by)='provider' order by activity_id desc")
    @spmail = @sell_pro_mail.sample(3)
    mail(:to => user.email_address, :subject => "Welcome to Famtivity!")
  end

  def shared_message_api(email,subject,message,activity,curr_user)
    headers['X-No-Spam'] = 'True'
    @email = email
    @subject = subject
    @message = message
    @activity = activity
    @curr_user = curr_user
   
    #delivery_options = { user_name: company.smtp_user, password: company.smtp_password, address: company.smtp_host }
    mail(:to =>email,:from => @curr_user.email_address , :subject => subject)
  end
  
  def forgot_password_api(user_name,email,password)
    headers['X-No-Spam'] = 'True'
    @user_name = user_name
    @email=email
    @password=password    
    mail(:to =>email, :subject => "Your Famtivity Password") 
  end
  
  def change_password_api(user)
    headers['X-No-Spam'] = 'True'
    @user = user
    mail(:to =>user.email_address, :subject => "Password Changed")
  end
  
  #reschedule activity
  def activity_reschedule_api(email,activity,user)
    headers['X-No-Spam'] = 'True'
    @user = user
    @email = email
    @activity = activity
    mail(:to =>@email, :subject => "Your Updated Activity Details - #{@activity.activity_name}") 
  end
  
  #reschedule activity mail to participants
  def activity_reschedule_participant_api(email,activity,user)
    headers['X-No-Spam'] = 'True'
    @user = user
    @email = email
    @activity = activity
    mail(:to =>@email, :subject => "Your Updated Activity Details - #{@activity.activity_name}")     
  end
  
  def delete_msg_parent_api(email,activity,user)
    headers['X-No-Spam'] = 'True'
    @email = email
    @activity = activity    
    @user = user
    mail(:to =>@email, :subject => "#{@activity.activity_name} Deleted Successfully")    
  end
  
  def delete_msg_participants_api(user,activity,activity_user)
    headers['X-No-Spam'] = 'True'
    @user = user
    @activity = activity    
    @activity_user = activity_user
    mail(:to =>@user.email_address, :subject => "#{@activity.activity_name} Details Have Changed") 
  end
  
  def support_message_api(type,email,label,comment,file_path)   
    headers['X-No-Spam'] = 'True'
    @type=type
    @email=email
    @label=label
    @comment=comment 
    @file_path = file_path
    mail(:to =>"ambika@i-waves.com", :subject => "Famtivity Support From User")    
  end
  
  
  #reply to user
  def support_reply_api(email)
    headers['X-No-Spam'] = 'True'
    @email = email
    mail(:to =>email, :subject => "Famtivity Support Team")    
  end
  
  #parent invite to provider
  # def invite_provider_parent_api(email,msg,name)
  # headers['X-No-Spam'] = 'True'
  # @email = email
  # @msg = msg
  # @name = name
  # mail(:to =>email, :subject => "Join Famtivity Network ")
  # end
  
  #common user invite a provider
  def invite_provider_api(email,business_name,name)
    headers['X-No-Spam'] = 'True'
    @email = email
    @business_name = business_name
    @name = name
    mail(:to =>email, :subject => "#{name.titlecase} has invited you to join Famtivity")
    
  end
  
  #after payment send mail to parent
  def after_payment_api(user,activity,trans,status,amount,ticket_code)
    headers['X-No-Spam'] = 'True'
    @user = user
    @activity = activity
    @trans = trans
    @status = status
    @amount = amount
    @ticket_code = ticket_code
    mail(:to =>user.email_address, :subject => "Payment Confirmation")
  end
  
  #sending mail if entire amount paid by promo_code or discount_dollar
  def payment_by_promo_discount_api(user,activity,trans,status,amount,ticket_code,promo_amount,discount_dollar_amt,current_balance,actt_price)
    headers['X-No-Spam'] = 'True'
		@user = user
		@activity = activity
		@trans = trans     
		@status = status
		@amount = amount
		@ticket_number = ticket_code
		@amount =actt_price
		#~ @parti = participants
		@promo = promo_amount
		@dis_amt = discount_dollar_amt
		@current_bal = current_balance
		mail(:to =>user.email_address, :subject => "Payment Confirmation")
  end
  
  #free activity attend send mail to parent
  def free_activity_attend_api(user,activity)
    headers['X-No-Spam'] = 'True'
    @user = user
    @activity = activity
    @amount = "Free"
    mail(:to =>user.email_address, :subject => "Payment Confirmation")
  end
  
  #free activity attend send mail to parent
  #~ def free_activity_attend_message_api(activity_user,user,activity,message)
  #~ headers['X-No-Spam'] = 'True'
  #~ @user = user
  #~ @created_user = activity_user
  #~ @activity = activity
  #~ @amount = "Free"
  #~ @message = message
  #~ mail(:to =>@created_user.email_address, :subject => "Payment Confirmation")
  #~ end
  
  
  #contact us mailer function
  def contact_mail_api(email,name,phone,msg,areyou)
    headers['X-No-Spam'] = 'True'
    @email = email
    @msg = msg
    @name = name
    @phone = phone  
    @areyou = areyou
    mail(:to =>"support@famtivity.com", :subject => "Famtivity - Contact")
  end
  
  #sending mail for the ticket
  def ticket_send_mail_api(activity,user,amount,ticket_code,subject)
    headers['X-No-Spam'] = 'True'
    @activity = activity  
    @amount = amount 
    @ticket_code = ticket_code
    mail(:to => user.email_address, :subject => subject)
  end
  
  #user send message
  def user_message_send_api(email,subject,message)
    headers['X-No-Spam'] = 'True'
    @msg = message
    mail(:to => email, :subject => subject)
  end
  
  #when someone in my network create an activity
  def network_user_create_api(user,networkuser,activity)
    headers['X-No-Spam'] = 'True'
    @user = user
    @activity = activity
    @networkuser = networkuser 
    mail(:to =>user.email_address, :subject => "#{@networkuser.user_name.titlecase} just added a Famtivity Activity")
  end
  
  #send mail to following user create new activity
  def following_user_create_api(user,followuser,activity)   
    headers['X-No-Spam'] = 'True' 
    @user = user
    @activity = activity
    @followuser = followuser
    mail(:to =>user.email_address, :subject => "#{@followuser.user_name.titlecase} just added a Famtivity Activity")
  end
  
  
  #send mail to someone follow you
  def following_user_api(user,followuser)
    headers['X-No-Spam'] = 'True'    
    @user = user
    @followuser = followuser
    mail(:to => followuser.email_address, :subject => "#{@user.user_name.titlecase} is now following you!")
  end
  
  #invite famtivity member to accept your friend request (user click the accept link update the contact user table to friend)
  def invitefriend_member_api(contact,user)   
    headers['X-No-Spam'] = 'True'
    @contact = contact
    @user = user
    sent_user_id = Base64.encode64("#{@user.user_id}")
    #~ @url = "#{$image_global_path}fam_member_activate?c_email=#{@contact.contact_email}&sent_user=#{sent_user_id}"
    #~ if @user && @user!=''
    #~ from_add = @user.email_address
    #~ else
    #~ from_add = ""
    #~ end
    @url = "#{$image_global_path}/contact_activate?cid=#{contact.contact_id}"
    mail(:to => @contact.contact_email, :from => @user.email_address, :subject => "#{@user["user_name"].capitalize} invites you to join as a Friend on Famtivity")
  end
  
  #invite  to join famtivity (this is contact page,user click accept link to open registration page)
  def invite_to_famtivity_api(contact,user)   
    headers['X-No-Spam'] = 'True'
    @contact = contact
    @user = user
    @url = "#{$image_global_path}?parent_reg=true"
    #mail(:to => @contact.contact_email, :subject => "#{@user["user_name"]} invites you to join Famtivity ")
    mail(:to => @contact.contact_email, :from => @user.email_address,  :subject => "#{@user["user_name"]} invites you to join Famtivity to benefit your kids!")
  end
  
  #inviteemail page send invite to join famtivity member (click accept link to open registration page) - Add contact,invite email
  def join_famtivity_api(invitor,user,msg,email)
    headers['X-No-Spam'] = 'True'
    @invitor = invitor
    @user = user
    @message = msg
    en_user_id = Base64.encode64("#{@user.user_id}")
    @email=email
    # @url = "#{$image_global_path_wap}register?parent_reg=true&invitedid=#{en_user_id}&user_email=#{@email}"
    @url = "#{$image_global_path}/register?parent_reg=true&sent_user=#{en_user_id}&sent_user_email=#{@email}"
    mail(:to => @email, :from => @user.email_address, :subject => "#{@user["user_name"]} invites you to join Famtivity!")
    #mail(:to => @email, :subject => "#{@user["user_name"]} invites you to join Famtivity")
  end
  
  #invite friend on famtiivty (user click the accept link update the contact user table to friend) - Add contact
  def invite_friend_api(contact,user,message)   
    headers['X-No-Spam'] = 'True'
    @contact = contact
    @user = user
    @msg = message
    sent_user_id = Base64.encode64("#{@user.user_id}")
    #if @contact.contact_user_type=="Member"
		#member, send this link
    @url = "#{$image_global_path}/contact_activate?cid=#{@contact.contact_id}"
    # else
    #non member send this link
    #@url = "#{$image_global_path}/contact_activate?parent_reg=true&sent_user=#{sent_user_id}&sent_user_email=#{@contact["contact_email"]}"
    #end
    # contact_user_type
    #@url = "#{$image_global_path}fam_member_activate?c_email=#{@contact.contact_email}&sent_user=#{sent_user_id}"
    # @url = "#{$image_global_path}/contact_activate?cid=#{@contact.contact_id}"
    mail(:to => @contact.contact_email,:from => @user.email_address,  :subject => "#{@user["user_name"]} invites you to join as a friend on Famtivity!")
  end
  
  def sendmessagetofriend_api(email,subject,message,name,user)
    headers['X-No-Spam'] = 'True'  
    @email = email    
    @message = message
    @name = name
    @user = user
    if @user && @user!=''
      from_add = @user.email_address
    else
      from_add = ""
    end
    mail(:to => @email,:from =>from_add,  :subject => "Famtivity - #{subject} ")
  end
  
  #monthly budget amount is expire send mail to provider
  def monthly_budget_provider_api(user)
    headers['X-No-Spam'] = 'True'
    @user = user    
    mail(:to => @user.email_address, :subject => "Famtivity - Monthly Budget")
  end 
  
  #deviceactivation mail
  def device_activation_api(udit,message)
    headers['X-No-Spam'] = 'True'
    @udit = udit    
    @message = message
    mail(:to =>"admin@famtivity.com,sonyabokhari@gmail.com,durgadevi@i-waves.com", :subject => "Famtivity - Device Activation")
    #admin@famtivity.com,sonyabokhari@gmail.com,durgadevi@i-waves.com
  end
  
  
  #if parent create activity send mail
  def activity_create_api(user,activity)
    headers['X-No-Spam'] = 'True'
    @user = user
    @activity = activity
    mail(:to => @user.email_address, :subject => "Famtivity Activity Added - #{@activity.activity_name}")
  end
  
  #facebook login
  def facebook_login_api(user)
    headers['X-No-Spam'] = 'True'
    @user = user
    mail(:to => @user.email_address, :subject =>"Welcome to Famtivity!")
  end
  
  #get info send mail to activity owner
  def getinfo_activity_api(activity_user,user,activity,message)
    headers['X-No-Spam'] = 'True'
    @activity_user = activity_user
    @user = user
    @activity = activity
    @msg = message
    mail(:to => @activity_user.email_address, :bcc=>$admin_bcc, :from=>@user.email_address, :subject =>"Request for more activity details")
  end
 
  #contact provider to activity price details
  def contact_provider_mail_api(activity_user,user,activity,message)
    headers['X-No-Spam'] = 'True'
    @activity_user = activity_user
    @user = user
    @activity = activity
    @msg = message
    mail(:to =>@activity_user.email_address, :subject => "Request for activity price details")
  end
  
  #send mail to activity owner, free attend
  def provider_attend_free_api(activity_user,user,activity,message)
    headers['X-No-Spam'] = 'True'
    @activity_user = activity_user
    @user_name = (user.class.to_s=='User') ? user.user_name : user.guest_name
    @activity = activity
    @msg = message
    @url = "#{$image_global_path}/attendies?uid=#{Base64.encode64("#{@activity.user_id}")}&aid=#{Base64.encode64("#{@activity.activity_id}")}&aname=#{Base64.encode64("#{@activity.activity_name}")}"
    mail(:to =>@activity_user.email_address, :subject => "#{@user_name.titlecase} is Attending #{@activity.activity_name}")
  end
  
  #send mail to activity owner, sell attend
  def provider_attend_sell_api(activity_user,user,activity,ticket_number)
    headers['X-No-Spam'] = 'True'
    @activity_user = activity_user
    @user_name = (user.class.to_s=='User') ? user.user_name : user.guest_name
    @u_id = (user.class.to_s=='User') ? user.user_id : user.guest_id
    @email = (user.class.to_s=='User') ? user.email_address : user.guest_email
    @activity = activity
    @ticket_number = ticket_number
    @url = "#{$image_global_path}/attendies?uid=#{Base64.encode64("#{@activity.user_id}")}&aid=#{Base64.encode64("#{@activity.activity_id}")}&aname=#{Base64.encode64("#{@activity.activity_name}")}"
    mail(:to =>@activity_user.email_address, :subject => "#{@user_name.titlecase} is Attending #{@activity.activity_name}")
  end
  
  #before login send message in activity details page
  def before_message_toprovider_api(email,user,message,activity)
    headers['X-No-Spam'] = 'True'
    @email = email
    @user = user    
    @msg = message   
    @activity = activity
    if !@user.nil? && @user!='' && @user.present? && @user.user_flag == TRUE 
      mail(:to => @user.email_address, :bcc=>$admin_bcc, :from => @email,  :subject => "Famtivity - Request for more activity details")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}",:from => @email, :subject => "Famtivity - Request for more activity details")
    end
  end
  #after login send message in activity details page
  def message_toprovider_api(cuser,user,message,activity)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @user = user    
    @msg = message   
    @activity = activity
    if !@user.nil? && @user!='' && @user.present? && @user.user_flag == TRUE 
      mail(:to => @user.email_address, :bcc=>$admin_bcc, :from => @cuser.email_address, :subject => "Famtivity - Request for more activity details")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}",:from => @cuser.email_address, :subject => "Famtivity - Request for more activity details")
    end
  end
  #message to provider card
  def message_toprovider_card_api(puser,cuser,message)
    headers['X-No-Spam'] = 'True'
    @cuser = cuser
    @puser = puser    
    @msg = message   
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag == TRUE 
      mail(:to => @puser.email_address, :from => @cuser, :subject => "Request for more activity details")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :from => @cuser, :subject => "Request for more activity details")
    end
  end
  #provider leads - sell through plan provider dont have the credit card, send mail to famtivity admin
  def nocc_sell_fam_api(user_cur,pro_usr,activity)
    headers['X-No-Spam'] = 'True'
    @cuser = user_cur
    @puser = pro_usr
    @activity = activity
    mail(:to => "#{$proleads_email}", :subject => "Famtivity - Please assist provider with uploading credit card details")
  end
  #provider leads - sell through plan provider dont have the credit card, send mail to provider
  def nocc_sell_pro_api(user_cur,pro_usr,activity)
    headers['X-No-Spam'] = 'True'
    @cuser = user_cur
    @puser = pro_usr
    @activity = activity
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag==TRUE #send a mail to provider
      mail(:to => @puser.email_address, :subject => "Famtivity - Please register your credit card details")
    else
      mail(:to => "#{$proleads_email}", :subject => "Famtivity - Please register your credit card details")
    end
  end
  #provider leads - market plan provider dont have the credit card, send mail to famtivity admin
  def nocc_free_fam_api(user_cur,pro_usr,activity)
    headers['X-No-Spam'] = 'True'
    @cuser = user_cur
    @puser = pro_usr
    @activity = activity
    mail(:to => "#{$proleads_email}", :subject => "Famtivity - Please assist provider with uploading credit card details")
  end
  #provider leads - market plan provider dont have the credit card, send mail to provider
  def nocc_free_pro_api(user_cur,pro_usr,activity)
    headers['X-No-Spam'] = 'True'
    @cuser = user_cur
    @puser = pro_usr
    @activity = activity
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag==TRUE #send a mail to provider
      mail(:to => @puser.email_address, :subject => "Famtivity - Please register your credit card details")
    else
      mail(:to => "#{$proleads_email}", :subject => "Famtivity - Please register your credit card details")
    end
  end
  
  #provider leads - sell through plan provider, the credit card incorrect, send mail to famtivity admin
  def incorrectcc_sell_fam_api(user_cur,pro_usr,activity)
    headers['X-No-Spam'] = 'True'
    @cuser = user_cur
    @puser = pro_usr
    @activity = activity
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag == TRUE #send a mail to provider
      mail(:to => @puser.email_address, :subject => "Famtivity - Provider credit card details have been entered incorrectly")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :subject => "Famtivity - Provider credit card details have been entered incorrectly")
    end
  end
  #provider leads - sell through plan provider, the credit card incorrect, send mail to provider
  def incorrectcc_sell_pro_api(user_cur,pro_usr,activity)
    headers['X-No-Spam'] = 'True'
    @cuser = user_cur
    @puser = pro_usr
    @activity = activity  
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag == TRUE #send a mail to provider
      mail(:to => @puser.email_address, :subject => "Famtivity - Your credit card details seem to be incorrect")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :subject => "Famtivity - Your credit card details seem to be incorrect")
    end
  end
  #provider leads - market plan provider, the credit card incorrect, send mail to famtivity
  def incorrectcc_free_fam_api(user_cur,pro_usr,activity)
    headers['X-No-Spam'] = 'True'
    @cuser = user_cur
    @puser = pro_usr
    @activity = activity 
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag == TRUE #send a mail to provider
      mail(:to => @puser.email_address, :subject => "Famtivity - Provider credit card details have been entered incorrectly")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :subject => "Famtivity - Provider credit card details have been entered incorrectly")
    end
  end
  #provider leads - market plan provider, the credit card incorrect, send mail to provider
  def incorrectcc_free_pro_api(user_cur,pro_usr,activity)
    headers['X-No-Spam'] = 'True'
    @cuser = user_cur
    @puser = pro_usr
    @activity = activity 
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag == TRUE #send a mail to provider
      mail(:to => @puser.email_address, :subject => "Famtivity - Your credit card details seem to be incorrect")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :subject => "Famtivity - Your credit card details seem to be incorrect")
    end
  end
  #provider leade - after success the transaction send mail to market plan provider
  def trans_msgto_free_api(user_cur,pro_usr,activity)
    headers['X-No-Spam'] = 'True'
    @cuser = user_cur
    @puser = pro_usr
    @activity = activity
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag == TRUE #send a mail to provider
      mail(:to => @puser.email_address, :bcc=>$admin_bcc, :from =>@cuser.email_address , :subject => "Request for more activity details")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :from =>@cuser.email_address, :subject => "Request for more activity details")
    end
  end
  #provider leade - after success the transaction send mail to sell through plan provider
  def trans_msgto_sell_api(user_cur,pro_usr,activity)
    headers['X-No-Spam'] = 'True'
    @cuser = user_cur
    @puser = pro_usr
    @activity = activity
    if !@puser.nil? && @puser!='' && @puser.present? && @puser.user_flag == TRUE #send a mail to provider
      mail(:to => @puser.email_address, :from =>@cuser.email_address, :subject => "Famtivity - You have been contacted about your activity")
    else #send a mail to admin 
      mail(:to => "#{$proleads_email}", :from =>@cuser.email_address, :subject => "Famtivity - You have been contacted about your activity")
    end
  end
  #Change mail id
  def change_email_address_api(user,urlr,utype)
    @utype=utype
    @user = user
    @url = "#{$image_global_path}user_activate?email=#{user.email_address}"
    user_id   = Base64.encode64("#{user.user_id}")
    @en_utype = Base64.encode64("#{utype}")
    @url = "#{$image_global_path}email_activate?uid=#{user_id}&utype=#{@en_utype}"
    mail(:to => user.new_email_address, :subject => "Change Email Address!")
  end
  
  #parent fill the required form send mail to provider
  def require_form_mail_api(current_user,activity,actuser,form)
    headers['X-No-Spam'] = 'True'
    @parent = current_user
    @activity=activity
    @actuser=actuser
    @form = form
    mail(:to =>actuser.email_address, :subject => "#{current_user.user_name} has completed the form")
  end
  def sendmessagetofriend_image_api(user,subject,message,files,to, urlr, name)
    @name = name
    @user = user
    @message = message
    files && files.each do |attach_file|
      if File.exists?("#{attach_file}")
        file_name =  File.basename(attach_file)
        attachments["#{file_name}"] = File.read("#{attach_file}")
      end
    end
    if @user && @user!=''
      from_add = @user.email_address
    else
      from_add = ""
    end
    #attachments['image.png'] = image_url
    mail(:to => to, :from=>from_add, :subject => subject)
    # Remove attachment folder after mail sent
    dir = "#{$tbl_image_path}/contact_users_upload/#{@user.user_id}"
    FileUtils.remove_dir dir, true if File.exists?(dir)
  end
  
  def network_invite_mail_api(curre_user,network,to,urlr,user)
    headers['X-No-Spam'] = 'True'
    @user=curre_user
    @network = network
    @to = to
    @user_id = user
    @url = "#{$image_global_path}accept_fam_network?group=#{network.group_id}&invite_user_id=#{to}"
    mail(:to => to, :subject => "Famtivity Network Invite")	
  end
  
  def network_to_join_famtivity_api(curre_user,network,to,urlr,contact,message)
    headers['X-No-Spam'] = 'True'
    @to_user = to
    @from_user = curre_user
    @message = message
    @network = network
    @contact = contact
    en_user_id = Base64.encode64("#{@from_user.user_id}")
    #~ added  attend_track param for analytic tracking
    @url = "#{$image_global_path}/register?cid=#{contact.contact_id}&group=#{network.group_id}&parent_reg=true&sent_user=#{en_user_id}&sent_user_email=#{@to_user}&attend_track=true"
    @image_path = "#{$image_global_path}"
    mail(:to => to, :subject => "Famtivity Network Invite")
  end

  def network_member_invite_mail_api(curre_user,network,to,urlr,user,contact_id,message)
    @from_user=curre_user
    @network = network
    @to = to
    @user_id = user.user_id
    @to_user = user.user_name
    @message = message
    @image_path = "#{$image_global_path}"
    @url = "#{$image_global_path}contact_activate?cid=#{contact_id}&group=#{network.group_id}&user_id=#{user.user_id}"
    mail(:to => to, :subject => "Famtivity Network Invite")
  end
  
  def network_friend_invite_mail_api(curre_user,network,to,urlr,user,contact_id,message)
    @from_user=curre_user
    @network = network
    @to = to
    @user_id = user.user_id
    @to_user = user.user_name
    @message = message
    @image_path = "#{$image_global_path}"
    @url = "#{$image_global_path}contact_activate?cid=#{contact_id}&group=#{network.group_id}&user_id=#{user.user_id}"
    mail(:to => to, :subject => "Famtivity Network Invite")
  end
  
  def ack_user_discount_api(invited_user,credits)
    @to_user = User.where('user_id=?',credits.user_id).first
    @invited_user = invited_user
    @credits = credits
    mail(:to =>@to_user.email_address, :subject => "You have received $#{credits.credit_amount.to_i} discount credits from Famtivity!")    
  end
  
  def fam_create_network_mail_api(email_address,fam_post,urlr,fromuser,msg,msg_rec)
    to_user = Base64.encode64(email_address) if !email_address.nil?
    @image_path = "#{$image_global_path}"	
    @url = "#{$image_global_path}messages?msg_email=#{to_user}&view_more=true&rep_id=#{msg_rec.message_id}"
    @to = email_address
    @fam_post = fam_post
    @fromuser = fromuser
    @msg = msg
    @msg_subject = msg_rec.subject
    mail(:to => @to, :subject => "#{@msg_subject} | Fam Network - #{@fam_post.group_name if @fam_post}")
  end
  
  def contact_success_mail_api(email_address,group_name,contact_users,url)
    @image_path = "#{$image_global_path}"
    @to = email_address
    @fam_post = group_name
    @contact = contact_users
    mail(:to => @to, :subject => "#{@contact.contact_email.split('@')[0] if @contact && @contact.contact_email} accepted your invitation | Fam Network - #{@fam_post.group_name}")
  end


  def user_fb_credit_discount_code(user,urlr,discount_code,discount_amount)
    @user = user
    @to = user.email_address
    @image_url = "http://#{urlr}"
    @code = discount_code
    @amt = discount_amount
    mail(:to => @to, :subject => "You have received $#{discount_amount} discount credits from Famtivity!")
  end
  
  
end
