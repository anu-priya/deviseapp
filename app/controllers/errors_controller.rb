class ErrorsController < ApplicationController
  def routing
    render "#{Rails.root}/public/404", :formats => [:html,:js], :status => 404, :layout => false
    #~ notification_report    
  end
  #~ def notification_report
	 #~ @host = request.env["HTTP_HOST"]
	 #~ @u_agent = request.env["HTTP_USER_AGENT"]
	 #~ @u_path = request.env["PATH_INFO"]
	 #~ @info = request.env["HTTP_COOKIE"]
	 #~ @details=@info.split(";")
	 #~ @user_info = @details[4..-1]
	 #~ @email = 'urajkumar@i-waves.com,rajutaya@gmail.com,'
         #~ @result = UserMailer.page_issue_report(@host,@u_agent,@u_path,@user_info,@email).deliver
  #~ end
  
end