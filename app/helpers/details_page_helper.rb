module DetailsPageHelper

  #get widget list
 def getWidgetlist(type,id)
   arr=[]
   if type=="provider"
      #get widgets for provider based on provider's subcategory
      #widget = Activity.where("user_id=?",id).map(&:sub_category).uniq
      #~ provider_act = Activity.select("activity_id").where("user_id=#{id} and lower(active_status)='active'")
      
      #identity cache
      prov_user = User.fetch(id)
      provider_act = prov_user.fetch_activities.where("lower(active_status)=?",'active').map(&:activity_id)
      
      provider_widget = ActivitySubcategory.find_by_sql("select s.script_url,s.href_url from activity_subcategories s left join user_profiles a on lower(a.sub_category) = lower(s.subcateg_name) where a.user_id = #{id} and s.script_url is not null and s.href_url is not null")
      activity_widget = ActivitySubcategory.find_by_sql("select s.script_url,s.href_url from activity_subcategories s left join activities a on lower(a.sub_category) = lower(s.subcateg_name) where a.user_id = #{id} and lower(a.active_status) = 'active' and s.script_url is not null and s.href_url is not null")
      if !provider_widget.blank? && provider_act.blank?
        widget = provider_widget
      elsif !provider_widget.blank? && !provider_act.blank?
        widget = !activity_widget.blank? ? activity_widget : provider_widget
      elsif provider_widget.blank? && !provider_act.blank?
        widget = !activity_widget.blank? ? activity_widget : []
      else 
        widget =[]
      end
      if !widget.blank?
        #randomly select 3 widgets from above list
        random_list = widget.length >= 2 ? widget.sample(2) : widget
        random_list.each do |wid_list|
          #wid_list = ActivitySubcategory.find_by_subcateg_name(list)
          source_url = wid_list.script_url if !wid_list.nil?
          href_url = wid_list.href_url if !wid_list.nil?
          if(!source_url.nil? && !href_url.nil? && source_url.present? && href_url.present?)
            arr << {"source_url" => source_url,"href_url" => href_url}
          end
        end
      end
    return arr
   elsif type=="activity"
     #get widgets from activity based on activity subcategory
     widget = Activity.fnd_activity_slug(params[:activity_name]).last
      if !widget.blank?
       wid_list= ActivitySubcategory.fetch_by_subcateg_name(widget.sub_category).last
       source_url = wid_list.script_url if !wid_list.nil?
       href_url = wid_list.href_url if !wid_list.nil?
       if(!source_url.nil? && !href_url.nil? && source_url.present? && href_url.present?)
         arr << {"source_url" => source_url,"href_url" => href_url}
       end
      end
     return arr
   end      
 end

def get_activity_name(slug_name)
    act_name = ''
    act_desc = ''
    act = Activity.fetch_by_slug(slug_name) if !slug_name.nil? && slug_name.present?  #identity cache
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
      bus_name = user.business_name.titleize if user.business_name.present? && !user.business_name.nil?
    end
    return bus_name
  end
	#page title for follow_cities(SEO)
  def find_page_title_for_detail_page(params)
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
      #activity page
               if params[:categ] && params[:categ]!=''
                       bus_name = get_business_name(params[:categ])
               else
                       bus_name=''
               end        
       @page_title = "#{bus_name} - #{@actname_meta.titleize}"
       @page_key =  "#{bus_name} #{@actname_meta.titleize}"       
       @page_desc =  "#{bus_name} - #{@actname_meta} - #{@actdesc_meta.truncate(156)}"
    elsif params[:city] && params[:categ]  
	    if params[:categ] && params[:categ]!=''
        bus_name = get_business_name(params[:categ])
      else
        bus_name=''
      end
      city_name = params[:city].gsub("-ca","")
      @page_title = "#{bus_name} - #{city_name.titleize}, CA"
      @page_key = "#{bus_name} #{city_name.titleize}, #{bus_name} #{city_name.titleize} classes, #{bus_name} #{city_name.titleize} lessons"
      @page_desc = "#{bus_name} - #{city_name.titleize} kids classes, lessons, day & summer camps, activities, & events for children"
      #~ @page_title = "#{params[:city].titleize} #{params[:categ].titleize} kids classes, camps, lessons, activities & events"
      #~ @page_key = "#{params[:city].titleize} #{params[:categ].titleize} kids classes, #{params[:city].titleize} #{params[:categ].titleize} kids activities, #{params[:city].titleize} #{params[:categ].titleize} camps"
      #~ @page_desc = "#{params[:city].titleize} #{params[:categ].titleize} kids classes, lessons, day & summer camps, activities, & events for children of all ages including local provider discounts & specials"
      #~ # title,keyword and description for city
    end
    
    return @page_title, @page_desc, @page_key
  end

  def check_city_using_geocoder(ip_addr)
    location = Geocoder.search("#{ip_addr}").first
    cookies[:latitude] = location.latitude
    cookies[:longitude] = location.longitude
    cookies[:search_city] = location.city
    return location.city
  end
  
  #check for width in detail page
    def getWidthofImage(image)
	  url = "#{request.protocol}#{request.host_with_port}"
	  #path = (url && url=='https://www.famtivity.com') ? image(:original) :  image.path(:original)
	  path =  image
	  width=Paperclip::Geometry.from_file(path).width if path && path.present?
	  height=Paperclip::Geometry.from_file(path).height if path && path.present?
	  return width,height
  end
  def sample_width(image,type)
	if type=='user'
		image_path=image.card
	else
		image_path=image.avatar
	end
	width=0
	height=0
	div_height=250
	url = "#{request.protocol}#{request.host_with_port}"
	path = (url && url=='https://www.famtivity.com') ? image_path(:original) :  image_path.path(:original)	
	if path && path.present?		
		width=Paperclip::Geometry.from_file(path).width
		height=Paperclip::Geometry.from_file(path).height
		img_width=(width && width>800) ? 1004 :  width.round		
		if img_width >= 800
			div_height= 518
		else
			if (img_width >= 400 && img_width < 800)
				if height >= 518
					div_height = 518
				else
					div_height= height.round
				end
			else
				if height >= 400
					#div_height=height.round
					div_height=518
				else
					div_height=250
				end
			end
		end
	
	end
	return width,height,div_height
end

#address
def getEventAddress(event,type)
	address_value = ''
	if type=='user'	
		address_value = (event.business_name.present?) ? address_value + event.business_name + ',' : address_value
	else
		user=UserProfile.where('user_id = ?', event.user_id).last
		address_value = (user.present? && user.business_name.present?) ? address_value + user.business_name + ',' : address_value
	end
	if event.address_1.present? && event.address_2.present?
		address_value = !address_value.blank? ? (address_value +  event.address_1 + ',' +  event.address_2 + ',') : ( event.address_1 + ',' +  event.address_2 + ',')
	elsif event.address_1.present? && event.address_2.blank?
		address_value =  !address_value.blank? ? (address_value +  event.address_1 + ',') : ( event.address_1 + ',')
	elsif event.address_1.blank? && event.address_2.present?
		address_value = !address_value.blank? ? (address_value +  event.address_2 + ',') : ( event.address_2 + ',')
	end
	address_value = (event.city.present?) ? address_value + event.city + ',' : address_value
	address_value = (event.state.present?) ? address_value + event.state + ',' : address_value	
	address_value = (event.zip_code.present?) ? address_value + event.zip_code : address_value
	return address_value
end

end
