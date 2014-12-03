class ActivitySchedule < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  attr_accessible  :note,:price_type,:no_of_participant, :schedule_status, :expiration_date,:activity_id, :end_date, :end_time, :business_hours, :modified_date, :repeat, :schedule_id, :schedule_mode, :start_date, :start_time
  include IdentityCache
  belongs_to :activity
  has_many :activity_repeat
  cache_has_many :activity_repeat,:embed=>true
  has_many :activity_prices
  cache_has_many :activity_prices,:embed=>true
  has_many :deleted_schedules
  
  # applied identity cache for queries
  class << self
  
   #~ #To display price
  def SchedulePrice(sched)
    if sched.present?
      act_prices = sched.fetch_activity_prices
      count = (!act_prices.nil?) ? act_prices.count : 0
      price = act_prices.last
      return count,price
    end
  end

  #~ #To display price for AnyTime
  def SchedulePriceAnyTime(act)
    if act.present?
      #act_prices = ActivityPrice.where("activity_id=?",act.activity_id)
      act_prices = ActivityPrice.fetch_by_activity_id(act.activity_id)
      count = (!act_prices.nil?) ? act_prices.count : 0
      price = act_prices.last
      return count,price
    end
  end


  #~ #To display address
  def ActivityAddress(act)
    if !act.nil? && !act.user_id.nil?
      #user = User.find(act.user_id)
      user = User.fetch(act.user_id)
      user_profile = user.fetch_user_profile
      addrss1 = (!user_profile.nil? && !act.nil?) ? (!user_profile.business_name.nil? ? user_profile.business_name+', ' : '') : ''
      addrss2 = (!act.address_1.nil? ? act.address_1+', ' : '')+(!act.address_2.nil? && act.address_2.present? ? ', '+act.address_2 : '')
      addrss3 = (!act.nil?) ? (!act.city.nil? ? act.city+', ' : '')+(!act.state.nil? ? act.state : '') : ''
      return addrss1, addrss2, addrss3
    end
  end

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
      #discount = Displaydiscount(p)
      return pay_calss,pay_calss_value
    end
  end

  #~ def Displaydiscount(act_price)
    #~ if !act_price.nil?
      #~ act_discount = act_price.fetch_activity_discount_price.last
      #~ ShowDiscount(act_discount)
    #~ end
  #~ end


  def ShowDiscount(act_discount)
		if !act_discount.nil? && !act_discount.discount_type.nil?
			dis_name = act_discount.discount_type
			dis_value = ((!act_discount.discount_currency_type.nil? && act_discount.discount_currency_type == '$') ? '$' : '')+ ("#{(ActionController::Base.helpers.number_with_precision act_discount.discount_price, :precision => 2).gsub(/\.00$/, "")}")+((!act_discount.discount_currency_type.nil? && act_discount.discount_currency_type == '%') ? '%' : '')+' off '
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
  def ChecForDiscount(sched_id,act_id,act_sched)
    #~ acti_prices= ActivityPrice.where("activity_schedule_id=?",sched_id)
    acti_prices= ((act_sched =='any time') || (act_sched =='by appointment')) ? (ActivityPrice.fetch_by_activity_id(act_id)) : (ActivityPrice.fetch_by_activity_schedule_id(sched_id))    
    test_price = []
    acti_prices.each do |ac_pri|
     dis_price = ac_pri.fetch_activity_discount_price
      if dis_price.present?
	dis_price.each do |dprice|
	    if !dprice.nil? && !dprice.discount_valid.nil?
		    early_bird_date = dprice.discount_valid.strftime("%Y-%m-%d") 
		    max_date = early_bird_date if !early_bird_date.nil? && early_bird_date.present? && early_bird_date!=""
		    cday = Time.now.strftime("%Y-%m-%d")
		    if !early_bird_date.nil? && early_bird_date.present? && early_bird_date >= cday
			test_price << dprice
		    end
	    elsif !dprice.nil? && dprice.discount_valid.nil?
		   test_price << dprice
            end
	end
	end
    end
    return test_price
  end


  def AnyTimeSchedule(act)
    act_schedules = act.fetch_activity_schedule.where("lower(schedule_mode)=?",'any time')
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
  
 #Any time for New Detail page 
 def AnyTimeScheduleDisplay(act)
    #~ act_schedules = act.fetch_activity_schedule.where("lower(schedule_mode)=?",'any time')
    act_schedules = act.fetch_activity_schedule.where("lower(schedule_mode)=?",'any time')
    if act_schedules.present?
      list_arr = []
      added_days = []
      total_days = ['mon','tue','wed','thu','fri','sat','sun']
      act_schedules.each do |a_sc|
        added_days << a_sc.business_hours
        any_format = a_sc.business_hours.titlecase+', '+((!a_sc.start_time.nil?) ? a_sc.start_time.strftime("%l:%M %p") : '')+' - '+((!a_sc.end_time.nil?) ? a_sc.end_time.strftime("%l:%M %p") : '')
        list_arr << any_format
      end
      closed_days = (total_days.present? && added_days.present?) ? total_days-added_days : ''
      return list_arr,closed_days
    end
  end
  
def AnyTimeDetailDisplay(act)
	any_schedules = act.fetch_activity_schedule.where("lower(schedule_mode)=?",'any time')
end

end
  
end
