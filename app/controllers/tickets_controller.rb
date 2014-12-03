class TicketsController < ApplicationController
  before_filter :authenticate_user

  
  def ticket_update
    session[:city] = params[:city] unless params[:city].nil?
    session[:date] = params[:date] unless params[:date].nil?
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
    session[:city] = "Walnut Creek" if session[:city].nil?
    act = Activity.get_providertype_zip_code_update(session[:city],params[:zip_code],session[:date],cookies[:uid_usr])
    @activities = act.paginate(:page => params[:page], :per_page =>10)
    respond_to do |format|
      format.js
      format.json {render :json =>@activities}
    end
  end


  def index 
    act = Activity.order("activity_id desc").find(:all,:conditions=>["created_by = ? and user_id = ? and active_status != ? ","Provider",cookies[:uid_usr], "Delete"])
    #act = Activity.order("activity_id desc").where("active_status like '%Inactive%'").where('user_id = ?', current_user.user_id)
    @activities = act.paginate(:page => params[:page], :per_page =>10)
    #act = Activity.where("active_status like '%Active%'")
    #@activities = act.paginate(:page => params[:page], :per_page =>10)
    #act = Activity.order("activity_id desc").find(:all,:conditions=>["created_by = ? and user_id = ? ","Provider",cookies[:uid_usr]])
  end

  def accept_tickets
	  @get_current_url = request.env['HTTP_HOST']
  end

  def participant_detail
  
  end
  def ticket_edit
  
  end

  def ticket_newedit

      @activities = Activity.find(params[:id])

  end

  def ticket_view
  
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def ticket_show
    @activities = Activity.find(params[:id])
  end

  def show
        @activities = Activity.find(params[:id])

   # @ticket = Ticket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ticket }
    end
  end

  # GET /tickets/new
  # GET /tickets/new.json
  def new
    @ticket = Ticket.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ticket }
    end
  end

  # GET /tickets/1/edit
  def edit
    @ticket = Ticket.find(params[:id])
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(params[:ticket])

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render json: @ticket, status: :created, location: @ticket }
      else
        format.html { render action: "new" }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.json
  def update
    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to tickets_url }
      format.json { head :no_content }
    end
  end
end
