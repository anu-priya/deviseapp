class NewslettersController < ApplicationController
	 before_filter :authenticate_user, :only=>[:weekend_activities]
	 
	def newsletter_template		
		@blog_value_p = []
		url = URI.parse("https://www.famtivity.com/blog/?feed=rss2")
    doc = Nokogiri::XML(open(url))
    begin
      if !doc.nil? && doc!='' && doc.present?
        (doc/'item')[0..1].each do|node|
          title = (node/'title').inner_html
          desc = (node/'description').inner_html
          link = (node/'link').inner_html
          img_srcs = desc[/img.*?src="(.*?)"/i,1]
          decs = desc.gsub(/<\/?[^>]*>/,"").gsub(/&#160;/,"")
          dec = decs.gsub("Read More","")
          title = title.gsub(/<\/?[^>]*>/,"")
          dec = dec.sub("Continue reading &#8594;","")
          dec1 = CGI::unescapeHTML(dec)
          title1 = CGI::unescapeHTML(title)
          @blog_value_p << {"title" => title1.html_safe, "description"=>dec1.html_safe,"img"=>img_srcs,"link"=>link}
        end
      end
    rescue Exception => exc
      logger.error("Message for the log file #{exc.message}")
      flash[:notice] = "Store error message"
    end  	
		render :layout => false
	end
	
	def weekend_template		
		if !params[:email].nil? && params[:email]!=''
		WeekendMailer.delay(queue: "Weekend Newsletter", priority: 2, run_at: 10.seconds.from_now).weekend_template(params[:email])
		render :text => "success"
		else
			render :text => "Please enter email address"
		end

	end
	
	#weekend_Activity added to db
	def weekend_activities
		#open form page
		#after submit the form - insert value to able
		if request.post?
			if params[:fun_activity] && params[:fun_activity]!='' && params[:special_activity] && params[:special_activity]!='' && params[:dd_activity] && params[:dd_Activity]!=''  && params[:added_by] && params[:added_by]!=''
				WeekendActivity.add_weekend_activity(params[:fun_activity],params[:special_activity],params[:dd_activity],params[:added_by],params[:bay_area])
				@error_msg = "Success"
			else
				@error_msg  = "Enter activity ids"
			end
			#check renewal provider list
			if params[:curr_date] && params[:curr_date]!=''
				#date renewal
				@renew = []
				date =params[:curr_date].split('/')
				date_cur = date[2]+"-"+date[0]+"-"+date[1] if !date.nil? && date.present?
				@renewal_p = ProviderTransaction.find_by_sql("select email_address from provider_transactions where date(end_date)='#{date_cur}' order by email_address").map(&:email_address)
				@str=@renewal_p.to_s.gsub('[','').gsub(']','').gsub('"',"'") if !@renewal_p.nil? && @renewal_p.present? && @renewal_p.length > 0			
				if !@str.nil? && !@str.include?('nil')
				@renew = ProviderTransaction.where("email_address in (#{@str})").order("email_address") if !@str.nil? && @str.present? && @str!=''
				else
					@error_renewal = 'No Renewal'
				end
				#@error_renewal = "success"			
			
			else
				@error_renewal ="Invalid date"
			end
			#check signup or upgrade  provider list
			if params[:start_date] && params[:start_date]!=''
				#date renewal
				date =params[:start_date].split('/')
				date_cur = date[2]+"-"+date[0]+"-"+date[1] if !date.nil? && date.present?
				@upgrade = ProviderTransaction.where("date(start_date)='#{date_cur}'")				
				#@error_renewal = "success"			
			
			else
				@error_upgrade ="Invalid date"
			end
			
			#check change email
			if params[:email] && params[:email]!=''
				@p_email = UserEmailChangeLog.where("lower(email_from)= ? ", params[:email].downcase).last
				
				#@error_email ="success"
			else
				@error_email = "Invalid email"
			end
			#check delete account
			if params[:det_email] && params[:det_email]!=''
				@det_email = UserDeletedAccount.where("lower(email_address)= ? ", params[:det_email].downcase).last
				
				#@error_email ="success"
			else
				@error_delete = "Invalid email"
			end
			#partner link creation
			if params[:email_partner] && params[:email_partner]!=''
				email = Base64.encode64("#{params[:email_partner]}")
				url ="http://www.famtivity.com/partner_register?view=ptr&pe=#{email}"
				@error_partner = url
			else
				@error_partner = "Enter Email Id!"
			end
			#check deactivate email 
			if params[:deact_email] && params[:deact_email]!=''
				@deact_email = User.find_by_email_address(params[:deact_email])				
			else
				@error_deactivate = "Invalid User"
			end
		end
	end
	
	
end
