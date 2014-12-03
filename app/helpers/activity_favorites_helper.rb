module ActivityFavoritesHelper
	
	#displayed the icon based on the favorites 
	def get_user_favorite(uid,acid)
		 #~ @usrfav = ActivityFavorite.find_by_activity_id_and_user_id(acid,uid) if uid && acid
		 @usrfav = ActivityFavorite.fetch_by_activity_id_and_user_id(acid,uid) if uid && acid #identity cache
		 if @usrfav && @usrfav.present?
			 return true
		 else
			 return false
		 end
	end

end
