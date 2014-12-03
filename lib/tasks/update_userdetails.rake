
namespace :provider_info  do
 desc "update provider transaction details with sales limt"
   task :details_update => :environment do
	  puts "---------------starting to update---------------"
      @prvers = ProviderTransaction.select('distinct user_id')
        !@prvers.nil? && @prvers.each do |providers|
	      begin
		      @pro_user = User.find(providers.user_id) if !providers.nil? && !providers.user_id.nil?
		      @puser = ProviderTransaction.where("user_id = ?",@pro_user.user_id).last if !@pro_user.nil? && !@pro_user.user_id.nil?
			if !@pro_user.nil? && !@pro_user.manage_plan.nil? && @pro_user.manage_plan.present?
				if @pro_user.manage_plan.downcase == "market_sell"	
					@puser.update_attributes(:plan_amount=>29.95, :email_address=>@pro_user.email_address, :payment_date=>@puser.inserted_date)
					puts "updated amount 25 for #{@pro_user.user_id}"
				elsif @pro_user.manage_plan.downcase == "market_sell_manage"	
					@puser.update_attributes(:plan_amount=>49.95, :email_address=>@pro_user.email_address, :payment_date=>@puser.inserted_date)
					 puts "updated amount 75 for #{@pro_user.user_id}"
				elsif @pro_user.manage_plan.downcase == "market_sell_manage_plus"	
					@puser.update_attributes(:plan_amount=>99.95, :email_address=>@pro_user.email_address, :payment_date=>@puser.inserted_date)
					 puts "updated amount 150 for #{@pro_user.user_id}"
				end
			end # puser ending
		rescue Exception => exc
			puts "#{exc.message}"
		end
	end #loop end
	  puts "---------------ending to update---------------"
   end
end