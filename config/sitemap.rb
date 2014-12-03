  require 'date'
  require 'time'
# Change this to your host. See the readme at https://github.com/lassebunk/dynamic_sitemaps
# for examples of multiple hosts and folders.

host "www.famtivity.com"
domain="https://#{host}"
#~ sitemap :site do
  #~ url root_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
#~ end

sitemap :site do
	url root_url, priority: 1.0, change_freq: "daily"
	url "#{domain}/about-us", priority: 1.0, change_freq: "weekly"
	url "#{domain}/how-it-works", priority: 1.0, change_freq: "daily"
	url "#{domain}/terms-of-service"
	url "#{domain}/privacy-policy"
	url "#{domain}/contact-us"
	url "#{domain}/frequently-asked-questions"
	url "http://blog.famtivity.com", priority: 1.0, change_freq: "daily"
	url "#{domain}/feedback"
end


# You can have multiple sitemaps like the above – just make sure their names are different.

# Automatically link to all pages using the routes specified
# using "resources :pages" in config/routes.rb. This will also
# automatically set <lastmod> to the date and time in page.updated_at:
#
#   sitemap_for Page.scoped

# For products with special sitemap name and priority, and link to comments:
#
#   sitemap_for Product.published, name: :published_products do |product|
#     url product, last_mod: product.updated_at, priority: (product.featured? ? 1.0 : 0.7)
#     url product_comments_url(product)
#   end

# If you want to generate multiple sitemaps in different folders (for example if you have
# more than one domain, you can specify a folder before the sitemap definitions:
# 
#   Site.all.each do |site|
#     folder "sitemaps/#{site.domain}"
#     host site.domain
#     
#     sitemap :site do
#       url root_url
#     end
# 
#     sitemap_for site.products.scoped
#   end

# Ping search engines after sitemap generation:
#



  #~ sitemap_for Activity do |product|
    #~ url product, last_mod: product.modified_date
    #~ url product, activityname: product.activity_name
  #~ end
  
 #provider and activity sitemap link
sitemap_for User.includes(:user_profile,:activities).where("lower(user_type)='p' and account_active_status=true and (user_status='activated' or user_status='' or user_status is null)") do |user|
	if !user.nil? && !user.user_profile.nil? && !user.user_profile.city.nil? && user.user_profile.city.present?
		url "#{domain}/" + user.user_profile.city.gsub(' ','-').downcase + "/" + user.user_profile.slug, priority: 1.0, change_freq: "daily"		
		if user.activities
			user.activities.each do |act|		
				if act.active_status.downcase=='active' && act.created_by.downcase=='provider'
					act_sch = ActivitySchedule.find_by_activity_id(act.activity_id)
					exp_date=act_sch.expiration_date if !act_sch.nil? && !act_sch.expiration_date.nil?
					if !act_sch.nil? && !exp_date.nil? && exp_date.strftime('%Y-%m-%d') >= Time.now.strftime('%Y-%m-%d')
						if !act.city.nil? && act.city.present? && act.city!=''
							url "#{domain}/"+ act.city.gsub(' ','-').downcase + "-ca" + "/" + user.user_profile.slug + "/" + act.category.gsub(' ','-').downcase + "/" + act.sub_category.gsub(' ','-').downcase + "/" + act.slug, last_mod: act.modified_date, priority: 1.0, change_freq: "daily"
						else
							url "#{domain}/anywhere-ca" + "/" + user.user_profile.slug + "/" + act.category.gsub(' ','-').downcase + "/" + act.sub_category.gsub(' ','-').downcase + "/" + act.slug , last_mod: act.modified_date, priority: 1.0, change_freq: "daily" 
						end
					end
				end
			end
		end
	end
end


#category and subcategory sitemap link
sitemap_for ActivityCategory.where("lower(category_name)!='default'") do |categ|
	if !categ.nil? && !categ.category_name.nil? && categ.category_name!=''
		if categ.category_name.downcase=="museums, zoos and exhibits"
			@cat = "museums zoos and exhibits"
		else
			@cat = categ.category_name
		end
	end	
	url "#{domain}/categories/" + @cat.gsub(' ', '-').downcase if !categ.nil?	
	sub_categ =ActivitySubcategory.where("category_id=#{categ.category_id}")  if !categ.nil?
	if !sub_categ.nil? && sub_categ.present?
		sub_categ.each do |act_subcateg|
			if act_subcateg				
				url "#{domain}/categories/" + @cat.gsub(' ', '-').downcase + "/" + act_subcateg.subcateg_name.gsub(' ', '-').downcase, priority: 1.0, change_freq: "daily" if !act_subcateg.nil? && !act_subcateg.subcateg_name.nil?
			end
		end
	end
end

#city sitemap link
sitemap_for City do |city|
	if !city.nil? && !city.city_name.nil? && city.city_name!=''
		url "#{domain}/search?zip_value_name=" + city.city_name + ",CA", priority: 1.0, change_freq: "daily"
	end
end

ping_with "http://#{host}/sitemap.xml"

