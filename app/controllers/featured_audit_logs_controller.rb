class FeaturedAuditLogsController < ApplicationController
  # GET /featured_audit_logs
  # GET /featured_audit_logs.json
  def index
    @featured_audit_logs = FeaturedAuditLog.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @featured_audit_logs }
    end
  end

  # GET /featured_audit_logs/1
  # GET /featured_audit_logs/1.json
  def show
    @featured_audit_log = FeaturedAuditLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @featured_audit_log }
    end
  end

  # GET /featured_audit_logs/new
  # GET /featured_audit_logs/new.json
  def new
    @featured_audit_log = FeaturedAuditLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @featured_audit_log }
    end
  end

  # GET /featured_audit_logs/1/edit
  def edit
    @featured_audit_log = FeaturedAuditLog.find(params[:id])
  end

  # POST /featured_audit_logs
  # POST /featured_audit_logs.json
  def create
    @featured_audit_log = FeaturedAuditLog.new(params[:featured_audit_log])

    respond_to do |format|
      if @featured_audit_log.save
        format.html { redirect_to @featured_audit_log, notice: 'Featured audit log was successfully created.' }
        format.json { render json: @featured_audit_log, status: :created, location: @featured_audit_log }
      else
        format.html { render action: "new" }
        format.json { render json: @featured_audit_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /featured_audit_logs/1
  # PUT /featured_audit_logs/1.json
  def update
    @featured_audit_log = FeaturedAuditLog.find(params[:id])

    respond_to do |format|
      if @featured_audit_log.update_attributes(params[:featured_audit_log])
        format.html { redirect_to @featured_audit_log, notice: 'Featured audit log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @featured_audit_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /featured_audit_logs/1
  # DELETE /featured_audit_logs/1.json
  def destroy
    @featured_audit_log = FeaturedAuditLog.find(params[:id])
    @featured_audit_log.destroy

    respond_to do |format|
      format.html { redirect_to featured_audit_logs_url }
      format.json { head :no_content }
    end
  end
end
