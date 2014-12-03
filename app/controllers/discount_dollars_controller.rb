class DiscountDollarsController < ApplicationController
layout 'provider_layout'
  def index
    @click_mode = params[:mode]  if !params[:mode].nil?
    if !current_user.nil? && current_user.present?
	    @credit_list = UserCredit.where("user_id=?",current_user.user_id)
	    @cdt_tot = @credit_list.length
	    @debit_list = UserDebit.where("user_id=?",current_user.user_id)
	    @dbt_tot = @debit_list.length
	    @invitor_list = InvitorList.where("user_id=?",current_user.user_id)
	    @ivted_tot = @invitor_list.length
	    #~ discount_cal = UserCredit.discount_calc(@credit_list,@debit_list)
	   
	    @t_cred_amount =  (!@credit_list.nil?) ? @credit_list.sum(&:credit_amount) : 0
	    @t_debit_amount = (!@debit_list.nil?) ? @debit_list.sum(&:debited_amount) : 0
    end
    render :layout=>"landing_layout"
  end
  
 def provider_activity_discount
    pro_fees = ProviderDiscountType.where("user_id=#{current_user.user_id}")
    @pro_fees = pro_fees.paginate(:page => params[:page], :per_page =>10)
    @protot = @pro_fees.length
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def edit_discount_type
    @chose_disc = ProviderDiscountType.where("user_id=#{current_user.user_id} and provider_discount_type_id=#{params[:cu_value]}").last
    respond_to do |format|
      format.js
    end
  end

  def update_discount_type
    @chose_disc = ProviderDiscountType.where("user_id=#{current_user.user_id} and provider_discount_type_id=#{params[:cu_value]}").last
    if !@chose_disc.nil?
      @chose_disc.discount_name = params[:disc_name]
      @chose_disc.valid_date = params[:disc_valid_date]
      @chose_disc.quantity = params[:disc_quantity]
      @chose_disc.note = params[:note]
      @chose_disc.user_id=current_user.user_id
      @chose_disc.save
      act_price = ActivityDiscountPrice.where("provider_discount_type_id=#{@chose_disc.provider_discount_type_id}")
      act_price.each do |price|
        price.discount_type=params[:disc_name]
        price.save
      end
    end
    pro_fees = ProviderDiscountType.where("user_id=#{current_user.user_id}")
    @pro_fees = pro_fees.paginate(:page => params[:page], :per_page =>10)
    respond_to do |format|
      format.js
    end
  end
	
  def provider_discount_type
    @provider_type = ProviderDiscountType.new
    @provider_type.discount_name = params[:disc_name]
    @provider_type.valid_date = params[:disc_valid_date]
    @provider_type.quantity = params[:disc_quantity]
    @provider_type.note = params[:note]
    @provider_type.user_id=current_user.user_id
    @provider_type.save
    @pro_fees = ProviderDiscountType.where("user_id=#{current_user.user_id}")
    respond_to do |format|
      format.js
    end
  end
	
  #before deleting the discount
  def delete_discount
    @page = params[:page]
    @dicount=params[:id] if !params[:id].nil?
    @to_delete=params[:id].split(',')
    @list = params[:mul]
    @del_act = params[:del_action]
    render :layout => nil
  end


  def discount_destroy
    dis_id=params[:id].gsub(/&\w+;/, '').parameterize
    all_id=dis_id.split('-');
    all_id.each do |al|
      pro_fees = ProviderDiscountType.find(al)
      act_price = ActivityDiscountPrice.where("provider_discount_type_id=#{al}")
      act_price.each do |price|
        price.destroy
      end
      pro_fees.destroy
    end
    @pro_fees = ProviderDiscountType.where("user_id=#{current_user.user_id}")
    @pro_fees = @pro_fees.paginate(:page => params[:page], :per_page =>10)
    @protot = @pro_fees.length
    respond_to do |format|
      format.js
      format.html
    end
  end
	
end