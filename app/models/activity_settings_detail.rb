class ActivitySettingsDetail < ActiveRecord::Base
  attr_accessible :info_id, :inserted_date, :modified_date, :user_type, :setting_name, :social_flag
end
