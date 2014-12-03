class ProviderTransaction < ActiveRecord::Base
  attr_accessible :transaction_id, :payment_date, :email_address, :plan_amount, :purchase_limit, :sales_limit, :expiry_status, :grace_period_date, :amount, :customer_payment_profile_id, :customer_profile_id, :id, :inserted_date, :modified_date, :user_id, :user_plan, :start_date, :end_date, :action_type
   include IdentityCache
   cache_index :user_id #identity cache
end
