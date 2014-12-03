class ProviderSetting < ActiveRecord::Base
  attr_accessible :contact_user, :inserted_date, :modified_date, :provider_setting_id, :setting_option, :setting_provider_id, :social_id, :user_id
end
