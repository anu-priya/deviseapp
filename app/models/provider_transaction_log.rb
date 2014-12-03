class ProviderTransactionLog < ActiveRecord::Base
  attr_accessible :email_address, :amount, :action_type, :customer_payment_profile_id, :customer_profile_id, :id, :inserted_date, :modified_date, :payment_date, :payment_message, :payment_status, :transaction_id, :user_id
end
