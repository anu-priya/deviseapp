class DetailsPageController < ApplicationController
  require 'will_paginate/array'
  require_dependency "activity_schedule.rb" #unmarshall error resolved for dalli
  require_dependency "activity.rb" #unmarshall error resolved for dalli
  layout "landing_layout"
  include DetailsPageHelper
	def index		
		@meta_alt=true  #dont remove, this for sitemap usage
		@mode ="parent"
     if request.fullpath.include?("assets") || request.fullpath.include?("system")
      respond_to do |format|
        format.js{render nothing: true}
        format.html{render nothing: true}
      end
    else
      if (params[:busi_name] && params[:city] && params[:categ] && params[:sub_categ] && params[:activity_name]) #Activity card
        @type="activity"
        @fam_city = City.getcities
        @activity = Activity.fnd_activity_slug(params[:activity_name]).last #from activity scope
        @user_profile = UserProfile.fetch_by_slug(params[:categ])
        @user = @user_profile.user if @user_profile
			
        #~ @use_act = User.find_by_user_id(@activity.user_id) if !@activity.nil? && @activity.user_id!=''
        #~ @user_profile = @use_act.user_profile  if !@use_act.nil?
        #breadcrumb formation
        prev_page = check_prevpage((request && request.referer) ? request.referer : '/')
        if prev_page.present?          
          city_name = @user_profile.city.gsub(" ","-").downcase if @user_profile && @user_profile.present? && @user_profile.city.present?
          state_code=check_for_state_value(@user_profile.city)  if @user_profile && @user_profile.present?  && @user_profile.city.present?
          if prev_page[0] && prev_page[0]!='' && prev_page[0].downcase == "all categories" || cookies[:browse_category] == "category"
           
            categ = ActivityCategory.getcategname(prev_page[2])
            sub_categ = ActivitySubcategory.getsubcategname(prev_page[3])
            if cookies[:browse_category] == "category"
              @breadcrumb = "<a href='/categories' title=All Categories'>All Categories</a>&nbsp;&gt;&nbsp;"
              cookies[:browse_category] = ""
            else
              @breadcrumb = "<a href='#{prev_page[1]}' title='#{prev_page[0]}'>#{prev_page[0]}</a>&nbsp;&gt;&nbsp;"
            end
			@breadcrumb  = @breadcrumb + "<a href='/#{params[:city].downcase.gsub(/\s/,'-')}/#{prev_page[2]}' title='#{categ}'>#{categ}</a>&nbsp;&gt;&nbsp;"
			@breadcrumb  = @breadcrumb + "<a href='/#{params[:city].downcase.gsub(/\s/,'-')}/#{prev_page[2]}/#{prev_page[3]}' title='#{sub_categ}'>#{sub_categ}</a>"
			if @user_profile.present? && @activity.present?  && @user_profile.city.present?
				@breadcrumb  = @breadcrumb + "&nbsp;&gt;&nbsp;<a href='/#{city_name}#{state_code}/#{@user_profile.slug}' title='#{@user_profile.business_name}'>#{@user_profile.business_name}</a>&nbsp;&gt;&nbsp;#{@activity.activity_name}"	      
			end
		else
			@breadcrumb ="<a href='#{prev_page[1]}' title='#{prev_page[0]}'>#{prev_page[0]}</a>"
			if @user_profile.present? && @activity.present?  && @user_profile.city.present?
				
				@breadcrumb = @breadcrumb + "&nbsp;&gt;&nbsp;<a href='/#{city_name}#{state_code}/#{@user_profile.slug}' title='#{@user_profile.business_name}'>#{@user_profile.business_name}</a>&nbsp;&gt;&nbsp;#{@activity.activity_name}"
			end
		end
        end
	#activity view count update to activity_counts table
	ActivityCount.updateViewCount(@activity.activity_id) if !@activity.nil? && @activity!=''
        #memcache start
        if ($dc.fetch("activity_schedules_for#{@activity.activity_id if @activity}").nil?)
          if @activity && !@activity.user_id.nil? && !current_user.nil? && !current_user.user_id.nil? && @activity.user_id == current_user.user_id
            @act_schedules = @activity.fetch_activity_schedule
          else
            @act_schedules = @activity.fetch_activity_schedule.where("expiration_date >= ?",Date.today) if @activity && @activity.activity_schedule
           end	
          $dc.set("activity_schedules_for#{@activity.activity_id if @activity}",@act_schedules.to_a)
        else
          @act_schedules = $dc.fetch("activity_schedules_for#{@activity.activity_id if @activity}")
        end
        #memcache end
        respond_to do |format|
          format.js
          format.html
        end


      elsif(params[:city] && params[:categ]) #Provider card
        @test_arr = []
        @type="provider"
        @fam_city = City.getcities
        @user_profile = UserProfile.getuserdetails('',params[:categ]) if params[:categ]
        
        if @user_profile
          prev_page = check_prevpage((request && request.referer) ? request.referer : '/')
          if prev_page.present?
            if prev_page[0] && prev_page[0]!='' && prev_page[0].downcase == "all categories"
              cookies[:browse_category] = "category"
              categ = ActivityCategory.getcategname(prev_page[2])
              sub_categ = ActivitySubcategory.getsubcategname(prev_page[3])
              @breadcrumb = "<a href='#{prev_page[1]}' title='#{prev_page[0]}'>#{prev_page[0]}</a>&nbsp;&gt;&nbsp;"
              @breadcrumb  = @breadcrumb + "<a href='/#{params[:city].downcase.gsub(/\s/,'-')}/#{prev_page[2]}' title='#{categ}'>#{categ}</a>&nbsp;&gt;&nbsp;"
              @breadcrumb  = @breadcrumb + "<a href='/#{params[:city].downcase.gsub(/\s/,'-')}/#{prev_page[2]}/#{prev_page[3]}' title='#{sub_categ}'>#{sub_categ}</a>&nbsp;&gt;&nbsp;"
              @breadcrumb  = @breadcrumb + "#{@user_profile.business_name}"
	      
			else
				@breadcrumb ="<a href='#{prev_page[1]}' title='#{prev_page[0]}'>#{prev_page[0]}</a>&nbsp;&gt;&nbsp;#{@user_profile.business_name}"
			end
		end
          #~ @user = User.locate_user(@user_profile.user_id).last if !@user_profile.nil?
          @user = User.fetch(@user_profile.user_id) if !@user_profile.nil?
          #activity_free = (@user_profile && !@user_profile.nil? && !@user_profile.user_id.nil?) ? Activity.get_activity_vals('','','',@user_profile.user_id) : []
          #memcache start
          if ($dc.fetch("provider_activity_for#{@user_profile.user_id}").nil?)
            activity_free = (@user_profile && !@user_profile.nil? && !@user_profile.user_id.nil?) ? Activity.get_activity_vals('','','',@user_profile.user_id) : []
            $dc.set("provider_activity_for#{@user_profile.user_id}",activity_free.to_a)
          else
            activity_free = $dc.fetch("provider_activity_for#{@user_profile.user_id}")
          end
          #memcache end
          @activity_free = activity_free.paginate(:page => params[:page], :per_page =>6) if !activity_free.nil?
          @activity_free.each do |r|
            status = City.get_activity_card_purchase_status(r)
            discount_price_1 = nil
            discount_price_1 = ActivityPrice.get_price_details(r.activity_id)
	    ac_user = User.fetch(r.user_id) #identity cache
            @test_arr << {:id=>'activity',:act=>r,:status=> status,:sched=>r.fetch_activity_schedule,:act_usr=>ac_user,:price=>r.activity_price,:discount_price=>discount_price_1} #display 1st 2 records and card
          end
          respond_to do |format|
            format.js
            format.html
          end
        else
          #else if second params is category          
          @search_city = (!cookies[:search_city].nil? ? cookies[:search_city] : "Walnut Creek")
	  @chk_city = @search_city+check_for_state_value(@search_city)
          @accordion = Activity.getcategories(type=2,@search_city)  #get the categories for accordion, type=2 means get list of activity category(both active or inactive) with city based
          user_categ = UserProfile.joins(:user).where("users.account_active_status=? and users.user_flag=?",true,true).map(&:category).uniq	 #Users registered with category
          #~ @categories_l = @accordion.map(&:category)
          @categories_l = (@accordion.map(&:category)+user_categ).compact.uniq.sort
          @categories_l.delete("")
          @qlinks = ["Specials","Discount Dollars", "Free", "Camps", "Special Needs"] #qlink displays
          @fam_city = City.getcities
          #choosed category values
          if (params[:categ] && params[:categ]!='' && params[:sub_categ] && params[:sub_categ]!='')
            @actcatname = ActivityCategory.getcategname(params[:categ])
            @actsubcatname = ActivitySubcategory.getsubcategname(params[:sub_categ])
            user_ids = Activity.get_actsubcatval(@actcatname.downcase,@actsubcatname.downcase,@search_city) if @actcatname && @actsubcatname
            @categories_l = UserProfile.joins(:user).where("users.user_id in (?)",user_ids).order("lower(business_name) asc")
          elsif(params[:categ] && params[:categ]!='' && !params[:sub_categ].present?)
            @actcatname = ActivityCategory.getcategname(params[:categ]) if params[:categ]
            @categories_l = Activity.get_actsubcatval(@actcatname.downcase,'',@search_city).sort if @actcatname
	    @chk_subcateg = true
          end
          render "quick_links/browse_category" if @actcatname.present?
        end
      end
    end
		@is_search_key = cookies[:test_cook] #for search autocomplete
		cookies.delete :test_cook
	end
	
	def check_prevpage(url)				
		prev_url = url.split("?")[0]	
		full_path = prev_url.split('/')
		path_url = prev_url.split('/').last
		quick_link =['hot-deals-activities','free-activities','camps-activities']				
		#if full_path && full_path.present? && full_path.length > 0 && full_path[3] == 'category'
		categ = ''
		sub_categ = ''
		if path_url && !path_url.nil? && path_url.present? && path_url.length > 0
			if  full_path.length == 6
				page = 'All Categories'
				link = "/categories"
				categ = full_path[4]
				sub_categ = full_path[5]
			elsif quick_link.include?(path_url)
				page = 'Search'
				link = "/#{path_url}"			
			else
				if path_url.include?('search')
					page = 'Search'
					link = cookies[:search_content]
				else
					page ="Home"
					link = '/'
				end
			end
		else
			page ="Home"
			link = '/'
		end				
		return page,link,categ,sub_categ
	end
	

#provider not present - display error page	
 def provider_error_page
	 @type="provider"
 end
	
  def find_location_by_ip
    city_val = ''
    if !request.ip.nil?
      city_val = check_city_using_geocoder(request.ip)
    end 
    render :text => city_val.blank? ? "Chennai" : city_val + check_for_state_value(city_val).gsub(/-/, ', ').upcase
 end 
end
