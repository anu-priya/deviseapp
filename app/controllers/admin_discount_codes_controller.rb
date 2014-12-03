class AdminDiscountCodesController < ApplicationController
  #before_filter :authenticate_user_admin
  require 'will_paginate/array'
  # GET /admin_discount_codes
  # GET /admin_discount_codes.json
  def index
    params["mode"]='admin'
    cookies[:set_colour] = "2"
    act = AdminDiscountCode.order("admin_discount_id desc").all
    @admin_discount_codes = act.paginate(:page => params[:page], :per_page =>30)
    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  # GET /admin_discount_codes/1
  # GET /admin_discount_codes/1.json
  def show
    @admin_discount_code = AdminDiscountCode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_discount_code }
    end
  end

  def create_discount_codes
    @admin_discount_code = AdminDiscountCode.new
    @admin_discount_code.discount_amount = params[:discount_code]
    @admin_discount_code.discount_sign = 0
    @admin_discount_code.discount_name = params[:discount_name]
    @admin_discount_code.discount_code = params[:discount_code]
    @admin_discount_code.discount_max = params[:discount_max]
    @admin_discount_code.discount_amount = params[:discount_amt]
    @admin_discount_code.discount_status = "Active"
    if params[:discount_expire]!= "1"
      @admin_discount_code.discount_start_date = params[:discount_start_date]
      @admin_discount_code.discount_end_date = params[:discount_end_date]
    end
    @admin_discount_code.save
    @act = AdminDiscountCode.order("admin_discount_id desc").all
    respond_to do |format|
      format.js
    end
  end


  def delete_discount_code
    @admin_discount_code = AdminDiscountCode.find(params[:id])
    @admin_discount_code.destroy()
    @act = AdminDiscountCode.order("admin_discount_id desc").all
    respond_to do |format|
      format.js
    end
  end


  def update_discount_active_status
    @admin_discount_code = AdminDiscountCode.find(params[:id])
    if @admin_discount_code
      if params[:status]== "Active"
        @admin_discount_code.discount_status = "Active"
      else
        @admin_discount_code.discount_status = "Inactive"
      end
      @admin_discount_code.save
    end
    respond_to do |format|
      format.js
    end
  end

  def admin_delete_discount
    
  end

  def edit_discount
    @admin_disc = AdminDiscountCode.find(params[:discount_id])
    if !params[:set_color].nil?
      if params[:set_color].to_i.even?
        cookies[:set_colour] = "2"
      else
        cookies[:set_colour] = "1"
      end
    else
      cookies[:set_colour] = "1"
    end
  end

  def update_discount_codes
    @admin_discount_code = AdminDiscountCode.find(params[:discount_id])
    if @admin_discount_code
      @admin_discount_code.discount_name = params[:discount_name]
      @admin_discount_code.discount_code = params[:discount_code]
      @admin_discount_code.discount_max = params[:discount_max]
      @admin_discount_code.discount_amount = params[:discount_amt]
      if params[:discount_expire]!= "1"
        @admin_discount_code.discount_start_date = params[:discount_start_date]
        @admin_discount_code.discount_end_date = params[:discount_end_date]
      else
        @admin_discount_code.discount_start_date = ""
        @admin_discount_code.discount_end_date = ""
      end
      @admin_discount_code.save
    end
    respond_to do |format|
      format.js
    end
  end



  # GET /admin_discount_codes/new
  # GET /admin_discount_codes/new.json
  def new
    @admin_discount_code = AdminDiscountCode.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_discount_code }
    end
  end

  # GET /admin_discount_codes/1/edit
  def edit
    @admin_discount_code = AdminDiscountCode.find(params[:id])
  end

  # POST /admin_discount_codes
  # POST /admin_discount_codes.json
  def create
    @admin_discount_code = AdminDiscountCode.new(params[:admin_discount_code])

    respond_to do |format|
      if @admin_discount_code.save
        format.html { redirect_to @admin_discount_code, notice: 'Admin discount code was successfully created.' }
        format.json { render json: @admin_discount_code, status: :created, location: @admin_discount_code }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_discount_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin_discount_codes/1
  # PUT /admin_discount_codes/1.json
  def update
    @admin_discount_code = AdminDiscountCode.find(params[:id])

    respond_to do |format|
      if @admin_discount_code.update_attributes(params[:admin_discount_code])
        format.html { redirect_to @admin_discount_code, notice: 'Admin discount code was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_discount_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_discount_codes/1
  # DELETE /admin_discount_codes/1.json
  def destroy
    @admin_discount_code = AdminDiscountCode.find(params[:id])
    @admin_discount_code.destroy

    respond_to do |format|
      format.html { redirect_to admin_discount_codes_url }
      format.json { head :no_content }
    end
  end
end
