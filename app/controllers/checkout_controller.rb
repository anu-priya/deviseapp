class CheckoutController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_filter :authenticate_user, :except => [:checkout_thank,:secure_checkout_success,:checkDiscountCode]

  #~ def add_participant_success
    #~ #    if request.xhr?
    #~ if params[:back]!="back"
      #~ @part_det_id =[]
      #~ @discount_type = params[:discount_type]
      #~ @payment_mode = params[:payment_mode]
      #~ part_count = params[:part_count].split(",")
      #~ if part_count.length > 0
        #~ part_count.each do |s|
          #~ if s!="" && !s.nil?
            #~ @participant = Participant.new
            #~ st_time = "#{params[:"day_#{s}"]}-#{params[:"month_#{s}"]}-#{params[:"year_#{s}"]}"
            #~ @participant.participant_name = params[:"participant_name_#{s}"]
            #~ @participant.participant_gender = params[:"gender_#{s}"]
            #~ @participant.participant_age = params[:"age_#{s}"]
            #~ @participant.participant_birth_date = st_time
            #~ @participant.participant= params   [:"photo_#{s}"]
            #~ @participant.user_id = cookies[:uid_usr]
            #~ if @participant.save
              #~ @attend_add = ActivityAttendDetail.new
              #~ @attend_add.activity_id = params[:activity_id]
              #~ @attend_add.user_id = current_user.user_id
              #~ @attend_add.schedule_id = params[:activity_id]
              #~ @attend_add.participant_id = @participant.participant_id
              #~ @attend_add.inserted_date = Time.now
              #~ @attend_add.save
              #~ @part_det_id.push(@participant.participant_id)
            #~ end
          #~ end
        #~ end
      #~ end   
    #~ end
    #~ @activity = Activity.find(params[:activity_id])   
    #~ if @activity.filter_id == "3" || @activity.price_type == "3" || @activity.created_by == "Parent"
      #~ @activity_free = "Free"
      #~ @part_det_id.each do |s|
        #~ if s!="" && !s.nil?
          #~ @part = ActivityAttendDetail.find_by_participant_id(s)
          #~ @part.update_attributes(:payment_status => "Paid") if !@part.nil?
        #~ end
      #~ end if @part_det_id.length > 0
    #~ else
      #~ if @activity.price_type == "1"
        #~ @price = ActivityPrice.find(params[:send_price])
        #~ @send_price = params[:send_price]
        #~ if !@price.price.nil? && @price.price!="" && @price.price!="% or USD"
          #~ total = @price.price.to_i * params[:payment_mode].to_i
        #~ end
        #~ @count = @part_det_id.length
        #~ @total_count = @count * (total) if !total.nil? && !@count.nil?
        #~ if params[:discount_type] == "early"
          #~ @discount = ActivityDiscountPrice.where("discount_number =#{params[:payment_mode]} and discount_type = 'Early Bird Discount' and discount_valid >='#{Time.now}' and activity_price_id = #{params[:send_price]}").last
          #~ if !@discount.nil?
            #~ if @discount.discount_currency_type == "%"
              #~ discount = @price.price.to_i * (@total_count.to_f/100)
              #~ @total_count = @total_count - discount
            #~ else
              #~ @total_count = @total_count - @discount.discount_price.to_i
            #~ end
          #~ end
        #~ elsif params[:discount_type] == "participant"
          #~ @discount = ActivityDiscountPrice.where("discount_number =#{@part_det_id.length} and discount_type = 'Multiple Participant Discount' and activity_price_id = #{params[:send_price]}").last
          #~ if !@discount.nil?
            #~ if @discount.discount_currency_type == "%"
              #~ discount = @price.price.to_i * (@total_count.to_f/100)
              #~ @total_count = @total_count - discount
            #~ else
              #~ @total_count = @total_count - @discount.discount_price.to_i
            #~ end
          #~ end
        #~ elsif params[:discount_type] == "session"
          #~ @discount = ActivityDiscountPrice.where("discount_number =#{params[:payment_mode]} and discount_type = 'Multiple Session Discount' and activity_price_id = #{params[:send_price]}").last
          #~ if !@discount.nil?
            #~ if @discount.discount_currency_type == "%"
              #~ discount = @price.price.to_i * (@total_count.to_f/100)
              #~ @total_count = @total_count - discount
            #~ else
              #~ @total_count = @total_count - @discount.discount_price.to_i
            #~ end
          #~ end
        #~ end
      #~ elsif @activity.price_type == "2"
        #~ @act_price = @activity.price
        #~ @count = @part_det_id.length
        #~ @total_count=@count*(@activity.price) if !@activity.price.nil? && !@count.nil?
      #~ end
    #~ end

    #~ respond_to do |format|
      #~ format.js
    #~ end
  #~ end
  
  
  def get_participant
    @participant = Participant.find(params[:participant_id])

    respond_to do |format|
      data = {'participant_id' =>@participant.participant_id,'participant_name' =>@participant.participant_name, 'participant_age'=> @participant.participant_age, 'participant_gender' => @participant.participant_gender ,'participant_image' => @participant.participant.url(:small)}
      format.json { render :json => data.to_json }
    end

	end

  def secure_checkout_success
    if current_user || (params[:guest_check] && params[:guest_check]=='true')
    @activity = Activity.find(params[:activity_id])
    @activity_sched = ActivitySchedule.find(params[:activity_sched_id])
        

    @act_quanty = params[:payment_mode]
    db_count = 0
    db_count = params[:db_count].split(",").reject(&:empty?).length unless params[:db_count].nil?
    add_count = 0
    add_count = params[:par_id].split(",").reject(&:empty?).length unless params[:par_id].nil?
    #@part_det_id = params[:par_id].split(",").length
    no_of_part = db_count + add_count
    #~ if @activity.filter_id == "3" || @activity_sched.price_type == "3" || @activity.created_by == "Parent"
    @other_fees = ProviderActivityFeeType.find_by_sql("select * from provider_activity_fee_types p_type join provider_activity_fees p_fees on p_type.provider_fee_type_id = p_fees.fee_type_id where p_fees.activity_id=#{params[:activity_id]}")
    @other_fees_mandatory_price = ProviderActivityFeeType.find_by_sql("select * from provider_activity_fee_types p_type join provider_activity_fees p_fees on p_type.provider_fee_type_id = p_fees.fee_type_id where p_fees.activity_id=#{params[:activity_id]} and p_type.fee_mandatory=#{true}").sum(&:price)
    if @activity_sched.price_type == 3 || @activity.created_by == "Parent"
      @activity_free = "Free"
      @total_count = "Free"
      @act_price = "Free"
      @pay_period = "Free"
    elsif @activity_sched.price_type == 1
      @price = ActivityPrice.find(params[:send_price])
      @send_price = params[:send_price]
      if !@price.price.nil? && @price.price!="" && @price.price!="% or USD"
        total = @price.price.to_i * params[:payment_mode].to_i
        @act_price = @price.price.to_i
        @pay_period = @price.payment_period if @price.present?
      end
      @total_count =@ttl_cnt= no_of_part * (total) if !total.nil? && !no_of_part.nil?
      @provider_dis_type = ProviderDiscountType.find(params[:discount_type]) if  params[:discount_type] && params[:discount_type]!='blank'#Provider Discount type record

      #Multiple participant and session discounts
       if params[:discount_type] == '2' || params[:discount_type] == '3'
	      if params[:discount_type] == '2'
		@discount = ActivityDiscountPrice.where("discount_number =#{no_of_part} and provider_discount_type_id = #{params[:discount_type].to_i} and activity_price_id = #{params[:send_price]}").last
	      elsif params[:discount_type] == '3'
		@discount = ActivityDiscountPrice.where("discount_number =#{params[:payment_mode]} and provider_discount_type_id = #{params[:discount_type].to_i} and activity_price_id = #{params[:send_price]}").last
	      end
	    @tot_discount_amt = @discount.discount_price.to_f  if @discount && !@discount.nil?
       else
	#Early bird and other discounts
		if @provider_dis_type && !@provider_dis_type.nil? && @provider_dis_type.present?
			discount_query = " and discount_valid >='#{(DateTime.now).strftime("%Y-%m-%d")}' " if @provider_dis_type.valid_date
			@discount = ActivityDiscountPrice.where("provider_discount_type_id = #{params[:discount_type].to_i} #{discount_query if discount_query}and activity_price_id = #{params[:send_price]}").last
			#To get the attendees count form attendees table		
			if  (@provider_dis_type &&  !@provider_dis_type.nil? &&  @provider_dis_type.present? && @provider_dis_type.quantity )
				@check_attend_parti_count = ActivityAttendDetail.attendeesCount(@activity_sched,@discount.discount_id,params[:discount_type]) #from ActivityAttendDetail model
			end
			@early_applicable = ActivityAttendDetail.earlyBirdApp(@discount.discount_number,@check_attend_parti_count) if @provider_dis_type && @provider_dis_type.quantity && @discount && !@discount.nil? && @check_attend_parti_count
			@tot_discount_no = (@early_applicable && !@early_applicable.nil?) ? (((@early_applicable && no_of_part <=@early_applicable) || @discount.discount_number==0) ? no_of_part : @early_applicable ) : 0
			#~ @tot_discount_amt = ((@discount.discount_currency_type == "%" ) ? @discount.discount_price.to_f : (@tot_discount_no * @discount.discount_price.to_f))
			@tot_discount_amt = (@tot_discount_no && !@tot_discount_no.nil? && @tot_discount_no!=0 && @discount && !@discount.nil? && @discount.present?) ? (@tot_discount_no * @discount.discount_price.to_f) : @discount.discount_price.to_f
		end

       end
	if !@discount.nil? && @tot_discount_amt && !@tot_discount_amt.nil? 
          if @discount.discount_currency_type == "%" 
            @discount_pr = discount = @total_count.to_f * (@tot_discount_amt/100) 
            @total_count = @total_count - discount 
            #@discount_value = "#{number_with_precision discount , :precision => 2}"
            @discount_value = discount
          else 
            @total_count = @total_count - @tot_discount_amt
            @discount_value = @tot_discount_amt
            #number_with_precision(2342.234, :precision => 2)
            #@discount_value = "#{number_with_precision(@discount.discount_price.to_f , :precision => 2)}"
          end
	end
    elsif @activity_sched.price_type == 2
      if (@activity_sched.schedule_mode.downcase=='any time') || (@activity_sched.schedule_mode.downcase=='any where') || (@activity_sched.schedule_mode.downcase=='by appointment')
	@act_sched_price = ActivityPrice.where("activity_id=?",@activity.activity_id).last
      else
        @act_sched_price = ActivityPrice.where("activity_schedule_id=?",@activity_sched.schedule_id).last
      end
      @price_rec = @act_sched_price.activity_discount_price
      @act_price = @act_sched_price.price
      @pay_period = @act_sched_price.payment_period if @act_sched_price.present?
      # @act_price = "#{number_with_precision @activity.price, :precision => 2}"
      @total_count=@ttl_cnt=no_of_part.to_i*(@act_sched_price.price.to_i) if !@act_sched_price.price.nil? && !no_of_part.nil?
      
	if @price_rec && @price_rec.present?
		@price_applicable = []
		@price_rec && @price_rec.each do |s_price|
			@provider_dis_type = ProviderDiscountType.find(s_price.provider_discount_type_id) #Provider Discount type record
			if (s_price.provider_discount_type_id==2 && (no_of_part==s_price.discount_number))
				 @price_applicable << s_price
			elsif (s_price.provider_discount_type_id!=2)
				 if (@provider_dis_type && (@provider_dis_type.quantity || @provider_dis_type.valid_date))
	#To get the attendees count form attendees table
	if  (@provider_dis_type &&  !@provider_dis_type.nil? &&  @provider_dis_type.present? && @provider_dis_type.quantity )
		@check_attend_parti_count = ActivityAttendDetail.attendeesCount(@activity_sched,s_price.discount_id,s_price.provider_discount_type_id) #from ActivityAttendDetail model
	end
					 @early_applicable = ActivityAttendDetail.earlyBirdApp(s_price.discount_number,@check_attend_parti_count) if s_price && @check_attend_parti_count && @provider_dis_type && @provider_dis_type.quantity
					 @chk_valid = s_price.discount_valid >= DateTime.now.strftime("%Y-%m-%d") if @provider_dis_type && @provider_dis_type.valid_date
					 #~ @chk_bth_cond = @early_applicable && (no_of_part <=@early_applicable)
					 if (@provider_dis_type.quantity && @provider_dis_type.valid_date)
						 #~ @price_applicable << s_price if (@early_applicable && (no_of_part <=@early_applicable) && @chk_valid)
						 @price_applicable << s_price if (@early_applicable && @chk_valid)
					 elsif (@provider_dis_type.quantity || @provider_dis_type.valid_date)
						 #~ if (@provider_dis_type.quantity && (@early_applicable && (no_of_part <=@early_applicable)))
						 if (@provider_dis_type.quantity && @early_applicable)
							  @price_applicable << s_price
						 elsif (@provider_dis_type.valid_date && @chk_valid)
							  @price_applicable << s_price
						 end
					 end
				elsif (@provider_dis_type && !@provider_dis_type.quantity && !@provider_dis_type.valid_date)
					@price_applicable << s_price
				end
			end
			
		end
	end

 
    end
    
    @summary_count = (@other_fees && @other_fees.present? && @other_fees_mandatory_price && !@other_fees_mandatory_price.nil? && @other_fees_mandatory_price.present?) ? (@total_count+@other_fees_mandatory_price) : @total_count

    @no_of_part = no_of_part

    respond_to do |format|
      format.js
    end
    end
  end

  #~ def secure_checkout
    #~ @activity = Activity.find(params[:activity_id])
  #~ end

  #~ def proceed_to_checkout
    #~ @activity = Activity.find(params[:activity_id])
    #~ @count = params[:count]
    #~ @total_count = 0
    #~ @total_count=@count*(@activity.price) if !@activity.price.nil? && !@count.nil?
  #~ end

  def checkout_thank
    if current_user || (params[:guest_check] && params[:guest_check]=='true')
    @ticket = ActivityAttendDetail.maximum("ticket_id")     
    if @ticket	  
      @ticket_code = @ticket + 1
    else
      @ticket_code = 1
    end   
    
    #GUEST ROLE
    if params[:guest_check] && params[:guest_check]=='true'
    guest = GuestDetail.new
    phone = "#{params[:guest_phone_1]}-" +"#{params[:guest_phone_2]}-"+"#{params[:guest_phone_3]}"
    @guest_usr = guest.addGuest(params[:guest_name],params[:guest_email],phone)
    end
    #GUEST ROLE
     
    check_valid = true
    @discount_pr = ""
    @activity = Activity.find(params[:activity_id])
    @activity_schedle = ActivitySchedule.find(params[:activity_sched_id])
    year = Time.now.year
      @transaction_success = "failure"
    @user_id = @activity.user_id
    @activity_id = @activity.activity_id
    @ticket_number = "FAM1#{year}#{@user_id}#{@activity_id}#{@ticket_code}T"
    @before_login_value=params[:before_login_value] if !params[:before_login_value].nil? && params[:before_login_value].present?
    @send_to = (current_user.nil? && params[:guest_check] && params[:guest_check]=='true' && @guest_usr) ? @guest_usr.guest_email : current_user.email_address
    @message = params[:message]
    @get_current_url = request.env['HTTP_HOST']
    @user = (current_user.nil? && params[:guest_check] && params[:guest_check]=='true' && @guest_usr) ? @guest_usr : current_user
    @activity_user = User.find_by_user_id(@activity.user_id)
    @to = @activity_user.email_address
    @user_profile = UserProfile.find_by_user_id(@activity.user_id)
    db_count = 0
    db_count = params[:db_part_count].split(",").reject(&:empty?).length unless params[:db_part_count].nil?
    add_count = 0
    add_count = params[:part_count].split(",").reject(&:empty?).length unless params[:part_count].nil?
    no_of_participant = db_count + add_count
    @part_name =""
    @part_det_id =[]

    if add_count > 0
      add_part = params[:part_count].split(",").reject(&:empty?)
      add_part.each do |s|
        if s!="" && !s.nil?
          @participant = Participant.new
          st_time = "#{params[:"day_#{s}"]}-#{params[:"month_#{s}"]}-#{params[:"year_#{s}"]}"
          @participant.participant_name = params[:"participant_name_#{s}"]
          @participant.participant_gender = params[:"gender_#{s}"]
          @participant.participant_age = params[:"age_#{s}"]
          @participant.participant_birth_date = st_time
          @participant.participant= params[:"photo_#{s}"] if params[:"photo_#{s}"] != "" && !params[:"photo_#{s}"].nil?
	  if (current_user.nil? && params[:guest_check] && params[:guest_check]=='true')
		@participant.guest_id = @guest_usr.guest_id
	  else
		@participant.user_id = cookies[:uid_usr]
	  end
          @participant.save
          if @participant.save
            @part_det_id.push(@participant.participant_id)
            @part_name.concat("#{params[:"participant_name_#{s}"]},")
          end
        end
      end
    end
    if db_count > 0
      part_id =  params[:db_part_count].split(",").reject(&:empty?)
      part_id.each do |s|
        part =  Participant.where("participant_id = #{s}").last
        @part_name.concat("#{part.participant_name},")  if !part.nil?
        @part_det_id.push(s)
      end
    end 

    if @activity.filter_id == "3" || @activity_schedle.price_type == 3 || @activity.created_by == "Parent"
      @activity_free = "Free"
      @total_count = "Free"
      @act_price = "Free"
    elsif @activity_schedle.price_type == 1
      @payment_process =true
      @price = ActivityPrice.find(params[:send_price])
      @send_price = params[:send_price]
      if !@price.price.nil? && @price.price!="" && @price.price!="% or USD"
        total = @price.price.to_i * params[:payment_mode].to_i
        @act_price = @price.price.to_i
      end
      @total_count = no_of_participant * (total) if !total.nil? && !no_of_participant.nil?
      @provider_dis_type = ProviderDiscountType.find(params[:discount_type]) if params[:discount_type] && params[:discount_type].present? && params[:discount_type]!='blank'#Provider Discount type record
      
      
      #Multiple participant and session discounts
       if params[:discount_type] == '2' || params[:discount_type] == '3'
	      if params[:discount_type] == '2'
		@discount = ActivityDiscountPrice.where("discount_number =#{@part_det_id.length} and provider_discount_type_id = #{params[:discount_type].to_i} and activity_price_id = #{params[:send_price]}").last
	      elsif params[:discount_type] == '3'
		@discount = ActivityDiscountPrice.where("discount_number =#{params[:payment_mode]} and provider_discount_type_id = #{params[:discount_type].to_i} and activity_price_id = #{params[:send_price]}").last
	      end
	    @tot_discount_amt = @discount.discount_price.to_f  if @discount && !@discount.nil?
       else
	#Early bird and other discounts
		if @provider_dis_type && !@provider_dis_type.nil? && @provider_dis_type.present?
			discount_query = " and discount_valid >='#{(DateTime.now).strftime("%Y-%m-%d")}' " if @provider_dis_type.valid_date
			@discount = ActivityDiscountPrice.where("provider_discount_type_id = #{params[:discount_type].to_i} #{discount_query if discount_query}and activity_price_id = #{params[:send_price]}").last
	#To get the attendees count form attendees table		
	if  (@provider_dis_type &&  !@provider_dis_type.nil? &&  @provider_dis_type.present? && @provider_dis_type.quantity )
		@check_attend_parti_count = ActivityAttendDetail.attendeesCount(@activity_schedle,@discount.discount_id,params[:discount_type]) #from ActivityAttendDetail model
	end
			
			@early_applicable = ActivityAttendDetail.earlyBirdApp(@discount.discount_number,@check_attend_parti_count) if @provider_dis_type && @provider_dis_type.quantity && @discount && !@discount.nil? && @check_attend_parti_count
			@tot_discount_no = (@early_applicable && !@early_applicable.nil?) ? (((@early_applicable && no_of_participant <=@early_applicable) || @discount.discount_number==0) ? no_of_participant : @early_applicable ) : 0
			#~ @tot_discount_amt = ((@discount.discount_currency_type == "%" ) ? @discount.discount_price.to_f : (@tot_discount_no * @discount.discount_price.to_f))
			
			early_dis = ((@discount.discount_currency_type == "%" ) ? (@price.price*(@discount.discount_price.to_f/100)) : @discount.discount_price.to_f)
			
			@tot_discount_amt = (@tot_discount_no && !@tot_discount_no.nil? && @tot_discount_no!=0) ? (@tot_discount_no * early_dis) : early_dis
		end

       end
	if !@discount.nil? && @tot_discount_amt && !@tot_discount_amt.nil? 
          if @discount.discount_currency_type == "%" 
            @discount_pr = discount = ((params[:discount_type]=='1') ? @tot_discount_amt : (@total_count.to_f * (@tot_discount_amt/100)) )
            @total_count = @total_count - discount 
            #@discount_value = "#{number_with_precision discount , :precision => 2}"
            @discount_value = discount
          else 
            @total_count = @total_count - @tot_discount_amt
            @discount_value = @tot_discount_amt
            #number_with_precision(2342.234, :precision => 2)
            #@discount_value = "#{number_with_precision(@discount.discount_price.to_f , :precision => 2)}"
          end
	end

    elsif @activity_schedle.price_type == 2
      @payment_process =true      
      @act_price =  ((@activity_schedle.schedule_mode.downcase=='any time') || (@activity_schedle.schedule_mode.downcase=='any where') || (@activity_schedle.schedule_mode.downcase=='by appointment')) ? (ActivityPrice.where('activity_id=?',@activity.activity_id).last.price.to_f if @activity && !@activity.nil?)   : (@activity_schedle.activity_prices.last.price.to_f if @activity_schedle && @activity_schedle.activity_prices && @activity_schedle.activity_prices.last)
      @total_count=no_of_participant*(@act_price) if !@act_price.nil? && !no_of_participant.nil?
      if params[:netdiscount_id] && params[:netdiscount_id]!='' && !params[:netdiscount_id].nil? 
	@discount = ActivityDiscountPrice.find_by_discount_id(params[:netdiscount_id])
	@provider_dis_type = ProviderDiscountType.find(@discount.provider_discount_type_id) if @discount && !@discount.nil? && @discount.provider_discount_type_id && !@discount.provider_discount_type_id.nil?
	if @discount.provider_discount_type_id==2
		@tot_discount_amt = @discount.discount_price.to_f	
		
	else
	#To get the attendees count form attendees table
	if  (@provider_dis_type &&  !@provider_dis_type.nil? &&  @provider_dis_type.present? && @provider_dis_type.quantity )
		@check_attend_parti_count = ActivityAttendDetail.attendeesCount(@activity_schedle,params[:netdiscount_id],@provider_dis_type.provider_discount_type_id) #from ActivityAttendDetail model
	end
		
		@early_applicable = ActivityAttendDetail.earlyBirdApp(@discount.discount_number,@check_attend_parti_count) if @discount && @check_attend_parti_count && @check_attend_parti_count!='' && !@check_attend_parti_count.nil? && @provider_dis_type && @provider_dis_type.quantity
		@tot_discount_no = ((@early_applicable && no_of_participant <=@early_applicable) || @discount.discount_number==0) ? no_of_participant : @early_applicable 
		#~ @tot_discount_amt = ((@discount.discount_currency_type == "%" ) ? @discount.discount_price.to_f : (@tot_discount_no * @discount.discount_price.to_f))
		early_dis = ((@discount.discount_currency_type == "%" ) ? (@act_price*(@discount.discount_price.to_f/100)) : @discount.discount_price.to_f)
		@tot_discount_amt = ((@tot_discount_no && @tot_discount_no.present? && !@tot_discount_no.nil? && @tot_discount_no!=0) ? (@tot_discount_no * early_dis) : early_dis)
	end

			  if @discount.discount_currency_type == "%" 
			    @discount_pr = discount = ((@discount.provider_discount_type_id==1) ? @tot_discount_amt : (@total_count.to_f * (@tot_discount_amt/100)) ) 
			    @total_count = @total_count - discount 
			  else 
			    @total_count = @total_count - @tot_discount_amt
			    @discount_pr = @tot_discount_amt.to_f 
		    end	   
      end
      
    end
    
    @acti_final_price = @total_count
    
    if (params[:pay_discount_dollar] == "on" && current_user && current_user.present?)
      discount_dollar_tot_amt = Activity.discount_total_amount(current_user.user_id)
      dd_dollar = discount_dollar_tot_amt[0] - discount_dollar_tot_amt[1]
      act_discount_eligible = @activity.discount_eligible
      if (act_discount_eligible.present? && !act_discount_eligible.nil?)
        discount_dollar = ((act_discount_eligible < dd_dollar)? act_discount_eligible : dd_dollar)
      else
	      discount_dollar = dd_dollar
      end   
      total_deduct = discount_dollar - @total_count
      @deb = UserDebit.new
      if discount_dollar >= @total_count
        @deb.debited_amount = @total_count
        @deb.credit_balance = total_deduct
        @payment_process = false
	@payment_by_discount_credits = true
      else
        @deb.credit_balance = 0
        @deb.debited_amount = discount_dollar
        @payment_process = true
      end
      @deb.activity_amount = @act_price
      @deb.total_amount = @total_count
      @deb.activity_id = @activity.activity_id
      @deb.user_id = current_user.user_id
      @deb.provider_id = @activity.user_id
      @deb.purchased_date = Time.now
      @deb.inserted_date = Time.now
      @deb.modified_date = Time.now
      @deb.save!
      @total_count = total_deduct.abs
    end
    
    if params["other_fees"] && params["other_fees"]!=""
	    @p_type_ids = params["other_fees"].split(",")
	    @other_fees = 0 
	    @p_type_ids && @p_type_ids.each do |f|
                @feeid_qty = f.split('&')
		@fee =  ProviderActivityFeeType.find(@feeid_qty[0]).price
		@tot = (@feeid_qty && !@feeid_qty.nil? && @feeid_qty[1] && @feeid_qty[1].present? && @feeid_qty[1]!='' && !@feeid_qty[1].nil? && @feeid_qty[1].to_i!=0) ? (@fee*@feeid_qty[1].to_i) : @fee
                @other_fees = @other_fees+@tot
	    end
	    
	    #~ @other_fees = ProviderActivityFeeType.where("provider_fee_type_id in (?)",@p_type_ids).sum(&:price)

	    @total_count = (@total_count+@other_fees).abs
    end
   
    if !params["discount_code"].nil? && params["discount_code"]!=""
	    @dis_code_type = ProviderDiscountCodeType.where("discount_code=?",params["discount_code"]).last
	    @total_count = (@total_count-@dis_code_type.coupon_price)
	    if @total_count <= 0
		    @payment_process = false
		    @payment_by_discount_code = true
	    else
		    @payment_process = true
		    @total_count = @total_count.abs
	    end
    end
    
    
    if @payment_by_discount_credits || @payment_by_discount_code
	if !current_user.nil? && current_user.user_flag==TRUE
	  #~ participants = Participant.where("participant_id in (?)",@part_det_id)
	  promo_amt = (@dis_code_type && !@dis_code_type.nil? && @dis_code_type.coupon_price && !@dis_code_type.coupon_price.nil?) ? @dis_code_type.coupon_price : 0
	  discount_dol_amt = (discount_dollar && !discount_dollar.nil?) ? discount_dollar : 0
	  if discount_dol_amt && discount_dol_amt!=0
	        discount_dollar_tot_amt = Activity.discount_total_amount(current_user.user_id)
		dd_dollar = discount_dollar_tot_amt[0] - discount_dollar_tot_amt[1]
	  end
	  current_bal = (discount_dol_amt && discount_dol_amt!=0) ? dd_dollar : 0
           UserMailer.delay(queue: "Transaction success", priority: 2, run_at: 10.seconds.from_now).ticket_send_mail(@total_count,@activity,params[:message],@get_current_url,@send_to,params[:subject],@ticket_number,@user,@part_det_id)
	   UserMailer.delay(queue: "Payment by promo_code or discount_dollar", priority: 2, run_at: 10.seconds.from_now).payment_by_promo_discount(@total_count,@activity,@get_current_url,@user,@ticket_number,promo_amt,discount_dol_amt,current_bal,@acti_final_price,@send_to)
       end
	 #checking for activity creator user flag
          if !@activity_user.nil? && @activity_user.user_flag==TRUE
            @result = UserMailer.delay(queue: "Transaction success message to creater", priority: 2, run_at: 10.seconds.from_now).provider_attend_activity_sell(@user,@activity_user,@to,@activity,@get_current_url,@ticket_number)
          end
    end

    if @payment_process == true
      if params[:chkout_card] =="Master Card"
        brand = 'master'
      elsif params[:chkout_card] =="Discover"
        brand = 'discover'
      elsif params[:chkout_card] =="American Express"
        brand = 'american_express'
      else
        brand = 'visa'
      end
      credit_card = ActiveMerchant::Billing::CreditCard.new(
        :brand               => "#{brand}",
        :number             => "#{params[:cardnumber_1]}" + "#{params[:cardnumber_2]}" + "#{params[:cardnumber_3]}" + "#{params[:cardnumber_4]}",
        :verification_value => params[:cardnumber_5],
        :month              => params[:date_card],
        :year               => params[:year_card_1],
        :first_name         => params[:CardholderFirstName],
	:last_name         => params[:CardholderLastName]
      )
      amount_to_charge = @total_count * 100

      if credit_card.valid?
        response = GATEWAY.authorize(amount_to_charge, credit_card, :billing_address =>
            {       :name =>"#{params[:CardholderFirstName]}" + "#{params[:CardholderLastName]}",
            :address1 => "#{params[:activity][:address_1]}" + "#{params[:activity][:address_2]}",
            :city => params[:chkout_city],
            :state =>  params[:chkout_state],
            :country =>params[:chkout_country],
            :zip => params[:zip_code_chkout],
            :phone => params[:phone_no]} )

        if response.success?
          par = GATEWAY.capture(amount_to_charge, response.authorization)
	  
	  test_count = @tot_discount_no
          @part_det_id.each do |s|
            @attend_add = ActivityAttendDetail.new
            @attend_add.activity_id = params[:activity_id]
	    if (current_user.nil? && params[:guest_check] && params[:guest_check]=='true')
		@attend_add.guest_id = @guest_usr.guest_id
	    else
		@attend_add.user_id = current_user.user_id
	    end
            @attend_add.attendies_email = ((current_user.nil? && params[:guest_check] && params[:guest_check]=='true') ? @guest_usr.guest_email : current_user.email_address)
            @attend_add.schedule_id = params[:activity_sched_id]
            @attend_add.participant_id = s
            @attend_add.payment_status = "paid"
            @attend_add.inserted_date = Time.now
            @attend_add.ticket_id = @ticket_code
            @attend_add.ticket_code = @ticket_number
	    @attend_add.discount_code = ((@dis_code_type && !@dis_code_type.nil? && @dis_code_type.present?) ? @dis_code_type.discount_code : "")
	    @attend_add.dd_price = discount_dollar if discount_dollar && !discount_dollar.nil? && discount_dollar.present?
	    @attend_add.discount_id = @discount.discount_id if @discount && !@discount.nil? && @discount.present? && @discount.discount_id && !@discount.discount_id.nil? && test_count && test_count!=0
	    @attend_add.provider_discount_type_id = @provider_dis_type.provider_discount_type_id if @provider_dis_type && !@provider_dis_type.nil? && @provider_dis_type.present? && @provider_dis_type.provider_discount_type_id && test_count && test_count!=0
            @attend_add.save
	    test_count = test_count-1 if test_count && !test_count.nil? && test_count.present? && test_count!=0
	end
	
	#provider transaction sales limit updated for the provider starting
	if !@part_det_id.nil? && @part_det_id!="" && @part_det_id.present?
		if @activity && !@activity.nil? && !@activity.user_id.nil?
			@tdy_date = Time.now.strftime("%Y-%m-%d")
			@p_tran = ProviderTransaction.find_by_sql("select * from provider_transactions where user_id=#{@activity.user_id} and (end_date >= date('#{@tdy_date}')) order by id desc limit 1") if !@activity.nil? 
				begin	
					if !@p_tran.nil? && !@p_tran[0].nil? && @p_tran[0]!="" && !@p_tran[0].purchase_limit.nil? && @p_tran[0].purchase_limit.present?
						@present_limit = @p_tran[0].purchase_limit
						@parti_tot = @part_det_id.length
						#checked sales and purchase limt
						if !@p_tran[0].sales_limit.nil? && @p_tran[0].sales_limit.present? && @p_tran[0].sales_limit <= @p_tran[0].purchase_limit
						@p_tran[0].update_attributes(:purchase_limit=>@p_tran[0].purchase_limit, :expiry_status=>false) #reached the limit
						elsif @p_tran[0].purchase_limit < @p_tran[0].sales_limit	
						@p_tran[0].update_attributes(:purchase_limit=>@present_limit+@parti_tot, :expiry_status=>true) if @present_limit && @parti_tot
						end #sales count ending
					else
						@p_tran[0].update_attributes(:purchase_limit=>@part_det_id.length, :expiry_status=>true) if @part_det_id
					end #pro transaction
				rescue Exception => exc
				puts "#{exc.message}"
				end
		end #activity end
	end #part end
	#provider transaction sales limit updated for the provider ending here

          @fam_fee = FamFeeDetail.last
          @transaction_success = "success"
          trs_ti = Time.now
          @trans = TransactionDetail.new
          @trans.amount = amount_to_charge/100
          @trans.transaction_id = response.authorization
          @trans.activity_id = params[:activity_id]
	  if (current_user.nil? && params[:guest_check] && params[:guest_check]=='true')
		@trans.guest_id = @guest_usr.guest_id
	  else
		@trans.user_id = current_user.user_id
	  end
          @trans.payment_status = "Success"
          @trans.payment_date = trs_ti
          @trans.activity_name = @activity.activity_name
          @trans.customer_name = "#{params[:CardholderFirstName]}"
          @trans.customer_phone = params[:phone_no]
          if (params[:activity][:address_1][-1]==',')
            address = "#{params[:activity][:address_1]}" + "#{params[:activity][:address_2] if params[:activity][:address_2]!="Address Line2"}," + "#{params[:chkout_city]},"+ "#{params[:chkout_state]}," + "#{params[:chkout_country]}"
          else
            address = "#{params[:activity][:address_1]}," + "#{params[:activity][:address_2] if params[:activity][:address_2]!="Address Line2"}," + "#{params[:chkout_city]},"+ "#{params[:chkout_state]}," + "#{params[:chkout_country]}"
          end
          @trans.customer_address = address
          @trans.participant_name = @part_name
          @trans.sale_price = @act_price
          @trans.discount = (@discount_pr && @discount_pr.present? ) ? @discount_pr.to_i : ""
          @trans.dd_price = (params[:pay_discount_dollar]=='on') ? discount_dollar.round : ""
          @trans.inserted_date = Time.now
          @trans.modified_date = Time.now
          @trans.ticket_code = @ticket_number
	  @trans.famtivity_fee = @fam_fee.famtivity_fee if @fam_fee && @fam_fee.famtivity_fee
	  @trans.credit_card_fee =@fam_fee.credit_card_fee  if @fam_fee && @fam_fee.credit_card_fee
          @trans.save
          if params[:pay_discount_dollar] == "on"
            @deb.transaction_id = @trans.trans_id
            @deb.save!
    end
          if ((!current_user.nil? && current_user.user_flag==true) || (current_user.nil? && params[:guest_check] && params[:guest_check]=='true'))
            @result = UserMailer.delay(queue: "Transaction success", priority: 2, run_at: 10.seconds.from_now).ticket_send_mail(@total_count,@activity,params[:message],@get_current_url,@send_to,params[:subject],@ticket_number,@user,@part_det_id)
            @result = UserMailer.delay(queue: "After Payment success", priority: 2, run_at: 10.seconds.from_now).after_payment_mail(@total_count,@activity,@get_current_url,@user,@ticket_number,@trans,@send_to,params[:cardnumber_4])
          end
          #checking for activity creator user flag
          if !@activity_user.nil? && @activity_user.user_flag==TRUE
            @result = UserMailer.delay(queue: "Transaction success message to creater", priority: 2, run_at: 10.seconds.from_now).provider_attend_activity_sell(@user,@activity_user,@to,@activity,@get_current_url,@ticket_number)
          end
          
          #@result = UserMailer.ticket_send_mail(@total_count,@activity,params[:message],@get_current_url,@send_to,params[:subject],@ticket_number).deliver  provider_attend_activity_sell
          #~ @trans_approve =  "Thank You! #{response.message.to_s} Your transaction Id is #{response.authorization}"
          @trans_approve =  "Your transaction Id for this payment is : #{response.authorization}"
	  @payment_type = params[:chkout_card]
        else
          @trans_approve =  "Sorry! #{response.message.to_s}"
          #transaction failure mail
	  if ((!current_user.nil? && current_user.user_flag==TRUE) || (current_user.nil? && @guest_usr && @guest_usr.present?))
		@result = UserMailer.delay(queue: "Transaction failure", priority: 2, run_at: 10.seconds.from_now).transaction_fail_mail(@user,@get_current_url,@trans_approve ,@send_to,params[:subject])
	  end
        end
      else
        @trans_approve = "Sorry! Your Credit card #{credit_card.errors.full_messages.join('. ')}"
	if ((!current_user.nil? && current_user.user_flag==TRUE) || (current_user.nil? && @guest_usr && @guest_usr.present?))
		@result = UserMailer.delay(queue: "Transaction failure", priority: 2, run_at: 10.seconds.from_now).transaction_fail_mail(@user,@get_current_url,@trans_approve ,@send_to,params[:subject])
	end
        check_valid = false
        if request.xhr?
          respond_to do |format|
            format.js{render :text => "$('#card_number_error').parent().parent().css('display','block');
                                       $('#card_number_error').html('Sorry! Your Credit card #{credit_card.errors.full_messages.join('. ')}');
                                       $('#cardnumber_1').css('border','1px solid red');
                                       $('#cardnumber_2').css('border','1px solid red');
                                       $('#cardnumber_3').css('border','1px solid red');
                                       $('#cardnumber_4').css('border','1px solid red');"}
          end
        else
          render :partial=>"checkout_thank"
        end
      end
    else
       
      @ticket = ActivityAttendDetail.maximum("ticket_id")
      if @ticket
        @ticket_code = @ticket + 1
      else
        @ticket_code = 1
      end
      @discount_pr = ""
      @activity = Activity.find(params[:activity_id])
      year = Time.now.year
      @user_id = @activity.user_id
      @activity_id = @activity.activity_id
      @ticket_number = "FAM1#{year}#{@user_id}#{@activity_id}#{@ticket_code}T"
       test_count = @tot_discount_no
      @part_det_id.each do |s|
        @attend_add = ActivityAttendDetail.new
        @attend_add.activity_id = params[:activity_id]
	 if (current_user.nil? && params[:guest_check] && params[:guest_check]=='true')
		@attend_add.guest_id = @guest_usr.guest_id
	else
		@attend_add.user_id = current_user.user_id
	end
	@attend_add.attendies_email =(current_user.nil? && params[:guest_check] && params[:guest_check]=='true') ? @guest_usr.guest_email  : current_user.email_address
        @attend_add.schedule_id = params[:activity_sched_id]
        @attend_add.participant_id = s
        @attend_add.payment_status = "paid"
        @attend_add.inserted_date = Time.now
        @attend_add.ticket_id = @ticket_code
        @attend_add.ticket_code = @ticket_number
	@attend_add.discount_code = ((@dis_code_type && !@dis_code_type.nil? && @dis_code_type.present?) ? @dis_code_type.discount_code : "")
	@attend_add.dd_price = discount_dollar if discount_dollar && !discount_dollar.nil? && discount_dollar.present?
	@attend_add.discount_id = @discount.discount_id if @discount && !@discount.nil? && @discount.present? && @discount.discount_id && !@discount.discount_id.nil? && test_count && test_count!=0
	@attend_add.provider_discount_type_id = @provider_dis_type.provider_discount_type_id if @provider_dis_type && !@provider_dis_type.nil? && @provider_dis_type.present? && @provider_dis_type.provider_discount_type_id && test_count && test_count!=0
        @attend_add.save
	test_count = test_count-1 if test_count && !test_count.nil? && test_count.present? && test_count!=0
	end
	#provider transaction sales limit updated for the provider starting
	if !@part_det_id.nil? && @part_det_id!="" && @part_det_id.present?
		if @activity && !@activity.nil? && !@activity.user_id.nil?
			@tdy_date = Time.now.strftime("%Y-%m-%d")
			@p_tran = ProviderTransaction.find_by_sql("select * from provider_transactions where user_id='#{@activity.user_id}' and (end_date >= date('#{@tdy_date}')) order by id desc limit 1") if !@activity.nil? 
				begin
					if !@p_tran.nil? && !@p_tran[0].nil? && @p_tran[0]!="" && !@p_tran[0].purchase_limit.nil? && @p_tran[0].purchase_limit.present?
						@present_limit = @p_tran[0].purchase_limit
						@parti_tot = @part_det_id.length
						#checked sales and purchase limt
						if !@p_tran[0].sales_limit.nil? && @p_tran[0].sales_limit.present? && @p_tran[0].sales_limit == @p_tran[0].purchase_limit
						@p_tran[0].update_attributes(:purchase_limit=>@p_tran[0].purchase_limit, :expiry_status=>false) #reached the limit
						elsif @p_tran[0].purchase_limit < @p_tran[0].sales_limit	
						@p_tran[0].update_attributes(:purchase_limit=>@present_limit+@parti_tot, :expiry_status=>true) if @present_limit && @parti_tot
						end #sales count ending
					else
						@p_tran[0].update_attributes(:purchase_limit=>@part_det_id.length, :expiry_status=>true) if @part_det_id
					end #pro transaction
				rescue Exception => exc
				puts "#{exc.message}"
				end
		end #activity end
	end #part end
	#provider transaction sales limit updated for the provider ending here
      
      if ((!current_user.nil? && current_user.user_flag==TRUE) || (current_user.nil? && @guest_usr && @guest_usr.present?))
        if @activity.price_type == "3"
          #~ @result = UserMailer.delay(queue: "Free Ticket Sending to creater", priority: 2, run_at: 10.seconds.from_now).provider_attend_activity_free(@user,@activity_user,@to,@activity,@get_current_url)
          @result = UserMailer.delay(queue: "Free Ticket Sending to participant", priority: 2, run_at: 10.seconds.from_now).ticket_send_mail("Free",@activity,params[:message],@get_current_url,@send_to,params[:subject],@ticket_number,@user,@part_det_id)
        else
          #mailer goes here
        end
      end
	 #checking for activity creator user flag
          if !@activity_user.nil? && @activity_user.user_flag==TRUE
            @result = UserMailer.delay(queue: "Free Ticket Sending to creater", priority: 2, run_at: 10.seconds.from_now).provider_attend_activity_free(@user,@activity_user,@to,@activity,@get_current_url)
          end
      #@trans_approve = "Your Message has been sent. #{"\n\n"} Please check your messages for the later reply  from #{@activity.created_by.downcase}. #{"\n\n"} Thank you #{"\n\n"}"
      @close_div_popup="success"
      @trans_approve="Great news! You have joined this activity!#{"\n\n"}We'll send a confirmation email to #{@send_to}"
    end
    if check_valid == true
      if request.xhr?
        respond_to do |format|
          format.js
        end
      else
        render :partial=>"checkout_thank"
      end
    end
    end
  end


  def checkDiscountCode
	  if params[:disp_code] && params[:act_id]
	  @dis_type = ProviderDiscountCodeType.where("discount_code=? and end_date>=?",params[:disp_code],Date.today).last
	  @dis_code = ProviderDiscountCode.where("discount_code_id=? and activity_id=? and discount_code_flag!=?",@dis_type.provider_discount_code_type_id,params[:act_id],true).last if @dis_type && !@dis_type.nil?
	  if @dis_type && @dis_code && !@dis_type.nil? && !@dis_code.nil?
		 @dis_code.discount_code_flag = false
		 @dis_code.save
		 render :text => @dis_type.coupon_price
          else
                 render :text => 'false'		  
	  end
	  end
  end

  def mail
    
  end
  
end
