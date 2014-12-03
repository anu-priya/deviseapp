class ActivityRowsController < ApplicationController
  # GET /activity_rows
  # GET /activity_rows.json
  def index
    @activity_rows = ActivityRow.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activity_rows }
    end
  end

  # GET /activity_rows/1
  # GET /activity_rows/1.json
  def show
    @activity_row = ActivityRow.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity_row }
    end
  end

  # GET /activity_rows/new
  # GET /activity_rows/new.json
  def new
    @activity_row = ActivityRow.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @activity_row }
    end
  end

  # GET /activity_rows/1/edit
  def edit
    @activity_row = ActivityRow.find(params[:id])
  end

  # POST /activity_rows
  # POST /activity_rows.json
  def create
    @activity_row = ActivityRow.new(params[:activity_row])

    respond_to do |format|
      if @activity_row.save
        format.html { redirect_to @activity_row, notice: 'Activity row was successfully created.' }
        format.json { render json: @activity_row, status: :created, location: @activity_row }
      else
        format.html { render action: "new" }
        format.json { render json: @activity_row.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /activity_rows/1
  # PUT /activity_rows/1.json
  def update
    @activity_row = ActivityRow.find(params[:id])

    respond_to do |format|
      if @activity_row.update_attributes(params[:activity_row])
        format.html { redirect_to @activity_row, notice: 'Activity row was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @activity_row.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_rows/1
  # DELETE /activity_rows/1.json
  def destroy
    @activity_row = ActivityRow.find(params[:id])
    @activity_row.destroy

    respond_to do |format|
      format.html { redirect_to activity_rows_url }
      format.json { head :no_content }
    end
  end
end
