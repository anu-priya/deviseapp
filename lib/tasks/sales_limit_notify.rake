  require 'date'
  require 'time'
namespace :sales_limit_notify do

  desc "Sent a mail to provider for renewal after reached the sales limit"
  task :sent_mail => :environment do
  puts '----Sales renewal alert mail starting----'
	puts "=============================================="
	@prvers = ProviderTransaction.select('distinct user_id')
	  !@prvers.nil? && @prvers.each do |providers|
		 begin
			@tdy_date = Time.now.strftime("%Y-%m-%d")
			@pro_user = User.find(providers.user_id) if !providers.nil? && !providers.user_id.nil?
			@p_tran = ProviderTransaction.find_by_sql("select * from provider_transactions where user_id=#{@pro_user.user_id} and (end_date >= date('#{@tdy_date}')) order by id desc limit 1") if !@pro_user.nil? && !@pro_user.user_id.nil?
			
			if !@p_tran.nil? && !@p_tran[0].nil? && @p_tran[0].present? && !@p_tran[0].purchase_limit.nil? && @p_tran[0].purchase_limit.present?
				if @pro_user && !@pro_user.nil? && !@pro_user.manage_plan.nil? && @pro_user.manage_plan.present?
					if @pro_user.manage_plan.downcase == "market_sell"	
						if (@p_tran[0].purchase_limit >= 25)
								puts "Sales limit Renewal alert time #{Time.now.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
								  UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_saleslimit_alert(@pro_user) if !@pro_user.nil?
						elsif @p_tran[0].nil?
							puts "Limitation not getting over for this provider #{@pro_user.user_id if !@pro_user.nil? && !@pro_user.user_id.nil?}"
						end #attend condition ending here
					elsif @pro_user.manage_plan.downcase == "market_sell_manage"	
						if (@p_tran[0].purchase_limit >= 75)
								puts "Sales limit Renewal alert time #{Time.now.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
								  UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_saleslimit_alert(@pro_user) if !@pro_user.nil?
						elsif @p_tran[0].nil?
							puts "Limitation not getting over for this provider #{@pro_user.user_id if !@pro_user.nil? && !@pro_user.user_id.nil?}"
						end #attend condition ending here
					elsif @pro_user.manage_plan.downcase == "market_sell_manage_plus"	
						if (@p_tran[0].purchase_limit >= 150)
								puts "Sales limit Renewal alert time #{Time.now.strftime("%Y-%m-%d")} for the #{@pro_user.user_id}"
								  UserMailer.delay(queue: "Provider renewal alert mail", priority: 1, run_at: 2.seconds.from_now).provider_saleslimit_alert(@pro_user) if !@pro_user.nil?
						elsif @p_tran[0].nil?
							puts "Limitation not getting over for this provider #{@pro_user.user_id if !@pro_user.nil? && !@pro_user.user_id.nil?}"
						end #attend condition ending here
					end #manage plan condition checking here
				end #pro user ending here
			end # end date present condition checked
		rescue Exception => exc
			puts "#{exc.message}"
		end
	  end #do ending here
	puts "=============================================="
  puts '----Sales limit renewal alert mail ending------'
  end #env end
  
end #namespace ending
