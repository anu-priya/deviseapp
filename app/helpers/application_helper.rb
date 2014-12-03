module ApplicationHelper

	def link_to_remote(name, options = {}, html_options = nil)
	end
  
  def default_meta_tags
    {
      :title       => 'Famtivity',
      :description => 'Family Activity Network',
      :keywords    => 'Activity, Famil, Network',
      :separator   => "&mdash;".html_safe,
    }
  end


  def title(page_title)
    content_for(:title) { page_title }
  end

  def get_activity_name(slug_name)
		act_name = ''
    act_desc = ''
    act = Activity.fetch_by_slug(slug_name) if !slug_name.nil? && slug_name.present? #identity cache
    if !act.nil? && act.present?
      act_name = act.activity_name
      act_desc = ActionView::Base.full_sanitizer.sanitize(act.description).gsub(/\s+/, " ").strip if act.description.present?
    end
    return act_name,act_desc
  end
  #get business name from slug
  def get_business_name(slug_name)
    bus_name = ''
    user = UserProfile.fetch_by_slug(slug_name) if !slug_name.nil? && slug_name.present? #identity cache
    if !user.nil? && user.present?
      bus_name = user.business_name.titleize
    end
    return bus_name
  end
  #page title for follow_cities(SEO)
  def find_page_title(params)
    @user_profile = UserProfile.where("lower(business_name)=?",params[:busi_name].gsub('-',' ').downcase).last if params[:busi_name]
    @user_profile_title = UserProfile.getuserdetails('',params[:categ]) if params[:categ]
    if @user_profile_title #if cate as businessname
      @user = User.getdetails(@user_profile_title.user_id) if !@user_profile_title.nil?
      #@activity =  (@user_profile_title && !@user_profile_title.nil? && !@user_profile_title.user_id.nil?) ? Activity.get_activity_det(params[:activity_name],@user_profile_title.user_id) : []
      @actcatname = ActivityCategory.getcategname(params[:categ])
      @actsubcatname = ActivitySubcategory.getsubcategname(params[:sub_categ])
    else
      @user_profile = UserProfile.getuserdetails('',params[:busi_name]) if params[:busi_name]
      @user = User.getdetails(@user_profile.user_id) if !@user_profile.nil?
      #@activity =  (@user_profile && !@user_profile.nil? && !@user_profile.user_id.nil?) ? Activity.get_activity_det(params[:activity_name],@user_profile.user_id) : []
    end
    #get activity name
    if params[:activity_name] && params[:activity_name]!=''
      @actname_meta = ''
      @actdesc_meta = ''
      @act_meta=get_activity_name(params[:activity_name])
      @actname_meta = @act_meta[0].titleize if !@act_meta.nil? && @act_meta.present?
      @actdesc_meta = @act_meta[1] if !@act_meta.nil? && @act_meta.present?
    end
	
    if params[:city] && params[:categ] && params[:sub_categ] && params[:busi_name] && params[:activity_name]
      if params[:categ] && params[:categ]!=''
        bus_name = get_business_name(params[:categ])
      else
        bus_name=''
      end
      @page_title = "#{params[:city].titleize} #{bus_name} #{@actname_meta.titleize}"
      @page_key =  "#{params[:city].titleize} #{@actname_meta.titleize}, #{bus_name} #{@actname_meta.titleize}, #{params[:city].titleize} #{bus_name} #{@actname_meta.titleize}"
      #@page_desc = "#{@activity.description if @activity && !@activity.nil? && @activity.present? && !@activity.description.nil? && @activity.description.present? }"
      #@page_desc =  "#{params[:city].titleize} #{@actname_meta.titleize}, #{params[:categ].titleize} #{@actname_meta.titleize}, #{params[:city].titleize} #{params[:categ].titleize} #{@actname_meta.titleize}"
      @page_desc =  "#{bus_name} - #{@actname_meta} - Find Kids Classes, Lessons, Camps, Sports, Activities & Events on Famtivity"
    elsif params[:city] && params[:categ] && params[:sub_categ] && params[:busi_name]
      @page_title = "#{params[:busi_name].titleize} - #{params[:city].titleize}, CA"
      @page_key = "#{params[:busi_name].titleize} #{params[:city].titleize}, #{params[:busi_name].titleize} #{params[:city].titleize} discounts, #{params[:busi_name].titleize} #{params[:city].titleize} camps"
      @page_desc = "#{params[:busi_name].titleize} #{params[:city].titleize} kids classes, lessons, day & summer camps, activities, & events for children of all ages including local provider discounts & specials"

    elsif params[:city] && params[:categ] && params[:sub_categ]
      @page_title = "#{params[:city].titleize} #{params[:categ].titleize} #{params[:sub_categ].titleize} kids classes, camps, lessons, activities & events"
      @page_key = "#{params[:city].titleize} #{params[:categ].titleize} #{params[:sub_categ].titleize} kids classes, #{params[:city].titleize} #{params[:categ].titleize} #{params[:sub_categ].titleize} kids lessons, #{params[:city].titleize} #{params[:categ].titleize} #{params[:sub_categ].titleize} camps"
      @page_desc = "#{params[:city].titleize} #{params[:categ].titleize} #{params[:sub_categ].titleize} kids classes, lessons, day & summer camps, activities, & events for children of all ages including local provider discounts & specials"
      # title,keyword and description for city,catgory
    elsif params[:city] && params[:categ]  
	    if params[:categ] && params[:categ]!=''
        bus_name = get_business_name(params[:categ])
      else
        bus_name=''
      end
      @page_title = "#{bus_name} - #{params[:city].titleize}, CA"
      @page_key = "#{bus_name} #{params[:city].titleize}, #{bus_name} #{params[:city].titleize} discounts, #{bus_name} #{params[:city].titleize} camps"
      @page_desc = "#{bus_name} - #{params[:city].titleize} kids classes, lessons, day & summer camps, activities, & events for children of all ages including local provider discounts & specials"
      #~ @page_title = "#{params[:city].titleize} #{params[:categ].titleize} kids classes, camps, lessons, activities & events"
      #~ @page_key = "#{params[:city].titleize} #{params[:categ].titleize} kids classes, #{params[:city].titleize} #{params[:categ].titleize} kids activities, #{params[:city].titleize} #{params[:categ].titleize} camps"
      #~ @page_desc = "#{params[:city].titleize} #{params[:categ].titleize} kids classes, lessons, day & summer camps, activities, & events for children of all ages including local provider discounts & specials"
      #~ # title,keyword and description for city
    elsif params[:city]
      @page_title = "#{params[:city].titleize} kids classes, camps, lessons, activities & events"
      @page_key = "#{params[:city].titleize} kids classes, #{params[:city].titleize} kids activities, #{params[:city].titleize} camps"
      @page_desc = "#{params[:city].titleize} kids activities classes, lessons, day and summer camps & events for children of all ages including local provider discounts & specials"
    elsif params[:city_v][0]
      @page_title = "Famtivity - Kids Classes, Camps, Lessons, Events & Activities"
      @page_key = "Kids Classes, Kids Camps, Kids Activities"
      @page_desc = "Kids activities, classes, day & summer camps, lessons, things to do & events for children of all ages including local provider discounts & specials"
    end
    
    return @page_title, @page_desc, @page_key
  end

  #page title for provider (SEO)
  def find_page_title_provider(params)
    if  params[:city] && params[:profile_id]
      @user_pro = UserProfile.find_by_profile_id(params[:profile_id]) if params[:profile_id]
      if !@user_pro.nil? && @user_pro.present? && @user_pro!=''
        pro_name = @user_pro.business_name
        pro_zipcode = @user_pro.zip_code
      else
        pro_name = nil
        pro_zipcode = nil
      end
      @page_title = "#{pro_name.titleize} - #{params[:city].titleize}, CA"
      @page_key = "#{pro_name.titleize} #{params[:city].titleize}, #{pro_name} #{params[:city].titleize} discounts, #{pro_name} #{params[:city].titleize} camps"
      @page_desc = "#{pro_name.titleize} #{params[:city].titleize} kids classes, lessons, day & summer camps, activities, & events for children of all ages including local provider discounts & specials"
    elsif  params[:city]
      @page_title = "#{params[:city].titleize} kids classes, camps, lessons, activities & events"
      @page_key = "#{params[:city].titleize} kids classes, #{params[:city].titleize} kids lessons, #{params[:city].titleize} camps"
      @page_desc = "#{params[:city].titleize} kids classes, lessons, day & summer camps, activities, & events for children of all ages including local provider discounts & specials"
    elsif params[:city] && params[:busi_name]
      @page_title = "#{params[:busi_name].titleize} - #{params[:city].titleize}, CA"
      @page_key = "#{params[:busi_name].titleize} #{params[:city].titleize}, #{params[:busi_name].titleize} #{params[:city].titleize} discounts, #{params[:busi_name].titleize} #{params[:city].titleize} camps"
      @page_desc = "#{params[:busi_name].titleize} #{params[:city].titleize} kids classes, lessons, day & summer camps, activities, & events for children of all ages including local provider discounts & specials"

    elsif params[:city_v][0]
      @page_title = "Famtivity - Kids Classes, Camps, Lessons, Events & Activities"
      @page_key = "Kids Classes, Kids Camps, Kids Activities"
      @page_desc = "Kids activities, classes, day & summer camps, lessons, things to do & events for children of all ages including local provider discounts & specials"
		        
    end
    return @page_title, @page_desc, @page_key
  end


  def get_bread_crumb(url)
    begin
      breadcrumb = ''
      so_far = '/'
      elements = url.split('/').reject(&:blank?)
      for i in 0...elements.size
        so_far += elements[i] + '/'
        if elements[i]!= "category"
          if elements[i] =~ /^\d+$/
            begin
              if i==1
                breadcrumb += link_to_if(i != elements.size - 1, eval("#{elements[i - 1].singularize.camelize}.find(#{elements[i]}).name").gsub("-ca","-CA").gsub("_"," ").to_s, so_far)
              else
                breadcrumb += link_to_if(i != elements.size - 1, eval("#{elements[i - 1].singularize.camelize}.find(#{elements[i]}).name").gsub("_"," ").to_s, so_far)
              end
            rescue
              breadcrumb += elements[i]
            end
          else
            if i == 1
              breadcrumb += link_to_if(i != elements.size - 1,elements[i].titlecase.gsub("-ca","-CA").gsub("_"," "), so_far)
            else
              breadcrumb += link_to_if(i != elements.size - 1,elements[i].gsub("-ca","-CA").gsub("_"," ").titleize, so_far)
            end
        
          end
          #breadcrumb += " &gt; " if i != elements.size - 1
          if i != elements.size - 2
            breadcrumb += " <span style='color:#4495ae;'>&gt;</span> " if i != elements.size - 1
          else
            breadcrumb += " <span style='color:#666;'>&gt;</span> " if i != elements.size - 1
          end
        end
      end
      #~ breadcrumb = breadcrumb.slice(0...(breadcrumb.index('?'))) if breadcrumb.include?('?')
      breadcrumb
    rescue
      'Not available'
    end
  end

  def get_mactivty(act_id)
    activity = Activity.fetch(act_id) if act_id
    user = User.fetch(activity.user_id) if activity && activity.present?
    activity_link_format(activity,user) if !activity.nil? && activity.present?
  end

  def activity_link_format(activity,user)
	
    if activity.class.to_s == 'Hash'
      schedule_mode = activity[:schedule_mode]
      city = activity[:city]
      category = activity[:category]
      categ = ActivityCategory.fetch_by_category_name(category).last if !category.nil?
      catslug = (categ && categ.slug) ? (categ.slug) : (category.gsub(/\s/,'-'))
      sub_category = activity[:sub_category]
      subcat = ActivitySubcategory.fetch_by_subcateg_name(sub_category).last if !sub_category.nil?
      subslug = (subcat && subcat.slug) ? (subcat.slug) : (sub_category.gsub(/\s/,'-'))
      slug = activity[:slug]
    else
      schedule_mode = activity.schedule_mode
      city = activity.city
      category = activity.category
      categ = ActivityCategory.fetch_by_category_name(category).last if !category.nil?
      catslug = (categ && categ.slug) ? (categ.slug) : (category.gsub(/\s/,'-'))
      sub_category = activity.sub_category
      subcat = ActivitySubcategory.fetch_by_subcateg_name(sub_category).last if !sub_category.nil?
      subslug = (subcat && subcat.slug) ? (subcat.slug) : (sub_category.gsub(/\s/,'-'))
      slug = activity.slug
    end
	
    get_city = (activity && schedule_mode && schedule_mode.downcase=='any where') ? 'anywhere' : ((activity && city.present?) ? ((check_for_state(city)) ? city.gsub(/\s/,'-').downcase+url_state_value : city.gsub(/\s/,'-').downcase) : '')

    acti_link = (activity && get_city && get_city.present? && !user.nil? && user.present? && user!="" && !user.fetch_user_profile.nil? && !user.fetch_user_profile.slug.nil? && category && sub_category && slug && subslug && catslug) ? (get_city+"/"+user.fetch_user_profile.slug+"/"+catslug.downcase+"/"+subslug.downcase+"/"+slug) : '#'
    return acti_link
  end

  def get_provider_path
    url_path = request.fullpath
    pages= ["/plan_report","/payment_setup","/bank_info","/get_credit_card_info","/provider","/provider_activites", "/provider","/provider_activity_discount","/activity_provider_schedule","/provider_profile","/provider_policies","/provider_plan","/change_password","/provider_settings","/transaction"]
    if pages.any? { |page_url| url_path.include?(page_url) }
      return true
    else
      return false
    end
  end 
  
  
  #~ def is_actv_file_exists(act)
  def is_file_exists(image_path)
    test_url = "#{request.protocol}#{request.host_with_port}"
    img_path = image_path if image_path && image_path.present?
    result = false
	if (test_url == 'https://www.famtivity.com')
		s3 = AWS::S3.new(:access_key_id => ENV['access_key_id'], :secret_access_key => ENV['secret_access_key'])
		result = s3.buckets[ENV['bucket']].objects[img_path].exists? if img_path && img_path.present?
	elsif (test_url == 'http://famtivity.com:3005')
		s3 = AWS::S3.new(:access_key_id => ENV['access_key_id'], :secret_access_key => ENV['secret_access_key'])
		result = s3.buckets[ENV['bucket']].objects[img_path].exists? if img_path && img_path.present?
	else
		result = File.exists?(img_path)  if img_path && img_path.present?
	end
    return result
  end
  
  def get_provider_and_parent_path
    url_path = request.fullpath
    pages= ["/plan_report","/payment_setup","/bank_info","/get_credit_card_info","/provider","/provider_activites", "/provider","/provider_activity_discount","/activity_provider_schedule","/provider_profile","/provider_policies","/provider_plan","/change_password","/provider_settings","/transaction","/terms-of-service","/terms-of-service","/terms-of-service","/privacy-policy","/about-us","/contact-us","/frequently-asked-questions","/activity_parent_schedule?mode=parent","/parent_profile?mode=parent","/parent_settings?mode=parent","/discount_dollars?mode=parent","/change_password?mode=parent","/contact_users","/messages","/reply_message_form","about-us","/search"]
    if pages.any? { |page_url| url_path.include?(page_url) }
      return true
    else
      return false
    end
  end 


  def url_state_value
    #~ @state = State.find_by_state_id(1)
    #~ if @state && @state!="" && @state.state_name == "California"
    state = "-ca" #get the states values
    #~ end
    return state
  end
  

  def check_for_state(city)
    chk_city = City.where("lower(city_name)=?",city.downcase).last if city && city.present?
    chk_state = (chk_city && chk_city.state_id && chk_city.state_id==1) ? true : false
  end

  def check_for_state_value(city)
    chk_city = City.where("lower(city_name)=?",city.downcase).last if city && city.present?
    chk_state = (chk_city && chk_city.state_id && chk_city.state.state_id==1) ? "-#{chk_city.state.state_code.downcase}" : ('')
  end

  def create_log_for_zipcode
    log_v ||= Logger.new("log/#{Time.now.strftime("%Y-%m-%d")}_geocoder_log.txt")
    log_v.info "Search using Maxmind == #{cookies[:search_maxmind_city]}"
    log_v.info "Search using Geocoder == #{cookies[:search_geocoder_city]}"
    log_v.info "Ip Address == #{request.ip}"
    log_v.info "#{Time.now.strftime("%a %d %H %M %p %Z %Y-%m-%d")}"
    log_v.close
  end

  def get_provider_and_parent_path
    url_path = request.fullpath
    pages= ["/payment_setup","/bank_info","/get_credit_card_info","/plan_report","/provider","/provider_activites", "/provider","/provider_activity_discount","/activity_provider_schedule","/provider_profile","/provider_policies","/provider_plan","/change_password","/provider_settings","/transaction","/terms-of-service","/terms-of-service","/terms-of-service","/privacy-policy","/about-us","/contact-us","/frequently-asked-questions","/activity_parent_schedule?mode=parent","/parent_profile?mode=parent","/parent_settings?mode=parent","/discount_dollars?mode=parent","/change_password?mode=parent","/contact_users","/messages","/reply_message_form","/search"]
    if pages.any? { |page_url| url_path.include?(page_url) }
      return true
    else
      return false
    end
  end 
end
