class FormResultAnswer < ActiveRecord::Base
  attr_accessible :answer_id, :form_result_id, :question_id, :question_name, :question_value
  
  belongs_to :form_result
  
  #add answer
  def self.add_answer(form_result_id,qid,qname,ans)
	@form_answer = FormResultAnswer.new
	@form_answer.form_result_id = form_result_id
	@form_answer.question_id = qid
	@form_answer.question_name = qname
	@form_answer.question_value =  ans
	@form_answer.save
  end

end
