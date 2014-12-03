class AdminController < ApplicationController
  before_filter :authenticate_user_admin
  require 'date'
  require 'time'
  require 'will_paginate/array'

  def index
    params["mode"]='admin'
    session[:city] ="Location"
    #    @act = Activity.where(['created_by = ? AND lower(active_status)!= ?', "Provider", "delete"]).order("activity_id desc").find(:all)
    params[:cat] = cookies[:pro_id] if !cookies[:pro_id].nil?
    params[:cat_zc] = cookies[:cat_zc] if !cookies[:cat_zc].nil?
    @act = Activity.get_admin_activities(params[:cat_zc],session[:city],params[:cat],params[:date_from], params[:date_to])
    @view = params[:view]
    @view = "view" if params[:view].nil?
    #auto complete variable
    @auto_comp_admin=@act
    if !cookies[:last_action].nil? && cookies[:last_action].present? && !cookies[:page].nil? && cookies[:page].present? && (cookies[:last_action]=="provider_edit_activity" || cookies[:last_action]=="delete_activity")
      params[:page] = cookies[:page] if !cookies[:page].nil?
    end
    cookies[:page] = params[:page] if !params[:page].nil?
    @accordion = Activity.order("category Asc").find(:all,:group=>'category',:select => "DISTINCT lower(trim(category))as category,count(DISTINCT lower(trim(sub_category)))as category_count")
    @activities = @act.paginate(:page => params[:page], :per_page =>36)
    if @activities.length==0 && !@act.nil? && @act.present?
      params[:page] = (params[:page].to_i) - 1
      @activities = @act.paginate(:page => params[:page], :per_page =>36)   
    end
    @provider_by = Activity.find_by_sql("select Distinct(users.email_address),users.user_id from activities,users where activities.user_id = users.user_id order by users.email_address asc;")
    cookies[:last_action]=""
    cookies[:page]=""
    cookies[:cat_zc]=""
    cookies[:pro_id]=""
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def activity_provider_list_res
    @provider = User.where("email_address ='#{params[:user]}'").last

    @user = UserProfile.where("user_id = #{@provider.user_id}").last
    @activity = Activity.where("user_id = #{@provider.user_id} and lower(active_status) = 'active' and cleaned = true")
    render :layout=>false
  end

  def activity_provider_list
    render :layout=>false
  end



  
  #admin activity category reports
  def category_reports
    params["mode"]='admin'
    @fam_city = Activity.all
    @city = @fam_city.map(&:city).uniq
    @category = @fam_city.map(&:category).uniq
	
    city_category = ""
    #all citities and all categories
    if !params[:cat].nil? && !params[:city_name].nil? && params[:city_name].downcase=="all cities" && params[:cat].downcase=="all categories"
      city_category = ""
      #selected city with all categories
    elsif (!params[:cat].nil? && !params[:city_name].nil? && params[:city_name].downcase != "all cities" && params[:cat].downcase == "all categories")
      city_category = "and lower(city) = '#{params[:city_name].downcase}'" if !params[:cat].nil? && !params[:city_name].nil?
      #selected category with all cities
    elsif (!params[:cat].nil? && !params[:city_name].nil? && params[:city_name].downcase == "all cities" && params[:cat].downcase != "all categories")
      city_category = "and lower(category) = '#{params[:cat].downcase}'" if !params[:cat].nil? && !params[:city_name].nil?
      #selected category and selected city
    elsif (!params[:cat].nil? && !params[:city_name].nil? && params[:city_name].downcase != "all cities" && params[:cat].downcase != "all categories")
      city_category = "and lower(category) = '#{params[:cat].downcase}' and lower(city) = '#{params[:city_name].downcase}'" if !params[:cat].nil? && !params[:city_name].nil?
    end
    #new changes
    @act_row_page = Activity.find_by_sql("SELECT * FROM activities where lower(active_status)='active' and lower(created_by)='provider' and cleaned =true #{city_category} order by activity_id desc").uniq
    if !@act_row_page.nil? && @act_row_page!="" && @act_row_page.present?
      @total = @act_row_page.length
    else
      @total = 0
    end
    #display the providers count
    @act_provider_act = @act_row_page.map(&:user_id).uniq if @act_row_page
    if !@act_provider_act.nil? && @act_provider_act!="" && @act_provider_act.present?
      @total_provider_l = @act_provider_act.length
    else
      @total_provider_l = 0
    end
	
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  #email metric reports for the all the providers list
  def email_metrics
    params["mode"]='admin'
    if params[:filter_value] && !params[:filter_value].nil? && params[:filter_value].present? && params[:filter_value]!="" && params[:filter_value] == "by_curator"
      @users = Activity.find_by_sql("select u.user_name,u.user_id,up.business_name,u.email_address from users u left join user_profiles up on u.user_id=up.user_id where lower(u.user_type)='p' and lower(user_plan)='curator' and user_flag=false and u.account_active_status=true order by u.user_id desc")
    elsif params[:filter_value] && !params[:filter_value].nil? && params[:filter_value].present? && params[:filter_value]!="" && params[:filter_value] == "Free"
      @users = Activity.find_by_sql("select u.user_name,u.user_id,up.business_name,u.email_address from users u left join user_profiles up on u.user_id=up.user_id where lower(u.user_type)='p' and lower(user_plan)='free' and manage_plan is null and u.account_active_status=true order by u.user_id desc")
    elsif params[:filter_value] && !params[:filter_value].nil? && params[:filter_value].present? && params[:filter_value]!="" && params[:filter_value] == "market_sell"
      @users = Activity.find_by_sql("select u.user_name,u.user_id,up.business_name,u.email_address from users u left join user_profiles up on u.user_id=up.user_id where lower(u.user_type)='p' and lower(user_plan)='sell' and lower(manage_plan) = 'market_sell' and u.account_active_status=true order by u.user_id desc")
    elsif params[:filter_value] && !params[:filter_value].nil? && params[:filter_value].present? && params[:filter_value]!="" && params[:filter_value] == "market_sell_manage"
      @users = Activity.find_by_sql("select u.user_name,u.user_id,up.business_name,u.email_address from users u left join user_profiles up on u.user_id=up.user_id where lower(u.user_type)='p' and lower(user_plan)='sell' and lower(manage_plan) = 'market_sell_manage' and u.account_active_status=true order by u.user_id desc")
    elsif params[:filter_value] && !params[:filter_value].nil? && params[:filter_value].present? && params[:filter_value]!="" && params[:filter_value] == "market_sell_manage_plus"
      @users = Activity.find_by_sql("select u.user_name,u.user_id,up.business_name,u.email_address from users u left join user_profiles up on u.user_id=up.user_id where lower(u.user_type)='p' and lower(user_plan)='sell' and lower(manage_plan) = 'market_sell_manage_plus' and u.account_active_status=true order by u.user_id desc")
    else
      @users = Activity.find_by_sql("select u.user_name,u.user_id,up.business_name,u.email_address from users u left join user_profiles up on u.user_id=up.user_id where lower(u.user_type)='p' and lower(user_plan)='sell' and manage_plan is not null and u.account_active_status=true order by u.user_id desc")
    end

    @activities = @users.paginate(:page => params[:page], :per_page =>15)

    @start_date = params[:date_from] if params[:date_from] && !params[:date_from].nil? && params[:date_from]!=""
    @end_date = params[:date_to] if params[:date_to] && !params[:date_to].nil? && params[:date_to]!=""
     
    @tpage = @activities.total_pages if !@activities.nil? && @activities.present?
    
    @show_all=params[:show_all]  && !params[:show_all].nil? && params[:show_all]!=""
    @show_filters = params[:filter_value] && !params[:filter_value].nil? && params[:filter_value]!=""
    if params[:page].nil?
      @pva = 1
    else
      @pva = params[:page]
    end
    
    respond_to do |format|
      format.html
      format.js
      format.xls #for excel format
    end
  end

  def email_metrics_report
    if request.xhr?
      if(!params[:date_from].nil? && params[:date_from].present?)
        @date_from = params[:date_from]
        @date_to = Date.parse(params[:date_from],'%Y-%m-%d') + 30.days
        #@users = ProviderTransaction.find_by_sql("select business_name, email_address, start_date, end_date, provider_transactions.user_id from provider_transactions, user_profiles where date(provider_transactions.start_date) >= '#{@date_from}' and  date(provider_transactions.end_date) <= '#{@date_to}' and provider_transactions.user_id = user_profiles.user_id")
        @users = ProviderTransaction.find_by_sql("select business_name, email_address, start_date, end_date, provider_transactions.user_id from provider_transactions, user_profiles where date(provider_transactions.inserted_date) >= '#{@date_from}' and provider_transactions.user_id = user_profiles.user_id")
	@active_users = @users.paginate(:page => params[:page], :per_page =>15)
        @pva = @active_users.total_pages
      end
    else
      @active_users = nil
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def sort_process
    if request.xhr?
      if(!params[:sort_type].blank? && !params[:sort_name].blank? && !params[:date_from].blank?)
        sort_name = params[:sort_name].split("_").first
        order_name = case sort_name
          when "bname"
            "business_name"
          when "email"
            "email_address"
        end
        @date_from = params[:date_from]
        @date_to = Date.parse(params[:date_from],'%Y-%m-%d') + 30.days
        @users = ProviderTransaction.find_by_sql("select business_name, email_address, start_date, end_date, provider_transactions.user_id from provider_transactions, user_profiles where date(provider_transactions.start_date) >= '#{@date_from}' and  date(provider_transactions.end_date) <= '#{@date_to}' and provider_transactions.user_id = user_profiles.user_id order by #{order_name} #{params[:sort_type]};")
        @active_users = @users.paginate(:page => params[:page], :per_page =>15)
        @pva = @active_users.total_pages
      else
        @active_users = nil
      end
    else
      @active_users = nil
    end
    respond_to do |format|
      format.js
    end
  end

  def metric_report_generation
    if(!params[:user_ids].nil? && params[:user_ids].present?)
      @ids = params[:user_ids].split(",")
      @mode = params[:email_mode]
      @to_mail = params[:to_email]
      @end_date = params[:date_to]
      @users = User.where("user_id in (?)",@ids)
      !@users.blank? && @users.each do |user|
        @result = NewsletterMailer.delay(queue: "Provider activity count", priority: 2, run_at: 10.seconds.from_now).metric_report(user,@mode,@to_mail,@end_date)
      end
      render :text => 'Success'
    end
  end

  def metric_process
    @mode = params[:email_mode]
    @user_ids = params[:user_ids]
    @date_from = params[:date_from]
    @date_to = Date.parse(params[:date_from],'%Y-%m-%d') + 30.days 
    render :layout => false
  end
  
  #famtivity user reports
  def user_reports
    params["mode"]='admin'
	   
    @user_type = params[:user_type] if params[:user_type]!="" && !params[:user_type].nil?
    @start_date = params[:date_from] if params[:date_from] && !params[:date_from].nil? && params[:date_from]!=""
    @end_date = params[:date_to] if params[:date_to] && !params[:date_to].nil? && params[:date_to]!=""

    respond_to do |format|
      format.html
      format.js
    end
  end


  def admin_user_list
    params["mode"]='admin'
    # if !params[:list].nil? && params[:list]="admin"
    # @fam_user_list=User.find_all_by_user_type("A")
    #end
    @admin_list=[]
    @dd=  params[:list].gsub('[','').gsub(']','') if !params[:list].nil?
    @fam_list =@dd.split(",")

    @fam_list.each do |f|
      user=User.where("user_id=?",f)
      @admin_list << user if !user.nil?
    end
    @fam_user_list=@admin_list.flatten
    respond_to do |format|
      format.js
    end
  end

  #famtivity general reports
  def general_reports
    params["mode"]='admin'
	   
    #@user_type = params[:user_type] if params[:user_type]!="" && !params[:user_type].nil?
    @start_date = params[:date_from] if params[:date_from] && !params[:date_from].nil? && params[:date_from]!=""
    @end_date = params[:date_to] if params[:date_to] && !params[:date_to].nil? && params[:date_to]!=""

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def admin_gallery
	  params["mode"]='admin'
    session[:city] ="Location"
    params[:cat] = cookies[:pro_id] if !cookies[:pro_id].nil?
    params[:cat_zc] = cookies[:cat_zc] if !cookies[:cat_zc].nil?
    @act = Activity.get_admin_activities(params[:cat_zc],session[:city],params[:cat],params[:date_from], params[:date_to])
    #    @act = Activity.where(['created_by = ? AND lower(active_status)!= ?', "Provider", "delete"]).order("activity_id desc").find(:all)
    @view = "gallery"
    #auto complete variable
    @auto_comp_admin=@act
    params[:page] = cookies[:page] if !cookies[:last_action].nil? && cookies[:last_action].present? && cookies[:last_action]=="provider_edit_activity" && !cookies[:page].nil? && cookies[:page].present?
    #cookies[:page] = params[:page] if !params[:page].nil?
    @accordion = Activity.order("category Asc").find(:all,:group=>'category',:select => "DISTINCT lower(trim(category))as category,count(DISTINCT lower(trim(sub_category)))as category_count")
    @activities = @act.paginate(:page =>params[:page], :per_page =>36)
    @provider_by = Activity.find_by_sql("select Distinct(users.email_address),users.user_id from activities,users where activities.user_id = users.user_id order by users.email_address asc;")
    @curator_by = Activity.find_by_sql("select Distinct(users.email_address),users.user_id from activities,users where activities.user_id = users.user_id and users.user_plan='curator' order by users.email_address asc;")
    cookies[:last_action]=""
    cookies[:page]=""
    cookies[:cat_zc]=""
    cookies[:pro_id]=""
    respond_to do |format|
      format.html
      format.js
    end
  end

  def provider_curator
    #displayed the curator show card approved and non approved cards
    if params[:show] && params[:show]!="" && params[:show].present? && params[:show] == "Approved"
      @user_to = User.order("user_id desc").where("user_plan = 'curator' and show_card=true")
    elsif params[:show] && params[:show]!="" && params[:show].present? && params[:show] == "UnApproved"
      @user_to = User.order("user_id desc").where("user_plan = 'curator' and show_card=false")
    else
      @user_to = User.order("user_id desc").where("user_plan = 'curator'")
    end
    
    @user = @user_to.paginate(:page =>params[:page] || 1, :per_page =>36)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def raise_flag_provider_update
    @user = User.find(params[:user_id])
    if params[:approve] =="true"
      @user.update_attributes(:show_card=>true)
    else
      @user.update_attributes(:show_card=>false)
      @get_current_url = request.env['HTTP_HOST']
      #UserMailer.delay(queue: "Admin Mail", priority: 2, run_at: 10.seconds.from_now).admin_user_mail(@activity,$admin_email_address,@get_current_url,params[:desc])
      #UserMailer.admin_user_mail(@activity,$admin_email_address,@get_current_url,params[:desc]).deliver

    end
    render :text => @user.to_json
  end


  #search implemented for admin index page using ajax call
  def search_admin_index
    params[:search_text_admin]
    @view = params[:view]
    @view = "view" if params[:view].nil?
    #sphinx search
    #act = Activity.search params[:search_text], :conditions => {:created_by=>"Provider"}, :with => {:user_id => "#{cookies[:uid_usr]}"}
  
    #normal search with ajax call
    #select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id
    @act = Activity.find_by_sql("select * from activities act left join user_profiles usp on act.user_id= usp.user_id left join users usr on act.user_id= usr.user_id where ((act.activity_name like '%#{params[:search_text_admin].downcase}%') or (usp.business_name like '%#{params[:search_text_admin].downcase}%') or  (usr.email_address like '%#{params[:search_text_admin].downcase}%')) and cleaned=true and lower(act.active_status)!='delete' and lower(act.created_by)='provider' order by act.activity_id desc ")
    #@act = Activity.find_by_sql("select * from activities where activity_name like '%#{params[:search_text_admin].downcase}%' and cleaned=true and lower(active_status)!='delete' and lower(created_by)='provider' order by activities.activity_id desc ")
    #@act = Activity.search(params[:search_text_admin])
    @act = [] if @act.nil?
    #pagination for activities
    
    @activities = @act.paginate(:page => params[:page], :per_page =>36)

  end
  

  def index_update
    session[:city] = params[:city] unless params[:city].nil?
    @view = params[:view]
    @view = "view" if params[:view].nil?
    if params[:cat_zc] =="next_7_days"
      params[:date_from] = Date.today
      params[:date_to] = Date.today + 7.days
    end
    params[:page] = cookies[:page] if !cookies[:last_action].nil? && cookies[:last_action].present? && cookies[:last_action]=="provider_edit_activity" && !cookies[:page].nil? && cookies[:page].present?
    @view = "gallery" if params[:view].nil?
    @act = Activity.get_admin_activities(params[:cat_zc],session[:city],params[:cat],params[:date_from], params[:date_to])
    @activities = @act.paginate(:page => params[:page], :per_page =>36)
    
    respond_to do |format|
      format.html
      format.js
    end
  end
 

  def status_update
    @view = params[:view]
    @view = "view" if params[:view].nil?
    session[:city] = params[:city] unless params[:city].nil?
    @activity = Activity.find(params[:activity_id])
    if @activity.active_status=="Active"
      @activity.update_attributes(:active_status=>"Inactive")
    else
      @activity.update_attributes(:active_status=>"Active")
    end if !@activity.nil?
    @act = Activity.get_admin_activities(params[:cat_zc],session[:city],params[:cat],params[:date_from], params[:date_to])
    @activities = @act.paginate(:page => params[:page], :per_page =>36)
    respond_to do |format|
      format.js
    end
  end

  def delete_activity
    @to_delete = params[:id]
    @prop = params[:prop]
    @page = params[:page]
  end




  def raise_flag_update

    @activity = Activity.find(params[:activity_id])
    if params[:approve] =="true"
      @activity.update_attributes(:approve_flag=>true,:cleaned=>true,:raised_flag=>false,:report=>"")
    else
      @activity.update_attributes(:report=>params[:desc],:cleaned=>false,:raised_flag=>true,:approve_flag=>false)
      @get_current_url = request.env['HTTP_HOST']
      #UserMailer.delay(queue: "Admin Mail", priority: 2, run_at: 10.seconds.from_now).admin_user_mail(@activity,$admin_email_address,@get_current_url,params[:desc])
      #UserMailer.admin_user_mail(@activity,$admin_email_address,@get_current_url,params[:desc]).deliver

    end
    render :text => @activity.to_json
  end


  def destroy
    @view = params[:view]
    @view = "view" if params[:view].nil?
    activity_details=params[:id].split(",")
    activity_details.each do|activity|
      if activity!="" && !activity.nil?
        @act=Activity.find(activity) if !activity.nil?
        #        @schedule=ActivitySchedule.find_by_activity_id(@act)
        #        @repeat = ActivityRepeat.find_by_activity_schedule_id(@schedule.schedule_id)if !@schedule.nil?
        #        @repeat.destroy if !@repeat.nil?
        #
        #        @schedule.destroy if !@schedule.nil?
        #        @share = ActivityShare.find_by_activity_id(@act) if !@share.nil?
        #        @share.destroy if !@share.nil?
       
        Activity.find(activity).destroy if !activity.nil?
      end #do method
    end if activity_details.length >0

    cookies[:last_action] = params[:last_action]
    cookies[:page] = params[:page]

    @act = Activity.get_admin_activities(params[:cat_zc],session[:city],params[:cat],params[:date_from], params[:date_to])
    @activities = @act.paginate(:page => params[:page], :per_page =>36)
    if @activities.length==0 && !@act.nil? && @act.present?
      params[:page] = (params[:page].to_i) - 1
      @activities = @act.paginate(:page => params[:page], :per_page =>36)   
    end

    respond_to do |format|
      format.js
    end
  end

  def mark_featured
    @view = params[:view]
    @view = "view" if params[:view].nil?
    activity_details=params[:id].split(",")
    activity_details.each do |activity|
      if activity!="" && !activity.nil?
        @act=Activity.find(activity) if !activity.nil?
        @act.update_attribute(:featured_flag,true) if !@act.nil?
      end #do method
    end if activity_details.length >0

    @act = Activity.get_admin_activities(params[:cat_zc],session[:city],params[:cat],params[:date_from], params[:date_to])
    @activities = @act.paginate(:page => params[:page], :per_page =>36)

    respond_to do |format|
      format.js
    end
  end


  def schedule_repeat_append(event,events,type_icon)
    p @schedule.schedule_mode
    if @schedule.schedule_mode == "Schedule"
      start_date = "#{@schedule.start_date} #{@schedule.start_time.strftime('%H:%M:00')}"
      end_date = "#{@schedule.start_date} #{@schedule.end_time.strftime('%H:%M:00')}"
      @repeat = ActivityRepeat.where("activity_schedule_id =?",@schedule.schedule_id).last
      info = false
      js_start_date = Time.at(params['start'].to_i)
      js_end_date =Time.at(params['end'].to_i)
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
            if s=="Mon"||s=="mon"
              @wek.push(1)
              @ss.push(:monday)
            elsif s =="Tue"||s=="tue"
              @wek.push(2)
              @ss.push(:tuesday)
            elsif s =="Wed"||s=="wed"
              @wek.push(3)
              @ss.push(:wednesday)
            elsif s =="Thu"||s=="thu"
              @wek.push(4)
              @ss.push(:thursday)
            elsif s =="Fri"||s=="fri"
              @wek.push(5)
              @ss.push(:friday)
            elsif s =="Sat"||s=="sat"
              @wek.push(6)
              @ss.push(:saturday)
            elsif s =="Sun"||s=="sun"
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
        start_date = "#{@schedule.start_date} #{@schedule.start_time.strftime('%H:%M:00')}"
        end_date = "#{@schedule.start_date} #{@schedule.end_time.strftime('%H:%M:00')}"
        p_date = "#{@schedule.start_date} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"
        events << {:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}", :description => event.description,:uni_date=>@schedule.start_date, :start => "#{start_date}", :end => "#{end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}
      end
    elsif @schedule.schedule_mode == "Camps/Workshop"
      start_date = "#{@schedule.start_date} #{@schedule.start_time.strftime('%H:%M:00')}"
      end_date = "#{@schedule.end_date} #{@schedule.end_time.strftime('%H:%M:00')}"
      p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} - #{@schedule.end_date.strftime("%a %m/%d/%Y")} #{@schedule.end_time.strftime('%I:%M%p')}"

      if @schedule.start_date==@schedule.end_date
        events << {:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}", :description => event.description,:uni_date=>@schedule.start_date, :start => "#{start_date}", :end => "#{end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}
      else
        events << {:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}", :description => event.description,:uni_date=>@schedule.start_date, :start => "#{start_date}", :end => "#{end_date}", :allDay =>1,:type_icon=>@type_icon, :recurring => true}
      end
    elsif @schedule.schedule_mode == "Any Time"
      any_time = ActivitySchedule.where("activity_id = ?",event.activity_id)

      any_time.each do|s|
        if s.business_hours =="mon"
          r = Recurrence.new(:every => :week, :on => :monday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          p_date = "#{s.start_time.strftime('%I:%M%p')} & #{s.end_time.strftime('%I:%M%p')}"
          r.events.each { |date| events << {:id => event.activity_id, :title => event.activity_name, :description => event.description,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>"#{date.to_s}#{event.activity_id}", :start => "#{date.to_s}", :end => "#{date.to_s}", :allDay =>1,:type_icon=>@type_icon, :recurring => true } }
        elsif s.business_hours =="tue"
          p_date = "#{s.start_time.strftime('%I:%M%p')} & #{s.end_time.strftime('%I:%M%p')}"
          r = Recurrence.new(:every => :week, :on => :tuesday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:id => event.activity_id, :title => event.activity_name, :description => event.description,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>"#{date.to_s}#{event.activity_id}", :start => "#{date.to_s}", :end => "#{date.to_s}", :allDay =>1,:type_icon=>@type_icon, :recurring => true } }
        elsif s.business_hours =="wed"
          p_date = "#{s.start_time.strftime('%I:%M%p')} & #{s.end_time.strftime('%I:%M%p')}"
          r = Recurrence.new(:every => :week, :on => :wednesday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:id => event.activity_id, :title => event.activity_name, :description => event.description,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>"#{date.to_s}#{event.activity_id}", :start => "#{date.to_s}", :end => "#{date.to_s}", :allDay =>1,:type_icon=>@type_icon, :recurring => true } }
        elsif s.business_hours =="thu"
          p_date = "#{s.start_time.strftime('%I:%M%p')} & #{s.end_time.strftime('%I:%M%p')}"
          r = Recurrence.new(:every => :week, :on =>:thursday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:id => event.activity_id, :title => event.activity_name, :description => event.description,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>"#{date.to_s}#{event.activity_id}", :start => "#{date.to_s}", :end => "#{date.to_s}", :allDay =>1,:type_icon=>@type_icon, :recurring => true } }
        elsif s.business_hours =="fri"
          p_date = "#{s.start_time.strftime('%I:%M%p')} & #{s.end_time.strftime('%I:%M%p')}"
          r = Recurrence.new(:every => :week, :on =>:friday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:id => event.activity_id, :title => event.activity_name, :description => event.description,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>"#{date.to_s}#{event.activity_id}", :start => "#{date.to_s}", :end => "#{date.to_s}", :allDay =>1,:type_icon=>@type_icon, :recurring => true } }
        elsif s.business_hours =="sat"
          p_date = "#{s.start_time.strftime('%I:%M%p')} & #{s.end_time.strftime('%I:%M%p')}"
          r = Recurrence.new(:every => :week, :on => :saturday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}", :description => event.description,:uni_date=>"#{date.to_s}#{event.activity_id}", :start => "#{date.to_s}", :end => "#{date.to_s}", :allDay =>1,:type_icon=>@type_icon, :recurring => true } }
        elsif s.business_hours =="sun"
          p_date = "#{s.start_time.strftime('%I:%M%p')} & #{s.end_time.strftime('%I:%M%p')}"
          r = Recurrence.new(:every => :week, :on => :sunday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}", :description => event.description,:uni_date=>"#{date.to_s}#{event.activity_id}", :start => "#{date.to_s}", :end => "#{date.to_s}", :allDay =>1,:type_icon=>@type_icon, :recurring => true } }
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
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if js_start_date < running_date
        if running_date < occ
          if r.events.include?(running_date)
            repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
            repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"

            events << {:id => event.activity_id, :title => event.activity_name,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>running_date.strftime("%Y-%m-%d"),:leader=>event.leader,:pop_date=>p_date,  :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}

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
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if js_start_date < running_date
        if r.events.include?(running_date)
          repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
          repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"
          events << {:id => event.activity_id, :title => event.activity_name,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>running_date.strftime("%Y-%m-%d"), :leader=>event.leader,:pop_date=>p_date, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}

          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def repeat_monthly_day(event, events, js_end_date, js_start_date, occ, running_date,se,info)
    w_day = running_date.strftime("%A")
    r = Recurrence.new(:every => :month, :on => se,  :weekday =>:"#{w_day.downcase}" , :interval => @repeat.repeat_every.to_i)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if running_date < occ
        if r.events.include?(running_date)
          repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
          repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"
          events << {:id => event.activity_id, :title => event.activity_name,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>running_date.strftime("%Y-%m-%d"),:leader=>event.leader,:pop_date=>p_date,:description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}

          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end if js_start_date < running_date
      end
      running_date = running_date + 1.days
    end

    return repeat_end_date, repeat_start_date, running_date
  end

  # TODO Comment
  def repeat_monthly_day_never(event, events, js_end_date, js_start_date,running_date,se,info)
    w_day = running_date.strftime("%A")
    r = Recurrence.new(:every => :month, :on => se,  :weekday =>:"#{w_day.downcase}" , :interval => @repeat.repeat_every.to_i)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if js_start_date < running_date
        if r.events.include?(running_date)
          repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
          repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"
          events << {:id => event.activity_id, :title => event.activity_name,:address=>"#{event.address_1} #{event.address_2}", :leader=>event.leader,:pop_date=>p_date, :uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}

          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      running_date = running_date + 1.days
    end
    return repeat_end_date, repeat_start_date, running_date
  end

  # TODO Comment
  def repeat_monthly_date_never(event, events, js_end_date, js_start_date,running_date,se,info)
    w_date = running_date.strftime("%d")
    r = Recurrence.new(:every => :month, :on => w_date.to_i, :interval => @repeat.repeat_every.to_i)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if js_start_date < running_date
        if r.events.include?(running_date)
          repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
          repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"
          events << {:id => event.activity_id, :title => event.activity_name,:address=>"#{event.address_1} #{event.address_2}", :leader=>event.leader,:pop_date=>p_date, :uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}

          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      running_date = running_date + 1.days
    end
    return repeat_end_date, repeat_start_date, running_date
  end



  def repeat_monthly_date(event, events, js_end_date, js_start_date, occ, running_date,se,info)
    w_date = running_date.strftime("%d")
    r = Recurrence.new(:every => :month, :on => w_date.to_i, :interval => @repeat.repeat_every.to_i)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if running_date < occ
        if r.events.include?(running_date)
          repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
          repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"
          events << {:id => event.activity_id, :title => event.activity_name,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>running_date.strftime("%Y-%m-%d"),:leader=>event.leader,:pop_date=>p_date,:description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}

          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end if js_start_date < running_date
      end
      running_date = running_date + 1.days
    end

    return repeat_end_date, repeat_start_date, running_date
  end

  # TODO Comment
  def every_week_mon_to_fri_never(event, events, js_end_date, js_start_date, running_date,info)

    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if running_date.wday !=0 && running_date.wday !=6
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"
        events << {:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}

        #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
      end if js_start_date < running_date

      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def every_week_mon_to_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if running_date.wday !=0 && running_date.wday !=6
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"
        events << {:id => event.activity_id, :title => event.activity_name,:uni_date=>running_date.strftime("%Y-%m-%d"),:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}", :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}

        #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
      end if running_date <= occ if js_start_date < running_date
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def every_mon_wed_fri_never(event, events, js_end_date, js_start_date, running_date,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if running_date.wday ==1 || running_date.wday == 3 || running_date.wday == 5
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"
        events << {:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}

        #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}

      end if js_start_date < running_date
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def every_mon_wed_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if running_date.wday ==1 || running_date.wday == 3 || running_date.wday == 5
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"
        events << {:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}

        #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
      end if running_date <= occ if js_start_date < running_date
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def every_tue_thu_never(event, events, js_end_date, js_start_date, running_date,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if running_date.wday ==2 || running_date.wday == 4
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"
        events << {:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}

        #         events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
      end if js_start_date < running_date
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def every_tue_thu(event, events, js_end_date, js_start_date, occ, running_date,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if running_date.wday ==2 || running_date.wday == 4
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"
        events << {:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}

      end if running_date <= occ if js_start_date < running_date
      running_date = running_date + 1.days
    end
  end

  # TODO Comment
  def repeat_schedule_occurance(event, events, js_end_date, js_start_date, occ, running_date,type,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if running_date <= occ
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"
        events << {:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}",:uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}
        #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
      end if js_start_date < running_date
      rep = @repeat.repeat_every.to_i.days if type == 'daily'
      rep = @repeat.repeat_every.to_i.years if type == 'yearly'
      running_date = running_date + rep
    end
    return running_date
  end

  # TODO Comment
  def repeat_schedule_end(event, events, js_end_date, js_start_date, occ, running_date,type,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if js_start_date < running_date
        if running_date <= occ
          repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
          repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"
          events << {:id => event.activity_id, :leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}",:title => event.activity_name,:uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true}
          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
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
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")} #{@schedule.start_time.strftime('%I:%M%p')} & #{@schedule.end_time.strftime('%I:%M%p')}"

    while js_end_date > running_date
      if js_start_date < running_date
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00')}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')}"

        events << {:id => event.activity_id, :leader=>event.leader,:pop_date=>p_date,:address=>"#{event.address_1} #{event.address_2}",:title => event.activity_name,:description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :uni_date=>running_date.strftime("%Y-%m-%d"),:info=>info, :allDay =>0,:type_icon=>@type_icon, :recurring => true}
      end
      rep = @repeat.repeat_every.to_i.days if type == 'daily'
      rep = @repeat.repeat_every.to_i.years if type == 'yearly'

      running_date = running_date + rep
    end

    return  running_date
  end

  def week_of_month_for_date(date)
    my_date = date
    week_of_target_date = my_date.strftime("%U").to_i
    week_of_beginning_of_month = my_date.beginning_of_month.strftime("%U").to_i
    week_of_target_date - week_of_beginning_of_month + 1
  end


  #user plan transaction report
  def provider_plan_report
    if !params[:search_plan].nil? && params[:search_plan]!=''
      @user_plan_r = ProviderTransaction.find_by_sql("select t.user_id,t.transaction_id,t.payment_date,u.business_name,t.email_address,t.user_plan,t.amount,t.action_type from provider_transactions t left join user_profiles u on t.user_id=u.user_id where t.email_address='#{params[:search_plan]}'  order by t.id desc")
      #display the deacivated user lists starting here
    elsif params[:actiontype] && !params[:actiontype].nil? && params[:actiontype].present? && params[:actiontype] == "Deactivated"
      @user_plan_r = ProviderTransaction.find_by_sql("select t.user_id,t.transaction_id,t.payment_date,u.business_name,t.email_address,t.user_plan,t.amount,t.action_type from provider_transactions t left join user_profiles u on t.user_id=u.user_id where t.action_type='deactivate' order by t.id desc")
      #display the not renewed user lists starting here
    elsif params[:actiontype] && !params[:actiontype].nil? && params[:actiontype].present? && params[:actiontype] == "Not Renewed"
      @prvers = ProviderTransaction.select('distinct user_id')
      # display the list of not renewed user details
      @user_plan_r = []
      !@prvers.nil? && @prvers.each do |providers|
        #display the not renewed user details
        begin
          @puser = ProviderTransaction.where("user_id = ?",providers.user_id).last if !providers.nil?
          if @puser && !@puser.nil? && !@puser.end_date.nil? && @puser.end_date!="" && @puser.end_date.present?
            @thirty_day = @puser && @puser.end_date
            #compare the current date end end date for the registered user
            if @thirty_day && @thirty_day.strftime("%Y-%m-%d") < "#{Time.now.strftime('%Y-%m-%d')}"
              @r_user = User.find(providers.user_id) if !providers.nil?
              if !@r_user.nil? && @r_user !="" && @r_user.present?
                @user_plan_r << @puser #push the transaction user details if the user present in user table
              end
            end
          end
        rescue Exception => exc
          puts "#{exc.message}"
        end #begin ending here
      end #do ending here
      #~ @user_plan_r = ProviderTransaction.find_by_sql("select t.user_id,t.transaction_id,t.end_date,t.payment_date,u.business_name,t.email_address,t.user_plan,t.amount,t.action_type from provider_transactions t left join user_profiles u on t.user_id=u.user_id where date(t.end_date)<'#{Time.now.strftime('%Y-%m-%d')}' order by t.id desc")
      #display the deacivated user lists ending here
    elsif params[:actiontype] && !params[:actiontype].nil? && params[:actiontype].present? && params[:actiontype] == "Deleted"
      @user_plan_r = ProviderTransaction.find_by_sql("select t.user_id,t.transaction_id,t.payment_date,u.business_name,t.email_address,t.user_plan,t.amount,t.action_type from provider_transactions t left join user_deleted_accounts u on t.email_address=u.email_address where t.email_address in(select distinct email_address from user_deleted_accounts) order by t.id desc")
      #by default display this list
    else
      @user_plan_r = ProviderTransaction.find_by_sql("select t.user_id,t.transaction_id,t.payment_date,u.business_name,t.email_address,t.user_plan,t.amount,t.action_type from provider_transactions t left join user_profiles u on t.user_id=u.user_id order by t.id desc")
    end
    if !@user_plan_r.nil? && @user_plan_r.present?
      @user_plan = @user_plan_r.paginate(:page => params[:page], :per_page =>10)
    end
    @user_email = ProviderTransaction.all.uniq.map(&:email_address)
    #@user_email = ProviderTransaction.find_by_sql("select p.email_address,u.business_name from provider_transactions p left join user_profiles u on p.user_id = u.user_id")
    respond_to do |format|
      format.html
      format.js
      format.csv #{ send_data csv_string }
      format.xls #{ send_data @transactions.to_csv(col_sep: "\t") }
		
    end
  end

  def providercard_listview
    #auto completed search options
    if !params[:search_plan].nil? && params[:search_plan]!=''
      @curator_provider = User.find_by_sql("select up.business_name,u.email_address,up.website,up.address_1,up.address_2,up.city,up.zip_code,up.phone,up.mobile,u.user_plan,u.user_created_date,up.added_by from users u left join user_profiles up on u.user_id = up.user_id where lower(user_plan)='curator' and lower(u.email_address) = '#{params[:search_plan].downcase}' order by u.user_id desc")
      #display the result for city based filter
    elsif params[:curator_city] && !params[:curator_city].nil? && params[:curator_city]!=''
      @curator_provider = User.find_by_sql("select up.business_name,u.email_address,up.website,up.address_1,up.address_2,up.city,up.zip_code,up.phone,up.mobile,u.user_plan,u.user_created_date,up.added_by from users u left join user_profiles up on u.user_id = up.user_id where lower(user_plan)='curator' and lower(up.city) = '#{params[:curator_city].downcase}' order by u.user_id desc")
      #display all the list view details
    elsif params[:added_by] && !params[:added_by].nil? && params[:added_by]!=''
      @curator_provider = User.find_by_sql("select up.business_name,u.email_address,up.website,up.address_1,up.address_2,up.city,up.zip_code,up.phone,up.mobile,u.user_plan,u.user_created_date,up.added_by from users u left join user_profiles up on u.user_id = up.user_id where lower(user_plan)='curator' and lower(up.added_by) = '#{params[:added_by].downcase}' order by u.user_id desc")
    else
      @curator_provider = User.find_by_sql("select up.business_name,u.email_address,up.website,up.address_1,up.address_2,up.city,up.zip_code,up.phone,up.mobile,u.user_plan,u.user_created_date,up.added_by from users u left join user_profiles up on u.user_id = up.user_id where lower(user_plan)='curator' order by u.user_id desc")
    end
	
    if !@curator_provider.nil? && @curator_provider.present?
      @curator_provider_usr = @curator_provider.paginate(:page => params[:page], :per_page =>10)
    end
    @user_email_val = User.where("lower(user_plan) = 'curator'").map(&:email_address)
    #response
    respond_to do |format|
      format.html
      format.js
      format.xls
    end
  end

end
