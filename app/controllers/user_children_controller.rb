class UserChildrenController < ApplicationController
  # GET /user_children
  # GET /user_children.json
  def index
    @user_children = UserChild.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_children }
    end
  end

  # GET /user_children/1
  # GET /user_children/1.json
  def show
    @user_child = UserChild.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_child }
    end
  end

  # GET /user_children/new
  # GET /user_children/new.json
  def new
    @user_child = UserChild.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_child }
    end
  end

  # GET /user_children/1/edit
  def edit
    @user_child = UserChild.find(params[:id])
  end

  # POST /user_children
  # POST /user_children.json
  def create
    @user_child = UserChild.new(params[:user_child])

    respond_to do |format|
      if @user_child.save
        format.html { redirect_to @user_child, notice: 'User child was successfully created.' }
        format.json { render json: @user_child, status: :created, location: @user_child }
      else
        format.html { render action: "new" }
        format.json { render json: @user_child.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_children/1
  # PUT /user_children/1.json
  def update
    @user_child = UserChild.find(params[:id])

    respond_to do |format|
      if @user_child.update_attributes(params[:user_child])
        format.html { redirect_to @user_child, notice: 'User child was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_child.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_children/1
  # DELETE /user_children/1.json
  def destroy
    @user_child = UserChild.find(params[:id])
    @user_child.destroy

    respond_to do |format|
      format.html { redirect_to user_children_url }
      format.json { head :no_content }
    end
  end
end
