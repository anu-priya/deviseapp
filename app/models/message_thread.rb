class MessageThread < ActiveRecord::Base
attr_accessible :msg_flag,:sms_status
belongs_to :message
has_many :message_thread_viewers
has_many :message_files
require 'send_sms'
def self.deleteMsgThrd(msg_thread_id,user)
	                 msg_thread = MessageThread.find(msg_thread_id)
			 msg = Message.find(msg_thread.message_id)
			 msg_threadss = MessageThread.where("message_id=? and msg_flag=? and posted_by=?",msg_thread.message_id,true,user.user_id)
			 to_chk_msgthrd = msg_threadss.count
			 thread_in_viewer_ids = msg.message_threads.map(&:thread_id)-msg_threadss.map(&:thread_id)
			 to_chk_thrdviewer = MessageThreadViewer.where("message_thread_id in (?) and user_id=?",thread_in_viewer_ids,user.user_id).count
			 to_chk_last = to_chk_msgthrd+to_chk_thrdviewer
			 chklast_msg = (to_chk_last && to_chk_last > 1) ? 'not_last' : 'last'
			 msg_thread.update_attributes(msg_flag: false)  if user.user_id == msg_thread.posted_by
			 viewer = MessageThreadViewer.where("message_thread_id=? and user_id=?",msg_thread_id,user.user_id).last
			 viewer.delete if viewer && !viewer.nil? && viewer.present?
			return msg_thread.message_id,chklast_msg
end
		
		
#~ #To Send Notification for Fam Network
def self.send_notification_network(notify_users,curr_user,res,url)

	notify_users && notify_users.each do |n_user|
		c_user = ContactUser.find(n_user)
		if c_user && c_user.fam_user_id && c_user.fam_user_id.present?
		to_user = User.find(c_user.fam_user_id)
		user_prof = to_user.user_profile
		result  = ParentNotificationDetail.find_by_sql("select p.* from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id  where pn.notify_action='7' and lower(pn.notify_status)='active'and p.user_id=#{c_user.fam_user_id}")
		#To send email to the members of the group
		if (to_user && to_user.user_flag && (!result.present? || (result && result.present? && result.last.notify_flag?)))
			FamtivityNetworkMailer.delay(queue: "Fam Network Delete", priority: 2, run_at: 10.seconds.from_now).fam_network_delete_to_owner(to_user,res.group_name,url)
		end
		#To send sms
			SendSMS.send_sms_to_users(to_user,curr_user,result.last.parent_notify_id,'parent',res,url) if result && result.present? && result.last.notify_by_sms && to_user && to_user.user_flag && user_prof && user_prof.sms_mobile_num && user_prof.sms_mobile_num.present?
			#~ SendSMS.delay(queue: "Send message", priority: 2, run_at: 10.seconds.from_now).send_sms_to_users(msg_thrd,to_user,curr_user,result.last.parent_notify_id,'parent') if result && result.present? && result.last.notify_by_sms
		end
	end
end


end