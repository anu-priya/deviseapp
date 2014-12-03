class UserProfilesController < ApplicationController
  before_filter :authenticate_user, :except=>[:email_activate, :fetch_city,:user_tags]
  # GET /user_profiles
  # GET /user_profiles.json
  include ActionView::Helpers::NumberHelper
  require 'active_merchant'

  #user account delete method while delete the account by rajkumar
  def user_account_delete
    @get_current_url = request.env['HTTP_HOST']
    @user = User.find(params[:user_id]) if !params[:user_id].nil? && params[:user_id]!=""
    @ubname = ((@user && @user.user_profile && @user.user_profile.business_name) ? (@user.user_profile.business_name) : (@user.user_name if @user && @user.user_name))
    @usr_delted = UserDeletedAccount.deleted_user_info(@user,@ubname) if @user && @ubname
    #send a mail to the user while delete the account
    #~ if @user && @user.present?
		#~ @user.update_attributes(:user_plan=>"curator", :user_password=>"info@2014", :manage_plan=>nil, :downgrade_plan=>nil)
		#~ @user_mail = UserMailer.delay(queue: "User Account Delete", priority: 1, run_at: 5.seconds.from_now).user_account_deleted(@user)
		#~ @user_mail1 = UserMailer.delay(queue: "User Account Delete Admin", priority: 1, run_at: 5.seconds.from_now).user_account_deleted_admin(@user)
    #~ end
    #delete the user associated information from famtivity database
    #~ @uinfo = User.delete_user_details(@user) if !@user.nil?
    if @usr_delted && !@usr_delted.nil? && @usr_delted!=""
      @contact_users=ContactUser.find_all_by_contact_email(@user.email_address) if !@user.email_address.nil? && @user.email_address !=""
      @contact_users.each do |con|
        con.update_attributes(:contact_user_type=>"non_member",:fam_user_id=>nil)
      end
      @con_group=ContactUserGroup.find_all_by_user_id(params[:user_id]) if !params[:user_id].nil? && params[:user_id]!=""
      @con_group.each do |con|
        con.update_attributes(:fam_accept_status=>false)
      end
      @fam_net=FamNetworkRow.find_all_by_user_id(params[:user_id]) if !params[:user_id].nil? && params[:user_id]!=""
      @fam_net.each do |fam|
        fam.destroy 
      end
      @user.destroy if @user
    end
    respond_to do |format|
      format.js { render :text => "$('#delete_account_feature').hide();$('#loading_img_delete').hide();$('#user_deleted').bPopup({fadeSpeed:100,followSpeed:100,opacity:0.8,position: [241, 100],positionStyle: 'absolute',modalClose: false});" }
    end
  end

  #user account delete method while deactivate the account by rajkumar
  def user_account_deactivate
    @get_current_url = request.env['HTTP_HOST']
    @to = current_user.email_address
    @user = User.find(params[:user_id]) if !params[:user_id].nil? && params[:user_id]!=""
    @user_status = params[:user_status] if !params[:user_status].nil? && params[:user_status]!=""
	if @user
		#for deactivate and activate the user account
		if !@user_status.nil? && @user_status=="deactivate"
			@astatus = @user.update_attributes(:user_status=>@user_status, :show_card=>true)
			
			#store the user deactivate details in user deactivate log table
				UserDeactivateLog.log_user_details(@user.user_id,@user.email_address,@user_status) if @user && @user_status
			#store the user deactivate details in user deactivate log table ending
			
			#update the activities status as deactivate
			@act_all = Activity.where("user_id = ? and lower(active_status) = ?",params[:user_id],"active") if !params[:user_id].nil? && params[:user_id]!=""
			!@act_all.nil? && @act_all.present? && @act_all.each do |act|
				act.update_attributes(:active_status=>@user_status)
			end
			#~ if !@act_all.nil? && @act_all.present?
				#~ @act_all.update_all(:active_status=>@user_status)
			#~ end               
				#sent a mail to provider about deactivate
				UserMailer.delay(queue: "Deactivate account", priority: 1, run_at: 5.seconds.from_now).user_account_deactivated(@user) if @user
		elsif !@user_status.nil? && @user_status=="activate"
				#store the user deactivate details in user deactivate log table
				UserDeactivateLog.log_user_details(@user.user_id,@user.email_address,@user_status) if @user && @user_status
				#store the user deactivate details in user deactivate log table ending
				
				#==========update the user status as activate===============#				
				pro_transvl= ProviderTransaction.where("user_id=?",@user.user_id).last if !@user.nil?	
				if !pro_transvl.nil? && pro_transvl.present? && !pro_transvl.end_date.nil? && pro_transvl.end_date.strftime("%Y-%m-%d") < Time.now.strftime("%Y-%m-%d")
					#response status
					@astatus = @rstatus = current_account_activate(@user,"activate",'account') if !@user.nil?
				elsif !pro_transvl.nil? && pro_transvl.present? && !pro_transvl.end_date.nil? && pro_transvl.end_date.strftime("%Y-%m-%d") >= Time.now.strftime("%Y-%m-%d")
					@astatus = @user.update_attributes(:user_status=>@user_status, :manage_plan=>"market_sell", :show_card=>true)
					@act_all = Activity.where("user_id = ? and lower(active_status) = ?",params[:user_id],"deactivate") if !params[:user_id].nil? && params[:user_id]!=""
					#~ if !@act_all.nil? && @act_all.present?						
						#~ @act_all.update_all(:active_status=>"Active")						
					#~ end 
					!@act_all.nil? && @act_all.present? && @act_all.each do |act|					
						act.update_attributes(:active_status=>"Active")						
					end 
					#response status
					@rstatus = true
				end	      
		end #user status condition ending here
	end
	
    #memcache resetting here
    if @astatus && @astatus==true
	$dc.set("provider_activity_for#{current_user.user_id}",nil) if current_user.present?
    end
    
    respond_to do |format|
	format.js
	end
  end #user account deactivate ending here,

  def change_email #change email_popup
    @u_type=params[:u_type] if !params[:u_type].nil?
  end

  def plan_success_message #change email_popup
    @act=params[:act] if !params[:act].nil?
  end
  def change_email_address #change email function
    if !params[:u_type].nil? && params[:u_type].present?
      @u_type=params[:u_type] 
    else
      @u_type="provider"
    end
    @get_current_url = request.env['HTTP_HOST']
    @user = User.find_by_user_id(current_user.user_id)
    @user.update_attributes(:new_email_address => params[:email].downcase, :email_status=>false)
    UserMailer.delay(queue: "Change Email Activate", priority: 1, run_at: 5.seconds.from_now).change_email_address(@user,@get_current_url,@u_type)
    respond_to do |format|
      format.js {render :text => "$('#messageSuccess').bPopup({fadeSpeed:100,followSpeed:100,opacity:0.8,positionStyle: 'absolute',modalClose: false});$('#loading').css('display','none');"}
    end
  end

  def email_activate #new email_activation
    @uid = Base64.decode64(params[:uid]) if (!params[:uid].nil? && params[:uid].present?)
    @u_type = Base64.decode64(params[:utype]) if (!params[:utype].nil? && params[:utype].present?)
    @user = User.find_by_user_id(@uid)
    if !@user.nil? && @user.present? && @user.email_status==false #email_status start
      @act = Activity.where('user_id = ?', @uid) if (!@uid.nil? && @uid.present?)
      @act.each do |ac|
        if (ac.email==@user.email_address)
          ac.update_attributes(:email => @user.new_email_address.downcase)  #change in activity table
        end
      end
      @act_attend = ActivityAttendDetail.where('user_id = ?', @uid) if (!@uid.nil? && @uid.present?)
      @act_attend.each do |ac|
        if (ac.attendies_email==@user.email_address)
          ac.update_attributes(:attendies_email => @user.new_email_address.downcase) #change in activity_attend table
        end
      end
      @chang_mail=UserEmailChangeLog.create(:user_id=>@uid, :email_from =>@user.email_address.downcase, :email_to=>@user.new_email_address.downcase, :email_updated_date=>Time.now) if !@uid.nil? 
      @old_email=@user.email_address
      @user.email_address=@user.new_email_address
      @user.new_email_address=""
      @user.email_status=true
      @user.save
      UserMailer.delay(queue: "Change Email Success", priority: 1, run_at: 10.seconds.from_now).change_email_success(@user,@get_current_url,@old_email,@u_type)
      if !current_user.nil? && current_user.present?
        redirect_to :controller=>'landing',:action=>'landing_new', :s_out=>'sign_out'
      else
        redirect_to :controller=>'landing',:action=>'landing_new', :u=>'email_active'
      end
    else
      redirect_to :controller=>'landing',:action=>'landing_new', :u=>'email_already_activated'
    end #email_status end
  end #def 

  def index
    @user_profiles = UserProfile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_profiles }
    end
  end

  def parent_edit_profile
    # @participants = Participant.where('user_id = ?', current_user.user_id)
    @agerangecolors = UserChild.where('user_id = ?', current_user.user_id)
    @user_profile = UserProfile.where('user_id = ?', current_user.user_id)
    if !@user_profile.nil?
      @users = UserProfile.create(:user_id=> current_user.user_id,:inserted_date =>Time.now, :modified_date => Time.now )
      @user_profile = UserProfile.where('user_id = ?', current_user.user_id)
    end
  end
  
  def provider_edit_profile
    @user_profile = current_user.user_profile
    @user = User.find_by_user_id(current_user.user_id)
    @tags_text = @user_profile.tags_txt.split(",") if !@user_profile.nil? && !@user_profile.tags_txt.nil?
  end
  
  #Autocomplete tags data populate
  def user_tags
    @user_profile = current_user.user_profile if !current_user.nil?
    @tags_text = @user_profile.tags_txt.split(",") if !@user_profile.nil? && !@user_profile.tags_txt.nil?
    @default_tags = GeneralTag.all
    @arr = []
    params[:term] = params[:term].blank? ? "" : params[:term]
    !@tags_text.blank? && @tags_text.each do |tag|
      if(!params[:term].blank? && !tag.downcase.scan(params[:term].downcase).blank?)
        @arr << {"id" => @user_profile.profile_id,"label" => tag,"value" => tag}
      end
    end
    !@default_tags.blank? && @default_tags.each do |tag|
      if(!params[:term].blank? && !tag.tag_name.downcase.scan(params[:term].downcase).blank?)
        @arr << {"id" => tag.tag_id,"label" => tag.tag_name,"value" => tag.tag_name}
      end
    end
    render :json => @arr
  end
  
  #Autocomplete city data populate
  def fetch_city
    @state_value = params[:state_value].blank? ? false : true
    @city_arr = []
    if(@state_value)
      @cities = City.where("state_id = 1 and country_id = 1").order("city_name Asc")
    else
      @cities = City.order("city_name Asc")
    end
    !@cities.blank? && @cities.each do |city|
      if(!params[:term].blank? && !city.city_name.downcase.scan(params[:term].downcase).blank?)
        @city_arr << {"id" => city.city_id,"label" => city.city_name,"value" => city.city_name}
      end
    end
    render :json => @city_arr
  end

  #this method is old one
  def parent_settings_new
    @get_current_url = request.env['HTTP_HOST']
     
    # parent setting page started by rajkumar
    @setting_name=ActivitySettingsDetail.find(:all, :conditions => ["user_type = ? or user_type = ?", "U", "UP"], :order=>"info_id asc")
    @s_type=ActivitySettingsType.all
    @social=SocialType.find(:all, :order=>"social_id asc")
    @contact=ContactUser.find_all_by_user_id(current_user.user_id).uniq
    @activity_settings = ActivitySetting.order("info_id asc").where("user_id = ? and user_type = ?", current_user.user_id, "parent") if current_user.present?

  end
  
  def parent_settings
    #fetching parent setting details
    @setting_name=ParentSettingDetail.find(:all, :order=>"parent_setting_id asc")
    #ParentNotificationDetail fetched   
    @parent_notify = ParentNotificationDetail.find(:all, :conditions=>["notify_type=? and notify_status = ?","parent","active"], :order =>"parent_notify_id asc")
    @fam_net_notify = ParentNotificationDetail.find(:all, :conditions=>["notify_type=? and notify_status = ?","fam_network","active"], :order =>"parent_notify_id asc")
    @social=SocialType.find(:all, :order=>"social_id asc")
    @contact=User.find_by_sql("select user_id,user_name,email_address from users where email_address in (select contact_email from contact_users where user_id=#{current_user.user_id})").uniq if current_user.present?
    @activity_settings = ParentSetting.order("parent_setting_id asc").where("user_id = ?", current_user.user_id) if current_user.present?
    @check_notify_parent = ParentNotification.order("parent_notify_id asc").where("user_id = ? and notify_type = ?", current_user.user_id, "parent") if current_user.present?
    @check_notify_fam = ParentNotification.order("parent_notify_id asc").where("user_id = ? and notify_type = ?", current_user.user_id, "fam_network") if current_user.present?
    @user_profile = current_user.user_profile if current_user && current_user.present?
  end
  
  
  def parent_settings_old

  end
  
  #storing the setting values in setting tables.
  def create_setting
    #get the total count for displaying the record.
    @setting_details_count = params[:setting_detail_count] if params[:setting_detail_count]!=""

    if current_user!="" && current_user.present?
      (1..@setting_details_count.to_i).each { |s|

        @type_id=""
        @type_id = params["visible_to_#{s}"] if params["visible_to_#{s}"] && params["visible_to_#{s}"]!="" && params["visible_to_#{s}"]!=nil
        @info_id=""
        @info_id = params["type_id_#{s}"] if params["type_id_#{s}"] && params["type_id_#{s}"]!="" && params["type_id_#{s}"]!=nil
        @social_id=""
        @social_id=params["social_id_#{s}"]  if params["social_id_#{s}"] && params["social_id_#{s}"]!="" && params["social_id_#{s}"]!=nil
        #~ @social_id = @social_values if @social_values!=nil && @social_values!=""
        @contact_user=""
        @contact_user = params["contact_id_#{s}"] if params["contact_id_#{s}"] && params["contact_id_#{s}"]!="" && params["contact_id_#{s}"]!=nil
    
        #hidden field for both user.
        if params[:setting_user]=="provider"
          @user_type="provider"
        else
          @user_type="parent"
        end
  
        if current_user.present? && current_user!="" && params["setting_detail#{s}"]!="" && params["setting_detail#{s}"]!=nil
          @settings=ActivitySetting.find_by_info_id_and_user_id_and_user_type("#{params["setting_detail#{s}"]}", "#{current_user.user_id}", "#{@user_type}") if params["setting_detail#{s}"] !="" && current_user.user_id!=""
          if @settings
            if (@type_id !="" && @info_id !="" && @type_id !=nil && @info_id !=nil && !@type_id.nil? && !@info_id.nil?) || (!@social_id.nil? && @social_id!="")
              @flag = true
            end
            #updatating the record if not present
            @settings.update_attributes(:type_id=>@type_id, :social_id=>@social_id, :contact_user=>@contact_user, :user_type=>@user_type)
          else
            #creating the record.
            @activity_settings = ActivitySetting.create(:info_id=>params["setting_detail#{s}"], :user_id=>current_user.user_id, :type_id=>@type_id, :contact_user=>@contact_user, :user_type =>@user_type, :inserted_date=>Time.now, :social_id=>@social_id, :modified_date=>Time.now)
          end
        end

      } #loopend
  
      if @flag
        #successful response
        respond_to do |format|
          format.js{render :text => "$('.success_setting_info').css('display', 'block').fadeOut(5000);"}
        end
      else
        #failer response
        respond_to do |format|
          format.js{render :text => "$('.success_setting_info_false').css('display', 'block').fadeOut(5000);"}
        end
      end #flag end
  
    end#first if loop end
  
  end

  #storing the setting details for provider by rajkumar dont remove this code
  def create_provider_settings
    #get the total count for displaying the record.
    @setting_details_count = params[:setting_detail_count] if params[:setting_detail_count]!=""
    if current_user!="" && current_user.present?
      #storing the values in parent setting table.
      @flag = []
      (1..@setting_details_count.to_i).each { |s|
        @setting_option=""
        @setting_option = params["visible_to_#{s}"] if params["visible_to_#{s}"] && params["visible_to_#{s}"]!="" && params["visible_to_#{s}"]!=nil
        @provider_setting_id=""
        @provider_setting_id = params["type_id_#{s}"] if params["type_id_#{s}"] && params["type_id_#{s}"]!="" && params["type_id_#{s}"]!=nil
        @social_id=""
        @social_id=params["social_id_#{s}"]  if params["social_id_#{s}"] && params["social_id_#{s}"]!="" && params["social_id_#{s}"]!=nil
        @contact_user=""
        @contact_user = params["contact_id_#{s}"] if params["contact_id_#{s}"] && params["contact_id_#{s}"]!="" && params["contact_id_#{s}"]!=nil
  
        if current_user.present? && current_user!="" && params["setting_detail#{s}"]!="" && params["setting_detail#{s}"]!=nil
          @settings=ProviderSetting.find_by_provider_setting_id_and_user_id("#{params["setting_detail#{s}"]}", "#{current_user.user_id}") if params["setting_detail#{s}"] !="" && current_user.user_id!=""
          if @settings
            if (@setting_option !="" && @setting_option !="" && @provider_setting_id!=nil && @provider_setting_id !=nil && !@setting_option.nil? && !@provider_setting_id.nil?) || (!@social_id.nil? && @social_id!="")
	        if (@setting_option !="" && @setting_option !="" && @setting_option=="2" && @provider_setting_id!=nil && @provider_setting_id !=nil && @provider_setting_id=="1" && !@setting_option.nil? && !@provider_setting_id.nil? && (@contact_user.nil? || @contact_user.empty?))
	           @flag << false
		else
		   @flag << true
		 end
            end
            #updatating the record if not present
            @settings.update_attributes(:setting_option=> @setting_option, :social_id=>@social_id, :contact_user=>@contact_user)
          else
            #creating the record.
	     if (@setting_option !="" && @setting_option !="" && @setting_option=="2" && @provider_setting_id!=nil && @provider_setting_id !=nil && @provider_setting_id=="1" && !@setting_option.nil? && !@provider_setting_id.nil? && (@contact_user.nil? || @contact_user.empty?))
	           @flag << false
	     else
		   @flag << true
	      end
            @activity_settings = ProviderSetting.create(:provider_setting_id=>params["setting_detail#{s}"], :user_id=>current_user.user_id, :setting_option=>@setting_option, :contact_user=>@contact_user, :inserted_date=>Time.now, :social_id=>@social_id, :modified_date=>Time.now)
          end
        end
      } #loopend
      
      #storing the activity notification values in provider notification table.
      @count_provider_notify = params[:count_provider_notify] if params[:count_provider_notify]!=""
      @notify_provider_notify_type = params[:activity_notify_detail]
      (1..@count_provider_notify.to_i).each { |s|
        if params["notify_parent#{s}"]
	     check_for_notification = UserProfile.chkFlagNotification(params["notify_parent#{s}"],params["email_row_info#{s}"],params["sms_row_info#{s}"])
	     #~ @flag = check_for_notification[0]
	     notify_email = check_for_notification[0]
	     notify_sms = check_for_notification[1]
          @user_notify_parent=ProviderNotification.find_by_provider_notify_id_and_user_id("#{params["notify_parent#{s}"]}", "#{current_user.user_id}") if params["notify_parent#{s}"]!="" && !params["notify_parent#{s}"].nil? && !current_user.nil?
          if @user_notify_parent
            @user_notify_parent.update_attributes(:provider_notify_id=>params["notify_parent#{s}"], :notify_flag=>notify_email, :notify_type=>@notify_provider_notify_type,:notify_by_sms=>notify_sms) if !@user_notify_parent.nil?
          else
            @user_notify_parent_detail = ProviderNotification.create(:user_id => current_user.user_id, :provider_notify_id =>params["notify_parent#{s}"], :notify_flag=>notify_email, :notify_type=>@notify_provider_notify_type, :inserted_date =>Time.now, :modified_date =>Time.now,:notify_by_sms=>notify_sms)
          end
        end
      } #loop end
    
      #storing the provider default notification values in provider notification table.
      @count_provider_default_notify = params[:count_provider_default_notify] if params[:count_provider_default_notify]!=""
      @provider_default_notify_type = params[:provider_default_notify]
      (1..@count_provider_default_notify.to_i).each { |s|
        if params["text_parent#{s}"]
    	     check_for_notification = UserProfile.chkFlagNotification(params["text_parent#{s}"],params["email_chk_parent#{s}"],params["sms_chk_parent#{s}"])
	     #~ @flag = check_for_notification[0]
	     notify_email = check_for_notification[0]
	     notify_sms = check_for_notification[1]
          @provider_notify_default=ProviderNotification.find_by_provider_notify_id_and_user_id("#{params["text_parent#{s}"]}", "#{current_user.user_id}") if params["text_parent#{s}"]!="" && !params["text_parent#{s}"].nil? && !current_user.nil?
          if @provider_notify_default
            @provider_notify_default.update_attributes(:provider_notify_id=>params["text_parent#{s}"], :notify_flag=>notify_email, :notify_type=>@provider_default_notify_type,:notify_by_sms=>notify_sms) if !@provider_notify_default.nil?
          else
            @provider_notify_default_detail = ProviderNotification.create(:user_id => current_user.user_id, :provider_notify_id =>params["text_parent#{s}"], :notify_flag=>notify_email, :notify_type=>@provider_default_notify_type, :inserted_date =>Time.now, :modified_date =>Time.now,:notify_by_sms=>notify_sms)
          end
        end
      } #loop end
    
      if @flag && @flag.include?(false)
       #failer response
        respond_to do |format|
          #format.js{render :text => "$('.success_setting_info_false').css('display', 'block').fadeOut(5000);"}
          format.js{render :text => 
           "$('html, body').animate({ scrollTop: 0 });
            $('.flash-message').html('Please select at least one contact to proceed');
            var win=$(window).width();
            var con=$('.flash_content').width();
            var leftvalue=((win/2)-(con/2))
            $('.flash_content').css('left',leftvalue+'px');
            $('.flash_content').css('top','67px');
            $('.flash_content').fadeIn().delay(5000).fadeOut();"
              }
        end
      else
         #successful response
        respond_to do |format|
          #format.js{render :text => "$('.success_setting_info').css('display', 'block').fadeOut(5000);"} All the changes in settings have been applied successfully
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
      end #flag end

  
    end#first if loop end
  
  end #create provider settings method end

  #this method for storing the parent setting records.
  def create_parent_settings
    #get the total count for displaying the record.
    @setting_details_count = params[:setting_detail_count] if params[:setting_detail_count]!=""
    @flag = []
    if current_user!="" && current_user.present?
      #storing the values in parent setting table.
      (1..@setting_details_count.to_i).each { |s|
        @setting_option=""
        @setting_option = params["visible_to_#{s}"] if params["visible_to_#{s}"] && params["visible_to_#{s}"]!="" && params["visible_to_#{s}"]!=nil
        @parent_setting_id=""
        @parent_setting_id = params["type_id_#{s}"] if params["type_id_#{s}"] && params["type_id_#{s}"]!="" && params["type_id_#{s}"]!=nil
        @social_id=""
        @social_id=params["social_id_#{s}"]  if params["social_id_#{s}"] && params["social_id_#{s}"]!="" && params["social_id_#{s}"]!=nil
        @contact_user=""
        @contact_user = params["contact_id_#{s}"] if params["contact_id_#{s}"] && params["contact_id_#{s}"]!="" && params["contact_id_#{s}"]!=nil
  
        if current_user.present? && current_user!="" && params["setting_detail#{s}"]!="" && params["setting_detail#{s}"]!=nil
          @settings=ParentSetting.find_by_parent_setting_id_and_user_id("#{params["setting_detail#{s}"]}", "#{current_user.user_id}") if params["setting_detail#{s}"] !="" && current_user.user_id!=""
          if @settings
            if (@setting_option !="" && @setting_option !="" && @parent_setting_id!=nil && @parent_setting_id !=nil && !@setting_option.nil? && !@parent_setting_id.nil?) || (!@social_id.nil? && @social_id!="")
              #~ @flag = true
	         if (@setting_option !="" && @setting_option !="" && @setting_option=="2" && !@setting_option.nil? && (@contact_user.nil? || @contact_user.empty?))
	           @flag << false
		 else
		   @flag << true
		 end
            end
            #updatating the record if not present
            @settings.update_attributes(:setting_option=> @setting_option, :social_id=>@social_id, :contact_user=>@contact_user)
          else
            #creating the record.
	    if (@setting_option !="" && @setting_option !="" && @setting_option=="2" && !@setting_option.nil? && (@contact_user.nil? || @contact_user.empty?))
	           @flag << false
	    else
		   @flag << true
	    end
            @activity_settings = ParentSetting.create(:parent_setting_id=>params["setting_detail#{s}"], :user_id=>current_user.user_id, :setting_option=>@setting_option, :contact_user=>@contact_user, :inserted_date=>Time.now, :social_id=>@social_id, :modified_date=>Time.now)
          end
        end
      } #loopend
      
      #storing the values in parent notification table.
      @count_parent_notify = params[:count_parent_notify] if params[:count_parent_notify]!=""
      @notify_parent_notify_type = params[:parent_detail]
      (1..@count_parent_notify.to_i).each { |s|
        if params["notify_parent#{s}"]
    	     check_for_notification = UserProfile.chkFlagNotification(params["notify_parent#{s}"],params["email_chk_parent#{s}"],params["sms_chk_parent#{s}"])
	     #~ @flag = check_for_notification[0]
	     notify_email = check_for_notification[0]
	     notify_sms = check_for_notification[1]
          @user_notify_parent=ParentNotification.find_by_parent_notify_id_and_user_id("#{params["notify_parent#{s}"]}", "#{current_user.user_id}") if params["notify_parent#{s}"]!="" && !params["notify_parent#{s}"].nil? && !current_user.nil?
          if @user_notify_parent
            @user_notify_parent.update_attributes(:parent_notify_id=>params["notify_parent#{s}"], :notify_flag=>notify_email, :notify_type=>@notify_parent_notify_type,:notify_by_sms=>notify_sms) if !@user_notify_parent.nil?
          else
            @user_notify_parent_detail = ParentNotification.create(:user_id => current_user.user_id, :parent_notify_id =>params["notify_parent#{s}"], :notify_flag=>notify_email, :notify_type=>@notify_parent_notify_type, :inserted_date =>Time.now, :modified_date =>Time.now,:notify_by_sms=>notify_sms)
          end
        end
      } #loop end
      
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
        respond_to do |format|
          #format.js{render :text => "$('.success_setting_info_false').css('display', 'block').fadeOut(5000);"}
          format.js{render :text => 
           "$('html, body').animate({ scrollTop: 0 });
            $('.flash-message').html('Please select at least one contact to proceed.');
            var win=$(window).width();
            var con=$('.flash_content').width();
            var leftvalue=((win/2)-(con/2))
            $('.flash_content').css('left',leftvalue+'px');
            $('.flash_content').css('top','67px');
            $('.flash_content').fadeIn().delay(5000).fadeOut();"
              }
	 end
      else
          #successful response
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
        
      end #flag end
  
    end#first if loop end

  end #create_parent_setting end

  def change_password
    @click_mode = params[:mode]  if !params[:mode].nil?
  end

  def update_userpassword
    @user_details = current_user
    params[:user_password]
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
            respond_to do |format|
              #~ format.js{render :text => "$('.success_update_info').css('display', 'block').fadeOut(4000);"}
              format.js{render :text => "$('#cge_pwd_cfm').bPopup({fadeSpeed:100,
		followSpeed:100,
		opacity:0.8,
		positionStyle: 'absolute',
		modalClose: false});"}
            end #response do end
          else
            #sending a nofification while status changed
            user_email_id=current_user.email_address if !current_user.email_address.nil? &&  !current_user.nil? && current_user.user_flag==TRUE
            @result = UserMailer.delay(queue: "Update Password", priority: 2, run_at: 10.seconds.from_now).change_password_mail(current_user,@get_current_url,params[:message],user_email_id,params[:subject])
            respond_to do |format|
              format.js{render :text => "$('#cge_pwd_cfm').bPopup({fadeSpeed:100,
		followSpeed:100,
		opacity:0.8,
		positionStyle: 'absolute',
		modalClose: false});"}
            end #response do end
          end #setting if end
        end #third if 
      end#if seconde
    end#first if
    
  end #update end
  
  #this function called when you blocked the user setting page block form
  def blocked_user
    @b_name=params[:block_name] if params[:block_name]!=""
    @b_email=params[:block_email] if params[:block_email]!=""
    #stored the blocked user details
    if params[:block_name]!="" && params[:block_email]!=""
      @block_user=BlockUser.create(:name=>@b_name, :email=>@b_email, :user_id=>current_user.user_id, :inserted_date=>Time.now, :modified_date=>Time.now)
      respond_to do |format|
        format.js{render :text => "$('.block_user_info').css('display', 'block');"}
      end
    end
  end

  #this method is old one
  def provider_settings_new
    #provider setting started
    @setting_name=ActivitySettingsDetail.find(:all, :conditions => ["user_type = ? or user_type = ?", "P", "UP"], :order=>"info_id asc")
    @s_type=ActivitySettingsType.all
    @social=SocialType.find(:all, :order=>"social_id asc")
    @contact=ContactUser.find_all_by_user_id(current_user.user_id).uniq
    @activity_settings = ActivitySetting.order("info_id asc").where("user_id = ? and user_type = ?", current_user.user_id, "provider") if current_user.present?
  
    #notification details fetched
    @notify_info=NotificationDetail.find(:all, :conditions => ["user_type = ?", "U"], :order=>"notify_id asc")
    @notify_info_provider=NotificationDetail.find(:all, :conditions => ["user_type = ?", "P"], :order=>"notify_id asc")
    @check_notify_provider = UserNotification.order("notify_id asc").where("user_id = ? and user_type = ?", current_user.user_id, "provider") if current_user.present?
    @check_notify_parent = UserNotification.order("notify_id asc").where("user_id = ? and user_type = ?", current_user.user_id, "parent") if current_user.present?
  end
  
  #provider setting new changes
  def provider_settings
    #provider setting started
    @setting_name=ProviderSettingDetail.find(:all, :order=>"provider_setting_id asc")
    #~ @setting_name=ActivitySettingsDetail.find(:all, :conditions => ["user_type = ? or user_type = ?", "P", "UP"], :order=>"info_id asc")
    @s_type=ActivitySettingsType.all
    @social=SocialType.find(:all, :order=>"social_id asc")
    #~ @contact=ContactUser.find_all_by_user_id(current_user.user_id).uniq
    @contact=User.find_by_sql("select user_id,user_name,email_address from users where email_address in (select contact_email from contact_users where user_id=#{current_user.user_id})").uniq if current_user.present?
    @activity_settings = ProviderSetting.order("provider_setting_id asc").where("user_id = ?", current_user.user_id) if current_user.present?
    #notification details fetched
    @notify_info=ProviderNotificationDetail.find(:all, :conditions => ["notify_type = ? and notify_status = ?","activity" ,"active"], :order=>"provider_notify_id asc")
    @notify_info_provider=ProviderNotificationDetail.find(:all, :conditions => ["notify_type = ? and notify_status = ?", "default", "active"], :order=>"provider_notify_id asc")
    #displayed the details
    @check_notify_parent = ProviderNotification.order("provider_notify_id asc").where("user_id = ? and notify_type = ?", current_user.user_id, "activity") if current_user.present?
    @check_notify_provider = ProviderNotification.order("provider_notify_id asc").where("user_id = ? and notify_type = ?", current_user.user_id, "default") if current_user.present?
    @user_profile = current_user.user_profile if current_user && current_user.present?
  end
  
  #parent notification details saved in this method by using ajax call.
  def notification_details
    @count_parent_record = params[:count_parent] if params[:count_parent]!=""
    @notify_parent_user_type = params[:parent_detail]
  
    (1..@count_parent_record.to_i).each { |s|
  
      if current_user.present?
        if params["notify_parent#{s}"]
          if params["notify_parent#{s}"]==params["row_info#{s}"]
            @success_flag=true
            @notify_flag=true
          else
            @notify_flag=false
          end
    
          @user_notify_parent=UserNotification.find_by_notify_id_and_user_id("#{params["notify_parent#{s}"]}", "#{current_user.user_id}") if params["notify_parent#{s}"]!="" && !params["notify_parent#{s}"].nil? && !current_user.nil?
          if @user_notify_parent
            @user_notify_parent.update_attributes(:notify_id=>params["notify_parent#{s}"], :notify_flag=>@notify_flag, :user_type=>@notify_parent_user_type) if !@user_notify_parent.nil?
          else
            @user_notify_parent_detail = UserNotification.create(:user_id => current_user.user_id, :notify_id =>params["notify_parent#{s}"], :notify_flag=>@notify_flag, :user_type=>@notify_parent_user_type, :inserted_date =>Time.now, :modified_date =>Time.now)
          end
        end
      end
  
    } #loop end
  
  
    if @success_flag
      #successful response
      respond_to do |format|
        format.js{render :text => "$('.parent_notify_success').css('display', 'block').fadeOut(3000);"}
      end
    else
      #failer response
      respond_to do |format|
        format.js{render :text => "$('.parent_notify_failer').css('display', 'block').fadeOut(3000);"}
      end
    end #flag end
  
  end #method end
  
  
  #provider notification details stored for provider setting page.
  def notification_details_provider
    @count_provider_record = params[:count_provider] if params[:count_provider]!=""
    @notify_provider_user_type = params[:provider_detail]
    (1..@count_provider_record.to_i).each { |s|
      if current_user.present?
        if params["text_parent#{s}"]
          if params["text_parent#{s}"]==params["chk_parent#{s}"]
            @success_flag=true
            @notify_flag=true
          else
            @notify_flag=false
          end
          @user_notify_provider=UserNotification.find_by_notify_id_and_user_id("#{params["text_parent#{s}"]}", "#{current_user.user_id}") if params["text_parent#{s}"]!="" && !params["text_parent#{s}"].nil? && !current_user.nil?
          if @user_notify_provider
            @user_notify_provider.update_attributes(:notify_id=>params["text_parent#{s}"], :notify_flag=>@notify_flag, :user_type=>@notify_provider_user_type) if !@user_notify_provider.nil?
          else
            @user_notify_provider_detail = UserNotification.create(:user_id => current_user.user_id, :notify_id =>params["text_parent#{s}"], :notify_flag=>@notify_flag, :user_type=>@notify_provider_user_type, :inserted_date =>Time.now, :modified_date =>Time.now)
          end
        end
      end
    } #loop end
  
    if @success_flag
      #successful response
      respond_to do |format|
        format.js{render :text => "$('.provider_notify_success').css('display', 'block').fadeOut(3000);"}
      end
    else
      #failer response
      respond_to do |format|
        format.js{render :text => "$('.provider_notify_failer').css('display', 'block').fadeOut(3000);"}
      end
    end #flag end
  
  end #method end
  
  def provider_plan
    @user_profile = current_user.user_profile
     render :layout=>"provider_layout"
  end


  def provider_sponsor
    if !current_user.user_transaction.nil?
      @payment_detail = UserTransaction.find_by_user_id(current_user.user_id)
      @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id)  if !@payment_detail.nil?
      @card_number = @payment_profile.params["payment_profile"]['payment']['credit_card']['card_number'] if @payment_profile.success?  if !@payment_profile.nil?
      @current_user = User.find(params[:id])
      @old_plan = current_user.user_plan
      @get_current_url = request.env['HTTP_HOST'] 
      @user = current_user
      @to = current_user.email_address
      @name = current_user.user_name
      @current_user.update_attributes(:user_plan => "sponsor")
      @provider_notify_plan = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='10' and p.user_id='#{current_user.user_id}' and p.notify_flag=true") if !current_user.nil? && !current_user.user_id.nil?
      if !@provider_notify_plan.nil? && @provider_notify_plan!="" && @provider_notify_plan.present?
        if current_user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Sponsor Upgrade", priority: 2, run_at: 10.seconds.from_now).sponcor_upgrade_mail(@user,@to,@get_current_url)
        end
      else
        if current_user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Sponsor Upgrade", priority: 2, run_at: 10.seconds.from_now).sponcor_upgrade_mail(@user,@to,@get_current_url)
        end
      end
      #redirect_to( :action =>"provider_plan")
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: provider_plan }
      end
    
    end
  end
  
  #~ #setting page details
  #~ @setting_plan_changes=ProviderNotification.where(:user_id=>current_user.user_id, :notify_type=>"default") if current_user.present? && !current_user.user_id.nil?
  #~ if @setting_plan_changes.present? && @setting_plan_changes!="" && !@setting_plan_changes.nil?
  #~ @setting_plan_changes.each do |plan_setting|
  #~ if plan_setting.provider_notify_id==10
  #~ if plan_setting.notify_flag==TRUE && plan_setting.provider_notify_id==10
  #~ @result = UserMailer.sponcor_upgrade_mail(@user,params[:message],@name,@to,params[:subject]).deliver
  #~ end if plan_setting.present? && !plan_setting.notify_flag.nil? && !plan_setting.provider_notify_id.nil?
  #~ end if plan_setting.present? && !plan_setting.provider_notify_id.nil?
  #~ end if @setting_plan_changes.present? && !@setting_plan_changes.nil? #do end
  #~ else
  #~ @result = UserMailer.sponcor_upgrade_mail(@user,params[:message],@name,@to,params[:subject]).deliver 
  #~ end
  
  #provider curator view files calling
  def provider_curator
  end
    
  
  def provider_sell

    if !current_user.user_bank_detail.nil? 
      #@payment_detail = UserTransaction.find_by_user_id(current_user.user_id)
      #@payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id)  if !@payment_detail.nil?
      #@card_number = @payment_profile.params["payment_profile"]['payment']['credit_card']['card_number'] if @payment_profile.success?  if !@payment_profile.nil?
      @current_user = User.find(params[:id])
      @old_plan = current_user.user_plan
      @get_current_url = request.env['HTTP_HOST'] 
      @user_usr = current_user
      @name = current_user.user_name
      @to = current_user.email_address
      @user = current_user
      if !@user.nil? && !@user.user_plan.nil? && @user.user_plan.downcase == "curator"
        #send a mail to admin about the curator changes
	@pro_status = 'curator'
        @result = UserMailer.delay(queue: "curator Upgrade", priority: 2, run_at: 10.seconds.from_now).curator_upgrade_info(@user)
        @user.update_attributes(:user_plan => "sell", :user_flag=>true)
      else
		@pro_status = ''
        @user.update_attributes(:user_plan => "sell")
      end
      @provider_notify_plan = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='10' and p.user_id='#{current_user.user_id}' and p.notify_flag=true") if !current_user.nil? && !current_user.user_id.nil?
      if !@provider_notify_plan.nil? && @provider_notify_plan!="" && @provider_notify_plan.present?
        if current_user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Sell Upgrade", priority: 2, run_at: 10.seconds.from_now).sell_upgrade_mail(@user_usr,@to,@get_current_url,@pro_status)
        end
      else
        if current_user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Sell Upgrade", priority: 2, run_at: 10.seconds.from_now).sell_upgrade_mail(@user_usr,@to,@get_current_url,@pro_status)
        end
      end
      #cotc for plan upgrade and downgrade
      # if (request.url == "http://www.famtivity.com/")
      #cotc_plan_update
      #end
      #redirect_to( :action =>"provider_plan")
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: provider_plan }
      end
    
    end
  end
  
  def provider_plan_upgrade_tran
    @np = params[:np] if !params[:np].nil?
  end #method ending here.
  
  def provider_plan_submit_tran
	  
    cookies[:np]= params[:np] if !params[:np].nil?
    @user = current_user
    @user_old = User.find_by_user_id(current_user.user_id)
     if !@user_old.nil? && @user_old.manage_plan.blank?
	        @ext_plan = @user_old.user_plan
      else
	      @ext_plan = @user_old.manage_plan
	end
    @c_plan = @user.manage_plan if !@user.manage_plan.nil?

    if !@user.nil? && @user.user_transaction.nil?
      #authorize net started by rajkumar
      customer_profile_information = {
        :profile     => {
          :merchant_customer_id => params[:sell_CardholderFirstName]+"#{Time.now.strftime("%S") if params[:sell_CardholderFirstName]}",
          :email => @user.email_address
        }
      }
      create_profile = CIMGATEWAY.create_customer_profile(customer_profile_information)
      if !create_profile.nil? && create_profile.success? #check the profile
        billing_info = {
          :first_name => params[:sell_CardholderFirstName]
        }
        #get the credit card details
        credit_card = ActiveMerchant::Billing::CreditCard.new(
          :first_name => params[:sell_CardholderFirstName],
          #:last_name => params[:sell_CardholderLastName],
          :number => "#{params[:sell_cardnumber_1]}" + "#{params[:sell_cardnumber_2]}" + "#{params[:sell_cardnumber_3]}" + "#{params[:sell_cardnumber_4]}",
          :month => params[:sell_date_card].to_i,
          :year => params[:sell_year_card_1].to_i,
          :verification_value => params[:sell_cardnumber_5], #verification codes are now required
          :type => params[:sell_chkout_card] #choosen payment type
        )

        payment_profile = {
          :bill_to => billing_info,
          :payment => {
            :credit_card => credit_card
          }
        }

        options = {
          :customer_profile_id => create_profile.authorization,
          :payment_profile => payment_profile
        }
        #create the customer payment profile for registered user
        pay_profile = CIMGATEWAY.create_customer_payment_profile(options)
        if !pay_profile.nil? && pay_profile.success?
          #manage plan calculation checked started
          if cookies[:np]=="market_sell"
            amnt = 29.95
            nplan = "Market Sell Plan"
            sales_pro_limit = 25
            plan_amount_tot = 29.95
          elsif cookies[:np]=="market_sell_manage"
            if !@c_plan.nil? && @c_plan =="market_sell"
              amnt = 49.95 - 29.95
            else
              amnt = 49.95
            end
            nplan = "Market Sell Manage Plan"
            sales_pro_limit = 75
            plan_amount_tot = 49.95
          elsif cookies[:np]=="market_sell_manage_plus"
            if !@c_plan.nil? && @c_plan =="market_sell"
              amnt = 99.95 - 29.95
            elsif !@c_plan.nil? && @c_plan =="market_sell_manage"
              amnt = 99.95 - 49.95
            else
              amnt = 99.95
            end
            nplan = "Market Sell Manage Plus Plan"
            sales_pro_limit = 150
            plan_amount_tot = 99.95
          end
          #manage plan calculation checked ending here.

          if !create_profile.authorization.nil? && !pay_profile.params["customer_payment_profile_id"].nil?
            @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>create_profile.authorization,:customer_payment_profile_id=>pay_profile.params["customer_payment_profile_id"])
            transaction =
              {:transaction => {
                :type => :auth_capture,
                :amount => "#{amnt.round(2)}", #amount detection
                :customer_profile_id => create_profile.authorization,
                :customer_payment_profile_id => pay_profile.params["customer_payment_profile_id"]
              }
            }
            #create the transaction for the user
            response_pr = CIMGATEWAY.create_customer_profile_transaction(transaction)
            if !response_pr.nil? && response_pr.success?
              #~ stored the transaction success information in leads table
              provider_trans_id = "#{response_pr.authorization}" if !response_pr.nil? && !response_pr.authorization.nil?
              @old_plan = current_user.user_plan
              @get_current_url = request.env['HTTP_HOST']
              @user = current_user
              @to = current_user.email_address
              @name = current_user.user_name
			
              #====================activate the =======================================#
              if @user && !@user.user_status.nil? && @user.user_status=="deactivate"
                activate_user_upgrade(@user)
              end #ending
              #===========================================================#
			
              if !@user.nil? && !@user.user_plan.nil? && @user.user_plan.downcase == "curator"
                #send a mail to admin about the changes
		@pro_status = 'curator'
                @result = UserMailer.delay(queue: "curator Upgrade", priority: 2, run_at: 10.seconds.from_now).curator_upgrade_info(@user)
                @user.update_attributes(:user_plan => "sell", :manage_plan => cookies[:np], :user_flag=>true, :downgrade_plan=>nil, :user_status=>"activate", :is_partner=>false)
              else
		      @pro_status = ''
                @user.update_attributes(:user_plan => "sell", :manage_plan => cookies[:np], :downgrade_plan=>nil, :user_status=>"activate", :is_partner=>false)
              end
		
              #after success transaction stored the user information
              @user_transaction = UserTransaction.new
              @user_transaction.customer_profile_id = create_profile.authorization
              @user_transaction.customer_payment_profile_id = pay_profile.params["customer_payment_profile_id"]
              @user_transaction.user_id = @user.user_id
              @user_transaction.inserted_date = Time.now
              @user_transaction.save
				
              utran= UserTransaction.where("user_id=?",@user.user_id).last
			
              pro_transval= ProviderTransaction.where("user_id=?",@user.user_id).last if !@user.nil?
              pro_transval.update_attributes(:expiry_status=>false) if !pro_transval.nil?
			
              #sent a mail to provider transaction for the user
              UserMailer.delay(queue: "User upgrade Transaction", priority: 1, run_at: 10.seconds.from_now).register_user_transaction(@user,amnt)
			
              #while upgrading to the provider update the current plan end date to the provider transaction table.
              @tdy_date = Time.now.strftime("%Y-%m-%d")
              @p_tran_check = ProviderTransaction.find_by_sql("select * from provider_transactions where user_id='#{@user.user_id}' and (end_date >= date('#{@tdy_date}')) order by id desc limit 1") if !@user.nil?
              (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].start_date.nil? && @p_tran_check[0].start_date.present?) ? (p_sdate = @p_tran_check[0].start_date) : (p_sdate=Time.now)
              (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].end_date.nil? && @p_tran_check[0].end_date.present?) ? (p_edate = @p_tran_check[0].end_date) : (p_edate=Time.now+30.days)
              (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].grace_period_date.nil? && @p_tran_check[0].grace_period_date.present?) ? (p_gdate = @p_tran_check[0].grace_period_date) : (p_gdate=Time.now+37.days)
              (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].purchase_limit.nil? && @p_tran_check[0].purchase_limit.present?) ? (plimit = @p_tran_check[0].purchase_limit) : (plimit=0)
              #while upgrading to the provider update the current plan end date to the provider transaction table ending here
			
              #-----------------------------store to the transaction details------------------------------------------#
              @p_trans = ProviderTransaction.create(:user_id=>@user.user_id, :action_type=>"upgrade", :amount=>amnt, :user_plan=>@user.manage_plan, :customer_profile_id=>utran.customer_profile_id, :customer_payment_profile_id=>utran.customer_payment_profile_id, :inserted_date=>Time.now, :modified_date=>Time.now, :start_date=>p_sdate, :end_date=>p_edate, :grace_period_date=>p_gdate, :sales_limit=>sales_pro_limit, :purchase_limit=>plimit, :expiry_status=>true, :payment_date=>Time.now, :plan_amount=>plan_amount_tot, :email_address=>@user.email_address, :transaction_id=>provider_trans_id) if !@user.nil? && !amnt.nil?
              #-----------------------------------------------------------------------#
              @u_success=true
	        #provider transaction details started stored user information after success or failure
		ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>amnt, :action_type=>"upgrade", :customer_payment_profile_id=>utran.customer_payment_profile_id, :customer_profile_id=>utran.customer_profile_id, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{response_pr.message}", :payment_status=>"success", :transaction_id=>provider_trans_id, :user_id=>@user.user_id) if @user && @user.email_address
		#provider transaction details ended here
              #mailing for the provider user
              if !current_user.nil? && current_user.user_flag==TRUE
                @result = UserMailer.delay(queue: "Sell Upgrade new plan", priority: 2, run_at: 10.seconds.from_now).sell_upgrade_mail(@user,@to,@get_current_url,nplan,@pro_status,plan_amount_tot,amnt,@ext_plan)
              end
              #after success ending here
            else #transaction response else part
              @failer_message= "#{response_pr.message}" if !response_pr.nil? && !response_pr.message.nil?
		#provider transaction details started stored user information after success or failure
		ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>amnt, :action_type=>"upgrade", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{response_pr.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>@user.user_id) if @user && @user.email_address
		#provider transaction details ended here
	      @u_success=false
            end #response ending
          end #create profile authorize ending here.
        else #pay profile else part
          @u_success=false
	  #provider transaction details started stored user information after success or failure
		ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>amnt, :action_type=>"upgrade", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{pay_profile.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>@user.user_id) if @user && @user.email_address
		#provider transaction details ended here
        end
      else #create profile else part
        @u_success=false
        @failer_message = create_profile.message if !create_profile.nil?
	#provider transaction details started stored user information after success or failure
		ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>amnt, :action_type=>"upgrade", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{create_profile.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>@user.user_id) if @user && @user.email_address
		#provider transaction details ended here
      end  #create profile ending
      #authorize net end
    end #user transaction end part

	  if @user && @user.errors.empty? && @u_success
      @trans_approve =  "Success! You have been upgraded to the #{nplan}!"
    else
      @trans_approve =  "Sorry. we are unable to process the transaction. Please check your card details or try again later."
	  end
    render :partial=>'provider_sell_thank'
  end #submit transaction ending here
 
  #provider plan down grade method calling
  def provider_plan_downgrade
    if !current_user.nil?
      cookies[:np]= params[:np] if !params[:np].nil?
      @old_plan = current_user.user_plan
      @get_current_url = request.env['HTTP_HOST']
      @user = current_user
      @to = current_user.email_address
      @name = current_user.user_name
      #plan changes start
			if cookies[:np]=="market_sell"
				nplan = "Market Sell Plan"
			elsif cookies[:np]=="market_sell_manage"
				nplan = "Market Sell Manage Plan"
			elsif cookies[:np]=="market_sell_manage_plus"
        nplan = "Market Sell Manage Plus Plan"
			end
      #plan changes ending here
		
      #if we get the amount for maintenance kindly autorenewal current plan amount for the provider user while downgrading#
      pro_transval= ProviderTransaction.where("user_id=?",@user.user_id).last if !@user.nil?
      if !pro_transval.nil? && pro_transval.present? && !pro_transval.action_type.nil? && pro_transval.action_type=="deactivate"
        #call this method for activate the current plan (after user deactivated)
      #~ current_account_activate(@user,params[:np]) if !@user.nil? && !params[:np].nil?
        current_account_activate(@user,params[:np],'downgrade') if !@user.nil? && !params[:np].nil?
        #update the user activities as active
        activate_user_upgrade(@user)
        @user.update_attributes(:user_plan => "sell", :user_flag=>true, :downgrade_plan=>cookies[:np], :manage_plan=>cookies[:np], :user_status=>"activate")
      else #normal downgrade function
		
        if !@user.nil? && !@user.user_plan.nil? && @user.user_plan.downcase == "curator"
          #send a mail to admin about the changes
          #~ @result = UserMailer.delay(queue: "curator Upgrade", priority: 2, run_at: 10.seconds.from_now).curator_upgrade_info(@user)
          @user.update_attributes(:user_plan => "sell", :user_flag=>true, :downgrade_plan=>cookies[:np], :user_status=>"activate", :is_partner=>false)
          @result = UserMailer.delay(queue: "Sell Downgrade", priority: 2, run_at: 10.seconds.from_now).sell_downgrade_mail(@user,@to,@get_current_url,nplan)
          #~ @return_status="Thank you. Your plan has been downgraded successfully.";
        else
          @user.update_attributes(:user_plan => "sell", :downgrade_plan => cookies[:np], :user_status=>"activate", :is_partner=>false)
          @result = UserMailer.delay(queue: "Sell Downgrade", priority: 2, run_at: 10.seconds.from_now).sell_downgrade_mail(@user,@to,@get_current_url,nplan)
				
        end
      end #deactivate ending here.
			@return_status="Thank you. Your plan has been downgraded successfully.";
      render :text=> @return_status.to_json
    end #current_user ending here
  end

  #provider plan upgrade functionalities by rajkumar
  def provider_plan_upgrade
    cookies[:np]= params[:np] if !params[:np].nil?

    if !current_user.user_bank_detail.nil? 
      @current_user = User.find(current_user.user_id)
      @user_old = User.find_by_user_id(current_user.user_id)
     if !@user_old.nil? && @user_old.manage_plan.blank?
	        @ext_plan = @user_old.user_plan
      else
	      @ext_plan = @user_old.manage_plan
	end
      @get_current_url = request.env['HTTP_HOST'] 
      @user_usr = current_user
      @name = current_user.user_name
      @to = current_user.email_address
      @user = current_user
      @c_plan = @user.manage_plan if !@user.manage_plan.nil?

      if cookies[:np]=="market_sell"
        amnt = 29.95
        nplan = "Market Sell Plan"
        sales_pro_limit = 25
        plan_amount_tot = 29.95
      elsif cookies[:np]=="market_sell_manage"
        if !@c_plan.nil? && @c_plan =="market_sell"
          amnt = 49.95 - 29.95
        else
          amnt = 49.95
        end
        nplan = "Market Sell Manage Plan"
        sales_pro_limit = 75
        plan_amount_tot = 49.95
      elsif cookies[:np]=="market_sell_manage_plus"
        if !@c_plan.nil? && @c_plan =="market_sell"
          amnt = 99.95 - 29.95
        elsif !@c_plan.nil? && @c_plan =="market_sell_manage"
          amnt = 99.95 - 49.95
        else
          amnt = 99.95
        end
        nplan = "Market Sell Manage Plus Plan"
        sales_pro_limit = 150
        plan_amount_tot = 99.95
      end
         
      #amnt="#{number_with_precision amnt, :precision => 2  if !amnt.nil?}"
      amnt1=amnt.round(2)  if !amnt.nil?
      if !@user.user_transaction.nil? && !@user.user_transaction.customer_profile_id.nil?
        @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@user.user_transaction.customer_profile_id,:customer_payment_profile_id=>@user.user_transaction.customer_payment_profile_id)
        transaction =
          {:transaction => {
            :type => :auth_capture,
            :amount => "#{amnt1}", #0.99cents
            :customer_profile_id => @user.user_transaction.customer_profile_id,
            :customer_payment_profile_id => @user.user_transaction.customer_payment_profile_id
          }
        }

        #create the transaction for the user
        response_pr = CIMGATEWAY.create_customer_profile_transaction(transaction)
        @res_status = response_pr.message
        if(@res_status=='Successful.')
          @return_status="Thank you. Your plan has been upgraded successfully.";
        else
          @return_status="Sorry. we are unable to proceed with the transaction. Please check your card details or try again later.";
        end
        
        if !response_pr.nil? && response_pr.success?
          provider_trans_id = "#{response_pr.authorization}" if !response_pr.nil? && !response_pr.authorization.nil?
          #~stored the transaction success information in leads table
          @old_plan = current_user.user_plan
          @get_current_url = request.env['HTTP_HOST']
          @user = current_user
          @to = current_user.email_address
          @name = current_user.user_name
            
          #====================activate the =======================================#
          if @user && !@user.user_status.nil? && @user.user_status=="deactivate"
            activate_user_upgrade(@user)
          end #ending
          #===========================================================#
			
          if !@user.nil? && !@user.user_plan.nil? && @user.user_plan.downcase == "curator"
            #send a mail to admin about the changes
	    @pro_status = 'curator'
            @result = UserMailer.delay(queue: "curator Upgrade", priority: 2, run_at: 10.seconds.from_now).curator_upgrade_info(@user)
            @user.update_attributes(:user_plan => "sell", :manage_plan => cookies[:np], :user_flag=>true, :downgrade_plan=>nil, :user_status=>"activate", :is_partner=>false)
          else
		@pro_status = ''
            @user.update_attributes(:user_plan => "sell", :manage_plan => cookies[:np], :downgrade_plan=>nil, :user_status=>"activate", :is_partner=>false)
          end
          utran= UserTransaction.where("user_id=?",@user.user_id).last
	   
          pro_transval= ProviderTransaction.where("user_id=?",@user.user_id).last if !@user.nil?
          pro_transval.update_attributes(:expiry_status=>false) if !pro_transval.nil?

          #while upgrading to the provider update the current plan end date to the provider transaction table.
          @tdy_date = Time.now.strftime("%Y-%m-%d")
          @p_tran_check = ProviderTransaction.find_by_sql("select * from provider_transactions where user_id='#{@user.user_id}' and (end_date >= date('#{@tdy_date}')) order by id desc limit 1") if !@user.nil?
          (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].start_date.nil? && @p_tran_check[0].start_date.present?) ? (p_sdate = @p_tran_check[0].start_date) : (p_sdate=Time.now)
          (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].end_date.nil? && @p_tran_check[0].end_date.present?) ? (p_edate = @p_tran_check[0].end_date) : (p_edate=Time.now+30.days)
          (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].grace_period_date.nil? && @p_tran_check[0].grace_period_date.present?) ? (p_gdate = @p_tran_check[0].grace_period_date) : (p_gdate=Time.now+37.days)
          (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].purchase_limit.nil? && @p_tran_check[0].purchase_limit.present?) ? (plimit = @p_tran_check[0].purchase_limit) : (plimit=0)
          #while upgrading to the provider update the current plan end date to the provider transaction table ending here
	
          #-----------------------------store to the transaction details------------------------------------------#
          @p_trans = ProviderTransaction.create(:user_id=>@user.user_id, :action_type=>"upgrade", :amount=>amnt, :user_plan=>@user.manage_plan, :customer_profile_id=>utran.customer_profile_id, :customer_payment_profile_id=>utran.customer_payment_profile_id, :inserted_date=>Time.now, :modified_date=>Time.now, :start_date=>p_sdate, :end_date=>p_edate, :grace_period_date=>p_gdate, :sales_limit=>sales_pro_limit, :purchase_limit=>plimit, :expiry_status=>true, :payment_date=>Time.now, :plan_amount=>plan_amount_tot, :email_address=>@user.email_address, :transaction_id=>provider_trans_id) if !@user.nil? && !amnt.nil? && !utran.nil?
          #-----------------------------------------------------------------------#
          #sent a mail to provider transaction for the user
          UserMailer.delay(queue: "User upgrade Transaction", priority: 1, run_at: 10.seconds.from_now).register_user_transaction(@user,amnt)

          @provider_notify_plan = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='10' and p.user_id='#{current_user.user_id}' and p.notify_flag=true") if !current_user.nil? && !current_user.user_id.nil?
          if !@provider_notify_plan.nil? && @provider_notify_plan!="" && @provider_notify_plan.present?
            if current_user.user_flag==TRUE
              @result = UserMailer.delay(queue: "Sell Upgrade", priority: 2, run_at: 10.seconds.from_now).sell_upgrade_mail(@user_usr,@to,@get_current_url,nplan,@pro_status,plan_amount_tot,amnt,@ext_plan)
            end
          else
            if current_user.user_flag==TRUE
              @result = UserMailer.delay(queue: "Sell Upgrade", priority: 2, run_at: 10.seconds.from_now).sell_upgrade_mail(@user_usr,@to,@get_current_url,nplan,@pro_status,plan_amount_tot,amnt,@ext_plan)
            end
	end
		#provider transaction details started stored user information after success or failure
		ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>amnt, :action_type=>"upgrade", :customer_payment_profile_id=>utran.customer_payment_profile_id, :customer_profile_id=>utran.customer_profile_id, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{response_pr.message}", :payment_status=>"success", :transaction_id=>provider_trans_id, :user_id=>@user.user_id) if @user && @user.email_address
		#provider transaction details ended here
	else#response_pr else part
		#provider transaction details started stored user information after success or failure
		ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>amnt, :action_type=>"upgrade", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{response_pr.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>@user.user_id) if @user && @user.email_address
		#provider transaction details ended here
    
        end
      end


      #cotc for plan upgrade and downgrade
      # if (request.url == "http://www.famtivity.com/")
      #cotc_plan_update
      #end
      #redirect_to( :action =>"provider_plan")
      render :text=> @return_status.to_json
    
    end

  end
  
  #provider renewaling method for the provider
  def provider_plan_renewaling
    cookies[:np]= params[:np] if !params[:np].nil?

    if !current_user.user_bank_detail.nil? 
      @get_current_url = request.env['HTTP_HOST'] 
      @user = current_user
      @c_plan = @user.manage_plan if !@user.manage_plan.nil?
      @to = current_user.email_address
      #current user plan amount calculations starting here
      if cookies[:np]=="market_sell"
        amnt = 29.95
        nplan = "Market Sell Plan"
        sales_pro_limit = 25
        plan_amount_tot = 29.95
      elsif cookies[:np]=="market_sell_manage"
        if !@c_plan.nil? && @c_plan =="market_sell"
          amnt = 49.95 - 29.95
        else
          amnt = 49.95
        end
        nplan = "Market Sell Manage Plan"
        sales_pro_limit = 75
        plan_amount_tot = 49.95
      elsif cookies[:np]=="market_sell_manage_plus"
        if !@c_plan.nil? && @c_plan =="market_sell"
          amnt = 99.95 - 29.95
        elsif !@c_plan.nil? && @c_plan =="market_sell_manage"
          amnt = 99.95 - 49.95
        else
          amnt = 99.95
        end
        nplan = "Market Sell Manage Plus Plan"
        sales_pro_limit = 150
        plan_amount_tot = 99.95
      end
      #current user plan amount calculations ending here.
	 
      #amnt="#{number_with_precision amnt, :precision => 2  if !amnt.nil?}"
      amnt1=amnt.round(2)  if !amnt.nil?
      if !@user.user_transaction.nil? && !@user.user_transaction.customer_profile_id.nil?
        @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@user.user_transaction.customer_profile_id,:customer_payment_profile_id=>@user.user_transaction.customer_payment_profile_id)
        transaction =
          {:transaction => {
            :type => :auth_capture,
            :amount => "#{amnt1}", #amount for the users
            :customer_profile_id => @user.user_transaction.customer_profile_id,
            :customer_payment_profile_id => @user.user_transaction.customer_payment_profile_id
          }
        }

        #create the transaction for the user
        response_pr = CIMGATEWAY.create_customer_profile_transaction(transaction)
        @res_status = response_pr.message
        if(@res_status=='Successful.')
          @return_status="Thank you. Your plan has been renewed successfully.";
        else
          @return_status="Sorry. we are unable to proceed with the transaction. Please check your card details or try again later.";
        end
        
        if !response_pr.nil? && response_pr.success?
          provider_trans_id = "#{response_pr.authorization}" if !response_pr.nil? && !response_pr.authorization.nil?
           
          #====================activate the =======================================#
          if @user && !@user.user_status.nil? && @user.user_status=="deactivate"
            activate_user_upgrade(@user)
          end #ending
          #===========================================================#
          #~stored the transaction success information in leads table
          if !@user.nil? && !@user.user_plan.nil? && @user.user_plan.downcase == "curator"
            #send a mail to admin about the changes
            @user.update_attributes(:user_plan => "sell", :manage_plan => cookies[:np], :user_flag=>true, :downgrade_plan=>nil, :user_status=>"activate", :is_partner=>false)
          else
            @user.update_attributes(:user_plan => "sell", :manage_plan => cookies[:np], :downgrade_plan=>nil, :user_status=>"activate", :is_partner=>false)
          end
          #get the user transaction information
          utran= UserTransaction.where("user_id=?",@user.user_id).last if !@user.nil?
          pro_transval= ProviderTransaction.where("user_id=?",@user.user_id).last if !@user.nil?
          pro_transval.update_attributes(:expiry_status=>false) if !pro_transval.nil?
          #store to the transaction details#
          @p_trans = ProviderTransaction.create(:user_id=>@user.user_id, :action_type=>"plan-renewal", :amount=>amnt, :user_plan=>@user.manage_plan, :customer_profile_id=>utran.customer_profile_id, :customer_payment_profile_id=>utran.customer_payment_profile_id, :inserted_date=>Time.now, :modified_date=>Time.now, :start_date=>Time.now, :end_date=>Time.now+30.days, :grace_period_date=>Time.now+37.days, :sales_limit=>sales_pro_limit, :purchase_limit=>0, :expiry_status=>true, :payment_date=>Time.now, :plan_amount=>plan_amount_tot, :email_address=>@user.email_address, :transaction_id=>provider_trans_id) if !@user.nil? && !amnt.nil? && !utran.nil?
          #provider transaction ending here#
	
          #sent a mail to provider transaction for the user
          UserMailer.delay(queue: "User renewaling Transaction", priority: 1, run_at: 10.seconds.from_now).register_user_transaction(@user,amnt)
          #mail template for renewaling the plan
          @result = UserMailer.delay(queue: "Sell Renewal", priority: 2, run_at: 10.seconds.from_now).plan_renewal_mail(@user,@to,@get_current_url,nplan)
		#provider transaction details started stored user information after success or failure
		ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>amnt, :action_type=>"plan-renewal", :customer_payment_profile_id=>utran.customer_payment_profile_id, :customer_profile_id=>utran.customer_profile_id, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{response_pr.message}", :payment_status=>"success", :transaction_id=>provider_trans_id, :user_id=>@user.user_id) if @user && @user.email_address
		#provider transaction details ended here
	else #response_pr else part
	#provider transaction details started stored user information after success or failure
	ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>amnt, :action_type=>"plan-renewal", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{response_pr.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>@user.user_id) if @user && @user.email_address
	#provider transaction details ended here
	end #response_pr ending here
      end #transaction ending here
  
      #cotc for plan upgrade and downgrade
      # if (request.url == "http://www.famtivity.com/")
      #cotc_plan_update
      #end
      #redirect_to( :action =>"provider_plan")
      
      render :text=> @return_status.to_json
    end
  end
  #provider renewaling method ending here.

  def upgradePlan
     
    cookies[:np] if !cookies[:np].nil?
 
    @user = current_user
     @user_old = User.find_by_user_id(current_user.user_id)
     if !@user_old.nil? && @user_old.manage_plan.blank?
	        @ext_plan = @user_old.user_plan
      else
	      @ext_plan = @user_old.manage_plan
	end
    @c_plan = @user.manage_plan if !@user.manage_plan.nil?
    if !@user.nil?
      
      
      
      #p "___________@user-asda---#{@user.user_transaction.inspect}"
  
      if !@user.nil? && @user.user_transaction.nil?
        #authorize net started by rajkumar
        customer_profile_information = {
          :profile     => {
            :merchant_customer_id => params[:CardholderFirstName]+"#{Time.now.strftime("%S") if params[:CardholderFirstName]}",
            :email => @user.email_address
          }
        }
        create_profile = CIMGATEWAY.create_customer_profile(customer_profile_information)
        if !create_profile.nil? && create_profile.success? #check the profile
          billing_info = {
            :first_name => params[:CardholderFirstName]            
          }
          #get the credit card details
          credit_card = ActiveMerchant::Billing::CreditCard.new(
            :first_name => params[:CardholderFirstName],
            #:last_name => params[:CardholderLastName],
            :number => "#{params[:cardnumber_1]}" + "#{params[:cardnumber_2]}" + "#{params[:cardnumber_3]}" + "#{params[:cardnumber_4]}",
            :month => params[:date_card].to_i,
            :year => params[:year_card_1].to_i,
            :verification_value => params[:cardnumber_5], #verification codes are now required
            :type => params[:chkout_card]
          )

          payment_profile = {
            :bill_to => billing_info,
            :payment => {
              :credit_card => credit_card
            }
          }

          options = {
            :customer_profile_id => create_profile.authorization,
            :payment_profile => payment_profile
          }
          #create the customer payment profile for registered user
          pay_profile = CIMGATEWAY.create_customer_payment_profile(options)
          if !pay_profile.nil? && pay_profile.success?
            @user_transaction = UserTransaction.new
            @user_transaction.customer_profile_id = create_profile.authorization
            @user_transaction.customer_payment_profile_id = pay_profile.params["customer_payment_profile_id"]
            @user_transaction.user_id = @user.user_id
            @user_transaction.inserted_date = Time.now
            @user_transaction.save
            if !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="bankinfo"
              @user_bank = UserBankDetail.new
              @user_bank.bank_name = params[:bank_name]
              @user_bank.bank_wire_transfer = params[:w_transfer]
              @user_bank.bank_account_name = params[:account_name]
              @user_bank.bank_account_number = params[:acc_number]
              @user_bank.bank_swift_code = params[:swift_code]
              @user_bank.bank_state = params[:bank_state]
              @user_bank.bank_city = params[:bank_city]
              @user_bank.bank_zip_code = params[:bank_z_code]
              @user_bank.supplier_code = params[:s_code]
              @user_bank.legal_name = params[:l_name]
              @user_bank.tax_code = params[:t_code]
              @user_bank.bank_street_address = params[:street_bank_code] if params[:street_bank_code] != "Enter street number & street address"
              #~ @user_bank.street_number = params[:number_bank_code]
              @user_bank.perm_state = params[:state_reg]
              @user_bank.prem_city = params[:city_reg]
              @user_bank.prem_zip_code = params[:z_code]
              @user_bank.user_id = current_user.user_id
              @user_bank.prefered_mode= "bank"
              @user_bank.save
            elsif !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="check"
              @user_bank = UserBankDetail.new
              @user_bank.user_id = current_user.user_id
              @user_bank.payee_name = params[:paye_name]
              @user_bank.business_name = params[:business_name]
              @user_bank.check_street_address = params[:street_check_code] if params[:street_check_code] != "Enter street number & street address"
              @user_bank.check_state = params[:bank_state]
              @user_bank.check_city = params[:check_bank_city]
              @user_bank.check_zip_code = params[:check_z_code]
              @user_bank.check_country = params[:bank_country]
              @user_bank.prefered_mode= "check"
              @user_bank.save
            end
            @u_success=true


            if cookies[:np]=="market_sell"
              amnt = 29.95
              nplan = "Market Sell Plan"
              sales_pro_limit = 25
              plan_amount_tot = 29.95
            elsif cookies[:np]=="market_sell_manage"
              if !@c_plan.nil? && @c_plan =="market_sell"
                amnt = 49.95 - 29.95
              else
                amnt = 49.95
              end
              nplan = "Market Sell Manage Plan"
              sales_pro_limit = 75
              plan_amount_tot = 49.95
            elsif cookies[:np]=="market_sell_manage_plus"
              if !@c_plan.nil? && @c_plan =="market_sell"
                amnt = 99.95 - 29.95
              elsif !@c_plan.nil? && @c_plan =="market_sell_manage"
                amnt = 99.95 - 49.95
              else
                amnt = 99.95
              end
              nplan = "Market Sell Manage Plus Plan"
              sales_pro_limit = 150
              plan_amount_tot = 99.95
            end

            if !create_profile.authorization.nil? && !pay_profile.params["customer_payment_profile_id"].nil?
              @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>create_profile.authorization,:customer_payment_profile_id=>pay_profile.params["customer_payment_profile_id"])
              transaction =
                {:transaction => {
                  :type => :auth_capture,
                  :amount => "#{amnt}", #0.99cents
                  :customer_profile_id => create_profile.authorization,
                  :customer_payment_profile_id => pay_profile.params["customer_payment_profile_id"]
                }
              }
              #create the transaction for the user
              response_pr = CIMGATEWAY.create_customer_profile_transaction(transaction)
              #p "=====sadfsafdrespnse====#{response_pr}"
              if !response_pr.nil? && response_pr.success?
                provider_trans_id = "#{response_pr.authorization}" if !response_pr.nil? && !response_pr.authorization.nil?
                #~stored the transaction success information in leads table
                @old_plan = current_user.user_plan
                @get_current_url = request.env['HTTP_HOST']
                @user = current_user
                @to = current_user.email_address
                @name = current_user.user_name
                
                #====================activate the =======================================#
                if @user && !@user.user_status.nil? && @user.user_status=="deactivate"
                  activate_user_upgrade(@user)
                end #ending
                #===========================================================#
			
                if !@user.nil? && !@user.user_plan.nil? && @user.user_plan.downcase == "curator"
                  #send a mail to admin about the changes
                  @result = UserMailer.delay(queue: "curator Upgrade", priority: 2, run_at: 10.seconds.from_now).curator_upgrade_info(@user)
                  @user.update_attributes(:user_plan => "sell", :manage_plan => cookies[:np], :user_flag=>true, :downgrade_plan=>nil, :user_status=>"activate", :is_partner=>false)
                else
                  @user.update_attributes(:user_plan => "sell", :manage_plan => cookies[:np], :downgrade_plan=>nil, :user_status=>"activate", :is_partner=>false)
                end
                #sent a mail to provider transaction for the user
                UserMailer.delay(queue: "User upgrade Transaction", priority: 1, run_at: 10.seconds.from_now).register_user_transaction(@user,amnt)
              
                utran= UserTransaction.where("user_id=?",@user.user_id).last
		   
                pro_transval= ProviderTransaction.where("user_id=?",@user.user_id).last if !@user.nil?
                pro_transval.update_attributes(:expiry_status=>false) if !pro_transval.nil?
		   
                #while upgrading to the provider update the current plan end date to the provider transaction table.
                @tdy_date = Time.now.strftime("%Y-%m-%d")
                @p_tran_check = ProviderTransaction.find_by_sql("select * from provider_transactions where user_id='#{@user.user_id}' and (end_date >= date('#{@tdy_date}')) order by id desc limit 1") if !@user.nil?
                (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].start_date.nil? && @p_tran_check[0].start_date.present?) ? (p_sdate = @p_tran_check[0].start_date) : (p_sdate=Time.now)
                (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].end_date.nil? && @p_tran_check[0].end_date.present?) ? (p_edate = @p_tran_check[0].end_date) : (p_edate=Time.now+30.days)
                (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].grace_period_date.nil? && @p_tran_check[0].grace_period_date.present?) ? (p_gdate = @p_tran_check[0].grace_period_date) : (p_gdate=Time.now+37.days)
                (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].purchase_limit.nil? && @p_tran_check[0].purchase_limit.present?) ? (plimit = @p_tran_check[0].purchase_limit) : (plimit=0)
                #while upgrading to the provider update the current plan end date to the provider transaction table ending here
		
                #-----------------------------store to the transaction details------------------------------------------#
                @p_trans = ProviderTransaction.create(:user_id=>@user.user_id, :action_type=>"upgrade", :amount=>amnt, :user_plan=>@user.manage_plan, :customer_profile_id=>utran.customer_profile_id, :customer_payment_profile_id=>utran.customer_payment_profile_id, :inserted_date=>Time.now, :modified_date=>Time.now, :start_date=>p_sdate, :end_date=>p_edate, :grace_period_date=>p_gdate, :sales_limit=>sales_pro_limit, :purchase_limit=>plimit, :expiry_status=>true, :payment_date=>Time.now, :plan_amount=>plan_amount_tot, :email_address=>@user.email_address, :transaction_id=>provider_trans_id) if !@user.nil? && !amnt.nil?
                #-----------------------------------------------------------------------#
	       @u_success=true
	       
			#provider transaction details started stored user information after success or failure
			ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>amnt, :action_type=>"upgrade", :customer_payment_profile_id=>utran.customer_payment_profile_id, :customer_profile_id=>utran.customer_profile_id, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{response_pr.message}", :payment_status=>"success", :transaction_id=>provider_trans_id, :user_id=>@user.user_id) if @user && @user.email_address
			#provider transaction details ended here
	       
	      else #response_pr response else part here
			#provider transaction details started stored user information after success or failure
			ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>amnt, :action_type=>"upgrade", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{response_pr.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>@user.user_id) if @user && @user.email_address
			#provider transaction details ended here
		      @u_success=false
	      end
            end
      
          else
            @u_success=false
	    #provider transaction details started stored user information after success or failure
		ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>amnt, :action_type=>"upgrade", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{pay_profile.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>@user.user_id) if @user && @user.email_address
		#provider transaction details ended here
          end
        else #create profile else part
          @u_success=false
          @failer_message = create_profile.message if !create_profile.nil?
		#provider transaction details started stored user information after success or failure
		ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>amnt, :action_type=>"upgrade", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{create_profile.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>@user.user_id) if @user && @user.email_address
		#provider transaction details ended here
        end  #create profile ending
        #authorize net end
      else

        if cookies[:np]=="market_sell"
          amnt = 29.95
          nplan = "Market Sell Plan"
          sales_pro_limit = 25
          plan_amount_tot = 29.95
        elsif cookies[:np]=="market_sell_manage"
          if !@c_plan.nil? && @c_plan =="market_sell"
            amnt = 49.95 - 29.95
          else
            amnt = 49.95
          end
          nplan = "Market Sell Manage Plan"
          sales_pro_limit = 75
          plan_amount_tot = 49.95
        elsif cookies[:np]=="market_sell_manage_plus"
          if !@c_plan.nil? && @c_plan =="market_sell"
            amnt = 99.95 - 29.95
          elsif !@c_plan.nil? && @c_plan =="market_sell_manage"
            amnt = 99.95 - 49.95
          else
            amnt = 99.95
          end
          sales_pro_limit = 150
          plan_amount_tot = 99.95
          nplan = "Market Sell Manage Plus Plan"
        end

        if !@user.user_transaction.nil? && !@user.user_transaction.customer_profile_id.nil?
          @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@user.user_transaction.customer_profile_id,:customer_payment_profile_id=>@user.user_transaction.customer_payment_profile_id)
          transaction =
            {:transaction => {
              :type => :auth_capture,
              :amount => "#{amnt}", #0.99cents
              :customer_profile_id => @user.user_transaction.customer_profile_id,
              :customer_payment_profile_id => @user.user_transaction.customer_payment_profile_id
            }
          }
          #create the transaction for the user
          response_pr = CIMGATEWAY.create_customer_profile_transaction(transaction)
          if !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="bankinfo"
            @user_bank = UserBankDetail.new
            @user_bank.bank_name = params[:bank_name]
            @user_bank.bank_wire_transfer = params[:w_transfer]
            @user_bank.bank_account_name = params[:account_name]
            @user_bank.bank_account_number = params[:acc_number]
            @user_bank.bank_swift_code = params[:swift_code]
            @user_bank.bank_state = params[:bank_state]
            @user_bank.bank_city = params[:bank_city]
            @user_bank.bank_zip_code = params[:bank_z_code]
            @user_bank.supplier_code = params[:s_code]
            @user_bank.legal_name = params[:l_name]
            @user_bank.tax_code = params[:t_code]
            @user_bank.bank_street_address = params[:street_bank_code] if params[:street_bank_code] != "Enter street number & street address"
            #~ @user_bank.street_number = params[:number_bank_code]
            @user_bank.perm_state = params[:state_reg]
            @user_bank.prem_city = params[:city_reg]
            @user_bank.prem_zip_code = params[:z_code]
            @user_bank.user_id = current_user.user_id
            @user_bank.prefered_mode= "bank"
            @user_bank.save
          elsif !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="check"
            @user_bank = UserBankDetail.new
            @user_bank.user_id = current_user.user_id
            @user_bank.payee_name = params[:paye_name]
            @user_bank.business_name = params[:business_name]
            @user_bank.check_street_address = params[:street_check_code] if params[:street_check_code] != "Enter street number & street address"
            @user_bank.check_state = params[:bank_state]
            @user_bank.check_city = params[:check_bank_city]
            @user_bank.check_zip_code = params[:check_z_code]
            @user_bank.check_country = params[:bank_country]
            @user_bank.prefered_mode= "check"
            @user_bank.save
          end


          #p "=====respnse====#{response_pr.message}"
          if !response_pr.nil? && response_pr.success?
	          provider_trans_id = "#{response_pr.authorization}" if !response_pr.nil? && !response_pr.authorization.nil?
            #~stored the transaction success information in leads table
            @old_plan = current_user.user_plan
            @get_current_url = request.env['HTTP_HOST']
            @user = current_user
            @to = current_user.email_address
            @name = current_user.user_name
		
            #====================activate the =======================================#
            if @user && !@user.user_status.nil? && @user.user_status=="deactivate"
              activate_user_upgrade(@user)
            end #ending
            #===========================================================#
			
            if !@user.nil? && !@user.user_plan.nil? && @user.user_plan.downcase == "curator"
              #send a mail to admin about the changes
	      @pro_status = 'curator'
              @result = UserMailer.delay(queue: "curator Upgrade", priority: 2, run_at: 10.seconds.from_now).curator_upgrade_info(@user)
              @user.update_attributes(:user_plan => "sell", :manage_plan => cookies[:np], :user_flag=>true, :downgrade_plan=>nil, :user_status=>"activate", :is_partner=>false)
            else
		    @pro_status = ''
              @user.update_attributes(:user_plan => "sell", :manage_plan => cookies[:np], :downgrade_plan=>nil, :user_status=>"activate", :is_partner=>false)
            end
            utran= UserTransaction.where("user_id=?",@user.user_id).last
	   
            pro_transval= ProviderTransaction.where("user_id=?",@user.user_id).last if !@user.nil?
            pro_transval.update_attributes(:expiry_status=>false) if !pro_transval.nil?
	
            #while upgrading to the provider update the current plan end date to the provider transaction table.
            @tdy_date = Time.now.strftime("%Y-%m-%d")
            @p_tran_check = ProviderTransaction.find_by_sql("select * from provider_transactions where user_id='#{@user.user_id}' and (end_date >= date('#{@tdy_date}')) order by id desc limit 1") if !@user.nil?
            (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].start_date.nil? && @p_tran_check[0].start_date.present?) ? (p_sdate = @p_tran_check[0].start_date) : (p_sdate=Time.now)
            (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].end_date.nil? && @p_tran_check[0].end_date.present?) ? (p_edate = @p_tran_check[0].end_date) : (p_edate=Time.now+30.days)
            (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].grace_period_date.nil? && @p_tran_check[0].grace_period_date.present?) ? (p_gdate = @p_tran_check[0].grace_period_date) : (p_gdate=Time.now+37.days)
            (!@p_tran_check.nil? && !@p_tran_check[0].nil? && !@p_tran_check[0].purchase_limit.nil? && @p_tran_check[0].purchase_limit.present?) ? (plimit = @p_tran_check[0].purchase_limit) : (plimit=0)
            #while upgrading to the provider update the current plan end date to the provider transaction table ending here
	
            #-----------------------------store to the transaction details------------------------------------------#
            @p_trans = ProviderTransaction.create(:user_id=>@user.user_id, :action_type=>"upgrade", :amount=>amnt, :user_plan=>@user.manage_plan, :customer_profile_id=>utran.customer_profile_id, :customer_payment_profile_id=>utran.customer_payment_profile_id, :inserted_date=>Time.now, :modified_date=>Time.now,:start_date=>p_sdate, :end_date=>p_edate, :grace_period_date=>p_gdate, :sales_limit=>sales_pro_limit, :purchase_limit=>plimit, :expiry_status=>true, :payment_date=>Time.now, :plan_amount=>plan_amount_tot, :email_address=>@user.email_address, :transaction_id=>provider_trans_id) if !@user.nil? && !amnt.nil?
            #-----------------------------------------------------------------------#
	
            #sent a mail to provider transaction for the user
            UserMailer.delay(queue: "User upgrade Transaction", priority: 1, run_at: 10.seconds.from_now).register_user_transaction(@user,amnt)
		#provider transaction details started stored user information after success or failure
		ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>amnt, :action_type=>"upgrade", :customer_payment_profile_id=>utran.customer_payment_profile_id, :customer_profile_id=>utran.customer_profile_id, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{response_pr.message}", :payment_status=>"success", :transaction_id=>provider_trans_id, :user_id=>@user.user_id) if @user && @user.email_address
		#provider transaction details ended here
	else #response_pr else part
		#provider transaction details started stored user information after success or failure
		ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>amnt, :action_type=>"upgrade", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{response_pr.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>@user.user_id) if @user && @user.email_address
		#provider transaction details ended here
	end
        end
           
      end #user transaction end
  
      @provider_notify_plan = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='10' and p.user_id='#{current_user.user_id}' and p.notify_flag=true") if !current_user.nil? && !current_user.user_id.nil?
      if !@provider_notify_plan.nil? && @provider_notify_plan!="" && @provider_notify_plan.present?
        if current_user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Sell Upgrade", priority: 2, run_at: 10.seconds.from_now).sell_upgrade_mail(@user,@to,@get_current_url,nplan,@pro_status,plan_amount_tot,amnt,@ext_plan)
        end
        #@result = UserMailer.sell_upgrade_mail(@user,params[:message],@to,params[:subject],@get_current_url,@old_plan,@card_number).deliver
      else
        if current_user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Sell Upgrade", priority: 2, run_at: 10.seconds.from_now).sell_upgrade_mail(@user,@to,@get_current_url,nplan,@pro_status,plan_amount_tot,amnt,@ext_plan)
        end
      end

      if !@user.manage_plan.nil?
        @trans_approve =  "Success! You have been upgraded to the #{nplan}!"
      else
        @trans_approve =  "Sorry. we are unable to proceed with the transaction. Please check your card details or try again later."
      end
      render :partial=>'provider_sell_thank'
    end
  end
  #upgrade to sell plan ending

  def down_free
    @current_user = User.find(params[:id])
    @payment_detail = UserTransaction.find_by_user_id(current_user.user_id)
    @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id)  if !@payment_detail.nil?
    @card_number = @payment_profile.params["payment_profile"]['payment']['credit_card']['card_number'] if @payment_profile.success?  if !@payment_profile.nil?
    @old_plan = current_user.user_plan
    @get_current_url = request.env['HTTP_HOST'] 
    #~ @current_user.update_attributes(:user_plan => "free")
    if !@current_user.nil? && !@current_user.user_plan.nil? && @current_user.user_plan.downcase == "curator"
      #send a mail to admin about the curator changes
      @current_user.update_attributes(:user_plan => "free", :user_flag=>true)
      @result = UserMailer.delay(queue: "curator Upgrade", priority: 2, run_at: 10.seconds.from_now).curator_upgrade_info(@current_user)
    else
      @current_user.update_attributes(:user_plan => "free")
    end
    @to = current_user.email_address
    @user = current_user
    @provider_notify_plan = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='10' and p.user_id='#{current_user.user_id}' and p.notify_flag=true") if !current_user.nil? && !current_user.user_id.nil?
    if !@provider_notify_plan.nil? && @provider_notify_plan!="" && @provider_notify_plan.present?
      if current_user.user_flag==TRUE
        @result = UserMailer.delay(queue: "Free Downgrade", priority: 2, run_at: 10.seconds.from_now).free_downgrade_mail(@user,@to,@get_current_url)
      end 
      # @result = UserMailer.free_downgrade_mail(@user,@to,@get_current_url).deliver
    else
      #@result = UserMailer.free_downgrade_mail(@user,@to,@get_current_url).deliver
      if current_user.user_flag==TRUE
        @result = UserMailer.delay(queue: "Free Downgrade", priority: 2, run_at: 10.seconds.from_now).free_downgrade_mail(@user,@to,@get_current_url)
      end
    end
    #cotc for plan upgrade and downgrade
    #if (request.url == "http://www.famtivity.com/")
    #cotc_plan_update
    #end
    # render :text => "down"
    #redirect_to( :action =>"provider_plan")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: provider_plan }
    end
  end

  def down_sponcer
    @current_user = User.find(params[:id])
    @payment_detail = UserTransaction.find_by_user_id(current_user.user_id)
    @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id)  if !@payment_detail.nil?
    @card_number = @payment_profile.params["payment_profile"]['payment']['credit_card']['card_number'] if @payment_profile.success?  if !@payment_profile.nil?
    @old_plan = current_user.user_plan
    @get_current_url = request.env['HTTP_HOST'] 
    @current_user.update_attributes(:user_plan => "sponsor")
    @to = current_user.email_address
    @user = current_user
    @provider_notify_plan = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='10' and p.user_id='#{current_user.user_id}' and p.notify_flag=true") if !current_user.nil? && !current_user.user_id.nil?
    if !@provider_notify_plan.nil? && @provider_notify_plan!="" && @provider_notify_plan.present?
      if current_user.user_flag==TRUE
        @result = UserMailer.delay(queue: "Free Sponcer", priority: 2, run_at: 10.seconds.from_now).sponcor_downgrade_mail(@user,@to,@get_current_url)
      end
      #@result = UserMailer.sponcor_downgrade_mail(@user,params[:message],@to,params[:subject],@get_current_url,@old_plan,@card_number).deliver
    else
      if current_user.user_flag==TRUE
        @result = UserMailer.delay(queue: "Free Sponcer", priority: 2, run_at: 10.seconds.from_now).sponcor_downgrade_mail(@user,@to,@get_current_url)
      end
    end
    
    #redirect_to( :action =>"provider_plan")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: provider_plan }
    end
  end

  def up_sponcer
    
    customer_profile_information = {
      :profile     => {
        :merchant_customer_id => current_user.user_name ,
        :email => current_user.email_address
        #params[:email] params[:first_name]
      }
    }

    create_profile = CIMGATEWAY.create_customer_profile(customer_profile_information)
    if create_profile.success?
      billing_info = {
        :first_name => params[:first_name],
        :last_name => params[:last_name],
        :address => "#{params[:activity][:address_1]}" + "#{params[:activity][:address_2]}",
        :city => @city,
        :zip => @zip,
        :phone_number => @phone,
        :fax_number => @fax
      }

      credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name => params[:first_name],
        :last_name => params[:last_name],
        :number => "#{params[:cardnumber_1]}" + "#{params[:cardnumber_2]}" + "#{params[:cardnumber_3]}" + "#{params[:cardnumber_4]}",
        :month => params[:date_card],
        :year => params[:year_card_1],
        :verification_value => params[:cardnumber_5].to_i, #verification codes are now required
        :type => 'visa'
      )

      payment_profile = {
        :bill_to => billing_info,
        :payment => {
          :credit_card => credit_card
        }
      }

      options = {
        :customer_profile_id => create_profile.authorization,
        :payment_profile => payment_profile
      }

      pay_profile = CIMGATEWAY.create_customer_payment_profile(options)
      if pay_profile.success?
        @user_transaction = UserTransaction.new
        @user_transaction.customer_profile_id = create_profile.authorization
        @user_transaction.customer_payment_profile_id = pay_profile.params["customer_payment_profile_id"]
        @user_transaction.user_id = current_user.user_id
        @user_transaction.save
        @old_plan = current_user.user_plan
        @get_current_url = request.env['HTTP_HOST'] 
        @user = current_user
        @payment_detail = UserTransaction.find_by_user_id(current_user.user_id)
        @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id)  if !@payment_detail.nil?
        @card_number = @payment_profile.params["payment_profile"]['payment']['credit_card']['card_number'] if @payment_profile.success?  if !@payment_profile.nil?
        @to = current_user.email_address
        @name = current_user.user_name
        current_user.update_attributes(:user_plan => "sponsor")
        @provider_notify_plan = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='10' and p.user_id='#{current_user.user_id}' and p.notify_flag=true") if !current_user.nil? && !current_user.user_id.nil?
        if !@provider_notify_plan.nil? && @provider_notify_plan!="" && @provider_notify_plan.present?
          if current_user.user_flag==TRUE
            @result = UserMailer.delay(queue: "Sponcer Upgrade", priority: 2, run_at: 10.seconds.from_now).sponcor_upgrade_mail(@user,@to,@get_current_url)
          end
          #@result = UserMailer.sponcor_upgrade_mail(@user,params[:message],@name,@to,params[:subject],@get_current_url,@old_plan,@card_number).deliver
        else
          if current_user.user_flag==TRUE
            @result = UserMailer.delay(queue: "Sponcer Upgrade", priority: 2, run_at: 10.seconds.from_now).sponcor_upgrade_mail(@user,@to,@get_current_url)
          end
        end
        @trans_approve =  "Success! You have been upgraded to the Sponsor plan!"
        # render :partial=>'provider_sponsor_thank'
      end
    else
      @trans_approve =  "Sorry!!"
      #render :partial=>'provider_sponsor_thank'
      #puts "Error: {pay_profile.message}" 
    end

    render :partial=>'provider_sponsor_thank'
    #redirect_to( :action =>"provider_plan") 
  end

  #upgrade to sell plan
  def up_sell
    @user = current_user
    if !@user.nil?
      if !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="bankinfo"
        @user_bank = UserBankDetail.new
        @user_bank.bank_name = params[:bank_name]
        @user_bank.bank_wire_transfer = params[:w_transfer]
        @user_bank.bank_account_name = params[:account_name]
        @user_bank.bank_account_number = params[:acc_number]
        @user_bank.bank_swift_code = params[:swift_code]
        @user_bank.bank_state = params[:bank_state]
        @user_bank.bank_city = params[:bank_city]
        @user_bank.bank_zip_code = params[:bank_z_code]
        @user_bank.supplier_code = params[:s_code]
        @user_bank.legal_name = params[:l_name]
        @user_bank.tax_code = params[:t_code]
        @user_bank.street_address = params[:street_bank_code] if params[:street_bank_code] != "Enter street number & street address"
        #~ @user_bank.street_number = params[:number_bank_code]
        @user_bank.perm_state = params[:state_reg]
        @user_bank.prem_city = params[:city_reg]
        @user_bank.prem_zip_code = params[:z_code]
        @user_bank.user_id = current_user.user_id
        @user_bank.save
      elsif !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="check"
        @user_bank = UserBankDetail.new
        @user_bank.user_id = current_user.user_id
        @user_bank.payee_name = params[:paye_name]
        @user_bank.business_name = params[:business_name]
        @user_bank.street_address = params[:street_check_code] if params[:street_check_code] != "Enter street number & street address"
        @user_bank.bank_state = params[:bank_state]
        @user_bank.bank_city = params[:check_bank_city]
        @user_bank.bank_zip_code = params[:check_z_code]
        @user_bank.bank_country = params[:bank_country]
        @user_bank.save
      end
      
      @old_plan = current_user.user_plan
      @get_current_url = request.env['HTTP_HOST'] 
      @user = current_user
      @to = current_user.email_address
      @name = current_user.user_name
      if !@user.nil? && !@user.user_plan.nil? && @user.user_plan.downcase == "curator"
	      #send a mail to admin about the changes
	      @pro_status = 'curator'
	      @result = UserMailer.delay(queue: "curator Upgrade", priority: 2, run_at: 10.seconds.from_now).curator_upgrade_info(@user)
        @user.update_attributes(:user_plan => "sell", :user_flag=>true)
      else
	      @pro_status = ''
        @user.update_attributes(:user_plan => "sell")
      end
	
	
      if !@user.nil? && @user.user_transaction.nil?
        #authorize net started by rajkumar
        customer_profile_information = {
          :profile     => {
            :merchant_customer_id => params[:CardholderFirstName],
            :email => @user.email_address
          }
        }
        create_profile = CIMGATEWAY.create_customer_profile(customer_profile_information)

        if !create_profile.nil? && create_profile.success? #check the profile
          billing_info = {
            :first_name => params[:CardholderFirstName],
            :last_name => params[:CardholderLastName]
          }
          #get the credit card details
          credit_card = ActiveMerchant::Billing::CreditCard.new(
            :first_name => params[:CardholderFirstName],
            :last_name => params[:CardholderLastName],
            :number => "#{params[:cardnumber_1]}" + "#{params[:cardnumber_2]}" + "#{params[:cardnumber_3]}" + "#{params[:cardnumber_4]}",
            :month => params[:date_card].to_i,
            :year => params[:year_card_1].to_i,
            :verification_value => params[:cardnumber_5].to_i, #verification codes are now required
            :type => 'visa'
          )

          payment_profile = {
            :bill_to => billing_info,
            :payment => {
              :credit_card => credit_card
            }
          }

          options = {
            :customer_profile_id => create_profile.authorization,
            :payment_profile => payment_profile
          }
          #create the customer payment profile for registered user
          pay_profile = CIMGATEWAY.create_customer_payment_profile(options)
          if !pay_profile.nil? && pay_profile.success?
            @user_transaction = UserTransaction.new
            @user_transaction.customer_profile_id = create_profile.authorization
            @user_transaction.customer_payment_profile_id = pay_profile.params["customer_payment_profile_id"]
            @user_transaction.user_id = @user.user_id
            @user_transaction.inserted_date = Time.now
            @user_transaction.save
            @u_success=true
          else
            @u_success=false
          end
        else #create profile else part
          @u_success=false
          @failer_message = create_profile.message if !create_profile.nil?
        end  #create profile ending
        #authorize net end
      end #user transaction end
	
      @provider_notify_plan = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='10' and p.user_id='#{current_user.user_id}' and p.notify_flag=true") if !current_user.nil? && !current_user.user_id.nil?
      if !@provider_notify_plan.nil? && @provider_notify_plan!="" && @provider_notify_plan.present?
        if current_user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Sell Upgrade", priority: 2, run_at: 10.seconds.from_now).sell_upgrade_mail(@user,@to,@get_current_url,@pro_status)
        end
        #@result = UserMailer.sell_upgrade_mail(@user,params[:message],@to,params[:subject],@get_current_url,@old_plan,@card_number).deliver
      else
        if current_user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Sell Upgrade", priority: 2, run_at: 10.seconds.from_now).sell_upgrade_mail(@user,@to,@get_current_url,@pro_status)
        end
      end
      @trans_approve =  "Success! You have been upgraded to the Sell Through plan!"
      render :partial=>'provider_sell_thank'
    end
  end
  #upgrade to sell plan ending

  #upgrade to sell plan


  #upgrade curator user to market plan
  def up_curator
    @user = current_user
    if !@user.nil?
      @get_current_url = request.env['HTTP_HOST'] 
      @to = current_user.email_address
      @name = current_user.user_name
      if !@user.nil? && !@user.user_plan.nil? && @user.user_plan.downcase == "curator"
	      #send a mail to admin about the changes
	      @result = UserMailer.delay(queue: "curator Upgrade", priority: 2, run_at: 10.seconds.from_now).curator_upgrade_info(@user)
        @user.update_attributes(:user_plan => "free", :user_flag=>true)
      else
        @user.update_attributes(:user_plan => "free")
      end
	
      if !@user.nil? && @user.user_transaction.nil?
        #authorize net started by rajkumar
        customer_profile_information = {
          :profile     => {
            :merchant_customer_id => params[:sell_CardholderFirstName] ,
            :email => current_user.email_address
          }
        }
        create_profile = CIMGATEWAY.create_customer_profile(customer_profile_information)

        if !create_profile.nil? && create_profile.success? #check the profile
          billing_info = {
            :first_name => params[:sell_CardholderFirstName],
            :last_name => params[:sell_CardholderLastName]
          }
          #get the credit card details
          credit_card = ActiveMerchant::Billing::CreditCard.new(
            :first_name => params[:sell_CardholderFirstName],
            :last_name => params[:sell_CardholderLastName],
            :number => "#{params[:sell_cardnumber_1]}" + "#{params[:sell_cardnumber_2]}" + "#{params[:sell_cardnumber_3]}" + "#{params[:sell_cardnumber_4]}",
            :month => params[:sell_date_card].to_i,
            :year => params[:sell_year_card_1].to_i,
            :verification_value => params[:sell_cardnumber_5].to_i, #verification codes are now required
            :type => "#{params[:sell_chkout_card]}"
          )

          payment_profile = {
            :bill_to => billing_info,
            :payment => {
              :credit_card => credit_card
            }
          }

          options = {
            :customer_profile_id => create_profile.authorization,
            :payment_profile => payment_profile
          }
          #create the customer payment profile for registered user
          pay_profile = CIMGATEWAY.create_customer_payment_profile(options)
          if !pay_profile.nil? && pay_profile.success?
            @user_transaction = UserTransaction.new
            @user_transaction.customer_profile_id = create_profile.authorization
            @user_transaction.customer_payment_profile_id = pay_profile.params["customer_payment_profile_id"]
            @user_transaction.user_id = current_user.user_id if current_user.present?
            @user_transaction.inserted_date = Time.now
            @user_transaction.save
            @u_success=true
          else
            @u_success=false
          end
        else #create profile else part
          @u_success=false
          @failer_message = create_profile.message if !create_profile.nil?
        end  #create profile ending
        #authorize net end
      end #transaction end
	
      @trans_approve =  "Success! You have been upgraded to the Market plan!"
      render :partial=>'provider_sell_thank'
    end
  end
  #upgrade curator user to market plan ending

  def up_sell_old

    customer_profile_information = {
      :profile     => {
        :merchant_customer_id => current_user.user_name ,
        :email => current_user.email_address
      }
    }
    @user_bank = UserBankDetail.new
    @user_bank.bank_name = params[:bank_name]
    @user_bank.bank_wire_transfer = params[:w_transfer]
    @user_bank.bank_clear_house = params[:c_house]
    @user_bank.bank_account_number = params[:acc_number]
    @user_bank.bank_swift_code = params[:swift_code]
    @user_bank.bank_state = params[:street_bank_code]
    @user_bank.bank_city = params[:number_bank_code]
    @user_bank.bank_zip_code = params[:bank_z_code]
    @user_bank.supplier_code = params[:s_code]
    @user_bank.legal_name = params[:l_name]
    @user_bank.tax_code = params[:t_code]
    @user_bank.street_address = params[:street_reg]
    @user_bank.street_number = params[:number_reg]
    @user_bank.perm_state = params[:state_reg]
    @user_bank.prem_city = params[:city_reg]
    @user_bank.prem_zip_code = params[:z_code]
    @user_bank.user_id = current_user.user_id
    @user_bank.save

    create_profile = CIMGATEWAY.create_customer_profile(customer_profile_information)
    if create_profile.success?
      billing_info = {
        :first_name => params[:first_name],
        :last_name => params[:last_name],
        :address => "#{params[:activity][:address_1]}" + "#{params[:activity][:address_2]}",
        :city => @city,
        :zip => @zip,
        :phone_number => @phone,
        :fax_number => @fax
      }

      credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name => params[:first_name],
        :last_name => params[:last_name],
        :number => "#{params[:cardnumber_1]}" + "#{params[:cardnumber_2]}" + "#{params[:cardnumber_3]}" + "#{params[:cardnumber_4]}",
        :month => params[:date_card],
        :year => params[:year_card_1],
        :verification_value => params[:cardnumber_5].to_i, #verification codes are now required
        :type => 'visa'
      )

      payment_profile = {
        :bill_to => billing_info,
        :payment => {
          :credit_card => credit_card
        }
      }

      options = {
        :customer_profile_id => create_profile.authorization,
        :payment_profile => payment_profile
      }
      pay_profile = CIMGATEWAY.create_customer_payment_profile(options)
      if pay_profile.success?
        @user_transaction = UserTransaction.new
        @user_transaction.customer_profile_id = create_profile.authorization
        @user_transaction.customer_payment_profile_id=pay_profile.params["customer_payment_profile_id"]
        @user_transaction.user_id = current_user.user_id
        @user_transaction.save
        @old_plan = current_user.user_plan
        @get_current_url = request.env['HTTP_HOST'] 
        @user = current_user
        @payment_detail = UserTransaction.find_by_user_id(current_user.user_id)
        @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id)  if !@payment_detail.nil?
        @card_number = @payment_profile.params["payment_profile"]['payment']['credit_card']['card_number'] if @payment_profile.success?  if !@payment_profile.nil?
        @to = current_user.email_address
        @name = current_user.user_name
        current_user.update_attributes(:user_plan => "sell")
        @provider_notify_plan = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='10' and p.user_id='#{current_user.user_id}' and p.notify_flag=true") if !current_user.nil? && !current_user.user_id.nil?
        if !@provider_notify_plan.nil? && @provider_notify_plan!="" && @provider_notify_plan.present?
          if current_user.user_flag==TRUE
            @result = UserMailer.delay(queue: "Sell Upgrade", priority: 2, run_at: 10.seconds.from_now).sell_upgrade_mail(@user,@to,@get_current_url)
          end
          #@result = UserMailer.sell_upgrade_mail(@user,params[:message],@to,params[:subject],@get_current_url,@old_plan,@card_number).deliver
        else
          if current_user.user_flag==TRUE
            @result = UserMailer.delay(queue: "Sell Upgrade", priority: 2, run_at: 10.seconds.from_now).sell_upgrade_mail(@user,@to,@get_current_url)
          end
        end 
        @trans_approve =  "Success! You have been upgraded to the Sell Through plan!"
      end
    else
      #puts "Error: {response.message}"
      @trans_approve =  "Sorry!!"
    end
    render :partial=>'provider_sell_thank'

    #   redirect_to( :action =>"provider_plan")
  end

  def update_profile
    @user =current_user
    #@user=User.find_by_user_id(current_user.user_id) params[:category_id], params[:location_id]
    @birthdate=params[:user]["birthdate(1i)"]+"-"+params[:user]["birthdate(2i)"]+"-"+params[:user]["birthdate(3i)"]
    current_user.birthdate=@birthdate.to_s
    current_user.zipcode =params[:user][:zipcode]
    
    if current_user.update_attributes(params[:user])
     
      flash[:notice] ="Your Profile Is Updated"
      redirect_to edit_profile_path
    else
      flash[:notice] ="Profile is Not created"
      render :action =>"edit_profile"
    end
  end

  def provider_update_profile
    #@user_profile = UserProfile.find_by_user_id(params[:user_id])
    @user =User.find_by_user_id(current_user.user_id)
    #update the contact name in edit profiles
    if @user && @user.present?
	if params[:contact_name] == "Enter Contact Name"
		@user.update_attributes(:user_name=>"")
	else
		@user.update_attributes(:user_name=>params[:contact_name])
	end
   end
    @user_profile = current_user.user_profile
    params[:profile_email]
    if params[:photo] !=""
      @user_profile.update_attributes(:profile =>params[:my_image])
      #@user_profile.update_attributes(:logo =>params[:my_image])
    end
    if @user_profile 
      #@user.update_attributes(:email_address => params[:profile_email])
      #@user_profile.update_attributes(:currency => params[:b_currency], :date_format => params[:profile_date_edit], :business_language => params[:language_edit], :business_name => params[:business_name], :owner_first_name=> params[:owner_first_name], :owner_last_name=> params[:owner_last_name],:first_name=> params[:admin_first_name], :last_name=> params[:admin_last_name], :phone=> params[:profile_phone], :mobile=> params[:profile_mobile], :fax=> params[:profile_fax], :website=> params[:profile_web] , :time_zone=> params[:Time_zone_edit], :address_1=> params[:profile_Add1], :address_2=> params[:profile_Add2], :city=> params[:city_edit_profile], :state=> params[:state_edit_profile], :country=> params[:country_edit_profile], :zip_code=> params[:profile_zipcode] )
      #@user_profile.currency = params[:b_currency]
      #@user_profile.date_format = params[:b_currency]
      @user_profile.card = params[:card_image] if !params[:card_image].nil? && params[:card_image]!=""
      @user_profile.description = params[:p_description].strip if params[:p_description] != "Description should not exceed 1000 characters" && params[:p_description] !=""
      @user_profile.business_language = params[:language_edit]
      @user_profile.business_name = params[:business_name]
      #Tags
      @user_profile.tags_txt = params["provider-tag-txt"].blank? ? "" : params["provider-tag-txt"]
      params[:tags_txt] = params["provider-tag-txt"].blank? ? "" : params["provider-tag-txt"]
      #Category and Sub Category
      @user_profile.category = params["user_profile"]["category"].blank? ? "" : params["user_profile"]["category"]
      @user_profile.sub_category = params["user_profile"]["sub_category"].blank? ? "" : params["user_profile"]["sub_category"]
     
      if params[:owner_first_name] == "First Name"
        @user_profile.owner_first_name = ""
      else
        @user_profile.owner_first_name = params[:owner_first_name]
      end
      if params[:owner_last_name] == "Last Name"
        @user_profile.owner_last_name = ""
      else
        @user_profile.owner_last_name = params[:owner_last_name]
      end
      if params[:admin_first_name] == "First Name"
        @user_profile.first_name = ""
      else
        @user_profile.first_name = params[:admin_first_name]
      end
      if params[:admin_last_name] == "Last Name"
        @user_profile.last_name = ""
      else
        @user_profile.last_name = params[:admin_last_name]
      end
      @phone_value = "#{params[:profile_phone_1]}-" +"#{params[:profile_phone_2]}-"+"#{params[:profile_phone_3]}"
      if @phone_value == "xxx-xxx-xxxx"  
        @user_profile.phone =""
      else
        @user_profile.phone = @phone_value
      end
      #@user_profile.mobile = params[:profile_mobile]              if params[:profile_mobile] != "Enter Mobile Number" 
      #@user_profile.mobile = "#{params[:profile_contact_1]}-" +"#{params[:profile_contact_2]}-"+"#{params[:profile_contact_3]}"  if !params[:profile_contact_1].nil? && !params[:profile_contact_2].nil? && !params[:profile_contact_3].nil?
      @mobile_value = "#{params[:profile_contact_1]}-" +"#{params[:profile_contact_2]}-"+"#{params[:profile_contact_3]}"
      #@user_profile.mobile = @mobile_value if @mobile_value != "111-111-1111"
      if @mobile_value == "xxx-xxx-xxxx"  
        @user_profile.mobile =""
      else
        @user_profile.mobile =@mobile_value
      end
      if params[:profile_fax] == "Enter Fax Number"
        @user_profile.fax =""
      else
        @user_profile.fax =params[:profile_fax]
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
      @user_profile.time_zone = params[:Time_zone_edit]           
      @user_profile.city = params[:city_edit_profile]
      @user_profile.state = params[:state_edit_profile]
      @user_profile.country = params[:country_edit_profile]
      @user_profile.zip_code = params[:profile_zipcode]  
      @user_profile.save
      if !params[:city_edit_profile].nil? && params[:city_edit_profile]!=""
        city_se = City.where("city_name='#{params[:city_edit_profile]}'").last
        if !city_se.nil?
          @user.latitude  = city_se.latitude
          @user.longitude  = city_se.longitude
        end
      end
      @user.save
      #cotc for provider update
      # if (request.url == "http://www.famtivity.com/")
      cotc_for_provider_update
      # end
      redirect_to( :action =>"provider_profile")
      #provider notification settings added.
      @provider_notify_profile = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='7' and p.user_id='#{current_user.user_id}' and p.notify_flag=true") if !current_user.nil? && !current_user.user_id.nil?
      if @provider_notify_profile.present? && @provider_notify_profile!="" && !@provider_notify_profile.nil?
        #sending a mail while editing the activity by the provider
        user=User.find_by_user_id(current_user.user_id) if !current_user.nil?
        attend_email=user.email_address if !user.email_address.nil?
        @get_current_url = request.env['HTTP_HOST']
        if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Provider Update", priority: 2, run_at: 10.seconds.from_now).provider_edit_profile_mail(user,@get_current_url,attend_email,params[:subject])
       end
      end #if loop end for provider mail
    else
      render :action =>"provider_edit_profile"
      #redirect_to( :action =>"provider_profile")
    end
  end

  
  def parent_profile
     
    @pro = params[:pro]
    @user_profile = current_user.user_profile
    @user_category = ActivityRow.where('user_id = ?', current_user.user_id)
    @user =User.find_by_user_id(current_user.user_id)
    @participants = Participant.where('user_id = ?', current_user.user_id)
    @agerangecolors = UserChild.where('user_id = ?', current_user.user_id)

  end
  
  def parent_update_profile 
    @agerangecolors = UserChild.where('user_id = ?', current_user.user_id)
    if current_user.participant
      @part_count = current_user.participant.length
    else 
      @part_count == "0"
    end

    # @agerangecolors = ParticipantAgerangeColor.where('user_id = ?', current_user.user_id)
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
      #@user.update_attributes( :email_address => params[:profile_email])
      dob = "#{params[:"year_profile_1"]}-#{params[:"month_edit"]}-#{params[:"day_edit"]}"
      #@user_profile.dob = dob
      #@user_profile.update_attributes(params[:"dob"]) if !@user_profile.dob.nil?
      #@user_profile.update_attributes(:dob =>dob,  :business_language => params[:language_edit], :mobile => params[:profile_contact], :first_name=> params[:profile_first_name], :last_name=> params[:profile_first_name], :gender=> params[:gender_edit], :website=> params[:profile_web] , :time_zone=> params[:Time_zone_edit],  :address_1=> params[:profile_Add1], :address_2=> params[:profile_Add2], :city=> params[:city_edit_profile], :state=> params[:state_edit_profile], :country=> params[:country_edit_profile], :zip_code=> params[:profile_zipcode] )
      @user_profile.dob = dob
      @user_profile.business_language = params[:language_edit] if params[:language_edit] != "Select"
      if !params[:profile_contact_1].nil? && params[:profile_contact_1].present? && !params[:profile_contact_2].nil? && params[:profile_contact_2].present? &&!params[:profile_contact_3].nil? && params[:profile_contact_3].present?
        @mobile_value = "#{params[:profile_contact_1]}-" +"#{params[:profile_contact_2]}-"+"#{params[:profile_contact_3]}"
        if @mobile_value == "xxx-xxx-xxxx"
          @user_profile.mobile =""
        else
          @user_profile.mobile = @mobile_value
        end
        #@user_profile.mobile = @mobile_value if @mobile_value != "111-111-1111"
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
      #@user_profile.mobile = "#{params[:profile_contact_1]}-" +"#{params[:profile_contact_2]}-"+"#{params[:profile_contact_3]}"  if !params[:profile_contact_1] != "111" && !params[:profile_contact_2] != "111" && !params[:profile_contact_3]  != "1111"
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
              #@old_part =ParticipantAgerangeColor.find_by_age_range_and_user_id(params[:"age_edit_arr_#{s}"], current_user.user_id).color_id
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
          #@participant = Participant.find(s)
          #pdate = "#{params[:"year_#{@participant.participant_id}"]}-#{params[:"month_#{@participant.participant_id}"]}-#{params[:"day_#{@participant.participant_id}"]}"
          #@participant.participant_birth_date = pdate
          #@participant.update_attributes(params[:"pdate"]) if !@participant.participant_birth_date.nil?
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
            # st_time = DateTime.parse("#{params[:"day_#{s}"]} #{params[:"month_#{s}"]} #{params[:"year_#{s}"]}").strftime("%H:%M:%S")
            #st_time = "#{params[:"day_#{s}"]}-#{params[:"month_#{s}"]}-#{params[:"year_#{s}"]}"
            @participant.participant_name = params[:"participant_name_#{s}"]
            @participant.participant_gender = params[:"gender_#{s}"]
            @participant.participant_age = params[:"age_#{s}"]
            #@participant.participant_birth_date = st_time
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
      # redirect_to( :action =>"edit_success")
      redirect_to( :action =>"parent_profile")
    else
      render :action =>"parent_update_profile"
    end
  end

  def provider_profile
    
    @pro = params[:pro]
    @user_profile = current_user.user_profile
    @user =User.find_by_user_id(current_user.user_id)
    #@user_profile = UserProfile.find(params[:id])
    #@user = (params[:id]) ? User.find_by_id(params[:id]) : @current_user
  end


  def participant_destroy
    #@participant = Participant.where('id', params[:id]) unless params[:id].nil?
    @participant = Participant.find(params[:id])
    @participant.destroy
    respond_to do |format|
      #format.html { redirect_to profile_path(@profile) }
      format.js { render :nothing => true }
    end
    
  end
  def agecolor_destroy
    @agerangecolor = UserChild.find(params[:id])
    @agerangecolor.destroy

    respond_to do |format|
      #format.html { redirect_to profile_path(@profile) }
      format.js { render :nothing => true }
    end
    
  end
  def participant_edit
    @participant = Participant.find(params[:id])
    @participant.update_attributes(params[:participant])
    #render :action =>"parent_update_profile"
    #redirect_to :back

  end

  
  # GET /user_profiles/1
  # GET /user_profiles/1.json
  def show
    @user_profile = UserProfile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_profile }
    end
  end

  # GET /user_profiles/new
  # GET /user_profiles/new.json
  def new
    @user_profile = UserProfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_profile }
    end
  end

  # GET /user_profiles/1/edit
  def edit
    @user_profile = UserProfile.find(params[:id])
  end

  # POST /user_profiles
  # POST /user_profiles.json
  def create
    @user_profile = UserProfile.new(params[:user_profile])

    respond_to do |format|
      if @user_profile.save
        format.html { redirect_to @user_profile, notice: 'User profile was successfully created.' }
        format.json { render json: @user_profile, status: :created, location: @user_profile }
      else
        format.html { render action: "new" }
        format.json { render json: @user_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_profiles/1
  # PUT /user_profiles/1.json
  def update
    @user_profile = UserProfile.find(params[:id])

    respond_to do |format|
      if @user_profile.update_attributes(params[:user_profile])
        format.html { redirect_to @user_profile, notice: 'User profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_profiles/1
  # DELETE /user_profiles/1.json
  #  gateway = ActiveMerchant::Billing::Base.gateway(:authorized_net.new(
  #       :login => '3Rp74CQw2P',         #API Login ID
  #      :password => '88Br2z8z6JuSY4QJ'))

  def destroy
    @user_profile = UserProfile.find(params[:id])
    @user_profile.destroy

    respond_to do |format|
      format.html { redirect_to user_profiles_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  #Cotc provider update
  def cotc_for_provider_update	  
    url ="http://campaignonthecloud.com/Update_Registration_Status.aspx?name=#{@user.user_name}&mobile=#{@phone_value}&email_id=#{@user.email_address}&country=#{params[:country_edit_profile]}&address=#{params[:profile_Add1]}&city=#{params[:city_edit_profile]}&businessname=#{params[:business_name]}&zipcode=#{params[:profile_zipcode]}&domain_name=#{$domain_name}&planname=#{@user.user_plan}&action=1"
   uri = URI.parse(URI.encode(url.strip))
    http = Net::HTTP.new(uri.host, uri.port)
    request_cotc = Net::HTTP::Get.new(uri.request_uri)
    begin
      response = http.request(request_cotc)
    rescue Exception => exc
      logger.error("Message for the log file #{exc.message}")
      flash[:notice] = "Store error message"
    end
  end	  

  #Cotc plan update
  def cotc_plan_update
    if (@user.user_plan == "curator")
      url ="http://www.campaignonthecloud.com/UpdatedRegistrationActivation.aspx?email_id=#{@user.email_address}&domain_name=#{$domain_name}&planname=Curator"
    end
    if (@user.user_plan == "free")
      url ="http://www.campaignonthecloud.com/UpdatedRegistrationActivation.aspx?email_id=#{@user.email_address}&domain_name=#{$domain_name}&planname=Basic%20Market%20Plan"
    end
    if (@user.user_plan == "sell")
      url ="http://www.campaignonthecloud.com/UpdatedRegistrationActivation.aspx?email_id=#{@user.email_address}&domain_name=#{$domain_name}&planname=Sell-Through%20Plan"
    end
    uri = URI.parse(URI.encode(url.strip))
    http = Net::HTTP.new(uri.host, uri.port)
    request_cotc = Net::HTTP::Get.new(uri.request_uri)
    begin
      response = http.request(request_cotc)
    rescue Exception => exc
      logger.error("Message for the log file #{exc.message}")
      flash[:notice] = "Store error message"
    end
  end

   def activate_user_upgrade(user)
    @act_all = Activity.where("user_id = ?",user.user_id) if !user.nil? && user!=""
	!@act_all.nil? && @act_all.present? && @act_all.each do |act|
	act.update_attributes(:active_status=>"Active")
	end
    #~ @act_all.update_all(:active_status=>"Active")
    
  end # calling this method for activate the account while upgrading.

   def current_account_activate(user,userplan,ptype)
	if !user.manage_plan.nil? && user.manage_plan.present?
		if !userplan.nil? && userplan!="" && (ptype == "account" || ptype == "downgrade")
			if user.manage_plan.downcase == "market_sell"
				amnt = 29.95
				nplan = "Market Sell Plan"
				sales_pro_limit = 25
				plan_amount_tot = 29.95
			elsif user.manage_plan.downcase == "market_sell_manage"
				amnt = 29.95
				nplan = "Market Sell Plan"
				sales_pro_limit = 25
				plan_amount_tot = 29.95
			elsif user.manage_plan.downcase == "market_sell_manage_plus"
				amnt = 29.95
				nplan = "Market Sell Plan"
				sales_pro_limit = 25
				plan_amount_tot = 29.95
			end
			amnt1=amnt.round(2)  if !amnt.nil?
			if !user.user_transaction.nil? && !user.user_transaction.customer_profile_id.nil? && !user.user_transaction.customer_payment_profile_id.nil?
				@payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>user.user_transaction.customer_profile_id,:customer_payment_profile_id=>user.user_transaction.customer_payment_profile_id)
				transaction =
				{:transaction => {
				:type => :auth_capture,
				:amount => "#{amnt1}", #amount for the users
				:customer_profile_id => user.user_transaction.customer_profile_id,
				:customer_payment_profile_id => user.user_transaction.customer_payment_profile_id
				}
				}
				 #create the transaction for the user
				response_pr = CIMGATEWAY.create_customer_profile_transaction(transaction)
				if !response_pr.nil? && response_pr.success?
					provider_trans_id = "#{response_pr.authorization}" if !response_pr.nil? && !response_pr.authorization.nil?
					#get the user transaction information
					utran= UserTransaction.where("user_id=?",user.user_id).last if !user.nil?
					if !ptype.nil? && ptype!="" && ptype == "account"
						#~ uplan = user.manage_plan
						uplan = "market_sell"
						user.update_attributes(:user_status=>'activate',:manage_plan=>"market_sell", :show_card=>true)						
						@act_all = Activity.where("user_id = ? and lower(active_status) = ?",user.user_id,"deactivate") if !user.nil?
						#~ if !@act_all.nil? && @act_all.present?						
							#~ @act_all.update_all(:active_status=>"Active")						
						#~ end 
						!@act_all.nil? && @act_all.present? && @act_all.each do |act|
						act.update_attributes(:active_status=>"Active")
						end
						
					else
						#~ uplan = userplan
						uplan = "market_sell"
						user.update_attributes(:manage_plan=>"market_sell")	
					end
					#store to the transaction details#
					@p_trans = ProviderTransaction.create(:user_id=>user.user_id, :action_type=>"activate-renewal", :amount=>amnt, :user_plan=>uplan, :customer_profile_id=>utran.customer_profile_id, :customer_payment_profile_id=>utran.customer_payment_profile_id, :inserted_date=>Time.now, :modified_date=>Time.now, :start_date=>Time.now, :end_date=>Time.now+30.days, :grace_period_date=>Time.now+37.days, :sales_limit=>sales_pro_limit, :purchase_limit=>0, :expiry_status=>true, :payment_date=>Time.now, :plan_amount=>plan_amount_tot, :email_address=>user.email_address, :transaction_id=>provider_trans_id) if !user.nil? && !amnt.nil? && !utran.nil?
					UserMailer.delay(queue: "User renewaling Transaction", priority: 1, run_at: 10.seconds.from_now).register_user_transaction(user,amnt)
					@response_status = true
				else
					@response_status=false
				end	 #res ending
			else
				@response_status=false
			end #trans ending
		else
			@response_status=false
		end #uplan ending
	else
		@response_status=false
	end #mplan ending
	
	return @response_status
        
  end #current account activate ending here.

end
