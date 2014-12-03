class ContactUsersController < ApplicationController
  #require 'koala'
  require 'will_paginate/array'
  require 'fileutils'
  before_filter :authenticate_user, :except=>[:contact_activate,:fam_member_activate]
  before_filter :getcity_search, only: [:contact_index]
  layout "message", only: [:contact_index]
  include ActivitiesHelper

  #Newsletter Invite
  def newslertter_invite
  end

  #Newsletter fam_network
  def newslertter_fam_network
  end

  #success popup for invite
  def invite_success_page
    @reld=params[:reld]
    # Added for analytics
    @click_mode = params[:mode] if !params[:mode].nil?
  end
  
  #invite mail
  def invite_mail
    contactss= params[:toemailaddress].to_s.gsub(" ","")
    contact =contactss.split(",")
    @get_current_url = request.env['HTTP_HOST']
    user= current_user
    con_id=params[:con_id] if !params[:con_id].nil?
    grp_id=params[:grp_id] if !params[:grp_id].nil?
    fam_group = ContactGroup.where("group_id ='#{params[:grp_id]}'").last if !params[:grp_id].nil?
    con_user = ContactUser.where("contact_id=?",params[:con_id]).last if !params[:con_id].nil?
    message = params[:redactor_content].gsub("\r\n", "<br>") if !params[:redactor_content].nil?
    get_current_url = request.env['HTTP_HOST']
    contact.each do |d|
      c = d.gsub(/"/, '')
      invited_user = c
      @con_email = c.split("@")
      old_user = User.where("email_address = ?",c).first
      if old_user.nil?
        @contact_exist = ContactUser.find_by_contact_email_and_user_id(c,current_user.user_id) if !current_user.nil?
        if @contact_exist.nil?
          @contact_exist = ContactUser.create(:contact_name=>@con_email[0], :contact_email=>c, :user_id=>current_user.user_id, :contact_type=>"famtivity", :invite_status=>true, :accept_status=>false, :contact_user_type=>"non_member" , :inserted_date=>Time.now)
        end
      else
        @contact_exist = ContactUser.find_by_contact_email_and_user_id(c,current_user.user_id) if !current_user.nil?
        if @contact_exist.nil?
            if !old_user.nil? && !old_user.user_profile.nil? && !old_user.user_profile.user_photo.nil?
              img=old_user.user_profile.user_photo 
              @contact_exist = ContactUser.create(:contact=>img, :contact_name=>@con_email[0], :contact_email=>c, :user_id=>current_user.user_id, :contact_type=>"famtivity", :invite_status=>true, :accept_status=>false, :contact_user_type=>"member" , :inserted_date=>Time.now)
            else
              contact_exist = ContactUser.create(:contact_name=>@con_email[0], :contact_email=>c, :user_id=>current_user.user_id, :contact_type=>"famtivity", :invite_status=>true, :accept_status=>false, :contact_user_type=>"member" , :inserted_date=>Time.now)
            end
        end
      end
      invitor_user = InvitorList.where("invited_email = ?",c).first
      if !old_user.present?
        if !invitor_user
          InvitorList.invitor_list(c,current_user.user_id,'friend')
        else
          invitor_user.update_attributes(modified_date: Time.now)
        end
        if cookies[:fam_network].nil? || !cookies[:fam_network].present?
          if !fam_group.nil? && !con_user.nil?
            @msg="#{fam_group.group_name} Invitation"
            MessageMailer.delay(queue: "Send message", priority: 2, run_at: 10.seconds.from_now).send_to_famnetwork(invited_user,@msg,user,get_current_url,con_id,fam_group.group_id,con_user)
          else
            UserMailer.delay(queue: "invite Message", priority: 2, run_at: 10.seconds.from_now).invite_to_join_famtivity(invited_user, user, message,get_current_url)
          end
        end
      end
      if !cookies[:fam_network].nil? && cookies[:fam_network]!=""
        fam_net_group = ContactGroup.where("group_id ='#{cookies[:fam_network]}'").last
        @old_user = "raja"  
        @fam_net = ContactUserGroup.where("contact_group_id ='#{cookies[:fam_network]}' and contact_user_id='#{@contact_exist.contact_id}'").last
        if @fam_net.nil?
          c_user= ContactUserGroup.new
          c_user.contact_user_id = @contact_exist.contact_id
          c_user.contact_group_id = cookies[:fam_network]
          c_user.user_id= current_user.user_id
          c_user.inserted_date = Time.now
          c_user.modified_date = Time.now
          if !old_user.nil?
            c_user.fam_accept_user_id = old_user.user_id
          end
          c_user.save!
        end
        @msg="message"
        if !old_user.nil?
          if @contact_exist.contact_user_type == "friend"
            FamtivityNetworkMailer.delay(queue: "Fam Network Friend", priority: 2, run_at: 10.seconds.from_now).network_friend_invite_mail(user,fam_net_group,c,@get_current_url,old_user,@contact_exist.contact_id,message)
          else
            FamtivityNetworkMailer.delay(queue: "Fam Network Non Friend", priority: 2, run_at: 10.seconds.from_now).network_member_invite_mail(user,fam_net_group,c,@get_current_url,old_user,@contact_exist.contact_id,message)
          end
        else
          FamtivityNetworkMailer.delay(queue: "Fam Network Invite to join", priority: 2, run_at: 10.seconds.from_now).network_to_join_famtivity(user,fam_net_group,c,@get_current_url,@contact_exist,message)
        end      
      end
    end
  end

  # GET /contact_users
  # GET /contact_users.json
  def index
    @click_mode = params[:mode] if !params[:mode].nil?
    @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]] , :order => "contact_name ASC")
    @all_users = @contact_users
    @test ="index"
    @contact_groups = ContactGroup.find(:all,:conditions=>["user_id = ?", cookies[:uid_usr]] , :order => "group_name ASC")
    # Finding Activity Groups
    # @arr = []
    # activity_groups = ActivityAttendDetail.where(:user_id=>current_user.user_id)
    # @activity_groups = activity_groups.group_by(&:activity_id).to_a
    # @arr = activity_groups.map(&:user_id)
    # @activity_users = User.where("user_id IN (?)",@arr)
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
    #end
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def contact_index
    if !cookies[:con_act].nil? && cookies[:con_act]!=""
      if cookies[:con_act]=="delete"
        @del=true
      elsif cookies[:con_act]=="group"
        @grp=true
      elsif cookies[:con_act]=="group_create"
        @net=true
      end
    end
    cookies[:friend_mode] = params[:mode] if !params[:mode].nil?
    @click_mode = params[:mode] if !params[:mode].nil?
    @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]] , :order => "contact_name ASC")
    @all_users = @contact_users
    @contact_groups = ContactGroup.find(:all,:conditions=>["user_id = ?", cookies[:uid_usr]] , :order => "group_name ASC")
    
    # Finding Activity Groups
    # @arr = []
    # activity_groups = ActivityAttendDetail.where(:user_id=>current_user.user_id)
    # @activity_groups = activity_groups.group_by(&:activity_id).to_a
    # @arr = activity_groups.map(&:user_id)
    # @activity_users = User.where("user_id IN (?)",@arr)
    activity_list = Activity.where(:user_id => current_user.user_id, :created_by => "Provider", :cleaned => true, :active_status => "Active")
    act_ids = !activity_list.blank? ? activity_list.map(&:id) : []
    @activity_groups = ActivityAttendDetail.where("activity_id IN (?)",act_ids).group_by(&:activity_id).to_a
    @activity_users = []
    @users = []
    activity_ids = []
    @activity_groups.each do |group|
      activity = find_activity_record(group[0])
      activity_ids << activity.id
      @users << find_parents(activity.id).map(&:id)
    end
    @users = @users.flatten
    activity_ids = activity_ids.flatten
    @activity_users = User.where("user_id IN (?)",@users)
    activities = Activity.where("activity_id IN (?)",activity_ids)
    # Auto complete
    @groups = ContactGroup.find_all_by_user_id(current_user.user_id).uniq.map(&:group_name) if current_user.present?
    @friends = ContactUser.find_all_by_user_id(current_user.user_id) if current_user.present?
    @users = @activity_users if current_user.present?
    @activities = activities.map(&:activity_name) if current_user.present?
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
    if !params[:mode].nil?
      params[:mode]=params[:mode] 
    else
      params[:mode]="provider"
    end

    @get_current_url = request.env['HTTP_HOST']
    @file=params[:checked]
    @test ="index"
    cookies[:con_act]=""
    respond_to do |format|
      format.html
      format.js
      format.csv
      format.xls
    end
  end

  #export csv contacts
  def csv_contacts
    @click_mode = params[:mode] if !params[:mode].nil?
    @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]] , :order => "contact_name ASC")
    @file=params[:checked]
    @test ="index"
    @con_group=[]
    @contact_users.each do |con|
      if !con.contact_name.nil? && con.contact_name.present?
        c_name = con.contact_name
      elsif !con.contact_email.nil? && con.contact_email.present?
        name= con.contact_email.split('@')
        c_name=name[0]
      else
        c_name = "-"
      end
      if !con.contact_email.nil? && con.contact_email.present?
        c_email = con.contact_email
      else
        c_email = "-"
      end
      if !con.contact_mobile.nil? && con.contact_mobile.present?
        c_mobie = con.contact_mobile
      else
        c_mobie = "-"
      end
      row = [c_name,c_email, c_mobie]
      @con_group<<row
    end
    respond_to do |format|
      format.csv
    end
  end

  #import csv contacts
  def file_import
    @before_import = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]] )
    @before= @before_import.length
    userid=current_user.user_id
    file=params[:csvfile]
    @test=[]
    @csvlist = []
    @c_id=[]
    begin
      #numrows = CSV.read(file.path)#.size
      CSV.foreach(file.path, headers: true) do |row|
        contact = row.to_hash # exclude the price field
        contact_user =ContactUser.where("contact_name=? and user_id=?",contact["Name"],cookies[:uid_usr])
        @old_contact = ContactUser.find_by_contact_email_and_user_id(contact["Email"],userid) if !contact["Email"].nil? && contact["Email"].present?
        if !contact["Email"].nil?
          @test << contact["Email"]
        elsif !contact["Name"].nil?
          @test << contact["Name"]
        elsif !contact["Mobile Number"].nil?
          @test << contact["Mobile Number"]
        end
          @csvlist << @old_contact if @old_contact
          @csvlist.count
        #if contact_user.count == 1
        #  contact_user.first.update_attributes(contact)
        #else
          if !@old_contact && !contact["Name"].nil? && contact["Name"].present? && contact["Email"]!="friend_email"
            @olduser= User.where("email_address = ?",contact["Email"])
            @oldcontact= ContactUser.where("contact_email = ? and user_id = ?",contact["Email"],userid)
            if @olduser.present? && @oldcontact.present?
              @contact_user_type = "friend"
            elsif @olduser.present?
              @contact_user_type = "member"
            else
              @contact_user_type = "non_member"
            end
            c_user= ContactUser.new
            c_user.contact_name= contact["Name"]  if contact["Name"]!="friend_name"
            c_user.contact_email= contact["Email"]
            if (!contact["Mobile Number"].nil? && contact["Mobile Number"].length==10)
              c_user.contact_mobile= contact["Mobile Number"]
            elsif (!contact["Mobile Number"].nil? && contact["Mobile Number"].length==12 && contact["Mobile Number"].at(3)=="-" && contact["Mobile Number"].at(7)=="-")
              c_user.contact_mobile= contact["Mobile Number"]
            elsif (!contact["Mobile Number"].nil? && contact["Mobile Number"].length==12 && contact["Mobile Number"].at(3)=="." && contact["Mobile Number"].at(7)==".")
              c_user.contact_mobile= contact["Mobile Number"]
            elsif (!contact["Mobile Number"].nil? && contact["Mobile Number"].length==16 && contact["Mobile Number"].at(0)=="(" && contact["Mobile Number"].at(4)==")" && contact["Mobile Number"].at(5)=="(" && contact["Mobile Number"].at(9)==")" && contact["Mobile Number"].at(10)=="(" && contact["Mobile Number"].at(15)==")")
              c_user.contact_mobile= contact["Mobile Number"]
            end
            c_user.contact_user_type= @contact_user_type
            c_user.user_id= userid
            c_user.inserted_date= Time.now
            c_user.modified_date= Time.now
            c_user.save
            @csvlist << c_user if c_user
            @get_current_url = request.env['HTTP_HOST']
            @contact_id = c_user.contact_id
            @user = current_user
            @to = contact["Email"]
            @name = contact["Name"]
            @old_email = User.find_by_email_address(contact["Email"])
            message =""
            #  if @old_email.nil?
            #     UserMailer.delay(queue: "Contact Create", priority: 2, run_at: 10.seconds.from_now).contact_register(@user, @get_current_url, @to, @contact_id, @name)
            # end
            old_user = User.where("email_address = ?",@to).first
            invitor_user = InvitorList.where("invited_email = ?",@to).first
            #if !old_user.present?
            #  if !invitor_user
            #    InvitorList.invitor_list(@to,current_user.user_id,'friend')
            #  else
            #    invitor_user.update_attributes(modified_date: Time.now)
            #  end
            #  UserMailer.delay(queue: "invite Message", priority: 2, run_at: 10.seconds.from_now).invite_to_join_famtivity(@to, @user, message, @get_current_url)
            #else
            #  UserMailer.delay(queue: "Contact Create", priority: 2, run_at: 10.seconds.from_now).contact_register(@user, @get_current_url, @to, @contact_id, @name)
            #end
          end
       # end
      end
      @csvlist.each do |c|
        @c_id<< c.contact_id if !c.nil?
      end
      cookies[:all_con]=@c_id
      @test.count
      @full_value=@test.count if !@test.nil?
      @after_import = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]] )
      @after=@after_import.length
      @now=@after-@before if !@after.nil? && !@before.nil?
      @fail=@full_value-@now if !@test.nil?
      respond_to do |format|
        format.js
      end
    rescue
      @after_import = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]] )
      @after=@after_import.length      
      respond_to do |format|
        format.js
      end
    end

  end

  def check_contact_invite
    @user = User.find_by_email_address(params[:email])
    if @user
      @user_exist = "failed"
      render :text=> @user_exist.to_json
    else
      @user_exist = "success"
      render :text=> @user_exist.to_json
    end
  end


  def check_contact_exist
    @contact_user = ContactUser.find_by_contact_email_and_user_id(params[:email],current_user.user_id)
    #@user = User.find_by_email_address(params[:email])
    @user=current_user.email_address == params[:email]

    if @user
      @contact_exist ="same_user"
      render :text=> @contact_exist.to_json
    elsif @contact_user
      @contact_exist = "failed"
      render :text=> @contact_exist.to_json
    else
      @contact_exist = "success"
      render :text=> @contact_exist.to_json
    end
  end

  # GET /contact_users/1
  # GET /contact_users/1.json
  def contact_detail
    if(params[:user_type] == "contacts")
      @contact_user = ContactUser.find(params[:id])
      @group_names = @contact_user.contact_groups.blank? ? nil : @contact_user.contact_groups.map(&:group_name)
    elsif(params[:user_type] == "network")
      @contact_user = ContactUser.find(params[:id])
      @group_names = @contact_user.contact_groups.blank? ? nil : @contact_user.contact_groups.map(&:group_name)
      @show_detail="true"
    elsif(params[:user_type] == "network_owner")
      @show_detail="true"
      @fam_group=ContactGroup.where(:group_id => params[:network_owner_id]).last
      @fam_owner = User.find_by_user_id(@fam_group.user_id)
    elsif(params[:user_type] == "users")
      @contact_user = User.find_by_user_id(params[:id])
    end
  end

  def contact_edit
    @contact_user = ContactUser.find(params[:id])
    @user = User.find(@contact_user.user_id)
    @group_names = @contact_user.contact_groups.blank? ? nil : @contact_user.contact_groups.map(&:group_name)
    @group_ids = @contact_user.contact_groups.blank? ? nil : @contact_user.contact_groups.map(&:group_id)
    @u_groups = @user.contact_groups
    @u_group_name = ContactGroup.find(@contact_user.group_id).group_name if !@contact_user.group_id.nil?
    
    respond_to do |format|
      if @contact_user.save
        @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]])
        format.js
      else
        @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]])
        format.js
      end
    end
  end

  # GET /contact_users/new
  # GET /contact_users/new.json
  def new
    @contact_user = ContactUser.new
    @user = User.find(current_user.id)
    @u_groups = @user.contact_groups
    @fam_last = params[:fam_last] if !params[:fam_last].nil?
  end

  def contact_create
    @old_email = User.find_by_email_address(params[:contact_email])
    @contact_user = ContactUser.new
    if params[:photo1] !="" && params[:photo1].present?
      #if params[:activity_image][:photo] !="" && params[:activity_image][:datafile] !=""
      @contact_user.contact = params[:activity_image][:datafile] if !params[:activity_image][:datafile].nil? && params[:activity_image][:datafile]!=""
    end
    @contact_user.user_id = cookies[:uid_usr]
    @contact_user.contact_name = params[:contact_name]
    @contact_user.contact_email = params[:contact_email]
    @contact_user.inserted_date = Time.now
    @contact_user.modified_date = Time.now
    @contact_user.fam_user_id = @old_email.user_id if !@old_email.nil? && !@old_email.user_id.nil?
    if params[:select_invite] !="" && params[:select_invite]=="1"
      @contact_user.invite_status = true
      cookies[:con_act]="create_invite"
      @success_message="You've successfully added a contact in Famtivity! An email has been sent to the contact with the invite."
    else
      cookies[:con_act]="create"
      @success_message="You've successfully added a contact in Famtivity!"
    end
    if !params[:profile_phone_1].nil? && params[:profile_phone_1].present? && !params[:profile_phone_2].nil? && params[:profile_phone_2].present? &&!params[:profile_phone_3].nil? && params[:profile_phone_3].present?
      @contact_mobile = "#{params[:profile_phone_1]}-" +"#{params[:profile_phone_2]}-"+"#{params[:profile_phone_3]}"
      if @contact_mobile !="xxx-xxx-xxxx"
        @contact_user.contact_mobile = @contact_mobile
      end
    end
    @contact_user.contact_user_type= ContactUser.choose_contact_type(params[:contact_email], current_user.user_id)
    #@contact_user.contact_mobile = params[:contact_mobile]
    @contact_user.contact_type = "famtivity"
    if @contact_user.save
      @contact_id = @contact_user.contact_id
      @user = current_user
      # add multiple grops for creat
      @to = params[:contact_email]
      @name = params[:contact_name]
      message =""
      @get_current_url = request.env['HTTP_HOST']
      old_user = User.where("email_address = ?",@to).first
      invitor_user = InvitorList.where("invited_email = ?",@to).first
      if(!params[:edit_group_ids].blank?)
        checked_group = params[:edit_group_ids].split(',')
        checked_group.each do |g_id|
          #Assign this new contact to selected group
          @group = ContactGroup.where("group_id = ? and user_id = ?",g_id, @contact_user.user_id).first if !g_id.nil? && g_id!=""
  
          if(!@group.blank?)
            @group_user = ContactUserGroup.new(:user_id => @contact_user.user_id, :contact_user_id => @contact_user.contact_id, :contact_group_id => @group.group_id)
            @group_user.inserted_date = Time.now
            @group_user.modified_date = Time.now
            if !old_user.nil?
              @group_user.fam_accept_user_id = old_user.user_id
            end
            @group_user.save
            if !old_user.nil?
              FamtivityNetworkMailer.delay(queue: "Fam Network Non Friend", priority: 2, run_at: 10.seconds.from_now).network_member_invite_mail(@user,@group,@to,@get_current_url,old_user,@contact_user.contact_id,message)
            else
              FamtivityNetworkMailer.delay(queue: "Fam Network Invite to join", priority: 2, run_at: 10.seconds.from_now).network_to_join_famtivity(@user,@group,@to,@get_current_url,@contact_user,message)
            end 
          end
        end
      else
        if !old_user.present?
          if !invitor_user
            InvitorList.invitor_list(@to,current_user.user_id,'friend')
          else
            invitor_user.update_attributes(modified_date: Time.now)
          end
          UserMailer.delay(queue: "invite Message", priority: 2, run_at: 10.seconds.from_now).invite_to_join_famtivity(@to, @user, message, @get_current_url)
        else
          #UserMailer.delay(queue: "Contact Create", priority: 2, run_at: 10.seconds.from_now).contact_register(@user, @get_current_url, @to, @contact_id, @name)
          if params[:select_invite] !="" && params[:select_invite]=="1"
            UserMailer.delay(queue: "Send Friend Request", priority: 2, run_at: 10.seconds.from_now).friend_request(@contact_user,@user,@get_current_url)
          end
        end
      end  
      render :partial =>'create_contact_success'
    end
  end
  # GET /contact_users/1/edit

  def edit
    @contact_user = ContactUser.find(params[:id])
  end

  # POST /contact_users
  # POST /contact_users.json
  def create
    @contact_user = ContactUser.new(params[:contact_user])

    respond_to do |format|
      if @contact_user.save
        format.html { redirect_to @contact_user, :notice => 'Contact user was successfully created.' }
        format.json { render :json => @contact_user, :status => :created, :location => @contact_user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @contact_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contact_users/1
  # PUT /contact_users/1.json


  def contact_update
    @old_email = User.find_by_email_address(params[:contact_user][:contact_email])
    @contact_user = ContactUser.find(params[:id])
    @contact_user.contact = params[:contact_user][:contact] if !params[:contact_user][:contact].nil? && params[:contact_user][:contact]!=""
    @contact_user.contact_name = params[:contact_user][:contact_name]
    @contact_user.contact_email = params[:contact_user][:contact_email]
    @contact_user.fam_user_id = @old_email.user_id if !@old_email.nil? && !@old_email.user_id.nil?
    @mobile_value = "#{params[:contact_user][:profile_phone_1]}-" +"#{params[:contact_user][:profile_phone_2]}-" +"#{params[:contact_user][:profile_phone_3]}"
    @contact_user.contact_mobile = @mobile_value
    @contact_user.contact_user_type= ContactUser.choose_contact_type(params[:contact_user][:contact_email], current_user.user_id)
    #finding groups
    @group_ids = params[:edit_group_ids]
    @group = @group_ids.split(",")
    @groups = ContactGroup.find(:all, :conditions => ["user_id=? and group_id IN (?)", cookies[:uid_usr], @group])
    #assign contacts to groups
    # msg = "#{@contact_user.contact_name.capitalize} is already assigned to "
    # @error_arr = []
    # @groups.each do |group|
    # @group_user = ContactUserGroup.where("user_id = ? and contact_group_id = ? and contact_user_id = ?", cookies[:uid_usr], group.group_id , @contact_user.contact_id)
    # if(@group_user.blank?)
    # @group_user = ContactUserGroup.new(:user_id => cookies[:uid_usr], :contact_user_id => @contact_user.contact_id, :contact_group_id => group.group_id)
    # @group_user.inserted_date = Time.now
    # @group_user.modified_date = Time.now
    # @group_user.save
    # else
    # @error_arr << "#{group.group_name}"
    # end
    # end
    #@error_msg = msg + @error_arr.join(",") if !@error_arr.blank?
    @contact_user.save
    @error_arr = []
    @error_msg = ""
    if params[:update_group_ids] == "true"
      @contact_user.contact_user_groups.collect{|g| g.delete}
      !@groups.blank? && @groups.each do |group|
        @group_user = ContactUserGroup.new(:user_id => cookies[:uid_usr], :contact_user_id => @contact_user.contact_id, :contact_group_id => group.group_id)
        @group_user.inserted_date = Time.now
        @group_user.modified_date = Time.now
        @group_user.save
      end
    end
    render :partial =>'edit_contact_success'
  end

  # DELETE /contact_users/1
  # DELETE /contact_users/1.json
  def destroy
    @get_current_url = request.env['HTTP_HOST']
    @contact_flag = false
    @group_flag = false
    contact= params[:id].split(",")
    cookies[:con_act]="delete"
    contact.each do |c|
      if c!=''
        @contact_flag = true
        @contact_user = ContactUser.find(c)
        @contact_user.destroy
      end
    end if !contact.nil? && contact.length > 0
    @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]], :order => "contact_name ASC")
    @all_users = @contact_users
    #group delete
    groupid = params[:groupid].split(",") if !params[:groupid].nil? && params[:groupid]!=''
    groupid.each do |gval|
      if gval!=''
        @group_flag = true
        @group = ContactGroup.find(gval)
  @bef_del = ContactUserGroup.where("contact_group_id=? and fam_accept_status=?",@group.group_id,true).map(&:contact_user_id)
  FamtivityNetworkMailer.delay(queue: "Fam Network Delete", priority: 2, run_at: 10.seconds.from_now).fam_network_delete_to_owner(current_user,@group.group_name,@get_current_url)
        #Notification after deleting the Fam Network
  MessageThread.send_notification_network(@bef_del,current_user,@group,@get_current_url)
        #Notification after deleting the Fam Network
        @group.destroy
      end
    end if !groupid.nil? && groupid.length > 0
    @contact_groups= ContactGroup.find(:all,:conditions=>["user_id = ? ",  cookies[:uid_usr]], :order => "group_name ASC")
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
    #end
    @contact_exist = "failed"
    #render :text=> @contact_users.to_json
    respond_to do |format|
      format.js
    end
  end
  
  def delete
    @to_delete = params[:id]
    @group_id = params[:groupid]
    @contact= @to_delete.split(",")
    @group_delete=@group_id.split(",")
  end
  
  def delete_empty
    @type = params[:type]
    @to_delete = params[:id]
  end

 
  def select_mail
    @to_delete = params[:id]
    @contact= @to_delete.split(",")
    @s_mail = ContactUser.find(@contact)
    @group= @s_mail.collect{|f|f["contact_email"]}.join(',')
    @group1 = @group.gsub(",","")
    @group_email = @group1.gsub(".com",".com,").gsub(".in",".in,")

  end
  
  def select_mail_empty
    @to_delete = params[:id]
  end

  def contact_import
    @user = User.find(current_user.id)
  end

  def contact_store
    @user = User.find(current_user.id)

    params[:subList].each do |co|
      val = co.split("-")
      @friend = ContactUser.new(:contact_email => val[0], :contact_name => val[1],  :user_id => current_user.id )
      @friend.save
    end
    #redirect_to contact_users_path
    render :action=>"contact_store"
  end


  def add_contact_success
    if !params[:subList].nil?
      contact_type = cookies[:from]
      @c_old =[]
      @c_id =[]
      @sublist = []
      @sublist << params[:subList]
      @s_value = params[:subList].count
      @pre_con=ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]])
      params[:subList].each do |co|
        @val = co.split("^")
        @old_email = User.find_by_email_address(@val[0])
        @old_contact = ContactUser.find_by_contact_email_and_user_id(@val[0],current_user.user_id)
        @sameuser = current_user.email_address==@val[0]
        if !@old_contact && !@sameuser
          @friend = ContactUser.new(:contact_email => @val[0], :contact_name => @val[1],  :user_id => current_user.id, :contact_type => contact_type, :inserted_date=>Time.now, :modified_date => Time.now)
          @friend.contact_user_type = ContactUser.choose_contact_type(@val[0], current_user.user_id)
          @friend.fam_user_id = @old_email.user_id if !@old_email.nil? && !@old_email.user_id.nil?
          @friend.save
        else
          @c_old << @old_contact
        end
        #group_old_email= @c_old.collect{|f|f["contact_email"]}.join(',')
        @g1 =@c_old.count
        @group = @s_value - @g1
      end
      @cur_con=ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]])
      @rm_con=@cur_con - @pre_con if !@cur_con.nil? && !@pre_con.nil?
      @contact=@rm_con + @c_old
      @contact.each do |c|
        @c_id<< c.contact_id if !c.nil?
      end
      cookies[:all_con]=@c_id
      respond_to do |format|
        if params[:invite].nil?
          @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]])
          format.html {render :template => 'contact_users/add_contact_success', :layout => false}
        else
          format.html {render :template => 'contact_users/gmail_contact_success', :layout => false}
        end
      end
    end
  end

  def contact_fail

  end

  def invite_friend_famtivity
    cookies.delete :f_invited_user
    @click_mode = params[:mode] if !params[:mode].nil?
    cookies[:friend_mode] = params[:mode] if !params[:mode].nil?
    if !params[:fam_net_id].nil?
      cookies[:fam_network] = params[:fam_net_id]
      @con = ContactGroup.where("group_id=?", params[:fam_net_id]).last
      cookies[:follow_cat_val]=@con.group_name
    else
      cookies[:fam_network] = nil
    end
    @fam_last=params[:fam_last] if !params[:fam_last].nil?
    @get_current_url = request.env['HTTP_HOST']
    @con=[]
    @all_con=""
    @all_con=cookies[:all_con] if !cookies[:all_con].nil?
    @sp_con=@all_con.split('&') if !cookies[:all_con].nil?
    @sp_con.each do |d|
      @contact_users = ContactUser.where("contact_id=?",d).last
      @con<< @contact_users
    end if !@sp_con.nil?
    @contacts = @con if !@con.nil?
    @check = params[:check_invite]
    @reld = params[:reld]
    @fb_val = params[:fb_val] if !params[:fb_val].nil?
    @all_users = User.select("email_address,user_name").where("user_flag=? and account_active_status=?",true,true)
    #.map(&:email_address)
    render :partial => 'invite_friend', :locals => { :check => @check, :all_users => @all_users, :reld => @reld ,:fb_val => @fb_val}
  end
  
  #Auto Populating email to invite friends
  def populate_email
    params[:query] = params[:query].blank? ? "" : params[:query]
    @user_email=[]
    @email = ContactUser.find_all_by_user_id(current_user.user_id).uniq#.map(&:contact_email)
    @email.each do |email|
      if !email.contact_email.blank?
        if(!params[:query].blank? && !email.contact_email.downcase.scan(params[:query].downcase).blank?)
          @user_email << {"id" => email.contact_id,"label" => "#{email.contact_name}, #{email.contact_email}","value" => email.contact_email}
        end
      end
    end
   
    render :json => @user_email
  end


  def facebook_contact_list
    @contacts = request.env['omnicontacts.contacts']
    @user_contacts = request.env['omnicontacts.user']
    #code= request.env['omnicontacts.access_token']
    #@code= request.env["QUERY_STRING"]
    #@code= request.env['omniauth.auth']
  end


  def contact_list
    @contacts = request.env['omnicontacts.contacts']
  end

  def yahoo_contact_list
    @contacts = request.env['omnicontacts.contacts']
  end


  def facebook_contact_success
    if !params[:subList].nil?
      @c_old =[]
      @sublist = []
      @sublist << params[:subList]
      @s_value = params[:subList].count
      @c_id =[]
      @pre_con=ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]])
      params[:subList].each do |co|
        val = co.split("^")
        @old_email = User.find_by_fb_id(val[0])
        @old_contact = ContactUser.find_by_profile_id_and_user_id(val[0],current_user.user_id)
        if !@old_contact
          @friend = ContactUser.new(:profile_id => val[0], :contact_name => val[1] , :user_id => current_user.id, :contact_type => "facebook", :inserted_date=>Time.now, :modified_date => Time.now)
          @friend.contact_user_type = ContactUser.fb_choose_contact_type(val[0],current_user.user_id)
          @friend.fam_user_id = @old_email.user_id if !@old_email.nil? && !@old_email.user_id.nil?
          @friend.save
        else
          @c_old << @old_contact
        end
        @g1 =@c_old.count
        @group = @s_value - @g1
      end
      @cur_con=ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]])

      @rm_con=@cur_con - @pre_con if !@cur_con.nil? && !@pre_con.nil?
      @contact=@rm_con + @c_old
      @contact.each do |c|
        @c_id<< c.contact_id if !c.nil?
      end
      cookies[:all_con]=@c_id
    end
    respond_to do |format|
      format.html {render :template => 'contact_users/facebook_contact_success', :layout => false}
      #format.xml {render :xml => @contacts.to_xml} #access_token
    end
  end

  def fb_invite
    if !params[:reciver_id].nil? && params[:reciver_id].present? && params[:reciver_id]!=""
      @fb_reciver=ContactUser.find_by_contact_id(params[:reciver_id])
      @fb_reciver.update_attributes(:invite_status=>true, :modified_date=>Time.now);
      @c_page= params[:c_page] if !params[:c_page].nil? && params[:reciver_id]!=""
      @reld=true
      @fb_val=true
      @get_current_url = request.env['HTTP_HOST']
      @con=[]
      @all_con=""
      @all_con=cookies[:all_con] if !cookies[:all_con].nil?
      @sp_con=@all_con.split('&') if !cookies[:all_con].nil?
      @sp_con.each do |d|
        @contact = ContactUser.where("contact_id=?",d).last
        @con<< @contact
      end if !@sp_con.nil?
      @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]] , :order => "contact_name ASC")
      @contacts = @con if !@con.nil?
      respond_to do |format|
        format.js
      end
    end

  end
 
  def contact_create_message
    @arr = []
    @s_mail = []
    #@mails = params[:mail]
    #@contacts = @mails.split(",")
    #@smail = []
    #@arrs = ContactUser.find(@contacts)
    #@arrs.each do |a|
    # @tt =a.profile_id
    #  @smail << @tt if !@tt.nil?
    #end
    #p @smail if !@smail.nil?
    #p "1111111"
    #finding contact users
    if(!params[:mail].blank? && params[:mail]!="undefined")
      @mail = params[:mail]
      @contact = @mail.split(",")
      @arr = ContactUser.where("contact_id IN (?)",@contact)
    end
    #finding group users
    if(!params[:group_mail].blank? && params[:group_mail]!="undefined")
      group = params[:group_mail].split(",")
      @group = ContactGroup.where("group_id IN (?)",group)
      @users = @group.collect{|g| g.contact_users}.flatten
      @users.each do |user|
        @s_mail << user
      end
    end
    @arr.each do |a|
      @s_mail << a
    end
    @arr_list = []
    #finding activity group users
    if(!params[:act_mail].blank? && params[:act_mail]!="undefined")
      act = params[:act_mail].split(",")
      @activity_groups = ActivityAttendDetail.where("activity_id IN (?)",act).group_by(&:activity_id).to_a
      @users = []
      @activity_groups.each do |group|
        activity = find_activity_record(group[0])
        @users << find_parents(activity.id)
      end
      @users = !@users.blank? ? @users.flatten : []
      @users && @users.each do |user|
        @arr_list << user
      end
    end
    @email= @s_mail.collect{|f|f["contact_email"]}
    @p_ids= @s_mail.collect{|f|f["profile_id"]}
    if(!params[:act_mail].blank? && params[:act_mail]!="undefined")
      @arr_list.each do |user|
        @email << user["email_address"]
        @p_ids << user["fb_id"]
      end
    end
    @fb = @p_ids.to_s.gsub(" nil,","").gsub(/nil/, '')
    if @fb==", "
      @fb_id=""
    else
      @fb_id=@fb
    end
    @email_str= @email.to_s
    @email_split=@email_str.gsub(" nil,","").gsub("[","").gsub("]","").gsub(/"/, '').gsub(/nil/, '')
    if @email_split==", "
      @email_value=@email_split.gsub(", ","")
      @facebook="empty"
    else
      @email_value = @email_split
    end

    #@email_value
    
  end


  def contact_send_message
    @mail = params[:mail]
    if !params[:mail].nil?
      name = params[:mail].split("@")
      @name = name[0]
      @message = "Hi #{@name.titlecase+"\n\n"}Please join me on famtivity, the family activity network! #{"\n"}I think you'll really enjoy it.#{"\n\n"+current_user.user_name.titlecase} "
    end
  end

  def send_message
    @fb= params[:fb_ids] if !params[:fb_ids].nil? && params[:fb_ids].present?
    @fb_ids=@fb.gsub(/"/, '')
    p @fb_ids
    @user= current_user
    @to =params[:cre_to_msg]
    @subject = params[:subject_cre]
    @message = params[:redactor_content].gsub(/<br><br>/, ' ').gsub(/<br>/, ' ')
    #@image = params[:create_message]
    @get_current_url = request.env['HTTP_HOST']
    if !params[:cre_to_msg].nil?
      name = params[:cre_to_msg].split("@")
      @name = name[0]
    end
    @message_vaule = params[:pass_msg]
    @contact_groups = ContactGroup.find(:all,:conditions=>["user_id = ?", cookies[:uid_usr]] , :order => "group_name ASC")
    # Finding Activity Groups
    # @arr = []
    # activity_groups = ActivityAttendDetail.where(:user_id=>current_user.user_id)
    # @activity_groups = activity_groups.group_by(&:activity_id).to_a
    # @arr = activity_groups.map(&:user_id)
    # @activity_users = User.where("user_id IN (?)",@arr)
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
    #end
    respond_to do |format|
      @files = Dir.glob("#{Rails.root}/public/contact_users_upload/#{current_user.user_id}/*")
      if @files != nil && !@files.nil? && @files.present?
        @old_email = User.find_by_email_address(params[:cre_to_msg])

        if !@old_email.nil? && @old_email.present? && @old_email!=''
          if@old_email.user_flag==TRUE
            UserMailer.delay(queue: "Send Message", priority: 2, run_at: 10.seconds.from_now).send_image_message(@user, @subject, @message, @files, @to, @get_current_url, @name)
          end
        else
          UserMailer.delay(queue: "Send Message", priority: 2, run_at: 10.seconds.from_now).send_image_message(@user, @subject, @message, @files, @to, @get_current_url, @name)
        end

        #redirect_to contact_users_path
        @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]])
        @all_users = @contact_users
        format.js
      else
        @old_email = User.find_by_email_address(params[:cre_to_msg])

        if !@old_email.nil? && @old_email.present? && @old_email!=''
          if@old_email.user_flag==TRUE
            UserMailer.delay(queue: "Send Message", priority: 2, run_at: 10.seconds.from_now).send_message(@user, @subject, @message, @to)
          end
        else
          UserMailer.delay(queue: "Send Message", priority: 2, run_at: 10.seconds.from_now).send_message(@user, @subject, @message, @to)
        end

        @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]], :order => "contact_name ASC")
        @all_users = @contact_users
        format.js
        # redirect_to contact_users_path
      end
    end
  end
  
  def invite_friend
    @to = current_user.user_id
    @user = ContactUser.find(:all, :include => :user, :conditions => ["contact_users.contact_email = users.email_address"])
    gmail = ContactUser.find(:all,:conditions=> ['contact_type LIKE ? AND user_id = ?', 'gmail%', current_user.user_id])                            # field2 LIKE '%roger%'
    @gmail_contacts = ContactUser.find(:all,:conditions=> ['contact_type LIKE ? AND user_id = ?', 'gmail%', current_user.user_id], :order => "contact_id DESC")
    @yahoo_contacts = ContactUser.find(:all,:conditions=> ['contact_type LIKE ? AND user_id = ?', 'yahoo%', current_user.user_id])
    @hotmail_contacts = ContactUser.find(:all,:conditions=> ['contact_type LIKE ? AND user_id = ?', 'hotmail%', current_user.user_id])
    @facebook_contacts = ContactUser.find(:all,:conditions=> ['contact_type LIKE ? AND user_id = ?', 'facebook%', current_user.user_id], :order => "contact_id DESC")
    #@famtivity_contacts = ContactUser.find(:all,:conditions=> ['contact_type LIKE ? AND user_id = ?', 'famtivity%', current_user.user_id]) .order("id DESC")
    @famtivity_contacts= User.find(:all)
    @user= current_user
    @to =params[:cre_to_msg]
    @subject = params[:subject_cre]
    @message = params[:redactor_content]
    @get_current_url = request.env['HTTP_HOST']
    if !params[:cre_to_msg].nil?
      name = params[:cre_to_msg].split("@")
      @name = name[0]
      if !params[:create_message].nil?
        file_data = params[:create_message]
        if file_data.respond_to?(:read)
          str_to_encode = file_data.read
          @image = str_to_encode
        else file_data.respond_to?(:path)
          str_to_encode = File.read(file_data.path)
          @image = str_to_encode
        end
        @old_email = User.find_by_email_address(params[:cre_to_msg])

        if !@old_email.nil? && @old_email.present? && @old_email!=''
          if@old_email.user_flag==TRUE
            UserMailer.delay(queue: "invite Message", priority: 2, run_at: 10.seconds.from_now).send_image_message(@user, @subject, @message, @image, @to, @get_current_url, @name)
          end
        else
          UserMailer.delay(queue: "invite Message", priority: 2, run_at: 10.seconds.from_now).send_image_message(@user, @subject, @message, @image, @to, @get_current_url, @name)
        end


      end

      @old_email = User.find_by_email_address(params[:cre_to_msg])

      if !@old_email.nil? && @old_email.present? && @old_email!=''
        if@old_email.user_flag==TRUE
          UserMailer.delay(queue: "invite Message", priority: 2, run_at: 10.seconds.from_now).send_message(@user, @subject, @message, @to)
        end
      else
        UserMailer.delay(queue: "invite Message", priority: 2, run_at: 10.seconds.from_now).send_message(@user, @subject, @message, @to)
      end
      #redirect_to :back
      #redirect_to contact_users_path
    end
  end

  def contact_invite
    @contact = ContactUser.find(params[:id])
    @contact_id = params[:id]
    @user= current_user
    @to = params[:mail]
    @get_current_url = request.env['HTTP_HOST']

    @old_email = User.find_by_email_address(params[:mail])

    if !@old_email.nil? && @old_email.present? && @old_email!=''
      if@old_email.user_flag==TRUE
        UserMailer.delay(queue: "Invite Message", priority: 2, run_at: 10.seconds.from_now).contact_invite(@user, @get_current_url, @to, @contact_id)
      end
    else
      UserMailer.delay(queue: "Invite Message", priority: 2, run_at: 10.seconds.from_now).contact_invite(@user, @get_current_url, @to, @contact_id)
    end
  end


  
  def multi_email
    #contactss= params[:subList].to_a
    contactss= params[:cre_to_msg].to_s.gsub("[", '').gsub("]", '')
    contact =contactss.split(",")
    user= current_user
    message = params[:message].gsub("\r\n", "<br>") if !params[:message].nil?
    get_current_url = request.env['HTTP_HOST']
    contact.each do |d|
      c = d.gsub(/"/, '').strip
      invited_user = c
      @contact_exist=ContactUser.where("contact_email = ? and user_id=?",c,current_user.user_id).first
      if !@contact_exist.nil?
        @contact_exist.update_attributes(:invite_status => true, :modified_date=>Time.now)
      end
      
      old_user = User.where("email_address = ?",c).first
      invitor_user = InvitorList.where("invited_email = ?",c).first
      if !old_user.present?
        if !invitor_user
          InvitorList.invitor_list(c,current_user.user_id,'friend')
        else
          invitor_user.update_attributes(modified_date: Time.now)
        end
        if cookies[:fam_network].nil? 
          UserMailer.delay(queue: "invite Message", priority: 2, run_at: 10.seconds.from_now).invite_to_join_famtivity(invited_user, user, message,get_current_url)
        end
        #~ check_user = false
      else
        if cookies[:fam_network].nil? 
          #UserMailer.delay(queue: "Send Friend Request", priority: 2, run_at: 10.seconds.from_now).friend_request_fam_member(old_user,user,get_current_url)
          UserMailer.delay(queue: "Send Friend Request", priority: 2, run_at: 10.seconds.from_now).friend_request(@contact_exist,user,get_current_url) 
        end
      end
      if !cookies[:fam_network].nil? && cookies[:fam_network]!=""
        @contact_exist = ContactUser.find_by_contact_email_and_user_id(c,current_user.user_id) if !current_user.nil?
        if !@contact_exist.nil?
          @fam = ContactGroup.where("group_id ='#{cookies[:fam_network]}'").last
          @old_user = "raja"
          @fam_net = ContactUserGroup.where("contact_group_id ='#{cookies[:fam_network]}' and contact_user_id='#{@contact_exist.contact_id}'").last
          if @fam_net.nil?
            c_user= ContactUserGroup.new
            c_user.contact_user_id = @contact_exist.contact_id
            c_user.contact_group_id = cookies[:fam_network]
            c_user.user_id= current_user.user_id
            if !old_user.nil?
              c_user.fam_accept_user_id = old_user.user_id
            end
            c_user.save!
          end
          if !old_user.nil?
            if @contact_exist.contact_user_type == "friend"
              FamtivityNetworkMailer.delay(queue: "Fam Network Friend", priority: 2, run_at: 10.seconds.from_now).network_friend_invite_mail(user,@fam,c,get_current_url,old_user,@contact_exist.contact_id,message)
            else
              FamtivityNetworkMailer.delay(queue: "Fam Network Non Friend", priority: 2, run_at: 10.seconds.from_now).network_member_invite_mail(user,@fam,c,get_current_url,old_user,@contact_exist.contact_id,message)
            end
          else
            FamtivityNetworkMailer.delay(queue: "Fam Network Invite to join", priority: 2, run_at: 10.seconds.from_now).network_to_join_famtivity(user,@fam,c,get_current_url,@contact_exist,message)
          end
        end
      end
    end

    #render :action=>"invite_success_page"
    #  respond_to do |format|
    #       format.html {render :action=>"invite_success_page", :layout => false}
    #   end
    # render :partial =>'invite_friend_succ'
  end



  def multi_email_old
    @mail = params[:cre_to_msg]
    @contact= @mail.split(",")
    @s_mail = ContactUser.find(@contact)
    @email= @s_mail.collect{|f|f["contact_email"]}
    @invite_email= @email.to_s.gsub(" nil,","").gsub("nil", "").gsub(/"/, '')
    @p_ids= @s_mail.collect{|f|f["profile_id"]}
    @fb_split = @p_ids.to_s.gsub(" nil,","").gsub(/nil/, '').gsub(/"/, '')
    if @fb_split=="[]"
      @fb=""
    else
      @fb=@fb_split
    end
    #contactss= params[:subList].to_a
    contactss= @invite_email.to_s.gsub("[", '').gsub("]", '')
    contact =contactss.split(",")
    user= current_user
    message = params[:message].gsub("\r\n", "<br>") if !params[:message].nil?
    get_current_url = request.env['HTTP_HOST']
    contact.each do |d|
      c = d.gsub(/"/, '')
      if c!=""
        invited_user = c
        old_user = User.where("email_address = ?",c).first
        invitor_user = InvitorList.where("invited_email = ?",c).first
        if !old_user.present?
          if !invitor_user
            InvitorList.invitor_list(c,current_user.user_id,'friend')
          else
            invitor_user.update_attributes(modified_date: Time.now)
          end
          UserMailer.delay(queue: "invite Message", priority: 2, run_at: 10.seconds.from_now).invite_to_join_famtivity(invited_user, user, message,get_current_url)
          #~ check_user = false
        end
      end
    end


    respond_to do |format|
      format.html {render :partial =>'invite_friend_succ'}
    end

    #render :partial =>'invite_friend_succ'
  end
  
  def check_repeated_users
    contactss= params[:cre_to_msg].to_s.gsub("[", '').gsub("]", '').gsub("\"", '').gsub(" ", '')
    contact= contactss.split(",")
    @rep_users = ""

    if !cookies[:fam_network].nil? && !params[:check_fam_id].nil? && params[:check_fam_id].present? && params[:check_fam_id]!=""
     @fam_users = ContactUser.find_by_sql("select * FROM contact_users
                                        INNER JOIN contact_user_groups as fam
                                        ON contact_users.contact_id = fam.contact_user_id and fam.contact_group_id='#{params[:check_fam_id]}'")
      contact.each do |con|
      same_email=current_user.email_address==con
      user_id=ContactGroup.where("group_id=?",cookies[:fam_network]).map(&:user_id) if !cookies[:fam_network].nil? && cookies[:fam_network].present? 
      email=User.where("user_id=?",user_id).map(&:email_address) if !user_id.nil?
      owner=(email[0]==con) if !cookies[:fam_network].nil? && cookies[:fam_network].present?
      if owner
        @rep_users.concat("owner")
      elsif same_email
            @rep_users.concat("your")
      else 
       @fam_users.each do |user|
       old_fam_net=((user.fam_accept_status=="t")&&(user.contact_email==con))
        if old_fam_net.present?
            if @rep_users.empty?
              @rep_users.concat("#{user.contact_email}")
            else
              if @rep_users!=user.contact_email
                @rep_users.concat(",#{user.contact_email}")
              end
            end
         end
       end
       end#same_email end
       end#do end
    #  elsif !cookies[:fam_network].nil? && cookies[:fam_network]!=""
    #     p "22222222"
    #  contact.each do |user|
    #    con_d = ContactUser.where("contact_email = ? and user_id = ?",user,current_user.user_id).last
    #    if con_d.present?
    #      chk_user = ContactUserGroup.where("contact_user_id = ? and contact_group_id =? and fam_accept_status =? ",con_d.contact_id,cookies[:fam_network],true).last
    #      if chk_user.present?
    #        if @rep_users.empty?
    #          @rep_users.concat("#{user}")
    #        else
    #          @rep_users.concat(",#{user}")
    #        end
    #      end
    #    end
    #  end
    # end
    else
      contact.each do |user|
        if (params[:type].present? && params[:type]=="inv_provider")
          chk_user = User.where("user_type = ? and email_address = ?", 'P',user).first
        else
          chk_user = User.where("email_address = ?", user).first
        end
        if chk_user.present?
          if @rep_users.empty?
            @rep_users.concat("#{user}")
          else
            @rep_users.concat(",#{user}")
          end
        end
      end
    end
    render :text => @rep_users
  end

  def check_same_users
    contactss= params[:cre_to_msg].to_s.gsub("[", '').gsub("]", '').gsub("\"", '').gsub(" ", '')
    contact= contactss.split(",")
    @same_users = []
    contact.each do |user|
     @same_users<< "your" if current_user.email_address==user 
    end
    render :text => @same_users
  end
  
  def req_multi_email
    @to_delete = params[:ids]
    @curr_user = current_user
    contact= params[:ids].split(",")
    get_current_url = request.env['HTTP_HOST']
    contact.each do |cont|
      contact_user = ContactUser.find(cont)
      old_user = User.where("email_address=?",contact_user.contact_email).first
      invitor_user = InvitorList.where("invited_email=?",contact_user.contact_email).first
      if (params[:request] == "new_invite" && !old_user)
        if (!invitor_user)
          InvitorList.invitor_list(contact_user.contact_email,current_user.user_id,'friend')
        else
          invitor_user.update_attributes(modified_date: Time.now)
        end
        message = ""
        contact_user.update_attributes(:invite_status=>true, :modified_date=>Time.now)
        #invite_status == true
        UserMailer.delay(queue: "invite Message", priority: 2, run_at: 10.seconds.from_now).invite_to_join_famtivity(contact_user.contact_email, @curr_user, message,get_current_url)
      elsif (params[:request] == "friend_invite")
        contact_user.update_attributes(:invite_status=>true, :modified_date=>Time.now)
        UserMailer.delay(queue: "Send Friend Request", priority: 2, run_at: 10.seconds.from_now).friend_request(contact_user,@curr_user,get_current_url)
      end
    end
    activities = Activity.where(:user_id => current_user.user_id, :created_by => "Provider", :cleaned => true, :active_status => "Active")
    act_ids = !activities.blank? ? activities.map(&:id) : []
    @activity_groups = ActivityAttendDetail.where("activity_id IN (?)",act_ids).group_by(&:activity_id).to_a
    @contact_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]] , :order => "contact_name ASC")
    @activity_users = []
    @users = []
    activity_ids = []
    @activity_groups.each do |group|
      activity = find_activity_record(group[0])
      activity_ids << activity.id
      @users << find_parents(activity.id).map(&:id)
    end
    @users = @users.flatten
    activity_ids = activity_ids.flatten
    @activity_users = User.where("user_id IN (?)",@users)
    activities = Activity.where("activity_id IN (?)",activity_ids)
      if !params[:group_id].nil? && params[:group_id].present?
        @status_id = params[:group_id] 
        @fam_group=ContactGroup.where(:group_id => @status_id).last
        @fam_owner=User.find_by_user_id(@fam_group.user_id)
        @fam =ContactUser.find_by_sql("select * FROM contact_users INNER JOIN contact_user_groups as fam ON 
          contact_users.contact_id = fam.contact_user_id and fam.contact_group_id='#{@status_id}'")
     end
    respond_to do |format|
      format.js
      format.html
    end
  end
  

 
  def import_contact
    @user = User.find(current_user.id)
    if params[:from] && !params[:from].blank? && params[:login] && !params[:login].blank? && params[:password] && !params[:password].blank?
      begin
        @sites = {"hotmail" => Contacts::Hotmail, "gmail"  => Contacts::Gmail, "yahoo" => Contacts::Yahoo }
        authenticated_user = @sites[params[:from]].new(params[:login], params[:password])
        @contacts = authenticated_user.contacts if authenticated_user
        cookies[:from] = params[:from]
        respond_to do |format|
          format.html {render :template => 'contact_users/_contact_list', :layout => false}
        end
      rescue
        #flash.now[:error] = "Password and mail id mismatch"
        respond_to do |format|
          cookies[:from] = params[:from]
          format.html {render :template => 'contact_users/_new_import'}
        end
      end
    else
      #flash.now[:error]="Please enter all fields"
      cookies[:from] = params[:from]
      render :action=>"new_import"
    end
  end

  def new_import

  end

  def gmail_import

  end

 
  #searching the contact user.
  def search_contact_user
    #params[:contact_user] = params[:contact_user]!="" ? params[:contact_user] : "Search for Friend"
    @con=params[:contact_user].split(',') if !params[:contact_user].nil?
    @con_name=@con[0] if !params[:contact_user].nil?
    @con_name if @con_name!=""
    params[:user_id] if params[:user_id]!=""
    params[:search_key] if params[:search_key]!=""
    @search ="search"
    @get_current_url = request.env['HTTP_HOST']
    @groups = ContactGroup.find(:all,:conditions=>["user_id = ? ", params[:user_id]], :order => "group_name ASC")
    @all_users = ContactUser.find(:all,:conditions=>["user_id = ? ", cookies[:uid_usr]] , :order => "contact_name ASC")
    if @con_name != "" && !params[:user_id].nil?
      @contact_groups = ContactGroup.search_contactgroup(@con_name,params[:user_id],params[:represented]) if @con_name.present? && params[:user_id].present?
      @contact_users = ContactUser.search_contactuser(@con_name,params[:user_id],params[:search_key]) if @con_name.present? && params[:user_id].present?
      @activity_groups = Activity.search_activitygroup(@con_name,params[:user_id],params[:represented]) if @con_name.present? && params[:user_id].present?
      @activity_users = User.search_activityuser(@con_name,params[:user_id],params[:represented]) if @con_name.present? && params[:user_id].present?
    else
      @contact_groups = []
      @contact_users = []
      @activity_groups = []
      @activity_users = []
    end
  end
  
  #To find famtivity members in contact drop down
  def search_famtivity_members
    if params[:key_word]
      @key_word=params[:key_word]
      @fam_mem = User.where("email_address LIKE ? and user_flag=?","%#{params[:key_word]}%",true)
      render :partial => "famtivity_members_list"
    end
  end
  #To send friend request in the famtivity members
  def send_friend_request
    @user_mem = User.where("email_address = ?", params[:contact_email]).first
    @curr_user = current_user
    
    @get_current_url = request.env['HTTP_HOST']
    @contact_exist = ContactUser.find_by_contact_email_and_user_id(params[:contact_email],current_user.user_id) if !current_user.nil?
    if @contact_exist.nil?
      if !@user_mem.nil? && !@user_mem.user_profile.nil? && !@user_mem.user_profile.user_photo.nil?
        img=@user_mem.user_profile.user_photo 
        @contact_exist = ContactUser.create(:contact=>img, :contact_name=>@user_mem.user_name, :contact_email=>@user_mem.email_address, :user_id=>current_user.user_id, :contact_type=>"famtivity", :invite_status=>true, :accept_status=>false, :contact_user_type=>"member" , :inserted_date=>Time.now, :fam_user_id=>@user_mem.user_id)
      else
        @contact_exist = ContactUser.create(:contact_name=>@user_mem.user_name, :contact_email=>@user_mem.email_address, :user_id=>current_user.user_id, :contact_type=>"famtivity", :invite_status=>true, :accept_status=>false, :contact_user_type=>"member" , :inserted_date=>Time.now, :fam_user_id=>@user_mem.user_id)
      end
    else
      @contact_exist.update_attributes(:invite_status => true, :modified_date=>Time.now,:fam_user_id=>@user_mem.user_id)
    end
    #add to invitor list
    invitor_user = InvitorList.find_by_invited_email_and_user_id(params[:contact_email],current_user.user_id)
    if invitor_user.nil?
      InvitorList.invitor_list(params[:contact_email],current_user.user_id,'friend')
    else
      invitor_user.update_attributes(:modified_date =>Time.now)
    end
    if !cookies[:fam_network].nil? && cookies[:fam_network]!=""
      @fam = ContactGroup.where("group_id ='#{cookies[:fam_network]}'").last
      @old_user = "raja"
      @fam_net = ContactUserGroup.where("contact_group_id ='#{cookies[:fam_network]}' and contact_user_id='#{@contact_exist.contact_id}'").last
      if @fam_net.nil?
        c_user= ContactUserGroup.new
        c_user.contact_user_id = @contact_exist.contact_id
        c_user.contact_group_id = cookies[:fam_network]
        c_user.fam_accept_user_id = @user_mem.user_id
        c_user.user_id= current_user.user_id
        c_user.save!
      end
      if !@user_mem.nil?
        if @contact_exist.contact_user_type == "friend"
          FamtivityNetworkMailer.delay(queue: "Fam Network Friend", priority: 2, run_at: 10.seconds.from_now).network_friend_invite_mail(current_user,@fam,params[:contact_email],@get_current_url,@user_mem,@contact_exist.contact_id,nil)
        else
          FamtivityNetworkMailer.delay(queue: "Fam Network Non Friend", priority: 2, run_at: 10.seconds.from_now).network_member_invite_mail(current_user,@fam,params[:contact_email],@get_current_url,@user_mem,@contact_exist.contact_id,nil)
        end
      else
        FamtivityNetworkMailer.delay(queue: "Fam Network Invite to join", priority: 2, run_at: 10.seconds.from_now).network_to_join_famtivity(current_user,@fam,params[:contact_email],@get_current_url,@contact_exist,"Famtivity")
      end 
    else
      if !@user_mem.nil?
        if @user_mem.user_flag == true
          #~ UserMailer.delay(queue: "Send Friend Request", priority: 2, run_at: 10.seconds.from_now).friend_request_fam_member(@contact_user,@curr_user,@get_current_url)
          UserMailer.delay(queue: "Send Friend Request", priority: 2, run_at: 10.seconds.from_now).friend_request(@contact_exist,@curr_user,@get_current_url) if !@contact_exist.nil?
        end
      else
        UserMailer.delay(queue: "Send Friend Request", priority: 2, run_at: 10.seconds.from_now).friend_request(@contact_exist,@curr_user,@get_current_url) if !@contact_exist.nil?
      end
    end
    if !@contact_exist.nil?
      if params[:key_val]
        @fam_mem = User.where("email_address iLIKE ? and user_flag=?","%#{params[:key_val]}%",true)
        render :partial => "famtivity_members_list"
        #render :text => true
      else
        render :text => true
      end
    else
      render :text => false
    end
  
  end
  
  def fam_member_activate
    sent_user_id = Base64.decode64(params[:sent_user]) if !params[:sent_user].nil?
    sent_user = User.find_by_user_id(sent_user_id)
    user = User.where("email_address = ?",params[:c_email]).first
    @contact_user = ContactUser.where("contact_email = ? and user_id = ?",params[:c_email],sent_user.user_id).first
    if @contact_user
      @contact_user.update_attributes(:accept_status=>true, :contact_user_type => 'friend')
    else
      @contact_user = ContactUser.new(:contact_email => user.email_address, :contact_name => user.user_name,  :user_id => sent_user.id,:accept_status => true)
      @contact_user.contact_user_type = 'friend'
      @contact_user.save
    end
    flash[:notice]= "Accept successfully!"
    if sent_user.user_flag==true
      UserMailer.delay(queue: "Accept Message", priority: 2, run_at: 10.seconds.from_now).accept_email(sent_user.email_address, sent_user.user_name, @contact_user.contact_name)
    end
    #redirect_to root_url
    invitedid=params[:sent_user]
    user_email = params[:c_email]
    parent_reg = true
    redirect_to "/?sent_user=#{invitedid}&sent_user_email=#{user_email}&parent_reg=#{parent_reg}"
  end
  

  def contact_activate
    @contact_users = ContactUser.find_by_contact_id(params[:cid])
    if !@contact_users.nil?
      params[:cid_m] = Base64.encode64(params[:cid])
      @invit_user = User.find_by_email_address(@contact_users.contact_email) if !@contact_users.contact_email.nil? && @contact_users.contact_email!=''
      
      @user = User.find_by_user_id(@contact_users.user_id)
      @email = @user.email_address if !@user.nil?
      @uname = @user.user_name if !@user.nil?
      #@user.collect{|c|c.user_name }
      @cname = @contact_users.contact_name
      #@old_email = User.find_by_email_address(@email)

      @cont_uid = User.find_by_email_address(@contact_users.contact_email) if @contact_users && @contact_users.contact_email

      #update status to invitor_list
      invitor_user = InvitorList.find_by_invited_email_and_user_id(@contact_users.contact_email,@contact_users.user_id)
      if !invitor_user.nil? && invitor_user.present?
        invitor_user.update_attributes(:status => 'Accepted', :accepted_date => Time.now)
      end
      #while accepting the request add invitor as friend to contact user
      @chk_contact = ContactUser.find_by_contact_email_and_user_id(@user.email_address,@invit_user.user_id)
      if @chk_contact.nil?
        @create_contact = ContactUser.create(:contact_name=>@user.user_name, :contact_email=>@user.email_address, :user_id=>@cont_uid.user_id, :contact_type=>"famtivity",  :invite_status=>true, :accept_status=>true, :contact_user_type=>"friend", :fam_user_id => @user.user_id, :inserted_date => Time.now, :modified_date => Time.now) if @user && @contact_users && @contact_users.user_id && @cont_uid
      else
        @chk_contact.update_attributes(:accept_status=>true, :contact_user_type => 'friend', :fam_user_id => @user.user_id, :modified_date => Time.now)
      end
      cookies[:date_registered_usr] = Time.now.strftime("%Y-%m-%d") if cookies[:date_registered_usr].nil?
      cookies[:login_usr] = "on"
      cookies[:role_usr]= @invit_user.user_type
      cookies[:logged_in] = "yes"
      session[:user_id] = @invit_user.user_id
      cookies.permanent[:uid_usr] = @invit_user.user_id
      cookies.permanent[:username_usr] = @invit_user.user_name
      cookies[:email_usr] = @invit_user.email_address
      @sent_user = User.find_by_user_id(@contact_users.user_id) if @contact_users
      # sent_user_email = Base64.encode64("#{@sent_user.email_address}")
      


      if !params[:group].nil? && params[:group]!=""
        if @contact_users.accept_status != true
          @contact_users.update_attributes(:accept_status=>true, :contact_user_type => 'friend')
        end
        @fam = ContactUserGroup.find_by_contact_group_id_and_contact_user_id(params[:group],params[:cid])
        if !@fam.nil?
          contact=ContactUser.find_by_contact_id(params[:cid])
          @fam_con=ContactUser.find_all_by_contact_email(contact.contact_email)
          if @fam.fam_accept_status != true
            #@fam.fam_accept_status = true
            if !@fam_con.nil?
               @fam_con.each do |f_con|
               con_group = ContactUserGroup.find_by_contact_user_id_and_contact_group_id(f_con.contact_id,params[:group]) if !f_con.nil?
                   if !con_group.nil?
                    con_group.fam_accept_status = true
                    con_group.save!
                   end
               end
            end
            user_usr = User.find_by_email_address(@contact_users.contact_email)
            @user_u = User.find_by_user_id(@fam.user_id)
            url = request.env['HTTP_HOST']
            @con = ContactGroup.where("group_id=#{params[:group]}").last
            FamtivityNetworkMailer.delay(queue: "Accepted Invitation", priority: 2, run_at: 10.seconds.from_now).contact_success_mail(@user_u.email_address,@con,@contact_users,url)
            @fam_row = FamNetworkRow.find_by_contact_group_id_and_user_id(params[:group],user_usr.user_id)
        
            if !user_usr.nil?
              @fam.fam_accept_user_id = user_usr.user_id
              @row = FamNetworkRow.new
              @row.contact_group_id = params[:group]
              @row.user_id = user_usr.user_id
              @row.inserted_date = Time.now
              @row.save!
            end
            @fam.save!
            if user_usr
              add_sign_count = user_usr.sign_in_count
              user_usr.sign_in_count = (add_sign_count.nil? || add_sign_count==0) ?  1 : (add_sign_count+1)
              user_usr.last_sign_in = Time.now
              user_usr.save
            end
            cookies[:follow_cat_val]=@con.group_name
            @thank_msg = "Accept successfully!"
            #flash[:notice]= "Accept successfully!"
            cookies[:follow_cat_val]=@con.group_name
            #redirect_to "/?net_m=#{params[:cid_m]}&fam_status=true"
            if !user_usr.nil? && !user_usr.user_type.nil? && user_usr.user_type = "P" 
              redirect_to "/contact_users"
            else
              redirect_to "/contact_users?mode=parent"
            end
          else
            @thank_msg = "Your Already in Network!"
            #flash[:notice]= "Your Already in Network!"
            #redirect_to "/?fam_status=true"
              if !user_usr.nil? && !user_usr.user_type.nil? && user_usr.user_type = "P" 
                redirect_to "/contact_users"
              else
                redirect_to "/contact_users?mode=parent"
              end
          end
        end
        #@con = ContactGroup.where("group_id=#{params[:group]}").last
        #cookies[:follow_cat_val]=@con.group_name
        #redirect_to "/?net_m=#{params[:cid_m]}"
      else
        @invit_user = User.find_by_email_address(@contact_users.contact_email) if !@contact_users.contact_email.nil? && @contact_users.contact_email!=''
        if @contact_users.accept_status != true
          if @contact_users.update_attributes(:accept_status=>true, :contact_user_type => 'friend')
            flash[:notice]= "Accept successfully!"
            @user = User.find_by_user_id(@contact_users.user_id)
            @email = @user.email_address if !@user.nil?
            @uname = @user.user_name if !@user.nil?
            #@user.collect{|c|c.user_name }
            @cname = @contact_users.contact_name
            #@old_email = User.find_by_email_address(@email)

            @cont_uid = User.find_by_email_address(@contact_users.contact_email) if @contact_users && @contact_users.contact_email
        
            #update status to invitor_list
            invitor_user = InvitorList.find_by_invited_email_and_user_id(@contact_users.contact_email,@contact_users.user_id)
            if !invitor_user.nil? && invitor_user.present?
              invitor_user.update_attributes(:status => 'Accepted', :accepted_date => Time.now)
            end
            #while accepting the request add invitor as friend to contact user
            @chk_contact = ContactUser.find_by_contact_email_and_user_id(@user.email_address,@invit_user.user_id)
            if @chk_contact.nil?
              @create_contact = ContactUser.create(:contact_name=>@user.user_name, :contact_email=>@user.email_address, :user_id=>@cont_uid.user_id, :contact_type=>"famtivity",  :invite_status=>true, :accept_status=>true, :contact_user_type=>"friend") if @user && @contact_users && @contact_users.user_id && @cont_uid
            else
              @chk_contact.update_attributes(:accept_status=>true, :contact_user_type => 'friend')
            end
            if !@user.nil? && @user.present? && @user!=''
              if @user.user_flag==true
                UserMailer.delay(queue: "Accept Message", priority: 2, run_at: 10.seconds.from_now).accept_email(@email, @uname, @cname)
              end
            end
            if !@invit_user.nil? && @invit_user.present?
              cookies[:date_registered_usr] = Time.now.strftime("%Y-%m-%d") if cookies[:date_registered_usr].nil?
              cookies[:login_usr] = "on"
              cookies[:role_usr]= @invit_user.user_type
              cookies[:logged_in] = "yes"
              session[:user_id] = @invit_user.user_id
              cookies.permanent[:uid_usr] = @invit_user.user_id
              cookies.permanent[:username_usr] = @invit_user.user_name
              cookies[:email_usr] = @invit_user.email_address
              @sent_user = User.find_by_user_id(@contact_users.user_id) if @contact_users
              sent_user_email = Base64.encode64("#{@sent_user.email_address}")
              @thank_msg = "You are now friends with #{@sent_user.email_address}"
              redirect_to "/contact_users?mode=parent&cid_m=#{Base64.encode64(params[:cid])}&cont_msg=#{Base64.encode64(@thank_msg )}"

            else
              redirect_to root_url
            end
          else
            flash[:notice]= "Please contact the administaror!"
            if !@invit_user.nil? && @invit_user.present?
              cookies[:date_registered_usr] = Time.now.strftime("%Y-%m-%d") if cookies[:date_registered_usr].nil?
              cookies[:login_usr] = "on"
              cookies[:role_usr]= @invit_user.user_type
              cookies[:logged_in] = "yes"
              session[:user_id] = @invit_user.user_id
              cookies.permanent[:uid_usr] = @invit_user.user_id
              cookies.permanent[:username_usr] = @invit_user.user_name
              cookies[:email_usr] = @invit_user.email_address
              @thank_msg = "Please contact the administaror!"
              redirect_to "/contact_users?mode=parent&cid_m=#{Base64.encode64(params[:cid])}&cont_msg=#{Base64.encode64(@thank_msg )}"
            else
              redirect_to "/contact_users?mode=parent"
            end
          end
        else
          flash[:notice]= "You have already Accept successfully!"
          if !@invit_user.nil? && @invit_user.present?
            cookies[:date_registered_usr] = Time.now.strftime("%Y-%m-%d") if cookies[:date_registered_usr].nil?
            cookies[:login_usr] = "on"
            cookies[:role_usr]= @invit_user.user_type
            cookies[:logged_in] = "yes"
            session[:user_id] = @invit_user.user_id
            cookies.permanent[:uid_usr] = @invit_user.user_id
            cookies.permanent[:username_usr] = @invit_user.user_name
            cookies[:email_usr] = @invit_user.email_address
            @thank_msg = "You have already accept friend request!"
            redirect_to "/contact_users?mode=parent&cid_m=#{Base64.encode64(params[:cid])}&cont_msg=#{Base64.encode64(@thank_msg )}"
          else
            redirect_to "/contact_users?mode=parent"
          end

        end
      end
    else
      flash[:notice]= "Email Doesn't Exist!"
      redirect_to root_url
    end
  end
  
  
  def contact_type_filter
    mode=params[:mode]
    @get_current_url = request.env['HTTP_HOST']
    @key_word = params[:key_word]
    @refresh = params[:refresh].blank? ? '' : params[:refresh]
    # Finding Activity Groups
    # @arr = []
    # activity_groups = ActivityAttendDetail.where(:user_id=>current_user.user_id)
    # @activity_groups = activity_groups.group_by(&:activity_id).to_a
    # @arr = activity_groups.map(&:user_id)
    # @activity_users = User.where("user_id IN (?)",@arr)
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
    #end

    if (@key_word == 'all')
      @gbox=params[:gbox] if !params[:gbox].nil?
      @contact_users = ContactUser.where("user_id = ?",current_user.id).order("contact_name ASC")
      @activity_users = User.where("user_id IN (?)",@users)
    else
      @contact_users = ContactUser.where("user_id=? and contact_user_type = ?",current_user.id,@key_word).order("contact_name ASC")
      @activity_users = []
    end
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
    @contact_groups = ContactGroup.find(:all,:conditions=>["user_id = ?", current_user.id] , :order => "group_name ASC")

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
    respond_to do |format|
      format.js
    end
  end

  
  
  #To add the multiple uploaded files to temp folder
  def add_files_to_temp
    orig_dir = FileUtils.mkdir_p("#{Rails.root}/public/contact_users_upload", :mode => 0770) if !File.exists?("#{Rails.root}/public/contact_users_upload")
    dir = "#{Rails.root}/public/contact_users_upload/#{current_user.user_id}"
    if params[:my_file] && params[:my_file].present? && !params[:my_file].nil? && params[:my_file].original_filename && params[:my_file].original_filename.present? && !params[:my_file].original_filename.nil? && params[:my_file].original_filename!=''
      Dir.mkdir(dir,0755)  if !File.exists?(dir)
      f_name = params[:my_file].original_filename.split('.')
      renamed_file_path="#{dir}/#{f_name[0]}_#{Time.now.strftime('%y%m%d%H%M%S')}.#{f_name[1]}"
      FileUtils.cp(params[:my_file].tempfile, renamed_file_path)
      render :text=>true
    else
      render :text=>false
    end
  end
  
end