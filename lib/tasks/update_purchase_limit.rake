
namespace :provider_tran  do
 desc "update provider transaction details with activity purchase limt"
   task :purchased_update => :environment do
	  puts "---------------starting to update---------------"
      @prvers = ProviderTransaction.select('distinct user_id')
        !@prvers.nil? && @prvers.each do |providers|
	      begin
		      @pro_user = User.find(providers.user_id) if !providers.nil? && !providers.user_id.nil?
		      #provider activities attend limit
			@tdy_date = Time.now.strftime("%Y-%m-%d")
			@p_tran = ProviderTransaction.find_by_sql("select * from provider_transactions where user_id=#{@pro_user.user_id} order by id desc limit 1") if !@pro_user.nil? && !@pro_user.user_id.nil?
			@start_date = @p_tran[0].start_date.strftime("%Y-%m-%d") if !@p_tran.nil? && !@p_tran[0].nil? && !@p_tran[0].start_date.nil? && @p_tran[0].start_date.present?
			@end_date = @p_tran[0].end_date.strftime("%Y-%m-%d") if !@p_tran.nil? && !@p_tran[0].nil? && !@p_tran[0].end_date.nil? && @p_tran[0].end_date.present?
			@actattend = ActivityAttendDetail.find_by_sql("select attend_id from activity_attend_details where activity_id in (select activity_id from activities where user_id=#{@pro_user.user_id}) and (inserted_date between date('#{@start_date}') and date('#{@end_date}'))") if !@pro_user.nil? && !@pro_user.user_id.nil? && !@start_date.nil? && !@end_date.nil?
		      
			if !@p_tran.nil? && !@p_tran[0].nil? && @p_tran[0].present?
				if @actattend && !@actattend.nil? && @actattend != "" && @actattend.present?
					puts "updated purchase limit for this #{@p_tran[0].user_id if !@p_tran[0].user_id.nil?}"
					@p_tran[0].update_attributes(:purchase_limit=>@actattend.length)
				else
					@p_tran[0].update_attributes(:purchase_limit=>0)
				end #activity length
			end # puser ending
		rescue Exception => exc
			puts "#{exc.message}"
		end
	end #loop end
	  puts "---------------ending to update---------------"
   end
end