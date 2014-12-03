class SchoolRepresentativesController < ApplicationController
 
  def represented_details
	@user = User.where('lower(user_type)=? and lower(user_plan)=? and account_active_status=? and email_address!=?','p','sell',true,current_user.email_address) if current_user && !current_user.nil?
  end

  
 def create
	if params[:activityid] && params[:activityid].present? && params[:represented_id] && params[:represented_id].present?
	old_act = Activity.find(params[:activityid])
        new_act_created = old_act.create_duplicate(params[:represented_id])
	if new_act_created
	@school_rep = SchoolRepresentative.new
	@school_rep.activity_id = new_act_created.activity_id
	@school_rep.vendor_id = current_user.user_id
	@school_rep.representative_id = params[:represented_id]
	@school_rep.edit_p = params[:edit] if params[:edit]=='on'
	@school_rep.delete_p = params[:delete] if params[:delete]=='on'
	@school_rep.view_p = params[:view] if params[:view]=='on'
	@school_rep.status = 'pending'
	@school_rep.share = params[:representative_share]
	@school_rep.save
	@success = (@school_rep.save==true) ? true : false
		#assign form to school represented activity , use old activity form to new activity
		@activity_form_chk = ActivityForm.where("activity_id=? and active_status=true",params[:activityid])
		if !@activity_form_chk.nil? && @activity_form_chk.present? && @activity_form_chk.length > 0
			@activity_form_chk.each do |aval|
				create_assign_form = aval.assign_form_dublicate(params[:represented_id], current_user.user_id,new_act_created.activity_id)
				
			end			
		end
	end
	else
	 @success = false	
        end
        if @success
		@to_user = User.find(params[:represented_id])
		@from_user = User.find(@school_rep.vendor_id)
		@get_current_url = request.env['HTTP_HOST']
		@request = 'invite'
		UserMailer.delay(queue: "Send representative the activity", priority: 2, run_at: 10.seconds.from_now).activity_represent_invite_mail(@school_rep,new_act_created,@to_user,@from_user,@get_current_url,@request)
	end
	render :partial => 'create_thank'
end

def activate_representative_activity
	school_rep = SchoolRepresentative.find(params[:school_rep]) if !params[:school_rep].nil? && params[:school_rep].present?
	if school_rep
		@get_current_url = request.env['HTTP_HOST']
		school_rep.updateSchoolStatus(@get_current_url)
	end
	if current_user.nil?
		redirect_to '/'
	else
	       if current_user.user_id==school_rep.representative_id
			redirect_to "/provider?#{current_user.user_profile.business_name.parameterize+'/'+current_user.user_profile.city.parameterize if !current_user.user_profile.nil?}"
	       else
		       redirect_to '/logout'
	       end
	end
end


def update_schoolrep_status
  if params[:schedule_page] && params[:act_id] && !params[:schedule_page].nil? && !params[:act_id].nil? && params[:schedule_page]=='true'
  @schedule_present = params[:schedule_page]
  @school_rep = 	SchoolRepresentative.where('activity_id=?',params[:act_id]).last
  else
  @school_rep = SchoolRepresentative.find(params[:id]) if params[:id]
  end
  if @school_rep
	@get_current_url = request.env['HTTP_HOST']
	s_updated = @school_rep.updateSchoolStatus(@get_current_url)
	if s_updated
		    respond_to do |format|
			format.js
		    end
	end
  end
end

def vendor_permission_update
	rep_sch = SchoolRepresentative.find(params[:id]) if params[:id]
	@update = rep_sch.update_attributes(edit_p: params[:e_val], delete_p: params[:d_val])
	if @update
		render :text => true
	end
end

def checkForBusinessName
	if params[:name] && params[:name].present?
	business_name = params[:name].split(',')
	check_rec = UserProfile.where("lower(business_name)=?",business_name[0].downcase).last if business_name && business_name[0] && !business_name[0].nil?
	user_present = User.where('user_id=? and account_active_status=?',check_rec.user_id,true).last if check_rec
	success = (user_present && !user_present.nil?) ? user_present.user_id : ''
	else
		success = ''
	end
	render :text => success
end
 
end




