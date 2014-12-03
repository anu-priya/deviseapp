class FamNetworksController < ApplicationController
  before_filter :authenticate_user
  before_filter :clear_temp_photo, :only=>[:fam_network_detail]
  #layout "message", only: [:fam_create_post]
  def fam_create_post
    @name=params[:group_name] if !params[:group_name].nil?
    cookies[:fam_network] = params[:id] if !params[:id].nil?
    @fam_users=[]
    @ttl_fam_users = ContactUser.find_by_sql("select * FROM contact_users
                                        INNER JOIN contact_user_groups as fam
                                        ON contact_users.contact_id = fam.contact_user_id and fam.fam_accept_status=true and fam.contact_group_id='#{cookies[:fam_network]}'")
    @fam_users = @ttl_fam_users.map(&:contact_email).uniq
    @status=params[:show] if !params[:show].nil?
    @con = ContactGroup.where("group_id=?", params[:id]).last
    @same_user=@con.user_id==current_user.user_id if !@con.nil?
    if !@same_user
      @creater=User.where("user_id = ?",@con.user_id).first if !@con.nil?
      @fam_users<< @creater.email_address if !@creater.nil?
    end
    cookies[:follow_cat_val]=@con.group_name if !@con.nil? 
    dir = "#{Rails.root}/public/temp_message_upload/#{current_user.user_id}"
    FileUtils.remove_dir dir, true if File.exists?(dir)
    #~ dir = "#{Rails.root}/public/temp_post_upload/Images/#{current_user.user_id}"
    #~ FileUtils.remove_dir dir, true if File.exists?(dir)
    if params[:show].nil? && params[:show]!="success"
      render layout: "message", locals: {fam_users: @fam_users}
    end
  end



  def accept_fam_network
    @fam = FamNetwork.where("fam_contact_email='#{params[:email_add]}' and fam_group_id = #{params[:group]}").last
    if !@fam.nil?
      @fam.fam_accept_status =true
      @fam.save
    end
    redirect_to "/"
  end

  def fam_network_detail
    if params[:id] && !params[:id].nil? && params[:id].present?
      @group_name= params[:group_name] if !params[:group_name].nil? && params[:group_name].present?
	    @fam_network = Message.where("message_id='#{params[:id]}'").last
	    #~ @message_threads = @fam_network.message_threads
	     @message_threads  = MessageThread.find_by_sql("select mt.* from message_threads as mt left join message_thread_viewers as mv on mt.thread_id=mv.message_thread_id where(mt.message_id=#{@fam_network.message_id} and ((mt.posted_by=#{current_user.user_id} and mt.msg_flag=true) or mv.user_id=#{current_user.user_id})) order by mt.posted_on asc").uniq if @fam_network && @fam_network.present? && !@fam_network.nil?

	    @first_msg_thread = @message_threads.first
	    @fam_image = []
	    @fam_documents = []
    end
  end

  private
  #To clear temp photo folder for multiple file upload
  def clear_temp_photo
	 	dir = "#{Rails.root}/public/temp_message_upload/#{current_user.user_id}"
		FileUtils.remove_dir dir, true if File.exists?(dir)
  end
end
