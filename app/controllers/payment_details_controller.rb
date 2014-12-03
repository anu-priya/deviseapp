class PaymentDetailsController < ApplicationController
  # GET /payment_details
  # GET /payment_details.json
  def index
    @payment_details = PaymentDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payment_details }
    end
  end

  # GET /payment_details/1
  # GET /payment_details/1.json
  def show
    @payment_detail = PaymentDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment_detail }
    end
  end

  # GET /payment_details/new
  # GET /payment_details/new.json
  def new
    @payment_detail = PaymentDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment_detail }
    end
  end

  # GET /payment_details/1/edit
  def edit
    @payment_detail = PaymentDetail.find(params[:id])
  end

  # POST /payment_details
  # POST /payment_details.json
  def create
    @payment_detail = PaymentDetail.new(params[:payment_detail])

    respond_to do |format|
      if @payment_detail.save
        format.html { redirect_to @payment_detail, notice: 'Payment detail was successfully created.' }
        format.json { render json: @payment_detail, status: :created, location: @payment_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @payment_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payment_details/1
  # PUT /payment_details/1.json
  def update
    @payment_detail = PaymentDetail.find(params[:id])

    respond_to do |format|
      if @payment_detail.update_attributes(params[:payment_detail])
        format.html { redirect_to @payment_detail, notice: 'Payment detail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_details/1
  # DELETE /payment_details/1.json
  def destroy
    @payment_detail = PaymentDetail.find(params[:id])
    @payment_detail.destroy

    respond_to do |format|
      format.html { redirect_to payment_details_url }
      format.json { head :no_content }
    end
  end
end
