class ActivityFavorite < ActiveRecord::Base
  include IdentityCache
  attr_accessible :activity_id, :activity_name, :favorite_id, :inserted_date, :modified_date, :user_id
  belongs_to :activites
  cache_index :activity_id, :user_id #identity cache
end
