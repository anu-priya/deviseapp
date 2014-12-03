class QuestionValue < ActiveRecord::Base
  attr_accessible :display_order, :field_value, :question_id, :question_value_id, :range_end, :range_start
  
   belongs_to :question
end
