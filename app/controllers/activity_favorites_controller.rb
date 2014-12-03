class ActivityFavoritesController < ApplicationController
  # GET /activity_favorites
  # GET /activity_favorites.json
  
  #activity favorites method calling here
  def favorite_exist
	  if current_user && current_user.present? && params[:activity_id]
	  @already_exist = ActivityFavorite.find_by_activity_id_and_user_id(params[:activity_id],!current_user.nil? && current_user.user_id) if !params[:activity_id].nil? && !current_user.nil?
		if @already_exist && @already_exist.present?
		  @fav = "already_exist"
		  @already_exist.destroy
		else
		  ActivityFavorite.create(:activity_id=>params[:activity_id], :user_id=>current_user.user_id, :inserted_date=>Time.now) if current_user && current_user.user_id.present?
		  @fav = "new_entry"
		end
	  end
	render :text=>@fav
  end

 #add calender in activity details page by rajkumar
 def add_calender
      @usr_cal = UserCalender.find_by_activity_id_and_user_id_and_schedule_id(params[:activity_id],params[:user_id],params[:schedule_id]) if !params[:activity_id].nil? && !params[:user_id].nil? && !params[:schedule_id].nil?
       if @usr_cal.nil?
	      @usr_cal = UserCalender.new
	      @usr_cal.activity_id = params[:activity_id] if !params[:activity_id].nil? && params[:activity_id]!="" && params[:activity_id].present?
	      @usr_cal.user_id = params[:user_id] if !params[:user_id].nil? && params[:user_id]!="" && params[:user_id].present?
	      @usr_cal.schedule_id = params[:schedule_id] if !params[:schedule_id].nil? && params[:schedule_id]!="" && params[:schedule_id].present?
	      @usr_cal.inserted_date = Time.now
	      @usr_cal.modified_date = Time.now
	      @usr_cal.save
	      @cal_val="success"
      else
	      if !@usr_cal.nil? && @usr_cal!="" && @usr_cal.present?
		@cal_val = 'cal_exist'
	      end
      end
	respond_to do |format|
	format.js
	end
end


 #New Detail page Add to calendar 
 def add_famtivity_calender
      @usr_cal = UserCalender.find_by_activity_id_and_user_id_and_schedule_id(params[:activity_id],params[:user_id],params[:schedule_id]) if !params[:activity_id].nil? && !params[:user_id].nil? && !params[:schedule_id].nil?
       if @usr_cal.nil?
	      @usr_cal = UserCalender.new
	      @usr_cal.activity_id = params[:activity_id] if !params[:activity_id].nil? && params[:activity_id]!="" && params[:activity_id].present?
	      @usr_cal.user_id = params[:user_id] if !params[:user_id].nil? && params[:user_id]!="" && params[:user_id].present?
	      @usr_cal.schedule_id = params[:schedule_id] if !params[:schedule_id].nil? && params[:schedule_id]!="" && params[:schedule_id].present?
	      @usr_cal.inserted_date = Time.now
	      @usr_cal.modified_date = Time.now
	      @usr_cal.save
	      @cal_val="success"
      else
	      if !@usr_cal.nil? && @usr_cal!="" && @usr_cal.present?
		@cal_val = 'cal_exist'
	      end
      end
      
      if (!@cal_val.nil? && @cal_val=="success")
	      @success_mess = "This activity is successfully added to your calendar"
      elsif (!@cal_val.nil? && @cal_val=="cal_exist")
	      @success_mess = "This activity is already added to your calendar"
      end
      
	respond_to do |format|
          format.js{render :text => 
           "$('html, body').animate({ scrollTop: 0 });
            $('.flash-message').html('#{@success_mess}');
            var win=$(window).width();
            var con=$('.flash_content').width();
            var leftvalue=((win/2)-(con/2))
            $('.flash_content').css('left',leftvalue+'px');
            $('.flash_content').css('top','67px');
            $('.flash_content').fadeIn().delay(5000).fadeOut();"
              }
	end
 end

 
  def add_to_favourite
    p params.inspect
  end

  def add_favorite
    @user_fav = ActivityFavorite.find_by_activity_id_and_user_id(params[:activity_id],params[:user_id])
    #shared removed. user check
	@user = User.find_by_user_id(params[:user_id])	
    @user_shared = ActivityShared.find_by_activity_id_and_shared_to(params[:activity_id],@user["email_address"]) if @user.present? && !@user.nil?
    @row = params[:row]
    @send = "Failure"
    if @user_fav.nil? && @row.nil?
      @favour = ActivityFavorite.new
      @favour.activity_id = params[:activity_id]
      @favour.user_id = params[:user_id]
      @favour.inserted_date = Time.now
      @favour.save
      @send = "Success"
    elsif !@row.nil? && @row.present? && @row=="shared"
       @user_shared.destroy if !@user_shared.nil? && @user_shared.present? && @user_shared != ""
    else
	     @user_fav.destroy if @user_fav != ""
    end

    respond_to do |format|
      format.js
      format.json {render :json =>@send.to_json}
    end

  end


  def index
    @activity_favorites = ActivityFavorite.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activity_favorites }
    end
  end

  # GET /activity_favorites/1
  # GET /activity_favorites/1.json
  def show
    @activity_favorite = ActivityFavorite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity_favorite }
    end
  end

  # GET /activity_favorites/new
  # GET /activity_favorites/new.json
  def new
    @activity_favorite = ActivityFavorite.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @activity_favorite }
    end
  end

  # GET /activity_favorites/1/edit
  def edit
    @activity_favorite = ActivityFavorite.find(params[:id])
  end

  # POST /activity_favorites
  # POST /activity_favorites.json
  def create
    @activity_favorite = ActivityFavorite.new(params[:activity_favorite])

    respond_to do |format|
      if @activity_favorite.save
        format.html { redirect_to @activity_favorite, notice: 'Activity favorite was successfully created.' }
        format.json { render json: @activity_favorite, status: :created, location: @activity_favorite }
      else
        format.html { render action: "new" }
        format.json { render json: @activity_favorite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /activity_favorites/1
  # PUT /activity_favorites/1.json
  def update
    @activity_favorite = ActivityFavorite.find(params[:id])

    respond_to do |format|
      if @activity_favorite.update_attributes(params[:activity_favorite])
        format.html { redirect_to @activity_favorite, notice: 'Activity favorite was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @activity_favorite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_favorites/1
  # DELETE /activity_favorites/1.json
  def destroy
    @activity_favorite = ActivityFavorite.find(params[:id])
    @activity_favorite.destroy

    respond_to do |format|
      format.html { redirect_to activity_favorites_url }
      format.json { head :no_content }
    end
  end
end
