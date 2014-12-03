class ParentNotificationDetail < ActiveRecord::Base
  attr_accessible :inserted_date, :modified_date, :notify_id, :notify_name, :notify_type, :notify_status
end
