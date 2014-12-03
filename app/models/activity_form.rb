class ActivityForm < ActiveRecord::Base
  attr_accessible :activity_form_id, :activity_id, :created_date, :modified_date, :user_id, :active_status, :policy_file_id
  
  belongs_to :user
  belongs_to :activity
  belongs_to :form
  
  
  #insert record to table - form assign to activity
	def self.assign_form(formid,activityid,userid)
		#already assign this form to activity dont assign again
		@pdf_test = formid.last(4) =="-pdf"   
		if !@pdf_test.nil? && @pdf_test.present?
		    policy_file_id=formid.gsub('-pdf','')
			@act_form = ActivityForm.find_by_activity_id_and_policy_file_id(activityid,policy_file_id,userid)
			if @act_form.nil? 
				@activity_form = ActivityForm.new
				@activity_form.activity_id = activityid
				#@activity_form.form_id = ""
				@activity_form.user_id = userid
				@activity_form.created_date = Time.now
				@activity_form.modified_date = Time.now
				@activity_form.active_status = true
				@activity_form.policy_file_id = policy_file_id
				@activity_form.save
			else
				@act_form.update_attributes(:active_status => true, :modified_date => Time.now)
			end
		else
			@act_form = ActivityForm.find_by_activity_id_and_form_id(activityid,formid,userid)
			if @act_form.nil? 
				@activity_form = ActivityForm.new
				@activity_form.activity_id = activityid
				@activity_form.form_id = formid
				@activity_form.user_id = userid
				@activity_form.created_date = Time.now
				@activity_form.modified_date = Time.now
				@activity_form.active_status = true
				@activity_form.save
			else
				@act_form.update_attributes(:active_status => true, :modified_date => Time.now)
			end
		end
		#@act_form = ActivityForm.find_by_activity_id_and_form_id(activityid,formid,userid)
		
	end

#assign activity to other user, form assign to represented activity also
def assign_form_dublicate(userid,vendorid,activityid)
	if self && userid.present? && vendorid.present?
		new_act = self.dup
		new_act.activity_id = activityid
		new_act.user_id=userid
		new_act.vendor_id=vendorid
		new_act.save
	end
end

end
