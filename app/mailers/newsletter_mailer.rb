class NewsletterMailer < ActionMailer::Base
	default "from" => "no-reply@famtivity.com"
	layout 'newsletter'
	$image_global_path = 'http://dev.famtivity.com:8080/'
	helper LandingHelper
	#user activity count newsletter
	def user_activity_count(user)
		headers['X-No-Spam'] = 'True'
		@user = user
		@user_pro = @user.user_profile if !@user.nil?
		if !@user_pro.nil?
			bus_name = @user_pro.business_name
		else
			bus_name = @user.user_name
		end
		#mail(:to => @user.email_address, :bcc => 'sithankumar@i-waves.com,durgadevi@i-waves.com', :subject => "Your Famtivity Report")
		mail(:to => 'no-rely@famtivity.com', :subject => "Your Famtivity Report")		
		#mail(:to => 'support@famtivity.com,heidi@famtivity.com', :subject => "Final | Michael To Review | #{bus_name} - #{@user.email_address} | Your Famtivity Report")
		#mail(:to => 'sithankumar@i-waves.com,durgadevi@i-waves.com', :subject => "Final | Michael To Review | #{bus_name} - #{@user.email_address} | Your Famtivity Report")
	end
	
	def metric_report(user,mode,to_mail,end_date)
		headers['X-No-Spam'] = 'True'
		@user = user
		@user_pro = @user.user_profile if !@user.nil?
		if !@user_pro.nil?
			bus_name = @user_pro.business_name
		else
			bus_name = @user.user_name
		end
		@lastweek = end_date
		if(mode=='Review')
			mail(:to => to_mail, :subject => "Your Famtivity Report")
		else
			mail(:to => @user.email_address, :subject => "Your Famtivity Report")
		end
	end
end
