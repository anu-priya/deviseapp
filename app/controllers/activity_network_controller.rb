class ActivityNetworkController < ApplicationController
	
   #assigned manager for user	
   def assigned_manager
	   if !current_user.nil? && current_user.present?
		 get_current_url = request.env['HTTP_HOST']
		@activity = Activity.find(params[:activity_id]) if params[:activity_id] if !params[:activity_id].nil?
		@schedule_id = params[:schedule_id] if !params[:schedule_id].nil? && params[:schedule_id].present?
		@a_manager = params[:assign_manager_list] if !params[:assign_manager_list].nil? && params[:assign_manager_list].present?
		 (!params[:invite_manager_m].nil? && params[:invite_manager_m].present?) ? (@invite_m = params[:invite_manager_m]) : (@invite_m = false)
		 (!params[:invite_attendees_m].nil? && params[:invite_attendees_m].present?) ? (@invite_a = params[:invite_attendees_m]) : (@invite_a = false)
		 (!params[:view_m].nil? && params[:view_m].present?) ? (@view_m = true) : (@view_m = true)
		 (!params[:edit_m].nil? && params[:edit_m].present?) ? (@edit_m = params[:edit_m]) : (@edit_m = false)
	    
	    @assigned_manager_ids = User.find_by_sql("select * from users where user_id in(select distinct manager_user_id from activity_network_permissions where provider_user_id = #{current_user.user_id} and activity_id = #{params[:activity_id]} and schedule_id = #{@schedule_id} and lower(accept_status) = 'accepted')").map(&:user_id) if !current_user.nil? && !params[:activity_id].nil?
	   #already checked the values
	     a_man_val = []
	     if !@assigned_manager_ids.nil? && @assigned_manager_ids.present?
		 @a_manager.each do |m_val|
		  a_man_val << m_val.to_i
		end if !@a_manager.nil? #do end
	      del_net = (@assigned_manager_ids.to_a) - (a_man_val.to_a) if !@assigned_manager_ids.nil? && !a_man_val.nil?        
	      d_val = del_net.to_s.gsub("[","(").gsub("]",")") if del_net
		      if !params[:activity_id].nil? && !current_user.nil? && !d_val.nil? && d_val.present? && !del_net.nil? && del_net.length>0  && !@schedule_id.nil?
		      ActivityNetworkPermission.find_by_sql("delete from activity_network_permissions where manager_user_id in #{d_val} and activity_id = #{params[:activity_id]} and provider_user_id = #{current_user.user_id} and schedule_id = #{@schedule_id} ") 
		      end
	     end
     
	    # stored the assign manager list
	    @a_manager.each do |manager|
		    @assigned_list = ActivityNetworkPermission.find_by_activity_id_and_schedule_id_and_provider_user_id_and_manager_user_id(params[:activity_id],@schedule_id,current_user.user_id,manager) if !params[:activity_id].nil? && !current_user.nil? && !manager.nil? && !@schedule_id.nil?
		    if !@assigned_list.nil? && @assigned_list.present? #update information
			@assigned_list.update_attributes(:edit_manager=>@edit_m, :invite_managers=>@invite_m, :invite_attendies=>@invite_a, :modified_date=>Time.now) 
		    else #create new record
			@assigned_list = ActivityNetworkPermission.create(:activity_id=>params[:activity_id], :schedule_id=>@schedule_id, :provider_user_id=>current_user.user_id, :manager_user_id=>manager, :view_manager=>@view_m, :edit_manager=>@edit_m, :invite_managers=>@invite_m, :invite_attendies=>@invite_a, :accept_status=>"Accepted", :inserted_date=>Time.now, :modified_date=>Time.now) if !params[:activity_id].nil? && !current_user.nil? && !manager.nil? && !@schedule_id.nil?
			#mailer function to assign manager
			UserMailer.delay(queue: "Assign to manager", priority: 2, run_at: 10.seconds.from_now).assign_to_manager(manager,@activity,current_user,@assigned_list.id,get_current_url) if @activity && manager && current_user && @assigned_list
		    end #end
	    end if !@a_manager.nil? && @a_manager.length>0 #do end
	    
          end #current user end
	#response
	  @rm_all = params[:rm_all] if !params[:rm_all].nil? && params[:rm_all]!=''
	respond_to do |format|
		if !@rm_all.nil? && @rm_all.present? && @rm_all=="unassined"
   		 format.js {render :text => "$('#invite_manager_m').prop( 'checked', false );$('#invite_attendees_m').prop( 'checked', false );$('#edit_m').prop( 'checked', false );$('#un_assignedmanager').bPopup({fadeSpeed:100,followSpeed:100,opacity:0.8,position: [241, 100],positionStyle: 'absolute',modalClose: false});"}
		else
		 format.js {render :text => "$('#invite_manager_m').prop( 'checked', false );$('#invite_attendees_m').prop( 'checked', false );$('#edit_m').prop( 'checked', false );$('#assignedmanager').bPopup({fadeSpeed:100,followSpeed:100,opacity:0.8,position: [241, 100],positionStyle: 'absolute',modalClose: false});"}
		end
	end
  end #ending assign manager

	#accept assigned manager for member user
 def assign_manager_accept
	mrecord = Base64.decode64(params[:mrecord]) if !params[:mrecord].nil? && params[:mrecord]!=''
	invited_uid = Base64.decode64(params[:sent_user]) if !params[:sent_user].nil? && params[:sent_user]!=''
	@manager_email_id = params[:sent_user_email]  if !params[:sent_user_email].nil? && params[:sent_user_email]!=''
	#~ @m_user = ActivityNetworkPermission.find_by_email_id_and_provider_user_id_and_id(@manager_email_id,invited_uid,mrecord) if !@manager_email_id.nil? && !invited_uid.nil? && !mrecord.nil?	
	 @m_user = ActivityNetworkPermission.find(mrecord) if !mrecord.nil?
	 provider_user = User.find(@m_user.provider_user_id) if !@m_user.nil? && !@m_user.provider_user_id.nil?
	 acpt_user = User.find(@m_user.manager_user_id) if !@m_user.nil? && !@m_user.manager_user_id.nil?
	 get_current_url = request.env['HTTP_HOST']
	@activity = Activity.find(@m_user.activity_id) if !@m_user.nil?
	if !@m_user.nil? && @m_user.present?
		@m_user.update_attributes(:accept_status=>"Accepted", :modified_date=>Time.now)
		#send a mail to user
		if provider_user !="" && !provider_user.nil? && !provider_user.blank? && provider_user.user_flag==TRUE
		UserMailer.delay(queue: "Accepted status to Assigned provider", priority: 2, run_at: 10.seconds.from_now).accept_manager(provider_user,@activity,acpt_user,get_current_url)  if !@activity.nil? && !acpt_user.nil? && !provider_user.nil?
		end
	end
	#displayed the login popup
	 if current_user && !current_user.nil?
		redirect_to '/provider' 
	 else
		redirect_to :controller=>'landing',:action=>'landing_new', :u=>'manager_accept'
	 end
 end #invite manager accept ending
 
 #view edit delete permissions updated
 def permission_managers
	@schedule_id = params[:schedule_id] if !params[:schedule_id].nil?
	@mid = params[:act_man_uid] if !params[:act_man_uid].nil?
	@pid = params[:provider_id] if !params[:provider_id].nil?
	(!params[:permission_invite].nil? && params[:permission_invite].present?) ? (@invite_m = params[:permission_invite]) : (@invite_m = false)
	(!params[:attendees_invite].nil? && params[:attendees_invite].present?) ? (@invite_a = params[:attendees_invite]) : (@invite_a = false)
	(!params[:permission_view].nil? && params[:permission_view].present?) ? (@view_m = true) : (@view_m = true)
	(!params[:permission_edit].nil? && params[:permission_edit].present?) ? (@edit_m = params[:permission_edit]) : (@edit_m = false)
	@activity = Activity.find(params[:activity_id]) if params[:activity_id] if !params[:activity_id].nil?
	@activity_schedules = @activity.activity_schedule if @activity
	@p_list = ActivityNetworkPermission.find_by_activity_id_and_schedule_id_and_provider_user_id_and_manager_user_id(params[:activity_id],@schedule_id,current_user.user_id,@mid) if !params[:activity_id].nil? && !current_user.nil? && !@mid.nil? && !@schedule_id.nil?
	 
	 if @p_list
		 @p_list.update_attributes(:edit_manager=>@edit_m, :invite_managers=>@invite_m, :invite_attendies=>@invite_a, :modified_date=>Time.now) 
		#send a mail to manager user about the permission changes by the provider 
		UserMailer.delay(queue: "Permission changes for manager", priority: 2, run_at: 10.seconds.from_now).manager_permission_changes(current_user,@activity,@mid)  if !@activity.nil? && !@mid.nil? && !current_user.nil?
	 end
	 
	 respond_to do |format|
		 format.js{render:text=>"success"}
	 end
 end #method ending
 
 #index page for activity network
   def activity_network
	@mgr_acpted = params[:mgr_acpted] if !params[:mgr_acpted].nil? #if user accept open the network popup
	if params[:acti_id] && !params[:acti_id].nil? && params[:acti_id].present?
	@activity = Activity.find(params[:acti_id])
	@activity_schedules = @activity.activity_schedule if @activity
	@schedule_id = @activity_schedules.first.schedule_id if @activity_schedules
	@managers_list = User.find_by_sql("select * from users where user_id in(select manager_user_id from managers where invited_user_id = #{current_user.user_id} and activity_id = #{params[:acti_id]} and lower(accept_status)='accepted')") if !current_user.nil? && !params[:acti_id].nil?
	@assigned_manager_list = User.find_by_sql("select * from users where user_id in(select distinct manager_user_id from activity_network_permissions where provider_user_id = #{current_user.user_id} and activity_id = #{params[:acti_id]} and schedule_id = #{@schedule_id} and lower(accept_status)='accepted')") if !current_user.nil? && !params[:acti_id].nil? && !@schedule_id.nil?
	@assigned_manager_ids = User.find_by_sql("select * from users where user_id in(select distinct manager_user_id from activity_network_permissions where provider_user_id = #{current_user.user_id} and activity_id = #{params[:acti_id]} and schedule_id = #{@schedule_id} and lower(accept_status)='accepted')").map(&:user_id) if !current_user.nil? && !params[:acti_id].nil? && !@schedule_id.nil?
	#displayed the invite managers view based on permission setup
	#~ @invite_mn = ActivityNetworkPermission.find_by_sql("select * from activity_network_permissions where activity_id = #{params[:acti_id]} and schedule_id = #{@schedule_id} and manager_user_id = #{current_user.user_id}  and provider_user_id = #{@activity.user_id}") if !@activity.nil? && !params[:acti_id].nil? && !current_user.nil? && !@schedule_id.nil?
	@invite_mn = ActivityNetworkPermission.find_by_activity_id_and_schedule_id_and_manager_user_id_and_provider_user_id(params[:acti_id],@schedule_id,current_user.user_id,@activity.user_id) if !@activity.nil? && !params[:acti_id].nil? && !current_user.nil? && !@schedule_id.nil?
	elsif !params[:sh_id].nil? && params[:sh_id].present? && !params[:pending].nil? && params[:pending].present? 
	@activity_schedule_id = @schedule_id = params[:sh_id] 
	@activity_schedules = ActivitySchedule.where("schedule_id=?",params[:sh_id])
	@activity = @activity_schedules.first.activity
        end
   respond_to do |format|
      format.html
      format.js
    end
  end
  
 # Send message in groups
  def participant_message
     if params[:a_email_ids] || params[:m_email_ids] || params[:p_email_ids]  || params[:schedule_ids]
	   params[:a_email_ids] = '' if params[:a_email_ids].nil? 
	   params[:m_email_ids] = '' if params[:m_email_ids].nil?  
	   params[:p_email_ids] = '' if params[:p_email_ids].nil?  
	  @all_emails =  params[:a_email_ids]+params[:m_email_ids]+params[:p_email_ids] 
	  @e_arr = []
	  if @all_emails && @all_emails!=""
		@e_arr = @all_emails.split(',').uniq
	  end
	if params[:schedule_ids] && params[:schedule_ids].present?
		@schedules_ids = params[:schedule_ids].split(',')
		@schedules_ids.each do |sched|
		@attnd_list_users = ActivityAttendDetail.where("schedule_id=? and (lower(payment_status)=? or lower(payment_status)=?)",sched,'paid','offline').map(&:attendies_email)
		@manage_list_users = User.find_by_sql("select * from users where user_id in(select distinct manager_user_id from activity_network_permissions where provider_user_id = #{current_user.user_id} and schedule_id = #{sched} and lower(accept_status)='accepted')").map(&:email_address) if !current_user.nil? && !sched.nil?
		@pending_attndees = InviteAttendees.where("user_id=? and schedule_id=? and lower(accept_status)=?",current_user.user_id,sched,'pending').map(&:email_id)
		@user_list = (@attnd_list_users + @manage_list_users+@pending_attndees).uniq
		@e_arr << @user_list if @user_list && @user_list.present?
		end
	#~ @e_arr <<  User.find_by_sql("select email_address from users where user_id in #{@user_list.to_s.gsub("[","(").gsub("]",")").gsub("nil","")}").map(&:email_address).uniq if @user_list && @user_list.present?
end
	 @emails = @e_arr.flatten.uniq.to_s.gsub('"','').gsub("[","").gsub("]","") if @e_arr
     end
  end
  
   # Send message success
  def participant_message_success
         if  params[:send_to] && params[:subject] && params[:message] && params[:send_to].present? && params[:subject].present? && params[:message].present?
	  @to_emails = params[:send_to].split(',')
	  @sub = params[:subject]
	  @msg = params[:message]
	 @to_emails.each do |email|
	  UserMailer.delay(queue: "Send message to all in the networks", priority: 2, run_at: 10.seconds.from_now).send_message_to_networks(email,@sub,@msg,current_user)
	 end
	  #~ render:partial => 'participant_message_success'
	#~ respond_to do |format|
		#~ format.js {render :text => "$('#messageSuccess').bPopup({fadeSpeed:100,followSpeed:100,opacity:0.8,positionStyle: 'absolute',modalClose: false});"}
	#~ end
	render :text=>'true'
	end  
  end

#invite manger exist checked for email entered by the provider
def invite_manager_exist
	if current_user && current_user.present?
	  @actid = params[:activity_id] if !params[:activity_id].nil?
	  managerss= params[:invite_email].to_s.gsub("[", '').gsub("]", '').gsub("\"", '').gsub(" ", '')
	  manlist= managerss.split(",")
	  @rep_users = ""
	  manlist.each do |user|
		    if !current_user.nil? && current_user.email_address == user
		    chk_user = user
		    else
		    chk_user = Manager.find_by_email_id_and_activity_id(user,@actid) if !user.nil? && !@actid.nil?
		   end
		#return the exist mail_id for invite mangers
		    if chk_user.present?
		      if @rep_users.empty?
		      @rep_users.concat("#{user}")  
		      else
		      @rep_users.concat(",#{user}")
		      end
		    end
	  end if !manlist.nil? # do end
	   render :text => @rep_users
	end #current user ending
end #invite manager mail exist!
  
  #invite manager storing data
  def invite_manager
	if current_user && current_user.present?
	 get_current_url = request.env['HTTP_HOST']
	 @actid = params[:activity_id] if !params[:activity_id].nil?
	 @act = Activity.find(@actid) if !@actid.nil?
	 @msg = params[:invite_message_manager] if !params[:invite_message_manager].nil?
	 email_mngr = params[:invite_email_manager].split(',')
		   email_mngr.each do|s|
		      if !s.nil? && s!="" && !s.blank?
			user = User.find_by_email_address(s)
			@m_exist = Manager.find_by_email_id_and_invited_user_id_and_activity_id(s,current_user.user_id,params[:activity_id]) if !s.nil? && !current_user.nil? && !params[:activity_id].nil?
			if !user.nil?
			  @m_userid = user.user_id 
			  attend_email=user.email_address
			  if attend_email !="" && !attend_email.nil? && !attend_email.blank? && user.user_flag==TRUE && !@m_exist
			     @manager = Manager.create(:email_id=>s, :manager_user_id=>@m_userid, :invited_user_id=>current_user.user_id, :accept_status=>"pending", :activity_id=>@actid, :inserted_date=>Time.now, :modified_date=>Time.now) if !@actid.nil?
			    UserMailer.delay(queue: "invite Message for Manager", priority: 2, run_at: 10.seconds.from_now).invite_to_manager(attend_email,@act,current_user,@msg,get_current_url,@manager.id) if !@manager.nil?
			 end
			else
			   @m_userid = nil
			  #~ @result = UserMailer.delay(queue: "Shared Activity", priority: 2, run_at: 10.seconds.from_now).share_activity_mail(@user,@activity,@get_current_url,t,s,params[:subject],@mode)
		            if !@m_exist #insert only one time
			     @manager = Manager.create(:email_id=>s, :manager_user_id=>@m_userid, :invited_user_id=>current_user.user_id, :accept_status=>"pending", :activity_id=>@actid, :inserted_date=>Time.now, :modified_date=>Time.now) if !@actid.nil?
			    UserMailer.delay(queue: "invite Message for Manager non user", priority: 2, run_at: 10.seconds.from_now).invite_manager_to_join(s,@act,current_user,@msg,get_current_url)
			    end
			end #user if end
		       
			#~ if !@m_exist #store only one manager
			#~ @manager = Manager.create(:email_id=>s, :manager_user_id=>@m_userid, :invited_user_id=>current_user.user_id, :accept_status=>"pending", :activity_id=>@actid, :inserted_date=>Time.now, :modified_date=>Time.now) if !@actid.nil?
		        #~ end
		      end # if end
	      end #do end
			      respond_to do |format|
				format.js {render :text => "$('#invite_email').val('johnjoe@gmail.com,smith@yahoo.com');$('#invite_email').css('color','#999999');$('#invite_message').val('');$('#loading_img').css('display','none');$('#invitemanager').bPopup({fadeSpeed:100,followSpeed:100,opacity:0.8,position: [241, 100],positionStyle: 'absolute',modalClose: false});"}
			      end
	    end #current_user end
end #invite manager end

#accept invite manager for member user
 def invite_manager_accept
	manager_uid = Base64.decode64(params[:muid]) if !params[:muid].nil? && params[:muid]!=''
	invited_uid = Base64.decode64(params[:sent_user]) if !params[:sent_user].nil? && params[:sent_user]!=''
	@manager_email_id = params[:sent_user_email]  if !params[:sent_user_email].nil? && params[:sent_user_email]!=''
	@m_user = Manager.find(manager_uid) if !manager_uid.nil?
	 provider_user = User.find(@m_user.invited_user_id) if !@m_user.nil? && !@m_user.invited_user_id.nil?
	 get_current_url = request.env['HTTP_HOST']
	@activity = Activity.find(@m_user.activity_id) if !@m_user.nil?
	if !@m_user.nil? && @m_user.present?
		@m_user.update_attributes(:accept_status=>"Accepted", :modified_date=>Time.now)
		#send a mail to both user
		UserMailer.delay(queue: "Accepted status to manager user", priority: 2, run_at: 10.seconds.from_now).accepted_status_to_manager(@m_user.email_id,@activity,provider_user,get_current_url) if !@activity.nil? && !@m_user.nil?
		if provider_user !="" && !provider_user.nil? && !provider_user.blank? && provider_user.user_flag==TRUE
		UserMailer.delay(queue: "Accepted status to Owner provider", priority: 2, run_at: 10.seconds.from_now).accepted_status_to_provider(provider_user,@activity,@m_user.email_id,get_current_url)  if !@activity.nil? && !@m_user.nil?
		end
	end
	#displayed the login popup
	 if current_user && !current_user.nil?
		redirect_to '/provider' 
	 else
		redirect_to :controller=>'landing',:action=>'landing_new', :u=>'manager_accept'
	 end
 end #invite manager accept ending
 
  #rendering single schedule details
  def network_next_prev_details
	if params[:activity_sch_id]  && params[:sch_num] && !params[:activity_sch_id].nil?  && !params[:sch_num].nil?
	@activity_sch_id = params[:activity_sch_id]  
	@activity_sche = ActivitySchedule.find(@activity_sch_id) if !@activity_sch_id.nil?
	@activity = Activity.find(@activity_sche.activity_id) if !@activity_sche.nil?
	#displayed the assigned managers list for assign
	@managers_list = User.find_by_sql("select * from users where user_id in(select manager_user_id from managers where invited_user_id = #{current_user.user_id} and activity_id = #{@activity.activity_id} and lower(accept_status)='accepted')") if !@activity.nil? && !current_user.nil?
	@assigned_manager_list = User.find_by_sql("select * from users where user_id in(select distinct manager_user_id from activity_network_permissions where provider_user_id = #{current_user.user_id} and activity_id = #{@activity.activity_id} and schedule_id = #{@activity_sch_id} and lower(accept_status)='accepted')") if !current_user.nil? && !@activity.nil? && !@activity_sch_id.nil?
	@assigned_manager_ids = User.find_by_sql("select * from users where user_id in(select distinct manager_user_id from activity_network_permissions where provider_user_id = #{current_user.user_id} and activity_id = #{@activity.activity_id} and schedule_id = #{@activity_sch_id} and lower(accept_status)='accepted')").map(&:user_id) if !current_user.nil? && !@activity.nil? && !@activity_sch_id.nil?
	#displayed the invite managers view based on permission setup
	#~ @invite_mn = ActivityNetworkPermission.find_by_sql("select * from activity_network_permissions where activity_id = #{@activity.activity_id} and schedule_id = #{@activity_sch_id}  and manager_user_id = #{current_user.user_id}  and provider_user_id = #{@activity.user_id}") if !@activity.nil? && !current_user.nil? && !@activity_sch_id.nil?
	@invite_mn = ActivityNetworkPermission.find_by_activity_id_and_schedule_id_and_manager_user_id_and_provider_user_id(@activity.activity_id,@activity_sch_id,current_user.user_id,@activity.user_id) if !@activity.nil? && !current_user.nil? && !@activity_sch_id.nil?
	@num =  params[:sch_num]
	@activity_schedules = ActivitySchedule.where("schedule_id=?",params[:activity_sch_id])
	@schedule_id = params[:activity_sch_id]
	respond_to do |format|
		format.js
	end 
	end
  end
  
  
#FamPass ticket accept functionality from network 
  def fampass_accept
	  if params[:attnd_id]
	  @fam_pass = FampassDetail.where("attend_id=?",params[:attnd_id]).last 
	  if @fam_pass && !@fam_pass.nil?
		@fam_pass.update_attributes(status: 'accepted')  
	  else
		@attend_detail = ActivityAttendDetail.find(params[:attnd_id])
		@fam_pass = FampassDetail.new
		@fam_pass.attend_id = params[:attnd_id]
		@fam_pass.status = 'accepted'
		@fam_pass.accepted_date = Time.now
		@fam_pass.created_at = Time.now
		@fam_pass.updated_at = Time.now
		@fam_pass.save
	   end
		render :text=>true
	  else
		render :text=>false
	  end
  end

def attendees_destroy
	@invite_id = InviteAttendees.find(params[:id])
	@invite_id.destroy
	@activity_sch_id = params[:sh_id]
	@activity = Activity.find(params[:acti_id])
	@invite = InviteAttendees.where("user_id = ? and schedule_id = ?", current_user.user_id, params[:sh_id]) if !current_user.nil? && current_user.present?
    respond_to do |format|
      format.js
    end
end

  #invite attendies
def invite_attend
    if !params[:act_id].nil? &&  params[:act_id].present?
	@act_id = params[:act_id] if !params[:act_id].nil?
    elsif !params[:shedule_id].nil? &&  params[:shedule_id].present?
    	@activity_schedules = ActivitySchedule.where("schedule_id=?",params[:shedule_id]).last
    	@act_id=@activity_schedules.activity_id
    end
	 @activity = Activity.find(@act_id) if !@act_id.nil?
	 @schedule = params[:shedule_id] if !params[:shedule_id].nil?
	 @to=params[:attendees_parent_email].split(",") if !params[:attendees_parent_email].nil?
	 get_current_url = request.env['HTTP_HOST']
	 @sh_price = params[:sh_price] if !params[:sh_price].nil?
	 @msg = params[:invite_parent_message] if params[:invite_parent_message] && !params[:invite_parent_message].nil?
	     @to && @to.each do |to_email|
		        @invite = InviteAttendees.where("email_id=? and activity_id=? and schedule_id=?",to_email,@act_id,params[:shedule_id]).last
			if !@invite 
			@invite = InviteAttendees.new
			@invite.email_id=to_email
			@invite.user_id=current_user.user_id if !current_user.nil?
			@invite.activity_id=@act_id
			@invite.schedule_id = params[:shedule_id]
			@invite.accept_status = 'Pending'
			@invite.created_at = Time.now
			@invite.updated_at = Time.now
			@invite.save
			end
			UserMailer.delay(queue: "Invite Attendies ", priority: 2, run_at: 10.seconds.from_now).invite_attendies_mail(@activity,current_user,@schedule,get_current_url,to_email,@sh_price,@invite.invite_id,@msg) 
	      end
      render :text=>true
end

#Accept attendees request
def invite_attendees_accept
	if params[:inv_attend_id] && params[:inv_attend_id].present?
	de_inv = Base64.decode64("#{params[:inv_attend_id]}")
	@inv_attnd = InviteAttendees.find(de_inv)
	@inv_attnd.accept_status = "accepted"
	@inv_attnd.save
	end
	redirect_to '/'
end
  
#Add Offline participant
def offline_participant_add
	invite_attnd_id = params["invitee_attnd_id"]
	@invite_attnd = InviteAttendees.find(invite_attnd_id)
	@olduser = User.where("email_address=?",@invite_attnd.email_id).last
	part_det_id=params["single_raw"].split(',') if !params["single_raw"].nil? && params["single_raw"].present?
	part_add_flag = false
	if !part_det_id.nil? && part_det_id.present?
		part_det_id.each do |s|
			parti = Participant.new
		        parti.participant_name = params["part_name_#{invite_attnd_id}_#{s}"]
		        parti.participant_gender = params["participant_gender_#{invite_attnd_id}_#{s}"]
		        parti.participant_age = params["participant_age_#{invite_attnd_id}_#{s}"]
		        parti.user_id = @olduser.user_id if !@olduser.nil?
			parti.participant=params["photo_#{invite_attnd_id}_#{s}"]
		        parti.save 
			@attend_add = ActivityAttendDetail.new
		        @attend_add.attendies_email=@invite_attnd.email_id
		        @attend_add.activity_id = params[:activ_id]
		        @attend_add.user_id = @olduser.user_id if !@olduser.nil?
		        @attend_add.schedule_id = params[:sched_id]
		        @attend_add.participant_id = parti.participant_id
			@attend_add.payment_status = "offline"
		        @attend_add.inserted_date = Time.now
		        @attend_add.save 
			part_add_flag = true if parti.save && @attend_add.save 
		end
	@invite_attnd.delete if part_add_flag	
	end
	render :text=>true
end
  
  #search in attendees list
  def search_attend_detail
	  if params[:sched_val] && params[:search_val] && !params[:sched_val].nil? && !params[:search_val].nil?
	   @schedule_id = params[:sched_val]
	   @query_all = "select attnd.*,fam.status from activity_attend_details as attnd left join participants as parti on attnd.participant_id = parti.participant_id left join fampass_details as fam on attnd.attend_id=fam.attend_id 
 where attnd.schedule_id=#{params[:sched_val]}"
           @parti_query = "and lower(attnd.ticket_code) like '%#{params[:search_val].downcase}%'"
	   if  params[:search_val]=='all'
		    @attend_list = ActivityAttendDetail.find_by_sql("#{@query_all}")
	   else
		    @attend_list = ActivityAttendDetail.find_by_sql("#{@query_all} #{@parti_query}")
           end
          @search_key = params[:search_val]
          @search = 'true'
	  render :partial => 'attendees_list'
	 end
 end
 
 
 
 #sort the attendees list
 def sort_attend_list
	 if params[:sched_val] && params[:sort_val] && params[:sched_val].present? && params[:sort_val].present?
		 @schedule_id = params[:sched_val]
		if params[:sort_val].downcase=='name'
		 @attend_list = ActivityAttendDetail.find_by_sql("select attnd.*,fam.status from activity_attend_details as attnd left join fampass_details as fam on attnd.attend_id=fam.attend_id left join participants p on attnd.participant_id=p.participant_id where attnd.schedule_id=#{params[:sched_val]} order by p.participant_name")
		elsif (params[:sort_val].downcase=='code_no' ||  params[:sort_val].downcase=='fam_status')
			if params[:sort_val].downcase=='code_no'
				chk_order = 'order by attnd.ticket_code'
			elsif params[:sort_val].downcase=='fam_status'
				chk_order = 'order by fam.status desc'
			end
			@attend_list = ActivityAttendDetail.find_by_sql("select attnd.*,fam.status from activity_attend_details as attnd left join fampass_details as fam on attnd.attend_id=fam.attend_id where attnd.schedule_id=#{params[:sched_val]} #{chk_order}")
		end
		@sort = 'true'
		 render :partial => 'attendees_list'
	 else
		 render :text => 'false'
	 end
 end
 
end #controller end
