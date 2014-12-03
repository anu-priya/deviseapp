class BlockUser < ActiveRecord::Base
  attr_accessible :email, :inserted_date, :modified_date, :name, :user_id
end
