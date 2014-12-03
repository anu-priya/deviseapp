require 'logger'
#this task for monthly basis auto renewal for the registered provider based on the manage plan by U.Rajkumar 2014.1.18
namespace :monthly_deactivate do

  desc "Monthly De-activate the provider users"
  task :provider_users => :environment do
  puts '----Automatic deactivate for the provider users started----'
	puts "=============================================="
	@prvers = ProviderTransaction.select('distinct user_id')
	  !@prvers.nil? && @prvers.each do |providers|
		begin
			@puser = ProviderTransaction.where("user_id = ?",providers.user_id).last if !providers.nil?
			if @puser && !@puser.nil? && !@puser.grace_period_date.nil? && @puser.grace_period_date!="" && @puser.grace_period_date.present?
				@grace_date = @puser && @puser.grace_period_date
				#sent a mail to provider fot the 30th day auto renewal
				if @grace_date && @grace_date!="" && @grace_date.strftime("%Y-%m-%d") < Time.now.strftime("%Y-%m-%d")
					@r_user = User.find(providers.user_id) if !providers.nil?
					puts "Auto-matic deactivate time #{Time.now.strftime("%Y-%m-%d")} for the userId #{@r_user.user_id}"
							#sell manage user amount details started here
							#check the downgrade plan for the provider user for auto renewal
							if !@r_user.nil? && @r_user !="" && !@r_user.manage_plan.nil? && @r_user.manage_plan.present?
								@r_user.update_attributes(:user_status=>"deactivate")
								#update the activities status as deactivate
								@act_all = Activity.where("user_id = ?",@r_user.user_id) if !@r_user.nil? && @r_user.user_id!=""
								!@act_all.nil? && @act_all.each do |activity|
									if !activity.nil? && !activity.active_status.nil? && activity.active_status == "Active"
									activity.update_attributes(:active_status=>"deactivate")
									end #active status condition ending here
								end #ending
								#sent a mail to provider about deactivate
								UserMailer.delay(queue: "Deactivate account", priority: 1, run_at: 5.seconds.from_now).user_account_deactivated(@r_user) if @r_user
							end #sell manage user amount details
				else
				puts "-----Not reached the date for automatic de-activate-------"   
				end
			else
				puts "--------There is no end date for automatic de-activate for providers-------"  
			end
		rescue Exception => exc
				puts "#{exc.message}"
		end #begin ending here
	end #do ending here
	puts "=============================================="
   puts '----Automatic deactivate for the providers ending----'
  end #environment do ending
  
end #name space ending here
