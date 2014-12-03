class ActivityComment < ActiveRecord::Base
  attr_accessible :activity_id, :comment_date, :comment_desc, :comment_id, :inserted_date, :modified_date, :user_id
end
