class ActivityPricesController < ApplicationController
  # GET /activity_prices
  # GET /activity_prices.json
  def index
    @activity_prices = ActivityPrice.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activity_prices }
    end
  end

  # GET /activity_prices/1
  # GET /activity_prices/1.json
  def show
    @activity_price = ActivityPrice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity_price }
    end
  end

  # GET /activity_prices/new
  # GET /activity_prices/new.json
  def new
    @activity_price = ActivityPrice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @activity_price }
    end
  end

  # GET /activity_prices/1/edit
  def edit
    @activity_price = ActivityPrice.find(params[:id])
  end

  # POST /activity_prices
  # POST /activity_prices.json
  def create
    @activity_price = ActivityPrice.new(params[:activity_price])

    respond_to do |format|
      if @activity_price.save
        format.html { redirect_to @activity_price, notice: 'Activity price was successfully created.' }
        format.json { render json: @activity_price, status: :created, location: @activity_price }
      else
        format.html { render action: "new" }
        format.json { render json: @activity_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /activity_prices/1
  # PUT /activity_prices/1.json
  def update
    @activity_price = ActivityPrice.find(params[:id])

    respond_to do |format|
      if @activity_price.update_attributes(params[:activity_price])
        format.html { redirect_to @activity_price, notice: 'Activity price was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @activity_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_prices/1
  # DELETE /activity_prices/1.json
  def destroy
    @activity_price = ActivityPrice.find(params[:id])
    @activity_price.destroy

    respond_to do |format|
      format.html { redirect_to activity_prices_url }
      format.json { head :no_content }
    end
  end
end
