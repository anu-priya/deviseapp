class WeekendActivity < ActiveRecord::Base
  attr_accessible :fun_activity, :special_activity,:dd_activity, :inserted_date, :modified_date, :weekend_id, :activity_type, :added_by
  
  #get current week activity
  def self.get_weekend_activity
    @str = ''
    @str1 = ''
    @week_act = WeekendActivity.order("modified_date desc").limit(1)
    if !@week_act.nil? && @week_act.present?
      @week_act.each do |val|
        @str = val.fun_activity + "," + val.special_activity + "," + val.dd_activity
      end
    end
    if @str!=''
      act_ids = @str.gsub('"',"")
      #check activity is expire or not
      @act = Activity.find_by_sql("select a.activity_id as activity_id from activities a left join activity_schedules sch on a.activity_id=sch.activity_id where a.activity_id in (#{act_ids}) and date(sch.expiration_date) >= '#{Time.now.strftime("%Y-%m-%d")}'").map(&:activity_id)
      @str1 = @act.to_s.gsub('[' , "").gsub(']' , "").gsub(' ' , "") if !@act.nil? && @act.present?
    end
    return @str1
  end

  def self.get_weekend_activity_detail(city)
    @str = ''
    @str1 = ''
    group_id = 1
    city_se = City.where("city_name='#{city.gsub(",ca","").gsub(",CA","")}'").last if !city.nil? && city!=""
    group_id = city_se.group_id unless city_se.group_id.nil? if !city_se.nil?
    @week_act = WeekendActivity.where(:group_id=>group_id).order("modified_date desc").limit(1)
    @week_act.each do |val|
        @str = val.fun_activity + "," + val.special_activity + "," + val.dd_activity
      end if !@week_act.nil? && @week_act.present?
    if @str!=''
      act_ids = @str.gsub('"',"")
      #check activity is expire or not
      @act = Activity.find_by_sql("select a.activity_id as activity_id from activities a left join activity_schedules sch on a.activity_id=sch.activity_id where a.activity_id in (#{act_ids}) and date(sch.expiration_date) >= '#{Time.now.strftime("%Y-%m-%d")}'").map(&:activity_id)
      @str1 = @act.to_s.gsub('[' , "").gsub(']' , "").gsub(' ' , "") if !@act.nil? && @act.present?
    end
    return @str1
  end



  def self.add_weekend_activity(fun_activity,special_activity,dd_activity,addedby,group)
    @week = WeekendActivity.new
    @week.fun_activity = fun_activity
    @week.special_activity = special_activity
    @week.dd_activity = dd_activity
    @week.inserted_date = Time.now
    @week.modified_date = Time.now
    @week.group_id = group
    @week.added_by = addedby
    @week.save
  end
  
end
