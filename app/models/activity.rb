class Activity < ActiveRecord::Base
include IdentityCache
  extend FriendlyId
  friendly_id :activity_name_and_city, use: :slugged
  require 'geo_ip'
  require 'geocoder'
  attr_accessible :slug, :phone_extension, :country_id, :country_code, :latitude,:longitude,:cleaned,:min_age_range,:max_age_range,:price_type,:note,:approve_kid,:gender,:raised_flag,:report,:approve_flag,:featured_flag,:sub_category,:user_id,:active_status,:activity_id, :activity_name,:contact_price, :address_1, :address_2, :age_range, :avatar, :avatar_updated_at, :category, :city, :created_by, :description, :discount, :email, :filter_id, :inserted_date, :leader, :modified_date, :no_participants, :phone, :price, :schedule_mode, :skill_level, :time_zone, :website, :zip_code
  cache_index :slug, :unique => true #identity cache
  belongs_to :user
  has_many :activity_schedule
  cache_has_many :activity_schedule, :embed=>true #identity cache
  has_many :activity_total_count
  has_many :activity_favorite
  #  has_many :activity_repeat,:through=>:activity_schedule
  has_many :activity_shared
  has_many :activity_price
  has_many :agerangecolor
  has_many :deleted_schedules
  has_many :activity_forms
  has_many :activity_discount_price, through: :activity_price
  #~ has_attached_file :avatar, :styles => { :small=>"100x100>",:medium => "200x200>", :thumb => "300x300>" },
  #  validates_uniqueness_of :activity_name_apf,:message =>"Email id already exists."

  #~ has_attached_file :avatar, :styles => { :thumb=>"190", :small => "210", :medium => "230" }, :default_url => "/images/:style/no-image.png",
  #~ has_attached_file :avatar, :styles => { :thumb=>"190x190>", :small => "190x274>", :medium => "190x324>",:act_card=>"283x212>" }, :default_url => "/images/:style/no-image.png",
    #~ :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    #~ :url => "/system/:attachment/:id/:style/:filename"
  
  has_attached_file :avatar, :styles => { :thumb=>"190x190>", :small => "190x274>", :medium => "190x324>",:act_card=>"283x212>",:preview=>"1920x1200>" }, :default_url => "/images/:style/no-image.png",
    #:convert_options => {:thumb => "-quality 80 -interlace Plane", :small => "-quality 80 -interlace Plane", :medium => "-quality 80 -interlace Plane", :act_card => "-quality 80 -interlace Plane", :preview => "-quality 80 -interlace Plane"},
    #:processors => [:thumbnail,:compression],
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
=begin
   has_attached_file :avatar,
	:styles =>{ :thumb=>"190x190>", :small => "190x274>", :medium => "190x324>",:act_card=>"283x212>",:preview=>"1920x1200>" },:storage => :s3,:s3_protocol => :https,
    	:convert_options => {:thumb => "-quality 80 -interlace plane", :small => "-quality 80 -interlace plane", :medium => "-quality 80 -interlace plane", :act_card => "-quality 80 -interlace plane", :preview => "-quality 80 -interlace  plane"}, 
    	:processors => [:thumbnail,:compression],
    	:path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    	:s3_credentials => "#{Rails.root}/config/s3.yml",:path => ":attachment/:id/:style/:filename",:bucket => 'famtivity/production',:s3_host_alias => "famtivity.com"
=end
  
  after_create :add_activity_total_count
  
  #~ scope :fnd_activity_slug, lambda { |slg| fetch_by_slug_and_cleaned_and_active_status(slg,true,'Active')}
  scope :fnd_activity_slug, lambda { |slg| where("slug=? and cleaned=? and lower(active_status)=?",slg,true,'active')}

  
  #provider business logo trac view
  def self.track_logo_view(uid)
	  # @lastweek = (Date.today.beginning_of_week)-1
    #@week_start =@lastweek.at_beginning_of_week.strftime("%Y-%m-%d")
    #@week_end =@lastweek.at_end_of_week.strftime("%Y-%m-%d")
    @lastweek = Date.today
    @week_start = (@lastweek-30.days).strftime('%Y-%m-%d')
    @week_end = @lastweek.strftime('%Y-%m-%d')
    @provider_count = ProviderCount.find_by_sql("select sum(provider_count) as provider_count from provider_counts where user_id=#{uid} and (date(inserted_date) between '#{@week_start}' and '#{@week_end}')").map(&:provider_count).first
  end
  #list out the total view lists
  def self.total_view_list_lastweek(uid)
    #~ lastweek day
    #@lastweek = (Date.today.beginning_of_week)-1
    #@week_start =@lastweek.at_beginning_of_week.strftime("%Y-%m-%d")
    #@week_end =@lastweek.at_end_of_week.strftime("%Y-%m-%d")
    @lastweek = Date.today
    @week_start = (@lastweek-60.days).strftime('%Y-%m-%d')
    @week_end = (@lastweek-30.days).strftime('%Y-%m-%d')
    Activity.find_by_sql("select sum(view_count) as view_count from activity_counts where activity_id in(select activity_id from activities where user_id=#{uid}) and (date(inserted_date) between date('#{@week_start}') and date('#{@week_end}')) and view_count is not null") if !uid.nil? && uid!="" && uid.present?
  end
  #list out the total view lists
  def self.total_view_list(uid)
    #@week_start = Date.today.beginning_of_week.strftime("%Y-%m-%d")
    #@week_end = Date.today.end_of_week.strftime("%Y-%m-%d")
    @lastweek = Date.today
    @week_start = (@lastweek-30.days).strftime('%Y-%m-%d')
    @week_end = @lastweek.strftime('%Y-%m-%d')
    Activity.find_by_sql("select sum(view_count) as view_count from activity_counts where activity_id in(select activity_id from activities where user_id=#{uid}) and (date(inserted_date) between date('#{@week_start}') and date('#{@week_end}')) and view_count is not null") if !uid.nil? && uid!="" && uid.present?
  end
  #list out the top share activities
  def self.top_share_activities(uid)
    #@week_start = Date.today.beginning_of_week.strftime("%Y-%m-%d")
    #@week_end = Date.today.end_of_week.strftime("%Y-%m-%d")
    @lastweek = Date.today
    @week_start = (@lastweek-30.days).strftime('%Y-%m-%d')
    @week_end = @lastweek.strftime('%Y-%m-%d')
    Activity.find_by_sql("select activity_id from activity_counts where activity_id in(select activity_id from activities where user_id=#{uid}) and (date(inserted_date) between date('#{@week_start}') and date('#{@week_end}')) and share_count is not null order by share_count desc limit 3") if !uid.nil? && uid!="" && uid.present?
  end
  #list out the top view activities
  def self.top_view_activities(uid)
    #@week_start = Date.today.beginning_of_week.strftime("%Y-%m-%d")
    #@week_end = Date.today.end_of_week.strftime("%Y-%m-%d")
    @lastweek = Date.today
    @week_start = (@lastweek-30.days).strftime('%Y-%m-%d')
    @week_end = @lastweek.strftime('%Y-%m-%d')
    #Activity.find_by_sql("select activity_id from activity_counts where activity_id in(select activity_id from activities where user_id=#{uid}) and (date(inserted_date) between date('#{@week_start}') and date('#{@week_end}')) order by view_count desc limit 3") if !uid.nil? && uid!="" && uid.present?
    ActivityCount.find_by_sql("select distinct(ac.activity_id),a.activity_name,(select sum(activity_count) from activity_counts where activity_id=ac.activity_id and date(inserted_date) between '#{@week_start}' and '#{@week_end}') as activity_count from activity_counts 
    ac left join activities a on ac.activity_id=a.activity_id where a.user_id=#{uid} and date(ac.inserted_date) between '#{@week_start}' and '#{@week_end}' order by activity_count desc limit 3")
  end
  #list out the active activities
  def self.active_activities_list(uid)
    #Activity.find_by_sql("select a.activity_id from activities a left join school_representatives s on a.activity_id=s.activity_id where (user_id = #{uid}  or vendor_id = #{uid}) and lower(created_by)='provider' and lower(active_status)='active'") if !uid.nil? && uid!="" && uid.present?
    Activity.find_by_sql("select a.activity_id from activities a left join activity_schedules sch on a.activity_id=sch.activity_id left join 
    school_representatives s on a.activity_id=s.activity_id where (user_id =#{uid} or vendor_id =#{uid}) and lower(created_by)='provider' and lower(active_status)='active' and sch.expiration_date >= '#{Date.today.strftime("%Y-%m-%d")}'")
    
  end
  #list out the inactive activities
  def self.inactive_activities(uid)
	  #~ Activity.find_by_sql("select activity_id from activities where user_id = #{uid} and lower(created_by)='provider' and lower(active_status)='inactive'") if !uid.nil? && uid!="" && uid.present?
    Activity.find_by_sql("select a.activity_id from activities a left join school_representatives s on a.activity_id=s.activity_id where (user_id = #{uid} or vendor_id = #{uid}) and lower(created_by)='provider' and lower(active_status)='inactive'") if !uid.nil? && uid!="" && uid.present?
  end
  #list of expired activities
  def self.expired_activities(uid)
	  #~ Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where act_sch.expiration_date < '#{Date.today.strftime("%Y-%m-%d")}' and lower(act.created_by)='provider' and act.user_id=#{uid}") if !uid.nil? && uid!="" && uid.present?
    #~ Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id left join school_representatives school on act.activity_id = school.activity_id where act_sch.expiration_date < '#{Date.today.strftime("%Y-%m-%d")}' and lower(act.created_by)='provider' and (act.user_id=#{uid} or school.vendor_id=#{uid})") if !uid.nil? && uid!="" && uid.present?
    #Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id left join school_representatives school on act.activity_id = school.activity_id where act_sch.expiration_date < '#{Date.today.strftime("%Y-%m-%d")}' and (lower(act.active_status)='inactive' or lower(act.active_status)='active') and lower(act.created_by)='provider' and (act.user_id=#{uid} or school.vendor_id=#{uid}) and act.activity_id not in (select act.activity_id from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where lower(act.created_by)='provider' and act.user_id=#{uid} and act_sch.expiration_date >= '#{Date.today.strftime("%Y-%m-%d")}')") if !uid.nil? && uid!="" && uid.present?
    Activity.find_by_sql("select distinct a.* from activities a left join activity_schedules sch on a.activity_id=sch.activity_id left join
    school_representatives s on a.activity_id=s.activity_id where (a.user_id = #{uid} or s.vendor_id = #{uid} ) and lower(created_by)='provider' and lower(active_status)='active' and sch.expiration_date < '#{Date.today.strftime("%Y-%m-%d")}'")
 
  end
  #list of discount dollar activities
  def self.discount_dollar_activities(uid)
	  Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where act_sch.expiration_date >= '#{Date.today.strftime("%Y-%m-%d")}' and (act.price_type ='1' or act.price_type ='2') and cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and (act.discount_eligible IS NOT NULL) and act.user_id=#{uid}") if !uid.nil? && uid!="" && uid.present?
  end
  #list of lead users
  def self.lead_user_list(email_id)
	  Activity.find_by_sql("SELECT from_email FROM activity_tracks where to_email='#{email_id}' and from_email is not null") if !email_id.nil? && email_id!="" && email_id.present?
  end
  #list of invitee users
  def self.provider_invitee_list(uid)
	  Activity.find_by_sql("select * from user_credits where user_id = #{uid} and invitee_id is not null") if !uid.nil? && uid!="" && uid.present?
  end
  
  def activity_name_and_city
    "#{activity_name}"
  end

  def self.get_upcoming_activities(before_check)
    @act_free=[]
    @all_act=[]
    before_check.each do |af|
      newact=ActivitySchedule.where("activity_id = ?",af.activity_id).last

      @check_newact=newact.expiration_date>=Date.today  if !newact.nil? && newact.expiration_date && newact.expiration_date.present?
      @all_act << newact if !newact.nil? && !@check_newact.nil? && @check_newact.present?
    end if !before_check.nil?
    @all_act.each do |al|
      if !al.nil? && al.activity_id!=''
        id=al.activity_id
        act=Activity.where("activity_id = ?",id).last if id!='' && !id.nil?
        @act_free << act if !act.nil?
      end
    end if !@all_act.nil? && @all_act.present? && @all_act.length > 0

    return @act_free if !@act_free.nil?
  end

  #  :storage => :s3,
  #:s3_credentials => ":rails_root/config/s3.yml",
  #  :s3_credentials => Rails.root.join("config/s3.yml"),
  #  :path => "rails_root/public/system/:attachment/:id/:style/:filename"

  #    :url => "/system/:attachment/:id/:style/:filename",
  #    :path => ":rails_root/public/images/photos/:id/:basename_:style.:extension"
  #has_many :tickets

  def self.get_featured_activities()
    return act = Activity.find_by_sql("select * from activities as act,activity_bids as bid where act.activity_id = bid.activity_id and lower(bid_status)='active' or (act.featured_flag = true and lower(active_status)='active') order by bid.bid_amount desc, act.featured_flag Asc limit 100 offset 0").uniq
  end

  #Activities shown in index page
  def self.get_activities(city,zip,date,filter_id)

    city_cond = " "
    
    date_cond = " "

    city_cond = "and lower(city)  = '#{city.downcase}'"  if city != 0 and city != nil and city != "" and city!='All'

    city_cond = " and zip_code = '#{zip}'"  if zip != 0 and zip != nil and zip != ""

    date_cond = "and (activity_schedules.start_date in ('#{date}') or (activity_schedules.start_date<='#{date}' and activity_schedules.end_date >= '#{date}'))"  if date != 0 and date != nil and date != ""
    filter_cond = "and filter_id=#{filter_id}"
    cleaned_cond = "and cleaned =true"
    featured_cond = "filter_id=#{filter_id}"

    filter_cond = "and featured_flag = true" if filter_id == 1

    featured_cond = "featured_flag = true" if filter_id == 1
    
    return act = Activity.find_by_sql("SELECT * FROM activities INNER JOIN activity_schedules ON activity_schedules.activity_id = activities.activity_id
              WHERE (lower(active_status)='active'
              and lower(activities.schedule_mode)='any time'
              #{city_cond} #{filter_cond} #{cleaned_cond}) or lower(activities.schedule_mode)='by appointment' and lower(activities.active_status)='active' and cleaned =true
              or (#{featured_cond} #{date_cond} #{city_cond} #{cleaned_cond} and lower(activities.active_status)='active') order by activities.activity_id desc limit 100").uniq
    #    return act = Activity.find_by_sql("SELECT * FROM activities INNER JOIN activity_schedules ON activity_schedules.activity_id = activities.activity_id
    #        WHERE (lower(active_status)='active' and lower(activities.schedule_mode)='any time'
    #        And filter_id=#{filter_id} #{city_cond})#{date_cond} order by activities.activity_id desc").uniq

  end


  def self.get_activities_repeat(city,zip,date,filter_id)

    city_cond = " "

    date_cond = " "
    
    cleaned_cond = "and cleaned =true"

    city_cond = "and lower(city)  = '#{city.downcase}'"  if city != 0 and city != nil and city != "" and city!='All'

    city_cond = " and zip_code = '#{zip}'"  if zip != 0 and zip != nil and zip != ""

    #~ date_cond = "And (start_date <='#{date}')"  if date != 0 and date != nil and date != ""
    date_cond = ""

    filter_cond = "and price_type='#{filter_id}'"
    
    filter_cond = "and featured_flag = true"  if filter_id == 1

    return act = Activity.find_by_sql("SELECT * FROM activities where lower(active_status)='active' and lower(created_by)='provider'  #{city_cond} #{filter_cond} #{cleaned_cond} order by activity_id desc").uniq

  end


  def self.get_activity_row_values_repeat(city,zip,date,cat,user_id)
    city_cond = " "

    date_cond = " "
    user_cond =" "
    city_cond = "and lower(city)  = '#{city.downcase}'"  if city != 0 and city != nil and city != "" and city!='All'

    city_cond = " and zip_code = '#{zip}'"  if zip != 0 and zip != nil and zip != ""

    #~ date_cond = "And (start_date <='#{date}')"  if date != 0 and date != nil and date != ""
    date_cond = ""  #if date != 0 and date != nil and date != ""
    cleaned_cond = "and cleaned =true"
    cat_cond = "And lower(category)='#{cat.downcase}'" if cat != 0 and cat != nil and cat != ""
    user_cond = "and row.user_id = #{user_id}" if user_id != 0 and user_id != nil and user_id != ""

    #~ return act = Activity.find_by_sql("SELECT * FROM activities INNER JOIN activity_schedules ON activity_schedules.activity_id = activities.activity_id where
    #~ lower(active_status)='active'  #{city_cond}#{cat_cond} #{date_cond} #{cleaned_cond} Or (lower(activities.schedule_mode)='any time'  #{city_cond} #{cat_cond} #{cleaned_cond} and lower(activities.active_status)='active') Or (lower(activities.schedule_mode)='by appointment' #{city_cond} #{cat_cond} #{cleaned_cond} and lower(activities.active_status)='active') limit 100").uniq

    return act = Activity.find_by_sql("SELECT * FROM activities INNER JOIN activity_schedules ON activity_schedules.activity_id = activities.activity_id where
 lower(active_status)='active' and lower(created_by) = 'provider'  #{city_cond}#{cat_cond} #{date_cond} #{cleaned_cond} Or (lower(activities.schedule_mode)='any time' and lower(activities.created_by) = 'provider' #{city_cond} #{cat_cond} #{cleaned_cond}) Or (lower(activities.schedule_mode)='by appointment' and lower(activities.created_by) = 'provider' #{city_cond} #{cat_cond} #{cleaned_cond}) order by activities.activity_id desc limit 300").uniq

  end


  def self.get_activity_row_values_repeat_category(city,zip,date,cat,user_id,sub_cat)
    city_cond = " "

    date_cond = " "

    sub_cate_cond = ""
    #change for anywhere
    city_cond = "and ((lower(city)  = '#{city.downcase}') or (city=''))"  if city != 0 and city != nil and city != "" and city!='All'
    #city_cond = "and lower(city)  = '#{city.downcase}'"  if city != 0 and city != nil and city != "" and city!='All'

    city_cond = " and zip_code = '#{zip}'"  if zip != 0 and zip != nil and zip != ""

    date_cond = ""
    cont=''
    cleaned_cond = "and cleaned =true"
    @category_id = ActivityCategory.where("lower(category_name)='#{cat.downcase}'").last if !cat.nil? && cat.present? && cat!=""
    if !user_id.nil? && user_id!='' && user_id.present?
      @subcategory = ActivitySubcategory.find_by_sql("select distinct(subcateg_name) from activity_subcategories s right join activity_rows r on r.subcateg_id= s.subcateg_id where s.category_id=#{@category_id["category_id"]} and r.user_id=#{user_id}")  if !@category_id.nil? && @category_id!='' && @category_id.present?
      @i = 1
      cont.concat("lower(category)='#{cat.downcase}'")   if cat != 0 and cat != nil and cat != ""
      if !@subcategory.nil? && @subcategory!='' && @subcategory.present?
        @subcategory.each do |val|
          if @i== 1
            cont.concat("and lower(sub_category)='#{val["subcateg_name"].downcase}'")
          else
            cont.concat("or lower(sub_category)='#{val["subcateg_name"].downcase}'")
          end
          @i = @i +1
        end  #each loop end
      end
    else #current user else part
      if !sub_cat.nil? && sub_cat!="" && sub_cat.present?
        @subcate_id = sub_cat.to_s.gsub('[','').gsub(']','').gsub("&",",") if !sub_cat.nil? && sub_cat!="" && sub_cat.present?
        @subcategory = ActivitySubcategory.find_by_sql("select distinct(subcateg_name) from activity_subcategories where subcateg_id in (#{@subcate_id}) and category_id=#{@category_id["category_id"]}") if !@subcate_id.nil? && !@category_id.nil? && @category_id!='' && @category_id.present?
				@i = 1
        cont.concat("lower(category)='#{cat.downcase}'")   if cat != 0 and cat != nil and cat != ""
				if !@subcategory.nil? && @subcategory!='' && @subcategory.present?
          @subcategory.each do |val|
            if @i== 1
              cont.concat("and lower(sub_category)='#{val["subcateg_name"].downcase}'")
            else
              cont.concat("or lower(sub_category)='#{val["subcateg_name"].downcase}'")
            end
            @i = @i +1
          end  #each loop end
        end
      end #sub cat end
    end  #current user end
    
    sub_cate_cond= "and (#{cont})" if !cont.nil? && cont!='' && cont.present?

    # return act = Activity.find_by_sql("SELECT * FROM activities where lower(active_status)='active' #{sub_cate_cond} #{city_cond} #{cleaned_cond} order by activity_id desc").uniq
    #change for expire date activiy
    return act = Activity.find_by_sql("select a.* from activities a inner join users u on u.user_id = a.user_id inner join activity_schedules act_sc on act_sc.activity_id = a.activity_id where (lower(a.active_status)='active' #{sub_cate_cond} and a.city = '#{city}' and lower(a.active_status)='active' and a.cleaned=true and lower(a.created_by)='provider' and act_sc.expiration_date >= '#{Date.today}') order by u.user_plan desc")

    #return act = Activity.find_by_sql("SELECT * FROM activities, activity_schedules  where activities.activity_id=activity_schedules.activity_id and activity_schedules.expiration_date >= '#{Date.today}' and lower(activities.active_status)='active'  #{sub_cate_cond} #{city_cond} #{cleaned_cond} order by activities.activity_id desc").uniq
  end



  def self.get_near_by_activity_row_values_repeat_category(city,zip,date,cat,user_id,sub_cat,page,set_p)
    city_cond = " "

    date_cond = " "

    sub_cate_cond = ""
    #change for anywhere
    city_cond = "and ((lower(city)  = '#{city.downcase}') or (city=''))"  if city != 0 and city != nil and city != "" and city!='All'
    #city_cond = "and lower(city)  = '#{city.downcase}'"  if city != 0 and city != nil and city != "" and city!='All'

    city_cond = " and zip_code = '#{zip}'"  if zip != 0 and zip != nil and zip != ""

    date_cond = ""
    cont=''
    cleaned_cond = "and cleaned =true"
    @category_id = ActivityCategory.where("lower(category_name)='#{cat.downcase}'").last if !cat.nil? && cat.present? && cat!=""
    if !user_id.nil? && user_id!='' && user_id.present?
      @subcategory = ActivitySubcategory.find_by_sql("select distinct(subcateg_name) from activity_subcategories s right join activity_rows r on r.subcateg_id= s.subcateg_id where s.category_id=#{@category_id["category_id"]} and r.user_id=#{user_id}")  if !@category_id.nil? && @category_id!='' && @category_id.present?
      @i = 1
      # cont.concat("lower(category)='#{cat.downcase}'")   if cat != 0 and cat != nil and cat != ""
      if !@subcategory.nil? && @subcategory!='' && @subcategory.present?
        @subcategory.each do |val|
          if @i== 1
            cont.concat("lower(sub_category)='#{val["subcateg_name"].downcase}'")
          else
            cont.concat("or lower(sub_category)='#{val["subcateg_name"].downcase}'")
          end
          @i = @i +1
        end  #each loop end
      end
    else #current user else part
      if !sub_cat.nil? && sub_cat!="" && sub_cat.present?
        @subcate_id = sub_cat.to_s.gsub('[','').gsub(']','').gsub("&",",") if !sub_cat.nil? && sub_cat!="" && sub_cat.present?
        @subcategory = ActivitySubcategory.find_by_sql("select distinct(subcateg_name) from activity_subcategories where subcateg_id in (#{@subcate_id}) and category_id=#{@category_id["category_id"]}") if !@subcate_id.nil? && !@category_id.nil? && @category_id!='' && @category_id.present?
				@i = 1
        #cont.concat("lower(category)='#{cat.downcase}'")   if cat != 0 and cat != nil and cat != ""
				if !@subcategory.nil? && @subcategory!='' && @subcategory.present?
          @subcategory.each do |val|
            if @i== 1
              cont.concat("lower(sub_category)='#{val["subcateg_name"].downcase}'")
            else
              cont.concat("or lower(sub_category)='#{val["subcateg_name"].downcase}'")
            end
            @i = @i +1
          end  #each loop end
        end
      end #sub cat end
    end  #current user end

    sub_cate_cond= "and lower(category)='#{cat.downcase}' and (#{cont})" if !cont.nil? && cont!='' && cont.present?
    if set_p == 1
      ac_sub = Activity.find_by_sql("select a.* from activities a inner join users u on u.user_id = a.user_id inner join activity_schedules act_sc on act_sc.activity_id = a.activity_id where (lower(a.active_status)='active' #{sub_cate_cond} and (a.city = '#{city}' or a.city='') and lower(a.active_status)='active' and a.cleaned=true and lower(a.created_by)='provider' and act_sc.expiration_date >= '#{Date.today}') order by u.user_plan desc")
      act = ac_sub.paginate(:page => page, :per_page =>20)
    else
      re_times = 5
      begin
        a_coord = Geocoder.coordinates("#{city.titlecase},ca")
        radius = 1500
        nearby_cities = City.near(a_coord, radius, :order => :distance).map(&:city_name)
      rescue Exception => e
        re_times-=1
        if re_times>0
          retry
        else
          nearby_cities = ["#{city.titlecase}"]
        end
      end
      if nearby_cities.length==0
        re_times = 5
        begin
          a_coord = Geocoder.coordinates("Walnut Creek,ca")
          radius = 1500
          nearby_cities = City.near(a_coord, radius, :order => :distance).map(&:city_name)
        rescue Exception => e
          re_times-=1
          if re_times>0
            retry
          else
            nearby_cities = ["#{city.titlecase}"]
          end
        end
      end
      nearby_cities = (nearby_cities.count == 1 && nearby_cities[0]==city) ? nearby_cities : nearby_cities.reject{|a| a==city}
      arr_nearby_cities = nearby_cities
      nearby_cities =  City.format_gsub(nearby_cities)

      ac_sub = Activity.find_by_sql("select a.* from activities a inner join users u on u.user_id = a.user_id inner join activity_schedules act_sc on act_sc.activity_id = a.activity_id where (lower(a.active_status)='active' #{sub_cate_cond} and (a.city in #{nearby_cities} or a.city='') and lower(a.active_status)='active' and a.cleaned=true and lower(a.created_by)='provider' and act_sc.expiration_date >= '#{Date.today}') order by u.user_plan desc")
      act = ac_sub.paginate(:page => page, :per_page =>20)
    end



    return act 
  end




  def self.get_parent_activity_row_values_repeat(city,zip,date,cat,user_id)
    city_cond = " "
    cleaned_cond = "and cleaned =true"
    date_cond = " "
    user_cond =" "
    city_cond = "and lower(city)  = '#{city.downcase}'"  if city != 0 and city != nil and city != "" and city!='All'

    city_cond = " and zip_code = '#{zip}'"  if zip != 0 and zip != nil and zip != ""

    date_cond = "And (start_date <='#{date}')"  if date != 0 and date != nil and date != ""

    cat_cond = "And lower(category)='#{cat.downcase}'" if cat != 0 and cat != nil and cat != ""
    user_cond = "and user_id = #{user_id}" if user_id != 0 and user_id != nil and user_id != ""

    return act = Activity.find_by_sql("SELECT * FROM activities where lower(active_status)='active' and lower(created_by) ='parent' #{user_cond} #{cleaned_cond} order by activity_id desc").uniq

  end



  def self.get_provider_activity_row_values_repeat(city,zip,date,cat,user_id)
    city_cond = " "
    cleaned_cond = "and cleaned =true"
    date_cond = " "
    user_cond =" "
    city_cond = "and lower(city)  = '#{city.downcase}'"  if city != 0 and city != nil and city != "" and city!='All'

    city_cond = " and zip_code = '#{zip}'"  if zip != 0 and zip != nil and zip != ""

    date_cond = "And (start_date <='#{date}')"  if date != 0 and date != nil and date != ""

    cat_cond = "And lower(category)='#{cat.downcase}'" if cat != 0 and cat != nil and cat != ""
    user_cond = "and user_id = #{user_id}" if user_id != 0 and user_id != nil and user_id != ""
    
    message_list = MessageThread.where("posted_by=#{user_id} and msg_flag=true and show_card=true").order("posted_on asc").group_by(&:message_id)
    message=[]
    message_list && message_list.each do |msg|
      message << msg[1].last
    end
    
    act = Activity.find_by_sql("SELECT * FROM activities where lower(active_status)='active' and lower(created_by) ='provider' #{user_cond} #{cleaned_cond} order by activity_id desc").uniq
    result = (message+act).sort_by(&:modified_date).reverse
    return result

  end

  
  def self.get_shared_activities(user_id,email)


    return  act_provider =  Activity.find_by_sql("select * from activities where activity_id in(select activity_id from activity_shareds where share_id='#{user_id}' or activity_shareds.user_id='#{user_id}') and lower(active_status)='active' and cleaned = true order by inserted_date desc limit 100").uniq
    #    return  act_provider =  Activity.find_by_sql("SELECT * FROM activities,activity_shareds,activity_schedules where activity_shareds.activity_id=activities.activity_id
    #              and activities.activity_id=activity_schedules.activity_id
    #              and lower(active_status)='active' And shared_to='#{email}' or activity_shareds.user_id='#{user_id}'
    #              order by activities.activity_id desc#").uniq
  end

  def self.provider_get_activity_row_values(city,date,cat,user_id)


    city_cond = " "

    date_cond = " "
    cat_cond = " "
    cleaned_cond = "and cleaned =true"
    cat_cond = "And lower(category)='#{cat.downcase}'" if cat != 0 and cat != nil and cat != ""

    city_cond = "and lower(city)  = '#{city.downcase}'"  if city != 0 and city != nil and city != "" and city!='All'


    date_cond = "(activity_schedules.start_date in ('#{date}') or (activity_schedules.start_date<='#{date}' and activity_schedules.end_date >= '#{date}'))" if date != 0 and date != nil and date != ""

    user_cond = "and activities.user_id = #{user_id}" if user_id != 0 and user_id != nil and user_id != "" and user_id!='All'

    return act = Activity.find_by_sql("SELECT * FROM activities INNER JOIN activity_schedules ON activity_schedules.activity_id = activities.activity_id
              WHERE (lower(active_status)='active'
              and lower(activities.schedule_mode)='any time' #{user_cond}
              #{city_cond} #{cat_cond} #{cleaned_cond})
              or ( #{date_cond} #{city_cond} #{cat_cond}#{user_cond}#{cleaned_cond} and lower(activities.active_status)='active') order by activities.activity_id desc limit 100").uniq
    #    return act = Activity.find_by_sql("SELECT * FROM activities INNER JOIN activity_schedules ON activity_schedules.activity_id = activities.activity_id
    #              WHERE lower(active_status)='active'
    #{city_cond} #{cat_cond} #{date_cond} order by activities.activity_id desc#").uniq

    #    return act = Activity.order("activity_id desc").select("activities.*, activity_schedules.*").joins(:activity_schedule).where("lower(active_status)='active' And lower(city) = '#{city}' And lower(sub_category)='#{rowtype}' And start_date = '#{cdate}'").uniq

  end


    
  #Fetching activity row values showing in activity index page
  def self.get_activity_row_values(city,date,cat)


    city_cond = " "

    date_cond = " "
    cat_cond = " "
     
    cat_cond = "And lower(category)='#{cat.downcase}'" if cat != 0 and cat != nil and cat != ""

    city_cond = "and lower(city)  = '#{city.downcase}'"  if city != 0 and city != nil and city != "" and city!='All'

    cleaned_cond = "and cleaned =true"
    date_cond = "(activity_schedules.start_date in ('#{date}') or (activity_schedules.start_date<='#{date}' and activity_schedules.end_date >= '#{date}'))" if date != 0 and date != nil and date != ""

    
    return act = Activity.find_by_sql("SELECT * FROM activities INNER JOIN activity_schedules ON activity_schedules.activity_id = activities.activity_id
              WHERE (lower(active_status)='active'
              and lower(activities.schedule_mode)='any time'
              #{city_cond} #{cat_cond} #{cleaned_cond})
              or ( #{date_cond} #{city_cond} #{cat_cond} #{cleaned_cond} and lower(activities.active_status)='active') order by activities.activity_id desc limit 100").uniq
    #    return act = Activity.find_by_sql("SELECT * FROM activities INNER JOIN activity_schedules ON activity_schedules.activity_id = activities.activity_id
    #              WHERE lower(active_status)='active'
    #{city_cond} #{cat_cond} #{date_cond} order by activities.activity_id desc#").uniq

    #    return act = Activity.order("activity_id desc").select("activities.*, activity_schedules.*").joins(:activity_schedule).where("lower(active_status)='active' And lower(city) = '#{city}' And lower(sub_category)='#{rowtype}' And start_date = '#{cdate}'").uniq
    
  end


  #Activities from user favorites
  def self.get_saved_favorites(city,zip,date,user_id)
    fav_cond = "activity_id in(select activity_id from activity_favorites where user_id =#{user_id} order by inserted_date desc limit 60)"
    #~ select * from activities where activity_id in(select activity_id from activity_favorites where user_id = 61) and cleaned = true and lower(active_status)='active' or(lower(created_by)='parent' and user_id = 61 and lower(active_status)='active') order by activity_id
    return act = Activity.find_by_sql("select * from activities where #{fav_cond} and cleaned = true and lower(active_status)='active'").uniq
    #~ return act = ActivityFavorite.find_by_sql("select * from activity_favorites where user_id =#{user_id} order by inserted_date desc").uniq
  end
  
  
  #Activities from user favorites
  def self.get_saved_created_activities(city,zip,date,user_id)
    #~ fav_cond = "activity_id in(select activity_id from activity_favorites where user_id =#{user_id} )"
    #~ select * from activities where activity_id in(select activity_id from activity_favorites where user_id = 61) and cleaned = true and lower(active_status)='active' or(lower(created_by)='parent' and user_id = 61 and lower(active_status)='active') order by activity_id
    return act = Activity.find_by_sql("select * from activities where (lower(created_by)='parent' and user_id = #{user_id} and lower(active_status) = 'active') order by activity_id desc limit 100").uniq
  end

  #Activities based on to provider
  def self.get_provider_activities(city,zip,date,filter_id,user_id)

    city_cond = " "

    date_cond = " "

    city_cond = "and lower(city)  = '#{city.downcase}'"  if city != 0 and city != nil and city != "" and city!='All'

    city_cond = " and zip_code = '#{zip}'"  if zip != 0 and zip != nil and zip != ""

    date_cond = "or (activity_schedules.start_date in ('#{date}') or (activity_schedules.start_date<='#{date}' and activity_schedules.end_date >= '#{date}'))" if date != 0 and date != nil and date != ""
    filter_cond = "and filter_id=#{filter_id}"

    featured_cond = "filter_id=#{filter_id}"
    cleaned_cond = "and cleaned =true and lower(created_by) = 'provider'"
    filter_cond = "and featured_flag = true" if filter_id == 1

    featured_cond = "featured_flag = true" if filter_id == 1
    
    return act = Activity.find_by_sql("SELECT * FROM activities INNER JOIN activity_schedules ON activity_schedules.activity_id = activities.activity_id
              WHERE (lower(active_status)='active' and user_id = #{user_id}
              and lower(activities.schedule_mode)='any time'
              #{city_cond}#{filter_cond} #{cleaned_cond})
              or (#{featured_cond} #{date_cond} #{city_cond}#{cleaned_cond} and lower(activities.active_status)='active')order by activities.activity_id desc").uniq

  end

  #calling from provider activity_update action
  def self.get_providertype_zip_code_update(city,zip,date,user_id)

    city_cond = " "

    date_cond = " "
    cleaned_cond = "and cleaned =true"
    city_cond = "and lower(city) = '#{city.downcase}'" if city != 0 and city != nil and city != "" and city!='All'

    city_cond = " and zip_code = '#{zip}'" if zip != 0 and zip != nil and zip != ""

    date_cond = "activity_id in(select activity_id from activity_schedules where (start_date in ('#{date}') or (start_date<='#{date}' and end_date >= '#{date}')))" if date != 0 and date != nil and date != ""


    return act = Activity.find_by_sql("select * from activities where #{date_cond} #{city_cond} #{cleaned_cond} and user_id =#{user_id} and created_by ='Provider' and lower(active_status)='active'  order by activity_id desc").uniq
  end



  #used for admin
  def self.get_admin_activities(cat_zc,city,cat,date_from, date_to)
    city_cond = " "
    created_cond = "and created_by = 'Provider'"
    if cat_zc =="date"

      city_cond = "and lower(city) = '#{city.downcase.strip}'" if city != 0 and city != nil and city != "" and city!='All' and city != "Location"

      return act = Activity.find_by_sql("select * from activities where lower(active_status)!='delete' and inserted_date >= '#{date_from} 00:00:00' and inserted_date <= '#{date_to} 23:59:59' #{city_cond} order by activity_id desc").uniq
    elsif cat_zc == "next_7_days"
      date_cond = "(activity_schedules.start_date in ('#{date_from}') or (activity_schedules.start_date<='#{date_from}' and activity_schedules.end_date >= '#{date_to}'))"


      return act = Activity.find_by_sql("SELECT * FROM activities INNER JOIN activity_schedules ON activity_schedules.activity_id = activities.activity_id
              WHERE (lower(active_status)!='delete'
              and lower(activities.schedule_mode)='any time'
              #{city_cond}#{created_cond})
              or ( #{date_cond} #{city_cond}#{created_cond} )order by activities.activity_id desc").uniq
      
    elsif cat_zc=="category"

      city_cond = "and lower(city) = '#{city.downcase.strip}'" if city != 0 and city != nil and city != "" and city!='All' and city != "Location"

      return act = Activity.find_by_sql("select * from activities where lower(active_status)!='delete' and lower(sub_category) = '#{cat.downcase}' #{city_cond} #{created_cond} order by activity_id desc").uniq
    elsif cat_zc=="provider"
      
      city_cond = "and lower(city) = '#{city.downcase.strip}'" if city != 0 and city != nil and city != "" and city!='All' and city != "Location"

      return act = Activity.find_by_sql("select * from activities where lower(active_status)!='delete' and (user_id = #{cat}) #{city_cond} #{created_cond} order by activity_id desc").uniq
    elsif cat_zc=="description"
     
      city_cond = "and lower(city) = '#{city.downcase.strip}'"  if city != 0 and city != nil and city != "" and city!='All' and city != "Location"

      return act = Activity.find_by_sql("select * from activities where lower(active_status)!='delete' and (description = '' or description = 'Description should not exceed 500 characters')  #{city_cond} #{created_cond} order by activity_id desc").uniq
    elsif cat_zc=="created_date"
      
      city_cond = "and lower(city) = '#{city.downcase.strip}'" if city != 0 and city != nil and city != "" and city!='All' and city != "Location"

      return act = Activity.find_by_sql("select * from activities where lower(active_status)!='delete' and date(inserted_date) = '#{date_from}'  #{city_cond} #{created_cond} order by activity_id desc").uniq
    elsif cat_zc=="approved"
      
      city_cond = "and lower(city) = '#{city.downcase.strip}'" if city != 0 and city != nil and city != "" and city!='All'and city != "Location"

      return act = Activity.find_by_sql("select * from activities where lower(active_status)!='delete'and cleaned=true #{city_cond} #{created_cond}order by activity_id desc").uniq
    elsif cat_zc=="unapproved"

      city_cond = "and lower(city) = '#{city.downcase.strip}'" if city != 0 and city != nil and city != "" and city!='All'and city != "Location"

      return act = Activity.find_by_sql("select * from activities where lower(active_status)!='delete' and (approve_flag is null or approve_flag = false  or cleaned=false) #{city_cond} #{created_cond}order by activity_id desc").uniq
  
    else
      
      city_cond = "and lower(city) = '#{city.downcase.strip}'" if city != 0 and city != nil and city != "" and city!='All'and city != "Location"

      return act = Activity.find_by_sql("select * from activities where lower(active_status)!='delete' #{city_cond} #{created_cond}order by activity_id desc").uniq
    end
  end


  #calling from provider index
  def self.get_providertype_zip_code(city,zip,date,user_id)

    city_cond = " "
    if city != 0 and city != nil and city != "" and city!='All'
      city_cond = "and lower(city) = '#{city.downcase}'"
    end

    zip_cond = " "
    if zip != 0 and zip != nil and zip != ""
      zip_cond = " and zip_code = '#{zip}'"
    end

    date_cond = " "
    if date != 0 and date != nil and date != ""
      date_cond = "activity_id in(select activities from activity_schedules where start_date = '#{date}')"
    end
    
    return act = Activity.find_by_sql("select * from activities where user_id =#{user_id} and lower(active_status)='active' order by activity_id desc").uniq

  end


  #basic search for provider activities list. date 18.1.2013. !--dont delete this code--!
  def self.search_data(search,user_id)
    if search !="" && search !=nil
      #display the results when the user entered the text in search box.
      #~ find(:all, :conditions => ["created_by = ? and user_id = ? and active_status != ? and lower(activity_name) LIKE ? and cleaned = true","Provider","#{user_id}","Delete", "%#{search.downcase}%"])
      Activity.find_by_sql("select a.* from activities a left join school_representatives s on a.activity_id=s.activity_id where (user_id=#{user_id} or vendor_id=#{user_id} or representative_id=#{user_id}) and lower(activity_name) LIKE '%#{search.downcase}%' and cleaned=true and lower(active_status)!='delete' and user_id=#{user_id} and lower(created_by)='provider' order by a.activity_id desc")
    end
  end
  
  #basic search for admin list date 28.1.13 when admin enter the text in search box.
  def self.search_admin(search)
    if search !="" && search!=nil
      #display the results when the user entered the text in search box.
      find(:all, :conditions => ["lower(activity_name) LIKE ? and cleaned = true and lower(active_status)='active'", "%#{search.downcase}%" ], :order => 'activity_name asc')
      #~ else
      #~ #display the results based on the users.
      #~ find(:all)
    end
  end
  
  #basic search for parent list date 29.1.13 when admin enter the text in search box.
  def self.search_parent(search)
    if search !="" && search!=nil
      #display the results when the user entered the text in search box.
      find(:all, :conditions => ["lower(activity_name) LIKE ? or lower(category) LIKE ? or lower(sub_category) LIKE ? and cleaned = true and lower(active_status)='active' and lower(created_by)='provider'", "%#{search.downcase}%", "%#{search.downcase}%", "%#{search.downcase}%" ], :order => 'activity_name asc')
      #~ else
      #~ #display the results based on the users.
      #~ find(:all, :conditions => ["category LIKE ?", "%#{search}%" ], :order => 'category asc')
    end
  end


  def self.schedule_repeat_append(event,events,type_icon,schedule,date)
    @schedule = schedule
    if @schedule.schedule_mode == "Schedule"
      @repeat = ActivityRepeat.where("activity_schedule_id =?",@schedule.schedule_id).last
      info = false
      js_start_date = Date.parse(date)
      js_end_date = Date.parse(date)
      @type_icon = type_icon
      if @repeat
        if @repeat.repeats == "Daily"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            self.repeat_schedule(event, events, js_end_date, js_start_date, running_date,'daily',info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              self.repeat_schedule_end(event, events, js_end_date, js_start_date, occ, running_date,'daily',info)
            else
              occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
              self.repeat_schedule_occurance(event, events, js_end_date, js_start_date, occ, running_date,'daily',info)
            end
          end
        end
        if @repeat.repeats == "yearly"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            self.repeat_schedule(event, events, js_end_date, js_start_date, running_date,'yearly',info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              self.repeat_schedule_end(event, events, js_end_date, js_start_date, occ, running_date,'yearly',info)
            else
              occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
              self.repeat_schedule_end(event, events, js_end_date, js_start_date, occ, running_date,'yearly',info)
            end
          end
        end
        if @repeat.repeats == "Weekly"
          running_date = @schedule.start_date
          @wek =[]
          @ss =[]
          
          rep = @repeat.repeat_on.split(",")
          rep.each do|s|
            if s=="Mon"||s=="mon"
              @wek.push(1)
              @ss.push(:monday)
            elsif s =="Tue"||s=="tue"
              @wek.push(2)
              @ss.push(:tuesday)
            elsif s =="Wed"||s=="wed"
              @wek.push(3)
              @ss.push(:wednesday)
            elsif s =="Thu"||s=="thu"
              @wek.push(4)
              @ss.push(:thursday)
            elsif s =="Fri"||s=="fri"
              @wek.push(5)
              @ss.push(:friday)
            elsif s =="Sat"||s=="sat"
              @wek.push(6)
              @ss.push(:saturday)
            elsif s =="Sun"||s=="sun"
              @wek.push(0)
              @ss.push(:sunday)
            end if s!=""
          end
          if @repeat.ends_never == true
            self.repeat_weekly_never(event, events, js_end_date, js_start_date, running_date,info) if !@ss.nil? && !@ss.empty?
          else
            if !@repeat.ends_on.nil? && @repeat.ends_on!=''
              occ = @repeat.ends_on

              self.repeat_weekly(event, events, js_end_date, js_start_date, occ, running_date,info) if !@ss.nil? && !@ss.empty?
            else
              occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i * 7).days
              self.repeat_weekly(event, events, js_end_date, js_start_date, occ, running_date,info) if !@ss.nil? && !@ss.empty?
            end
          end
        end
        if @repeat.repeats == "Monthly"
          running_date = @schedule.start_date
          if @repeat.repeated_by_month == true
            s = week_of_month_for_date(running_date)
            if s == 1
              se = :first
            elsif s==2
              se = :second
            elsif s==3
              se = :third
            elsif s>=4
              se = :last
            end

            if @repeat.ends_never == true
              self.repeat_monthly_day_never(event, events, js_end_date, js_start_date, running_date,se,info)
            else
              if !@repeat.ends_on.nil?
                occ = @repeat.ends_on
                self.repeat_monthly_day(event, events, js_end_date, js_start_date, occ, running_date,se,info)
              else
                occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
                self.repeat_monthly_day(event, events, js_end_date, js_start_date, occ, running_date,se,info)
              end
            end
          else
            if @repeat.ends_never == true
              self.repeat_monthly_date_never(event, events, js_end_date, js_start_date, running_date,se,info)
            else
              if !@repeat.ends_on.nil?
                occ = @repeat.ends_on
                self.repeat_monthly_date(event, events, js_end_date, js_start_date, occ, running_date,se,info)
              else
                occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
                self.repeat_monthly_date(event, events, js_end_date, js_start_date, occ, running_date,se,info)
              end
            end
          end
        end
        if @repeat.repeats == "Every week (Monday to Friday)"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            self.every_week_mon_to_fri_never(event, events, js_end_date, js_start_date, running_date,info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              self.every_week_mon_to_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
            else
              occ = @schedule.start_date + (@repeat.end_occurences.to_i * 7).days
              self.every_week_mon_to_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
            end
          end
        end
        if @repeat.repeats == "Every Monday,Wednesday and Friday"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            self.every_mon_wed_fri_never(event, events, js_end_date, js_start_date, running_date,info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              self.every_mon_wed_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
            else
              occ = @schedule.start_date + (@repeat.end_occurences.to_i * 7).days
              self.every_mon_wed_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
            end
          end
        end
        if @repeat.repeats == "Every Tuesday and Thursday"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            self.every_tue_thu_never(event, events, js_end_date, js_start_date, running_date,info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              self.every_tue_thu(event, events, js_end_date, js_start_date, occ, running_date,info)
            else
              occ = @schedule.start_date + (@repeat.end_occurences.to_i * 7).days
              self.every_tue_thu(event, events, js_end_date, js_start_date, occ, running_date,info)
            end
          end
        end

      else
        if @schedule.start_date == js_start_date.to_s

          events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
        end
      end
    elsif @schedule.schedule_mode == "Camps/Workshop"
      if @schedule.end_date >= Date.parse(date)
        events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
      end
    elsif @schedule.schedule_mode == "Any Time"
      #      any_time = ActivitySchedule.where("activity_id = ?",event.activity_id)
      date_w = Time.parse(date).strftime("%a") if !date.nil?
      any_time = ActivitySchedule.where("activity_id =#{event.activity_id} and business_hours='#{date_w.downcase}'").last

      if !any_time.nil?
        events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
      end
    end if @schedule

  end

  def self.repeat_weekly(event, events, js_end_date, js_start_date, occ, running_date,info)
    date_un = DateTime.parse(js_end_date.to_s)
    if @repeat.repeat_every.to_i !=0
      r = Recurrence.new(:every => :week, :on => @ss,:starts =>running_date,:until => date_un,:interval=>@repeat.repeat_every.to_i)
    else
      r = Recurrence.new(:every => :week, :on => @ss,:starts =>running_date,:until => date_un)
    end

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date <= occ
          if r.events.include?(running_date)

            events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
            #            events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
          end
        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def self.repeat_weekly_never(event, events, js_end_date, js_start_date, running_date,info)
    date_js = DateTime.parse(js_end_date.to_s)
    if @repeat.repeat_every.to_i !=0
      r = Recurrence.new(:every => :week, :on => @ss,:starts =>running_date,:until => date_js,:interval=>@repeat.repeat_every.to_i)
    else
      r = Recurrence.new(:every => :week, :on => @ss,:starts =>running_date,:until => date_js)
    end

    while js_end_date >= running_date
      if js_start_date <= running_date
        if r.events.include?(running_date)
          events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def self.repeat_monthly_day(event, events, js_end_date, js_start_date, occ, running_date,se,info)
    w_day = running_date.strftime("%A") if !running_date.nil?
    r = Recurrence.new(:every => :month, :on => se,  :weekday =>:"#{w_day.downcase}" , :interval => @repeat.repeat_every.to_i)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date <= occ
          if r.events.include?(running_date)
            events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
            #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
          end
        end
      end
      running_date = running_date + 1.days
    end

    return running_date
  end

  # TODO Comment
  def self.repeat_monthly_day_never(event, events, js_end_date, js_start_date,running_date,se,info)
    w_day = running_date.strftime("%A")  if !running_date.nil?
    r = Recurrence.new(:every => :month, :on => se,  :weekday =>:"#{w_day.downcase}" , :interval => @repeat.repeat_every.to_i)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if r.events.include?(running_date)
          events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def self.repeat_monthly_date_never(event, events, js_end_date, js_start_date,running_date,se,info)
    w_date = running_date.strftime("%d")  if !running_date.nil?
    r = Recurrence.new(:every => :month, :on => w_date.to_i, :interval => @repeat.repeat_every.to_i)
    while js_end_date >= running_date
      if js_start_date <= running_date
        if r.events.include?(running_date)
          events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end



  def self.repeat_monthly_date(event, events, js_end_date, js_start_date, occ, running_date,se,info)
    w_date = running_date.strftime("%d")  if !running_date.nil?
    r = Recurrence.new(:every => :month, :on => w_date.to_i, :interval => @repeat.repeat_every.to_i)

    while js_end_date >= running_date
      if running_date <= occ
        if r.events.include?(running_date)
          events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end if js_start_date <= running_date
      end
      running_date = running_date + 1.days
    end

    return running_date
  end

  # TODO Comment
  def self.every_week_mon_to_fri_never(event, events, js_end_date, js_start_date, running_date,info)


    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date.wday !=0 && running_date.wday !=6
          events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end

      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def self.every_week_mon_to_fri(event, events, js_end_date, js_start_date, occ, running_date,info)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date <= occ
          if running_date.wday !=0 && running_date.wday !=6
            events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
            #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
          end
        end
        running_date = running_date + 1.days
      end
    end
    return running_date
  end

  # TODO Comment
  def self.every_mon_wed_fri_never(event, events, js_end_date, js_start_date, running_date,info)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date.wday ==1 || running_date.wday == 3 || running_date.wday == 5
          events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}

        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def self.every_mon_wed_fri(event, events, js_end_date, js_start_date, occ, running_date,info)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date <= occ
          if running_date.wday ==1 || running_date.wday == 3 || running_date.wday == 5
            events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
            #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
          end
        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def self.every_tue_thu_never(event, events, js_end_date, js_start_date, running_date,info)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date.wday ==2 || running_date.wday == 4
          events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          #         events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def self.every_tue_thu(event, events, js_end_date, js_start_date, occ, running_date,info)

    while js_end_date >= running_date
      if running_date.wday ==2 || running_date.wday == 4
        events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
      end if running_date <= occ if js_start_date <= running_date
      running_date = running_date + 1.days
    end
  end

  # TODO Comment
  def self.repeat_schedule_occurance(event, events, js_end_date, js_start_date, occ, running_date,type,info)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date <= occ
          events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
        end
      end
      rep = @repeat.repeat_every.to_i.days if type == 'daily'
      rep = @repeat.repeat_every.to_i.years if type == 'yearly'
      running_date = running_date + rep
    end
    return running_date
  end

  # TODO Comment
  def self.repeat_schedule_end(event, events, js_end_date, js_start_date, occ, running_date,type,info)

    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date <= occ
          events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
          ##          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      rep = @repeat.repeat_every.to_i.days if type == 'daily'
      rep = @repeat.repeat_every.to_i.years if type == 'yearly'

      running_date = running_date + rep
    end
    return running_date
  end

  # TODO Comment
  def self.repeat_schedule(event, events, js_end_date, js_start_date,running_date,type,info)

    while js_end_date >= running_date
      if js_start_date <= running_date
        events << {:id => event.activity_id, :price_type => event.price_type, :city => event.city, :activity_name => event.activity_name, :description => event.description,:avatar=> event.avatar,:avatar_file_name=>event.avatar_file_name,:category=>event.category,:sub_category=>event.sub_category,:price=>event.price,:address_1=>event.address_1,:address_2=>event.address_2,:age_range=>event.age_range,:no_participants=>event.no_participants,:created_by=>event.created_by,:user_id=>event.user_id}
      end
      rep = @repeat.repeat_every.to_i.days if type == 'daily'
      rep = @repeat.repeat_every.to_i.years if type == 'yearly'

      running_date = running_date + rep
    end

    return  running_date
  end

  def self.week_of_month_for_date(date)
    my_date = date
    week_of_target_date = my_date.strftime("%U").to_i if !my_date.nil?
    week_of_beginning_of_month = my_date.beginning_of_month.strftime("%U").to_i  if !my_date.beginning_of_month.nil?
    week_of_target_date - week_of_beginning_of_month + 1
  end
  
  #get favorite activities for setting page
  def self.setting_favorite_activity(user_id)
    return setting_details = Activity.find_by_sql("select a.* from activity_favorites f left join activities a on f.activity_id = a.activity_id where f.user_id='#{user_id}' and lower(a.active_status)='active' order by a.activity_id desc").uniq
    #~ return setting_details = Activity.find_by_sql("select * from activities where activity_id in(select Distinct(activity_id) from activity_favorites where user_id = #{user_id} ) and (lower(active_status)='active') and lower(created_by)='parent' order by activity_id desc").uniq
  end
  
  def self.setting_attend_activity(user_id)
    return setting_attend = Activity.find_by_sql("select a.* from activity_attend_details p left join activities a on p.activity_id = a.activity_id where lower(p.payment_status)='paid' and p.user_id='#{user_id}' and lower(a.active_status)='active' order by a.activity_id desc").uniq
  end
  #~ define_index do
  #~ indexes :activity_name, :sortable=> true
  #~ indexes :created_by
  #~ has user_id, :type => :integer
  #~ end


  #~ def self.get_provider_saved_favorites(user_id)
  #~ fav_cond = "activity_id in(select activity_id from activity_favorites where user_id =#{user_id} )"
  #~ return act = Activity.find_by_sql("select * from activities where #{fav_cond} and cleaned = true and lower(active_status)='active' order by activity_id desc limit 100").uniq
  #~ end
   
  #~ #provider shared activity
  #~ def self.get_shared_activities(user_id,email)
  #~ return  act_provider =  Activity.find_by_sql("select * from activities where activity_id in(select activity_id from activity_shareds where shared_to='#{email}' or activity_shareds.user_id='#{user_id}') and lower(active_status)='active' and cleaned = true order by activity_id desc limit 100").uniq
  #~ end
 
  #provider shared activity free activity
  def self.get_provider_activities_free(city,zip,date,user_id)
 
    city_cond = " "
 
    date_cond = " "
 
    cleaned_cond = "and cleaned =true and user_id=#{user_id}"
 
    city_cond = "and lower(city)  = '#{city.downcase}'"  if city != 0 and city != nil and city != "" and city!='All'
 
    city_cond = "and zip_code = '#{zip}'"  if zip != 0 and zip != nil and zip != ""
 
    date_cond = "and (start_date <='#{date}')"  if date != 0 and date != nil and date != ""
 
    filter_cond = "and price_type='3'"
 
    return act = Activity.find_by_sql("SELECT * FROM activities INNER JOIN activity_schedules ON activity_schedules.activity_id = activities.activity_id where
                                      lower(active_status)='active'  #{city_cond} #{filter_cond} #{date_cond}#{cleaned_cond} Or (lower(activities.schedule_mode)='any time' and lower(activities.active_status) = 'active' #{filter_cond} #{city_cond} #{cleaned_cond}) Or (lower(activities.schedule_mode)='by appointment' #{filter_cond} #{city_cond} #{cleaned_cond} and lower(activities.active_status) = 'active') limit 100").uniq 
 
  end
  
  
  ##################################
  #activity featured row displayed based on future date
  
  #get activity count and insert into temp table
  def self.schedule_feature_list(c_date,actv,arr)
    @c_date1 = c_date
    @schedule = ActivitySchedule.where("activity_id = ?",actv.activity_id).last
    @a_share = actv
    @c_date1 = Time.now.strftime("%Y-%m-%d") if @c_date1.nil?
    if !@schedule.nil? && @schedule!='' && @schedule.present?
      #if schedule, repeat yes
      @repeat = ActivityRepeat.where("activity_schedule_id=?",@schedule["schedule_id"]).last
      @c_date = DateTime.parse(@c_date1).strftime("%Y-%m-%d")
      @c_day = DateTime.parse(@c_date1).strftime("%a")
      @schedule_start = @schedule.start_date
      if !@repeat.nil? && @repeat!='' && @repeat.present?
        #start daily
        if @repeat.repeats=="Daily"
          repeat_daily_feature(@c_date,@repeat,@schedule,actv,arr,@c_day)
        end
        if @repeat.repeats=="Weekly"
          repeat_weekly_feature(@c_date,@repeat,@schedule,actv,arr,@c_day)
        end
        if @repeat.repeats =="Every week (Monday to Friday)"
          repeat_weekly_feature(@c_date,@repeat,@schedule,actv,arr,@c_day)
        end
        if @repeat.repeats =="Every Monday,Wednesday and Friday"
          repeat_weekly_feature(@c_date,@repeat,@schedule,actv,arr,@c_day)
        end
        if @repeat.repeats =="Every Tuesday and Thursday"
          repeat_weekly_feature(@c_date,@repeat,@schedule,actv,arr,@c_day)
        end
        if @repeat.repeats=="Monthly"
          repeat_monthly_feature(@c_date,@repeat,@schedule,actv,arr,@c_day)
        end
        if @repeat.repeats=="Yearly"
          repeat_yearly_feature(@c_date,@repeat,@schedule,actv,arr,@c_day)
        end
      else	
        #without repeat start camps/workshop
        #if start and end date is exist	
        if !@schedule["start_date"].nil? && !@schedule["end_date"].nil?		
          if (@schedule["start_date"].strftime("%Y-%m-%d") <= @c_date) && (@schedule["end_date"].strftime("%Y-%m-%d") >= @c_date)
            arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
            #~ elsif @schedule["start_date"].strftime("%Y-%m-%d") < @c_date
            #~ arr << {:id => actv.activity_id, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
          elsif @schedule["start_date"].strftime("%Y-%m-%d") >= @c_date
            arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
          end
        else
          #start date is exist and end date is nil
          if !@schedule["start_date"].nil? && @schedule["end_date"].nil?
            @schedule_ = ActivitySchedule.where("activity_id =#{actv.activity_id} and  start_date >='#{@c_date}'").last
            if !@schedule_.nil? && @schedule_.present?
              arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
            end
          else
            if !@schedule.nil? && @schedule!='' && @schedule.present?
              arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
            end
          end
        end #inner without repeat end
      end # repeat check loop end
    else
      #activity dont have schedule eg by appointment
      if (@a_share.inserted_date.strftime("%Y-%m-%d") <= @c_date1)
        arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
      end
    end  #schedule loop end
  end
  
  #view page repeat functionality
  def self.repeat_daily_feature(c_date,repeat,schedule,actv,arr,c_day)
    @c_date = c_date
    @repeat = repeat
    @schedule = schedule
    @a_share = actv
    #if daily and ends never true
    if @repeat.ends_never == true
      s_date = @schedule.start_date
      r = Recurrence.new(:every => :day, :starts =>@schedule.start_date, :interval => @repeat.repeat_every.to_i)
      if r.events.length > 0
        arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
      end
      #if Daily and ends on exists
    elsif !@repeat.ends_on.nil?
      s_date =  @schedule.start_date
      if @repeat.ends_on.strftime("%Y-%m-%d") >= @c_date
        r = Recurrence.new(:every => :day, :starts =>@schedule.start_date, :until =>@repeat.ends_on, :interval => @repeat.repeat_every.to_i)
        if r.events.length > 0
          arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
        end
      end
      #if Daily and end occurences exists
    elsif !@repeat.end_occurences.nil?
      e_date = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
      s_date =  @schedule.start_date
      if e_date.strftime("%Y-%m-%d") >= @c_date
        r = Recurrence.new(:every => :day, :starts =>@schedule.start_date, :until =>e_date, :interval => @repeat.repeat_every.to_i)
        if r.events.length > 0
          arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
        end
      end
    end
  end
  
  def self.repeat_weekly_feature(c_date,repeat,schedule,actv,arr,c_day)
    @c_date = c_date
    @repeat = repeat
    @schedule = schedule
    @a_share = actv
    @wek =[]
    @ss =[]
    s_date=@schedule.start_date
    
    repeat_o = @repeat.repeat_on
    if !repeat_o.nil? && repeat_o!='' && repeat_o.present?
      rep = repeat_o.split(",")
      rep.each do|s|
        if s.downcase=="mon"
          @wek.push(1)
          @ss.push(:monday)
        elsif s.downcase =="tue"
          @wek.push(2)
          @ss.push(:tuesday)
        elsif s.downcase =="wed"
          @wek.push(3)
          @ss.push(:wednesday)
        elsif s.downcase =="thu"
          @wek.push(4)
          @ss.push(:thursday)
        elsif s.downcase =="fri"
          @wek.push(5)
          @ss.push(:friday)
        elsif s.downcase =="sat"
          @wek.push(6)
          @ss.push(:saturday)
        elsif s.downcase =="sun"
          @wek.push(0)
          @ss.push(:sunday)
        end if s!=""
      end
    end
    #if weekly and ends never true
    if @repeat.ends_never == true
      if @ss!='' && !@ss.nil? && @ss.present?
        r = Recurrence.new(:every => :week, :starts =>@schedule.start_date, :on =>@ss, :interval =>@repeat.repeat_every.to_i)
        # p r
        if r.events.length > 0
          arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
        end
      end
      #if weekly and ends on exists
    elsif !@repeat.ends_on.nil?
      end_date = @repeat.ends_on
      if end_date.strftime("%Y-%m-%d") >= @c_date
        if @ss!='' && !@ss.nil? && @ss.present?
          r = Recurrence.new(:every => :week, :on =>@ss, :starts =>@schedule.start_date, :until=>end_date, :interval =>@repeat.repeat_every.to_i)
          if r.events.length > 0
            arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
          end
        end
      end
      #if weekly and end occurences exists
    elsif !@repeat.end_occurences.nil?
      end_date = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i * 7).days
      if end_date.strftime("%Y-%m-%d") >= @c_date
        if @ss!='' && !@ss.nil? && @ss.present?
          r = Recurrence.new(:every => :week, :on =>@ss, :starts =>@schedule.start_date, :until=>end_date, :interval =>@repeat.repeat_every.to_i)
          if r.events.length > 0
            arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
          end
        end
      end
    end
  end

  #repeat monthly
  def self.repeat_monthly_feature(c_date,repeat,schedule,actv,arr,c_day)
    @c_date = c_date
    @repeat = repeat
    @schedule = schedule
    @a_share = actv
    s_date =  @schedule.start_date
    s = week_of_month_for_date(s_date)
    if s == 1
      se = :first
    elsif s==2
      se = :second
    elsif s==3
      se = :third
    elsif s>=4
      se = :last
    end
    if @repeat.ends_never == true
      if @repeat.repeated_by_month == true
        s_date = s_date.strftime("%d")
        r = Recurrence.new(:every => :month, :starts =>@schedule.start_date, :on =>s_date.to_i, :interval => @repeat.repeat_every.to_i)
        if r.events.length > 0
          arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
        end
      else
        s_day = s_date.strftime("%a")
        r = Recurrence.new(:every => :month, :on =>"#{se}",  :starts =>@schedule.start_date, :weekday =>"#{s_day.downcase}", :interval => @repeat.repeat_every.to_i)
        if r.events.length > 0
          arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
        end
      end
    
      # # #if Daily and ends on exists
    elsif !@repeat.ends_on.nil?
      s_date =  @schedule.start_date
      if @repeat.ends_on.strftime("%Y-%m-%d") >= @c_date
        if @repeat.repeated_by_month == true
          s_date1 = s_date.strftime("%d")
          r = Recurrence.new(:every => :month, :on =>s_date1.to_i,:starts =>@schedule.start_date, :until => @repeat.ends_on, :interval => @repeat.repeat_every.to_i)
          if r.events.length > 0
            arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
          end
        else
          s_day = s_date.strftime("%a")
          r = Recurrence.new(:every => :month, :on =>"#{se}",  :weekday =>"#{s_day.downcase}", :starts =>@schedule.start_date, :until => @repeat.ends_on, :interval => @repeat.repeat_every.to_i)
          if r.events.length > 0
            arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
          end
        end
      end
      # #if monthly and end occurences exists
    elsif !@repeat.end_occurences.nil?
      e_date = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).months
      s_date =  @schedule.start_date
      if e_date.strftime("%Y-%m-%d") >= @c_date
        if @repeat.repeated_by_month == true
          s_date1 = s_date.strftime("%d")
          r = Recurrence.new(:every => :month, :on =>s_date1.to_i,:starts =>@schedule.start_date, :until => e_date, :interval => @repeat.repeat_every.to_i)
          if r.events.length > 0
            arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
          end
        else
          s_day = s_date.strftime("%a")
          r = Recurrence.new(:every => :month, :on =>"#{se}",  :weekday =>"#{s_day.downcase}", :starts =>@schedule.start_date, :until => e_date, :interval => @repeat.repeat_every.to_i)
          if r.events.length > 0
            arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
          end
        end
      end
    end
  end
  
  #repeat yearly
  def self.repeat_yearly_feature(c_date,repeat,schedule,actv,arr,c_day)
    @c_date = c_date
    @repeat = repeat
    @schedule = schedule
    @a_share = actv
    #if daily and ends never true
    if @repeat.ends_never == true
      s_date = @schedule.start_date
      r = Recurrence.new(:every => :year, :starts =>@schedule.start_date, :on => [s_date.strftime("%m").to_i, s_date.strftime("%d").to_i], :interval => @repeat.repeat_every.to_i)
      if r.events.length > 0
        arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
      end
       
      #if Daily and ends on exists
    elsif !@repeat.ends_on.nil?
      s_date =  @schedule.start_date
      if @repeat.ends_on.strftime("%Y-%m-%d") >= @c_date
        r = Recurrence.new(:every => :year, :on => [s_date.strftime("%m").to_i, s_date.strftime("%d").to_i],:starts =>@schedule.start_date, :until => @repeat.ends_on, :interval => @repeat.repeat_every.to_i)
        if r.events.length > 0
          arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
        end
      end
      #if Daily and end occurences exists
    elsif !@repeat.end_occurences.nil?
      e_date = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).years
      s_date =  @schedule.start_date
      if e_date.strftime("%Y-%m-%d") >= @c_date
        r = Recurrence.new(:every => :year, :on => [s_date.strftime("%m").to_i, s_date.strftime("%d").to_i],:starts =>@schedule.start_date, :until => e_date, :interval => @repeat.repeat_every.to_i)
        if r.events.length > 0
          arr << {:slug => actv.slug, :purchase_url=>actv.purchase_url, :discount_eligible=>actv.discount_eligible, :schedule =>@schedule, :activity=>@a_share, :id => actv.activity_id, :leader=>actv.leader, :skill_level=>actv.skill_level, :schedule_mode=>actv.schedule_mode, :filter_id=>actv.filter_id, :min_age_range=>actv.min_age_range, :max_age_range=>actv.max_age_range, :price_type => actv.price_type, :city => actv.city, :activity_name => actv.activity_name, :description => actv.description,:avatar=> actv.avatar,:avatar_file_name=>actv.avatar_file_name,:category=>actv.category,:sub_category=>actv.sub_category,:price=>actv.price,:address_1=>actv.address_1,:address_2=>actv.address_2,:age_range=>actv.age_range,:no_participants=>actv.no_participants,:created_by=>actv.created_by,:user_id=>actv.user_id}
        end
      end
    end
  end
  ##################################
  
  def self.ip_city_name(ip_addr)
    re_times = 5
    begin
      if ip_addr.nil? || ip_addr=="127.0.0.1"
        #use either ip or lantitude/longitude
        #ip_location = GeoIp.geolocation('173.243.0.64')
        #~ ip_location = {:latitude=>'37.9100783',:longitude=>'-122.0651819'}
        #~ ip_location = {'latitude'=>'37.9100783','longitude'=>'-122.0651819', 'city' => 'WALNUT CREEK'}
        ip_location = {:latitude=>'37.9100783',:longitude=>'-122.0651819', :city => 'WALNUT CREEK'}
      else
        ip_location = GeoIp.geolocation(ip_addr)
      end
    rescue Exception => e
      re_times-=1
      if re_times>0
        retry
      else
	      ip_location = {:latitude=>'37.9100783',:longitude=>'-122.0651819', :city => 'WALNUT CREEK'}
        #~ ip_location = {'latitude'=>'37.9100783','longitude'=>'-122.0651819', 'city' => 'WALNUT CREEK'}
      end
    end
  end
  
  def self.discount_total_amount(u_id)
    credit_list = UserCredit.where("user_id=?",u_id)
    debit_list = UserDebit.where("user_id=?",u_id)
    t_cred_amount =  (!credit_list.nil?) ? credit_list.sum(&:credit_amount) : 0
    t_debit_amount = (!debit_list.nil?) ? debit_list.sum(&:debited_amount) : 0
    return t_cred_amount,t_debit_amount
  end

  searchable :auto_index => true do

    text :tags_txt do
      tags_txt.split(",") if !tags_txt.nil?
    end

    text :activity_name,:boost => 8.0
    text :city, :boost => 10.0 do
	    city.downcase if !city.nil? && city!=''
    end
    text :user_profile_name,:boost => 9.0 do
      user_pro = UserProfile.find_by_user_id(user_id)
      user_pro.business_name.gsub("\x10","") if !user_pro.business_name.nil? unless user_pro.nil?
    end
    #    text :users_user_name do
    #      use_name = User.find(user_id)
    #      use_name.user_name unless use_name.nil?
    #    end
    text :category do
      category.downcase if !category.nil? && category!=''
    end
    text :sub_category do
      sub_category.downcase if !sub_category.nil? && sub_category!=''
    end

    string :user_plan do
      use_name = User.find(user_id)
      use_name.user_plan unless use_name.nil?
    end

    string :c_class do
      "activity"
    end

    string :cleaned
    string :city_lower do
	    city.downcase if !city.nil? && city!=''
    end 
    string :category
    string :gender
    string :zip_code
    string :max_age_range
    string :min_age_range
    string :created_by
    string :price_type
    
    string :category_lower do
      category.downcase if !category.nil? && category!=''
    end
    string :sub_category_lower do
      sub_category.downcase if !sub_category.nil? && sub_category!=''
    end

    #string :sub_category
    string :active_status
    string :activity_name
    string :schedule_mode

    string :show_card do
      true
    end
    #    string :sort_activity_name do
    #      activity_name.downcase.gsub(/^(an?|the)\b/, '')
    #    end
    #------comment

    date(:start_date, multiple: true) do
      se_start = []
      if schedule_mode !="By Appointment" && schedule_mode !="Any Time"
        raj_start = activity_schedule
        srt = nil
        if !raj_start.nil?
          se_start = raj_start.map{|p|
            if !p.start_date.nil?
              if "#{p.expiration_date}" == "2100-12-31"
                end_d = p.start_date + 5.years
                (p.start_date..end_d).to_a
              else
                if !p.end_date.nil?
                  (p.start_date..p.end_date).to_a
                elsif !p.expiration_date.nil?
                  (p.start_date..p.expiration_date).to_a
                else
                  (p.start_date..p.start_date).to_a
                end
              end
            end
          }.compact.flatten
        end
      end
      se_start
    end

    date(:expiration_date, multiple: true) do
      se_end = []
      if schedule_mode !="By Appointment" && schedule_mode !="Any Time"
        raj_end = activity_schedule
        srt_se_end = nil
        if !raj_end.nil?
          se_end = raj_end.map{|p|
            if !p.start_date.nil?
              if "#{p.expiration_date}" == "2100-12-31"
                end_d = p.start_date + 5.years
                (p.start_date..end_d).to_a
              else
                if !p.end_date.nil?
                  (p.start_date..p.end_date).to_a
                elsif !p.expiration_date.nil?
                  (p.start_date..p.expiration_date).to_a
                else
                  (p.start_date..p.start_date).to_a
                end
              end
            end
          }.compact.flatten
        end
      end
      se_end
    end

    string(:repeat_on, multiple: true) do
      se_repeat = []
      raj_repeat = activity_schedule
      raj_hr = activity_schedule.map(&:business_hours)
      se_repeat << raj_hr
      if !raj_repeat.nil?
        raj_repeat.each do |s|
          if !s.nil?
            st = activity_schedule(s.schedule_id).first.activity_repeat.last
            se_repeat << st.repeat_on.downcase.split(",").compact.flatten if !st.nil?
          end
        end
      end
      se_repeat.compact.flatten
    end

    string :created_date do
      inserted_date
    end

    string :recent_date do
      if !modified_date.nil?
        inserted_date
      else
        modified_date
      end
    end
    integer :category_id do
      act_cat = ActivityCategory.where("lower(category_name)='#{category.downcase}'").last
      act_cat.category_id  unless act_cat.nil?
    end
    integer :sub_category_id do
      act_cat = ActivityCategory.where("lower(category_name)='#{category.downcase}'").last
      unless act_cat.nil?
        #where("locations.permissions LIKE '%?%'",email)
	s_categ = sub_category.gsub("'","''")
        act_sub = ActivitySubcategory.where("category_id = ? and lower(subcateg_name)= ?", act_cat.category_id ,s_categ.downcase).last
        #act_sub = ActivitySubcategory.where("category_id=#{act_cat.category_id} and lower(subcateg_name)='#{sub_category.downcase}'").last
          act_sub.subcateg_id unless act_sub.nil?
        end
      end
    
      integer :user_id
      integer :activity_id
      double :latitude
      double :longitude
      latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }
    end


    def create_duplicate(rep_id)
      if self && rep_id.present?
        new_act = self.dup
        #~ image_path = self.avatar.path if self.avatar
        #~ new_act.avatar = self.avatar if (self.avatar && File.exists?(image_path))
        #img= self.avatar.path
        #if !img.nil? &&  File.exist?(img)
        # new_act.avatar = self.avatar if !self.avatar.nil? && self.avatar.present? && self.avatar!=""
        #end
        new_act.avatar = self.avatar if self.avatar
        new_act.user_id = rep_id
        new_act.active_status = 'Inactive'
        new_act.inserted_date = Time.now
        new_act.modified_date = Time.now
        new_act.save
        i = 1
        j = self.activity_schedule.count
        if self.schedule_mode.downcase=='any time'
          i=j
        end
     
        pdt=ProviderDiscountCode.where("activity_id=?",self.activity_id)
        pdt.each do |p|
          pro_dis_type=ProviderDiscountCode.new
          pro_dis_type.activity_id=new_act.activity_id
          pro_dis_type.user_id=p.user_id
          pro_dis_type.discount_code_id=p.discount_code_id
          pro_dis_type.inserted_date=Time.now
          pro_dis_type.discount_code_flag=false
          pro_dis_type.save
        end if !pdt.nil?
        paf=ProviderActivityFee.where("activity_id=?",self.activity_id)
        paf.each do |p|
          pro_act_fee=ProviderActivityFee.new
          pro_act_fee.activity_id=new_act.activity_id
          pro_act_fee.user_id=p.user_id
          pro_act_fee.fee_type_id=p.fee_type_id
          pro_act_fee.inserted_date=Time.now
          pro_act_fee.save
        end if !paf.nil?
        self.activity_schedule.each do |old_schedule|
          new_schedule = old_schedule.dup
          new_schedule.activity_id = new_act.activity_id
          new_schedule.save
		
          all_prices = (self && self.schedule_mode.present? && self.schedule_mode.downcase=='any time') ? self.activity_price : old_schedule.activity_prices

          if(i<=j)
            all_prices.each do |old_price|
              new_price = old_price.dup
              new_price.activity_schedule_id = new_schedule.schedule_id  if old_schedule.schedule_mode.downcase!='any time'
              new_price.activity_id = new_act.activity_id
              new_price.save
					
              old_price.activity_discount_price.each do |old_discount_price|
                new_discount_p = old_discount_price.dup
                new_discount_p.activity_price_id = new_price.activity_price_id
                new_discount_p.save
              end
            end
          end
          i=i+1
          if (old_schedule.schedule_mode.downcase=='schedule' && old_schedule.activity_repeat.count > 0)
            old_schedule.activity_repeat.each do |old_repeat|
              new_repeat = old_repeat.dup
              new_repeat.activity_schedule_id = new_schedule.schedule_id
              new_repeat.save
            end
          end
        end
        new_act
      end
    end

    #this week end activities
    def self.weekend_activities(arr,parent_keyword)
      today = Date.today
      date2 = today.at_end_of_week
      date1 = date2 - 1
      if !parent_keyword.nil? && parent_keyword!='' && @parent_keyword!="search 20,000   local activities and counting"
        @activity = Activity.find_by_sql("select a.activity_id,a.schedule_mode from activities a left join activity_schedules s on a.activity_id = s.activity_id where lower(a.created_by)='provider' and lower(a.active_status)='active' and cleaned=true and (date(s.start_date) <= '#{date1}' and date(s.expiration_date) >= '#{date1}' or s.start_date is null) and (lower(a.activity_name) like '%#{parent_keyword}%' or lower(a.category) like '%#{parent_keyword}%' or lower(a.sub_category) like '%#{parent_keyword}%' or lower(a.description) like '%#{parent_keyword}%' or lower(a.city) like '%#{parent_keyword}%') limit 100")
      else
        #@activity = Activity.find_by_sql("select a.activity_id,a.schedule_mode,s.start_date,s.expiration_date from activities a left join activity_schedules s on a.activity_id = s.activity_id where lower(a.created_by)='provider' and lower(a.active_status)='active' and cleaned=true and ((date(s.start_date) <= '#{date1}' and date(s.expiration_date) >= '#{date1}') or s.start_date is null)")
        @activity = Activity.find_by_sql("select a.activity_id,a.schedule_mode from activities a left join activity_schedules s on a.activity_id = s.activity_id where lower(a.created_by)='provider' and lower(a.active_status)='active' and cleaned=true and (date(s.start_date) <= '#{date1}' and date(s.expiration_date) >= '#{date1}' or s.start_date is null) limit 100")
      end
      if !@activity.nil? && @activity.present? && @activity.length > 0
        @activity.each do |aval|
          @schedule  = ActivitySchedule.find_by_sql("select * from activity_schedules where activity_id=#{aval.activity_id}")
          if !@schedule.nil? && @schedule.present? && @schedule.length > 0
            @schedule.each do |sval|
              @repeat = ActivityRepeat.where("activity_schedule_id=?",sval["schedule_id"]).last
              if !@repeat.nil? && @repeat!='' && @repeat.present?
                #start daily
                if @repeat.repeats=="Daily"
                  if @repeat.ends_never == true
                    r = Recurrence.new(:every => :day, :starts =>sval["start_date"], :interval => @repeat.repeat_every.to_i)
                  elsif !@repeat.ends_on.nil?
                    r = Recurrence.new(:every => :day, :starts =>sval["start_date"], :until =>@repeat.ends_on, :interval => @repeat.repeat_every.to_i)
                  elsif !@repeat.end_occurences.nil?
                    e_date = sval["start_date"] + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
                    r = Recurrence.new(:every => :day, :starts =>sval["start_date"], :until =>e_date, :interval => @repeat.repeat_every.to_i)
                  end
                  if !r.nil? && !r.events.nil? && r.events.length > 0
                    if r.include?(date1 || date2)
                      arr << aval.activity_id
                    end
                  end
                end
                if @repeat.repeats=="Weekly" || @repeat.repeats =="Every week (Monday to Friday)" || @repeat.repeats =="Every Monday,Wednesday and Friday" ||  @repeat.repeats =="Every Tuesday and Thursday"
                  @wek =[]
                  @ss =[]
                  repeat_o =  @repeat.repeat_on
                  if !repeat_o.nil? && repeat_o!='' && repeat_o.present?
                    rep = repeat_o.split(",")
                    rep.each do|s|
                      if s.downcase=="mon"
                        @wek.push(1)
                        @ss.push(:monday)
                      elsif s.downcase =="tue"
                        @wek.push(2)
                        @ss.push(:tuesday)
                      elsif s.downcase =="wed"
                        @wek.push(3)
                        @ss.push(:wednesday)
                      elsif s.downcase =="thu"
                        @wek.push(4)
                        @ss.push(:thursday)
                      elsif s.downcase =="fri"
                        @wek.push(5)
                        @ss.push(:friday)
                      elsif s.downcase =="sat"
                        @wek.push(6)
                        @ss.push(:saturday)
                      elsif s.downcase =="sun"
                        @wek.push(0)
                        @ss.push(:sunday)
                      end if s!=""
                    end
                  end
                  if @repeat.ends_never == true
                    r = Recurrence.new(:every => :week, :on =>@ss, :starts =>sval["start_date"], :interval =>@repeat.repeat_every.to_i)
                    if !r.nil? && !r.events.nil? && r.events.length > 0
                      if r.include?(date1 || date2)
                        if @repeat.repeat_on!=''
                          r_day=@repeat.repeat_on.split(',')
                          r_day.map!(&:downcase)
                          if !r_day.nil? && r_day.include?('sat' || 'sun')
                            arr << aval.activity_id
                          end
                        end
                      end
                    end
									
                  elsif !@repeat.ends_on.nil?
                    r = Recurrence.new(:every => :week, :on =>@ss, :starts =>sval["start_date"], :until=>@repeat.ends_on, :interval =>@repeat.repeat_every.to_i)
                    if !r.nil? && !r.events.nil? && r.events.length > 0
                      if r.include?(date1 || date2)
                        arr << aval.activity_id
                      end
                    end
                  elsif !@repeat.end_occurences.nil?
                    end_date = sval["start_date"] + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i * 7).days
                    r = Recurrence.new(:every => :week, :on =>@ss, :starts =>sval["start_date"],  :until=>end_date, :interval =>@repeat.repeat_every.to_i)
                    if !r.nil? && !r.events.nil? && r.events.length > 0
                      if r.include?(date1 || date2)
                        arr << aval.activity_id
                      end
                    end
                  end
								
                end
                if @repeat.repeats=="Monthly"
                  repeat_monthly_weekend(@repeat,sval,aval,arr,date1,date2)
                end
                if @repeat.repeats=="Yearly"
                  if !date1.nil?
                    if @repeat.ends_never == true
                      r = Recurrence.new(:every => :year, :starts =>sval["start_date"], :on => [sval["start_date"].strftime("%m").to_i, sval["start_date"].strftime("%d").to_i], :interval => @repeat.repeat_every.to_i)
                    elsif !@repeat.ends_on.nil?
                      r = Recurrence.new(:every => :year, :on => [sval["start_date"].strftime("%m").to_i, sval["start_date"].strftime("%d").to_i],:starts =>sval["start_date"], :until => @repeat.ends_on, :interval => @repeat.repeat_every.to_i)
                    elsif !@repeat.end_occurences.nil?
                      e_date = sval["start_date"] + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).years
                      r = Recurrence.new(:every => :year, :on => [sval["start_date"].strftime("%m").to_i, sval["start_date"].strftime("%d").to_i],:starts =>sval["start_date"], :until => e_date, :interval => @repeat.repeat_every.to_i)
                    end
                    if !r.nil? && !r.events.nil? && r.events.length > 0
                      if r.include?(date1)
                        arr << aval.activity_id
                      end
                    end
                  end
                  if !date2.nil?
                    if @repeat.ends_never == true
                      r = Recurrence.new(:every => :year, :starts =>sval["start_date"], :on => [sval["start_date"].strftime("%m").to_i, sval["start_date"].strftime("%d").to_i], :interval => @repeat.repeat_every.to_i)
                    elsif !@repeat.ends_on.nil?
                      r = Recurrence.new(:every => :year, :on => [sval["start_date"].strftime("%m").to_i, sval["start_date"].strftime("%d").to_i],:starts =>sval["start_date"], :until => @repeat.ends_on, :interval => @repeat.repeat_every.to_i)
                    elsif !@repeat.end_occurences.nil?
                      e_date = sval["start_date"] + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).years
                      r = Recurrence.new(:every => :year, :on => [sval["start_date"].strftime("%m").to_i, sval["start_date"].strftime("%d").to_i],:starts =>sval["start_date"], :until => e_date, :interval => @repeat.repeat_every.to_i)
                    end
                    if !r.nil? && !r.events.nil? && r.events.length > 0
                      if r.include?(date2)
                        arr << aval.activity_id
                      end
                    end
                  end
							
                end
              else
                #without repeat start camps/workshop
                #if start and end date is exist
                if !sval["start_date"].nil? && !sval["end_date"].nil?
                  r = Recurrence.new(:every => :day, :starts =>sval["start_date"], :until=>sval["end_date"])
                  if !r.nil? && !r.events.nil? && r.events.length > 0
                    arr << aval.activity_id
                  end
                else
                  if !sval["start_date"].nil? && sval["end_date"].nil?
                    r = Recurrence.new(:every => :day,  :starts =>sval["start_date"], :until=>sval["start_date"])
                    if !r.nil? && !r.events.nil? && r.events.length > 0
                      arr << aval.activity_id
                    end
                  else
                    if !aval.nil? && !aval.schedule_mode.nil? && aval.schedule_mode!=''
                      if aval.schedule_mode.downcase == 'any time'
                        @sch_any = ActivitySchedule.where("activity_id =#{aval.activity_id} and (lower(business_hours)='sat' or lower(business_hours)='sun')")
                        if !@sch_any.nil? && @sch_any.present? && @sch_any.length > 0
                          arr << aval.activity_id
                        end
                      else
                        arr << aval.activity_id
                      end
                    end
									
                  end
                end #inner without repeat end
              end # repeat check loop end
            end
          end
        end
      end
    end
	
    def self.repeat_monthly_weekend(repeat,sval,aval,arr,date1,date2)
      @repeat = repeat
      @schedule = sval
      s_date =  @schedule.start_date
      s = week_of_month_for_date(s_date)
      if s == 1
        se = :first
      elsif s==2
        se = :second
      elsif s==3
        se = :third
      elsif s>=4
        se = :last
      end
      if @repeat.ends_never == true
        if @repeat.repeated_by_month == true
          s_date = s_date.strftime("%d")
          r = Recurrence.new(:every => :month, :starts =>@schedule.start_date, :on =>s_date.to_i, :interval => @repeat.repeat_every.to_i)
          if !r.nil? && !r.events.nil? && r.events.length > 0
            if r.include?(date1 || date2)
              arr << aval.activity_id
            end
          end
        else
          s_day = s_date.strftime("%a")
          r = Recurrence.new(:every => :month, :on =>"#{se}",  :starts =>@schedule.start_date, :weekday =>"#{s_day.downcase}", :interval => @repeat.repeat_every.to_i)
          if !r.nil? && !r.events.nil? && r.events.length > 0
            if r.include?(date1 || date2)
              arr << aval.activity_id
            end
          end
        end
        # # #if Daily and ends on exists
      elsif !@repeat.ends_on.nil?
        s_date =  @schedule.start_date
        end_date = @repeat.ends_on
        if @repeat.repeated_by_month == true
          s_date1 = s_date.strftime("%d")
          r = Recurrence.new(:every => :month, :on =>s_date1.to_i,:starts =>@schedule.start_date, :until => @repeat.ends_on, :interval => @repeat.repeat_every.to_i)
          if !r.nil? && !r.events.nil? && r.events.length > 0
            if r.include?(date1 || date2)
              arr << aval.activity_id
            end
          end
        else
          s_day = s_date.strftime("%a")
          r = Recurrence.new(:every => :month, :on =>"#{se}",  :weekday =>"#{s_day.downcase}", :starts =>@schedule.start_date, :until => @repeat.ends_on, :interval => @repeat.repeat_every.to_i)
          if !r.nil? && !r.events.nil? && r.events.length > 0
            if r.include?(date1 || date2)
              arr << aval.activity_id
            end
          end
        end
        # #if monthly and end occurences exists
      elsif !@repeat.end_occurences.nil?
        e_date = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).months
        s_date =  @schedule.start_date
        if @repeat.repeated_by_month == true
          s_date1 = s_date.strftime("%d")
          r = Recurrence.new(:every => :month, :on =>s_date1.to_i,:starts =>@schedule.start_date, :until => e_date, :interval => @repeat.repeat_every.to_i)
          if !r.nil? && !r.events.nil? && r.events.length > 0
            if r.include?(date1 || date2)
              arr << aval.activity_id
            end
          end
        else
          s_day = s_date.strftime("%a")
          r = Recurrence.new(:every => :month, :on =>"#{se}",  :weekday =>"#{s_day.downcase}", :starts =>@schedule.start_date, :until => e_date, :interval => @repeat.repeat_every.to_i)
          if !r.nil? && !r.events.nil? && r.events.length > 0
            if r.include?(date1 || date2)
              arr << aval.activity_id
            end
          end
        end
      end
    end

    #basic search for activity groups.
    def self.search_activitygroup(search,user_id,represent)
      activity_list = Activity.where(:user_id => user_id, :created_by => "Provider", :cleaned => true, :active_status => "Active")
      act_ids = !activity_list.blank? ? activity_list.map(&:id) : []
      activities = ActivityAttendDetail.where("activity_id IN (?)",act_ids).uniq.map(&:activity_id)
      if search !="" && search != nil
        find(:all, :conditions => ["lower(activity_name) LIKE ? AND activity_id IN (?)", "%#{search.downcase}%",activities], :order => "activity_name ASC")
      end
    end

    #To add activity total count for feature row
    def add_activity_total_count
      if (self && !self.nil? && self.present?)
        act_count = ActivityTotalCount.new
        act_count.activity_id = self.activity_id
        act_count.activity_display_count = 0
        act_count.save
      end
    end

    #get the activities list based on the params
    def self.get_activity_vals(city,categ,subcateg,uid)
      if city && city!='' && categ && categ!='' && subcateg && subcateg!='' && uid && uid!=''
        @footcity = Activity.find_by_sql("select * from activities act left join activity_schedules sch on act.activity_id=sch.activity_id where act.user_id = #{uid} and act.cleaned=true and lower(act.active_status)='active' and lower(act.city)='#{city}' and lower(category)='#{categ}' and lower(sub_category)='#{subcateg}' and sch.expiration_date >= '#{Date.today.strftime("%Y-%m-%d")}'").uniq
      elsif city && city!='' && categ && categ!='' && subcateg && subcateg!=''
        #~ @footcity = Activity.where("lower(city)='#{city}' and cleaned=? and lower(active_status)=? and lower(category)='#{categ}' and lower(sub_category)='#{subcateg}'",true,'active').map(&:user_id).uniq
        @footcity= Activity.find_by_sql("select * from activities act left join activity_schedules sch on act.activity_id=sch.activity_id where lower(act.city)='#{city}' and lower(act.category)='#{categ}' and lower(act.sub_category)='#{subcateg}' and act.cleaned=true and lower(act.active_status)='active' and sch.expiration_date >= '#{Date.today.strftime("%Y-%m-%d")}'").map(&:user_id).uniq
      elsif city && city!='' && categ && categ!='' && uid && uid!=''
        #~ @footcity = Activity.where("user_id=? and lower(city)='#{city}' and cleaned=? and lower(category)='#{categ}' and lower(active_status)=?",uid,true,'active').map(&:sub_category).uniq.sort
        @footcity= Activity.find_by_sql("select * from activities act left join activity_schedules sch on act.activity_id=sch.activity_id where act.user_id=#{uid} and lower(act.city)='#{city}' and lower(act.category)='#{categ}' and act.cleaned=true and lower(act.active_status)='active' and sch.expiration_date >= '#{Date.today.strftime("%Y-%m-%d")}'").map(&:sub_category).uniq.sort
      elsif city && city!='' && categ && categ!=''
        #~ @footcity = Activity.where("lower(city)='#{city}' and cleaned=? and lower(active_status)=? and lower(category)='#{categ}'",true,'active').map(&:sub_category).uniq.sort
        @footcity= Activity.find_by_sql("select * from activities act left join activity_schedules sch on act.activity_id=sch.activity_id where lower(act.city)='#{city}' and lower(act.category)='#{categ}' and act.cleaned=true and lower(act.active_status)='active' and sch.expiration_date >= '#{Date.today.strftime("%Y-%m-%d")}'").map(&:sub_category).uniq.sort
      elsif city && city!='' && uid && uid!=''
        @footcity= Activity.find_by_sql("select * from activities act left join activity_schedules sch on act.activity_id=sch.activity_id where lower(act.city)='#{city}' and act.user_id = #{uid} and act.cleaned=true and lower(act.active_status)='active' and sch.expiration_date >= '#{Date.today.strftime("%Y-%m-%d")}'").uniq
      elsif city && city!=''
        #~ @footcity = Activity.where("lower(city)='#{city}' and cleaned=? and lower(active_status)=?",true,'active').map(&:category).uniq.sort
        @footcity= Activity.find_by_sql("select * from activities act left join activity_schedules sch on act.activity_id=sch.activity_id where lower(act.city)='#{city}' and act.cleaned=true and lower(act.active_status)='active' and sch.expiration_date >= '#{Date.today.strftime("%Y-%m-%d")}'").map(&:category).uniq.sort
      elsif categ && categ!='' && subcateg && subcateg!='' && uid && uid!=''
        @footcity= Activity.find_by_sql("select * from activities act left join activity_schedules sch on act.activity_id=sch.activity_id where lower(act.category)='#{categ}' and lower(act.sub_category)='#{subcateg}' and act.user_id = #{uid} and act.cleaned=true and lower(act.active_status)='active' and sch.expiration_date >= '#{Date.today.strftime("%Y-%m-%d")}'").uniq
      elsif uid && uid!=''
        @footcity= Activity.find_by_sql("select * from activities act left join activity_schedules sch on act.activity_id=sch.activity_id where act.user_id = #{uid} and act.cleaned=true and lower(act.active_status)='active' and sch.expiration_date >= '#{Date.today.strftime("%Y-%m-%d")}'").uniq if !uid.nil? && uid!=''
      end
      return @footcity
    end

    #get the activity details
    def self.get_activity_det(actname,uid)
      @activity = Activity.where("user_id=? and cleaned=? and lower(active_status)=? and slug='#{actname}'",uid,true,'active').uniq.last if uid && uid!='' && actname.present?
    end

    #get the values for quick links
    def self.getquicklink_values(cities,stype,uid)
      dicountdollar = ''
      if stype && stype!='' && stype.present? && stype == "hot-deals" && cities.present? #quick link hot-deals activities
        #combine discount dollar and specials
        act_results =  Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id left join activity_prices p on act.activity_id=p.activity_id left join activity_discount_prices d
				on d.activity_price_id=p.activity_price_id where #{cities} and act_sch.expiration_date >= '#{Date.today}' and cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and (((act.price_type='1') or (act.price_type='2')) and 
				(((date(d.discount_valid) >= '#{Date.today}') or (d.discount_valid is null and d.discount_price is not null)) or (act.discount_eligible IS NOT NULL))) order by act.activity_id desc")
      elsif stype && stype!='' && stype.present? && stype == "favorite" && cities.present? && uid && uid.present? #quick link favorite activities
        act_results = Activity.find_by_sql("select * from activities act right join activity_favorites actfav on actfav.activity_id = act.activity_id where actfav.user_id=#{uid} and act.cleaned=true and lower(act.active_status)='active' order by actfav.inserted_date desc")
      elsif stype && stype!='' && stype.present? && stype == "discount-dollar" && cities.present?
        dicountdollar = "and (act.price_type ='1' or act.price_type ='2') and act_sch.expiration_date >= '#{Date.today}' and (act.discount_eligible IS NOT NULL)"
      elsif stype && stype!='' && stype.present? && stype == "camp" && cities.present?
        @camps = "Whole Day"
        dicountdollar = "and act_sch.expiration_date >= '#{Date.today}' and (lower(act.schedule_mode)='#{@camps.downcase.strip}' or ((act.sub_category)='Camps')or ((act.camps)=true))"
      elsif stype && stype!='' && stype.present? && stype == "special" && cities.present?
        act_results =  Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id left join activity_prices p on act.activity_id=p.activity_id left join activity_discount_prices d
				on d.activity_price_id=p.activity_price_id where #{cities} and act_sch.expiration_date >= '#{Date.today}' and cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and (((act.price_type='1') or (act.price_type='2')) and 
				((date(d.discount_valid) >= '#{Date.today}') or (d.discount_valid is null and d.discount_price is not null))) order by act.activity_id desc")
      elsif stype && stype!='' && stype.present? && stype == "free" && cities.present?
        dicountdollar = "and act_sch.expiration_date >= '#{Date.today}' and act.price_type='3'"
      elsif stype && stype!='' && stype.present? && stype == "special-needs" && cities.present?
        dicountdollar = "and act_sch.expiration_date >= '#{Date.today}' and ((lower(act.sub_category)='special needs')or((act.special_needs)=true))"
      end
      act_results = Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where #{cities} and cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' #{dicountdollar} order by act.activity_id desc") if dicountdollar && dicountdollar!=nil && dicountdollar!=''
      return act_results
    end #get quick link ending here

    #get accordion categories
    def self.getcategories(type,city)
      if type == 1
        act = Activity.order("category Asc").find(:all,:select => "DISTINCT trim(category) as category",:conditions=>["lower(active_status) = ? and cleaned = ? and lower(category)!=? and category !=? and lower(city)=?",'active',true,'default','',city.downcase])
      elsif type == 2
        act = Activity.order("category Asc").find(:all,:select => "DISTINCT trim(category) as category",:conditions=>["lower(category)!=? and category !=? and lower(city)=?",'default','',city.downcase])
      else
        act = Activity.order("category Asc").find(:all,:select => "DISTINCT trim(category) as category",:conditions=>["lower(category)!=? and category !=?",'default',''])
      end
      return act
    end

    #get all the subcategories values
    def self.get_actsubcatval(categ,subcateg,city)
      @actsub_tmp = []
      if categ && categ!='' && subcateg && subcateg!='' && city && city!=''
        #@actsub1 = Activity.where("lower(category)='#{categ}' and lower(sub_category)='#{subcateg}'").map(&:user_id).uniq
        #@actuser2 = User.find_by_sql("select u.user_id from users u left join user_profiles p on u.user_id=p.user_id where lower(p.category)='#{categ}' and lower(p.sub_category)='#{subcateg}' and u.account_active_status=true").map(&:user_id).uniq
        @actsub1 = Activity.select("activities.user_id").joins("left join users on activities.user_id=users.user_id").where("lower(category)='#{categ}' and lower(sub_category)='#{subcateg}' and lower(city)='#{city.downcase}' and users.show_card=true and users.account_active_status=true").map(&:user_id).uniq
        @actuser2 = User.find_by_sql("select u.user_id from users u left join user_profiles p on u.user_id=p.user_id where lower(p.category)='#{categ}' and lower(p.sub_category)='#{subcateg}' and lower(city)='#{city.downcase}' and u.account_active_status=true and u.show_card=true").map(&:user_id).uniq
      elsif categ && categ!='' && city && city!=''
        @actsub1= Activity.find_by_sql("select * from activities act left join activity_schedules sch on act.activity_id=sch.activity_id where lower(act.category)='#{categ}' and lower(city)='#{city.downcase}'").map(&:sub_category).uniq.sort
        @actuser2 = UserProfile.joins(:user).where("users.account_active_status=? and lower(user_profiles.category)='#{categ}' and lower(city)=? ", true, city.downcase).map(&:sub_category).uniq
      end
      @actsub = (@actsub1+@actuser2).flatten.uniq
      return @actsub
    end

  end