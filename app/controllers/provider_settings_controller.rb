class ProviderSettingsController < ApplicationController
layout nil
layout "provider_layout"
before_filter :authenticate_user
include ActionView::Helpers::NumberHelper
include UserTransactionsHelper
include ActionView::Helpers::TextHelper
require 'active_merchant'
require 'zip/zip'
require 'zip/zipfilesystem'
require 'date'
require 'time'
require 'will_paginate/array'
require 'fastimage'#this gem for fetching the images.
include ActivitiesHelper
	
#provider setting new changes
  def provider_settings
    #provider setting started
    #~ @setting_name=ProviderSettingDetail.find(:all, :order=>"provider_setting_id asc")
    @setting_name=ProviderSettingDetail.where("lower(setting_status)=?",'active').order("provider_setting_id asc")
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
  
  ############################provider profile starting###################################################
  
  def provider_profile
    @pro = params[:pro]
    @user_profile = current_user.user_profile
    @user =User.find_by_user_id(current_user.user_id)
  end
  
   def provider_edit_profile
    @user_profile = current_user.user_profile
    @user = User.find_by_user_id(current_user.user_id)
    @tags_text = @user_profile.tags_txt.split(",") if !@user_profile.nil? && !@user_profile.tags_txt.nil?
    render :layout=>"application"
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
    end
    if @user_profile 
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
      @mobile_value = "#{params[:profile_contact_1]}-" +"#{params[:profile_contact_2]}-"+"#{params[:profile_contact_3]}"

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
  ############################provider profile ending###################################################
  
  ###########################credit card details starting#####################################
  #displayed the credit card information details for the card holders
  def payment_setup
    @payment_detail = UserTransaction.find_by_user_id(current_user.user_id)
    @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id)  if !@payment_detail.nil?
  end
  
  #get credit card information for edit the card details
  def get_credit_card_info
	@payment_detail = UserTransaction.find_by_user_id(current_user.user_id)
	@payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id)  if !@payment_detail.nil?
  end #method ending

  #updating cc form
  def update_credit_card_info
	  #checked the table
	  @payment_detail = UserTransaction.find_by_user_id(current_user.user_id)  if !current_user.nil?
	   
	   if !@payment_detail.nil? && @payment_detail.present?
		   
	    billing_info = {
	      :first_name => params[:sell_CardholderFirstName]
	
		}  
	   #get the data from authorize.net
	   @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id) if !@payment_detail.nil?
	      
	      credit_card = ActiveMerchant::Billing::CreditCard.new(
		:first_name => params[:sell_CardholderFirstName],
		#:last_name => params[:sell_CardholderLastName],
		:number => "#{params[:sell_cardnumber_1]}" + "#{params[:sell_cardnumber_2]}" + "#{params[:sell_cardnumber_3]}" + "#{params[:sell_cardnumber_4]}",
		:month => params[:sell_date_card].to_i,
		:year => params[:sell_year_card_1].to_i,
		:verification_value => params[:sell_cardnumber_5], #verification codes are now required
		#:type => 'visa'
		:type => "#{params[:sell_chkout_card]}"
		)
	      
	  if !@payment_detail.nil?
		payment_profile = {
		:customer_payment_profile_id => @payment_detail.customer_payment_profile_id,
		:bill_to => billing_info,
		:payment => {
		:credit_card => credit_card
		}
          }	

      options = {
        :customer_profile_id => @payment_detail.customer_profile_id,
        :payment_profile => payment_profile
      }
      
	      if @payment_profile.success?
		@payment_update =  CIMGATEWAY.update_customer_payment_profile(options)
		@tran_val = "success"
	     else
		@tran_val = "failure"  
	     end if !@payment_profile.nil?
	
      end # payment detail loop end
      
      else #payment details empty 
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
		:type => "#{params[:sell_chkout_card]}"
		)
		
		 payment_profile = {
		:bill_to => billing_info,
		:payment => {
		:credit_card => credit_card
				}
			}
			
       #customer id added for the user
       if !params[:sell_CardholderFirstName].nil? && params[:sell_CardholderFirstName]!=''
		@cholder_fname = params[:sell_CardholderFirstName]+"#{Time.now.strftime("%S")}"
	else
		@cholder_fname ="#{Time.now.strftime("%S")}"
	end
      customer_profile_information = {
        :profile     => {
          :merchant_customer_id => @cholder_fname,
          :email => current_user.email_address
        }
      }
      create_profile = CIMGATEWAY.create_customer_profile(customer_profile_information)
      
      if create_profile.success?
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
			@user_transaction.inserted_date = Time.now
			@user_transaction.save
			@tran_val = "success"
		else
			  #~ puts "Error: #{pay_profile.message}"
			  if !pay_profile.nil? && !pay_profile.message.nil?
				@tran_val = "#{pay_profile.message}"  
			  else
				@tran_val = "failure"  
			  end
		end #payment end
      else
        #~ puts "Error: #{create_profile.message}"
		if !create_profile.nil? && !create_profile.message.nil?
			@tran_val = "#{create_profile.message}"  
		else
			@tran_val = "failure"  
		end
      end #create profile loop end
		
      end #payment details loop end
    
    respond_to do |format|
	      format.js#{render :text => "$('.loadingmessage').hide();$('#success_creditcard_info').bPopup({fadeSpeed:100,followSpeed:100,opacity:0.8,positionStyle: 'absolute',modalClose: false});"}
	end
	      
  end #method ending

 ########################################user plan report###################################################
  def plan_report
    @user_plan_r = ProviderTransaction.select("transaction_id,payment_date,user_plan,amount").where("user_id=?",current_user.user_id).order("id desc") if !current_user.nil?  
    if !@user_plan_r.nil? && @user_plan_r.present?
      @user_plan = @user_plan_r.paginate(:page => params[:page], :per_page =>10) 
      @usertot = @user_plan.length
    end
    respond_to do |format| 
      format.html
      format.csv #{ send_data csv_string }
      format.xls #{ send_data @transactions.to_csv(col_sep: "\t") }
      format.js
    end
  end
 ########################################method end###########################################################

 ########################################user transaction report###################################################
  def transaction
    @get_current_url = request.env['HTTP_HOST']
    if !current_user.nil?
      #reports filter for payment_date
      if !params[:act_name].nil? && params[:act_name].present? && !params[:trans_act].nil? && current_user.present?
        tran = TransactionDetail.find_by_sql("select act.*,tran.* from activities as act right join transaction_details as tran on act.activity_id = tran.activity_id left join school_representatives as rep on tran.activity_id=rep.activity_id where (act.user_id = #{current_user.user_id} or rep.vendor_id=#{current_user.user_id}) and act.activity_id = '#{params[:act_name]}' order by tran.trans_id desc")
      elsif !params[:date_from].nil? && !params[:date_to].nil? && params[:date_from].present? && params[:date_to].present? && current_user.present?
        tran = TransactionDetail.find_by_sql("select act.*,tran.* from activities as act right join transaction_details as tran on act.activity_id = tran.activity_id left join school_representatives as rep on tran.activity_id=rep.activity_id where (act.user_id = #{current_user.user_id} or rep.vendor_id=#{current_user.user_id}) and date(tran.payment_date) between '#{params[:date_from]}' and '#{params[:date_to]}' order by tran.trans_id desc")
      elsif !params[:date_from].nil? && params[:date_from].present?
        tran = TransactionDetail.find_by_sql(" select act.*,tran.* from activities as act right join transaction_details as tran on act.activity_id = tran.activity_id left join school_representatives as rep on tran.activity_id=rep.activity_id where (act.user_id = #{current_user.user_id} or rep.vendor_id=#{current_user.user_id}) and date(tran.payment_date) = '#{params[:date_from]}' order by tran.trans_id desc")
        #email metric activity stats list
      elsif !params[:activity_stats].nil? && params[:activity_stats].present? && current_user.present?
        activity_stats = Activity.find_by_sql("select a.activity_id,a.activity_name,a.discount_eligible from activities a left join school_representatives s on a.activity_id=s.activity_id where (user_id = #{current_user.user_id}  or vendor_id = #{current_user.user_id}) and lower(created_by)='provider' and (lower(active_status)='active' or lower(active_status)='inactive') order by a.activity_id desc") if !current_user.nil?
      else
        tran = TransactionDetail.find_by_sql(" select act.*,tran.* from activities as act right join transaction_details as tran on act.activity_id = tran.activity_id left join school_representatives as rep on tran.activity_id=rep.activity_id where (act.user_id = #{current_user.user_id} or rep.vendor_id=#{current_user.user_id}) order by tran.trans_id desc")
      end
      @activity_name = Activity.find_by_sql("select a.activity_id,a.activity_name from activities a left join school_representatives s on a.activity_id=s.activity_id where (user_id=#{current_user.user_id} or vendor_id=#{current_user.user_id}) and lower(active_status)='active' and cleaned=true order by activity_name asc") if !current_user.nil?
    end

    # provider activity stats list
    if !params[:activity_stats].nil? && params[:activity_stats].present? && current_user.present?
      @activity_stats = activity_stats
      @activity_stats = [] if activity_stats.nil?
      @activity_stats = activity_stats.paginate(:page => params[:page], :per_page =>10) if !activity_stats.nil? && activity_stats.present?
    else  #normal provider list 
      @trans = tran
      @transactions = [] if tran.nil?
      @transactions = tran.paginate(:page => params[:page], :per_page =>7) if !tran.nil? && tran.present?
    end

    @trans_group=[]
    if !@trans.nil? && @trans.length > 0 
      @trans.each do |tran|
          if !tran.transaction_id.nil? && tran.transaction_id.present? 
            tran_id = tran.transaction_id 
          else 
            tran_id = "-" 
          end
          if !tran.payment_date.nil? && tran.payment_date.present? 
            tran_date = tran.payment_date.strftime("%b %d, %Y") 
          else 
            tran_date = "-" 
          end
          if !tran.amount.nil? && tran.amount.present?
            tran_amt = tran.amount
          else 
            tran_amt = "-"
          end
          if !tran.activity_id.nil? && tran.activity_id.present? 
            tran_actid = tran.activity_id 
          else 
            tran_actid = "-" 
          end
          if !tran.activity_name.nil? && tran.activity_name.present?
            tran_actname = tran.activity_name
          else
            tran_actname = "-"
          end
          if !tran.customer_name.nil? && tran.customer_name.present?
            cus_name = tran.customer_name.gsub("\"", "").gsub("&#039;", "'").gsub("&#126;", "~").gsub("&#92;", "\\").gsub("undefined", "").gsub("&quot;","").gsub(",",";") 
          else 
            cus_name = "-"
          end
          if !tran.customer_phone.nil? && tran.customer_phone.present?
            cus_phone = tran.customer_phone.gsub("\"", "").gsub("&#039;", "'").gsub("&#126;", "~").gsub("&#92;", "\\").gsub("undefined", "").gsub("&quot;","").gsub(",",";") 
          else 
            cus_phone = "-" 
          end
          if !tran.customer_address.nil? && tran.customer_address.present? 
            cus_add = tran.customer_address.gsub("\"", "").gsub("&#039;", "'").gsub("&#126;", "~").gsub("&#92;", "\\").gsub("undefined", "").gsub("&quot;","").gsub(",",";").gsub("Address Line2;","") 
          else 
            cus_add = "-" 
          end
          if !tran.participant_name.nil? && tran.participant_name.present?
            partic = tran.participant_name.gsub("\"", "").gsub("&#039;", "'").gsub("&#126;", "~").gsub("&#92;", "\\").gsub("undefined", "").gsub("&quot;","").gsub(",",";") 
          else
            partic = "-" 
          end 
          if !tran.ticket_code.nil? && tran.ticket_code.present?
            tran_code = tran.ticket_code 
          else 
            tran_code = "-" 
          end
          if !tran.sale_price.nil? && tran.sale_price.present? 
            tran_sale = tran.sale_price
          else
            tran_sale = "-"
          end
          if !tran.nil? && !tran.discount.nil? && tran.discount!='' && tran.discount.present?
            tran_dist = tran.discount.to_s.gsub("\"", "").gsub("&#039;", "'").gsub("&#126;", "~").gsub("&#92;", "\\").gsub("undefined", "").gsub("&quot;","").gsub(",",";").gsub(""''"","") 
          else
            tran_dist="-"
          end
          if tran!='' && !tran.dd_price.nil? && tran.dd_price.present? 
            tran_dd = tran.dd_price.gsub("&quot;","")  
          else   
            tran_dd = '-'
          end
          fam_fee_amt = calculate_fam_fee(tran.amount)
          credit_card_fee = (fam_fee_amt && fam_fee_amt[2] && fam_fee_amt[2] > 0) ? fam_fee_amt[2] : '-'
          fam_fee = (fam_fee_amt && fam_fee_amt[0] && fam_fee_amt[0] > 0) ? fam_fee_amt[0] : '-'
          tot_amt = (fam_fee_amt && fam_fee_amt[1]) ? (fam_fee_amt[1]!='free' ? fam_fee_amt[1].round(2) : fam_fee_amt[1]) : tran.amount

          row = [ tran_id,tran_date,tran_actid, tran_actname, cus_name, cus_phone, cus_add, partic, tran_code, tran_sale, tran_dist, tran_dd, tran_amt, credit_card_fee, fam_fee, tot_amt] 
          @trans_group<<row  
      end
    end

    #displaying serial no for provider activity stats values
    if params[:page].nil?
      @page_sno = 1
    else
      @page_sno = params[:page]
    end

    respond_to do |format|
      format.html
      format.csv #{ send_data csv_string }
      format.xls #{ send_data @transactions.to_csv(col_sep: "\t") }
      format.js
    end
  end
 ########################################method end###########################################################

 
 ###########################bank details starting#####################################
   def bank_info
    if !current_user.nil? && current_user.present? && current_user!=''
      @bank_details = UserBankDetail.find_by_user_id(current_user.user_id)
    end
   end
   
   #update bank info
  def updatebank_info
    if !current_user.nil? && current_user.present? && current_user!=''
      if !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="bankinfo"
        @usr_bank_det = UserBankDetail.find_by_user_id(current_user.user_id)
        @bank_name = params[:bank_name] if !params[:bank_name].nil? && params[:bank_name]!="" && params[:bank_name]!="Name of bank"
        @act_name = params[:account_name] if !params[:account_name].nil? && params[:account_name]!="" && params[:account_name]!="Enter your account name"
        @w_transfer = params[:w_transfer] if !params[:w_transfer].nil? && params[:w_transfer]!="" && params[:w_transfer]!="Enter the routing number"
        @act_num = params[:acc_number] if !params[:acc_number].nil? && params[:acc_number]!="" && params[:acc_number]!="Enter your account number"
        #~ @strtno = params[:number_bank_code] if !params[:number_bank_code].nil? && params[:number_bank_code]!="" && params[:number_bank_code]!="Enter number"
        @srt_bank_code = params[:street_bank_code] if !params[:street_bank_code].nil? && params[:street_bank_code]!="" && params[:street_bank_code]!="Enter street number & street address"
        @bank_city = params[:bank_city] if !params[:bank_city].nil? && params[:bank_city]!=""
        @bank_state = params[:bank_state] if !params[:bank_state].nil? && params[:bank_state]!=""
        @bank_z_code = params[:bank_z_code] if !params[:bank_z_code].nil? && params[:bank_z_code]!="" && params[:bank_z_code]!="Enter zip code"
        if !@usr_bank_det.nil? && @usr_bank_det!="" && @usr_bank_det.present?
          @usr_bank_det.update_attributes(:bank_name=>@bank_name, :bank_wire_transfer=>@w_transfer, :bank_account_name=>@act_name, :bank_account_number=>@act_num, :bank_street_address=>@srt_bank_code, :bank_city=> @bank_city, :bank_state=>@bank_state, :bank_zip_code=>@bank_z_code, :user_id=>current_user.user_id, :prefered_mode=> "bank")
        else
          UserBankDetail.create(:bank_name=>@bank_name, :bank_wire_transfer=>@w_transfer, :bank_account_name=>@act_name, :bank_account_number=>@act_num, :bank_street_address=>@srt_bank_code, :bank_city=> @bank_city, :bank_state=>@bank_state, :bank_zip_code=>@bank_z_code, :user_id=>current_user.user_id, :prefered_mode=> "bank")
        end
      elsif !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="check"
        @usr_bank_det = UserBankDetail.find_by_user_id(current_user.user_id)
        @user_id = current_user.user_id
        @payee_name = params[:paye_name]
        @business_name = params[:business_name]
        @street_address =params[:street_check_code]  if !params[:street_check_code].nil? && params[:street_check_code]!="" && params[:street_check_code]!= "Enter street number & street address"
        @bank_state = params[:bank_state]
        @bank_city = params[:check_bank_city]
        @bank_zip_code = params[:check_z_code]
        @bank_country = params[:bank_country]
        if !@usr_bank_det.nil? && @usr_bank_det!="" && @usr_bank_det.present?
          @usr_bank_det.update_attributes(:check_country=>@bank_country, :user_id=>@user_id, :payee_name=>@payee_name, :business_name=>@business_name, :check_street_address=>@street_address, :check_city=> @bank_city, :check_state=>@bank_state, :check_zip_code=>@bank_zip_code, :prefered_mode => "check")
        else
          UserBankDetail.create(:check_country=>@bank_country, :user_id=>@user_id, :payee_name=>@payee_name, :business_name=>@business_name, :check_street_address=>@street_address,  :check_city=> @bank_city, :check_state=>@bank_state, :check_zip_code=>@bank_zip_code, :prefered_mode => "check")
        end
      end
    end
    respond_to do |format|
      format.js{render :text => "$('#success_bank_info').bPopup({fadeSpeed:100,followSpeed:100,opacity:0.8,positionStyle: 'absolute',modalClose: false});"}
    end
  end
 
 ###########################bank details ending#####################################
 
 #############################provider policies###############################################
 def provider_policies
    @policy_old = Policy.where('user_id = ?', current_user.user_id)
    @provider_policies = Policy.where('status = ? AND ptype_id = ? ', false,1)
    @waiver = Policy.where('status = ? AND ptype_id = ? ', false,2)
    @policy_file = PolicyFile.where("user_id=?",current_user.user_id)
    @policy_value = params[:uid]
    if !params[:uid].nil?
      @policy_id = params[:uid]
    else
      @policy_id = current_user.user_id
    end
    @policy_type = PolicyType.find(:all)
    @old_policy = Policy.find_by_user_id(@policy_id)
    @old_policys= Policy.where(:user_id => @policy_id)
    @policy_one = Policy.find_by_user_id_and_ptype_id(@policy_id,"1")
    @policy_two = Policy.find_by_user_id_and_ptype_id(@policy_id,"2")
  end
  
  def policy_update
    if !current_user.nil? && current_user.present?
      if params[:radio_1]=="1"
        @ptype = 1
      elsif params[:radio_2]=="1"
        @ptype = 2
      elsif params[:radio_3]=="1"
        @ptype = 3
      else
        @ptype = 1
      end
      @old_policy_ptype = Policy.find_by_user_id_and_ptype_id(current_user.user_id,@ptype)
      @old_policys= Policy.where(:user_id => (current_user.user_id))
      @old_policy = Policy.find_by_user_id(current_user.user_id)
      if !params[:content].nil?
        if !@old_policys
          @policy = Policy.new
          @policy.content = params[:content]
          @policy.user_id = current_user.user_id
          @policy.status = TRUE
          @policy.inserted_date = Time.now
          @policy.modified_date = Time.now
          @policy.ptype_id = @ptype
          @policy.save
        elsif @old_policys && !@old_policy_ptype
          @policy = Policy.new
          @policy.content = params[:content]
          @policy.user_id = current_user.user_id
          @policy.status = TRUE
          @policy.inserted_date = Time.now
          @policy.modified_date = Time.now
          @policy.ptype_id = @ptype
          @policy.save
        elsif @old_policy_ptype
          @old_policy_ptype.update_attributes(:content => params[:content], :modified_date => Time.now)
        end
      end
      redirect_to :back
    end
  end
  
  
   def upload_policy
   pdf= params[:pdf_name] if !params[:pdf_name].nil?
   old_pdf=PolicyFile.find_by_user_id_and_pdf_file_name(current_user.user_id,pdf) if !params[:pdf_name].nil?
   if old_pdf.nil? 
    if(params[:policy][:datafile].present? && !params[:policy][:datafile].nil?)
      @p_file = PolicyFile.new
      @p_file.user_id = current_user.user_id
      @p_file.pdf = params[:policy][:datafile]
      @p_file.save
      @policy_file = PolicyFile.where("user_id=?",current_user.user_id)
		  if  (@p_file && @p_file.save)
        @val="success"
        render :partial =>'upload_file'
		  else
        render :text => 'false'
		  end
	  end
    else
        render :text => 'already_exit'
  end
  end
  
  def download_policy
    if !params[:id].nil?
      p_file = PolicyFile.where("policy_file_id=?",params[:id]).first
      #~ path = "#{Rails.root}/public/system/pdfs/#{p_file.policy_file_id}/original/#{p_file.pdf_file_name}"
      path = "#{p_file.pdf.path(:original)}"
      if p_file && File.exists?(path)
        send_file path, :x_sendfile=>true,  :disposition => "attachment"
      else
        redirect_to "/provider_policies"
      end
    end
  end
  
  def policy_file_delete
    if (params[:id].present? && !params[:id].nil? && !params[:id].empty?)
      p_id=params[:id]
      d_file = PolicyFile.where("policy_file_id=?",params[:id]).first
      form_file=ActivityForm.find_by_policy_file_id(p_id)
      d_file.destroy if !d_file.nil?
      form_file.destroy if !form_file.nil?
	    if (d_file.destroyed?)
	      render :text => true
	    else
	      render :text => false
	    end
    end
  end
 #############################provider policies ending here########################################
# Provider index page
  def index
  
    cookies.delete :friend_mode
    # Added for listing activities based on provider
    #~ @activity= Activity.find_by_sql("select * from activities where user_id=#{current_user.user_id} and cleaned=true and lower(active_status)='active' and lower(created_by)='provider' order by activity_id desc limit 200") if !current_user.nil? && current_user.present?
    #~ @act_id = @activity.map(&:activity_id)
    @follow_provider_user = UserRow.where("user_id=#{current_user.user_id} and user_type='U'").map(&:row_user_id)
  
    @mgr_acpted = params[:mgr_acpted] if !params[:mgr_acpted].nil?
    @macid = params[:macid] if !params[:macid].nil?
    #displayed submenu for manager users
    if (current_user.user_type).downcase == "u"
      if !params[:provider_id].nil? && params[:provider_id].present?
        act = Activity.find_by_sql("select * from activities where activity_id in(select activity_id from activity_network_permissions where provider_user_id = #{params[:provider_id]} and manager_user_id = #{current_user.user_id} and lower(accept_status) = 'accepted')") if !params[:provider_id].nil? && !current_user.nil?
      else
        redirect_to "/"
      end
    end
    
    session[:city] = cookies[:city_new_usr] unless cookies[:city_new_usr].nil?
    session[:city] = "Walnut Creek" if session[:city].nil?
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    
    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT lower(trim(category))as category")

    if (current_user.user_type).downcase == "p"
      #displayed the data based on assigned manager list
      if !params[:provider_id].nil? && params[:provider_id].present?
        act_list = Activity.find_by_sql("select * from activities where activity_id in(select activity_id from activity_network_permissions where provider_user_id = #{params[:provider_id]} and manager_user_id = #{current_user.user_id} and lower(accept_status) = 'accepted')") if !params[:provider_id].nil? && !current_user.nil?
        act = act_list.sort_by(&:modified_date).reverse if act_list
        #~ act = Activity.find_by_sql("select * from activity_network_permissions an left join activities a on an.activity_id = a.activity_id where an.provider_user_id = #{params[:provider_id]} and an.manager_user_id = #{current_user.user_id}") if !params[:provider_id].nil? && !current_user.nil?
      else
        #displayed the data based on active_status
        act_list = Activity.find_by_sql("select a.* from activities a left join school_representatives s on a.activity_id=s.activity_id where (user_id=#{current_user.user_id} or vendor_id=#{current_user.user_id} or representative_id=#{current_user.user_id}) and cleaned=true and lower(active_status)!='delete' and lower(active_status)!='city' and lower(created_by)='provider' order by a.activity_id desc") if !current_user.nil? && current_user.present?
        act = act_list.sort_by(&:modified_date).reverse if act_list
      end
    end

    if !cookies[:last_action].nil? && cookies[:last_action].present? && !cookies[:page].nil? && cookies[:page].present? && (cookies[:last_action]=="provider_edit_activity" || cookies[:last_action]=="delete_activity")
      params[:page] = cookies[:page] if !cookies[:page].nil?
    end
    act = [] if act.nil?
    @auto_comp=act
    @activities = []
    @activities = act.paginate(:page => params[:page], :per_page =>10)
    if @activities.length==0 && !act.nil? && act.present?
      params[:page] = (params[:page].to_i) - 1
      @activities = act.paginate(:page => params[:page], :per_page =>10)
    end
    
    cookies[:last_action]=""
    cookies[:page]=""
    @get_current_url = request.env['HTTP_HOST']
    #profile image changes
    if !current_user.nil? && !current_user.user_profile.nil?
      @profile_data=current_user.user_profile if !current_user.user_profile.nil?
      @aa='$image_global_path'+@profile_data.profile.url(:thumb)
      @profile_ig=FastImage.size(@aa)
      @p_f = @aa if @profile_ig!="" && !@profile_ig.nil?
    end
  

  end #provider index ending here.

  # Provider index page
  def provider_activites
    if (current_user.user_type).downcase == "u"
      redirect_to "/"
    end
    session[:city] = cookies[:city_new_usr] unless cookies[:city_new_usr].nil?
    session[:city] = "Walnut Creek" if session[:city].nil?
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    
    #~ act_free = Activity.find_by_sql("select * from activities where user_id=#{current_user.user_id} and cleaned=true and lower(active_status)='active' and lower(created_by)='provider' order by activity_id desc limit 200") if !current_user.nil? && current_user.present?
    act_free_list = Activity.find_by_sql("select * from activities where user_id=#{current_user.user_id} and cleaned=true and lower(active_status)!='delete' and lower(active_status)!='city' and lower(created_by)='provider' order by activity_id desc") if !current_user.nil? && current_user.present?
    act_free = act_free_list.sort_by(&:modified_date).reverse if act_free_list
  
    cookies[:page] = params[:page] if !params[:page].nil?
    act_free = [] if act_free.nil?
    @activities = []
    #~ Taking per page as 60 to match the list of cards for different size monitors
    @activities = act_free.paginate(:page => params[:page], :per_page =>60)
  end
  
  #ajax calling function while searching the text in activities/index page.
  def search_index
    params[:search_text]
    @event = params[:provider_page]
    params[:user_id]
    session[:city] = cookies[:city_new_usr] unless cookies[:city_new_usr].nil?
    session[:city] = "Walnut Creek" if session[:city].nil?
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?

    #normal search with ajax call
    @search_provider ="search_provider"
    act = Activity.search_data(params[:search_text],params[:user_id])

    #pagination for activities
    act = [] if act.nil?
    @activities = act.paginate(:page => params[:page], :per_page =>10)

  end

    #provider thumb page search by rajkumar
  def provider_basic_search
    @keyword=params[:search_text] if params[:search_text]!=nil && params[:search_text]!=''
    @parent_keyword = @keyword.downcase.gsub("'","") if !@keyword.nil?
    session[:city] = cookies[:city_new_usr] unless cookies[:city_new_usr].nil?
    session[:city] = "Walnut Creek" if session[:city].nil?
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    
    #normal search with ajax call
    @search_provider ="search_provider"
    act = Activity.search_data(@parent_keyword,params[:user_id])

    #pagination for activities
    act = [] if act.nil?
    @activities = act.paginate(:page => params[:page], :per_page =>60)
    
    respond_to do |format|
      format.js
    end
  end

  #activity save copy option
  def activity_save_copy
    if !params[:activity_id].nil? && params[:activity_id]!=''
      @par_actid = params[:activity_id] #dont remove this
      old_act = Activity.find(params[:activity_id])
      newact = old_act.create_duplicate(old_act.user_id)
      act = Activity.find_by_sql("select a.* from activities a left join school_representatives s on a.activity_id=s.activity_id where (user_id=#{current_user.user_id} or vendor_id=#{current_user.user_id} or representative_id=#{current_user.user_id}) and cleaned=true and lower(active_status)!='delete' and lower(active_status)!='city' and lower(created_by)='provider' order by a.activity_id desc") if !current_user.nil? && current_user.present?
      #old form save start
      @old_form=old_act.activity_forms
      @old_form.each do |frm|
        @activity_form = ActivityForm.new
        @activity_form.activity_id = newact.activity_id if !newact.nil?
        @activity_form.form_id = frm.form_id if !frm.form_id.nil?
        @activity_form.user_id = newact.user_id if !newact.nil?
        @activity_form.created_date = Time.now
        @activity_form.modified_date = Time.now
        @activity_form.active_status = true
        @activity_form.policy_file_id = frm.policy_file_id if !frm.policy_file_id.nil?
        @activity_form.save
      end
      #old form save end
      act = [] if act.nil?
      @auto_comp=act
      @activities = []
      @activities = act.paginate(:page => params[:page], :per_page =>10)
      if @activities.length==0 && !act.nil? && act.present?
        params[:page] = (params[:page].to_i) - 1
        @activities = act.paginate(:page => params[:page], :per_page =>10)
      end
      @get_current_url = request.env['HTTP_HOST']
      #profile image changes
      if !current_user.nil? && !current_user.user_profile.nil?
        @profile_data=current_user.user_profile if !current_user.user_profile.nil?
        @aa='$image_global_path'+@profile_data.profile.url(:thumb)
        @profile_ig=FastImage.size(@aa)
        @p_f = @aa if @profile_ig!="" && !@profile_ig.nil?
      end
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
