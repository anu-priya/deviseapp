class ActivityRepeatsController < ApplicationController
  # GET /activity_repeats
  # GET /activity_repeats.json
  def index
    @activity_repeats = ActivityRepeat.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activity_repeats }
    end
  end

  # GET /activity_repeats/1
  # GET /activity_repeats/1.json
  def show
    @activity_repeat = ActivityRepeat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity_repeat }
    end
  end

  # GET /activity_repeats/new
  # GET /activity_repeats/new.json
  def new
    @activity_repeat = ActivityRepeat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @activity_repeat }
    end
  end

  # GET /activity_repeats/1/edit
  def edit
    @activity_repeat = ActivityRepeat.find(params[:id])
  end

  # POST /activity_repeats
  # POST /activity_repeats.json
  def create
    @activity_repeat = ActivityRepeat.new(params[:activity_repeat])

    respond_to do |format|
      if @activity_repeat.save
        format.html { redirect_to @activity_repeat, notice: 'Activity repeat was successfully created.' }
        format.json { render json: @activity_repeat, status: :created, location: @activity_repeat }
      else
        format.html { render action: "new" }
        format.json { render json: @activity_repeat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /activity_repeats/1
  # PUT /activity_repeats/1.json
  def update
    @activity_repeat = ActivityRepeat.find(params[:id])

    respond_to do |format|
      if @activity_repeat.update_attributes(params[:activity_repeat])
        format.html { redirect_to @activity_repeat, notice: 'Activity repeat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @activity_repeat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_repeats/1
  # DELETE /activity_repeats/1.json
  def destroy
    @activity_repeat = ActivityRepeat.find(params[:id])
    @activity_repeat.destroy

    respond_to do |format|
      format.html { redirect_to activity_repeats_url }
      format.json { head :no_content }
    end
  end
end
