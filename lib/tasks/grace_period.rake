  require 'date'
  require 'time'
namespace :grace_period do

  desc "Sent a mail to provider for auto-renewal"
  task :activate_grace => :environment do
  puts '----Auto renewal alert mail starting----'
	puts "=============================================="
	@prvers = ProviderTransaction.select('distinct user_id')
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
						#@thirty = @puser && @puser.end_date
						@thirty_second = @puser && @puser.end_date+2.days
						@thirty_4th = @puser && @puser.end_date+4.days
						@thirty_6th = @puser && @puser.end_date+6.days
						#sent a mail to provider fot the 30th day
						@r_user = User.find(providers.user_id) if !providers.nil?
						#if @thirty && @thirty.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							#puts "Renewal alert time #{@thirty.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							 # UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_renewal_alert(@r_user) if !@r_user.nil?
						#sent a mail to provider fot the 32nd day
						#els
						if @thirty_second && @thirty_second.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_second.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							  #~ UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_renewal_alert(@r_user) if !@r_user.nil?
						#sent a mail to provider fot the 34th day
						elsif @thirty_4th && @thirty_4th.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_4th.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							  #~ UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_renewal_alert(@r_user) if !@r_user.nil?
						#sent a mail to provider fot the 36th day
						elsif @thirty_6th && @thirty_6th.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_6th.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							  #~ UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_renewal_alert(@r_user) if !@r_user.nil?
						else
						puts "End date not over"   
						end
					elsif @actattend.nil?
						puts "There is no attendies"
					end #attend condition ending here
				elsif @pro_user.manage_plan.downcase == "market_sell_manage"	
					if (!@actattend.nil? && !@actattend.length.nil? && @actattend.length < 75)
						#@thirty = @puser && @puser.end_date
						@thirty_second = @puser && @puser.end_date+2.days
						@thirty_4th = @puser && @puser.end_date+4.days
						@thirty_6th = @puser && @puser.end_date+6.days
						#sent a mail to provider fot the 30th day
						@r_user = User.find(providers.user_id) if !providers.nil?
						#if @thirty && @thirty.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
						#	puts "Renewal alert time #{@thirty.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
						#	  UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_renewal_alert(@r_user) if !@r_user.nil?
						#sent a mail to provider fot the 32nd day
						#els
						if @thirty_second && @thirty_second.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_second.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							  #~ UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_renewal_alert(@r_user) if !@r_user.nil?
						#sent a mail to provider fot the 34th day
						elsif @thirty_4th && @thirty_4th.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_4th.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							  #~ UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_renewal_alert(@r_user) if !@r_user.nil?
						#sent a mail to provider fot the 36th day
						elsif @thirty_6th && @thirty_6th.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_6th.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							  #~ UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_renewal_alert(@r_user) if !@r_user.nil?
						else
						puts "End date not over"   
						end
					elsif @actattend.nil?
						puts "There is no attendies"
					end #attend condition ending here
				elsif @pro_user.manage_plan.downcase == "market_sell_manage_plus"	
					if (!@actattend.nil? && !@actattend.length.nil? && @actattend.length < 150)
						#@thirty = @puser && @puser.end_date
						@thirty_second = @puser && @puser.end_date+2.days
						@thirty_4th = @puser && @puser.end_date+4.days
						@thirty_6th = @puser && @puser.end_date+6.days
						#sent a mail to provider fot the 30th day
						@r_user = User.find(providers.user_id) if !providers.nil?
						#if @thirty && @thirty.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
						#	puts "Renewal alert time #{@thirty.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
						#	  UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_renewal_alert(@r_user) if !@r_user.nil?
						#sent a mail to provider fot the 32nd day
						#els
						if @thirty_second && @thirty_second.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_second.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							  #~ UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_renewal_alert(@r_user) if !@r_user.nil?
						#sent a mail to provider fot the 34th day
						elsif @thirty_4th && @thirty_4th.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_4th.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							  #~ UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_renewal_alert(@r_user) if !@r_user.nil?
						#sent a mail to provider fot the 36th day
						elsif @thirty_6th && @thirty_6th.strftime("%Y-%m-%d") == Time.now.strftime("%Y-%m-%d")
							puts "Renewal alert time #{@thirty_6th.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
							  #~ UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_renewal_alert(@r_user) if !@r_user.nil?
						else
						puts "End date not over for the #{@pro_user.user_id}"   
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
	puts "=============================================="
  puts '----Auto renewal alert mail ending------'
  end
  
end
