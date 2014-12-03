class UsersController < ApplicationController
  layout 'frame_layout',:only => [:new_parent_register, :new_provider_register]
  include ActionView::Helpers::NumberHelper
  before_filter :authenticate_user, :only=>[:bank_info, :user_activates_list]
  # GET /users
  # GET /users.json
  require "active_merchant"

  #famtivity user account activate state
  def user_activates_list
	  render :layout=>false
  end
  
  #display the list of famtivity users count
  def user_activate_details
    if !current_user.nil?
	    #take the un account activate users list for the support team
	    @today = Date.today.strftime("%Y-%m-%d")
	    @users_list = User.find_by_sql("select email_address,user_name from users where account_active_status=false and lower(user_type)='p' and lower(user_plan)='sell' and date(user_created_date) < '#{@today}'")
	    #send a mail to support team for un activate users list
	    #~ UserMailer.delay(queue: "User account activate details to support team", priority: 1, run_at: 5.seconds.from_now).provider_account_details(@users_list)
	    UserMailer.provider_account_details(@users_list).deliver
    end
    render :partial => "famtivity_user_accountstatus"
  end
  #user activation email to provider
  def resend_activation_link
	  if params[:email] && params[:email]!=''
      @user=User.find_by_email_address(params[:email])
      UserMailer.delay(queue: "Resent Activation to user", priority: 1, run_at: 5.seconds.from_now).resend_activation(@user) if !@user.nil?
      render :text => 'Success'
    else
      render :text => "Please send email address!"
    end
	
  end
  #provider click count update
  def provider_list_count_top
    n_count = 0
    if !params[:userid].nil? && params[:userid]!=''
      @user = User.find_by_user_id(params[:userid])
      if !@user.nil? && @user.present?
        @date = Time.now.strftime("%Y-%m-%d")
        @pro_count = ProviderCount.where("user_id=? and date(inserted_date)=?",params[:userid],@date)
        if !@pro_count.nil? && @pro_count.present? && @pro_count!='' && @pro_count.length > 0
          ex_count = @pro_count[0].provider_count.to_i
          n_count = ex_count + 1
          @pro_count[0].update_attributes(:provider_count => n_count,:modified_date => Time.now)
        else
          n_count = 1
          @count_add = ProviderCount.create(:user_id => params[:userid], :provider_count => n_count, :inserted_date=>Time.now,:modified_date=>Time.now)
        end
      end
    end
    render :text => "success"
  end
  def bank_info
    if !current_user.nil? && current_user.present? && current_user!=''
      @bank_details = UserBankDetail.find_by_user_id(current_user.user_id)
    end
  end

  def user_register
    @user_usr = User.new
    respond_to do |format|
      format.html
    end
  end
  
  def provider_bid_amount
    @raj = Activity.where("active_status = ? and city=?", "Active","San Francisco").joins(:activity_schedule).group("activities.activity_id")
    @raj.each do |s|
      p s
    end
    p @sekar
  end
  
  def user_exist
    #    if !current_user.nil? && !current_user.user_profile.nil?
    if !current_user.nil? && current_user.present? && !current_user.user_profile.nil? && current_user.user_profile.present?
      @user = current_user.user_id
      @user_exist = "success"
      render :text=> @user_exist
    else
      @user = User.find_by_email_address(params[:email])
      if @user
        @user_exist = "failed"
        render :text=> @user_exist
      else
        @user_exist = "success"
        render :text=> @user_exist
      end
    end
  end
  
  def curated_user_exist
    #if !current_user.nil? && current_user.present? && !current_user.user_profile.nil? && current_user.user_profile.present?
    #  @user = current_user.user_id
    #  exist_result = 'success'
    #else
    user = User.where('email_address=?',params[:email].downcase).first if !params[:email].nil?
    if (user && user.user_plan=='curator')
      exist_result = 'curated'
    elsif(user)
      exist_result = 'failed'
    else
      exist_result = 'success'
    end
    # end
    render :text => exist_result.to_json
  end
  
  def provider_sponsor_submit
    #checking current_user for become a provider start
    if !current_user.nil? && !current_user.user_profile.nil?
      @user= User.find_by_user_id(current_user.user_id)
      @user_profile = current_user.user_profile
      @user.email_address = params[:sp_email]   if !params[:sp_email].nil?
      @user.user_password = Base64.encode64("#{params[:sp_password]}")
      @user.user_name = params[:sp_name]
      @user.user_plan = "sponsor"
      @user.user_type = "P"
      @user.save
      @user_profile.business_name = params[:sb_name]   if params[:sb_name] != "Enter the Name Of your business"
      @user_profile.phone = params[:sp_phone]
      @user_profile.mobile = params[:sp_mobile]        if params[:sp_mobile] != "Enter Your Mobile Number"
      @user_profile.fax =params[:sp_fax]                if params[:sp_fax] != "Enter Your Fax Number"
      @user_profile.address_1 = params[:sp_address1]    if params[:sp_address1] != "Enter Address"
      @user_profile.address_2 = params[:sp_address2]    if params[:sp_address2] != "Enter Address"
      @user_profile.owner_first_name = params[:sp_owner_lastname]  if params[:sp_owner_firstname] != "First Name"
      @user_profile.owner_last_name = params[:p_owner_lastname]    if params[:sp_owner_lastname] != "Last Name"
      @user_profile.website = params[:sp_web_addrs]                if params[:sp_web_addrs] != "Enter The URL Of Your Website"
      @user_profile.zip_code = params[:sp_zipcode]
      @user_profile.state = params[:state]
      @user_profile.city = params[:city]
      @user_profile.country = params[:country]
      @user_profile.business_language = params[:language_usr]
      @user_profile.profile = params[:activity_image] if !params[:activity_image].nil? && params[:activity_image]!=""
      @user_profile.time_zone = params[:time]
      @user_profile.save

      profile_data = {
        :profile=>{:email => current_user.email_address.downcase} 
      }
      create_profile = CIMGATEWAY.create_customer_profile(profile_data)
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
          :verification_value => params[:cardnumber_5], #verification codes are now required
          :brand => 'visa'
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
        end
      else
        puts "Error: {response.message}"
      end
      @get_current_url = request.env['HTTP_HOST']
      @plan = "sell"
      @c_user = current_user
      if !@c_user.nil? && @c_user.user_flag==TRUE
        UserMailer.delay(queue: "Become Provider", priority: 1, run_at: 5.seconds.from_now).become_provider_user(@c_user,@get_current_url,@plan)
      end
      #UserMailer.become_provider_user(@c_user,@get_current_url,@plan).deliver
      render :partial=>'become_provider_market_thank'

    else

      createtime = Time.now
      expirytime = createtime + (30*24*60*60)
      createdate = createtime.strftime("%Y-%m-%d %H:%M:%S")
      expirydate = expirytime.strftime("%Y-%m-%d %H:%M:%S")
      @buis_name = params[:sb_name] if params[:sb_name] != "Enter the Name Of your business"
      @phone = params[:sp_phone]
      @mobile = params[:sp_mobile] if params[:sp_mobile] != "Enter Your Mobile Number"
      @fax = params[:sp_fax]
      @add1 = params[:sp_address1]         if params[:sp_address1] != "Enter Address"
      @add2 = params[:sp_address2]         if params[:sp_address2] != "Enter Address"
      @owner1 = params[:sp_owner_lastname] if params[:sp_owner_lastname] != "Last Name"
      @owner2 = params[:sp_owner_firstname] if params[:sp_owner_firstname] != "First Name"
      @web = params[:sp_web_addrs]          if params[:sp_web_addrs] != "Enter The URL Of Your Website"
      @zip = params[:sp_zipcode]
      @state = params[:state]
      @city = params[:city]
      @country = params[:country]
      @zip =  params[:sp_zipcode]
      @lang = params[:language_usr]
      @p_name = params[:sp_name]
      @p_email = params[:sp_email].downcase if !params[:sp_email].nil?
      @ava = params[:activity_image] if !params[:activity_image].nil? && params[:activity_image]!=""
      @time_zone = params[:time]

      test = { :user_usr => {:user_name => @p_name,
          :email_address=>@p_email, :user_password=> Base64.encode64("#{params[:sp_password]}"),:user_type=>"P",:user_created_date=> createdate,
          :user_expiry_date => expirydate,:account_active_status => false, :user_flag => true,:user_plan=>"sponsor",
          :user_profile_attributes => { :business_name => @buis_name, :first_name => @owner2,:last_name => @owner1,:phone=> @phone,:address_2=> @add2,
            :mobile=> @mobile,:website=> @web,:address_1=> @add1,:fax=> @fax,:administrator=> @admin,
            :city=> @city,:zip_code=> @zip,:state=>@state,:country=>@country,:business_language=>@lang,:time_zone=>@time_zone, :profile=>@ava, :inserted_date =>createdate, :modified_date => createdate  } } }

      @user_usr = User.create(test[:user_usr])

      if @user_usr && @user_usr.errors.empty?
	      
        c_user = ContactUser.where("contact_email = ?",@user_usr.email_address)
        if c_user
          c_user.each do |contact|
            contact.update_attributes(:contact_user_type => "member")
          end
        end

        profile_data = {
          :profile=>{:email => params[:sp_email].downcase}
        }
        create_profile = CIMGATEWAY.create_customer_profile(profile_data)
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
            :verification_value => params[:cardnumber_5], #verification codes are now required
            :brand => 'visa'
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
            @user_transaction.user_id = @user_usr.user_id
            @user_transaction.save
          end
        else
          puts "Error: {response.message}"
        end
        #Cotc Update for the register email         
        cotc_for_provider       
        @get_current_url = request.env['HTTP_HOST']
        flag_curation=false
        UserMailer.delay(queue: "User Register", priority: 1, run_at: 5.seconds.from_now).register_user(@user_usr,@get_current_url,flag_curation)
        #UserMailer.register_user(@user_usr,@get_current_url).deliver
        cookies[:city_registered_usr] = cookies[:city_new_usr]
        render :partial=>'provider_market_thank'
      else
        flash[:notice]= "Already has taken that Email address. Try another."
        if request.xhr?
          respond_to do |format|
            format.js{render :text => "$('#user_name_wrong_sponsor').html('Looks Like this Email has been Already registered');$('#user_name_wrong_sponsor').css('display', 'block').fadeOut(10000);"}
          end
        else
          render :partial=>'provider_market_failure'
        end
      end

    end #checking current_user for become a provider end

  end

  #provider form submit for new choose plan
  def provider_sell_submit
    cookies.delete :f_curator
    cookies.delete :f_path
    @partner_reg = params[:partner_reg] #For partner registration
    #checking empty user values start
    if params[:email_old] && !params[:email_old].nil?
      @old_cur=User.where("lower(email_address)=? and user_plan = ?", params[:email_old].downcase,"curator").last if !params[:sell_b_name].nil?
    else
      @old_cur=User.where("lower(email_address)=? and user_plan=?", params[:sell_email].downcase,"curator").last if !params[:sell_b_name].nil?
    end
    #@old_cur=User.find_by_email_address_and_user_plan(params[:sell_email],"curator") if !params[:sell_b_name].nil?
    if !params[:sell_b_name].nil? && params[:sell_b_name]!='' && params[:sell_b_name] !="Enter the name of your business" && !params[:sell_name].nil? && params[:sell_name]!='' && params[:sell_name] !="Eg: John Smith"
      if ((!current_user.nil? && !current_user.user_profile.nil?)||(!@old_cur.nil? && @old_cur.present?))
        if !current_user.nil? && !current_user.user_profile.nil?
          @user= User.find_by_user_id(current_user.user_id)
          @user_profile = current_user.user_profile
        elsif !@old_cur.nil? && @old_cur.present?
          @user= @old_cur
          @user_profile= @old_cur.user_profile
        end

        @get_current_url = request.env['HTTP_HOST']
        #school flow condition started here
        if params[:plan_sell_manage] && !params[:plan_sell_manage].nil? && params[:plan_sell_manage]!="" && params[:plan_sell_manage].present? && params[:plan_sell_manage]=="school"
          #user and user profile information stored
          @plan_sell_manage = params[:plan_sell_manage]  if !params[:plan_sell_manage].nil? && params[:plan_sell_manage]!=""
          @user.email_address = params[:sell_email].downcase if !params[:sell_email].nil?
          @user.user_password =  Base64.encode64("#{params[:sell_password]}")
          @user.user_name = params[:sell_name]
          @user.user_type = "P"
          @user.user_plan = "sell"
          @user.user_flag = true
          @user.manage_plan = @plan_sell_manage if !@plan_sell_manage.nil?
          @user.show_card = true #show card for sell user
          if !params[:city].nil? && params[:city]!=""
            city_se = City.where("city_name='#{params[:city]}'").last
            if !city_se.nil?
              @user.latitude  = city_se.latitude
              @user.longitude  = city_se.longitude
            end
          end
          @user.save
          @user_profile.business_name = params[:sell_b_name] if params[:sell_b_name] != "Enter the name of your business"
          @user_profile.phone = "#{params[:sell_phone_1]}-" +"#{params[:sell_phone_2]}-"+"#{params[:sell_phone_3]}"
          @user_profile.mobile = "#{params[:sell_mobile_1]}-" +"#{params[:sell_mobile_2]}-"+"#{params[:sell_mobile_3]}" if params[:sell_mobile_1] != "111"
          @mobile_value = "#{params[:sell_mobile_1]}-" +"#{params[:sell_mobile_2]}-"+"#{params[:sell_mobile_3]}"
          if @mobile_value !="xxx-xxx-xxxx"
            @user_profile.mobile = @mobile_value
          end
          @user_profile.fax =params[:sell_fax]        if params[:sell_fax] != "Enter your fax number"
          @user_profile.address_1 = params[:sell_address1] if params[:sell_address1] != "Enter address"
          @user_profile.address_2 = params[:sell_address2] if params[:sell_address2] != "Enter address"
          @user_profile.owner_first_name = params[:sell_owner_firstname] if params[:sell_owner_firstname] != "First name"
          @user_profile.owner_last_name = params[:sell_owner_lastname] if params[:sell_owner_lastname] != "Last name"
          @user_profile.website = params[:sell_web_addrs] if params[:sell_web_addrs] != "Enter the URL of your website"
          @user_profile.zip_code = params[:sell_zipcode]
          @user_profile.state = params[:state]
          @user_profile.city = params[:city]
          @user_profile.country = params[:country]
          @user_profile.business_language = params[:language_usr]
          @user_profile.profile = params[:activity_image] if !params[:activity_image].nil? && params[:activity_image]!=""
          @user_profile.time_zone = params[:time]
          @user_profile.card = params[:provider_image] if !params[:provider_image].nil? && params[:provider_image]!=""
          @user_profile.description = params[:sell_description] if !params[:sell_description].nil? && params[:sell_description]!="" && params[:sell_description] != "Description should not exceed 1000 characters"
          @user_profile.save
          #@old_contact=ContactUser.find_all_by_contact_email(@user_usr.email_address)
          @old_contact=ContactUser.where("lower(contact_email)= ? ",@user_usr.email_address.downcase)
          @old_contact.each do |con|
            con.update_attributes(:fam_user_id =>@user.user_id,:contact_user_type=>"member")
            @cont_group = ContactuserGroup.where(:contact_user_id => con.contact_id)
            @cont_group.each do |s|
              s.update_attributes(:fam_accept_user_id =>@user.user_id)
            end
          end if !@old_contact.nil?
          #user and user profile information storing end
          #user bank details stored started based on the check and bankinfo
          if !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="bankinfo"
            UserBankDetail.user_bank_form(@user.user_id,params[:bank_name],params[:account_name],params[:w_transfer],params[:acc_number],params[:bank_state],params[:bank_city],params[:bank_z_code],params[:street_bank_code]) if !@user.nil? && @user != ""
          elsif !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="check"
            UserBankDetail.user_check_form(@user.user_id,params[:paye_name],params[:c_business_name],params[:street_check_code],params[:bank_state],params[:check_bank_city],params[:check_z_code],params[:bank_country]) if !@user.nil? && @user != ""
          end
          #user bank deatils stored ending
          if !params[:be_invite_user_id].nil? && params[:be_invite_user_id].present? && !params[:be_invitee_email].nil? && params[:be_invitee_email].present?
            #discount_dollar_submit(@user_usr)
            @u_credits = UserCredit.new
            @u_credits.user_id = params[:be_invite_user_id]
            @u_credits.invitee_id = @user.user_id
            invitee_detail = User.user_plan_type(@user.user_type,@user.user_plan)
            @u_credits.invitee_plan = invitee_detail[0]
            @u_credits.credit_amount = invitee_detail[1]
            @u_credits.provider_plan = invitee_detail[2]
            @u_credits.credit_type = "invite"
            @u_credits.inserted_date = Time.now
            @u_credits.modified_date = Time.now
            @u_credits.save
            UserMailer.delay(queue: "Acknowledge User Discount", priority: 1, run_at: 5.seconds.from_now).ack_user_discount(@user,@u_credits)
          end
          @u_success=true
		
        else #school flow else condition started here
          #authorize net started by rajkumar
          if !params[:sell_name].nil? && params[:sell_name]!=''
            @sell_bname = params[:sell_name][0..8].strip+"#{Time.now.strftime("%S")}"
          else
            @sell_bname ="#{Time.now.strftime("%S")}"
          end
          customer_profile_information = {
            :profile     => {
              :merchant_customer_id =>@sell_bname,
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
              @payment_profile_user = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>create_profile.authorization, :customer_payment_profile_id=>pay_profile.params["customer_payment_profile_id"])
              #===========transaction started here for the register user===============#
              if !params[:plan_sell_manage].nil? && params[:plan_sell_manage] !=""
                if params[:plan_sell_manage]=="market_sell"
                  @usr_tran_amt = "#{$market_sell_u}" #marget sell user amount 29.95$
                  plan_amount_tot = "#{$market_sell_u}"
                  sales_pro_limit = 25
                elsif params[:plan_sell_manage]=="market_sell_manage"
                  @usr_tran_amt = "#{$market_sell_manage_u}" #marget sell user amount 49.95$
                  plan_amount_tot = "#{$market_sell_manage_u}"
                  sales_pro_limit = 75
                elsif params[:plan_sell_manage]=="market_sell_manage_plus"
                  @usr_tran_amt = "#{$market_sell_manage_plus_u}" #marget sell user amount 99.95$
                  plan_amount_tot = "#{$market_sell_manage_plus_u}"
                  sales_pro_limit = 150
                end
              end #sell manage user
              #========================transaction started here========================================#
              #transaction for the user
              transaction = {:transaction => {
                  :type => :auth_capture,
                  :amount => "#{@usr_tran_amt}", #marget sell registrations
                  :customer_profile_id => create_profile.authorization,
                  :customer_payment_profile_id => pay_profile.params["customer_payment_profile_id"]
								}
              }
              response = CIMGATEWAY.create_customer_profile_transaction(transaction)
              if !response.nil? && response.success?
                #user and user profile information stored
                provider_trans_id = "#{response.authorization}" if !response.nil? && !response.authorization.nil?
                @plan_sell_manage = params[:plan_sell_manage]  if !params[:plan_sell_manage].nil? && params[:plan_sell_manage]!=""
                @user.email_address = params[:sell_email].downcase if !params[:sell_email].nil?
                @user.user_password =  Base64.encode64("#{params[:sell_password]}")
                @user.user_name = params[:sell_name]
                @user.user_type = "P"
                @user.user_plan = "sell"
                @user.user_flag = true
                @user.manage_plan = @plan_sell_manage if !@plan_sell_manage.nil?
                @user.show_card = true #show card for sell user
                if !params[:city].nil? && params[:city]!=""
                  city_se = City.where("city_name='#{params[:city]}'").last
                  if !city_se.nil?
                    @user.latitude  = city_se.latitude
                    @user.longitude  = city_se.longitude
                  end
                end
                @user.save
                @user_profile.business_name = params[:sell_b_name] if params[:sell_b_name] != "Enter the name of your business"
                @user_profile.phone = "#{params[:sell_phone_1]}-" +"#{params[:sell_phone_2]}-"+"#{params[:sell_phone_3]}"
                @user_profile.mobile = "#{params[:sell_mobile_1]}-" +"#{params[:sell_mobile_2]}-"+"#{params[:sell_mobile_3]}" if params[:sell_mobile_1] != "111"
                @mobile_value = "#{params[:sell_mobile_1]}-" +"#{params[:sell_mobile_2]}-"+"#{params[:sell_mobile_3]}"
                if @mobile_value !="xxx-xxx-xxxx"
                  @user_profile.mobile = @mobile_value
                end
                if !@old_cur.nil? && @old_cur.present?
                  @user_profile.user_id = @old_cur.user_id
                end
                @user_profile.fax =params[:sell_fax]        if params[:sell_fax] != "Enter your fax number"
                @user_profile.address_1 = params[:sell_address1] if params[:sell_address1] != "Enter address"
                @user_profile.address_2 = params[:sell_address2] if params[:sell_address2] != "Enter address"
                @user_profile.owner_first_name = params[:sell_owner_firstname] if params[:sell_owner_firstname] != "First name"
                @user_profile.owner_last_name = params[:sell_owner_lastname] if params[:sell_owner_lastname] != "Last name"
                @user_profile.website = params[:sell_web_addrs] if params[:sell_web_addrs] != "Enter the URL of your website"
                @user_profile.zip_code = params[:sell_zipcode]
                @user_profile.state = params[:state]
                @user_profile.city = params[:city]
                @user_profile.country = params[:country]
                @user_profile.business_language = params[:language_usr]
                @user_profile.profile = params[:activity_image] if !params[:activity_image].nil? && params[:activity_image]!=""
                @user_profile.time_zone = params[:time]
                @user_profile.card = params[:provider_image] if !params[:provider_image].nil? && params[:provider_image]!=""
                @user_profile.description = params[:sell_description] if !params[:sell_description].nil? && params[:sell_description]!="" && params[:sell_description] != "Description should not exceed 1000 characters"
                @user_profile.save
                #user and user profile information storing end
                @user_transaction = UserTransaction.new
                @user_transaction.customer_profile_id = create_profile.authorization
                @user_transaction.customer_payment_profile_id = pay_profile.params["customer_payment_profile_id"]
                @user_transaction.user_id = @user.user_id if !@user.nil?
                @user_transaction.inserted_date = Time.now
                @user_transaction.save
                #-----------------------------store to the transaction details------------------------------------------#
                @p_trans = ProviderTransaction.create(:user_id=>@user.user_id, :amount=>@usr_tran_amt, :user_plan=>@user.manage_plan, :customer_profile_id=>create_profile.authorization, :customer_payment_profile_id=>pay_profile.params["customer_payment_profile_id"], :inserted_date=>Time.now, :modified_date=>Time.now, :start_date=>Time.now, :end_date=>Time.now+30.days, :grace_period_date=>Time.now+37.days, :sales_limit=>sales_pro_limit, :purchase_limit=>0, :expiry_status=>true, :payment_date=>Time.now, :plan_amount=>plan_amount_tot, :email_address=>@user.email_address, :transaction_id=>provider_trans_id) if !@user.nil? && !@usr_tran_amt.nil?
                #-----------------------------------------------------------------------#
                #user bank details stored started based on the check and bankinfo
                if !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="bankinfo"
                  UserBankDetail.user_bank_form(@user.user_id,params[:bank_name],params[:account_name],params[:w_transfer],params[:acc_number],params[:bank_state],params[:bank_city],params[:bank_z_code],params[:street_bank_code]) if !@user.nil? && @user != ""
                elsif !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="check"
                  UserBankDetail.user_check_form(@user.user_id,params[:paye_name],params[:c_business_name],params[:street_check_code],params[:bank_state],params[:check_bank_city],params[:check_z_code],params[:bank_country]) if !@user.nil? && @user != ""
                end
                #user bank deatils stored ending
                if !params[:be_invite_user_id].nil? && params[:be_invite_user_id].present? && !params[:be_invitee_email].nil? && params[:be_invitee_email].present?
                  #discount_dollar_submit(@user_usr)
                  @u_credits = UserCredit.new
                  @u_credits.user_id = params[:be_invite_user_id]
                  @u_credits.invitee_id = @user.user_id
                  invitee_detail = User.user_plan_type(@user.user_type,@user.user_plan)
                  @u_credits.invitee_plan = invitee_detail[0]
                  @u_credits.credit_amount = invitee_detail[1]
                  @u_credits.provider_plan = invitee_detail[2]
                  @u_credits.credit_type = "invite"
                  @u_credits.inserted_date = Time.now
                  @u_credits.modified_date = Time.now
                  @u_credits.save
                  UserMailer.delay(queue: "Acknowledge User Discount", priority: 1, run_at: 5.seconds.from_now).ack_user_discount(@user,@u_credits)
                end
                @u_success=true
                #provider transaction details started stored user information after success or failure
                ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>@usr_tran_amt, :action_type=>"become_provider", :customer_payment_profile_id=>pay_profile.params["customer_payment_profile_id"], :customer_profile_id=>create_profile.authorization, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{response.message}", :payment_status=>"success", :transaction_id=>provider_trans_id, :user_id=>@user.user_id) if @user && @user.email_address
                #provider transaction details ended here
              else #transaction response else part
                @failer_message= "#{response.message}" if !response.nil? && !response.message.nil?
                cookies[:card_msg]=@failer_message if !@failer_message.nil?
                @u_success=false
                #provider transaction details started stored user information after success or failure
                ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>@usr_tran_amt, :action_type=>"become_provider", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{response.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>@user.user_id) if @user && @user.email_address
                #provider transaction details ended here
              end
              #=========================transaction ending here========================================#
            else #pay profile else part
              @u_success=false
              #provider transaction details started stored user information after success or failure
              ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>@usr_tran_amt, :action_type=>"become_provider", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{pay_profile.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>@user.user_id) if @user && @user.email_address
              #provider transaction details ended here
            end
          else #create profile else part
            @u_success=false
            #provider transaction details started stored user information after success or failure
            ProviderTransactionLog.create(:email_address=>@user.email_address,:amount=>@usr_tran_amt, :action_type=>"become_provider", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{create_profile.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>@user.user_id) if @user && @user.email_address
            #provider transaction details ended here
            @failer_message = create_profile.message if !create_profile.nil? && !create_profile.message.nil?
          end  #create profile ending
          #authorize net end
        end #school flow ending here.

        #curator check start
        #~ if !@old_cur.nil? && @old_cur.present?
        #~ UserMailer.delay(queue: "User Register Transaction", priority: 1, run_at: 10.seconds.from_now).register_user_transaction(@user,@usr_tran_amt)
        #~ @return_status="success"
        #~ render :text=> @return_status.to_json
		
        if @user && !@user.nil? && @u_success
          @c_user = current_user
          @plan = "sell"
          if !@c_user.nil? && @c_user.user_flag==TRUE
            UserMailer.delay(queue: "Become Provider", priority: 1, run_at: 5.seconds.from_now).become_provider_user(@c_user,@get_current_url,@plan)
          end
	
          #==============Newsletter subscribe for COTC domain starting ===========================#
          #news_letter_signup(@user.email_address,params[:city])
          #Cotc Update for the register email
          cotc_for_provider_update(@user)
          #==============Newsletter subscribe for COTC domain ending===========================#
	
          #amount detection mail to provider user
          if params[:plan_sell_manage] && !params[:plan_sell_manage].nil? && params[:plan_sell_manage]!="" && params[:plan_sell_manage].present? && params[:plan_sell_manage]=="school"
            #dont sent mail to the user from the school#
            UserMailer.delay(queue: "School registration mail to admin", priority: 1, run_at: 5.seconds.from_now).school_register_toadmin(@user,@get_current_url)
            UserMailer.delay(queue: "School registration to provider", priority: 1, run_at: 5.seconds.from_now).school_register_to_provider(@user)
          else
            if !@user.is_partner
              UserMailer.delay(queue: "User Register Transaction", priority: 1, run_at: 10.seconds.from_now).register_user_transaction(@user,@usr_tran_amt)
            end
          end #plan_sell_manage ending here
          if params[:discount_code_sell]
            disc = params[:discount_code_sell]
          elsif params[:discount_code]
            disc = params[:discount_code]
          end
          if disc
            @disc = AdminDiscountCode.where("lower(discount_code) = '#{disc.downcase}' and discount_status ='Active' and discount_max > discount_sign and ((discount_start_date <='#{Date.today} 23:59:59' and discount_end_date >='#{Date.today} 00:00:00')or(discount_start_date is null and discount_end_date is null ))").last
            if @disc
              @disc.discount_sign = @disc.discount_sign + 1
              @disc.save
              u_cdts = UserCredit.new
              u_cdts.user_id = @user.user_id if @user.present?
              u_cdts.credit_amount = @disc.discount_amount
              u_cdts.provider_plan = @user.user_plan if @user.present?
              u_cdts.inserted_date = Time.now
              u_cdts.modified_date = Time.now
              u_cdts.credit_type = "register discount code"
              u_cdts.save
            end
          end
          #
          #render :partial=>'become_provider_market_thank'
          @return_status="b_provider"
          render :text=> @return_status.to_json
        else
          #render :partial=>'provider_sell_failure'
          @return_status="failed"
          render :text=> @return_status.to_json
        end

        ###########New user registration started by rajkumar##################
      else #new user registration for sell through provider

        @get_current_url = request.env['HTTP_HOST']
        createtime = Time.now
        expirytime = createtime + (30*24*60*60)
        createdate = createtime.strftime("%Y-%m-%d %H:%M:%S")
        expirydate = expirytime.strftime("%Y-%m-%d %H:%M:%S")
        @buis_name = params[:sell_b_name] if params[:sell_b_name] != "Enter the name of your business"
        @phone = "#{params[:sell_phone_1]}-" +"#{params[:sell_phone_2]}-"+"#{params[:sell_phone_3]}"
        @mobile_value = "#{params[:sell_mobile_1]}-" +"#{params[:sell_mobile_2]}-"+"#{params[:sell_mobile_3]}"
        if @mobile_value !="xxx-xxx-xxxx"
          @mobile = @mobile_value
        end
        #@mobile = "#{params[:sell_mobile_1]}-" +"#{params[:sell_mobile_2]}-"+"#{params[:sell_mobile_3]}" if params[:sell_mobile_1] != "111"
        @fax = params[:sell_fax] if params[:sell_fax] != "Enter your fax number"
        @add1 = params[:sell_address1]  if params[:sell_address1] != "Enter address"
        @add2 = params[:sell_address2]  if params[:sell_address2] != "Enter address"
        @owner1 = params[:sell_owner_lastname] if params[:sell_owner_lastname] != "Last name"
        @owner2 = params[:sell_owner_firstname] if params[:sell_owner_firstname] != "First name"
        @web = params[:sell_web_addrs]         if params[:sell_web_addrs] != "Enter the URL of your website"
        @zip = params[:sell_zipcode]
        @state = params[:state]
        @city = params[:city]
        @country = params[:country]
        @zip =  params[:sell_zipcode]
        @lang = params[:language_usr]
        @p_name = params[:sell_name]
        @p_email = params[:sell_email].downcase if !params[:sell_email].nil?
        @ava = params[:activity_image] if !params[:activity_image].nil? && params[:activity_image]!=""
        @card = params[:provider_image] if !params[:provider_image].nil? && params[:provider_image]!=""
        @sell_description = params[:sell_description] if !params[:sell_description].nil? && params[:sell_description]!="" && params[:sell_description] != "Description should not exceed 1000 characters"
        @time_zone = params[:time]
      
        #school flow condition started here
        if params[:plan_sell_manage] && !params[:plan_sell_manage].nil? && params[:plan_sell_manage]!="" && params[:plan_sell_manage].present? && params[:plan_sell_manage]=="school"
	
          #==============================================================#
          #Provider Claim process added
          #generate temporary password to curator user
          school_reg = "school_present"
          tcount = 10
          chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789'
          @temp_password = ''
          tcount.times { |i| @temp_password << chars[rand(chars.length)] }
		
          curated_user = User.where("lower(email_address)=? and user_plan=?",@p_email,'curator').first
          @plan_sell_manage = params[:plan_sell_manage]  if !params[:plan_sell_manage].nil? && params[:plan_sell_manage]!=""
          if params[:invite_user_id] && params[:invite_user_id].present? && !params[:invite_user_id].empty?
            active_status_u = true
          else
            active_status_u = false
          end
          if (curated_user.present? && !curated_user.nil? && params[:curated_user_sell]=='cur_user')
            test_user = { :user_usr => {:user_name => @p_name,
                :email_address=>@p_email, :user_password=> Base64.encode64("#{params[:sell_password]}"),:user_type=>"P",:user_created_date=> createdate,
                :user_expiry_date => expirydate,:account_active_status => active_status_u, :user_flag => true,:user_plan=>"sell", :show_card => true, :manage_plan=>@plan_sell_manage},:user_profile_attributes => { :business_name => @buis_name, :first_name => @owner2,:last_name => @owner1,:phone=> @phone,:address_2=> @add2,
                :mobile=> @mobile,:website=> @web,:address_1=> @add1,:fax=> @fax,:administrator=> @admin,
                :city=> @city,:zip_code=> @zip,:state=>@state,:country=>@country,:business_language=>@lang,:time_zone=>@time_zone, :profile=>@ava, :card=>@card, :description=>@sell_description, :inserted_date =>createdate, :modified_date => createdate  }}
            @user_usr = curated_user
            @user_profile = @user_usr.user_profile
            @user_usr.update_attributes(test_user[:user_usr])
            @user_profile.update_attributes(test_user[:user_profile_attributes])
            @user_bank = @user_usr.user_bank_detail.present? ? @user_usr.user_bank_detail : UserBankDetail.new
            flag_curation = true
          else
            if !params[:city].nil? && params[:city]!=""
              city_se = City.where("city_name='#{params[:city]}'").last
              if !city_se.nil?
                @latitude  = city_se.latitude
                @longitude  = city_se.longitude
              end
            end
            test = { :user_usr => {:latitude =>@latitude , :longitude =>@longitude, :user_name => @p_name,:email_address=>@p_email, :user_password=> Base64.encode64("#{params[:sell_password]}"),:user_type=>"P",:user_created_date=> createdate, :user_expiry_date => expirydate,:account_active_status => active_status_u, :user_flag => true, :show_card => true, :user_plan=>"sell", :manage_plan=>@plan_sell_manage,
                :user_profile_attributes => { :business_name => @buis_name, :first_name => @owner2,:last_name => @owner1,:phone=> @phone,:address_2=> @add2,:mobile=> @mobile,:website=> @web,:address_1=> @add1,:fax=> @fax,:administrator=> @admin,
                  :city=> @city,:zip_code=> @zip,:state=>@state,:country=>@country,:business_language=>@lang,:time_zone=>@time_zone, :profile=>@ava, :card=>@card, :description=>@sell_description, :inserted_date =>createdate, :modified_date => createdate  } } }
            #school save
            @user_usr = User.create(test[:user_usr]) if !city_se.nil?
            #@old_contact=ContactUser.find_all_by_contact_email(@user_usr.email_address)
            @old_contact=ContactUser.where("lower(contact_email)= ? ",@user_usr.email_address.downcase) if @user_usr && @user_usr.email_address.present?
            @old_contact.each do |con|
              con.update_attributes(:fam_user_id =>@user_usr.user_id,:contact_user_type=>"member")
            end if !@old_contact.nil?
            flag_curation = false
          end #curator condition ended
	 
          #-----------------stored the bank information-----------------------------------------#
          if @user_usr && @user_usr.errors.empty?
            if !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="bankinfo"
              UserBankDetail.user_bank_form(@user_usr.user_id,params[:bank_name],params[:account_name],params[:w_transfer],params[:acc_number],params[:bank_state],params[:bank_city],params[:bank_z_code],params[:street_bank_code]) if !@user_usr.nil? && @user_usr != ""
            elsif !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="check"
              UserBankDetail.user_check_form(@user_usr.user_id,params[:paye_name],params[:c_business_name],params[:street_check_code],params[:bank_state],params[:check_bank_city],params[:check_z_code],params[:bank_country]) if !@user_usr.nil? && @user_usr != ""
            end
            discount_dollar_submit(@user_usr)
            credit_for_user(@user_usr)
            @u_success=true
          end #@user_usr ending here
          #-----------------stored the bank information ending here-----------------------------------------#
          #==============================================================#
      
        else#school condition else part started here.
          school_reg = "school__not_present"
          #authorize net started by rajkumar
          if !@buis_name.nil? && @buis_name!=''
            @b_name= @buis_name[0..8].strip+"#{Time.now.strftime("%S")}"
          else
            @b_name="#{Time.now.strftime("%S")}"
          end
          if @partner_reg=='partner_register'		  
            curated_user = User.where("email_address=? and user_plan=?",@p_email,'curator').first
            @plan_sell_manage = params[:plan_sell_manage]  if !params[:plan_sell_manage].nil? && params[:plan_sell_manage]!=""
            if params[:invite_user_id] && params[:invite_user_id].present? && !params[:invite_user_id].empty?
              active_status_u = true
            else
              active_status_u = false
            end
            if (curated_user.present? && !curated_user.nil? && params[:curated_user_sell]=='cur_user')
              test_user = { :user_usr => {:user_name => @p_name,
                  :email_address=>@p_email, :user_password=> Base64.encode64("#{params[:sell_password]}"),:user_type=>"P",:user_created_date=> createdate,
                  :user_expiry_date => expirydate,:account_active_status => active_status_u, :user_flag => true,:user_plan=>"sell",:is_partner => true, :show_card => true, :manage_plan=>@plan_sell_manage},:user_profile_attributes => { :business_name => @buis_name, :first_name => @owner2,:last_name => @owner1,:phone=> @phone,:address_2=> @add2,
                  :mobile=> @mobile,:website=> @web,:address_1=> @add1,:fax=> @fax,:administrator=> @admin,
                  :city=> @city,:zip_code=> @zip,:state=>@state,:country=>@country,:business_language=>@lang,:time_zone=>@time_zone, :profile=>@ava, :card=>@card, :description=>@sell_description, :inserted_date =>createdate, :modified_date => createdate  }}
              @user_usr = curated_user
              @user_profile = @user_usr.user_profile
              @user_usr.update_attributes(test_user[:user_usr])
              @user_profile.update_attributes(test_user[:user_profile_attributes])
              @user_bank = @user_usr.user_bank_detail.present? ? @user_usr.user_bank_detail : UserBankDetail.new
              flag_curation = true
            else
              if !params[:city].nil? && params[:city]!=""
                city_se = City.where("city_name='#{params[:city]}'").last
                if !city_se.nil?
                  @latitude  = city_se.latitude
                  @longitude  = city_se.longitude
                end

              end

              test = { :user_usr => {:latitude =>@latitude , :longitude =>@longitude, :user_name => @p_name,:email_address=>@p_email, :user_password=> Base64.encode64("#{params[:sell_password]}"),:user_type=>"P",:user_created_date=> createdate, :user_expiry_date => expirydate,:account_active_status => active_status_u, :user_flag => true, :show_card => true, :user_plan=>"sell",:is_partner => true, :manage_plan=>@plan_sell_manage,
                  :user_profile_attributes => { :business_name => @buis_name, :first_name => @owner2,:last_name => @owner1,:phone=> @phone,:address_2=> @add2,:mobile=> @mobile,:website=> @web,:address_1=> @add1,:fax=> @fax,:administrator=> @admin,
                    :city=> @city,:zip_code=> @zip,:state=>@state,:country=>@country,:business_language=>@lang,:time_zone=>@time_zone, :profile=>@ava, :card=>@card, :description=>@sell_description, :inserted_date =>createdate, :modified_date => createdate  } } }
              @user_usr = User.create(test[:user_usr])
              flag_curation = false
		        end #curator condition ended
		
            if !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="bankinfo"
              UserBankDetail.user_bank_form(@user_usr.user_id,params[:bank_name],params[:account_name],params[:w_transfer],params[:acc_number],params[:bank_state],params[:bank_city],params[:bank_z_code],params[:street_bank_code]) if !@user_usr.nil? && @user_usr != ""
            elsif !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="check"
              UserBankDetail.user_check_form(@user_usr.user_id,params[:paye_name],params[:c_business_name],params[:street_check_code],params[:bank_state],params[:check_bank_city],params[:check_z_code],params[:bank_country]) if !@user_usr.nil? && @user_usr != ""
            end
            discount_dollar_submit(@user_usr)
            credit_for_user(@user_usr)
            @u_success=true
		
          else
            customer_profile_information = {
              :profile     => {
                :merchant_customer_id =>@b_name,
                :email => @p_email
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
                @payment_profile_user = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>create_profile.authorization, :customer_payment_profile_id=>pay_profile.params["customer_payment_profile_id"])
                #===========transaction started here for the register user===============#
                if !params[:plan_sell_manage].nil? && params[:plan_sell_manage] !=""
                  if params[:plan_sell_manage]=="market_sell"
                    @usr_tran_amt = "#{$market_sell_u}" #marget sell user amount 29.95$
                    sales_pro_limit = 25
                    plan_amount_tot = "#{$market_sell_u}"
                  elsif params[:plan_sell_manage]=="market_sell_manage"
                    @usr_tran_amt = "#{$market_sell_manage_u}" #marget sell user amount 49.95$
                    sales_pro_limit = 75
                    plan_amount_tot = "#{$market_sell_manage_u}"
                  elsif params[:plan_sell_manage]=="market_sell_manage_plus"
                    @usr_tran_amt = "#{$market_sell_manage_plus_u}" #marget sell user amount 99.95$
                    sales_pro_limit = 150
                    plan_amount_tot = "#{$market_sell_manage_plus_u}"
                  end
                end #sell manage user
                #transaction for the user
                transaction = {:transaction => {
                    :type => :auth_capture,
                    :amount => "#{@usr_tran_amt}", #marget sell registrations
                    :customer_profile_id => create_profile.authorization,
                    :customer_payment_profile_id => pay_profile.params["customer_payment_profile_id"]
                  }
                }
                response = CIMGATEWAY.create_customer_profile_transaction(transaction)

			
                if !response.nil? && response.success?
                  provider_trans_id = "#{response.authorization}" if !response.nil? && !response.authorization.nil?
                  @failer_message= "#{response.message}" if !response.nil? && !response.message.nil?
                  cookies[:card_msg]=@failer_message if !@failer_message.nil?
                  #=============================store the user information=====================================#
                  #Provider Claim process added
						      #generate temporary password to curator user
						      tcount = 10
						      chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789'
						      @temp_password = ''
						      tcount.times { |i| @temp_password << chars[rand(chars.length)] }
							
						      curated_user = User.where("email_address=? and user_plan=?",@p_email,'curator').first
						      @plan_sell_manage = params[:plan_sell_manage]  if !params[:plan_sell_manage].nil? && params[:plan_sell_manage]!=""
                  if params[:invite_user_id] && params[:invite_user_id].present? && !params[:invite_user_id].empty?
                    active_status_u = true
                  else
							      active_status_u = false
                  end
						      if (curated_user.present? && !curated_user.nil? && params[:curated_user_sell]=='cur_user')
                    test_user = { :user_usr => {:user_name => @p_name,
                        :email_address=>@p_email, :user_password=> Base64.encode64("#{params[:sell_password]}"),:user_type=>"P",:user_created_date=> createdate,
                        :user_expiry_date => expirydate,:account_active_status => active_status_u, :user_flag => true,:user_plan=>"sell", :show_card => true, :manage_plan=>@plan_sell_manage},:user_profile_attributes => { :business_name => @buis_name, :first_name => @owner2,:last_name => @owner1,:phone=> @phone,:address_2=> @add2,
                        :mobile=> @mobile,:website=> @web,:address_1=> @add1,:fax=> @fax,:administrator=> @admin,
                        :city=> @city,:zip_code=> @zip,:state=>@state,:country=>@country,:business_language=>@lang,:time_zone=>@time_zone, :profile=>@ava, :card=>@card, :description=>@sell_description, :inserted_date =>createdate, :modified_date => createdate  }}
                    @user_usr = curated_user
                    @user_profile = @user_usr.user_profile
                    @user_usr.update_attributes(test_user[:user_usr])
                    @user_profile.update_attributes(test_user[:user_profile_attributes])
                    @user_bank = @user_usr.user_bank_detail.present? ? @user_usr.user_bank_detail : UserBankDetail.new
                    flag_curation = true
                  else


                    if !params[:city].nil? && params[:city]!=""
                      city_se = City.where("city_name='#{params[:city]}'").last
                      if !city_se.nil?
                        @latitude  = city_se.latitude
                        @longitude  = city_se.longitude

                      end

                    end

                    test = { :user_usr => {:latitude =>@latitude , :longitude =>@longitude, :user_name => @p_name,:email_address=>@p_email, :user_password=> Base64.encode64("#{params[:sell_password]}"),:user_type=>"P",:user_created_date=> createdate, :user_expiry_date => expirydate,:account_active_status => active_status_u, :user_flag => true, :show_card => true, :user_plan=>"sell", :manage_plan=>@plan_sell_manage,
                        :user_profile_attributes => { :business_name => @buis_name, :first_name => @owner2,:last_name => @owner1,:phone=> @phone,:address_2=> @add2,:mobile=> @mobile,:website=> @web,:address_1=> @add1,:fax=> @fax,:administrator=> @admin,
                          :city=> @city,:zip_code=> @zip,:state=>@state,:country=>@country,:business_language=>@lang,:time_zone=>@time_zone, :profile=>@ava, :card=>@card, :description=>@sell_description, :inserted_date =>createdate, :modified_date => createdate  } } }
                    #provdier save
                    @user_usr = User.create(test[:user_usr])
                    # @old_contact=ContactUser.find_all_by_contact_email(@user_usr.email_address.downcase)
                    @old_contact=ContactUser.where("lower(contact_email)= ? ",@user_usr.email_address.downcase)
                    @old_contact.each do |con|
                      con.update_attributes(:fam_user_id =>@user_usr.user_id,:contact_user_type=>"member")
                    end if !@old_contact.nil?
                    flag_curation = false
                  end #curator condition ended
                  #-----------------------------store to the transaction details------------------------------------------#
                  if params[:invite_user_id] && params[:invite_user_id].present? && !params[:invite_user_id].empty?
                    @p_trans = ProviderTransaction.create(:user_id=>@user_usr.user_id, :amount=>@usr_tran_amt, :user_plan=>@user_usr.manage_plan, :customer_profile_id=>create_profile.authorization, :customer_payment_profile_id=>pay_profile.params["customer_payment_profile_id"], :inserted_date=>Time.now, :modified_date=>Time.now, :start_date=>Time.now, :end_date=>Time.now+30.days, :grace_period_date=>Time.now+37.days, :sales_limit=>sales_pro_limit, :purchase_limit=>0, :expiry_status=>true, :payment_date=>Time.now, :plan_amount=>plan_amount_tot, :email_address=>@user_usr.email_address, :transaction_id=>provider_trans_id) if !@user_usr.nil? && !@usr_tran_amt.nil?
                  else
                    @p_trans = ProviderTransaction.create(:user_id=>@user_usr.user_id, :amount=>@usr_tran_amt, :user_plan=>@user_usr.manage_plan, :customer_profile_id=>create_profile.authorization, :customer_payment_profile_id=>pay_profile.params["customer_payment_profile_id"], :inserted_date=>Time.now, :modified_date=>Time.now, :sales_limit=>sales_pro_limit, :purchase_limit=>0, :expiry_status=>true, :payment_date=>Time.now, :plan_amount=>plan_amount_tot, :email_address=>@user_usr.email_address, :transaction_id=>provider_trans_id) if !@user_usr.nil? && !@usr_tran_amt.nil?
                  end
                  #-----------------------------------------------------------------------#
                  if @user_usr && @user_usr.errors.empty?
                    #bank details stored
                    @user_transaction = UserTransaction.new
                    @user_transaction.customer_profile_id = create_profile.authorization
                    @user_transaction.customer_payment_profile_id = pay_profile.params["customer_payment_profile_id"]
                    @user_transaction.user_id = @user_usr.user_id
                    @user_transaction.inserted_date = Time.now
                    @user_transaction.save
                    if !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="bankinfo"
                      UserBankDetail.user_bank_form(@user_usr.user_id,params[:bank_name],params[:account_name],params[:w_transfer],params[:acc_number],params[:bank_state],params[:bank_city],params[:bank_z_code],params[:street_bank_code]) if !@user_usr.nil? && @user_usr != ""
                    elsif !params[:radio_value].nil? && params[:radio_value].present? && params[:radio_value]=="check"
                      UserBankDetail.user_check_form(@user_usr.user_id,params[:paye_name],params[:c_business_name],params[:street_check_code],params[:bank_state],params[:check_bank_city],params[:check_z_code],params[:bank_country]) if !@user_usr.nil? && @user_usr != ""
                    end
                    discount_dollar_submit(@user_usr)
                    credit_for_user(@user_usr)
                    @u_success=true
                    #provider transaction details started stored user information after success or failure
                    ProviderTransactionLog.create(:email_address=>@p_email, :amount=>@usr_tran_amt, :action_type=>"new_signup", :customer_payment_profile_id=>pay_profile.params["customer_payment_profile_id"], :customer_profile_id=>create_profile.authorization, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{response.message}", :payment_status=>"success", :transaction_id=>provider_trans_id, :user_id=>@user_usr.user_id) if @user_usr
                    #provider transaction details ended here
                  end #@user_usr ending here
                  #=============================store the user information ending====================================#
                else
                  @failer_message= "#{response.message}" if !response.nil? && !response.message.nil?
                  cookies[:card_msg]=@failer_message if !@failer_message.nil?
                  #provider transaction details started stored user information after success or failure
                  ProviderTransactionLog.create(:email_address=>@p_email, :amount=>@usr_tran_amt, :action_type=>"new_signup", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{response.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>nil)
                  #provider transaction details ended here
                  @u_success=false
                end
                #===========transaction ending here for the register user================#
              else #payment profile else part
                #provider transaction details started stored user information after success or failure
                ProviderTransactionLog.create(:email_address=>@p_email,:amount=>@usr_tran_amt, :action_type=>"new_signup", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{pay_profile.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>nil)
                #provider transaction details ended here
                @u_success=false
              end
            else #create profile else part
              @u_success=false
              @failer_message = create_profile.message if !create_profile.nil?
              #provider transaction details started stored user information after success or failure
              ProviderTransactionLog.create(:email_address=>@p_email,:amount=>@usr_tran_amt, :action_type=>"new_signup", :customer_payment_profile_id=>nil, :customer_profile_id=>nil, :inserted_date=>Time.now, :modified_date=>Time.now, :payment_date=>Time.now, :payment_message=>"#{create_profile.message}", :payment_status=>"failure", :transaction_id=>nil, :user_id=>nil)
              #provider transaction details ended here
            end  #create profile ending
            #authorize net end
          end #partner registeration end
        end #school ending
        #school flow condition ending here by rajkumar
	
	
       
        if @user_usr && @user_usr.errors.empty? && @u_success
          #activation email to user
          if params[:invite_user_id] && params[:invite_user_id].present? && !params[:invite_user_id].empty?

            #welcome mail
            if !@user_usr.nil? && @user_usr.user_flag==TRUE
              @credit_list = UserCredit.where("user_id=?",@user_usr.user_id)
              @t_cred_amount =  (!@credit_list.nil?) ? @credit_list.sum(&:credit_amount) : 0
              UserMailer.delay(queue: "Welcome Mail", priority: 1, run_at: 5.seconds.from_now).famtivity_welcome(@user_usr,@get_current_url,@t_cred_amount)
            end
          else
            #curator user register as provider to send mail to eileen
            if flag_curation
              @result = UserMailer.delay(queue: "curator Upgrade", priority: 2, run_at: 10.seconds.from_now).curator_upgrade_info(@user_usr)
            end
            if params[:plan_sell_manage] && !params[:plan_sell_manage].nil? && params[:plan_sell_manage]!="" && params[:plan_sell_manage].present? && params[:plan_sell_manage]=="school"
              #----dont sent a mail to school provider#
              UserMailer.delay(queue: "School registration mail to admin", priority: 1, run_at: 5.seconds.from_now).school_register_toadmin(@user_usr,@get_current_url)
              UserMailer.delay(queue: "School registration to provider", priority: 1, run_at: 5.seconds.from_now).school_register_to_provider(@user_usr)
            else
              UserMailer.delay(queue: "User Register", priority: 1, run_at: 5.seconds.from_now).register_user(@user_usr,@get_current_url,flag_curation)
            end
          end
	  
          #==============Newsletter subscribe for COTC domain starting ===========================#
          #news_letter_signup(@user_usr.email_address,params[:city])
          #Cotc Update for the register email
          cotc_for_provider
          #==============Newsletter subscribe for COTC domain ending===========================#
	 
          #amount detection mail to provider user
          if params[:plan_sell_manage] && !params[:plan_sell_manage].nil? && params[:plan_sell_manage]!="" && params[:plan_sell_manage].present? && params[:plan_sell_manage]=="school"
            #nothing for school#
          else
            if !@user_usr.is_partner
              UserMailer.delay(queue: "User Register Transaction", priority: 1, run_at: 10.seconds.from_now).register_user_transaction(@user_usr,@usr_tran_amt)
            end
          end
          cookies[:city_registered_usr] = cookies[:city_new_usr]
          #render :partial=>'provider_sell_thank'
          if params[:invite_user_id] && params[:invite_user_id].present? && !params[:invite_user_id].empty?
            @return_status=@user_usr.user_id if !@user_usr.nil? && !@user_usr.user_id.nil?
            @msg_page=params[:msg_value] if !params[:msg_value].nil? && params[:msg_value]!=""
            if !@msg_page.nil?
              cookies[:message]="message"
              # @old_msg = MessageThreadViewer.find_all_by_user_email(@user_usr.email_address) if !@user_usr.nil?
              @old_msg = MessageThreadViewer.where("lower(user_email)= ? ",@user_usr.email_address.downcase) if !@user_usr.nil?
              if !@old_msg.nil? && !@user_usr.nil?
                @old_msg.each do |msg|
                  msg.update_attributes(:user_id=>@user_usr.user_id)
                end
              end
            end
            #add friend start
            @invite_user=User.find_by_user_id(params[:invite_user_id]) if !params[:invite_user_id].nil?
            if @invite_user
              @contact_user = ContactUser.new
              @contact_user.contact_name = @invite_user.user_name if !@invite_user.user_name.nil?
              @contact_user.contact_email = @invite_user.email_address.downcase if !@invite_user.email_address.nil?
              @contact_user.user_id = @user_usr.user_id if !@user_usr.nil? && !@user_usr.user_id.nil?
              @contact_user.inserted_date = Time.now
              @contact_user.modified_date = Time.now
              @contact_user.contact_user_type = 'friend'
              @contact_user.accept_status = true
              @contact_user.contact_type = 'famtivity'
              @contact_user.fam_user_id = @invite_user.user_id if !@invite_user.user_id.nil?
              @contact_user.inserted_date = Time.now
              @contact_user.modified_date = Time.now
              @contact_user.save
              cookies[:fam_invited_user]=@invite_user.email_address if !@invite_user.email_address.nil?
            end
            #add friend end
          elsif school_reg=="school_present"
            @return_status="school"
          elsif @partner_reg == "partner_register"
            @return_status="partner"
          else
            @return_status="success"
          end
      
          render :text=> @return_status.to_json
        else
          @return_status="failed"
          render :text=> @return_status.to_json
          #UserMailer.delay(queue: "User Register", priority: 1, run_at: 5.seconds.from_now).register_user(@user_usr,@get_current_url,flag_curation)
          # render :partial=>'provider_sell_failure'
        end
      end #checking current_user for become a provider end

    else
      redirect_to "/home"
    end #checking empty user end

  end #provider sell submit ending
  


  #~ def provider_sell_submit_old
  #~ #checking current_user for become a provider end
  #~ if !current_user.nil? && !current_user.user_profile.nil?
  #~ @user= User.find_by_user_id(current_user.user_id)
  #~ @user_profile = current_user.user_profile
  #~ @user.email_address = params[:sell_email] if !params[:sell_email].nil?
  #~ @user.user_password = params[:sell_password]
  #~ @user.user_name = params[:sell_name]
  #~ @user.user_type = "P"
  #~ @user.user_plan = "sell"
  #~ @user.save
  #~ @user_profile.business_name = params[:sell_b_name]  if params[:sell_b_name] != "Enter the Name Of your business"
  #~ @user_profile.phone = params[:sell_phone_no]
  #~ @user_profile.mobile = params[:sell_mobile]         if params[:sell_mobile] != "Enter Your Mobile Number"
  #~ @user_profile.fax =params[:sell_fax]                if params[:sell_fax] != "Enter Your Fax Number"
  #~ @user_profile.address_1 = params[:sell_address1]    if params[:sell_address1] != "Enter Address"
  #~ @user_profile.address_2 = params[:sell_address2]    if params[:sell_address2] != "Enter Address"
  #~ @user_profile.owner_first_name = params[:sell_owner_firstname]  if params[:sell_owner_firstname] != "First Name"
  #~ @user_profile.owner_last_name = params[:sell_owner_lastname]    if params[:sell_owner_lastname] != "Last Name"
  #~ @user_profile.website = params[:sell_web_addrs]                 if params[:sell_web_addrs] != "Enter The URL Of Your Website"
  #~ @user_profile.zip_code = params[:sell_zipcode]
  #~ @user_profile.state = params[:state]
  #~ @user_profile.city = params[:city]
  #~ @user_profile.country = params[:country]
  #~ @user_profile.business_language = params[:language_usr]
  #~ @user_profile.profile = params[:activity_image] if !params[:activity_image].nil? && params[:activity_image]!=""
  #~ @user_profile.time_zone = params[:time]
  #~ @user_profile.save
 
  #~ @user_bank = UserBankDetail.new
  #~ @user_bank.bank_name = params[:bank_name]
  #~ @user_bank.bank_wire_transfer = params[:w_transfer]
  #~ @user_bank.bank_clear_house = params[:c_house]
  #~ @user_bank.bank_account_number = params[:acc_number]
  #~ @user_bank.bank_swift_code = params[:swift_code]
  #~ @user_bank.bank_state = params[:street_bank_code]
  #~ @user_bank.bank_city = params[:number_bank_code]
  #~ @user_bank.bank_zip_code = params[:bank_z_code]
  #~ @user_bank.supplier_code = params[:s_code]
  #~ @user_bank.legal_name = params[:l_name]
  #~ @user_bank.tax_code = params[:t_code]
  #~ @user_bank.street_address = params[:street_reg]
  #~ @user_bank.street_number = params[:number_reg]
  #~ @user_bank.perm_state = params[:state_reg]
  #~ @user_bank.prem_city = params[:city_reg]
  #~ @user_bank.prem_zip_code = params[:z_code]
  #~ @user_bank.user_id = current_user.user_id
  #~ @user_bank.save
  #~ profile_data = {
  #~ :profile=>{:email => current_user.email_address.downcase}
  #~ }
  #~ create_profile = CIMGATEWAY.create_customer_profile(profile_data)
  #~ if create_profile.success?
  #~ billing_info = {
  #~ :first_name => params[:first_name_sell],
  #~ :last_name => params[:last_name_sell],
  #~ :address => "#{params[:activity][:address_1]}" + "#{params[:activity][:address_2]}",
  #~ :city => @city,
  #~ :zip => @zip,
  #~ :phone_number => @phone,
  #~ :fax_number => @fax
  #~ }

  #~ credit_card = ActiveMerchant::Billing::CreditCard.new(
  #~ :first_name => params[:first_name_sell],
  #~ :last_name => params[:last_name_sell],
  #~ :number => "#{params[:sell_cardnumber_1]}" + "#{params[:sell_cardnumber_2]}" + "#{params[:sell_cardnumber_3]}" + "#{params[:sell_cardnumber_4]}",
  #~ :month => params[:sell_date_card],
  #~ :year => params[:sell_year_card_1],
  #~ :verification_value => params[:sell_cardnumber_5].to_i, #verification codes are now required
  #~ :type => 'visa'
  #~ )

  #~ payment_profile = {
  #~ :bill_to => billing_info,
  #~ :payment => {
  #~ :credit_card => credit_card
  #~ }
  #~ }

  #~ options = {
  #~ :customer_profile_id => create_profile.authorization,
  #~ :payment_profile => payment_profile
  #~ }

  #~ pay_profile = CIMGATEWAY.create_customer_payment_profile(options)
  #~ if pay_profile.success?
  #~ @user_transaction = UserTransaction.new
  #~ @user_transaction.customer_profile_id = create_profile.authorization
  #~ @user_transaction.customer_payment_profile_id=pay_profile.params["customer_payment_profile_id"]
  #~ @user_transaction.user_id = current_user.user_id
  #~ @user_transaction.save
  #~ end
  #~ else
  #~ puts "Error: {response.message}"
  #~ end
  #~ @get_current_url = request.env['HTTP_HOST']
  #~ @c_user = current_user
  #~ @plan = "sell"
  #~ if !@c_user.nil? && @c_user.user_flag==TRUE
  #~ UserMailer.delay(queue: "Become Provider", priority: 1, run_at: 5.seconds.from_now).become_provider_user(@c_user,@get_current_url,@plan)
  #~ end
  #~ #UserMailer.become_provider_user(@c_user,@get_current_url,@plan).deliver
  #~ render :partial=>'become_provider_market_thank'

  #~ else
  #~ createtime = Time.now
  #~ expirytime = createtime + (30*24*60*60)
  #~ createdate = createtime.strftime("%Y-%m-%d %H:%M:%S")
  #~ expirydate = expirytime.strftime("%Y-%m-%d %H:%M:%S")
  #~ @buis_name = params[:sell_b_name] if params[:sell_b_name] != "Enter the Name Of your business"
  #~ @phone = params[:sell_phone_no]
  #~ @mobile = params[:sell_mobile] if params[:sell_mobile] != "Enter Your Mobile Number"
  #~ @fax = params[:sell_fax]
  #~ @add1 = params[:sell_address1]         if params[:sell_address1] != "Enter Address"
  #~ @add2 = params[:sell_address2]         if params[:sell_address2] != "Enter Address"
  #~ @owner1 = params[:sell_owner_lastname] if params[:sell_owner_lastname] != "Last Name"
  #~ @owner2 = params[:sell_owner_firstname] if params[:sell_owner_firstname] != "First Name"
  #~ @web = params[:sell_web_addrs]         if params[:sell_web_addrs] != "Enter The URL Of Your Website"
  #~ @zip = params[:sell_zipcode]
  #~ @state = params[:state]
  #~ @city = params[:city]
  #~ @country = params[:country]
  #~ @zip =  params[:sell_zipcode]
  #~ @lang = params[:language_usr]
  #~ @p_name = params[:sell_name]
  #~ @p_email = params[:sell_email].downcase if !params[:sell_email].nil?
  #~ @ava = params[:activity_image] if !params[:activity_image].nil? && params[:activity_image]!=""
  #~ @time_zone = params[:time]

  #~ test = { :user_usr => {:user_name => @p_name,
  #~ :email_address=>@p_email, :user_password=>params[:sell_password],:user_type=>"P",:user_created_date=> createdate,
  #~ :user_expiry_date => expirydate,:account_active_status => false, :user_flag => true,:user_plan=>"sell",
  #~ :user_profile_attributes => { :business_name => @buis_name, :first_name => @owner2,:last_name => @owner1,:phone=> @phone,:address_2=> @add2,
  #~ :mobile=> @mobile,:website=> @web,:address_1=> @add1,:fax=> @fax,:administrator=> @admin,
  #~ :city=> @city,:zip_code=> @zip,:state=>@state,:country=>@country,:business_language=>@lang,:time_zone=>@time_zone, :profile=>@ava, :inserted_date =>createdate, :modified_date => createdate  } } }

  #~ @user_usr = User.create(test[:user_usr])

  #~ if @user_usr && @user_usr.errors.empty?
  #~ @user_bank = UserBankDetail.new
  #~ @user_bank.bank_name = params[:bank_name]
  #~ @user_bank.bank_wire_transfer = params[:w_transfer]
  #~ @user_bank.bank_clear_house = params[:c_house]
  #~ @user_bank.bank_account_number = params[:acc_number]
  #~ @user_bank.bank_swift_code = params[:swift_code]
  #~ @user_bank.bank_state = params[:street_bank_code]
  #~ @user_bank.bank_city = params[:number_bank_code]
  #~ @user_bank.bank_zip_code = params[:bank_z_code]
  #~ @user_bank.supplier_code = params[:s_code]
  #~ @user_bank.legal_name = params[:l_name]
  #~ @user_bank.tax_code = params[:t_code]
  #~ @user_bank.street_address = params[:street_reg]
  #~ @user_bank.street_number = params[:number_reg]
  #~ @user_bank.perm_state = params[:state_reg]
  #~ @user_bank.prem_city = params[:city_reg]
  #~ @user_bank.prem_zip_code = params[:z_code]
  #~ @user_bank.user_id = @user_usr.user_id
  #~ @user_bank.save
  #~ profile_data = {
  #~ :profile=>{:email => params[:sell_email].downcase}
  #~ }
  #~ create_profile = CIMGATEWAY.create_customer_profile(profile_data)
  #~ if create_profile.success?
  #~ billing_info = {
  #~ :first_name => params[:first_name_sell],
  #~ :last_name => params[:last_name_sell],
  #~ :address => "#{params[:activity][:address_1]}" + "#{params[:activity][:address_2]}",
  #~ :city => @city,
  #~ :zip => @zip,
  #~ :phone_number => @phone,
  #~ :fax_number => @fax
  #~ }

  #~ credit_card = ActiveMerchant::Billing::CreditCard.new(
  #~ :first_name => params[:first_name_sell],
  #~ :last_name => params[:last_name_sell],
  #~ :number => "#{params[:sell_cardnumber_1]}" + "#{params[:sell_cardnumber_2]}" + "#{params[:sell_cardnumber_3]}" + "#{params[:sell_cardnumber_4]}",
  #~ :month => params[:sell_date_card],
  #~ :year => params[:sell_year_card_1],
  #~ :verification_value => params[:sell_cardnumber_5].to_i, #verification codes are now required
  #~ :type => 'visa'
  #~ )

  #~ payment_profile = {
  #~ :bill_to => billing_info,
  #~ :payment => {
  #~ :credit_card => credit_card
  #~ }
  #~ }

  #~ options = {
  #~ :customer_profile_id => create_profile.authorization,
  #~ :payment_profile => payment_profile
  #~ }

  #~ pay_profile = CIMGATEWAY.create_customer_payment_profile(options)
  #~ if pay_profile.success?
  #~ @user_transaction = UserTransaction.new
  #~ @user_transaction.customer_profile_id = create_profile.authorization
  #~ @user_transaction.customer_payment_profile_id=pay_profile.params["customer_payment_profile_id"]
  #~ @user_transaction.user_id = @user_usr.user_id
  #~ @user_transaction.save
  #~ end
  #~ else
  #~ puts "Error: {response.message}"
  #~ end
  #~ #Cotc Update for the register email
  #~ #uri = URI.parse("http://campaignsonthecloud.com/Update_Registration_Status.aspx?name=#{@p_name.gsub(" ", "%20")}&mobile=#{@mobile}&email_id=#{@p_email.downcase}&country=#{@country.gsub(" ", "%20")}&address=#{@add1.gsub(" ", "%20")}&city=#{@city.gsub(" ", "%20")}&zipcode=#{@zip}&domain_name=famtivity&planname=Sell-Through%20Plan")
  #~ #http = Net::HTTP.new(uri.host, uri.port)
  #~ #request_cotc = Net::HTTP::Get.new(uri.request_uri)
  #~ #begin
  #~ #  response = http.request(request_cotc)
  #~ # rescue Exception => exc
  #~ #  logger.error("Message for the log file #{exc.message}")
  #~ #  flash[:notice] = "Store error message"
  #~ #end
  #~ @get_current_url = request.env['HTTP_HOST']
  #~ UserMailer.delay(queue: "User Register", priority: 1, run_at: 5.seconds.from_now).register_user(@user_usr,@get_current_url)
  #~ # UserMailer.register_user(@user_usr,@get_current_url).deliver
  #~ cookies[:city_registered_usr] = cookies[:city_new_usr]
  #~ flash[:notice]= "You have been successfully Registered"
  #~ render :partial=>'provider_market_thank'
  #~ else
  #~ flash[:notice]= "Already has taken that Email address. Try another."
  #~ if request.xhr?
  #~ respond_to do |format|
  #~ format.js{render :text => "$('#user_name_wrong_sell').html('Looks Like this Email has been Already registered');$('#user_name_wrong_sell').css('display', 'block').fadeOut(10000);"}
  #~ end
  #~ else
  #~ render :partial=>'provider_market_failure'
  #~ end
  #~ end
  #~ end #checking current_user for become a provider end
  #~ end
  

  def register_status_message  
    @status=params[:reg_status] if !params[:reg_status].nil?
    @user_usr=params[:reg_status] if !params[:reg_status].nil? && ((params[:reg_status] !="success")||(params[:reg_status] !="failed") || (params[:reg_status] !="school") || (params[:reg_status] !="partner"))
    @failer_message= cookies[:card_msg] if !cookies[:card_msg].nil?
  end
  
  def provider_sell
    @user_usr = User.new
    @user_usr.build_user_profile
    @owner1 = "First Name"
    @owner2= "Last Name"
    @zip = "Enter Zip Code"
    @buis_name ="Enter the Name Of your business"
    @p_name = "Eg: John Smith"
    @p_email = "Eg:john@gmail.com"

    @phone = "Enter Your Phone Number"
    @mobile = "Enter Your Mobile Number"
    @fax = "Enter Your Fax Number"
    @web= "Enter The URL Of Your Website"
    respond_to do |format|
      format.html
    end
  end


  def user_submit
    @user_usr = User.new
    @user_usr.user_name = params[:username_usr]
    @user_usr.email_address = params[:email_usr].downcase if !params[:email_usr].nil? && params[:email_usr]!=""
    @user_usr.user_password = Base64.encode64("#{params[:password_usr_reg]}")
    @user_usr.user_type = "U"
    @user_usr.user_plan = "free"
    @user_usr.user_created_date = Time.now
    @user_usr.user_expiry_date = Time.now + (30*24*60*60)
    cookies[:beta_ver] = params[:beta_ver] if params[:beta_ver]
    
    @chk_u_activate = ((params[:invite_user_id] && params[:invite_user_id].present? && !params[:invite_user_id].empty?) || (params[:guest_user] && params[:guest_user].present? && params[:guest_user]=='true'))
    
    if @chk_u_activate
      @user_usr.account_active_status = true
      @msg_page=params[:msg_value] if !params[:msg_value].nil? && params[:msg_value]!=""
      if !@msg_page.nil?
        cookies[:message]="message"
      end
      @return_status=@user_usr.user_id if !@user_usr.nil? && !@user_usr.user_id.nil?
    else
      @user_usr.account_active_status = false
      @return_status="success"
    end
    @user_usr.user_flag = TRUE
    @result = @user_usr.save
    @u_cdts = credit_for_user(@user_usr)
    #insert user id to contact table if old friend 
    #@old_contact=ContactUser.find_all_by_contact_email(@user_usr.email_address)
    @old_contact=ContactUser.where("lower(contact_email)= ? ",@user_usr.email_address.downcase) if @user_usr && !@user_usr.nil? && @user_usr.email_address && !@user_usr.email_address.nil?
    @old_contact && @old_contact.each do |con|
      con.update_attributes(:fam_user_id =>@user_usr.user_id,:contact_user_type=>"member")
    end if !@old_contact.nil?

    #@old_msg = MessageThreadViewer.find_all_by_user_email(@user_usr.email_address) if !@user_usr.nil?
    @old_msg = MessageThreadViewer.where("lower(user_email)= ? ",@user_usr.email_address.downcase) if !@user_usr.nil?
    if !@old_msg.nil? && !@user_usr.nil?
      @old_msg.each do |msg|
        msg.update_attributes(:user_id=>@user_usr.user_id)
      end
    end
    if !params[:log_value].nil? && params[:log_value]!="" && params[:log_value]=="reld"
      @log_value="reld"
    end
    if params[:invite_user_id] && params[:invite_user_id].present? && !params[:invite_user_id].empty?
      @msg_page=params[:msg_value] if !params[:msg_value].nil? && params[:msg_value]!=""
      if !@msg_page.nil?
        cookies[:message]="message"
      end

      @invite_user=User.find_by_user_id(params[:invite_user_id]) if !params[:invite_user_id].nil?

      if @invite_user
        @contact_user = ContactUser.new
        @contact_user.contact_name = @invite_user.user_name if !@invite_user.user_name.nil?
        @contact_user.contact_email = @invite_user.email_address.downcase if !@invite_user.email_address.nil?
        @contact_user.user_id = @user_usr.user_id if !@user_usr.nil? && !@user_usr.user_id.nil?
        @contact_user.inserted_date = Time.now
        @contact_user.modified_date = Time.now
        @contact_user.contact_user_type = 'friend'
        @contact_user.accept_status = true
        @contact_user.contact_type = 'famtivity'
        @contact_user.inserted_date = Time.now
        @contact_user.modified_date = Time.now
        @contact_user.fam_user_id = @invite_user.user_id if !@invite_user.user_id.nil?
        @contact_user.save
        cookies[:fam_invited_user]=@invite_user.email_address if !@invite_user.email_address.nil?
      end
      @return_status=@user_usr.user_id if !@user_usr.nil? && !@user_usr.user_id.nil?
    else
      @return_status="success"
    end
	
    success = @user_usr && @user_usr.save
    if success && @user_usr.errors.empty?	    
      #Discount Dollar functionality added
      discount_dollar_submit(@user_usr)
	
      #==============Newsletter subscribe for COTC domain starting ===========================#
      news_letter_signup(@user_usr.email_address,cookies[:current_city],@user_usr)
      #==============Newsletter subscribe for COTC domain ending===========================#      
	
      UserProfile.create(:user_id=> @user_usr.user_id,:inserted_date =>Time.now, :modified_date => Time.now, :city=>cookies[:current_city])
      @get_current_url = request.env['HTTP_HOST']
      if @chk_u_activate
        #welcome mail here
        if !@user_usr.nil? && @user_usr.user_flag==TRUE
          @credit_list = UserCredit.where("user_id=?",@user_usr.user_id)
          @t_cred_amount =  (!@credit_list.nil?) ? @credit_list.sum(&:credit_amount) : 0
          UserMailer.delay(queue: "Welcome Mail", priority: 1, run_at: 5.seconds.from_now).famtivity_welcome(@user_usr,@get_current_url,@t_cred_amount)
        end
      else
        UserMailer.delay(queue: "Parent Register", priority: 1, run_at: 5.seconds.from_now).parent_register_user(@user_usr,@get_current_url)
      end
      #UserMailer.parent_register_user(@user_usr,@get_current_url).deliver
      cookies[:city_registered_usr] = cookies[:city_new_usr]
      #from invited user directly login the user instead send the activation mail by rajkumar
      #~ if params[:invite_user_id] && params[:invite_user_id].present? && !params[:invite_user_id].empty?
      #~ activate_with_login(@user_usr)
      #~ else
      #respond_to do |format|
      #  format.js
      #end
      #~ end
    else
      @user_exist=User.find_by_email_address(params[:email_usr])
      if !@user_exist.nil? && @user_exist.present?
        if !@user_exist.user_plan.nil? && @user_exist.user_plan!='' && @user_exist.user_plan.downcase == 'curator'
          @return_status="curator"
        else
          @return_status="member"
        end
		
      end      
      #respond_to do |format|
      #  format.js{render :text => "$('#user_name_wrong').html('This Email is already registered with Famtivity. Please enter a different Email address');$('#user_name_wrong').css('display', 'block').fadeOut(10000);"}
      #end
    end
    if (params[:guest_user] && params[:guest_user].present? && params[:guest_user]=='true')
      cookies[:date_registered_usr] = Time.now.strftime("%Y-%m-%d") if cookies[:date_registered_usr].nil?
      cookies[:login_usr] = "on"
      cookies[:role_usr]= @user_usr.user_type
      cookies[:logged_in] = "yes"
      session[:user_id] = @user_usr.user_id
      cookies.permanent[:uid_usr] = @user_usr.user_id
      cookies.permanent[:username_usr] = @user_usr.user_name
      cookies[:email_usr] = @user_usr.email_address
      if @user_usr
        add_sign_count = @user_usr.sign_in_count
        @user_usr.sign_in_count = (add_sign_count.nil? || add_sign_count==0) ?  1 : (add_sign_count+1)
        @user_usr.last_sign_in = Time.now
        @user_usr.save
      end
    end
    render :text=> @return_status.to_json
  end

  def check_discount_code
    @disc = AdminDiscountCode.where("lower(discount_code) = '#{params[:discount_code].downcase}' and discount_status ='Active' and discount_max > discount_sign and ((discount_start_date <='#{Date.today} 23:59:59' and discount_end_date >='#{Date.today} 00:00:00')or(discount_start_date is null and discount_end_date is null ))").last
    if @disc
      if params[:apply_discount] == "yes"
        @disc.discount_sign = @disc.discount_sign + 1
        @disc.save
        u_cdts = UserCredit.new
        u_cdts.user_id = current_user.user_id if current_user.present?
        u_cdts.credit_amount = @disc.discount_amount
        u_cdts.provider_plan = current_user.user_plan if current_user.present?
        u_cdts.inserted_date = Time.now
        u_cdts.modified_date = Time.now
        u_cdts.credit_type = "register discount code"
        u_cdts.save
        @get_current_url = request.env['HTTP_HOST']
        UserMailer.delay(queue: "Facebook discount code", priority: 1, run_at: 5.seconds.from_now).user_fb_credit_discount_code(current_user,@get_current_url,params[:discount_code],"#{(number_with_precision @disc.discount_amount, :precision => 2).gsub(/\.00$/, "")}")
        user_id = current_user.user_id

        @cdt_lst = UserCredit.where("user_id=?",user_id)
        @dbt_lst = UserDebit.where("user_id=?",user_id)
        @t_cred_amt =  (!@cdt_lst.nil?) ? @cdt_lst.sum(&:credit_amount) : 0
        @t_debit_amt = (!@dbt_lst.nil?) ? @dbt_lst.sum(&:debited_amount) : 0
        @crt_balance = (@t_cred_amt-@t_debit_amt)
        @total = "$#{(number_with_precision @crt_balance, :precision => 2)}"
        @resp = {:success =>"success",:total_amount=> @total}
        render :text=> @resp.to_json
      else
        render :text=> "success".to_json
      end
    else
      if params[:apply_discount] == "yes"
        @resp = {:success =>"failed"}
        render :text=> @resp.to_json
      else
        render :text=> "failed".to_json
      end
    end
  end



  def internal_provider
    @tags_text = GeneralTag.all
    @user_usr = User.new
    @user_usr.build_user_profile
    @owner1 = "First Name"
    @owner2= "Last Name"
    @zip = "Enter Zip Code"
    @buis_name ="Enter the Name Of your business"
    @p_name = "Eg: John Smith"
    @p_email = "Eg:john@gmail.com"

    @phone = "Enter Your Phone Number"
    @mobile = "Enter Your Mobile Number"
    @fax = "Enter Your Fax Number"
    @web= "Enter The URL Of Your Website"
    respond_to do |format|
      format.html
    end
  end

  #while user clicked the activation link to call this method
  def user_activate
    @user = User.find_by_email_address(params[:email])
    if !@user.nil?
      if @user.account_active_status !=TRUE
        if @user.user_created_date <= @user.user_created_date + 1
          if @user.update_attributes(:account_active_status=>TRUE)
            # insert the credited values $ 5 per registeration start
            # @u_cdts = credit_for_user(@user)
            # insert the credited values $ 5 per registeration end
            #===========provider transaction activation started by rajkumar======================#
            @p_tran_val = ProviderTransaction.find_by_user_id(@user.user_id) if !@user.nil? && @user.present?
            @p_tran_val.update_attributes(:start_date=>Time.now, :end_date=>Time.now+30.days, :grace_period_date=>Time.now+37.days) if !@p_tran_val.nil?
            #===========provider transaction activation ending ======================#
		  
            if @user.user_type == "P"
              #update ito COTC
              cotc_for_user_activate
            end
            @get_current_url = request.env['HTTP_HOST']

            if (params[:curated_flag]=="true")
              UserMailer.delay(queue: "Activity List Mail", priority: 1, run_at: 5.seconds.from_now).curated_user_activities(@user,@get_current_url)
              UserMailer.delay(queue: "curator activation info to fam", priority: 1, run_at: 5.seconds.from_now).curator_actinfo_tofam(@user,@get_current_url)
            else
              if !@user.nil? && @user.user_flag==TRUE
                @credit_list = UserCredit.where("user_id=?",@user.user_id)
                @t_cred_amount =  (!@credit_list.nil?) ? @credit_list.sum(&:credit_amount) : 0
                UserMailer.delay(queue: "Activate Mail", priority: 1, run_at: 5.seconds.from_now).famtivity_welcome(@user,@get_current_url,@t_cred_amount)
              end
            end
      
            #UserMailer.famtivity_welcome(@user,@get_current_url).deliver
            #~ flash[:notice]= "Your account has been activated successfully!"
            #~ redirect_to :controller=>'landing',:action=>'landing_new', :u=>'activated'
            activate_with_login(@user)
            #~ redirect_to :controller=>'landing',:action=>'landing_new'#, :u=>'activated'
          else
            flash[:notice]= "Please contact the administaror!"
            redirect_to :controller=>'landing',:action=>'landing_new', :u=>'not_activate',:email=>params[:email]
          end
        else
          flash[:notice]= "You are Link Has Been Expired.Please contact the administaror!"
          #~ @user.user_profile.destroy() if @user.user_type =="P"
          #~ @user.destroy()
          redirect_to :controller=>'landing',:action=>'landing_new', :u=>'expired',:email=>params[:email]
        end
      else
        #~ flash[:notice]= "You have already activated the account successfully!"
        #~ redirect_to :controller=>'landing',:action=>'landing_new', :u=>'already_activated'
        activate_with_login(@user)
      end
    else
      flash[:notice]= "This Email address does not exist. Please use a different Email!"
      #~ redirect_to :controller=>'login',:action=>'index'
      redirect_to :controller=>'landing',:action=>'landing_new', :u=>'no_id',:email=>params[:email]
    end
  end
  
  
  def  credit_for_user(user)
    if params[:discount_code_sell]
      disc = params[:discount_code_sell]
    elsif params[:discount_code]
      disc = params[:discount_code]
    end
    if disc
      @disc = AdminDiscountCode.where("lower(discount_code) = '#{disc.downcase}' and discount_status ='Active' and discount_max > discount_sign and ((discount_start_date <='#{Date.today} 23:59:59' and discount_end_date >='#{Date.today} 00:00:00')or(discount_start_date is null and discount_end_date is null ))").last
      if @disc
        @disc.discount_sign = @disc.discount_sign + 1
        @disc.save
        u_cdts = UserCredit.new
        u_cdts.user_id = user.user_id if user.present?
        u_cdts.credit_amount = @disc.discount_amount
        u_cdts.provider_plan = user.user_plan if user.present?
        u_cdts.inserted_date = Time.now
        u_cdts.modified_date = Time.now
        u_cdts.credit_type = "register discount code"
        u_cdts.save
      end
    end
    u_cdts = UserCredit.new
    u_cdts.user_id = user.user_id if user.present?
    u_cdts.credit_amount = 20
    u_cdts.provider_plan = user.user_plan if user.present?
    u_cdts.inserted_date = Time.now
    u_cdts.modified_date = Time.now
    u_cdts.credit_type = "register"
    u_cdts.save
    return u_cdts
  end
  
  
  
  #while clicking the activation link redirect to landing page without any credentials
  def activate_with_login(user)
	  @user = user
    ##########while activating the mail go to landing page##############
		if @user
      add_sign_count = @user.sign_in_count
      @user.sign_in_count = (add_sign_count.nil? || add_sign_count==0) ?  1 : (add_sign_count+1)
      @user.last_sign_in = Time.now
      @user.save
		end
		cookies[:date_registered_usr] = Time.now.strftime("%Y-%m-%d") if cookies[:date_registered_usr].nil?
		cookies[:login_usr] = "on"
		cookies[:role_usr]= @user.user_type
		cookies[:logged_in] = "yes"
		session[:user_id] = @user.user_id
		cookies.permanent[:uid_usr] = @user.user_id
		cookies.permanent[:username_usr] = @user.user_name
		cookies[:email_usr] = @user.email_address
    if cookies[:role_usr] == "P"
      redirect_to "/provider?dect=activate&#{@user.user_profile.business_name.parameterize if !@user.nil? && !@user.user_profile.nil? && !@user.user_profile.business_name.nil?}/#{@user.user_profile.city.parameterize if !@user.user_profile.nil? && !@user.user_profile.business_name.nil?}"
    else
      redirect_to "/?dect=activate&email_m=#{Base64.encode64(@user.email_address)}"
    end
			
    ############while activating the mail go to landing page############
  end #activate with login method end

  def provider_register

  end
  
  def register_assign_values
    @is_partner = request.fullpath.split("?")[0].gsub("/","") #To check for partner registeration please dont remove
    @msg_invite=params[:msg_invite] if (!params[:msg_invite].nil? && params[:msg_invite].present?)
    @log_value=params[:log_value] if (!params[:log_value].nil? && params[:log_value].present?)
    @aten_mail=params[:aten_mail] if (!params[:aten_mail].nil? && params[:aten_mail].present?)
    @b_invited_user=params[:invited_user]
    @b_invitee_email=params[:invitee_email]
    @invited_user = Base64.decode64(params[:s_user_id]) if (!params[:s_user_id].nil? && params[:s_user_id].present?)
    @imanager = params[:imanager] if (!params[:imanager].nil? && params[:imanager].present?)
    @invitee_user_email = params[:s_user_email] if (!params[:s_user_email].nil? && params[:s_user_email].present?)
    @curator_val= params[:curator_val] if (!params[:curator_val].nil? && params[:curator_val].present?)
  end
  
  def new_parent_register
    cookies[:beta_ver] = ""
    cookies.delete :beta_ver
    @page_show = "parent"
    register_assign_values
	respond_to do |format|
		if request.xhr?
			format.js
		else
			format.html
		end
	end
  end
  
  def new_provider_register
    @pro_invite=params[:pro_invite] if (!params[:pro_invite].nil? && params[:pro_invite].present?)
    @bcm_invite=params[:bcm_invite] if (!params[:bcm_invite].nil? && params[:bcm_invite].present?)
    register_assign_values
      if params[:pe] && !params[:pe].nil?
        @partner_email = Base64.decode64(params[:pe])
        @u_exists = User.where("email_address=?",@partner_email).first
      end
	respond_to do |format|
		if request.xhr?
			format.js
		else
			format.html
		end
	end
  end
  
  
  def parent_register
    cookies[:beta_ver] = ""
    cookies.delete :beta_ver
    @pro_invite=params[:pro_invite] if (!params[:pro_invite].nil? && params[:pro_invite].present?)
    @bcm_invite=params[:bcm_invite] if (!params[:bcm_invite].nil? && params[:bcm_invite].present?)
    if (params[:provider_reg]=='true' || !params[:view].nil?)
      @page_show = params[:view]
      if params[:pe] && !params[:pe].nil?
        @partner_email = Base64.decode64(params[:pe])
        @u_exists = User.where("email_address=?",@partner_email).first
      end
    elsif !params[:price].nil?
      @page_show = "price"      
    else
      @page_show = "parent"
    end
    @is_partner = request.fullpath.split("?")[0].gsub("/","") #To check for partner registeration please dont remove
    @msg_invite=params[:msg_invite] if (!params[:msg_invite].nil? && params[:msg_invite].present?)
    @log_value=params[:log_value] if (!params[:log_value].nil? && params[:log_value].present?)
    @aten_mail=params[:aten_mail] if (!params[:aten_mail].nil? && params[:aten_mail].present?)
    @b_invited_user=params[:invited_user]
    @b_invitee_email=params[:invitee_email]
    @invited_user = Base64.decode64(params[:s_user_id]) if (!params[:s_user_id].nil? && params[:s_user_id].present?)
    @imanager = params[:imanager] if (!params[:imanager].nil? && params[:imanager].present?)
    @invitee_user_email = params[:s_user_email] if (!params[:s_user_email].nil? && params[:s_user_email].present?)
    @curator_val= params[:curator_val] if (!params[:curator_val].nil? && params[:curator_val].present?)
    #~ @page_show = params[:view] if !params[:view].nil?
    #~ if !params[:invite_user].nil?
    #~ @check_parent = Base64.decode64(params[:invite_user]) if !params[:invite_user].nil?
    #~ @check_invite = params[:parent_reg]
    #~ end
    # group_val cid

  end


  def city_webservice
    @cities  = City.find(:all)
    respond_to do |format|
      format.json   { render :json => @cities.to_json }
    end
  end


  def internal_provider_submit
    createtime = Time.now
    expirytime = createtime + (30*24*60*60)
    createdate = createtime.strftime("%Y-%m-%d %H:%M:%S")
    expirydate = expirytime.strftime("%Y-%m-%d %H:%M:%S")
    @buis_name = params[:b_name] if params[:b_name] != "Enter the Name Of your business"
    @phone = params[:p_phone]
    @mobile = params[:p_mobile]  if params[:p_mobile] != "Enter Your Mobile Number"
    @fax = params[:p_fax] if params[:p_fax] !="Enter Your Fax Number"
    @add1 = params[:address1]	
    @add2 = params[:address2]	
    @owner1 = params[:p_owner_lastname] if params[:p_owner_lastname] != "Last Name"
    @owner2 = params[:p_owner_firstname] if params[:p_owner_firstname] != "First Name"
    @web = params[:web_addrs] if params[:web_addrs] != "Enter The URL Of Your Website"
    @zip = params[:p_zipcode]
    @state = params[:state]
    @city = params[:city]
    @country = params[:country]
    @zip =  params[:p_zipcode]
    @lang = params[:language_usr]
    @p_name = params[:p_name]
    @desc = params[:p_description].strip if params[:p_description] != "Description should not exceed 1000 characters" && params[:p_description] !="" && !params[:p_description].nil?
    @card = params[:card_image] if !params[:card_image].nil? && params[:card_image]!=""
    @p_email = params[:p_email].downcase if !params[:p_email].nil?
    pass_usr = params[:p_password]
    @ava = params[:activity_image] if !params[:activity_image].nil? && params[:activity_image]!=""
    @time_zone = params[:time]
    @category = params[:category].blank? ? "" : params[:category]
    @sub_category = params[:sub_category].blank? ? "" : params[:sub_category]
    @added_by = params[:add_by].blank? ? "" : params[:add_by]
    @tags_txt = params[:provider_tag] if !params[:provider_tag].nil?
    @latitude  = ""
    @longitude  = ""
	if !params[:city].nil? && params[:city]!=""
		city_se = City.where("city_name='#{params[:city]}'").last
		if !city_se.nil?
			@latitude  = city_se.latitude
			@longitude  = city_se.longitude
		end
	end
    
    params = { :user_usr => {:user_name => @p_name,
        :email_address=>@p_email,:user_password=> Base64.encode64("#{pass_usr}"),:user_type=>"P",:user_created_date=> createdate,:show_card=>false,
        :user_expiry_date => expirydate,:account_active_status => true, :user_flag => false,:user_plan=>"curator",:latitude => @latitude, :longitude => @longitude,
        :user_profile_attributes => { :business_name => @buis_name,:owner_first_name => @owner2,:owner_last_name => @owner1,:phone=> @phone,:address_2=> @add2,
          :mobile=> @mobile,:website=> @web,:address_1=> @add1,:fax=> @fax,:administrator=> @admin,
          :city=> @city,:zip_code=> @zip,:card=>@card,:description=>@desc,:state=>@state,:country=>@country,:business_language=>@lang,:time_zone=>@time_zone, :profile=>@ava, :inserted_date =>createdate, :modified_date => createdate ,:category => @category, :sub_category => @sub_category, :added_by=>@added_by, :tags_txt=>@tags_txt  } } }
    @user_usr = User.create(params[:user_usr])
    success = @user_usr
    if success && @user_usr.errors.empty?
      #Cotc Update for the register email  
      cotc_for_provider
     
      if params[:user_mail]==1 && @user_usr.user_flag==TRUE
        @get_current_url = request.env['HTTP_HOST']
        if !@user_usr.nil? && @user_usr.user_flag==TRUE
          flag_curation=false
          UserMailer.delay(queue: "User Register", priority: 1, run_at: 5.seconds.from_now).register_user(@user_usr,@get_current_url,flag_curation)
        end
        #        UserMailer.register_user(@user_usr,@get_current_url).deliver
      end
      cookies[:city_registered_usr] = cookies[:city_new_usr]
      flash[:notice]= "You have been successfully Registered"
      redirect_to :controller=>'login',:action=>'index'
    else
      render :action => 'internal_provider'
    end
  end

  #provider market plan register
  def provider_submit
    if !current_user.nil? && !current_user.user_profile.nil?
      #@user= current_user.user_id
      @user= User.find_by_user_id(current_user.user_id)
      @user_profile = current_user.user_profile
      @user.email_address = params[:p_email]    if !params[:p_email].nil?
      @user.user_password =  Base64.encode64("#{params[:p_password]}")
      @user.user_name = params[:p_name]
      @user.user_type = "P"
      @user.user_plan = "free"
      @user.save
      @user_profile.business_name = params[:b_name]

      @mobile_value = "#{params[:p_mobile_1]}-" +"#{params[:p_mobile_2]}-"+"#{params[:p_mobile_3]}" if params[:p_mobile_1]
      if @mobile_value !="xxx-xxx-xxxx"
        @user_profile.mobile = @mobile_value
      end
      @user_profile.phone = "#{params[:p_phone_1]}-" +"#{params[:p_phone_2]}-"+"#{params[:p_phone_3]}"
      #@user_profile.mobile = "#{params[:p_mobile_1]}-" +"#{params[:p_mobile_2]}-"+"#{params[:p_mobile_3]}" if params[:p_mobile_1] != "111"
      @user_profile.fax =params[:p_fax] if params[:p_fax] != "Enter your fax number"
      @user_profile.address_1 = params[:address1] if params[:address1] != "Enter address"
      @user_profile.address_2 = params[:address2] if params[:address2] != "Enter address"
      @user_profile.owner_first_name = params[:p_owner_firstname] if params[:p_owner_firstname] != "First name"
      @user_profile.owner_last_name = params[:p_owner_lastname] if params[:p_owner_lastname] != "Last name"
      @user_profile.website = params[:web_addrs] if params[:web_addrs] != "Enter the URL of your website"
      @user_profile.zip_code = params[:p_zipcode]
      @user_profile.state = params[:state]  
      @user_profile.city = params[:city]
      @user_profile.country = params[:country]
      @user_profile.business_language = params[:language_usr]
      @user_profile.profile = params[:activity_image] if !params[:activity_image].nil? && params[:activity_image]!=""
      @user_profile.time_zone = params[:time]
      @user_profile.save
      @get_current_url = request.env['HTTP_HOST'] 
      @plan = "free"
      @c_user = current_user

      #authorize.net for become a provider start
      #authorize net start
      customer_profile_information = {
        :profile     => {
          :merchant_customer_id => params[:p_name],
          :email => params[:p_email]
        }
      }
      create_profile = CIMGATEWAY.create_customer_profile(customer_profile_information)

      if !create_profile.nil? && create_profile.success?
        billing_info = {
          :first_name => params[:p_owner_firstname],
          :last_name => params[:p_owner_lastname]
        }

        credit_card = ActiveMerchant::Billing::CreditCard.new(
          :first_name => params[:CardholderFirstName],
          :last_name => params[:CardholderLastName],
          :number => "#{params[:cardnumber_1]}" + "#{params[:cardnumber_2]}" + "#{params[:cardnumber_3]}" + "#{params[:cardnumber_4]}",
          :month => params[:date_card].to_i,
          :year => params[:year_card_1].to_i,
          :verification_value => params[:cardnumber_5], #verification codes are now required
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
      else
        @failer_message = create_profile.message if !create_profile.nil?
        @u_success=false
      end
	    #authorize net end
      @get_current_url = request.env['HTTP_HOST']
      #authorize.net for become a provider end

      if !@c_user.nil? && @c_user.user_flag==TRUE
        UserMailer.delay(queue: "Become Provider", priority: 1, run_at: 5.seconds.from_now).become_provider_user(@c_user,@get_current_url,@plan)
      end
      #UserMailer.become_provider_user(@c_user,@get_current_url,@plan).deliver
      render :partial=>'become_provider_market_thank'

    else #new user registered
      createtime = Time.now
      expirytime = createtime + (30*24*60*60)
      createdate = createtime.strftime("%Y-%m-%d %H:%M:%S")
      expirydate = expirytime.strftime("%Y-%m-%d %H:%M:%S")
      @buis_name = params[:b_name] if params[:b_name] !="Enter the Name Of your business"
      @phone = "#{params[:p_phone_1]}-" +"#{params[:p_phone_2]}-"+"#{params[:p_phone_3]}"
      #@mobile = "#{params[:p_mobile_1]}-" +"#{params[:p_mobile_2]}-"+"#{params[:p_mobile_3]}" if params[:p_mobile_1] != "111"
      @mobile_value = "#{params[:p_mobile_1]}-" +"#{params[:p_mobile_2]}-"+"#{params[:p_mobile_3]}" 
      if @mobile_value !="xxx-xxx-xxxx"
        @mobile = @mobile_value
      end
      @fax = params[:p_fax] if params[:p_fax] !="Enter your fax number"
      @add1 = params[:address1]
      @add2 = params[:address2] if params[:address2] !="Enter address"
      @owner1 = params[:p_owner_lastname] if params[:p_owner_lastname] != "Last name"
      @owner2 = params[:p_owner_firstname] if params[:p_owner_firstname] != "First name"
      @web = params[:web_addrs] if params[:web_addrs] !="Enter the URL of your website"
      @zip = params[:p_zipcode]
      @state = params[:state]
      @city = params[:city]
      @country = params[:country]
      @zip =  params[:p_zipcode]
      @lang = params[:language_usr]
      @p_name = params[:p_name]
      @p_email = params[:p_email].downcase if !params[:p_email].nil?
      pass_usr = params[:p_password]
      @ava = params[:activity_image] if !params[:activity_image].nil? && params[:activity_image]!=""
      @time_zone = params[:time]
      
      curated_user = User.where("email_address=? and user_plan=?",@p_email,'curator').first
      
      if (curated_user.present? && !curated_user.nil? && params[:curated_user]=='cur_user')
        test_user = { :user_usr => {:user_name => @p_name,
            :email_address=>@p_email, :user_password=> Base64.encode64("#{pass_usr}"),:user_type=>"P",:user_created_date=> createdate,
            :user_expiry_date => expirydate,:account_active_status => false, :user_flag => true,:user_plan=>"free"},:user_profile_attributes => { :business_name => @buis_name, :first_name => @owner2,:last_name => @owner1,:phone=> @phone,:address_2=> @add2,
            :mobile=> @mobile,:website=> @web,:address_1=> @add1,:fax=> @fax,:administrator=> @admin,
            :city=> @city,:zip_code=> @zip,:state=>@state,:country=>@country,:business_language=>@lang,:time_zone=>@time_zone, :profile=>@ava, :inserted_date =>createdate, :modified_date => createdate  }}
        @user_usr = curated_user
        @user_profile = @user_usr.user_profile
        @user_usr.update_attributes(test_user[:user_usr])
        @user_profile.update_attributes(test_user[:user_profile_attributes])
        flag_curation = true
      else
        test = { :user_usr => {:user_name => @p_name,
            :email_address=>@p_email,:user_password=> Base64.encode64("#{pass_usr}"),:user_type=>"P",:user_created_date=> createdate,
            :user_expiry_date => expirydate,:account_active_status => false, :user_flag => true,:user_plan=>"free",
            :user_profile_attributes => { :business_name => @buis_name,:owner_first_name => @owner2,:owner_last_name => @owner1,:phone=> @phone,:address_2=> @add2,
              :mobile=> @mobile,:website=> @web,:address_1=> @add1,:fax=> @fax, :administrator=> @admin,
              :city=> @city,:zip_code=> @zip,:state=>@state,:profile=>@ava,:country=>@country,:business_language=>@lang,:time_zone=>@time_zone, :inserted_date =>createdate, :modified_date => createdate  } } }
        @user_usr = User.create(test[:user_usr])
        flag_curation = false
      end

      #authorize net start
      customer_profile_information = {
        :profile     => {
          :merchant_customer_id => @p_name ,
          :email => @p_email
        }
      }
      create_profile = CIMGATEWAY.create_customer_profile(customer_profile_information)
  
      #billing_info = {:first_name => "#{@owner2}",:last_name => "#{@owner1}",:address => "#{@add1}" + "#{@add2}",:city => @city,:zip => @zip,:phone_number => @phone,:fax_number => @fa}

      if !create_profile.nil? && create_profile.success?
        billing_info = {
          :first_name => "#{@owner2}",
          :last_name => "#{@owner1}"
        }

        credit_card = ActiveMerchant::Billing::CreditCard.new(
          :first_name => params[:CardholderFirstName],
          :last_name => params[:CardholderLastName],
          :number => "#{params[:cardnumber_1]}" + "#{params[:cardnumber_2]}" + "#{params[:cardnumber_3]}" + "#{params[:cardnumber_4]}",
          :month => params[:date_card].to_i,
          :year => params[:year_card_1].to_i,
          :verification_value => params[:cardnumber_5], #verification codes are now required
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
        if !pay_profile.nil? && pay_profile.success?
          @user_transaction = UserTransaction.new
          @user_transaction.customer_profile_id = create_profile.authorization
          @user_transaction.customer_payment_profile_id = pay_profile.params["customer_payment_profile_id"]
          @user_transaction.user_id = @user_usr.user_id
          @user_transaction.inserted_date = Time.now
          @user_transaction.save
          @u_success=true
        else
          @u_success=false
        end
      else
        @failer_message = create_profile.message if !create_profile.nil?
        @u_success=false
      end
	    #authorize net end
      discount_dollar_submit(@user_usr)
      #Cotc Update for the register email
      cotc_for_provider

      @get_current_url = request.env['HTTP_HOST']
      success = @user_usr
      if success && @user_usr.errors.empty? && @u_success
        UserMailer.delay(queue: "User Register", priority: 1, run_at: 5.seconds.from_now).register_user(@user_usr,@get_current_url,flag_curation)
        cookies[:city_registered_usr] = cookies[:city_new_usr]
        render :partial=>'provider_market_thank'
      else
        if !@user_usr.nil? && @user_usr.errors.empty?
          UserMailer.delay(queue: "User Register", priority: 1, run_at: 5.seconds.from_now).register_user(@user_usr,@get_current_url,flag_curation)
        end
        render :partial=>'provider_market_failure'
      end
    end
  end


  def provider_market
    @user_usr = User.new
    @user_usr.build_user_profile
    @owner1 = "First Name"
    @owner2= "Last Name"
    @zip = "Enter Zip Code"
    @buis_name ="Enter the Name Of your business"
    @p_name = "Eg: John Smith"
    @p_email = "Eg:john@gmail.com"

    @phone = "Enter Your Phone Number"
    @mobile = "Enter Your Mobile Number"
    @fax = "Enter Your Fax Number"
    @web= "Enter The URL Of Your Website"
    respond_to do |format|
      format.html
    end
  end

  def provider_sponsor
    @bid_amount = params[:bidamount]
    @budget = params[:budget]
    @user_usr = User.new
    @user_usr.build_user_profile
    @owner1 = "First Name"
    @owner2= "Last Name"
    @zip = "Enter Zip Code"
    @buis_name ="Enter the Name Of your business"
    @p_name = "Eg: John Smith"
    @p_email = "Eg:john@gmail.com"

    @phone = "Enter Your Phone Number"
    @mobile = "Enter Your Mobile Number"
    @fax = "Enter Your Fax Number"
    @web= "Enter The URL Of Your Website"
    respond_to do |format|
      format.html
    end
  end
  

  #~ To send mail manually
  def activate_email
	  u_email = params[:email].split(",")
	  success_user = ''
	  failure_user = ''
	  u_email.each do |user|
	    @chk_user = User.where('email_address=?',user).first
	    if @chk_user
        @get_current_url = request.env['HTTP_HOST']
        ##Send Original Activation Link if mail not sent
        #UserMailer.delay(queue: "Parent Register", priority: 1, run_at: 5.seconds.from_now).parent_register_user(@chk_user,@get_current_url)
        
        ##Resending the activation link for activation failure
        UserMailer.delay(queue: "Parent Register", priority: 1, run_at: 5.seconds.from_now).parent_user_resend_activation(@chk_user,@get_current_url)
        success_user.concat(user+',')
      else
        failure_user.concat(user+',')
      end
    end
    @test = Hash.new
    @test['success']=success_user
    @test['failure']=failure_user
    response.content_type = Mime::JSON
    render :text => @test.to_json
  end
  
  
  def discount_dollar_submit(user_usr)
	  if params[:invite_user_id].present? && !params[:invite_user_id].empty?
      @cont_user = ContactUser.where("contact_email=? and user_id=?",user_usr.email_address,params[:invite_user_id]).first
      @invitor_user = InvitorList.where("invited_email=?",user_usr.email_address).first
      #manager invitation stored information
      @m_user = Manager.where("invited_user_id = ? and email_id = ?",params[:invite_user_id],user_usr.email_address).last if !user_usr.nil? && !params[:invite_user_id].nil?
      if !@m_user.nil? && @m_user.present?
        @m_user.update_attributes(:accept_status=>"Accepted", :manager_user_id=>user_usr.user_id, :modified_date=>Time.now) if !user_usr.nil?
        @mgr_head = User.find(params[:invite_user_id]) if !params[:invite_user_id].nil?
        #send a mail to invited_user and accepted user for manager flow
        UserMailer.delay(queue: "Accepted status to registered user", priority: 1, run_at: 5.seconds.from_now).joined_manager_accepted(user_usr,@mgr_head) if !user_usr.nil? && !@mgr_head.nil?
        UserMailer.delay(queue: "Accepted status to invited user", priority: 1, run_at: 5.seconds.from_now).joined_mgr_acpted_to_provider(user_usr,@mgr_head) if !user_usr.nil? && !@mgr_head.nil?
      end


      if !params[:aten_mail].nil? && params[:aten_mail]!=""
        @u_id=user_usr.user_id
        @attend_add = ActivityAttendDetail.find_by_attendies_email(user_usr.email_address)
        @attend_add.user_id=@u_id
        @attend_add.save
        @invite_add = InviteAttendees.find_by_user_id_and_email_id(params[:invite_user_id],user_usr.email_address)
        if !@invite_add.nil?
          @invite_add.invited_user_id=@u_id
          @invite_add.accept_status="Accepted"
          @invite_add.accepted_date = Time.now
          @invite_add.save
        end
      end
	     
      if @invitor_user
		    desc = (user_usr.user_type=='U') ? 'Invited as Friend' : 'Invited as Provider'
        @invitor_user.update_attributes(status: 'Accepted', description: desc, accepted_date: Time.now)
      end
      if @cont_user
        @cont_user.contact_user_type='friend'
        @cont_user.fam_user_id = user_usr.user_id if !user_usr.user_id.nil?
        @cont_user.accept_status = true
        @cont_user.modified_date = Time.now
        @cont_user.save
      else
        @c_user = ContactUser.new
        @c_user.user_id = params[:invite_user_id]
        @c_user.contact_email = user_usr.email_address
        @c_user.contact_name = user_usr.user_name
        @c_user.contact_user_type = 'friend'
        @c_user.contact_type = 'famtivity'
        @c_user.fam_user_id = user_usr.user_id if !user_usr.user_id.nil?
        @c_user.inserted_date = Time.now
        @c_user.modified_date = Time.now
        @c_user.accept_status = true
        @c_user.save
      end
      if !params[:group].nil? && params[:group]!="" && params[:cid]!="" && !params[:cid].nil?
        @fam = ContactUserGroup.find_by_contact_user_id_and_contact_group_id(params[:cid],params[:group])
        @fam_con=ContactUser.find_all_by_contact_email(user_usr.email_address)
        if !@fam_con.nil?
          @fam_con.each do |f_con|
            con_group = ContactUserGroup.find_by_contact_user_id_and_contact_group_id(f_con.contact_id,params[:group]) if !f_con.nil?
            if !con_group.nil?
              con_group.fam_accept_status = true
              con_group.fam_accept_user_id = user_usr.user_id
              con_group.save!
            end
          end
        end
        if !@fam.nil?
          #@fam.fam_accept_status = true
          #@fam.fam_accept_user_id = user_usr.user_id
          #@fam.save!
          @con = ContactGroup.where("group_id=#{params[:group]}").last
          @user_u = User.find_by_user_id(@fam.user_id)
          url = request.env['HTTP_HOST']
          FamtivityNetworkMailer.delay(queue: "Accepted Invitation", priority: 2, run_at: 10.seconds.from_now).contact_success_mail(@user_u.email_address,@con,@cont_user,url)
          @fam_row = FamNetworkRow.find_by_contact_group_id_and_user_id(params[:group],user_usr.user_id)
          if @fam_row.nil?
            @row = FamNetworkRow.new
            @row.contact_group_id = params[:group]
            @row.user_id = user_usr.user_id
            @row.inserted_date = Time.now
            @row.save!
          end
        end
      end
      @u_credits = UserCredit.new
      @u_credits.user_id = params[:invite_user_id]
      @u_credits.invitee_id = user_usr.user_id
      invitee_detail = User.user_plan_type(user_usr.user_type,user_usr.user_plan)
      @u_credits.invitee_plan = invitee_detail[0]
      @u_credits.credit_amount = invitee_detail[1]
      @u_credits.provider_plan = invitee_detail[2]
      @u_credits.credit_type = "invite"
      @u_credits.inserted_date = Time.now
      @u_credits.modified_date = Time.now
      @u_credits.save
      UserMailer.delay(queue: "Acknowledge User Discount", priority: 1, run_at: 5.seconds.from_now).ack_user_discount(user_usr,@u_credits)
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
   
  private
   
  #Cotc Update for provider register
	def cotc_for_provider			
		group_name = User.get_newsletter_group(@city,@user_usr)
		if !@user_usr.nil?
			if (@user_usr.user_plan.downcase == "curator")
				url = "http://campaignonthecloud.com/Update_Registration_Status.aspx?name=#{@p_name}&mobile=#{@mobile}&email_id=#{@p_email.downcase}&country=#{@country}&address=#{@add1}&city=#{@city}&businessname=#{params[:b_name]}&zipcode=#{@zip}&domain_name=#{$domain_name}&planname=Curator&optflag=true&groupname=#{group_name}&subscription=1"
			end
			if (@user_usr.user_plan.downcase == "free")
				url ="http://campaignonthecloud.com/Update_Registration_Status.aspx?name=#{@p_name}&mobile=#{@mobile}&email_id=#{@p_email.downcase}&country=#{@country}&address=#{@add1}&city=#{@city}&businessname=#{params[:b_name]}&zipcode=#{@zip}&domain_name=#{$domain_name}&planname=Basic%20Market%20Plan&groupname=#{group_name}&subscription=1"
			end
			if (@user_usr.user_plan.downcase == "sell")
				url = "http://campaignonthecloud.com/Update_Registration_Status.aspx?name=#{@p_name}&mobile=#{@mobile}&email_id=#{@p_email.downcase}&country=#{@country}&address=#{@add1}&city=#{@city}&businessname=#{params[:sell_b_name]}&zipcode=#{@zip}&domain_name=#{$domain_name}&planname=Sell-Through%20Plan&groupname=#{group_name}&subscription=1"
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
	end
	
  #Cotc provider update if become a provider do this
  def cotc_for_provider_update(user)
    @use_pro = user.user_profile if !user.nil?
    url ="http://campaignonthecloud.com/Update_Registration_Status.aspx?name=#{user.user_name}&mobile=#{@use_pro.phone}&email_id=#{user.email_address.downcase}&country=#{@use_pro.country}&address=#{@use_pro.address_1}&city=#{@use_pro.city}&businessname=#{@use_pro.business_name}&zipcode=#{@use_pro.zip_code}&domain_name=#{$domain_name}&action=1"
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
  
  #Cotc Update for the register email activate
  def cotc_for_user_activate
		url ="http://campaignonthecloud.com/UpdatedRegistrationActivation.aspx?email_id=#{@user.email_address}&domain_name=#{$domain_name}"
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
	
	#user plan transaction report
  def user_plan_transaction
    @user_plan = ProviderTransaction.where("user_id=7")
  end

  #calling this method while users signup to famtivity
  def news_letter_signup(email,city,user)	
    group_name = User.get_newsletter_group(city,user)
    city_val = (city && city.present? && city!='') ? URI::encode(city) : ''
    user_name = (user && !user.nil? && user.user_name.present?) ? URI::encode(user.user_name) : ''
    url="http://campaignonthecloud.com/Update_Registration_Status.aspx?name=#{user_name}&mobile=&email_id=#{email}&country=&address=&city=#{city_val}&zipcode=&domain_name=#{$domain_name}&planname=&groupname=#{group_name}&subscription=1"
    uri = URI.parse(URI.encode(url.strip))
    req = Net::HTTP.new(uri.host, uri.port)
    begin
      res = req.request_head(uri.path)
      if res.code != "404"
        request = Net::HTTP::Get.new(uri.request_uri)
        response = req.request(request)
        @news_response=response.body.html_safe
        #~ render :text => @news_response
      end
    rescue Exception => exc
      #~ render :text => "Problem on API"
    end
  end #news letter signup ending here



	
end
