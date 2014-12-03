class ActivityRatingsController < ApplicationController
  # GET /activity_ratings
  # GET /activity_ratings.json
  def index
    @activity_ratings = ActivityRating.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activity_ratings }
    end
  end

  # GET /activity_ratings/1
  # GET /activity_ratings/1.json
  def show
    @activity_rating = ActivityRating.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity_rating }
    end
  end

  # GET /activity_ratings/new
  # GET /activity_ratings/new.json
  def new
    @activity_rating = ActivityRating.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @activity_rating }
    end
  end

  # GET /activity_ratings/1/edit
  def edit
    @activity_rating = ActivityRating.find(params[:id])
  end

  # POST /activity_ratings
  # POST /activity_ratings.json
  def create
    @activity_rating = ActivityRating.new(params[:activity_rating])

    respond_to do |format|
      if @activity_rating.save
        format.html { redirect_to @activity_rating, notice: 'Activity rating was successfully created.' }
        format.json { render json: @activity_rating, status: :created, location: @activity_rating }
      else
        format.html { render action: "new" }
        format.json { render json: @activity_rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /activity_ratings/1
  # PUT /activity_ratings/1.json
  def update
    @activity_rating = ActivityRating.find(params[:id])

    respond_to do |format|
      if @activity_rating.update_attributes(params[:activity_rating])
        format.html { redirect_to @activity_rating, notice: 'Activity rating was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @activity_rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_ratings/1
  # DELETE /activity_ratings/1.json
  def destroy
    @activity_rating = ActivityRating.find(params[:id])
    @activity_rating.destroy

    respond_to do |format|
      format.html { redirect_to activity_ratings_url }
      format.json { head :no_content }
    end
  end
end
