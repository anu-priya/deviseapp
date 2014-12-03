module FamNetworkPostsHelper

def membersInChat(msg_id,curr_user)
	msg = Message.find(msg_id)
	msg_threadss = msg.message_threads.where("msg_flag=?",true)
	msg_viewer = MessageThreadViewer.where("message_thread_id in (?) and msg_thread_flag = ? and user_id=?",msg.message_threads.map(&:thread_id),true,curr_user.user_id).map(&:message_thread_id)
	thread_count = (msg_threadss.map(&:thread_id) + msg_viewer).uniq.count
	thread_postedby = MessageThread.select("distinct(posted_by)").where("thread_id in (?)",msg_viewer).limit(5).map(&:posted_by)
	posted_user = changeUserName(thread_postedby.first)
	last_user = changeUserName(thread_postedby.last) if thread_count > 1
	if thread_postedby.count==2
	   user_names = posted_user+','+last_user+'('+(thread_count.to_s)+')'
	elsif thread_postedby.count > 2
           user_names = posted_user+'..'+last_user+'('+(thread_count.to_s)+')'
	else
	   user_names = posted_user+'('+(thread_count.to_s)+')' if posted_user
        end
   return user_names
end


def changeUserName(u_id)
	if u_id && u_id.present?
	name = User.find(u_id).user_name if User.find(u_id) && User.find(u_id).user_name.present?
	short_name  = ((name.length > 8) ? name[0..7] : name) if name && name.present?
	return short_name if short_name
	end
end

end
