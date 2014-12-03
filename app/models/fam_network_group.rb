class FamNetworkGroup < ActiveRecord::Base
  attr_accessible :fam_group_name, :inserted_date, :modified_date, :user_id
  has_many :messages
end
