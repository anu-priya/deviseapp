class Question < ActiveRecord::Base
  attr_accessible :field_name, :question_id, :is_required, :question_type_id, :form_id, :help_text
  
   belongs_to :form
   has_many :question_values
end
