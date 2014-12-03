class SponsorShipsController < ApplicationController
  # GET /sponsor_ships
  # GET /sponsor_ships.json
  before_filter :authenticate_user
  require 'will_paginate/array'
  def index
    @sponsor_ships = SponsorShip.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sponsor_ships }
    end
  end


  def activity_create_bid
    @activity = Activity.find(params[:id])
  end


  def create_bid
    @mon = MonthlyBudget.find_by_user_id(current_user.user_id)
    if !@mon.nil?
      @mon.update_attributes(:monthly_budget=>params[:bid_amount_monthly],:bid_amount => params[:bid_amount])
    else
      @month = MonthlyBudget.new
      @month.user_id = current_user.user_id
      @month.monthly_budget = params[:bid_amount_monthly]
      @month.bid_amount = params[:bid_amount]
      @month.bid_start_date = Time.now.beginning_of_month.strftime("%Y-%m-%d")
      @month.bid_end_date = Time.now.end_of_month.strftime("%Y-%m-%d")
      @month.created_at = Time.now
      #@month.updated_at = Time.now
      @month.save
    end
    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  def location_based_activity
    request.ip
    p params.inspect
    city = params["city"].split(",")
    @city_cond =""
    r = 1
    city.each { |s| @city_cond.concat("and lower(city)  = '#{s.downcase.strip}'") if r == 1; @city_cond.concat("or lower(city)  = '#{s.downcase.strip}'") if r != 1; r+=1 }
    @activity = []
    @activity = Activity.find_by_sql("select activity_id,activity_name from activities where user_id =#{current_user.user_id} #{@city_cond}") if (current_user.user_plan == "sponsor" ||current_user.user_plan == "sell")
    render :partial => "activity_name", :locals => { :activity => @activity }
  end

  def bid_create
    @mon = MonthlyBudget.find_by_user_id(current_user.user_id)
    if !@mon.nil?
      @mon.update_attributes(:monthly_budget=>params[:bid_amount_monthly],:bid_amount => params[:bid_amount])
    else
      @month = MonthlyBudget.new
      @month.user_id = current_user.user_id
      @month.monthly_budget = params[:bid_amount_monthly]
      @month.bid_amount = params[:bid_amount]
      @month.bid_start_date = Time.now.beginning_of_month.strftime("%Y-%m-%d")
      @month.bid_end_date = Time.now.end_of_month.strftime("%Y-%m-%d")
      @month.created_at = Time.now
      #@month.updated_at = Time.now
      @month.save
    end
    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  def bid_update
    @mon = MonthlyBudget.find_by_user_id(current_user.user_id)
    if !@mon.nil?
      @mon.update_attributes(:monthly_budget=>params[:bid_amount_monthly],:bid_amount => params[:bid_amount])
    else
      @month = MonthlyBudget.new
      @month.user_id = current_user.user_id
      @month.monthly_budget = params[:bid_amount_monthly]
      @month.bid_amount = params[:bid_amount]
      @month.bid_start_date = Time.now
      @month.bid_end_date = Time.now.end_of_month
      @month.created_at = Time.now
      # @month.updated_at = Time.now
      @month.save
    end
    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  # GET /sponsor_ships/1
  # GET /sponsor_ships/1.json
  def show
    @sponsor_ship = SponsorShip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sponsor_ship }
    end
  end

  # GET /sponsor_ships/new
  # GET /sponsor_ships/new.json
  def new
    @sponsor_ship = SponsorShip.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sponsor_ship }
    end
  end

  # GET /sponsor_ships/1/edit
  def edit
    @sponsor_ship = SponsorShip.find(params[:id])
  end

  # POST /sponsor_ships
  # POST /sponsor_ships.json
  def create
    @sponsor_ship = SponsorShip.new(params[:sponsor_ship])

    respond_to do |format|
      if @sponsor_ship.save
        format.html { redirect_to @sponsor_ship, notice: 'Sponsor ship was successfully created.' }
        format.json { render json: @sponsor_ship, status: :created, location: @sponsor_ship }
      else
        format.html { render action: "new" }
        format.json { render json: @sponsor_ship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sponsor_ships/1
  # PUT /sponsor_ships/1.json
  def update
    @sponsor_ship = SponsorShip.find(params[:id])

    respond_to do |format|
      if @sponsor_ship.update_attributes(params[:sponsor_ship])
        format.html { redirect_to @sponsor_ship, notice: 'Sponsor ship was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sponsor_ship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sponsor_ships/1
  # DELETE /sponsor_ships/1.json
  def destroy
    @sponsor_ship = SponsorShip.find(params[:id])
    @sponsor_ship.destroy

    respond_to do |format|
      format.html { redirect_to sponsor_ships_url }
      format.json { head :no_content }
    end
  end


  def del_bid
    session[:city] = params[:city] unless params[:city].nil?
    session[:date] = params[:date] unless params[:date].nil?
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    session[:city] = "Walnut Creek" if session[:city].nil?
    @activity_bid = ActivityBid.find_by_activity_id(params[:id])
    @activity_bid.destroy
    act = ActivityBid.activity_user_bids("","","",cookies[:uid_usr])
    @activities = act.paginate(:page => params[:page], :per_page =>10)
    respond_to do |format|
      format.js
    end
  end
  
  def delete_bid
    @to_delete = params[:id]
  end


  def billing_sponsorship
    @p_f=""
    @get_current_url = request.env['HTTP_HOST']
    act = ActivityBid.activity_user_bids(current_user.user_id)
    @activities = act.paginate(:page => params[:page], :per_page =>10)
    @mon = MonthlyBudget.find_by_user_id(current_user.user_id)
  end


  def billing_sponsorship_update
    act = ActivityBid.activity_user_bids(current_user.user_id)
    @activities = act.paginate(:page => params[:page], :per_page =>10)
    respond_to do |format|
      format.js
    end
  end
  
  def bid_setup
    #@cities = City.all
    @budget = MonthlyBudget.find_by_user_id(current_user.user_id)
  end
  
  def edit_bid 
    #@activity = Activity.find(params[:bid_id])
    #@bid = ActivityBid.find_by_userid(current_user.user_id)
    @budget = MonthlyBudget.find_by_user_id(current_user.user_id)
  end

end
