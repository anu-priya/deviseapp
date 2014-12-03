
namespace :activity_network  do
 desc "update the activity attend table with email for users"
   task :update_attendees => :environment do
      @attndees = ActivityAttendDetail.all
      @attndees.each do |c|
	 user = User.where("user_id=?",c.user_id).last
	 if c && c.present? && c.user_id && !c.user_id.nil? && user && !user.nil? && !c.attendies_email.present?
		 c.attendies_email = user.email_address
		 c.save
	 end
      end
   end
end