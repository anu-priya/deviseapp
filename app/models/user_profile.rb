class UserProfile < ActiveRecord::Base
  include IdentityCache
  extend FriendlyId
  friendly_id :slug_for_business_name, use: :slugged
  attr_accessible :slug,:profile_id,:business_name,:business_owner,:administrator,:phone,:mobile,:fax,:business_language,
    :webaddress,:userid, :inserted_date,:modified_date,:first_name,:address_1,:address_2,:last_name,
    :zip_code, :date_of_birth, :dob,
    :gender, :city, :state, :country, :website, :currency, :date_format,
    :business_logo, :categories,
    :owner_first_name,:owner_last_name,:admin_first_name,:admin_last_name,:time_zone,:user_id,
    :profile, :profile_file_name, :profile_content_type, :profile_file_size, :profile_updated_at,:card,:card_file_name, :card_content_type, :card_file_size, :card_updated_at,
	  :user_photo, :user_photo_file_name, :user_photo_content_type, :user_photo_file_size, :user_photo_updated_at,:description,:added_by, :tags_txt, :category, :sub_category, :sms_mobile_num, :sms_verify_code, :sms_notify_status 
 
 after_save :remove_profile
 after_destroy :remove_profile
  #has_attached_file :user_photo, :styles => { :small=>"85x87!",:medium => "130x110!", :thumb => "21x21!" }, :default_url => "/assets/profile/user_icon_69.png",
  cache_index :slug, :unique => true
  has_attached_file :user_photo, :styles => { :small=>"72x72>",:medium => "134x142>", :thumb => "21x21>" }, :default_url => "/assets/profile/user_icon_69.png",
    #~ :convert_options => {:small => "-quality 80 -interlace plane", :medium => "-quality 80 -interlace plane", :thumb => "-quality 80 -interlace plane"}, 
    #~ :processors => [:thumbnail,:compression],
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"

  has_attached_file :profile, :styles => {:small=>"90x40>",:medium => "134x142>", :thumb => "21x21>" }, :default_url => "/assets/profile/user_icon_69.png",    
    #~ :convert_options => {:small => "-quality 80 -interlace plane", :medium => "-quality 80 -interlace plane", :thumb => "-quality 80 -interlace plane"}, 
    #~ :processors => [:thumbnail,:compression],
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"


  has_attached_file :card, 
    :styles => {:profile => "134x142>", :thumb=>"190x190>",:small => "190x274>",:user_profile=>"72x72>",:pro_card=>"283x212>" }, :default_url => "/assets/profile/user_icon_69.png",
    #~ :convert_options => {:profile => "-quality 80 -interlace plane", :thumb => "-quality 80 -interlace plane", :small => "-quality 80 -interlace plane", :user_profile => "-quality 80 -interlace plane", :pro_card => "-quality 80 - interlace plane"}, 
    #~ :processors => [:thumbnail,:compression],
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"

  cache_index :profile

  belongs_to :user
  validates_uniqueness_of :user_id
  
  accepts_nested_attributes_for :user
  
  def self.chkFlagNotification(parent_n,email_n,sms_n)
	  if (parent_n==email_n && parent_n==sms_n)
	    #~ flag = true
	    notify_email = true
	    notify_sms = true
          elsif parent_n==email_n
            #~ flag = true
	    notify_email = true
	    notify_sms = false
	  elsif parent_n==sms_n
	    #~ flag = true
	    notify_sms = true
	    notify_email = false
          else
	    #~ flag=true
	    notify_sms = false
	    notify_email = false
          end
	#~ return flag,notify_email,notify_sms
	return notify_email,notify_sms
end
#by using bname get the user details
def self.getuserdetails(city,bname)
	if city && city!=''
		@prov_list = UserProfile.joins(:user).where("lower(users.user_type)=? and lower(city)=?",'p',city).uniq if city && city!=''
	elsif bname && bname!=''
	if ($dc.fetch("user_profile_for_#{bname}").nil?)
		@prov_list = UserProfile.joins(:user).where("slug=? and (lower(user_status)!=? or user_status is null)",bname,'deactivate').last if bname && bname!=''
		$dc.set("user_profile_for_#{bname}",@prov_list) if @prov_list && @prov_list.present?
	else
		@prov_list = $dc.fetch("user_profile_for_#{bname}")	
	end
	#~ @prov_list = UserProfile.fetch_by_slug(bname) if bname && bname!=''
	end
	return @prov_list
end

  def slug_for_business_name
    "#{business_name}"
  end

private
def remove_profile
	$dc.set("user_profile_for_#{self.slug}",nil)
end

end

