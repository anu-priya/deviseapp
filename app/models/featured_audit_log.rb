class FeaturedAuditLog < ActiveRecord::Base
  attr_accessible :activity_id, :inserted_date, :modified_date, :user_id, :user_name
end
