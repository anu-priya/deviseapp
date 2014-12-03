class ProviderListController < ApplicationController
  def index
    #select all city from city table
    @city = City.order("city_name")        
  end
  
  def providersubmit      
      city=params[:dd_city]
	  @activity = Activity.where("lower(city)=? and lower(created_by)=?",city.downcase,'provider').uniq.collect(&:user_id)
      @user = User.select("users.*,user_profiles.*").joins("left join user_profiles on users.user_id=user_profiles.user_id").where(:user_id=>@activity).uniq
      respond_to do |format|
          format.js
      end
  end
end
