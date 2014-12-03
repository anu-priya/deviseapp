class TransactionDetail < ActiveRecord::Base
  attr_accessible :activity_id, :trans_id, :transaction_id, :user_id, :amount, :payment_status, :payment_date, :inserted_date, :modified_date
end
