module UserProfilesHelper

def findCheckboxValues(check_notify)
		if (check_notify.notify_flag && check_notify.notify_by_sms)
			chk_sms_value = "checked" 
			chk_email_value = "checked" 
		elsif check_notify.notify_flag
			chk_email_value = "checked" 
			chk_sms_value = "" 
		elsif check_notify.notify_by_sms
			chk_email_value = "" 
			chk_sms_value = "checked" 
		end
	return chk_email_value,chk_sms_value
end
end
