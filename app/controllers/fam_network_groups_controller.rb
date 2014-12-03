class FamNetworkGroupsController < ApplicationController

  before_filter :authenticate_user
  # GET /fam_network_groups
  # GET /fam_network_groups.json


  def fam_edit_network_group
    @fam_group = ContactGroup.where("group_id = #{params[:id]}").last
    @fam_users = ContactUser.find_by_sql("select * FROM contact_users
                                        INNER JOIN contact_user_groups as fam
                                        ON contact_users.contact_id = fam.contact_user_id and fam.contact_group_id='#{params[:id]}'")
    
    #@fam_users=@fam.uniq{|x| x.contact_email}
    cookies[:fam_network] = params[:id]
  end


  def remove_member
    @get_current_url = request.env['HTTP_HOST']
    if params[:fam_del]=="yes"
      @bef_del = ContactUserGroup.where("contact_group_id=? and fam_accept_status=?",params[:fam_id],true).map(&:contact_user_id)
      ContactUserGroup.destroy_all(:contact_group_id => params[:fam_id])
      FamNetworkRow.destroy_all(:contact_group_id => params[:fam_id])
      @fam = ContactGroup.find_by_user_id_and_group_id(current_user.user_id,params[:fam_id])   
      FamtivityNetworkMailer.delay(queue: "Fam Network Delete", priority: 2, run_at: 10.seconds.from_now).fam_network_delete_to_owner(current_user,@fam.group_name,@get_current_url)
      #Notification after deleting the Fam Network
	MessageThread.send_notification_network(@bef_del,current_user,@fam,@get_current_url)
      #Notification after deleting the Fam Network
      @fam.destroy() if !@fam.nil?

    else
      rem_id = params[:fam_rem_id].split(",")
      rem_id.reject!(&:empty?)
      if rem_id.length > 0
        rem_id.each do |k|
          fam = ContactUserGroup.find_by_contact_user_id_and_contact_group_id(k,params[:fam_id])
          if !fam.nil?
            fam_row = FamNetworkRow.find_by_user_id_and_contact_group_id(fam.fam_accept_user_id,params[:fam_id])
            fam_row.destroy() if !fam_row.nil?
            fam.destroy()
          end
        end
        @fam_group = ContactGroup.find_by_group_id(params[:fam_id])
        FamtivityNetworkMailer.fam_network_remove_contacts_to_owner(current_user,@fam_group,@get_current_url).deliver
      end
    end
  end

  def fam_network
   cookies.delete :fam_post_invite
  end


  def create_network
    @fam = ContactGroup.new(:group_name => params[:group_name],:group_status=>"private", :inserted_date => Time.now, :modified_date => Time.now, :user_id => cookies[:uid_usr])
    if @fam.save
      cookies[:follow_cat_val]=params[:group_name] if !params[:group_name].nil? 
      @row = FamNetworkRow.new
      @row.contact_group_id = @fam.group_id
      @row.user_id = current_user.user_id
      @row.inserted_date = Time.now
      @row.save!
      events = {:data => "success",:value=>"#{@fam.group_id}"}
      cookies[:fam_network] = @fam.group_id
      render :text =>events.to_json
    else
      events = {:data => "exist",:value=>""}
      render :text =>events.to_json
    end
  end
 
end
