class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
  $image_global_path = 'http://dev.famtivity.com:8080/'
  $admin_email_address= 'admin@famtivity.com,sithankumar@i-waves.com,durgadevi@i-waves.com'
  $pop_load_url = ''
  $fb_appid='421335961251817' 
  # $accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT lower(trim(category))as category")
  #Invite provider credit amount here we can change the amount
  $dollar="25.00"
  #provider leads amount dont activity_image
  $pro_leads="0.99"
  $market_sell_u="29.95" # this amount for user market sell plan
  $market_sell_manage_u="49.95" # this amount for user market_sell_manage plan
  $market_sell_manage_plus_u="99.95" # this amount for user market sell plan
  $app_url = "http://dev.famtivity.com:8080"
  $activity_image = "http://dev.famtivity.com:8080" #if we use s3 empty this path
  #$meta_mobile = "http://m.famtivity.com" #for mobile site alternate link added
  $meta_mobile = "http://dev.famtivity.com:3004" 
  #this for 54...367662280021164
  #this for famtivitycom 403872903035404
  #this for rajkumar421335961251817
  #COTC configuration
  #$domain_name='famtivity'   #live use this variable
  $mail_redirection_path = 'http://dev.famtivity.com:3004'
  #$mail_redirection_path = 'http://uat.famtivity.com:3004'
  #$mail_redirection_path = 'http://m.famtivity.com'
  $domain_name='famtivitydev'
  $dc = Dalli::Client.new("127.0.0.1:11211")
  before_filter :redirect_mobile ,:except=>[:activity_embed] 
  before_filter :set_access_control_headers, :only => [:activity_embed]
  before_filter :getcity_search, :authenticate_site,:set_cache_buster, :init, :clear_other_users_session, :invite_welfriend,:except=>[:activity_embed]


	def getcity_search
		@fam_city = City.order(:city_name)
	end
def set_access_control_headers
headers['Access-Control-Request-Method'] = '*'
end

  def redirect_mobile(site = $mail_redirection_path)
	url=site+request.fullpath
	redirect_to url if /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|ipad|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.match(request.user_agent) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.match(request.user_agent[0..3])
  end

  #measure the loading time
  def init
	@start_time = Time.now.usec
	@s_time = Time.now
  end  
  
  helper_method :current_user
  
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
#~ #routing error and other error custom message 

rescue_from ActiveRecord::RecordNotFound, :with => :render_404
rescue_from AbstractController::ActionNotFound, :with => :render_404
rescue_from ActionController::RoutingError, :with => :render_404
rescue_from ActionController::UnknownController, :with => :render_404
rescue_from ActionController::UnknownAction, :with => :render_404
rescue_from ActiveRecord::StatementInvalid, :with => :render_404
#~ rescue_from Exception, :with => :server_error

  #~ notification message from server while accessing.
  def server_error(exception)
   ExceptionNotifier::Notifier.exception_notification(request.env, exception).deliver
   render_404
  end

private

def render_404(exception = nil)
	if exception
	logger.info "Rendering 404: #{exception.message}"
	end
	render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
end
  
  protected
  
  def authenticate_site
     authenticate_or_request_with_http_basic do |username, password|
	username == "fam-webuser" && password == "f@musr"
     end
  end

  def json_request?
    request.format.json?
  end

  def check_cookies
    if !cookies[:city_new_usr].nil?
      true	
    else
      redirect_to root_url
    end
  end
  
   def authenticate_user_admin 	
    if cookies[:uid_usr] 
      @a_current_user ||= User.where("user_id= ? and user_type=?",cookies[:uid_usr],"A").first if cookies[:uid_usr] 
      redirect_to "/" if @a_current_user.nil? 
    elsif session[:user_id] 
      @a_current_user ||= User.find_by_user_id_and_user_type(session[:user_id],"A") if session[:user_id] 
      redirect_to "/" if @a_current_user.nil? 
    else 
      redirect_to "/" 
    end 
  end
  
  def set_current_user
    User.current = current_user
  end

def authenticate_user
if !session[:user_id].nil? && session[:user_id] !=""
@current_user ||= User.where("user_id= ?",session[:user_id]).last if session[:user_id]
cookies[:uid_usr] = session[:user_id] if !@current_user.nil?
redirect_to "/" if @current_user.nil?
elsif !cookies[:uid_usr].nil? && cookies[:uid_usr] !=""
@current_user ||= User.where("user_id= ?",cookies[:uid_usr]).last if cookies[:uid_usr]
session[:user_id] = cookies[:uid_usr] if !@current_user.nil?
redirect_to "/" if @current_user.nil?
else
redirect_to "/"
end
end



  def current_user
    @current_user ||= (login_from_session || login_from_cookie) unless @current_user == false
  end
  
  def current_user=(user)
    @current_user = user
  end

  def login_from_session
    self.current_user = User.where("user_id= ?",session[:user_id]).last if session[:user_id]
  end

  def login_from_cookie
    self.current_user = User.where("user_id= ?",cookies[:uid_usr]).last if cookies[:uid_usr]
  end
  

  #To delete the other user session/Sindhu
    def clear_other_users_session
       pmsg_email= Base64.decode64(params[:msg_email]) if (!params[:msg_email].nil? && params[:msg_email].present?)
       if !params[:sent_user_email].nil? && !params[:group].nil? && !params[:cid].nil?
          @fam = ContactUserGroup.find_by_contact_user_id_and_contact_group_id_and_fam_accept_status(params[:cid],params[:group],true)
      end 


   #~ chk_user = Base64.decode64(params[:sent_user]) if params[:sent_user] && !params[:sent_user].nil?
    if params[:login] && !params[:login].nil? && params[:login]=="login"
      if !current_user.nil? && current_user.present? && current_user.user_type=="P"
        redirect_to"/provider?invite_friend=friend"
      elsif !current_user.nil? && current_user.present? && ((current_user.user_type=="U")||(current_user.user_type=="A"))
        redirect_to"/?invite_friend=friend"
      else
       redirect_to "/invite-friends/login"
      end
    elsif params[:news_letter_fam] && !params[:news_letter_fam].nil? && params[:news_letter_fam]=="login"
      if !current_user.nil? && current_user.present? 
       redirect_to "/?creat_network=true"
      else
       redirect_to "/invite-famnetworks/login/"
      end
    elsif !@fam.nil? && @fam.present?
      email_present(params[:sent_user_email]) if !params[:sent_user_email].nil? 
      redirect_to "/?fam_status=true"
    elsif ((params[:sent_user] && params[:sent_user_email] && !params[:sent_user].nil? && !params[:sent_user_email].nil? && current_user && !current_user.nil? && current_user.email_address!=params[:sent_user_email] && params[:become_provider].nil? && !params[:become_provider].present?) ||(!params[:facebook_reg].nil? && !params[:sent_user].nil?) || (params[:idm] && !params[:idm].nil?) || (params[:s_out] && !params[:s_out].nil?)|| (params[:provider_reg] && !params[:provider_reg].nil?))
     clear_user_sesion
     if (params[:sent_user] && params[:sent_user_email] && params[:parent_reg]&& !params[:sent_user].nil? && !params[:sent_user_email].nil? && !params[:parent_reg].nil? && !params[:message_reg] && !params[:cid])
          redirect_to "/home?sent_user=#{params[:sent_user]}&sent_user_email=#{params[:sent_user_email]}"
     elsif (params[:sent_user] && params[:sent_user_email] && params[:group]&& !params[:sent_user].nil? && params[:message_reg] && params[:cid] && !params[:sent_user_email].nil? && !params[:group].nil? && !params[:message_reg].nil? && !params[:cid].nil? && params[:con_invite].nil?)
          redirect_to "/home?sent_user=#{params[:sent_user]}&sent_user_email=#{params[:sent_user_email]}&message_reg=#{params[:message_reg]}&cid=#{params[:cid]}&group=#{params[:group]}&con_invite=true"
     end
    elsif (params[:sent_user] && params[:sent_user_email] && params[:parent_reg]&& !params[:sent_user].nil? && !params[:sent_user_email].nil? && !params[:parent_reg].nil? && !params[:message_reg] && !params[:cid])
      redirect_to "/home?sent_user=#{params[:sent_user]}&sent_user_email=#{params[:sent_user_email]}"
    elsif (params[:sent_user] && params[:sent_user_email] && params[:group]&& params[:message_reg] && params[:cid] && !params[:sent_user].nil? && !params[:sent_user_email].nil? && !params[:group].nil? && !params[:message_reg].nil? && !params[:cid].nil? && params[:con_invite].nil?)
          redirect_to "/home?sent_user=#{params[:sent_user]}&sent_user_email=#{params[:sent_user_email]}&message_reg=#{params[:message_reg]}&cid=#{params[:cid]}&group=#{params[:group]}&con_invite=true"
    elsif !params[:become_provider].nil? && params[:become_provider].present? && !params[:sent_user_email].nil?
     user = User.where("email_address=? and user_type=? and account_active_status=?",params[:sent_user_email],"U",true).last if !params[:sent_user_email].nil?
     provider = User.where("email_address=? and user_type=? and account_active_status=?",params[:sent_user_email],"P",true).last if !params[:sent_user_email].nil?
     #@same_user=(current_user.email_address==user.email_address) if !user.nil? && user.present? && !current_user.nil? && current_user.present?
     if !provider.nil? && provider.present?
      email_present(provider.email_address)
      redirect_to "/"
     elsif !user.nil? && user.present?
      email_present(user.email_address)
       redirect_to "/?become_pro=yes"
     end
    elsif !pmsg_email.nil?
      email_present(pmsg_email)
      if !params[:cnetwork].nil? && params[:cnetwork].present? 
        redirect_to "/?creat_network=true"
      elsif !params[:group].nil? && params[:group].present?
        @con = ContactGroup.where("group_id=#{params[:group]}").last
        cookies[:follow_cat_val]=@con.group_name if !@con.nil?
        redirect_to "/"
      else
        redirect_to "/messages?mode=parent&rep_id=#{params[:rep_id]}"
      end
   elsif !current_user.nil? && !current_user.email_address.nil? && pmsg_email && current_user.email_address==pmsg_email
        redirect_to "/messages?mode=parent&rep_id=#{params[:rep_id]}"
   elsif params[:guest_login] && params[:guest_login]=='true' && params[:guest_id]
	   guest = GuestDetail.find_by_guest_id(params[:guest_id])
	   user = User.where("email_address=?",guest.guest_email).last if guest && guest.present?
	   if user && user.present?
		if !current_user.nil? && current_user.user_id!=user.user_id
			clear_user_sesion
		end
		email_present(user.email_address) if current_user.nil?
	   end
   end
   
	if !params[:mview].nil? && params[:mview]!='' && params[:mview].present?
	   act_url = get_mactivty(params[:mview])
	   if params[:bcrum] && params[:bcrum].present?
		   if params[:bcrum]=="p"
			cookies[:set_bread]="p"
		   else
			cookies[:thro_page] = params[:bcrum]  
		   end
	   end
	   redirect_to "/#{act_url}" , :status => 301
	end
   
  end
  #To delete the other user session
  
                                                                                
def invite_welfriend
  if !params[:wel_friend].nil? && params[:wel_friend]!='' && params[:wel_friend].present?
     @user_usr=User.where("user_id= ?",params[:wel_friend]).last
     p current_user && !current_user.nil? && @user_usr && @user_usr.user_id==current_user.user_id
    if current_user && !current_user.nil? && @user_usr && @user_usr.user_id==current_user.user_id
      redirect_to "/?invite_wel_friend=#{params[:wel_friend]}"
    else
      if @user_usr
        cookies[:date_registered_usr] = Time.now.strftime("%Y-%m-%d") if cookies[:date_registered_usr].nil?
        cookies[:login_usr] = "on"
        cookies[:role_usr]= @user_usr.user_type
        cookies[:logged_in] = "yes"
        session[:user_id] = @user_usr.user_id
        cookies.permanent[:uid_usr] = @user_usr.user_id
        cookies.permanent[:username_usr] = @user_usr.user_name
        cookies[:email_usr] = @user_usr.email_address
        add_sign_count = @user_usr.sign_in_count
        @user_usr.sign_in_count = (add_sign_count.nil? || add_sign_count==0) ?  1 : (add_sign_count+1)
        @user_usr.last_sign_in = Time.now
        @user_usr.save
        redirect_to "/?invite_wel_friend=#{params[:wel_friend]}"
      end
    end
 end
end
  
def email_present(pmsg_email)
  c_user=User.where("email_address= ?", pmsg_email).last
      cookies[:date_registered_usr] = Time.now.strftime("%Y-%m-%d") if cookies[:date_registered_usr].nil?
      cookies[:login_usr] = "on"
      cookies[:role_usr]= c_user.user_type
      cookies[:logged_in] = "yes"
      session[:user_id] = c_user.user_id
      cookies.permanent[:uid_usr] = c_user.user_id
      cookies.permanent[:username_usr] = c_user.user_name
      cookies[:email_usr] = c_user.email_address
      if c_user
              add_sign_count = c_user.sign_in_count
              c_user.sign_in_count = (add_sign_count.nil? || add_sign_count==0) ?  1 : (add_sign_count+1)
              c_user.last_sign_in = Time.now
              c_user.save
      end
      @current_user = c_user
    end
  
  def clear_user_sesion
		    cookies.delete :login_usr
		    cookies.delete :uid_usr
		    cookies.delete :city_new_usr
		    cookies.delete :selected_city
		    cookies.delete :first_import
		    cookies.delete :first_import_success
		    cookies.delete :logged_in
		    cookies.delete :username_usr
		    cookies.delete :email_usr
		    session[:user_id] = nil
		    #session['ip_location'] = nil
		    @current_user = false
  end
  
end
