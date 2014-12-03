class FollowingUser < ActiveRecord::Base
  attr_accessible :follow_id, :follow_user_id, :inserted_date, :modified_date, :user_id
end
