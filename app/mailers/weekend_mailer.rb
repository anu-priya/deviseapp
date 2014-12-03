class WeekendMailer < ActionMailer::Base
  
  default "from" => "user@famtivity.com"
	layout 'weekend'
	$image_global_path = 'http://54.243.133.232:8080/'
	helper LandingHelper
	
	#weekend newsletter template
	def weekend_template(email)		
		headers['X-No-Spam'] = 'True'
		mail(:to => email, :subject => "Weekend Newsletter")	
		
	end
end
