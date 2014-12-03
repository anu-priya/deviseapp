class PaymentDetail < ActiveRecord::Base
  attr_accessible :billing_address1, :billing_address2, :card_number, :cardholder_name, :city, :contact_no, :country, :email, :expire_date, :payment_date, :payment_method, :payment_status, :state, :zipcode
end
