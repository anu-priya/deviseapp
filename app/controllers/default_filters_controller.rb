class DefaultFiltersController < ApplicationController
  # GET /default_filters
  # GET /default_filters.json
  def index
    @default_filters = DefaultFilter.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @default_filters }
    end
  end

  # GET /default_filters/1
  # GET /default_filters/1.json
  def show
    @default_filter = DefaultFilter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @default_filter }
    end
  end

  # GET /default_filters/new
  # GET /default_filters/new.json
  def new
    @default_filter = DefaultFilter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @default_filter }
    end
  end

  # GET /default_filters/1/edit
  def edit
    @default_filter = DefaultFilter.find(params[:id])
  end

  # POST /default_filters
  # POST /default_filters.json
  def create
    @default_filter = DefaultFilter.new(params[:default_filter])

    respond_to do |format|
      if @default_filter.save
        format.html { redirect_to @default_filter, notice: 'Default filter was successfully created.' }
        format.json { render json: @default_filter, status: :created, location: @default_filter }
      else
        format.html { render action: "new" }
        format.json { render json: @default_filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /default_filters/1
  # PUT /default_filters/1.json
  def update
    @default_filter = DefaultFilter.find(params[:id])

    respond_to do |format|
      if @default_filter.update_attributes(params[:default_filter])
        format.html { redirect_to @default_filter, notice: 'Default filter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @default_filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /default_filters/1
  # DELETE /default_filters/1.json
  def destroy
    @default_filter = DefaultFilter.find(params[:id])
    @default_filter.destroy

    respond_to do |format|
      format.html { redirect_to default_filters_url }
      format.json { head :no_content }
    end
  end
end
