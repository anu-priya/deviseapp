class DeletedSchedule < ActiveRecord::Base
  belongs_to :activity
  belongs_to :activity_schedule
end

