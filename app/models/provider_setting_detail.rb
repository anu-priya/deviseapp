class ProviderSettingDetail < ActiveRecord::Base
  attr_accessible :inserted_date, :modified_date, :provider_setting_id, :setting_name, :setting_option, :social_flag
end
