class Form < ActiveRecord::Base
  attr_accessible :created_by_user_id, :created_date, :description, :form_id, :isactive, :title, :updated_by_user_id, :updated_date
   
   has_many :activity_form
   has_many :questions
end
