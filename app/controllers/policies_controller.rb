class PoliciesController < ApplicationController
  before_filter :authenticate_user
  include PoliciesHelper
  # GET /policies
  # GET /policies.json
  def index
    @policies = Policy.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @policies }
    end
  end
  
  def provider_policies
    @policy_old = Policy.where('user_id = ?', current_user.user_id)
    @provider_policies = Policy.where('status = ? AND ptype_id = ? ', false,1)
    @waiver = Policy.where('status = ? AND ptype_id = ? ', false,2)
    @policy_file = PolicyFile.where("user_id=?",current_user.user_id)
    @policy_value = params[:uid]
    if !params[:uid].nil?
      @policy_id = params[:uid]
    else
      @policy_id = current_user.user_id
    end
    @policy_type = PolicyType.find(:all)
    @old_policy = Policy.find_by_user_id(@policy_id)
    @old_policys= Policy.where(:user_id => @policy_id)
    @policy_one = Policy.find_by_user_id_and_ptype_id(@policy_id,"1")
    @policy_two = Policy.find_by_user_id_and_ptype_id(@policy_id,"2")
  end
  
  def provider_terms
    @act = Activity.where("activity_id=?",params[:pid]).first
    @policy_old = Policy.where('user_id = ?', @act.user_id) if !@act.nil?
  end 	  

  def ptype_create
    @policy = PolicyType.new(params[:policy])
    @policy.save
    redirect_to :back

  end

  # GET /policies/1
  # GET /policies/1.json
  def show
    @policy = Policy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @policy }
    end
  end

  # GET /policies/new
  # GET /policies/new.json
  def new
    @policy = Policy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @policy }
    end
  end

  # GET /policies/1/edit
  def edit
    @policy = Policy.find(params[:id])
  end

  # POST /policies
  # POST /policies.json
  def create
    @policy = Policy.new(params[:policy])

    respond_to do |format|
      if @policy.save
        format.html { redirect_to @policy, notice: 'Policy was successfully created.' }
        format.json { render json: @policy, status: :created, location: @policy }
      else
        format.html { render action: "new" }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /policies/1
  # PUT /policies/1.json
  #  def contact_update
  #    @contact_user = ContactUser.find(params[:id])
  #    @contact_user.contact = params[:contact_user][:contact] if !params[:contact_user][:contact].nil? && params[:contact_user][:contact]!=""
  #    @contact_user.contact_name = params[:contact_user][:contact_name]
  #    @contact_user.contact_mobile = params[:contact_user][:contact_mobile]
  #    @contact_user.save
  #    render :partial =>'edit_contact_success'
  #    :account_active_status=>TRUE
  #  end

  def policy_update
    if !current_user.nil? && current_user.present?

      if params[:radio_1]=="1"
        @ptype = 1
      elsif params[:radio_2]=="1"
        @ptype = 2
      elsif params[:radio_3]=="1"
        @ptype = 3
      else
        @ptype = 1
      end
      @old_policy_ptype = Policy.find_by_user_id_and_ptype_id(current_user.user_id,@ptype)
      @old_policys= Policy.where(:user_id => (current_user.user_id))
      @old_policy = Policy.find_by_user_id(current_user.user_id)
      if !params[:content].nil?
        if !@old_policys
          @policy = Policy.new
          @policy.content = params[:content]
          @policy.user_id = current_user.user_id
          @policy.status = TRUE
          @policy.inserted_date = Time.now
          @policy.modified_date = Time.now
          @policy.ptype_id = @ptype
          @policy.save
        elsif @old_policys && !@old_policy_ptype
          @policy = Policy.new
          @policy.content = params[:content]
          @policy.user_id = current_user.user_id
          @policy.status = TRUE
          @policy.inserted_date = Time.now
          @policy.modified_date = Time.now
          @policy.ptype_id = @ptype
          @policy.save
        elsif @old_policy_ptype
          @old_policy_ptype.update_attributes(:content => params[:content], :modified_date => Time.now)
        end
      end
      redirect_to :back
    end
  end
  
  def update
    @policy = Policy.find(params[:id])

    respond_to do |format|
      if @policy.update_attributes(params[:policy])
        format.html { redirect_to @policy, notice: 'Policy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /policies/1
  # DELETE /policies/1.json
  def destroy
    @policy = Policy.find(params[:id])
    @policy.destroy

    respond_to do |format|
      format.html { redirect_to policies_url }
      format.json { head :no_content }
    end
  end
  
  def upload_policy
   pdf= params[:pdf_name] if !params[:pdf_name].nil?
   old_pdf=PolicyFile.find_by_user_id_and_pdf_file_name(current_user.user_id,pdf) if !params[:pdf_name].nil?
   if old_pdf.nil? 
    if(params[:policy][:datafile].present? && !params[:policy][:datafile].nil?)
      @p_file = PolicyFile.new
      @p_file.user_id = current_user.user_id
      @p_file.pdf = params[:policy][:datafile]
      @p_file.save
      @policy_file = PolicyFile.where("user_id=?",current_user.user_id)
		  if  (@p_file && @p_file.save)
        @val="success"
        render :partial =>'upload_file'
		  else
        render :text => 'false'
		  end
	  end
    else
        render :text => 'already_exit'
  end
  end
  
  def download_policy
    if !params[:id].nil?
      p_file = PolicyFile.where("policy_file_id=?",params[:id]).first
      #~ path = "#{Rails.root}/public/system/pdfs/#{p_file.policy_file_id}/original/#{p_file.pdf_file_name}"
      path = "#{p_file.pdf.path(:original)}"
      if p_file && File.exists?(path)
        send_file path, :x_sendfile=>true,  :disposition => "attachment"
      else
        redirect_to "/provider_policies"
      end
    end
  end
  
  def policy_file_delete

    if (params[:id].present? && !params[:id].nil? && !params[:id].empty?)
      p_id=params[:id]
      d_file = PolicyFile.where("policy_file_id=?",params[:id]).first
      form_file=ActivityForm.find_by_policy_file_id(p_id)
      d_file.destroy if !d_file.nil?
      form_file.destroy if !form_file.nil?
	    if (d_file.destroyed?)
	      render :text => true
	    else
	      render :text => false
	    end
    end
  end

end
