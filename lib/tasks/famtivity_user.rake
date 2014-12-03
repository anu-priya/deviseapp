namespace :famtivity_user  do
  desc "update the fam_user_id in contact user table for old contact"
  task :contact => :environment do
   @contacts= ContactUser.find(:all) 
   @contacts.each do |con|
    user = User.find_by_email_address(con.contact_email)
    if !con.contact_user_type.nil? && con.contact_user_type=='friend'
      con.update_attributes(:fam_user_id=>user.user_id) if !user.nil?
    else
      con.update_attributes(:fam_user_id=>user.user_id,:contact_user_type=>"member") if !user.nil?
    end
      p "famtivity_user_id: #{con.contact_id}" if !user.nil?
   end  if !@contacts.nil? && @contacts.present?
   @fb_contacts= ContactUser.where("profile_id IS NOT NULL")
   @fb_contacts.each do |fcon|
    fbuser = User.find_by_fb_id(fcon.profile_id)
     if !fcon.contact_user_type.nil? && fcon.contact_user_type=='friend'
       fcon.update_attributes(:fam_user_id=>fcon.contact_id) if !fbuser.nil?
     else
       fcon.update_attributes(:fam_user_id=>fbuser.user_id,:contact_user_type=>"member") if !fbuser.nil?
     end 
      p "famtivity_facebookuser_id: #{fcon.profile_id}" if !fbuser.nil?
   end  if !@fb_contacts.nil? && @fb_contacts.present?
  end
end

