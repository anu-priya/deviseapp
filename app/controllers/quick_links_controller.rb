class QuickLinksController < ApplicationController
	require 'will_paginate/array'
	#quick links methods calling here
	#~ layout "landing_layout", :only => [:quick_links]
	layout "landing_layout"
	def quick_links
		@meta_alt=true  #dont remove, this for sitemap usage
		@fam_city = City.order(:city_name)		   
		@accordion = Activity.getcategories(type=0,'')  #get the categories for accordion, type=0 means get list of activity category(both active or inactive)
		@test_arr = []
		
		#quick link new chagnes
		city_arr = []
			a = []
			b = []
			other_city_arr = []
		quick_search = quick_link_result_hot
		
		#Separate the array into current city and other city
			if params[:search_type]=="favorite"
				quick_search_all = quick_search
			else
				if(quick_search.length > 0)
					a = quick_search.collect{|x| x.city == @search_city_details.city_name ? x : nil}
					city_arr = a.compact
					if(!quick_search.blank? && !city_arr.blank?)
						other_city_arr = quick_search - city_arr
						if(!other_city_arr.blank?)
							chk = other_city_arr.group_by{|x| x.city}.values
							quick_search_all = city_arr + chk.flatten
						else
							quick_search_all = quick_search
						end
					elsif(!quick_search.blank? && city_arr.blank?)
						other_city_arr = quick_search
						chk = other_city_arr.group_by{|x| x.city}.values
						quick_search_all = chk.flatten
					end
				else
					quick_search_all = quick_search
				end
			end
			#end current city and other city separation
		
		
		@search_count = quick_search_all.length
    if params[:page].nil?
      @page_v = 1
    else
      @page_v = params[:page].to_i + 1 if !params[:page].nil?
    end
			
		@activity_free = quick_search_all.paginate(:page =>@page_v, :per_page =>12) if !quick_search_all.nil?
		@activity_free && @activity_free.each do |r|
      status = City.get_activity_card_purchase_status(r)
      discount_price_1 = nil
      discount_price_1 = ActivityPrice.get_price_details(r.activity_id)
      @test_arr << {:id=>'activity',:act=>r,:status=> status,:sched=>r.activity_schedule,:act_usr=>r.user,:price=>r.activity_price,:discount_price=>discount_price_1} #display 1st 2 records and card
		end
		@tpage = @activity_free.total_pages if !@activity_free.nil? && @activity_free.present?
		@cpage = @activity_free.current_page if !@activity_free.nil? && @activity_free.present? 
		   
	end #qlink end

  def quick_link_result_hot
    session['near_cities'] = nil
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
     search_city = "and (activities.city in #{nearby_cities} or activities.city = '')" 
   else 
     search_city = "and (activities.city like '%#{@search_city}%' or activities.city = '')" 
   end
    cookies[:test_city] = search_city
    if params[:search_type]=="hot-deals"
      #~ result = Activity.includes(:activity_schedule,:user,:activity_price,:activity_discount_price).where("lower(activities.active_status)='active' and lower(users.user_status) != 'deactivate' #{search_city} and activities.cleaned=true and lower(activities.created_by)='provider' and ((activities.price_type='1') or (activities.price_type='2')) and (((date(activity_discount_prices.discount_valid) >= '#{Date.today}') or (activity_discount_prices.discount_valid is null and activity_discount_prices.discount_price is not null)) or (activities.discount_eligible IS NOT NULL)) and activity_schedules.expiration_date >= '#{Date.today}'").order("activities.activity_id desc")
      #~ result = Activity.includes(:activity_schedule,:user,:activity_price,:activity_discount_price).where("lower(activities.active_status)='active' #{search_city} and activity_schedules.expiration_date >= '#{Date.today}' and activity_schedules.expiration_date IS NOT NULL and activities.cleaned=true and lower(activities.created_by)='provider' and (lower(users.user_status)!='deactivate' or users.user_status IS NULL) and ((activities.discount_eligible is not null) or ((activity_discount_prices.discount_valid >= '#{Date.today}') or (activity_discount_prices.discount_valid is null  and (activity_discount_prices.discount_price is not null))))")
      result = Activity.includes(:activity_schedule,:user,:activity_price,:activity_discount_price).where("lower(activities.active_status)='active' #{search_city} and activity_schedules.expiration_date >= '#{Date.today}' and activity_schedules.expiration_date IS NOT NULL and activities.cleaned=true and lower(activities.created_by)='provider' and (lower(users.user_status)!='deactivate' or users.user_status IS NULL) and ((activities.price_type='1') or (activities.price_type='2')) and ((activities.discount_eligible is not null) or ((activity_discount_prices.discount_valid >= '#{Date.today}') or (activity_discount_prices.discount_valid is null  and (activity_discount_prices.discount_price is not null))))").order("activities.city desc")
    elsif params[:search_type]=="favorite"
      #~ result = Activity.includes(:activity_schedule,:user,:activity_price,:activity_discount_price,:activity_favorite).where("lower(activities.active_status)='active' #{search_city} and activities.cleaned=true and lower(activities.created_by)='provider' and activity_favorites.user_id = #{current_user.user_id} and activity_schedules.expiration_date >= '#{Date.today}'").order("activities.activity_id desc") if !current_user.nil?
      result = Activity.includes(:activity_schedule,:user,:activity_price,:activity_discount_price,:activity_favorite).where("lower(activities.active_status)='active' and lower(users.user_status) != 'deactivate' and activities.cleaned=true and lower(activities.created_by)='provider' and activity_favorites.user_id = #{current_user.user_id}") if !current_user.nil?
    elsif params[:search_type]=="free"
      result = Activity.includes(:activity_schedule,:user,:activity_price,:activity_discount_price).where("lower(activities.active_status)='active' and lower(users.user_status) != 'deactivate' #{search_city} and activities.cleaned=true and lower(activities.created_by)='provider' and activities.price_type='3' and activity_schedules.expiration_date >= '#{Date.today}'")
   elsif params[:search_type]=="camp"
      @camps = "Whole Day"
      result = Activity.includes(:activity_schedule,:user,:activity_price,:activity_discount_price).where("lower(activities.active_status)='active' #{search_city} and activities.cleaned=true and lower(users.user_status) != 'deactivate' and lower(activities.created_by)='provider' and (lower(activities.schedule_mode)='#{@camps.downcase.strip}' or activities.sub_category='Camps' or activities.camps = true ) and activity_schedules.expiration_date >= '#{Date.today}'")
    end
    return result
  end

	
	#browse by location method started here
	def browse_by_location
		@accordion = Activity.getcategories(type=0,'')  #get the categories for accordion, type=0 means get list of activity category(both active or inactive)
		@fam_city = City.getcities
		@citygroup = CityGroup.getgroupnames
		#city dynamic values displaying here
		#~ @city_lists = (params[:gid] && params[:gid]!='' && params[:gid].present?) ? (City.getgroupcity(params[:gid])) : (City.getgroupcity('all')) 
		#~ @city_list_all = City.getgroupcity('all')
		
		respond_to do |format|
			format.html
			format.js
		end
	end #browse ending
	
	#browse by category
	def browse_category	
		@search_city = (!cookies[:search_city].nil? ? cookies[:search_city] : "Walnut Creek")
		
		@accordion = Activity.getcategories(type=2,@search_city)  #get the categories for accordion, type=2 means get list of activity category(both active or inactive) with city based
		user_categ = UserProfile.joins(:user).where("users.account_active_status=? and users.user_flag=?",true,true).map(&:category).uniq	 #Users registered with category
		#~ @categories_l = @accordion.map(&:category)
		@categories_l = (@accordion.map(&:category)+user_categ).compact.uniq.sort
		@categories_l.delete("")
		@qlinks = ["Hot Deals", "Free", "Camps"] #qlink displays
		@fam_city = City.getcities
		#choosed category values
		if (params[:categ] && params[:categ]!='' && params[:sub_categ] && params[:sub_categ]!='')		
			@actcatname = ActivityCategory.getcategname(params[:categ])
			@actsubcatname = ActivitySubcategory.getsubcategname(params[:sub_categ])
			user_ids = Activity.get_actsubcatval(@actcatname.downcase,@actsubcatname.downcase,@search_city) if @actcatname && @actsubcatname
			@categories_l = UserProfile.joins(:user).where("users.user_id in (?)",user_ids).order("lower(business_name) asc")
			#~ if !@categories_la.nil? && @categories_la.present?
      #~ @sorted_arr = ((!@categories_la.group_by(&:city)[@search_city].nil?) ? @categories_la.group_by(&:city)[@search_city] : []) #Group by city
      #~ @other_sorted_arr = !@categories_la.blank? && !@sorted_arr.blank? ? @categories_la - @sorted_arr : [] #To get activity apart from selected city
      #~ if (!@sorted_arr.nil? && @sorted_arr.length > 0 ) && (!@other_sorted_arr.nil? && @other_sorted_arr.length > 0 )
      #~ @categories_l = @sorted_arr + @other_sorted_arr
      #~ else
      #~ @categories_l = @categories_la
      #~ end
			#~ end
		elsif(params[:categ] && params[:categ]!='' && !params[:sub_categ].present?)
			@actcatname = ActivityCategory.getcategname(params[:categ]) if params[:categ]
			@categories_l = Activity.get_actsubcatval(@actcatname.downcase,'',@search_city).sort if @actcatname
		end
		
	end
	
	
end #controller ending here
