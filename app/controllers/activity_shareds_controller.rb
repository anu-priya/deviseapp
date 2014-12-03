class ActivitySharedsController < ApplicationController
  # GET /activity_shareds
  # GET /activity_shareds.json
  def index
    @activity_shareds = ActivityShared.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activity_shareds }
    end
  end

  # GET /activity_shareds/1
  # GET /activity_shareds/1.json
  def show
    @activity_shared = ActivityShared.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity_shared }
    end
  end

  # GET /activity_shareds/new
  # GET /activity_shareds/new.json
  def new
    @activity_shared = ActivityShared.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @activity_shared }
    end
  end

  # GET /activity_shareds/1/edit
  def edit
    @activity_shared = ActivityShared.find(params[:id])
  end

  # POST /activity_shareds
  # POST /activity_shareds.json
  def create
    @activity_shared = ActivityShared.new(params[:activity_shared])

    respond_to do |format|
      if @activity_shared.save
        format.html { redirect_to @activity_shared, notice: 'Activity shared was successfully created.' }
        format.json { render json: @activity_shared, status: :created, location: @activity_shared }
      else
        format.html { render action: "new" }
        format.json { render json: @activity_shared.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /activity_shareds/1
  # PUT /activity_shareds/1.json
  def update
    @activity_shared = ActivityShared.find(params[:id])

    respond_to do |format|
      if @activity_shared.update_attributes(params[:activity_shared])
        format.html { redirect_to @activity_shared, notice: 'Activity shared was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @activity_shared.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_shareds/1
  # DELETE /activity_shareds/1.json
  def destroy
    @activity_shared = ActivityShared.find(params[:id])
    @activity_shared.destroy

    respond_to do |format|
      format.html { redirect_to activity_shareds_url }
      format.json { head :no_content }
    end
  end
end
