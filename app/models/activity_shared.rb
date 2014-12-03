class ActivityShared < ActiveRecord::Base
  attr_accessible :activity_id, :message, :shared_id, :shared_to, :subject, :user_id, :inserted_date, :share_id
  belongs_to :activity
end
