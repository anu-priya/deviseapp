class SearchController < ApplicationController
  before_filter :authenticate_user, :except=>[:data_entry,:search,:basic_search_count, :search_by_keyword,:search_new_search]
  include ActionView::Helpers::TextHelper
  include SearchHelper
  require 'zip/zip'
  require 'zip/zipfilesystem'
  #caches_page :event_index
  require 'date'
  require 'time'
  require 'will_paginate/array'
  require 'fastimage'#this gem for fetching the images.
  layout 'landing_layout'

  include ActivitiesHelper
  include LandingHelper
  #New approval GUi Goes here.Please add your new action and code below.
   
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
  
  def data_entry
    #cookies[:search_city] = "Walnut Creek"
    if !cookies[:search_city].nil? && cookies[:search_city]!=""
      city_se = City.where("city_name='#{cookies[:search_city].gsub(",ca","").gsub(",CA","")}'").last
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
    @events.unshift({:data => "all",:value=>"#{params[:query]}",:act=>"Show All",:cur_set =>params[:set_p],:cur_page=>params[:page] || 1, :total_p=>total_pgae,:w_plan_name=> "2"})
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
      @flag=true
      if record.class == Activity
        user = UserProfile.where("user_id = #{record.user_id}").last
        user_p = User.where("user_id = #{record.user_id}").last
        anywhere_result = (record && record.schedule_mode && record.schedule_mode.present? && !record.schedule_mode.nil? && record.schedule_mode.downcase=='any where') ? 'anywhere': ((record && record.city.present? && !record.city.nil?) ? ((check_for_state(record.city)) ? record.city.gsub(/\s/,'-').downcase+url_state_value : record.city.gsub(/\s/,'-').downcase) : '')
        if @flag
          @events << {:w_class=>"activity",:category=>record.category,:sub_category=>record.sub_category,:city=> record.city,:w_activity_name=> record.activity_name,:w_provider_name=>user.business_name,:w_city=> anywhere_result,:user_id=>record.user_id,:provider_name=>truncate(user.business_name, :length =>25),:pass_value=>params[:query],:activity_name=>truncate(record.activity_name, :length =>25),:w_plan_name => user_p.user_plan , :data=> record.activity_id, :value=> "#{record.activity_name} "  + " #{user.business_name} "+ " #{record.city}",:w_slug => record.slug, :up_slug => user.slug} if !user.slug.nil? if !user.business_name.nil? if !user.nil?
        end
      else
        user = UserProfile.where("user_id = #{record.user_id}").last
        if @flag
          @events << {:w_class=>"user",:w_provider_name=>user.business_name,:user_id=>record.user_id,:provider_name=>truncate(user.business_name, :length =>25),:w_plan_name => record.user_plan , :pass_value=>params[:query],:city =>"#{user.city}",:w_city=>"#{user.city}", :data=> record.user_id, :value=> " #{user.business_name}" } if !user.business_name.nil? if !user.nil?
        end
      end
    }

  end
  
  def search_old
    @fam_city = City.order(:city_name)
    if (params[:zip_value_name] && params[:zip_value_name]!='') && !params[:x]
      cookies.delete :search_city
	    @z_city = params[:zip_value_name].split('-')[0..-2].join(" ")
	    @zcity = @z_city.titlecase.to_s
	    cstatev = check_for_state_value(@zcity)	    
	    cookies[:search_city] = (cstatev && cstatev.present?) ? ("#{@zcity},CA") : (@zcity)
    end
    #~ else
    if !cookies[:search_city].nil? && cookies[:search_city]!=""
      city_se = City.where("city_name='#{cookies[:search_city].gsub(",ca","").gsub(",CA","")}'").last
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
    #~ end
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
        if params[:event_search] && params[:event_search]!='' && params[:event_search].present? && (params[:event_search]!='Search 20,000   Local Activities & Counting...' && params[:event_search] != 'Search 20,000 + Local Activities & Counting...')
          keywords params[:event_search] do
            #query_phrase_slop 1
            minimum_match 1
            phrase_fields :user_profile_name => 9,:activity_name =>8
            fields(:city=>10,:user_profile_name=>9,:activity_name =>8,:category=>1,:sub_category=>1)
          end
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
    @keyword =  params[:event_search] if params[:event_search] && params[:event_search]!='' && params[:event_search].present? && (params[:event_search]!='Search 20,000   Local Activities & Counting...' && params[:event_search] != 'Search 20,000 + Local Activities & Counting...') 
    @accordion = Activity.getcategories(type=1,'') #get the categories for accordion, type=1 means get list of active activity category
    if !params[:type].nil? && params[:type] == "city"
      @keyword = "#{params[:city_name]}" if params[:type] == "city"
    else
      @keyword = "#{params[:event_search].html_safe if !params[:event_search].nil? }" + " " + "#{params[:city_name]}" if params[:type] == "city"
    end
    #@keyword =  params[:event_search] = "#{params[:event_search].html_safe if !params[:event_search].nil?}" + " " + "#{params[:pro_name]}" if params[:type] == "provider"
    # @keyword =  params[:event_search] = "#{params[:city_name]}" if params[:type] == "city"
    if params[:type] == "provider" && @search_tu == "yes"
      @keyword =  params[:event_search] = "#{params[:pro_name]}" if params[:event_search] && params[:event_search]!='' && params[:event_search].present? && (params[:event_search]!='Search 20,000   Local Activities & Counting...' && params[:event_search] != 'Search 20,000 + Local Activities & Counting...') 
      @search_count = @search_count + 1 if !@user_curated.nil?
    end
    if request.headers['X-PJAX']
      respond_to do |format|
        format.js{ render :layout => false}
        format.html{ render :layout => false}
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
    #~ age_range = []
    #~ if params[:aa_all] !="a_all"
    #~ if params[:aa_m1] == "0-6"
    #~ age_range << age_month_calc((0..6).to_a)
    #~ end
    #~ if params[:aa_m1] == "6-12"
    #~ age_range << age_month_calc((6..12).to_a)
    #~ end
    #~ if (params[:aa_r1] == "0-3") || (params[:aa_r1] == "2-3")
    #~ age_r1 = (params[:aa_r1]=="0-3") ? (0..3) : (2..3)
    #~ age_range << (age_r1).to_a
    #~ end
    #~ if params[:aa_r4] == "4-7"
    #~ age_range << (4..7).to_a
    #~ end
    #~ if params[:aa_r8] == "8-15"
    #~ age_range << (8..99).to_a
    #~ end
    #~ end
    
    #age range new changes
    agee_type = params[:age_type]
    agee = params[:age_range]
    sval = agee.split("-") if agee && agee!="all" && agee!="8+"
    age_range = []
	  if (agee && agee.downcase!="all" && agee!="8+")
		  if agee_type.downcase == 'month'
        age_range << age_month_calc((sval[0]..sval[1]).to_a)
		  elsif agee_type.downcase == 'year'
        age_range << (sval[0]..sval[1]).to_a
		  end
	  elsif agee && agee=="8+"
		  age_range << (8..99).to_a
	  end

    camp = true if params[:camp_range_1] == "camp"
    special = []
    special = @special
    start_date =""
    age_range_flat = age_range.flatten
    end_date = Date.today
    start_date =  params[:start_dates] if !params[:start_dates].nil? && params[:start_dates]!=""
    end_date = params[:end_dates] if !params[:end_dates].nil? && params[:end_dates]!=""

    @search = Sunspot.search(Activity,User) do
      if params[:event_search] && params[:event_search]!='' && params[:event_search].present? && (params[:event_search]!='Search 20,000   Local Activities & Counting...' && params[:event_search] != 'Search 20,000 + Local Activities & Counting...')
        fulltext params[:event_search] do
          query_phrase_slop 1
          # minimum_match 1
          phrase_fields :city => 10,:user_profile_name => 9,:activity_name =>8
          fields(:city=>9,:user_profile_name=>9,:activity_name =>8,:category=>8,:sub_category=>8,:tags_txt=>8)
        end
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



  def search_new_search
    @fam_city = City.order(:city_name)
    @events = []
    if (params[:zip_value_name] && params[:zip_value_name]!='') && !params[:x]
      cookies.delete :search_city
	    @z_city = params[:zip_value_name].split('-')[0..-2].join(" ")
	    @zcity = @z_city.titlecase.to_s
	    cstatev = check_for_state_value(@zcity)	    
	    cookies[:search_city] = (cstatev && cstatev.present?) ? ("#{@zcity},CA") : (@zcity)
    end
    #~ else
    if !params[:find_loc].nil? && params[:find_loc]!="" && params[:find_loc] !="Enter city (or) Zip code"
      if params[:page].nil? || params[:page]== "1" || params[:page_load] == "yes"
        re_times = 5
        if !params[:find_loc].nil? && params[:find_loc]!=""
          city_se = City.where("city_name='#{params[:find_loc].gsub(",ca","").gsub(",CA","").gsub(", CA","").gsub(", CA","")}'").last
          if !city_se.nil?
            cookies[:latitude] = city_se.latitude
            cookies[:longitude] = city_se.longitude
          else
            begin
              location = Geocoder.search("#{params[:find_loc]}").first
              cookies[:latitude] = location.latitude
              cookies[:longitude] = location.longitude
              if location.country_code == "IN"
                cookies[:search_city] = location.city + "," + location.state_code
              else
                cookies[:search_city] = location.city
              end
              cookies[:search_city] = location.city
              if cookies[:latitude] == 0.0 || cookies[:search_city]=="" || cookies[:search_city].nil?
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
        end
      end
    elsif cookies[:latitude] == 0.0 || cookies[:search_city]=="" || cookies[:search_city].nil?
      cookies[:latitude] = 37.9100783
      cookies[:longitude] = -122.0651819
      cookies[:search_city] = "Walnut Creek"
    end

    @category = []
    @city = []
    @city = city = params[:city].split(",").reject(&:empty?) if !params[:city].nil? && params[:city]!=""
    @day_of_Week = day_of_week = params[:day_range].downcase.split(",").reject(&:empty?) if !params[:day_range].nil? && params[:day_range]!="" && params[:day_all]!="all"
    if !params[:category].nil? && params[:category]!=""
      @category = params[:category].split(",").reject(&:empty?)
      categories =ActivityCategory.includes(:activity_subcategory).where(:category_id => @category ) if params[:cat_all]!="all"
    end
    params[:city_search_ra] = params[:city_name] if !params[:city_name].nil? && params[:city_name]!=""
    if params[:p_all]!= "p_all"
      free = true if params[:a_f] == "free"
      paid = true if params[:paid]== "paid"
    end

    age_range = []
    if params[:age_all] !="all"
      age_range << age_month_calc((0..6).to_a) if params[:age_six_mn] == "0-6"
      age_range << age_month_calc((6..12).to_a) if params[:age_twel_mn] == "6-12"
      age_range << 1 if params[:age_twel_mn] == "6-12"
      age_range << (2..3).to_a if params[:age_three_yr] == "2-3"
      age_range << (4..7).to_a if params[:age_seven_yr] == "4-7"
      if params[:age_eight_yr] == "8-15"
        age_range << (8..99).to_a 
        age_range << 'Adults'
      end
    end
    #age range new changes
    agee_type = params[:age_type]
    agee = params[:age_range]
    sval = agee.split("-") if agee && agee!="all" && agee!="8+"
	  if (agee && agee.downcase!="all" && agee!="8+")
		  if agee_type.downcase == 'month'
        age_range << age_month_calc((sval[0]..sval[1]).to_a)
        age_range << 1 if params[:age_range] == "6-12"
		  elsif agee_type.downcase == 'year'
        age_range << (sval[0]..sval[1]).to_a
		  end
	  elsif agee && agee=="8+"
		  age_range << (8..99).to_a
      age_range << 'Adults'
	  end
    params[:event_search] = "" if params[:type] == "city" || params[:type] == "provider" || params[:event_search] =="dance lessons, painting, class, etc" || params[:event_search] =="dance lessons, painting..."
    camp = true if params[:camp_range_1] == "camp"
    special = []
    special = @special
    start_date =""
    age_range_flat = age_range.flatten
    end_date = Date.today
    if params[:page_load]=='yes'
      params[:page_no] = params[:page]
      params[:page] = 1
    end
    if params[:date_all]!="all"
      params[:start_dates] = start_date = params[:date_start_alt] if !params[:date_start_alt].nil? && params[:date_start_alt]!=""
      params[:end_dates] = end_date = params[:date_end_alt] if !params[:date_end_alt].nil? && params[:date_end_alt]!=""
    end
    @search = Sunspot.search(Activity,User) do
      fulltext params[:event_search] do
        query_phrase_slop 1
        # minimum_match 1
        phrase_fields :city => 10,:user_profile_name => 9,:activity_name =>8
        fields(:city=>9,:user_profile_name=>9,:activity_name =>8,:category=>8,:sub_category=>8,:tags_txt=>8)
      end

      if city
        any_of do
          city.each do |c|
            with(:city_lower, c.downcase)
          end
        end
      end

      order_by_geodist(:location, cookies[:latitude], cookies[:longitude]) if params[:type] != "provider"

      if free
        with(:price_type,3)
      end

      if categories
        any_of do
          categories.each do |c|
            c.activity_subcategory.each do |s|
              if params[:"sub_cat_#{c.category_id}"].split(",").reject(&:empty?).include?(s.subcateg_id.to_s)
                with(:sub_category_id, s.subcateg_id)
              end
            end
          end
        end
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
        any_of do
          age_range_flat.each do |d|
            with(:max_age_range,d)
            with(:min_age_range,d)
          end
        end
      end

      #      if !age_range_flat.empty?
      #        with(:max_age_range).any_of(age_range_flat)
      #        with(:min_age_range).any_of(age_range_flat)
      #      end
      if params[:type] == "provider"
        #        any_of do
        #          with(:created_by, "Provider")
        #        end
        order_by :recent_date,:desc
      end
      with :city_lower,params[:city_name].downcase if !params[:city_name].nil? && params[:city_name]!=""
      with :zip_code,params[:zip_value_name] if params[:zip_value_name] !="Enter city (or) Zip code" && params[:zip_value_name]!="" && !params[:zip_value_name].nil? && !params[:zip_value_name].scan(/^[0-9]+$/).blank?
      with :gender,params[:gender] if !params[:gender].nil? && params[:gender]!='' && params[:gender]!="g_all"
      with :user_id, params[:user_id]  if params[:type] == "provider" && !params[:user_id].nil? && params[:user_id]!=""
      with :show_card,true
      with :cleaned,true
      with :active_status, "Active"
      paginate :page =>params[:page] || 1, :per_page => 24
      order_by :user_plan,:desc if params[:type] != "provider"
    end
    @search_count = @search.total
    @keyword =  params[:event_search] if params[:event_search] && params[:event_search]!='' && params[:event_search].present? && (params[:event_search]!='Search 20,000   Local Activities & Counting...' && params[:event_search] != 'Search 20,000 + Local Activities & Counting...')
    if !params[:type].nil? && params[:type] == "city"
      @keyword = "#{params[:city_name]}" if params[:type] == "city"
    else
      @keyword = "#{params[:event_search].html_safe if !params[:event_search].nil? }" + " " + "#{params[:city_name]}" if params[:type] == "city"
    end
    if params[:type] == "provider"
      @keyword =  params[:event_search] = params[:pro_name]
      @search_count = @search_count + 1 if !@user_curated.nil?
    end
    @search.results.each { |record|
      if record.class == Activity
        status = City.get_activity_card_purchase_status(record)
        discount_price_1 = nil
        discount_price_1 = ActivityPrice.get_price_details(record.activity_id) if (record.activity_price)
        @events << {:id=>'activity',:act=>record,:status=> status,:sched=>record.activity_schedule,:act_usr=>record.user,:price=>record.activity_price,:discount_price=>discount_price_1} #display 1st 2 records and card
      else
        @events << {:id=>'user',:usr => record,:user_pro => record.user_profile} if record.show_card
      end
    }
    if request.headers['X-PJAX']
      respond_to do |format|
        format.js{ render :layout => false}
        format.html{ render :layout => false}
      end
    else
      respond_to do |format|
        format.js
        format.html
      end
    end
    #these cookies for breadcrumb usage
    cookies[:search_content] = request.fullpath

  end


end
