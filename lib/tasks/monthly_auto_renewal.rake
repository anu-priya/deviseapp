require 'logger'
#this task for monthly basis auto renewal for the registered provider based on the manage plan by U.Rajkumar 2014.1.18
namespace :monthly_auto_renewal do

  desc "Monthly Auto-renewal for the provider users"
  task :provider_amount => :environment do
	@sval = []
	puts '----Auto renewal amount detection for monthly basis started----'	
	@prvers = ProviderTransaction.select('distinct user_id')
	  !@prvers.nil? && @prvers.each do |providers|
		  @usr_tran_amt  = ''
	begin
		@puser = ProviderTransaction.where("user_id = ?",providers.user_id).last if !providers.nil?
		if @puser && !@puser.nil? && !@puser.end_date.nil? && @puser.end_date!="" && @puser.end_date.present?
			@thirty_day = @puser && @puser.end_date
			
			current_day_in = Time.now-1.days			
			current_day = current_day_in.strftime("%Y-%m-%d")

			if @thirty_day && @thirty_day.strftime("%Y-%m-%d") == "#{current_day}"
				puts "Auto-Renewal time #{@thirty_day.strftime("%Y-%m-%d")}"
				
				@r_user = User.find_by_user_id_and_account_active_status_and_is_partner(providers.user_id,true,false) if !providers.nil?
				@uid = @r_user.user_id if !@r_user.nil?
					
		
				if !@r_user.nil? && @r_user.present? && @r_user.user_status != 'deactivate'			
					if @r_user.user_plan!= 'curator' 
					if @r_user.manage_plan!='school'						
					  @payment_detail = UserTransaction.where("user_id = ?",providers.user_id).last if !providers.nil? && providers.present?
					 #authorize information started
						if !@payment_detail.nil? && @payment_detail.present? && !@r_user.nil? && @r_user.present?
							#sell manage user amount details started here
							#check the downgrade plan for the provider user for auto renewal
							#if !@r_user.nil? && @r_user !="" && !@r_user.user_status.nil? && @r_user.user_status.present? && @r_user.user_status=="deactivate"  && @r_user.is_partner==false
							#	@usr_tran_amt = 4.95 #deactivate maintenance fee4.95$
							#	if !@r_user.nil? && @r_user !="" && !@r_user.manage_plan.nil? && @r_user.manage_plan.present?
								#	@r_user.update_attributes(:user_plan=>"sell", :manage_plan=>"market_sell", :downgrade_plan=>nil)								
								#	if @r_user.manage_plan.downcase == "market_sell"
								#	sales_pro_limit = 25
								#	plan_amount_tot = 29.95
								#	elsif @r_user.manage_plan.downcase == "market_sell_manage"
								#	sales_pro_limit = 25
								#	plan_amount_tot = 29.95
								#	elsif @r_user.manage_plan.downcase == "market_sell_manage_plus"
								#	sales_pro_limit = 25
								#	plan_amount_tot = 29.95
								#	end
								#end
							#els
							if !@r_user.nil? && @r_user !="" && !@r_user.downgrade_plan.nil? && @r_user.downgrade_plan.present?  && @r_user.is_partner==false
								@r_user.update_attributes(:user_plan=>"sell", :manage_plan=>"market_sell", :downgrade_plan=>nil)
								if !@r_user.nil? && @r_user !="" && !@r_user.manage_plan.nil? && @r_user.manage_plan.present?
									if @r_user.manage_plan.downcase == "market_sell"
									@usr_tran_amt = 29.95 #marget sell user amount 29.95$
									sales_pro_limit = 25
									plan_amount_tot = 29.95
									elsif @r_user.manage_plan.downcase == "market_sell_manage"
									@usr_tran_amt = 29.95 #marget sell user amount 49.95$
									sales_pro_limit = 25
									plan_amount_tot = 29.95
									elsif @r_user.manage_plan.downcase == "market_sell_manage_plus"
									@usr_tran_amt = 29.95 #marget sell user amount 99.95$
									sales_pro_limit = 25
									plan_amount_tot = 29.95
									end
								end
							elsif !@r_user.nil? && @r_user !="" && !@r_user.manage_plan.nil? && @r_user.manage_plan.present? && @r_user.is_partner==false
								@r_user.update_attributes(:user_plan=>"sell", :manage_plan=>"market_sell", :downgrade_plan=>nil)														
								if @r_user.manage_plan.downcase == "market_sell"
								@usr_tran_amt = 29.95 #marget sell user amount 29.95$
								sales_pro_limit = 25
								plan_amount_tot = 29.95
								elsif @r_user.manage_plan.downcase == "market_sell_manage"
								@usr_tran_amt = 29.95 #marget sell user amount 49.95$
								sales_pro_limit = 25
								plan_amount_tot = 29.95
								elsif @r_user.manage_plan.downcase == "market_sell_manage_plus"
								@usr_tran_amt = 29.95 #marget sell user amount 99.95$
								sales_pro_limit = 25
								plan_amount_tot = 29.95
								end
							end #sell manage user amount details
							if !@usr_tran_amt.nil? && @usr_tran_amt > 0
								transaction = 
							      {:transaction => {
								:type => :auth_capture,
								:amount => "#{@usr_tran_amt}", #marget sell provider auto renewal detection by rajkumar
								:customer_profile_id => @payment_detail.customer_profile_id,
								:customer_payment_profile_id => @payment_detail.customer_payment_profile_id
													}
												}
								#create the transaction for the user
								response = CIMGATEWAY.create_customer_profile_transaction(transaction)
								if !response.nil? && response.success?
									#action type for deactivate and auto renewal
									if !@r_user.nil? && @r_user !="" && !@r_user.user_status.nil? && @r_user.user_status.present? && @r_user.user_status=="deactivate"
										action_type_values = "deactivate"
									else
										action_type_values = "auto_renewal"
									end #action type ending here
									provider_trans_id = "#{response.authorization}" if !response.nil? && !response.authorization.nil?
									#~stored the transaction success information in provider transaction table
									@p_trans = ProviderTransaction.create(:user_id=>@r_user.user_id, :amount=>@usr_tran_amt, :user_plan=>@r_user.manage_plan, :customer_profile_id=>@payment_detail.customer_profile_id, :customer_payment_profile_id=>@payment_detail.customer_payment_profile_id, :inserted_date=>Time.now, :modified_date=>Time.now, :start_date=>Time.now, :end_date=>Time.now+30.days, :grace_period_date=>Time.now+37.days, :action_type=>action_type_values, :sales_limit=>sales_pro_limit, :purchase_limit=>0, :expiry_status=>true, :payment_date=>Time.now, :plan_amount=>plan_amount_tot, :email_address=>@r_user.email_address, :transaction_id=>provider_trans_id) if !@r_user.nil? && !@usr_tran_amt.nil? && !@payment_detail.nil? 
									#send a mail to provider about the transaction
									#UserMailer.delay(queue: "Auto-renewal Success to provider", priority: 1, run_at: 10.seconds.from_now).autorenewal_success_to_provider(@r_user,@usr_tran_amt)
									UserMailer.delay(queue: "Auto-renewal Success to Admin", priority: 1, run_at: 10.seconds.from_now).autorenewal_success_to_famtivity(@r_user,@usr_tran_amt)
									
									#create the log files for the provider transaction information
									create_log_file_here(@usr_tran_amt,@uid,response,@sval)
								else
									#create the log files for the provider transaction information
									create_log_file_here(@usr_tran_amt,@uid,response,@sval)
									#send a mail to provider about the transaction
									UserMailer.delay(queue: "Auto-renewal failure to provider", priority: 1, run_at: 10.seconds.from_now).autorenewal_failure_to_provider(@r_user,@usr_tran_amt,response.message) if response
									UserMailer.delay(queue: "Auto-renewal failure to Admin", priority: 1, run_at: 10.seconds.from_now).autorenewal_failure_to_famtivity(@r_user,@usr_tran_amt,response.message) if response
									#~stored the transaction failure information in leads table
								end #auth response end
							end
						end #payment details loop end
						#authorize information end
					end  #school end
					end  #curator end
				end
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
	#print the array values
		if @sval
		#log_v = Logger.new("/var/www/famtivity_logs/payment_transactions/#{Time.now.strftime("%Y-%m-%d")}_transaction_log.txt", 'daily')
		log_v = Logger.new("log/#{Time.now.strftime("%Y-%m-%d")}_transaction_log.txt", 'daily')
		log_v.info "\n\r ============================================================================="
		log_v.info "#{@sval}\n\r"
		log_v.info "=============================================================================\n\r"
		log_v.close
		end
	puts "=============================================="  
  end

  def create_log_file_here(amt,uid,resp,arr)
	#~ log_v = Logger.new("log/#{uid}.txt", 'daily') if !uid.nil?	
	arr << "Authorize response #{resp.message if !resp.nil?}."
	arr << "Authorize Time #{Time.now}."
	arr << "Transaction amount is $#{amt}."
	arr << "Transaction User id is #{uid if !uid.nil?}."	
	arr << "Hi User please check the user id #{uid if !uid.nil?}."	
  end #method ending here
  
end #name space ending here
