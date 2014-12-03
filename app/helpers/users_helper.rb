module UsersHelper

def city_detail_list
	city = City.where("state_id = 1 and country_id = 1").order("city_name Asc")
end
def uservaluesstore(uid)
	@user_usr=User.where("user_id=?",uid).last
	add_sign_count = @user_usr.sign_in_count if !@user_usr.sign_in_count.nil?
	@user_usr.sign_in_count = (add_sign_count.nil? || add_sign_count==0) ?  1 : (add_sign_count+1)
	@user_usr.last_sign_in = Time.now
	@user_usr.save
	return @user_usr
end

def usercreditvalues(user)
	 #user credit values
	#~ @u_cdts = UserCredit.new
	#~ @u_cdts.user_id = user.user_id if user.present? && user.user_id.present?
	#~ @u_cdts.credit_amount = 20
	#~ @u_cdts.provider_plan = user.user_plan if user.present?
	#~ @u_cdts.inserted_date = Time.now
	#~ @u_cdts.modified_date = Time.now
	#~ @u_cdts.credit_type = "register"
	#~ @u_cdts.save
	
	#auto login
	cookies[:date_registered_usr] = Time.now.strftime("%Y-%m-%d") if cookies[:date_registered_usr].nil?
	cookies[:login_usr] = "on"
	cookies[:role_usr]= user.user_type if user && user.user_type
	cookies[:logged_in] = "yes"
	session[:user_id] = user.user_id if user && user.user_id
	cookies.permanent[:uid_usr] = user.user_id if user && user.user_id
	cookies.permanent[:username_usr] = user.user_name if user && user.user_name
	cookies[:email_usr] = user.email_address if user && user.email_address
end

def updateproviderdetails(user)
	@p_tran_val = ProviderTransaction.find_by_user_id(user.user_id) if !user.nil? && user.present?
	@p_tran_val.update_attributes(:start_date=>Time.now, :end_date=>Time.now+30.days, :grace_period_date=>Time.now+37.days) if !@p_tran_val.nil?
end

end
