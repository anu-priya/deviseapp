class ContactGroup < ActiveRecord::Base
	attr_accessible :group_id, :group_name, :inserted_date, :modified_date, :user_id,:group_status
	has_many :contact_user_groups
	has_many :contact_users, :through => :contact_user_groups
	belongs_to :user
	
	validates :group_name, :presence => {:message => "Please enter Network name."}
	validates :group_name, :uniqueness => {:scope => :user_id,:message => "Network name already exists.",:case_sensitive => false}
  
		#basic search for contact groups.
	def self.search_contactgroup(search,user_id,s_key)
		if search !="" && search !=nil
			#display the results when the user entered the text in search box.
			 find(:all, :conditions => ["user_id = ? and lower(group_name) LIKE ? ","#{user_id}", "%#{search.downcase}%"], :order => "group_name ASC")
		end
	end
end
