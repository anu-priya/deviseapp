class ActivityCommentsController < ApplicationController
  # GET /activity_comments
  # GET /activity_comments.json
  def index
    @activity_comments = ActivityComment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activity_comments }
    end
  end

  # GET /activity_comments/1
  # GET /activity_comments/1.json
  def show
    @activity_comment = ActivityComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity_comment }
    end
  end

  # GET /activity_comments/new
  # GET /activity_comments/new.json
  def new
    @activity_comment = ActivityComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @activity_comment }
    end
  end

  # GET /activity_comments/1/edit
  def edit
    @activity_comment = ActivityComment.find(params[:id])
  end

  # POST /activity_comments
  # POST /activity_comments.json
  def create
    @activity_comment = ActivityComment.new(params[:activity_comment])

    respond_to do |format|
      if @activity_comment.save
        format.html { redirect_to @activity_comment, notice: 'Activity comment was successfully created.' }
        format.json { render json: @activity_comment, status: :created, location: @activity_comment }
      else
        format.html { render action: "new" }
        format.json { render json: @activity_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /activity_comments/1
  # PUT /activity_comments/1.json
  def update
    @activity_comment = ActivityComment.find(params[:id])

    respond_to do |format|
      if @activity_comment.update_attributes(params[:activity_comment])
        format.html { redirect_to @activity_comment, notice: 'Activity comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @activity_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_comments/1
  # DELETE /activity_comments/1.json
  def destroy
    @activity_comment = ActivityComment.find(params[:id])
    @activity_comment.destroy

    respond_to do |format|
      format.html { redirect_to activity_comments_url }
      format.json { head :no_content }
    end
  end
end
