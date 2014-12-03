#this task for monthly basis auto renewal for the registered provider based on the manage plan by U.Rajkumar 2014.1.18
namespace :auto_renewal_process do

  desc "Auto-renewal process reports to the support team"
  task :provider_reports => :environment do
	  @arr_val = []
  puts '----Auto renewal amount detection for monthly basis users list to support team started----'
	puts "=============================================="
	@prvers = ProviderTransaction.select('distinct user_id')
	  !@prvers.nil? && @prvers.each do |providers|
	begin
		@puser = ProviderTransaction.where("user_id = ?",providers.user_id).last if !providers.nil?
		if @puser && !@puser.nil? && !@puser.end_date.nil? && @puser.end_date!="" && @puser.end_date.present?
			@thirty_day = @puser && @puser.end_date
			#sent a mail to provider fot the 30th day auto renewal
			current_day_in = Time.now-1.days
			current_day = current_day_in.strftime("%Y-%m-%d")
			#~ current_day = "2014-02-20"
			if @thirty_day && @thirty_day.strftime("%Y-%m-%d") == "#{current_day}"
				@r_user = User.find(providers.user_id) if !providers.nil?
					#check the downgrade plan for the provider user for auto renewal
					if !@r_user.nil? && @r_user !="" && !@r_user.user_status.nil? && @r_user.user_status.present? && @r_user.user_status=="deactivate"
						#deactivate maintenance fee4.95$
						puts "Auto-Renewal time started #{@thirty_day.strftime("%Y-%m-%d")} for the user #{@r_user.user_id} with (deactivate)"
						@arr_val<<@r_user
					elsif !@r_user.nil? && @r_user !="" && !@r_user.downgrade_plan.nil? && @r_user.downgrade_plan.present?
						#downgraded user
						puts "Auto-Renewal time started #{@thirty_day.strftime("%Y-%m-%d")} for the user #{@r_user.user_id} with (downgrade) plan"
						@arr_val<<@r_user
					elsif !@r_user.nil? && @r_user !="" && !@r_user.manage_plan.nil? && @r_user.manage_plan.present?
						#manage sell user
						puts "Auto-Renewal time started #{@thirty_day.strftime("%Y-%m-%d")} for the user #{@r_user.user_id} with #{@r_user.manage_plan}"
						@arr_val<<@r_user
					end #sell manage user amount details
			else
			puts "-----Not reached the date for auto renewal-------"   
			end
		else
			puts "--------There is no end date for auto renewal-------"  
		end
	rescue Exception => exc
			puts "#{exc.message}"
	end #begin ending here
	end #do ending here

	#=====================daily grace period users list starting here==================================#
		 @arr_val_grace = []
		 !@prvers.nil? && @prvers.each do |providers|
		 begin
		@puser = ProviderTransaction.where("user_id = ?",providers.user_id).last if !providers.nil? && !providers.user_id.nil?
		 @start_date = @puser.start_date.strftime("%Y-%m-%d") if !@puser.nil? && !@puser.start_date.nil? && @puser.start_date.present?
		 @end_date = @puser.end_date.strftime("%Y-%m-%d") if !@puser.nil? && !@puser.end_date.nil? && @puser.end_date.present?
		if @puser && !@puser.nil? && !@puser.end_date.nil? && @puser.end_date!="" && @puser.end_date.present?
			 @actattend = ActivityAttendDetail.find_by_sql("select attend_id from activity_attend_details where activity_id in (select activity_id from activities where user_id=#{providers.user_id}) and (inserted_date between date('#{@start_date}') and date('#{@end_date}'))") if !providers.nil? && !providers.user_id.nil? && !@start_date.nil? && !@end_date.nil?
			@pro_user = User.find(providers.user_id) if !providers.nil? && !providers.user_id.nil?
			if !@pro_user.nil? && !@pro_user.manage_plan.nil? && @pro_user.manage_plan.present?
				if @pro_user.manage_plan.downcase == "market_sell"	
					if (!@actattend.nil? && !@actattend.length.nil? && @actattend.length < 25)
						@thirty_second = @puser && @puser.end_date+2.days
						@thirty_4th = @puser && @puser.end_date+4.days
						@thirty_6th = @puser && @puser.end_date+6.days
						#sent a mail to provider for 32nd day during grace period
						if @thirty_second && @thirty_second.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_second.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							@arr_val_grace<<@pro_user
						#sent a mail to provider fot the 34th day
						elsif @thirty_4th && @thirty_4th.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_4th.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							@arr_val_grace<<@pro_user
						#sent a mail to provider fot the 36th day
						elsif @thirty_6th && @thirty_6th.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_6th.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							@arr_val_grace<<@pro_user
						else
						puts "End date not over"   
						end
					elsif @actattend.nil?
						puts "There is no attendies"
					end #attend condition ending here
				elsif @pro_user.manage_plan.downcase == "market_sell_manage"	
					if (!@actattend.nil? && !@actattend.length.nil? && @actattend.length < 75)
						@thirty_second = @puser && @puser.end_date+2.days
						@thirty_4th = @puser && @puser.end_date+4.days
						@thirty_6th = @puser && @puser.end_date+6.days
						#sent a mail to provider fot the 32nd day
						if @thirty_second && @thirty_second.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_second.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							@arr_val_grace<<@pro_user
						#sent a mail to provider fot the 34th day
						elsif @thirty_4th && @thirty_4th.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_4th.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							@arr_val_grace<<@pro_user
						#sent a mail to provider fot the 36th day
						elsif @thirty_6th && @thirty_6th.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_6th.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							@arr_val_grace<<@pro_user
						else
						puts "End date not over"   
						end
					elsif @actattend.nil?
						puts "There is no attendies"
					end #attend condition ending here
				elsif @pro_user.manage_plan.downcase == "market_sell_manage_plus"	
					if (!@actattend.nil? && !@actattend.length.nil? && @actattend.length < 150)
						@thirty_second = @puser && @puser.end_date+2.days
						@thirty_4th = @puser && @puser.end_date+4.days
						@thirty_6th = @puser && @puser.end_date+6.days
						#sent a mail to provider fot the 32nd day
						if @thirty_second && @thirty_second.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_second.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							@arr_val_grace<<@pro_user
						#sent a mail to provider fot the 34th day
						elsif @thirty_4th && @thirty_4th.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_4th.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							@arr_val_grace<<@pro_user
						#sent a mail to provider fot the 36th day
						elsif @thirty_6th && @thirty_6th.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_6th.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							@arr_val_grace<<@pro_user
						else
						puts "End date not over for the user #{@pro_user.user_id}"   
						end
					elsif @actattend.nil?
						puts "There is no attendies"
					end #attend condition ending here
				end #manage plan condition checking here
			end #pro user ending here
		end # end date present condition checked
		rescue Exception => exc
			puts "#{exc.message}"
		end
	  end #do ending here
	#=====================daily grace period users list ending here==================================#
	
	#print the array values for the provider support team
	if (@arr_val && @arr_val.present? && @arr_val!="" && @arr_val != []) || (@arr_val_grace && @arr_val_grace.present? && @arr_val_grace!="" && @arr_val_grace != [])
		#send a mail to support team for auto-renewal user list
		UserMailer.delay(queue: "Auto-renewal process list to support team", priority: 1, run_at: 10.seconds.from_now).autorenewal_report_to_famtivity(@arr_val,@arr_val_grace)
	else
		puts "there are no users for auto-renewal today"
		@arr_val=[]
		@arr_val_grace=[]
		UserMailer.delay(queue: "Auto-renewal process list to support team", priority: 1, run_at: 10.seconds.from_now).autorenewal_report_to_famtivity(@arr_val,@arr_val_grace)
	end
	
	puts "=============================================="
    puts '----Auto renewal amount detection for monthly basis users list to support team ending here----'
  end
  
end #name space ending here
