 class StaticController < ApplicationController
	layout "static_layout",:except=>[:category_list]
	def about_us
		@meta_alt = true #dont remove, this for sitemap usage
		if current_user.nil?
		session.clear
		end
		@get_current_url = request.env['HTTP_HOST']
	end

	def contact_us
		@meta_alt = true #dont remove, this for sitemap usage
		if current_user.nil?
		session.clear
		end
		@get_current_url = request.env['HTTP_HOST']
	end

	def contact_us_mail
		@phone_value = "#{params[:phone1]}-" +"#{params[:phone2]}-"+"#{params[:phone3]}"

		if params[:email] && params[:name] && params[:usertype] && @phone_value && params[:msg] && params[:usertype]
			@get_current_url = request.env['HTTP_HOST']
			@result = UserMailer.delay(queue: "Contact", priority: 1, run_at: 5.seconds.from_now).contact_us(params[:email],params[:name],@get_current_url,@phone_value,params[:msg],params[:usertype])
			#@result = UserMailer.contact_us(params[:email],params[:name],@get_current_url,params[:phone],params[:msg]).deliver
			respond_to do |format|
			format.js{render :text => "$('.success_update_info').css('display', 'block').fadeOut(4000);"} 
			end
		end
	end


	def faq
		@meta_alt = true #dont remove, this for sitemap usage
		if current_user.nil?
		session.clear
		end
		@get_current_url = request.env['HTTP_HOST']
	end
	
	def privacy_policy
		@meta_alt = true #dont remove, this for sitemap usage
		if current_user.nil?
		session.clear
		end
		@get_current_url = request.env['HTTP_HOST']
	end

	def terms_of_service
		@meta_alt = true #dont remove, this for sitemap usage
		if current_user.nil?
		session.clear
		end
		@get_current_url = request.env['HTTP_HOST']
	end
	
	def category_list
		@category = ActivityCategory.all
		if params[:category] && params[:sub_category] && params[:script_url] && params[:href_url]
			@categ = ActivityCategory.where("lower(category_name)='#{params[:category].downcase}'").last
			if @categ  && @categ .present?
				@sub = ActivitySubcategory.where("category_id = ?  and lower(subcateg_name)=?",@categ.category_id, params[:sub_category].downcase).last
				@sub_category= @sub.update_attributes(:script_url => params[:script_url], :href_url => params[:href_url]) if @sub && @sub.present?
			end	
		@sub_category=ActivitySubcategory.where("category_id = ?",@categ.category_id)
		end
	end
	
	def parent_terms_of_service
		
	end

	def provider_terms_of_service
		
	end
	
	def parent_privacy_policy
	  
	end

	def provider_privacy_policy
	  
	end
end
