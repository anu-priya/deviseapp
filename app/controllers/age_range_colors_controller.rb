class AgeRangeColorsController < ApplicationController
  # GET /age_range_colors
  # GET /age_range_colors.json
  def index
    @age_range_colors = AgeRangeColor.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @age_range_colors }
    end
  end


  def age_range_create
      @age_range_color = AgeRangeColor.new(params[:id])
   
     if @age_range_color.save
     else
     end

  end

  # GET /age_range_colors/1
  # GET /age_range_colors/1.json
  def show
    @age_range_color = AgeRangeColor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @age_range_color }
    end
  end

  # GET /age_range_colors/new
  # GET /age_range_colors/new.json
  def new
    @age_range_color = AgeRangeColor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @age_range_color }
    end
  end

  # GET /age_range_colors/1/edit
  def edit
    @age_range_color = AgeRangeColor.find(params[:id])
  end

  # POST /age_range_colors
  # POST /age_range_colors.json
  def create
    @age_range_color = AgeRangeColor.new(params[:age_range_color])

    respond_to do |format|
      if @age_range_color.save
        format.html { redirect_to @age_range_color, notice: 'Age range color was successfully created.' }
        format.json { render json: @age_range_color, status: :created, location: @age_range_color }
      else
        format.html { render action: "new" }
        format.json { render json: @age_range_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /age_range_colors/1
  # PUT /age_range_colors/1.json
  def update
    @age_range_color = AgeRangeColor.find(params[:id])

    respond_to do |format|
      if @age_range_color.update_attributes(params[:age_range_color])
        format.html { redirect_to @age_range_color, notice: 'Age range color was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @age_range_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /age_range_colors/1
  # DELETE /age_range_colors/1.json
  def destroy
    @age_range_color = AgeRangeColor.find(params[:id])
    @age_range_color.destroy

    respond_to do |format|
      format.html { redirect_to age_range_colors_url }
      format.json { head :no_content }
    end
  end
end
