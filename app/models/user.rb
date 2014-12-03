class User < ActiveRecord::Base
  attr_accessible :user_status, :downgrade_plan, :manage_plan, :show_card,:raj_user,:userid,:user_name,:user_password,:email_address,:user_type,:user_created_date,:user_expiry_date, :account_active_status,:user_plan, :user_flag, :new_email_address, :email_status , :longitude, :latitude, :is_partner
  include IdentityCache
  
  before_destroy :notify_user
  #  after_save :update_user_index
 after_save :remove_profile
 after_destroy :remove_profile
  validates :email_address, :presence => {:message =>"Email Address Can't be blank."}

  validates_uniqueness_of  :email_address,:message =>"Already has taken that Email address. Try another."
  
  has_many :policy
  
  has_many :activities
  cache_has_many :activities, :embed => true #identity cache
  
  has_one :user_profile
  cache_has_one :user_profile, :embed => true #identity cache

  has_many :contact_user
  
  has_many :managers, :foreign_key => :invited_user_id
  
  has_many :activity_network_permissions, :foreign_key => :provider_user_id
  
  has_one :user_transaction 

  has_one :user_bank_detail  
   
  has_many :participant

  has_many :userchild

  has_many :agerangecolor
  has_many :activity_forms

  #~ has_many :participantagerangecolor 
  has_many :user_credits,:dependent => :destroy


  has_many :authentications
  has_many :contact_groups


  scope :search_parent, lambda{ |value|{
      :joins=>:user_profile,:select => "user_profiles.*,users.*",:order=>'users.user_name ASC, user_profiles.first_name ASC',:conditions => ['users.account_active_status = ? and lower(users.user_type) = ? and (lower(users.user_name) LIKE ? OR lower(user_profiles.first_name) LIKE ? OR lower(user_profiles.last_name) LIKE ? )',true,"u","%#{value.downcase}%", "%#{value.downcase}%", "%#{value.downcase}%"]
    }
  }
     
  scope :search_provider, lambda { |value| { :joins=>:user_profile,:select => "user_profiles.*,users.user_name",:order=>'business_name ASC, first_name ASC',:conditions => ['users.account_active_status = ?  and lower(users.user_type) = ? and (lower(business_name) LIKE ? OR lower(first_name) LIKE ? OR lower(last_name) LIKE ?) ', true,"p","%#{value.downcase}%", "%#{value.downcase}%", "%#{value.downcase}%"]} }
  scope :locate_user, lambda { |id| where('user_id = ?', id) }
  
  #~ has_many :activity_row
  #  has_attached_file :profile, :styles => { :small=>"85x87!",:medium => "130x110!", :thumb => "21x21!" },
  #    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  #    :url => "/system/:attachment/:id/:style/:filename"
  
  attr_accessible :user_profile, :user_profile_attributes

  accepts_nested_attributes_for :user_profile, :agerangecolor
  
  after_create :default_row_save
  #attr_accessible :user_profile_attributes
  
  #get group name based on city
	def self.get_newsletter_group(city,user)
		#~ if !city.nil? && city!=''
			#~ @city = City.find_by_sql("select group_name from cities c left join city_groups g on c.group_id = g.group_id where lower(c.city_name) = '#{city.downcase}'")			
			#~ if !@city.nil? && @city.present?
				#~ group_name = @city[0].group_name if !@city[0].group_name.nil?  && @city[0].group_name!=''
			#~ else
				#~ group_name = 'ungrouped'
			#~ end
		#~ else
			#~ group_name = 'ungrouped'
		#~ end	
		#~ return group_name			
		group_multi = ''
		group_name = 'Ungrouped'
		if city && !city.nil? && city!=''
			@city = City.find_by_sql("select group_name from cities c left join city_groups g on c.group_id = g.group_id where lower(c.city_name) = '#{city.downcase}'")			
			if !@city.nil? && @city.present?
				group_name = @city[0].group_name if !@city[0].group_name.nil?  && @city[0].group_name!=''
			else
				group_name = 'Ungrouped'
			end	
		else
			group_name = 'Ungrouped'
		end		
		if user && !user.nil? && user.present?
			if !user.user_type.nil? && user.user_type.downcase == 'u'
				@str = "Famtivity Users!Famtivity Parents"
				group_multi = "#{@str}!#{group_name} Parents"				
			elsif !user.user_type.nil? && user.user_type.downcase == 'p'
				@str = "Famtivity Users!Famtivity Providers"					
				group_multi = "#{@str}!#{group_name} Providers"
			end
		end		
		group_multi_val = (group_multi!='') ? group_multi : group_name
		return group_multi_val		
	end
  #send a mail to user while delete the account
  def notify_user
    #~ @user_mail = UserMailer.delay(queue: "User Account Delete", priority: 1, run_at: 1.seconds.from_now).user_account_deleted(self)
    if !self.nil? && self.user_flag==TRUE
      UserMailer.user_account_deleted(self).deliver
      UserMailer.user_account_deleted_admin(self).deliver
    end
    #~ @user_mail1 = UserMailer.delay(queue: "User Account Delete Admin", priority: 1, run_at: 5.seconds.from_now).user_account_deleted_admin(@user)
  end
  
  #delete the user associated information from famtivity database
  def self.delete_user_details(user)
	  if user && user!="" && user.present?
		  all_act = user.activities
		  all_contact = user.contact_user
		  all_manager = user.managers
		  all_actnetper = user.activity_network_permissions
		
		  #delete activities
		  if !all_act.nil? && all_act.present?
			  all_act.destroy_all
		  end
		  #delete contacts
      if !all_contact.nil? && all_contact.present?
			  all_contact.destroy_all
		  end
		  #delete managers
      if !all_manager.nil? && all_manager.present?
			  all_manager.destroy_all
		  end
		  #delete all_actnetper
      if !all_actnetper.nil? && all_actnetper.present?
			  all_actnetper.destroy_all
		  end
    end #user present ending here
  end
  
  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end
  
  def default_row_save
    cat = ActivityCategory.where("lower(category_name)='default'").last
    sub_cat = ActivitySubcategory.where(:category_id=>cat.category_id)
    sub_cat.each do |act|
      if !act.nil? && !act.subcateg_name.nil? && act.subcateg_name!="Shared"
        @row = ActivityRow.new
        @row.subcateg_id = act.subcateg_id
        @row.row_type = act.subcateg_name
        @row.user_id = self.id
        @row.inserted_date = Time.now
        @row.save
      end
    end
    
  end
  
  def self.user_plan_type(type,plan)
    if (type=='U')
      u_type = 'Parent'
      u_plan = 'Free'
      amount = 1
    else
      u_type = 'Provider'
      if (plan == 'sell')
        u_plan = 'Sell'
        #~ amount = 25
        #get this amount from the application controller by rajkumar
        amount = "#{$dollar}"
      else
        u_plan = 'Market'
        amount = 1
      end
    end
    return u_type,amount,u_plan
  end
 
  #basic search for activity user.
	def self.search_activityuser(search,user_id,represent)
		if represent == "activity_users"
		  find(:all, :conditions => ["lower(user_name) LIKE ? ", "%#{search.downcase}%"], :order => "user_name ASC")
		else
		  find(:all, :conditions => ["user_id = ? and lower(user_name) LIKE ? ","#{user_id}", "%#{search.downcase}%"], :order => "user_name ASC")
		end
	end


  searchable :auto_index => true do
    text :user_profile_name,:boost => 10.0 do
      user_pro = UserProfile.find_by_user_id(user_id)
      user_pro.business_name.gsub("\x10","") if !user_pro.business_name.nil? unless user_pro.nil?
    end
    
    text :tags_txt do
      user_pro = UserProfile.find_by_user_id(user_id)
      user_pro.tags_txt.split(",") if !user_pro.tags_txt.nil? unless user_pro.nil?
    end
    
    text :category do
      user_pro = UserProfile.find_by_user_id(user_id)
      user_pro.category.downcase if !user_pro.category.nil? && user_pro.category!='' unless user_pro.nil?
    end
    
    text :sub_category do
      user_pro = UserProfile.find_by_user_id(user_id)
      user_pro.sub_category.downcase if !user_pro.sub_category.nil? && user_pro.sub_category!='' unless user_pro.nil?
    end
    
    string :cleaned do
      true
    end
    string :active_status do
      if account_active_status == true && user_status !='deactivate'
        "Active"
      else
        "Inactive"
      end
    end
    string :c_class do
      "user"
    end
    
    string :city_lower do
      user_pro = UserProfile.find_by_user_id(user_id)
      user_pro.city.downcase if !user_pro.city.nil? && user_pro.city!='' unless user_pro.nil?
    end

    integer :category_id do
      user_pro = UserProfile.find_by_user_id(user_id)
      unless user_pro.nil?
        if !user_pro.category.nil? && user_pro.category!=''
          act_cat = ActivityCategory.where("lower(category_name)='#{user_pro.category.downcase}'").last
          act_cat.category_id  unless act_cat.nil?
        end
      end
    end
    
    integer :sub_category_id do
      user_pro = UserProfile.find_by_user_id(user_id)
      unless user_pro.nil?
        if !user_pro.category.nil? && user_pro.category!=''
          act_cat = ActivityCategory.where("lower(category_name)='#{user_pro.category.downcase}'").last
          unless act_cat.nil?
	  s_categ = user_pro.sub_category.gsub("'","''")
            act_sub = ActivitySubcategory.where("category_id=#{act_cat.category_id} and lower(subcateg_name)='#{s_categ.downcase}'").last
            act_sub.subcateg_id unless act_sub.nil?
          end
        end
      end
    end

    double :latitude

    double :longitude
    
    latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }

    string :show_card
    integer :user_id
    
  end

  #private

  #def update_user_index
    
  #end
  #get the user details
  def self.getdetails(userid)
	  @user = User.fetch(userid) if !userid.nil? && userid!='' #identity cache
  end
  
  private
def remove_profile
	dc = Dalli::Client.new("127.0.0.1:11211")
	dc.set("user_profile_for_#{self.fetch_user_profile.slug}",nil) if self && self.fetch_user_profile
end

end
