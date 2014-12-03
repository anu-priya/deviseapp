module ActivityNetworkHelper


 def attendeesListNet(act_sched)
	 if act_sched && !act_sched.nil? && act_sched.present?
		attndees = ActivityAttendDetail.find_by_sql("select attnd.*,fam.status from activity_attend_details as attnd left join fampass_details as fam on attnd.attend_id=fam.attend_id where attnd.schedule_id=#{act_sched.schedule_id}")
	 end
 end
 
 def getuserval(uid)
	 user=User.find(uid) if !uid.nil?
 end
 
 def getactpermival(mid,actid,sid,pid)
	 @anetval = ActivityNetworkPermission.find_by_activity_id_and_schedule_id_and_provider_user_id_and_manager_user_id(actid,sid,pid,mid) if !actid.nil? && !sid.nil? && !pid.nil? && !mid.nil?
 end
 
 #get the managers values
 def get_assigned_provider_val(uid)
	 @provider_users = User.find_by_sql("select * from users where user_id in (select provider_user_id from activity_network_permissions where manager_user_id = #{uid})") if !uid.nil?
 end
 
 def getprovider_val(pid)
	user=User.find(pid) if !pid.nil?
end

 def schoolRepFind(acti_id,cur_user_id)
	 school = SchoolRepresentative.where("activity_id=? and vendor_id=?",acti_id,cur_user_id).last
 end
 
 
end
