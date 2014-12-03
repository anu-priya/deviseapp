class ContactGroupsController < ApplicationController
  # GET /contact_groups
  # GET /contact_groups.json
  include ActivitiesHelper

  def index
    @contact_groups = ContactGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contact_groups }
    end
  end

  # GET /contact_groups/1
  # GET /contact_groups/1.json
  def show
    @contact_group = ContactGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contact_group }
    end
  end

  # GET /contact_groups/new
  # GET /contact_groups/new.json
  def new
    @contact_group = ContactGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact_group }
    end
  end

  # GET /contact_groups/1/edit
  def edit
    @contact_group = ContactGroup.find(params[:id])
  end

  # POST /contact_groups
  # POST /contact_groups.json
  def create
    @contact_group = ContactGroup.new(:group_name => params[:contact_group_name], :inserted_date => Time.now, :modified_date => Time.now, :user_id => cookies[:uid_usr])
    @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]], :order => "contact_name ASC")
    # Finding Activity Groups
    activities = Activity.where(:user_id => current_user.user_id, :created_by => "Provider", :cleaned => true, :active_status => "Active")
    act_ids = !activities.blank? ? activities.map(&:id) : []
    @activity_groups = ActivityAttendDetail.where("activity_id IN (?)",act_ids).group_by(&:activity_id).to_a
    @activity_users = []
    @users = []
    @activity_groups.each do |group|
      activity = find_activity_record(group[0])
      @users << find_parents(activity.id).map(&:id)
    end
    @users = @users.flatten
    @activity_users = User.where("user_id IN (?)",@users)
    @all_users = @contact_users
    #end
    if params[:fam_net] == "true"
      @contact_group.group_status = "private"
    else
      @contact_group.group_status = "just_me"
    end
    cookies[:con_act]="group_create" 
    respond_to do |format|
      if @contact_group.save
        if params[:fam_net] == "true"
          @row = FamNetworkRow.new
          @row.contact_group_id = @contact_group.group_id
          @row.user_id = current_user.user_id
          @row.inserted_date = Time.now
          @row.save!
        end
        @contact_groups = ContactGroup.find(:all,:conditions=>["user_id = ?", cookies[:uid_usr]] , :order => "group_name ASC")
        format.js
      else
        @contact_groups = ContactGroup.find(:all,:conditions=>["user_id = ?", cookies[:uid_usr]] , :order => "group_name ASC")
        @errors = @contact_group.errors
        format.js
      end
    end
  end

  # PUT /contact_groups/1
  # PUT /contact_groups/1.json
  def update
    @contact_group = ContactGroup.find(params[:id])
    @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]] , :order => "contact_name ASC")
    # Finding Activity Groups
    activities = Activity.where(:user_id => current_user.user_id, :created_by => "Provider", :cleaned => true, :active_status => "Active")
    act_ids = !activities.blank? ? activities.map(&:id) : []
    @activity_groups = ActivityAttendDetail.where("activity_id IN (?)",act_ids).group_by(&:activity_id).to_a
    @activity_users = []
    @users = []
    @activity_groups.each do |group|
      activity = find_activity_record(group[0])
      @users << find_parents(activity.id).map(&:id)
    end
    if params[:fam_net] == "true"
      @contact_group.group_status = "private"
    else
      @contact_group.group_status = "just_me"
    end
    @users = @users.flatten
    @activity_users = User.where("user_id IN (?)",@users)
    #end
    @all_users = @contact_users
    respond_to do |format|
      if @contact_group.update_attributes(:group_name => params[:contact_group_name], :modified_date => Time.now, :user_id => cookies[:uid_usr])
        @contact_groups = ContactGroup.find(:all,:conditions=>["user_id = ?", cookies[:uid_usr]] , :order => "group_name ASC")
        format.js
      else
        @contact_groups = ContactGroup.find(:all,:conditions=>["user_id = ?", cookies[:uid_usr]] , :order => "group_name ASC")
        @errors = @contact_group.errors
        format.js
      end
    end
  end
  
  def delete_group
    @contact_group = ContactGroup.find(params[:id])
    render :layout => false
  end

  # DELETE /contact_groups/1
  # DELETE /contact_groups/1.json
  def destroy
    @get_current_url = request.env['HTTP_HOST']
    @contact_group = ContactGroup.find(params[:id])
    @bef_del = ContactUserGroup.where("contact_group_id=? and fam_accept_status=?",@contact_group.group_id,true).map(&:contact_user_id)
    FamtivityNetworkMailer.delay(queue: "Fam Network Delete", priority: 2, run_at: 10.seconds.from_now).fam_network_delete_to_owner(current_user,@contact_group.group_name,@get_current_url) if @contact_group.group_status !="just_me"
    MessageThread.send_notification_network(@bef_del,current_user,@contact_group,@get_current_url)
    @contact_group.destroy
    @contact_groups = ContactGroup.find(:all,:conditions=>["user_id = ?", cookies[:uid_usr]] , :order => "group_name ASC")
    @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]] , :order => "contact_name ASC")
    # Finding Activity Groups
    activities = Activity.where(:user_id => current_user.user_id, :created_by => "Provider", :cleaned => true, :active_status => "Active")
    act_ids = !activities.blank? ? activities.map(&:id) : []
    @activity_groups = ActivityAttendDetail.where("activity_id IN (?)",act_ids).group_by(&:activity_id).to_a
    @activity_users = []
    @users = []
    @activity_groups.each do |group|
      activity = find_activity_record(group[0])
      @users << find_parents(activity.id).map(&:id)
    end
    cookies[:con_act]="group" 
    @users = @users.flatten
    @activity_users = User.where("user_id IN (?)",@users)
    @all_users = @contact_users
    respond_to do |format|
      format.js
    end
  end
  
  def assign_to_groups
    #finding groups
    @group_ids = params[:group_ids]
    @group = @group_ids.split(",")
    #@groups = ContactGroup.find(:all, :conditions => ["user_id=? and group_id IN (?)", cookies[:uid_usr], @group])
    @groups = ContactGroup.find(:all, :conditions => ["group_id IN (?)",@group])
    #finding  contacts
    @contact_ids = params[:contact_ids]
    @contact = @contact_ids.split(",")
    @contacts = ContactUser.find(:all, :conditions => ["user_id=? and contact_id IN (?)", cookies[:uid_usr] , @contact])
    # Finding Activity Groups
    activities = Activity.where(:user_id => current_user.user_id, :created_by => "Provider", :cleaned => true, :active_status => "Active")
    act_ids = !activities.blank? ? activities.map(&:id) : []
    @activity_groups = ActivityAttendDetail.where("activity_id IN (?)",act_ids).group_by(&:activity_id).to_a
    @activity_users = []
    @users = []
    @get_current_url = request.env['HTTP_HOST']
    @activity_groups.each do |group|
      activity = find_activity_record(group[0])
      @users << find_parents(activity.id).map(&:id)
    end
    user = current_user
    @users = @users.flatten
    @activity_users = User.where("user_id IN (?)",@users)
    #end
    #assign contacts to groups
    @error_msg = ""
    @message = ""
    @groups.each do |group|
      @new_con=[]
      @contacts.each do |contact|
        @group_user = ContactUserGroup.where("user_id = ? and contact_group_id = ? and contact_user_id = ?", cookies[:uid_usr], group.group_id , contact.contact_id)
        if(@group_user.blank?)
          @group_user = ContactUserGroup.new(:user_id => cookies[:uid_usr], :contact_user_id => contact.contact_id, :contact_group_id => group.group_id)
          @group_user.inserted_date = Time.now
          @group_user.modified_date = Time.now
          if group.group_status != "just_me"
            if !contact.contact_email.nil? && contact.contact_email!=""
              old_user = User.where("email_address = ?",contact.contact_email).first
              if !old_user.nil?
                @group_user.fam_accept_user_id = old_user.user_id
                if contact.contact_user_type == "friend"
                  FamtivityNetworkMailer.delay(queue: "Fam Network Friend", priority: 2, run_at: 10.seconds.from_now).network_friend_invite_mail(user,group,contact.contact_email,@get_current_url,old_user,contact.contact_id,@message)
                else
                  FamtivityNetworkMailer.delay(queue: "Fam Network Non Friend", priority: 2, run_at: 10.seconds.from_now).network_member_invite_mail(user,group,contact.contact_email,@get_current_url,old_user,contact.contact_id,@message)
                end
              else
                FamtivityNetworkMailer.delay(queue: "Fam Network Invite to join", priority: 2, run_at: 10.seconds.from_now).network_to_join_famtivity(user,group,contact.contact_email,@get_current_url,contact,@message)
              end 
            end
          end
          @group_user.save
        else
          @new_con<<contact.contact_name.capitalize
        end
        #@error_msg += "#{contact.contact_name.capitalize} is already assigned to #{group.group_name}<br/>"
      end
      if !@new_con.empty? && !@new_con.nil? && @new_con.present? && @new_con.count==1
        @error_msg = "#{@new_con[0]} is already assigned to #{group.group_name}<br/>"
      elsif !@new_con.empty? && !@new_con.nil? && @new_con.present? && @new_con.count>1
        @error_msg = "These people are already assigned this #{group.group_name}<br/>"
      end
    end
    @contact_groups = ContactGroup.find(:all,:conditions=>["user_id = ?", cookies[:uid_usr]] , :order => "group_name ASC")
    @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]] , :order => "contact_name ASC")
    #friends netwrok start
    @fam_post = FamNetworkRow.where("user_id=#{current_user.user_id}").map(&:contact_group_id).uniq
    @fusers=[]
    @fam_post.each do |fam|
      @f_name=ContactGroup.where("group_id=?",fam).first
      @fusers<< @f_name if !@f_name.nil?
    end
    if !@fusers.nil? && @fusers.present?
      @famnetwork=@fusers - @contact_groups if !@contact_groups.nil?
    else
      @famnetwork=@fusers
    end
    if !@contact_groups.nil? && !@famnetwork.nil?
        @total_groups = @contact_groups + @famnetwork
    elsif !@contact_groups.nil?
        @total_groups = @contact_groups
    elsif !@famnetwork.nil?
        @total_groups = @famnetwork
    end
    #friends netwrok end

    @all_users = @contact_users
    @non_members = ContactUser.where("user_id = ? and contact_user_type = ?",current_user.user_id,"non_member") if current_user.present?
    if !@non_members.nil? && @non_members!=[] && @non_members.present?
      @non_mem = @non_members.count
    else
      @non_mem = 0
    end
    @members_l = ContactUser.where("user_id = ? and contact_user_type = ?",current_user.user_id,"member") if current_user.present?
    if !@members_l.nil? && @members_l!=[] && @members_l.present?
      @mem_l = @members_l.count
    else
      @mem_l = 0
    end
    @friends_l = ContactUser.where("user_id = ? and contact_user_type = ?",current_user.user_id,"friend") if current_user.present?
    if !@friends_l.nil? && @friends_l!=[] && @friends_l.present?
      @frd_l = @friends_l.count
    else
      @frd_l = 0
    end

    respond_to do |format|
      format.js
    end
  end
  
  def filter_contacts_by_groups
    @click = params[:click]
    if(params[:click]=="groups")
      @activity_users = []
      @status_id=params[:id]
      @contact_group = ContactGroup.where(:group_id => params[:id]).last
      @contact_users = @contact_group.contact_users.order("contact_name ASC")
      @all_users = @contact_users
      if @contact_group.group_status !="just_me"
        cookies[:fam_network] = params[:id]
      else
        cookies[:fam_network] = nil
      end
    elsif(params[:click]=="others")
      @status_id=params[:id]
      @fam_group=ContactGroup.where(:group_id => params[:id]).last
      @fam_owner=User.find_by_user_id(@fam_group.user_id)
      @fam_contact=ContactUser.where("contact_email=?",@fam_owner.email_address).last
      @fam =ContactUser.find_by_sql("select * FROM contact_users
                                        INNER JOIN contact_user_groups as fam
                                        ON contact_users.contact_id = fam.contact_user_id and fam.contact_group_id='#{params[:id]}'")
    else
      @activity = Activity.where(:activity_id=>params[:id]).first
      @activity_users = find_parents(@activity.id)
    end
    respond_to do |format|
      format.js
    end
  end

  def frinds_networks
    if !params[:group_ids].nil? && params[:group_ids].present?
     @networkgroup= params[:group_ids].split(',')
      @group_names=""
      !@networkgroup.nil? && @networkgroup.each do |ng|
       @cg= ContactGroup.where(:group_id => ng).last

      if @group_names.empty?
        @group_names.concat("#{@cg.group_name} ") if !@cg.nil?&& !@cg.group_name.nil?
      else
        @group_names.concat(",#{@cg.group_name} ") if !@cg.nil?&& !@cg.group_name.nil?
      end
      end
    end
    respond_to do |format|
      format.js
    end
    #render :text => @group_names
  end

end
