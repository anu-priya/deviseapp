class LeadTransaction < ActiveRecord::Base
  attr_accessible :amount, :customer_payment_profile_id, :customer_profile_id, :inserted_date, :lead_id, :lead_trans_id, :modified_date, :payment_date, :payment_message, :payment_status, :transaction_id
end
