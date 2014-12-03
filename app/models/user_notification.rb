class UserNotification < ActiveRecord::Base
  attr_accessible :inserted_date, :modified_date, :notify_id, :user_id, :user_notify_id, :notify_flag, :user_type
end
