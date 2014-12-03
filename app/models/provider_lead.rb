class ProviderLead < ActiveRecord::Base
  attr_accessible :activity_id, :amount, :customer_id, :inserted_date, :lead_id, :modified_date, :payment_status, :user_id, :user_plan, :message
end
