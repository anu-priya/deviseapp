class FormResult < ActiveRecord::Base
  attr_accessible :created_by_user_id, :created_date, :form_id, :form_title, :form_result_id, :updated_by_user_id, :updated_date
  
  has_many :activity_result_answers
  
end
