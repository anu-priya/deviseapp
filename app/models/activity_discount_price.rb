class ActivityDiscountPrice < ActiveRecord::Base
  attr_accessible :discount_currency_type, :discount_number, :discount_price, :discount_type, :discount_valid,:provider_discount_type_id
  belongs_to :activity_price
end
