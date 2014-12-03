class ProviderWebsiteTrack < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :activity_website_count, :provider_website_count, :user_id, :inserted_date, :modified_date
end
