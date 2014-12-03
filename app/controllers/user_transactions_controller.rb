class UserTransactionsController < ApplicationController
  before_filter :authenticate_user
   include UserTransactionsHelper
  require 'time'
  require 'will_paginate/array'
  require 'csv'
  require "active_merchant"
  # GET /user_transactions
  # GET /user_transactions.json
  def index
    @user_transactions = UserTransaction.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_transactions }
    end
  end
  
  #provider transaction
  
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

  def transaction_update

    session[:city] = params[:city] unless params[:city].nil?
    session[:date] = params[:date] unless params[:date].nil?
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    session[:city] = "Walnut Creek" if session[:city].nil?
    tran =  TransactionDetail.get_transaction_values(session[:city],params[:zip_code],session[:date],cookies[:uid_usr])
    @transactions = tran.paginate(:page => params[:page], :per_page =>10)
    respond_to do |format|
      format.js
    end
  end

  def transaction_detail
    @transaction_detail = TransactionDetail.find(params[:tran_id])
    @activity =  Activity.find(@transaction_detail.activity_id)
  end

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
	     #~ credit_card = ActiveMerchant::Billing::CreditCard.new(
		#~ :first_name => params[:sell_CardholderFirstName],
		#~ :last_name => params[:sell_CardholderLastName],
		#~ :number => "#{@payment_profile.params["payment_profile"]['payment']['credit_card']['card_number']}"
	      #~ )
	      
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

  def edit_payment_detail
    @payment_detail = UserTransaction.find_by_user_id(current_user.user_id) if !current_user.nil?

    billing_info = {
      :first_name => params[:first_name],
      :last_name => params[:last_name],
      :address => "#{params[:activity][:address_1]}" + "#{params[:activity][:address_2] if params[:activity][:address_2] != "Address Line2" }"  ,     
      :country =>params[:chkout_country],
      :state => params[:chkout_state],
      :city => params[:activity][:city_apf],
      :zip => params[:zip_code_chkout],
      :phone_number =>  params[:phone_no]
    }  
    if params[:creditcard_save]=="1"
      credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name => params[:first_name],
        :last_name => params[:last_name],
        :number => "#{params[:cardnumber_1]}" + "#{params[:cardnumber_2]}" + "#{params[:cardnumber_3]}" + "#{params[:cardnumber_4]}",
        :month => params[:date_card],
        :year => params[:year_card_1],
        :verification_value => params[:cardnumber_5].to_i, #verification codes are now required
        :type => 'visa'
      )
    else
      @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id)
     
      credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name => params[:first_name],
        :last_name => params[:last_name],
        :number => "#{@payment_profile.params["payment_profile"]['payment']['credit_card']['card_number']}"
      )
    end
    @create = true
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
        @create = false
      end if !@payment_profile.nil?
    end
    if @create
      payment_profile = {
        :bill_to => billing_info,
        :payment => {
          :credit_card => credit_card
        }
      }
      customer_profile_information = {
        :profile     => {
          :merchant_customer_id => current_user.user_name,
          :email => current_user.email_address
          #params[:email] params[:first_name]
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
          @user_transaction.save
        else
          puts "Error: #{pay_profile.message}"
        end
      else
        puts "Error: #{create_profile.message}"
      end
    end
    
    #setting page notification added
    @provider_notify_account = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='9' and p.user_id='#{current_user.user_id}' and p.notify_flag=true") if !current_user.nil? && !current_user.user_id.nil?
    if @provider_notify_account.present? && @provider_notify_account!="" && !@provider_notify_account.nil?
      #sending a mail while editing the activity by the provider
      user=User.find_by_user_id(current_user.user_id) if !current_user.nil?
      attend_email=user.email_address if user.present? && !user.email_address.nil?
      attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
      if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
        #@result = UserMailer.provider_accountdetails_mail(user,@get_current_url,attend_email,params[:subject]).deliver
        @result = UserMailer.delay(queue: "provider Account Details", priority: 2, run_at: 10.seconds.from_now).provider_accountdetails_mail(user,@get_current_url,attend_email,params[:subject])

      end
    end #if loop end for provider mail
    respond_to do |format|
      #format.html # new.html.erb
      format.js
    end
  end

  #get credit card information
  def get_credit_card_info
	@payment_detail = UserTransaction.find_by_user_id(current_user.user_id)
	@payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id)  if !@payment_detail.nil?
  end #method ending

  #provider payment setup
  
  def payment_setup
    @payment_detail = UserTransaction.find_by_user_id(current_user.user_id)

    #   raj = CIMGATEWAY.get_customer_profile_ids()
    #     ss =  CIMGATEWAY.delete_customer_profile(:customer_profile_id=>raj.params['ids']['numeric_string'])
    #    raj.params['ids']['numeric_string'].each do |s|
    #      ss =  gateway.delete_customer_profile(:customer_profile_id=>params['ids']['numeric_string'])
    #      #gateway.delete_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id)
    #      p ss
    #    end

    @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id)  if !@payment_detail.nil?
  end

  def pop_provider_payment_details
    @payment_detail = UserTransaction.find_by_user_id(current_user.user_id)

    @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id)  if !@payment_detail.nil?
  end
  

  # GET /user_transactions/new
  # GET /user_transactions/new.json
  def new
    @user_transaction = UserTransaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_transaction }
    end
  end

  # GET /user_transactions/1/edit
  def edit
    @user_transaction = UserTransaction.find(params[:id])
  end

  # POST /user_transactions
  # POST /user_transactions.json
  def create
    @user_transaction = UserTransaction.new(params[:user_transaction])

    respond_to do |format|
      if @user_transaction.save
        format.html { redirect_to @user_transaction, notice: 'User transaction was successfully created.' }
        format.json { render json: @user_transaction, status: :created, location: @user_transaction }
      else
        format.html { render action: "new" }
        format.json { render json: @user_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_transactions/1
  # PUT /user_transactions/1.json
  def update
    @user_transaction = UserTransaction.find(params[:id])

    respond_to do |format|
      if @user_transaction.update_attributes(params[:user_transaction])
        format.html { redirect_to @user_transaction, notice: 'User transaction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_transactions/1
  # DELETE /user_transactions/1.json
  def destroy
    @user_transaction = UserTransaction.find(params[:id])
    @user_transaction.destroy

    respond_to do |format|
      format.html { redirect_to user_transactions_url }
      format.json { head :no_content }
    end
  end
  
  def provider_transaction
	  params["mode"]='admin'
    if !current_user.nil?
      #reports filter for payment_date
      if !params[:report_trans].nil? && params[:report_trans].present? && !params[:report_trans].nil? && current_user.present?
         #tran = TransactionDetail.find_by_sql("select * from activities as act left join transaction_details as tran on act.activity_id = tran.activity_id order by act.activity_id desc")
        tran = TransactionDetail.find_by_sql("select * from activities as act right join transaction_details as tran on tran.activity_id=act.activity_id left join users u on act.user_id=u.user_id order by tran.trans_id desc")
      else
        tran = TransactionDetail.find_by_sql("select * from activities as act right join transaction_details as tran on tran.activity_id=act.activity_id left join users u on act.user_id=u.user_id order by tran.trans_id desc")
      end
    end #currentuser end
    @trans = tran
    @transactions = [] if tran.nil?
    @transactions = tran.paginate(:page => params[:page], :per_page =>10) if !tran.nil? && tran.present?
    

  respond_to do |format|
    format.html
    format.csv #{ send_data csv_string }
    format.xls #{ send_data @transactions.to_csv(col_sep: "\t") }
    format.js
  end
  end #provider_transaction end
  
  
  	#user plan transaction report
 def plan_report	
	@user_plan_r = ProviderTransaction.select("transaction_id,payment_date,user_plan,amount").where("user_id=?",current_user.user_id).order("id desc") if !current_user.nil?	
	if !@user_plan_r.nil? && @user_plan_r.present?
		@user_plan = @user_plan_r.paginate(:page => params[:page], :per_page =>10) 
	end
	respond_to do |format|
		format.html
		format.csv #{ send_data csv_string }
		format.xls #{ send_data @transactions.to_csv(col_sep: "\t") }
		format.js
	end
 end
 
end
