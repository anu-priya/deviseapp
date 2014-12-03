class ActivityClick < ActiveRecord::Base
  attr_accessible :user_type,:no_of_clicks,:modified_date,:device_id,:activity_id,:no_of_attempts,:click_date
end
