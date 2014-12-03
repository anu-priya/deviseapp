class EmbedController < ApplicationController
	 before_filter :set_access_control_headers
	after_filter :set_access_control_headers
  
  layout "false"
    def set_access_control_headers
	#~ headers['Access-Control-Allow-Origin'] = '*'
	#~ headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
	#~ headers['Access-Control-Request-Method'] = '*'
	#~ headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

	#~ headers["Access-Control-Allow-Origin"] = "*"
	#~ headers["Access-Control-Allow-Methods"] = %w{GET POST PUT DELETE}.join(",")
	#~ headers["Access-Control-Allow-Headers"] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(",")

	#~ head(:ok) if request.request_method == "OPTIONS"
	headers['Access-Control-Allow-Origin'] = "*"
        headers['Access-Control-Request-Method'] = %w{GET POST}.join(",")  

end
	def activity_embed		
		arr = []
		@activity = []
		
		if params[:provider_token]  && params[:provider_token]!=''
			proid_split = Base64.decode64(params[:provider_token]).split('$')	
			@user = User.where("user_id =? and date(user_created_date)=?",proid_split[0].to_i,proid_split[1]).last  if !proid_split.nil? && !proid_split[0].nil? && proid_split[0]!=''
			if !@user.nil? && @user.present?
				@embed_user=proid_split[0]
				@embed_act_id=params[:activity] if !params[:activity].nil? && params[:activity] !=""	
				@activity = Activity.find_by_sql("select distinct a.* from activities a left join activity_schedules sch on a.activity_id=sch.activity_id where user_id=#{@user.user_id} and date(expiration_date)>='#{Time.now.strftime("%Y-%m-%d")}' and lower(active_status)='active' and lower(created_by)='provider'")		
			else
				@msg ="Invalid token"
			end
		else
			@msg ="Invalid token"
		end
		render :partial => "embed"
	end
    
	def get_provider_activity(userid)
		
	end
   
    
end
