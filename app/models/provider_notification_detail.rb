class ProviderNotificationDetail < ActiveRecord::Base
  attr_accessible :inserted_date, :modified_date, :notify_name, :notify_type, :provider_notify_id, :notify_status
end
