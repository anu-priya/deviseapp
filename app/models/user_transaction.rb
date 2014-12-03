class UserTransaction < ActiveRecord::Base
  attr_accessible :customer_payment_profile_id, :customer_profile_id
  belongs_to :user
end
