class City < ActiveRecord::Base
  require 'geocoder'
  reverse_geocoded_by :latitude, :longitude
  geocoded_by :city_name
  #~ after_validation :geocode
  #~ after_validation :reverse_geocode
  attr_accessible :city_code, :city_name
  belongs_to :state

  def self.nearby_city_activities(lat,long,city,page)

    #To get current Day Users without activities start
    curr_day_users = User.joins(:user_profile).where("DATE(user_created_date)=? and lower(user_profiles.city)=? and lower(user_plan)=? and show_card=? and account_active_status=? and lower(user_status)!=?",Date.today,"#{city.downcase if !city.nil?}",'sell',true,true,'deactivate').order("user_plan desc").map(&:user_id)
    if curr_day_users  && curr_day_users.present?
      final_curr_day_users = City.getCurrentDayRegUsers(curr_day_users)
      final_curr_day_users_chk = City.format_gsub(final_curr_day_users) if final_curr_day_users && final_curr_day_users.present? && !final_curr_day_users.empty?
      res_sub_query = "u.user_id not in #{final_curr_day_users_chk} and" if final_curr_day_users_chk && !final_curr_day_users_chk.empty? && final_curr_day_users_chk.present?
    end
    #To get current Day Users without activities start

    result = Activity.find_by_sql("select a.* from activities a inner join users u on u.user_id = a.user_id and lower(u.user_status)!='deactivate' inner join activity_schedules act_sc on act_sc.activity_id = a.activity_id inner join activity_total_counts act on a.activity_id=act.activity_id  where (#{res_sub_query if res_sub_query} a.city = '#{city}' and lower(a.active_status)='active' and lower(u.user_plan)='sell' and a.cleaned=true and lower(a.created_by)='provider' and act_sc.expiration_date >= '#{Date.today}') order by u.user_plan desc,act.activity_display_count desc")
    a_count = 0
    group_results = (!result.blank?) ? (result.compact.uniq.group_by(&:user_id) ) : {}
    group_results = City.add_city_providers_to_hash(group_results,final_curr_day_users,'current_day') if final_curr_day_users && final_curr_day_users.present? # To add the current day user cards

    #To get users in current city without activities
    used_user_ids = group_results.keys
    current_city_users = User.joins(:user_profile).where("users.user_id not in (?) and lower(user_profiles.city)=? and lower(user_plan)=? and show_card=? and account_active_status=? and lower(u.user_status)!=?",used_user_ids,"#{city.downcase if !city.nil?}",'sell',true,true,'deactivate').order("user_plan desc").map(&:user_id)
    if current_city_users  && current_city_users.present?
      final_current_city_users = City.getCurrentDayRegUsers(current_city_users)
    end
    group_results = City.add_city_providers_to_hash(group_results,final_current_city_users,'current_city')
    #To get users in current city without activities

    select_city_users = group_results.keys
    city_arr = City.displyCityActivities(group_results,a_count)
    test_arr = city_arr[0]
    test_page = test_arr.paginate(:page => page, :per_page =>20)
    ttl_pages = test_page.total_pages
    if (page <= ttl_pages) #First Load the selected city and then other cities start
      test_arr = test_arr
      other_city_chk = false
    else
      #~ #Other Nearby Cities Listing start
      #~ #Fixed Radius
      re_times = 5
      begin
        a_coord = Geocoder.coordinates("#{city.titlecase},ca")
        radius = 1500
        nearby_cities = self.near(a_coord, radius, :order => :distance).map(&:city_name)
      rescue Exception => e
        re_times-=1
        if re_times>0
          retry
        else
          nearby_cities = ["#{city.titlecase}"]
        end
      end
      #Fixed Radius
      if nearby_cities.length==0
        re_times = 5
        begin
          a_coord = Geocoder.coordinates("Walnut Creek,ca")
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
      end

      nearby_cities = (nearby_cities.count == 1 && nearby_cities[0]==city) ? nearby_cities : nearby_cities.reject{|a| a==city}
      arr_nearby_cities = nearby_cities
      nearby_cities =  City.format_gsub(nearby_cities)

      #Other Nearby Cities Listing end

      #To get current Day Users in other cities without activities start
      curr_day_users = User.joins(:user_profile).where("DATE(user_created_date)=? and lower(user_profiles.city) in (?) and lower(user_plan)=? and show_card=? and account_active_status=? and lower(u.user_status)!=?",Date.today,arr_nearby_cities,'sell',true,true,'deactivate').order("user_plan desc").map(&:user_id)

      if curr_day_users && curr_day_users.present?
        final_curr_day_users = City.getCurrentDayRegUsers(curr_day_users)
        final_curr_day_users_chk = City.format_gsub(final_curr_day_users) if final_curr_day_users && final_curr_day_users.present? && !final_curr_day_users.empty?
        res_sub_query = "u.user_id not in #{final_curr_day_users_chk} and" if final_curr_day_users_chk && !final_curr_day_users_chk.empty? && final_curr_day_users_chk.present?
      end
      #To get current Day Users  in other cities without activities start

      result = Activity.find_by_sql("select a.* from activities a inner join users u on u.user_id = a.user_id and u.user_status !='deactivate' inner join activity_schedules act_sc on act_sc.activity_id = a.activity_id inner join activity_total_counts act on a.activity_id=act.activity_id  where (#{res_sub_query if res_sub_query} a.city in #{nearby_cities} and lower(a.active_status)='active' and lower(u.user_plan)='sell' and a.cleaned=true and lower(a.created_by)='provider' and act_sc.expiration_date >= '#{Date.today}') order by u.user_plan desc,act.activity_display_count desc")
      group_results = (!result.blank?) ? (result.compact.uniq.group_by(&:user_id) ) : {}
      group_results = City.add_city_providers_to_hash(group_results,final_curr_day_users,'current_day') if final_curr_day_users && final_curr_day_users.present? # To add the current day user cards for other cities

      #To get users in current city without activities
      used_user_ids = group_results.keys
      current_city_users = User.joins(:user_profile).where("users.user_id not in (?) and user_profiles.city in (?) and lower(user_plan)=? and show_card=?  and account_active_status=? and lower(user_status)!= ?",used_user_ids,arr_nearby_cities,'sell',true,true,'deactivate').order("user_plan desc").map(&:user_id)
      final_current_city_users = City.getCurrentDayRegUsers(current_city_users) if current_city_users && current_city_users.present?
      group_results = City.add_city_providers_to_hash(group_results,final_current_city_users,'current_city') if final_current_city_users && final_current_city_users.present?
      #To get users in current city without activities

      other_city_users = group_results.keys


      comman_city_users = select_city_users & other_city_users
      !comman_city_users.blank? && comman_city_users.each do |b_del|
        group_results.delete(b_del)
      end
      other_ac_count = ((city_arr && city_arr[1] && !city_arr[1].nil?) ? city_arr[1] : a_count)
      city_arr = City.displyCityActivities(group_results,other_ac_count)
      test_arr = city_arr[0]
      other_city_chk = true
    end #First Load the selected city and then other cities end
    return test_arr,other_city_chk
  end

  #New desing code changes is below
  def self.nearby_city_activities_detail(lat,long,city,page)

    #To get current Day Users without activities start
    curr_day_users = User.includes(:user_profile).where("DATE(user_created_date)=? and lower(user_profiles.city)=? and lower(user_plan)=? and show_card=? and account_active_status=? and lower(user_status)!=?",Date.today,"#{city.downcase if !city.nil?}",'sell',true,true,'deactivate').order("user_plan desc").map(&:user_id)
    if curr_day_users  && curr_day_users.present?
      final_curr_day_users = City.getCurrentDayRegUsers(curr_day_users)
      final_curr_day_users_chk = City.format_gsub(final_curr_day_users) if final_curr_day_users && final_curr_day_users.present? && !final_curr_day_users.empty?
      res_sub_query = "users.user_id not in #{final_curr_day_users_chk} and" if final_curr_day_users_chk && !final_curr_day_users_chk.empty? && final_curr_day_users_chk.present?
    end
    #To get current Day Users without activities start
    result = Activity.includes(:activity_schedule,:activity_total_count,:user,:activity_price).where("#{res_sub_query if res_sub_query} activities.city = '#{city}' and lower(activities.active_status)='active' and lower(users.user_status)!='deactivate' and lower(users.user_plan)='sell' and activities.cleaned=true and lower(activities.created_by)='provider' and activity_schedules.expiration_date >= '#{Date.today}'").order("users.user_plan desc,activity_total_counts.activity_display_count asc")
    #result = Activity.find_by_sql("select a.* from activities a inner join users u on u.user_id = a.user_id inner join activity_schedules act_sc on act_sc.activity_id = a.activity_id inner join activity_total_counts act on a.activity_id=act.activity_id  where (#{res_sub_query if res_sub_query} a.city = '#{city}' and lower(a.active_status)='active' and lower(u.user_plan)='sell' and a.cleaned=true and lower(a.created_by)='provider' and act_sc.expiration_date >= '#{Date.today}') order by u.user_plan desc,act.activity_display_count desc")
    a_count = 0
    group_results = (!result.blank?) ? (result.compact.uniq.group_by(&:user_id) ) : {}
    group_results = City.add_city_providers_to_hash(group_results,final_curr_day_users,'current_day') if final_curr_day_users && final_curr_day_users.present? # To add the current day user cards
	
    #To get users in current city without activities
    used_user_ids = group_results.keys
    current_city_users = User.includes(:user_profile).where("users.user_id not in (?) and lower(user_profiles.city)=? and lower(user_plan)=? and show_card=? and account_active_status=? and lower(users.user_status)!=?",used_user_ids,"#{city.downcase if !city.nil?}",'sell',true,true,'deactivate').order("user_plan desc").map(&:user_id)
    final_current_city_users = City.getCurrentDayRegUsers(current_city_users) if current_city_users  && current_city_users.present?
    group_results = City.add_city_providers_to_hash(group_results,final_current_city_users,'current_city')
    #To get users in current city without activities
	
    select_city_users = group_results.keys
    city_arr = City.displyCityActivities_detail(group_results,a_count,city)
    test_arr = city_arr[0]
    test_page = test_arr.paginate(:page => page, :per_page =>10)
    ttl_pages = test_page.total_pages
    if (page <= ttl_pages) #First Load the selected city and then other cities start
      test_arr = test_arr
      other_city_chk = false
    else
      #~ #Other Nearby Cities Listing start
      #~ #Fixed Radius
      re_times = 5
      begin
        a_coord = Geocoder.coordinates("#{city.titlecase},ca")
	if !a_coord.present?
		chk_city = City.where("lower(city_name)=?",city.downcase).last
		a_coord = []
		a_coord << chk_city.latitude if chk_city && chk_city.latitude
		a_coord << chk_city.longitude if chk_city && chk_city.longitude 
       end
        radius = 150
        nearby_cities = self.near(a_coord, radius, :order => :distance).map(&:city_name)
      rescue Exception => e
        re_times-=1
        if re_times>0
          retry
        else
          nearby_cities = []
          nearby_cities = ["#{city.titlecase}"] if city && city.present?
        end
      end
      #Fixed Radius
      if nearby_cities.length==0
        re_times = 5
        begin
          a_coord = Geocoder.coordinates("Walnut Creek,ca")
	   if !a_coord.present?
		a_coord = [37.9100783,-122.0651819]
	   end
          radius = 100
          nearby_cities = self.near(a_coord, radius, :order => :distance).map(&:city_name)
        rescue Exception => e
          re_times-=1
          if re_times>0
            retry
          else
            nearby_cities = ["#{city.titlecase}"]
          end
        end
      end
      
      nearby_cities = (nearby_cities.count == 1 && nearby_cities[0]==city) ? nearby_cities : nearby_cities.reject{|a| a==city}
      arr_nearby_cities = nearby_cities
      nearby_cities =  City.format_gsub(nearby_cities)
	
      #Other Nearby Cities Listing end

      #To get current Day Users in other cities without activities start
      curr_day_users = User.includes(:user_profile).where("DATE(user_created_date)=? and lower(user_profiles.city) in (?) and lower(user_plan)=? and show_card=? and account_active_status=? and lower(user_status)!=?",Date.today,arr_nearby_cities,'sell',true,true,'deactivate').order("user_plan desc").map(&:user_id)

      if curr_day_users && curr_day_users.present?
        final_curr_day_users = City.getCurrentDayRegUsers(curr_day_users)
        final_curr_day_users_chk = City.format_gsub(final_curr_day_users) if final_curr_day_users && final_curr_day_users.present? && !final_curr_day_users.empty?
        res_sub_query = "users.user_id not in #{final_curr_day_users_chk} and" if final_curr_day_users_chk && !final_curr_day_users_chk.empty? && final_curr_day_users_chk.present?
      end
      #To get current Day Users  in other cities without activities start
      result = Activity.includes(:activity_schedule,:activity_total_count,:user,:activity_price).where("#{res_sub_query if res_sub_query} activities.city in #{nearby_cities} and lower(activities.active_status)='active' and lower(users.user_status)!='deactivate' and lower(users.user_plan)='sell' and activities.cleaned=true and lower(activities.created_by)='provider' and activity_schedules.expiration_date >= '#{Date.today}'").order("users.user_plan desc,activity_total_counts.activity_display_count asc")
      result = result.sort_by{|x| nearby_cities.index x.city}
      # result = Activity.find_by_sql("select a.* from activities a inner join users u on u.user_id = a.user_id inner join activity_schedules act_sc on act_sc.activity_id = a.activity_id inner join activity_total_counts act on a.activity_id=act.activity_id  where (#{res_sub_query if res_sub_query} a.city in #{nearby_cities} and lower(a.active_status)='active' and lower(u.user_plan)='sell' and a.cleaned=true and lower(a.created_by)='provider' and act_sc.expiration_date >= '#{Date.today}') order by u.user_plan desc,act.activity_display_count desc")
      group_results = (!result.blank?) ? (result.compact.uniq.group_by(&:user_id) ) : {}
      group_results = City.add_city_providers_to_hash(group_results,final_curr_day_users,'current_day') if final_curr_day_users && final_curr_day_users.present? # To add the current day user cards for other cities
	
      #To get users in current city without activities
      used_user_ids = group_results.keys
      current_city_users = User.includes(:user_profile).where("users.user_id not in (?) and user_profiles.city in (?) and lower(user_plan)=? and show_card=?  and account_active_status=? and lower(user_status)!=?",used_user_ids,arr_nearby_cities,'sell',true,true,'deactivate').order("user_plan desc").map(&:user_id)
      final_current_city_users = City.getCurrentDayRegUsers(current_city_users) if current_city_users && current_city_users.present?
      group_results = City.add_city_providers_to_hash(group_results,final_current_city_users,'current_city') if final_current_city_users && final_current_city_users.present?
      #To get users in current city without activities

      other_city_users = group_results.keys
	
	
      comman_city_users = select_city_users & other_city_users
      !comman_city_users.blank? && comman_city_users.each do |b_del|
        group_results.delete(b_del)
      end
      other_ac_count = ((city_arr && city_arr[1] && !city_arr[1].nil?) ? city_arr[1] : a_count)
      city_arr = City.displyCityActivities_detail(group_results,other_ac_count,city)
      test_arr = city_arr[0]
      other_city_chk = true
    end #First Load the selected city and then other cities end
    return test_arr,other_city_chk
  end
  
  
  def self.add_city_providers_to_hash(hash,city_prov,chk_arg)#insert card at index pos if keys is available else add the key with its card
    new_hash = {}
    #~ keys=hash.keys  if !hash.nil? && !hash.keys.nil?
    city_prov.each do |prov_id|
      new_hash[prov_id]=[]
    end if !city_prov.nil? && city_prov.present?
    hash = ((chk_arg=='current_day') ? new_hash.merge(hash) : hash.merge(new_hash))
    return hash if !hash.nil?
  end
	  
  def self.displyCityActivities(arr_list,a_count)
    #@week_end_act = Activity.where("activity_id in (?)",[28635,28636,27590,28648,28649,27744,28644,28645,28646,28643,28647,28642,28611,28641,28639,28637,28638,28640,28434,27000,27012,28617,28616,28614]) #uat
    #~ @week_end_act = Activity.where("activity_id in (?)",[3617,3618,3611,3564,3494,3559])
    @weekend_activity = WeekendActivity.get_weekend_activity

    @week_act_id = @weekend_activity.split(",") if !@weekend_activity.nil? && @weekend_activity!=''

    @week_end_act = Activity.where("activity_id in (?) and lower(active_status)=? and cleaned=?",@week_act_id,'active',true).order("activity_id desc") if !@week_act_id.nil? && @week_act_id.present?


	  #~ @week_end_act = Activity.all[0..10] #local
		test_arr = []
    key_test = arr_list.keys
    #looping with provider id old scenario
    key_test.each do |prov|
      card=User.find(prov)
      if arr_list[prov].empty?
        test_arr << card if card.show_card
      else
        #~ test_arr=test_arr.compact.flatten
        test_arr << card if card.show_card
        test_arr << arr_list[prov][0] if (arr_list[prov][0]) #display 1st 2 records and card
        test_arr << arr_list[prov][1] if (arr_list[prov][1])
      end
      if card.show_card
        test_arr << [@week_end_act[a_count]] if !@week_end_act.nil? && @week_end_act[a_count] && !@week_end_act[a_count].nil?
        a_count=a_count+1
      end
			#~ key_test.delete(prov)
    end
		return test_arr.compact.uniq,a_count
	end

  #new design code changes is below
  def self.displyCityActivities_detail(arr_list,a_count,city)
    #@week_end_act = Activity.where("activity_id in (?)",[28635,28636,27590,28648,28649,27744,28644,28645,28646,28643,28647,28642,28611,28641,28639,28637,28638,28640,28434,27000,27012,28617,28616,28614]) #uat
    #~ @week_end_act = Activity.where("activity_id in (?)",[3617,3618,3611,3564,3494,3559])
    @weekend_activity = WeekendActivity.get_weekend_activity_detail(city)

    @week_act_id = @weekend_activity.split(",") if !@weekend_activity.nil? && @weekend_activity!=''

    @week_end_act = Activity.eager_load(:activity_schedule,:user,:activity_price).where("activities.activity_id in (?) and lower(active_status)=? and cleaned=?",@week_act_id,'active',true).order("activities.activity_id desc") if !@week_act_id.nil? && @week_act_id.present?

	  #~ @week_end_act = Activity.all[0..10] #local
		test_arr = []
    key_test = arr_list.keys
    #looping with provider id old scenario
    usr_ids = self.format_gsub(key_test)
    if key_test.length > 0
      test = User.includes(:user_profile).where("users.user_id in #{usr_ids}")
      r = test.sort_by{|x| key_test.index x.user_id}
      r.each do |prov|
        if arr_list[prov.user_id].empty?
          test_arr << {:id=>'user',:usr => prov,:user_pro => prov.user_profile} if prov.show_card
        else
          #~ test_arr=test_arr.compact.flatten
          test_arr << {:id=>'user',:usr => prov,:user_pro => prov.user_profile} if prov.show_card
          if (arr_list[prov.user_id][0])
            status = get_activity_card_purchase_status(arr_list[prov.user_id][0])
            discount_price_1 = nil
            discount_price_1 = ActivityPrice.get_price_details(arr_list[prov.user_id][0].activity_id) if (arr_list[prov.user_id][0].activity_price)
            test_arr << {:id=>'activity',:act=>arr_list[prov.user_id][0],:status=> status,:sched=>arr_list[prov.user_id][0].activity_schedule,:act_usr=>arr_list[prov.user_id][0].user,:price=>arr_list[prov.user_id][0].activity_price,:discount_price=>discount_price_1} if (arr_list[prov.user_id][0]) #display 1st 2 records and card
          end
          if (arr_list[prov.user_id][1])
            status = get_activity_card_purchase_status(arr_list[prov.user_id][0])
            discount_price_2 = nil
            discount_price_2 = ActivityPrice.get_price_details(arr_list[prov.user_id][1].activity_id) if (arr_list[prov.user_id][1].activity_price) if (arr_list[prov.user_id][0].price_type !="3" && arr_list[prov.user_id][0].price_type !="4")
            test_arr << {:id=>'activity',:act=>arr_list[prov.user_id][1],:status=> status,:sched=>arr_list[prov.user_id][1].activity_schedule,:act_usr=>arr_list[prov.user_id][1].user,:price=>arr_list[prov.user_id][0].activity_price,:discount_price=>discount_price_2} if (arr_list[prov.user_id][1])
          end
        end
        if prov.show_card
          if !@week_end_act.nil? && @week_end_act[a_count] && !@week_end_act[a_count].nil?
            weekend_price = @week_end_act[a_count].activity_price
            status = get_activity_card_purchase_status(@week_end_act[a_count])
            discount_price_3 = nil
            discount_price_3 = ActivityPrice.get_price_details(@week_end_act[a_count].activity_id) if (weekend_price) if (@week_end_act[a_count].price_type !="3" && @week_end_act[a_count].price_type !="4")
            test_arr << {:id=>'weekend',:act=>@week_end_act[a_count],:status=> status,:sched=>@week_end_act[a_count].activity_schedule,:act_usr=>@week_end_act[a_count].user,:price=>weekend_price,:discount_price=>discount_price_3}
          end
          a_count=a_count+1
        end
      end
    end
		return test_arr.compact.uniq,a_count
	end

  def self.get_activity_card_purchase_status(activity)

    @today = Time.now.strftime("%Y-%m-%d")

    @str =''
		if !activity.nil? && activity!=''
			#@userid = activity.user_id
			@activity = activity
			#price - advance , net and free goes here
			#~ @act_user = activity.user
			@act_user = User.fetch(@activity.user_id) if @activity && @activity.present? #identity cache
			#@today = Time.now.strftime("%Y-%m-%d")

			if !@activity.nil?
				@schedule = activity.fetch_activity_schedule
				if !@activity.created_by.nil? && @activity.created_by!='' && @activity.created_by.downcase == 'provider'
					if !@act_user.nil?
						if @act_user.user_flag == false
							@str = 'Get Info'
						elsif @act_user.user_flag == true
							if !@activity.nil? && !@activity.purchase_url.nil? && @activity.purchase_url!='' && @activity.purchase_url.present?
								@str = 'Buy Now'
							else
								if @activity.price_type == '4'
									@str = 'Get Info'
								elsif @activity.price_type == '3'
									if @act_user.user_plan.downcase == 'free'  && (@act_user.manage_plan.nil? || @act_user.manage_plan.empty?)
										@str = 'Get Info'
									else
										if !@schedule.nil? && @schedule.present? && @schedule.length > 0
											@str = 'Attend'
										else
											@str = 'Get Info'
										end
									end
								else
									#~ @pro_trans = ProviderTransaction.find_by_sql("select * from provider_transactions where user_id=#{@act_user.user_id} and date(grace_period_date) >= '#{@today}' order by id desc limit 1")
									pro_users = ProviderTransaction.fetch_by_user_id(@act_user.user_id) #identity cache
									@pro_trans = (pro_users.select{|p| p.grace_period_date >= "#{@today}"})


									if !@activity.schedule_mode.nil? && @activity.schedule_mode!='' && (@activity.schedule_mode.downcase == 'by appointment' || @activity.schedule_mode.downcase == 'any where' || @activity.schedule_mode.downcase == 'any time')
										#schedule - anytime, any where and by appoinment goes here
										if @act_user.user_plan.downcase == 'free' && (@act_user.manage_plan.nil? || @act_user.manage_plan.empty?)
											@str = 'Get Info'
										elsif @act_user.user_plan.downcase == 'sell'&& (@act_user.manage_plan.nil? || @act_user.manage_plan.empty?)
											@str = 'Buy Now'
										elsif @act_user.user_plan.downcase == 'sell' && !@act_user.manage_plan.nil? && @act_user.manage_plan != ''
											#check sales limit
											if !@pro_trans.nil? && @pro_trans.present? && @pro_trans.length > 0
												@str = 'Buy Now'
												#~ if !@pro_trans[0].nil? && @pro_trans[0].sales_limit.to_i > @pro_trans[0].purchase_limit.to_i
                        #~ @str = 'Buy Now'
												#~ else
                        #~ @str ='Get Info'
												#~ end
											else
												if @act_user.is_partner == true
													@str = 'Buy Now'
												else
													@str = 'Get Info'
												end

											end
										elsif @act_user.user_plan.downcase == 'curator'
											@str = 'Get Info'
										else
											@str = 'Get Info'
										end
									else
										#schedule - schedule and whole day
										if !@schedule.nil? && @schedule.present? && @schedule.length > 0
											if @act_user.user_plan.downcase == 'free'  && (@act_user.manage_plan.nil? || @act_user.manage_plan.empty?)
												@str = 'Get Info'
											elsif @act_user.user_plan.downcase == 'sell'  && (@act_user.manage_plan.nil? || @act_user.manage_plan.empty?)
												@str = 'Buy Now'
											elsif @act_user.user_plan.downcase == 'sell' && !@act_user.manage_plan.nil? && @act_user.manage_plan != ''
												#check sales limit
												if !@pro_trans.nil? && @pro_trans.present? && @pro_trans.length > 0
													@str = 'Buy Now'
													#~ if !@pro_trans[0].nil? && @pro_trans[0].sales_limit.to_i > @pro_trans[0].purchase_limit.to_i
                          #~ @str = 'Buy Now'
													#~ else
                          #~ @str ='Get Info'
													#~ end
												else
													if @act_user.is_partner == true
														@str = 'Buy Now'
													else
														@str = 'Get Info'
													end
												end
											elsif @act_user.user_plan.downcase == 'curator'
												@str = 'Get Info'
											else
												@str = 'Get Info'
											end
										else
											@str = 'Get Info'
										end
									end
								end
							end
						else
							@str = 'Get Info'
						end
					end

				elsif !@activity.created_by.nil? && @activity.created_by!='' && @activity.created_by.downcase == 'parent'
          if !@schedule.nil? && @schedule.present? && @schedule.length > 0
            @str = 'Buy Now'
          else
            @str = 'Get Info'
          end
				else
					#parent / provider not
					@str = 'Buy Now'
				end

			else
				@str ='invalid'
			end
		else
			@str = 'invalid'
		end
		return @str
	end



  def self.format_gsub(g_val)
    g_val.to_s.gsub("[","(").gsub("]",")").gsub("\"","'")
  end
	
  def self.getCurrentDayRegUsers(user_id_value)
    formated_user_ids = City.format_gsub(user_id_value)
    curr_day_or_city_users_act = Activity.find_by_sql("select a.* from activities a inner join activity_schedules act_sc on act_sc.activity_id = a.activity_id where (a.user_id in #{formated_user_ids} and lower(a.active_status)='active' and a.cleaned=true and act_sc.expiration_date >= '#{Date.today}')").map(&:user_id) if formated_user_ids && formated_user_ids.present? && !formated_user_ids.empty?
    final_curr_day_users = user_id_value - curr_day_or_city_users_act if user_id_value  && user_id_value.present?
  end
  
  def self.getcities
	  cities = City.order(:city_name)
	  return cities
  end
  
  #get the city values for browse by location 
  def self.getgroupcity(gid)
    if gid && gid!='' && gid.present? && gid!="all"
      city = City.where("group_id = ?",gid).map(&:city_name).sort
    elsif gid && gid!='' && gid.present? && gid=="all"
      #~ city = City.where("group_id = ?",1).map(&:city_name).sort
      city = City.order(:city_name).map(&:city_name).sort
    end
    return city
  end
  
  
  
end
