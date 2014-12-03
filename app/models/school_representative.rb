class SchoolRepresentative < ActiveRecord::Base
   attr_accessible :status,:edit_p,:delete_p
     include IdentityCache
     cache_index :activity_id
   def updateSchoolStatus(get_current_url)
		act = Activity.find(self.activity_id)
		#~ updated = act.update_attributes(active_status: 'Active') if act
		school_update = self.update_attributes(status: 'accepted') 
		if school_update
			to_user = User.find(self.vendor_id)
			from_user = User.find(self.representative_id)
			request = 'accept'
			UserMailer.delay(queue: "Send representative the activity", priority: 2, run_at: 10.seconds.from_now).activity_represent_invite_mail(self,act,to_user,from_user,get_current_url,request)	
		end
	end
	
#get representative details 
def self.getrep_details(activityid)
	@activity_rep = SchoolRepresentative.find_by_activity_id(activityid) if !activityid.nil? && activityid!=''
	if !@activity_rep.nil? && @activity_rep.present?		
		@represent = User.find_by_user_id(@activity_rep.representative_id)		
		@represent_pro = @represent.user_profile  if !@represent.nil? && @represent.present?
		if !@represent_pro.nil? && @represent_pro.present?
			@rep_name = @represent_pro.business_name
			@rep_email = @represent.email_address
		end
		@rep_share = @activity_rep.share.to_i
		@pro_share = 100 - @rep_share if !@rep_share.nil?
		return  @rep_name, @rep_email,@rep_share,@pro_share 
	else
		return nil
	end	
	
end

end