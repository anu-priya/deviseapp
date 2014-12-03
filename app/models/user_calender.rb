class UserCalender < ActiveRecord::Base
  attr_accessible :activity_id, :calender_id, :inserted_date, :modified_date, :user_id
end
