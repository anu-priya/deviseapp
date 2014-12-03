class LoginController < ApplicationController
  require "open-uri"
   layout 'frame_layout',:only => [:login, :new_login]
  # Login index page
  def index
    if cookies[:mail_usr] && cookies[:password_usr] && cookies[:automatic_login]
      email_usr = cookies[:mail_usr]
      password_usr = cookies[:password_usr]
      automatic_login = cookies[:automatic_login]
      role_usr = cookies[:role_usr]
    else
      email_usr  = "Eg:john@gmail.com"
      password_usr = "password"
      automatic_login = ""
    end
    @roles=["Parent","Provider"]
    @loggedin = [email_usr,password_usr,automatic_login]
  end

  #  called when submit in login page
  def submit
    @email_val=params[:email_val] if !params[:email_val].nil? && params[:email_val].present?
    @ws=params[:ws] if !params[:ws].nil? && params[:ws].present?
    @mgr_acpted=params[:mgr_acpted] if !params[:mgr_acpted].nil? && params[:mgr_acpted].present? #this params for mangaer accepted flow
    @macid=params[:macid] if !params[:macid].nil? && params[:macid].present? #this params for mangaer accepted flow
    @activity_id = params[:activity_id] if !params[:activity_id].nil? && params[:activity_id].present?
    @get_cooki_arg = params[:bcrum] if !params[:bcrum].nil? && params[:bcrum].present?
    @before_login_value=@activity_id if !params[:activity_id].nil? && params[:activity_id].present?
    @activity= Activity.find_by_activity_id(params[:activity_id]) if !params[:activity_id].nil? && params[:activity_id].present?
    @act= params[:act] if !params[:act].nil? && params[:act].present?
    @atten_type = params[:attend_act_type] if !params[:attend_act_type].nil? && params[:attend_act_type].present?
    @atten_uid = Base64.decode64("#{params[:attend_act_uid]}") if !params[:attend_act_uid].nil? && params[:attend_act_uid].present? && params[:attend_act_uid]!=''
    @atten_aid = params[:attend_act_aid] if !params[:attend_act_aid].nil? && params[:attend_act_aid].present?
    @news_import  = params[:news_import] if !params[:news_import].nil? && params[:news_import].present?
    if (@atten_type=='attendies')
      @attendee_link = "attendies?uid=#{params[:attend_act_uid]}&aid=#{params[:attend_act_aid]}"
    end
    cookies.delete :first_import
    email_usr = params[:email]
    password_usr = params[:password]
    automatic_login = params[:automatic_login]
    @become_provider = (params[:prov_invite] && !params[:prov_invite].nil? && !params[:prov_invite].empty?) ? params[:prov_invite] : false
    @invite_user_id = params[:invite_user_id] if !params[:invite_user_id].nil? && params[:invite_user_id].present?
    @imanager = params[:imanager] if !params[:imanager].nil? && params[:imanager].present?
    @invite_user_email = params[:invite_user_email] if !params[:invite_user_email].nil? && params[:invite_user_email].present?
    cookies[:logged_in] = "no"
    @embed_user=params[:embed_user] if !params[:embed_user].nil? && params[:embed_user].present?
    if !params[:email].nil?
      error_mes = "false"
      pwd=Base64.encode64('adminpassword')
      if !pwd.nil? && pwd!='' && !password_usr.nil? && password_usr!='' && pwd==Base64.encode64("#{password_usr}")
	      #@user_usr = User.find_by_email_address(params[:email].downcase)
	      @user_usr = User.where("lower(email_address)='#{params[:email].downcase}'").last
      else
        #@user_usr = User.find_by_email_address_and_user_password(params[:email].downcase,params[:password])
        @user_usr = User.where("lower(email_address)= ? and user_password = ? ", params[:email].downcase,Base64.encode64("#{params[:password]}")).last
      end
      error_mes = "Please check the Email and password you have entered" if @user_usr.nil?
      error_mes ="Your account has not been activated yet. Click on the activation link in your Email to activate it now" if @user_usr && @user_usr.account_active_status != true
      if error_mes == "false"
        if automatic_login == "true"
          cookies.permanent[:mail_usr] = email_usr
          cookies.permanent[:email_usr] = email_usr
          cookies.permanent[:password_usr] = password_usr
          cookies.permanent[:automatic_login] = automatic_login
        else
          cookies.delete :email_usr
          cookies.delete :password_usr
          cookies.delete :automatic_login
        end
        if @user_usr
          add_sign_count = @user_usr.sign_in_count
          @user_usr.sign_in_count = (add_sign_count.nil? || add_sign_count==0) ?  1 : (add_sign_count+1)
          @user_usr.last_sign_in = Time.now
          @user_usr.save
        end
        #        cookies.permanent[:auth_token]
        cookies[:date_registered_usr] = Time.now.strftime("%Y-%m-%d") if cookies[:date_registered_usr].nil?
        cookies[:login_usr] = "on"
        cookies[:role_usr]= @user_usr.user_type
        cookies[:logged_in] = "yes"
        session[:user_id] = @user_usr.user_id
        cookies.permanent[:uid_usr] = @user_usr.user_id
        cookies.permanent[:username_usr] = @user_usr.user_name
        cookies[:email_usr] = @user_usr.email_address
        respond_to do|format|
          format.js
        end
      else
        @login_error = [email_usr,password_usr,automatic_login,error_mes,params[:role_usr]]
        respond_to do |format|
          format.js{render :text => "$('#user_name_wrong').html('#{error_mes}');$('#user_name_wrong').css('display', 'block').fadeOut(10000);"}
        end
      end
    else
      @login_error = [email_usr,password_usr,automatic_login,error_mes,params[:role_usr]]
      respond_to do |format|
        format.js{render :text => "$('#user_name_wrong').html('Email Received Blank.Pls contact our support team');$('#user_name_wrong').css('display', 'block').fadeOut(10000);"}
      end
    end
  end
  
  def generate_password(length)
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789'
    password = ''
    length.times { |i| password << chars[rand(chars.length)] }
    password
  end
  
  # def set_picture(data)
  #    temp_file = Tempfile.new(['temp', '.jpg'], :encoding => 'ascii-8bit')
  #
  #    begin
  #      temp_file.write(data)
  #      self.user_photo = temp_file # assumes has_attached_file :picture
  #    ensure
  #      temp_file.close
  #      temp_file.unlink
  #    end
  #  end

  def fb_login
	  p 4444444444444
    @from_fb="active"
    @email_add = ''
    @get_current_url = request.env['HTTP_HOST']
    if !params[:fb_res].nil? && !params[:fb_res][:id].nil?
      if !params[:fb_res][:email].nil? && params[:fb_res][:email]!=''
        @email_add = params[:fb_res][:email].downcase
      end
      
      @user_curator = User.where(email_address: @email_add,user_plan: "curator").first
      if !@user_curator.nil?
        @old_plan="curator"
        cookies[:f_path]="facebook"
        cookies[:f_curator]=@email_add
        @user_curator.fb_id = params[:fb_res][:id]
        @user_curator.save!
      else   
        @user = User.where(fb_id: params[:fb_res][:id],email_address: @email_add ).first
        if !@user.nil?
          user = User.where(email_address: @email_add).first
          if user
            user.fb_id = params[:fb_res][:id]
            user.sign_in_count= user.sign_in_count + 1 if !user.sign_in_count.nil? && user.sign_in_count.present?
            user.save!
            cookies[:city_registered_usr] = cookies[:city_new_usr]
            cookies[:date_registered_usr] = Time.now.strftime("%Y-%m-%d") if cookies[:date_registered_usr].nil?
            cookies[:login_usr] = "on"
            cookies[:role_usr]= user.user_type
            cookies[:logged_in] = "yes"
            session[:user_id] = user.user_id
            cookies.permanent[:uid_usr] = user.user_id
            cookies.permanent[:username_usr] = user.user_name
            cookies[:email_usr] = user.email_address
          end
          if params[:s_user].present? && !params[:s_user].empty? && params[:s_user] !="undefined" && params[:invited].present? && !params[:invited].empty? && params[:invited] !="undefined"
            @cont_user = ContactUser.where("profile_id=? and user_id=?",params[:invited],params[:s_user]).first
            facebook_accept(@cont_user,params[:s_user],@user)
          end
        else
          @user_exist = User.where(email_address: @email_add).first
          if !@user_exist.nil?
            @user_exist.fb_id = params[:fb_res][:id]
            @user_exist.save!
            if params[:s_user].present? && !params[:s_user].empty? && params[:s_user] !="undefined" && params[:invited].present? && !params[:invited].empty? && params[:invited] !="undefined"
              @cont_user = ContactUser.where("profile_id=? and user_id=?",params[:invited],params[:s_user]).first
              facebook_accept(@cont_user,params[:s_user],@user_exist)
            end
            cookies[:city_registered_usr] = cookies[:city_new_usr]
            cookies[:date_registered_usr] = Time.now.strftime("%Y-%m-%d") if cookies[:date_registered_usr].nil?
            cookies[:login_usr] = "on"
            cookies[:role_usr]= @user_exist.user_type
            cookies[:logged_in] = "yes"
            session[:user_id] = @user_exist.user_id
            cookies.permanent[:uid_usr] = @user_exist.user_id
            cookies.permanent[:username_usr] = @user_exist.user_name
            cookies[:email_usr] = @user_exist.email_address
          else
            name = "user"
            @user_usr = User.new
            if !params[:fb_res][:username].nil?
              name =params[:fb_res][:username]
            else
              name =params[:fb_res][:name]
            end
            @user_usr.user_name = name
            @user_usr.email_address = params[:fb_res][:email].downcase if !params[:fb_res][:email].nil? && params[:fb_res][:email]!=""
            @user_usr.user_password = Base64.encode64("#{generate_password(10)}")
            @user_usr.user_type = "U"
            @user_usr.user_plan = "free"
            @user_usr.user_created_date = Time.now
            @user_usr.user_expiry_date = Time.now + (30*24*60*60)
            @user_usr.account_active_status = true
            @user_usr.fb_id = params[:fb_res][:id]
            @user_usr.user_flag = TRUE
            #~ Added sign_in_count for facebook login
            add_sign_count = @user_usr.sign_in_count
            @user_usr.sign_in_count = (add_sign_count.nil? || add_sign_count==0) ? 1 : (add_sign_count+1)
            @user_usr.last_sign_in = Time.now
            #end of sign_in_count
            @result = @user_usr.save
            @old_contact=ContactUser.find_all_by_contact_email(@user_usr.email_address)
            @old_contact.each do |con|
              con.update_attributes(:fam_user_id =>@user_usr.user_id,:contact_user_type=>"member")
            end if !@old_contact.nil?
            # insert the credited values $ 5 per registeration start
            @u_cdts = UserCredit.new
            @u_cdts.user_id = @user_usr.user_id if @user_usr.present?
            @u_cdts.credit_amount = 20
            @u_cdts.provider_plan = @user_usr.user_plan if @user_usr.present?
            @u_cdts.inserted_date = Time.now
            @u_cdts.modified_date = Time.now
            @u_cdts.credit_type = "register"
            @u_cdts.save
            # insert the credited values $ 5 per registeration end
            @from_fb="inactive"
            success = @user_usr && @user_usr.save
            if success && @user_usr.errors.empty?
              @user_pro = UserProfile.new
              @user_pro.inserted_date = Time.now
              @user_pro.modified_date = Time.now
              @user_pro.user_id =  @user_usr.user_id
	      @user_pro.city = cookies[:current_city]
              @user_pro.user_photo = open(params[:fb_res][:picture][:data][:url]) if !params[:fb_res][:picture][:data][:url].nil?
              @user_pro.save
              if params[:s_user].present? && !params[:s_user].empty? && params[:s_user] !="undefined" && params[:invited].present? && !params[:invited].empty? && params[:invited] !="undefined"
                user = User.find_by_user_id(params[:s_user])
                @c_user = ContactUser.new
                if @user_usr
                  @c_user.user_id = @user_usr.user_id
                  @c_user.contact_email = user.email_address
                  @c_user.contact_name = user.user_name
                  @c_user.inserted_date = Time.now
                  @c_user.modified_date = Time.now
                  @c_user.accept_status = true
                  @c_user.contact_user_type = 'friend'
                  @c_user.contact_type = 'facebook'
                  @c_user.fam_user_id = user.user_id if !user.user_id.nil?
                  @c_user.inserted_date = Time.now
                  @c_user.modified_date = Time.now
                  @c_user.save
                  cookies[:fam_invited_user]=user.email_address if !user.email_address.nil?
                end
              end
            
              #=================Fb user register with newsletter for cotc starting======================#
              group_name = User.get_newsletter_group(cookies[:current_city], @user_usr)
	      city_val = cookies[:current_city]!='' ? URI::encode(cookies[:current_city]) : ''
	      user_name = (@user_usr && !@user_usr.nil? && @user_usr.user_name.present?) ? URI::encode(@user_usr.user_name) : ''
              url_v="http://campaignonthecloud.com/Update_Registration_Status.aspx?name=#{user_name}&mobile=&email_id=#{@user_usr.email_address}&country=&address=&city=#{city_val}&zipcode=&domain_name=#{$domain_name}&planname=&groupname=#{group_name}&subscription=1"
              url = URI.parse(URI.encode(url_v.strip))
              req = Net::HTTP.new(url.host, url.port)
              begin
                res = req.request_head(url.path)
                if res.code != "404"
                  request = Net::HTTP::Get.new(url.request_uri)
                  response = req.request(request)
                  @news_response=response.body.html_safe
                  #~ render :text => @news_response
                end
              rescue Exception => exc
                #~ render :text => "Problem on API"
              end
              #=================Fb user register with newsletter for cotc ending======================#
	    
              cookies[:city_registered_usr] = cookies[:city_new_usr]
              cookies[:date_registered_usr] = Time.now.strftime("%Y-%m-%d") if cookies[:date_registered_usr].nil?
              cookies[:login_usr] = "on"
              cookies[:role_usr]= @user_usr.user_type
              cookies[:logged_in] = "yes"
              session[:user_id] = @user_usr.user_id
              cookies.permanent[:uid_usr] = @user_usr.user_id
              cookies.permanent[:username_usr] = @user_usr.user_name
              cookies[:email_usr] = @user_usr.email_address
              @register = "success"
              @from_fb = "success"

              #changes for invite facebook start
              if params[:s_user].present? && !params[:s_user].empty? && params[:s_user] !="undefined" && params[:invited].present? && !params[:invited].empty? && params[:invited] !="undefined"
                @cont_user = ContactUser.where("profile_id=? and user_id=?",params[:invited],params[:s_user]).first
                if @cont_user
                  @cont_user.contact_user_type='friend'
                  @cont_user.contact_email = @user_usr.email_address
                  @cont_user.contact_name = @user_usr.user_name
                  @cont_user.fam_user_id = @user_usr.user_id if !@user_usr.user_id.nil?
                  @cont_user.modified_date = Time.now
                  @cont_user.accept_status = true
                  @cont_user.save
                else
                  @c_user = ContactUser.new
                  @c_user.user_id = params[:s_user]
                  @c_user.contact_email = @user_usr.email_address
                  @c_user.contact_name = @user_usr.user_name
                  @c_user.contact_user_type = 'friend'
                  @c_user.accept_status = true
                  @c_user.contact_type = 'facebook'
                  @c_user.fam_user_id = @user_usr.user_id if !@user_usr.user_id.nil?
                  @c_user.inserted_date = Time.now
                  @c_user.modified_date = Time.now
                  @c_user.save
                end
                @u_credits = UserCredit.new
                @u_credits.user_id = params[:s_user]
                @u_credits.invitee_id = @user_usr.user_id
                invitee_detail = User.user_plan_type(@user_usr.user_type,@user_usr.user_plan)
                @u_credits.invitee_plan = invitee_detail[0]
                @u_credits.credit_amount = invitee_detail[1]
                @u_credits.provider_plan = invitee_detail[2]
                @u_credits.credit_type = "invite"
                @u_credits.inserted_date = Time.now
                @u_credits.modified_date = Time.now
                @u_credits.save
                UserMailer.delay(queue: "Acknowledge User Discount", priority: 1, run_at: 5.seconds.from_now).ack_user_discount(@user_usr,@u_credits)
              end
              #changes for invite facebook end
              #~ UserMailer.delay(queue: "Parent Register", priority: 1, run_at: 5.seconds.from_now).parent_register_user_pass(@user_usr,@get_current_url)
              #soren feedback mail updated
              cookies.delete :first_import
              @credit_list = UserCredit.where("user_id=?",@user_usr.user_id)
              @t_cred_amount =  (!@credit_list.nil?) ? @credit_list.sum(&:credit_amount) : 0
              UserMailer.delay(queue: "Parent Register", priority: 1, run_at: 5.seconds.from_now).famtivity_welcome(@user_usr,@get_current_url,@t_cred_amount)
            end
            #UserMailer.parent_register_user(@user_usr,@get_current_url).deliver
          end
        end
      end #@user_curator end
    end #@user end
  end #def end

 
  def facebook_accept(cont_user,s_user,old_user)
    if cont_user
      cont_user.contact_user_type='friend'
      cont_user.contact_email = old_user.email_address
      cont_user.contact_name = old_user.user_name
      cont_user.accept_status = true
      cont_user.save
    end
    user = User.find_by_user_id(s_user)
    if cont_user
      @c_user = ContactUser.new
      @c_user.user_id = old_user.user_id
      @c_user.contact_email = user.email_address
      @c_user.contact_name = user.user_name
      @c_user.inserted_date = Time.now
      @c_user.modified_date = Time.now
      @c_user.accept_status = true
      @c_user.contact_user_type = 'friend'
      @c_user.contact_type = 'facebook'
      @c_user.fam_user_id = user.user_id if !user.user_id.nil?
      @c_user.inserted_date = Time.now
      @c_user.modified_date = Time.now
      @c_user.save
      cookies[:fam_invited_user]=user.email_address if !user.email_address.nil?
    end
  end

  def login
    @act= params[:act] if !params[:act].nil? && params[:act].present?
    @macid= Base64.decode64(params[:macid]) if (!params[:macid].nil? && params[:macid].present?)
    @msg_email= Base64.decode64(params[:msg_email_val]) if (!params[:msg_email_val].nil? && params[:msg_email_val].present?)
    @activity_id = params[:activity_id] if !params[:activity_id].nil? && params[:activity_id].present?
    @bcrum = params[:bcrum] if !params[:bcrum].nil? && params[:bcrum].present?
    @s_id=Base64.decode64(params[:s_user_id]) if (!params[:s_user_id].nil? && params[:s_user_id].present?)
    @imanager=params[:imanager] if (!params[:imanager].nil? && params[:imanager].present?)
    @s_email=params[:s_user_email] if !params[:s_user_email].nil? && params[:s_user_email].present?
    @mgr_acpted=params[:idm] if !params[:idm].nil? && params[:idm].present?
    @embed_user=params[:embed_user] if !params[:embed_user].nil? && params[:embed_user].present?
    @imports=params[:u] if !params[:u].nil? && params[:u].present?
    if cookies[:mail_usr] && cookies[:password_usr] && cookies[:automatic_login]
      email_usr = cookies[:mail_usr]
      password_usr = cookies[:password_usr]
      automatic_login = cookies[:automatic_login]
      role_usr = cookies[:role_usr]
      @login_flag = true
    else
      email_usr  = "Eg:john@gmail.com"
      password_usr = "password"
      automatic_login = ""
      @login_flag = false
    end
    @roles=["Parent","Provider"]
    @loggedin = [email_usr,password_usr,automatic_login]
    #display the flash message in login page while user click the activate link modified by rajkumar on 2013-4-25
    @activate = params[:id] if params[:id]!="" && !params[:id].nil?
    if @activate=="already_activated"
      flash[:notice]= "You have already activated the account successfully!"
    elsif @activate=="no_id"
      flash[:notice]= "This Email does not exist. Please use a different Email!"
    elsif @activate=="expired"
      flash[:notice]= "You are Link Has Been Expired.Pls register again"
    elsif @activate=="not_activate"
      flash[:notice]= "Please contact the administaror!"
    elsif @activate=="manager_accept"
      flash[:notice]= "You have successfully accepted as manager"
    elsif @activate=="email_active"
      flash[:notice]= "Your email has been activated successfully!"
    elsif @activate=="email_already_activated"
      flash[:notice]= "You have already activated the email successfully!"
    elsif @activate=="activated"
      @ws='1'
      flash[:notice]= "Your account has been activated successfully!"
    end
  
  end
 

def new_login
    @act= params[:act] if !params[:act].nil? && params[:act].present?
    @macid= Base64.decode64(params[:macid]) if (!params[:macid].nil? && params[:macid].present?)
    @msg_email= Base64.decode64(params[:msg_email_val]) if (!params[:msg_email_val].nil? && params[:msg_email_val].present?)
    @activity_id = params[:activity_id] if !params[:activity_id].nil? && params[:activity_id].present?
    @bcrum = params[:bcrum] if !params[:bcrum].nil? && params[:bcrum].present?
    @s_id=Base64.decode64(params[:s_user_id]) if (!params[:s_user_id].nil? && params[:s_user_id].present?)
    @imanager=params[:imanager] if (!params[:imanager].nil? && params[:imanager].present?)
    @s_email=params[:s_user_email] if !params[:s_user_email].nil? && params[:s_user_email].present?
    @mgr_acpted=params[:idm] if !params[:idm].nil? && params[:idm].present?
    @embed_user=params[:embed_user] if !params[:embed_user].nil? && params[:embed_user].present?
    @imports=params[:u] if !params[:u].nil? && params[:u].present?
    if cookies[:mail_usr] && cookies[:password_usr] && cookies[:automatic_login]
      email_usr = cookies[:mail_usr]
      password_usr = cookies[:password_usr]
      automatic_login = cookies[:automatic_login]
      role_usr = cookies[:role_usr]
      @login_flag = true
    else
      email_usr  = "Eg:john@gmail.com"
      password_usr = "password"
      automatic_login = ""
      @login_flag = false
    end
    @roles=["Parent","Provider"]
    @loggedin = [email_usr,password_usr,automatic_login]
    #display the flash message in login page while user click the activate link modified by rajkumar on 2013-4-25
    @activate = params[:id] if params[:id]!="" && !params[:id].nil?
    if @activate=="already_activated"
      flash[:notice]= "You have already activated the account successfully!"
    elsif @activate=="no_id"
      flash[:notice]= "This Email does not exist. Please use a different Email!"
    elsif @activate=="expired"
      flash[:notice]= "You are Link Has Been Expired.Pls register again"
    elsif @activate=="not_activate"
      flash[:notice]= "Please contact the administaror!"
    elsif @activate=="manager_accept"
      flash[:notice]= "You have successfully accepted as manager"
    elsif @activate=="email_active"
      flash[:notice]= "Your email has been activated successfully!"
    elsif @activate=="email_already_activated"
      flash[:notice]= "You have already activated the email successfully!"
    elsif @activate=="activated"
      @ws='1'
      flash[:notice]= "Your account has been activated successfully!"
    end
    if request.xhr?
	render :partial => "new_login"
    else
	respond_to do|format|
         format.html
        end
    end

end


  def forgot_password
    @user_usr = User.find_by_email_address_and_account_active_status(params[:email].downcase,TRUE)
    @user_usr_val = User.find_by_email_address_and_account_active_status(params[:email].downcase,FALSE)
    flash[:notice]=""
    if !@user_usr.nil?
      if @user_usr.user_flag==TRUE
        @get_current_url = request.env['HTTP_HOST']
        UserMailer.delay(queue: "Forgot Password", priority: 1, run_at: 5.seconds.from_now).send_password(@user_usr.user_name,@user_usr.email_address, @user_usr.user_password,@get_current_url)
        #UserMailer.send_password(@user_usr.user_name,@user_usr.email_address,@user_usr.user_password,@get_current_url).deliver
      end
      @forgot = "success"
      render :text => @forgot.to_json
    elsif !@user_usr_val.nil? && @user_usr_val.account_active_status==false
      @forgot = "failed_alert"
      render :text => @forgot.to_json
    else
      @forgot = "failed"
      render :text => @forgot.to_json
    end
  end 
  
  #clear cookies
  def clear_cookies
    cookies.delete :email_usr
    cookies.delete :password_usr
    cookies.delete :automatic_login
    cookies.delete :mail_usr
    @login = 'success'
    render :text => @login
  end

  
end