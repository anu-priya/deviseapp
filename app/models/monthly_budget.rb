class MonthlyBudget < ActiveRecord::Base
  attr_accessible :inserted_at, :modified_at, :monthly_budget, :user_id,:bid_amount, :attempt_amount
end
