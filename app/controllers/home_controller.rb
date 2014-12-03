class HomeController < ApplicationController
  require 'will_paginate/array'
  layout 'landing_layout'
  require 'geo_ip'

  def index
    @meta_alt=true  #dont remove, this for sitemap usage
    @fam_city = City.order(:city_name)
    params[:mode]='parent'  #dont remove this
    @fnetwork=params[:network]
    cookies[:browse_category] = ""
    get_featured_details
  end

	
  def home_articles
    @blog_value  = []
    url = URI.parse("https://www.famtivity.com/blog/?feed=rss2")
    doc = Nokogiri::XML(open(url))
    begin
      if !doc.nil? && doc!='' && doc.present?
        (doc/'item')[0..1].each do|node|
          title = (node/'title').inner_html
          desc = (node/'description').inner_html
          link = (node/'link').inner_html
          img_srcs = desc[/img.*?src="(.*?)"/i,1]
          decs = desc.gsub(/<\/?[^>]*>/,"").gsub(/&#160;/,"")
          dec = decs.gsub("Read More","")
          title = title.gsub(/<\/?[^>]*>/,"")
          dec = dec.sub("Continue reading &#8594;","")
          dec1 = CGI::unescapeHTML(dec)
          title1 = CGI::unescapeHTML(title)
          @blog_value << {"title" => title1.html_safe, "description"=>dec1.html_safe,"img"=>img_srcs,"link"=>link}
        end
      end
    rescue Exception => exc
      logger.error("Message for the log file #{exc.message}")
      flash[:notice] = "Store error message"
    end
    render :layout=>false
  end

  def home_fam_network
    if current_user.present? && !current_user.nil?
      @fam_post = Message.find_by_sql("select * from messages as m left join message_threads as mt on m.message_id=mt.message_id left join message_thread_viewers as mv on mt.thread_id=mv.message_thread_id where (m.message_type='fam_network') and ((mt.posted_by=#{current_user.user_id} and mt.msg_flag=true ) or (mv.user_id=#{current_user.user_id} and mv.msg_thread_flag=true)) order by m.message_id desc").uniq
      @fam_page = @fam_post.paginate(:page => params[:page], :per_page =>11) if !@fam_post.nil? && @fam_post.present?
    end
  end

  # Feature row activities start #
  def featured_activity_detail
    get_featured_details
    render :partial=>"activity_card/activity_short_desc"
  end
 
  def get_featured_details
    if cookies[:search_city].nil? && params[:page].nil?
      re_times = 5
      begin
        user_intial_loc = GeoIp.geolocation("#{request.ip}")
        session[:city] = user_intial_loc[:city].capitalize
        session[:country] = user_intial_loc[:country_code]
        if session[:country] =="IN" || session[:city].nil? || session[:city]=="-"
          session[:city] = "Walnut Creek"
	end
      cookies[:current_city] = session[:city]
      rescue Exception => e
        re_times-=1
        if re_times>0
          retry
        else
          session[:city] = user_intial_loc[:city].capitalize
          session[:country] = user_intial_loc[:country_code]
          if session[:country] =="IN" || session[:city].nil? || session[:city]=="-"
            session[:city] = "Walnut Creek"
          end
        end
      end
    else
      session[:city] = cookies[:search_city] 
    end
    session[:city] = "Walnut Creek" if cookies[:search_city] && cookies[:search_city].include?("Chennai")

    if params[:page].nil?
      cookies[:feature_page] = 1
      cookies.delete :other_city_page
    end
   

    cookies[:feature_page] = 1 + cookies[:feature_page].to_i if !params[:page].nil?
    re_time = 1
    arr = []
    feature_get_total_list(arr,cookies[:latitude],cookies[:longitude])
    featured = arr.compact.flatten
    while featured.length < 12 && re_time <= 5
      cookies[:feature_page] = 1 + cookies[:feature_page].to_i
      feature_get_total_list(arr,cookies[:latitude],cookies[:longitude])
      featured = arr.compact.flatten
      re_time+=1
    end
    @activity_featured = featured
  end
 
 
  def feature_get_total_list(arr,lat,long)
    featured = City.nearby_city_activities_detail(lat,long,session[:city],cookies[:feature_page])
    #~ @admin_activity=[]
    if featured[1]
      cookies[:other_city_page] = 1 +  cookies[:other_city_page].to_i if !cookies[:other_city_page].nil?
      cookies[:other_city_page] = 1 if cookies[:other_city_page].nil?
      #cookies[:other_city_page] = ((cookies[:other_city_page].nil?)  ? 1 : (cookies[:other_city_page].to_i+1))
      @admin_activity = featured[0].paginate(:page => cookies[:other_city_page], :per_page =>12)
    else
      @admin_activity = featured[0].paginate(:page => cookies[:feature_page], :per_page =>12)
    end
    @total_pages = @admin_activity.total_pages
    arr << @admin_activity
    arr.compact.flatten
    return arr
  end
  # Feature row activities end #


end
