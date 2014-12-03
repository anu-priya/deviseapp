class ProviderNotification < ActiveRecord::Base
  attr_accessible :inserted_date, :modified_date, :notify_flag, :notify_provider_id, :notify_type, :provider_notify_id, :user_id, :notify_by_sms
end
