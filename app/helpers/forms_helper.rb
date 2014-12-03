module FormsHelper

#get question and helptext , type
def get_question_details(questionid)
	@question =Question.find_by_sql("select * from questions q left join question_types qt on q.question_type_id =qt.type_id where q.question_id=#{questionid.to_i} order by q.question_id")
	return @question
end

#get option value
def get_question_option(questionid)
	@question_option =QuestionValue.where("question_id=?",questionid.to_i).order("display_order")
	return @question_option
end

#get type in preview page
def get_type_details(typeid)
	@question_type = QuestionType.find_by_type_id(typeid)
	return @question_type
end

#get form details - in police page
def get_form_details(userid)
	@form=Form.where("created_by_user_id=? and isactive=true",userid).order("form_id desc")	
	return @form
end
#get form details both vendoe and representative - in provider list page
def get_vr_form_details(userid,activityid)
	#activity represented to other user - get both vendor  and represented user form list
	@school_rep = SchoolRepresentative.find_by_activity_id(activityid)
	if !@school_rep.nil? && @school_rep.present?
		@vendor_id = @school_rep["vendor_id"]		
		if !current_user.nil? && current_user.user_id == @vendor_id
			@form=Form.where("(created_by_user_id=? or created_by_user_id=?) and isactive=true",userid,@school_rep["vendor_id"]).order("form_id desc")
		else			
			@form=Form.find_by_sql("select * from forms where form_id in (select distinct(form_id) from activity_forms where activity_id=#{activityid}) or (created_by_user_id=#{userid} and isactive=true) order by form_id desc")
		end		
	else
		#owner form list
		@form=Form.where("created_by_user_id=? and isactive=true",userid).order("form_id desc")
	end	
	return @form
end
	
#get assigned form id  count- in provider list page
def assigned_activity_form(activityid)	
	@act_form_count=ActivityForm.select("form_id").where("activity_id=? and active_status=true",activityid).map(&:form_id)
	return @act_form_count.length
end
#check form is assigned or not  - in provider list page
def assigned_activity_form_details(activityid,formid)	
	@act_form=ActivityForm.where("activity_id=? and form_id= ? and active_status=true",activityid,formid)
	if !@act_form.nil? && @act_form.present?		
		return true
	else
		return false
	end
end

#check form is assigned or not  - in provider list page
def assigned_activity_form_details_policy(activityid,policy_file_id)	
	@act_form=ActivityForm.where("activity_id=? and policy_file_id= ? and active_status=true",activityid,policy_file_id)
	if !@act_form.nil? && @act_form.present?		
		return true
	else
		return false 
	end
end

#get assigned activity form name list - checkout page
def form_list_attend(activityid)
	@act_form=Form.find_by_sql("select * from activity_forms af left join forms f on af.form_id=f.form_id where activity_id=#{activityid} and active_status=true")
	return @act_form
end

#get assigned pdf file activity form name list - checkout page
def form_list_pdf_attend(activityid)
	@act_form=Form.find_by_sql("select * from activity_forms af left join policy_files f on af.policy_file_id=f.policy_file_id where activity_id=#{activityid} and active_status=true")
	return @act_form
end

#participant filled form count for particular activity
def attendees_form_count(formcount,activityid,schedule_mode,scheduleid,userid,partid)
	if !schedule_mode.nil? && schedule_mode!='' && schedule_mode.downcase == 'any time' || schedule_mode.downcase == 'any where' || schedule_mode.downcase == 'by appointment'
		@flag=FormResult.where("created_by_user_id = ? and activity_id= ? and participant_id = ?",userid,activityid,partid)
	else
		@flag=FormResult.where("created_by_user_id = ? and activity_id= ? and participant_id = ? and schedule_id = ?",userid,activityid,partid,scheduleid)
	end
	if !@flag.nil? && @flag.length > 0
		if !formcount.nil? && formcount!='' && formcount.to_i == @flag.length
			return true
		else		
			return false
		end
	else 
		return false
	end
end

#provider network page  - get the answer for question
def get_ques_answer(formid,activityid,schedule_mode,scheduleid,partid,quesid,parentid,isguest)	
	if !schedule_mode.nil? && schedule_mode!='' && schedule_mode.downcase == 'any time' || schedule_mode.downcase == 'any where' || schedule_mode.downcase == 'by appointment'
		if isguest && isguest==true
			@result = FormResult.find_by_form_id_and_activity_id_and_participant_id_and_created_by_guest_id(formid,activityid,partid,parentid)
		else
			@result = FormResult.find_by_form_id_and_activity_id_and_participant_id_and_created_by_user_id(formid,activityid,partid,parentid)
		end
	else	
		if isguest && isguest==true
			@result = FormResult.find_by_form_id_and_activity_id_and_participant_id_and_schedule_id_and_created_by_guest_id(formid,activityid,partid,scheduleid,parentid)
		else
			@result = FormResult.find_by_form_id_and_activity_id_and_participant_id_and_schedule_id_and_created_by_user_id(formid,activityid,partid,scheduleid,parentid)
		end
	end	
	if !@result.nil? 		
		@form_ans=FormResultAnswer.find_by_form_result_id_and_question_id(@result.form_result_id,quesid)
		if !@form_ans.nil?			
			return @form_ans
		else
			return nil
		end
	else
		return nil
	end	
end

end
