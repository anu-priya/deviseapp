class ActivityRating < ActiveRecord::Base
  attr_accessible :activity_id, :inserted_date, :modified_date, :rating_count, :rating_id, :user_id
end
