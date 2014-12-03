namespace :activity_share  do
  desc "update the share_id in activity shared table for email reciver"
  task :share => :environment do
   @act_shared= ActivityShared.find(:all) 
   @act_shared.each do |act|
    user = User.find_by_email_address(act.shared_to)
      act.update_attributes(:share_id=>user.user_id) if !user.nil?
      p "Share id: #{act.share_id}"
   end  if !@act_shared.nil? && @act_shared.present?
  end
end