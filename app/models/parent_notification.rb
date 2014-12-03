class ParentNotification < ActiveRecord::Base
  attr_accessible :inserted_date, :modified_date, :notify_flag, :notify_parent_id, :notify_type, :parent_notify_id, :user_id, :notify_by_sms
end
