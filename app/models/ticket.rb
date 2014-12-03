class Ticket < ActiveRecord::Base
  attr_accessible :email_address, :support_type


  def self.get_providertype_zip_code_update(city,zip,date,user_id)

    city_cond = " "

    date_cond = " "

    city_cond = "and lower(city) = '#{city.downcase}'" if city != 0 and city != nil and city != "" and city!='All'

    city_cond = " and zip_code = '#{zip}'" if zip != 0 and zip != nil and zip != ""

    date_cond = "activity_id in(select activity_id from activity_schedules where (start_date in ('#{date}') or (start_date<='#{date}' and end_date >= '#{date}')))" if date != 0 and date != nil and date != ""


    return act = Activity.find_by_sql("select * from activities where #{date_cond} #{city_cond} and user_id =#{user_id} and created_by ='Provider'  order by activity_id desc").uniq
  end


end
