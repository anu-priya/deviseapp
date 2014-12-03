class FamPostsController < ApplicationController
  # GET /fam_posts
  # GET /fam_posts.json
  def index
    @fam_posts = FamPost.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fam_posts }
    end
  end

  # GET /fam_posts/1
  # GET /fam_posts/1.json
  def show
    @fam_post = FamPost.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fam_post }
    end
  end

  # GET /fam_posts/new
  # GET /fam_posts/new.json
  def new
    @fam_post = FamPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fam_post }
    end
  end

  # GET /fam_posts/1/edit
  def edit
    @fam_post = FamPost.find(params[:id])
  end

  # POST /fam_posts
  # POST /fam_posts.json
  def create
    @fam_post = FamPost.new(params[:fam_post])

    respond_to do |format|
      if @fam_post.save
        format.html { redirect_to @fam_post, notice: 'Fam post was successfully created.' }
        format.json { render json: @fam_post, status: :created, location: @fam_post }
      else
        format.html { render action: "new" }
        format.json { render json: @fam_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fam_posts/1
  # PUT /fam_posts/1.json
  def update
    @fam_post = FamPost.find(params[:id])

    respond_to do |format|
      if @fam_post.update_attributes(params[:fam_post])
        format.html { redirect_to @fam_post, notice: 'Fam post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fam_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fam_posts/1
  # DELETE /fam_posts/1.json
  def destroy
    @fam_post = FamPost.find(params[:id])
    @fam_post.destroy

    respond_to do |format|
      format.html { redirect_to fam_posts_url }
      format.json { head :no_content }
    end
  end
end
