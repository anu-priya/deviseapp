namespace :update_accept_status  do
 desc "update activity_counts details with total_activity_count"
   task :invite => :environment do
	  puts "---------------starting to update---------------"
	    #@member= ContactUser.find_all_by_contact_user_type("non member")
	    #@member && @member.each do |con|
		#	con.update_attributes(contact_user_type: "non_member")
		#		puts "#{con.contact_id} is changed"
		#end
	  	@friend= ContactUser.find_all_by_contact_user_type("friend")
		@friend && @friend.each do |con|
			con.update_attributes(accept_status: true)
				puts "#{con.contact_id} is changed"
		end
	  puts "---------------end of update---------------"
   end
end

