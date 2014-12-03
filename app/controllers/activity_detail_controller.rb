class ActivityDetailController < ApplicationController
  before_filter :authenticate_user, :only => [:provider_edit_activity]
  require 'fastimage'#this gem for fetching the images.
  require 'active_merchant'
  require 'will_paginate/array'
  include ActionView::Helpers::TextHelper
  include ActivitiesHelper
  include ActivityDetailHelper


  def provider_discount_type
    @provider_type = ProviderDiscountType.new
    @provider_type.discount_name = params[:disc_name]
    @provider_type.valid_date = params[:disc_valid_date]
    @provider_type.quantity = params[:disc_quantity]
    @provider_type.note = params[:note]
    @provider_type.user_id=current_user.user_id
    @provider_type.save
    @pro_fees = ProviderDiscountType.where("user_id=#{current_user.user_id}")
    respond_to do |format|
      format.js
    end
  end

  def provider_activity_discount
    pro_fees = ProviderDiscountType.where("user_id=#{current_user.user_id}")
    @pro_fees = pro_fees.paginate(:page => params[:page], :per_page =>10)
    respond_to do |format|
      format.html
      format.js
    end
  end

 

  def edit_discount_type
    @chose_disc = ProviderDiscountType.where("user_id=#{current_user.user_id} and provider_discount_type_id=#{params[:cu_value]}").last
    respond_to do |format|
      format.js
    end
  end

  def update_discount_type
    @chose_disc = ProviderDiscountType.where("user_id=#{current_user.user_id} and provider_discount_type_id=#{params[:cu_value]}").last
    if !@chose_disc.nil?
      @chose_disc.discount_name = params[:disc_name]
      @chose_disc.valid_date = params[:disc_valid_date]
      @chose_disc.quantity = params[:disc_quantity]
      @chose_disc.note = params[:note]
      @chose_disc.user_id=current_user.user_id
      @chose_disc.save
      act_price = ActivityDiscountPrice.where("provider_discount_type_id=#{@chose_disc.provider_discount_type_id}")
      act_price.each do |price|
        price.discount_type=params[:disc_name]
        price.save
      end
    end
    pro_fees = ProviderDiscountType.where("user_id=#{current_user.user_id}")
    @pro_fees = pro_fees.paginate(:page => params[:page], :per_page =>10)
    respond_to do |format|
      format.js
    end
  end



  def create_discount_type
    @provid_disc_types = ProviderDiscountType.where("user_id=#{current_user.user_id} or user_id is null")
    @chose_disc = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:cu_value]}").last
    render :partial =>"shared/discount_type"
  end



  def create_first_discount_type
    @provid_disc_types = ProviderDiscountType.where("user_id=#{current_user.user_id} or user_id is null")
    @provid_disc_types = @provid_disc_types.reject{|a| a.provider_discount_type_id==3} if params["net"]=="net_"
    render :partial =>"shared/create_first_discount_type"
  end


  #before deleting the discount
  def delete_discount
    @page = params[:page]
    @dicount=params[:id] if !params[:id].nil?
    @to_delete=params[:id].split(',')
    @list = params[:mul]
    @del_act = params[:del_action]
  end


  def discount_destroy
    dis_id=params[:id].gsub(/&\w+;/, '').parameterize
    all_id=dis_id.split('-');
    all_id.each do |al|
      pro_fees = ProviderDiscountType.find(al)
      act_price = ActivityDiscountPrice.where("provider_discount_type_id=#{al}")
      act_price.each do |price|
        price.destroy
      end
      pro_fees.destroy
    end
    @pro_fees = ProviderDiscountType.where("user_id=#{current_user.user_id}")
    @pro_fees = @pro_fees.paginate(:page => params[:page], :per_page =>10)
    respond_to do |format|
      format.js
      format.html
    end
  end



  def provider_fee
    @provider_fee = ProviderActivityFeeType.new
    @provider_fee.fee_name = params[:fee_name]
    @provider_fee.price = params[:fee_price]
    @provider_fee.fee_mandatory = params[:fee_mandatory]
    @provider_fee.quantity = params[:fee_quantity]
    @provider_fee.note = params[:note]
    @provider_fee.user_id=current_user.user_id
    @provider_fee.save
    @pro_fees = ProviderActivityFeeType.where("user_id=#{current_user.user_id}")
    respond_to do |format|
      format.js
    end
  end

  def edit_provider_fee
    @edit_fees = ProviderActivityFeeType.where("user_id=#{current_user.user_id} and provider_fee_type_id=#{params[:fee_type_id]}").last
    respond_to do |format|
      format.js
    end
  end


  def update_provider_fee
    @up_provider_fee = ProviderActivityFeeType.where("user_id=#{current_user.user_id} and provider_fee_type_id=#{params[:fee_type_id]}").last
    if !@up_provider_fee.nil?
      @up_provider_fee.fee_name = params[:fee_name]
      @up_provider_fee.price = params[:fee_price]
      @up_provider_fee.fee_mandatory = params[:fee_mandatory]
      @up_provider_fee.quantity = params[:fee_quantity]
      @up_provider_fee.note = params[:note]
      @up_provider_fee.user_id=current_user.user_id
      @up_provider_fee.save
    end
    @pro_fees = ProviderActivityFeeType.where("user_id=#{current_user.user_id}")
    respond_to do |format|
      format.js
    end
  end
  
  def delete_provider_fee
    up_provider_fee = ProviderActivityFeeType.where("user_id=#{current_user.user_id} and provider_fee_type_id=#{params[:fee_type_id]}").last
    up_provider_fee.destroy() if !up_provider_fee.nil?
    @pro_fees = ProviderActivityFeeType.where("user_id=#{current_user.user_id}")
    respond_to do |format|
      format.js
    end
  end


  def edit_provider_discount_fee
    @edit_disc_fees = ProviderDiscountCodeType.where("user_id=#{current_user.user_id} and provider_discount_code_type_id=#{params[:fee_type_id]}").last
    respond_to do |format|
      format.js
    end
  end
  
  def update_provider_discount_fee
    @up_disc_provider_fee = ProviderDiscountCodeType.where("user_id=#{current_user.user_id} and provider_discount_code_type_id=#{params[:fee_type_id]}").last
    if !@up_disc_provider_fee.nil?
      @up_disc_provider_fee.code_name = params[:disc_name]
      @up_disc_provider_fee.discount_code = params[:disc_code]
      @up_disc_provider_fee.coupon_price = params[:disc_price]
      @up_disc_provider_fee.start_date = DateTime.parse(params[:discount_code_start])
      @up_disc_provider_fee.end_date = DateTime.parse(params[:discount_code_end])
      @up_disc_provider_fee.note = params[:note]
      @up_disc_provider_fee.user_id=current_user.user_id
      @up_disc_provider_fee.save
    end
    @pro_discount_fees = ProviderDiscountCodeType.where("user_id=#{current_user.user_id}")
    respond_to do |format|
      format.js
    end
  end

  def delete_provider_discount_fee
    up_disc_provider_fee = ProviderDiscountCodeType.where("user_id=#{current_user.user_id} and provider_discount_code_type_id=#{params[:fee_type_id]}").last
    up_disc_provider_fee.destroy() if !up_disc_provider_fee.nil?
    @pro_discount_fees = ProviderDiscountCodeType.where("user_id=#{current_user.user_id}")
    respond_to do |format|
      format.js
    end
  end


  def provider_discount_fee
    @provider_discount_fee = ProviderDiscountCodeType.new
    @provider_discount_fee.code_name = params[:disc_name]
    @provider_discount_fee.discount_code = params[:disc_code]
    @provider_discount_fee.coupon_price = params[:disc_price]
    @provider_discount_fee.start_date = params[:discount_code_start]
    @provider_discount_fee.end_date = params[:discount_code_end]
    @provider_discount_fee.note = params[:note] if params[:note]!="Enter Notes here"
    @provider_discount_fee.user_id=current_user.user_id
    @provider_discount_fee.save
    @pro_discount_fees = ProviderDiscountCodeType.where("user_id=#{current_user.user_id}")
    respond_to do |format|
      format.js
    end
  end

  def provider_edit
    @save_copy=params[:s_copy] if !params[:s_copy].nil?
    @set_color = params[:color_val]
    @edited_page = params[:edited_page]
    @activity_profile_apf = Activity.find(params[:save_id])
    @activity_profile_apf.description = params[:redactor_content] if params[:redactor_content] !="Description should not exceed 500 characters"
    @activity_profile_apf.contact_price = params[:con_provider]
    if params[:phone_4] && params[:phone_4]!="" 
	if params[:phone_4] !="Ext"
	@activity_profile_apf.phone_extension = params[:phone_4] 
	else
	@activity_profile_apf.phone_extension = nil
	end
    end
    

    if params[:discountElligble]=='on'
      @activity_profile_apf.discount_eligible = params[:ddligprice] if !params[:ddligprice].nil? && params[:ddligprice].present? && params[:ddligprice]!='Eg: 3'
      @activity_profile_apf.discount_type = params[:ddselect] if !params[:ddselect].nil? && params[:ddselect].present?
    else
      @activity_profile_apf.discount_eligible=nil
      @activity_profile_apf.discount_type=nil
    end
    @page = params[:page]
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    no_participants =""
    leader = ""
    website = ""
    email =""
    address_2 =""
    cookies[:last_action] = params[:last_action]
    cookies[:page] = params[:page]
    cookies[:pro_id] = params[:cat]
    cookies[:cat_zc] = params[:cat_zc]
    leader = params[:leader] if params[:leader] != "Enter Leader Name"
    website = params[:website] if params[:website] != "Enter URL"
    email = params[:email]  if params[:email] != "Enter Email"
    phone = "#{params[:phone_1]}-" + "#{params[:phone_2]}-" + "#{params[:phone_3]}" if !params[:phone_1].nil?
    @activity_profile_apf.gender = params[:gender] if !params[:gender].nil? && params[:gender] != "--Select Gender--"
    skill_level = params[:skill_level] if params[:skill_level] != "--Select--"
    no_participants = params[:no_participants] if params[:no_participants] != "Specify Number"
    address_2  =  params[:address_2] if params[:address_2] != "Address Line 2"
    @activity_profile_apf.tags_txt = params["keyword-tag"].blank? ? "" : params["keyword-tag"]
    params[:tags_txt] = params["keyword-tag"].blank? ? "" : params["keyword-tag"]
    @activity_profile_apf.leader = leader
    @activity_profile_apf.state = params[:state]
    @activity_profile_apf.website = website
    @activity_profile_apf.email = email
    if !phone.nil? && phone !="xxx-xxx-xxxx"
      @activity_profile_apf.phone = phone 
    else
      @activity_profile_apf.phone = nil
    end
    if !params[:class_link].nil? && params[:class_link]=="1"
       @activity_profile_apf.camps = true
    elsif params[:class_link]!="1"
       @activity_profile_apf.camps = false
    end
    if !params[:special_link].nil? && params[:special_link]=="1"
       @activity_profile_apf.special_needs = true
    elsif params[:special_link]!="1"
       @activity_profile_apf.special_needs = false
    end
    @activity_profile_apf.skill_level = skill_level
    @activity_profile_apf.no_participants = no_participants
    @activity_profile_apf.address_2 = address_2
    @activity_profile_apf.modified_date = Time.now
    @activity_profile_apf.note = params[:notes]
    
    if !params[:min_type].nil? && params[:min_type] != '' && params[:min_type].downcase == 'month'
      if !params[:month_age1].nil? && params[:month_age1] != '' && !params[:month_age1].empty? 
        min_age_range = ((params[:month_age1].to_f) / 12).round(2)
      else
        min_age_range = nil
      end
    elsif !params[:min_type].nil? && params[:min_type] != '' && params[:min_type].downcase == 'year'
      if !params[:year_age1].nil? && params[:year_age1] != '' && !params[:year_age1].empty? 
        min_age_range = params[:year_age1]
      else
        min_age_range = nil
      end
    end
    if !params[:max_type].nil? && params[:max_type] != '' && params[:max_type].downcase == 'month'
      if !params[:month_age2].nil? && params[:month_age2] != '' && !params[:month_age2].empty? 
        max_age_range = ((params[:month_age2].to_f)/ 12).round(2)
      else
        max_age_range = nil
      end
    elsif !params[:max_type].nil? && params[:max_type] != '' && params[:max_type].downcase == 'year'
      if !params[:year_age2].nil? && params[:year_age2] != '' && !params[:year_age2].empty? 
        max_age_range = params[:year_age2] 
      else
        max_age_range = nil
      end
    end
    
    @age_range = @activity_profile_apf
    @age_range.min_age_range = min_age_range.blank? ? '' : min_age_range
    @age_range.max_age_range = max_age_range.blank? ? '' : max_age_range
    @age_range.save
	
    if !params[:photo].nil? && params[:photo]!=""
      @activity_profile_apf.avatar = params[:photo]
    end
    if params[:price_1] == "1"
      price_type = 2
    elsif params[:price_2] == "1"
      price_type = 1
    elsif params[:price_3] == "1"
      price_type = 3
    elsif params[:price_4] == "1"
      price_type = 4
    end
    if params[:url_pasted]=="1"
      unless params[:provider_url][/\Ahttp:\/\//] || params[:provider_url][/\Ahttps:\/\//]
        params[:provider_url] = "http://#{params[:provider_url]}"
      end
      @activity_profile_apf.purchase_url = params[:provider_url]
    else
      @activity_profile_apf.purchase_url =""
    end
    #    @user = User.find(cookies[:uid_usr])
    @activity_profile_apf.filter_id = 5
    @activity_old =  @activity_profile_apf.clone
    if params[:addres_anywhere_id] == "2"
      schedule_mo = "Any Where"
    else
      schedule_mo = params[:activity][:schedule_mode]
    end


    if @activity_old.schedule_mode != schedule_mo
      if !@activity_profile_apf.activity_schedule.nil? && !@activity_profile_apf.activity_schedule.empty?
        #@del_pre = ActivityRepeat.find_by_activity_schedule_id(@activity_profile_apf.activity_schedule.last.schedule_id)
        #@activity_sc = ActivityRepeat.delete_all(["activity_schedule_id = ? ",  @activity_profile_apf.activity_schedule.last.schedule_id])
        @activity_delete = ActivitySchedule.delete_all(["activity_id = ? ", params[:save_id]])
        @activity_delete = ActivityPrice.delete_all(["activity_id = ? ", params[:save_id]])
      end
      if params[:addres_anywhere_id] == "1"
        if params[:activity][:schedule_mode] == "Schedule"
          @date_split = params[:schedule_tabs].split(',') if !params[:schedule_tabs].nil?
          @date_split.each do |s|
            st_time = DateTime.parse("#{params[:"schedule_stime_1_#{s}"]} #{params[:"schedule_stime_2_#{s}"]}").strftime("%H:%M:%S") if !params[:"schedule_stime_1_#{s}"].nil? && !params[:"schedule_stime_2_#{s}"].nil? && params[:"schedule_stime_1_#{s}"]!="" && params[:"schedule_stime_2_#{s}"]!=""
            en_time = DateTime.parse("#{params[:"schedule_etime_1_#{s}"]} #{params[:"schedule_etime_2_#{s}"]}").strftime("%H:%M:%S") if !params[:"schedule_etime_1_#{s}"].nil? && !params[:"schedule_etime_2_#{s}"].nil? && params[:"schedule_etime_1_#{s}"]!="" && params[:"schedule_etime_2_#{s}"]!=""
            ex_date = ""
            if params[:"repeatCheck_#{s}"] =="yes"
              if params[:"r1_#{s}"] == "1"
                ex_date = "2100-12-31"
                end_on = ""
              else
                if !params[:"after_occ_#{s}"].nil? && params[:"after_occ_#{s}"]!=""
                  if params[:"repeatWeekVal_#{s}"] == "Daily"
                    ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).days
                  elsif params[:"repeatWeekVal_#{s}"] == "Weekly"
                    ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i * 7).days
                  elsif params[:"repeatWeekVal_#{s}"] == "Monthly"
                    ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).months
                  elsif params[:"repeatWeekVal_#{s}"] == "Yearly"
                    ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i ).years
                  end
                  #ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).days
                  end_on = ""
                elsif !params[:"repeat_alt_on_date_#{s}"].nil? && params[:"repeat_alt_on_date_#{s}"]!=""
                  ex_date = params[:"repeat_alt_on_date_#{s}"]
                  end_on = params[:"repeat_alt_on_date_#{s}"]
                end
              end
            end
            if ex_date =="" || ex_date.nil?
              ex_date = params[:"date_1_#{s}"]
            end

            @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"date_1_#{s}"],
              :end_date=>params[:"date_2_#{s}"],:start_time=>st_time,:end_time=>en_time,:price_type=>price_type,:no_of_participant=>params[:"participant_#{s}"],:expiration_date=>ex_date)
            if params[:"repeatCheck_#{s}"] =="yes"
              @schedule.activity_repeat.create(:repeat_every => params[:"repeatNumWeekVal_#{s}"],
                :ends_never=>params[:"r1_#{s}"],:end_occurences=>params[:"after_occ_#{s}"],
                :ends_on=>end_on,:starts_on=>params[:"date_1_#{s}"],:repeated_by_month=>params[:"month1_#{s}"],:repeat_on=>params[:"repeat_no_of_days_#{s}"],:repeats=>params[:"repeatWeekVal_#{s}"])
            end
            if params[:price_2] == "1"
              total_outer_div =  params[:total_outer_div].split(",").reject(&:empty?)
              total_outer_div.each do |out_div|
                if params[:"chosen_ad_sc_#{out_div}"] == s
                  if !params[:"inner_div_count_#{out_div}"].nil?
                    inner_div_count = params[:"inner_div_count_#{out_div}"].split(",")
                    inner_div_count.each do |in_div|
                      net_price =  params[:"ad_price_#{in_div}"]
                      no_class = params[:"ad_payment_box_fst_#{in_div}"]
                      payment_period = params[:"ads_payment_#{in_div}"]
                      no_hours = params[:"ad_payment_box_sec_#{in_div}"] if params[:"ad_payment_box_sec_#{in_div}"]!="Eg: 3"
                      @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>@schedule.schedule_id  )
                      if !params[:"early_div_count_#{in_div}"].nil?
                        early_div_count = params[:"early_div_count_#{in_div}"].split(",")
                        early_div_count.each do |ea_div|
                          if !params[:"ad_discount_type_#{ea_div}"].nil? && params[:"ad_discount_type_#{ea_div}"]!=""
                            discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_#{ea_div}"]}").last
                            if !discount_type.nil?
                              discount_type_id = params[:"ad_discount_type_#{ea_div}"]
                              discount_price = params[:"ad_discount_price_#{ea_div}"]
                              discount_currency = params[:"ad_discount_price_type_#{ea_div}"]
                              if !params[:"ad_valid_date_alt_#{ea_div}"].nil? && params[:"ad_valid_date_alt_#{ea_div}"]!=""
                                discount_valid_or = DateTime.parse(params[:"ad_valid_date_alt_#{ea_div}"])
                              else
                                discount_valid_or = ""
                              end
                              discount_validity = discount_valid_or
                              discount_number = params[:"ad_no_subs_#{ea_div}"]
                              @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                                :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                            end
                          end
                        end
                      end
                    end
                  end
                end
                if !params[:"advance_notes_#{out_div}"].nil?
                  @schedule.note = params[:"advance_notes_#{out_div}"]
                  @schedule.save
                end
              end
            elsif params[:price_1] == "1"
              multi_discount = params[:total_div_count].split(",")
              multi_discount.each do |t|
                pr_a = t.split("_")
                if params[:"chosen_sc_#{t}"] == s
                  @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:"price_#{t}"],:activity_schedule_id=>@schedule.schedule_id )
                  if !params[:"net_notes_#{t}"].nil?
                    @schedule.note = params[:"net_notes_#{t}"]
                    @schedule.save
                  end
                  if !params[:"last_in_discount_id_#{pr_a[0]}"].nil?
                    early_discount = params[:"last_in_discount_id_#{pr_a[0]}"].split(",")
                    early_discount.each do |w|
                      if !params[:"ad_discount_type_net_#{w}"].nil? && params[:"ad_discount_type_net_#{w}"]!=""
                        discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_net_#{w}"]}").last
                        if !discount_type.nil?
                          discount_type_id = params[:"ad_discount_type_net_#{w}"]
                          discount_price = params[:"ad_discount_price_net_#{w}"]
                          discount_currency = params[:"ad_discount_price_type_net_#{w}"]
                          if !params[:"ad_valid_date_alt_net_#{w}"].nil? && params[:"ad_valid_date_alt_net_#{w}"]!=""
                            discount_valid_or = DateTime.parse(params[:"ad_valid_date_alt_net_#{w}"])
                          else
                            discount_valid_or = ""
                          end
                          discount_validity = discount_valid_or
                          discount_number = params[:"ad_no_subs_net_#{w}"]
                          @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                            :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
        if params[:activity][:schedule_mode] == "By Appointment"
          @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:price_type=>price_type,:no_of_participant=>params[:app_participants],:expiration_date=>"2100-12-31")
          @update_any_time = true
        end
        if params[:activity][:schedule_mode] == "Any Time"
          re = ['mon','tue','wed','thu','fri','sat','sun'].to_a
          re.each do |s|
            if params[:"anytime_closed_#{s}"] !="0"
              st_time = DateTime.parse("#{params[:"anytime_s#{s}_1"]} #{params[:"anytime_s#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_s#{s}_1"].nil? && !params[:"anytime_s#{s}_2"].nil? && params[:"anytime_s#{s}_1"]!="" && params[:"anytime_s#{s}_2"]!=""
              en_time = DateTime.parse("#{params[:"anytime_e#{s}_1"]} #{params[:"anytime_e#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_e#{s}_1"].nil? && !params[:"anytime_e#{s}_2"].nil? && params[:"anytime_e#{s}_1"]!="" && params[:"anytime_e#{s}_2"]!=""
              @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],
                :start_time=>st_time,:end_time=>en_time,:price_type=>price_type,:business_hours=>"#{s}",:no_of_participant=>params[:anytime_participants],:expiration_date=>"2100-12-31")
            end
          end
          @update_any_time = true
        end
        if params[:activity][:schedule_mode] == "Camps/Workshop" || params[:activity][:schedule_mode] == "Whole Day"
          @whole_split = params[:whole_day_tabs].split(',') if !params[:whole_day_tabs].nil?
          @whole_split.each do |wd|
            if params[:"wday_1_#{wd}"] =="1"
              st_time = DateTime.parse("#{params[:"whole_stime_1_#{wd}"]} #{params[:"whole_stime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"whole_stime_1_#{wd}"].nil? && !params[:"whole_stime_2_#{wd}"].nil? && params[:"whole_stime_1_#{wd}"]!="" && params[:"whole_stime_2_#{wd}"]!=""
              en_time = DateTime.parse("#{params[:"whole_etime_1_#{wd}"]} #{params[:"whole_etime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"whole_etime_1_#{wd}"].nil? && !params[:"whole_etime_2_#{wd}"].nil? && params[:"whole_etime_1_#{wd}"]!="" && params[:"whole_etime_2_#{wd}"]!=""
              @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"datestartwhole_alt_1_#{wd}"],
                :start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:"datestartwhole_alt_1_#{wd}"],:price_type=>price_type,:no_of_participant=>params[:"single_day_participants_1_#{wd}"])
            end
            if params[:"wday_2_#{wd}"] =="1"
              st_time = DateTime.parse("#{params[:"camps_stime_1_#{wd}"]} #{params[:"camps_stime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"camps_stime_1_#{wd}"].nil? && !params[:"camps_stime_2_#{wd}"].nil? && params[:"camps_stime_1_#{wd}"]!="" && params[:"camps_stime_2_#{wd}"]!=""
              en_time = DateTime.parse("#{params[:"camps_etime_1_#{wd}"]} #{params[:"camps_etime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"camps_etime_1_#{wd}"].nil? && !params[:"camps_etime_2_#{wd}"].nil? && params[:"camps_etime_1_#{wd}"]!="" && params[:"camps_etime_2_#{wd}"]!=""
              @schedule =  @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"datestcamps_1_#{wd}"],
                :end_date=>params[:"dateencamps_2_#{wd}"],:start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:"dateencamps_2_#{wd}"],:price_type=>price_type,:no_of_participant=>params[:"mul_day_participants_1_#{wd}"])
            end

            if params[:price_2] == "1"
              total_outer_div =  params[:total_outer_div].split(",").reject(&:empty?)
              total_outer_div.each do |out_div|
                if params[:"chosen_ad_sc_#{out_div}"] == wd
                  if !params[:"inner_div_count_#{out_div}"].nil?
                    inner_div_count = params[:"inner_div_count_#{out_div}"].split(",")
                    inner_div_count.each do |in_div|
                      net_price =  params[:"ad_price_#{in_div}"]
                      no_class = params[:"ad_payment_box_fst_#{in_div}"]
                      payment_period = params[:"ads_payment_#{in_div}"]
                      no_hours = params[:"ad_payment_box_sec_#{in_div}"] if params[:"ad_payment_box_sec_#{in_div}"]!="Eg: 3"
                      @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>@schedule.schedule_id )
                      if !params[:"early_div_count_#{in_div}"].nil?
                        early_div_count = params[:"early_div_count_#{in_div}"].split(",")
                        early_div_count.each do |ea_div|
                          if !params[:"ad_discount_type_#{ea_div}"].nil? && params[:"ad_discount_type_#{ea_div}"]!=""
                            discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_#{ea_div}"]}").last
                            if !discount_type.nil?
                              discount_type_id = params[:"ad_discount_type_#{ea_div}"]
                              discount_price = params[:"ad_discount_price_#{ea_div}"]
                              discount_currency = params[:"ad_discount_price_type_#{ea_div}"]
                              if !params[:"ad_valid_date_alt_#{ea_div}"].nil? && params[:"ad_valid_date_alt_#{ea_div}"]!=""
                                discount_valid_or = DateTime.parse(params[:"ad_valid_date_alt_#{ea_div}"])
                              else
                                discount_valid_or = ""
                              end
                              discount_validity = discount_valid_or
                              discount_number = params[:"ad_no_subs_#{ea_div}"]
                              @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                                :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                            end
                          end
                        end
                      end
                    end
                  end
                end
                if !params[:"advance_notes_#{out_div}"].nil?
                  @schedule.note = params[:"advance_notes_#{out_div}"]
                  @schedule.save
                end
              end
            elsif params[:price_1] == "1"
              multi_discount = params[:total_div_count].split(",")
              multi_discount.each do |t|
                pr_a = t.split("_")
                if params[:"chosen_sc_#{t}"] == wd
                  @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:"price_#{t}"],:activity_schedule_id=>@schedule.schedule_id )
                  if !params[:"net_notes_#{t}"].nil?
                    @schedule.note = params[:"net_notes_#{t}"]
                    @schedule.save
                  end
                  if !params[:"last_in_discount_id_#{pr_a[0]}"].nil?
                    early_discount = params[:"last_in_discount_id_#{pr_a[0]}"].split(",")
                    early_discount.each do |w|
                      if !params[:"ad_discount_type_net_#{w}"].nil? && params[:"ad_discount_type_net_#{w}"]!=""
                        discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_net_#{w}"]}").last
                        if !discount_type.nil?
                          discount_type_id = params[:"ad_discount_type_net_#{w}"]
                          discount_price = params[:"ad_discount_price_net_#{w}"]
                          discount_currency = params[:"ad_discount_price_type_net_#{w}"]
                          if !params[:"ad_valid_date_alt_net_#{w}"].nil? && params[:"ad_valid_date_alt_net_#{w}"]!=""
                            discount_valid_or = DateTime.parse(params[:"ad_valid_date_alt_net_#{w}"])
                          else
                            discount_valid_or = ""
                          end
                          discount_validity = discount_valid_or
                          discount_number = params[:"ad_no_subs_net_#{w}"]
                          @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                            :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      else
        if params[:addres_anywhere_id] == "2"
          @activity_profile_apf.schedule_mode = "Any Where"
          @activity_profile_apf.activity_schedule.create(:schedule_mode=> "Any Where",:price_type=>price_type,:expiration_date=>"2100-12-31")
          @update_any_time = true
        end
      end
    else
      if params[:addres_anywhere_id] == "1"
        if params[:activity][:schedule_mode] == "Schedule"
          @date_split = params[:schedule_tabs].split(',') if !params[:schedule_tabs].nil?

          @schedule_tot = ActivitySchedule.where("activity_id=#{params[:save_id]}").map(&:schedule_id)
          @del_schedule = []
       
          @date_split.each do |s|
            if !params[:"schedule_r_1_#{s}"].nil?
              if @schedule_tot.include?(params[:"schedule_r_1_#{s}"].to_i)
                @del_schedule << params[:"schedule_r_1_#{s}"].to_i if !params[:"schedule_r_1_#{s}"].nil?
                @act_schedule = ActivitySchedule.find(params[:"schedule_r_1_#{s}"])
                st_time = DateTime.parse("#{params[:"schedule_stime_1_#{s}"]} #{params[:"schedule_stime_2_#{s}"]}").strftime("%H:%M:%S") if !params[:"schedule_stime_1_#{s}"].nil? && !params[:"schedule_stime_2_#{s}"].nil? && params[:"schedule_stime_1_#{s}"]!="" && params[:"schedule_stime_2_#{s}"]!=""
                en_time = DateTime.parse("#{params[:"schedule_etime_1_#{s}"]} #{params[:"schedule_etime_2_#{s}"]}").strftime("%H:%M:%S") if !params[:"schedule_etime_1_#{s}"].nil? && !params[:"schedule_etime_2_#{s}"].nil? && params[:"schedule_etime_1_#{s}"]!="" && params[:"schedule_etime_2_#{s}"]!=""
                ex_date = ""
                if params[:"repeatCheck_#{s}"] =="yes"
                  if params[:"r1_#{s}"] == "1"
                    ex_date = "2100-12-31"
                    end_on = ""
                  else
                    if !params[:"after_occ_#{s}"].nil? && params[:"after_occ_#{s}"]!=""
                      if params[:"repeatWeekVal_#{s}"] == "Daily"
                        ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).days
                      elsif params[:"repeatWeekVal_#{s}"] == "Weekly"
                        ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i * 7).days
                      elsif params[:"repeatWeekVal_#{s}"] == "Monthly"
                        ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).months
                      elsif params[:"repeatWeekVal_#{s}"] == "Yearly"
                        ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i ).years
                      end

                      #ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).days
                      end_on = ""
                    elsif !params[:"repeat_alt_on_date_#{s}"].nil? && params[:"repeat_alt_on_date_#{s}"]!=""
                      ex_date = params[:"repeat_alt_on_date_#{s}"]
                      end_on = params[:"repeat_alt_on_date_#{s}"]
                    end
                  end
                end
                if ex_date =="" || ex_date.nil?
                  ex_date = params[:"date_1_#{s}"]
                end
                @activity_price_del = ActivityPrice.delete_all(["activity_schedule_id = ? ",  @act_schedule.schedule_id])
                @act_schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"date_1_#{s}"],
                  :end_date=>params[:"date_2_#{s}"],:start_time=>st_time,:end_time=>en_time,:price_type=>price_type,:no_of_participant=>params[:"participant_#{s}"],:expiration_date=>ex_date)
                if params[:"repeatCheck_#{s}"]=="yes"
                  @activity_repeat = ActivityRepeat.find_by_activity_schedule_id(@act_schedule.schedule_id)
                  if !@activity_repeat.nil?
                    @activity_repeat.repeat_every = params[:"repeatNumWeekVal_#{s}"]
                    @activity_repeat.ends_never= params[:"r1_#{s}"]
                    @activity_repeat.end_occurences= params[:"after_occ_#{s}"]
                    @activity_repeat.ends_on= end_on
                    @activity_repeat.starts_on = params[:"date_1_#{s}"]
                    @activity_repeat.repeat_on= params[:"repeat_no_of_days_#{s}"]
                    @activity_repeat.repeats= params[:"repeatWeekVal_#{s}"]
                    @activity_repeat.repeated_by_month = params[:"month1_#{s}"]
                    @activity_repeat.save
                  else
                    @act_schedule.activity_repeat.create(:repeat_every => params[:"repeatNumWeekVal_#{s}"],
                      :ends_never=>params[:"r1_#{s}"],:end_occurences=>params[:"after_occ_#{s}"],
                      :ends_on=>end_on,:starts_on=>params[:"date_1_#{s}"],:repeated_by_month=>params[:"month1_#{s}"],:repeat_on=>params[:"repeat_no_of_days_#{s}"],:repeats=>params[:"repeatWeekVal_#{s}"])
                  end
                else
                  @activity_sc = ActivityRepeat.delete_all(["activity_schedule_id = ? ",  @act_schedule.schedule_id])
                end

                if params[:price_2] == "1"
                  total_outer_div =  params[:total_outer_div].split(",").reject(&:empty?)
                  total_outer_div.each do |out_div|
                    if params[:"chosen_ad_sc_#{out_div}"] == s
                      if !params[:"inner_div_count_#{out_div}"].nil?
                        inner_div_count = params[:"inner_div_count_#{out_div}"].split(",")
                        inner_div_count.each do |in_div|
                          net_price =  params[:"ad_price_#{in_div}"]
                          no_class = params[:"ad_payment_box_fst_#{in_div}"]
                          payment_period = params[:"ads_payment_#{in_div}"]
                          no_hours = params[:"ad_payment_box_sec_#{in_div}"] if params[:"ad_payment_box_sec_#{in_div}"]!="Eg: 3"
                          @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>@act_schedule.schedule_id  )
                          if !params[:"early_div_count_#{in_div}"].nil?
                            early_div_count = params[:"early_div_count_#{in_div}"].split(",")
                            early_div_count.each do |ea_div|
                              if !params[:"ad_discount_type_#{ea_div}"].nil? && params[:"ad_discount_type_#{ea_div}"]!=""
                                discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_#{ea_div}"]}").last
                                if !discount_type.nil?
                                  discount_type_id = params[:"ad_discount_type_#{ea_div}"]
                                  discount_price = params[:"ad_discount_price_#{ea_div}"]
                                  discount_currency = params[:"ad_discount_price_type_#{ea_div}"]
                                  if !params[:"ad_valid_date_alt_#{ea_div}"].nil? && params[:"ad_valid_date_alt_#{ea_div}"]!=""
                                    discount_valid_or = DateTime.parse(params[:"ad_valid_date_alt_#{ea_div}"])
                                  else
                                    discount_valid_or = ""
                                  end
                                  discount_validity = discount_valid_or
                                  discount_number = params[:"ad_no_subs_#{ea_div}"]
                                  @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                                    :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                    if !params[:"advance_notes_#{out_div}"].nil?
                      @act_schedule.note = params[:"advance_notes_#{out_div}"]
                      @act_schedule.save
                    end
                  end
                elsif params[:price_1] == "1"
                  multi_discount = params[:total_div_count].split(",")
                  multi_discount.each do |t|
                    pr_a = t.split("_")
                    if params[:"chosen_sc_#{t}"] == s
                      @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:"price_#{t}"],:activity_schedule_id=>@act_schedule.schedule_id )
                      if !params[:"net_notes_#{t}"].nil? && params[:"net_notes_#{t}"] != "Notes:"
                        @act_schedule.note = params[:"net_notes_#{t}"]
                        @act_schedule.save
                      end
                      if !params[:"last_in_discount_id_#{pr_a[0]}"].nil?
                        early_discount = params[:"last_in_discount_id_#{pr_a[0]}"].split(",")
                        early_discount.each do |w|
                          if !params[:"ad_discount_type_net_#{w}"].nil? && params[:"ad_discount_type_net_#{w}"]!=""
                            discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_net_#{w}"]}").last
                            if !discount_type.nil?
                              discount_type_id = params[:"ad_discount_type_net_#{w}"]
                              discount_price = params[:"ad_discount_price_net_#{w}"]
                              discount_currency = params[:"ad_discount_price_type_net_#{w}"]
                              if !params[:"ad_valid_date_alt_net_#{w}"].nil? && params[:"ad_valid_date_alt_net_#{w}"]!=""
                                discount_valid_or = DateTime.parse(params[:"ad_valid_date_alt_net_#{w}"])
                              else
                                discount_valid_or = ""
                              end
                              discount_validity = discount_valid_or
                              discount_number = params[:"ad_no_subs_net_#{w}"]
                              @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                                :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            else
              st_time = DateTime.parse("#{params[:"schedule_stime_1_#{s}"]} #{params[:"schedule_stime_2_#{s}"]}").strftime("%H:%M:%S") if !params[:"schedule_stime_1_#{s}"].nil? && !params[:"schedule_stime_2_#{s}"].nil? && params[:"schedule_stime_1_#{s}"]!="" && params[:"schedule_stime_2_#{s}"]!=""
              en_time = DateTime.parse("#{params[:"schedule_etime_1_#{s}"]} #{params[:"schedule_etime_2_#{s}"]}").strftime("%H:%M:%S") if !params[:"schedule_etime_1_#{s}"].nil? && !params[:"schedule_etime_2_#{s}"].nil? && params[:"schedule_etime_1_#{s}"]!="" && params[:"schedule_etime_2_#{s}"]!=""
              ex_date = ""
              if params[:"repeatCheck_#{s}"] =="yes"
                if params[:"r1_#{s}"] == "1"
                  ex_date = "2100-12-31"
                  end_on = ""
                else
                  if !params[:"after_occ_#{s}"].nil? && params[:"after_occ_#{s}"]!=""
                    if params[:"repeatWeekVal_#{s}"] == "Daily"
                      ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).days
                    elsif params[:"repeatWeekVal_#{s}"] == "Weekly"
                      ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i * 7).days
                    elsif params[:"repeatWeekVal_#{s}"] == "Monthly"
                      ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).months
                    elsif params[:"repeatWeekVal_#{s}"] == "yearly"
                      ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i ).years
                    end
                    #ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).days
                    end_on = ""
                  elsif !params[:"repeat_alt_on_date_#{s}"].nil? && params[:"repeat_alt_on_date_#{s}"]!=""
                    ex_date = params[:"repeat_alt_on_date_#{s}"]
                    end_on = params[:"repeat_alt_on_date_#{s}"]
                  end
                end
              end
              if ex_date =="" || ex_date.nil?
                ex_date = params[:"date_1_#{s}"]
              end

              @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"date_1_#{s}"],
                :end_date=>params[:"date_2_#{s}"],:start_time=>st_time,:end_time=>en_time,:price_type=>price_type,:no_of_participant=>params[:"participant_#{s}"],:expiration_date=>ex_date)
              if params[:"repeatCheck_#{s}"] =="yes"
                @schedule.activity_repeat.create(:repeat_every => params[:"repeatNumWeekVal_#{s}"],
                  :ends_never=>params[:"r1_#{s}"],:end_occurences=>params[:"after_occ_#{s}"],
                  :ends_on=>end_on,:starts_on=>params[:"date_1_#{s}"],:repeated_by_month=>params[:"month1_#{s}"],:repeat_on=>params[:"repeat_no_of_days_#{s}"],:repeats=>params[:"repeatWeekVal_#{s}"])
              end
              if params[:price_2] == "1"
                total_outer_div =  params[:total_outer_div].split(",").reject(&:empty?)
                total_outer_div.each do |out_div|
                  if params[:"chosen_ad_sc_#{out_div}"] == s
                    if !params[:"inner_div_count_#{out_div}"].nil?
                      inner_div_count = params[:"inner_div_count_#{out_div}"].split(",")
                      inner_div_count.each do |in_div|
                        net_price =  params[:"ad_price_#{in_div}"]
                        no_class = params[:"ad_payment_box_fst_#{in_div}"]
                        payment_period = params[:"ads_payment_#{in_div}"]
                        no_hours = params[:"ad_payment_box_sec_#{in_div}"] if params[:"ad_payment_box_sec_#{in_div}"]!="Eg: 3"
                        @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>@schedule.schedule_id  )
                        if !params[:"early_div_count_#{in_div}"].nil?
                          early_div_count = params[:"early_div_count_#{in_div}"].split(",")
                          early_div_count.each do |ea_div|
                            if !params[:"ad_discount_type_#{ea_div}"].nil? && params[:"ad_discount_type_#{ea_div}"]!=""
                              discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_#{ea_div}"]}").last
                              if !discount_type.nil?
                                discount_type_id = params[:"ad_discount_type_#{ea_div}"]
                                discount_price = params[:"ad_discount_price_#{ea_div}"]
                                discount_currency = params[:"ad_discount_price_type_#{ea_div}"]
                                if !params[:"ad_valid_date_alt_#{ea_div}"].nil? && params[:"ad_valid_date_alt_#{ea_div}"]!=""
                                  discount_valid_or = DateTime.parse(params[:"ad_valid_date_alt_#{ea_div}"])
                                else
                                  discount_valid_or = ""
                                end
                                discount_validity = discount_valid_or
                                discount_number = params[:"ad_no_subs_#{ea_div}"]
                                @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                                  :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                  if !params[:"advance_notes_#{out_div}"].nil?
                    @act_schedule.note = params[:"advance_notes_#{out_div}"]
                    @act_schedule.save
                  end
                end
              elsif params[:price_1] == "1"
                multi_discount = params[:total_div_count].split(",")
                multi_discount.each do |t|
                  pr_a = t.split("_")
                  if params[:"chosen_sc_#{t}"] == s
                    @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:"price_#{t}"],:activity_schedule_id=>@schedule.schedule_id )
                    if !params[:"net_notes_#{t}"].nil? && params[:"net_notes_#{t}"] != "Notes:"
                      @schedule.note = params[:"net_notes_#{t}"]
                      @schedule.save
                    end
                    if !params[:"last_in_discount_id_#{pr_a[0]}"].nil?
                      early_discount = params[:"last_in_discount_id_#{pr_a[0]}"].split(",")
                      early_discount.each do |w|
                        if !params[:"ad_discount_type_net_#{w}"].nil? && params[:"ad_discount_type_net_#{w}"]!=""
                          discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_net_#{w}"]}").last
                          if !discount_type.nil?
                            discount_type_id = params[:"ad_discount_type_net_#{w}"]
                            discount_price = params[:"ad_discount_price_net_#{w}"]
                            discount_currency = params[:"ad_discount_price_type_net_#{w}"]
                            if !params[:"ad_valid_date_alt_net_#{w}"].nil? && params[:"ad_valid_date_alt_net_#{w}"]!=""
                              discount_valid_or = DateTime.parse(params[:"ad_valid_date_alt_net_#{w}"])
                            else
                              discount_valid_or = ""
                            end
                            discount_validity = discount_valid_or
                            discount_number = params[:"ad_no_subs_net_#{w}"]
                            @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                              :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end #date_spilt end

          to_delet =  @schedule_tot - @del_schedule

          to_delet.each do |d|
            @activity_delete = ActivitySchedule.delete_all(["schedule_id = ? ", d])
          end
        end



        if params[:activity][:schedule_mode] == "By Appointment"
          @update_any_time = true
          @activity_price_del = ActivityPrice.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
          if !params[:schedule_id_value].nil? && params[:schedule_id_value]!=""
            @act_schedule = ActivitySchedule.find(params[:schedule_id_value])
            @act_schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:price_type=>price_type,:no_of_participant=>params[:app_participants],:expiration_date=>"2100-12-31")
          end
        end
        if params[:activity][:schedule_mode] == "Camps/Workshop" || params[:activity][:schedule_mode] == "Whole Day"
          @schedule_tot = ActivitySchedule.where("activity_id=#{params[:save_id]}").map(&:schedule_id)
          @del_schedule =[]
          @whole_split = params[:whole_day_tabs].split(',') if !params[:whole_day_tabs].nil?
          @whole_split.each do |wd|
            if !params[:"schedule_whr_1_#{wd}"].nil?
              if @schedule_tot.include?(params[:"schedule_whr_1_#{wd}"].to_i)
                @del_schedule << params[:"schedule_whr_1_#{wd}"].to_i if !params[:"schedule_whr_1_#{wd}"].nil?
                @schedule = ActivitySchedule.find(params[:"schedule_whr_1_#{wd}"])
                @activity_price_del = ActivityPrice.delete_all(["activity_schedule_id = ? ",  @schedule.schedule_id])
                if params[:"wday_1_#{wd}"] =="1"
                  st_time = DateTime.parse("#{params[:"whole_stime_1_#{wd}"]} #{params[:"whole_stime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"whole_stime_1_#{wd}"].nil? && !params[:"whole_stime_2_#{wd}"].nil? && params[:"whole_stime_1_#{wd}"]!="" && params[:"whole_stime_2_#{wd}"]!=""
                  en_time = DateTime.parse("#{params[:"whole_etime_1_#{wd}"]} #{params[:"whole_etime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"whole_etime_1_#{wd}"].nil? && !params[:"whole_etime_2_#{wd}"].nil? && params[:"whole_etime_1_#{wd}"]!="" && params[:"whole_etime_2_#{wd}"]!=""
                  @schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"datestartwhole_alt_1_#{wd}"],
                    :start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:"datestartwhole_alt_1_#{wd}"],:price_type=>price_type,:no_of_participant=>params[:"single_day_participants_1_#{wd}"])
                end
                if params[:"wday_2_#{wd}"] =="1"
                  st_time = DateTime.parse("#{params[:"camps_stime_1_#{wd}"]} #{params[:"camps_stime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"camps_stime_1_#{wd}"].nil? && !params[:"camps_stime_2_#{wd}"].nil? && params[:"camps_stime_1_#{wd}"]!="" && params[:"camps_stime_2_#{wd}"]!=""
                  en_time = DateTime.parse("#{params[:"camps_etime_1_#{wd}"]} #{params[:"camps_etime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"camps_etime_1_#{wd}"].nil? && !params[:"camps_etime_2_#{wd}"].nil? && params[:"camps_etime_1_#{wd}"]!="" && params[:"camps_etime_2_#{wd}"]!=""
                  @schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"datestcamps_1_#{wd}"],
                    :end_date=>params[:"dateencamps_2_#{wd}"],:start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:"dateencamps_2_#{wd}"],:price_type=>price_type,:no_of_participant=>params[:"mul_day_participants_1_#{wd}"])
                end
              else
                @whole_create = true
              end
            else
              @whole_create = true
            end
            if @whole_create == true
              if params[:"wday_1_#{wd}"] =="1"
                st_time = DateTime.parse("#{params[:"whole_stime_1_#{wd}"]} #{params[:"whole_stime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"whole_stime_1_#{wd}"].nil? && !params[:"whole_stime_2_#{wd}"].nil? && params[:"whole_stime_1_#{wd}"]!="" && params[:"whole_stime_2_#{wd}"]!=""
                en_time = DateTime.parse("#{params[:"whole_etime_1_#{wd}"]} #{params[:"whole_etime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"whole_etime_1_#{wd}"].nil? && !params[:"whole_etime_2_#{wd}"].nil? && params[:"whole_etime_1_#{wd}"]!="" && params[:"whole_etime_2_#{wd}"]!=""
                @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"datestartwhole_alt_1_#{wd}"],
                  :start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:"datestartwhole_alt_1_#{wd}"],:price_type=>price_type,:no_of_participant=>params[:"single_day_participants_1_#{wd}"])
              end
              if params[:"wday_2_#{wd}"] =="1"
                st_time = DateTime.parse("#{params[:"camps_stime_1_#{wd}"]} #{params[:"camps_stime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"camps_stime_1_#{wd}"].nil? && !params[:"camps_stime_2_#{wd}"].nil? && params[:"camps_stime_1_#{wd}"]!="" && params[:"camps_stime_2_#{wd}"]!=""
                en_time = DateTime.parse("#{params[:"camps_etime_1_#{wd}"]} #{params[:"camps_etime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"camps_etime_1_#{wd}"].nil? && !params[:"camps_etime_2_#{wd}"].nil? && params[:"camps_etime_1_#{wd}"]!="" && params[:"camps_etime_2_#{wd}"]!=""
                @schedule =  @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"datestcamps_1_#{wd}"],
                  :end_date=>params[:"dateencamps_2_#{wd}"],:start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:"dateencamps_2_#{wd}"],:price_type=>price_type,:no_of_participant=>params[:"mul_day_participants_1_#{wd}"])
              end
            end
        

            if params[:price_2] == "1"
              total_outer_div =  params[:total_outer_div].split(",").reject(&:empty?)
              total_outer_div.each do |out_div|
                if params[:"chosen_ad_sc_#{out_div}"] == wd
                  if !params[:"inner_div_count_#{out_div}"].nil?
                    inner_div_count = params[:"inner_div_count_#{out_div}"].split(",")
                    inner_div_count.each do |in_div|
                      net_price =  params[:"ad_price_#{in_div}"]
                      no_class = params[:"ad_payment_box_fst_#{in_div}"]
                      payment_period = params[:"ads_payment_#{in_div}"]
                      no_hours = params[:"ad_payment_box_sec_#{in_div}"] if params[:"ad_payment_box_sec_#{in_div}"]!="Eg: 3"
                      @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>@schedule.schedule_id )
                      if !params[:"early_div_count_#{in_div}"].nil?
                        early_div_count = params[:"early_div_count_#{in_div}"].split(",")
                        early_div_count.each do |ea_div|
                          if !params[:"ad_discount_type_#{ea_div}"].nil? && params[:"ad_discount_type_#{ea_div}"]!=""
                            discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_#{ea_div}"]}").last
                            if !discount_type.nil?
                              discount_type_id = params[:"ad_discount_type_#{ea_div}"]
                              discount_price = params[:"ad_discount_price_#{ea_div}"]
                              discount_currency = params[:"ad_discount_price_type_#{ea_div}"]
                              if !params[:"ad_valid_date_alt_#{ea_div}"].nil? && params[:"ad_valid_date_alt_#{ea_div}"]!=""
                                discount_valid_or = DateTime.parse(params[:"ad_valid_date_alt_#{ea_div}"])
                              else
                                discount_valid_or = ""
                              end
                              discount_validity = discount_valid_or
                              discount_number = params[:"ad_no_subs_#{ea_div}"]
                              @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                                :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                            end
                          end
                        end
                      end
                    end
                  end
                end
                if !params[:"advance_notes_#{out_div}"].nil?
                  @schedule.note = params[:"advance_notes_#{out_div}"]
                  @schedule.save
                end
              end
            elsif params[:price_1] == "1"
              multi_discount = params[:total_div_count].split(",")
              multi_discount.each do |t|
                pr_a = t.split("_")
                if params[:"chosen_sc_#{t}"] == wd
                  @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:"price_#{t}"],:activity_schedule_id=>@schedule.schedule_id )
                  if !params[:"net_notes_#{t}"].nil?
                    @schedule.note = params[:"net_notes_#{t}"]
                    @schedule.save
                  end
                  if !params[:"last_in_discount_id_#{pr_a[0]}"].nil?
                    early_discount = params[:"last_in_discount_id_#{pr_a[0]}"].split(",")
                    early_discount.each do |w|
                      if !params[:"ad_discount_type_net_#{w}"].nil? && params[:"ad_discount_type_net_#{w}"]!=""
                        discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_net_#{w}"]}").last
                        if !discount_type.nil?
                          discount_type_id = params[:"ad_discount_type_net_#{w}"]
                          discount_price = params[:"ad_discount_price_net_#{w}"]
                          discount_currency = params[:"ad_discount_price_type_net_#{w}"]
                          if !params[:"ad_valid_date_alt_net_#{w}"].nil? && params[:"ad_valid_date_alt_net_#{w}"]!=""
                            discount_valid_or = DateTime.parse(params[:"ad_valid_date_alt_net_#{w}"])
                          else
                            discount_valid_or = ""
                          end
                          discount_validity = discount_valid_or
                          discount_number = params[:"ad_no_subs_net_#{w}"]
                          @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                            :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                        end
                      end
                    end
                  end
                end
              end
            end
          end

          to_delet =  @schedule_tot - @del_schedule

          to_delet.each do |d|
            @activity_delete = ActivitySchedule.delete_all(["schedule_id = ? ", d])
          end

        
        end
        if params[:activity][:schedule_mode] == "Any Time"
          @update_any_time = true
          raj = params[:schedule_id_value].split(",")
          @day_v = []
          @day_id = []
          re = ['mon','tue','wed','thu','fri','sat','sun'].to_a
          raj.each do |s|
            t =  s.gsub("[","").gsub("]","")
            @act_schedule = ActivitySchedule.find(t)
            @day_v << @act_schedule.business_hours
          end
          @activity_price_del = ActivityPrice.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
          re.each do |s|
            if @day_v.include?(s)
              if params[:"anytime_closed_#{s}"] !="0"
                st_time = DateTime.parse("#{params[:"anytime_s#{s}_1"]} #{params[:"anytime_s#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_s#{s}_1"].nil? && !params[:"anytime_s#{s}_2"].nil? && params[:"anytime_s#{s}_1"]!="" && params[:"anytime_s#{s}_2"]!=""
                en_time = DateTime.parse("#{params[:"anytime_e#{s}_1"]} #{params[:"anytime_e#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_e#{s}_1"].nil? && !params[:"anytime_e#{s}_2"].nil? && params[:"anytime_e#{s}_1"]!="" && params[:"anytime_e#{s}_2"]!=""
                not_value = @day_v.index(s)
                t = raj[not_value].gsub("[","").gsub("]","")
                act_schedule = ActivitySchedule.find(t)
                act_schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>"",:no_of_participant=>params[:anytime_participants],
                  :end_date=>"",:start_time=>st_time,:end_time=>en_time,:business_hours=>"#{s}")
              else
                not_value = @day_v.index(s)
                t = raj[not_value].gsub("[","").gsub("]","")
                act_schedule = ActivitySchedule.find(t)
                #              act_schedule = ActivitySchedule.find(raj[not_value])
                act_schedule.destroy
              end
            else
              if params[:"anytime_closed_#{s}"] !="0"
                st_time = DateTime.parse("#{params[:"anytime_s#{s}_1"]} #{params[:"anytime_s#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_s#{s}_1"].nil? && !params[:"anytime_s#{s}_2"].nil? && params[:"anytime_s#{s}_1"]!="" && params[:"anytime_s#{s}_2"]!=""
                en_time = DateTime.parse("#{params[:"anytime_e#{s}_1"]} #{params[:"anytime_e#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_e#{s}_1"].nil? && !params[:"anytime_e#{s}_2"].nil? && params[:"anytime_e#{s}_1"]!="" && params[:"anytime_e#{s}_2"]!=""
                @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>"",:no_of_participant=>params[:anytime_participants],
                  :end_date=>"",:start_time=>st_time,:end_time=>en_time,:business_hours=>"#{s}")
              end
            end
          end
        end

      else
        @activity_profile_apf.schedule_mode = "Any Where"
        @activity_profile_apf.address_2 = ""
        @activity_profile_apf.address_1 = ""
        @activity_profile_apf.city = ""
        @update_any_time = true
        @activity_price_del = ActivityPrice.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
        if !params[:schedule_id_value].nil? && params[:schedule_id_value]!=""
          @act_schedule = ActivitySchedule.find(params[:schedule_id_value])
          @act_schedule.update_attributes(:price_type=>price_type,:schedule_mode=>"Any Where", :expiration_date=>"2100-12-31")
        end
      end
    end

    if @update_any_time == true
      if params[:price_2] == "1"
        price_count =  params[:advance_price_count_anys].split(",").reject(&:empty?)
        price_count.each do |c|
          net_price =  params[:"ad_anytime_price_#{c}_#{c}"]
          no_class = params[:"ad_payment_box_anytime_fst_#{c}_#{c}"]
          payment_period = params[:"ad_payment_#{c}_#{c}"]
          no_hours = params[:"ad_payment_box_anytime_sec_#{c}_#{c}"] if params[:"ad_payment_box_anytime_sec_#{c}_#{c}"]!="Eg: 3"
          sh_activity=ActivitySchedule.where("activity_id=? AND schedule_mode!=?",params[:save_id],"Schedule").last
          if !sh_activity.nil? && sh_activity.present?
             @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>sh_activity.schedule_id )
          else
             @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours )
          end
          multi_discount = params[:"multiple_discount_count_#{c}_#{c}"].split(",")
          multi_discount.each do |t|
            if !params[:"ad_discount_type_#{t}_#{c}"].nil? && params[:"ad_discount_type_#{t}_#{c}"]!=""
              discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_#{t}_#{c}"]}").last
              if !discount_type.nil?
                discount_type_id = params[:"ad_discount_type_#{t}_#{c}"]
                discount_price = params[:"ad_discount_price_#{t}_#{c}"]
                discount_currency = params[:"ad_discount_price_type_#{t}_#{c}"]
                if !params[:"ad_valid_date_alt_#{t}_#{c}"].nil? && params[:"ad_valid_date_alt_#{t}_#{c}"]!=""
                  discount_valid_or = DateTime.parse(params[:"ad_valid_date_alt_#{t}_#{c}"])
                else
                  discount_valid_or = ""
                end
                discount_validity = discount_valid_or
                discount_number = params[:"ad_no_subs_#{t}_#{c}"]
                @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                  :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
              end
            end
          end
        end

      elsif params[:price_1] == "1"
        c="1"
        multi_discount = params[:"multiple_discount_count_net_#{c}_#{c}"].split(",")
        @ss = multi_discount.count
        #if multi_discount.count > 0
        #store activity schedule id for get price detail in expired activity flow
        sh_activity=ActivitySchedule.where("activity_id=? AND schedule_mode!=?",params[:save_id],"Schedule").last
        if !sh_activity.nil? && sh_activity.present?
           @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:price],:activity_schedule_id=>sh_activity.schedule_id )
        else
           @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:price] )
        end
        #end
        multi_discount.each do |t|
          if !params[:"ad_discount_type_net_#{t}_#{c}"].nil? && params[:"ad_discount_type_net_#{t}_#{c}"]!=""
            discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_net_#{t}_#{c}"]}").last
            if !discount_type.nil?
              discount_type_id = params[:"ad_discount_type_net_#{t}_#{c}"]
              discount_price = params[:"ad_discount_price_net_#{t}_#{c}"]
              discount_currency = params[:"ad_discount_price_type_net_#{t}_#{c}"]
              if !params[:"ad_valid_date_alt_net_#{t}_#{c}"].nil? && params[:"ad_valid_date_alt_net_#{t}_#{c}"]!=""
                discount_valid_or = DateTime.parse(params[:"ad_valid_date_alt_net_#{t}_#{c}"])
              else
                discount_valid_or = ""
              end
              discount_validity = discount_valid_or
              discount_number = params[:"ad_no_subs_net_#{t}_#{c}"]
              @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
            end
          end
        end
      end
    end



    #@activity_price_del = ActivityPrice.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
    if params[:price_1] == "1"
      @activity_profile_apf.price_type = 2
      @activity_profile_apf.price = params[:price]
      if params[:other_fee_open]=="1"
        add_to_provider_fee(params[:add_other_org],params[:rem_other_org],@activity_profile_apf.activity_id)
      else
        ProviderActivityFee.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
      end
      if params[:discount_code_open] == "1"
        add_to_provider_discount_code(params[:add_otherdiscount_org],params[:rem_otherdiscount_org],@activity_profile_apf.activity_id)
      else
        ProviderDiscountCode.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
      end
    elsif params[:price_2] == "1"
      @activity_profile_apf.price_type = 1
      if params[:other_fee_open]=="1"
        add_to_provider_fee(params[:add_other_org],params[:rem_other_org],@activity_profile_apf.activity_id)
      else
        ProviderActivityFee.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
      end
      if params[:discount_code_open] == "1"
        add_to_provider_discount_code(params[:add_otherdiscount_org],params[:rem_otherdiscount_org],@activity_profile_apf.activity_id)
      else
        ProviderDiscountCode.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
      end
    elsif params[:price_3] == "1"
      @activity_profile_apf.price_type = 3
      @activity_profile_apf.filter_id = 3
      ProviderActivityFee.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
      ProviderDiscountCode.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
    elsif params[:price_4] == "1"
      @activity_profile_apf.price_type = 4
      ProviderActivityFee.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
      ProviderDiscountCode.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
    end

    if params[:addres_anywhere_id] == "2"
      @activity_profile_apf.address_2 = ""
      @activity_profile_apf.address_1 = ""
      @activity_profile_apf.zip_code = ""
      @activity_profile_apf.city = ""
      @activity_profile_apf.state = ""
      params[:activity][:address_1] = ""
      params[:activity][:city] = ""
      params[:activity][:zip_code] = ""
      params[:activity][:latitude] =""
      params[:activity][:longitude] =""
      params[:activity][:schedule_mode] = "Any Where"
      @activity_profile_apf.schedule_mode = "Any Where"
    end
    if !params[:activity][:city].nil? && params[:activity][:city]!=""
      city_se = City.where("city_name='#{params[:activity][:city]}'").last
      if !city_se.nil?
        @activity_profile_apf.latitude  = city_se.latitude
        @activity_profile_apf.longitude  = city_se.longitude
      end
    end
	
    chk_update = @activity_profile_apf.update_attributes(params[:activity])
    if chk_update
	    $dc.set("activity_schedules_for#{@activity_profile_apf.activity_id}",nil)
	    $dc.set("provider_activity_for#{current_user.user_id}",nil)
    end

   
    render :partial => "provider_edit_activity_thank"
  end


  def provider_edit_new_changes
    @save_copy=params[:s_copy] if !params[:s_copy].nil?
    @set_color = params[:color_val]
    @edited_page = params[:edited_page]
    @activity_profile_apf = Activity.find(params[:save_id])
    @activity_profile_apf.description = params[:description] if params[:description] !="Description should not exceed 500 characters"
    @activity_profile_apf.contact_price = params[:con_provider]

    if params[:discountElligble]=='on'
      @activity_profile_apf.discount_eligible = params[:ddligprice] if !params[:ddligprice].nil? && params[:ddligprice].present? && params[:ddligprice]!='Eg: 3'
      @activity_profile_apf.discount_type = params[:ddselect] if !params[:ddselect].nil? && params[:ddselect].present?
    else
      @activity_profile_apf.discount_eligible=nil
      @activity_profile_apf.discount_type=nil
    end
    @page = params[:page]
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    no_participants =""
    leader = ""
    website = ""
    email =""
    address_2 =""
    cookies[:last_action] = params[:last_action]
    cookies[:page] = params[:page]
    cookies[:pro_id] = params[:cat]
    cookies[:cat_zc] = params[:cat_zc]
    leader = params[:leader] if params[:leader] != "Enter Leader Name"
    website = params[:website] if params[:website] != "Enter URL"
    email = params[:email]  if params[:email] != "Enter Email"
    phone = "#{params[:phone_1]}-" + "#{params[:phone_2]}-" + "#{params[:phone_3]}" if !params[:phone_1].nil?
    @activity_profile_apf.gender = params[:gender] if !params[:gender].nil? && params[:gender] != "--Select Gender--"
    skill_level = params[:skill_level] if params[:skill_level] != "--Select--"
    no_participants = params[:no_participants] if params[:no_participants] != "Specify Number"
    address_2  =  params[:address_2] if params[:address_2] != "Address Line 2"
    @activity_profile_apf.leader = leader
    @activity_profile_apf.state = params[:state]
    @activity_profile_apf.website = website
    @activity_profile_apf.email = email
    @activity_profile_apf.phone = phone
    @activity_profile_apf.skill_level = skill_level
    @activity_profile_apf.no_participants = no_participants
    @activity_profile_apf.address_2 = address_2
    @activity_profile_apf.modified_date = Time.now
    @activity_profile_apf.note = params[:notes]

    if !params[:min_type].nil? && params[:min_type]!='' && params[:min_type] == 'month'
      @activity_profile_apf.min_age_range = ((params[:month_age1].to_f) / 12).round(2) if !params[:month_age1].nil? && params[:month_age1]!=''
    elsif !params[:min_type].nil? && params[:min_type]!='' && params[:min_type] == 'year'
      @activity_profile_apf.min_age_range = params[:year_age1] if !params[:year_age1].nil? && params[:year_age1]!=''
    end
    if !params[:max_type].nil? && params[:max_type]!='' && params[:max_type] == 'month'
      @activity_profile_apf.max_age_range = ((params[:month_age2].to_f)/ 12).round(2) if !params[:month_age2].nil? && params[:month_age2]!=''
    elsif !params[:max_type].nil? && params[:max_type]!='' && params[:max_type].downcase == 'year'
      @activity_profile_apf.max_age_range = params[:year_age2] if !params[:year_age2].nil? && params[:year_age2]!=''
    end
	
    if !params[:photo].nil? && params[:photo]!=""
      @activity_profile_apf.avatar = params[:photo]
    end
    if params[:price_1] == "1"
      price_type = 2
    elsif params[:price_2] == "1"
      price_type = 1
    elsif params[:price_3] == "1"
      price_type = 3
    elsif params[:price_4] == "1"
      price_type = 4
    end
    if params[:url_pasted]=="1"
      unless params[:provider_url][/\Ahttp:\/\//] || params[:provider_url][/\Ahttps:\/\//]
        params[:provider_url] = "http://#{params[:provider_url]}"
      end
      @activity_profile_apf.purchase_url = params[:provider_url]
    else
      @activity_profile_apf.purchase_url =""
    end
    #    @user = User.find(cookies[:uid_usr])
    @activity_profile_apf.filter_id = 5
    @activity_old =  @activity_profile_apf.clone
    if params[:addres_anywhere_id] == "2"
      schedule_mo = "Any Where"
    else
      schedule_mo = params[:activity][:schedule_mode]
    end


    if @activity_old.schedule_mode != schedule_mo
      if !@activity_profile_apf.activity_schedule.nil? && !@activity_profile_apf.activity_schedule.empty?
        #@del_pre = ActivityRepeat.find_by_activity_schedule_id(@activity_profile_apf.activity_schedule.last.schedule_id)
        #@activity_sc = ActivityRepeat.delete_all(["activity_schedule_id = ? ",  @activity_profile_apf.activity_schedule.last.schedule_id])
        @activity_delete = ActivitySchedule.delete_all(["activity_id = ? ", params[:save_id]])
        @activity_delete = ActivityPrice.delete_all(["activity_id = ? ", params[:save_id]])
      end
      if params[:addres_anywhere_id] == "1"
        if params[:activity][:schedule_mode] == "Schedule"
          @date_split = params[:schedule_tabs].split(',') if !params[:schedule_tabs].nil?
          @date_split.each do |s|
            st_time = DateTime.parse("#{params[:"schedule_stime_1_#{s}"]} #{params[:"schedule_stime_2_#{s}"]}").strftime("%H:%M:%S") if !params[:"schedule_stime_1_#{s}"].nil? && !params[:"schedule_stime_2_#{s}"].nil? && params[:"schedule_stime_1_#{s}"]!="" && params[:"schedule_stime_2_#{s}"]!=""
            en_time = DateTime.parse("#{params[:"schedule_etime_1_#{s}"]} #{params[:"schedule_etime_2_#{s}"]}").strftime("%H:%M:%S") if !params[:"schedule_etime_1_#{s}"].nil? && !params[:"schedule_etime_2_#{s}"].nil? && params[:"schedule_etime_1_#{s}"]!="" && params[:"schedule_etime_2_#{s}"]!=""
            ex_date = ""
            if params[:"repeatCheck_#{s}"] =="yes"
              if params[:"r1_#{s}"] == "1"
                ex_date = "2100-12-31"
                end_on = ""
              else
                if !params[:"after_occ_#{s}"].nil? && params[:"after_occ_#{s}"]!=""
                  if params[:"repeatWeekVal_#{s}"] == "Daily"
                    ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).days
                  elsif params[:"repeatWeekVal_#{s}"] == "Weekly"
                    ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i * 7).days
                  elsif params[:"repeatWeekVal_#{s}"] == "Monthly"
                    ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).months
                  elsif params[:"repeatWeekVal_#{s}"] == "Yearly"
                    ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i ).years
                  end
                  #ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).days
                  end_on = ""
                elsif !params[:"repeat_alt_on_date_#{s}"].nil? && params[:"repeat_alt_on_date_#{s}"]!=""
                  ex_date = params[:"repeat_alt_on_date_#{s}"]
                  end_on = params[:"repeat_alt_on_date_#{s}"]
                end
              end
            end
            if ex_date =="" || ex_date.nil?
              ex_date = params[:"date_1_#{s}"]
            end

            @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"date_1_#{s}"],
              :end_date=>params[:"date_2_#{s}"],:start_time=>st_time,:end_time=>en_time,:price_type=>price_type,:no_of_participant=>params[:"participant_#{s}"],:expiration_date=>ex_date)
            if params[:"repeatCheck_#{s}"] =="yes"
              @schedule.activity_repeat.create(:repeat_every => params[:"repeatNumWeekVal_#{s}"],
                :ends_never=>params[:"r1_#{s}"],:end_occurences=>params[:"after_occ_#{s}"],
                :ends_on=>end_on,:starts_on=>params[:"date_1_#{s}"],:repeated_by_month=>params[:"month1_#{s}"],:repeat_on=>params[:"repeat_no_of_days_#{s}"],:repeats=>params[:"repeatWeekVal_#{s}"])
            end
            if params[:price_2] == "1"
              total_outer_div =  params[:total_outer_div].split(",").reject(&:empty?)
              total_outer_div.each do |out_div|
                if params[:"chosen_ad_sc_#{out_div}"] == s
                  if !params[:"inner_div_count_#{out_div}"].nil?
                    inner_div_count = params[:"inner_div_count_#{out_div}"].split(",")
                    inner_div_count.each do |in_div|
                      net_price =  params[:"ad_price_#{in_div}"]
                      no_class = params[:"ad_payment_box_fst_#{in_div}"]
                      payment_period = params[:"ads_payment_#{in_div}"]
                      no_hours = params[:"ad_payment_box_sec_#{in_div}"] if params[:"ad_payment_box_sec_#{in_div}"]!="Eg: 3"
                      @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>@schedule.schedule_id  )
                      if !params[:"early_div_count_#{in_div}"].nil?
                        early_div_count = params[:"early_div_count_#{in_div}"].split(",")
                        early_div_count.each do |ea_div|
                          if !params[:"ad_discount_type_#{ea_div}"].nil? && params[:"ad_discount_type_#{ea_div}"]!=""
                            discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_#{ea_div}"]}").last
                            if !discount_type.nil?
                              discount_type_id = params[:"ad_discount_type_#{ea_div}"]
                              discount_price = params[:"ad_discount_price_#{ea_div}"]
                              discount_currency = params[:"ad_discount_price_type_#{ea_div}"]
                              discount_validity = params[:"ad_valid_date_alt_#{ea_div}"]
                              discount_number = params[:"ad_no_subs_#{ea_div}"]
                              @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                                :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                            end
                          end
                        end
                      end
                    end
                  end
                end
                if !params[:"advance_notes_#{out_div}"].nil?
                  @schedule.note = params[:"advance_notes_#{out_div}"]
                  @schedule.save
                end
              end
            elsif params[:price_1] == "1"
              multi_discount = params[:total_div_count].split(",")
              multi_discount.each do |t|
                pr_a = t.split("_")
                if params[:"chosen_sc_#{t}"] == s
                  @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:"price_#{t}"],:activity_schedule_id=>@schedule.schedule_id )
                  if !params[:"net_notes_#{t}"].nil?
                    @schedule.note = params[:"net_notes_#{t}"]
                    @schedule.save
                  end
                  if !params[:"last_in_discount_id_#{pr_a[0]}"].nil?
                    early_discount = params[:"last_in_discount_id_#{pr_a[0]}"].split(",")
                    early_discount.each do |w|
                      if !params[:"ad_discount_type_net_#{w}"].nil? && params[:"ad_discount_type_net_#{w}"]!=""
                        discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_net_#{w}"]}").last
                        if !discount_type.nil?
                          discount_type_id = params[:"ad_discount_type_net_#{w}"]

                          discount_price = params[:"ad_discount_price_net_#{w}"]
                          discount_currency = params[:"ad_discount_price_type_net_#{w}"]
                          discount_validity = params[:"ad_valid_date_alt_net_#{w}"]
                          discount_number = params[:"ad_no_subs_net_#{w}"]

                          @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                            :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
        if params[:activity][:schedule_mode] == "By Appointment"
          @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:price_type=>price_type,:no_of_participant=>params[:app_participants],:expiration_date=>"2100-12-31")
          @update_any_time = true
        end
        if params[:activity][:schedule_mode] == "Any Time"
          re = ['mon','tue','wed','thu','fri','sat','sun'].to_a
          re.each do |s|
            if params[:"anytime_closed_#{s}"] !="0"
              st_time = DateTime.parse("#{params[:"anytime_s#{s}_1"]} #{params[:"anytime_s#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_s#{s}_1"].nil? && !params[:"anytime_s#{s}_2"].nil? && params[:"anytime_s#{s}_1"]!="" && params[:"anytime_s#{s}_2"]!=""
              en_time = DateTime.parse("#{params[:"anytime_e#{s}_1"]} #{params[:"anytime_e#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_e#{s}_1"].nil? && !params[:"anytime_e#{s}_2"].nil? && params[:"anytime_e#{s}_1"]!="" && params[:"anytime_e#{s}_2"]!=""
              @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],
                :start_time=>st_time,:end_time=>en_time,:price_type=>price_type,:business_hours=>"#{s}",:no_of_participant=>params[:anytime_participants],:expiration_date=>"2100-12-31")
            end
          end
          @update_any_time = true
        end
        if params[:activity][:schedule_mode] == "Camps/Workshop" || params[:activity][:schedule_mode] == "Whole Day"
          @whole_split = params[:whole_day_tabs].split(',') if !params[:whole_day_tabs].nil?
          @whole_split.each do |wd|
            if params[:"wday_1_#{wd}"] =="1"
              st_time = DateTime.parse("#{params[:"whole_stime_1_#{wd}"]} #{params[:"whole_stime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"whole_stime_1_#{wd}"].nil? && !params[:"whole_stime_2_#{wd}"].nil? && params[:"whole_stime_1_#{wd}"]!="" && params[:"whole_stime_2_#{wd}"]!=""
              en_time = DateTime.parse("#{params[:"whole_etime_1_#{wd}"]} #{params[:"whole_etime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"whole_etime_1_#{wd}"].nil? && !params[:"whole_etime_2_#{wd}"].nil? && params[:"whole_etime_1_#{wd}"]!="" && params[:"whole_etime_2_#{wd}"]!=""
              @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"datestartwhole_alt_1_#{wd}"],
                :start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:"datestartwhole_alt_1_#{wd}"],:price_type=>price_type,:no_of_participant=>params[:"single_day_participants_1_#{wd}"])
            end
            if params[:"wday_2_#{wd}"] =="1"
              st_time = DateTime.parse("#{params[:"camps_stime_1_#{wd}"]} #{params[:"camps_stime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"camps_stime_1_#{wd}"].nil? && !params[:"camps_stime_2_#{wd}"].nil? && params[:"camps_stime_1_#{wd}"]!="" && params[:"camps_stime_2_#{wd}"]!=""
              en_time = DateTime.parse("#{params[:"camps_etime_1_#{wd}"]} #{params[:"camps_etime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"camps_etime_1_#{wd}"].nil? && !params[:"camps_etime_2_#{wd}"].nil? && params[:"camps_etime_1_#{wd}"]!="" && params[:"camps_etime_2_#{wd}"]!=""
              @schedule =  @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"datestcamps_1_#{wd}"],
                :end_date=>params[:"dateencamps_2_#{wd}"],:start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:"dateencamps_2_#{wd}"],:price_type=>price_type,:no_of_participant=>params[:"mul_day_participants_1_#{wd}"])
            end

            if params[:price_2] == "1"
              total_outer_div =  params[:total_outer_div].split(",").reject(&:empty?)
              total_outer_div.each do |out_div|
                if params[:"chosen_ad_sc_#{out_div}"] == wd
                  if !params[:"inner_div_count_#{out_div}"].nil?
                    inner_div_count = params[:"inner_div_count_#{out_div}"].split(",")
                    inner_div_count.each do |in_div|
                      net_price =  params[:"ad_price_#{in_div}"]
                      no_class = params[:"ad_payment_box_fst_#{in_div}"]
                      payment_period = params[:"ads_payment_#{in_div}"]
                      no_hours = params[:"ad_payment_box_sec_#{in_div}"] if params[:"ad_payment_box_sec_#{in_div}"]!="Eg: 3"
                      @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>@schedule.schedule_id )
                      if !params[:"early_div_count_#{in_div}"].nil?
                        early_div_count = params[:"early_div_count_#{in_div}"].split(",")
                        early_div_count.each do |ea_div|
                          if !params[:"ad_discount_type_#{ea_div}"].nil? && params[:"ad_discount_type_#{ea_div}"]!=""
                            discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_#{ea_div}"]}").last
                            if !discount_type.nil?
                              discount_type_id = params[:"ad_discount_type_#{ea_div}"]
                              discount_price = params[:"ad_discount_price_#{ea_div}"]
                              discount_currency = params[:"ad_discount_price_type_#{ea_div}"]
                              discount_validity = params[:"ad_valid_date_alt_#{ea_div}"]
                              discount_number = params[:"ad_no_subs_#{ea_div}"]
                              @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                                :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                            end
                          end
                        end
                      end
                    end
                  end
                end
                if !params[:"advance_notes_#{out_div}"].nil?
                  @schedule.note = params[:"advance_notes_#{out_div}"]
                  @schedule.save
                end
              end
            elsif params[:price_1] == "1"
              multi_discount = params[:total_div_count].split(",")
              multi_discount.each do |t|
                pr_a = t.split("_")
                if params[:"chosen_sc_#{t}"] == wd
                  @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:"price_#{t}"],:activity_schedule_id=>@schedule.schedule_id )
                  if !params[:"net_notes_#{t}"].nil?
                    @schedule.note = params[:"net_notes_#{t}"]
                    @schedule.save
                  end
                  if !params[:"last_in_discount_id_#{pr_a[0]}"].nil?
                    early_discount = params[:"last_in_discount_id_#{pr_a[0]}"].split(",")
                    early_discount.each do |w|
                      if !params[:"ad_discount_type_net_#{w}"].nil? && params[:"ad_discount_type_net_#{w}"]!=""
                        discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_net_#{w}"]}").last
                        if !discount_type.nil?
                          discount_type = params[:"ad_discount_type_net_#{w}"]
                          discount_price = params[:"ad_discount_price_net_#{w}"]
                          discount_currency = params[:"ad_discount_price_type_net_#{w}"]
                          discount_validity = params[:"ad_valid_date_alt_net_#{w}"]
                          discount_number = params[:"ad_no_subs_net_#{w}"]
                          @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                            :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      else
        if params[:addres_anywhere_id] == "2"
          @activity_profile_apf.schedule_mode = "Any Where"
          @activity_profile_apf.activity_schedule.create(:schedule_mode=> "Any Where",:price_type=>price_type,:expiration_date=>"2100-12-31")
          @update_any_time = true
        end
      end
    else
      if params[:addres_anywhere_id] == "1"
        if params[:activity][:schedule_mode] == "Schedule"
          @date_split = params[:schedule_tabs].split(',') if !params[:schedule_tabs].nil?

          @schedule_tot = ActivitySchedule.where("activity_id=#{params[:save_id]}").map(&:schedule_id)
          @del_schedule = []
       
          @date_split.each do |s|
            if !params[:"schedule_r_1_#{s}"].nil?
              if @schedule_tot.include?(params[:"schedule_r_1_#{s}"].to_i)
                @del_schedule << params[:"schedule_r_1_#{s}"].to_i if !params[:"schedule_r_1_#{s}"].nil?
                @act_schedule = ActivitySchedule.find(params[:"schedule_r_1_#{s}"])
                st_time = DateTime.parse("#{params[:"schedule_stime_1_#{s}"]} #{params[:"schedule_stime_2_#{s}"]}").strftime("%H:%M:%S") if !params[:"schedule_stime_1_#{s}"].nil? && !params[:"schedule_stime_2_#{s}"].nil? && params[:"schedule_stime_1_#{s}"]!="" && params[:"schedule_stime_2_#{s}"]!=""
                en_time = DateTime.parse("#{params[:"schedule_etime_1_#{s}"]} #{params[:"schedule_etime_2_#{s}"]}").strftime("%H:%M:%S") if !params[:"schedule_etime_1_#{s}"].nil? && !params[:"schedule_etime_2_#{s}"].nil? && params[:"schedule_etime_1_#{s}"]!="" && params[:"schedule_etime_2_#{s}"]!=""
                ex_date = ""
                if params[:"repeatCheck_#{s}"] =="yes"
                  if params[:"r1_#{s}"] == "1"
                    ex_date = "2100-12-31"
                    end_on = ""
                  else
                    if !params[:"after_occ_#{s}"].nil? && params[:"after_occ_#{s}"]!=""
                      if params[:"repeatWeekVal_#{s}"] == "Daily"
                        ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).days
                      elsif params[:"repeatWeekVal_#{s}"] == "Weekly"
                        ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i * 7).days
                      elsif params[:"repeatWeekVal_#{s}"] == "Monthly"
                        ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).months
                      elsif params[:"repeatWeekVal_#{s}"] == "Yearly"
                        ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i ).years
                      end

                      #ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).days
                      end_on = ""
                    elsif !params[:"repeat_alt_on_date_#{s}"].nil? && params[:"repeat_alt_on_date_#{s}"]!=""
                      ex_date = params[:"repeat_alt_on_date_#{s}"]
                      end_on = params[:"repeat_alt_on_date_#{s}"]
                    end
                  end
                end
                if ex_date =="" || ex_date.nil?
                  ex_date = params[:"date_1_#{s}"]
                end
                @activity_price_del = ActivityPrice.delete_all(["activity_schedule_id = ? ",  @act_schedule.schedule_id])
                @act_schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"date_1_#{s}"],
                  :end_date=>params[:"date_2_#{s}"],:start_time=>st_time,:end_time=>en_time,:price_type=>price_type,:no_of_participant=>params[:"participant_#{s}"],:expiration_date=>ex_date)
                if params[:"repeatCheck_#{s}"]=="yes"
                  @activity_repeat = ActivityRepeat.find_by_activity_schedule_id(@act_schedule.schedule_id)
                  if !@activity_repeat.nil?
                    @activity_repeat.repeat_every = params[:"repeatNumWeekVal_#{s}"]
                    @activity_repeat.ends_never= params[:"r1_#{s}"]
                    @activity_repeat.end_occurences= params[:"after_occ_#{s}"]
                    @activity_repeat.ends_on= end_on
                    @activity_repeat.starts_on = params[:"date_1_#{s}"]
                    @activity_repeat.repeat_on= params[:"repeat_no_of_days_#{s}"]
                    @activity_repeat.repeats= params[:"repeatWeekVal_#{s}"]
                    @activity_repeat.repeated_by_month = params[:"month1_#{s}"]
                    @activity_repeat.save
                  else
                    @act_schedule.activity_repeat.create(:repeat_every => params[:"repeatNumWeekVal_#{s}"],
                      :ends_never=>params[:"r1_#{s}"],:end_occurences=>params[:"after_occ_#{s}"],
                      :ends_on=>end_on,:starts_on=>params[:"date_1_#{s}"],:repeated_by_month=>params[:"month1_#{s}"],:repeat_on=>params[:"repeat_no_of_days_#{s}"],:repeats=>params[:"repeatWeekVal_#{s}"])
                  end
                else
                  @activity_sc = ActivityRepeat.delete_all(["activity_schedule_id = ? ",  @act_schedule.schedule_id])
                end

                if params[:price_2] == "1"
                  total_outer_div =  params[:total_outer_div].split(",").reject(&:empty?)
                  total_outer_div.each do |out_div|
                    if params[:"chosen_ad_sc_#{out_div}"] == s
                      if !params[:"inner_div_count_#{out_div}"].nil?
                        inner_div_count = params[:"inner_div_count_#{out_div}"].split(",")
                        inner_div_count.each do |in_div|
                          net_price =  params[:"ad_price_#{in_div}"]
                          no_class = params[:"ad_payment_box_fst_#{in_div}"]
                          payment_period = params[:"ads_payment_#{in_div}"]
                          no_hours = params[:"ad_payment_box_sec_#{in_div}"] if params[:"ad_payment_box_sec_#{in_div}"]!="Eg: 3"
                          @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>@act_schedule.schedule_id  )
                          if !params[:"early_div_count_#{in_div}"].nil?
                            early_div_count = params[:"early_div_count_#{in_div}"].split(",")
                            early_div_count.each do |ea_div|
                              if !params[:"ad_discount_type_#{ea_div}"].nil? && params[:"ad_discount_type_#{ea_div}"]!=""
                                discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_#{ea_div}"]}").last
                                if !discount_type.nil?
                                  discount_type_id = params[:"ad_discount_type_#{ea_div}"]
                                  discount_price = params[:"ad_discount_price_#{ea_div}"]
                                  discount_currency = params[:"ad_discount_price_type_#{ea_div}"]
                                  discount_validity = params[:"ad_valid_date_alt_#{ea_div}"]
                                  discount_number = params[:"ad_no_subs_#{ea_div}"]
                                  @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                                    :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                    if !params[:"advance_notes_#{out_div}"].nil?
                      @act_schedule.note = params[:"advance_notes_#{out_div}"]
                      @act_schedule.save
                    end
                  end
                elsif params[:price_1] == "1"
                  multi_discount = params[:total_div_count].split(",")
                  multi_discount.each do |t|
                    pr_a = t.split("_")
                    if params[:"chosen_sc_#{t}"] == s
                      @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:"price_#{t}"],:activity_schedule_id=>@act_schedule.schedule_id )
                      if !params[:"net_notes_#{t}"].nil? && params[:"net_notes_#{t}"] != "Notes:"
                        @act_schedule.note = params[:"net_notes_#{t}"]
                        @act_schedule.save
                      end
                      if !params[:"last_in_discount_id_#{pr_a[0]}"].nil?
                        early_discount = params[:"last_in_discount_id_#{pr_a[0]}"].split(",")
                        early_discount.each do |w|
                          if !params[:"ad_discount_type_net_#{w}"].nil? && params[:"ad_discount_type_net_#{w}"]!=""
                            discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_net_#{w}"]}").last
                            if !discount_type.nil?
                              discount_type_id = params[:"ad_discount_type_net_#{w}"]
                              discount_price = params[:"ad_discount_price_net_#{w}"]
                              discount_currency = params[:"ad_discount_price_type_net_#{w}"]
                              discount_validity = params[:"ad_valid_date_alt_net_#{w}"]
                              discount_number = params[:"ad_no_subs_net_#{w}"]
                              @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                                :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            else
              st_time = DateTime.parse("#{params[:"schedule_stime_1_#{s}"]} #{params[:"schedule_stime_2_#{s}"]}").strftime("%H:%M:%S") if !params[:"schedule_stime_1_#{s}"].nil? && !params[:"schedule_stime_2_#{s}"].nil? && params[:"schedule_stime_1_#{s}"]!="" && params[:"schedule_stime_2_#{s}"]!=""
              en_time = DateTime.parse("#{params[:"schedule_etime_1_#{s}"]} #{params[:"schedule_etime_2_#{s}"]}").strftime("%H:%M:%S") if !params[:"schedule_etime_1_#{s}"].nil? && !params[:"schedule_etime_2_#{s}"].nil? && params[:"schedule_etime_1_#{s}"]!="" && params[:"schedule_etime_2_#{s}"]!=""
              ex_date = ""
              if params[:"repeatCheck_#{s}"] =="yes"
                if params[:"r1_#{s}"] == "1"
                  ex_date = "2100-12-31"
                  end_on = ""
                else
                  if !params[:"after_occ_#{s}"].nil? && params[:"after_occ_#{s}"]!=""
                    if params[:"repeatWeekVal_#{s}"] == "Daily"
                      ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).days
                    elsif params[:"repeatWeekVal_#{s}"] == "Weekly"
                      ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i * 7).days
                    elsif params[:"repeatWeekVal_#{s}"] == "Monthly"
                      ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).months
                    elsif params[:"repeatWeekVal_#{s}"] == "yearly"
                      ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i ).years
                    end
                    #ex_date = Date.parse(params[:"date_1_#{s}"]) + (params[:"repeatNumWeekVal_#{s}"].to_i * params[:"after_occ_#{s}"].to_i).days
                    end_on = ""
                  elsif !params[:"repeat_alt_on_date_#{s}"].nil? && params[:"repeat_alt_on_date_#{s}"]!=""
                    ex_date = params[:"repeat_alt_on_date_#{s}"]
                    end_on = params[:"repeat_alt_on_date_#{s}"]
                  end
                end
              end
              if ex_date =="" || ex_date.nil?
                ex_date = params[:"date_1_#{s}"]
              end

              @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"date_1_#{s}"],
                :end_date=>params[:"date_2_#{s}"],:start_time=>st_time,:end_time=>en_time,:price_type=>price_type,:no_of_participant=>params[:"participant_#{s}"],:expiration_date=>ex_date)
              if params[:"repeatCheck_#{s}"] =="yes"
                @schedule.activity_repeat.create(:repeat_every => params[:"repeatNumWeekVal_#{s}"],
                  :ends_never=>params[:"r1_#{s}"],:end_occurences=>params[:"after_occ_#{s}"],
                  :ends_on=>end_on,:starts_on=>params[:"date_1_#{s}"],:repeated_by_month=>params[:"month1_#{s}"],:repeat_on=>params[:"repeat_no_of_days_#{s}"],:repeats=>params[:"repeatWeekVal_#{s}"])
              end
              if params[:price_2] == "1"
                total_outer_div =  params[:total_outer_div].split(",").reject(&:empty?)
                total_outer_div.each do |out_div|
                  if params[:"chosen_ad_sc_#{out_div}"] == s
                    if !params[:"inner_div_count_#{out_div}"].nil?
                      inner_div_count = params[:"inner_div_count_#{out_div}"].split(",")
                      inner_div_count.each do |in_div|
                        net_price =  params[:"ad_price_#{in_div}"]
                        no_class = params[:"ad_payment_box_fst_#{in_div}"]
                        payment_period = params[:"ads_payment_#{in_div}"]
                        no_hours = params[:"ad_payment_box_sec_#{in_div}"] if params[:"ad_payment_box_sec_#{in_div}"]!="Eg: 3"
                        @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>@schedule.schedule_id  )
                        if !params[:"early_div_count_#{in_div}"].nil?
                          early_div_count = params[:"early_div_count_#{in_div}"].split(",")
                          early_div_count.each do |ea_div|
                            if !params[:"ad_discount_type_#{ea_div}"].nil? && params[:"ad_discount_type_#{ea_div}"]!=""
                              discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_#{ea_div}"]}").last
                              if !discount_type.nil?
                                discount_type_id = params[:"ad_discount_type_#{ea_div}"]
                                discount_price = params[:"ad_discount_price_#{ea_div}"]
                                discount_currency = params[:"ad_discount_price_type_#{ea_div}"]
                                discount_validity = params[:"ad_valid_date_alt_#{ea_div}"]
                                discount_number = params[:"ad_no_subs_#{ea_div}"]
                                @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                                  :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                  if !params[:"advance_notes_#{out_div}"].nil?
                    @act_schedule.note = params[:"advance_notes_#{out_div}"]
                    @act_schedule.save
                  end
                end
              elsif params[:price_1] == "1"
                multi_discount = params[:total_div_count].split(",")
                multi_discount.each do |t|
                  pr_a = t.split("_")
                  if params[:"chosen_sc_#{t}"] == s
                    @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:"price_#{t}"],:activity_schedule_id=>@schedule.schedule_id )
                    if !params[:"net_notes_#{t}"].nil? && params[:"net_notes_#{t}"] != "Notes:"
                      @schedule.note = params[:"net_notes_#{t}"]
                      @schedule.save
                    end
                    if !params[:"last_in_discount_id_#{pr_a[0]}"].nil?
                      early_discount = params[:"last_in_discount_id_#{pr_a[0]}"].split(",")
                      early_discount.each do |w|
                        if !params[:"ad_discount_type_net_#{w}"].nil? && params[:"ad_discount_type_net_#{w}"]!=""
                          discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_net_#{w}"]}").last
                          if !discount_type.nil?
                            discount_type_id = params[:"ad_discount_type_net_#{w}"]
                            discount_price = params[:"ad_discount_price_net_#{w}"]
                            discount_currency = params[:"ad_discount_price_type_net_#{w}"]
                            discount_validity = params[:"ad_valid_date_alt_net_#{w}"]
                            discount_number = params[:"ad_no_subs_net_#{w}"]
                            @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                              :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end #date_spilt end

          to_delet =  @schedule_tot - @del_schedule

          to_delet.each do |d|
            @activity_delete = ActivitySchedule.delete_all(["schedule_id = ? ", d])
          end
        end



        if params[:activity][:schedule_mode] == "By Appointment"
          @update_any_time = true
          @activity_price_del = ActivityPrice.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
          if !params[:schedule_id_value].nil? && params[:schedule_id_value]!=""
            @act_schedule = ActivitySchedule.find(params[:schedule_id_value])
            @act_schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:price_type=>price_type,:no_of_participant=>params[:app_participants],:expiration_date=>"2100-12-31")
          end
        end
        if params[:activity][:schedule_mode] == "Camps/Workshop" || params[:activity][:schedule_mode] == "Whole Day"
          @schedule_tot = ActivitySchedule.where("activity_id=#{params[:save_id]}").map(&:schedule_id)
          @del_schedule =[]
          @whole_split = params[:whole_day_tabs].split(',') if !params[:whole_day_tabs].nil?
          @whole_split.each do |wd|
            if !params[:"schedule_whr_1_#{wd}"].nil?
              if @schedule_tot.include?(params[:"schedule_whr_1_#{wd}"].to_i)
                @del_schedule << params[:"schedule_whr_1_#{wd}"].to_i if !params[:"schedule_whr_1_#{wd}"].nil?
                @schedule = ActivitySchedule.find(params[:"schedule_whr_1_#{wd}"])
                @activity_price_del = ActivityPrice.delete_all(["activity_schedule_id = ? ",  @schedule.schedule_id])
                if params[:"wday_1_#{wd}"] =="1"
                  st_time = DateTime.parse("#{params[:"whole_stime_1_#{wd}"]} #{params[:"whole_stime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"whole_stime_1_#{wd}"].nil? && !params[:"whole_stime_2_#{wd}"].nil? && params[:"whole_stime_1_#{wd}"]!="" && params[:"whole_stime_2_#{wd}"]!=""
                  en_time = DateTime.parse("#{params[:"whole_etime_1_#{wd}"]} #{params[:"whole_etime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"whole_etime_1_#{wd}"].nil? && !params[:"whole_etime_2_#{wd}"].nil? && params[:"whole_etime_1_#{wd}"]!="" && params[:"whole_etime_2_#{wd}"]!=""
                  @schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"datestartwhole_alt_1_#{wd}"],
                    :start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:"datestartwhole_alt_1_#{wd}"],:price_type=>price_type,:no_of_participant=>params[:"single_day_participants_1_#{wd}"])
                end
                if params[:"wday_2_#{wd}"] =="1"
                  st_time = DateTime.parse("#{params[:"camps_stime_1_#{wd}"]} #{params[:"camps_stime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"camps_stime_1_#{wd}"].nil? && !params[:"camps_stime_2_#{wd}"].nil? && params[:"camps_stime_1_#{wd}"]!="" && params[:"camps_stime_2_#{wd}"]!=""
                  en_time = DateTime.parse("#{params[:"camps_etime_1_#{wd}"]} #{params[:"camps_etime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"camps_etime_1_#{wd}"].nil? && !params[:"camps_etime_2_#{wd}"].nil? && params[:"camps_etime_1_#{wd}"]!="" && params[:"camps_etime_2_#{wd}"]!=""
                  @schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"datestcamps_1_#{wd}"],
                    :end_date=>params[:"dateencamps_2_#{wd}"],:start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:"dateencamps_2_#{wd}"],:price_type=>price_type,:no_of_participant=>params[:"mul_day_participants_1_#{wd}"])
                end
              else
                @whole_create = true
              end
            else
              @whole_create = true
            end
            if @whole_create == true
              if params[:"wday_1_#{wd}"] =="1"
                st_time = DateTime.parse("#{params[:"whole_stime_1_#{wd}"]} #{params[:"whole_stime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"whole_stime_1_#{wd}"].nil? && !params[:"whole_stime_2_#{wd}"].nil? && params[:"whole_stime_1_#{wd}"]!="" && params[:"whole_stime_2_#{wd}"]!=""
                en_time = DateTime.parse("#{params[:"whole_etime_1_#{wd}"]} #{params[:"whole_etime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"whole_etime_1_#{wd}"].nil? && !params[:"whole_etime_2_#{wd}"].nil? && params[:"whole_etime_1_#{wd}"]!="" && params[:"whole_etime_2_#{wd}"]!=""
                @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"datestartwhole_alt_1_#{wd}"],
                  :start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:"datestartwhole_alt_1_#{wd}"],:price_type=>price_type,:no_of_participant=>params[:"single_day_participants_1_#{wd}"])
              end
              if params[:"wday_2_#{wd}"] =="1"
                st_time = DateTime.parse("#{params[:"camps_stime_1_#{wd}"]} #{params[:"camps_stime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"camps_stime_1_#{wd}"].nil? && !params[:"camps_stime_2_#{wd}"].nil? && params[:"camps_stime_1_#{wd}"]!="" && params[:"camps_stime_2_#{wd}"]!=""
                en_time = DateTime.parse("#{params[:"camps_etime_1_#{wd}"]} #{params[:"camps_etime_2_#{wd}"]}").strftime("%H:%M:%S") if !params[:"camps_etime_1_#{wd}"].nil? && !params[:"camps_etime_2_#{wd}"].nil? && params[:"camps_etime_1_#{wd}"]!="" && params[:"camps_etime_2_#{wd}"]!=""
                @schedule =  @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:"datestcamps_1_#{wd}"],
                  :end_date=>params[:"dateencamps_2_#{wd}"],:start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:"dateencamps_2_#{wd}"],:price_type=>price_type,:no_of_participant=>params[:"mul_day_participants_1_#{wd}"])
              end
            end
        

            if params[:price_2] == "1"
              total_outer_div =  params[:total_outer_div].split(",").reject(&:empty?)
              total_outer_div.each do |out_div|
                if params[:"chosen_ad_sc_#{out_div}"] == wd
                  if !params[:"inner_div_count_#{out_div}"].nil?
                    inner_div_count = params[:"inner_div_count_#{out_div}"].split(",")
                    inner_div_count.each do |in_div|
                      net_price =  params[:"ad_price_#{in_div}"]
                      no_class = params[:"ad_payment_box_fst_#{in_div}"]
                      payment_period = params[:"ads_payment_#{in_div}"]
                      no_hours = params[:"ad_payment_box_sec_#{in_div}"] if params[:"ad_payment_box_sec_#{in_div}"]!="Eg: 3"
                      @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>@schedule.schedule_id )
                      if !params[:"early_div_count_#{in_div}"].nil?
                        early_div_count = params[:"early_div_count_#{in_div}"].split(",")
                        early_div_count.each do |ea_div|
                          if !params[:"ad_discount_type_#{ea_div}"].nil? && params[:"ad_discount_type_#{ea_div}"]!=""
                            discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_#{ea_div}"]}").last
                            if !discount_type.nil?
                              discount_type_id = params[:"ad_discount_type_#{ea_div}"]
                              discount_price = params[:"ad_discount_price_#{ea_div}"]
                              discount_currency = params[:"ad_discount_price_type_#{ea_div}"]
                              discount_validity = params[:"ad_valid_date_alt_#{ea_div}"]
                              discount_number = params[:"ad_no_subs_#{ea_div}"]
                              @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                                :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                            end
                          end
                        end
                      end
                    end
                  end
                end
                if !params[:"advance_notes_#{out_div}"].nil?
                  @schedule.note = params[:"advance_notes_#{out_div}"]
                  @schedule.save
                end
              end
            elsif params[:price_1] == "1"
              multi_discount = params[:total_div_count].split(",")
              multi_discount.each do |t|
                pr_a = t.split("_")
                if params[:"chosen_sc_#{t}"] == wd
                  @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:"price_#{t}"],:activity_schedule_id=>@schedule.schedule_id )
                  if !params[:"net_notes_#{t}"].nil?
                    @schedule.note = params[:"net_notes_#{t}"]
                    @schedule.save
                  end
                  if !params[:"last_in_discount_id_#{pr_a[0]}"].nil?
                    early_discount = params[:"last_in_discount_id_#{pr_a[0]}"].split(",")
                    early_discount.each do |w|
                      if !params[:"ad_discount_type_net_#{w}"].nil? && params[:"ad_discount_type_net_#{w}"]!=""
                        discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_net_#{w}"]}").last
                        if !discount_type.nil?
                          discount_type_id = params[:"ad_discount_type_net_#{w}"]
                          discount_price = params[:"ad_discount_price_net_#{w}"]
                          discount_currency = params[:"ad_discount_price_type_net_#{w}"]
                          discount_validity = params[:"ad_valid_date_alt_net_#{w}"]
                          discount_number = params[:"ad_no_subs_net_#{w}"]
                          @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                            :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
                        end
                      end
                    end
                  end
                end
              end
            end
          end

          to_delet =  @schedule_tot - @del_schedule

          to_delet.each do |d|
            @activity_delete = ActivitySchedule.delete_all(["schedule_id = ? ", d])
          end

        
        end
        if params[:activity][:schedule_mode] == "Any Time"
          @update_any_time = true
          raj = params[:schedule_id_value].split(",")
          @day_v = []
          @day_id = []
          re = ['mon','tue','wed','thu','fri','sat','sun'].to_a
          raj.each do |s|
            t =  s.gsub("[","").gsub("]","")
            @act_schedule = ActivitySchedule.find(t)
            @day_v << @act_schedule.business_hours
          end
          @activity_price_del = ActivityPrice.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
          re.each do |s|
            if @day_v.include?(s)
              if params[:"anytime_closed_#{s}"] !="0"
                st_time = DateTime.parse("#{params[:"anytime_s#{s}_1"]} #{params[:"anytime_s#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_s#{s}_1"].nil? && !params[:"anytime_s#{s}_2"].nil? && params[:"anytime_s#{s}_1"]!="" && params[:"anytime_s#{s}_2"]!=""
                en_time = DateTime.parse("#{params[:"anytime_e#{s}_1"]} #{params[:"anytime_e#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_e#{s}_1"].nil? && !params[:"anytime_e#{s}_2"].nil? && params[:"anytime_e#{s}_1"]!="" && params[:"anytime_e#{s}_2"]!=""
                not_value = @day_v.index(s)
                t = raj[not_value].gsub("[","").gsub("]","")
                act_schedule = ActivitySchedule.find(t)
                act_schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>"",:no_of_participant=>params[:anytime_participants],
                  :end_date=>"",:start_time=>st_time,:end_time=>en_time,:business_hours=>"#{s}")
              else
                not_value = @day_v.index(s)
                t = raj[not_value].gsub("[","").gsub("]","")
                act_schedule = ActivitySchedule.find(t)
                #              act_schedule = ActivitySchedule.find(raj[not_value])
                act_schedule.destroy
              end
            else
              if params[:"anytime_closed_#{s}"] !="0"
                st_time = DateTime.parse("#{params[:"anytime_s#{s}_1"]} #{params[:"anytime_s#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_s#{s}_1"].nil? && !params[:"anytime_s#{s}_2"].nil? && params[:"anytime_s#{s}_1"]!="" && params[:"anytime_s#{s}_2"]!=""
                en_time = DateTime.parse("#{params[:"anytime_e#{s}_1"]} #{params[:"anytime_e#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_e#{s}_1"].nil? && !params[:"anytime_e#{s}_2"].nil? && params[:"anytime_e#{s}_1"]!="" && params[:"anytime_e#{s}_2"]!=""
                @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>"",:no_of_participant=>params[:anytime_participants],
                  :end_date=>"",:start_time=>st_time,:end_time=>en_time,:business_hours=>"#{s}")
              end
            end
          end
        end

      else
        @activity_profile_apf.schedule_mode = "Any Where"
        @activity_profile_apf.address_2 = ""
        @activity_profile_apf.address_1 = ""
        @activity_profile_apf.city = ""
        @update_any_time = true
        @activity_price_del = ActivityPrice.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
        if !params[:schedule_id_value].nil? && params[:schedule_id_value]!=""
          @act_schedule = ActivitySchedule.find(params[:schedule_id_value])
          @act_schedule.update_attributes(:price_type=>price_type,:schedule_mode=>"Any Where", :expiration_date=>"2100-12-31")
        end
      end
    end

    if @update_any_time == true
      if params[:price_2] == "1"
        price_count =  params[:advance_price_count_anys].split(",").reject(&:empty?)
        price_count.each do |c|
          net_price =  params[:"ad_anytime_price_#{c}_#{c}"]
          no_class = params[:"ad_payment_box_anytime_fst_#{c}_#{c}"]
          payment_period = params[:"ad_payment_#{c}_#{c}"]
          no_hours = params[:"ad_payment_box_anytime_sec_#{c}_#{c}"] if params[:"ad_payment_box_anytime_sec_#{c}_#{c}"]!="Eg: 3"
          sh_activity=ActivitySchedule.where("activity_id=? AND schedule_mode!=?",params[:save_id],"Schedule").last
          if !sh_activity.nil? && sh_activity.present?
            @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>sh_activity.schedule_id  )

          else
            @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours )
          end
          
          multi_discount = params[:"multiple_discount_count_#{c}_#{c}"].split(",")
          multi_discount.each do |t|
            if !params[:"ad_discount_type_#{t}_#{c}"].nil? && params[:"ad_discount_type_#{t}_#{c}"]!=""
              discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_#{t}_#{c}"]}").last
              if !discount_type.nil?
                discount_type_id = params[:"ad_discount_type_#{t}_#{c}"]
                discount_price = params[:"ad_discount_price_#{t}_#{c}"]
                discount_currency = params[:"ad_discount_price_type_#{t}_#{c}"]
                discount_validity = params[:"ad_valid_date_alt_#{t}_#{c}"]
                discount_number = params[:"ad_no_subs_#{t}_#{c}"]
                @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                  :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
              end
            end
          end
        end

      elsif params[:price_1] == "1"
        c="1"
        multi_discount = params[:"multiple_discount_count_net_#{c}_#{c}"].split(",")
        @ss = multi_discount.count
        #if multi_discount.count > 0
        sh_activity=ActivitySchedule.where("activity_id=? AND schedule_mode!=?",params[:save_id],"Schedule").last
          if !sh_activity.nil? && sh_activity.present?
            @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:price],:activity_schedule_id=>sh_activity.schedule_id  )
          else
            @activity_price = @activity_profile_apf.activity_price.create(:price=>params[:price] )
          end
        #@activity_price = @activity_profile_apf.activity_price.create( :price=>params[:price] )
        #end
        multi_discount.each do |t|
          if !params[:"ad_discount_type_net_#{t}_#{c}"].nil? && params[:"ad_discount_type_net_#{t}_#{c}"]!=""
            discount_type = ProviderDiscountType.where("(user_id=#{current_user.user_id} or user_id is null) and provider_discount_type_id=#{params[:"ad_discount_type_net_#{t}_#{c}"]}").last
            if !discount_type.nil?
              discount_type_id = params[:"ad_discount_type_net_#{t}_#{c}"]
              discount_price = params[:"ad_discount_price_net_#{t}_#{c}"]
              discount_currency = params[:"ad_discount_price_type_net_#{t}_#{c}"]
              discount_validity = params[:"ad_valid_date_alt_net_#{t}_#{c}"]
              discount_number = params[:"ad_no_subs_net_#{t}_#{c}"]
              @activity_price.activity_discount_price.create(:discount_type=>discount_type.discount_name,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
                :discount_valid => discount_validity,:discount_number =>discount_number,:provider_discount_type_id=>discount_type_id) if !discount_price.nil? && discount_price.present? && discount_price!=''
            end
          end
        end
      end
    end



    #@activity_price_del = ActivityPrice.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
    if params[:price_1] == "1"
      @activity_profile_apf.price_type = 2
      @activity_profile_apf.price = params[:price]
      if params[:other_fee_open]=="1"
        add_to_provider_fee(params[:add_other_org],params[:rem_other_org],@activity_profile_apf.activity_id)
      else
        ProviderActivityFee.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
      end
      if params[:discount_code_open] == "1"
        add_to_provider_discount_code(params[:add_otherdiscount_org],params[:rem_otherdiscount_org],@activity_profile_apf.activity_id)
      else
        ProviderDiscountCode.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
      end
    elsif params[:price_2] == "1"
      @activity_profile_apf.price_type = 1
      if params[:other_fee_open]=="1"
        add_to_provider_fee(params[:add_other_org],params[:rem_other_org],@activity_profile_apf.activity_id)
      else
        ProviderActivityFee.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
      end
      if params[:discount_code_open] == "1"
        add_to_provider_discount_code(params[:add_otherdiscount_org],params[:rem_otherdiscount_org],@activity_profile_apf.activity_id)
      else
        ProviderDiscountCode.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
      end
    elsif params[:price_3] == "1"
      @activity_profile_apf.price_type = 3
      @activity_profile_apf.filter_id = 3
      ProviderActivityFee.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
      ProviderDiscountCode.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
    elsif params[:price_4] == "1"
      @activity_profile_apf.price_type = 4
      ProviderActivityFee.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
      ProviderDiscountCode.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
    end

    if params[:addres_anywhere_id] == "2"
      @activity_profile_apf.address_2 = ""
      @activity_profile_apf.address_1 = ""
      @activity_profile_apf.zip_code = ""
      @activity_profile_apf.city = ""
      @activity_profile_apf.state = ""
      params[:activity][:address_1] = ""
      params[:activity][:city] = ""
      params[:activity][:zip_code] = ""
      params[:activity][:schedule_mode] = "Any Where"
      @activity_profile_apf.schedule_mode = "Any Where"
    end
    @activity_profile_apf.update_attributes(params[:activity])
   
    render :partial => "provider_edit_activity_thank"
  end



  def send_edit_mail

    @activity_profile_apf = Activity.find(params[:act_id])
    if params[:atten_dies]=="1"
      #setting notification detail sending a mail to the provider
      @provider_notifications_activity = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='2' and p.user_id='#{@activity_profile_apf.user_id}' and p.notify_flag=true") if !@activity_profile_apf.nil? && !@activity_profile_apf.user_id.nil?
      if @provider_notifications_activity.present? && @provider_notifications_activity!="" && !@provider_notifications_activity.nil?
        @participant=ActivityAttendDetail.select("user_id").where("activity_id =? and lower(payment_status)=?",@activity_profile_apf.activity_id,'paid').uniq
        @get_current_url = request.env['HTTP_HOST']
        @participant.each do |r|
          user=User.find_by_user_id(r.user_id)
          attend_email=user.email_address
          if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
            #@result = UserMailer.edit_activity_mail(user,@activity_profile_apf,@get_current_url,params[:message],attend_email,params[:subject]).deliver
            @result = UserMailer.delay(queue: "Edit Provider Activity to Participants", priority: 2, run_at: 10.seconds.from_now).edit_provider_participant_mail(user,@activity_profile_apf,@get_current_url,attend_email)
          end  if user.present? && !user.nil?
        end #do end participant
      else #first if the user not present in setting tables.
        @participant=ActivityAttendDetail.select("user_id").where("activity_id =? and lower(payment_status)=?",@activity_profile_apf.activity_id,'paid').uniq
        # to get the all participant details from participant table.
        @get_current_url = request.env['HTTP_HOST']
        @participant.each do |r|
          user=User.find_by_user_id(r.user_id)
          attend_email=user.email_address if user && user.present?
          if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
            @result = UserMailer.delay(queue: "Edit Provider Activity to Participants", priority: 2, run_at: 10.seconds.from_now).edit_provider_participant_mail(user,@activity_profile_apf,@get_current_url,attend_email)
          end  if user.present? && !user.nil?
        end #do end participant
      end #if loop end for participant
    end

    if params[:just_me]=="1"
      @provider_notification_default = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='5' and p.user_id='#{@activity_profile_apf.user_id}' and p.notify_flag=true") if !@activity_profile_apf.nil? && !@activity_profile_apf.user_id.nil?
      if @provider_notification_default.present? && @provider_notification_default!="" && !@provider_notification_default.nil?
        #sending a mail while editing the activity by the provider
        @get_current_url = request.env['HTTP_HOST']
        @plan = current_user.user_plan if !current_user.nil? && !current_user.user_plan.nil?
        user=User.find_by_user_id(@activity_profile_apf.user_id) if !@activity_profile_apf.nil?
        attend_email=user.email_address if !user.email_address.nil?
        if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Provider Edit Activity", priority: 2, run_at: 10.seconds.from_now).edit_activity_provider_mail(user,@activity_profile_apf,@get_current_url,attend_email,@plan)
        end
      else
        #sending a mail while editing the activity by the provider
        user=User.find_by_user_id(@activity_profile_apf.user_id) if !@activity_profile_apf.nil?
        attend_email=user.email_address if !user.email_address.nil?
        @get_current_url = request.env['HTTP_HOST']
        @plan = current_user.user_plan if !current_user.nil? && !current_user.user_plan.nil?
        if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Provider Edit Activity", priority: 2, run_at: 10.seconds.from_now).edit_activity_provider_mail(user,@activity_profile_apf,@get_current_url,attend_email,@plan)
        end
      end #if loop end for provider mail
    end

    if params[:represen_tative]=="1"
      @school_rep = SchoolRepresentative.where("activity_id = #{params[:act_id]}")
      @school_rep.each do |s|
        user=User.find_by_user_id(s.representative_id)
        attend_email=user.email_address if !user.email_address.nil?
        @get_current_url = request.env['HTTP_HOST']
        @plan = current_user.user_plan if !current_user.nil? && !current_user.user_plan.nil?
        if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Provider Edit Activity", priority: 2, run_at: 10.seconds.from_now).edit_activity_provider_mail(user,@activity_profile_apf,@get_current_url,attend_email,@plan)
        end
      end
      
    end



    exist_result = "success"
    render :text => exist_result.to_json

   
  end



  def activity_detail_page_old
    @get_current_url = request.env['HTTP_HOST']
    @activity = Activity.find(params[:det])
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    if params[:click]=="clicked"
      ip_address = request.ip
      user_add = "anonymous"
      user_add = current_user.email_address if !current_user.nil?
      @click = ActivityClick.where("activity_id=#{params[:det]} and device_id='#{ip_address}' and click_date='#{Date.today}' and user_type='#{user_add}'").last
      unless @click.nil?
        @click_count = @click.no_of_clicks
        count = @click_count.to_i + 1
        @update = @click.update_attributes(:no_of_attempts => count,:user_type =>user_add)
      else
        sdate = Time.now.beginning_of_month.strftime("%Y-%m-%d")
        edate = Time.now.end_of_month.strftime("%Y-%m-%d")
        @mon = MonthlyBudget.where("user_id=#{@activity.user_id} and bid_start_date='#{sdate}' and bid_end_date='#{edate}'").last
        #@mon = MonthlyBudget.find_by_user_id(@activity.user_id)
        if !@mon.nil?
          #update balance amount to monthly budget table
          @monthly = @mon["monthly_budget"]
          @attempt = @mon["attempt_amount"].to_i + @mon["bid_amount"].to_i
          if @monthly.to_i >= @attempt.to_i
            @mon.update_attributes(:attempt_amount => @attempt)
          end
          #if click amount reached to  monthly amount send notification to provider
          if !@monthly.nil? && !@attempt.nil?
            if @monthly.to_i == @attempt.to_i
              @user = User.find_by_user_id(@activity.user_id)
              if !@user.nil? && @user!='' && @user.present? && @user.user_flag==TRUE
                #UserMailer.delay(queue: "Monthly Budget", priority: 2, run_at: 10.seconds.from_now).monthly_budget_provider(@user)
              end
            end
          end
          @add_click = ActivityClick.new
          @add_click.activity_id = params[:det]
          @add_click.device_id = ip_address
          @add_click.no_of_attempts =  1
          @add_click.click_amount = @mon.bid_amount
          @add_click.no_of_clicks = 1
          @add_click.user_type = user_add
          @add_click.click_date = Time.now
          @add_click.inserted_date = Time.now
          @add_click.user_id = @activity.user_id
          @add_click.save
        end
      end
    end
    @event_page=params[:list_details]
    @provider_mode=params[:provider_mode]
    @free_page=params[:getinfo]
    @contact_pro=params[:contact_provider]
    #render :partial => 'activity_detail'
  end
  
  #changed activity_detail_iframe to activities SEO

  def activities
    #~ @act_id = params[:act_view]
    #~ @mode = params[:det].split('/')[2] if !params[:det].nil? 
    # SEO 301 redirections starts
    if request.fullpath.include?("/activities")
      @act_id =params[:det]
    else
      @act_id = params[:det].split('-')[0] if params[:det] && !params[:det].nil? && params[:det].present?
    end
    @activity = Activity.find(@act_id) if @act_id && !@act_id.nil? && @act_id.present?
    @user_profile = UserProfile.where("user_id = #{@activity.user_id}").last
    @bus_name = @user_profile.slug
    @city = params[:city]
    @categ = params[:category]
    @sub_categ = params[:sub_category]
    cat=@activity.category
    sub_cat=@activity.sub_category
    if params[:mode] && params[:city] && params[:category] && params[:sub_category] && params[:det]
      redirect_to "/#{@city}-ca/#{@bus_name}/#{@categ}/#{@sub_categ}/#{@activity.slug}", :status=> 301
    elsif params[:city] && params[:det]
      redirect_to "/#{@city}-ca/#{@bus_name}/#{cat}/#{sub_cat}/#{@activity.slug}", :status=> 301
    end
    # end
    @mode = "parent"
    @mode_act = params[:act]
    @get_current_url = request.env['HTTP_HOST']
    if params[:act]
	    @act_id= params[:det] if params[:det] && !params[:det].nil? && params[:det].present?
	    @activity = Activity.find(@act_id) if @act_id && !@act_id.nil? && @act_id.present?
    else
	    @act_id= params[:det] if params[:det] && !params[:det].nil? && params[:det].present?
	    @activity = Activity.find_by_slug(@act_id) if @act_id && !@act_id.nil? && @act_id.present?
    end

    #~ @country_code = Country.where("country_id = ?",1)
    if @activity && !@activity.user_id.nil? && !current_user.nil? && !current_user.user_id.nil? && @activity.user_id == current_user.user_id
      @act_schedules = @activity.activity_schedule
    else
      @act_schedules = @activity.activity_schedule.where("expiration_date >= ?",Date.today)  if @activity && !@activity.nil?
    end
    
    #To store views count in activity count table
    ActivityCount.updateViewCount(@activity.activity_id) if !@activity.nil? && @activity!=''
    
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    if params[:click]=="clicked"
      ip_address = request.ip
      user_add = "anonymous"
      user_add = current_user.email_address if !current_user.nil?
      @click = ActivityClick.where("activity_id=#{@activity.activity_id} and device_id='#{ip_address}' and click_date='#{Date.today}' and user_type='#{user_add}'").last  if @activity && !@activity.nil?
      unless @click.nil?
        @click_count = @click.no_of_clicks
        count = @click_count.to_i + 1
        @update = @click.update_attributes(:no_of_attempts => count,:user_type =>user_add)
      else
        sdate = Time.now.beginning_of_month.strftime("%Y-%m-%d")
        edate = Time.now.end_of_month.strftime("%Y-%m-%d")
        @mon = MonthlyBudget.where("user_id=#{@activity.user_id} and bid_start_date='#{sdate}' and bid_end_date='#{edate}'").last if @activity && !@activity.nil?
        #@mon = MonthlyBudget.find_by_user_id(@activity.user_id)
        if !@mon.nil?
          #update balance amount to monthly budget table
          @monthly = @mon["monthly_budget"]
          @attempt = @mon["attempt_amount"].to_i + @mon["bid_amount"].to_i
          if @monthly.to_i >= @attempt.to_i
            @mon.update_attributes(:attempt_amount => @attempt)
          end
          #if click amount reached to  monthly amount send notification to provider
          if !@monthly.nil? && !@attempt.nil?
            if @monthly.to_i == @attempt.to_i
              @user = User.find_by_user_id(@activity.user_id)
              if !@user.nil? && @user!='' && @user.present? && @user.user_flag==TRUE
                #UserMailer.delay(queue: "Monthly Budget", priority: 2, run_at: 10.seconds.from_now).monthly_budget_provider(@user)
              end
            end
          end
          @add_click = ActivityClick.new
          @add_click.activity_id = @activity.activity_id if @activity
          @add_click.device_id = ip_address
          @add_click.no_of_attempts =  1
          @add_click.click_amount = @mon.bid_amount
          @add_click.no_of_clicks = 1
          @add_click.user_type = user_add
          @add_click.click_date = Time.now
          @add_click.inserted_date = Time.now
          @add_click.user_id = @activity.user_id
          @add_click.save
        end
      end
    end
    @event_page=params[:list_details]
    @provider_mode=params[:provider_mode]
    @free_page=params[:getinfo]
    @contact_pro=params[:contact_provider]
    #render :partial => 'activity_detail'
  end

#~ def activity_detail_iframe
	#~ @det = params[:det].split('/') if params[:det] && params[:det]!=''
	#~ redirect_to "/activities/#{@det[0]}-#{@det[5]}/#{@det[1]}/#{@det[2]}/#{@det[3]}/#{@det[4]}"
#~ end
 #old activity detail iframe
def activity_detail_iframe
	if params[:act] && params[:act]!=''
		@det = params[:det] if params[:det] && params[:det]!=''
	else
		@det = params[:det].split('/') if params[:det] && params[:det]!=''
       end
       if params[:act] && params[:det] && params[:mode]
	        redirect_to "/activity_share/#{params[:det]}/#{ params[:mode]}/#{params[:act]}"  
      elsif @det && @det[2] == "parent"
           @mode="p"
	    redirect_to "/activities/#{@mode}/#{@det[1]}/#{@det[3]}/#{@det[4]}/#{@det[0]}-#{@det[5]}", :status=> 301
       elsif @det && @det[2] == "provider"
           @mode="pr"
	    redirect_to "/activities/#{@mode}/#{@det[1]}/#{@det[3]}/#{@det[4]}/#{@det[0]}-#{@det[5]}", :status=> 301
       end
       #~ @det = params[:det].split('/') if params[:det] && params[:det]!=''
       #~ if @det && @det[2] == "parent"
           #~ @mode="p"
       #~ elsif @det && @det[2] == "provider"
           #~ @mode="pr"
       #~ end
       #~ redirect_to "/activities/#{@mode}/#{@det[1]}/#{@det[3]}/#{@det[4]}/#{@det[0]}-#{@det[5]}", :status=> 301
end  
  
  def activity_detail_old
    @before_login_value = params[:before_login_value] if !params[:before_login_value].nil? && params[:before_login_value].present?
    @get_current_url = request.env['HTTP_HOST']
    @activity = Activity.find(params[:det])
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    if params[:click]=="clicked"
      ip_address = request.ip
      user_add = "anonymous"
      user_add = current_user.email_address if !current_user.nil?
      @click = ActivityClick.where("activity_id=#{params[:det]} and device_id='#{ip_address}' and click_date='#{Date.today}' and user_type='#{user_add}'").last
      unless @click.nil?
        @click_count = @click.no_of_clicks
        count = @click_count.to_i + 1
        @update = @click.update_attributes(:no_of_attempts => count,:user_type =>user_add)
      else
        sdate = Time.now.beginning_of_month.strftime("%Y-%m-%d")
        edate = Time.now.end_of_month.strftime("%Y-%m-%d")
        @mon = MonthlyBudget.where("user_id=#{@activity.user_id} and bid_start_date='#{sdate}' and bid_end_date='#{edate}'").last
        #@mon = MonthlyBudget.find_by_user_id(@activity.user_id)
        if !@mon.nil?
          #update balance amount to monthly budget table
          @monthly = @mon["monthly_budget"]
          @attempt = @mon["attempt_amount"].to_i + @mon["bid_amount"].to_i
          if @monthly.to_i >= @attempt.to_i
            @mon.update_attributes(:attempt_amount => @attempt)
          end
          #if click amount reached to  monthly amount send notification to provider
          if !@monthly.nil? && !@attempt.nil?
            if @monthly.to_i == @attempt.to_i
              @user = User.find_by_user_id(@activity.user_id)
              if !@user.nil? && @user!='' && @user.present? && @user.user_flag==TRUE
                #UserMailer.delay(queue: "Monthly Budget", priority: 2, run_at: 10.seconds.from_now).monthly_budget_provider(@user)
              end
            end
          end
          @add_click = ActivityClick.new
          @add_click.activity_id = params[:det]
          @add_click.device_id = ip_address
          @add_click.no_of_attempts =  1
          @add_click.click_amount = @mon.bid_amount
          @add_click.no_of_clicks = 1
          @add_click.user_type = user_add
          @add_click.click_date = Time.now
          @add_click.inserted_date = Time.now
          @add_click.user_id = @activity.user_id
          @add_click.save
        end
      end
    end
    @event_page=params[:list_details]
    @provider_mode=params[:provider_mode]
    @free_page=params[:getinfo]
    @contact_pro=params[:contact_provider]
    render :partial => 'activity_detail'
	  
  end

  #~ def activity_detail_if
  def activitydetail_new
    #~ @act_id = params[:act_view]
    @before_login_value = params[:before_login_value] if !params[:before_login_value].nil? && params[:before_login_value].present?
    @get_current_url = request.env['HTTP_HOST']
     if params[:act]
	    @act_id= params[:det]
	    @activity = Activity.find(@act_id)
    else
	    @act_id= params[:det].split('-')[0]
	    @activity = Activity.find(@act_id)
    end
    #~ @activity = Activity.find(params[:det])
    @mode = params[:mode]
    #~ @country_code = Country.where("country_id = ?",1)
    @form_present = ActivityForm.where("activity_id=? and active_status=?",@activity.activity_id,true).map(&:form_id).present?
    if @activity && !@activity.user_id.nil? && !current_user.nil? && !current_user.user_id.nil? && @activity.user_id == current_user.user_id && @mode=='provider'
      @act_schedules = @activity.activity_schedule
    else
      @act_schedules = @activity.activity_schedule.where("expiration_date >= ?",Date.today)
    end

    #To store views count in activity count table
    ActivityCount.updateViewCount(@act_id) if !@act_id.nil? && @act_id!=''
    
    @set_color = params[:set_color]
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    if params[:click]=="clicked"
      ip_address = request.ip
      user_add = "anonymous"
      user_add = current_user.email_address if !current_user.nil?
      @click = ActivityClick.where("activity_id=#{@act_id} and device_id='#{ip_address}' and click_date='#{Date.today}' and user_type='#{user_add}'").last
      unless @click.nil?
        @click_count = @click.no_of_clicks
        count = @click_count.to_i + 1
        @update = @click.update_attributes(:no_of_attempts => count,:user_type =>user_add)
      else
        sdate = Time.now.beginning_of_month.strftime("%Y-%m-%d")
        edate = Time.now.end_of_month.strftime("%Y-%m-%d")
        @mon = MonthlyBudget.where("user_id=#{@activity.user_id} and bid_start_date='#{sdate}' and bid_end_date='#{edate}'").last
        #@mon = MonthlyBudget.find_by_user_id(@activity.user_id)
        if !@mon.nil?
          #update balance amount to monthly budget table
          @monthly = @mon["monthly_budget"]
          @attempt = @mon["attempt_amount"].to_i + @mon["bid_amount"].to_i
          if @monthly.to_i >= @attempt.to_i
            @mon.update_attributes(:attempt_amount => @attempt)
          end
          #if click amount reached to  monthly amount send notification to provider
          if !@monthly.nil? && !@attempt.nil?
            if @monthly.to_i == @attempt.to_i
              @user = User.find_by_user_id(@activity.user_id)
              if !@user.nil? && @user!='' && @user.present? && @user.user_flag==TRUE
                #UserMailer.delay(queue: "Monthly Budget", priority: 2, run_at: 10.seconds.from_now).monthly_budget_provider(@user)
              end
            end
          end
          @add_click = ActivityClick.new
          @add_click.activity_id = @act_id
          @add_click.device_id = ip_address
          @add_click.no_of_attempts =  1
          @add_click.click_amount = @mon.bid_amount
          @add_click.no_of_clicks = 1
          @add_click.user_type = user_add
          @add_click.click_date = Time.now
          @add_click.inserted_date = Time.now
          @add_click.user_id = @activity.user_id
          @add_click.save
        end
      end
    end
    
    @event_page=params[:list_details]
    @provider_mode=params[:provider_mode]
    @free_page=params[:getinfo]
    @contact_pro=params[:contact_provider]
    render :partial => 'activitydetail_new'

end

#New Activity Page PJAX by sindhu
 def activitydetailpage_jax
    @get_current_url = request.env['HTTP_HOST']
     @act_id= params[:det]
  #  @act_name = params[:act_name]
    @activity = Activity.where("ACTIVITY_ID=?",@act_id).last
    @act_id=@activity.activity_id if !@activity.nil?
    @mode = params[:mode]
    @mode = 'parent'
    @form_present = ActivityForm.where("activity_id=? and active_status=?",@activity.activity_id,true).map(&:form_id).present?  if !@activity.nil?
    if @activity && !@activity.user_id.nil? && !current_user.nil? && !current_user.user_id.nil? && @activity.user_id == current_user.user_id && @mode=='provider'
      @act_schedules = @activity.activity_schedule
    else
      @act_schedules = @activity.activity_schedule.where("expiration_date >= ?",Date.today)
    end
    @activity_usr = User.find_by_user_id(@activity.user_id) if !@activity.nil?
	if !@activity_usr.nil? && !@activity_usr.user_profile.nil? && !@activity_usr.user_profile.business_name.nil? && @activity_usr.user_type=="P"
	  @usr_name = @activity_usr.user_profile.business_name
	else
	  @usr_name = @activity_usr.user_name
	end
    
    #To store views count in activity count table
    ActivityCount.updateViewCount(@act_id) if !@act_id.nil? && @act_id!=''
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    @event_page=params[:list_details]
    @provider_mode=params[:provider_mode]
    @free_page=params[:getinfo]
    @contact_pro=params[:contact_provider]
	if request.headers['X-PJAX']
		render :layout => false
	end
  end



  def edit_activity
    @activity = Activity.find(params[:activity_id])
    #@cities = ["Chicago","Dallas","Detroit","Houston","Las Vegas","Los Angeles","New York","Philadelphia","San Antonio","San Francisco","San Jose","Seattle","Walnut Creek"]
    @cities = City.order("city_name Asc").all.map(&:city_name)
    @schedule = @activity.activity_schedule
    @act_repeat =  ActivityRepeat.find_by_activity_schedule_id(@schedule.last.schedule_id) if !@schedule.last.nil?
  end

  def provider_edit_activity
    @save_copy=params[:s_copy] if !params[:s_copy].nil?
    @edited_from = params[:edit_from]
    @color_val = params[:set_color]
    @activity = Activity.find(params[:activity_id])
    #@cities = ["Chicago","Dallas","Detroit","Houston","Las Vegas","Los Angeles","New York","Philadelphia","San Antonio","San Francisco","San Jose","Seattle","Walnut Creek"]
    @page = params[:page]
    @cities = City.order("city_name Asc").all.map(&:city_name)
    @schedule = @activity.activity_schedule
    @act_repeat =  ActivityRepeat.find_by_activity_schedule_id(@schedule.last.schedule_id) if !@schedule.last.nil?
    @pro_fees = ProviderActivityFeeType.where("user_id=#{current_user.user_id}")
    @pro_discount_fees = ProviderDiscountCodeType.where("user_id=#{current_user.user_id}")
    @pro_sel_fees = ProviderActivityFee.where("activity_id=#{params[:activity_id]} and user_id=#{current_user.user_id}").map(&:fee_type_id)
    @pro_sel_discount_fees = ProviderDiscountCode.where("activity_id=#{params[:activity_id]} and user_id=#{current_user.user_id}").map(&:discount_code_id)
    @provid_disc_types = ProviderDiscountType.where("user_id=#{current_user.user_id} or user_id is null")
    @tags_text = @activity.tags_txt.split(",") if !@activity.tags_txt.nil?
    @previous_tags = Activity.where(:created_by => "Provider", :cleaned => true, :user_id => current_user.user_id).map {|activity| activity.tags_txt.split(",") if !activity.nil? && !activity.tags_txt.nil? }.compact.flatten.uniq
    #~ @country_code = Country.where("country_id = ?",1)
  end
  
  def edit_activity_parent
    @activity = Activity.find(params[:activity_id])
    #@cities = ["Chicago","Dallas","Detroit","Houston","Las Vegas","Los Angeles","New York","Philadelphia","San Antonio","San Francisco","San Jose","Seattle","Walnut Creek"]
    @cities = City.order("city_name Asc").all.map(&:city_name)
    @schedule = @activity.activity_schedule
    @act_repeat =  ActivityRepeat.find_by_activity_schedule_id(@schedule.last.schedule_id) if !@schedule.last.nil?
  end

  def create_thank

  end


  def edit_acitivity_thank

  end
  
  def parent_acitivity_thank
    
  end



  def schedule_price
    @activity = Activity.find(params[:activity_id])
  end
  

  def ticket
    
  end

  def share_activity
    @before_login_value = params[:before_login_value] if !params[:before_login_value].nil? && params[:before_login_value].present?
    @action = params[:act]
    @activity = Activity.find(params[:activity_id])
    @user_email = ContactUser.find_all_by_user_id(current_user.user_id).uniq.map(&:contact_email) if current_user.present?
  end



  def share_activity_success
    @action = params[:act]
    @subject=params[:subject]
    @activity=params[:activity_id]
    @user = current_user
    @mode = params[:mode]

    @activity = Activity.find_by_activity_id(params[:activity_id])
    
    #To store the share count
    ActivityCount.updateShareCount(params[:activity_id])

    @get_current_url = request.env['HTTP_HOST']
    t=params[:message].gsub("\r\n", "<br>")
    send = params[:send_to].split(',')
    send.each do|s|
      if !s.nil? && s!="" && !s.blank?
        user = User.find_by_email_address(s)
        if !user.nil?
          attend_email=user.email_address
          if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
            @result = UserMailer.delay(queue: "Shared Activity", priority: 2, run_at: 10.seconds.from_now).share_activity_mail(@user,@activity,@get_current_url,t,s,params[:subject],@mode)
            #@result = UserMailer.share_activity_mail(@user,@activity,@get_current_url,params[:message],s,params[:subject]).deliver
          end
        else
          @result = UserMailer.delay(queue: "Shared Activity", priority: 2, run_at: 10.seconds.from_now).share_activity_mail(@user,@activity,@get_current_url,t,s,params[:subject],@mode)
          #@result = UserMailer.share_activity_mail(@user,@activity,@get_current_url,params[:message],s,params[:subject]).deliver
        end
        @old_user_id = user.user_id if !user.nil?
        @share=@activity.activity_shared.new(:message=>t,:user_id=>current_user.user_id,:shared_to=>s,:subject=>params[:subject],:inserted_date=>Time.now)
        @share.share_id = @old_user_id if !@old_user_id.nil?
        @share.save
      end
    end
    
    respond_to do |format|
      format.js
    end

  end


  def share_activity_thank

  end

  def share_activity_favthank

  end

  def embedded_link
    @activity = Activity.find(params[:activity_id])
    @act_id=params[:activity_id]
    @img_path = @activity.avatar.url(:thumb)
    @act_user = User.find_by_user_id(@activity.user_id) if @activity && @activity.present?
  end
  
  #provider embedded activity
  def provider_embedded_link
    @activity = Activity.find_by_sql("select * from activities where user_id=#{current_user.user_id} and cleaned=true and lower(active_status)='active' and lower(created_by)='provider' order by activity_id desc limit 200") if !current_user.nil? && current_user.present?
    @act_id=@activity.map(&:activity_id) if !@activity.nil?
    #~ @img_path = @activity.avatar.url(:thumb)
  end
  
  #find_us_on_famtivity
  def find_us_on_famtivity_popup
    @get_current_url = request.env['HTTP_HOST']
  end
  
  #provider embedded activity
  def embed_popup
    arr = []
    @embed_user=params[:pu] if !params[:pu].nil? && params[:pu] !=""
    @embed_act_id=params[:activity] if !params[:activity].nil? && params[:activity] !=""
    #~ get_total_feature_list(arr)
    get_total_feature_list(arr,params[:pu])
    featured = arr.uniq{|x| x[:id]}
    if featured.length !=0 && featured.length <8
      cookies[:feature_page] = 1 + cookies[:feature_page].to_i
      #~ get_total_feature_list(arr)
      get_total_feature_list(arr,params[:pu])
    end
    @activity_featured = arr.uniq{|x| x[:id]}
    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT trim(category) as category",:conditions=>["lower(category)!=?",'default'])
  end
    
  def preview_embed_popup
    embed_popup
  end

  def get_total_feature_list(arr,user_id)
    #featured = Activity.where("lower(active_status)='active' and featured_flag =true and cleaned=true and lower(created_by)='provider'").order("activity_id DESC").uniq
    #featured =Activity.find_by_sql("select act.* from activities act left join users u on act.user_id=u.user_id where lower(u.user_plan)='sell' and lower(active_status)='active' and cleaned=true and lower(created_by)='provider' order by activity_id desc")
    #~ featured = Activity.find_by_sql("select * from activities where user_id=#{user_id} and cleaned=true and lower(active_status)='active' and lower(created_by)='provider' order by activity_id desc limit 200") if !user_id.nil? && user_id.present?
    featured = Activity.joins(:user,:activity_schedule).where("activities.user_id=#{user_id} and lower(active_status)='active' and cleaned=true and lower(created_by)='provider' and expiration_date >= '#{Date.today}'").order("activity_id DESC") if user_id && user_id.present?
    featured.each do |actv|
      @schedule = ActivitySchedule.where("activity_id = ?",actv.activity_id).last
      #~ Activity.schedule_feature_list(session[:date],event,arr) if !event.nil?
      arr << {:discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>actv, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id,:slug=>actv.slug}
    end if !featured.nil? && featured.length > 0
    return arr
  end
  
  def activity_email_link
    @activity = Activity.find(params[:activity_id])
  end
 
  def provider_edit_old
    @set_color = params[:color_val]
    @edited_page = params[:edited_page]
    @activity_profile_apf = Activity.find(params[:save_id])
    @activity_profile_apf.description = params[:description] if params[:description] !="Description should not exceed 500 characters"
    @activity_profile_apf.contact_price = params[:con_provider]
 
    if params[:discountElligble]=='on'
      @activity_profile_apf.discount_eligible = params[:ddligprice] if !params[:ddligprice].nil? && params[:ddligprice].present? && params[:ddligprice]!='Eg: 3'
      @activity_profile_apf.discount_type = params[:ddselect] if !params[:ddselect].nil? && params[:ddselect].present?
    else
      @activity_profile_apf.discount_eligible=nil
      @activity_profile_apf.discount_type=nil
    end
    @page = params[:page]
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    no_participants =""
    leader = ""
    website = ""
    email =""
    address_2 =""
    cookies[:last_action] = params[:last_action]
    cookies[:page] = params[:page]
    cookies[:pro_id] = params[:cat]
    cookies[:cat_zc] = params[:cat_zc]
    leader = params[:leader] if params[:leader] != "Enter Leader Name"
    website = params[:website] if params[:website] != "Enter URL"
    email = params[:email]  if params[:email] != "Enter Email"
    phone = "#{params[:phone_1]}-" + "#{params[:phone_2]}-" + "#{params[:phone_3]}" if !params[:phone_1].nil?
    @activity_profile_apf.gender = params[:gender] if !params[:gender].nil? && params[:gender] != "--Select Gender--"
    skill_level = params[:skill_level] if params[:skill_level] != "--Select--"
    no_participants = params[:no_participants] if params[:no_participants] != "Specify Number"
    address_2  =  params[:address_2] if params[:address_2] != "Address Line 2"
    @activity_profile_apf.leader = leader
    @activity_profile_apf.state = params[:state]
    @activity_profile_apf.website = website
    @activity_profile_apf.email = email
    @activity_profile_apf.phone = phone
    @activity_profile_apf.skill_level = skill_level
    @activity_profile_apf.no_participants = no_participants
    @activity_profile_apf.address_2 = address_2
    @activity_profile_apf.modified_date = Time.now
    @activity_profile_apf.note = params[:notes]
    @activity_profile_apf.min_age_range = params[:age1]
    @activity_profile_apf.max_age_range = params[:age2]
    if !params[:photo].nil? && params[:photo]!=""
      @activity_profile_apf.avatar = params[:photo]
    end
    #    @user = User.find(cookies[:uid_usr])
    @activity_profile_apf.filter_id = 5
    @activity_old =  @activity_profile_apf.clone
    if @activity_old.schedule_mode != params[:activity][:schedule_mode]
      if !@activity_profile_apf.activity_schedule.nil? && !@activity_profile_apf.activity_schedule.empty?
        @del_pre = ActivityRepeat.find_by_activity_schedule_id(@activity_profile_apf.activity_schedule.last.schedule_id)
        @activity_sc = ActivityRepeat.delete_all(["activity_schedule_id = ? ",  @activity_profile_apf.activity_schedule.last.schedule_id])
        @activity_delete = ActivitySchedule.delete_all(["activity_id = ? ", params[:save_id]])
      end
      if params[:activity][:schedule_mode] == "Schedule"
        @date_split = params[:date_total].split(',') if !params[:date_total].nil?
        @date_split.each do |s|
          st_time = DateTime.parse("#{params[:schedule_stime_1]} #{params[:schedule_stime_2]}").strftime("%H:%M:%S") if !params[:schedule_stime_1].nil? && !params[:schedule_stime_2].nil? && params[:schedule_stime_1]!="" && params[:schedule_stime_2]!=""
          en_time = DateTime.parse("#{params[:schedule_etime_1]} #{params[:schedule_etime_2]}").strftime("%H:%M:%S") if !params[:schedule_etime_1].nil? && !params[:schedule_etime_2].nil? && params[:schedule_etime_1]!="" && params[:schedule_etime_2]!=""
          @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:date_1],
            :end_date=>params[:date_2],:start_time=>st_time,:end_time=>en_time)
          if params[:repeatCheck]=="yes"
            @schedule.activity_repeat.create(:repeat_every => params[:repeatNumWeekVal],
              :ends_never=>params[:r1],:end_occurences=>params[:after_occ],
              :ends_on=>params[:repeat_on_date1],:starts_on=>params[:date_1],:repeat_on=>params[:repeat_no_of_days],:repeated_by_month=>params[:month1],:repeats=>params[:repeatWeekVal])
          end
        end
      end
      if params[:activity][:schedule_mode] == "By Appointment"
        st_time = DateTime.parse("#{params[:appointment_stime_1]} #{params[:appointment_stime_2]}").strftime("%H:%M:%S") if !params[:appointment_stime_1].nil? && !params[:appointment_stime_2].nil? && params[:appointment_stime_1]!="" && !params[:appointment_stime_2]!=""
        en_time = DateTime.parse("#{params[:appointment_etime_1]} #{params[:appointment_etime_2]}").strftime("%H:%M:%S") if !params[:appointment_etime_1].nil? && !params[:appointment_etime_2].nil? && params[:appointment_etime_1]!="" && !params[:appointment_etime_2]!=""
        @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:datebill_1],
          :end_date=>"",:start_time=>st_time,:end_time=>en_time)
      end
      if params[:activity][:schedule_mode] == "Any Time"
        re = ['mon','tue','wed','thu','fri','sat','sun'].to_a
        re.each do |s|
          if params[:"anytime_closed_#{s}"] !="0"
            st_time = DateTime.parse("#{params[:"anytime_s#{s}_1"]} #{params[:"anytime_s#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_s#{s}_1"].nil? && !params[:"anytime_s#{s}_2"].nil? && params[:"anytime_s#{s}_1"]!="" && params[:"anytime_s#{s}_2"]!=""
            en_time = DateTime.parse("#{params[:"anytime_e#{s}_1"]} #{params[:"anytime_e#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_e#{s}_1"].nil? && !params[:"anytime_e#{s}_2"].nil? && params[:"anytime_e#{s}_1"]!="" && params[:"anytime_e#{s}_2"]!=""
            @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>"",
              :end_date=>"",:start_time=>st_time,:end_time=>en_time,:business_hours=>"#{s}")
          end
        end
      end
      if params[:activity][:schedule_mode] == "Camps/Workshop" || params[:activity][:schedule_mode] == "Whole Day"
        if params[:wday_1] =="1"
          st_time = DateTime.parse("#{params[:whole_stime_1]} #{params[:whole_stime_2]}").strftime("%H:%M:%S") if !params[:whole_stime_1].nil? && !params[:whole_stime_1].nil? && params[:whole_stime_1]!="" && params[:whole_stime_1]!=""
          en_time = DateTime.parse("#{params[:whole_etime_1]} #{params[:whole_etime_2]}").strftime("%H:%M:%S") if !params[:whole_etime_1].nil? && !params[:whole_etime_2].nil? && params[:whole_etime_1]!="" && params[:whole_etime_2]!=""
          @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:datestartwhole_alt_1],
            :end_date=>"",:start_time=>st_time,:end_time=>en_time)
        end
        if params[:wday_2] =="1"
          st_time = DateTime.parse("#{params[:camps_stime_1]} #{params[:whole_stime_2]}").strftime("%H:%M:%S") if !params[:camps_stime_1].nil? && !params[:camps_stime_1].nil? && params[:camps_stime_1]!="" && params[:camps_stime_1]!=""
          en_time = DateTime.parse("#{params[:camps_etime_1]} #{params[:camps_etime_2]}").strftime("%H:%M:%S") if !params[:camps_etime_1].nil? && !params[:camps_etime_2].nil? && params[:camps_etime_1]!="" && params[:camps_etime_2]!=""
          @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:datestcamps_1],
            :end_date=>params[:dateencamps_2],:start_time=>st_time,:end_time=>en_time)
        end
      end
    else
      if params[:activity][:schedule_mode] == "Schedule"
        if !params[:schedule_id_value].nil? && params[:schedule_id_value]!=""
          @act_schedule = ActivitySchedule.find(params[:schedule_id_value])
          st_time = DateTime.parse("#{params[:schedule_stime_1]} #{params[:schedule_stime_2]}").strftime("%H:%M:%S") if !params[:schedule_stime_1].nil? && !params[:schedule_stime_2].nil? && params[:schedule_stime_1]!="" && params[:schedule_stime_2]!=""
          en_time = DateTime.parse("#{params[:schedule_etime_1]} #{params[:schedule_etime_2]}").strftime("%H:%M:%S") if !params[:schedule_etime_1].nil? && !params[:schedule_etime_2].nil? && params[:schedule_etime_1]!="" && params[:schedule_etime_2]!=""
          @act_schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:date_1],
            :end_date=>params[:date_2],:start_time=>st_time,:end_time=>en_time)
          if params[:repeatCheck]=="yes"
            @activity_repeat = ActivityRepeat.find_by_activity_schedule_id(@act_schedule.schedule_id)
            if !@activity_repeat.nil?
              @activity_repeat.repeat_every = params[:repeatNumWeekVal]
              @activity_repeat.ends_never= params[:r1]
              @activity_repeat.end_occurences= params[:after_occ]
              @activity_repeat.ends_on= params[:repeat_alt_on_date1]
              @activity_repeat.starts_on=params[:date_1]
              @activity_repeat.repeat_on= params[:repeat_no_of_days]
              @activity_repeat.repeats= params[:repeatWeekVal]
              @activity_repeat.repeated_by_month = params[:month1]
              @activity_repeat.save
            else
              @act_schedule.activity_repeat.create(:repeat_every => params[:repeatNumWeekVal],
                :ends_never=>params[:r1],:end_occurences=>params[:after_occ],
                :ends_on=>params[:repeat_on_date1],:starts_on=>params[:date_1],:repeated_by_month=>params[:month1],:repeat_on=>params[:repeat_no_of_days],:repeats=>params[:repeatWeekVal])
            end
          else
            @activity_sc = ActivityRepeat.delete_all(["activity_schedule_id = ? ",  @act_schedule.schedule_id])
          end
        end
      end
      if params[:activity][:schedule_mode] == "By Appointment"
        if !params[:schedule_id_value].nil? && params[:schedule_id_value]!=""
          @act_schedule = ActivitySchedule.find(params[:schedule_id_value])
          #        Time.parse("9:03 pm").strftime("%H:%M:%S")
          st_time = DateTime.parse("#{params[:appointment_stime_1]} #{params[:appointment_stime_2]}").strftime("%H:%M:%S") if !params[:appointment_stime_1].nil? && !params[:appointment_stime_2].nil? && params[:appointment_stime_1]!="" && params[:appointment_stime_2]!=""
          en_time = DateTime.parse("#{params[:appointment_etime_1]} #{params[:appointment_etime_2]}").strftime("%H:%M:%S") if !params[:appointment_etime_1].nil? && !params[:appointment_etime_2].nil? && params[:appointment_etime_1]!="" && params[:appointment_etime_2]!=""
          @act_schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:datebill_1],
            :end_date=>"",:start_time=>st_time,:end_time=>en_time)
        end
      end
      if params[:activity][:schedule_mode] == "Camps/Workshop" || params[:activity][:schedule_mode] == "Whole Day"
        if !params[:schedule_id_value].nil? && params[:schedule_id_value]!=""
          @act_schedule = ActivitySchedule.find(params[:schedule_id_value])
          if params[:wday_1] =="1"
            st_time = DateTime.parse("#{params[:whole_stime_1]} #{params[:whole_stime_2]}").strftime("%H:%M:%S") if !params[:whole_stime_1].nil? && !params[:whole_stime_1].nil? && params[:whole_stime_1]!="" && params[:whole_stime_1]!=""
            en_time = DateTime.parse("#{params[:whole_etime_1]} #{params[:whole_etime_2]}").strftime("%H:%M:%S") if !params[:whole_etime_1].nil? && !params[:whole_etime_2].nil? && params[:whole_etime_1]!="" && params[:whole_etime_2]!=""
            @act_schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:datestartwhole_alt_1],
              :end_date=>"",:start_time=>st_time,:end_time=>en_time)
          end
          if params[:wday_2] =="1"
            st_time = DateTime.parse("#{params[:camps_stime_1]} #{params[:camps_stime_2]}").strftime("%H:%M:%S") if !params[:camps_stime_1].nil? && !params[:camps_stime_1].nil? && params[:camps_stime_1]!="" && params[:camps_stime_1]!=""
            en_time = DateTime.parse("#{params[:camps_etime_1]} #{params[:camps_etime_2]}").strftime("%H:%M:%S") if !params[:camps_etime_1].nil? && !params[:camps_etime_2].nil? && params[:camps_etime_1]!="" && params[:camps_etime_2]!=""
            @act_schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:datestcamps_1],
              :end_date=>params[:dateencamps_2],:start_time=>st_time,:end_time=>en_time)
          end
        else
          if params[:wday_1] =="1"
            st_time = DateTime.parse("#{params[:whole_stime_1]} #{params[:whole_stime_2]}").strftime("%H:%M:%S") if !params[:whole_stime_1].nil? && !params[:whole_stime_1].nil? && params[:whole_stime_1]!="" && params[:whole_stime_1]!=""
            en_time = DateTime.parse("#{params[:whole_etime_1]} #{params[:whole_etime_2]}").strftime("%H:%M:%S") if !params[:whole_etime_1].nil? && !params[:whole_etime_2].nil? && params[:whole_etime_1]!="" && params[:whole_etime_2]!=""
            @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:datestartwhole_alt_1],
              :end_date=>"",:start_time=>st_time,:end_time=>en_time)
          end
          if params[:wday_2] =="1"
            st_time = DateTime.parse("#{params[:camps_stime_1]} #{params[:whole_stime_2]}").strftime("%H:%M:%S") if !params[:camps_stime_1].nil? && !params[:camps_stime_1].nil? && params[:camps_stime_1]!="" && params[:camps_stime_1]!=""
            en_time = DateTime.parse("#{params[:camps_etime_1]} #{params[:camps_etime_2]}").strftime("%H:%M:%S") if !params[:camps_etime_1].nil? && !params[:camps_etime_2].nil? && params[:camps_etime_1]!="" && params[:camps_etime_2]!=""
            @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:datestcamps_1],
              :end_date=>params[:dateencamps_2],:start_time=>st_time,:end_time=>en_time)
          end
        end
      end
      if params[:activity][:schedule_mode] == "Any Time"

        raj = params[:schedule_id_value].split(",")
        @day_v = []
        @day_id = []
        re = ['mon','tue','wed','thu','fri','sat','sun'].to_a
        raj.each do |s|
          t =  s.gsub("[","").gsub("]","")
          @act_schedule = ActivitySchedule.find(t)
          @day_v << @act_schedule.business_hours
        end
        re.each do |s|

          if @day_v.include?(s)
            if params[:"anytime_closed_#{s}"] !="0"
              st_time = DateTime.parse("#{params[:"anytime_s#{s}_1"]} #{params[:"anytime_s#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_s#{s}_1"].nil? && !params[:"anytime_s#{s}_2"].nil? && params[:"anytime_s#{s}_1"]!="" && params[:"anytime_s#{s}_2"]!=""
              en_time = DateTime.parse("#{params[:"anytime_e#{s}_1"]} #{params[:"anytime_e#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_e#{s}_1"].nil? && !params[:"anytime_e#{s}_2"].nil? && params[:"anytime_e#{s}_1"]!="" && params[:"anytime_e#{s}_2"]!=""
              not_value = @day_v.index(s)
              t = raj[not_value].gsub("[","").gsub("]","")
              act_schedule = ActivitySchedule.find(t)
              act_schedule.update_attributes(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>"",
                :end_date=>"",:start_time=>st_time,:end_time=>en_time,:business_hours=>"#{s}")
            else
              not_value = @day_v.index(s)
              t = raj[not_value].gsub("[","").gsub("]","")
              act_schedule = ActivitySchedule.find(t)
              #              act_schedule = ActivitySchedule.find(raj[not_value])
              act_schedule.destroy
            end
          else
            if params[:"anytime_closed_#{s}"] !="0"
              st_time = DateTime.parse("#{params[:"anytime_s#{s}_1"]} #{params[:"anytime_s#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_s#{s}_1"].nil? && !params[:"anytime_s#{s}_2"].nil? && params[:"anytime_s#{s}_1"]!="" && params[:"anytime_s#{s}_2"]!=""
              en_time = DateTime.parse("#{params[:"anytime_e#{s}_1"]} #{params[:"anytime_e#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_e#{s}_1"].nil? && !params[:"anytime_e#{s}_2"].nil? && params[:"anytime_e#{s}_1"]!="" && params[:"anytime_e#{s}_2"]!=""
              @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>"",
                :end_date=>"",:start_time=>st_time,:end_time=>en_time,:business_hours=>"#{s}")
            end
          end
        end
      end
    end

    @activity_price_del = ActivityPrice.delete_all(["activity_id = ? ",  @activity_profile_apf.activity_id])
    if params[:price_1] == "1"
      @activity_profile_apf.price_type = 2
      @activity_profile_apf.price = params[:price]
      c="1"
      multi_discount = params[:"multiple_discount_count_net_#{c}_#{c}"].split(",")
      @ss = multi_discount.count

      if multi_discount.count > 0
        
        sh_activity=ActivitySchedule.where("activity_id=? AND schedule_mode!=?",params[:save_id],"Schedule").last
          if !sh_activity.nil? && sh_activity.present?
            @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:price],:activity_schedule_id=>sh_activity.schedule_id )
          else
            @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:price] )
          end
      end
      multi_discount.each do |t|
        discount_type = params[:"ad_discount_type_net_#{t}_#{c}"]
        if discount_type =="Early Bird Discount"
          discount_price = params[:"ad_discount_price_net_#{t}_#{c}"]
          discount_currency = params[:"ad_discount_price_type_net_#{t}_#{c}"]
          discount_validity = params[:"ad_valid_date_alt_net_#{t}_#{c}"]
          discount_number = params[:"ad_no_subs_net_#{t}_#{c}"]
        elsif discount_type =="Multiple Session Discount"
          discount_price = params[:"ad_discount_sess_price_net_#{t}_#{c}"]
          discount_currency = params[:"ad_discount_sess_price_type_net_#{t}_#{c}"]
          discount_validity = ""
          discount_number = params[:"ad_no_sess_net_#{t}_#{c}"]
        elsif discount_type =="Multiple Participant Discount"
          discount_price = params[:"ad_discount_part_price_net_#{t}_#{c}"]
          discount_currency = params[:"ad_discount_part_price_type_net_#{t}_#{c}"]
          discount_validity = ""
          discount_number = params[:"ad_no_part_net_#{t}_#{c}"]
        end
        @activity_price.activity_discount_price.create(:discount_type=>discount_type,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
          :discount_valid => discount_validity,:discount_number =>discount_number) if !discount_price.nil? && discount_price.present? && discount_price!=''
      end
    elsif params[:price_2] == "1"
      @activity_profile_apf.price_type = 1
      
      @activity_profile_apf.price = params[:price]
      price_count =  params[:advance_price_count].split(",").reject(&:empty?)
      price_count.each do |c|
        net_price =  params[:"ad_price_1_#{c}"]
        no_class = params[:"ad_payment_box_fst_1_#{c}"]
        payment_period = params[:"ad_payment_1_#{c}"]
        no_hours = params[:"ad_payment_box_sec_1_#{c}"] if params[:"ad_payment_box_sec_1_#{c}"]!="Eg: 3"
        sh_activity=ActivitySchedule.where("activity_id=? AND schedule_mode!=?",params[:save_id],"Schedule").last
          if !sh_activity.nil? && sh_activity.present?
            @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>sh_activity.schedule_id )
          else
           @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours )
          end
        multi_discount = params[:"multiple_discount_count_#{c}_#{c}"].split(",")
        multi_discount.each do |t|
          discount_type = params[:"ad_discount_type_#{t}_#{c}"]
          if discount_type =="Early Bird Discount"
            discount_price = params[:"ad_discount_price_#{t}_#{c}"]
            discount_currency = params[:"ad_discount_price_type_#{t}_#{c}"]
            discount_validity = params[:"ad_valid_date_alt_#{t}_#{c}"]
            discount_number = params[:"ad_no_subs_#{t}_#{c}"]
          elsif discount_type =="Multiple Session Discount"
            discount_price = params[:"ad_discount_sess_price_#{t}_#{c}"]
            discount_currency = params[:"ad_discount_sess_price_type_#{t}_#{c}"]
            discount_validity = ""
            discount_number = params[:"ad_no_sess_#{t}_#{c}"]
          elsif discount_type =="Multiple Participant Discount"
            discount_price = params[:"ad_discount_part_price_#{t}_#{c}"]
            discount_currency = params[:"ad_discount_part_price_type_#{t}_#{c}"]
            discount_validity = ""
            discount_number = params[:"ad_no_part_#{t}_#{c}"]
          end
          @activity_price.activity_discount_price.create(:discount_type=>discount_type,:discount_price=>discount_price,:discount_currency_type=>discount_currency,
            :discount_valid => discount_validity,:discount_number =>discount_number) if !discount_price.nil? && discount_price.present? && discount_price!=''
        end

      end
    elsif params[:price_3] == "1"
      @activity_profile_apf.price_type = 3
      @activity_profile_apf.filter_id = 3
    elsif params[:price_4] == "1"
      @activity_profile_apf.price_type = 4
    end

    #sending a  mail while editing the activity page
    #f params[:attendees] == "1"
    #~ @participant = Participant.find(:all,:conditions=>["activity_id = ? ", @activity_profile_apf.activity_id])
    # @participant = ActivityAttendDetail.find(:all,:conditions=>["activity_id = ? ", @activity_profile_apf.activity_id])
      
    # @get_current_url = request.env['HTTP_HOST']
    # to get the all participant details from participant table.
    #@participant.each do |r|
    #  user=User.find_by_user_id(r.user_id)
    # attend_email=user.email_address
    # if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
    #@result = UserMailer.edit_activity_mail(user,@activity_profile_apf,@get_current_url,params[:message],attend_email,params[:subject]).deliver
    # end  if user.present? && !user.nil?
    #end
    #end

    @activity_profile_apf.update_attributes(params[:activity])
    
    #setting notification detail sending a mail to the provider
    @provider_notifications_activity = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='2' and p.user_id='#{@activity_profile_apf.user_id}' and p.notify_flag=true") if !@activity_profile_apf.nil? && !@activity_profile_apf.user_id.nil?
    if @provider_notifications_activity.present? && @provider_notifications_activity!="" && !@provider_notifications_activity.nil?
      @participant=ActivityAttendDetail.select("user_id").where("activity_id =? and lower(payment_status)=?",@activity_profile_apf.activity_id,'paid').uniq
      @get_current_url = request.env['HTTP_HOST']
      @participant.each do |r|
        user=User.find_by_user_id(r.user_id)
        attend_email=user.email_address
        if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
          #@result = UserMailer.edit_activity_mail(user,@activity_profile_apf,@get_current_url,params[:message],attend_email,params[:subject]).deliver
          @result = UserMailer.delay(queue: "Edit Provider Activity to Participants", priority: 2, run_at: 10.seconds.from_now).edit_provider_participant_mail(user,@activity_profile_apf,@get_current_url,attend_email)
        end  if user.present? && !user.nil?
      end #do end participant
    else #first if the user not present in setting tables.
      @participant=ActivityAttendDetail.select("user_id").where("activity_id =? and lower(payment_status)=?",@activity_profile_apf.activity_id,'paid').uniq
      # to get the all participant details from participant table.
      @get_current_url = request.env['HTTP_HOST']
      @participant.each do |r|
        user=User.find_by_user_id(r.user_id)
        attend_email=user.email_address
        if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Edit Provider Activity to Participants", priority: 2, run_at: 10.seconds.from_now).edit_provider_participant_mail(user,@activity_profile_apf,@get_current_url,attend_email)
          #@result = UserMailer.edit_activity_mail(user,@activity_profile_apf,@get_current_url,params[:message],attend_email,params[:subject]).deliver
        end  if user.present? && !user.nil?
      end #do end participant
    end #if loop end for participant
    @provider_notification_default = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='5' and p.user_id='#{@activity_profile_apf.user_id}' and p.notify_flag=true") if !@activity_profile_apf.nil? && !@activity_profile_apf.user_id.nil?
    if @provider_notification_default.present? && @provider_notification_default!="" && !@provider_notification_default.nil?
      #sending a mail while editing the activity by the provider
      @get_current_url = request.env['HTTP_HOST']
      @plan = current_user.user_plan
      user=User.find_by_user_id(@activity_profile_apf.user_id) if !@activity_profile_apf.nil?
      attend_email=user.email_address if !user.email_address.nil?
      if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
        #@result = UserMailer.edit_activity_provider_mail(user,@activity_profile_apf,@get_current_url,attend_email,params[:subject]).deliver
        @result = UserMailer.delay(queue: "Provider Edit Activity", priority: 2, run_at: 10.seconds.from_now).edit_activity_provider_mail(user,@activity_profile_apf,@get_current_url,attend_email,@plan)
      end
    else
      #sending a mail while editing the activity by the provider
      user=User.find_by_user_id(@activity_profile_apf.user_id) if !@activity_profile_apf.nil?
      attend_email=user.email_address if !user.email_address.nil?
      @get_current_url = request.env['HTTP_HOST']
      @plan = current_user.user_plan
      if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
        @result = UserMailer.delay(queue: "Provider Edit Activity", priority: 2, run_at: 10.seconds.from_now).edit_activity_provider_mail(user,@activity_profile_apf,@get_current_url,attend_email,@plan)
        #@result = UserMailer.edit_activity_provider_mail(user,@activity_profile_apf,@get_current_url,attend_email,params[:subject]).deliver
      end
    end #if loop end for provider mail
    render :partial => "provider_edit_activity_thank"
    #redirect_to :action => "edit_acitivity_thank"
  end


  def parent_activity_update
    @activity_profile_apf = Activity.find(params[:activity_id])
    @activity_profile_apf.description = params[:description] if params[:description] !="Description should not exceed 500 characters"
    @user = User.find(cookies[:uid_usr])
    @activity_profile_apf.filter_id = 3
    if !params[:min_type].nil? && params[:min_type]!='' && params[:min_type] == 'month'
      @activity_profile_apf.min_age_range = ((params[:month_age1].to_f) / 12).round(2) if !params[:month_age1].nil? && params[:month_age1]!=''
    elsif !params[:min_type].nil? && params[:min_type]!='' && params[:min_type] == 'year'
      @activity_profile_apf.min_age_range = params[:year_age1] if !params[:year_age1].nil? && params[:year_age1]!=''
    end
    if !params[:max_type].nil? && params[:max_type]!='' && params[:max_type] == 'month'
      @activity_profile_apf.max_age_range = ((params[:month_age2].to_f)/ 12).round(2) if !params[:month_age2].nil? && params[:month_age2]!=''
    elsif !params[:max_type].nil? && params[:max_type]!='' && params[:max_type].downcase == 'year'
      @activity_profile_apf.max_age_range = params[:year_age2] if !params[:year_age2].nil? && params[:year_age2]!=''
    end
    @activity_profile_apf.avatar = params[:photo] if !params[:photo].nil? && params[:photo]!=""
    @activity_profile_apf.address_2 = params[:address_2] if params[:address_2] != "Address Line 2"
    @activity_profile_apf.address_1 = params[:address_1] if params[:address_1] != "Address Line 1"
    @activity_profile_apf.city = params[:city] if !params[:city].nil? && params[:city]!=''
    @activity_profile_apf.zip_code = params[:zip_code] if params[:zip_code]!="Enter Zip Code"
    @activity_old =  @activity_profile_apf.clone
    if !params[:city].nil? && params[:city]!=""
      city_se = City.where("city_name='#{params[:city]}'").last
      if !city_se.nil?
        @activity_profile_apf.latitude  = city_se.latitude
        @activity_profile_apf.longitude  = city_se.longitude
      end
    end
    if @activity_old.schedule_mode != params[:schedule_mode]
      @activity_delete = ActivitySchedule.delete_all(["activity_id = ? ", params[:activity_id]])
      if params[:schedule_mode] =="Any Time"
        @activity_profile_apf.update_attributes(:schedule_mode=> "Any Time")
        if params[:any_where]=="1"
          @activity_profile_apf.address_2 = nil
          @activity_profile_apf.address_1 = nil
          @activity_profile_apf.city = nil
          @activity_profile_apf.state = nil
          @activity_profile_apf.zip_code = nil
        end
      else
        if params[:repeatCheck_1]=="yes"
          if params[:repeatCheck_1] =="yes"
            if params[:r1_1] == "1"
              ex_date = "2100-12-31"
            else
              if !params[:repeat_alt_on_date_1].nil? && params[:repeat_alt_on_date_1]!=""
                ex_date = params[:repeat_alt_on_date_1]
              elsif !params[:after_occ_1].nil? && params[:after_occ_1]!=""
                ex_date = Date.parse(params[:date_1_1]) + (params[:repeatNumWeekVal_1].to_i * params[:after_occ_1].to_i).days
              end
            end
          end
          if ex_date =="" || ex_date.nil?
            ex_date = params[:date_1_1]
          end
          @date_split = params[:date_total].split(',') if !params[:date_total].nil?
          @date_split.each do |s|
            st_time = DateTime.parse("#{params[:schedule_stime_1_1]} #{params[:schedule_stime_2_1]}").strftime("%H:%M:%S") if !params[:schedule_stime_1_1].nil? && !params[:schedule_stime_2_1].nil? && params[:schedule_stime_1_1]!="" && params[:schedule_stime_2_1]!=""
            en_time = DateTime.parse("#{params[:schedule_etime_1_1]} #{params[:schedule_etime_2_1]}").strftime("%H:%M:%S") if !params[:schedule_etime_1_1].nil? && !params[:schedule_etime_2_1].nil? && params[:schedule_etime_1_1]!="" && params[:schedule_etime_2_1]!=""
            @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> "Schedule",:start_date=>params[:date_1_1],
              :start_time=>st_time,:end_time=>en_time,:expiration_date=>ex_date)
          end
          @activity_profile_apf.update_attributes(:schedule_mode=> "Schedule")
          @schedule.activity_repeat.create(:repeat_every => params[:repeatNumWeekVal_1],
            :ends_never=>params[:r1_1],:end_occurences=>params[:after_occ_1],
            :ends_on=>params[:repeat_alt_on_date1_1],:starts_on=>params[:date_1_1],:repeated_by_month=>params[:month1_1],:repeat_on=>params[:repeat_no_of_days_1],:repeats=>params[:repeatWeekVal_1])

        else
          @activity_profile_apf.update_attributes(:schedule_mode=> "Schedule")
          st_time = DateTime.parse("#{params[:schedule_stime_1_1]} #{params[:schedule_stime_2_1]}").strftime("%H:%M:%S") if !params[:schedule_stime_1_1].nil? && !params[:schedule_stime_2_1].nil? && params[:schedule_stime_1_1]!="" && params[:schedule_stime_2_1]!=""
          en_time = DateTime.parse("#{params[:schedule_etime_1_1]} #{params[:schedule_etime_2_1]}").strftime("%H:%M:%S") if !params[:schedule_etime_1_1].nil? && !params[:schedule_etime_2_1].nil? && params[:schedule_etime_1_1]!="" && params[:schedule_etime_2_1]!=""
          @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=>"Schedule",:start_date=>params[:date_1_1],
            :end_date=>params[:date_2_1],:start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:date_2_1])
        end
      end
    else
      if params[:schedule_mode] !="Any Time"
        if !params[:schedule_id_value].nil? && params[:schedule_id_value]!=""
          @act_schedule = ActivitySchedule.find(params[:schedule_id_value])
          st_time = DateTime.parse("#{params[:schedule_stime_1_1]} #{params[:schedule_stime_2_1]}").strftime("%H:%M:%S") if !params[:schedule_stime_1_1].nil? && !params[:schedule_stime_2_1].nil? && params[:schedule_stime_1_1]!="" && params[:schedule_stime_2_1]!=""
          en_time = DateTime.parse("#{params[:schedule_etime_1_1]} #{params[:schedule_etime_2_1]}").strftime("%H:%M:%S") if !params[:schedule_etime_1_1].nil? && !params[:schedule_etime_2_1].nil? && params[:schedule_etime_1_1]!="" && params[:schedule_etime_2_1]!=""
          if params[:repeatCheck_1]=="yes"
            if params[:repeatCheck_1] =="yes"
              if params[:r1_1] == "1"
                ex_date = "2100-12-31"
              else
                if !params[:repeat_alt_on_date_1].nil? && params[:repeat_alt_on_date_1]!=""
                  ex_date = params[:repeat_alt_on_date_1]
                elsif !params[:after_occ_1].nil? && params[:after_occ_1]!=""
                  ex_date = Date.parse(params[:date_1_1]) + (params[:repeatNumWeekVal_1].to_i * params[:after_occ_1].to_i).days
                end
              end
            end
            if ex_date =="" || ex_date.nil?
              ex_date = params[:date_1_1]
            end


            @activity_profile_apf.schedule_mode = "Schedule"
            @act_schedule.update_attributes(:schedule_mode=> "Schedule",:start_date=>params[:date_1_1],
              :start_time=>st_time,:end_time=>en_time,:expiration_date=>ex_date)
            @activity_repeat = ActivityRepeat.find_by_activity_schedule_id(@act_schedule.schedule_id)
            if !@activity_repeat.nil?
              @activity_repeat.repeat_every = params[:repeatNumWeekVal_1]
              @activity_repeat.ends_never= params[:r1_1]
              end_on_date =""
              if params[:r1_1]=="0" && params[:after_occ_1].nil?
                end_on_date = params[:repeat_alt_on_date1_1]
              end
              @activity_repeat.end_occurences= params[:after_occ_1]
              @activity_repeat.ends_on= end_on_date
              @activity_repeat.starts_on=params[:date_1_1]
              @activity_repeat.repeat_on= params[:repeat_no_of_days_1]
              @activity_repeat.repeats= params[:repeatWeekVal_1]
              @activity_repeat.repeated_by_month = params[:month1_1]
              @activity_repeat.save
            else
              @act_schedule.activity_repeat.create(:repeat_every => params[:repeatNumWeekVal_1],
                :ends_never=>params[:r1_1],:end_occurences=>params[:after_occ_1],
                :ends_on=>params[:repeat_on_date1_1],:starts_on=>params[:date_1_1],:repeated_by_month=>params[:month1_1],:repeat_on=>params[:repeat_no_of_days_1],:repeats=>params[:repeatWeekVal_1])
            end
          else
            @activity_profile_apf.update_attributes(:schedule_mode => "Whole Day")

            @activity_sc = ActivityRepeat.delete_all(["activity_schedule_id = ? ",  @activity_profile_apf.activity_schedule.last.schedule_id])
            @act_schedule.update_attributes(:schedule_mode=> "Whole Day",:start_date=>params[:date_1_1],
              :end_date=>params[:date_2_1],:start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:date_2_1])
          end
        end
      else
        @activity_profile_apf.update_attributes(:schedule_mode => "Any Time")
        if params[:any_where]=="1"
          @activity_profile_apf.address_2 = nil
          @activity_profile_apf.address_1 = nil
          @activity_profile_apf.city = nil
          @activity_profile_apf.state = nil
          @activity_profile_apf.zip_code = nil
        end
      end
    end


    
    @activity_profile_apf.update_attributes(params[:activity])
    
    #sending a  mail while editing the activity page to participant
    # if params[:attendees] == "1"
    @participant=ActivityAttendDetail.select("user_id").where("activity_id =? and lower(payment_status)=?",@activity_profile_apf.activity_id,'paid').uniq
    @get_current_url = request.env['HTTP_HOST']
    @participant.each do |r|
      user=User.find_by_user_id(r.user_id)
      attend_email=user.email_address
      if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
        #@result = UserMailer.edit_activity_mail(user,@activity_profile_apf,@get_current_url,params[:message],attend_email,params[:subject]).deliver
        @result = UserMailer.delay(queue: "Edit Parent Activity to Participants", priority: 2, run_at: 10.seconds.from_now).edit_parent_participant_mail(user,@activity_profile_apf,@get_current_url,attend_email)
      end  if user.present? && !user.nil?
    end #do end participant
    #end
    #sending a mail while editing the activity by the parent
    user=User.find_by_user_id(@activity_profile_apf.user_id) if !@activity_profile_apf.nil?
    attend_email=user.email_address if !user.email_address.nil?
    @get_current_url = request.env['HTTP_HOST']
    if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
      @result = UserMailer.delay(queue: "Parent Edit Activity", priority: 2, run_at: 10.seconds.from_now).edit_activity_parent_mail(user,@activity_profile_apf,@get_current_url,attend_email)
      #@result = UserMailer.edit_activity_provider_mail(user,@activity_profile_apf,@get_current_url,attend_email,params[:subject]).deliver
    end

    redirect_to :action => "parent_acitivity_thank"

  end
  
  def provider_activity_success
    @before_login_value = params[:before_login_value] if !params[:before_login_value].nil? && params[:before_login_value].present?
    @activity = Activity.find_by_activity_id(params[:activity_id])
    @get_current_url = request.env['HTTP_HOST']
    @send_to = params[:send_to]
    @activity_user=User.find_by_user_id(@activity.user_id) if !@activity.nil?
    # add from to user
    @from_user=current_user if !current_user.nil? && current_user.present?
    if @activity_user
      @result = UserMailer.delay(queue: "Get Info", priority: 2, run_at: 10.seconds.from_now).get_information_mail(@from_user,@activity,@activity_user,@get_current_url,params[:message],@send_to,params[:subject]) if !@activity_user.nil? && @activity_user.user_flag==TRUE
      #@result = UserMailer.get_information_mail(@from_user,@activity,@edit_activity_provider_mail,params[:message],@send_to,params[:subject]).deliver if !user.nil? && user.user_flag==TRUE
    else
      @result = UserMailer.delay(queue: "Get Info", priority: 2, run_at: 10.seconds.from_now).get_information_mail(@from_user,@activity,@activity_user,@get_current_url,params[:message],@send_to,params[:subject])
      #@result = UserMailer.get_information_mail(@from_user,@activity,@get_current_url,params[:message],@send_to,params[:subject]).deliver
    end
    respond_to do |format|
      format.js
    end

  end
  
  #provider info form page
  def provider_information
    @before_login_value = params[:before_login_value] if !params[:before_login_value].nil? && params[:before_login_value].present?
    @activity = Activity.find(params[:activity_id])
    @mge="I found your activity in Famtivity. I would like a little more information about it before I proceed. Please get in touch with me."
  end
  
  #contact provider informatino page get method
  def contact_provider_info
    @activity = Activity.find(params[:activity_id])
    @cont_message="I found your activity in Famtivity. I would like a little more information about the pricing structure before I proceed. Please get in touch with me."
  end
  
  #contact provider post success function calling
  def contact_provider_success
    @activity = Activity.find_by_activity_id(params[:activity_id])
    @get_current_url = request.env['HTTP_HOST']
    @send_to = params[:send_to]
    @activity_user=User.find_by_user_id(@activity.user_id) if !@activity.nil?
    # add from to user
    @from_user=current_user if !current_user.nil? && current_user.present?
    if @activity_user
      @result = UserMailer.delay(queue: "Contact Info", priority: 2, run_at: 10.seconds.from_now).provider_contact_price(@from_user,@activity,@activity_user,@get_current_url,params[:message],@send_to) if !@activity_user.nil? && @activity_user.user_flag==TRUE
      #@result = UserMailer.get_information_mail(@from_user,@activity,@edit_activity_provider_mail,params[:message],@send_to,params[:subject]).deliver if !user.nil? && user.user_flag==TRUE
    else
      @result = UserMailer.delay(queue: "Contact Info", priority: 2, run_at: 10.seconds.from_now).provider_contact_price(@from_user,@activity,@activity_user,@get_current_url,params[:message],@send_to)
      #@result = UserMailer.get_information_mail(@from_user,@activity,@get_current_url,params[:message],@send_to,params[:subject]).deliver
    end
    respond_to do |format|
      format.js
    end
  end

  #method for link clicked in activity details page by rajkumar
  def link_clicked
    @tdate = Date.today
    @sdat = @tdate.at_beginning_of_month.strftime("%Y-%m-%d")
    @edat = @tdate.end_of_month.strftime("%Y-%m-%d")
    @usr_clk = ActivityTrack.where("user_id = ? and activity_id = ? and start_date = ? and end_date = ?",params[:user_id],params[:activity_id],"#{@sdat}","#{@edat}").last if !params[:activity_id].nil? && !params[:user_id].nil?
    if @usr_clk.nil?
      @usr_clk = ActivityTrack.new #insert the data
      @usr_clk.activity_id = params[:activity_id] if !params[:activity_id].nil? && params[:activity_id]!="" && params[:activity_id].present?
      @usr_clk.user_id = params[:user_id] if !params[:user_id].nil? && params[:user_id]!="" && params[:user_id].present?
      @usr_clk.inserted_date = Time.now
      @usr_clk.modified_date = Time.now
      if !params[:pemail].nil? && params[:pemail].present? && params[:pemail] == 'email'
        @usr_clk.email_count = 1
      else
        @usr_clk.website_count = 1
      end
      @usr_clk.start_date = @sdat
      @usr_clk.end_date = @edat
      @usr_clk.save
      @status = "inserted"
    else #update the data while clicking
      if !@usr_clk.nil? && @usr_clk!="" && @usr_clk.present?
        if !params[:pemail].nil? && params[:pemail].present? && params[:pemail] == 'email'
          @ecount="" #email count updated
          @ecount = @usr_clk.email_count #increment the click count values
          if !@ecount.nil?
            @ecount = @ecount+1
          else
            @ecount = 1
          end
          @usr_clk.update_attributes(:email_count=>@ecount, :modified_date=>Time.now)
          @status = "updated"
        else
          #website_count link updated
          @wcount=""
          @wcount = @usr_clk.website_count #increment the click count values
          if !@wcount.nil?
            @wcount = @wcount+1
          else
            @wcount = 1
          end
          @usr_clk.update_attributes(:website_count=>@wcount, :modified_date=>Time.now)
          @status = "updated"
        end
      end
    end
    render :text=>@status
  end  #link clicked method end

  #send a mail to provider
  def sendmsgtoprver_old
    if !current_user.nil? && current_user.present?
      @user = current_user
      @pro_usr = User.find_by_user_id(params[:user_id]) if !params[:user_id].nil? && params[:user_id].present?
      @get_current_url = request.env['HTTP_HOST']
      #activity click count start
      @tdate = Date.today
      @sdat = @tdate.at_beginning_of_month.strftime("%Y-%m-%d")
      @edat = @tdate.end_of_month.strftime("%Y-%m-%d")
      @activity = Activity.find_by_activity_id(params[:activity_id]) #to get the activity information
      @usr_clk = ActivityTrack.where("user_id = ? and activity_id = ? and start_date = ? and end_date = ?",params[:user_id],params[:activity_id],"#{@sdat}","#{@edat}").last if !params[:activity_id].nil? && !params[:user_id].nil?
      #insert the message count in activity track table
      if !@activity.nil? && !@activity.created_by.nil? && @activity.created_by == "Provider" #only count for provider
        if @usr_clk.nil?
          @usr_clk = ActivityTrack.new #insert the data
          @usr_clk.activity_id = params[:activity_id] if !params[:activity_id].nil? && params[:activity_id]!="" && params[:activity_id].present?
          @usr_clk.user_id = params[:user_id] if !params[:user_id].nil? && params[:user_id]!="" && params[:user_id].present?
          @usr_clk.inserted_date = Time.now
          @usr_clk.modified_date = Time.now
          @usr_clk.message_count = 1
          @usr_clk.start_date = @sdat
          @usr_clk.end_date = @edat
          @usr_clk.save
        else  #upate the message count in activity track table
          @mcount=""
          @mcount = @usr_clk.message_count #increment the click count values
          if !@mcount.nil?
            @mcount = @mcount+1
          else
            @mcount = 1
          end
          @usr_clk.update_attributes(:message_count=>@mcount, :modified_date=>Time.now)
        end #if end
      end #only count for provider end
	      
      #activity click count end
      if !@pro_usr.nil? && @pro_usr!='' && @pro_usr.present? && @pro_usr.user_flag==TRUE
        #~ @result = UserMailer.message_to_provider(@user,@pro_usr,@activity,@get_current_url,params[:send_msg]).deliver
        @result = UserMailer.delay(queue: "Send message", priority: 2, run_at: 10.seconds.from_now).message_to_provider(@user,@pro_usr,@activity,@get_current_url,params[:send_msg])
      end
    end
    #~ render :text=>@status
    respond_to do |format|
      format.js{render :text => "$('.success_send_msg').css('display', 'block').fadeOut(2000);$('#send_msg').val('');"}
    end
  end #method end

  def provider_detail_iframe
    @mode_act = params[:act]
    @user_profile = UserProfile.where("user_id = #{params[:det]}").last 
    redirect_to "/#{@user_profile.city.gsub(' ','-').downcase if !@user_profile.nil? && !@user_profile.city.nil?}-ca/#{@user_profile.slug}", :status=> 301
  end

  def provider_info
    #~ @user_profile = UserProfile.find_by_business_name(params[:business_name]) if params[:business_name]
    @bname = params[:business_name] if params[:business_name]
    @user_profile = UserProfile.where("slug = ?", "#{@bname}").last if @bname
    @user = User.where("user_id = ?","#{@user_profile.user_id}").last if @user_profile && @user_profile!=''
  end
  
  #send a mail to provider
  def sendmsgtoprver
    @pro_usr = User.find_by_user_id(params[:user_id]) if !params[:user_id].nil? && params[:user_id].present?
    @activity = Activity.find_by_activity_id(params[:activity_id]) #to get the activity information
    @get_current_url = request.env['HTTP_HOST']
      
    if !current_user.nil? && current_user.present?
      @user = current_user
      #Provider lead started
      @date = Date.today.strftime("%Y-%m-%d")
      @usr_clk = ProviderLead.where("user_id = ? and customer_id = ? and activity_id = ? and inserted_date = ?",params[:user_id],current_user.user_id,params[:activity_id],"#{@date}").last if !params[:user_id].nil? && !current_user.nil? && !current_user.user_id.nil? && !params[:activity_id].nil?
      #insert the data in provider leads table
      if !@activity.nil? && !@activity.created_by.nil? && @activity.created_by == "Provider" && !@pro_usr.nil? && !@pro_usr.user_plan.nil? && @pro_usr.user_plan.downcase !="curator" && !@pro_usr.manage_plan.nil? && @pro_usr.manage_plan.present? #only count for market provider not the new manage plan user
      elsif !@activity.nil? && !@activity.created_by.nil? && @activity.created_by == "Provider" && !@pro_usr.nil? && !@pro_usr.user_plan.nil? && @pro_usr.user_plan.downcase !="curator"#only count for market provider
        if @usr_clk.nil?
          @payment_detail = UserTransaction.find_by_user_id(params[:user_id]) if !params[:user_id].nil? && params[:user_id].present?
          @usr_clk = ProviderLead.new #insert the data
          @usr_clk.activity_id = params[:activity_id] if !params[:activity_id].nil? && params[:activity_id]!="" && params[:activity_id].present?
          @usr_clk.user_id = params[:user_id] if !params[:user_id].nil? && params[:user_id]!="" && params[:user_id].present?
          @usr_clk.inserted_date = @date
          @usr_clk.modified_date = Time.now
          @usr_clk.customer_id = current_user.user_id if !current_user.nil? && !current_user.user_id.nil?
          @usr_clk.amount = "#{$pro_leads}" #get the values from app controller
          @usr_clk.message = params[:send_msg] if !params[:send_msg].nil? && params[:send_msg]!=""
          @usr_clk.user_plan = @pro_usr.user_plan if !@pro_usr.nil? && @pro_usr!='' && @pro_usr.present?
          if !@payment_detail.nil? && @payment_detail.present?
            @usr_clk.credit_card = "yes"
          else
            @usr_clk.credit_card = "no"
          end
          @usr_clk.save

          #authorize information started
          if !@payment_detail.nil? && @payment_detail.present?
            @payment_profile = CIMGATEWAY.get_customer_payment_profile(:customer_profile_id=>@payment_detail.customer_profile_id,:customer_payment_profile_id=>@payment_detail.customer_payment_profile_id)
            transaction =
              {:transaction => {
                :type => :auth_capture,
                :amount => "#{$pro_leads}", #0.99cents
                :customer_profile_id => @payment_detail.customer_profile_id,
                :customer_payment_profile_id => @payment_detail.customer_payment_profile_id
              }
            }
            #create the transaction for the user
            response = CIMGATEWAY.create_customer_profile_transaction(transaction)
            if !response.nil? && response.success?
              #~stored the transaction success information in leads table
              @lead = LeadTransaction.new #insert the transaction information in lead table
              @lead.lead_id = @usr_clk.lead_id if !@usr_clk.nil?
              @lead.payment_status = "success"
              @lead.transaction_id = "#{response.authorization}" if !response.nil? && !response.authorization.nil?
              @lead.payment_date = Time.now
              @lead.customer_payment_profile_id = @payment_detail.customer_payment_profile_id if !@payment_detail.nil? && !@payment_detail.customer_payment_profile_id.nil?
              @lead.customer_profile_id =  @payment_detail.customer_profile_id if !@payment_detail.nil? && !@payment_detail.customer_profile_id.nil?
              @lead.payment_message =  "#{response.message}" if !response.nil? && !response.message.nil?
              @lead.amount = "#{$pro_leads}"
              @lead.inserted_date = Time.now
              @lead.modified_date = Time.now
              @lead.save
              #send a mail to provider about the transaction
              if !@pro_usr.nil? && @pro_usr!='' && @pro_usr.present? && !@pro_usr.user_plan.nil? && @pro_usr.user_plan.downcase == "free" #send a mail to provider
                #~ @result = UserMailer.trans_msgtoprovider(@user,@pro_usr,@activity,@get_current_url,params[:send_msg]).deliver
                @result = UserMailer.delay(queue: "Send message to market provider for transaction", priority: 2, run_at: 10.seconds.from_now).trans_msgtoprovider(@user,@pro_usr,@activity,@get_current_url,params[:send_msg])
              else
                @result = UserMailer.delay(queue: "Send message to sell through provider", priority: 2, run_at: 10.seconds.from_now).trans_msgto_sellpro(@user,@pro_usr,@activity,@get_current_url)
              end
            else
              #~ raise StandardError, response.message
              #~stored the transaction failure information in leads table
              @lead = LeadTransaction.new #insert the transaction information in lead table
              @lead.lead_id = @usr_clk.lead_id if !@usr_clk.nil?
              @lead.payment_status = "failure"
              @lead.transaction_id = "#{response.authorization}" if !response.nil? && !response.authorization.nil?
              @lead.payment_date = Time.now
              @lead.customer_payment_profile_id = @payment_detail.customer_payment_profile_id if !@payment_detail.nil? && !@payment_detail.customer_payment_profile_id.nil?
              @lead.customer_profile_id = @payment_detail.customer_profile_id if !@payment_detail.nil? && !@payment_detail.customer_profile_id.nil?
              @lead.payment_message = "#{response.message}" if !response.nil? && !response.message.nil?
              @lead.amount = "#{$pro_leads}"
              @lead.inserted_date = Time.now
              @lead.modified_date = Time.now
              @lead.save
              if !@pro_usr.nil? && @pro_usr!='' && @pro_usr.present? && !@pro_usr.user_plan.nil? && @pro_usr.user_plan.downcase == "free" #send a mail to provider
                @result = UserMailer.delay(queue: "Send message to fam", priority: 2, run_at: 10.seconds.from_now).incorrect_mailto_pro(@user,@pro_usr,@activity,@get_current_url)
                @result1 = UserMailer.delay(queue: "Send message to pro", priority: 2, run_at: 10.seconds.from_now).incorrect_mailto_fam(@user,@pro_usr,@activity,@get_current_url)
              else
                @result = UserMailer.delay(queue: "Send message to fam for sell", priority: 2, run_at: 10.seconds.from_now).incorrect_mailto_pro_forsell(@user,@pro_usr,@activity,@get_current_url)
                @result1 = UserMailer.delay(queue: "Send message to pro for sell", priority: 2, run_at: 10.seconds.from_now).incorrect_mailto_fam_forsell(@user,@pro_usr,@activity,@get_current_url)
              end
            end #auth response end
          else #if the user didn't have any credit card details send a mail to provider and support team
            #~ @result = UserMailer.nocrdcrt_det_to_fam(@user,@pro_usr,@activity,@get_current_url).deliver
            if !@pro_usr.nil? && @pro_usr!='' && @pro_usr.present? && !@pro_usr.user_plan.nil? && @pro_usr.user_plan.downcase == "free" #send a mail to provider
              @result = UserMailer.delay(queue: "Send message to famtivity", priority: 2, run_at: 10.seconds.from_now).nocrdcrt_det_to_fam(@user,@pro_usr,@activity,@get_current_url)
              @result1 = UserMailer.delay(queue: "Send message to provider", priority: 2, run_at: 10.seconds.from_now).nocrdcrt_det_to_pro(@user,@pro_usr,@activity,@get_current_url)
            else
              @result = UserMailer.delay(queue: "Send message to famtivity for sell", priority: 2, run_at: 10.seconds.from_now).nocrdcrt_det_to_fam_forsell(@user,@pro_usr,@activity,@get_current_url)
              @result1 = UserMailer.delay(queue: "Send message to provider for sell", priority: 2, run_at: 10.seconds.from_now).nocrdcrt_det_to_pro_forsell(@user,@pro_usr,@activity,@get_current_url)
            end
          end #payment details loop end
          #authorize information end
        end #if end
      end #only count for provider end
		
      #Stored the send message track in activity track table start
      @clk_track = ActivityTrack.new #insert the data
      @clk_track.activity_id = params[:activity_id] if !params[:activity_id].nil? && params[:activity_id]!="" && params[:activity_id].present?
      @clk_track.activity_name = @activity.activity_name if !@activity.nil? && !@activity.activity_name.nil?
      @clk_track.parent_user_id = current_user.user_id if !current_user.nil? && !current_user.user_id.nil?
      @clk_track.date = Date.today.strftime("%Y-%m-%d")
      @clk_track.from_email = current_user.email_address if !current_user.nil? && !current_user.email_address.nil?
      @clk_track.to_email = @pro_usr.email_address if !@pro_usr.nil? && !@pro_usr.email_address.nil?
      @clk_track.message = params[:send_msg] if !params[:send_msg].nil? && params[:send_msg]!=""
      @clk_track.message_type = "activity"
      @clk_track.inserted_date = Time.now
      @clk_track.modified_date = Time.now
      @clk_track.save
      #Stored the send message track in activity track table end

      #activity click count end
      if !@pro_usr.nil? && @pro_usr!='' && @pro_usr.present? && @pro_usr.user_flag==TRUE
        #~ @result = UserMailer.message_to_provider(@user,@pro_usr,@activity,@get_current_url,params[:send_msg]).deliver
        @result = UserMailer.delay(queue: "Send message to owner of activity", priority: 2, run_at: 10.seconds.from_now).message_to_provider(@user,@pro_usr,@activity,@get_current_url,params[:send_msg])
      else
        @result = UserMailer.delay(queue: "Send message to famtivity support", priority: 2, run_at: 10.seconds.from_now).message_to_provider(@user,@pro_usr,@activity,@get_current_url,params[:send_msg])
      end
    else #current user not present send a mail to provider
      #Stored the send message track in activity track table start
      @clk_track = ActivityTrack.new #insert the data
      @clk_track.activity_id = params[:activity_id] if !params[:activity_id].nil? && params[:activity_id]!="" && params[:activity_id].present?
      @clk_track.activity_name = @activity.activity_name if !@activity.nil? && !@activity.activity_name.nil?
      @clk_track.date = Date.today.strftime("%Y-%m-%d")
      @clk_track.from_email = params[:provider_email] if !params[:provider_email].nil? && params[:provider_email]!="Enter your Email"
      @clk_track.to_email = @pro_usr.email_address if !@pro_usr.nil? && !@pro_usr.email_address.nil?
      @clk_track.message = params[:send_msg] if !params[:send_msg].nil? && params[:send_msg]!=""
      @clk_track.message_type = "activity"
      @clk_track.inserted_date = Time.now
      @clk_track.modified_date = Time.now
      @clk_track.save
      #Stored the send message track in activity track table end
      #~ @result = UserMailer.beforeln_msg_toprovider(params[:provider_email],@pro_usr,@activity,@get_current_url,params[:send_msg]).deliver
      @result = UserMailer.delay(queue: "Send message to pro before login", priority: 2, run_at: 10.seconds.from_now).beforeln_msg_toprovider(params[:provider_email],@pro_usr,@activity,@get_current_url,params[:send_msg])
    end #current user ending
    #~ render :text=>@status
    respond_to do |format|
      format.js{render :text => "$('html, body').animate({ scrollTop: 0 });
					$('#send_msg').val('');
				     $('.flash-message').html('Message has been sent successfully!');
					var win=$(window).width();
					var con=$('.flash_content').width();
					var leftvalue=((win/2)-(con/2))
					$('.flash_content').css('left',leftvalue+'px');
					$('.flash_content').css('top','67px');
					$('.flash_content').fadeIn().delay(5000).fadeOut();
      "}
    end
  end #method end

  #send message to provider card
  def msg_to_provider_curator
    @pro_usr = User.find_by_user_id(params[:user_id]) if !params[:user_id].nil? && params[:user_id].present?
    @get_current_url = request.env['HTTP_HOST']
    @date = Date.today.strftime("%Y-%m-%d")
    @email = params[:provider_email] if !params[:provider_email].nil? && params[:provider_email]!="Enter your Email"
     
    if !current_user.nil? && current_user.present?
      @user = current_user
      #Stored the send message track in activity track table start
      @clk_track = ActivityTrack.store_providercard_withuser(current_user.user_id,@date,current_user.email_address,@pro_usr.email_address,params[:send_msg]) if @pro_usr
      @result = UserMailer.delay(queue: "Send message", priority: 2, run_at: 10.seconds.from_now).message_to_provider_curator(@user,@pro_usr,@get_current_url,params[:send_msg])
    else #if current user not present
      #Stored the send message track in activity track table end
      @result = UserMailer.delay(queue: "Send message to provider card user before login", priority: 2, run_at: 10.seconds.from_now).beforeln_msg_to_cardprovider(params[:provider_email],@pro_usr,@get_current_url,params[:send_msg])
      @clk_track = ActivityTrack.store_providercard_withuser('',@date,@email,@pro_usr.email_address,params[:send_msg]) if @pro_usr
    end #current user end
	
    respond_to do |format|
	#~ format.js{render :text => "$('.success_send_msg').css('display', 'block').fadeOut(2000);$('#send_msg').val('');"}
       format.js{render :text => "$('html, body').animate({ scrollTop: 0 });
					$('#send_msg').val('');
				     $('.flash-message').html('Message has been sent successfully!');
					var win=$(window).width();
					var con=$('.flash_content').width();
					var leftvalue=((win/2)-(con/2))
					$('.flash_content').css('left',leftvalue+'px');
					$('.flash_content').css('top','67px');
					$('.flash_content').fadeIn().delay(5000).fadeOut();
      "}
    end
  end #msg to provider ending

  
  #Google cal datas
  def googleCalAdd
    rsult = ''
    activity_sched = ActivitySchedule.find(params[:sched_id])
    test = googleCalData(activity_sched) #From ActivityDetail helper
    t_zone = time_zone_location #From ActivityDetail helper
    rsult = rsult+"#{test[0]}"+"@#{test[1]}"+"@#{test[2]}"+"@#{test[3]}"+"@#{test[4]}"+"@#{test[5]}"+"@#{test[6]}"+"@#{t_zone}"
    render :text => "#{rsult}"+"#"+"#{test[7]}"
  end
  
end
