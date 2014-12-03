require 'twilio-ruby'

module SendSMS
	def self.send_sms_to_users(to_user,from_user,notify_id,notify_by,resource,glob_url)
		client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
		if resource
			if resource.class.to_s=='UserProfile'
				msg_content = "Your Verification Code is #{resource.sms_verify_code}"
			else
				if notify_by == 'parent'
					if (notify_id==4 && resource.class.to_s=='MessageThread')
						user = User.find(resource.posted_by)
						msg = resource.message
						msg_content = "#{user.user_name} sent a message to you on famtivity. Click http://#{glob_url}/viewmessage?message_id=#{msg.message_id}"
					elsif (notify_id==7 && resource.class.to_s=='ContactGroup')
						msg_content = "#{resource.group_name} have been deleted"
					end
				end
			end
		else
			msg_content = "Hello World"
		end
		
		to_mobile_num = (resource && resource.class.to_s == 'UserProfile') ? resource.sms_mobile_num : to_user.user_profile.sms_mobile_num
		
		begin
			sms_snt = client.account.messages.create(
			from: '+1925-304-4244',
			to: to_mobile_num,
			body: msg_content,
			#~ media_url: "https://demo.twilio.com/owl.png",
			#~ StatusCallback:  ENV['app_url']+ENV['twilio_sms_postback']+'?smsId='+textmessageId.to_s
			#~ StatusCallback:  "http://10.37.4.3000/sms_status?smsId="+mt_id.to_s
			)
			rescue Twilio::REST::RequestError => e
			puts e.message
		end
		
		if sms_snt
			test_status = client.account.messages.get(sms_snt.sid)
			add_sms_status = SmsStatus.new
			add_sms_status.from_user_id = from_user.user_id
			add_sms_status.to_user_id = to_user.user_id
			add_sms_status.from_email = from_user.email_address
			add_sms_status.to_email = to_user.email_address
			add_sms_status.sid = test_status.sid
			add_sms_status.parent_notify_id = notify_id if notify_by && notify_by.present? && notify_by == 'parent' && notify_id && notify_id.present?
			add_sms_status.provider_notify_id = notify_id if notify_by && notify_by.present? && notify_by == 'provider' && notify_id && notify_id.present?
			add_sms_status.date_created = test_status.date_created
			add_sms_status.date_updated = test_status.date_updated
			add_sms_status.date_sent = test_status.date_sent
			add_sms_status.account_sid = test_status.account_sid
			add_sms_status.to_number = test_status.to
			add_sms_status.from_number = test_status.from
			add_sms_status.body = test_status.body
			add_sms_status.status = test_status.status
			add_sms_status.num_segments = test_status.num_segments
			add_sms_status.num_media = test_status.num_media
			add_sms_status.direction = test_status.direction
			add_sms_status.api_version = test_status.api_version
			add_sms_status.price = test_status.price
			add_sms_status.price_unit = test_status.price_unit
			add_sms_status.uri = test_status.uri
			add_sms_status.save
                end
	end
end



