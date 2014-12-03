class ParentSetting < ActiveRecord::Base
  attr_accessible :contact_user, :inserted_date, :modified_date, :parent_setting_id, :setting_option, :setting_parent_id, :social_id, :user_id
end
