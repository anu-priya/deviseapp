class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end

  def handle_unverified_request
    true
  end


  def create
    omniauth = request.env["omniauth.auth"]
    logger.debug('omni')
    logger.debug(omniauth)
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Signed in successfully."
      logger.debug(' auth ')
      logger.debug( authentication.user )
      redirect_to :controller=>'contact_users', :action => 'facebook_import'
    elsif current_user
      Authentication.delete_all
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'])
      redirect_to :controller=>'contact_users', :action => 'facebook_import'
    end
    logger.debug('CURRENT')
    logger.debug( current_user.authentications[0]['token'] ) 
  end

  

  def old_create
    omniauth = request.env["omniauth.auth"]
    logger.debug('omni')
    logger.debug(omniauth)
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      p "1111111111111111"
      flash[:notice] = "Signed in successfully."
      logger.debug(' auth ')
      logger.debug( authentication.user )
      redirect_to :controller=>'contact_users', :action => 'facebook_import'
    elsif current_user
      p "22222222222222"
      Authentication.delete_all
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'])
      redirect_to :controller=>'contact_users', :action => 'facebook_import'

    else
      p "3333333333333"
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        #redirect_to :controller=>'contact_users', :action => 'facebook_import'
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
    logger.debug('CURRENT')
    logger.debug( current_user.authentications[0]['token'] ) 
    p "44444444444444"
  end



  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
