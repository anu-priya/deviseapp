class GuestDetail < ActiveRecord::Base
  include IdentityCache
  cache_index :guest_id  
	def addGuest(name,email,phone)
		if name && email
			self.guest_name = name
			self.guest_email = email
			self.guest_phone = phone
			self.inserted_date = Time.now
			self.modified_date = Time.now
			self.save
			self
		end
	end
	
	
end
