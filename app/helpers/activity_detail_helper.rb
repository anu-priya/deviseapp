module ActivityDetailHelper
  #get the activity details
  def get_activity_det(act_id)
    act_price = ""
    act_price= ActivityPrice.where("activity_id = ?", act_id) if !act_id.nil? && act_id.present?
    return act_price if !act_price.nil? && act_price!="" && act_price.present?
  end
  
  def googlecal_weekly_rep(repeat_days)
    result = ''
    if !repeat_days.nil? && repeat_days.present?
      rep_split = ((repeat_days.class==Array) ? repeat_days : repeat_days.split(',') )
      rep_split.each do |days|
        day = match_days(days)
        result = ((result=='')? result+day : result+','+day) if !day.nil? && day.present?
      end
    end
    return result
  end
  
  
  def googlecal_monthly_rep(started_on)
    result = ''
    if !started_on.nil? && started_on.present?
      my_date =started_on
      week_of_target_date = my_date.strftime("%U").to_i
      week_of_beginning_of_month = my_date.beginning_of_month.strftime("%U").to_i
      repeat_week = (week_of_target_date - week_of_beginning_of_month + 1).to_s
      day_of_week = my_date.strftime("%a")
      day = match_days(day_of_week)
      result = result+repeat_week+day
    end
    return result
  end
 
  def match_days(days)
    if (!days.nil? && days.present?)
      case days.titlecase
      when 'Mon'
        day='MO'
      when 'Tue'
        day='TU'
      when 'Wed'
        day='WE'
      when 'Thu'
        day='TH'
      when 'Fri'
        day='FR'
      when 'Sat'
        day='SA'
      when 'Sun'
        day='SU'
      end
      return day
    end
  end
  
  
    def match_entire_day(days)
    if (!days.nil? && days.present?)
      case days.titlecase
      when 'Mon'
        day='Monday'
      when 'Tue'
        day='Tuesday'
      when 'Wed'
        day='Wednesday'
      when 'Thu'
        day='Thursday'
      when 'Fri'
        day='Friday'
      when 'Sat'
        day='Saturday'
      when 'Sun'
        day='Sunday'
      end
      return day
    end
  end
  
  def format_date_time(date,time)
    res = ''
    if (!date.nil? && !time.nil?)
      res_date = date.strftime("%Y-%m-%d")
      res_time = time.strftime("%H:%M:%S")
      res = res_date+'T'+res_time
    end
    return res
  end
  
  def time_zone_location
    ip_addr = request.remote_ip
    if (!ip_addr.nil? && ip_addr.present?)
      begin
        geo =  GeoIp.geolocation(ip_addr)
        if geo && !geo.nil? && geo[:country_name]!='-'
          time_zone = (!geo[:country_name].nil? ? (geo[:country_name].titlecase=='United States' ? "America/Los_Angeles" : "Asia/Kolkata" ) : "Asia/Kolkata")
        else
          time_zone = "Asia/Kolkata"
        end
      rescue Exception => e
        time_zone = "Asia/Kolkata"
      end
    else
      time_zone = "Asia/Kolkata"
    end
    return time_zone
  end
  
  def check_participants_toAttend(act)
    no_of_participant = act.no_participants
    parti_attended = ActivityAttendDetail.where('activity_id=? and lower(payment_status)=?',act.activity_id,'paid').count
    can_attnd = no_of_participant-parti_attended if(!no_of_participant.nil? && !parti_attended.nil?)
    (no_of_participant.nil? || can_attnd > 0) ? true : false
  end

  #To check pariticipant for schedule
  def check_participants_toAttendSchedule(act)
    no_of_participant = act.no_of_participant
    if no_of_participant!=0 && !no_of_participant.nil?
      can_attnd = selfCheckParti(act)
      (no_of_participant.nil? || (can_attnd  && can_attnd[0] && can_attnd[0] < 1)) ? true : false
    else
      return false
    end
  end

  def capacity_of_participants(act)
    if act && !act.nil? && act.present?
      no_of_participant = act.no_of_participant
      if no_of_participant!=0 && !no_of_participant.nil?
        selfCheckParti(act)
      end
    end
  end


  def selfCheckParti(act)
    parti_attended = (act.schedule_mode.downcase=='any time') ? ActivityAttendDetail.where('activity_id=? and lower(payment_status)=?',act.activity_id,'paid').count : ActivityAttendDetail.where('schedule_id=? and lower(payment_status)=?',act.schedule_id,'paid').count
    can_attnd = act.no_of_participant-parti_attended if(!act.no_of_participant.nil? && !parti_attended.nil?)
    return can_attnd,act.no_of_participant,parti_attended
  end

  def gcal_client_ids
    test_url = "#{request.protocol}#{request.host_with_port}"
    apiKey = 'AIzaSyDi2NlUVaFXOoIQdSg0uLuvEko89UuZiRE'
    scopes = 'https://www.googleapis.com/auth/calendar'
    case test_url
    when 'http://localhost:3000'
      clientId = '718685077630-h9m14pcoirss71f3fma9a62rsfe1psqd.apps.googleusercontent.com'
      updated_time_hour = 0
      updated_time_min = 0
    when 'http://dev.famtivity.com:8080'
      clientId = '718685077630.apps.googleusercontent.com'
      updated_time_hour = 9
      updated_time_min = 30
    when 'http://dev.famtivity.com:3000'
      clientId = '718685077630-4e1kuj30hvb91ohfqb49gt14imstums5.apps.googleusercontent.com'
      updated_time_hour = 9
      updated_time_min = 30
    when 'http://famtivity.com:3000'
      clientId = '718685077630-4ubiatqhrn3vhsm78kf07bnmsp9c96hu.apps.googleusercontent.com'
      updated_time_hour = 5
      updated_time_min = 0
    when 'http://famtivity.com:3005'
      clientId = '718685077630-1mcsb8ntrd8qas2v3p1lhtjki1hndoqa.apps.googleusercontent.com'
      updated_time_hour = 5
      updated_time_min = 0
    when 'https://www.famtivity.com'
      clientId = '718685077630-ga0cre5un7u1dlacc03uu2o7lh5ac8vp.apps.googleusercontent.com'
      updated_time_hour = 5
      updated_time_min = 30
    when 'https://famtivity.com'
      clientId = '718685077630-2reda2mi1en9p2mtf0ulbh82ftbe6uqb.apps.googleusercontent.com'
      updated_time_hour = 5
      updated_time_min = 30
    when 'http://uat.famtivity.com:3000'
      clientId = '718685077630-tpd5ptnktbj484akcpbh36sgmbkm4o67.apps.googleusercontent.com'
      updated_time_hour = 9
      updated_time_min = 30
    end
    return apiKey,clientId,scopes,updated_time_hour,updated_time_min
  end


  def RepeatDisplays(repeat)
    collective_str = ''
    collective_str = ' Repeats '
  
    if repeat.repeats.downcase=='daily'
	  
      if !repeat.repeat_every.nil?
        if repeat.repeat_every=='1'
          test = 'Daily '
        else
          test ='Every '+ repeat.repeat_every+' Days '
        end
        collective_str = collective_str+test
      end

    elsif repeat.repeats.downcase=='weekly'
  
      if !repeat.repeat_every.nil? && repeat.repeat_every=='1'
        test = 'Weekly'
      else
        #~ w_day=repeat.repeat_on.split(",")
        #~ length=w_day.length-1 if !w_day.nil?
        #~ w_day.each_with_index do |wk,i|
          #~ if !wk.nil? && wk!="" && wk.present?
            #~ test =' Every '+((repeat && repeat.repeat_every && !repeat.repeat_every.nil?) ? repeat.repeat_every : '')+' Weeks on '+ ((i==length && !wk.nil?) ? wk+' '  : wk  + " ," )
          #~ end
        #~ end
	test ='Every '+((repeat && repeat.repeat_every && !repeat.repeat_every.nil?) ? repeat.repeat_every : '')+' Weeks'
      end

	w_day=repeat.repeat_on.gsub(',',', ')  if repeat && repeat.repeat_on.present?
          if w_day && !w_day.nil? && w_day.present?
            test = test+' on '+ w_day
          end

      collective_str = collective_str+test
		
    elsif repeat.repeats.downcase=='monthly'
	
      if !repeat.repeat_every.nil? && repeat.repeat_every=='1'
        test = 'Monthly '
      else
        #~ test = 'Every Months on '
	test ='Every '+((repeat && repeat.repeat_every && !repeat.repeat_every.nil?) ? repeat.repeat_every : '')+' Months'
      end
        if repeat.repeated_by_month==TRUE
          test = test+' on '+((!repeat.starts_on.nil?) ? repeat.starts_on.strftime("day %d ") : '')
        else
          my_date = repeat.starts_on
          week_of_target_date = my_date.strftime("%U").to_i
          week_of_beginning_of_month = my_date.beginning_of_month.strftime("%U").to_i
          repeat_week = week_of_target_date - week_of_beginning_of_month + 1
          if repeat_week==1
            spe_day = ' First '
          elsif repeat_week==2
            spe_day = ' Second '
          elsif repeat_week==3
            spe_day = ' Third '
          elsif repeat_week==4
            spe_day = ' Fourth '
          elsif repeat_week==5
            spe_day = ' Fifth '
          end
          test = test+' on '+spe_day+((!repeat.starts_on.nil?) ? repeat.starts_on.strftime("%a") : '')
        end
      collective_str = collective_str+test

    elsif repeat.repeats.downcase=='yearly'
      
      if  !repeat.repeat_every.nil?
        if repeat.repeat_every=='1'
          test = ' Annually'
        else
          test = 'Every '+repeat.repeat_every+' Years'
        end
  
        test = test+' on '+((!repeat.starts_on.nil?) ? repeat.starts_on.strftime("%b %d ") : '')
        collective_str = collective_str+test
      end
   
    end
  
  if !repeat.nil? && !repeat.end_occurences.nil? && repeat.end_occurences!=""
      chk_end_date = (repeat.end_occurences=="1" ? ', Once ' : ', '+repeat.end_occurences+' times ')
  end
  
    #~ if !repeat.nil? && !repeat.ends_never.nil? && repeat.ends_never!="" && repeat.ends_never==true
      #~ chk_end_date = ' Ends Never '
    #~ elsif !repeat.nil? && !repeat.end_occurences.nil? && repeat.end_occurences!=""
      #~ chk_end_date = (repeat.end_occurences=="1" ? ', Once ' : ', '+repeat.end_occurences+' times ')
    #~ elsif !repeat.nil? && !repeat.ends_on.nil? && repeat.ends_on!=""
      #~ chk_end_date = repeat.ends_on.strftime("until %a, %b %d, %Y")
    #~ end
  
    collective_str = (chk_end_date) ? collective_str+chk_end_date : collective_str
    return collective_str
  end
  
  
  #attendees list for require form - fill
  def form_attendees_list(activityid,schedule_mode,scheduleid,userid)
    if !schedule_mode.nil? && schedule_mode!='' && schedule_mode.downcase == 'any time' || schedule_mode.downcase == 'any where' || schedule_mode.downcase == 'by appointment'
      @attend=Participant.find_by_sql("select a.*,p.* from participants p left join activity_attend_details a on p.participant_id=a.participant_id where a.activity_id=#{activityid} and a.user_id=#{userid} and lower(a.payment_status)='paid'")
    else
      @attend=Participant.find_by_sql("select a.*,p.* from participants p left join activity_attend_details a on p.participant_id=a.participant_id where a.activity_id=#{activityid} and a.user_id=#{userid} and a.schedule_id=#{scheduleid} and lower(a.payment_status)='paid'")
    end
    return @attend
  end
  #check participant filled the form or not - use this in activity details page, network page
  def form_filled_participant(activityid,schedule_mode,scheduleid,userid,formid,partid)
    if !schedule_mode.nil? && schedule_mode!='' && schedule_mode.downcase == 'any time' || schedule_mode.downcase == 'any where' || schedule_mode.downcase == 'by appointment'
      @flag=FormResult.find_by_form_id_and_created_by_user_id_and_activity_id_and_participant_id(formid,userid,activityid,partid)
    else
      @flag=FormResult.find_by_form_id_and_created_by_user_id_and_activity_id_and_participant_id_and_schedule_id(formid,userid,activityid,partid,scheduleid)
    end
    return @flag
  end


  #Google Calendar Datas

  def googleCalData(acti_sched)
	
    if acti_sched &&  !acti_sched.nil?
      activity = acti_sched.activity
      schedule = acti_sched
      repeat = schedule.activity_repeat.last if schedule.present? && !schedule.nil?
      if repeat
        set_repeat = 'true'
		    start_form_date = format_date_time(repeat.starts_on,schedule.start_time) if repeat.starts_on.present? && !repeat.starts_on.nil? && schedule && !schedule.start_time.nil?
		    end_form_date =   ((repeat || repeat.ends_never==true || repeat.ends_on.nil?) ? format_date_time(repeat.starts_on,schedule.end_time) : (format_date_time(repeat.ends_on,schedule.end_time) if repeat.ends_on.present? && !repeat.ends_on.nil? && schedule && !schedule.end_time.nil?))
    
        rep_end_date = repeat.ends_on.strftime("%Y%m%dT%H%M%SZ") if repeat.ends_on.present? && !repeat.ends_on.nil?
        repeat_occur = repeat.repeats.upcase if repeat.repeats.present? && !repeat.repeats.nil?
        repeat_end_occur = repeat.end_occurences if repeat.end_occurences.present? && !repeat.end_occurences.nil?
        repeat_every_occur = repeat.repeat_every if repeat.repeat_every.present? && !repeat.repeat_every.nil?
		
        if repeat && repeat_occur=='WEEKLY'
          daily_rep_on = googlecal_weekly_rep(repeat.repeat_on)  if repeat.repeat_on.present? && !repeat.repeat_on.nil? && !repeat.repeat_on.empty?
        elsif repeat && repeat_occur=='MONTHLY'
          daily_rep_on = googlecal_monthly_rep(repeat.starts_on) if repeat.starts_on.present? && !repeat.starts_on.nil? &&  repeat.repeated_by_month==FALSE
        end
		     
      elsif schedule.present? && !schedule.nil?
        set_repeat = 'false'
        if schedule && schedule.schedule_mode.titlecase=='Any Time'
          set_repeat = 'true'
				  if schedule.business_hours.present? && !schedule.business_hours.nil? && !schedule.business_hours.empty? 
            any_time_busi_hours = activity.activity_schedule.map(&:business_hours)
            repeat_occur = 'WEEKLY'
            daily_rep_on = googlecal_weekly_rep(any_time_busi_hours)
          else
            repeat_occur = 'DAILY'
          end
        end
			
        if schedule && !schedule.start_date.nil? && schedule.end_date.nil?
			    act_end_date = schedule.start_date if schedule && schedule.start_date.present? && !schedule.start_date.nil?
			    act_start_date = schedule.start_date if schedule && schedule.start_date.present? && !schedule.start_date.nil?
        elsif schedule && schedule.start_date.nil? && !schedule.end_date.nil?
          act_end_date = schedule.end_date if schedule && schedule.end_date.present? && !schedule.end_date.nil?
          act_start_date = schedule.end_date if schedule && schedule.end_date.present? && !schedule.end_date.nil?
        elsif schedule && !schedule.start_date.nil? && !schedule.end_date.nil?
          act_end_date = schedule.end_date if schedule && schedule.end_date.present? && !schedule.end_date.nil?
			    act_start_date = schedule.start_date if schedule && schedule.start_date.present? && !schedule.start_date.nil?
        else
	   if acti_sched && acti_sched.schedule_mode.titlecase=='Any Time'
		 anytime_date = ((any_time_busi_hours.class==Array) ? any_time_busi_hours : any_time_busi_hours.split(',') )
		 any_schedules = activity.activity_schedule
		 week_days = ['mon','tue','wed','thu','fri','sat','sun']
		 anytime_schdle = []
		 week_days.each do |day|
			 sch = any_schedules.select{|x| x.business_hours==day}
			 anytime_schdle << sch
		 end
		anytime_schdle = anytime_schdle.flatten.compact
                 if anytime_date.count > 1
			i=0
			begin
			  any_d = anytime_schdle[i]
			  chk_any = getDate_for_anytime(any_d.business_hours,any_d.start_time,any_d.end_time)
			  if any_d && any_d.present? && chk_any[0]==true
			  test_arr = chk_any[1] 
			  end
			  i=i+1
			end while !(i>(anytime_schdle.count-1) || chk_any[0]==true)
			if chk_any && chk_any[0]==false
				test_arr = getDate_for_anytime(anytime_schdle.first.business_hours,anytime_schdle.first.start_time,anytime_schdle.first.end_time)[1] 
				any_d = anytime_schdle.first
			end 
		 else
			 test_arr = getDate_for_anytime(anytime_schdle.first.business_hours,anytime_schdle.first.start_time,anytime_schdle.first.end_time)[1] if anytime_date && anytime_date.present?
			 any_d = anytime_schdle.first
		 end
		act_date = test_arr
	   else
             act_end_date = Time.now
             act_start_date = Time.now
	   end
        end
			  if acti_sched && acti_sched.schedule_mode.titlecase=='Any Time'
				start_form_date = format_date_time(act_date,any_d.start_time) if (act_date && !act_date.nil? && any_d && any_d.present? && any_d.start_time.present?)
				end_form_date = format_date_time(act_date,any_d.end_time) if (act_date && !act_date.nil? && any_d && any_d.present? && any_d.end_time.present?)
			  else
				start_form_date = format_date_time(act_start_date,schedule.start_time) if (schedule && !act_start_date.nil? && !schedule.start_time.nil?)   
				end_form_date = format_date_time(act_end_date,schedule.end_time) if (schedule && !act_end_date.nil? && !schedule.end_time.nil?) 
			  end
     else
        if acti_sched && acti_sched.schedule_mode.titlecase=='Any Time'
		      set_repeat = 'true'
		      repeat_occur = 'DAILY'
        end
end
			start_date = Time.parse(start_form_date).utc.to_i*1000 if start_form_date && !start_form_date.nil?
			end_date = Time.parse(end_form_date).utc.to_i*1000 if end_form_date && !end_form_date.nil?
      return start_date,end_date, rep_end_date,repeat_occur,set_repeat,repeat_end_occur,repeat_every_occur,daily_rep_on
    end
  end


def getDate_for_anytime(day_abbr,str_time,end_time)
	 get_whole_day = match_entire_day(day_abbr)
	 anytime_sdate = DateTime.parse(get_whole_day)
	 #~ curr_date = DateTime.now
	 curr_date_server = DateTime.now
	 get_correct_time = getCorrectTime(curr_date_server)
	 curr_date = (!get_correct_time.nil? && get_correct_time.present?) ? get_correct_time : curr_date_server
	 curr_date_formate = DateTime.parse(curr_date.strftime("%d-%m-%Y"))
	 anytime_date_formate = DateTime.parse(anytime_sdate.strftime("%d-%m-%Y"))
	 curr_time_formate = Time.parse(curr_date.strftime("%H:%M"))
	 strt_time_formate = Time.parse(str_time.strftime("%H:%M"))
	 end_time_formate = Time.parse(end_time.strftime("%H:%M"))
	 #result =  (((curr_date_formate <= anytime_date_formate) && (curr_time_formate > strt_time_formate) && (curr_time_formate < end_time_formate)) ? true : false)
        if (curr_date_formate < anytime_date_formate)
		result = true
        elsif (curr_date_formate == anytime_date_formate)
              result = (((curr_time_formate > strt_time_formate) && (curr_time_formate < end_time_formate)) ? true : false)
        else
		result = false
        end

	 if (curr_date_formate > anytime_date_formate)
		 final_anydate = anytime_sdate+7.days
	 else
               if (curr_date_formate == anytime_date_formate)
		 final_anydate = ((curr_time_formate > strt_time_formate) && (curr_time_formate < end_time_formate)) ? anytime_sdate : anytime_sdate+7.days
               else
               final_anydate = anytime_sdate
               end
	 end
	 return result,final_anydate
 end
 
 
 def getCorrectTime(time)
	 my_path=request.protocol+request.host
	 case my_path
	 when 'http://dev.famtivity.com'
		get_time = time+10.hours-8.minutes
	 when 'http://uat.famtivity.com'
		get_time = time+10.hours-21.minutes
	 when ('https://www.famtivity.com') || ('https://famtivity.com') || ('http://famtivity.com') || ('http://www.famtivity.com')
		get_time = time+5.hours+25.minutes
	 end
	 get_time
#~ Dev -    +10.hours-8.minutes
#~ Uat -     +10.hours-21.minutes
#~ Live -    +5.hours+25.minutes
end

  #To display price
  def SchedulePrice(sched)
    if sched.present?
      act_prices = sched.activity_prices
      count = (!act_prices.nil?) ? act_prices.count : 0
      price = act_prices.last
      return count,price
    end
  end

  #To display price for AnyTime
  def SchedulePriceAnyTime(act)
    if act.present?
      act_prices = ActivityPrice.where("activity_id=?",act.activity_id)
      count = (!act_prices.nil?) ? act_prices.count : 0
      price = act_prices.last
      return count,price
    end
  end





  #To display address
  def ActivityAddress(act)
    if !act.nil? && !act.user_id.nil?
      user = User.find(act.user_id)
      user_profile = user.user_profile
      addrss1 = (!user_profile.nil? && !act.nil?) ? (!user_profile.business_name.nil? ? user_profile.business_name+', ' : '') : ''
      addrss2 = (!act.address_1.nil? ? act.address_1+', ' : '')+(!act.address_2.nil? && act.address_2.present? ? ', '+act.address_2 : '')
      addrss3 = (!act.nil?) ? (!act.city.nil? ? act.city+', ' : '')+(!act.state.nil? ? act.state : '') : ''
      return addrss1, addrss2, addrss3
    end
  end

#For provider side - Detail Page start
  #To display price detail
  def MultiPrice(p)
    if !p.nil?
      if p.payment_period =="Class Card"
        pay_calss = "Class Card"
        if p.no_of_class == "1"
          pay_calss_value = "(#{p.no_of_class} Class)"
        else
          pay_calss_value = "(#{p.no_of_class} Classes)"
        end
      elsif p.payment_period=="Per Class"
        if p.no_of_class== "1"
          pay_calss = "#{p.no_of_class} Day"
        else
          pay_calss = "#{p.no_of_class} Days"
        end
      elsif p.payment_period =="Per Session"
        hour = ""
        if !p.no_of_hour.nil?
          hour = "#{p.no_of_hour} hours"
        end
        pay_calss = "Per Session (#{p.no_of_class} days #{hour}) "
      elsif p.payment_period =="Per Hour"
        if p.no_of_class == "1"
          pay_calss = "#{p.no_of_class} Hour"
        else
          pay_calss = "#{p.no_of_class} Hours"
        end
      elsif p.payment_period=="Weekly"
        if p.no_of_class == "1"
          pay_calss = "#{p.no_of_class} Week"
        else
          pay_calss = "#{p.no_of_class} Weeks"
        end
      elsif p.payment_period =="Monthly"
        if p.no_of_class == "1"
          pay_calss = "#{p.no_of_class} Month"
        else
          pay_calss = "#{p.no_of_class} Months"
        end
      elsif p.payment_period =="Yearly"
        if p.no_of_class== "1"
          pay_calss = "#{p.no_of_class} Year"
        else
          pay_calss = "#{p.no_of_class} Years"
        end
      end
      #~ discount = Displaydiscount(p)
      return pay_calss,pay_calss_value
    end
  end

  def Displaydiscount(act_price)
    if !act_price.nil?
      act_discount = act_price.activity_discount_price.last
      #~ if !act_discount.nil? && !act_discount.discount_type.nil? && !act_discount.discount_currency_type.nil? && !act_discount.discount_number.nil?
			#~ dis_name = act_discount.discount_type
			#~ dis_value = act_discount.discount_currency_type+act_discount.discount_price.to_s+' off '  number_with_precision p.price, :precision => 2
			#~ disc_val = ' for '+act_discount.discount_number.to_s+' Participants '
			#~ disc_val = (act_discount.discount_type.downcase=='early bird discount') ?  disc_val+', until'+act_discount.discount_valid.strftime("%a, %b %d, %Y") : disc_val
		  #~ return dis_name,dis_value,disc_val
      #~ end
      ShowDiscount(act_discount)
    end
  end


  def ShowDiscount(act_discount)
		if !act_discount.nil? && !act_discount.discount_type.nil?
			dis_name = act_discount.discount_type
			dis_value = ((!act_discount.discount_currency_type.nil? && act_discount.discount_currency_type == '$') ? '$' : '')+ (number_with_precision act_discount.discount_price, :precision => 2)+((!act_discount.discount_currency_type.nil? && act_discount.discount_currency_type == '%') ? '%' : '')+' off '
			if !act_discount.discount_number.nil?
        disc_val = ' for '+act_discount.discount_number.to_s+((!act_discount.discount_type.nil? && act_discount.discount_type.downcase=='multiple session discount') ? ' Sessions ' : ' Participants')
      end
      if !act_discount.discount_valid.nil? && !act_discount.discount_number.nil?
      	disc_val = (act_discount.discount_type.downcase) ?  disc_val+', until '+((!act_discount.discount_valid.nil?) ? act_discount.discount_valid.strftime("%a, %b %d, %Y") : '') : disc_val
      elsif !act_discount.discount_valid.nil?
        disc_val = 'until '+((!act_discount.discount_valid.nil?) ? act_discount.discount_valid.strftime("%a, %b %d, %Y") : '')
      end
      return dis_name,dis_value,disc_val
		end
  end



  #To check for discount display
  def ChecForDiscount(sched_id)
    acti_prices= ActivityPrice.where("activity_schedule_id=?",sched_id)
    disc_present = false
    acti_prices.each do |ac_pri|
      if ac_pri.activity_discount_price.present?
        disc_present=true
      end
    end
    return disc_present
  end

  #To check for discount display for AnyTime
  def ChecForDiscountAnyTime(act_id)
    acti_prices= ActivityPrice.where("activity_id=?",act_id)
    disc_present = false
    acti_prices.each do |ac_pri|
      if ac_pri.activity_discount_price.present?
        disc_present=true
      end
    end
    return disc_present
  end

  def AnyTimeSchedule(act)
    act_schedules = act.activity_schedule.where("lower(schedule_mode)=?",'any time')
    if act_schedules.present?
      list_arr = []
      added_days = []
      total_days = ['mon','tue','wed','thu','fri','sat','sun']
      act_schedules.each do |a_sc|
        added_days << a_sc.business_hours
        any_format = a_sc.business_hours.titlecase+', '+((!a_sc.start_time.nil?) ? a_sc.start_time.strftime("%l:%M %p") : '')+'-'+((!a_sc.end_time.nil?) ? a_sc.end_time.strftime("%l:%M %p") : '')
        list_arr << any_format
      end
      closed_days = (total_days.present? && added_days.present?) ? total_days-added_days : ''
      clos_str = ''
      closed_days && closed_days.each do |c_day|
        clos_str = (clos_str=='') ? clos_str.concat(c_day.titlecase) : clos_str.concat(','+c_day.titlecase)
      end
      return list_arr,clos_str
    end
  end
#For provider side - Detail Page end

#event calendar get repeat on days
def match_calendar_day(day)
if day && day.present?
      case day.titlecase
      when 'Mon'
        day=:monday
      when 'Tue'
        day=:tuesday
      when 'Wed'
        day=:wednesday
      when 'Thu'
        day=:thursday
      when 'Fri'
        day=:friday
      when 'Sat'
        day=:saturday
      when 'Sun'
        day=:sunday
      end
      return day
end
end

#Event calendar in Detail page
def event_calendar_data(schedule,act)
	if schedule &&  !schedule.nil?
		whole_days = false
		repeat = schedule.activity_repeat.last if schedule.present? && !schedule.nil?
		start_date = schedule.start_date
		end_date = schedule.expiration_date
		if schedule.schedule_mode.downcase == 'schedule'
			if repeat
				repeat_every = repeat.repeat_every.to_i
				 if repeat.repeats == "Daily"
					whole_days = true
					date = []
					date << start_date
					date << end_date
				 elsif repeat.repeats == "Yearly"
					r = Recurrence.new(:every => :year,:starts =>start_date, :on => [start_date.strftime("%m").to_i, start_date.strftime("%d").to_i],:until => end_date,:interval=>repeat_every)
				 elsif repeat.repeats == "Weekly"
					 rep_on = repeat.repeat_on.split(',')
					 repeat_on = rep_on.select!{|x| !x.nil?}
					 repeat_on = rep_on.collect{|s| match_calendar_day(s)}.compact if rep_on && rep_on.present? && !rep_on.empty?
					 r = Recurrence.new(:every => :week, :on => repeat_on,:starts =>start_date,:until => end_date,:interval=>repeat_every) if repeat_on && repeat_on.present? && !repeat_on.empty? && end_date && end_date.present?
				 elsif repeat.repeats == "Monthly"
					 if repeat.repeated_by_month
						 w_date = start_date.strftime("%d")  if !start_date.nil?
						 r = Recurrence.new(:every => :month,:starts =>start_date, :on => w_date.to_i,:until => end_date, :interval => repeat_every)
					 else
						s = Activity.week_of_month_for_date(start_date)
						w_day = start_date.strftime("%A")  if !start_date.nil?
						if s == 1
						se = :first
						elsif s==2
						se = :second
						elsif s==3
						se = :third
						elsif s>=4
						se = :last
						end
						 r = Recurrence.new(:every => :month,:starts =>start_date, :on => se,  :weekday =>:"#{w_day.downcase}" ,:until => end_date, :interval => repeat_every)
					 end
				 end
				 date = r.events if date.nil? && r && r.events
			 else
				 date = ["#{start_date}"]
			 end
		 elsif schedule.schedule_mode.downcase == 'whole day'
			 if schedule.end_date.nil?
				 date = ["#{start_date}"]
			 else
				 whole_days = true
				 date = []
				 date << start_date
				 date << end_date
			 end
		elsif schedule.schedule_mode.downcase == 'any time'
			rep_on = act.fetch_activity_schedule.where("lower(schedule_mode)=?",'any time').map(&:business_hours)
			repeat_on = rep_on.select!{|x| !x.nil?}
			repeat_on = rep_on.collect{|s| match_calendar_day(s)} if rep_on && rep_on.present? && !rep_on.empty?
			r = Recurrence.new(:every => :week, :on => repeat_on,:until => end_date,:interval=>1) if repeat_on && repeat_on.present? && !repeat_on.empty? && end_date && end_date.present?
			date = r.events if r && r.events
		 end
	 end
	 return date,whole_days
end

end
