class AdminDiscountCode < ActiveRecord::Base
  attr_accessible :discount_code, :discount_name,:discount_max, :discount_amount
  validates_uniqueness_of :discount_code, :case_sensitive => false
end
