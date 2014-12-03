class ActivitiesController < ApplicationController
  before_filter :authenticate_user, :except=>[:provider_web_count,:data_entry,:search_event_index,:advanced_search, :advance_search, :landing_search, :search, :basic_search_count, :search_by_keyword, :activity_count_newsletter,:edit_update_sub_category,:add_participant]
  include ActionView::Helpers::TextHelper
  require 'zip/zip'
  require 'zip/zipfilesystem'
  #caches_page :event_index
  require 'date'
  require 'time'
  require 'will_paginate/array'
  require 'fastimage'#this gem for fetching the images.


  include ActivitiesHelper
  #New approval GUi Goes here.Please add your new action and code below.
   
  def message_preview_attachment
    @thread = params[:mthreads] if params[:mthreads]!='' && params[:mthreads].present?
    @get_current_url = request.env['HTTP_HOST']
  end

  #get the attached image for messages
  #~ def get_preview_images
	   
  #~ respond_to do |format|
  #~ format.js
  #~ end
  #~ end
   
  def build_activity_network_popup
    @get_current_url = request.env['HTTP_HOST']
  end
  #provider, activity website count
  def provider_web_count
    @web_count = ProviderWebsiteTrack.where("user_id=?",params[:user_id]).last
    @date = Time.now.strftime("%Y-%m-%d")
    @old_date=@web_count.modified_date.strftime("%Y-%m-%d") if !@web_count.nil? && !@web_count.modified_date.nil?
    if !@old_date.nil? && @date==@old_date
      if !params[:type].nil? && params[:type]=="activity"
        if !@web_count.activity_website_count.nil?
          @web_count.activity_website_count=@web_count.activity_website_count + 1
        else
          @web_count.activity_website_count=1
        end
        @web_count.inserted_date=Time.now
        @web_count.modified_date=Time.now
        @web_count.save
      else
        if !@web_count.provider_website_count.nil?
          @web_count.provider_website_count=@web_count.provider_website_count + 1
        else
          @web_count.provider_website_count=1
        end
        @web_count.inserted_date=Time.now
        @web_count.modified_date=Time.now
        @web_count.save
      end
    else
      webcount=ProviderWebsiteTrack.new
      if !params[:type].nil? && params[:type]=="activity"
        webcount.activity_website_count=1
      else
        webcount.provider_website_count=1
      end
      webcount.user_id=params[:user_id] if !params[:user_id].nil?
      webcount.inserted_date=Time.now
      webcount.modified_date=Time.now
      webcount.save
    end
    render :text => true
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
   
  #displayed the count for the user's activity
  def user_activity_status
    if current_user && !current_user.nil?
      #business logo click views
      @track_logo = Activity.track_logo_view(current_user.user_id)
      if !@track_logo.nil? && @track_logo.present?
        @track_logo
      else
        @track_logo= 0
      end
	
      #Total views count for previous week
      @last_week = Activity.total_view_list_lastweek(current_user.user_id)
      if !@last_week.nil? && @last_week.present? && @last_week!=""
        @last_week
      else
        @last_week = 0
      end
     
      #Total views count list
      @total_views = Activity.total_view_list(current_user.user_id)
      if !@total_views.nil? && @total_views.present? && @total_views!=""
        @total_views
      else
        @total_views = 0
      end
      
      #active activities
      @active = Activity.active_activities_list(current_user.user_id)
      if !@active.nil? && @active.present? && @active!=""
        @active_count = @active.length
      else
        @active_count = 0
      end
      #inactive activities
      @inactive = Activity.inactive_activities(current_user.user_id)
      if !@inactive.nil? && @inactive.present? && @inactive!=""
        @inactcount = @inactive.length
      else
        @inactcount = 0
      end
      #expired activities
      @expired = Activity.expired_activities(current_user.user_id)
      if !@expired.nil? && @expired.present? && @expired!=""
        @expired_count = @expired.length
      else
        @expired_count = 0
      end
      #discount dollar activities
      @ddollar = Activity.discount_dollar_activities(current_user.user_id)
      if !@ddollar.nil? && @ddollar.present? && @ddollar!=""
        @ddollar_count = @ddollar.length
      else
        @ddollar_count = 0
      end
      #Lead user count
      @leaduser = Activity.lead_user_list(current_user.email_address)
      if !@leaduser.nil? && @leaduser.present? && @leaduser!=""
        @leaduser_count = @leaduser.length
      else
        @leaduser_count = 0
      end
      #Registration invitee user list for the provider
      @reg_invite = Activity.provider_invitee_list(current_user.user_id)
      if !@reg_invite.nil? && @reg_invite.present? && @reg_invite!=""
        @reg_invite_count = @reg_invite.length
      else
        @reg_invite_count = 0
      end
      #Top view activities list
      @top_view = Activity.top_view_activities(current_user.user_id)
      
      #Top share activities list
      @top_share = Activity.top_share_activities(current_user.user_id)

      render :layout=>false
    end
  end #user activity status ending here.
  
 
  #delete function for multiple shedule activity
  def schedule_destroy
    @schedule_value = params[:sch_id].split(',')
    #activity delete start
    if !params[:act_id].nil? && params[:act_id].present? && params[:act_id]=="not_empty"
      activity=params[:activity_id].gsub(/&\w+;/, '').parameterize
      @act=Activity.find(activity) if !activity.nil?
      @activity_user = User.find_by_user_id(@act.user_id) if !@act.nil? && @act.present?
      #update the activity record as delete status.
      @act.update_attributes(:active_status=>"Delete",:modified_date=>Time.now)
      #setting notification for the users
      @provider_notifications = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='1' and p.user_id='#{@act.user_id}' and p.notify_flag=true") if !@act.nil? && !@act.user_id.nil?
      # if user present in setting tables
      if @provider_notifications.present? && @provider_notifications!="" && !@provider_notifications.nil?
        #~ #sending mail to the participant while delete the activity  ----dont remove this code----
        @participant = ActivityAttendDetail.select("user_id").where("activity_id=? and lower(payment_status)=?",@act.activity_id,'paid').group("user_id")
        #~ @participant = ActivityAttendDetail.find(:all,:conditions=>["activity_id = ? ", @act.activity_id])
        @participant.each do |r|
          user_parent=User.find_by_user_id(r.user_id)
          email_parent=user_parent.email_address if !user_parent.email_address.nil? &&  !user_parent.nil?
          if email_parent !="" && !email_parent.nil? && !email_parent.blank? && user_parent.user_flag==TRUE
            @result = UserMailer.delay(queue: "Cancel Activity to participant", priority: 2, run_at: 10.seconds.from_now).cancel_activity_mail_to_parent(user_parent.user_name,@act,@get_current_url,email_parent,@activity_user)
            #@result = UserMailer.cancel_activity_mail_to_parent(user_parent.user_name,@act,@get_current_url,params[:message],email_parent,params[:subject]).deliver
          end  if user_parent.present? && !user_parent.nil?
        end if !@participant.nil? && @participant.present?
      else #first if the user not present in setting tables.
        #~ #sending mail to the participant while delete the activity  ----dont remove this code----
        #~ @participant = ActivityAttendDetail.find(:all,:conditions=>["activity_id = ? ", @act.activity_id])
        @participant = ActivityAttendDetail.select("user_id").where("activity_id=? and lower(payment_status)=?",@act.activity_id,'paid').group("user_id")
        @participant.each do |r|
          user_parent=User.find_by_user_id(r.user_id)
          email_parent=user_parent.email_address if !user_parent.email_address.nil? &&  !user_parent.nil?
          if email_parent !="" && !email_parent.nil? && !email_parent.blank? && user_parent.user_flag==TRUE
            @result = UserMailer.delay(queue: "Cancel Activity to participant", priority: 2, run_at: 10.seconds.from_now).cancel_activity_mail_to_parent(user_parent.user_name,@act,@get_current_url,email_parent,@activity_user)
            #@result = UserMailer.cancel_activity_mail_to_parent(user_parent.user_name,@act,@get_current_url,params[:message],email_parent,params[:subject]).deliver
          end  if user_parent.present? && !user_parent.nil?
        end if !@participant.nil? && @participant.present?
      end #first if end
      
      #setting notification for the users
      @provider_notification_default = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='6' and p.user_id='#{@act.user_id}' and p.notify_flag=true") if !@act.nil? && !@act.user_id.nil?
      #user present in setting notify me when the record is removed
      if @provider_notification_default.present? && @provider_notification_default!="" && !@provider_notification_default.nil?
        #sending mail while delete the activity by the provider.
        user=User.find_by_user_id(@act.user_id) if !@act.nil?
        attend_email=user.email_address if !user.email_address.nil?
        user_name=user.user_name if !user.user_name.nil?
        if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Delete Activity", priority: 2, run_at: 10.seconds.from_now).delete_activity_mail(user,@act,@get_current_url,attend_email)
          #@result = UserMailer.delete_activity_mail(user_name,@act,@get_current_url,params[:message],attend_email,params[:subject]).deliver
        end  if user.present? && !user.nil?
      else
        #user not present in setting table
        #sending mail while delete the activity by the provider.
        user=User.find_by_user_id(@act.user_id) if !@act.nil?
        attend_email=user.email_address if !user.email_address.nil?
        user_name=user.user_name if !user.user_name.nil?
        if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
          @result = UserMailer.delay(queue: "Delete Activity", priority: 2, run_at: 10.seconds.from_now).delete_activity_mail(user,@act,@get_current_url,attend_email)
          #@result = UserMailer.delete_activity_mail(user_name,@act,@get_current_url,params[:message],attend_email,params[:subject]).deliver
        end  if user.present? && !user.nil?
      end
    else
      @schedule_value.each do |schedule| #activity_shedule delete start
        @act_schedule = ActivitySchedule.find(schedule)
        @act_price = ActivityPrice.find_by_activity_schedule_id(schedule)
        activity=params[:activity_id].gsub(/&\w+;/, '').parameterize
        @act=Activity.find(activity) if !activity.nil?
        @delete=DeletedSchedule.new
        @delete.schedule_id = @act_schedule.schedule_id
        @delete.activity_id = @act_schedule.activity_id
        @delete.schedule_mode = @act_schedule.schedule_mode
        @delete.start_date = @act_schedule.start_date
        @delete.end_date = @act_schedule.end_date
        @delete.start_time = @act_schedule.start_time
        @delete.end_time = @act_schedule.end_time
        @delete.repeat = @act_schedule.repeat
        @delete.business_hours = @act_schedule.business_hours
        @delete.modified_date = @act_schedule.modified_date
        @delete.no_of_participant = @act_schedule.no_of_participant
        @delete.expiration_date= @act_schedule.expiration_date
        @delete.price_type = @act_schedule.price_type
        if @act.price_type=='3'
          @delete.price="Free"
        elsif @act.price_type=='4'
          @delete.price="Contact Provider"
        elsif !@act_price.nil? && @act_price.present? && !@act_price.price.nil? && @act_price.price.present?
          @delete.price=@act_price.price
        else
          @delete.price=@act.price if !@act.price.nil? && @act.price.present?
        end
        @delete.save
        @act_schedule.destroy
        @act_price.destroy if !@act_price.nil? && @act_price.present?
      end #activity_shedule delete end
      @schedulle_cnt=@schedule_value.count
      #sending mail while delete the activity by the multiple schedule.
      activity=params[:activity_id].gsub(/&\w+;/, '').parameterize
      @act=Activity.find(activity) if !activity.nil?
      @activity_user = User.find_by_user_id(@act.user_id) if !@act.nil? && @act.present?
      user=User.find_by_user_id(@act.user_id) if !@act.nil?
      attend_email=user.email_address if !user.email_address.nil?
      user_name=user.user_name if !user.user_name.nil?
      if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
        if @schedulle_cnt > 1  #activity or more schedule delete mail
          @result = UserMailer.delay(queue: "Delete Activity", priority: 2, run_at: 10.seconds.from_now).delete_activity_mail(user,@act,@get_current_url,attend_email)
        elsif @schedulle_cnt ==1 #single schedule delete
          @result = UserMailer.delay(queue: "Delete Activity Schedule", priority: 2, run_at: 10.seconds.from_now).delete_activity_schedule_mail(user,@act,@delete,@get_current_url,attend_email)
        end
      end  if user.present? && !user.nil?
    end  #activity delete end
    respond_to do |format|
      format.js
    end
  end



  def provider_create
    @activity_profile_apf = Activity.new(params[:activity])
    @activity_profile_apf.inserted_date = Time.now
    @activity_profile_apf.modified_date = Time.now
    @activity_profile_apf.tags_txt = params["keyword-tag"].blank? ? "" : params["keyword-tag"]
    #~ @activity_profile_apf.country_code = params[:country_codeval] if params[:country_codeval] && params[:country_codeval]!=""
    #~ @activity_profile_apf.country_id = params[:country_idval] if params[:country_idval] && params[:country_idval]!=""
    @activity_profile_apf.phone_extension = params[:phone_4] if params[:phone_4] && params[:phone_4]!="" && params[:phone_4] !="Ext"
    
    if !params[:activity][:avatar].nil? && params[:activity][:avatar]!=""
      @activity_profile_apf.avatar = params[:activity][:avatar]
    elsif !params[:save_id].nil?
      @act_dup = Activity.find(params[:save_id])
      @activity_profile_apf.avatar = @act_dup.avatar
    end
    if !params[:class_link].nil? && params[:class_link]=="1"
      @activity_profile_apf.camps = true
    end
    if !params[:special_link].nil? && params[:special_link]=="1"
      @activity_profile_apf.special_needs = true
    end
    if params[:url_pasted]=="1"
      unless params[:provider_url][/\Ahttp:\/\//] || params[:provider_url][/\Ahttps:\/\//]
        params[:provider_url] = "http://#{params[:provider_url]}"
      end
      @activity_profile_apf.purchase_url = params[:provider_url]
    end
    @activity_profile_apf.description = params[:redactor_content] if params[:redactor_content] !="Description should not exceed 500 characters"
    @activity_profile_apf.active_status = "Active"
    @activity_profile_apf.gender = params[:gender] if !params[:gender].nil? && params[:gender] != "--Select Gender--"
    if params[:discountElligble]=='on'
      @activity_profile_apf.discount_eligible = params[:ddligprice] if !params[:ddligprice].nil? && params[:ddligprice].present? && params[:ddligprice]!='Eg: 3'
      @activity_profile_apf.discount_type = params[:ddselect] if !params[:ddselect].nil? && params[:ddselect].present?
    end
    #setting page default my activity as active or inactive
    @provider_setting_default=ProviderSettingDetail.find_by_sql("select * from provider_setting_details s left join provider_settings p on s.provider_setting_id=p.provider_setting_id  where  p.user_id='#{current_user.user_id}'") if current_user.present?
    if !@provider_setting_default.nil? && @provider_setting_default.present? && @provider_setting_default!=""
      @provider_setting_default.each do|provider_default|
        if provider_default.setting_action=="default" && provider_default.setting_option=="4"
          @activity_profile_apf.active_status = "Active"
        elsif provider_default.setting_action=="default" && provider_default.setting_option=="5"
          @activity_profile_apf.active_status = "Inactive"
        end if provider_default.present? && provider_default.setting_action.present? && provider_default.setting_option.present?
      end if @provider_setting_default.present? #do end
    else
      @activity_profile_apf.active_status = "Active"
    end
    @activity_profile_apf.contact_price = params[:con_provider]
    @activity_profile_apf.leader = params[:leader] if params[:leader] != "Enter Leader Name"
    @activity_profile_apf.website = params[:website] if params[:website] != "Enter URL"
    @activity_profile_apf.email = params[:email] if params[:email] != "Enter Email"
    @mobile_value = "#{params[:phone_1]}-" +"#{params[:phone_2]}-"+"#{params[:phone_3]}" if !params[:phone_1].nil?
    if @mobile_value !="111-111-1111" && @mobile_value !="xxx-xxx-xxxx"
      @activity_profile_apf.phone = @mobile_value
    end
    #@activity_profile_apf.phone = "#{params[:phone_1]}-" + "#{params[:phone_2]}-" + "#{params[:phone_2]}" if !params[:phone_1].nil?
    #    @activity_profile_apf.no_participants = params[:no_participants] if params[:no_participants] != "Specify Number"
    @activity_profile_apf.address_2 = params[:address_2] if params[:address_2] != "Address Line 2"
    @activity_profile_apf.skill_level = params[:skill_level] if params[:skill_level]!='--Select--'
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
    @activity_profile_apf.state = params[:state]
    #@activity_profile_apf.age_range = params[:age_range] if params[:age_range]!="--Select Age Range--"
    @user = User.find(cookies[:uid_usr])
    @activity_profile_apf.filter_id = 5
    @activity_profile_apf.price = ""
    #price_type ==>1-pric, 2-net price,3-free,4-contact provider
    if params[:price_1] == "1"
      @activity_profile_apf.price_type = 2
      @activity_profile_apf.price = params[:price]
      price_type = 2
    elsif params[:price_2] == "1"
      @activity_profile_apf.price_type = 1
      price_type = 1
    elsif params[:price_3] == "1"
      @activity_profile_apf.price_type = 3
      @activity_profile_apf.filter_id = 3
      price_type = 3
    elsif params[:price_4] == "1"
      @activity_profile_apf.price_type = 4
      price_type = 4
    end
    if params[:addres_anywhere_id] == "2"
      @activity_profile_apf.address_2 = ""
      @activity_profile_apf.address_1 = ""
      @activity_profile_apf.zip_code = ""
      @activity_profile_apf.city = ""
      params[:activity][:address_1] = ""
      params[:address_2] = ""
      params[:activity][:city] = ""
      params[:activity][:schedule_mode] = "Any Where"
      @activity_profile_apf.schedule_mode = "Any Where"
    end
    @activity_profile_apf.note = params[:notes]
    @activity_profile_apf.approve_kid = params[:payment]
    @activity_profile_apf.created_by = "Provider"
    @activity_profile_apf.user_id = cookies[:uid_usr]
    if !params[:activity][:city].nil? && params[:activity][:city]!=""
      city_se = City.where("city_name='#{params[:activity][:city]}'").last
      if !city_se.nil?
        @activity_profile_apf.latitude  = city_se.latitude
        @activity_profile_apf.longitude  = city_se.longitude
      end
    end

    @result_in = @activity_profile_apf.save
    success = @activity_profile_apf && @activity_profile_apf.save
    if success && @activity_profile_apf.errors.empty?
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
                    if !params[:"advance_notes_#{out_div}"].nil? && params[:"advance_notes_#{out_div}"] != "Notes:"
                      @schedule.note = params[:"advance_notes_#{out_div}"]
                      @schedule.save
                    end
                  end
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
        end
        if params[:activity][:schedule_mode] == "By Appointment"
          @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:price_type=>price_type,:no_of_participant=>params[:app_participants],:expiration_date=>"2100-12-31")
          if params[:price_2] == "1"
            price_count =  params[:advance_price_count_anys].split(",").reject(&:empty?)
            price_count.each do |c|
              net_price =  params[:"ad_anytime_price_#{c}_#{c}"]
              no_class = params[:"ad_payment_box_anytime_fst_#{c}_#{c}"]
              payment_period = params[:"ad_payment_#{c}_#{c}"]
              no_hours = params[:"ad_payment_box_anytime_sec_#{c}_#{c}"] if params[:"ad_payment_box_anytime_sec_#{c}_#{c}"]!="Eg: 3"
              @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>@schedule.schedule_id )
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
            @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:price],:activity_schedule_id=>@schedule.schedule_id  )
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
        if params[:activity][:schedule_mode] == "Any Time"
          re = ['mon','tue','wed','thu','fri','sat','sun'].to_a
          re.each do |s|
            if params[:"anytime_closed_#{s}"] !="0"
              params[:"anytime_s#{s}_val"]
              st_time = DateTime.parse("#{params[:"anytime_s#{s}_1"]} #{params[:"anytime_s#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_s#{s}_1"].nil? && !params[:"anytime_s#{s}_2"].nil? && params[:"anytime_s#{s}_1"]!="" && params[:"anytime_s#{s}_2"]!=""
              en_time = DateTime.parse("#{params[:"anytime_e#{s}_1"]} #{params[:"anytime_e#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_e#{s}_1"].nil? && !params[:"anytime_e#{s}_2"].nil? && params[:"anytime_e#{s}_1"]!="" && params[:"anytime_e#{s}_2"]!=""
              @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],
                :start_time=>st_time,:end_time=>en_time,:price_type=>price_type,:business_hours=>"#{s}",:no_of_participant=>params[:anytime_participants],:expiration_date=>"2100-12-31")
            end
          end
          if params[:price_2] == "1"
            price_count =  params[:advance_price_count_anys].split(",").reject(&:empty?)
            price_count.each do |c|
              net_price =  params[:"ad_anytime_price_#{c}_#{c}"]
              no_class = params[:"ad_payment_box_anytime_fst_#{c}_#{c}"]
              payment_period = params[:"ad_payment_#{c}_#{c}"]
              no_hours = params[:"ad_payment_box_anytime_sec_#{c}_#{c}"] if params[:"ad_payment_box_anytime_sec_#{c}_#{c}"]!="Eg: 3"
              @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours )
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
            @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:price] )
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
                      payment_period = params[:"ad_payment_#{in_div}"]
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
                    if !params[:"advance_notes_#{out_div}"].nil? && params[:"advance_notes_#{out_div}"] != "Notes:"
                      @schedule.note = params[:"advance_notes_#{out_div}"]
                      @schedule.save
                    end
                  end
                end
              end
            elsif params[:price_1] == "1"
              multi_discount = params[:total_div_count].split(",")
              multi_discount.each do |t|
                pr_a = t.split("_")
                if params[:"chosen_sc_#{t}"] == wd
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
        end
      end



      if params[:addres_anywhere_id] == "2"
        @activity_profile_apf.activity_schedule.create(:schedule_mode=> "Any Where",:price_type=>price_type,:expiration_date=>"2100-12-31")
        if params[:price_2] == "1"
          price_count =  params[:advance_price_count_anys].split(",").reject(&:empty?)
          price_count.each do |c|
            net_price =  params[:"ad_anytime_price_#{c}_#{c}"]
            no_class = params[:"ad_payment_box_anytime_fst_#{c}_#{c}"]
            payment_period = params[:"ad_payment_#{c}_#{c}"]
            no_hours = params[:"ad_payment_box_anytime_sec_#{c}_#{c}"] if params[:"ad_payment_box_anytime_sec_#{c}_#{c}"]!="Eg: 3"
            @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours )
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
          @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:price] )
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
                if discount_currency.nil?
                  discount_currency = "$"
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
      @activity_profile_apf.save
      @get_current_url = request.env['HTTP_HOST']
      @plan = current_user.user_plan
      render :partial => "provider_create_thank"
    end
    if params[:other_fee_open]=="1"
      add_to_provider_fee(params[:add_other_org],"",@activity_profile_apf.activity_id) if !params[:add_other_org].nil? && params[:add_other_org]!=""
    end
    if params[:discount_code_open] == "1"
      add_to_provider_discount_code(params[:add_otherdiscount_org],"",@activity_profile_apf.activity_id) if !params[:add_otherdiscount_org].nil? && params[:add_otherdiscount_org]!=""
    end
    @created_setting = ProviderSettingDetail.find_by_sql("select p.* from provider_setting_details s left join provider_settings p on s.provider_setting_id=p.provider_setting_id  where s.setting_action='created' and p.user_id=#{current_user.user_id}")
    if !@created_setting.nil? && @created_setting!='' && @created_setting.present?
      #setting_option 1, show to famtiivty everyone
      @created_setting.each do |set_val|
        if set_val["setting_option"] == "1"
          @follow = UserRow.select("distinct user_id").where("row_user_id=#{current_user.user_id} and lower(user_type)='p'")
          @follow_user = User.find_by_user_id(current_user.user_id)
          if !@follow.nil? && @follow!='' && @follow.present?
            @follow.each do |fval|
              #check notification
              @notify_setting_fo = ParentNotificationDetail.find_by_sql("select p.* from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id  where pn.notify_action='2' and lower(pn.notify_status)='active'and p.user_id=#{fval["user_id"]} and p.notify_flag=true")
              if !@notify_setting_fo.nil? && @notify_setting_fo!='' && @notify_setting_fo.present?
                @user_mail = User.find_by_user_id(fval["user_id"])
                if !@user_mail.nil? && @user_mail!='' && @user_mail.present?
                  if @user_mail["user_flag"]== true
                    @net_user_email = @user_mail.email_address
                    @net_user_name = @user_mail.user_name
                    @get_current_url = request.env['HTTP_HOST']
                    @result = UserMailer.delay(queue: "Following User", priority: 2, run_at: 10.seconds.from_now).following_user_mail_provider(@net_user_email,@net_user_name,current_user,@activity_profile_apf,@get_current_url,params[:message],params[:subject])
                  end
                end
              end
            end
          end
        end

        # setting_option 2, famtivity contact user only
        if set_val["setting_option"]=="2"
          @con_user = set_val["contact_user"].split(",")
          @follow = UserRow.select("distinct user_id").where("row_user_id=#{current_user.user_id} and lower(user_type)='p'")
          @follow_user = User.find_by_user_id(current_user.user_id)
          if !@follow.nil? && @follow!='' && @follow.present?
            @follow.each do |fval|
              if @con_user.include?(fval["user_id"])
                #check notification
                @notify_setting_fo = ParentNotificationDetail.find_by_sql("select p.* from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id  where pn.notify_action='2' and lower(pn.notify_status)='active'and p.user_id=#{fval["user_id"]} and p.notify_flag=true")
                if !@notify_setting_fo.nil? && @notify_setting_fo!='' && @notify_setting_fo.present?
                  @user_mail = User.find_by_user_id(fval["user_id"])
                  if !@user_mail.nil? && @user_mail!='' && @user_mail.present?
                    if @user_mail["user_flag"]== true
                      @net_user_email = @user_mail.email_address
                      @net_user_name = @user_mail.user_name
                      @get_current_url = request.env['HTTP_HOST']
                      @result = UserMailer.delay(queue: "Following User", priority: 2, run_at: 10.seconds.from_now).following_user_mail_provider(@net_user_email,@net_user_name,current_user,@activity_profile_apf,@get_current_url,params[:message],params[:subject])
                    end
                  end
                end
              end
            end
          end
        end
      end
    end


if @result_in
	    $dc.set("activity_schedules_for#{@activity_profile_apf.activity_id}",nil)
	    $dc.set("provider_activity_for#{current_user.user_id}",nil)
end


    #notify me when an activity is created for setting page
    @provider_notify_create = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='3' and p.user_id='#{@activity_profile_apf.user_id}' and p.notify_flag=true") if !@activity_profile_apf.nil? && !@activity_profile_apf.user_id.nil?
    if !@provider_notify_create.nil? && @provider_notify_create.present? && @provider_notify_create!=""
      #sending a nofification while created the activity by the provider
      @user=User.find_by_user_id(@activity_profile_apf.user_id) if !@activity_profile_apf.nil? && !@activity_profile_apf.user_id.nil?
      user_email_id=@user.email_address if !@user.email_address.nil? &&  !@user.nil? && @user.user_flag==TRUE
      @result = UserMailer.delay(queue: "Provider Create Activity", priority: 2, run_at: 10.seconds.from_now).provider_create_activity_mail(@user,@activity_profile_apf,user_email_id,params[:subject],@plan,@get_current_url)
    end
  end

  #old Famtivity Code Please add new code above.







  def provider_create_new_changes
    @activity_profile_apf = Activity.new(params[:activity])
    @activity_profile_apf.inserted_date = Time.now
    @activity_profile_apf.modified_date = Time.now
    if !params[:activity][:avatar].nil? && params[:activity][:avatar]!=""
      @activity_profile_apf.avatar = params[:activity][:avatar]
    elsif !params[:save_id].nil?
      @act_dup = Activity.find(params[:save_id])
      @activity_profile_apf.avatar = @act_dup.avatar
    end
    if params[:url_pasted]=="1"
      unless params[:provider_url][/\Ahttp:\/\//] || params[:provider_url][/\Ahttps:\/\//]
        params[:provider_url] = "http://#{params[:provider_url]}"
      end
      @activity_profile_apf.purchase_url = params[:provider_url]
    end
    @activity_profile_apf.description = params[:description] if params[:description] !="Description should not exceed 500 characters"
    @activity_profile_apf.active_status = "Active"
    @activity_profile_apf.gender = params[:gender] if !params[:gender].nil? && params[:gender] != "--Select Gender--"
    if params[:discountElligble]=='on'
      @activity_profile_apf.discount_eligible = params[:ddligprice] if !params[:ddligprice].nil? && params[:ddligprice].present? && params[:ddligprice]!='Eg: 3'
      @activity_profile_apf.discount_type = params[:ddselect] if !params[:ddselect].nil? && params[:ddselect].present?
    end
    #setting page default my activity as active or inactive
    @provider_setting_default=ProviderSettingDetail.find_by_sql("select * from provider_setting_details s left join provider_settings p on s.provider_setting_id=p.provider_setting_id  where  p.user_id='#{current_user.user_id}'") if current_user.present?
    if !@provider_setting_default.nil? && @provider_setting_default.present? && @provider_setting_default!=""
      @provider_setting_default.each do|provider_default|
        if provider_default.setting_action=="default" && provider_default.setting_option=="4"
          @activity_profile_apf.active_status = "Active"
        elsif provider_default.setting_action=="default" && provider_default.setting_option=="5"
          @activity_profile_apf.active_status = "Inactive"
        end if provider_default.present? && provider_default.setting_action.present? && provider_default.setting_option.present?
      end if @provider_setting_default.present? #do end
    else
      @activity_profile_apf.active_status = "Active"
    end
    @activity_profile_apf.contact_price = params[:con_provider]
    @activity_profile_apf.leader = params[:leader] if params[:leader] != "Enter Leader Name"
    @activity_profile_apf.website = params[:website] if params[:website] != "Enter URL"
    @activity_profile_apf.email = params[:email] if params[:email] != "Enter Email"
    @mobile_value = "#{params[:phone_1]}-" +"#{params[:phone_2]}-"+"#{params[:phone_3]}" if !params[:phone_1].nil?
    if @mobile_value !="111-111-1111" && @mobile_value !="xxx-xxx-xxxx"
      @activity_profile_apf.phone = @mobile_value
    end
    #@activity_profile_apf.phone = "#{params[:phone_1]}-" + "#{params[:phone_2]}-" + "#{params[:phone_2]}" if !params[:phone_1].nil?
    #    @activity_profile_apf.no_participants = params[:no_participants] if params[:no_participants] != "Specify Number"
    @activity_profile_apf.address_2 = params[:address_2] if params[:address_2] != "Address Line 2"
    @activity_profile_apf.skill_level = params[:skill_level] if params[:skill_level]!='--Select--'
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
    @activity_profile_apf.state = params[:state]
    #@activity_profile_apf.age_range = params[:age_range] if params[:age_range]!="--Select Age Range--"
    @user = User.find(cookies[:uid_usr])
    @activity_profile_apf.filter_id = 5
    @activity_profile_apf.price = ""
    #price_type ==>1-pric, 2-net price,3-free,4-contact provider
    if params[:price_1] == "1"
      @activity_profile_apf.price_type = 2
      @activity_profile_apf.price = params[:price]
      price_type = 2
    elsif params[:price_2] == "1"
      @activity_profile_apf.price_type = 1
      price_type = 1
    elsif params[:price_3] == "1"
      @activity_profile_apf.price_type = 3
      @activity_profile_apf.filter_id = 3
      price_type = 3
    elsif params[:price_4] == "1"
      @activity_profile_apf.price_type = 4
      price_type = 4
    end
    if params[:addres_anywhere_id] == "2"
      @activity_profile_apf.address_2 = ""
      @activity_profile_apf.address_1 = ""
      @activity_profile_apf.zip_code = ""
      @activity_profile_apf.city = ""
      params[:activity][:address_1] = ""
      params[:address_2] = ""
      params[:activity][:city] = ""
      params[:activity][:schedule_mode] = "Any Where"
      @activity_profile_apf.schedule_mode = "Any Where"
    end
    @activity_profile_apf.note = params[:notes]
    @activity_profile_apf.approve_kid = params[:payment]
    @activity_profile_apf.created_by = "Provider"
    @activity_profile_apf.user_id = cookies[:uid_usr]

    @result_in = @activity_profile_apf.save
    success = @activity_profile_apf && @activity_profile_apf.save
    if success && @activity_profile_apf.errors.empty?
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
                    if !params[:"advance_notes_#{out_div}"].nil? && params[:"advance_notes_#{out_div}"] != "Notes:"
                      @schedule.note = params[:"advance_notes_#{out_div}"]
                      @schedule.save
                    end
                  end
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
        end
        if params[:activity][:schedule_mode] == "By Appointment"
          @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:price_type=>price_type,:no_of_participant=>params[:app_participants],:expiration_date=>"2100-12-31")
          if params[:price_2] == "1"
            price_count =  params[:advance_price_count_anys].split(",").reject(&:empty?)
            price_count.each do |c|
              net_price =  params[:"ad_anytime_price_#{c}_#{c}"]
              no_class = params[:"ad_payment_box_anytime_fst_#{c}_#{c}"]
              payment_period = params[:"ad_payment_#{c}_#{c}"]
              no_hours = params[:"ad_payment_box_anytime_sec_#{c}_#{c}"] if params[:"ad_payment_box_anytime_sec_#{c}_#{c}"]!="Eg: 3"
              @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours,:activity_schedule_id=>@schedule.schedule_id )
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
            @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:price],:activity_schedule_id=>@schedule.schedule_id  )
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
        if params[:activity][:schedule_mode] == "Any Time"
          re = ['mon','tue','wed','thu','fri','sat','sun'].to_a
          re.each do |s|
            if params[:"anytime_closed_#{s}"] !="0"
              params[:"anytime_s#{s}_val"]
              st_time = DateTime.parse("#{params[:"anytime_s#{s}_1"]} #{params[:"anytime_s#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_s#{s}_1"].nil? && !params[:"anytime_s#{s}_2"].nil? && params[:"anytime_s#{s}_1"]!="" && params[:"anytime_s#{s}_2"]!=""
              en_time = DateTime.parse("#{params[:"anytime_e#{s}_1"]} #{params[:"anytime_e#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_e#{s}_1"].nil? && !params[:"anytime_e#{s}_2"].nil? && params[:"anytime_e#{s}_1"]!="" && params[:"anytime_e#{s}_2"]!=""
              @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],
                :start_time=>st_time,:end_time=>en_time,:price_type=>price_type,:business_hours=>"#{s}",:no_of_participant=>params[:anytime_participants],:expiration_date=>"2100-12-31")
            end
          end
          if params[:price_2] == "1"
            price_count =  params[:advance_price_count_anys].split(",").reject(&:empty?)
            price_count.each do |c|
              net_price =  params[:"ad_anytime_price_#{c}_#{c}"]
              no_class = params[:"ad_payment_box_anytime_fst_#{c}_#{c}"]
              payment_period = params[:"ad_payment_#{c}_#{c}"]
              no_hours = params[:"ad_payment_box_anytime_sec_#{c}_#{c}"] if params[:"ad_payment_box_anytime_sec_#{c}_#{c}"]!="Eg: 3"
              @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours )
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
            @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:price] )
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
                      payment_period = params[:"ad_payment_#{in_div}"]
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
                    if !params[:"advance_notes_#{out_div}"].nil? && params[:"advance_notes_#{out_div}"] != "Notes:"
                      @schedule.note = params[:"advance_notes_#{out_div}"]
                      @schedule.save
                    end
                  end
                end
              end
            elsif params[:price_1] == "1"
              multi_discount = params[:total_div_count].split(",")
              multi_discount.each do |t|
                pr_a = t.split("_")
                if params[:"chosen_sc_#{t}"] == wd
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
        end
      end



      if params[:addres_anywhere_id] == "2"
        @activity_profile_apf.activity_schedule.create(:schedule_mode=> "Any Where",:price_type=>price_type,:expiration_date=>"2100-12-31")
        if params[:price_2] == "1"
          price_count =  params[:advance_price_count_anys].split(",").reject(&:empty?)
          price_count.each do |c|
            net_price =  params[:"ad_anytime_price_#{c}_#{c}"]
            no_class = params[:"ad_payment_box_anytime_fst_#{c}_#{c}"]
            payment_period = params[:"ad_payment_#{c}_#{c}"]
            no_hours = params[:"ad_payment_box_anytime_sec_#{c}_#{c}"] if params[:"ad_payment_box_anytime_sec_#{c}_#{c}"]!="Eg: 3"
            @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours )
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
          @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:price] )
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
      
      @get_current_url = request.env['HTTP_HOST']
      @plan = current_user.user_plan
      render :partial => "provider_create_thank"
    end
    if params[:other_fee_open]=="1"
      add_to_provider_fee(params[:add_other_org],"",@activity_profile_apf.activity_id) if !params[:add_other_org].nil? && params[:add_other_org]!=""
    end
    if params[:discount_code_open] == "1"
      add_to_provider_discount_code(params[:add_otherdiscount_org],"",@activity_profile_apf.activity_id) if !params[:add_otherdiscount_org].nil? && params[:add_otherdiscount_org]!=""
    end
    @created_setting = ProviderSettingDetail.find_by_sql("select p.* from provider_setting_details s left join provider_settings p on s.provider_setting_id=p.provider_setting_id  where s.setting_action='created' and p.user_id=#{current_user.user_id}")
    if !@created_setting.nil? && @created_setting!='' && @created_setting.present?
      #setting_option 1, show to famtiivty everyone
      @created_setting.each do |set_val|
        if set_val["setting_option"] == "1"
          @follow = UserRow.select("distinct user_id").where("row_user_id=#{current_user.user_id} and lower(user_type)='p'")
          @follow_user = User.find_by_user_id(current_user.user_id)
          if !@follow.nil? && @follow!='' && @follow.present?
            @follow.each do |fval|
              #check notification
              @notify_setting_fo = ParentNotificationDetail.find_by_sql("select p.* from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id  where pn.notify_action='2' and lower(pn.notify_status)='active'and p.user_id=#{fval["user_id"]} and p.notify_flag=true")
              if !@notify_setting_fo.nil? && @notify_setting_fo!='' && @notify_setting_fo.present?
                @user_mail = User.find_by_user_id(fval["user_id"])
                if !@user_mail.nil? && @user_mail!='' && @user_mail.present?
                  if @user_mail["user_flag"]== true
                    @net_user_email = @user_mail.email_address
                    @net_user_name = @user_mail.user_name
                    @get_current_url = request.env['HTTP_HOST']
                    @result = UserMailer.delay(queue: "Following User", priority: 2, run_at: 10.seconds.from_now).following_user_mail_provider(@net_user_email,@net_user_name,current_user,@activity_profile_apf,@get_current_url,params[:message],params[:subject])
                  end
                end
              end
            end
          end
        end

        # setting_option 2, famtivity contact user only
        if set_val["setting_option"]=="2"
          @con_user = set_val["contact_user"].split(",")
          @follow = UserRow.select("distinct user_id").where("row_user_id=#{current_user.user_id} and lower(user_type)='p'")
          @follow_user = User.find_by_user_id(current_user.user_id)
          if !@follow.nil? && @follow!='' && @follow.present?
            @follow.each do |fval|
              if @con_user.include?(fval["user_id"])
                #check notification
                @notify_setting_fo = ParentNotificationDetail.find_by_sql("select p.* from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id  where pn.notify_action='2' and lower(pn.notify_status)='active'and p.user_id=#{fval["user_id"]} and p.notify_flag=true")
                if !@notify_setting_fo.nil? && @notify_setting_fo!='' && @notify_setting_fo.present?
                  @user_mail = User.find_by_user_id(fval["user_id"])
                  if !@user_mail.nil? && @user_mail!='' && @user_mail.present?
                    if @user_mail["user_flag"]== true
                      @net_user_email = @user_mail.email_address
                      @net_user_name = @user_mail.user_name
                      @get_current_url = request.env['HTTP_HOST']
                      @result = UserMailer.delay(queue: "Following User", priority: 2, run_at: 10.seconds.from_now).following_user_mail_provider(@net_user_email,@net_user_name,current_user,@activity_profile_apf,@get_current_url,params[:message],params[:subject])
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    #notify me when an activity is created for setting page
    @provider_notify_create = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='3' and p.user_id='#{@activity_profile_apf.user_id}' and p.notify_flag=true") if !@activity_profile_apf.nil? && !@activity_profile_apf.user_id.nil?
    if !@provider_notify_create.nil? && @provider_notify_create.present? && @provider_notify_create!=""
      #sending a nofification while created the activity by the provider
      @user=User.find_by_user_id(@activity_profile_apf.user_id) if !@activity_profile_apf.nil? && !@activity_profile_apf.user_id.nil?
      user_email_id=@user.email_address if !@user.email_address.nil? &&  !@user.nil? && @user.user_flag==TRUE
      @result = UserMailer.delay(queue: "Provider Create Activity", priority: 2, run_at: 10.seconds.from_now).provider_create_activity_mail(@user,@activity_profile_apf,user_email_id,params[:subject],@plan,@get_current_url)
    end
  end

  #old Famtivity Code Please add new code above.

  #to get activities detail by date wise used by amar to collect the data entering
  def act_date

  end
  
  def schedule_price_detail
    
  end
  
  #get the count for basic search
  def basic_search_count
    @search = Sunspot.search(Activity,User) do
      keywords params[:event_search] do
        #query_phrase_slop 1
        minimum_match 1
        fields(:city=>10,:user_profile_name=>9,:activity_name =>8)
      end
      with :cleaned,true
      with(:active_status, "Active")
      order_by :score, :desc
      with :show_card,true
	
    end
    render :text=>@search.total
  end
  
  def update_shared
    @activity_featured = Activity.all(:limit => 5)

    render :partial => "update_shared", :locals => { :states => @activity_featured }
  end
  
  def update_index
    @activity_featured = Activity.all(:limit => 2)

    render :partial => "act_index", :locals => { :states => @activity_featured }
  end
  
  def activities_index
    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT lower(trim(category))as category")
  end

  def activity_create_index_new
    #@cities = ["Chicago","Dallas","Detroit","Houston","Las Vegas","Los Angeles","New York","Philadelphia","San Antonio","San Francisco","San Jose","Seattle","Walnut Creek"]
    @cities = City.order("city_name Asc").all.map(&:city_name)
    @pro_fees = ProviderActivityFeeType.where("user_id=#{current_user.user_id}")
    @pro_discount_fees = ProviderDiscountCodeType.where("user_id=#{current_user.user_id}")
    @previous_tags = Activity.where(:created_by => "Provider", :cleaned => true, :user_id => current_user.user_id).map {|activity| activity.tags_txt.split(",") if !activity.nil? && !activity.tags_txt.nil? }.compact.flatten.uniq
    #~ @country_code = Country.where("country_id = ?",1)
  end

  #Autocomplete data populate
  def activity_tags
    @previous_tags = Activity.where(:created_by => "Provider", :cleaned => true, :user_id => current_user.user_id).map {|activity| activity.tags_txt.split(",") if !activity.nil? && !activity.tags_txt.nil? }.compact.flatten.uniq
    @default_tags = GeneralTag.all
    @arr = []
    params[:term] = params[:term].blank? ? "" : params[:term]
    !@previous_tags.blank? && @previous_tags.each do |tag|
      if(!params[:term].blank? && !tag.downcase.scan(params[:term].downcase).blank?)
        @arr << {"id" => current_user.user_id,"label" => tag,"value" => tag}
      end
    end
    !@default_tags.blank? && @default_tags.each do |tag|
      if(!params[:term].blank? && !tag.tag_name.downcase.scan(params[:term].downcase).blank?)
        @arr << {"id" => tag.tag_id,"label" => tag.tag_name,"value" => tag.tag_name}
      end
    end
    render :json => @arr
  end
  
  # success message for create and edit activity
  def new_success_page
    if params[:act]=="user_add"
      @msg="user_add"
    elsif params[:act]=="user_edit"
      @msg="user_edit"
    elsif params[:act]=="edit"
      @attend_rep = ActivityAttendDetail.where("activity_id = #{params[:act_id]}")
      @school_rep = SchoolRepresentative.where("activity_id = #{params[:act_id]}")
      @manager = ActivityNetworkPermission.where("activity_id = #{params[:act_id]}")
      @msg="edit"
    elsif params[:act]=="save_copy"
      @msg="save_copy"
    else
      @msg="You have successfully created your activity!"
    end
  end
  
  
  
  def provider_create_test
    @activity_profile_apf = Activity.new(params[:activity])
    @activity_profile_apf.inserted_date = Time.now
    @activity_profile_apf.modified_date = Time.now
    if !params[:photo].nil? && params[:photo]!=""
      @activity_profile_apf.avatar = params[:photo]
    elsif !params[:save_id].nil?
      @act_dup = Activity.find(params[:save_id])
      @activity_profile_apf.avatar = @act_dup.avatar
    end
    @activity_profile_apf.description = params[:description] if params[:description] !="Description should not exceed 500 characters"
    @activity_profile_apf.active_status = "Active"
    @activity_profile_apf.gender = params[:gender] if !params[:gender].nil? && params[:gender] != "--Select Gender--"
    if params[:discountElligble]=='on'
      @activity_profile_apf.discount_eligible = params[:ddligprice] if !params[:ddligprice].nil? && params[:ddligprice].present? && params[:ddligprice]!='Eg: 3'
      @activity_profile_apf.discount_type = params[:ddselect] if !params[:ddselect].nil? && params[:ddselect].present?
    end
    #setting page default my activity as active or inactive
    @provider_setting_default=ProviderSettingDetail.find_by_sql("select * from provider_setting_details s left join provider_settings p on s.provider_setting_id=p.provider_setting_id  where  p.user_id='#{current_user.user_id}'") if current_user.present?
    if !@provider_setting_default.nil? && @provider_setting_default.present? && @provider_setting_default!=""
      @provider_setting_default.each do|provider_default|
        if provider_default.setting_action=="default" && provider_default.setting_option=="4"
          @activity_profile_apf.active_status = "Active"
        elsif provider_default.setting_action=="default" && provider_default.setting_option=="5"
          @activity_profile_apf.active_status = "Inactive"
        end if provider_default.present? && provider_default.setting_action.present? && provider_default.setting_option.present?
      end if @provider_setting_default.present? #do end
    else
      @activity_profile_apf.active_status = "Active"
    end
    @activity_profile_apf.contact_price = params[:con_provider]
    @activity_profile_apf.leader = params[:leader] if params[:leader] != "Enter Leader Name"
    @activity_profile_apf.website = params[:website] if params[:website] != "Enter URL"
    @activity_profile_apf.email = params[:email] if params[:email] != "Enter Email"
    @mobile_value = "#{params[:phone_1]}-" +"#{params[:phone_2]}-"+"#{params[:phone_3]}" if !params[:phone_1].nil?
    if @mobile_value !="xxx-xxx-xxxx"
      @activity_profile_apf.phone = @mobile_value
    end
    #@activity_profile_apf.phone = "#{params[:phone_1]}-" + "#{params[:phone_2]}-" + "#{params[:phone_2]}" if !params[:phone_1].nil?
    @activity_profile_apf.no_participants = params[:no_participants] if params[:no_participants] != "Specify Number"
    @activity_profile_apf.address_2 = params[:address_2] if params[:address_2] != "Address Line 2"
    @activity_profile_apf.skill_level = params[:skill_level] if params[:skill_level]!='--Select--'
    @activity_profile_apf.min_age_range = params[:age1]
    @activity_profile_apf.max_age_range = params[:age2]
    @activity_profile_apf.state = params[:state]
    #@activity_profile_apf.age_range = params[:age_range] if params[:age_range]!="--Select Age Range--"
    @user = User.find(cookies[:uid_usr])
    @activity_profile_apf.filter_id = 5
    @activity_profile_apf.price = ""
    #price_type ==>1-pric, 2-net price,3-free,4-contact provider
    if params[:price_1] == "1"
      @activity_profile_apf.price_type = 2
      @activity_profile_apf.price = params[:price]
    elsif params[:price_2] == "1"
      @activity_profile_apf.price_type = 1
    elsif params[:price_3] == "1"
      @activity_profile_apf.price_type = 3
      @activity_profile_apf.filter_id = 3
    elsif params[:price_4] == "1"
      @activity_profile_apf.price_type = 4
    end
    @activity_profile_apf.note = params[:notes]
    @activity_profile_apf.approve_kid = params[:payment]
    @activity_profile_apf.created_by = "Provider"
    @activity_profile_apf.user_id = cookies[:uid_usr]
    @result_in = @activity_profile_apf.save
    success = @activity_profile_apf && @activity_profile_apf.save
    if success && @activity_profile_apf.errors.empty?
      if params[:activity][:schedule_mode] == "Schedule"
        @date_split = params[:date_total].split(',') if !params[:date_total].nil?
        @date_split.each do |s|
          st_time = DateTime.parse("#{params[:schedule_stime_1]} #{params[:schedule_stime_2]}").strftime("%H:%M:%S") if !params[:schedule_stime_1].nil? && !params[:schedule_stime_2].nil? && params[:schedule_stime_1]!="" && params[:schedule_stime_1]!=""
          en_time = DateTime.parse("#{params[:schedule_etime_1]} #{params[:schedule_etime_2]}").strftime("%H:%M:%S") if !params[:schedule_etime_1].nil? && !params[:schedule_etime_2].nil? && params[:schedule_etime_1]!="" && params[:schedule_etime_2]!=""
          @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:date_1],
            :end_date=>params[:date_2],:start_time=>st_time,:end_time=>en_time)
        end
        @schedule.activity_repeat.create(:repeat_every => params[:repeatNumWeekVal],
          :ends_never=>params[:r1],:end_occurences=>params[:after_occ],
          :ends_on=>params[:repeat_alt_on_date1],:starts_on=>params[:date_1],:repeated_by_month=>params[:month1],:repeat_on=>params[:repeat_no_of_days],:repeats=>params[:repeatWeekVal]) if params[:repeatCheck]=="yes"
      end
      if params[:activity][:schedule_mode] == "By Appointment"
        st_time = DateTime.parse("#{params[:appointment_stime_1]} #{params[:appointment_stime_2]}").strftime("%H:%M:%S") if !params[:appointment_stime_1].nil? && !params[:appointment_stime_2].nil? && params[:appointment_stime_1]!="" && params[:appointment_stime_2]!=""
        en_time = DateTime.parse("#{params[:appointment_etime_1]} #{params[:appointment_etime_2]}").strftime("%H:%M:%S") if !params[:appointment_etime_1].nil? && !params[:appointment_etime_2].nil? && params[:appointment_etime_1]!="" && params[:appointment_etime_2]!=""
        @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:datebill_1],
          :end_date=>"",:start_time=>st_time,:end_time=>en_time)
      end
      if params[:activity][:schedule_mode] == "Any Time"
        re = ['mon','tue','wed','thu','fri','sat','sun'].to_a
        re.each do |s|
          if params[:"anytime_closed_#{s}"] !="0"
            params[:"anytime_s#{s}_val"]
            st_time = DateTime.parse("#{params[:"anytime_s#{s}_1"]} #{params[:"anytime_s#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_s#{s}_1"].nil? && !params[:"anytime_s#{s}_2"].nil? && params[:"anytime_s#{s}_1"]!="" && params[:"anytime_s#{s}_2"]!=""
            en_time = DateTime.parse("#{params[:"anytime_e#{s}_1"]} #{params[:"anytime_e#{s}_2"]}").strftime("%H:%M:%S") if !params[:"anytime_e#{s}_1"].nil? && !params[:"anytime_e#{s}_2"].nil? && params[:"anytime_e#{s}_1"]!="" && params[:"anytime_e#{s}_2"]!=""
            @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>"",
              :end_date=>"",:start_time=>st_time,:end_time=>en_time,:business_hours=>"#{s}")
          end
        end
      end
      if params[:activity][:schedule_mode] == "Camps/Workshop" || params[:activity][:schedule_mode] == "Whole Day"
        if params[:wday_1] =="1"
          st_time = DateTime.parse("#{params[:whole_stime_1]} #{params[:whole_stime_2]}").strftime("%H:%M:%S") if !params[:whole_stime_1].nil? && !params[:whole_stime_2].nil? && params[:whole_stime_1]!="" && params[:whole_stime_2]!=""
          en_time = DateTime.parse("#{params[:whole_etime_1]} #{params[:whole_etime_2]}").strftime("%H:%M:%S") if !params[:whole_etime_1].nil? && !params[:whole_etime_2].nil? && params[:whole_etime_1]!="" && params[:whole_etime_2]!=""
          @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:datestartwhole_alt_1],
            :end_date=>"",:start_time=>st_time,:end_time=>en_time)
        end
        if params[:wday_2] =="1"
          st_time = DateTime.parse("#{params[:camps_stime_1]} #{params[:camps_stime_2]}").strftime("%H:%M:%S") if !params[:camps_stime_1].nil? && !params[:camps_stime_2].nil? && params[:camps_stime_1]!="" && params[:camps_stime_2]!=""
          en_time = DateTime.parse("#{params[:camps_etime_1]} #{params[:camps_etime_2]}").strftime("%H:%M:%S") if !params[:camps_etime_1].nil? && !params[:camps_etime_2].nil? && params[:camps_etime_1]!="" && params[:camps_etime_2]!=""
          @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:datestcamps_1],
            :end_date=>params[:dateencamps_2],:start_time=>st_time,:end_time=>en_time)
        end
      end
      if params[:activity][:schedule_mode] == "Any Day"
        @activity_profile_apf.activity_schedule.create(:schedule_mode=> params[:activity][:schedule_mode],:start_date=>params[:datestcamps_1],
          :end_date=>params[:dateencamps_2],:start_time=>"",:end_time=>"")
      end
      if params[:price_2] == "1"
        price_count =  params[:advance_price_count].split(",").reject(&:empty?)
        price_count.each do |c|
          net_price =  params[:"ad_price_1_#{c}"]
          no_class = params[:"ad_payment_box_fst_1_#{c}"]
          payment_period = params[:"ad_payment_1_#{c}"]
          no_hours = params[:"ad_payment_box_sec_1_#{c}"] if params[:"ad_payment_box_sec_1_#{c}"]!="Eg: 3"
          @activity_price = @activity_profile_apf.activity_price.create( :price=>net_price,:payment_period=>payment_period,:no_of_class=>no_class,:no_of_hour =>no_hours )
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

      elsif params[:price_1] == "1"
        c="1"
        multi_discount = params[:"multiple_discount_count_net_#{c}_#{c}"].split(",")
        @ss = multi_discount.count
        if multi_discount.count > 0
          @activity_price = @activity_profile_apf.activity_price.create( :price=>params[:price] )
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
      
      end
      @get_current_url = request.env['HTTP_HOST']
      @plan = current_user.user_plan
      render :partial => "provider_create_thank"
      #session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
      #@act_type =params[:act_type]
      #if !@act_type.nil? && @act_type.present? && @act_type=="provider_activites"
      #    act_free = Activity.find_by_sql("select * from activities where user_id=#{current_user.user_id} and cleaned=true and lower(active_status)='active' and lower(created_by)='provider' order by activity_id desc limit 200") if !current_user.nil? && current_user.present?
      #    @activities = act_free.paginate(:page => params[:page], :per_page =>60)
      #else
      #    act = Activity.order("activity_id desc").find(:all,:conditions=>["created_by = ? and user_id = ? and lower(active_status) != ? and cleaned = true ","Provider",cookies[:uid_usr], "delete"])
      #    @activities = act.paginate(:page => params[:page], :per_page =>10)
      #end
      #respond_to do |format|
      #    format.js
      #end
      #  if (current_user.user_plan == "sponsor" ||current_user.user_plan == "sell") && @activity_profile_apf.created_by=="Provider"
      #    render :partial => "create_act_bid_thank"
      #  else
      #    render :partial => "provider_create_thank"
      #  end
    end

    #send a mail while parent following me while creating activity
    #    @provider_setting_notify=ProviderSettingDetail.find_by_sql("select * from provider_setting_details s left join provider_settings p on s.provider_setting_id=p.provider_setting_id  where  p.user_id=#{current_user.user_id}") if !current_user.nil?
    #    @provider_setting_notify.each do |provider_notify|
    #      #<!--provider setting option is Every one-->
    #			if provider_notify.setting_action=="created" && provider_notify.setting_option=="1"
    #        @act_row_provider_page = "created"
    #			elsif provider_notify.setting_action=="created" && provider_notify.setting_option=="3"
    #				if provider_notify.setting_action=="created" && provider_notify.setting_option=="3"
    #					if current_user.user_id.to_i==provider_notify.user_id.to_i
    #            @act_row_provider_page = "created"
    #            @justme="justme"
    #					end
    #				end
    #			elsif provider_notify.setting_action=="created" && provider_notify.setting_option=="2"
    #				if provider_notify.setting_action=="created" && provider_notify.setting_option=="2" && !provider_notify.contact_user.nil?
    #          @famtivity_contact=provider_notify.contact_user.split(',')
    #          @act_row_provider_page = "created"
    #          @contact="contact"
    #				end#<!--if provider notify end-->
    #      end#<!--setting condition if end-->
    #    end #do end
    #
    #    if !@famtivity_contact.nil? && @famtivity_contact.present?
    #      @famtivity_contact.each do |fval|
    #        @user_mail = User.find_by_user_id(fval) if !fval.nil?
    #        @net_user_email = @user_mail.email_address
    #        @net_user_name = @user_mail.user_name
    #        @get_current_url = request.env['HTTP_HOST']
    #        @notify_setting_fo = ParentNotificationDetail.find_by_sql("select p.* from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id  where pn.notify_action='2' and lower(pn.notify_status)='active'and p.user_id=#{fval} and p.notify_flag=true")
    #        if !@notify_setting_fo.nil? && @notify_setting_fo!='' && @notify_setting_fo.present?
    #          if !@user_mail.nil? && @user_mail!='' && @user_mail.present?
    #            if @user_mail.user_flag== true
    #              @result = UserMailer.delay(queue: "Following User", priority: 2, run_at: 10.seconds.from_now).following_user_mail_provider(@net_user_email,@net_user_name,current_user,@activity_profile_apf,@get_current_url,params[:message],params[:subject])
    #              #@result = UserMailer.following_user_create_mail(@user_mail ,@follow_user,@activity_profile_apf,@get_current_url,params[:message],@user_mail.email_address,params[:subject]).deliver
    #            end
    #          end
    #        end
    #      end
    #    end
    @created_setting = ProviderSettingDetail.find_by_sql("select p.* from provider_setting_details s left join provider_settings p on s.provider_setting_id=p.provider_setting_id  where s.setting_action='created' and p.user_id=#{current_user.user_id}")
    if !@created_setting.nil? && @created_setting!='' && @created_setting.present?
      #setting_option 1, show to famtiivty everyone
      @created_setting.each do |set_val|
        if set_val["setting_option"] == "1"
          @follow = UserRow.select("distinct user_id").where("row_user_id=#{current_user.user_id} and lower(user_type)='p'")
          @follow_user = User.find_by_user_id(current_user.user_id)
          if !@follow.nil? && @follow!='' && @follow.present?
            @follow.each do |fval|
              #check notification
              @notify_setting_fo = ParentNotificationDetail.find_by_sql("select p.* from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id  where pn.notify_action='2' and lower(pn.notify_status)='active'and p.user_id=#{fval["user_id"]} and p.notify_flag=true")
              if !@notify_setting_fo.nil? && @notify_setting_fo!='' && @notify_setting_fo.present?
                @user_mail = User.find_by_user_id(fval["user_id"])
                if !@user_mail.nil? && @user_mail!='' && @user_mail.present?
                  if @user_mail["user_flag"]== true
                    @net_user_email = @user_mail.email_address
                    @net_user_name = @user_mail.user_name
                    @get_current_url = request.env['HTTP_HOST']
                    @result = UserMailer.delay(queue: "Following User", priority: 2, run_at: 10.seconds.from_now).following_user_mail_provider(@net_user_email,@net_user_name,current_user,@activity_profile_apf,@get_current_url,params[:message],params[:subject])
                  end
                end
              end
            end
          end
        end
    
        # setting_option 2, famtivity contact user only
        if set_val["setting_option"]=="2"
          @con_user = set_val["contact_user"].split(",")
          @follow = UserRow.select("distinct user_id").where("row_user_id=#{current_user.user_id} and lower(user_type)='p'")
          @follow_user = User.find_by_user_id(current_user.user_id)
          if !@follow.nil? && @follow!='' && @follow.present?
            @follow.each do |fval|
              if @con_user.include?(fval["user_id"])
                #check notification
                @notify_setting_fo = ParentNotificationDetail.find_by_sql("select p.* from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id  where pn.notify_action='2' and lower(pn.notify_status)='active'and p.user_id=#{fval["user_id"]} and p.notify_flag=true")
                if !@notify_setting_fo.nil? && @notify_setting_fo!='' && @notify_setting_fo.present?
                  @user_mail = User.find_by_user_id(fval["user_id"])
                  if !@user_mail.nil? && @user_mail!='' && @user_mail.present?
                    if @user_mail["user_flag"]== true
                      @net_user_email = @user_mail.email_address
                      @net_user_name = @user_mail.user_name
                      @get_current_url = request.env['HTTP_HOST']
                      @result = UserMailer.delay(queue: "Following User", priority: 2, run_at: 10.seconds.from_now).following_user_mail_provider(@net_user_email,@net_user_name,current_user,@activity_profile_apf,@get_current_url,params[:message],params[:subject])
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    #parent follow users
    #@follow_provider_user = UserRow.where("user_id=#{current_user.user_id} and user_type='U'").map(&:row_user_id)
    #    @follow_provider_user = UserRow.select("distinct user_id").where("row_user_id=#{current_user.user_id} and lower(user_type)='p'")
    #    if !@act_row_provider_page.nil? && @justme!="justme" && @contact!="contact"
    #      if !@follow_provider_user.nil? && @follow_provider_user!='' && @follow_provider_user.present?
    #        @follow_provider_user.each do |fval|
    #          @user_mail = User.find_by_user_id(fval["user_id"]) if !fval.nil?
    #          @net_user_email = @user_mail.email_address
    #          @net_user_name = @user_mail.user_name
    #          @get_current_url = request.env['HTTP_HOST']
    #          @notify_setting_fo = ParentNotificationDetail.find_by_sql("select p.* from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id  where pn.notify_action='2' and lower(pn.notify_status)='active'and p.user_id=#{fval["user_id"]} and p.notify_flag=true")
    #          if !@notify_setting_fo.nil? && @notify_setting_fo!='' && @notify_setting_fo.present?
    #            if !@user_mail.nil? && @user_mail!='' && @user_mail.present?
    #              if @user_mail.user_flag== true
    #                @result = UserMailer.delay(queue: "Following User", priority: 2, run_at: 10.seconds.from_now).following_user_mail_provider(@net_user_email,@net_user_name,current_user,@activity_profile_apf,@get_current_url,params[:message],params[:subject])
    #                #@result = UserMailer.following_user_create_mail(@user_mail ,@follow_user,@activity_profile_apf,@get_current_url,params[:message],@user_mail.email_address,params[:subject]).deliver
    #              end
    #            end
    #          end
    #        end
    #      end
    #    end

    #notify me when an activity is created for setting page
    @provider_notify_create = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='3' and p.user_id='#{@activity_profile_apf.user_id}' and p.notify_flag=true") if !@activity_profile_apf.nil? && !@activity_profile_apf.user_id.nil?
    if !@provider_notify_create.nil? && @provider_notify_create.present? && @provider_notify_create!=""
      #sending a nofification while created the activity by the provider
      @user=User.find_by_user_id(@activity_profile_apf.user_id) if !@activity_profile_apf.nil? && !@activity_profile_apf.user_id.nil?
      user_email_id=@user.email_address if !@user.email_address.nil? &&  !@user.nil? && @user.user_flag==TRUE
      @result = UserMailer.delay(queue: "Provider Create Activity", priority: 2, run_at: 10.seconds.from_now).provider_create_activity_mail(@user,@activity_profile_apf,user_email_id,params[:subject],@plan,@get_current_url)
      # @result = UserMailer.provider_create_activity_mail(@user,@activity_profile_apf,user_email_id,params[:subject]).deliver
    end
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
  
  #advance seach for provider page
  def provider_advance_search
    params[:search_user_id]
    @get_current_url = request.env['HTTP_HOST']
    #profile image changes
    if !current_user.nil? && !current_user.user_profile.nil?
      @profile_data=current_user.user_profile if !current_user.user_profile.nil?
      #~ ref  @pf1=FastImage.size("http://54.243.133.232:3002/system/profiles/7/thumb/business1_20130223-4128-1t69efx.jpg")
      @aa='$image_global_path'+@profile_data.profile.url(:thumb)
      @profile_ig=FastImage.size(@aa)
      @p_f = @aa if @profile_ig!="" && !@profile_ig.nil?
    end
	 
    arr = []
    date_range = ''
    selected_date = 'no'
    @condition_all = ''
   
    params[:d_mile]
    params[:d_r]
   
    #storing the selected values in array for activity type
    day_of_the_week=[]
    (1..7).each do |s|
      day_of_the_week<<params["day_of_week_#{s}"] if params["day_of_week_#{s}"] && params["day_of_week_#{s}"]!="" && params["day_of_week_#{s}"]!=nil
    end
   
    #storing the selected values in array for activity type
    @activity_type=[]
    (1..5).each do |s|
      @activity_type<<params["sch_#{s}"] if params["sch_#{s}"] && params["sch_#{s}"]!="" && params["sch_#{s}"]!=nil
    end
    
    @category = params[:ad_sub_category].split(",") if params[:ad_sub_category]!="" && !params[:ad_sub_category].nil?
    @zipcode = params[:z_c] if params[:z_c] !="Enter Zip Code" && params[:z_c]!="" && params[:z_c]!=nil && params[:z_c]
    @city = params[:city_1] if params[:city_1] !="" && params[:city_1]!=nil && params[:city_1]
    @gender = params[:gender]  if !params[:gender].nil? && params[:gender]!=''

    #create the array for age_range values
    age_range = []
    
    if params[:a_all] && params[:a_all]!="" && params[:a_all]!=nil
      age_range<<params[:a_all]
    end
    if params[:a_r10] && params[:a_r10]!="" && params[:a_r10]!=nil
      age_range<<params[:a_r10]
    end
    if params[:a_r1] && params[:a_r1]!="" && params[:a_r1]!=nil
      age_range<<params[:a_r1]
    end
    if params[:a_r13] && params[:a_r13]!="" && params[:a_r13]!=nil
      age_range<<params[:a_r13]
    end
    if params[:a_r4] && params[:a_r4]!="" && params[:a_r4]!=nil
      age_range<<params[:a_r4]
    end
    if params[:a_r15] && params[:a_r15]!="" && params[:a_r15]!=nil
      age_range<<params[:a_r15]
    end
    if params[:a_r7] && params[:a_r7]!="" && params[:a_r7]!=nil
      age_range<<params[:a_r7]
    end
    
    @condition1=''
    @condition2=''
    @condition3=''
    @condition4=''
    @condition5=''
    @condition6=''
    @condition7=''
    @i = 0
    @c = 0
    @z = 0
    @ct = 0
    @p = 0
    @ag = 0

    if !@activity_type.include?('all')
      @activity_type.each do |val|
        if @i == 0
          @condition1.concat("lower(activities.schedule_mode)  = '#{val.downcase.strip}'")  if val != 0 and val != nil and val != "" and val.downcase!='all'
        else
          @condition1.concat(" or lower(activities.schedule_mode)  = '#{val.downcase.strip}'")  if val != 0 and val != nil and val != "" and val.downcase!='all'
        end
        @i = @i +1
      end if !@activity_type.nil?
    end
   
    @category.each do |val|
      if @c == 0
        @condition2.concat("lower(sub_category) = '#{val.downcase.strip}'") if val != 0 and val != nil and val != "" && val.present? && !val.nil?
        @c = @c +1 if val != 0 and val != nil and val != "" && val.present? && !val.nil?
      else
        @condition2.concat(" or lower(sub_category) = '#{val.downcase.strip}'")  if val != 0 and val != nil and val != "" && val.present? && !val.nil?
        @c = @c +1 if val != 0 and val != nil and val != "" && val.present? && !val.nil?
      end
     
    end if !@category.nil? && @category!="" && @category.any? && @category.present? && @category!=""
   
    if params[:z_c] !="" && params[:z_c]!=nil && params[:z_c] && params[:z_c]!="Enter Zip Code"
      @condition3 = ("lower(zip_code) = '#{params[:z_c].downcase.strip}'")
    end
	
    if params[:city_1] !="" && params[:city_1]!=nil && params[:city_1]
      @condition4 = ("lower(city) = '#{params[:city_1].downcase.strip}'") if params[:city_1] !="" && params[:city_1]!=nil && params[:city_1]
    end
    
    if !params[:gender].nil? && params[:gender]!='' && params[:gender]!="g_all"
      @condition5=("lower(gender) = '#{params[:gender].downcase}'") if !params[:gender].nil? && params[:gender]!='' && params[:gender]!="g_all" && params[:gender]!=0
    end
   
    if params[:a_f]!="" && params[:a_f]=="free" && params[:a_f]!=nil &&  params[:a_f].present? && params[:a_f]!="p_all"
      if  params[:a_f] == "free"
        @condition6=("price_type = '3'")
      end
    end
   
    if params[:paid]!="" && params[:paid]=="paid" && params[:paid]!=nil && params[:paid].present? && params[:paid]!="p_all"
      if  params[:paid] == "paid"
        @condition6=("price_type='1' or price_type='2'")
      end
    end
  
    #~ if !age_range.include?('a_all')
    #~ age_range.each do |val|
    #~ if @ag == 0
    #~ @condition7.concat("lower(age_range) = '#{val.downcase}'") if val != 0 and val != nil and val !='' and val.downcase != "a_all"
    #~ else
    #~ @condition7.concat(" or lower(age_range) = '#{val.downcase}'") if val != 0 and val != nil and val !='' and val.downcase != "a_all"
    #~ end
    #~ @ag= @ag +1
    #~ end if !age_range.nil?
    #~ end
    
    if !age_range.include?('a_all')
      age_range.each do |val|
        if @ag == 0
          if val != 0 and val != nil and val !='' and val.downcase != "a_all"
            if val.downcase == 'adults'
              @condition7.concat("(lower(min_age_range) = '#{val.downcase}' or lower(max_age_range)= '#{val.downcase}')")
            else
              #split age range
              str_a = val.split("-")
              @condition7.concat("(lower(min_age_range) = '#{str_a[0]}' or lower(max_age_range) <= '#{str_a[1]}')")
            end
          end
        else
          if val != 0 and val != nil and val !='' and val.downcase != "a_all"
            if val.downcase == 'adults'
              @condition7.concat(" or (lower(min_age_range) = '#{val.downcase}' or lower(max_age_range) = '#{val.downcase}')")
            else
              #split age range
              str_a = val.split("-")
              @condition7.concat(" or (lower(min_age_range) = '#{str_a[0]}' or lower(max_age_range) <= '#{str_a[1]}')")
            end
          end
        end
        @ag= @ag +1
      end if !age_range.nil?
    end
  
   
    @condition_all.concat(" and (#{@condition1})") if !@condition1.nil? && @condition1!=''
    @condition_all.concat(" and (#{@condition2})") if !@condition2.nil? && @condition2!=''
    @condition_all.concat(" and (#{@condition3})") if !@condition3.nil? && @condition3!=''
    @condition_all.concat(" and (#{@condition4})") if !@condition4.nil? && @condition4!=''
    @condition_all.concat(" and (#{@condition5})") if !@condition5.nil? && @condition5!=''
    @condition_all.concat(" and (#{@condition6})") if !@condition6.nil? && @condition6!=''
    @condition_all.concat(" and (#{@condition7})") if !@condition7.nil? && @condition7!=''
       
    if !params[:d_r].nil? && params[:d_r]!='' && params[:d_r].present?
      if params[:d_r].downcase=="next 7 days"
        date_range = 7
      elsif params[:d_r].downcase == "next 20 days"
        date_range = 20
      elsif params[:d_r].downcase == "today"
        date_range = 1
      else
        if params[:d_r].downcase == "d_all"
          date_range = "all"
        else
          selected_date = "yes"
          date_range =  params[:datepicker_ad]
        end
      end
    end

    @ss = []
    @day_arr = []
    if day_of_the_week!='' && day_of_the_week!=nil && day_of_the_week.any? && !day_of_the_week.nil? && day_of_the_week
      day_of_the_week.each do |s|
        if s.downcase=="mon"
          @day_arr.push(:monday)
          @ss.push('monday')
        elsif s.downcase =="tue"
          @day_arr.push(:tuesday)
          @ss.push('tuesday')
        elsif s.downcase =="wed"
          @day_arr.push(:wednesday)
          @ss.push('wednesday')
        elsif s.downcase =="thu"
          @day_arr.push(:thursday)
          @ss.push('thursday')
        elsif s.downcase =="fri"
          @day_arr.push(:friday)
          @ss.push('friday')
        elsif s.downcase =="sat"
          @day_arr.push(:saturday)
          @ss.push('saturday')
        elsif s.downcase =="sun"
          @day_arr.push(:sunday)
          @ss.push('sunday')
        end if s!=""
      end
    end
    arr =[]
    if !date_range.nil? && date_range!=''
      if date_range == "all"
        #if day of week is have value
        if day_of_the_week!='' && day_of_the_week!=nil && day_of_the_week.any? && !day_of_the_week.nil? && day_of_the_week
          @activity = Activity.order("activity_id desc").select("activities.*").joins(:activity_schedule).where("lower(active_status)='active' and user_id='#{params[:search_user_id]}' #{@condition_all}").uniq
          if !@activity.nil? && @activity!='' && @activity.present?
            @activity.each do |actv|
              search_activity_all_repeat(actv,@ss,@day_arr,arr)
            end     #each loop end
          end    #activity exist loop end
        else
          @activity = Activity.order("activity_id desc").select("activities.*").joins(:activity_schedule).where("lower(active_status)='active' and user_id='#{params[:search_user_id]}' #{@condition_all}").uniq
          if !@activity.nil? && @activity!='' && @activity.present?
            @activity.each do |actv|
              arr << {:activity_id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
            end     #each loop end
          end    #activity exist loop end
        end
      else
        #choose particular date. activity
        if selected_date == "yes"
          sdate = DateTime.parse(params[:datepicker_ad]).strftime("%Y-%m-%d")
          r = Recurrence.new(:every => :day, :starts =>sdate, :until =>sdate)
          r.events.each do |date|
            #if day of week is have value
            if day_of_the_week!='' && day_of_the_week!=nil && day_of_the_week.any? && !day_of_the_week.nil? && day_of_the_week
              if @ss.include?(date.strftime("%A").downcase)
                @activity = Activity.order("activity_id desc").select("activities.*").joins(:activity_schedule).where("lower(active_status)='active' and user_id='#{params[:search_user_id]}' And (start_date <='#{date}') #{@condition_all}").uniq
                if !@activity.nil? && @activity!='' && @activity.present?
                  @activity.each do |actv|
                    advancesearch_repeat(date,actv,arr)
                  end     #each loop end
                end    #activity exist loop end
              end
            else
              @activity = Activity.order("activity_id desc").select("activities.*").joins(:activity_schedule).where("lower(active_status)='active' and user_id='#{params[:search_user_id]}' And (start_date <='#{date}') #{@condition_all}").uniq
              if !@activity.nil? && @activity!='' && @activity.present?
                @activity.each do |actv|
                  advancesearch_repeat(date,actv,arr)
                end     #each loop end
              end
            end
          end
        else
          #next selected date available activities
          r = Recurrence.new(:every => :day, :repeat => date_range)
          r.events.each do |date|
            #if day of week is have value
            if day_of_the_week!='' && day_of_the_week!=nil && day_of_the_week.any? && !day_of_the_week.nil? && day_of_the_week
              if @ss.include?(date.strftime("%A").downcase)
                @activity = Activity.order("activity_id desc").select("activities.*").joins(:activity_schedule).where("lower(active_status)='active' and user_id='#{params[:search_user_id]}' And (start_date <='#{date}') #{@condition_all}").uniq
                if !@activity.nil? && @activity!='' && @activity.present?
                  @activity.each do |actv|
                    advancesearch_repeat(date,actv,arr)
                  end     #each loop end
                end    #activity exist loop end
              end
            else
              @activity = Activity.order("activity_id desc").select("activities.*").joins(:activity_schedule).where("lower(active_status)='active' and user_id='#{params[:search_user_id]}' And (start_date <='#{date}') #{@condition_all}").uniq
              if !@activity.nil? && @activity!='' && @activity.present?
                @activity.each do |actv|
                  advancesearch_repeat(date,actv,arr)
                end     #each loop end
              end
            end
          end    #date each loop end
        end
      end
    end  #date range loop end
 
    arr = [] if arr.nil?
    @arr=arr.uniq{|x| x[:activity_id]}
    @activities = @arr.paginate(:page => params[:page], :per_page =>10)

    if !current_user.nil?
      @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT lower(trim(category))as category")
      @checck = ActivityRow.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]],:select => "row_type")
      @provider_activites_check =[]
      @checck.each do |s|
        @provider_activites_check<< s.row_type
      end
    end
    
    respond_to do |format|
      #~ format.html
      format.js
    end

  end
  
  def advanced_search
    @advanced_search = "d_r=d_all"
    redirect_to "/search_event_index?#{@advanced_search}"
  end
  
  
  #advanced search in parent view
  def advanced_search_changed
    #get the main search page url here
    @search_page = params[:act] if !params[:act].nil?
    session[:city] = cookies[:city_new_usr]
    session[:city] = "Walnut Creek" if session[:city].nil?
    session[:cat_zc]="date"
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    
    @sdate = DateTime.parse(params[:datepicker_ad]).strftime("%Y-%m-%d") if params[:datepicker_ad]!="" && !params[:datepicker_ad].nil?
	  
    @get_current_url = request.env['HTTP_HOST']
    
    arr = []
    date_range = ''
    selected_date = 'no'
    @condition_all = ''
   
    params[:d_mile]
    params[:d_r]
    @basictext = ''
    
    @keyword = params[:search] if !params[:search].nil? && params[:search].present?
    @parent_keyword = @keyword.downcase.gsub("'","") if !@keyword.nil?
    @basictext.concat(" (lower(user_profiles.business_name) like '%#{@parent_keyword}%' or lower(activities.activity_name) like '%#{@parent_keyword}%' or lower(activities.category) like '%#{@parent_keyword}%' or lower(activities.sub_category) like '%#{@parent_keyword}%' or lower(activities.description) like '%#{@parent_keyword}%' or lower(activities.city) like '%#{@parent_keyword}%') ")  if @parent_keyword != 0 and @parent_keyword != nil and @parent_keyword != ""
    
    #storing the selected values in array for activity type
    day_of_the_week=[]
    (1..7).each do |s|
      day_of_the_week<<params["day_of_week_#{s}"] if params["day_of_week_#{s}"] && params["day_of_week_#{s}"]!="" && params["day_of_week_#{s}"]!=nil
    end
   
    #storing the selected values in array for activity type
    @activity_type=[]
    (1..5).each do |s|
      @activity_type<<params["sch_#{s}"] if params["sch_#{s}"] && params["sch_#{s}"]!="" && params["sch_#{s}"]!=nil
    end
    
    @category = params[:ad_sub_category].split(",") if params[:ad_sub_category]!="" && !params[:ad_sub_category].nil?
    @zipcode = params[:z_c] if params[:z_c] !="Enter Zip Code" && params[:z_c]!="" && params[:z_c]!=nil && params[:z_c]
    @city = params[:city_1] if params[:city_1] !="" && params[:city_1]!=nil && params[:city_1]
    @gender = params[:gender]  if !params[:gender].nil? && params[:gender]!=''

    #create the array for age_range values
    age_range = []
    
    if params[:a_all] && params[:a_all]!="" && params[:a_all]!=nil
      age_range<<params[:a_all]
    end
    if params[:a_r10] && params[:a_r10]!="" && params[:a_r10]!=nil
      age_range<<params[:a_r10]
    end
    if params[:a_r1] && params[:a_r1]!="" && params[:a_r1]!=nil
      age_range<<params[:a_r1]
    end
    if params[:a_r13] && params[:a_r13]!="" && params[:a_r13]!=nil
      age_range<<params[:a_r13]
    end
    if params[:a_r4] && params[:a_r4]!="" && params[:a_r4]!=nil
      age_range<<params[:a_r4]
    end
    if params[:a_r15] && params[:a_r15]!="" && params[:a_r15]!=nil
      age_range<<params[:a_r15]
    end
    if params[:a_r7] && params[:a_r7]!="" && params[:a_r7]!=nil
      age_range<<params[:a_r7]
    end
    
    @condition1=''
    @condition2=''
    @condition3=''
    @condition4=''
    @condition5=''
    @condition6=''
    @condition7=''
    @i = 0
    @c = 0
    @z = 0
    @ct = 0
    @p = 0
    @ag = 0

    if !@activity_type.include?('all')
      @activity_type.each do |val|
        if @i == 0
          @condition1.concat("lower(activities.schedule_mode)  = '#{val.downcase.strip}'")  if val != 0 and val != nil and val != "" and val.downcase!='all'
        else
          @condition1.concat(" or lower(activities.schedule_mode)  = '#{val.downcase.strip}'")  if val != 0 and val != nil and val != "" and val.downcase!='all'
        end
        @i = @i +1
      end if !@activity_type.nil?
    end
   
    @category.each do |val|
      if @c == 0
        @condition2.concat("lower(activities.sub_category) = '#{val.downcase.strip}'") if val != 0 and val != nil and val != "" && val.present? && !val.nil?
        @c = @c +1 if val != 0 and val != nil and val != "" && val.present? && !val.nil?
      else
        @condition2.concat(" or lower(activities.sub_category) = '#{val.downcase.strip}'")  if val != 0 and val != nil and val != "" && val.present? && !val.nil?
        @c = @c +1 if val != 0 and val != nil and val != "" && val.present? && !val.nil?
      end
     
    end if !@category.nil? && @category!="" && @category.any? && @category.present? && @category!=""
   
    if params[:z_c] !="" && params[:z_c]!=nil && params[:z_c] && params[:z_c]!="Enter Zip Code"
      @condition3 = ("lower(activities.zip_code) = '#{params[:z_c].downcase.strip}'")
    end
	
    if params[:city_1] !="" && params[:city_1]!=nil && params[:city_1]
      @condition4 = ("lower(activities.city) = '#{params[:city_1].downcase.strip}'") if params[:city_1] !="" && params[:city_1]!=nil && params[:city_1]
    end
    
    if !params[:gender].nil? && params[:gender]!='' && params[:gender]!="g_all"
      @condition5=("lower(activities.gender) = '#{params[:gender].downcase}'") if !params[:gender].nil? && params[:gender]!='' && params[:gender]!="g_all" && params[:gender]!=0
    end
   
    if params[:a_f]!="" && params[:a_f]=="free" && params[:a_f]!=nil &&  params[:a_f].present? && params[:a_f]!="p_all"
      if  params[:a_f] == "free"
        @condition6=("activities.price_type = '3'")
      end
    end
   
    if params[:paid]!="" && params[:paid]=="paid" && params[:paid]!=nil && params[:paid].present? && params[:paid]!="p_all"
      if  params[:paid] == "paid"
        @condition6=("activities.price_type='1' or activities.price_type='2'")
      end
    end

    if !age_range.include?('a_all')
      age_range.each do |val|
        if @ag == 0
          if val != 0 and val != nil and val !='' and val.downcase != "a_all"
            if val.downcase == 'adults'
              @condition7.concat("(lower(activities.min_age_range) = '#{val.downcase}' or lower(activities.max_age_range)= '#{val.downcase}')")
            else
              #split age range
              str_a = val.split("-")
              @condition7.concat("(lower(activities.min_age_range) = '#{str_a[0]}' or lower(activities.max_age_range) <= '#{str_a[1]}')")
            end
          end
        else
          if val != 0 and val != nil and val !='' and val.downcase != "a_all"
            if val.downcase == 'adults'
              @condition7.concat(" or (lower(activities.min_age_range) = '#{val.downcase}' or lower(activities.max_age_range) = '#{val.downcase}')")
            else
              #split age range
              str_a = val.split("-")
              @condition7.concat(" or (lower(activities.min_age_range) = '#{str_a[0]}' or lower(activities.max_age_range) <= '#{str_a[1]}')")
            end
          end
        end
        @ag= @ag +1
      end if !age_range.nil?
    end

    @condition_all.concat(" and (#{@basictext})") if !@basictext.nil? && @basictext!=''
    @condition_all.concat(" and (#{@condition1})") if !@condition1.nil? && @condition1!=''
    @condition_all.concat(" and (#{@condition2})") if !@condition2.nil? && @condition2!=''
    @condition_all.concat(" and (#{@condition3})") if !@condition3.nil? && @condition3!=''
    @condition_all.concat(" and (#{@condition4})") if !@condition4.nil? && @condition4!=''
    @condition_all.concat(" and (#{@condition5})") if !@condition5.nil? && @condition5!=''
    @condition_all.concat(" and (#{@condition6})") if !@condition6.nil? && @condition6!=''
    @condition_all.concat(" and (#{@condition7})") if !@condition7.nil? && @condition7!=''
       
    if !params[:d_r].nil? && params[:d_r]!='' && params[:d_r].present?
      if params[:d_r].downcase=="next 7 days"
        date_range = 7
      elsif params[:d_r].downcase == "next 20 days"
        date_range = 20
      elsif params[:d_r].downcase == "today"
        date_range = 1
      else
        if params[:d_r].downcase == "d_all"
          date_range = "all"
        else
          selected_date = "yes"
          date_range =  params[:datepicker_ad]
        end
      end
    end

    @ss = []
    @day_arr = []
    if day_of_the_week!='' && day_of_the_week!=nil && day_of_the_week.any? && !day_of_the_week.nil? && day_of_the_week
      day_of_the_week.each do |s|
        if s.downcase=="mon"
          @day_arr.push(:monday)
          @ss.push('monday')
        elsif s.downcase =="tue"
          @day_arr.push(:tuesday)
          @ss.push('tuesday')
        elsif s.downcase =="wed"
          @day_arr.push(:wednesday)
          @ss.push('wednesday')
        elsif s.downcase =="thu"
          @day_arr.push(:thursday)
          @ss.push('thursday')
        elsif s.downcase =="fri"
          @day_arr.push(:friday)
          @ss.push('friday')
        elsif s.downcase =="sat"
          @day_arr.push(:saturday)
          @ss.push('saturday')
        elsif s.downcase =="sun"
          @day_arr.push(:sunday)
          @ss.push('sunday')
        end if s!=""
      end
    end
    arr =[]
    if !date_range.nil? && date_range!=''
      if date_range == "all"
        #if day of week is have value
        if day_of_the_week!='' && day_of_the_week!=nil && day_of_the_week.any? && !day_of_the_week.nil? && day_of_the_week
          @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where lower(activities.active_status)='active' and activities.cleaned = true #{@condition_all}")
          if !@activity.nil? && @activity!='' && @activity.present?
            @activity.each do |actv|
              search_activity_all_repeat(actv,@ss,@day_arr,arr)
            end     #each loop end
          end    #activity exist loop end
        else
          @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where lower(activities.active_status)='active' and activities.cleaned = true #{@condition_all}")
          if !@activity.nil? && @activity!='' && @activity.present?
            @activity.each do |actv|
              arr << {:activity_id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
            end     #each loop end
          end    #activity exist loop end
        end
      else
        #choose particular date. activity
        if selected_date == "yes"
          sdate = DateTime.parse(params[:datepicker_ad]).strftime("%Y-%m-%d")
          r = Recurrence.new(:every => :day, :starts =>sdate, :until =>sdate)
          r.events.each do |date|
            #if day of week is have value
            if day_of_the_week!='' && day_of_the_week!=nil && day_of_the_week.any? && !day_of_the_week.nil? && day_of_the_week
              if @ss.include?(date.strftime("%A").downcase)
                @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where lower(activities.active_status)='active' and activities.cleaned = true And (activity_schedules.start_date <='#{date}') #{@condition_all}")
                if !@activity.nil? && @activity!='' && @activity.present?
                  @activity.each do |actv|
                    advancesearch_repeat(date,actv,arr)
                  end     #each loop end
                end    #activity exist loop end
              end
            else
              @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where lower(activities.active_status)='active' and activities.cleaned = true And (activity_schedules.start_date <='#{date}') #{@condition_all}")
              if !@activity.nil? && @activity!='' && @activity.present?
                @activity.each do |actv|
                  advancesearch_repeat(date,actv,arr)
                end     #each loop end
              end
            end
          end
        else
          #next selected date available activities
          r = Recurrence.new(:every => :day, :repeat => date_range)
          r.events.each do |date|
            #if day of week is have value
            if day_of_the_week!='' && day_of_the_week!=nil && day_of_the_week.any? && !day_of_the_week.nil? && day_of_the_week
              if @ss.include?(date.strftime("%A").downcase)
                @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where lower(activities.active_status)='active' and activities.cleaned = true And (activity_schedules.start_date <='#{date}') #{@condition_all}")
                if !@activity.nil? && @activity!='' && @activity.present?
                  @activity.each do |actv|
                    advancesearch_repeat(date,actv,arr)
                  end     #each loop end
                end    #activity exist loop end
              end
            else
              @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where lower(activities.active_status)='active' and activities.cleaned = true And (activity_schedules.start_date <='#{date}') #{@condition_all}")
              if !@activity.nil? && @activity!='' && @activity.present?
                @activity.each do |actv|
                  advancesearch_repeat(date,actv,arr)
                end     #each loop end
              end
            end
          end    #date each loop end
        end
      end
    end  #date range loop end
      
    arr = [] if arr.nil?
    @arr=arr.uniq{|x| x[:activity_id]}
    @advance_count = @arr.length if !@arr.nil? && @arr.present?
    
    @activity_free = @arr.paginate(:page => params[:page], :per_page =>12)
    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT lower(trim(category))as category")
     
    @checck  = []
    @provider_activites_check =[]
    if !current_user.nil?
      @checck = ActivityRow.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]],:select => "row_type")
      @provider_activites_check =[]
      @checck.each do |s|
        @provider_activites_check<< s.row_type
      end
    end
    
    respond_to do |format|
      #~ format.html
      format.js
    end
  end #advance_search end
  
  
  #if select date range is all and day of the week is selected call this
  def search_activity_all_repeat(actv,ss,day_arr,arr)
    @schedule = ActivitySchedule.where("activity_id = ?",actv.activity_id).first
    if !@schedule.nil? && @schedule!='' && @schedule.present?
      #if schedule, repeat yes
      @repeat = ActivityRepeat.where("activity_schedule_id=?",@schedule["schedule_id"]).last
      @schedule_start = @schedule.start_date
      if !@repeat.nil? && @repeat!='' && @repeat.present?
        #start daily
        if @repeat.repeats=="Daily"
          search_daily_view(@repeat,@schedule,actv,arr,ss)
        end
        if @repeat.repeats=="Weekly"
          search_weekly_view(@repeat,@schedule,actv,arr,ss)
        end
        if @repeat.repeats =="Every week (Monday to Friday)"
          search_weekly_view(@repeat,@schedule,actv,arr,ss)
        end
        if @repeat.repeats =="Every Monday,Wednesday and Friday"
          search_weekly_view(@repeat,@schedule,actv,arr,ss)
        end
        if @repeat.repeats =="Every Tuesday and Thursday"
          search_weekly_view(@repeat,@schedule,actv,arr,ss)
        end
        if @repeat.repeats=="Monthly"
          search_monthly_view(@repeat,@schedule,actv,arr,ss,day_arr)
        end
        if @repeat.repeats=="Yearly"
          search_yearly_view(@repeat,@schedule,actv,arr,ss,day_arr)
        end
      else
        #without repeat start camps/workshop
        #if start and end date is exist
        @c_date = (Time.now).strftime("%Y-%m-%d")
        if !@schedule["start_date"].nil? && !@schedule["end_date"].nil?
          d_flag = false
          if @c_date <= @schedule["end_date"].strftime("%Y-%m-%d")
            sch_sdate = @schedule["start_date"].strftime("%Y-%m-%d")
            sch_edate = @schedule["end_date"].strftime("%Y-%m-%d")
            r = Recurrence.new(:every => :day, :starts =>sch_sdate, :until =>sch_edate, :interval => 1)
            if (r.events).length > 0
              r.events.each do |val|
                mon_day = val.strftime("%A")
                if ss.include?(mon_day.downcase)
                  d_flag=true
                  break
                end
              end
            end
            if d_flag == true
              arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
            end
          end
        else
          #start date is exist and end date is nil
          if !@schedule["start_date"].nil? && @schedule["end_date"].nil?
            d_flag = false
            if @c_date <= @schedule["start_date"].strftime("%Y-%m-%d")
              sch_date=@schedule["start_date"].strftime("%Y-%m-%d")
              r = Recurrence.new(:every => :day, :starts =>sch_date, :until =>sch_date, :interval => 1)
              if (r.events).length > 0
                r.events.each do |val|
                  mon_day = val.strftime("%A")
                  if ss.include?(mon_day.downcase)
                    d_flag=true
                    break
                  end
                end
              end
              if d_flag == true
                arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
              end
            end
          end
          ss.each do |s_dayval|
            day_ = s_dayval[0..2]
            @schedule = ActivitySchedule.where("activity_id =#{actv.activity_id} and  business_hours='#{day_.downcase}'").last
            if !@schedule.nil? && @schedule!='' && @schedule.present?
              arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
            end
          end
        end #inner without repeat end
      end # repeat check loop end
    else
      #activity dont have schedule eg by appointment
      arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
    end  #schedule loop end
  end
  
  #search page daily repeat functionality
  def search_daily_view(repeat,schedule,actv,arr,days)
    @c_date = Time.now.strftime("%Y-%m-%d")
    @repeat = repeat
    @schedule = schedule
    #if daily and ends never true
   
    if @repeat.ends_never == true
      d_flag = false
      s_date = @schedule.start_date
      if s_date.strftime("%Y-%m-%d") <= @c_date
        r = Recurrence.new(:every => :day, :interval => @repeat.repeat_every.to_i)
        if (r.events).length > 0
          r.events.each do |val|
            mon_day = val.strftime("%A")
            if days.include?(mon_day.downcase)
              d_flag=true
              break
            end
          end
        end
        if d_flag == true
          arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
        end
      end
      #if Daily and ends on exists
    elsif !@repeat.ends_on.nil?
      s_date =  @schedule.start_date
      if @repeat.ends_on.strftime("%Y-%m-%d") >= @c_date
        if s_date.strftime("%Y-%m-%d") <= @c_date
          r = Recurrence.new(:every => :day, :starts =>s_date, :until =>@repeat.ends_on, :interval => @repeat.repeat_every.to_i)
          if (r.events).length > 0
            r.events.each do |val|
              mon_day = val.strftime("%A")
              if days.include?(mon_day.downcase)
                d_flag=true
                break
              end
            end
          end
          if d_flag == true
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        end
      end
      #if Daily and end occurences exists
    elsif !@repeat.end_occurences.nil?
      e_date = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
      s_date =  @schedule.start_date
      if e_date.strftime("%Y-%m-%d") >= @c_date
        if s_date.strftime("%Y-%m-%d") <= @c_date
          r = Recurrence.new(:every => :day, :starts =>s_date, :until =>e_date, :interval => @repeat.repeat_every.to_i)
          if (r.events).length > 0
            r.events.each do |val|
              mon_day = val.strftime("%A")
              if days.include?(mon_day.downcase)
                d_flag=true
                break
              end
            end
          end
          if d_flag == true
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        end
      end
    

    end
  end
  
  #search weekly
  def search_weekly_view(repeat,schedule,actv,arr,days)
    @c_date = Time.now.strftime("%Y-%m-%d")
    @repeat = repeat
    repeat_o = @repeat.repeat_on
    if !repeat_o.nil? && repeat_o!='' && repeat_o.present?
      rep = repeat_o.split(",")
      @ss_arr = []
      rep.each do|s|
        if s.downcase=="mon"
          @ss_arr.push('monday')
        elsif s.downcase =="tue"
          @ss_arr.push('tuesday')
        elsif s.downcase =="wed"
          @ss_arr.push('wednesday')
        elsif s.downcase =="thu"
          @ss_arr.push('thursday')
        elsif s.downcase =="fri"
          @ss_arr.push('friday')
        elsif s.downcase =="sat"
          @ss_arr.push('saturday')
        elsif s.downcase =="sun"
          @ss_arr.push('sunday')
        end if s!=""
      end
    end
    days.each do |val|
      if @ss_arr.include?val
        arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
      end
    end
  end

  #search repeat monthly
  def search_monthly_view(repeat,schedule,actv,arr,days,day_arr)
    @c_date = Time.now.strftime("%Y-%m-%d")
    @repeat = repeat
    @schedule = schedule
    s_date =  @schedule.start_date
    s = week_of_month_for_date(s_date)
    if s == 1
      se = :first
    elsif s==2
      se = :second
    elsif s==3
      se = :third
    elsif s>=4
      se = :last
    end
    if @repeat.ends_never == true
      if @repeat.repeated_by_month == true
        d_flag = false
        s_date = s_date.strftime("%d")
        r = Recurrence.new(:every => :month, :on =>s_date.to_i, :interval => @repeat.repeat_every.to_i)
        if (r.events).length > 0
          r.events.each do |val|
            if @c_date <= val.strftime("%Y-%m-%d")
              mon_day = val.strftime("%A")
              if days.include?(mon_day.downcase)
                d_flag=true
                break
              end
            end
          end
        end
        if d_flag == true
          arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
        end
      else
        day_arr.each do |week_day|
          r = Recurrence.new(:every => :month, :on =>"#{se}",  :weekday =>week_day, :interval => @repeat.repeat_every.to_i)
          if (r.events).length > 0
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        end
      end
      # # # #if monthly and ends on exists
    elsif !@repeat.ends_on.nil?
      s_date =  @schedule.start_date
      if @repeat.ends_on.strftime("%Y-%m-%d") >= @c_date
        if @repeat.repeated_by_month == true
          d_flag = false
          s_date1 = s_date.strftime("%d")
          r = Recurrence.new(:every => :month, :on =>s_date1.to_i,:starts =>s_date, :until => @repeat.ends_on, :interval => @repeat.repeat_every.to_i)
          if (r.events).length > 0
            r.events.each do |val|
              if @c_date <= val.strftime("%Y-%m-%d")
                mon_day = val.strftime("%A")
                if days.include?(mon_day.downcase)
                  d_flag=true
                  break
                end
              end
            end
          end
          if d_flag == true
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        else
          day_arr.each do |week_day|
            r = Recurrence.new(:every => :month, :on =>"#{se}",  :weekday =>week_day, :starts =>s_date, :until => @repeat.ends_on, :interval => @repeat.repeat_every.to_i)
            if (r.events).length > 0
              arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
            end
          end
        end
      end
      # # #if monthly and end occurences exists
    elsif !@repeat.end_occurences.nil?
      d_flag = false
      e_date = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).months
      s_date =  @schedule.start_date
      if e_date.strftime("%Y-%m-%d") >= @c_date
        if @repeat.repeated_by_month == true
          s_date1 = s_date.strftime("%d")
          r = Recurrence.new(:every => :month, :on =>s_date1.to_i,:starts =>s_date, :until => e_date, :interval => @repeat.repeat_every.to_i)
          if (r.events).length > 0
            r.events.each do |val|
              if @c_date <= val.strftime("%Y-%m-%d")
                mon_day = val.strftime("%A")
                if days.include?(mon_day.downcase)
                  d_flag=true
                  break
                end
              end
            end
          end
          if d_flag == true
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        else
          day_arr.each do |week_day|
            r = Recurrence.new(:every => :month, :on =>"#{se}",  :weekday =>week_day, :starts =>s_date, :until => e_date, :interval => @repeat.repeat_every.to_i)
            if (r.events).length > 0
              arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
            end
          end
        end
      end
   
    end
    
  end
  
  #search repeat yearly
  def search_yearly_view(repeat,schedule,actv,arr,days,day_arr)
    @c_date = Time.now.strftime("%Y-%m-%d")
    @repeat = repeat
    @schedule = schedule
    #if yearly and ends never true
    if @repeat.ends_never == true
      d_flag = false
      s_date = @schedule.start_date
      if s_date.strftime("%Y-%m-%d") <= @c_date
        r = Recurrence.new(:every => :year, :on => [s_date.strftime("%m").to_i, s_date.strftime("%d").to_i], :interval => @repeat.repeat_every.to_i)
        if (r.events).length > 0
          r.events.each do |val|
            mon_day = val.strftime("%A")
            if days.include?(mon_day.downcase)
              d_flag=true
              break
            end
          end
        end
        if d_flag == true
          arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
        end
      end
      #if Daily and ends on exists
    elsif !@repeat.ends_on.nil?
      d_flag = false
      s_date =  @schedule.start_date
      if @repeat.ends_on.strftime("%Y-%m-%d") >= @c_date
        if s_date.strftime("%Y-%m-%d") <= @c_date
          r = Recurrence.new(:every => :year, :on => [s_date.strftime("%m").to_i, s_date.strftime("%d").to_i],:starts =>s_date, :until => @repeat.ends_on, :interval => @repeat.repeat_every.to_i)
          if (r.events).length > 0
            r.events.each do |val|
              mon_day = val.strftime("%A")
              if days.include?(mon_day.downcase)
                d_flag=true
                break
              end
            end
          end
          if d_flag == true
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        end
      end
      #if Daily and end occurences exists
    elsif !@repeat.end_occurences.nil?
      d_flag = false
      e_date = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).years
      s_date =  @schedule.start_date
      if e_date.strftime("%Y-%m-%d") >= @c_date
        if s_date.strftime("%Y-%m-%d") <= @c_date
          r = Recurrence.new(:every => :year, :on => [s_date.strftime("%m").to_i, s_date.strftime("%d").to_i],:starts =>s_date, :until => e_date, :interval => @repeat.repeat_every.to_i)
          if (r.events).length > 0
            r.events.each do |val|
              mon_day = val.strftime("%A")
              if days.include?(mon_day.downcase)
                d_flag=true
                break
              end
            end
          end
          if d_flag == true
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        end
      end
    
    
    end
  end
  
  #get activity count and insert into temp table
  def advancesearch_repeat(c_date,actv,arr)
    @c_date1 = c_date
    @schedule = ActivitySchedule.where("activity_id = ?",actv.activity_id).first
    if !@schedule.nil? && @schedule!='' && @schedule.present?
      #if schedule, repeat yes
      @repeat = ActivityRepeat.where("activity_schedule_id=?",@schedule["schedule_id"]).last
         
      @c_date =@c_date1.strftime("%Y-%m-%d")
      @c_day = @c_date1.strftime("%a")
                             
      @schedule_start = @schedule.start_date
      if !@repeat.nil? && @repeat!='' && @repeat.present?
        #start daily
        if @repeat.repeats=="Daily"
          repeat_daily_view(@c_date,@repeat,@schedule,actv,arr,@c_day)
        end
        if @repeat.repeats=="Weekly"
          repeat_weekly_view(@c_date,@repeat,@schedule,actv,arr,@c_day)
        end
        if @repeat.repeats =="Every week (Monday to Friday)"
          repeat_weekly_view(@c_date,@repeat,@schedule,actv,arr,@c_day)
        end
        if @repeat.repeats =="Every Monday,Wednesday and Friday"
          repeat_weekly_view(@c_date,@repeat,@schedule,actv,arr,@c_day)
        end
        if @repeat.repeats =="Every Tuesday and Thursday"
          repeat_weekly_view(@c_date,@repeat,@schedule,actv,arr,@c_day)
        end
        if @repeat.repeats=="Monthly"
          repeat_monthly_view(@c_date,@repeat,@schedule,actv,arr,@c_day)
        end
        if @repeat.repeats=="Yearly"
          repeat_yearly_view(@c_date,@repeat,@schedule,actv,arr,@c_day)
        end
      else
        #without repeat start camps/workshop
        #if start and end date is exist
        if !@schedule["start_date"].nil? && !@schedule["end_date"].nil?
          if (@schedule["start_date"].strftime("%Y-%m-%d") <= @c_date) && (@schedule["end_date"].strftime("%Y-%m-%d") >= @c_date)
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        else
          #start date is exist and end date is nil
          if !@schedule["start_date"].nil? && @schedule["end_date"].nil?
            @schedule = ActivitySchedule.where("activity_id =#{actv.activity_id} and  start_date='#{@c_date}'").last
            if @schedule
              arr << {:id => actv.activity_id,:min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
            end
          end
          s_day = @c_date1.strftime("%a")
          @schedule = ActivitySchedule.where("activity_id =#{actv.activity_id} and  business_hours='#{s_day.downcase}'").last
          if !@schedule.nil? && @schedule!='' && @schedule.present?
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range,:city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        end #inner without repeat end
      end # repeat check loop end
    else
      #activity dont have schedule eg by appointment
      arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range,:city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
    end  #schedule loop end
  end
    
  #view page repeat functionality
  def repeat_daily_view(c_date,repeat,schedule,actv,arr,c_day)
    @c_date = c_date
    @repeat = repeat
    @schedule = schedule
    #if daily and ends never true
    if @repeat.ends_never == true
      s_date = @schedule.start_date
      if s_date.strftime("%Y-%m-%d") <= @c_date
        r = Recurrence.new(:every => :day, :interval => @repeat.repeat_every.to_i)
        if r.include?(@c_date)
          arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range,:city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
        end
      end
      #if Daily and ends on exists
    elsif !@repeat.ends_on.nil?
      s_date =  @schedule.start_date
      if @repeat.ends_on.strftime("%Y-%m-%d") >= @c_date
        if s_date.strftime("%Y-%m-%d") <= @c_date
          r = Recurrence.new(:every => :day, :starts =>s_date, :until =>@repeat.ends_on, :interval => @repeat.repeat_every.to_i)
          if r.include?(@c_date)
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range,:city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        end
      end
      #if Daily and end occurences exists
    elsif !@repeat.end_occurences.nil?
      e_date = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
      s_date =  @schedule.start_date
      if e_date.strftime("%Y-%m-%d") >= @c_date
        if s_date.strftime("%Y-%m-%d") <= @c_date
          r = Recurrence.new(:every => :day, :starts =>s_date, :until =>e_date, :interval => @repeat.repeat_every.to_i)
          if r.include?(@c_date)
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range,:city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        end
      end
    end
  end
  
  def repeat_weekly_view(c_date,repeat,schedule,actv,arr,c_day)
    @c_date = c_date
    @repeat = repeat
    @schedule = schedule
    @wek =[]
    @ss =[]
    s_date=@schedule.start_date
    
    repeat_o = @repeat.repeat_on
    if !repeat_o.nil? && repeat_o!='' && repeat_o.present?
      rep = repeat_o.split(",")
      rep.each do|s|
        if s.downcase=="mon"
          @wek.push(1)
          @ss.push(:monday)
        elsif s.downcase =="tue"
          @wek.push(2)
          @ss.push(:tuesday)
        elsif s.downcase =="wed"
          @wek.push(3)
          @ss.push(:wednesday)
        elsif s.downcase =="thu"
          @wek.push(4)
          @ss.push(:thursday)
        elsif s.downcase =="fri"
          @wek.push(5)
          @ss.push(:friday)
        elsif s.downcase =="sat"
          @wek.push(6)
          @ss.push(:saturday)
        elsif s.downcase =="sun"
          @wek.push(0)
          @ss.push(:sunday)
        end if s!=""
      end
    end
    #if weekly and ends never true
    if @repeat.ends_never == true
      if s_date.strftime("%Y-%m-%d") <= @c_date
        if @ss!='' && !@ss.nil? && @ss.present?
          r = Recurrence.new(:every => :week, :on =>@ss, :interval =>@repeat.repeat_every.to_i)
          # p r
          if r.include?(@c_date)
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range,:city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        end
      end
      #if weekly and ends on exists
    elsif !@repeat.ends_on.nil?
      end_date = @repeat.ends_on
      if end_date.strftime("%Y-%m-%d") >= @c_date
        if s_date.strftime("%Y-%m-%d") <= @c_date
          if @ss!='' && !@ss.nil? && @ss.present?
            r = Recurrence.new(:every => :week, :on =>@ss, :starts =>s_date, :until=>end_date, :interval =>@repeat.repeat_every.to_i)
            if r.include?(@c_date)
              arr << {:id => actv.activity_id,:min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
            end
          end
        end
      end
      #if weekly and end occurences exists
    elsif !@repeat.end_occurences.nil?
      end_date = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i * 7).days
      if end_date.strftime("%Y-%m-%d") >= @c_date
        if s_date.strftime("%Y-%m-%d") <= @c_date
          if @ss!='' && !@ss.nil? && @ss.present?
            r = Recurrence.new(:every => :week, :on =>@ss, :starts =>s_date, :until=>end_date, :interval =>@repeat.repeat_every.to_i)
            if r.include?(@c_date)
              arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range,:city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
            end
          end
        end
      end
    
    
    end
  end

  #repeat monthly
  def repeat_monthly_view(c_date,repeat,schedule,actv,arr,c_day)
    @c_date = c_date
    @repeat = repeat
    @schedule = schedule
    s_date =  @schedule.start_date
    s = week_of_month_for_date(s_date)
    if s == 1
      se = :first
    elsif s==2
      se = :second
    elsif s==3
      se = :third
    elsif s>=4
      se = :last
    end
    if @repeat.ends_never == true
      if @repeat.repeated_by_month == true
        s_date = s_date.strftime("%d")
        r = Recurrence.new(:every => :month, :on =>s_date.to_i, :interval => @repeat.repeat_every.to_i)
        if r.include?@c_date
          arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
        end
      else
        s_day = s_date.strftime("%a")
        r = Recurrence.new(:every => :month, :on =>"#{se}",  :weekday =>"#{s_day.downcase}", :interval => @repeat.repeat_every.to_i)
        if r.include?@c_date
          arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
        end
      end
	  
      # # #if Daily and ends on exists
    elsif !@repeat.ends_on.nil?
      s_date =  @schedule.start_date
      if @repeat.ends_on.strftime("%Y-%m-%d") >= @c_date
        if @repeat.repeated_by_month == true
          s_date1 = s_date.strftime("%d")
          r = Recurrence.new(:every => :month, :on =>s_date1.to_i,:starts =>s_date, :until => @repeat.ends_on, :interval => @repeat.repeat_every.to_i)
          if r.include?@c_date
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        else
          s_day = s_date.strftime("%a")
          r = Recurrence.new(:every => :month, :on =>"#{se}",  :weekday =>"#{s_day.downcase}", :starts =>s_date, :until => @repeat.ends_on, :interval => @repeat.repeat_every.to_i)
          if r.include?@c_date
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        end
      end
      # #if monthly and end occurences exists
    elsif !@repeat.end_occurences.nil?
      e_date = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).months
      s_date =  @schedule.start_date
      if e_date.strftime("%Y-%m-%d") >= @c_date
        if @repeat.repeated_by_month == true
          s_date1 = s_date.strftime("%d")
          r = Recurrence.new(:every => :month, :on =>s_date1.to_i,:starts =>s_date, :until => e_date, :interval => @repeat.repeat_every.to_i)
          if r.include?@c_date
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        else
          s_day = s_date.strftime("%a")
          r = Recurrence.new(:every => :month, :on =>"#{se}",  :weekday =>"#{s_day.downcase}", :starts =>s_date, :until => e_date, :interval => @repeat.repeat_every.to_i)
          if r.include?@c_date
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        end
      end
    end
  end
  
  #repeat yearly
  def repeat_yearly_view(c_date,repeat,schedule,actv,arr,c_day)
    @c_date = c_date
    @repeat = repeat
    @schedule = schedule
    #if daily and ends never true
    if @repeat.ends_never == true
      s_date = @schedule.start_date
      if s_date.strftime("%Y-%m-%d") <= @c_date
        r = Recurrence.new(:every => :year, :on => [s_date.strftime("%m").to_i, s_date.strftime("%d").to_i], :interval => @repeat.repeat_every.to_i)
        if r.include?(@c_date)
          arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
        end
      end
    
      #if Daily and ends on exists
    elsif !@repeat.ends_on.nil?
      s_date =  @schedule.start_date
      if @repeat.ends_on.strftime("%Y-%m-%d") >= @c_date
        if s_date.strftime("%Y-%m-%d") <= @c_date
          r = Recurrence.new(:every => :year, :on => [s_date.strftime("%m").to_i, s_date.strftime("%d").to_i],:starts =>s_date, :until => @repeat.ends_on, :interval => @repeat.repeat_every.to_i)
          if r.include?(@c_date)
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        end
      end
      #if Daily and end occurences exists
    elsif !@repeat.end_occurences.nil?
      e_date = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).years
      s_date =  @schedule.start_date
      if e_date.strftime("%Y-%m-%d") >= @c_date
        if s_date.strftime("%Y-%m-%d") <= @c_date
          r = Recurrence.new(:every => :year, :on => [s_date.strftime("%m").to_i, s_date.strftime("%d").to_i],:starts =>s_date, :until => e_date, :interval => @repeat.repeat_every.to_i)
          if r.include?(@c_date)
            arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
          end
        end
      end
    
    
    end
  end
  
  
  
  def advanced_search_new
    #get the params from the event_index page.
    
    activity_subcategory = params[:ad_sub_category].split(",") if params[:ad_sub_category]!="" && !params[:ad_sub_category].nil?
    @get_current_url = request.env['HTTP_HOST']
    
    #profile image changes
    if !current_user.nil? && !current_user.user_profile.nil?
      @profile_data=current_user.user_profile if !current_user.user_profile.nil?
      #~ ref  @pf1=FastImage.size("http://54.243.133.232:3002/system/profiles/7/thumb/business1_20130223-4128-1t69efx.jpg")
      @aa='$image_global_path'+@profile_data.profile.url(:thumb)
      @profile_ig=FastImage.size(@aa)
      @p_f = @aa if @profile_ig!="" && !@profile_ig.nil?
    end
    
    if params[:z_c] !="Enter Zip Code" && params[:z_c]!="" && params[:z_c]!=nil && params[:z_c]
      @z=params[:z_c]
    else
      @z="Enter Zip Code"
    end

    #storing the selected values in array for activity type
    activity_type=[]
    (1..5).each do |s|
      activity_type<<params["sch_#{s}"] if params["sch_#{s}"] && params["sch_#{s}"]!="" && params["sch_#{s}"]!=nil
    end
    
    #storing the selected values in array for activity type
    day_of_the_week=[]
    (1..7).each do |s|
      day_of_the_week<<params["day_of_week_#{s}"] if params["day_of_week_#{s}"] && params["day_of_week_#{s}"]!="" && params["day_of_week_#{s}"]!=nil
    end

    #create the array for age_range values
    age_range = []
    
    if params[:a_all] && params[:a_all]!="" && params[:a_all]!=nil
      age_range<<params[:a_all]
    end
    if params[:a_r10] && params[:a_r10]!="" && params[:a_r10]!=nil
      age_range<<params[:a_r10]
    end
    if params[:a_r1] && params[:a_r1]!="" && params[:a_r1]!=nil
      age_range<<params[:a_r1]
    end
    if params[:a_r13] && params[:a_r13]!="" && params[:a_r13]!=nil
      age_range<<params[:a_r13]
    end
    if params[:a_r4] && params[:a_r4]!="" && params[:a_r4]!=nil
      age_range<<params[:a_r4]
    end
    if params[:a_r15] && params[:a_r15]!="" && params[:a_r15]!=nil
      age_range<<params[:a_r15]
    end
    if params[:a_r7] && params[:a_r7]!="" && params[:a_r7]!=nil
      age_range<<params[:a_r7]
    end
    
    #push the price all field in age range array
    if params[:p_all] && params[:p_all]!="" && params[:p_all]!=nil && params[:p_all]=="p_all"
      age_range<<params[:p_all]
    end
    
    session[:city] = cookies[:city_new_usr]
    session[:city] = "Walnut Creek" if session[:city].nil?
    session[:cat_zc]="date"
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?

    #if there are no search text it will not display the results.
    act_featured = []
    @activity_featured = act_featured.paginate(:page => params[:page], :per_page =>400)
    
    #~ #display the activities based on the current date
    #~ if params[:d_r]=="today" && params[:d_r]!="" && params[:d_r]!=nil
    #~ @date=Time.now
    #~ @d=@date.strftime("%Y-%m-%d")
    #~ act_free = Activity.order("activity_name asc").select("activities.*, activity_schedules.*").joins(:activity_schedule).where("start_date = '#{@d}'").uniq
    #~ end
    
    #~ #display the list of results based on the params while clicked the check box
    
    if activity_type!='' && activity_type!=nil && activity_type.any? && !activity_type.nil? && activity_type
      @schedule_mode=""
      if !activity_type.include?('all')
        r = 1
        activity_type.each { |s|
          if r == 1
            @schedule_mode.concat(" and lower(schedule_mode)  = '#{s.downcase.strip}'")
          else
            @schedule_mode.concat("or lower(schedule_mode)  = '#{s.downcase.strip}'")
          end
          r+=1
        }
      end #include ending
    end

    
    #when we click the age range it will display the result.
    if age_range!='' && age_range!=nil && age_range.any? && !age_range.nil? && age_range
      @age_range= ""
      if !age_range.include?('a_all') && !age_range.include?('p_all')
        s= 1
        age_range.each { |age|
          if s == 1
            @age_range.concat(" and lower(age_range) = '#{age.downcase.strip}'")
          else
            @age_range.concat("or lower(age_range)  = '#{age.downcase.strip}'")
          end
          s+=1
        }
      end
    end #age range end
      
    #display the values based on the free activities
    if params[:a_f]!="" && params[:a_f]=="free" && params[:a_f]!=nil
      @a_free= ""
      @a_free = ("and filter_id ='3'")
    end
         
    #display the results based on the paid and free results
    if params[:paid]!="" && params[:paid]=="paid" && params[:paid]!=nil && params[:a_f]!="" && params[:a_f]=="free" && params[:a_f]!=nil
      @a_paid= ""
      @a_paid = ("or price > 0")
    elsif params[:paid]!="" && params[:paid]=="paid" && params[:paid]!=nil
      @a_paid= ""
      @a_paid = ("and price > 0")
    end

    #display the results when the user enter the text in text box
    if params[:q] !="" && params[:q]!=nil && params[:q]
      @search=""
      @search = ("and lower(activity_name) = '%#{params[:q].downcase.strip}%'")
    end

    #display the zipcode details based on the user text
    if params[:z_c] !="" && params[:z_c]!=nil && params[:z_c] && params[:z_c]!="Enter Zip Code"
      @zipcode=""
      @zipcode = ("and lower(zip_code) = '#{params[:z_c].downcase.strip}'")
    end
	
    #display the data based on the city selection
    if params[:city_1] !="" && params[:city_1]!=nil && params[:city_1]
      @s_cty=""
      @s_cty = ("and lower(city) = '#{params[:city_1].downcase.strip}'") if params[:city_1] !="" && params[:city_1]!=nil && params[:city_1]
    end
    
    #when we click the activity subcategory it will display the result.
    if activity_subcategory!='' && activity_subcategory!=nil && activity_subcategory.any? && !activity_subcategory.nil? && activity_subcategory
      @sub_category= ""
      c= 1
      activity_subcategory.each { |sub|
        if c == 1
          @sub_category.concat(" and lower(sub_category) = '#{sub.downcase.strip}'")
        else
          @sub_category.concat("or lower(sub_category)  = '#{sub.downcase.strip}'")
        end
        c+=1
      }
    end #activity subcategory end

    #get the results based on the query
    
    #~ if @schedule_mode.present? || @age_range.present? || @a_free.present? || @a_paid.present? || @zipcode.present? || @s_cty.present? || @sub_category.present?
    act_free = Activity.find_by_sql("select * from activities where lower(active_status) = 'active'
	#{@schedule_mode} #{@age_range} #{@a_free} #{@a_paid} #{@search} #{@zipcode} #{@s_cty} #{@sub_category} order by activities.activity_id desc") 
    #~ end
    act_free = [] if act_free.nil?
    @activity_free = act_free.paginate(:page => params[:page], :per_page =>36)

    if !current_user.nil?
      act_provider =  []
      @activity_share_provider = act_provider.paginate(:page => params[:page], :per_page =>400)

      act_saved_fav = []
      @activity_saved_favorites = act_saved_fav.paginate(:page => params[:page], :per_page =>400)
      #~ add_to_activity_row(params[:activity_row],params[:remove_row])
      @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT lower(trim(category))as category")
      #~ @provider_activites = ActivityRow.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]],:select => "DISTINCT lower(trim(row_type))as row_type").collect {|r| r.row_type if !r.row_type.nil?}@provider_activites = ActivityRow.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]],:select => "DISTINCT lower(trim(row_type))as row_type").collect {|r| r.row_type if !r.row_type.nil?}
      @provider_activites = []
      @checck = ActivityRow.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]],:select => "row_type")
      @provider_activites_check =[]
      @checck.each do |s|
        @provider_activites_check<< s.row_type
      end
    end
    respond_to do |format|
      format.html
      format.js
    end
    
  end
  
  def save_favorites
    @activity_id = params[:activity_id]
    @name = params[:name]
    @before_login_value = params[:before_login_value] if !params[:before_login_value].nil? && params[:before_login_value].present?
  end

  def data_entry
    #cookies[:search_city] = "Walnut Creek"
    if !cookies[:search_city].nil? && cookies[:search_city]!=""
      city_se = City.where("city_name='#{cookies[:search_city]}'").last
      if !city_se.nil?
        cookies[:latitude] = city_se.latitude
        cookies[:longitude] = city_se.longitude
      end
    end
    #a_coord = Geocoder.coordinates("#{city.titlecase}")
    if cookies[:latitude].nil? && cookies[:longitude].nil?
      re_times = 5
      begin
        location = Geocoder.search("#{request.ip}").first
        cookies[:latitude] = location.latitude
        cookies[:longitude] = location.longitude
        cookies[:search_city] = location.city
        if ((cookies[:latitude] == 0.0) ||(location.country == "India"))
          cookies[:latitude] = 37.9100783
          cookies[:longitude] = -122.0651819
          cookies[:search_city] = "Walnut Creek"
        end
      rescue Exception => e
        re_times-=1
        if re_times>0
          retry
        else
          cookies[:latitude] = 37.9100783
          cookies[:longitude] = -122.0651819
          cookies[:search_city] = "Walnut Creek"
        end
      end
    end
    #    if params[:set_p].nil?
    #      params[:set_p] = "1"
    #    end

    #a_coord = Geocoder.coordinates("#{}")
    @events = []
    search_curator("1")
    #    if (@search.total <=30) || (@events.length < 30 && params[:set_p] == "1")
    #      params[:page] =1
    #      params[:set_p] = "2"
    #      search_curator("2")
    #    end
    
    total_pgae = @search.results.total_pages
    @events.unshift({:data => "all",:value=>"#{params[:query]}",:act=>"Show All",:cur_set =>params[:set_p],:cur_page=>params[:page] || 1, :total_p=>total_pgae,:w_plan_name=>"z"})
    # plan =User.order("user_plan desc").find(:all,:conditions=>["user_id = ?", cookies[:uid_usr]]).map(&:user_plan)
    #  @search.results.map {  |record| user = UserProfile.find_by_user_id(record.user_id);; events << {:city=> record.city, :user_id=>record.user_id,:provider_name=> user.business_name,  :activity_name=> record.activity_name, :data=> record.activity_id, :value=> "#{record.activity_name} " + "#{record.city}"  +" #{user.business_name}" } }

    #    @search.results.map { |record|
    #      user = UserProfile.where("user_id = #{record.user_id}").last
    #      events << {:category=>record.category,:sub_category=>record.sub_category,:city=> record.city,:w_activity_name=> record.activity_name,:w_provider_name=>user.business_name,:w_city=>record.city,:user_id=>record.user_id,:provider_name=>truncate(user.business_name, :length =>25),:pass_value=>params[:query],:activity_name=>truncate(record.activity_name, :length =>25), :data=> record.activity_id, :value=> "#{record.activity_name} "  + " #{user.business_name} "+ " #{record.city}"  } if !user.business_name.nil? if !user.nil?
    #    }
   
    #events = events.sort_by { |k| k[:w_plan_name] }.reverse
    

    @activities  = {
      query: "Unit",
      suggestions: @events }
    render :json =>@activities
  end

  def search_curator(second_set)

    @search = Sunspot.search(Activity,User) do
      fulltext params[:query] do
        query_phrase_slop 1
        # minimum_match 1
        phrase_fields :city => 10,:user_profile_name => 9,:activity_name =>8
        fields(:city=>9,:user_profile_name=>9,:activity_name =>8,:category=>8,:sub_category=>8,:tags_txt=>8)
      end

      order_by_geodist(:location, cookies[:latitude], cookies[:longitude])
      #with(:location).near(37,-122,:boost => 2, :precision => 6)

      #with(:location).in_radius(37, -122, 100, :bbox => true)
      # with(:location).in_radius(cookies[:latitude], cookies[:longitude], 500)

      any_of do
        with :expiration_date, nil
        all_of do
          #          #with(:start_date).greater_than_or_equal_to Date.today
          with(:expiration_date).greater_than_or_equal_to Date.today
        end
      end
      #      if second_set == "1"
      #        with :user_plan,"sell"
      #      end
      #      if second_set == "2"
      #        without :user_plan,"sell"
      #      end

      #without :user_plan,"free"
      with :show_card,true
      with :cleaned,true
      with :active_status, "Active"
      paginate :page =>params[:page] || 1, :per_page => 30
      #order_by :score, :desc
      # order_by_geodist(:location, cookies[:latitude], cookies[:longitude])
      order_by :user_plan,:desc
      # adjust_solr_params { |p| p[:defType] = 'edismax' }
    end

    @search.results.each { |record|
      user_setting(record.user_id)
      if record.class == Activity
        user = UserProfile.where("user_id = #{record.user_id}").last
        user_p = User.where("user_id = #{record.user_id}").last
        if @flag
          @events << {:w_class=>"activity",:category=>record.category,:sub_category=>record.sub_category,:city=> record.city,:w_activity_name=> record.activity_name,:w_provider_name=>user.business_name,:w_city=>record.city,:user_id=>record.user_id,:provider_name=>truncate(user.business_name, :length =>25),:pass_value=>params[:query],:activity_name=>truncate(record.activity_name, :length =>25),:w_plan_name => user_p.user_plan , :data=> record.activity_id, :value=> "#{record.activity_name} "  + " #{user.business_name} "+ " #{record.city}",:w_slug => record.slug, :up_slug => user.slug} if !user.slug.nil? if !user.business_name.nil? if !user.nil?
        end
      else
        user = UserProfile.where("user_id = #{record.user_id}").last
        if @flag
          @events << {:w_class=>"user",:w_provider_name=>user.business_name,:user_id=>record.user_id,:provider_name=>truncate(user.business_name, :length =>25),:w_plan_name => record.user_plan , :pass_value=>params[:query],:city =>"#{user.city}",:w_city=>"#{user.city}", :data=> record.user_id, :value=> " #{user.business_name}" } if !user.business_name.nil? if !user.nil?
        end
      end
    }

  end



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


  #provider page ajax call update
  def activity_update
    session[:city] = params[:city] unless params[:city].nil?
    session[:date] = params[:date] unless params[:date].nil?
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    session[:city] = "Walnut Creek" if session[:city].nil?
    act = Activity.get_providertype_zip_code_update(session[:city],params[:zip_code],session[:date],cookies[:uid_usr])
    @activities = act.paginate(:page => params[:page], :per_page =>10)
    respond_to do |format|
      format.js
      format.json {render :json =>@activities}
    end
  end


  #provider gallery view
  def provider_activites_old
	  
    @get_current_url = request.env['HTTP_HOST']
    #profile image changes
    if !current_user.nil? && !current_user.user_profile.nil?
      @profile_data=current_user.user_profile if !current_user.user_profile.nil?
      @aa='$image_global_path'+@profile_data.profile.url(:thumb)
      @profile_ig=FastImage.size(@aa)
      @p_f = @aa if @profile_ig!="" && !@profile_ig.nil?
    end

    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT lower(trim(category))as category")
    session[:city] = params[:city] unless params[:city].nil?
    session[:city] = "Walnut Creek" if session[:city].nil?
    session[:date] = params[:date] unless params[:date].nil?
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    add_to_activity_row(params[:activity_row],params[:remove_row])
    @activity_featured = []
    act_featured = Activity.get_provider_activities(session[:city],params[:zip_code],session[:date],1,cookies[:uid_usr])
    @activity_featured = act_featured.paginate(:page => params[:page], :per_page =>400)
    @activity_share_provider = []
    act_provider = Activity.get_shared_activities(cookies[:uid_usr],current_user.email_address)
    @activity_share_provider = act_provider.paginate(:page => params[:page], :per_page =>400)
    #~ act_free = Activity.get_provider_activities(session[:city],"",session[:date],3,cookies[:uid_usr])
    #~ @activity_free = act_free.paginate(:page => params[:page], :per_page =>400)
    @activity_free = []
    act_free = Activity.get_provider_activities_free(session[:city],"",session[:date],cookies[:uid_usr])
    @activity_free = act_free.paginate(:page => params[:page], :per_page =>400)
    @activity_saved_favorites = []
    act_saved_fav = Activity.get_saved_favorites(session[:city],params[:zip_code],session[:date],cookies[:uid_usr])
    @activity_saved_favorites = act_saved_fav.paginate(:page => params[:page], :per_page =>400)
    @activity_created_activities = []
    act_created_fav = Activity.get_saved_created_activities(session[:city],session[:zip_code],session[:date],cookies[:uid_usr])
    @activity_created_activities = act_created_fav.paginate(:page => params[:page], :per_page =>400)
     
    @provider_activites = []
    @provider_activites = Activity.order("category Asc").find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]],:select => "DISTINCT category")
  end

  #before deleting the activity
  def delete_activity
	  
    @page = params[:page]
    @to_delete=params[:id].split(',')
    @list = params[:mul]
    @del_act = params[:del_action]
    #render :layout => nil
    #@activity = Activity.find(@to_delete) if (@to_delete.present? && !@to_delete.nil?)
  end

  #update the activity status while change the text
  def update_active_status
    @activity_data=params[:id]
    @activity_status=params[:status]
    @school_present =  params[:school_r_present]
    @school_id =  params[:school_r_id]
    @get_current_url = request.env['HTTP_HOST']
    @activity=Activity.find(@activity_data) if !@activity_data.nil?

    @school_rep = SchoolRepresentative.find(@school_id) if (@school_present == 'true' && @school_id && @school_id.present?)
    if @activity_status=="Active"
      @astatus = @activity.update_attributes(:active_status=>"Active")
      
      if @school_present=='true' && @school_rep && @school_rep.status.downcase=='accepted' && @school_rep.vendor_id==current_user.user_id
        @set_update = true
      end
      
      @provider_notify_status = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='4' and p.user_id='#{@activity.user_id}' and p.notify_flag=true") if !@activity.nil? && !@activity.user_id.nil?
      #user present in setting table
      if @provider_notify_status.present? && @provider_notify_status!="" && !@provider_notify_status.nil?
        #sending a nofification while status changed
        @user=User.find_by_user_id(@activity.user_id) if !@activity.nil? && !@activity.user_id.nil?
        user_email_id=@user.email_address if !@user.email_address.nil? &&  !@user.nil? && @user.user_flag==TRUE
        #@result = UserMailer.activity_status_mail(@user,@activity,@get_current_url,params[:message],user_email_id,params[:subject]).deliver
        @result = UserMailer.delay(queue: "Activity Status", priority: 2, run_at: 10.seconds.from_now).activity_status_mail(@user,@activity,@get_current_url,params[:message],user_email_id,params[:subject])

      end
    elsif @activity_status=="Inactive"
      @astatus = @activity.update_attributes(:active_status=>"Inactive")
      if @school_present=='true' && @school_rep && @school_rep.status.downcase=='accepted' && @school_rep.vendor_id==current_user.user_id
        @school_rep.update_attributes(edit_p: false, delete_p: false)
        @set_update = false
      end
      if @provider_notify_status.present? && @provider_notify_status!="" && !@provider_notify_status.nil?
        #sending a nofification while status changed
        @user=User.find_by_user_id(@activity.user_id) if !@activity.nil? && !@activity.user_id.nil?
        user_email_id=@user.email_address if !@user.email_address.nil? &&  !@user.nil? && @user.user_flag==TRUE
        @result = UserMailer.delay(queue: "Activity Status", priority: 2, run_at: 10.seconds.from_now).activity_status_mail(@user,@activity,@get_current_url,params[:message],user_email_id,params[:subject])
        #@result = UserMailer.activity_status_mail(@user,@activity,@get_current_url,params[:message],user_email_id,params[:subject]).deliver
      end
    end
    
    #memcache resetting here
    if @astatus && @astatus==true
	$dc.set("activity_schedules_for#{@activity.activity_id}",nil)
	$dc.set("provider_activity_for#{current_user.user_id}",nil) if current_user.present?
    end

    respond_to do |format|
      format.js
    end

  end

  #delete the activities with the associated data
  def destroy
    activity_details=params[:id].split(",")
    @get_current_url =  request.env['HTTP_HOST']
    @del_mode = params[:del_mode]
    @del_mode_act = params[:del_mode_act]
    activity_details.each {|act|
      activity=act.gsub(/[^0-9A-Za-z]/, '')
      if activity!="" && !activity.nil?
        @act=Activity.find(activity) if !activity.nil?
        @activity_user = User.find_by_user_id(@act.user_id) if !@act.nil? && @act.present?
        #update the activity record as delete status.
        chk_del = @act.update_attributes(:active_status=>"Delete",:modified_date=>Time.now)
	if chk_del
		$dc.set("activity_schedules_for#{@act.activity_id}",nil)
		$dc.set("provider_activity_for#{@activity_user.user_id}",nil)
	end
         
        #setting notification for the users
        @provider_notifications = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='1' and p.user_id='#{@act.user_id}' and p.notify_flag=true") if !@act.nil? && !@act.user_id.nil?
        # if user present in setting tables
        if @provider_notifications.present? && @provider_notifications!="" && !@provider_notifications.nil?
          #~ #sending mail to the participant while delete the activity  ----dont remove this code----
          @participant = ActivityAttendDetail.select("user_id").where("activity_id=? and lower(payment_status)=?",@act.activity_id,'paid').group("user_id")
          #~ @participant = ActivityAttendDetail.find(:all,:conditions=>["activity_id = ? ", @act.activity_id])
          @participant.each do |r|
            user_parent=User.find_by_user_id(r.user_id)
            email_parent=user_parent.email_address if !user_parent.nil? && !user_parent.email_address.nil?
            if email_parent !="" && !email_parent.nil? && !email_parent.blank? && user_parent.user_flag==TRUE
              @result = UserMailer.delay(queue: "Cancel Activity to participant", priority: 2, run_at: 10.seconds.from_now).cancel_activity_mail_to_parent(user_parent.user_name,@act,@get_current_url,email_parent,@activity_user)
              #@result = UserMailer.cancel_activity_mail_to_parent(user_parent.user_name,@act,@get_current_url,params[:message],email_parent,params[:subject]).deliver
            end  if user_parent.present? && !user_parent.nil?
          end if !@participant.nil? && @participant.present?
        else #first if the user not present in setting tables.
          #~ #sending mail to the participant while delete the activity  ----dont remove this code----
          #~ @participant = ActivityAttendDetail.find(:all,:conditions=>["activity_id = ? ", @act.activity_id])
          @participant = ActivityAttendDetail.select("user_id").where("activity_id=? and lower(payment_status)=?",@act.activity_id,'paid').group("user_id")
          @participant.each do |r|
            user_parent=User.find_by_user_id(r.user_id)
            email_parent=user_parent.email_address if !user_parent.nil? && !user_parent.email_address.nil?
            if email_parent !="" && !email_parent.nil? && !email_parent.blank? && user_parent.user_flag==TRUE
              @result = UserMailer.delay(queue: "Cancel Activity to participant", priority: 2, run_at: 10.seconds.from_now).cancel_activity_mail_to_parent(user_parent.user_name,@act,@get_current_url,email_parent,@activity_user)
              #@result = UserMailer.cancel_activity_mail_to_parent(user_parent.user_name,@act,@get_current_url,params[:message],email_parent,params[:subject]).deliver
            end  if user_parent.present? && !user_parent.nil?
          end if !@participant.nil? && @participant.present?
        end #first if end
		  
        #setting notification for the users
        @provider_notification_default = ProviderNotificationDetail.find_by_sql("select * from provider_notification_details pn left join provider_notifications p on pn.provider_notify_id=p.provider_notify_id where pn.notify_action='6' and p.user_id='#{@act.user_id}' and p.notify_flag=true") if !@act.nil? && !@act.user_id.nil?
        #user present in setting notify me when the record is removed
        if @provider_notification_default.present? && @provider_notification_default!="" && !@provider_notification_default.nil?
          #sending mail while delete the activity by the provider.
          user=User.find_by_user_id(@act.user_id) if !@act.nil?
          attend_email=user.email_address if !user.nil? && !user.email_address.nil?
          user_name=user.user_name if !user.user_name.nil?
          if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
            @result = UserMailer.delay(queue: "Delete Activity", priority: 2, run_at: 10.seconds.from_now).delete_activity_mail(user,@act,@get_current_url,attend_email)
            #@result = UserMailer.delete_activity_mail(user_name,@act,@get_current_url,params[:message],attend_email,params[:subject]).deliver
          end  if user.present? && !user.nil?
        else
          #user not present in setting table
          #sending mail while delete the activity by the provider.
          user=User.find_by_user_id(@act.user_id) if !@act.nil?
          attend_email=user.email_address if !user.email_address.nil?
          user_name=user.user_name if !user.nil? && !user.user_name.nil?
          if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE
            @result = UserMailer.delay(queue: "Delete Activity", priority: 2, run_at: 10.seconds.from_now).delete_activity_mail(user,@act,@get_current_url,attend_email)
            #@result = UserMailer.delete_activity_mail(user_name,@act,@get_current_url,params[:message],attend_email,params[:subject]).deliver
          end  if user.present? && !user.nil?
        end #provider notification if end
	
        # for deleting the record from the activity table ----dont remove this code----

        #~ @schedule=ActivitySchedule.find_by_activity_id(@act) if !@act.nil?
        #~ @repeat = ActivityRepeat.find_by_activity_schedule_id(@schedule.schedule_id)if !@schedule.nil?
        #~ @repeat.destroy if !@repeat.nil?
        #~ @schedule.destroy if !@schedule.nil?
        #~ @fav = ActivityFavorite.destroy_all(:activity_id => @act) if !@act.nil?
        #~ @share = ActivityShared.find_by_activity_id(@act) if !@act.nil?
        #~ @share.destroy if !@share.nil?
        #~ Activity.find(activity).destroy if !activity.nil?
      end #if method

    } if !activity_details.nil? && activity_details!=""

    session[:city] = params[:city] unless params[:city].nil?
    session[:date] = params[:date] unless params[:date].nil?
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    session[:city] = "Walnut Creek"  if session[:city].nil?

    cookies[:last_action] = params[:last_action] if !params[:last_action].nil? && params[:last_action].present?
    cookies[:page] = params[:page] if !params[:page].nil? && params[:page].present?

    act = Activity.get_providertype_zip_code(session[:city],params[:zip_code],session[:date],cookies[:uid_usr])
    if !cookies[:last_action].nil? && cookies[:last_action].present? && !cookies[:page].nil? && cookies[:page].present? && (cookies[:last_action]=="provider_edit_activity" || cookies[:last_action]=="delete_activity")
      @activities = act.paginate(:page => params[:page], :per_page =>10)
      if @activities.length==0 && !act.nil? && act.present?
        params[:page] = (params[:page].to_i) - 1
        @activities = act.paginate(:page => params[:page], :per_page =>10)
      end
    end

    #if (!params[:del_action].empty? && (params[:del_action]=='index' || params[:del_action]=='admin_list' || params[:del_action]=='thumb_index' ))
    #  render :text => 'true'
    #else
    respond_to do |format|
      format.js
    end
    #end
  end

  def test_repeat
    #    @raj = Activity.select("activities.*").joins(:activity_schedule).where("start_date <= '2012-12-28'").uniq

    #    @activities = Activity.find_by_sql("SELECT DISTINCT activities.*, activity_schedules.schedule_mode,activity_schedules.start_date,activity_schedules.end_date FROM activities INNER JOIN activity_schedules ON
    #                                  activity_schedules.activity_id = activities.activity_id WHERE lower(active_status)='active' And lower(city) = 'san francisco'
    #                                  and filter_id=5 And (start_date <='2012-12-30') Or
    #                                  (lower(activities.schedule_mode)='any time' And filter_id=5 And lower(city) = 'san francisco') order by activity_id desc #").uniq
    #
    @activities = Activity.find_by_sql("select * from activities where activity_id = 102 order by activity_id desc").uniq

    events = []
    @activities.each do |event|
      @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
      schedule_repeat_activity(event,events)
    end
    @activity = events

  end

  #parent index page
  def event_index
    session[:city] = cookies[:city_new_usr]
    session[:city] = "San Francisco" if session[:city].nil?

    session[:cat_zc]="date"
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    
    @get_current_url = request.env['HTTP_HOST']
    #profile image changes
    if !current_user.nil? && !current_user.user_profile.nil?
      @profile_data=current_user.user_profile if !current_user.user_profile.nil?
      @aa='$image_global_path'+@profile_data.profile.url(:thumb)
      @profile_ig=FastImage.size(@aa)
      @p_f = @aa if @profile_ig!="" && !@profile_ig.nil?
    end
    
    #variable for array
    #@act_event_index = Activity.order("activity_id desc").find(:all)
    
    #@activity_featured = Activity.find_by_sql("select * from activities where activity_id in (select activity_id from activity_bids where lower(bid_status) = 'active' order by bid_amount asc) and lower(active_status)='active' or (featured_flag = true and lower(active_status)='active') order by featured_flag asc limit 100")
    @activity_featured = Activity.find_by_sql("select * from activities INNER JOIN activity_schedules ON activity_schedules.activity_id = activities.activity_id where activities.activity_id in (select activity_id from activity_bids where lower(bid_status) = 'active' order by bid_amount asc) and lower(active_status)='active' or (featured_flag = true and lower(active_status)='active') order by featured_flag asc limit 60").uniq
 
    events = []
    act_free = Activity.get_activities_repeat(session[:city],params[:zip_code],session[:date],3)
    act_free.each do |event|
      @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
      schedule_repeat_append(event,events,"created") if !@schedule.nil?
    end
    @activity_free = events
    act_provider =  Activity.get_shared_activities(cookies[:uid_usr],current_user.email_address)
    @activity_share_provider = act_provider.paginate(:page => params[:page], :per_page =>400)

    act_saved_fav = Activity.get_saved_favorites(session[:city],params[:zip_code],session[:date],cookies[:uid_usr])
    @activity_saved_favorites = act_saved_fav.paginate(:page => params[:page], :per_page =>400)
    user_id = current_user.user_id
    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT lower(trim(category))as category")
    @provider_activites =  ActivityRow.select("Distinct(activities.category)").order("activities.category Asc").joins("left join activities on lower(activities.sub_category)=lower(activity_rows.row_type)").where("activity_rows.user_id = ?",cookies[:uid_usr]).group("activities.category")
    @follow_parent_user = UserRow.where("user_id=#{user_id} and user_type='U'").map(&:row_user_id)
    @follow_provider_user = UserRow.where("user_id=#{user_id} and user_type='P'").map(&:row_user_id)
    @checck = ActivityRow.find(:all,:conditions=>["user_id = ? ",user_id],:select => "row_type")
    @provider_activites_check =[]
    @checck.each { |s| @provider_activites_check<< s.row_type }
    
    respond_to do |format|
      format.html
      format.js
    end

  end
  
  def landing_search
    params[:event_search]

    session[:city] = cookies[:city_new_usr]
    session[:city] = "Walnut Creek" if session[:city].nil?
    session[:cat_zc]="date"
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    
    @get_current_url = request.env['HTTP_HOST']
    #profile image changes
    if !current_user.nil? && !current_user.user_profile.nil?
      @profile_data=current_user.user_profile if !current_user.user_profile.nil?
      @aa='$image_global_path'+@profile_data.profile.url(:thumb)
      @profile_ig=FastImage.size(@aa)
      @p_f = @aa if @profile_ig!="" && !@profile_ig.nil?
    end
    

    #if there are no search text it will not display the results.
    act_free = Activity.search_parent(params[:event_search])
    act_free = [] if act_free.nil?
    @activity_free = act_free.paginate(:page => params[:page], :per_page =>36)
    #~ if !current_user.nil?
    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT lower(trim(category))as category")
    #~ @checck = ActivityRow.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]],:select => "row_type")
    @checck = []
    @provider_activites_check =[]
    @checck.each do |s|
      @provider_activites_check<< s.row_type
    end if !@checck.nil?
    #~ end
    respond_to do |format|
      format.html
      format.js
    end
	  
  end
  
  def search_event_index
    @fam_city = City.order(:city_name) 
    if !cookies[:search_city].nil? && cookies[:search_city]!=""
      city_se = City.where("city_name='#{cookies[:search_city]}'").last
      if !city_se.nil?
        cookies[:latitude] = city_se.latitude
        cookies[:longitude] = city_se.longitude
      end
    end
    if !params[:zip_value].nil? && params[:zip_value]!="" && params[:zip_value] !="Enter city (or) Zip code"
      if params[:page].nil? || params[:page]== "1"
        re_times = 5
        begin
          location = Geocoder.search("#{params[:zip_value]}").first
          cookies[:latitude] = location.latitude
          cookies[:longitude] = location.longitude
          cookies[:search_city] = location.city
          if cookies[:latitude] == 0.0 || cookies[:search_city]==""
            cookies[:latitude] = 37.9100783
            cookies[:longitude] = -122.0651819
            cookies[:search_city] = "Walnut Creek"
          end
          if !location.city.nil? && location.city!=""
            ci_se = City.where("lower(city_name) like '%#{cookies[:search_city].downcase}%'").last
            if !ci_se.nil?
              cookies[:latitude] = ci_se.latitude
              cookies[:longitude] = ci_se.longitude
            end
          end
        rescue Exception => e
          re_times-=1
          if re_times>0
            retry
          else
            cookies[:latitude] = 37.9100783
            cookies[:longitude] = -122.0651819
            cookies[:search_city] = "Walnut Creek"
          end
        end
      end
    elsif cookies[:latitude] == 0.0 || cookies[:search_city]=="" || cookies[:search_city].nil?
      cookies[:latitude] = 37.9100783
      cookies[:longitude] = -122.0651819
      cookies[:search_city] = "Walnut Creek"
    end


    special = []
    if params[:camp_range_1] == "specials"
      acc_special = Activity.find_by_sql(" select distinct a.* from activities a
    left join activity_prices p on a.activity_id=p.activity_id
    right join activity_discount_prices d on d.activity_price_id=p.activity_price_id
    where cleaned=true and lower(active_status)='active' and
    (lower(d.discount_type)='early bird discount' and d.discount_valid >= '#{Date.today}') or (lower(d.discount_type)!='early bird discount' )")
      @special = acc_special.map(&:activity_id)
    end

    if params[:specials] && params[:specials]!="" && !params[:specials].nil?
      @f_specials = params[:specials]
      if @parent_keyword && params[:specials] && !params[:specials].nil?
        act_free = Activity.find_by_sql("select distinct act.* from activities act left join activity_prices p on act.activity_id=p.activity_id left join activity_discount_prices d on d.activity_price_id=p.activity_price_id where #{search_city} and cleaned=true and lower(active_status)='active' and act.price_type='1' and(lower(d.discount_type)='early bird discount' and date(d.discount_valid) >= '#{@sp_date}') or (lower(d.discount_type)!='early bird discount') and (lower(act.activity_name) like '%#{@parent_keyword}%' or lower(act.category) like '%#{@parent_keyword}%' or lower(act.sub_category) like '%#{@parent_keyword}%' or lower(act.description) like '%#{@parent_keyword}%' or lower(act.city) like '%#{@parent_keyword}%') order by act.activity_id desc") if params[:specials]!=nil && params[:specials]!='' && !@parent_keyword.nil?
      else
        act_free = Activity.find_by_sql("select distinct act.* from activities act left join activity_prices p on act.activity_id=p.activity_id left join activity_discount_prices d on d.activity_price_id=p.activity_price_id where #{search_city} and cleaned=true and lower(active_status)='active' and act.price_type='1' and(lower(d.discount_type)='early bird discount' and date(d.discount_valid) >= '#{@sp_date}') or (lower(d.discount_type)!='early bird discount') order by act.activity_id desc") if !@sp_date.nil?
      end
    end
  
	
    if !params[:ad_search_value].nil? && params[:ad_search_value]!=""
      params[:event_search] = params[:ad_search_value]
    end

    if params[:week]=="1"
      week = []
      week << Date.today.end_of_week - 1.day
      week << Date.today.end_of_week
      @search = Activity.search do
        keywords params[:event_search] do
          #query_phrase_slop 1
          minimum_match 1
          phrase_fields :user_profile_name => 9,:activity_name =>8
          fields(:city=>10,:user_profile_name=>9,:activity_name =>8,:category=>1,:sub_category=>1)
        end
        any_of do
          with(:start_date, nil)
          all_of do
            week.each do |w|
              with(:start_date, w)
            end
          end
        end

        paginate :page =>params[:page] || 1, :per_page => 25
        with :cleaned,true
        with :active_status, "Active"
        order_by :score, :desc
      end
    else
      if params[:search_set_p].nil?
        params[:search_set_p] = "1"
      end
      @search_sell = []
      #      if params[:page].nil?
      #        search_advance_curator("0")
      #        @search_count = @search.total
      #        @search_cu = "yes"
      #      end
      #
      #      search_advance_curator(params[:search_set_p])
      #      @activity_free = @search.results
      #      if (@search.total <=25) || (@activity_free.length < 25 && params[:search_set_p] == "1")
      #        params[:page] = 1
      #        params[:search_set_p] = "2"
      search_advance_curator("2")
      @act_cur = @search.results
      @activity_free = @search.results
      @tpage = @search.results.total_pages
      #      else
      #        @tpage = @activity_free.total_pages
      #      end
    end
    @search_tu = "yes"
    @search_count = @search.total
    if params[:type] == "provider" && !params[:user_id].nil? && params[:user_id]!=""
      @user_curated = User.where("user_id=#{params[:user_id]} and show_card=true").last
      @user_profile_curated = UserProfile.where("user_id=#{params[:user_id]}").last if !@user_curated.nil?
    end
    @keyword =  params[:event_search]
    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT trim(category) as category",:conditions=>["lower(category)!=?",'default'])
    if !params[:type].nil? && params[:type] == "city"
      @keyword = "#{params[:city_name]}" if params[:type] == "city"
    else
      @keyword = "#{params[:event_search].html_safe if !params[:event_search].nil? }" + " " + "#{params[:city_name]}" if params[:type] == "city"
    end
    #@keyword =  params[:event_search] = "#{params[:event_search].html_safe if !params[:event_search].nil?}" + " " + "#{params[:pro_name]}" if params[:type] == "provider"
    # @keyword =  params[:event_search] = "#{params[:city_name]}" if params[:type] == "city"
    if params[:type] == "provider" && @search_tu == "yes"
      @keyword =  params[:event_search] = "#{params[:pro_name]}"
      @search_count = @search_count + 1 if !@user_curated.nil?
    end
	if request.headers['X-PJAX']
	    respond_to do |format|
	      format.js {render :layout => false}
	      format.html {render :layout => false}
           end	
        else
		respond_to do |format|
			format.js
			format.html
		end		
	end

  end


  def search_advance_curator(second_set)

    categories =[]
    categories = params[:ad_sub_category_1].split(",").reject(&:empty?) if !params[:ad_sub_category_1].nil? && params[:ad_sub_category_1]!=""
    day_of_week = params[:age_rangera].downcase.split(",").reject(&:empty?) if !params[:age_rangera].nil? && params[:age_rangera]!=""
    price_value = params[:price_value] if !params[:price_value].nil? && params[:price_value]!=""

    if !params[:city_name].nil? && params[:city_name]!=""
      params[:city_search_ra] = params[:city_name]
    end
    if params[:p_all]!= "p_all"
      if params[:a_f] == "free"
        free = true
      end
      if params[:paid]== "paid"
        paid = true
      end
    end
    age_range = []
    if params[:aa_all] !="a_all"
      if params[:aa_r1] == "0-3"
        age_range << (0..3).to_a
      end
      if params[:aa_r4] == "4-7"
        age_range << (4..7).to_a
      end
      if params[:aa_r8] == "8-15"
        age_range << (8..99).to_a
      end
    end
    if params[:camp_range_1] == "camp"
      camp = true
    end
    special = []
    special = @special
    start_date =""
    age_range_flat = age_range.flatten
    end_date = Date.today
    start_date =  params[:start_dates] if !params[:start_dates].nil? && params[:start_dates]!=""
    end_date = params[:end_dates] if !params[:end_dates].nil? && params[:end_dates]!=""

    @search = Sunspot.search(Activity,User) do
      fulltext params[:event_search] do
        query_phrase_slop 1
        # minimum_match 1
        phrase_fields :city => 10,:user_profile_name => 9,:activity_name =>8
        fields(:city=>9,:user_profile_name=>9,:activity_name =>8,:category=>8,:sub_category=>8,:tags_txt=>8)
      end

      if !categories.empty?
        any_of do
          categories.each do |c|
            with(:sub_category_lower, c.downcase)
          end
        end
      end
      order_by_geodist(:location, cookies[:latitude], cookies[:longitude]) if params[:type] != "provider"
      #        if (cookies[:latitude].present? && cookies[:longitude].present?)
      #          with(:location).in_radius(cookies[:latitude], cookies[:longitude], 5, :bbox => false)
      #        end

      if free
        with(:price_type,3)
      end

      #calls on camp&works shop search
      if camp == true
        without(:schedule_mode,'Schedule')
        without(:schedule_mode,'Any Time')
        without(:schedule_mode,'By Appointment')
      end
      #calls on when
      if paid
        without(:price_type,3)
      end

      if special
        any_of do
          special.each do |s|
            with(:activity_id, s)
          end
        end
      end
      if !params[:start_dates].nil? && params[:start_dates]!="" && !params[:end_dates].nil? && params[:end_dates]!=""
        all_of do
          with(:start_date).greater_than_or_equal_to start_date
          with(:expiration_date).less_than_or_equal_to end_date
        end
      elsif !params[:start_dates].nil? && params[:start_dates]!=""
        any_of do
          with :start_date, start_date
        end
      elsif !params[:end_dates].nil? && params[:end_dates]!=""
        any_of do
          with :expiration_date, end_date
        end
      else
        any_of do
          with :expiration_date, nil
          all_of do
            with(:expiration_date).greater_than_or_equal_to Date.today
          end
        end
      end

      if day_of_week
        any_of do
          with(:repeat_on,'Daily')
          day_of_week.each do |d|
            with(:repeat_on,d)
          end
        end
      end

      if !age_range_flat.empty?
        # with(:max_age_range,'Adults')
        #with(:min_age_range,'Adults')
        with(:max_age_range).any_of(age_range_flat)
        with(:min_age_range).any_of(age_range_flat)
      end
      #check provider activities in search
      if params[:type] == "provider"
        any_of do
          with(:created_by, "Provider")
        end
        order_by :recent_date,:desc
      end
      #      if second_set == "1"
      #        with :user_plan,"sell"
      #      end
      #      if second_set == "2"
      #        without :user_plan,"sell"
      #      end
     

      #  facet(:user_id)
      with :city_lower,params[:city_name].downcase if !params[:city_name].nil? && params[:city_name]!=""
      with :zip_code,params[:zip_value_name] if params[:zip_value_name] !="Enter city (or) Zip code" && params[:zip_value_name]!="" && !params[:zip_value_name].nil? && !params[:zip_value_name].scan(/^[0-9]+$/).blank?
      with :gender,params[:gender] if !params[:gender].nil? && params[:gender]!='' && params[:gender]!="g_all"
      with :user_id, params[:user_id]  if params[:type] == "provider" && !params[:user_id].nil? && params[:user_id]!=""
      with :show_card,true
      with :cleaned,true
      with :active_status, "Active"
      paginate :page =>params[:page] || 1, :per_page => 25
    
      order_by :user_plan,:desc if params[:type] != "provider"
      #order_by :score, :desc
      #order_by :activity_name, :asc
    end




  end


  
  #advance search in parent view
  def advance_search_hold
    #get the main search page url here
    @search_page = params[:act] if !params[:act].nil?
    session[:city] = cookies[:city_new_usr]
    session[:city] = "Walnut Creek" if session[:city].nil?
    session[:cat_zc]="date"
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    
    @sdate = DateTime.parse(params[:datepicker_ad]).strftime("%Y-%m-%d") if params[:datepicker_ad]!="" && !params[:datepicker_ad].nil?
	  
    @get_current_url = request.env['HTTP_HOST']
    
    arr = []
    date_range = ''
    selected_date = 'no'
    @condition_all = ''
   
    params[:d_mile]
    params[:d_r]
    @basictext = ''
    
    @keyword = params[:search] if !params[:search].nil? && params[:search].present?
    @parent_keyword = @keyword.downcase.gsub("'","") if !@keyword.nil?
    @basictext.concat(" (lower(user_profiles.business_name) like '%#{@parent_keyword}%' or lower(activities.activity_name) like '%#{@parent_keyword}%' or lower(activities.category) like '%#{@parent_keyword}%' or lower(activities.sub_category) like '%#{@parent_keyword}%' or lower(activities.description) like '%#{@parent_keyword}%' or lower(activities.city) like '%#{@parent_keyword}%') ")  if @parent_keyword != 0 and @parent_keyword != nil and @parent_keyword != ""
    
    #storing the selected values in array for activity type
    day_of_the_week=[]
    (1..7).each do |s|
      day_of_the_week<<params["day_of_week_#{s}"] if params["day_of_week_#{s}"] && params["day_of_week_#{s}"]!="" && params["day_of_week_#{s}"]!=nil
    end
   
    #storing the selected values in array for activity type
    @activity_type=[]
    (1..5).each do |s|
      @activity_type<<params["sch_#{s}"] if params["sch_#{s}"] && params["sch_#{s}"]!="" && params["sch_#{s}"]!=nil
    end
    
    @category = params[:ad_sub_category].split(",") if params[:ad_sub_category]!="" && !params[:ad_sub_category].nil?
    @zipcode = params[:z_c] if params[:z_c] !="Enter Zip Code" && params[:z_c]!="" && params[:z_c]!=nil && params[:z_c]
    @city = params[:city_1] if params[:city_1] !="" && params[:city_1]!=nil && params[:city_1]
    @gender = params[:gender]  if !params[:gender].nil? && params[:gender]!=''

    #create the array for age_range values
    age_range = []
    
    if params[:a_all] && params[:a_all]!="" && params[:a_all]!=nil
      age_range<<params[:a_all]
    end
    if params[:a_r10] && params[:a_r10]!="" && params[:a_r10]!=nil
      age_range<<params[:a_r10]
    end
    if params[:a_r1] && params[:a_r1]!="" && params[:a_r1]!=nil
      age_range<<params[:a_r1]
    end
    if params[:a_r13] && params[:a_r13]!="" && params[:a_r13]!=nil
      age_range<<params[:a_r13]
    end
    if params[:a_r4] && params[:a_r4]!="" && params[:a_r4]!=nil
      age_range<<params[:a_r4]
    end
    if params[:a_r15] && params[:a_r15]!="" && params[:a_r15]!=nil
      age_range<<params[:a_r15]
    end
    if params[:a_r7] && params[:a_r7]!="" && params[:a_r7]!=nil
      age_range<<params[:a_r7]
    end
    
    @condition1=''
    @condition2=''
    @condition3=''
    @condition4=''
    @condition5=''
    @condition6=''
    @condition7=''
    @i = 0
    @c = 0
    @z = 0
    @ct = 0
    @p = 0
    @ag = 0

    #if !@activity_type.include?('all')
    # @activity_type.each do |val|
    #  if @i == 0
    #    @condition1.concat("lower(activities.schedule_mode)  = '#{val.downcase.strip}'")  if val != 0 and val != nil and val != "" and val.downcase!='all'
    #  else
    #    @condition1.concat(" or lower(activities.schedule_mode)  = '#{val.downcase.strip}'")  if val != 0 and val != nil and val != "" and val.downcase!='all'
    #  end
    #  @i = @i +1
    #end if !@activity_type.nil?
    #end
    
    #while clicking the camps displayed the activities oct-9-13
    if !params[:acamps].nil? && params[:acamps]!='' && params[:acamps]
      @condition1.concat("lower(activities.schedule_mode) = '#{params[:acamps].downcase.strip}'")  if params[:acamps] !="" && params[:acamps]!=nil && params[:acamps]
    end
    
    @category.each do |val|
      if @c == 0
        @condition2.concat("lower(activities.sub_category) = '#{val.downcase.strip}'") if val != 0 and val != nil and val != "" && val.present? && !val.nil?
        @c = @c +1 if val != 0 and val != nil and val != "" && val.present? && !val.nil?
      else
        @condition2.concat(" or lower(activities.sub_category) = '#{val.downcase.strip}'")  if val != 0 and val != nil and val != "" && val.present? && !val.nil?
        @c = @c +1 if val != 0 and val != nil and val != "" && val.present? && !val.nil?
      end
     
    end if !@category.nil? && @category!="" && @category.any? && @category.present? && @category!=""
   
    if (params[:z_c].nil? || params[:z_c]=="" && params[:city_1].nil? || params[:city_1]=="" && !session['near_cities'].nil?)
      @cond_nearby_cities = "activities.city in #{session['near_cities']} and"
    elsif (params[:z_c].present? || params[:city_1].present?)
      if params[:z_c] !="" && params[:z_c]!=nil && params[:z_c] && params[:z_c]!="Enter Zip Code"
        @condition3 = ("lower(activities.zip_code) = '#{params[:z_c].downcase.strip}'")
      end
      if params[:city_1] !="" && params[:city_1]!=nil && params[:city_1]
        @condition4 = ("lower(activities.city) = '#{params[:city_1].downcase.strip}'") if params[:city_1] !="" && params[:city_1]!=nil && params[:city_1]
      end
    else
      @cond_nearby_cities = "activities.city like '%#{session[:city]}%' and"
    end
    
    if !params[:gender].nil? && params[:gender]!='' && params[:gender]!="g_all"
      @condition5=("lower(activities.gender) = '#{params[:gender].downcase}'") if !params[:gender].nil? && params[:gender]!='' && params[:gender]!="g_all" && params[:gender]!=0
    end
   
    if params[:a_f]!="" && params[:a_f]=="free" && params[:a_f]!=nil &&  params[:a_f].present? && params[:a_f]!="p_all"
      if  params[:a_f] == "free"
        @condition6=("activities.price_type = '3'")
      end
    end
   
    if params[:paid]!="" && params[:paid]=="paid" && params[:paid]!=nil && params[:paid].present? && params[:paid]!="p_all"
      if  params[:paid] == "paid"
        @condition6=("activities.price_type='1' or activities.price_type='2'")
      end
    end

    if !age_range.include?('a_all')
      age_range.each do |val|
        if @ag == 0
          if val != 0 and val != nil and val !='' and val.downcase != "a_all"
            if val.downcase == 'adults'
              @condition7.concat("(lower(activities.min_age_range) = '#{val.downcase}' or lower(activities.max_age_range)= '#{val.downcase}')")
            else
              #split age range
              str_a = val.split("-")
              @condition7.concat("(lower(activities.min_age_range) = '#{str_a[0]}' or lower(activities.max_age_range) <= '#{str_a[1]}')")
            end
          end
        else
          if val != 0 and val != nil and val !='' and val.downcase != "a_all"
            if val.downcase == 'adults'
              @condition7.concat(" or (lower(activities.min_age_range) = '#{val.downcase}' or lower(activities.max_age_range) = '#{val.downcase}')")
            else
              #split age range
              str_a = val.split("-")
              @condition7.concat(" or (lower(activities.min_age_range) = '#{str_a[0]}' or lower(activities.max_age_range) <= '#{str_a[1]}')")
            end
          end
        end
        @ag= @ag +1
      end if !age_range.nil?
    end
    
    @condition_all.concat(" and (#{@basictext})") if !@basictext.nil? && @basictext!=''
    @condition_all.concat(" and (#{@condition1})") if !@condition1.nil? && @condition1!=''
    @condition_all.concat(" and (#{@condition2})") if !@condition2.nil? && @condition2!=''
    @condition_all.concat(" and (#{@condition3})") if !@condition3.nil? && @condition3!=''
    @condition_all.concat(" and (#{@condition4})") if !@condition4.nil? && @condition4!=''
    @condition_all.concat(" and (#{@condition5})") if !@condition5.nil? && @condition5!=''
    @condition_all.concat(" and (#{@condition6})") if !@condition6.nil? && @condition6!=''
    @condition_all.concat(" and (#{@condition7})") if !@condition7.nil? && @condition7!=''
       
    if !params[:d_r].nil? && params[:d_r]!='' && params[:d_r].present?
      if params[:d_r].downcase=="next 7 days"
        date_range = 7
      elsif params[:d_r].downcase == "next 20 days"
        date_range = 20
      elsif params[:d_r].downcase == "today"
        date_range = 1
      else
        if params[:d_r].downcase == "d_all"
          date_range = "all"
        else
          selected_date = "yes"
          date_range =  params[:datepicker_ad]
        end
      end
    end

    @ss = []
    @day_arr = []
    if day_of_the_week!='' && day_of_the_week!=nil && day_of_the_week.any? && !day_of_the_week.nil? && day_of_the_week
      day_of_the_week.each do |s|
        if s.downcase=="mon"
          @day_arr.push(:monday)
          @ss.push('monday')
        elsif s.downcase =="tue"
          @day_arr.push(:tuesday)
          @ss.push('tuesday')
        elsif s.downcase =="wed"
          @day_arr.push(:wednesday)
          @ss.push('wednesday')
        elsif s.downcase =="thu"
          @day_arr.push(:thursday)
          @ss.push('thursday')
        elsif s.downcase =="fri"
          @day_arr.push(:friday)
          @ss.push('friday')
        elsif s.downcase =="sat"
          @day_arr.push(:saturday)
          @ss.push('saturday')
        elsif s.downcase =="sun"
          @day_arr.push(:sunday)
          @ss.push('sunday')
        end if s!=""
      end
    end
    arr =[]
    @spcl_date = Time.now.strftime("%Y-%m-%d")
    if !date_range.nil? && date_range!=''
      if date_range == "all"
        #if day of week is have value
        if day_of_the_week!='' && day_of_the_week!=nil && day_of_the_week.any? && !day_of_the_week.nil? && day_of_the_week
	    
          #if special selected
          if !params[:aspecials].nil? && params[:aspecials]!='' && params[:aspecials].present?
            @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_prices p on activities.activity_id=p.activity_id left join activity_discount_prices d on d.activity_price_id=p.activity_price_id where #{@cond_nearby_cities} cleaned=true and lower(active_status)='active' and activities.price_type='1' and(lower(d.discount_type)='early bird discount' and date(d.discount_valid) >= '#{@spcl_date}') or (lower(d.discount_type)!='early bird discount') #{@condition_all} order by activities.activity_id desc") if !@spcl_date.nil?
          else #other selected data
            @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where #{@cond_nearby_cities} lower(activities.active_status)='active' and activities.cleaned = true #{@condition_all}")
          end
   
          if !@activity.nil? && @activity!='' && @activity.present?
            @activity.each do |actv|
              search_activity_all_repeat(actv,@ss,@day_arr,arr)
            end     #each loop end
          end    #activity exist loop end
        else
          #if special selected
          if !params[:aspecials].nil? && params[:aspecials]!='' && params[:aspecials].present?
            @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_prices p on activities.activity_id=p.activity_id left join activity_discount_prices d on d.activity_price_id=p.activity_price_id where #{@cond_nearby_cities} cleaned=true and lower(active_status)='active' and activities.price_type='1' and(lower(d.discount_type)='early bird discount' and date(d.discount_valid) >= '#{@spcl_date}') or (lower(d.discount_type)!='early bird discount') #{@condition_all} order by activities.activity_id desc") if !@spcl_date.nil?
          else #other selected data
            @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where #{@cond_nearby_cities} lower(activities.active_status)='active' and activities.cleaned = true #{@condition_all}")
          end
    
          if !@activity.nil? && @activity!='' && @activity.present?
            @activity.each do |actv|
              arr << {:id => actv.activity_id, :min_age_range => actv.min_age_range, :max_age_range => actv.max_age_range, :city => actv.city, :price_type => actv.price_type, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id, :filter_id=>actv.filter_id, :active_status=>actv.active_status}
            end     #each loop end
          end    #activity exist loop end
        end
      else
        #choose particular date. activity
        if selected_date == "yes"
          sdate = DateTime.parse(params[:datepicker_ad]).strftime("%Y-%m-%d")
          r = Recurrence.new(:every => :day, :starts =>sdate, :until =>sdate)
          r.events.each do |date|
            #if day of week is have value
            if day_of_the_week!='' && day_of_the_week!=nil && day_of_the_week.any? && !day_of_the_week.nil? && day_of_the_week
              if @ss.include?(date.strftime("%A").downcase)
		      
                #if special selected
                if !params[:aspecials].nil? && params[:aspecials]!='' && params[:aspecials].present?
                  @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_prices p on activities.activity_id=p.activity_id left join activity_discount_prices d on d.activity_price_id=p.activity_price_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where #{@cond_nearby_cities} cleaned=true and lower(active_status)='active' and (activity_schedules.start_date <='#{date}') and activities.price_type='1' and(lower(d.discount_type)='early bird discount' and date(d.discount_valid) >= '#{@spcl_date}') or (lower(d.discount_type)!='early bird discount') #{@condition_all} order by activities.activity_id desc") if !@spcl_date.nil?
                else  #other selected data
                  @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where #{@cond_nearby_cities} lower(activities.active_status)='active' and activities.cleaned = true And (activity_schedules.start_date <='#{date}') #{@condition_all}")
                end
	
                if !@activity.nil? && @activity!='' && @activity.present?
                  @activity.each do |actv|
                    advancesearch_repeat(date,actv,arr)
                  end     #each loop end
                end    #activity exist loop end
              end
            else
		    
              #if special selected
              if !params[:aspecials].nil? && params[:aspecials]!='' && params[:aspecials].present?
                @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_prices p on activities.activity_id=p.activity_id left join activity_discount_prices d on d.activity_price_id=p.activity_price_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where #{@cond_nearby_cities} cleaned=true and lower(active_status)='active' and (activity_schedules.start_date <='#{date}') and activities.price_type='1' and(lower(d.discount_type)='early bird discount' and date(d.discount_valid) >= '#{@spcl_date}') or (lower(d.discount_type)!='early bird discount') #{@condition_all} order by activities.activity_id desc") if !@spcl_date.nil?
              else #other selected data
                @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where #{@cond_nearby_cities} lower(activities.active_status)='active' and activities.cleaned = true And (activity_schedules.start_date <='#{date}') #{@condition_all}")
              end
	  
              if !@activity.nil? && @activity!='' && @activity.present?
                @activity.each do |actv|
                  advancesearch_repeat(date,actv,arr)
                end     #each loop end
              end
            end
          end
        else
          #next selected date available activities
          r = Recurrence.new(:every => :day, :repeat => date_range)
          r.events.each do |date|
            #if day of week is have value
            if day_of_the_week!='' && day_of_the_week!=nil && day_of_the_week.any? && !day_of_the_week.nil? && day_of_the_week
              if @ss.include?(date.strftime("%A").downcase)
		      
                #if special selected
                if !params[:aspecials].nil? && params[:aspecials]!='' && params[:aspecials].present?
                  @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_prices p on activities.activity_id=p.activity_id left join activity_discount_prices d on d.activity_price_id=p.activity_price_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where #{@cond_nearby_cities} cleaned=true and lower(active_status)='active' and (activity_schedules.start_date <='#{date}') and activities.price_type='1' and(lower(d.discount_type)='early bird discount' and date(d.discount_valid) >= '#{@spcl_date}') or (lower(d.discount_type)!='early bird discount') #{@condition_all} order by activities.activity_id desc") if !@spcl_date.nil?
                else #other selected data
                  @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where #{@cond_nearby_cities} lower(activities.active_status)='active' and activities.cleaned = true And (activity_schedules.start_date <='#{date}') #{@condition_all}")
                end
	
                if !@activity.nil? && @activity!='' && @activity.present?
                  @activity.each do |actv|
                    advancesearch_repeat(date,actv,arr)
                  end     #each loop end
                end    #activity exist loop end
              end
            else
		    
              #if special selected
              if !params[:aspecials].nil? && params[:aspecials]!='' && params[:aspecials].present?
                @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_prices p on activities.activity_id=p.activity_id left join activity_discount_prices d on d.activity_price_id=p.activity_price_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where #{@cond_nearby_cities} cleaned=true and lower(active_status)='active' and (activity_schedules.start_date <='#{date}') and activities.price_type='1' and(lower(d.discount_type)='early bird discount' and date(d.discount_valid) >= '#{@spcl_date}') or (lower(d.discount_type)!='early bird discount') #{@condition_all} order by activities.activity_id desc") if !@spcl_date.nil?
              else
                @activity = Activity.find_by_sql("select distinct activities.* from activities left join user_profiles on activities.user_id=user_profiles.user_id left join activity_schedules on activities.activity_id = activity_schedules.activity_id where #{@cond_nearby_cities} lower(activities.active_status)='active' and activities.cleaned = true And (activity_schedules.start_date <='#{date}') #{@condition_all}")
              end

              if !@activity.nil? && @activity!='' && @activity.present?
                @activity.each do |actv|
                  advancesearch_repeat(date,actv,arr)
                end     #each loop end
              end
            end
          end    #date each loop end
        end
      end
    end  #date range loop end
      
    arr = [] if arr.nil?
    @arr=arr.uniq{|x| x[:id]}

    if(params[:datepicker_ad].nil? || params[:datepicker_ad]=='' ||  (params[:datepicker_ad]!='all' && (DateTime.parse(params[:datepicker_ad]).strftime("%Y-%m-%d") >= Time.now.strftime("%Y-%m-%d"))))
      arr_act = []
    
      acti_ids = arr.map{|ar| ar[:id]}
      @act = Activity.where("activity_id in (?)",acti_ids)
      @act.each do |event|
        @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
        Activity.schedule_feature_list(session[:date],event,arr_act) if !event.nil?
      end if !@act.nil? && @act.present?
      @arr = arr_act.uniq{|x| x[:id]}
    end

    @advance_count = @arr.length if !@arr.nil? && @arr.present?
    
    @activity_free = @arr.paginate(:page => params[:page], :per_page =>12)
    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT lower(trim(category))as category")
    @checck  = []
    @provider_activites_check =[]
    if !current_user.nil?
      @checck = ActivityRow.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]],:select => "row_type")
      @provider_activites_check =[]
      @checck.each do |s|
        @provider_activites_check<< s.row_type
      end
    end
    
    respond_to do |format|
      #~ format.html
      format.js
    end
  end #advance_search end

  

  #search using keyword
  def search_by_keyword
    session['near_cities'] = nil
    @keyword = params[:event_search].split('?ws=1').to_s.gsub('[','').gsub(']','').gsub('"','') if params[:event_search]!=nil && params[:event_search]!='' && params[:event_search] != "Search 20,000 + Local Activities & Counting..."
    @keyword = '' if params[:event_search] == "Search 20,000   Local Activities & Counting..."
    @search_city = (!cookies[:search_city].nil? ? cookies[:search_city] : "Walnut Creek")
    @search_city_details = City.where("city_name=?",@search_city.titlecase).first
    if @search_city_details.nil?
      @search_city_details = City.where("lower(city_name)=?","walnut creek").first
    end
    a_coord=[]
    a_coord << @search_city_details.latitude
    a_coord << @search_city_details.longitude
    nearby_cities = City.near(a_coord, 15, :order => :distance).map(&:city_name)
    nearby_cities = nearby_cities.to_s.gsub("[","(").gsub("]",")").gsub("\"","'")
    if nearby_cities.present? && nearby_cities!=''
      search_city = "(act.city in #{nearby_cities} or act.city = '')"
    else
      search_city = "(act.city like '%#{@search_city}%' or act.city = '')"
    end
    cookies[:test_city] = search_city
    session[:cat_zc]="date"
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    #removed the single quotes
    @parent_keyword = @keyword.downcase.gsub("'","") if !@keyword.nil?
    #split the values and age range with search text
    @sp_date = Time.now.strftime("%Y-%m-%d")
    if params[:discount_dollor] && params[:discount_dollor]!="" && !params[:discount_dollor].nil?
      @last_value="discount_dollor"
      #~ if @parent_keyword && params[:discount_dollor] && !params[:discount_dollor].nil? && @parent_keyword!="Search 20,000   Local Activities & Counting..."
      #~ act_free_dd = Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where #{search_city} and act_sch.expiration_date >= '#{Date.today}' and (act.price_type ='1' or act.price_type ='2') and cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and (act.discount_eligible IS NOT NULL) and (lower(act.activity_name) like '%#{@parent_keyword}%' or lower(act.category) like '%#{@parent_keyword}%' or lower(act.sub_category) like '%#{@parent_keyword}%' or lower(act.description) like '%#{@parent_keyword}%' or lower(act.city) like '%#{@parent_keyword}%' and cleaned=true and lower(act.active_status)='active') order by act.activity_id desc") if params[:discount_dollor]!=nil && params[:discount_dollor]!='' && !@parent_keyword.nil?
      #~ sorted_arr = ((!act_free_dd.group_by(&:city)[@search_city].nil?) ? act_free_dd.group_by(&:city)[@search_city] : []) #Group by city
      #~ other_sorted_arr = !act_free_dd.blank? && !sorted_arr.blank? ? act_free_dd-sorted_arr : [] #To get activity apart from selected city
			#~ if (!sorted_arr.nil? && sorted_arr.length > 0 ) && (!other_sorted_arr.nil? && other_sorted_arr.length > 0 )
      #~ act_free = sorted_arr + other_sorted_arr
			#~ else
      #~ act_free = act_free_dd
			#~ end
			#~ search_city_result = act_free
      #~ else
      #only for discount_dollor
      act_free_dd = Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where #{search_city} and cleaned=true and lower(act.active_status)='active' and (act.price_type ='1' or act.price_type ='2') and act_sch.expiration_date >= '#{Date.today}' and lower(act.created_by)='provider' and (act.discount_eligible IS NOT NULL) order by act.activity_id desc") if params[:discount_dollor]!=nil && params[:discount_dollor]!=''
      sorted_arr = ((!act_free_dd.group_by(&:city)[@search_city].nil?) ? act_free_dd.group_by(&:city)[@search_city] : []) #Group by city
      other_sorted_arr = !act_free_dd.blank? && !sorted_arr.blank? ? act_free_dd-sorted_arr : [] #To get activity apart from selected city
			if (!sorted_arr.nil? && sorted_arr.length > 0 ) && (!other_sorted_arr.nil? && other_sorted_arr.length > 0 )
				act_free = sorted_arr + other_sorted_arr	
			else
				act_free = act_free_dd
			end
			search_city_result = act_free
      #~ end
    elsif params[:camps] && params[:camps]!="" && !params[:camps].nil?
      @camps = params[:camps]
      @last_value="camps"
      #~ if @parent_keyword && params[:camps] && !params[:camps].nil? && @parent_keyword!="Search 20,000   Local Activities & Counting..."
      #~ act_free_camp = Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where #{search_city} and act_sch.expiration_date >= '#{Date.today}' and act.cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and (lower(act.schedule_mode)='#{params[:camps].downcase.strip}' or ((act.sub_category)='Camps')or ((act.camps)=true)) and (lower(act.activity_name) like '%#{@parent_keyword}%' or lower(act.category) like '%#{@parent_keyword}%' or lower(act.sub_category) like '%#{@parent_keyword}%' or lower(act.description) like '%#{@parent_keyword}%' or lower(act.city) like '%#{@parent_keyword}%' and cleaned=true and lower(act.active_status)='active') order by act.activity_id desc") if params[:camps]!=nil && params[:camps]!='' && !@parent_keyword.nil?
      #~ sorted_arr = ((!act_free_camp.group_by(&:city)[@search_city].nil?) ? act_free_camp.group_by(&:city)[@search_city] : []) #Group by city
      #~ other_sorted_arr = !act_free_camp.blank? && !sorted_arr.blank? ? act_free_camp-sorted_arr : [] #To get activity apart from selected city
			#~ if (!sorted_arr.nil? && sorted_arr.length > 0 ) && (!other_sorted_arr.nil? && other_sorted_arr.length > 0 )
      #~ act_free = sorted_arr + other_sorted_arr
			#~ else
      #~ act_free = act_free_camp
			#~ end
			#~ search_city_result = act_free
      #~ else
      #only for camps
      act_free_camp = Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where #{search_city} and act_sch.expiration_date >= '#{Date.today}' and act.cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and (lower(act.schedule_mode)='#{params[:camps].downcase.strip}' or ((act.sub_category)='Camps')or ((act.camps)=true)) order by act.activity_id desc") if params[:camps]!=nil && params[:camps]!=''
      sorted_arr = ((!act_free_camp.group_by(&:city)[@search_city].nil?) ? act_free_camp.group_by(&:city)[@search_city] : []) #Group by city
      other_sorted_arr = !act_free_camp.blank? && !sorted_arr.blank? ? act_free_camp-sorted_arr : [] #To get activity apart from selected city
			if (!sorted_arr.nil? && sorted_arr.length > 0 ) && (!other_sorted_arr.nil? && other_sorted_arr.length > 0 )
				act_free = sorted_arr + other_sorted_arr	
			else
				act_free = act_free_camp
			end
			search_city_result = act_free
      #~ end
    elsif params[:specials] && params[:specials]!="" && !params[:specials].nil?
      @f_specials = params[:specials]
      @last_value="specials"
      #~ if @parent_keyword && params[:specials] && !params[:specials].nil? && @parent_keyword!="Search 20,000   Local Activities & Counting..."
      #~ @act_free=[]
      #~ @all_act=[]
      #~ act_free_spl =  Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id left join activity_prices p on act.activity_id=p.activity_id left join activity_discount_prices d
      #~ on d.activity_price_id=p.activity_price_id where #{search_city} and act_sch.expiration_date >= '#{Date.today}'  and cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and (((act.price_type='1') or (act.price_type='2')) and
      #~ ((date(d.discount_valid) >= '#{Date.today}') or (d.discount_valid is null and d.discount_price is not null)) and (lower(act.activity_name) like '%#{@parent_keyword}%' or lower(act.category) like '%#{@parent_keyword}%' or lower(act.sub_category) like '%#{@parent_keyword}%' or lower(act.description)
      #~ like '%#{@parent_keyword}%' or lower(act.city) like '%#{@parent_keyword}%')) order by act.activity_id desc")
      #~ sorted_arr = ((!act_free_spl.group_by(&:city)[@search_city].nil?) ? act_free_spl.group_by(&:city)[@search_city] : []) #Group by city
      #~ other_sorted_arr = !act_free_spl.blank? && !sorted_arr.blank? ? act_free_spl-sorted_arr : [] #To get activity apart from selected city
			#~ if (!sorted_arr.nil? && sorted_arr.length > 0 ) && (!other_sorted_arr.nil? && other_sorted_arr.length > 0 )
      #~ act_free = sorted_arr + other_sorted_arr
			#~ else
      #~ act_free = act_free_spl
			#~ end
			#~ search_city_result = act_free
      #~ else
      #only for specials
      @act_free=[]
      @all_act=[]
      act_free_spl =  Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id left join activity_prices p on act.activity_id=p.activity_id left join activity_discount_prices d
				on d.activity_price_id=p.activity_price_id where #{search_city} and act_sch.expiration_date >= '#{Date.today}' and cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and (((act.price_type='1') or (act.price_type='2')) and 
				((date(d.discount_valid) >= '#{Date.today}') or (d.discount_valid is null and d.discount_price is not null))) order by act.activity_id desc")
      sorted_arr = ((!act_free_spl.group_by(&:city)[@search_city].nil?) ? act_free_spl.group_by(&:city)[@search_city] : []) #Group by city
      other_sorted_arr = !act_free_spl.blank? || !sorted_arr.blank? ? act_free_spl-sorted_arr : [] #To get activity apart from selected city
			if (!sorted_arr.nil? && sorted_arr.length > 0 ) && (!other_sorted_arr.nil? && other_sorted_arr.length > 0 )
				act_free = sorted_arr + other_sorted_arr	
			else
				act_free = act_free_spl
			end
			search_city_result = act_free
      #~ end
    elsif params[:free] && params[:free]!="" && !params[:free].nil?
      @f_specials = params[:free]
      @last_value="free"
      #~ if @parent_keyword && params[:free] && !params[:free].nil? && @parent_keyword!="Search 20,000   Local Activities & Counting..."
      #~ act_quick_free = Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where #{search_city} and act_sch.expiration_date >= '#{Date.today}' and cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and act.price_type='3' and (lower(act.activity_name) like '%#{@parent_keyword}%' or lower(act.category) like '%#{@parent_keyword}%' or lower(act.sub_category) like '%#{@parent_keyword}%' or lower(act.description) like '%#{@parent_keyword}%' or lower(act.city) like '%#{@parent_keyword}%' and cleaned=true and lower(act.active_status)='active') order by act.activity_id desc") if params[:free]!=nil && params[:free]!='' && !@parent_keyword.nil?
      #~ sorted_arr = ((!act_quick_free.group_by(&:city)[@search_city].nil?) ? act_quick_free.group_by(&:city)[@search_city] : []) #Group by city
      #~ other_sorted_arr = !act_quick_free.blank? || !sorted_arr.blank? ? act_quick_free-sorted_arr : [] #To get activity apart from selected city
			#~ if (!sorted_arr.nil? && sorted_arr.length > 0 ) && (!other_sorted_arr.nil? && other_sorted_arr.length > 0 )
      #~ act_free = sorted_arr + other_sorted_arr
			#~ else
      #~ act_free = act_quick_free
			#~ end
			#~ search_city_result = act_free
      #~ else
      #only for free
      act_quick_free = Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where #{search_city} and act_sch.expiration_date >= '#{Date.today}' and cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and act.price_type='3' order by act.activity_id desc") if params[:free]!=nil && params[:free]!=''
      sorted_arr = ((!act_quick_free.group_by(&:city)[@search_city].nil?) ? act_quick_free.group_by(&:city)[@search_city] : []) #Group by city
      other_sorted_arr = !act_quick_free.blank? || !sorted_arr.blank? ? act_quick_free-sorted_arr : [] #To get activity apart from selected city
			if (!sorted_arr.nil? && sorted_arr.length > 0 ) && (!other_sorted_arr.nil? && other_sorted_arr.length > 0 )
				act_free = sorted_arr + other_sorted_arr	
			else
				act_free = act_quick_free
			end
			search_city_result = act_free
      #~ end
    elsif params[:specialneeds] && params[:specialneeds]!="" && !params[:specialneeds].nil?
      @camps = params[:specialneeds]
      @last_value="specialneeds"
      #~ if @parent_keyword && params[:specialneeds] && !params[:specialneeds].nil? && @parent_keyword!="Search 20,000   Local Activities & Counting..."
      #~ act_free_camp = Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where #{search_city} and act_sch.expiration_date >= '#{Date.today}' and act.cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and ((lower(act.sub_category)='special needs')or((act.special_needs)=true)) and (lower(act.activity_name) like '%#{@parent_keyword}%' or lower(act.category) like '%#{@parent_keyword}%' or lower(act.sub_category) like '%#{@parent_keyword}%' or lower(act.description) like '%#{@parent_keyword}%' or lower(act.city) like '%#{@parent_keyword}%' and cleaned=true and lower(act.active_status)='active') order by act.activity_id desc") if params[:specialneeds]!=nil && params[:specialneeds]!='' && !@parent_keyword.nil?
      #~ sorted_arr = ((!act_free_camp.group_by(&:city)[@search_city].nil?) ? act_free_camp.group_by(&:city)[@search_city] : []) #Group by city
      #~ other_sorted_arr = !act_free_camp.blank? && !sorted_arr.blank? ? act_free_camp-sorted_arr : [] #To get activity apart from selected city
			#~ if (!sorted_arr.nil? && sorted_arr.length > 0 ) && (!other_sorted_arr.nil? && other_sorted_arr.length > 0 )
      #~ act_free = sorted_arr + other_sorted_arr
			#~ else
      #~ act_free = act_free_camp
			#~ end
			#~ search_city_result = act_free
      #~ else
      #only for specialneeds
      act_free_camp = Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where #{search_city} and act_sch.expiration_date >= '#{Date.today}' and act.cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and ((lower(act.sub_category)='special needs')or((act.special_needs)=true)) order by act.activity_id desc") if params[:specialneeds]!=nil && params[:specialneeds]!=''
      sorted_arr = ((!act_free_camp.group_by(&:city)[@search_city].nil?) ? act_free_camp.group_by(&:city)[@search_city] : []) #Group by city
      other_sorted_arr = !act_free_camp.blank? && !sorted_arr.blank? ? act_free_camp-sorted_arr : [] #To get activity apart from selected city
			if (!sorted_arr.nil? && sorted_arr.length > 0 ) && (!other_sorted_arr.nil? && other_sorted_arr.length > 0 )
				act_free = sorted_arr + other_sorted_arr			
			else
				act_free = act_free_camp
			end
			search_city_result = act_free
      #~ end
    elsif params[:week] && params[:week]!="" && !params[:week].nil?
      @last_value="weekend"
      if params[:page].nil?
        $week_act_free=''
        arr = []
        @arr= []
        if @parent_keyword && params[:free] && !params[:free].nil? && @parent_keyword!="Search 20,000   Local Activities & Counting..."
          Activity.weekend_activities(arr,@parent_keyword)
        else
          Activity.weekend_activities(arr,@parent_keyword)
        end
        if !arr.nil? && arr.length > 0
          @arr = arr.uniq
          @bb=@arr.to_s.gsub("[","(").gsub("]",")") if !@arr.nil? && @arr.length > 0
          act_free = Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where #{search_city} and cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and act.activity_id in #{@bb} order by act.activity_id desc") if !@bb.nil? && @bb.length > 0
          sorted_arr = ((!act_free.group_by(&:city)[@search_city].nil?) ? act_free.group_by(&:city)[@search_city] : []) #Group by city
          other_sorted_arr = !act_free.blank? || !sorted_arr.blank? ? act_free-sorted_arr : [] #To get activity apart from selected city
          $week_act_free = act_free
        end
      else
        if params[:page].to_i > 1
          act_free = $week_act_free if !$week_act_free.nil? && $week_act_free!=''
        end
      end
    end
    @search_tu = "yes"
    @search_count = act_free.length if !act_free.nil? && act_free.present?
    @activity_free = act_free.paginate(:page => params[:page], :per_page =>12) if !act_free.nil?
    @tpage = @activity_free.total_pages if !@activity_free.nil? && @activity_free.present?
    @cpage = @activity_free.current_page if !@activity_free.nil? && @activity_free.present?
    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT trim(category) as category",:conditions=>["lower(category)!=?",'default'])
	if request.headers['X-PJAX']
	    respond_to do |format|
	      format.html{render :layout => false}
	      format.js{render :layout => false}
	    end
        else
	    respond_to do |format|
	      format.html
	      format.js
	    end
	end

  end


  def special_activity_all(special_activity,spcls_act)
    spcls_act.each do |share|
      if !share.nil? && !share.price_type.nil? && share.price_type == "1"
        @p_details=""
        @p_details = ActivityPrice.get_price_details(share.activity_id) if !share.nil? && !share.activity_id.nil?
      end
      if !share.nil? && !share.price_type.nil? && share.price_type == "1"
        if !@p_details.nil? && @p_details.present? && @p_details=="true"
          special_activity.push(share.activity_id)
        end
      end
    end if !spcls_act.nil? && spcls_act.present? #do end
		
    return special_activity
			
  end
  
  
  #~ #Search results page while clicking the age range link in landing page
  def search
    session[:city] = cookies[:city_new_usr]
    session[:city] = "Walnut Creek" if session[:city].nil?
    session[:cat_zc]="date"
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    
    #removed the single quotes
    @get_current_url = request.env['HTTP_HOST']
    #profile image changes
    if !current_user.nil? && !current_user.user_profile.nil?
      @profile_data=current_user.user_profile if !current_user.user_profile.nil?
      @aa='$image_global_path'+@profile_data.profile.url(:thumb)
      @profile_ig=FastImage.size(@aa)
      @p_f = @aa if @profile_ig!="" && !@profile_ig.nil?
    end
    #split the values
    str_a = params[:arange].split("-") if params[:arange]!=nil && params[:arange]!=''
    #age range 0-3 or 4-7
    if params[:arange] && params[:arange]!="" && !params[:arange].nil?
      @arange = params[:arange]
      act_free = Activity.find_by_sql("select * from activities act where act.cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and (lower(act.min_age_range)='#{str_a[0]}' or lower(act.max_age_range) ='#{str_a[1]}') limit 100") if !str_a.nil? && str_a!=""
    end
	
    #age range 8 and above
    if params[:age] && params[:age]!="" && !params[:age].nil?
      @age = params[:age]
      act_free = Activity.find_by_sql("select * from activities act where act.cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and (lower(act.min_age_range)='#{params[:age].downcase.strip}' or lower(act.max_age_range) >='#{params[:age].downcase.strip}') limit 100")
    end

    #schedule type camps
    if params[:camps] && params[:camps]!="" && !params[:camps].nil?
      @camps = params[:camps]
      act_free = Activity.find_by_sql("select * from activities act where act.cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and lower(act.schedule_mode)='#{params[:camps].downcase.strip}' limit 100") if params[:camps]!=nil && params[:camps]!=''
    end
    
    act_free = [] if act_free.nil?
    @activity_free = act_free.paginate(:page => params[:page], :per_page =>60)
    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT lower(trim(category))as category")
    
    @checck = []
    @provider_activites_check =[]
    if !current_user.nil?
      @checck = ActivityRow.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]],:select => "row_type")
      @provider_activites_check =[]
      @checck.each do |s|
        @provider_activites_check<< s.row_type
      end
    end
    
    @blog_value = []
    url = URI.parse("http://blog.famtivity.com/?feed=rss2")
    req = Net::HTTP.new(url.host, url.port)
    begin
      res = req.request_head(url.path)
      if res.code != "404" && res.code !="500"
        doc = Nokogiri::XML(open(url))
        if !doc.nil? && doc!='' && doc.present?
          (doc/'item').each do|node|
            title = (node/'title').inner_html
            desc = (node/'description').inner_html
            link = (node/'link').inner_html
            img_srcs = desc[/img.*?src="(.*?)"/i,1]
            dec = desc.gsub(/<\/?[^>]*>/,"")
            title = title.gsub(/<\/?[^>]*>/,"")
            dec = dec.sub("Continue reading &#8594;","")
            @blog_value << {"title" => title.html_safe, "description"=>dec.html_safe,"img"=>img_srcs,"link"=>link}
          end
        end
      end
    rescue Exception => exc
      logger.error("Message for the log file #{exc.message}")
      flash[:notice] = "Store error message"
    end
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  #called when using options in event index page

  def event_index_update
    session[:city] = params[:city] unless params[:city].nil?
    session[:city] = "Walnut Creek" if session[:city].nil?

    session[:cat_zc]="date"
    session[:date] = params[:date] unless params[:date].nil?
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    #@activity_featured = Activity.find_by_sql("select * from activities where activity_id in (select activity_id from activity_bids where lower(bid_status) = 'active' order by bid_amount asc) and lower(active_status)='active' or (featured_flag = true and lower(active_status)='active') order by featured_flag asc limit 100")
    
    @get_current_url = request.env['HTTP_HOST']
    #profile image changes
    if !current_user.nil? && !current_user.user_profile.nil?
      @profile_data=current_user.user_profile if !current_user.user_profile.nil?
      @aa='$image_global_path'+@profile_data.profile.url(:thumb)
      @profile_ig=FastImage.size(@aa)
      @p_f = @aa if @profile_ig!="" && !@profile_ig.nil?
    end
    @follow_parent_user = UserRow.where("user_id=7 and user_type='U'").map(&:row_user_id)
    @follow_provider_user = UserRow.where("user_id=7 and user_type='P'").map(&:row_user_id)
    @activity_featured = Activity.find_by_sql("select * from activities INNER JOIN activity_schedules ON activity_schedules.activity_id = activities.activity_id where activities.activity_id in (select activity_id from activity_bids where lower(bid_status) = 'active' order by bid_amount asc) and lower(active_status)='active' or (featured_flag = true and lower(active_status)='active') order by featured_flag asc limit 60").uniq
 
	
    #    act_featured = Activity.get_activities_repeat(session[:city],params[:zip_code],session[:date],1)
    events = []
    #    act_featured.each do |event|
    #      @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
    #
    #      schedule_repeat_append(event,events,"created") if !@schedule.nil?
    #    end
    #    events_free=[]
    #    @activity_featured = events
    #    @activity_featured = act_featured.paginate(:page => params[:page], :per_page =>400)
    act_free = Activity.get_activities_repeat(session[:city],params[:zip_code],session[:date],3)
    act_free.each do |event|
      @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
      schedule_repeat_append(event,events,"created") if !@schedule.nil?
    end
    @activity_free = events

    act_provider =  Activity.get_shared_activities(cookies[:uid_usr],current_user.email_address)
    @activity_share_provider = act_provider.paginate(:page => params[:page], :per_page =>400)

    act_saved_fav = Activity.get_saved_favorites(session[:city],params[:zip_code],session[:date],cookies[:uid_usr])
    @activity_saved_favorites = act_saved_fav.paginate(:page => params[:page], :per_page =>400)
    add_to_activity_row(params[:activity_row],params[:remove_row])
    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT lower(trim(category))as category")
    #@provider_activites = ActivityRow.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]],:select => "DISTINCT lower(trim(row_type))as row_type").collect {|r| r.row_type if !r.row_type.nil?}
    #    @provider_activites = ActivityRow.find_by_sql("select Distinct(act.category) from activities as act,activity_rows as row where act.sub_category = row.row_type and row.user_id = 27 order by act.category Asc").collect {|r| r.category if !r.category.nil?}
    @provider_activites =  ActivityRow.select("Distinct(activities.category)").order("activities.category Asc").joins("left join activities on lower(activities.sub_category)=lower(activity_rows.row_type)").where("activity_rows.user_id = ?",cookies[:uid_usr]).group("activities.category")
 
    @checck = ActivityRow.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]],:select => "row_type")
    @provider_activites_check =[]
    @checck.each do |s|
      @provider_activites_check<< s.row_type
    end
    respond_to do |format|
      format.html
      format.js
    end
  end


  #create new activity for parent
  def activity_parent
    #@cities = ["Chicago","Dallas","Detroit","Houston","Las Vegas","Los Angeles","New York","Philadelphia","San Antonio","San Francisco","San Jose","Seattle","Walnut Creek"]
    @cities = City.order("city_name Asc").all.map(&:city_name)
  end

  def activity_create_index
    # @cities = ["Chicago","Dallas","Detroit","Houston","Las Vegas","Los Angeles","New York","Philadelphia","San Antonio","San Francisco","San Jose","Seattle","Walnut Creek"]
    @cities = City.order("city_name Asc").all.map(&:city_name)
  end

  def update_sub_category
    @sub_category = ActivitySubcategory.where(:category_id=>params[:id]).order(:subcateg_name) unless params[:id].blank?
    render :partial => "sub_category", :locals => { :states => @sub_category }
  end

  def edit_update_sub_category
    category = ActivityCategory.where(:category_name=>params[:id]).last unless params[:id].blank?
    @sub_category = ActivitySubcategory.where(:category_id=>category.id).order(:subcateg_name) unless category.blank?
    render :partial => "sub_category", :locals => { :states => @sub_category }
  end

  def add_participant
    @activity = Activity.find(params[:activity_id]) if params[:activity_id]!="" && params[:activity_id]!=nil
    @activity_sched = ActivitySchedule.find(params[:activity_schedule_id]) if params[:activity_schedule_id]!="" && params[:activity_schedule_id]!=nil
    @uid = @activity.user_id if @activity && !@activity.nil? && @activity.present?
    @attend_policy = Policy.find_by_user_id(@uid) if @uid && !@uid.nil? && @uid.present?
    @discount_dollar_tot_amt = Activity.discount_total_amount(current_user.user_id) if current_user && current_user.present? && !current_user.nil?
    @discount_dollar = @discount_dollar_tot_amt[0] - @discount_dollar_tot_amt[1] if @discount_dollar_tot_amt && @discount_dollar_tot_amt.present?
    @dd_eligible = @activity.discount_eligible if @activity && !@activity.nil? && @activity.present?
    @before_login_value = params[:before_login_value] if !params[:before_login_value].nil? && params[:before_login_value].present?
    @total_paticipant= params[:total_paticipant] if !params[:total_paticipant].nil? && params[:total_paticipant].present?
    @can_attend = params[:can_attend] if !params[:can_attend].nil? && params[:can_attend].present?
  end
  
  
  def file_download_checkout
    if !params[:id].nil?
      p_file = PolicyFile.where("policy_file_id=?",params[:id]).first
      path = "#{p_file.pdf.path(:original)}"
      if p_file && File.exists?(path)
        send_file path, :x_sendfile=>true,  :disposition => "attachment"
      else
        redirect_to "/add_participant"
      end
    end
  end



  def multi_download
    if !params[:val].nil?
      file_id = params[:val].split(",")
      attachments = []
      file_id && file_id.each do |p_file|
        policy_file = PolicyFile.where("policy_file_id=?",p_file).first
        attachments << policy_file
      end
      dir_name = "#{Rails.root}/public/system/zips"
      unless File.directory?(dir_name)
        Dir.mkdir "#{Rails.root}/public/system/zips"
      end
      zip_file_path = "#{Rails.root}/public/system/zips/activity_#{params[:id]}_policy_#{current_user.user_id}.zip"
      if File.file?(zip_file_path)
        File.delete(zip_file_path)
      end
      Zip::ZipFile.open(zip_file_path, Zip::ZipFile::CREATE) { |zipfile|
        attachments.each do |attachment|
          zipfile.add( attachment.pdf_file_name, attachment.pdf.path(:original))
        end
      }
      send_file zip_file_path, :type => 'application/zip', :disposition => 'attachment', :filename => "activity_#{params[:id]}_policy_#{current_user.user_id}.zip"
    end
  end


  #create new activity page for provider
  def create_activity

  end
  
  #called when creating activity for parent
  def activity_create
    @activity_profile_apf = Activity.new(params[:activity])
    @activity_profile_apf.inserted_date = Time.now

    @activity_profile_apf.modified_date = Time.now
    @activity_profile_apf.description = params[:description] if params[:description] !="Description should not exceed 500 characters"
    @activity_profile_apf.active_status = "Active"

    @activity_profile_apf.email = params[:email] if params[:email] != "Enter Email"
    #~ @activity_profile_apf.no_participants = params[:no_participants] if params[:no_participants] != "Specify Number"
    
    @activity_profile_apf.address_2 = params[:address_2] if params[:address_2] != "Address Line 2"
    @activity_profile_apf.address_1 = params[:address_1] if params[:address_1] != "Address Line 1"
 
    @activity_profile_apf.price_type = 3
    @activity_profile_apf.created_by = "Parent"
    @activity_profile_apf.state = params[:state]
    @activity_profile_apf.city = params[:city]
	
    if !params[:city].nil? && params[:city]!=""
      city_se = City.where("city_name='#{params[:city]}'").last
      if !city_se.nil?
        @activity_profile_apf.latitude  = city_se.latitude
        @activity_profile_apf.longitude  = city_se.longitude
      end
    end
    @activity_profile_apf.zip_code = params[:zip_code] if params[:zip_code]!="Enter Zip Code"
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
    #@activity_profile_apf.filter_id = 4 if params[:activity_type] == "U"
    @activity_profile_apf.user_id = cookies[:uid_usr]
    if params[:activity][:schedule_mode] =="Any Time"
      if params[:any_address]=="0"
        @activity_profile_apf.address_2 = nil
        @activity_profile_apf.address_1 = nil
        @activity_profile_apf.city = nil
        @activity_profile_apf.state = nil
        @activity_profile_apf.zip_code = nil
      end
    end
     
    @result_in = @activity_profile_apf.save

    success = @activity_profile_apf && @activity_profile_apf.save

    if success && @activity_profile_apf.errors.empty?
      if params[:activity][:schedule_mode] =="Any Time"
        @activity_profile_apf.update_attributes(:schedule_mode=> "Any Time")
        @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> "Any Time",:expiration_date=>"2100-12-31",:price_type => 3,:no_of_participant =>  params[:no_participants])
      else
        if params[:repeatCheck_1]=="yes"
          if params[:repeatCheck_1] =="yes"
            if params[:r1_1] == "1"
              ex_date = "2100-12-31"
            else
              if !params[:repeat_alt_on_date_1].nil? && params[:repeat_alt_on_date_1]!=""
                ex_date = params[:repeat_alt_on_date_1]
              elsif !params[:after_occ_1].nil? && params[:after_occ_1]!=""

                if params[:repeatWeekVal_1] == "Daily"
                  ex_date = Date.parse(params[:date_1_1]) + (params[:repeatNumWeekVal_1].to_i * params[:after_occ_1].to_i).days
                elsif params[:"repeatWeekVal_1"] == "Weekly"
                  ex_date = Date.parse(params[:date_1_1]) + (params[:repeatNumWeekVal_1].to_i * params[:after_occ_1].to_i * 7).days
                elsif params[:"repeatWeekVal_1"] == "Monthly"
                  ex_date = Date.parse(params[:date_1_1]) + (params[:repeatNumWeekVal_1].to_i * params[:after_occ_1].to_i).months
                elsif params[:"repeatWeekVal_1"] == "yearly"
                  ex_date = Date.parse(params[:date_1_1]) + (params[:repeatNumWeekVal_1].to_i * params[:after_occ_1].to_i ).years
                end
                #ex_date = Date.parse(params[:date_1_1]) + (params[:repeatNumWeekVal_1].to_i * params[:after_occ_1].to_i).days
              end
            end
          end
          if ex_date =="" || ex_date.nil?
            ex_date = params[:date_1_1]
          end

          #@date_split = params[:date_total].split(',') if !params[:date_total].nil?
          # @date_split.each do |s|
          st_time = DateTime.parse("#{params[:schedule_stime_1_1]} #{params[:schedule_stime_2_1]}").strftime("%H:%M:%S") if !params[:schedule_stime_1_1].nil? && !params[:schedule_stime_2_1].nil? && params[:schedule_stime_1_1]!="" && params[:schedule_stime_2_1]!=""
          en_time = DateTime.parse("#{params[:schedule_etime_1_1]} #{params[:schedule_etime_2_1]}").strftime("%H:%M:%S") if !params[:schedule_etime_1_1].nil? && !params[:schedule_etime_2_1].nil? && params[:schedule_etime_1_1]!="" && params[:schedule_etime_2_1]!=""
          @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=> "Schedule",:start_date=>params[:date_1_1],:price_type => 3,
            :start_time=>st_time,:end_time=>en_time,:expiration_date=>ex_date,:no_of_participant =>  params[:no_participants])
          #end
          @activity_profile_apf.update_attributes(:schedule_mode=> "Schedule")
          @schedule.activity_repeat.create(:repeat_every => params[:repeatNumWeekVal_1],
            :ends_never=>params[:r1_1],:end_occurences=>params[:after_occ_1],
            :ends_on=>params[:repeat_alt_on_date_1],:starts_on=>params[:date_1_1],:repeated_by_month=>params[:month1_1],:repeat_on=>params[:repeat_no_of_days_1],:repeats=>params[:repeatWeekVal_1])

        else
          @activity_profile_apf.update_attributes(:schedule_mode=> "Whole Day")
          st_time = DateTime.parse("#{params[:schedule_stime_1_1]} #{params[:schedule_stime_2_1]}").strftime("%H:%M:%S") if !params[:schedule_stime_1_1].nil? && !params[:schedule_stime_2_1].nil? && params[:schedule_stime_1_1]!="" && params[:schedule_stime_2_1]!=""
          en_time = DateTime.parse("#{params[:schedule_etime_1_1]} #{params[:schedule_etime_2_1]}").strftime("%H:%M:%S") if !params[:schedule_etime_1_1].nil? && !params[:schedule_etime_2_1].nil? && params[:schedule_etime_1_1]!="" && params[:schedule_etime_2_1]!=""
          @schedule = @activity_profile_apf.activity_schedule.create(:schedule_mode=>"Whole Day",:start_date=>params[:date_1_1],:price_type => 3,
            :end_date=>params[:date_2_1],:start_time=>st_time,:end_time=>en_time,:expiration_date=>params[:date_2_1],:no_of_participant =>  params[:no_participants])
        end
      end
    end
    
    #send a mail while creating activity
    @notify_setting_net = ParentNotificationDetail.find_by_sql("select * from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id where pn.notify_action='1' and p.user_id='#{current_user.user_id}' and p.notify_flag=true")
    if @notify_setting_net.present? && !@notify_setting_net.nil? && @notify_setting_net!=""
      @parent_network = ActivityShared.find_by_sql("select distinct user_id,shared_to from activity_shareds where shared_to='#{current_user.email_address}' and user_id!='#{current_user.user_id}'") if current_user.present?
      @get_current_url = request.env['HTTP_HOST']
      @parent_network.each do |net_user|
        @net_user = User.find_by_user_id(net_user.user_id) if net_user.present?
        if !@net_user.nil? && @net_user.user_flag == TRUE
          user_email_id =  @net_user.email_address
          #@result = UserMailer.following_user_mail(@net_user,current_user,@activity_profile_apf,@get_current_url,params[:message],user_email_id,params[:subject]).deliver
          @result = UserMailer.delay(queue: "Following User", priority: 2, run_at: 10.seconds.from_now).following_user_mail(@net_user,current_user,@activity_profile_apf,@get_current_url,params[:message],user_email_id,params[:subject])
        end
      end if @parent_network.present?
    end
    
    #When someone I'm following creates a new activity
    @notify_setting_info = ParentNotificationDetail.find_by_sql("select * from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id where pn.notify_action='2' and p.user_id=#{current_user.user_id} and p.notify_flag=true")
    #    if !@notify_setting_info.nil? && @notify_setting_info!='' && @notify_setting_info.present?
    mailtofollowuser_create(current_user.user_id,@activity_profile_apf,"create")
    #    end
    #parent activity mail purpose
    @get_current_url = request.env['HTTP_HOST']
    @plan = current_user.user_plan
    @user = current_user
    if !@user.nil? && @user.user_flag==TRUE
      user_email_id=@user.email_address if !@user.email_address.nil? &&  !@user.nil? && @user.user_flag==TRUE
      @result = UserMailer.delay(queue: "Parent Create Activity", priority: 2, run_at: 10.seconds.from_now).parent_create_activity_mail(@user,@activity_profile_apf,user_email_id,params[:subject],@plan,@get_current_url)
    end
    render :partial => "parent_create_thank"
  end

  def mailtofollowuser_create(userid,activity,flag)
    @activity_profile_apf = activity
    #    @follow = UserRow.where("row_user_id=#{userid} and lower(user_type)='u'").uniq
    #    @follow_user = User.find_by_user_id(userid)
    #    @get_current_url = "http://#{request.env['HTTP_HOST']}"
    #    if !@follow.nil? && @follow!='' && @follow.present?
    #      @follow.each do |fval|
    #        @user_mail = User.find_by_user_id(fval.user_id) if !fval.nil?
    #        if !@user_mail.nil? && @user_mail!='' && @user_mail.present?
    #          if @user_mail.user_flag== true
    #
    #               #@result = UserMailer.following_user_create_mail(@user_mail ,@follow_user,@activity_profile_apf,@get_current_url,params[:message],@user_mail.email_address,params[:subject]).deliver
    #          end
    #        end
    #      end
    #    end
    @get_current_url = "http://#{request.env['HTTP_HOST']}"
    @created_setting = ParentSettingDetail.find_by_sql("select p.* from parent_setting_details s left join parent_settings p on s.parent_setting_id=p.parent_setting_id  where s.setting_action='created' and p.user_id=#{userid}")
    if !@created_setting.nil? && @created_setting!='' && @created_setting.present?
      #setting_option 1, show to famtiivty everyone
      @created_setting.each do |set_val|
        if set_val["setting_option"] == "1"
          @follow = UserRow.select("distinct user_id").where("row_user_id=#{userid} and lower(user_type)='u'")
          @follow_user = User.find_by_user_id(userid)
          if !@follow.nil? && @follow!='' && @follow.present?
            @follow.each do |fval|
              #check notification
              @notify_setting_fo = ParentNotificationDetail.find_by_sql("select p.* from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id  where pn.notify_action='2' and lower(pn.notify_status)='active'and p.user_id=#{fval["user_id"]} and p.notify_flag=true")
              if !@notify_setting_fo.nil? && @notify_setting_fo!='' && @notify_setting_fo.present?
                @user_mail = User.find_by_user_id(fval["user_id"])
                if !@user_mail.nil? && @user_mail!='' && @user_mail.present?
                  if @user_mail["user_flag"]== true
                    @result = UserMailer.delay(queue: "Following User Create", priority: 2, run_at: 10.seconds.from_now).following_user_create_mail(@user_mail ,@follow_user,@activity_profile_apf,@get_current_url,params[:message],@user_mail.email_address,params[:subject])
                  end
                end
              end
            end
          end
        end
        # setting_option 2, famtivity contact user only
        if set_val["setting_option"]=="2"
          @con_user = set_val["contact_user"].split(",")
          @follow = UserRow.select("distinct user_id").where("row_user_id=#{userid} and lower(user_type)='u'")
          @follow_user = User.find_by_user_id(userid)
          if !@follow.nil? && @follow!='' && @follow.present?
            @follow.each do |fval|
              if @con_user.include?(fval["user_id"])
                #check notification
                @notify_setting_fo = ParentNotificationDetail.find_by_sql("select p.* from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id  where pn.notify_action='2' and lower(pn.notify_status)='active'and p.user_id=#{fval["user_id"]} and p.notify_flag=true")
                if !@notify_setting_fo.nil? && @notify_setting_fo!='' && @notify_setting_fo.present?
                  @user_mail = User.find_by_user_id(fval["user_id"])
                  if !@user_mail.nil? && @user_mail!='' && @user_mail.present?
                    if @user_mail["user_flag"]== true
                      @result = UserMailer.delay(queue: "Following User Create", priority: 2, run_at: 10.seconds.from_now).following_user_create_mail(@user_mail ,@follow_user,@activity_profile_apf,@get_current_url,params[:message],@user_mail.email_address,params[:subject])
                    end
                  end
                end
              end
            end
          end
        end
        # setting_option 3, just me activity only show to that person only
        if set_val["setting_option"]=="3"
          #if just me, dont send mail to oathers and me
        end
      end   #each loop end
    end    #setting loop
  end


  def invite_provider

  end

  def show
    @activities = Activity.find(params[:id])
  end

  def change_password
    p current_user
  end

  def update_password
    @user_details = current_user
    if params[:new_pass] == params[:confirm_pass]
      @password = params[:new_pass]
      if @user_details.user_password !=  Base64.encode64("#{@password}") && !@password.nil? && @password !=""
        @user_details.update_attributes(:user_password=> Base64.encode64("#{@password}")) if @password.present?
        respond_to do |format|
          format.js{render :text => "$('.success_update_info').css('display', 'block').fadeOut(5000);"}
        end
      end
    end#if first
  end


  def schedule_repeat_append(event,events,type_icon)
    @schedule.schedule_mode
    if @schedule.schedule_mode == "Schedule"
      start_date = "#{@schedule.start_date} #{@schedule.start_time.strftime('%H:%M:00')}" if !@schedule.start_date.nil? && !@schedule.start_time.nil?
      end_date = "#{@schedule.start_date} #{@schedule.end_time.strftime('%H:%M:00')}" if !@schedule.start_date.nil? && !@schedule.end_time.nil?
      @repeat = ActivityRepeat.where("activity_schedule_id =?",@schedule.schedule_id).last
      info = false
      js_start_date = Date.parse(session[:date])
      js_end_date = Date.parse(session[:date])
      @type_icon = type_icon
      if @repeat
        if @repeat.repeats == "Daily"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            repeat_schedule(event, events, js_end_date, js_start_date, running_date,'daily',info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              repeat_schedule_end(event, events, js_end_date, js_start_date, occ, running_date,'daily',info)
            else
              occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
              repeat_schedule_occurance(event, events, js_end_date, js_start_date, occ, running_date,'daily',info)
            end
          end
        end
        if @repeat.repeats == "yearly"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            repeat_schedule(event, events, js_end_date, js_start_date, running_date,'yearly',info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              repeat_schedule_end(event, events, js_end_date, js_start_date, occ, running_date,'yearly',info)
            else
              occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
              repeat_schedule_end(event, events, js_end_date, js_start_date, occ, running_date,'yearly',info)
            end
          end
        end
        if @repeat.repeats == "Weekly"
          running_date = @schedule.start_date
          @wek =[]
          @ss =[]
          rep = @repeat.repeat_on.split(",")
          rep.each do|s|
            if s=="Mon"
              @wek.push(1)
              @ss.push(:monday)
            elsif s =="Tue"
              @wek.push(2)
              @ss.push(:tuesday)
            elsif s =="Wed"
              @wek.push(3)
              @ss.push(:wednesday)
            elsif s =="Thu"
              @wek.push(4)
              @ss.push(:thursday)
            elsif s =="Fri"
              @wek.push(5)
              @ss.push(:friday)
            elsif s =="Sat"
              @wek.push(6)
              @ss.push(:saturday)
            elsif s =="Sun"
              @wek.push(0)
              @ss.push(:sunday)
            end if s!=""
          end
          if @repeat.ends_never == true
            repeat_weekly_never(event, events, js_end_date, js_start_date, running_date,info) if !@ss.nil? && !@ss.empty?
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              repeat_weekly(event, events, js_end_date, js_start_date, occ, running_date,info) if !@ss.nil? && !@ss.empty?
            else
              occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i * 7).days
              repeat_weekly(event, events, js_end_date, js_start_date, occ, running_date,info) if !@ss.nil? && !@ss.empty?
            end
          end
        end
        if @repeat.repeats == "Monthly"
          running_date = @schedule.start_date
          if @repeat.repeated_by_month == true
            s = week_of_month_for_date(running_date)
            if s == 1
              se = :first
            elsif s==2
              se = :second
            elsif s==3
              se = :third
            elsif s>=4
              se = :last
            end

            if @repeat.ends_never == true
              repeat_monthly_day_never(event, events, js_end_date, js_start_date, running_date,se,info)
            else
              if !@repeat.ends_on.nil?
                occ = @repeat.ends_on
                repeat_monthly_day(event, events, js_end_date, js_start_date, occ, running_date,se,info)
              else
                occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
                repeat_monthly_day(event, events, js_end_date, js_start_date, occ, running_date,se,info)
              end
            end
          else
            if @repeat.ends_never == true
              repeat_monthly_date_never(event, events, js_end_date, js_start_date, running_date,se,info)
            else
              if !@repeat.ends_on.nil?
                occ = @repeat.ends_on
                repeat_monthly_date(event, events, js_end_date, js_start_date, occ, running_date,se,info)
              else
                occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
                repeat_monthly_date(event, events, js_end_date, js_start_date, occ, running_date,se,info)
              end
            end
          end
        end
        if @repeat.repeats == "Every week (Monday to Friday)"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            every_week_mon_to_fri_never(event, events, js_end_date, js_start_date, running_date,info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              every_week_mon_to_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
            else
              occ = @schedule.start_date + (@repeat.end_occurences.to_i * 7).days
              every_week_mon_to_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
            end
          end
        end
        if @repeat.repeats == "Every Monday,Wednesday and Friday"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            every_mon_wed_fri_never(event, events, js_end_date, js_start_date, running_date,info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              every_mon_wed_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
            else
              occ = @schedule.start_date + (@repeat.end_occurences.to_i * 7).days
              every_mon_wed_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
            end
          end
        end
        if @repeat.repeats == "Every Tuesday and Thursday"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            every_tue_thu_never(event, events, js_end_date, js_start_date, running_date,info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              every_tue_thu(event, events, js_end_date, js_start_date, occ, running_date,info)
            else
              occ = @schedule.start_date + (@repeat.end_occurences.to_i * 7).days
              every_tue_thu(event, events, js_end_date, js_start_date, occ, running_date,info)
            end
          end
        end
      else
        start_date = "#{@schedule.start_date} #{@schedule.start_time.strftime('%H:%M:00')}" if !@schedule.start_date.nil? && !@schedule.start_time.nil?
        end_date = "#{@schedule.start_date} #{@schedule.end_time.strftime('%H:%M:00')}" if !@schedule.start_date.nil? && !@schedule.end_time.nil?
        p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"
        events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id,:start => "#{start_date}", :end => "#{end_date}"}
      end
    elsif @schedule.schedule_mode == "Camps/Workshop"
      start_date = "#{@schedule.start_date} #{@schedule.start_time.strftime('%H:%M:00')}" if !@schedule.start_date.nil? && !@schedule.start_time.nil?
      end_date = "#{@schedule.end_date} #{@schedule.end_time.strftime('%H:%M:00')}" if !@schedule.start_date.nil? && !@schedule.end_time.nil?

      if @schedule.start_date==@schedule.end_date
        events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id,:start => "#{start_date}", :end => "#{end_date}"}
      else
        events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id,:start => "#{start_date}", :end => "#{end_date}"}
      end
    elsif @schedule.schedule_mode == "Any Time"
      any_time = ActivitySchedule.where("activity_id = ?",event.activity_id)

      any_time.each do|s|
        if s.business_hours =="mon"
          r = Recurrence.new(:every => :week, :on => :monday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date|
            events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id

            } }
        elsif s.business_hours =="tue"
          r = Recurrence.new(:every => :week, :on => :tuesday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date|       events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          }
        elsif s.business_hours =="wed"
          r = Recurrence.new(:every => :week, :on => :wednesday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date|       events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          }
        elsif s.business_hours =="thu"
          r = Recurrence.new(:every => :week, :on =>:thursday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date|
            events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}

          }
        elsif s.business_hours =="fri"
          r = Recurrence.new(:every => :week, :on =>:friday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}  }
        elsif s.business_hours =="sat"
          r = Recurrence.new(:every => :week, :on => :saturday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date|  events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}   }
        elsif s.business_hours =="sun"
          r = Recurrence.new(:every => :week, :on => :sunday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}   }
        end if s.business_hours!=""
      end


    end if @schedule
  end


  def repeat_weekly(event, events, js_end_date, js_start_date, occ, running_date,info)
    date_un = DateTime.parse(js_end_date.to_s)
    if @repeat.repeat_every.to_i !=0
      r = Recurrence.new(:every => :week, :on => @ss,:starts =>running_date,:until => date_un,:interval=>@repeat.repeat_every.to_i)
    else
      r = Recurrence.new(:every => :week, :on => @ss,:starts =>running_date,:until => date_un)
    end

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date <= occ
          if r.events.include?(running_date)

            events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
            #            events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
          end
        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def repeat_weekly_never(event, events, js_end_date, js_start_date, running_date,info)
    date_js = DateTime.parse(js_end_date.to_s)
    if @repeat.repeat_every.to_i !=0
      r = Recurrence.new(:every => :week, :on => @ss,:starts =>running_date,:until => date_js,:interval=>@repeat.repeat_every.to_i)
    else
      r = Recurrence.new(:every => :week, :on => @ss,:starts =>running_date,:until => date_js)
    end

    while js_end_date >= running_date
      if js_start_date <= running_date
        if r.events.include?(running_date)
          events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def repeat_monthly_day(event, events, js_end_date, js_start_date, occ, running_date,se,info)
    w_day = running_date.strftime("%A") if !running_date.nil?
    r = Recurrence.new(:every => :month, :on => se,  :weekday =>:"#{w_day.downcase}" , :interval => @repeat.repeat_every.to_i)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date <= occ
          if r.events.include?(running_date)
            events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
            #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
          end
        end
      end
      running_date = running_date + 1.days
    end

    return running_date
  end

  # TODO Comment
  def repeat_monthly_day_never(event, events, js_end_date, js_start_date,running_date,se,info)
    w_day = running_date.strftime("%A") if !running_date.nil?
    r = Recurrence.new(:every => :month, :on => se,  :weekday =>:"#{w_day.downcase}" , :interval => @repeat.repeat_every.to_i)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if r.events.include?(running_date)
          events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def repeat_monthly_date_never(event, events, js_end_date, js_start_date,running_date,se,info)
    w_date = running_date.strftime("%d") if !running_date.nil?
    r = Recurrence.new(:every => :month, :on => w_date.to_i, :interval => @repeat.repeat_every.to_i)
    while js_end_date >= running_date
      if js_start_date <= running_date
        if r.events.include?(running_date)
          events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end



  def repeat_monthly_date(event, events, js_end_date, js_start_date, occ, running_date,se,info)
    w_date = running_date.strftime("%d") if !running_date.nil?
    r = Recurrence.new(:every => :month, :on => w_date.to_i, :interval => @repeat.repeat_every.to_i)

    while js_end_date >= running_date
      if running_date <= occ
        if r.events.include?(running_date)
          events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end if js_start_date <= running_date
      end
      running_date = running_date + 1.days
    end

    return running_date
  end

  # TODO Comment
  def every_week_mon_to_fri_never(event, events, js_end_date, js_start_date, running_date,info)


    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date.wday !=0 && running_date.wday !=6
          events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end

      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def every_week_mon_to_fri(event, events, js_end_date, js_start_date, occ, running_date,info)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date <= occ
          if running_date.wday !=0 && running_date.wday !=6
            events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
            #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
          end
        end
        running_date = running_date + 1.days
      end
    end
    return running_date
  end

  # TODO Comment
  def every_mon_wed_fri_never(event, events, js_end_date, js_start_date, running_date,info)

    while js_end_date > running_date
      if js_start_date <= running_date
        if running_date.wday ==1 || running_date.wday == 3 || running_date.wday == 5
          events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}

        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def every_mon_wed_fri(event, events, js_end_date, js_start_date, occ, running_date,info)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date <= occ
          if running_date.wday ==1 || running_date.wday == 3 || running_date.wday == 5
            events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
            #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
          end
        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def every_tue_thu_never(event, events, js_end_date, js_start_date, running_date,info)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date.wday ==2 || running_date.wday == 4
          events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          #         events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def every_tue_thu(event, events, js_end_date, js_start_date, occ, running_date,info)

    while js_end_date >= running_date
      if running_date.wday ==2 || running_date.wday == 4
        events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
      end if running_date <= occ if js_start_date <= running_date
      running_date = running_date + 1.days
    end
  end

  # TODO Comment
  def repeat_schedule_occurance(event, events, js_end_date, js_start_date, occ, running_date,type,info)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date <= occ
          events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
        end
      end
      rep = @repeat.repeat_every.to_i.days if type == 'daily'
      rep = @repeat.repeat_every.to_i.years if type == 'yearly'
      running_date = running_date + rep
    end
    return running_date
  end

  # TODO Comment
  def repeat_schedule_end(event, events, js_end_date, js_start_date, occ, running_date,type,info)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date <= occ
          events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          ##          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      rep = @repeat.repeat_every.to_i.days if type == 'daily'
      rep = @repeat.repeat_every.to_i.years if type == 'yearly'

      running_date = running_date + rep
    end
    return running_date
  end

  # TODO Comment
  def repeat_schedule(event, events, js_end_date, js_start_date,running_date,type,info)

    while js_end_date >= running_date
      if js_start_date <= running_date
        events << {:id => event.activity_id, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
      end
      rep = @repeat.repeat_every.to_i.days if type == 'daily'
      rep = @repeat.repeat_every.to_i.years if type == 'yearly'

      running_date = running_date + rep
    end

    return  running_date
  end

  def week_of_month_for_date(date)
    my_date = date
    week_of_target_date = my_date.strftime("%U").to_i if !my_date.nil?
    week_of_beginning_of_month = my_date.beginning_of_month.strftime("%U").to_i if !my_date.beginning_of_month.nil?
    week_of_target_date - week_of_beginning_of_month + 1
  end


  def contact_import

  end


  #settings for provider
  def user_setting(user_id)
    @flag = false
    @created_setting = ProviderSettingDetail.find_by_sql("select p.* from provider_setting_details s left join provider_settings p on s.provider_setting_id=p.provider_setting_id where s.setting_action='created' and p.user_id=#{user_id}")
    if !@created_setting.nil? && @created_setting!='' && @created_setting.present?
      #setting_option 1, show to famtiivty everyone
      @created_setting.each do |set_val|
        if set_val["setting_option"] == "1"
          @flag=true
        end
        if  current_user
          # setting_option 2, famtivity contact user only
          if set_val["setting_option"]=="2"
            @con_user = set_val["contact_user"].split(",")
            if @con_user.include?("#{current_user.user_id.to_i}")
              @flag=true
            end
          end
          # setting_option 3, just me activity only show to that person only
          if set_val["setting_option"]=="3"
            if user_id.to_i == current_user.user_id.to_i
              @flag=true
            end
          end
        end
      end #each loop end
    end
    # Default setting ,show to famtivity everyone
    if @created_setting == []
      @flag=true
    end
  end
  
  #active , inactive, expire view ount, share count activity list
  def activity_count_newsletter_api
    @act_result = Hash.new
    if params[:email] && params[:email]!=''
      @user = User.find_by_email_address(params[:email])
      if !@user.nil? && @user!='' && @user.present?
        @active_listings_list = Activity.active_activities_list(@user.user_id)
        if !@active_listings_list.nil? && @active_listings_list.length > 0
          @active_listings = @active_listings_list.length
        else
          @active_listings = 0
        end
        @discount_dollar_list = Activity.discount_dollar_activities(@user.user_id)
        if !@discount_dollar_list.nil? && @discount_dollar_list.length > 0
          @discount_dollar = @discount_dollar_list.length
        else
          @discount_dollar = 0
        end
        @inactive_list = Activity.inactive_activities(@user.user_id)
        if !@inactive_list.nil? && @inactive_list.length > 0
          @inactive = @inactive_list.length
        else
          @inactive = 0
        end
        @expired_list = Activity.expired_activities(@user.user_id)
        if !@expired_list.nil? && @expired_list.length > 0
          @expired = @expired_list.length
        else
          @expired = 0
        end
        #view : 500. 3% increase from last week
        p_str = ''
        @cal = 0
        @current_week = Activity.total_view_list(@user.user_id)
        @last_week = Activity.total_view_list_lastweek(@user.user_id)
        if !@current_week.nil? && @current_week.present? && @current_week.length > 0
          @current_week.each do |val|
            @current_wk_val = val.view_count
          end
        else
          @current_wk_val = 0
        end
        if !@last_week.nil? && @last_week.present? && @last_week.length > 0
          @last_week.each do |val|
            @last_wk_val = val.view_count
          end
        else
          @last_wk_val = 0
        end
			
        if @current_wk_val!='' && @last_wk_val!=''
          @cal = (@current_wk_val.to_f) - (@last_wk_val.to_f)
          @percentage = ((@current_wk_val.to_f) - (@last_wk_val.to_f))/100
        else
          @cal = 0
          @percentage = 0
        end
        if @cal!='' && @cal > 0
          p_str = "#{@current_wk_val}. #{@percentage} increase from last week"
        else
          if @cal == 0
            p_str = "#{@current_wk_val}. 0 from last week"
          else
            p_str = "#{@current_wk_val}. #{@percentage} decrease from last week"
          end
        end
        @view_percentage = p_str
        @top_view_activity = ''
        @top_view_activity_list = Activity.top_view_activities(@user.user_id)
        if !@top_view_activity_list.nil? && @top_view_activity_list.length > 0
          @top_view_activity_list.each do |activity|
            act = Activity.find_by_activity_id(activity.activity_id) if activity
            if @top_view_activity!=''
              @top_view_activity = "#{@top_view_activity},#{act.activity_name.capitalize}" if act && act.present? && !act.activity_name.nil?
            else
              @top_view_activity = act.activity_name.capitalize if act && act.present? && !act.activity_name.nil?
            end
          end
        else
          @top_view_activity = "No activities"
        end
			
        @top_activity_share = ''
        @top_activity_share_list = Activity.top_share_activities(@user.user_id)
        if !@top_activity_share_list.nil? && @top_activity_share_list.length > 0
          @top_activity_share_list.each do |activity|
            act = Activity.find_by_activity_id(activity.activity_id) if activity
            if @top_activity_share!=''
              @top_activity_share = "#{@top_activity_share},#{act.activity_name.capitalize}" if act && act.present? && !act.activity_name.nil?
            else
              @top_activity_share = act.activity_name.capitalize if act && act.present? && !act.activity_name.nil?
            end
          end
        else
          @top_activity_share = "No activities"
        end
			
        @leads_list = Activity.lead_user_list(@user.email_address)
        if !@leads_list.nil? && @leads_list.length > 0
          @leads = @leads_list.length
        else
          @leads = 0
        end
        @registration_list =Activity.provider_invitee_list(@user.user_id)
        if !@registration_list.nil? && @registration_list.length > 0
          @registration = @registration_list.length
        else
          @registration = 0
        end
        arr = []
        arr << {"active_listing"=>@active_listings,"discount_dollar"=>@discount_dollar ,"inactive_activity"=>@inactive,"expired_Activity"=>@expired, "view"=>@view_percentage, "top_activity"=>@top_view_activity, "top_share_activity"=>@top_activity_share,"leads"=>@leads,"registration"=>@registration}
        @act_result["result"] = "Success"
        @act_result["message"] = "Successfully get the details"
        @act_result["data"] = arr
        response.content_type = Mime::JSON
        render :text => @act_result.to_json
      else
        @act_result["result"] = "Failure"
        @act_result["message"] = "Invalid user"
        response.content_type = Mime::JSON
        render :text => @act_result.to_json
      end
    else
      @act_result["result"] = "Failure"
      @act_result["message"] = "Failure"
      response.content_type = Mime::JSON
      render :text => @act_result.to_json
		
    end
  end
  #activitu count newsletter
  def activity_count_newsletter
    @act_result = Hash.new
    if params[:email] && params[:email]!=''
      @user = User.find_by_email_address(params[:email])
      if !@user.nil? && @user!='' && @user.present?
        @result = NewsletterMailer.delay(queue: "Provider activity count", priority: 2, run_at: 10.seconds.from_now).user_activity_count(@user)
        @act_result["result"] = "Success"
        @act_result["message"] = "Mail has been send successfully"
        response.content_type = Mime::JSON
        render :text => @act_result.to_json
      else
        @act_result["result"] = "Failure"
        @act_result["message"] = "Invalid user"
        response.content_type = Mime::JSON
        render :text => @act_result.to_json
      end
    else
      @act_result["result"] = "Failure"
      @act_result["message"] = "Failure"
      response.content_type = Mime::JSON
      render :text => @act_result.to_json
		
    end
  end
  
end