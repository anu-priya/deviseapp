class ActivityBidsController < ApplicationController
  # GET /activity_bids
  # GET /activity_bids.json
  def index
    @activity_bids = ActivityBid.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activity_bids }
    end
  end

  # GET /activity_bids/1
  # GET /activity_bids/1.json
  def show
    @activity_bid = ActivityBid.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity_bid }
    end
  end

  # GET /activity_bids/new
  # GET /activity_bids/new.json
  def new
    @activity_bid = ActivityBid.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @activity_bid }
    end
  end

  # GET /activity_bids/1/edit
  def edit
    @activity_bid = ActivityBid.find(params[:id])
  end

  # POST /activity_bids
  # POST /activity_bids.json
  def create
    @activity_bid = ActivityBid.new(params[:activity_bid])

    respond_to do |format|
      if @activity_bid.save
        format.html { redirect_to @activity_bid, notice: 'Activity bid was successfully created.' }
        format.json { render json: @activity_bid, status: :created, location: @activity_bid }
      else
        format.html { render action: "new" }
        format.json { render json: @activity_bid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /activity_bids/1
  # PUT /activity_bids/1.json
  def update
    @activity_bid = ActivityBid.find(params[:id])

    respond_to do |format|
      if @activity_bid.update_attributes(params[:activity_bid])
        format.html { redirect_to @activity_bid, notice: 'Activity bid was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @activity_bid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_bids/1
  # DELETE /activity_bids/1.json
  def destroy
    @activity_bid = ActivityBid.find(params[:id])
    @activity_bid.destroy

    respond_to do |format|
      format.html { redirect_to activity_bids_url }
      format.json { head :no_content }
    end
  end
end
