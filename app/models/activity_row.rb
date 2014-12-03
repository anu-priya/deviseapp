class ActivityRow < ActiveRecord::Base
  attr_accessible :inserted_date, :modified_date, :row_type, :subcateg_id, :user_id
end
