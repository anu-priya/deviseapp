class ParentSettingsController < ApplicationController
  layout nil
  layout 'landing_layout', :except => :parent_edit_profile
  
  def change_password
	  @click_mode = params[:mode]  if !params[:mode].nil?
	  if @click_mode.nil?
		  render :layout => 'provider_layout'
	  end
  end
  
  def update_userpassword
    @user_details = current_user
    @get_current_url = request.env['HTTP_HOST']    
    if current_user.user_password== Base64.encode64("#{params[:user_password]}")
      if params[:new_pass] == params[:confirm_pass]
        @password = params[:new_pass]
        if @user_details.user_password !=  Base64.encode64("#{@password}") && !@password.nil? && @password !=""
          @user_details.update_attributes(:user_password=> Base64.encode64("#{@password}")) if @password.present?
          @provider_change_password = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='11' and p.user_id='#{current_user.user_id}' and p.notify_flag=true") if !current_user.nil? && !current_user.user_id.nil?
          if @provider_change_password.present? && @provider_change_password!="" && !@provider_change_password.nil?
            #sending a nofification while status changed
            user_email_id=current_user.email_address if !current_user.email_address.nil? &&  !current_user.nil? && current_user.user_flag==TRUE
            @result = UserMailer.delay(queue: "Update Password", priority: 2, run_at: 10.seconds.from_now).change_password_mail(current_user,@get_current_url,params[:message],user_email_id,params[:subject])
            #@result = UserMailer.change_password_mail(current_user,@get_current_url,params[:message],user_email_id,params[:subject]).deliver
          else
            #sending a nofification while status changed
            user_email_id=current_user.email_address if !current_user.email_address.nil? &&  !current_user.nil? && current_user.user_flag==TRUE
            @result = UserMailer.delay(queue: "Update Password", priority: 2, run_at: 10.seconds.from_now).change_password_mail(current_user,@get_current_url,params[:message],user_email_id,params[:subject])
    end #setting if end
	   respond_to do |format|
			format.js
            end #response do end
        end #third if 
      end#if seconde
    end#first if
  end #update end
  
  def parent_profile
    @pro = params[:pro]
    @user_profile = current_user.user_profile
    @user_category = ActivityRow.where('user_id = ?', current_user.user_id)
    @user =User.find_by_user_id(current_user.user_id)
    @participants = Participant.where('user_id = ?', current_user.user_id)
    @agerangecolors = UserChild.where('user_id = ?', current_user.user_id)
  end
  
  def parent_edit_profile
    @agerangecolors = UserChild.where('user_id = ?', current_user.user_id)
    @user_profile = UserProfile.where('user_id = ?', current_user.user_id)
    if !@user_profile.nil?
      @users = UserProfile.create(:user_id=> current_user.user_id,:inserted_date =>Time.now, :modified_date => Time.now )
      @user_profile = UserProfile.where('user_id = ?', current_user.user_id)
    end
  end

  def parent_update_profile 
    @agerangecolors = UserChild.where('user_id = ?', current_user.user_id)
    if current_user.participant
      @part_count = current_user.participant.length
    else 
      @part_count == "0"
    end
    @user =User.find_by_user_id(current_user.user_id)
    if !params[:city_edit_profile].nil? && params[:city_edit_profile]!=""
      city_se = City.where("city_name='#{params[:city_edit_profile]}'").last
      if !city_se.nil?
        @user.latitude  = city_se.latitude
        @user.longitude  = city_se.longitude
      end
    end
    #update the contact name for parent profile#
    if params[:contact_name] == "Enter Contact Name"
        @user.user_name = ""
    else
        @user.user_name = params[:contact_name]
    end
  #update the contact name for parent profile#
    @user.save
    @user_profile = current_user.user_profile
    # @participants = current_user.participant
    current_user.participant =  Participant.where('user_id = ?', current_user.user_id)
    if params[:photo] !=""
      @user_profile.update_attributes(:user_photo =>params[:profile_photo])
    end
    if @user   
      dob = "#{params[:"year_profile_1"]}-#{params[:"month_edit"]}-#{params[:"day_edit"]}"
      @user_profile.dob = dob
      @user_profile.business_language = params[:language_edit] if params[:language_edit] != "Select"
      if !params[:profile_contact_1].nil? && params[:profile_contact_1].present? && !params[:profile_contact_2].nil? && params[:profile_contact_2].present? &&!params[:profile_contact_3].nil? && params[:profile_contact_3].present?
        @mobile_value = "#{params[:profile_contact_1]}-" +"#{params[:profile_contact_2]}-"+"#{params[:profile_contact_3]}"
        if @mobile_value == "xxx-xxx-xxxx"
          @user_profile.mobile =""
        else
          @user_profile.mobile = @mobile_value
        end
      end
      if params[:profile_web] == "Enter The URL Of Your Website"
        @user_profile.website = ""
      else
        @user_profile.website = params[:profile_web] 
      end
      if params[:profile_Add1] == "Enter Your Address"
        @user_profile.address_1 = ""
      else
        @user_profile.address_1 = params[:profile_Add1]
      end
      if params[:profile_Add2] == "Enter Your Address"
        @user_profile.address_2 = ""
      else
        @user_profile.address_2 = params[:profile_Add2]
      end
      if params[:profile_zipcode] == "Enter zip code"
        @user_profile.zip_code = ""
      else
        @user_profile.zip_code = params[:profile_zipcode]
      end
      @user_profile.first_name = params[:profile_first_name] if params[:admin_first_name] != "First Name"
      @user_profile.last_name = params[:profile_last_name]   if params[:admin_last_name] != "Last Name"
      @user_profile.gender = params[:gender_edit]         if params[:gender_edit] != "Select"    
      @user_profile.time_zone = params[:Time_zone_edit]    if params[:Time_zone_edit] != "Select"
      @user_profile.city     = params[:city_edit_profile]  if params[:city_edit_profile] != "Enter City"
      @user_profile.state = params[:state_edit_profile]
      @user_profile.country = params[:country_edit_profile]
      @user_profile.save   

      participantss = Participant.find(:all, :conditions => ["user_id = ?", current_user.user_id])

      if params[:back]!="back"
        @pro_det_id =[]
        pro_count = params[:pro_count].split(",")
        if pro_count.length >=1
          pro_count.each do|s|
            if s!="" && !s.nil?
              @old_participant =UserChild.find_by_age_range_and_user_id(params[:"age_edit_arr_#{s}"], current_user.user_id)
              if !@old_participant
                if @agerangecolors.length < 7
                  @agerange = UserChild.new
                  @agerange.age_range = params[:"age_edit_arr_#{s}"]
                  @agerange.color = params[:"color_arr_#{s}"]
                  @agerange.user_id = cookies[:uid_usr]
                  @agerange.save
                end
              else
                @old_participant.update_attributes(:color => params[:"color_arr_#{s}"])
              end
            end
          end
        end
      end

      if !current_user.participant.blank?
        ids = params[:total_value].split(",")
        i = 0
        
        ids.each do |id|
          a = i += 1
          s = id.gsub("[","").gsub("]","")
          @participant =Participant.find_by_participant_id(s)
          if @participant
            if !params[:"photo_#{@participant.participant_id}"].nil? && params[:"photo_#{@participant.participant_id}"] != "" && params[:"photo_#{@participant.participant_id}"].present?
              @participant.update_attributes(:participant => params[:"photo_#{@participant.participant_id}"])
            end
          
            @participant.update_attributes(:participant_birth_date => params[:"dateFormate_#{a}"], :participant_age => params[:"age_#{@participant.participant_id}"], :participant_gender => params[:"pnn_#{@participant.participant_id}"], :participant_name => params[:"name_#{@participant.participant_id}"])
          end
        end
      end

      part_count = params[:part_count].split(",")
      if part_count.length >= 1
        part_count.each do|s|
          if s!="" && !s.nil?
            @participant = Participant.new
            @participant.participant_name = params[:"participant_name_#{s}"]
            @participant.participant_gender = params[:"gender_#{s}"]
            @participant.participant_age = params[:"age_#{s}"]
            @participant.participant_birth_date = params[:"dateFormate_#{s}"]
            @participant.participant= params[:"photo_#{s}"]
            @participant.user_id = cookies[:uid_usr]
            @participant.save
          end
        end
      else
        a = current_user.participant.count+1 if !current_user.participant.nil?
        params[:part_count] ="" && params[:participant_name_a]!="" && !params[:participant_name_a].nil?
        @participant = Participant.new
        @participant.participant_name = params[:"participant_name_#{a}"]
        @participant.participant_gender = params[:"gender_#{a}"]
        @participant.participant_age = params[:"age_#{a}"]
        @participant.participant_birth_date = params[:"dateFormate_#{a}"]
        @participant.participant= params[:"photo_#{a}"]
        @participant.user_id = cookies[:uid_usr]
        @participant.save
      end
      redirect_to( :action =>"parent_profile")
    else
      render :action =>"parent_update_profile"
    end
  end

  def participant_destroy
    @participant = Participant.find(params[:id])
    @participant.destroy
    respond_to do |format|
      format.js { render :nothing => true }
    end
  end
  
 def parent_settings
    #fetching parent setting details
    #~ @setting_name=ParentSettingDetail.find(:all, :order=>"parent_setting_id asc")
    #ParentNotificationDetail fetched   
    #~ @parent_notify = ParentNotificationDetail.find(:all, :conditions=>["notify_type=? and notify_status = ?","parent","active"], :order =>"parent_notify_id asc")
    @fam_net_notify = ParentNotificationDetail.find(:all, :conditions=>["notify_type=? and notify_status = ?","fam_network","active"], :order =>"parent_notify_id asc")
    #~ @social=SocialType.find(:all, :order=>"social_id asc")
    #~ @contact=User.find_by_sql("select user_id,user_name,email_address from users where email_address in (select contact_email from contact_users where user_id=#{current_user.user_id})").uniq if current_user.present?
    #~ @activity_settings = ParentSetting.order("parent_setting_id asc").where("user_id = ?", current_user.user_id) if current_user.present?
    #~ @check_notify_parent = ParentNotification.order("parent_notify_id asc").where("user_id = ? and notify_type = ?", current_user.user_id, "parent") if current_user.present?
    @check_notify_fam = ParentNotification.order("parent_notify_id asc").where("user_id = ? and notify_type = ?", current_user.user_id, "fam_network") if current_user.present?
    @user_profile = current_user.user_profile if current_user && current_user.present?
  end
  
  def create_parent_settings
    #get the total count for displaying the record.
    @setting_details_count = params[:setting_detail_count] if params[:setting_detail_count]!=""
    @flag = []
    if current_user!="" && current_user.present?
      #storing the values in parent setting table.
      #~ (1..@setting_details_count.to_i).each { |s|
        #~ @setting_option=""
        #~ @setting_option = params["visible_to_#{s}"] if params["visible_to_#{s}"] && params["visible_to_#{s}"]!="" && params["visible_to_#{s}"]!=nil
        #~ @parent_setting_id=""
        #~ @parent_setting_id = params["type_id_#{s}"] if params["type_id_#{s}"] && params["type_id_#{s}"]!="" && params["type_id_#{s}"]!=nil
        #~ @social_id=""
        #~ @social_id=params["social_id_#{s}"]  if params["social_id_#{s}"] && params["social_id_#{s}"]!="" && params["social_id_#{s}"]!=nil
        #~ @contact_user=""
        #~ @contact_user = params["contact_id_#{s}"] if params["contact_id_#{s}"] && params["contact_id_#{s}"]!="" && params["contact_id_#{s}"]!=nil
  
        #~ if current_user.present? && current_user!="" && params["setting_detail#{s}"]!="" && params["setting_detail#{s}"]!=nil
          #~ @settings=ParentSetting.find_by_parent_setting_id_and_user_id("#{params["setting_detail#{s}"]}", "#{current_user.user_id}") if params["setting_detail#{s}"] !="" && current_user.user_id!=""
          #~ if @settings
            #~ if (@setting_option !="" && @setting_option !="" && @parent_setting_id!=nil && @parent_setting_id !=nil && !@setting_option.nil? && !@parent_setting_id.nil?) || (!@social_id.nil? && @social_id!="")
              #~ #@flag = true
	         #~ if (@setting_option !="" && @setting_option !="" && @setting_option=="2" && !@setting_option.nil? && (@contact_user.nil? || @contact_user.empty?))
	           #~ @flag << false
		 #~ else
		   #~ @flag << true
		 #~ end
            #~ end
            #~ #updatating the record if not present
            #~ @settings.update_attributes(:setting_option=> @setting_option, :social_id=>@social_id, :contact_user=>@contact_user)
          #~ else
            #~ #creating the record.
	    #~ if (@setting_option !="" && @setting_option !="" && @setting_option=="2" && !@setting_option.nil? && (@contact_user.nil? || @contact_user.empty?))
	           #~ @flag << false
	    #~ else
		   #~ @flag << true
	    #~ end
            #~ @activity_settings = ParentSetting.create(:parent_setting_id=>params["setting_detail#{s}"], :user_id=>current_user.user_id, :setting_option=>@setting_option, :contact_user=>@contact_user, :inserted_date=>Time.now, :social_id=>@social_id, :modified_date=>Time.now)
          #~ end
        #~ end
      #~ } #loopend
      
      #storing the values in parent notification table.
      #~ @count_parent_notify = params[:count_parent_notify] if params[:count_parent_notify]!=""
      #~ @notify_parent_notify_type = params[:parent_detail]
      #~ (1..@count_parent_notify.to_i).each { |s|
        #~ if params["notify_parent#{s}"]
    	     #~ check_for_notification = UserProfile.chkFlagNotification(params["notify_parent#{s}"],params["email_chk_parent#{s}"],params["sms_chk_parent#{s}"])
	     #~ #@flag = check_for_notification[0]
	     #~ notify_email = check_for_notification[0]
	     #~ notify_sms = check_for_notification[1]
          #~ @user_notify_parent=ParentNotification.find_by_parent_notify_id_and_user_id("#{params["notify_parent#{s}"]}", "#{current_user.user_id}") if params["notify_parent#{s}"]!="" && !params["notify_parent#{s}"].nil? && !current_user.nil?
          #~ if @user_notify_parent
            #~ @user_notify_parent.update_attributes(:parent_notify_id=>params["notify_parent#{s}"], :notify_flag=>notify_email, :notify_type=>@notify_parent_notify_type,:notify_by_sms=>notify_sms) if !@user_notify_parent.nil?
          #~ else
            #~ @user_notify_parent_detail = ParentNotification.create(:user_id => current_user.user_id, :parent_notify_id =>params["notify_parent#{s}"], :notify_flag=>notify_email, :notify_type=>@notify_parent_notify_type, :inserted_date =>Time.now, :modified_date =>Time.now,:notify_by_sms=>notify_sms)
          #~ end
        #~ end
      #~ } #loop end
      
    #storing the fam_network notification values in provider notification table.
      @count_fam_default_notify = params[:count_fam_notify] if params[:count_fam_notify]!=""
      @provider_fam_notify_type = params[:fam_detail]
      (1..@count_fam_default_notify.to_i).each { |s|
        if params["notify_famnet#{s}"]
    	     check_for_notification = UserProfile.chkFlagNotification(params["notify_famnet#{s}"],params["email_chk_fam#{s}"],params["sms_chk_fam#{s}"])
	     #~ @flag = check_for_notification[0]
	     notify_email = check_for_notification[0]
	     notify_sms = check_for_notification[1]
          @provider_notify_default=ParentNotification.find_by_parent_notify_id_and_user_id("#{params["notify_famnet#{s}"]}", "#{current_user.user_id}") if params["notify_famnet#{s}"]!="" && !params["notify_famnet#{s}"].nil? && !current_user.nil?
          if @provider_notify_default
            @provider_notify_default.update_attributes(:parent_notify_id=>params["notify_famnet#{s}"], :notify_flag=>notify_email, :notify_type=>@provider_fam_notify_type,:notify_by_sms=>notify_sms) if !@provider_notify_default.nil?
          else
            @provider_notify_default_detail = ParentNotification.create(:user_id => current_user.user_id, :parent_notify_id =>params["notify_famnet#{s}"], :notify_flag=>notify_email, :notify_type=>@provider_fam_notify_type, :inserted_date =>Time.now, :modified_date =>Time.now,:notify_by_sms=>notify_sms)
          end
        end
      } #loop end
    
      if @flag && @flag.include?(false)
	#failer response
	message = 'Please select at least one contact to proceed.'
      else
          #successful response
	message = 'Your settings have been successfully saved!'
     end #flag end

        respond_to do |format|
          #format.js{render :text => "$('.success_setting_info').css('display', 'block').fadeOut(5000);"}
          format.js{render :text => 
           "$('html, body').animate({ scrollTop: 0 });
            $('.flash-message').html('Your settings have been successfully saved!');
            var win=$(window).width();
            var con=$('.flash_content').width();
            var leftvalue=((win/2)-(con/2))
            $('.flash_content').css('left',leftvalue+'px');
            $('.flash_content').css('top','67px');
            $('.flash_content').fadeIn().delay(5000).fadeOut();"
            }
        end

    end#first if loop end

  end #create_parent_setting end
end
