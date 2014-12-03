class UserChild < ActiveRecord::Base
  attr_accessible :age_range, :child_id, :color, :user_id
  belongs_to :user

end
