class AgerangeColorsController < ApplicationController
  # GET /agerange_colors
  # GET /agerange_colors.json
  def index
    @agerange_colors = AgerangeColor.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @agerange_colors }
    end
  end

  # GET /agerange_colors/1
  # GET /agerange_colors/1.json
  def show
    @agerange_color = AgerangeColor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @agerange_color }
    end
  end

  # GET /agerange_colors/new
  # GET /agerange_colors/new.json
  def new
    @agerange_color = AgerangeColor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @agerange_color }
    end
  end

  # GET /agerange_colors/1/edit
  def edit
    @agerange_color = AgerangeColor.find(params[:id])
  end

  # POST /agerange_colors
  # POST /agerange_colors.json
  def create
    @agerange_color = AgerangeColor.new(params[:agerange_color])

    respond_to do |format|
      if @agerange_color.save
        format.html { redirect_to @agerange_color, notice: 'Agerange color was successfully created.' }
        format.json { render json: @agerange_color, status: :created, location: @agerange_color }
      else
        format.html { render action: "new" }
        format.json { render json: @agerange_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /agerange_colors/1
  # PUT /agerange_colors/1.json
  def update
    @agerange_color = AgerangeColor.find(params[:id])

    respond_to do |format|
      if @agerange_color.update_attributes(params[:agerange_color])
        format.html { redirect_to @agerange_color, notice: 'Agerange color was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @agerange_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agerange_colors/1
  # DELETE /agerange_colors/1.json
  def destroy
    @agerange_color = AgerangeColor.find(params[:id])
    @agerange_color.destroy

    respond_to do |format|
      format.html { redirect_to agerange_colors_url }
      format.json { head :no_content }
    end
  end
end
