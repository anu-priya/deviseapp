class ActivityRepeat < ActiveRecord::Base
  attr_accessible :activity_schedule_id, :ends_never, :end_occurences, :ends_on, :modified_date, :repeat_every, :repeat_id, :repeat_on, :repeated_by_month, :repeats, :starts_on

  belongs_to :activity_schedule

end
