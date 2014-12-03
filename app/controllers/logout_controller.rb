class LogoutController < ApplicationController
  def index
    cookies.delete :login_usr
    cookies.delete :uid_usr
    cookies.delete :city_new_usr
    cookies.delete :selected_city
    cookies.delete :first_import
    cookies.delete :activate_popup
    cookies.delete :first_import_success
    cookies.delete :fam_invited_user
    cookies.delete :friend_mode


    session[:user_id] = nil
    #session['ip_location'] = nil
    redirect_to "/"
  end    
end
