module QuickLinksHelper
	#meta tags added for quick link pages
	def quicklink_mtags(linktype)
		#meta tags for specials
		if linktype && linktype!='' && linktype.present? && linktype == "special"
		  @tag_title = "Special activities for kids | famtivity.com"
		  @tag_desc = "Make the best of great discounts and offers with Famtivity's selection of special activities for kids"
		  @tag_key = "Special activities for kids, Special events for kids, Kids special activities"
		    return @tag_title,@tag_desc,@tag_key
		#meta tags for discount dollar
		elsif linktype && linktype!='' && linktype.present? && linktype == "discount-dollar"
		  @tag_title = "Discount dollar activities for kids | famtivity.com"
		  @tag_desc = "A list of kid's activities and events that you can pay for with your Discount Dollars"
		  @tag_key = "Discount dollar activities for kids, Discount dollar events, Discount dollar for activities"	
		    return @tag_title,@tag_desc,@tag_key
		#meta tags for free
		elsif linktype && linktype!='' && linktype.present? && linktype == "free"
		  @tag_title = "Free activities for kids | famtivity.com"
		  @tag_desc = "Free activities for kids from famtivity. Spending quality time with your kids needn't be expensive"
		  @tag_key = "Free activities for kids, Free kids events, Free events for kids"
		    return @tag_title,@tag_desc,@tag_key	
		elsif linktype && linktype!='' && linktype.present? && linktype == "camp"
		  @tag_title = "Camp activities for kids | famtivity.com"
		  @tag_desc = "A list of camp activities for kids provided for a single day or for multiple days by Famtivity providers"
		  @tag_key = "Camp activities for kids, Whole day camp activities, Multiple day camp activities"
		    return @tag_title,@tag_desc,@tag_key	
		elsif linktype && linktype!='' && linktype.present? && linktype == "special-needs"
		  @tag_title = "Special needs for disabled kids | famtivity.com"
		  @tag_desc = "A list of Famtivity activities with Special needs for disabled kids"
		  @tag_key = "Special needs for disabled kids, Special needs for kids, Special needs for disabled children"
		    return @tag_title,@tag_desc,@tag_key	
		elsif linktype && linktype!='' && linktype.present? && linktype == "hot-deals"	
			@tag_title = "Hot deals activities for kids | famtivity.com"
			@tag_desc = "Make the best of great discounts and offers with Famtivity's selection of hot deals activities for kids"
			@tag_key = "Hot deals activities for kids, Hot deals events for kids, Kids hot deals activities"
			return @tag_title,@tag_desc,@tag_key
		end
	end
	
	#get the qlink url
	def getqlinkurls(linktype)
		#~ if linktype && linktype!='' && linktype.present? && linktype == "Specials"
			#~ qurl = "/special-activities"
			#~ qimgs = "/assets/quick_links/kids-special-activities.png"
			#~ alt_image_text ="kids special activities"
		#~ elsif linktype && linktype!='' && linktype.present? && linktype == "Discount Dollars"
			#~ qurl = "/discount-dollar-activities"
			#~ qimgs = "/assets/quick_links/discount-dollar-activities.png"
			#~ alt_image_text ="discount dollar activities for kids"
		#~ elsif linktype && linktype!='' && linktype.present? && linktype == "Special Needs"
			#~ qurl = "/special-needs-activities"
			#~ qimgs = "/assets/quick_links/special-needs.png"
			#~ alt_image_text ="special needs for disabled kids"
		 if linktype && linktype!='' && linktype.present? && linktype == "Hot Deals"
			qurl = "/hot-deals-activities"
			qimgs = "/assets/quick_links/kids-special-activities.png"
			alt_image_text ="hot deals activities for kids"
		elsif linktype && linktype!='' && linktype.present? && linktype == "Free"
			qurl = "/free-activities"
			qimgs = "/assets/quick_links/free-activities.png"
			alt_image_text ="free activities for kids"
		elsif linktype && linktype!='' && linktype.present? && linktype == "Camps"
			qurl = "/camp-activities"
			qimgs = "/assets/quick_links/camp-activities.png"
			alt_image_text ="camp activities for kids"
		end
		return qurl,qimgs,alt_image_text
	end
	
	#meta tags for browse category
	def category_metatags(params)
	    if params[:city] && params[:categ] && params[:sub_categ]
	       #Sub-category Page with Providers list
	      #@page_title = "#{params[:categ].titleize} #{params[:sub_categ].titleize} kids classes, camps, lessons, activities & events"	      
	      #@page_key = "#{params[:categ].titleize} #{params[:sub_categ].titleize} kids classes, #{params[:categ].titleize} #{params[:sub_categ].titleize} kids lessons, #{params[:categ].titleize} #{params[:sub_categ].titleize} camps"	      
	      @page_title = "#{params[:sub_categ].titleize} in #{cookies[:search_city]}, CA for kids"	      
	      @page_key = "#{cookies[:search_city]} #{params[:sub_categ].titleize} kids classes, #{cookies[:search_city]} #{params[:sub_categ].titleize} kids lessons, #{cookies[:search_city]} #{params[:sub_categ].titleize} camps"	  
	      @page_desc = "#{cookies[:search_city]} #{params[:categ].titleize} #{params[:sub_categ].titleize} kids classes, lessons, day & summer camps, activities, & events for children of all ages including local provider discounts & specials"
	      # title,keyword and description for city,catgory
	    elsif params[:city] && params[:categ]
		    #Category Page with sub-categories list
	     # @page_title = "#{params[:categ].titleize} kids classes, camps, lessons, activities & events"
	     @page_title = "#{params[:categ].titleize} in #{cookies[:search_city]}, CA for kids"
	      @page_key = "#{cookies[:search_city]} #{params[:categ].titleize} kids classes, #{cookies[:search_city]} #{params[:categ].titleize} kids lessons, #{cookies[:search_city]} #{params[:categ].titleize} camps"
	      @page_desc = "#{cookies[:search_city]} #{params[:categ].titleize} kids classes, lessons, day & summer camps, activities, & events for children of all ages including local provider discounts & specials"
	      # title,keyword and description for city
	    elsif params[:action]=="browse_category"
	    	@page_title = "Famtivity - Kids Classes, Camps, Lessons, Events & Activities"
      		@page_key = "Kids Classes, Kids Camps, Kids Activities"
      		@page_desc = "Kids activities, classes, day & summer camps, lessons, things to do & events for children of all ages including local provider discounts & specials"
	    end
	    return @page_title, @page_desc, @page_key
    end
    
   #get the city values for browse by location 
  def getdynamic_cities(gid)
	if gid && gid!='' && gid.present? && gid!="all"
	   city = City.where("group_id = ?",gid).map(&:city_name).sort
	elsif gid && gid!='' && gid.present? && gid=="all"
	   #~ city = City.where("group_id = ?",1).map(&:city_name).sort
	   city = City.order(:city_name).map(&:city_name).sort
        end
	return city
    end
    
    def quicklink_htags(linktype)
	@htag = ""
	if linktype && linktype!='' && linktype.present? && linktype == "hot-deals"
	  @htag = "Featuring hot deals activities for kids in your area!"
	elsif linktype && linktype!='' && linktype.present? && linktype == "discount-dollar"
	  @htag = "Redeem your discount dollors - Buy discount dollar activities for kids!"
	elsif linktype && linktype!='' && linktype.present? && linktype == "free"
	  @htag = "Enjoy free activities for kids in your area!"	
	elsif linktype && linktype!='' && linktype.present? && linktype == "camp"
	  @htag = "Find, buy and share camp activities for kids!"
        end
	return @htag
    end
    
end #module ending here
