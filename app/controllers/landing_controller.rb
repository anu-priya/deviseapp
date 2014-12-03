class LandingController < ApplicationController
  before_filter :authenticate_user, :only=>[:invite_provider]
  before_filter :change_url, :only=>[:v2_landing_new]
  require 'fastimage'#this gem for fetching the images.
  require 'will_paginate/array'
  require 'geo_ip'
  require 'geocoder'
  #  before_filter :geo_ip_location
  include LandingHelper
  # Rendering Landing Page
  def index
    @cities = ["Chicago","Dallas","Detroit","Houston","Las Vegas","Los Angeles","New York","Philadelphia","San Antonio","San Francisco","San Jose","Seattle","Walnut Creek"]
    if cookies[:city_new_usr]
      @city_new_usr = cookies[:city_new_usr]
      respond_to do |format|
        format.html { render "action" => "index" }
      end
    else
      @default_city = "San Francisco"
      respond_to do |format|
        format.html { render "action" => "index" }
      end
    end
  end
  def newsletter

  end

  #calling register method for phone friendly
  def register
	  #new register method added for non-members
	  #~ redirect_to "/?parent_reg=#{params[:parent_reg]}&sent_user=#{params[:sent_user]}&sent_user_email=#{params[:sent_user_email]}&attend_track=#{params[:attend_track]}"
	  render :action=>:landing_new#?parent_reg=#{params[:parent_reg]}&sent_user=#{params[:sent_user]}&sent_user_email=#{params[:sent_user_email]}&attend_track=#{params[:attend_track]}"
  end
  
def home_redirect_activity
	if params[:mview] && params[:mview]!=''
		activity=Activity.find_by_activity_id(params[:mview])
		if !activity.nil?
		city = (activity.city!='') ? activity.city : 'anywhere'
		act_city = city.gsub(' ','-').downcase
		user = UserProfile.find_by_user_id(activity.user_id)
		bus_name = user.slug
		
		@category_slug = ""
		@sub_categ_slug = ""
		@categ= ActivityCategory.find_by_category_name(activity.category)
		@sub_categ= ActivitySubcategory.find_by_subcateg_name(activity.sub_category)
		@category_slug = @categ.slug if !@categ.nil? && @sub_categ.present?
		@sub_categ_slug = @sub_categ.slug if !@sub_categ.nil? && @sub_categ.present?	
		redirect_to "/#{act_city}-ca/#{bus_name}/#{@category_slug}/#{@sub_categ_slug}/#{activity.slug}"
		else
		redirect_to "/"
		end
	else
	redirect_to "/"
	end
end  
  # Confirming User City
  def submit
    city_new_usr = params[:city_new_usr_val]
    action_new_usr = params[:action_new_usr]
    cookies[:city_new_usr] = city_new_usr
    cookies[:date_new_usr] = Time.now.strftime("%Y-%m-%d") if cookies[:date_new_usr].nil?
    cookies[:sub_category_new_usr] = ""
    cookies[:login_usr] = "off"
    if action_new_usr == "login"
      cookies[:city_registered_usr] = cookies[:city_new_usr]
      redirect_to :controller => "login", :action => "index"
    elsif action_new_usr == "parent"
      cookies[:city_registered_usr] = cookies[:city_new_usr]
      redirect_to :controller => "user_usrs", :action => "user_register"
    elsif action_new_usr == "provider"
      cookies[:city_registered_usr] = cookies[:city_new_usr]
      redirect_to :controller => "user_usrs", :action => "provider_register"
    end
  end
  
  def how_it_works
	@meta_alt = true #dont remove, this for sitemap usage
    @get_current_url = request.env['HTTP_HOST']
  end
  

  def become_provider
    @s_user_id=params[:s_user_id]
    @s_user_email=params[:s_user_email]
  end

  def support
    
  end
  
  def invite_provider
	  @aclick=params[:aclick]
  end
  
  def about_us
	@meta_alt = true #dont remove, this for sitemap usage
    if current_user.nil?
      session.clear
    end
    @get_current_url = request.env['HTTP_HOST']
  end

  def contact_us
	@meta_alt = true #dont remove, this for sitemap usage
    if current_user.nil?
      session.clear
    end
    @get_current_url = request.env['HTTP_HOST']
  end
  
  def faq
	@meta_alt = true #dont remove, this for sitemap usage
    if current_user.nil?
      session.clear
    end
    @get_current_url = request.env['HTTP_HOST']
  end


  #send a mail while invite the provider by the user.
  #~ def invite_provider_submit
  #~ @provider_name = params[:p_business_name] if params[:p_business_name]!=""
  #~ params[:p_email] if params[:p_email]!=""
  #~ @parent_name = params[:name] if params[:name]!=""
  #~ @get_current_url = request.env['HTTP_HOST']

  #~ #sending a mail to the provider
  #~ if params[:p_email]
  #~ @result = UserMailer.delay(queue: "Provider Invite", priority: 2, run_at: 10.seconds.from_now).invite_provider_mail(params[:p_email],@get_current_url,params[:subject],@parent_name,@provider_name)
  #~ #@result = UserMailer.invite_provider_mail(params[:p_email],@get_current_url,params[:subject],@parent_name,@provider_name).deliver
  #~ end
  #~ end
  
  #send a mail while invite the provider by the user.
  def invite_provider_submit
    @provider_name = params[:p_business_name] if params[:p_business_name]!=" "
    params[:p_email] if params[:p_email]!=" "
    @parent_name = params[:name] if params[:name]!=" "
    @get_current_url = request.env['HTTP_HOST']
    #sending a mail to the provider
    if params[:p_email]
      @user = User.find_by_email_address(params[:p_email])
      @invitor_user = InvitorList.where("invited_email=?",params[:p_email]).first
      
      if (!@user && !@invitor_user)
        InvitorList.invitor_list(params[:p_email],current_user.user_id,'provider')
      elsif(!@user && @invitor_user)
        @invitor_user.update_attributes(modified_date: Time.now)
      end
      
      
      @type_parent = false
      if !@user.nil? && @user!='' && @user.present? && @user.user_flag==TRUE
				if @user["user_type"].downcase == "u" 
					@type_parent = true
					@result = UserMailer.delay(queue: "Provider Invite", priority: 2, run_at: 10.seconds.from_now).invite_provider_mail(params[:p_email],@get_current_url,params[:subject],params[:name],params[:p_business_name],@type_parent,current_user)
					@msg_flag = "Your invitation has been sent successfully!"
				else
					@msg_flag = "This Provider Already Registered!"
				end
      else
				@result = UserMailer.delay(queue: "Provider Invite", priority: 2, run_at: 10.seconds.from_now).invite_provider_mail(params[:p_email],@get_current_url,params[:subject],params[:name],params[:p_business_name],@type_parent,current_user)
        @msg_flag = "Your invitation has been sent successfully!"
      end
      #@result = UserMailer.invite_provider_mail(params[:p_email],@get_current_url,params[:subject],@parent_name,@provider_name).deliver
    end
  end
  

  def privacy_policy
	@meta_alt = true #dont remove, this for sitemap usage
    if current_user.nil?
      session.clear
    end
	  @get_current_url = request.env['HTTP_HOST']
  end

  def terms_of_service
	@meta_alt = true #dont remove, this for sitemap usage
    if current_user.nil?
      session.clear
    end
    @get_current_url = request.env['HTTP_HOST']
  end
  
  
  def parent_terms_of_service
  
  end
  
  def provider_terms_of_service
  
  end

  def parent_privacy_policy
  
  end

  def provider_privacy_policy
  
  end
  
  def service_discover_more
  
  end
  
  def service_purchase_more
  
  end



  def contact_us_mail
    @phone_value = "#{params[:phone1]}-" +"#{params[:phone2]}-"+"#{params[:phone3]}"

    if params[:email] && params[:name] && params[:usertype] && @phone_value && params[:msg] && params[:usertype]
      @get_current_url = request.env['HTTP_HOST']
      @result = UserMailer.delay(queue: "Contact", priority: 1, run_at: 5.seconds.from_now).contact_us(params[:email],params[:name],@get_current_url,@phone_value,params[:msg],params[:usertype])
      #@result = UserMailer.contact_us(params[:email],params[:name],@get_current_url,params[:phone],params[:msg]).deliver
      respond_to do |format|
        format.js{render :text => "$('.success_update_info').css('display', 'block').fadeOut(4000);"} 
      end
    end
  end

  def landing_new_old
    session[:city] = cookies[:city_new_usr]
    session[:city] = "Walnut Creek" if session[:city].nil?

    session[:cat_zc]="date"
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    #~ @activity_featured = Activity.find_by_sql("select * from activities INNER JOIN activity_schedules ON activity_schedules.activity_id = activities.activity_id where activities.activity_id in (select activity_id from activity_bids where lower(bid_status) = 'active' and cleaned = true order by bid_amount asc) and lower(active_status)='active' or (featured_flag = true and lower(active_status)='active' and cleaned = true) order by featured_flag asc limit 60").uniq
    @activity_featured = []
    @cdate = (DateTime.now).strftime("%Y-%m-%d")
    @sdate=Time.now.beginning_of_month.strftime("%Y-%m-%d")
    @edate=Time.now.end_of_month.strftime("%Y-%m-%d")
   
    #~ @budget = MonthlyBudget.order("bid_amount desc").joins("left join users on monthly_budgets.user_id=users.user_id").where("monthly_budgets.bid_start_date='#{@sdate}' and monthly_budgets.bid_end_date='#{@edate}' and (lower(users.user_plan)='sponsor' or lower(users.user_plan)='sell')")
    #~ @str = ''
    #~ @budget.each do |buser|
    #~ if buser["monthly_budget"].to_i > buser["attempt_amount"].to_i
    #~ if @str!='' && !@str.nil?
    #~ @str.concat(",#{buser["user_id"]}")
    #~ else
    #~ @str.concat("#{buser["user_id"]}")
    #~ end
    #~ end
    #~ end if !@budget.nil? && @budget!='' && @budget.present?    
    #~ @activity = Activity.where("user_id in (#{@str})").where("cleaned=? and lower(active_status)=? and lower(created_by)=?",true,'active','provider').limit(100) if !@str.nil? && @str!=''
   
    #~ @admin_curr = []
    #~ @admin_curr = Activity.order("activities.activity_id desc").select("activities.*,activity_schedules.*").joins(:activity_schedule).where("lower(active_status)='active' And (start_date <= '#{@cdate}' and featured_flag=true and lower(created_by)='provider' and cleaned=true) or (lower(activities.schedule_mode)='any time' And lower(active_status)='active' and featured_flag=true and cleaned = true and lower(created_by)='provider') or (lower(activities.schedule_mode)='by appointment' And lower(active_status)='active' and featured_flag=true and cleaned = true and lower(created_by)='provider')").uniq
    #~ @admin_feature = []
    #~ @admin_feature = Activity.order("activities.activity_id desc").select("activities.*,activity_schedules.*").joins(:activity_schedule).where("lower(active_status)='active' And start_date > '#{@cdate}' and featured_flag=true and cleaned = true and lower(created_by)='provider'").uniq
    @str = ''
    @budget = MonthlyBudget.order("bid_amount desc").where("bid_start_date='#{@sdate}' and bid_end_date='#{@edate}'")   #.uniq.collect(&:user_id)
   
    if !@budget.nil? && @budget!='' && @budget.present?
      @budget.each do |buser|
        if buser["monthly_budget"].to_i > buser["attempt_amount"].to_i
          if !current_user.nil? && current_user.present?
            if @str!='' && !@str.nil?
              @str.concat(",#{buser["user_id"]}") if !buser.user_id.nil?
            else
              @str.concat("#{buser["user_id"]}") if !buser.user_id.nil?
            end
          end
        end
      end  if !@budget.nil? && @budget.present?
    end
    if !@str.nil? && @str!=''
      @activity = Activity.where("user_id in (#{@str})").where("cleaned=? and lower(active_status)=? and lower(created_by)=?",true,'active','provider').uniq   #.collect(&:activity_id)
      #@click_activity = ActivityClick.where(:activity_id=>@activity).select("sum(click_amount) as click_amount, activity_id").where("click_amount > 0 and click_date between '#{@sdate}' and '#{@edate}'").group("activity_id").order("click_amount desc")
    end
    @admin_activity = Activity.order("activities.activity_id desc").where("lower(active_status)='active' and cleaned=true and  featured_flag=true and lower(created_by)='provider'").limit(60).uniq
    arr = []
    #~ Activity.schedule_feature_list(session[:date],event,arr) if !event.nil?
    act_free = Activity.get_activities_repeat(session[:city],session[:zip_code],session[:date],3)
    act_free.each do |event|
      @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
      #~ schedule_repeat_append(event,events,"created") if !@schedule.nil?
      #current and future date activities
      Activity.schedule_feature_list(session[:date],event,arr) if !event.nil?
    end
    @activity_free = []
    @activity_free = arr.uniq{|x| x[:id]}
    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT lower(trim(category))as category")
    
    @activity_share_provider = []
    @activity_saved_favorites = []
    @activity_created_activities = []
    @provider_activites = []
    @follow_parent_user = []
    @follow_provider_user = []
    @category = []
    @sub_category = []
    @checck  = []
    @jump_to_act =[]
    if !current_user.nil?
      act_provider =  Activity.get_shared_activities(cookies[:uid_usr],current_user.email_address)
      @activity_share_provider = act_provider.paginate(:page => params[:page], :per_page =>20)
      act_saved_fav = Activity.get_saved_favorites(session[:city],session[:zip_code],session[:date],cookies[:uid_usr])
      @activity_saved_favorites = act_saved_fav.paginate(:page => params[:page], :per_page =>20)
      act_created_fav = Activity.get_saved_created_activities(session[:city],session[:zip_code],session[:date],cookies[:uid_usr])
      @activity_created_activities = act_created_fav.paginate(:page => params[:page], :per_page =>20)
      user_id = current_user.user_id
      @provider_activites_selected = []
      @provider_activites_combined = []
      @provider_activites_selected =  ActivityRow.select("Distinct(activities.category)").order("activities.category Asc").joins("left join activities on lower(activities.sub_category)=lower(activity_rows.row_type)").where("activity_rows.user_id = ?",cookies[:uid_usr]).group("activities.category").map(&:category)
      #user selected activities 
      if @provider_activites_selected
        @provider_activites_combined<<@provider_activites_selected
      end
      #users default category sports,dance,music
      #~ @default = ActivitySubcategory.where(:category_id=>[8,4,12] ).map(&:subcateg_id)
      #~ @category_default =  ActivitySubcategory.where(:subcateg_id=>@default).map(&:category_id)
      #~ @provider_activites_default = []
      #~ @provider_activites_default = ActivityCategory.where(:category_id=>@category_default).map(&:category_name)
      #push to the array
      #~ if @provider_activites_default
      #~ @provider_activites_combined << @provider_activites_default
      #~ end
      #make all the category to single array
      @provider_activites_get = @provider_activites_combined.flatten
      @provider_activites = @provider_activites_get.uniq{|x| x}
      #provider activities based on the user selection row with default row added
      if (!@provider_activites.nil? && @provider_activites.present?)
        cat1="Dance"
        cat2="Music"
        cat3="Sports"
        c1=false
        c2=false
        c3=false
        if @provider_activites.include?cat1
          c1=true
        end
        if @provider_activites.include?cat2
          c2=true
        end
        if @provider_activites.include?cat3
          c3=true
        end
        if c1==false
          @provider_activites << "Dance"
        end
        if c2==false
          @provider_activites << "Music"
        end
        if c3==false
          @provider_activites << "Sports"
        end
        @provider_activites
      elsif @provider_activites.empty? || @provider_activites.blank?
        @default=""
        @default = ActivitySubcategory.where(:category_id=>[8,4,12] ).map(&:subcateg_id)
        @category_default =  ActivitySubcategory.where(:subcateg_id=>@default).map(&:category_id)
        @provider_activites = ActivityCategory.where(:category_id=>@category_default).map(&:category_name)
      end
      @follow_parent_user = UserRow.where("user_id=#{user_id} and user_type='U'").map(&:row_user_id)
      @follow_provider_user = UserRow.where("user_id=#{user_id} and user_type='P'").map(&:row_user_id)
      @category =  ActivityRow.where(:user_id=>user_id).map(&:subcateg_id)
      @sub_category = ActivitySubcategory.where(:subcateg_id=>@category ).map(&:subcateg_name)
      #@provider_activites = ActivityCategory.where(:category_id=>@category ).map(&:category_name)
      @checck = ActivityRow.find(:all,:conditions=>["user_id = ? ",user_id],:select => "row_type")
      session[:category_row] = ""
      @provider_activites_check =[]
      @checck.each { |s| @provider_activites_check<< s.row_type }
    else
      if session[:category_row]!=""
        session[:category_row] = ActivitySubcategory.where(:category_id=>[8,4,12] ).map(&:subcateg_id)
      else
        session[:category_row] = ActivitySubcategory.where(:category_id=>[8,4,12] ).map(&:subcateg_id)
      end
      @category =  ActivitySubcategory.where(:subcateg_id=>session[:category_row] ).map(&:category_id)
      @sub_category = ActivitySubcategory.where(:subcateg_id=>session[:category_row] ).map(&:subcateg_name)
      @provider_activites = ActivityCategory.where(:category_id=>@category ).map(&:category_name)
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
            dec1 = CGI::unescapeHTML(dec)
            title1 = CGI::unescapeHTML(title)
            @blog_value << {"title" => title1, "description"=>dec1,"img"=>img_srcs,"link"=>link}
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

  def update_ses_date
    @loc_flag = true
    session[:date] = params[:date] if !params[:date].nil?
    #~ cookies[:city_new_usr] = params[:state] if !params[:state].nil?
    cookies[:selected_city] = params[:state] if !params[:state].nil?
    session[:city]=cookies[:selected_city] 
    session[:zip_code] = params[:zip_code] if !params[:zip_code].nil?
    if !params[:page_a].nil? && params[:page_a]!='landing_new' && params[:page_a]!='v2_landing_new'
      @loc_flag = false
    end
    respond_to do |format|
      format.js
    end
  end
  

  def update_parent_provider
    if params[:user_type] == "p"
      @provider_user =  User.search_provider(params[:user]) if !params[:user].nil? && params[:user]!=""
      @user_row = UserRow.where("user_id=#{current_user.user_id} and user_type='P'").map(&:row_user_id) if !current_user.nil?
      render :partial=>"activity_subcategories/accordion_provider_user"
    else
      @parent_user =  User.search_parent(params[:user]) if !params[:user].nil? && params[:user]!=""
      @parent_follow_search = 'followsearch'
      render :partial=>"activity_subcategories/accordion_parent_user"
    end
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
        if (@repeat.repeats == "Weekly") || (@repeat.repeats == "Every week (Monday to Friday)") || (@repeat.repeats == "Every Tuesday and Thursday") || (@repeat.repeats == "Every Monday,Wednesday and Friday")
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
      else
        start_date = "#{@schedule.start_date} #{@schedule.start_time.strftime('%H:%M:00')}" if !@schedule.start_date.nil? && !@schedule.start_time.nil?
        end_date = "#{@schedule.start_date} #{@schedule.end_time.strftime('%H:%M:00')}" if !@schedule.start_date.nil? && !@schedule.end_time.nil?
        events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id,:start => "#{start_date}", :end => "#{end_date}"}
      end
    elsif @schedule.schedule_mode == "Camps/Workshop"
      start_date = "#{@schedule.start_date} #{@schedule.start_time.strftime('%H:%M:00')}" if !@schedule.start_date.nil? && !@schedule.start_time.nil?
      end_date = "#{@schedule.end_date} #{@schedule.end_time.strftime('%H:%M:00')}" if !@schedule.start_date.nil? && !@schedule.end_time.nil?

      if @schedule.start_date==@schedule.end_date
        events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id,:start => "#{start_date}", :end => "#{end_date}"}
      else
        events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id,:start => "#{start_date}", :end => "#{end_date}"}
      end
    elsif @schedule.schedule_mode == "Any Time"
      any_time = ActivitySchedule.where("activity_id = ?",event.activity_id)

      any_time.each do|s|
        if s.business_hours =="mon"
          r = Recurrence.new(:every => :week, :on => :monday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date|
            events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id

            } }
        elsif s.business_hours =="tue"
          r = Recurrence.new(:every => :week, :on => :tuesday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date|       events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          }
        elsif s.business_hours =="wed"
          r = Recurrence.new(:every => :week, :on => :wednesday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date|       events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          }
        elsif s.business_hours =="thu"
          r = Recurrence.new(:every => :week, :on =>:thursday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date|
            events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}

          }
        elsif s.business_hours =="fri"
          r = Recurrence.new(:every => :week, :on =>:friday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}  }
        elsif s.business_hours =="sat"
          r = Recurrence.new(:every => :week, :on => :saturday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date|  events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}   }
        elsif s.business_hours =="sun"
          r = Recurrence.new(:every => :week, :on => :sunday,:starts =>Time.at(params['start'].to_i).strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}   }
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

            events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
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
          events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
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
            events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
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
          events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
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
          events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
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
          events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
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
          events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
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
            events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
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
          events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
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
            events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
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
          events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
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
        events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
      end if running_date <= occ if js_start_date <= running_date
      running_date = running_date + 1.days
    end
  end

  # TODO Comment
  def repeat_schedule_occurance(event, events, js_end_date, js_start_date, occ, running_date,type,info)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date <= occ
          events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
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
          events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
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
        events << {:id => event.activity_id, :price_type => event.price_type, :city =>event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
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
  
  #call newsletter API to COTC 
  def newsletter_subscripe	 
    #url = URI.parse("http://showontherun.com/application/JsonApi/subScribeNewsLetter?email=#{params[:email]}&location=#{URI::encode(params[:banner_location])}")
    url=URI.parse("http://campaignonthecloud.com/Update_Registration_Status.aspx?name=&mobile=&email_id=#{params[:email]}&country=&address=&city=#{URI::encode(params[:banner_location])}&zipcode=&domain_name=famtivitydev&planname=&groupname=Weekend%20Newsletter&subscription=1")
    req = Net::HTTP.new(url.host, url.port)
    begin
      res = req.request_head(url.path)      
      if res.code != "404"
        request = Net::HTTP::Get.new(url.request_uri)	
        response = req.request(request)	
        #@news_response=JSON.parse(response.body)
        @news_response=response.body.html_safe
        #render :text => @news_response["results"]
        render :text => @news_response
      end
    rescue Exception => exc
      render :text => "Problem on API"
    end
  end

 
  def landing_new
	@meta_alt = true #dont remove, this for sitemap usage
    @blog_value = []
    @fam_city = City.order(:city_name)
    if params[:city_v] && params[:city_v]!=''
      @footcity = City.where("lower(city_name) like '#{params[:city_v].downcase}%'").map(&:city_name).sort
    end
  end
   
  def landing_feature
    landing_feature_activity
    render :partial => 'featured_row'
  end
     
  #before login home and logo click goto search page
  def search_activities
    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT trim(category) as category",:conditions=>["lower(category)!=?",'default'])
  end
   
  #get the bloag article from rss feed
  def blog_content
    @blog_value  = []
    url = URI.parse("https://www.famtivity.com/blog?feed=rss2")
    #req = Net::HTTP.new(url.host, url.port)
  
     # res = req.request_head(url.path)
      #if res.code != "404" && res.code !="500"
        doc = Nokogiri::XML(open(url))
        begin
	if !doc.nil? && doc!='' && doc.present?
          (doc/'item')[0..2].each do|node|
            title = (node/'title').inner_html
            desc = (node/'description').inner_html
            link = (node/'link').inner_html
            img_srcs = desc[/img.*?src="(.*?)"/i,1]
            decs = desc.gsub(/<\/?[^>]*>/,"")
            dec = decs.gsub("Read More","")
            title = title.gsub(/<\/?[^>]*>/,"")
            dec = dec.sub("Continue reading &#8594;","")
            dec1 = CGI::unescapeHTML(dec)
            title1 = CGI::unescapeHTML(title)
            @blog_value << {"title" => title1.html_safe, "description"=>dec1.html_safe,"img"=>img_srcs,"link"=>link}
          end
	end
	 rescue Exception => exc
      logger.error("Message for the log file #{exc.message}")
      flash[:notice] = "Store error message"
    end
      #end
   
    respond_to do |format|
      format.js
      format.html
    end
  end

  def search_landing_new	  
    @blog_value = []
  end
  
  def v2_landing_new
    cookies.delete :feature_page #to avoid duplicate - delete cookies for first time page load
    @sent_user = Base64.decode64(params[:sent_user]) if params[:sent_user] && !params[:sent_user].nil? && params[:sent_user]!=""
    y = rand(1..3)
    if (y==1)
      params[:mode]='parent'  #dont remove this
      if !session['ip_location'].nil?
        ip_location = session['ip_location']
      else
        ip_location = {'latitude'=>'37.9100783','longitude'=>'-122.0651819', 'city' => 'Walnut Creek'}
      end
      if (cookies[:selected_city].nil?)
        if(ip_location.present? && ip_location && !ip_location.nil? && !ip_location['city'].nil? && ip_location['city'].present? && ip_location['city']!="" )
          cookies[:city_new_usr] = ip_location['city'].titlecase  if(ip_location.present? && ip_location && !ip_location.nil? && !ip_location['city'].nil?)
        else #default values
          cookies[:city_new_usr] = 'Walnut Creek'
        end
        @city_value = request.url.split('/').last
        if (request.url.include? "=")
          if (@city_value.include? "?")
            cookies[:city_new_usr] = 'Walnut Creek'
          else
            cookies[:city_new_usr] = @city_value.titleize
          end
        else
          cookies[:city_new_usr] = 'Walnut Creek'
        end
      else #city selected values
        cookies[:city_new_usr] = cookies[:selected_city]
      end
    
      session[:city] = cookies[:city_new_usr]
      session[:city] = "Walnut Creek" if session[:city].nil?
      session[:cat_zc]="date"
      session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
      #    @blog_value = []
      #    url = URI.parse("http://blog.famtivity.com/?feed=rss2")
      #    req = Net::HTTP.new(url.host, url.port)
      #    begin
      #      res = req.request_head(url.path)
      #      if res.code != "404" && res.code !="500"
      #        doc = Nokogiri::XML(open(url))
      #        if !doc.nil? && doc!='' && doc.present?
      #          (doc/'item').each do|node|
      #            title = (node/'title').inner_html
      #            desc = (node/'description').inner_html
      #            link = (node/'link').inner_html
      #            img_srcs = desc[/img.*?src="(.*?)"/i,1]
      #            dec = desc.gsub(/<\/?[^>]*>/,"")
      #            title = title.gsub(/<\/?[^>]*>/,"")
      #            dec = dec.sub("Continue reading &#8594;","")
      #            dec1 = CGI::unescapeHTML(dec)
      #            title1 = CGI::unescapeHTML(title)
      #            @blog_value << {"title" => title1, "description"=>dec1,"img"=>img_srcs,"link"=>link}
      #          end
      #        end
      #      end
      #    rescue Exception => exc
      #      logger.error("Message for the log file #{exc.message}")
      #      flash[:notice] = "Store error message"
      #    end
      @provider_activites = []
      @follow_parent_user = []
      @follow_provider_user = []
      @category = []
      @sub_category = []
      @checck  = []
      @jump_to_act =[]
      if !current_user.nil?
        user_id = current_user.user_id
        @provider_activites_selected = []
        @provider_activites_combined = []
        @provider_activites_selected =  ActivityRow.select("Distinct(activities.category)").order("activities.category Asc").joins("left join activities on lower(activities.sub_category)=lower(activity_rows.row_type)").where("activity_rows.user_id = ?",cookies[:uid_usr]).group("activities.category").map(&:category)
        #user selected activities
        @provider_activites_combined<<@provider_activites_selected if @provider_activites_selected
        #make all the category to single array
        @provider_activites_get = @provider_activites_combined.flatten
        @provider_activites = @provider_activites_get.uniq{|x| x}
        #provider activities based on the user selection row with default row added
        #if (!@provider_activites.nil? && @provider_activites.present?)
        #cat1="Dance"
        #cat2="Music"
        #cat3="Sports"
        #c1=false
        #c2=false
        #c3=false
        #c1=true if @provider_activites.include?cat1
        #c2=true if @provider_activites.include?cat2
        #c3=true if @provider_activites.include?cat3
        #@provider_activites << "Dance" if c1==false
        #@provider_activites << "Music" if c2==false
        #@provider_activites << "Sports" if c3==false
        #@provider_activites
        #elsif @provider_activites.empty? || @provider_activites.blank?
        #@default=""
        #@default = ActivitySubcategory.where(:category_id=>[8,4,12] ).map(&:subcateg_id)
        #@category_default =  ActivitySubcategory.where(:subcateg_id=>@default).map(&:category_id)
        #@provider_activites = ActivityCategory.where(:category_id=>@category_default).map(&:category_name)
        #end
        @follow_parent_user = UserRow.where("user_id=#{user_id} and user_type='U'").map(&:row_user_id)
        @follow_provider_user = UserRow.where("user_id=#{user_id} and user_type='P'").map(&:row_user_id)
        @category =  ActivityRow.where(:user_id=>user_id).map(&:subcateg_id)
        @sub_category = ActivitySubcategory.where(:subcateg_id=>@category ).map(&:subcateg_name)
        @checck = ActivityRow.find(:all,:conditions=>["user_id = ? ",user_id],:select => "row_type")
        session[:category_row] = ""
        cookies[:subct_id] = ""
        session[:before_cat] = ""
        session[:before_prov] = ""
        session[:provider_row] = ""
        @provider_activites_check =[]
        @checck.each { |s| @provider_activites_check<< s.row_type }
      else
        #~ if session[:category_row]!=""
        #~ session[:category_row] = ActivitySubcategory.where(:category_id=>[8,4,12] ).map(&:subcateg_id)
        #~ else
        #~ session[:category_row] = ActivitySubcategory.where(:category_id=>[8,4,12] ).map(&:subcateg_id)
        #~ end
        #~ @category =  ActivitySubcategory.where(:subcateg_id=>session[:category_row] ).map(&:category_id)
        #~ @sub_category = ActivitySubcategory.where(:subcateg_id=>session[:category_row] ).map(&:subcateg_name)
        #~ @provider_activites = ActivityCategory.where(:category_id=>@category ).map(&:category_name)
      
        #before login display the category row start
        if session[:category_row]!=""
          @cv=session[:category_row].split(",") if session[:category_row]
          @category =  ActivitySubcategory.where(:subcateg_id=>@cv).map(&:category_id) if !@cv.nil?
          cookies[:subct_id]= @cv if !@cv.nil? && @cv.present?
          @sub_category = ActivitySubcategory.where(:subcateg_id=>@cv).map(&:subcateg_name) if !@cv.nil?
          @cat_val= ActivityCategory.where(:category_id=>@category ).map(&:category_name) if !@category.nil?
          session[:before_cat] = @cat_val if !@cat_val.nil? && @cat_val.present?
          @provider_activites =  session[:before_cat]
        else
          session[:category_row] = params[:cat_add_row]
        end
        #before login display the category row end
        #display provider follow row
        if session[:provider_row]!=""
          #~ session[:provider_row] = params[:provider_add_row]
          @pv=session[:provider_row].split(",") if session[:provider_row]
          session[:before_prov] = @pv if !@pv.nil? && @pv.present?
          @follow_provider_user = session[:before_prov]
        else
          session[:provider_row] = params[:provider_add_row]
        end
	
      end #current user end
      cookies[:feature_page] = 1
      arr = []
      #~ get_total_feature_list(arr)
      get_total_feature_list(arr,ip_location['latitude'],ip_location['longitude']) if !ip_location.nil? && ip_location!='' && ip_location.present? && !ip_location['latitude'].nil? && !ip_location['longitude'].nil? && ip_location['latitude']!='' && ip_location['longitude']!=''
      featured = arr.uniq{|x| x[:id]}
      if featured.length !=0 && featured.length <8
        cookies[:feature_page] = 1 + cookies[:feature_page].to_i
        #~ get_total_feature_list(arr)
        get_total_feature_list(arr,ip_location['latitude'],ip_location['longitude']) if !ip_location.nil? && ip_location!='' && ip_location.present? && !ip_location['latitude'].nil? && !ip_location['longitude'].nil? && ip_location['latitude']!='' && ip_location['longitude']!=''
      end
    
      # Provider fetch with scrolling start #
      cookies[:provider_page] = 1
      prov_arr = []
      get_total_provider_list(prov_arr)
      prov_list = prov_arr.uniq{|x| x[:id]}
      if prov_list.length != 0 && prov_list.length < 5
        cookies[:provider_page] = 1 + cookies[:provider_page].to_i
        get_total_provider_list(prov_arr)
      end
      @prov_list = prov_arr.uniq{|x| x[:id]}
      # end #
      @activity_featured = arr.uniq{|x| x[:id]}
      @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT trim(category) as category",:conditions=>["lower(category)!=?",'default'])
      @blog_value = []
      url = URI.parse("http://blog.famtivity.com/?feed=rss2")
      req = Net::HTTP.new(url.host, url.port)
      begin
        res = req.request_head(url.path)
        if res.code != "404" && res.code !="500"
          doc = Nokogiri::XML(open(url))
          if !doc.nil? && doc!='' && doc.present?
            (doc/'item')[0..2].each do|node|
              title = (node/'title').inner_html
              desc = (node/'description').inner_html
              link = (node/'link').inner_html
              img_srcs = desc[/img.*?src="(.*?)"/i,1]
              decs = desc.gsub(/<\/?[^>]*>/,"")
              dec = decs.gsub("Read More","")
              title = title.gsub(/<\/?[^>]*>/,"")
              dec = dec.sub("Continue reading &#8594;","")
              dec1 = CGI::unescapeHTML(dec)
              title1 = CGI::unescapeHTML(title)
              @blog_value << {"title" => title1, "description"=>dec1,"img"=>img_srcs,"link"=>link}
            end
          end
        end
      rescue Exception => exc
        logger.error("Message for the log file #{exc.message}")
        flash[:notice] = "Store error message"
      end
    else
      if !params[:mview].nil? && params[:mview]!=''
        redirect_to "/home?mview=#{params[:mview]}"
      elsif !params[:sent_user_email].nil? && params[:sent_user_email]!='' && !params[:sent_user].nil? && params[:sent_user]!=""
        redirect_to "/home?sent_user_email=#{params[:sent_user_email]}&sent_user=#{params[:sent_user]}"
      elsif !params[:findus].nil? && params[:findus]!=''
        redirect_to "/home?findus=view"
      elsif !params[:newsletter].nil? && params[:newsletter]!=''
        redirect_to "/home?newsletter=view"
      else
        redirect_to "/home"
      end
    end
  end

  def get_parent_user
    @act_row_parent_page = []
    s = params[:cat]
    session[:city] = cookies[:city_new_usr]
    session[:city] = "Walnut Creek" if session[:city].nil?
    cookies[:"page_parent#{s}"] = 1 if !params[:page].nil?
    cookies[:"page_parent#{s}"] = 1 + cookies[:"page_parent#{s}"].to_i if params[:page].nil?
    @check =false
    @attend_check = false
    @fav_check = false
    @parent_setting_notify=ParentSettingDetail.find_by_sql("select * from parent_setting_details s left join parent_settings p on s.parent_setting_id=p.parent_setting_id  where  p.user_id=#{s}")
    if @parent_setting_notify.present? && !@parent_setting_notify.nil? && @parent_setting_notify!=""
      @parent_setting_notify.each do |parent_notify|
        if parent_notify.setting_action=="purchased" && parent_notify.setting_option=="1"
          @attend_check = true   
        elsif parent_notify.setting_action=="purchased" && parent_notify.setting_option=="2"
          if parent_notify.setting_action=="purchased" && parent_notify.setting_option=="2" && !parent_notify.contact_user.nil?
            @attend_famtivity_contact=parent_notify.contact_user.split(',')
            if @attend_famtivity_contact.include?("#{current_user.user_id}")
              @attend_check = true
            end
          end
        elsif parent_notify.setting_action=="purchased" && parent_notify.setting_option=="3"
          if parent_notify.setting_action=="purchased" && parent_notify.setting_option=="3"
            if current_user.user_id.to_i==parent_notify.user_id.to_i
              @attend_check = true   
            end
          end
        end

        if parent_notify.setting_action=="favorites" && parent_notify.setting_option=="1"
          @fav_check = true
        elsif parent_notify.setting_action=="favorites" && parent_notify.setting_option=="2"
          if parent_notify.setting_action=="favorites" && parent_notify.setting_option=="2" && !parent_notify.contact_user.nil?
            @favorite_famtivity_contact=parent_notify.contact_user.split(',')
            if @favorite_famtivity_contact.include?("#{current_user.user_id}")
              @fav_check = true
            end
          end
        elsif parent_notify.setting_action=="favorites" && parent_notify.setting_option=="3"
          if parent_notify.setting_action=="favorites" && parent_notify.setting_option=="3"
            if current_user.user_id.to_i==parent_notify.user_id.to_i
              @fav_check = true
            end
          end
        end

        if parent_notify.setting_action=="created" && parent_notify.setting_option=="1"
          @check =true
        elsif parent_notify.setting_action=="created" && parent_notify.setting_option=="3"
          if parent_notify.setting_action=="created" && parent_notify.setting_option=="3"
            if current_user.user_id.to_i==parent_notify.user_id.to_i
              @check =true
            end
          end
        elsif parent_notify.setting_action=="created" && parent_notify.setting_option=="2"
          if parent_notify.setting_action=="created" && parent_notify.setting_option=="2" && !parent_notify.contact_user.nil?
            @famtivity_contact_parent=parent_notify.contact_user.split(',')
            if @famtivity_contact_parent.include?("#{current_user.user_id}")
              @check =true
            end
          end
        end
      end
    else
      @check =true
    end
    if @check == true
      @parent_page = Activity.get_parent_activity_row_values_repeat(session[:city],session[:zip_code],session[:date],"",s)
      @act_row_parent_page = @parent_page.paginate(:page => cookies[:"page_parent#{s}"], :per_page =>20)
    end
    if @attend_check == true
      @attend = Activity.setting_attend_activity(s)
      @setting_attend = @attend.paginate(:page => cookies[:"page_parent#{s}"], :per_page =>20)
    end
    if @fav_check == true
      @fav_check = Activity.setting_favorite_activity(s)
      @setting_fav = @fav_check.paginate(:page => cookies[:"page_parent#{s}"], :per_page =>20)
    end
    
    if request.headers['X-PJAX']
      render :partial =>"parent_activity_follow_row", :layout => false
    else
      render :partial =>"parent_activity_follow_row"
    end
  end

  def get_provider_user
    @act_row_provider_page =[]
    s = params[:cat]
    session[:city] = cookies[:city_new_usr]
    session[:city] = "Walnut Creek" if session[:city].nil?
    #~ cookies[:"page_provider#{s}"] = 1 if !params[:page].nil?
    #~ cookies[:"page_provider#{s}"] = 1 + cookies[:"page_provider#{s}"].to_i if params[:page].nil?
    @check = false
    @provider_setting_notify=ProviderSettingDetail.find_by_sql("select * from provider_setting_details s left join provider_settings p on s.provider_setting_id=p.provider_setting_id  where  p.user_id=#{s}")
    if @provider_setting_notify.present? && !@provider_setting_notify.nil? && @provider_setting_notify!=""
      @provider_setting_notify.each do |provider_notify|
        if provider_notify.setting_action=="created" && provider_notify.setting_option=="1"
          @check = true
        elsif provider_notify.setting_action=="created" && provider_notify.setting_option=="3"
          if provider_notify.setting_action=="created" && provider_notify.setting_option=="3"
            if current_user 
              if (current_user.user_id.to_i==provider_notify.user_id.to_i)
                @check = true
              end
            end
          end
        elsif provider_notify.setting_action=="created" && provider_notify.setting_option=="2"
          if provider_notify.setting_action=="created" && provider_notify.setting_option=="2" && !provider_notify.contact_user.nil?
            @famtivity_contact=provider_notify.contact_user.split(',')
            if (current_user && @famtivity_contact.include?("#{current_user.user_id}"))
              @check = true
            end
          end
        end
      end
    else
      @check = true
    end
    if @check == true
      @provider_page = Activity.get_provider_activity_row_values_repeat(session[:city],session[:zip_code],session[:date],"",s)
      @all_act=[]
      @act_free=[]
      upcoming_provider=get_upcoming_activities(@provider_page)
      #~ @act_row_provider_page = @provider_page.paginate(:page => cookies[:"page_provider#{s}"], :per_page =>20)
      @act_row_provider_page = upcoming_provider.paginate(:page => params[:page], :per_page =>20)
      @act_row_total_pages = @act_row_provider_page.total_pages
    end
    
    if request.headers['X-PJAX']
      render :partial =>"provider_activity_follow_row", :layout => false
    else
      render :partial =>"provider_activity_follow_row"
    end
   
  end


  def featured_activity_2
    city = "walnut creek"
    #@user = User.includes(:user_profile,:activities).where("lower(user_profiles.city)=? and lower(user_plan)=? and show_card=? and account_active_status=?","#{city.downcase if !city.nil?}",'sell',true,true).order("user_plan desc")
    re_times = 5
    begin
      a_coord = Geocoder.coordinates("#{city.titlecase},ca")
      radius = 1500
      nearby_cities = City.near(a_coord, radius, :order => :distance).map(&:city_name)
    rescue Exception => e
      re_times-=1
      if re_times>0
        retry
      else
        nearby_cities = ["#{city.titlecase}"]
      end
    end
    nearby_cities =  City.format_gsub(nearby_cities)
    #@user = User.near(params[:search], 50, :order => :distance)
    @user = User.includes(:user_profile,:activities).where("lower(user_profiles.city) in #{nearby_cities.downcase} and lower(user_plan)=? and show_card=? and account_active_status=?",'sell',true,true).order("user_plan desc")
    #@activity_count = Activity.preload(:activity_schedule,:activity_total_count,:user).where("active_status = 'Active'")

    #@user = ActivityTotalCount.includes(:activities).where("activities.active_status = 'Active'").order("activity_display_count desc")

    render :partial =>"activity/activity_short_desc"
  end

def featured_activity
    if !session['ip_location'].nil?
      ip_location = session['ip_location']
      # ip_location = ActiveSupport::JSON.decode(ip_loc)
    else
      ip_location = {'latitude'=>'37.9100783','longitude'=>'-122.0651819', 'city' => 'Walnut Creek'}
    end

    session[:city] = cookies[:search_city]
    #session[:city] = "Walnut Creek" if session[:city].nil?
    if params[:page].nil?
      cookies[:feature_page] = 1
      cookies.delete :other_city_page
    end
    cookies[:feature_page] = 1 + cookies[:feature_page].to_i if !params[:page].nil?
    re_time = 1
    arr = []
    get_total_feature_list(arr,cookies[:latitude],cookies[:longitude])
    featured = arr.uniq{|x| x[:id]}
    while arr.length < 8 && re_time <= 5
      cookies[:feature_page] = 1 + cookies[:feature_page].to_i
      get_total_feature_list(arr,cookies[:latitude],cookies[:longitude])
      re_time+=1
    end
    @activity_featured = arr.uniq{|x| x[:id]}
    render :partial=>"featured_row"
  end

  def get_total_feature_list(arr,lat,long)
    featured = City.nearby_city_activities(lat,long,session[:city],cookies[:feature_page])
    #~ @admin_activity=[]
    if featured[1]
      cookies[:other_city_page] = 1 +  cookies[:other_city_page].to_i if !cookies[:other_city_page].nil?
      cookies[:other_city_page] = 1 if cookies[:other_city_page].nil?
      #cookies[:other_city_page] = ((cookies[:other_city_page].nil?)  ? 1 : (cookies[:other_city_page].to_i+1))
      @admin_activity = featured[0].paginate(:page => cookies[:other_city_page], :per_page =>20)
    else
      @admin_activity = featured[0].paginate(:page => cookies[:feature_page], :per_page =>20)
    end

    @admin_activity.each do |actv|
      if actv.class.to_s=='Activity' || actv.class.to_s=='Array'
        activity = (actv.class.to_s=='Activity') ? actv : actv[0]
        mod_mode = (actv.class.to_s=='Activity') ? 'activity' : 'weekend'
	      @schedule = ActivitySchedule.where("activity_id = ?",activity.activity_id).last
	      #Activity.schedule_feature_list(session[:date],event,arr) if !event.nil?
        arr << {:model_mode=>mod_mode, :discount_eligible=>activity.discount_eligible, :schedule =>@schedule, :activity=>activity, :id => activity.activity_id, :leader=>activity.leader, :skill_level=>activity.skill_level, :schedule_mode=>activity.schedule_mode, :filter_id=>activity.filter_id, :min_age_range=>activity.min_age_range, :max_age_range=>activity.max_age_range, :price_type => activity.price_type, :city => activity.city, :activity_name => activity.activity_name, :description => activity.description,:avatar=> activity.avatar,:avatar_file_name=>activity.avatar_file_name,:category=>activity.category,:sub_category=>activity.sub_category,:price=>activity.price,:address_1=>activity.address_1,:address_2=>activity.address_2,:age_range=>activity.age_range,:no_participants=>activity.no_participants,:created_by=>activity.created_by,:user_id=>activity.user_id, :purchase_url=>activity.purchase_url,:slug=>activity.slug}
      else
        arr << {:id => actv.user_id,:model_mode=>'user'}
      end
    end if !@admin_activity.nil? && @admin_activity.length > 0
    @total_pages = @admin_activity.total_pages
    @current_page = (cookies[:other_city_page] && cookies[:other_city_page].present? && !cookies[:other_city_page].nil?) ? cookies[:other_city_page] : cookies[:feature_page]
    return arr
  end



#new design code goes from here

  #~ def featured_activity_detail
    #~ session[:city] = cookies[:search_city]
    #~ #session[:city] = "Walnut Creek"
    #~ if cookies[:search_city].include?("Chennai")
      #~ session[:city] = "Walnut Creek"
    #~ end
    #~ if params[:page].nil?
      #~ cookies[:feature_page] = 1
      #~ cookies.delete :other_city_page
    #~ end
    #~ cookies[:feature_page] = 1 + cookies[:feature_page].to_i if !params[:page].nil?
    #~ re_time = 1
    #~ arr = []
    #~ get_total_feature_list_detail(arr,cookies[:latitude],cookies[:longitude])
    #~ featured = arr.compact.flatten
    #~ while featured.length < 4 && re_time <= 5
      #~ cookies[:feature_page] = 1 + cookies[:feature_page].to_i
      #~ get_total_feature_list_detail(arr,cookies[:latitude],cookies[:longitude])
      #~ featured = arr.compact.flatten
      #~ re_time+=1
    #~ end
    #~ @activity_featured = featured
    #~ render :partial=>"activity_card/activity_short_desc"
  #~ end

  #~ def get_total_feature_list_detail(arr,lat,long)
    #~ featured = City.nearby_city_activities_detail(lat,long,session[:city],cookies[:feature_page])
#@admin_activity=[]
    #~ if featured[1]
      #~ cookies[:other_city_page] = 1 +  cookies[:other_city_page].to_i if !cookies[:other_city_page].nil?
      #~ cookies[:other_city_page] = 1 if cookies[:other_city_page].nil?
      #~ #cookies[:other_city_page] = ((cookies[:other_city_page].nil?)  ? 1 : (cookies[:other_city_page].to_i+1))
      #~ @admin_activity = featured[0].paginate(:page => cookies[:other_city_page], :per_page =>12)
    #~ else
      #~ @admin_activity = featured[0].paginate(:page => cookies[:feature_page], :per_page =>12)
    #~ end
    #~ arr << @admin_activity
    #~ arr.compact.flatten
    #~ return arr
  #~ end
  
  def provider_names_list
    # cookies[:provider_page] = 1 if !params[:page].nil?
    # cookies[:provider_page] = 1 + cookies[:provider_page].to_i if params[:page].nil?
    @page = !params[:page].nil? ? params[:page] : 1
    prov_arr = []
    prov_arr1 = []
    get_total_provider_list(prov_arr,prov_arr1)
    #~ prov_list = prov_arr.uniq{|x| x[:id]}
    #~ if prov_list.length != 0 && prov_list.length < 5
	  #~ # cookies[:provider_page] = 1 + cookies[:provider_page].to_i
	  #~ @page = @page.to_i + 1
	  #~ get_total_provider_list(prov_arr)
    #~ end
    @prov_list_new = prov_arr.uniq{|x| x[:id]}
    @prov_list_remain = prov_arr1.uniq{|x| x[:id]}
    render :partial=>"provider_list"
  end
  
  def get_total_provider_list(prov_arr,prov_arr1)
    #prov_user = UserProfile.joins(:user).where("lower(users.user_type)=?",'p').uniq
    prov_user = UserProfile.find_by_sql("select distinct * from user_profiles u left join users s on u.user_id = s.user_id where lower(s.user_type) = 'p' and s.account_active_status=TRUE and lower(s.user_plan)='sell' and s.show_card = true and (lower(s.user_status) != 'deactivate' or s.user_status is null)")
    #a = prov_user.collect{|user| user.user_plan == 'sell' ? user : nil}
    #b = prov_user.collect{|user| user.user_plan == 'free' ? user : nil}
    #c = prov_user.collect{|user| user.user_plan == 'curator' ? user : nil}
    #prov_user_list = a.compact + b.compact + c.compact
    prov_user = prov_user.compact
    prov_user_list = prov_user.sort { |a, b| a.user_id <=> b.user_id }
    prov_user_list1 = prov_user_list.reverse
    prov_list = prov_user_list1.paginate(:page => @page, :per_page => 30)
    prov_list_new = prov_list.collect{|user| (Time.parse(user.user_created_date).utc >= 3.days.ago) ? user : nil}
    prov_list_remain = prov_list.reject{|user| (Time.parse(user.user_created_date).utc >= 3.days.ago) ? user : nil}
    prov_list_new = prov_list_new.compact
    prov_list_remain = prov_list_remain.compact
    @prov_list_count = prov_list.total_pages if !prov_list.nil?
    cookies[:provider_count] = @prov_list_count
    prov_list_new && prov_list_new.each do |provider|
      prov_arr << {:id => provider.user_id,:business_name => provider.business_name, :business_logo => !provider.nil? && !provider.profile.nil? ? provider.profile.url(:thumb) : "", :user_created_date => !provider.nil? && !provider.user_created_date.nil? ? provider.user_created_date : ""}
    end
    prov_list_remain && prov_list_remain.each do |provider|
      prov_arr1 << {:id => provider.user_id,:business_name => provider.business_name, :business_logo => !provider.nil? && !provider.profile.nil? ? provider.profile.url(:thumb) : "", :user_created_date => !provider.nil? && !provider.user_created_date.nil? ? provider.user_created_date : ""}
    end
  end

  #Can be used if count is needed in landing page for each rows
  #~ def get_total_count_feature_list
  #~ if !session['ip_location'].nil?
  #~ ip_location = session['ip_location']
  #~ #ip_location = ActiveSupport::JSON.decode(ip_loc)
  #~ else
  #~ ip_location = {'latitude'=>'37.9100783','longitude'=>'-122.0651819', 'city' => 'Walnut Creek'}
  #~ end
  #~ if (cookies[:selected_city].nil?)
  #~ cookies[:city_new_usr] = ip_location['city'].titlecase  if(ip_location && !ip_location.nil? && !ip_location['city'].nil?)
  #~ else
  #~ cookies[:city_new_usr] = cookies[:selected_city]
  #~ end
  #~ if (ip_location['latitude']!='' && ip_location['longitude']!='' && !ip_location['latitude'].nil? && !ip_location['longitude'].nil?)
  #~ featured = City.nearby_city_activities(ip_location['latitude'],ip_location['longitude'],session[:city])
  #~ else
  #~ #featured =Activity.find_by_sql("select act.* from activities act left join users u on act.user_id=u.user_id where lower(u.user_plan)='sell' and lower(active_status)='active' and cleaned=true and lower(created_by)='provider' order by activity_id desc")
  #~ featured = Activity.joins(:user,:activity_schedule).where("city='Walnut Creek' and lower(user_plan)='sell' and lower(active_status)='active' and cleaned=true and lower(created_by)='provider' and expiration_date >= '#{Date.today}'").order("activity_id DESC")
  #~ end
  #~ @admin_activity = featured
  #~ arr = []
  #~ @admin_activity.each do |event|
  #~ @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
  #~ Activity.schedule_feature_list(session[:date],event,arr) if !event.nil?
  #~ end if !@admin_activity.nil? && @admin_activity.length > 0
  #~ arr_count = arr.uniq{|x| x[:id]}
  #~ render :text=> arr_count.length
  #~ end

  def shared_activity
    session[:city] = cookies[:city_new_usr]
    session[:city] = "Walnut Creek" if session[:city].nil?
    cookies[:shared_page] = 1 if !params[:page].nil?
    cookies[:shared_page] = 1 + cookies[:shared_page].to_i if params[:page].nil?
    arr_shared = []
    arr_shared << get_total_shared_list
    if arr_shared.length ==0 && arr_shared.length <8
      cookies[:shared_page] = 1 + cookies[:shared_page].to_i
      arr_shared << get_total_shared_list
    end
    @activity_share_provider = arr_shared[0]
    if request.headers['X-PJAX']
      render :partial=>"parent_shared", :layout => false
    else
      render :partial=>"parent_shared"
    end
  end
  
  def get_total_shared_list
    act_provider =  Activity.get_shared_activities(cookies[:uid_usr],current_user.email_address) if !current_user.nil?
    shared = act_provider.paginate(:page => cookies[:shared_page], :per_page =>20) if !act_provider.nil? && act_provider.present?
    @all_act=[]
    @act_free=[]
    upcoming_shared=get_upcoming_activities(shared)
    return upcoming_shared
  end

  def get_total_count_shared_list
    act_provider =  Activity.get_shared_activities(cookies[:uid_usr],current_user.email_address) if !current_user.nil?
    shared = act_provider.length

    render :text=> shared
  end
  
  def favorite_activity
    session[:city] = cookies[:city_new_usr]
    session[:city] = "Walnut Creek" if session[:city].nil?
    cookies[:favor_page] = 1 if !params[:page].nil?
    cookies[:favor_page] = 1 + cookies[:favor_page].to_i if params[:page].nil?
    arr_favorite = []
    arr_favorite << get_total_favorite_list
    if arr_favorite.length !=0 && arr_favorite.length <8
      cookies[:favor_page] = 1 + cookies[:favor_page].to_i
      arr_favorite << get_total_favorite_list
    end
    @activity_saved_favorites = arr_favorite[0]
    if request.headers['X-PJAX']
      render :partial=>"parent_saved_favorites", :layout => false
    else
      render :partial=>"parent_saved_favorites"
    end
  end

  def get_total_favorite_list
    act_saved_fav = Activity.get_saved_favorites(session[:city],session[:zip_code],session[:date],cookies[:uid_usr])
    saved_favorites = act_saved_fav.paginate(:page => cookies[:favor_page], :per_page =>20)
    #@all_act=[]
    #@act_free=[]
    #upcoming_favorites=get_upcoming_activities(saved_favorites)
    return saved_favorites
  end

  def get_total_favorite_count_list
    act_saved_fav = Activity.get_saved_favorites(session[:city],session[:zip_code],session[:date],cookies[:uid_usr])
    saved_favorites = act_saved_fav.length
    render :text=> saved_favorites
  end
  
  def my_activity
    session[:city] = cookies[:city_new_usr]
    session[:city] = "Walnut Creek" if session[:city].nil?
    cookies[:my_page] = 1 if !params[:page].nil?
    cookies[:my_page] = 1 + cookies[:my_page].to_i if params[:page].nil?
    arr_create = []
    arr_create << get_total_my_activity_list
    if arr_create.length !=0 && arr_create.length <8
      cookies[:my_page] = 1 + cookies[:my_page].to_i
      arr_create << get_total_my_activity_list
    end
    @activity_created_activities = arr_create[0]
    if request.headers['X-PJAX']
      render :partial=>"parent_created_activities", :layout => false
    else
      render :partial=>"parent_created_activities"
    end
  end

  def get_total_my_activity_list
    act_created_fav = Activity.get_saved_created_activities(session[:city],session[:zip_code],session[:date],cookies[:uid_usr])
    created_activities = act_created_fav.paginate(:page => cookies[:my_page], :per_page =>20)
    return created_activities
  end
  
  def get_total_count_my_activity_list
    act_created_fav = Activity.get_saved_created_activities(session[:city],session[:zip_code],session[:date],cookies[:uid_usr])
    created_activities = act_created_fav.length
    render :text=> created_activities
  end

  def free_activity
    session[:city] = cookies[:city_new_usr]
    session[:city] = "Walnut Creek" if session[:city].nil?
    cookies[:free_page] = 1 if !params[:page].nil?
    cookies[:free_page] = 1 + cookies[:free_page].to_i if params[:page].nil?
    arr = []
    get_total_free_list(arr)
    free = arr.uniq{|x| x[:id]}
    if free.length !=0 && free.length <6
      cookies[:free_page] = 1 + cookies[:free_page].to_i
      get_total_free_list(arr)
    end
    @activity_free = arr.uniq{|x| x[:id]}
    @free = true
    if request.headers['X-PJAX']
      render :partial=>"free_row", :layout => false
    else
      render :partial=>"free_row"
    end
  end

  def get_total_free_list(arr)
    featured = Activity.get_activities_repeat(session[:city],session[:zip_code],session[:date],3)
    @admin_activity = featured.paginate(:page => cookies[:free_page], :per_page =>20)
    @admin_activity.each do |event|
      @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
      Activity.schedule_feature_list(session[:date],event,arr) if !event.nil?
    end if !@admin_activity.nil? && @admin_activity.length > 0
    return arr
  end
  
  def get_total_count_free_list
    @admin_activity = Activity.get_activities_repeat(session[:city],session[:zip_code],session[:date],3)
    arr =[]
    @admin_activity.each do |event|
      @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
      Activity.schedule_feature_list(session[:date],event,arr) if !event.nil?
    end if !@admin_activity.nil? && @admin_activity.length > 0
    render :text=> arr.length
  end


  def cat_subcategory_row
    session[:city] = cookies[:search_city]
    session[:city] = "Walnut Creek" if session[:city].nil?
    cookies[:"page_#{params[:cat]}"] = 1 if !params[:page].nil?
    cookies[:"page_#{params[:cat]}"] = 1 + cookies[:"page_#{params[:cat]}"].to_i if params[:page].nil?
    arr = []
    if !current_user.nil? && current_user.present?
      if params[:page] == "1"
        cookies[:"other_#{params[:cat]}"] = 2
        get_total_sub_category_list(arr,cookies[:"page_#{params[:cat]}"],params[:cat])
      else
        cookies[:"other_#{params[:cat]}"] = 2
        cookies[:"other_page_#{params[:cat]}"] = 1 if cookies[:"other_page_#{params[:cat]}"].nil?
        cookies[:"other_page_#{params[:cat]}"] = 1 + cookies[:"other_page_#{params[:cat]}"].to_i
        get_total_sub_category_list(arr,cookies[:"other_page_#{params[:cat]}"],params[:cat])
      end
    else
      get_total_sub_category_list_with_subcat_id(arr,cookies[:"page_#{params[:cat]}"],params[:cat], cookies[:subct_id])
    end
    free = arr.uniq{|x| x[:id]}
    if free.length < 8
      cookies[:"other_#{params[:cat]}"] = 2
      cookies[:"other_page_#{params[:cat]}"] = 1 if cookies[:"other_page_#{params[:cat]}"].nil?
      cookies[:"other_page_#{params[:cat]}"] = 1 + cookies[:"other_page_#{params[:cat]}"].to_i
      get_total_sub_category_list(arr,cookies[:"other_page_#{params[:cat]}"],params[:cat])
    end
    @activity_free = arr.uniq{|x| x[:id]}
    if request.headers['X-PJAX']
      render :partial=>"provider_category_row", :layout => false
    else
      render :partial=>"provider_category_row"
    end
  end


  def fam_post_row
    if current_user && current_user.present?
      @fam_network =  ContactGroup.where("group_id=#{params[:id]}").last
      fam_post = Message.find_by_sql("select * from messages as m left join message_threads as mt on m.message_id=mt.message_id and m.contact_group_id = #{params[:id]}
                           left join message_thread_viewers as mv on mt.thread_id=mv.message_thread_id where ((mt.posted_by=#{current_user.user_id} and mt.msg_flag=true )
                            or (mv.user_id=#{current_user.user_id} and mv.msg_thread_flag=true)) order by m.message_id desc").uniq
      @fam_post = fam_post.paginate(:page => params[:page], :per_page =>20)

      @contact = ContactUserGroup.where("contact_group_id =#{params[:id]}")
      render :partial=>"fam_post_row"
    end
  end
  
  def get_total_sub_category_list(arr,page,cat) 
    cookies[:"other_#{cat}"] = 1 if cookies[:"other_#{cat}"].nil?

    act_row = Activity.get_near_by_activity_row_values_repeat_category(session[:city],session[:zip_code],session[:date],cat,cookies[:uid_usr],"",page,cookies[:"other_#{cat}"])
    @act_row_page = act_row
    @act_row_page.each do |event|
      @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
      Activity.schedule_feature_list(session[:date],event,arr) if !event.nil?
    end if !@act_row_page.nil? && @act_row_page.length > 0
    return arr
  end
  
  def get_total_sub_category_list_with_subcat_id(arr,page,cat,sub_cat)
    act_row = Activity.get_activity_row_values_repeat_category(session[:city],session[:zip_code],session[:date],cat,cookies[:uid_usr],sub_cat)
    @act_row_page = act_row.paginate(:page => page, :per_page =>20)

    @act_row_page.each do |event|
      @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
      Activity.schedule_feature_list(session[:date],event,arr) if !event.nil?
    end if !@act_row_page.nil? && @act_row_page.length > 0
    return arr
  end

  def get_total_count_sub_category_list
    session[:city] = cookies[:city_new_usr]
    session[:city] = "Walnut Creek" if session[:city].nil?
    arr =[]
    @act_row_page = Activity.get_activity_row_values_repeat_category(session[:city],session[:zip_code],session[:date],params[:cat],cookies[:uid_usr],"")

    @act_row_page.each do |event|
      @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
      Activity.schedule_feature_list(session[:date],event,arr) if !event.nil?
    end if !@act_row_page.nil? && @act_row_page.length > 0
    render :text=> arr.uniq{|x| x[:id]}.length
  end

  #filter categories and city based on the user selection by rajkumar 2013-9-2
  def category_report_count
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
    @act_row_page = Activity.find_by_sql("SELECT * FROM activities where lower(active_status)='active' and cleaned =true #{city_category} order by activity_id desc").uniq
    @total = @act_row_page.length if !@act_row_page.nil? && @act_row_page!="" && @act_row_page.present?
    #~ #provider count list
    #~ @act_provider_act = @act_row_page.map(&:user_id).uniq
    #~ @total_provider = @act_provider_act.length if !@act_provider_act.nil? && @act_provider_act!="" && @act_provider_act.present?
    
    #provider count - city and category fromusers
    @provider_count = UserProfile.find_by_sql("select * from users u left join user_profiles p on u.user_id=p.user_id where lower(u.user_type) = 'p' and lower(u.user_plan)='sell' and
u.account_active_status=true #{city_category} order by u.user_id desc")
    @act_provider_act = @provider_count.map(&:user_id).uniq
    @total_provider = @act_provider_act.length if !@act_provider_act.nil? && @act_provider_act!="" && @act_provider_act.present?
	
    render :partial =>"category_report_count"

  end

  def activity_category_report

    @fam_city = Activity.all
    @city = @fam_city.map(&:city).uniq
    @category = @fam_city.map(&:category).uniq

    render :layout=>false
  end
  
  #famtivity user report for list of users
  def famtivity_user_report
	  render :layout=>false
	  
  end
  def find_us_on_famtivity
	  @get_current_url = request.env['HTTP_HOST']
    render :layout=>false
  end
  
  
  #display the list of famtivity users count
  def famtivity_user_count
    render :partial => "famtivity_user_count"
  end
  
  def splash
  end

  # Hierachial - Follow Cities  (SEO)
  def follow_cities
	@meta_alt = true #dont remove, this for sitemap usage
    #activity card display here
    @qlinks = ["Specials","Discount Dollars", "Free", "Camps", "Special Needs"] #qlink displays
    @fam_city = City.order(:city_name)
    @mode ="parent"
    @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT trim(category) as category",:conditions=>["lower(category)!=?",'default'])

    if (params[:busi_name] && params[:city] && params[:categ] && params[:sub_categ] && params[:activity_name])
      # if city bname categ and subcateg will work this
      @user_profile_act = UserProfile.getuserdetails('',params[:categ]) if params[:categ]
      if @user_profile_act #if cate as businessname
        @user = User.getdetails(@user_profile_act.user_id) if !@user_profile_act.nil?
        @activity =  (@user_profile_act && !@user_profile_act.nil? && !@user_profile_act.user_id.nil?) ? Activity.get_activity_det(params[:activity_name],@user_profile_act.user_id) : []
        @actcatname = ActivityCategory.getcategname(params[:categ])
        @actsubcatname = ActivitySubcategory.getsubcategname(params[:sub_categ])
      else
        @user_profile = UserProfile.getuserdetails('',params[:busi_name]) if params[:busi_name]
        @user = User.getdetails(@user_profile.user_id) if !@user_profile.nil?
        @activity =  (@user_profile && !@user_profile.nil? && !@user_profile.user_id.nil?) ? Activity.get_activity_det(params[:activity_name],@user_profile.user_id) : []
      end
      #activity details display here
      if @activity && !@activity.user_id.nil? && !current_user.nil? && !current_user.user_id.nil? && @activity.user_id == current_user.user_id
        @act_schedules = @activity.activity_schedule
      else
        @act_schedules = @activity.activity_schedule.where("expiration_date >= ?",Date.today) if @activity && @activity.activity_schedule
      end
    elsif (params[:busi_name] && params[:city] && params[:categ] && params[:sub_categ])
      # if city bname categ and subcateg will work this
      @user_profile_sub = UserProfile.getuserdetails('',params[:categ]) if params[:categ]
      @user = User.getdetails(@user_profile_sub.user_id) if !@user_profile_sub.nil?
      if @user_profile_sub #if cate as businessname
        @actcatname = ActivityCategory.getcategname(params[:sub_categ])
        @actsubcatname = ActivitySubcategory.getsubcategname(params[:busi_name])
        @footcity =  (@user_profile_sub && !@user_profile_sub.nil? && !@user_profile_sub.user_id.nil?) ? Activity.get_activity_vals(params[:city].gsub('-',' ').downcase,@actcatname.downcase,@actsubcatname.downcase,@user_profile_sub.user_id) : []
      else
        @user_profile = UserProfile.getuserdetails('',params[:busi_name]) if params[:busi_name]
        @user = User.getdetails(@user_profile.user_id) if !@user_profile.nil?
        @actcatname = ActivityCategory.getcategname(params[:categ])
        @actsubcatname = ActivitySubcategory.getsubcategname(params[:sub_categ])
        @footcity =  (@user_profile && !@user_profile.nil? && !@user_profile.user_id.nil?) ? Activity.get_activity_vals(params[:city].gsub('-',' ').downcase,@actcatname.downcase,@actsubcatname.downcase,@user_profile.user_id) : []
      end
    elsif (params[:city] && params[:categ] && params[:sub_categ])
      @user_profile_cat = UserProfile.getuserdetails('',params[:categ]) if params[:categ]
      # if city bname and category
      if @user_profile_cat && @user_profile_cat.present? #if cate as businessname
        @actcatname = ActivityCategory.getcategname(params[:sub_categ]) #get the params of category values
        @footcity =  (@user_profile_cat && !@user_profile_cat.nil? && !@user_profile_cat.user_id.nil?) ? Activity.get_activity_vals(params[:city].gsub('-',' ').downcase,@actcatname.downcase,'',@user_profile_cat.user_id) : []
      else #if city category subcategory will work this
        @actcatname = ActivityCategory.getcategname(params[:categ])
        @actsubcatname = ActivitySubcategory.getsubcategname(params[:sub_categ])
        user_ids = Activity.get_activity_vals(params[:city].gsub('-',' ').downcase,@actcatname.downcase,@actsubcatname.downcase,'')
        @footcity = UserProfile.joins(:user).where("users.user_id in (?)",user_ids).order("lower(business_name) asc")
      end
    elsif(params[:city] && params[:categ])
      #if city or businame
      @user_profile_sub = UserProfile.getuserdetails('',params[:categ]) if params[:categ]
      @user = User.getdetails(@user_profile_sub.user_id) if !@user_profile_sub.nil?
      #business name came
      if @user_profile_sub #if cate as businessname
        #display browse category,category,subcategory
        if cookies[:ctyv].present? && cookies[:categv].present? && cookies[:sub_categv].present?
          @actcatname = ActivityCategory.getcategname(cookies[:categv])
          @actsubcatname = ActivitySubcategory.getsubcategname(cookies[:sub_categv])
          @footcity =  (@user_profile_sub && !@user_profile_sub.nil? && !@user_profile_sub.user_id.nil?) ? Activity.get_activity_vals(cookies[:ctyv].gsub('-',' ').downcase,@actcatname.downcase,@actsubcatname.downcase,@user_profile_sub.user_id) : []
        elsif cookies[:categv].present? && cookies[:sub_categv].present?
          @actcatname = ActivityCategory.getcategname(cookies[:categv])
          @actsubcatname = ActivitySubcategory.getsubcategname(cookies[:sub_categv])
          @footcity =  (@user_profile_sub && !@user_profile_sub.nil? && !@user_profile_sub.user_id.nil?) ? Activity.get_activity_vals('',@actcatname.downcase,@actsubcatname.downcase,@user_profile_sub.user_id) : []
        else
          @footcity =  (@user_profile_sub && !@user_profile_sub.nil? && !@user_profile_sub.user_id.nil?) ? Activity.get_activity_vals('','','',@user_profile_sub.user_id) : []
        end
      else
        #categ came
        @actcatname = ActivityCategory.getcategname(params[:categ])
        @footcity = Activity.get_activity_vals(params[:city].gsub('-',' ').downcase,@actcatname.downcase,'','') if params[:city] && params[:categ]
      end
    elsif (params[:city])
      @footcity = Activity.get_activity_vals(params[:city].gsub('-',' ').downcase,'','','') if params[:city]
      @prov_list = UserProfile.getuserdetails(params[:city].gsub('-',' ').downcase,'') if params[:city]
    end
    @is_search_key = cookies[:test_cook] #for search autocomplete
    cookies.delete :test_cook

    if request.headers['X-PJAX']
      render :layout => 'main_layout'
    end
  end #follow cities ending here
  
  #Hierarchical - Follow Provider (SEO)
  def follow_provider_card
    city_name= params[:city].gsub(' ','-').downcase if params[:city]
    if params[:city] && (!params[:profile_id].nil? || !params[:det_user_id].nil?)
      @user_profile = UserProfile.find(params[:profile_id])
      @user = User.find(@user_profile.user_id)
      @activities = (@user_profile && !@user_profile.nil? && !@user_profile.user_id.nil?) ? Activity.where("user_id=? and lower(city)='#{params[:city].gsub('-',' ').downcase}' and cleaned=? and lower(active_status)=?",@user_profile.user_id,true,'active').uniq  : []
      cat =  @activities.last.category.gsub(' ','-').downcase if @activities && @activities.last && @activities.last.category
      sub_cat =  @activities.last.sub_category.gsub(' ','-').downcase if @activities && @activities.last && @activities.last.sub_category
      redirect_to "/#{city_name}-ca/#{@user_profile.slug}",  :status => 301
    elsif params[:city]
      redirect_to "/#{city_name}-ca",  :status => 301
    end
  end

  def zip_search
    re_times = 5
    begin
      location = Geocoder.search("#{params[:zip_value]}").first
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
    
  
  protected
  
  def geo_ip_location
    #~ session['ip_location'] = Activity.ip_city_name(@i_addr).to_json if session['ip_location'].nil?
    if cookies[:search_city].nil?
      @i_addr = request.remote_ip
      ip_location = Activity.ip_city_name(@i_addr).to_json
      session['ip_location'] = ActiveSupport::JSON.decode(ip_location)
      cookies[:search_city] = session['ip_location']['city'].capitalize if !session['ip_location'].nil? && !session['ip_location']['city'].nil?
      cookies[:latitude] = session['ip_location']['latitude']
      cookies[:longitude]= session['ip_location']['longitude']
      if (session['ip_location']['latitude']=='0' || session['ip_location']['longitude']=='0' )
        session['ip_location'] = {'latitude'=>'37.9100783','longitude'=>'-122.0651819', 'city' => 'Walnut Creek'}
      end
    end
  end
  
  def change_url
	  if current_user && !current_user.nil? && current_user.present?
		  redirect_to '/'
	  end
  end
  
end