class UserRow < ActiveRecord::Base
  attr_accessible :row_user_id, :inserted_date, :modified_date, :row_id, :user_id, :user_type
end
