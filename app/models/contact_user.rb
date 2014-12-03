class ContactUser < ActiveRecord::Base
	attr_accessible :contact_gender,:contact, :contact_group,:contact_email, :contact_mobile, :contact_name, :group_id, :user_group, :user_usr_id, :user_id, :contact_type, :profile_id, :invite_status, :accept_status, :contact_user_type, :inserted_date, :modified_date, :fam_user_id

	has_attached_file :contact, :styles => { :small=>"190x270",:medium => "190x190", :thumb => "190x360" },
	 #:convert_options => {:small => "-quality 80 -interlace plane", :medium => "-quality 80 -interlace plane", :thumb => "-quality 80 -interlace plane"}, 
    #:processors => [:thumbnail,:compression],
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
	
	has_many :contact_user_groups
	has_many :contact_groups, :through => :contact_user_groups
  has_many :fam_network
	belongs_to :user
	
  #mobile validation for csv import
  def contact_mobile=(contact_mobile)
    write_attribute(:contact_mobile, contact_mobile.gsub(/\D/, ''))
  end

  #basic search for contact user.
	def self.search_contactuser(search,user_id,s_key)
		if search !="" && search !=nil
			#display the results when the user entered the text in search box.
			if (s_key == 'all')
        find(:all, :conditions => ["user_id = ? and lower(contact_name) LIKE ? ","#{user_id}", "%#{search.downcase}%"], :order => "contact_name ASC")
			else
        where("user_id = ? and contact_user_type= ? and lower(contact_name)LIKE?","#{user_id}", "#{s_key}", "%#{search.downcase}%").order("contact_name ASC")
			end
		end
	end
	
  def self.choose_contact_type(email,user_id)
    user = User.where("email_address = ?",email).first
	  c_user = ContactUser.where("contact_email = ? and user_id=?",email,user_id).first
		if (user && c_user && c_user.accept_status==true)
			c_status = "friend"
		elsif (user && c_user) || (user)
			c_status = "member"
		else
			c_status = "non_member"
		end
    return c_status
  end
 
 
  def self.fb_choose_contact_type(p_id,user_id)
    user = User.where("fb_id = ?",p_id).first
    c_user = ContactUser.where("profile_id = ? and user_id=?",p_id,user_id).first
		if (user && c_user && c_user.accept_status==true)
			c_status = "friend"
		elsif (user && c_user) || (user)
			c_status = "member"
		else
			c_status = "non_member"
		end
    return c_status
  end
	
end
