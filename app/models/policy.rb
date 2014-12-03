class Policy < ActiveRecord::Base
  attr_accessible :name, :content, :modified_date, :inserted_date, :ptype_id

  belongs_to :user
has_many :policy_type
end
