namespace :city_update do
  desc "update the share_id in activity shared table for email reciver"
  task :activity => :environment do
    @cities = City.find(:all)
    @cities.each do |act|
      p act.latitude
      p act.longitude
      @act = Activity.where("lower(city) = '#{act.city_name.downcase}'").update_all(:latitude => act.latitude,:longitude=>act.longitude)
      @user = User.joins(:user_profile).where("lower(city) = '#{act.city_name.downcase}'").readonly(false).update_all(:latitude => act.latitude,:longitude=>act.longitude)
#      @user.each do |u|
#        u.latitude = act.latitude
#        u.longitude = act.longitude
#        u.save
#      end
      #      @act.each do|a|
      #        a.update_attributes(:latitude => act.latitude,:longitude=>act.longitude)
      #      end
      p act.city_name
    end  if !@cities.nil? && @cities.present?
  end
end