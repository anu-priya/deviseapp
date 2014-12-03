class QuestionType < ActiveRecord::Base
  attr_accessible :description, :type_id, :type_name, :type_value
  
end
