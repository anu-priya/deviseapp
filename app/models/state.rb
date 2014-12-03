class State < ActiveRecord::Base
  attr_accessible :state_id, :country_id, :state_name, :inserted_date, :modified_date,:state_code
  has_many :cities 
end
