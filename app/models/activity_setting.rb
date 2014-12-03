class ActivitySetting < ActiveRecord::Base
  attr_accessible :info_id, :inserted_date, :modified_date, :setting_id, :social_id, :type_id, :user_id, :contact_user, :user_type
end
