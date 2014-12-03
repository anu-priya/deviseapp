class ActivitySubcategoriesController < ApplicationController
  # before_filter :authenticate_user
  include ActivitySubcategoriesHelper
  # GET /activity_subcategories
  # GET /activity_subcategories.json
  def index
    @activity_subcategories = ActivitySubcategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activity_subcategories }
    end
  end

  def get_follow_user
    @user = User.find_by_user_id(current_user.user_id) if !current_user.nil? && current_user.present?
    userid = @user.user_id if @user.present?
    @email = @user.email_address if @user.present?
    if params[:id] == "Parent"
      #@parent_list = ActivityShared.find_by_sql("select distinct user_id from activity_shareds where (shared_to='#{@email}' and user_id!=#{userid}) or (user_id=#{userid} and shared_to!='#{@email}')").collect(&:user_id)
      #@parent_user = User.joins(:user_profile).where("users.user_type = 'P'").where(:user_id=>@parent_list)
      #@user_row = UserRow.where("user_id=#{userid} and user_type='U'").map(&:row_user_id)
      @parent_list_email = ActivityShared.find_by_sql("select distinct user_id,share_id from activity_shareds where user_id=#{userid} and share_id!='#{userid}'").collect(&:share_id) if !userid.nil?
      @parent_list_id = ActivityShared.find_by_sql("select distinct user_id,share_id from activity_shareds where share_id='#{userid}' and user_id!=#{userid}").collect(&:user_id) if !userid.nil?
      @parent_user_id = User.joins(:user_profile).where("account_active_status=true").where(:user_id =>@parent_list_id ) if !@parent_list_id.nil?
      @contact_user = ContactUser.find_by_sql("select * from contact_users where contact_email in (select email_address from users where account_active_status=true) and user_id=#{userid} order by contact_email").collect(&:contact_email) if !userid.nil?
      contact_parent = @parent_list_email + @contact_user
      @parent_user_contact = User.joins(:user_profile).where("account_active_status=true").where(:user_id =>contact_parent.uniq ) if !contact_parent.nil?

      render :partial => "accordion_parent_user", :locals => { :states => @ac_sub }
    elsif params[:id] == "Provider"
      @type="Provider"
      #~ @provider_user = User.find(:all, :joins => :user_profile,:select=>"users.*,user_profiles.*", :conditions => ["user_type = 'P'"])
      # @provider_user=User.find_by_sql("select distinct(users.user_name), users.email_address,users.user_id,user_profiles.city,user_profiles.state,user_profiles.country,user_profiles.business_name,user_profiles.profile_file_name from users, user_profiles, activities where activities.cleaned=TRUE and users.user_id=user_profiles.user_id and users.account_active_status=TRUE and activities.active_status='Active' and users.user_type='P' and users.user_id=activities.user_id order by users.user_name asc")
      @pro = User.find_by_sql("select distinct(users.user_name), users.email_address,users.user_id,user_profiles.city,user_profiles.state,user_profiles.country,user_profiles.business_name,user_profiles.profile_file_name from users, user_profiles, activities where activities.cleaned=TRUE and users.user_id=user_profiles.user_id and users.account_active_status=TRUE and activities.active_status='Active'and activities.cleaned=TRUE and users.user_type='P' and users.user_id=activities.user_id order by user_profiles.business_name asc")
      @perpage=30
      @provider_user = @pro.paginate(:page => params[:page], :per_page =>@perpage)
      @user_row = UserRow.where("user_id=#{userid} and lower(user_type)='p'").map(&:row_user_id) if !userid.nil?
      #render :partial => "accordion_provider_user", :locals => { :states => @provider_user }
      respond_to do |format|
        format.html { render :partial => "accordion_provider_user", :locals => { :states => @provider_user } }
        format.js
      end
    else
      #user selected rows
      @subcat_id = ActivityRow.find_by_sql("select distinct subcateg_id from activity_rows where user_id=#{current_user.user_id}").map(&:subcateg_id) if current_user.present?
      @subval = @subcat_id.compact.to_s.gsub('[','').gsub(']','') if !@subcat_id.nil? && @subcat_id.present?
      # user selected categories
      @following_user_cat= ActivitySubcategory.find_by_sql("select distinct acat.category_name, acat.category_id,acat.category_file_name from activity_subcategories asub left join activity_categories acat on asub.category_id = acat.category_id where subcateg_id in (#{@subval})").uniq if !@subval.nil? && @subval.present?

      @contact_gr = ContactGroup.where(:user_id=> userid)
      @following_network = FamNetworkRow.where("user_id=#{userid}").map(&:contact_group_id)
      @following_your_network = FamNetworkRow.where(:contact_group_id=>@contact_gr).map(&:user_id)

      @net_following = ContactGroup.where(:group_id=>@following_network).where("lower(group_status) !='just_me'")
      @net_following_check = @net_following.map(&:group_id)
      @following_user = UserRow.where("user_id=#{userid}") if !userid.nil?
      you_user = UserRow.where("row_user_id=#{userid}").map(&:user_id) if !userid.nil?
      @following_you_user = @following_your_network + you_user
      @following_you_user = @following_you_user.uniq
      render :partial => "following_user", :locals => { :states => @ac_sub }
    end
  end


  def update_sub_category
    @ac_sub = []
    if params[:id]=="default"
      @act_subcateg = ActivityCategory.where("lower(category_name) = ?", params[:id].downcase).last
      @subcateg = ActivitySubcategory.where("category_id = ?", @act_subcateg.category_id)
      @subcateg.each do |sub|
        @ac_sub << {'id'=>sub.subcateg_id,'name'=>sub.subcateg_name}
      end
    elsif params[:id] =="net"
      @fam_cre = ContactGroup.where("user_id = #{current_user.user_id}").map(&:group_id)
      @fam_net = ContactUserGroup.where("fam_accept_user_id = #{current_user.user_id} and fam_accept_status = true").map(&:contact_group_id)
      @te = @fam_cre + @fam_net
      @creat = ContactGroup.where(:group_id=>@te.uniq).where("lower(group_status) !='just_me'")
      @creat.each do |sub|
        @ac_sub << {'id'=>sub.group_id,'name'=>sub.group_name}
      end
      @provider_activites_check = FamNetworkRow.where("user_id=#{current_user.user_id}").map(&:contact_group_id)
    else
      if !params[:id].nil? && params[:id].present? &&  params[:id]!=""
        @act_subcateg = Activity.order("lower(sub_category) asc").select("lower(sub_category) as sub_category").where("lower(category) = ?", params[:id].downcase).uniq  if !params[:id].nil? &&  params[:id]!=""
        @cat = ActivityCategory.where("lower(category_name) = ?", params[:id].downcase).last  if !params[:id].nil? &&  params[:id]!=""
        @act_subcateg.each do |subcateg|
          @subcateg = ActivitySubcategory.where("lower(subcateg_name) = ? and category_id = ?", (subcateg.sub_category).downcase,@cat.category_id) if !subcateg.nil? && subcateg.present? && !@cat.nil?
          if @subcateg && @subcateg.length > 0
            @ac_sub << {'id'=>@subcateg[0].subcateg_id,'name'=>@subcateg[0].subcateg_name}
          end
        end if !@act_subcateg.nil?
      end
    end

    if params[:id] == 'net'
      render :partial => "accordion_fam_network", :locals => { :states => @ac_sub }
    else
      if !current_user.nil?
        @checck = ActivityRow.find(:all,:conditions=>["user_id = ? ", current_user.user_id],:select => "subcateg_id")
        @provider_activites_check =[]
        @checck.each { |s| @provider_activites_check << s.subcateg_id if !s.subcateg_id.nil?}
      else
        @provider_activites_check = []
        @provider_activites_check = session[:category_row]
        #      @ac_sub.each {|s| @provider_activites_check << s['id'] if !s['id'].nil?}
      end
      render :partial => "accordion_sub_category", :locals => { :states => @ac_sub }
    end
  end

  def update_follow_row
    if !current_user.nil?
      user_id = current_user.user_id

      add_user_row(params[:parent_add_row],params[:parent_rem_row],'U',user_id)

      add_user_row(params[:provider_add_row],params[:provider_rem_row],'P',user_id)

      add_user_row(params[:follow_add_row],params[:follow_rem_row],'F',user_id)


      add_user_row(params[:follow_you_add_row],params[:follow_you_rem_row],'FY',user_id)

      add_remove_fam_network(params[:fam_net_add_row],params[:fam_net_rem_row],user_id)

      add_remove_subcategory(params[:cat_add_row],params[:cat_remove_row],user_id)


      #calling this method from helper currently following categories remove option 
      add_remove_followcategory(params[:catsub_add_row],params[:catsub_rem_row],user_id)
    else
      session[:category_row] = params[:cat_add_row]
      session[:provider_row] = params[:provider_add_row]
    end
    respond_to do |format|
      format.js
    end

  end


  # GET /activity_subcategories/1
  # GET /activity_subcategories/1.json
  def show
    @activity_subcategory = ActivitySubcategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity_subcategory }
    end
  end

  # GET /activity_subcategories/new
  # GET /activity_subcategories/new.json
  def new
    @activity_subcategory = ActivitySubcategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @activity_subcategory }
    end
  end

  # GET /activity_subcategories/1/edit
  def edit
    @activity_subcategory = ActivitySubcategory.find(params[:id])
  end

  # POST /activity_subcategories
  # POST /activity_subcategories.json
  def create
    @activity_subcategory = ActivitySubcategory.new(params[:activity_subcategory])

    respond_to do |format|
      if @activity_subcategory.save
        format.html { redirect_to @activity_subcategory, notice: 'Activity subcategory was successfully created.' }
        format.json { render json: @activity_subcategory, status: :created, location: @activity_subcategory }
      else
        format.html { render action: "new" }
        format.json { render json: @activity_subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /activity_subcategories/1
  # PUT /activity_subcategories/1.json
  def update
    @activity_subcategory = ActivitySubcategory.find(params[:id])

    respond_to do |format|
      if @activity_subcategory.update_attributes(params[:activity_subcategory])
        format.html { redirect_to @activity_subcategory, notice: 'Activity subcategory was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @activity_subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_subcategories/1
  # DELETE /activity_subcategories/1.json
  def destroy
    @activity_subcategory = ActivitySubcategory.find(params[:id])
    @activity_subcategory.destroy

    respond_to do |format|
      format.html { redirect_to activity_subcategories_url }
      format.json { head :no_content }
    end
  end
end
