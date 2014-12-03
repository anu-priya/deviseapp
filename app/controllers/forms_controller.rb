class FormsController < ApplicationController
include FormsHelper
before_filter :authenticate_user

#add new form builder
def add_form_builder
	#goes to view page
end
#edit form builder
def edit_form_builder
	#goes to view page
	if !params[:formid].nil? && params[:formid]!=''
		@form=Form.find_by_form_id(params[:formid])
		@question_count=Question.select("question_id").where("form_id=?",params[:formid])
		@get_field=Form.find_by_sql("select * from forms f left join questions q on f.form_id=q.form_id where f.created_by_user_id=#{current_user.user_id} and f.form_id=#{@form.form_id} and q.isactive=true")
		#isactive false questions are deleted
		@question_delete=Question.delete_all("form_id=#{params[:formid]} and isactive=false")
	end
end

#add form field value
def save_form_field
	#add form value to form table
	if !params[:form_id].nil? && params[:form_id]!=''
		@form=Form.find_by_form_id(params[:form_id])
		add_field_option(@form)
	else		
		@form=Form.new
		@form.title=params[:frmtitle] if !params[:frmtitle].nil? && params[:frmtitle]!=''
		@form.description=params[:frmdesc] if !params[:frmdesc].nil? && params[:frmdesc]!='' && params[:frmdesc]!='Fill the below fields with your kid information and sent it to the provider'
		@form.created_by_user_id=current_user.user_id  if !current_user.nil? && current_user.user_id!=''
		@form.created_date=Time.now
		if @form.save	
			add_field_option(@form)
		end
	end
	@form_id = @form.form_id
	#get field value
	#@get_field = Question.find_by_sql("select * from questions q left join question_types qt on q.question_type_id =qt.type_id left join question_values qv on q.question_id=qv.question_id where q.question_id=4")
	@get_field=Form.find_by_sql("select * from forms f left join form_questions q on f.form_id=q.form_id where f.created_by_user_id=#{current_user.user_id} and f.form_id=#{@form.form_id}")
	respond_to do |format|
		format.js
	end

end
#add field name, type name and option value
def add_field_option(form)
	@form=form
	#if question already added , update that question or insert to new question
	if !params[:editquestion_id].nil? && params[:editquestion_id]!=''
		@ques_chk=Question.find_by_question_id(params[:editquestion_id])
		if !@ques_chk.nil? && @ques_chk!=''
			@req=params[:chkrequired]=='0'? false : true if !params[:chkrequired].nil? && params[:chkrequired]!=''
				if !params[:fieldtype].nil? && params[:fieldtype]!=''
					@qt=params[:fieldtype].split("|")
					@ques_update = @ques_chk.update_attributes(:field_name=>params[:fieldname],:help_text=>params[:helptxt],:is_required=>@req,:question_type_id=>@qt[0])
			
					if (@qt[1].downcase=='radio' || @qt[1].downcase=='checkbox' || @qt[1].downcase=='list')				
						if @ques_chk['type_id'] == @qt[0]
							#same option means update the value
							if !params[:option_value].nil? && params[:option_value]!='' && params[:option_value].length > 0 
								@option_value =QuestionValue.where("question_id=?",@ques_chk.question_id) 
								#curent and existing option lenght same means goes here
								if @option_value.length == params[:option_value].length
									i=0
									j =1
									#if option_id empty exist, update existing option
									if !params[:option_id].nil? && params[:option_id]!='' && params[:option_id].length > 0
										for i in 0..params[:option_value].length
											@option_chk=QuestionValue.find_by_question_value_id(params[:option_id][i])
											if !@option_chk.nil? && @option_chk.present? && @option_chk!=''
												@option_update = @option_chk.update_attributes(:field_value => params[:option_value][i], :display_order=>j)
											end	
											j=j+1
										end
									else
										#if option_id empty, delete existing option value and insert new option value
										@delete_option = QuestionValue.delete_all("question_id=#{@ques_chk.question_id}")
										@j=1
										params[:option_value].each do |pval|
											if pval!=''
												@question_value=QuestionValue.new
												@question_value.question_id=@ques_chk.question_id
												@question_value.field_value=pval
												@question_value.display_order=@j
												@question_value.save
												@j=@j+1
											end
										end
									end
								else
									#delete option value and insert new option value
									@delete_option = QuestionValue.delete_all("question_id=#{@ques_chk.question_id}")
									if !params[:option_value].nil? && params[:option_value]!='' && params[:option_value].length > 0
										@j=1
										params[:option_value].each do |pval|
											if pval!=''
												@question_value=QuestionValue.new
												@question_value.question_id=@ques_chk.question_id
												@question_value.field_value=pval
												@question_value.display_order=@j
												@question_value.save
												@j=@j+1
											end
										end
									end
								end
							end
						else
							#if select different option, delete the previous option value and add new option value
							@delete_option = QuestionValue.delete_all("question_id=#{@ques_chk.question_id}")
							if !params[:option_value].nil? && params[:option_value]!='' && params[:option_value].length > 0
								@j=1
								params[:option_value].each do |pval|
									if pval!=''
										@question_value=QuestionValue.new
										@question_value.question_id=@ques_chk.question_id
										@question_value.field_value=pval
										@question_value.display_order=@j
										@question_value.save
										@j=@j+1
									end
								end
							end
						end
					else
						#if select different option like textbox , paragraph, delete the option
						@delete_option = QuestionValue.delete_all("question_id=#{@ques_chk.question_id}")
					end
				end
					
		end
			
	else
		#store field value to question, question_type and question_value
		if !params[:fieldtype].nil? && params[:fieldtype]!=''
			@qt=params[:fieldtype].split("|")					
			#question - label name  and required yes or no
			@question=Question.new
			@question.question_type_id=@qt[0]
			@question.field_name=params[:fieldname] if !params[:fieldname].nil? && params[:fieldname]!=''
			@question.help_text=params[:helptxt] if !params[:helptxt].nil? && params[:helptxt]!=''
			@question.is_required= params[:chkrequired]=='0'? false : true if !params[:chkrequired].nil? && params[:chkrequired]!=''
			@question.form_id=@form.form_id
			if @question.save
				#forn_question table store form and question id
				@form_question = FormQuestion.new
				@form_question.form_id=@form.form_id
				@form_question.question_id=@question.question_id
				@form_question.save
				#question values - option value and range
				if !@qt[1].nil? && @qt[1]!='' && (@qt[1].downcase=='radio' || @qt[1].downcase=='checkbox' || @qt[1].downcase=='list')				
					if !params[:option_value].nil? && params[:option_value]!='' && params[:option_value].length > 0
						@j=1
						params[:option_value].each do |pval|
							if pval!=''
								@question_value=QuestionValue.new
								@question_value.question_id=@question.question_id
								@question_value.field_value=pval
								@question_value.display_order=@j
								@question_value.save
								@j=@j+1
							end
						end
					end
				end
			end			
			#insert new question end
		end
	end
	
end

#edit field option value in add form
def edit_field_option
	@fquestion = []
	@fquestion_option  = []
	if !params[:questionid].nil? && params[:questionid]!=''
		@question_id=params[:questionid]
		@fquestion = get_question_details(params[:questionid])
		@fquestion_option = get_question_option(params[:questionid])
	end
	respond_to do |format|
		format.js
	end
end

#delete question,
def delete_question
	if !params[:questionid].nil? && params[:questionid]!=''
		@question_delete = Question.delete_all("question_id=#{params[:questionid]}")
	end
	render :text=>"deleted"	
end

#save form question - change status
def save_form_question
	@str='failure'
	if !params[:formid].nil? && params[:formid]!='' && params[:desc] && params[:desc]!='' && params[:title] && params[:title]!=''
		@form = Form.find_by_form_id(params[:formid])
		if !@form.nil? && @form!='' && @form.present?
			@form.update_attributes(:isactive=>true, :description=>URI::decode(params[:desc]),:title=>URI::decode(params[:title]))
			@question = Question.find_by_sql("update questions set isactive=true where form_id=#{params[:formid]}")
			@str='success'
		end
	end
	render :partial=>"form_success"	
end
#update form question - 
def edit_form_question
	@str='failure'
	if !params[:formid].nil? && params[:formid]!='' && params[:desc] && params[:desc]!='' && params[:title] && params[:title]!=''
		@form = Form.find_by_form_id(params[:formid])
		if !@form.nil? && @form!='' && @form.present?
			@form.update_attributes(:isactive=>true, :description=>URI::decode(params[:desc]),:title=>URI::decode(params[:title]))
			@question = Question.find_by_sql("update questions set isactive=true where form_id=#{params[:formid]}")
			@str='success'
		end
	end
	render :partial=>"update_form_success"
end

#clcik cancel or close icon in add form delete the form
def form_delete
	if !params[:formid].nil? && params[:formid]!='' && params[:formid].present?		
		@form_delete = Form.delete_all("form_id=#{params[:formid]}")	
		@question_delete=Question.delete_all("form_id=#{params[:formid]} and isactive=false")
		if @form_delete
			render :text => true
		else
			render :text => false
		end			
	end	
end

#preview the from 
def form_preview
	@question = []
	if params[:formid] && params[:formid]!=''
		@form = Form.find_by_form_id(params[:formid])
		@question=Question.where("form_id=?",params[:formid]).order("question_id")		
	end	
end

#delete form details
def formbuilder_delete	
	if !params[:formid].nil? && params[:formid]!='' && params[:formid].present?		
		@form_delete=Form.delete_all("form_id=#{params[:formid]}")		
		@question_delete=Question.delete_all("form_id=#{params[:formid]} and isactive=false")
		if @form_delete
			render :text => true
		else
			render :text => false
		end		
	end
end

#form assign to activity
def activity_form_assign
	if params[:act_id] && params[:act_id]!=''	
		@act=Activity.find_by_activity_id(params[:act_id])
		if !@act.nil? && @act.present?
			frmid=params[:act_form].split(',')	 if !params[:act_form].nil? && params[:act_form]!=''		
			frmid.each do |fval|
				@form_chk=Form.find_by_form_id(fval)
				#if !@form_chk.nil? && @form_chk.present?
					#assign form to selected activity
					if(fval!='')	
						@chk_form = ActivityForm.assign_form(fval,params[:act_id],current_user.user_id)
					end
				#end
			end if !frmid.nil? && frmid.present?
			#unselected from if exist in table change the active status is false
			delid=params[:unselect_form].split(',') if !params[:unselect_form].nil? && params[:unselect_form]!=''
			delid.each do |dval|
				@pdf_test = dval.last(4) =="-pdf"
				if !@pdf_test.nil? && @pdf_test.present?
					policy_file_id=dval.gsub('-pdf','')
					@form_update=ActivityForm.find_by_activity_id_and_policy_file_id(params[:act_id],policy_file_id)
					if !@form_update.nil? && @form_update.present? && @form_update!=''					
						@chk_form = @form_update.update_attributes(:active_status => false, :modified_date => Time.now)
					end
				else
					@form_update=ActivityForm.find_by_activity_id_and_form_id(params[:act_id],dval)
					if !@form_update.nil? && @form_update.present? && @form_update!=''					
						@chk_form = @form_update.update_attributes(:active_status => false, :modified_date => Time.now)
					end

				end
				
			end if !delid.nil? && delid.present?
		end
	end	
	#render :text=>'success'
	respond_to do |format|
		format.js
	end
end

#~ #parent form - enter answer check out page
#~ def required_form
	#~ if params[:frmid] && params[:frmid]!='' && params[:actid] && params[:actid]!=''
		#~ frmid=params[:frmid]
		#~ actid=params[:actid]
		#~ @form = Form.find_by_form_id_and_isactive(frmid,true)
		#~ if !@form.nil? && @form.present? && @form!=''
			#~ @activity=Activity.find_by_activity_id(actid)
			#~ @question=Question.where("form_id=? and isactive=true",frmid).order("question_id")			
		#~ end	
	#~ end
#~ end

#submit required form - activity details page validate first
def required_form_validate
	@err_flag = false
	@str = ""	
	if !current_user.nil? && current_user.present?
		if params[:form_id] && params[:form_id]!='' && params[:activity_id] && params[:activity_id]!='' && params[:part_id] && params[:part_id]!=''
			@form = Form.find_by_form_id_and_isactive(params[:form_id],true)
			if !@form.nil? && @form.present? && @form!=''
				@question=Question.where("form_id=? and isactive=true",params[:form_id]).order("question_id")
				@question_req=Question.select("question_id").where("form_id=? and isactive=true and is_required=true",params[:form_id]).order("question_id")
				if !@question.nil? && @question.present?					
					if @question_req.length > 0
						@new_val=[]
						@question.each do |qval|							
							if qval["is_required"] 								
								@f_type=QuestionType.find_by_type_id(qval["question_type_id"])						
								if !@f_type.nil? && @f_type.present? 	
									@new_val<< params[:"frm_#{qval["question_id"]}"] if !params[:"frm_#{qval["question_id"]}"].nil? && params[:"frm_#{qval["question_id"]}"]!=''
									if @f_type["type_value"]=="textbox" || @f_type["type_value"]=="paragraph"
										if !params[:"frm_#{qval["question_id"]}"].nil?  && !qval["help_text"].nil? && params[:"frm_#{qval["question_id"]}"]!='' && params[:"frm_#{qval["question_id"]}"].downcase==qval["help_text"].downcase
											@err_flag=true	
										end	
									else
										@new_val<< params[:"frm_#{qval["question_id"]}"] if !params[:"frm_#{qval["question_id"]}"].nil? && params[:"frm_#{qval["question_id"]}"]!=''
										if params[:"frm_#{qval["question_id"]}"] && !params[:"frm_#{qval["question_id"]}"].nil? 
											if params[:"frm_#{qval["question_id"]}"]==''
												@err_flag=true										
											end
										else
											@err_flag=true
										end											
									end						
								end
							end
						end if !@question.nil? && @question.present? && @question.length > 0
						if @new_val.empty?
							@err_flag = true
						end	
						if @err_flag
							@str = "Enter Required Field"
						else
							@str = "confirmation"
						end
					else
						#if no required field loop
						frm_arr = []						
						@question.each do |qval|												
							@f_type=QuestionType.find_by_type_id(qval["question_type_id"])						
							if !@f_type.nil? && @f_type.present? 														
								if @f_type["type_value"]=="textbox" || @f_type["type_value"]=="paragraph"
									if !params[:"frm_#{qval["question_id"]}"].nil? && !qval["help_text"].nil?  &&  params[:"frm_#{qval["question_id"]}"]!='' && params[:"frm_#{qval["question_id"]}"].downcase==qval["help_text"].downcase
										frm_arr << "y"																		
									elsif  !params[:"frm_#{qval["question_id"]}"].nil? && (qval["help_text"].nil? || qval["help_text"].empty?) && params[:"frm_#{qval["question_id"]}"] =='' 
										frm_arr << "y"																		
									else									
										frm_arr << "n"
									end
								else										
									if params[:"frm_#{qval["question_id"]}"] && !params[:"frm_#{qval["question_id"]}"].nil? 
										if params[:"frm_#{qval["question_id"]}"]==''											
											frm_arr << "y"																						
										else											
											frm_arr << "n"
										end										
									end	
								end						
							end				
						end if !@question.nil? && @question.present? && @question.length > 0				
						
						if frm_arr.include?('n')
							@str = "confirmation"
						else
							@str = "Please enter atleast one field."							
						end						
					end
					if @str!='' && @str=='confirmation'
						#provider can edit the form to allow the filled form to edit
						if !params[:frm_view].nil? && params[:frm_view]!='' && params[:frm_view] == 'u'
							#dont do anything here							
						else							
							#chk already add this participant dont enter again
							@activity = Activity.select("schedule_mode").find_by_activity_id(params[:activityid])
							if !@activity.nil? && @activity.schedule_mode!='' && (@activity.scheudle_mode.downcase == 'any time' || @activity.scheudle_mode.downcase == 'any where' || @activity.scheudle_mode.downcase == 'by appointment')
								@form_result_chk = FormResult.find_by_created_by_user_id_and_form_id_and_activity_id_and_participant_id(@user_id,@form.form_id,params[:activity_id],params[:part_id])
							else
								@form_result_chk = FormResult.find_by_created_by_user_id_and_form_id_and_activity_id_and_participant_id_and_schedule_id(@user_id,@form.form_id,params[:activity_id],params[:part_id],params[:schedule_id])
							end						
							if !@form_result_chk.nil?
								@str = "You have already filled this form"
							end
						end						
					end
				end
			else
				@str="Invalid Form"
			end	#form chk loop end	
		else
			@str="Invalid Form"
		end
	else
		@str="Login your account and fill the form"
	end
	
	render :text => @str
end
#submit required form - activity details page
def required_form_submit
	@err_flag = false
	@str = ""
	if !current_user.nil? && current_user.present?
		if params[:form_id] && params[:form_id]!='' && params[:activity_id] && params[:activity_id]!='' && params[:part_id] && params[:part_id]!=''
			@form = Form.find_by_form_id_and_isactive(params[:form_id],true)
			#get parent  details
			#@parent_user = User.find_by_user_id(params[:frm_parentid])
			if !@form.nil? && @form.present? && @form!=''
				@question=Question.where("form_id=? and isactive=true",params[:form_id]).order("question_id")
				@question_req=Question.select("question_id").where("form_id=? and isactive=true and is_required=true",params[:form_id]).order("question_id")
				if !@question.nil? && @question.present?														
					#insert answer to result table, srt is empty insert values
					if @str==''						
						#chk already add this participant dont enter again
						@activity = Activity.select("schedule_mode").find_by_activity_id(params[:activityid])
						if !@activity.nil? && @activity.schedule_mode!='' && (@activity.scheudle_mode.downcase == 'any time' || @activity.scheudle_mode.downcase == 'any where' || @activity.scheudle_mode.downcase == 'by appointment')
							@form_result_chk = FormResult.find_by_created_by_user_id_and_form_id_and_activity_id_and_participant_id(current_user.user_id,@form.form_id,params[:activity_id],params[:part_id])
						else
							@form_result_chk = FormResult.find_by_created_by_user_id_and_form_id_and_activity_id_and_participant_id_and_schedule_id(current_user.user_id,@form.form_id,params[:activity_id],params[:part_id],params[:schedule_id])
						end						
						if !@form_result_chk.nil?
							@str = "You have already filled this form"
						else	
							@form_result=FormResult.new
							@form_result.form_id=@form.form_id
							@form_result.created_by_user_id=current_user.user_id
							@form_result.form_title=@form.title
							@form_result.created_date=Time.now
							@form_result.updated_date=Time.now 
							@form_result.activity_id= params[:activity_id] if params[:activity_id] && params[:activity_id]!=''
							@form_result.activity_name=params[:activity_name] if params[:activity_name] && params[:activity_name]!=''
							@form_result.participant_id=params[:part_id]
							@form_result.participant_name=params[:part_name]
							@form_result.schedule_id=params[:schedule_id]
							if @form_result.save
								@question.each do |qval|
									@f_type=QuestionType.find_by_type_id(qval["question_type_id"])						
									if !@f_type.nil? && @f_type.present? 														
										if @f_type["type_value"]=="textbox" || @f_type["type_value"]=="paragraph"								
											if !params[:"frm_#{qval["question_id"]}"].nil?  && !qval["help_text"].nil? && params[:"frm_#{qval["question_id"]}"]!='' && params[:"frm_#{qval["question_id"]}"].downcase != qval["help_text"].downcase
												FormResultAnswer.add_answer(@form_result.form_result_id,qval["question_id"],qval["field_name"], params[:"frm_#{qval["question_id"]}"])
											elsif !params[:"frm_#{qval["question_id"]}"].nil?  && params[:"frm_#{qval["question_id"]}"]!='' && qval["help_text"].nil?
												FormResultAnswer.add_answer(@form_result.form_result_id,qval["question_id"],qval["field_name"], params[:"frm_#{qval["question_id"]}"])
											end	
										else								
											if params[:"frm_#{qval["question_id"]}"] && !params[:"frm_#{qval["question_id"]}"].nil?  && params[:"frm_#{qval["question_id"]}"]!=''																				
												ans_val = ''
												if @f_type["type_value"]=="checkbox"
													astr=''
													params[:"frm_#{qval["question_id"]}"].each do |aval|
														if astr ==''
															astr = aval
														else
															astr = astr + ',' + aval
														end
													end
													ans_val = astr
												else
													ans_val = params[:"frm_#{qval["question_id"]}"]
												end		
												FormResultAnswer.add_answer(@form_result.form_result_id,qval["question_id"],qval["field_name"], ans_val)																							
											end	
										end						
									end								
									
								end if !@question.nil? && @question.present? && @question.length > 0
								#send mail to provider for parent fill the form and they ready to attend activity								
								#if !params[:mode].nil? && params[:mode]!='' && params[:mode].downcase == 'parent'
									#chk activity owner
									@activity = Activity.find_by_activity_id(params[:activity_id])
									if !@activity.nil? && @activity.present?
										#get user details
										@actuser = User.find_by_user_id(@activity.user_id)
										UserMailer.delay(queue: "Require Form mail", priority: 1, run_at: 10.seconds.from_now).require_form_mail(current_user,@activity,@actuser,@form)
									end
								#end
								@str="Your details has been saved successfully"
							end
						end						
					end
				end
			else
				@str="Invalid Form"
			end	#form chk loop end	
		else
			@str="Invalid Form"
		end
	else
		@str="Login your account and fill the form"
	end
	render :text => @str
	
end

#activitydetails page click and fill online form - provider page also use this , provider can edit the filled form
def parent_required_form
	#~ if params[:frmid] && params[:frmid]!='' && params[:actid] && params[:actid]!=''
	if params[:actid] && params[:actid]!=''
		frmid=Base64.decode64(params[:frmid])
		actid=Base64.decode64(params[:actid])
		@part_id=Base64.decode64(params[:partid])  if !params[:partid].nil? && params[:partid]!=''
		#edit mode only use this params
		@fview=params[:fview] if !params[:fview].nil? && params[:fview]!=''
		#edit mode only fpid come
		@parentid=Base64.decode64(params[:fpid]) if !params[:fpid].nil? && params[:fpid]!=''		
		@participant = Participant.find_by_participant_id(@part_id)
		@guest_id = @participant.guest_id if @participant && @participant.present? && @participant.guest_id && @participant.guest_id.present?
		@mode = Base64.decode64(params[:mode]) if !params[:mode].nil? && params[:mode]!=''	
		@form = Form.find_by_form_id_and_isactive(frmid,true)
		if !@form.nil? && @form.present? && @form!=''
			@activity=Activity.find_by_activity_id(actid)
			@question=Question.where("form_id=? and isactive=true",frmid).order("question_id")	
			#already filled participant details
			if !current_user.nil?
				#provider edit view check parent id, if parent means use current user id
				if !@parentid.nil? && @parentid!=''
					@participant_chk=FormResult.find_by_created_by_user_id_and_form_id_and_activity_id_and_participant_id(@parentid,frmid,actid,@part_id)
				elsif @guest_id && @guest_id.present? && !@guest_id.nil?
					@participant_chk=FormResult.find_by_created_by_guest_id_and_form_id_and_activity_id_and_participant_id(@guest_id,frmid,actid,@part_id)
				else
					@participant_chk=FormResult.find_by_created_by_user_id_and_form_id_and_activity_id_and_participant_id(current_user.user_id,frmid,actid,@part_id)				
				end
				p 555555555
				p @participant_chk
				
			end
		end	
	end
end
#provider update required form - network page
def required_form_update
	@err_flag = false
	@str = ""
	if !current_user.nil? && current_user.present?
		if params[:form_id] && params[:form_id]!='' && params[:activity_id] && params[:activity_id]!='' && params[:part_id] && params[:part_id]!=''
			@form = Form.find_by_form_id_and_isactive(params[:form_id],true)
			if !@form.nil? && @form.present? && @form!=''
				@question=Question.where("form_id=? and isactive=true",params[:form_id]).order("question_id")
				@question_req=Question.select("question_id").where("form_id=? and isactive=true and is_required=true",params[:form_id]).order("question_id")
				if !@question.nil? && @question.present?
					#chk already add this participant dont enter again
					@activity = Activity.select("schedule_mode").find_by_activity_id(params[:activityid])

					if !params[:frm_parentid].nil? && params[:frm_parentid]!=''
						@user_id=params[:frm_parentid]   #provider edit view
					elsif params[:frm_guestid] && params[:frm_guestid].present? && !params[:frm_guestid].nil? && params[:frm_guestid]!=''
						@guest = true
						@guest_id = params[:frm_guestid]
					else
						@user_id=current_user.user_id   #parent preview view
					end
					
					if !@activity.nil? && @activity.schedule_mode!='' && (@activity.scheudle_mode.downcase == 'any time' || @activity.scheudle_mode.downcase == 'any where' || @activity.scheudle_mode.downcase == 'by appointment')
						if @guest
							@form_result_chk = FormResult.find_by_created_by_guest_id_and_form_id_and_activity_id_and_participant_id(@guest_id,@form.form_id,params[:activity_id],params[:part_id])
						else
							@form_result_chk = FormResult.find_by_created_by_user_id_and_form_id_and_activity_id_and_participant_id(@user_id,@form.form_id,params[:activity_id],params[:part_id])
						end
					else	
						if @guest
							@form_result_chk = FormResult.find_by_created_by_guest_id_and_form_id_and_activity_id_and_participant_id_and_schedule_id(@guest_id,@form.form_id,params[:activity_id],params[:part_id],params[:schedule_id])
						else
							@form_result_chk = FormResult.find_by_created_by_user_id_and_form_id_and_activity_id_and_participant_id_and_schedule_id(@user_id,@form.form_id,params[:activity_id],params[:part_id],params[:schedule_id])
						end
					end						
					if !@form_result_chk.nil?						
						@update_form = @form_result_chk.update_attributes(:updated_by_user_id=>current_user.user_id, :updated_date => Time.now)						
						if @update_form
						@question.each do |qval|
							@f_type=QuestionType.find_by_type_id(qval["question_type_id"])						
							if !@f_type.nil? && @f_type.present? 														
								if @f_type["type_value"]=="textbox" || @f_type["type_value"]=="paragraph"								
									@form_answer = FormResultAnswer.find_by_form_result_id_and_question_id(@form_result_chk.form_result_id,qval["question_id"])
									if params[:"frm_#{qval["question_id"]}"]!='' && params[:"frm_#{qval["question_id"]}"] != qval["help_text"]
										#already added means update the value or insert the new record
										if !@form_answer.nil?											
											@form_answer.update_attributes(:question_name=>qval["field_name"], :question_value=>params[:"frm_#{qval["question_id"]}"])											
										else											
											FormResultAnswer.add_answer(@form_result_chk.form_result_id,qval["question_id"],qval["field_name"], params[:"frm_#{qval["question_id"]}"])
										end
									else
										if !@form_answer.nil?
											@form_answer.destroy
										end
									end	
								else	
									@form_answer = FormResultAnswer.find_by_form_result_id_and_question_id(@form_result_chk.form_result_id,qval["question_id"])
									if params[:"frm_#{qval["question_id"]}"] && !params[:"frm_#{qval["question_id"]}"].nil?  && params[:"frm_#{qval["question_id"]}"]!=''																				
										ans_val=''
										if @f_type["type_value"]=="checkbox"
											astr=''
											params[:"frm_#{qval["question_id"]}"].each do |aval|
												if astr ==''
													astr = aval
												else
													astr = astr + ',' + aval
												end
											end
											ans_val =astr
										else
											ans_val = params[:"frm_#{qval["question_id"]}"]
										end										
										#already added means update the value or insert the new record										
										if !@form_answer.nil?
											@form_answer.update_attributes(:question_name=>qval["field_name"], :question_value=>ans_val)											
										else											
											FormResultAnswer.add_answer(@form_result_chk.form_result_id,qval["question_id"],qval["field_name"], ans_val)											
										end	
									else												
										if !@form_answer.nil?
										@form_answer.destroy
										end
									end	
								end	
														
							end			
						end if !@question.nil? && @question.present? && @question.length > 0
							@str="Form details has been updated successfully"		
							#send mail to parent for provider edit your form
							#chk activity owner
							@activity = Activity.find_by_activity_id(params[:activity_id])
							if !@activity.nil? && @activity.present?
								#get user details
								#provider can edit the parent form send mail to parent
								if !params[:frm_mode].nil? && params[:frm_mode]!='' && params[:frm_mode].downcase == 'provider'									
									@parent_user = ((@guest) ? GuestDetail.find_by_guest_id(@guest_id)  : User.find_by_user_id(@user_id))
									if @parent_user && !@parent_user.nil?
										type =@parent_user.class.to_s
										if (type=='User' && @parent_user.user_flag == true)  || (type=='GuestDetail')
											UserMailer.delay(queue: "Require Form Edit mail to parent", priority: 1, run_at: 10.seconds.from_now).require_form_edit_mail(current_user,@activity,@parent_user,@form,@form_result_chk["participant_name"]) 
										end
									end
								end
								#parent can edit the from send mail to provider
								if !params[:frm_mode].nil? && params[:frm_mode]!='' && params[:frm_mode].downcase == 'parent'
									@provider_user = User.find_by_user_id(@activity.user_id) if !@user_id.nil?
									if !@provider_user.nil?
										if @provider_user.user_flag == true
											UserMailer.delay(queue: "Require Form Edit mail to provider", priority: 1, run_at: 10.seconds.from_now).require_form_edit_toprovider(current_user,@activity,@provider_user,@form)
										end
									end
								end
								
							end
						else
							@str="Form details not updated"
						end
					else
						#@str="The parent has not filled out this form!"
						#---- provider fill the parent form start ----#	
							@form_result=FormResult.new
							@form_result.form_id=@form.form_id
							@form_result.created_by_user_id=@user_id
							@form_result.created_by_guest_id=@guest_id if @guest && @guest_id && @guest_id.present? && !@guest.nil?
							@form_result.form_title=@form.title
							@form_result.created_date=Time.now
							@form_result.updated_date=Time.now 
							@form_result.activity_id= params[:activity_id] if params[:activity_id] && params[:activity_id]!=''
							@form_result.activity_name=params[:activity_name] if params[:activity_name] && params[:activity_name]!=''
							@form_result.participant_id=params[:part_id]
							@form_result.participant_name=params[:part_name]
							@form_result.schedule_id=params[:schedule_id]
							if @form_result.save
								@question.each do |qval|
									@f_type=QuestionType.find_by_type_id(qval["question_type_id"])						
									if !@f_type.nil? && @f_type.present? 														
										if @f_type["type_value"]=="textbox" || @f_type["type_value"]=="paragraph"								
											if !params[:"frm_#{qval["question_id"]}"].nil?  && !qval["help_text"].nil? && params[:"frm_#{qval["question_id"]}"]!='' && params[:"frm_#{qval["question_id"]}"].downcase != qval["help_text"].downcase
												FormResultAnswer.add_answer(@form_result.form_result_id,qval["question_id"],qval["field_name"], params[:"frm_#{qval["question_id"]}"])
											elsif !params[:"frm_#{qval["question_id"]}"].nil?  && params[:"frm_#{qval["question_id"]}"]!='' && qval["help_text"].nil?
												FormResultAnswer.add_answer(@form_result.form_result_id,qval["question_id"],qval["field_name"], params[:"frm_#{qval["question_id"]}"])
											end	
										else								
											if params[:"frm_#{qval["question_id"]}"] && !params[:"frm_#{qval["question_id"]}"].nil?  && params[:"frm_#{qval["question_id"]}"]!=''																				
												ans_val = ''
												if @f_type["type_value"]=="checkbox"
													astr=''
													params[:"frm_#{qval["question_id"]}"].each do |aval|
														if astr ==''
															astr = aval
														else
															astr = astr + ',' + aval
														end
													end
													ans_val = astr
												else
													ans_val = params[:"frm_#{qval["question_id"]}"]
												end		
												FormResultAnswer.add_answer(@form_result.form_result_id,qval["question_id"],qval["field_name"], ans_val)																							
											end	
										end						
									end								
									
								end if !@question.nil? && @question.present? && @question.length > 0
								#send mail to parent for provider fill the form 						
								#~ @parent_user_ = User.find_by_user_id(@user_id)
								#~ #chk activity owner
								#~ @activity = Activity.find_by_activity_id(params[:activity_id])
								#~ if !@activity.nil? && @activity.present?									
									#~ if @parent_user_.user_flag == true										
										#~ UserMailer.delay(queue: "Require Form Edit mail to parent", priority: 1, run_at: 10.seconds.from_now).require_form_edit_mail(current_user,@activity,@parent_user_,@form,params[:part_name]) 
									#~ end
								#~ end
							
								@str="Form details has been saved successfully"
							end
							
						#---- provider add the parent form end ----#
					end						
					
				end
			else
				@str="Invalid Form"
			end	#form chk loop end	
		else
			@str="Invalid Form"
		end
	else
		@str="Login your account and fill the form"
	end
	render :text => @str	
end

#parent preview form
def preview_parent_required_form
	if params[:frmid] && params[:frmid]!='' && params[:actid] && params[:actid]!=''
		frmid=params[:frmid]
		actid=params[:actid]
		@part_id=params[:partid]
		#edit mode only use this params
		@fview=params[:fview] if !params[:fview].nil? && params[:fview]!=''
		@participant = Participant.find_by_participant_id(params[:partid])
		@form = Form.find_by_form_id_and_isactive(frmid,true)
		if !@form.nil? && @form.present? && @form!=''
			@activity=Activity.find_by_activity_id(actid)
			@question=Question.where("form_id=? and isactive=true",frmid).order("question_id")	
			#already filled participant details
			if !current_user.nil?
				@participant_chk=FormResult.find_by_created_by_user_id_and_form_id_and_activity_id_and_participant_id(current_user.user_id,frmid,actid,@part_id)				
			end
		end	
	end	
end

end


