class ActivityAttendDetailsController < ApplicationController
  # GET /activity_attend_details
  # GET /activity_attend_details.json
  before_filter :authenticate_user, :except => [:attendies]
  #~ before_filter :authenticate_user
  before_filter :check_for_attendies, :only => [:attendies]
  require 'will_paginate/array'
  require "base64"
  def index
    @activity_attend_details = ActivityAttendDetail.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activity_attend_details }
    end
  end

 def attendies
  @a_id = Base64.decode64(params[:aid]) if !params[:aid].nil?
  @u_id = Base64.decode64(params[:uid]) if !params[:uid].nil?
  #@a_name = Base64.decode64(params[:aname]) if !params[:aname].nil?
  #@a_name =Activity.find_all_by_activity_id(@a_id).map(&:activity_name)
  @name =Activity.find(@a_id)
  @a_name = @name.activity_name
  @participants =ActivityAttendDetail.find_all_by_activity_id(@a_id).map(&:participant_id)   if !@a_id.nil? && @a_id.present? && !@u_id.nil? && @u_id.present?
  @participants = @participants.paginate(:page => params[:page], :per_page =>10)
 end
 
 
  # GET /activity_attend_details/1
  # GET /activity_attend_details/1.json
  def show
    @activity_attend_detail = ActivityAttendDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity_attend_detail }
    end
  end

  # GET /activity_attend_details/new
  # GET /activity_attend_details/new.json
  def new
    @activity_attend_detail = ActivityAttendDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @activity_attend_detail }
    end
  end

  # GET /activity_attend_details/1/edit
  def edit
    @activity_attend_detail = ActivityAttendDetail.find(params[:id])
  end

  # POST /activity_attend_details
  # POST /activity_attend_details.json
  def create
    @activity_attend_detail = ActivityAttendDetail.new(params[:activity_attend_detail])

    respond_to do |format|
      if @activity_attend_detail.save
        format.html { redirect_to @activity_attend_detail, notice: 'Activity attend detail was successfully created.' }
        format.json { render json: @activity_attend_detail, status: :created, location: @activity_attend_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @activity_attend_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /activity_attend_details/1
  # PUT /activity_attend_details/1.json
  def update
    @activity_attend_detail = ActivityAttendDetail.find(params[:id])

    respond_to do |format|
      if @activity_attend_detail.update_attributes(params[:activity_attend_detail])
        format.html { redirect_to @activity_attend_detail, notice: 'Activity attend detail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @activity_attend_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_attend_details/1
  # DELETE /activity_attend_details/1.json
  def destroy
    @activity_attend_detail = ActivityAttendDetail.find(params[:id])
    @activity_attend_detail.destroy

    respond_to do |format|
      format.html { redirect_to activity_attend_details_url }
      format.json { head :no_content }
    end
  end
  
  
protected
# Added for attendies functionality in mailer
def check_for_attendies
	@user_id =  Base64.decode64("#{params[:uid]}")
	@activity_id =  Base64.decode64("#{params[:aid]}")
	@act = Activity.find(@activity_id)
	@a_user_id = @act.user_id
	if !current_user.nil? && current_user.present?
		if(current_user.user_id != @a_user_id.to_i)
			cookies.delete :login_usr
			cookies.delete :uid_usr
			cookies.delete :city_new_usr
			cookies.delete :selected_city
			cookies.delete :first_import
			cookies.delete :first_import_success
			session[:user_id] = nil
			session['ip_location'] = nil
			redirect_to "/attendies?uid=#{params[:uid]}&aid=#{params[:aid]}&act_type=attendies"
		end
	#~ else
		#~ redirect_to "/attendies?uid=#{params[:uid]}&aid=#{params[:aid]}&act_type=attendies"
	end	
end


end
