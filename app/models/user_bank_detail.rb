class UserBankDetail < ActiveRecord::Base
  attr_accessible :bank_country, :payee_name, :business_name, :bank_city, :bank_state, :bank_zip_code, :street_number, :street_address, :prem_city, :perm_state, :prem_zip_code, :user_id, :bank_name,:bank_wire_transfer,:bank_clear_house,:bank_account_number,:bank_swift_code, :bank_account_name, :check_street_address, :bank_street_address, :check_city, :check_state, :check_zip_code, :check_country, :prefered_mode
  belongs_to :user
  def self.user_check_form(uid,paye_name,c_business_name,street_check_code,bank_state,check_bank_city,check_z_code,bank_country)
	@user_bank = UserBankDetail.new
	@user_bank.user_id = "#{uid}" if uid != nil && uid != "" && !uid.nil?
	@user_bank.payee_name = "#{paye_name}" if paye_name != nil && paye_name != "" && !paye_name.nil?
	@user_bank.business_name = "#{c_business_name}" if c_business_name != nil && c_business_name != "" && !c_business_name.nil?
	@user_bank.check_street_address = "#{street_check_code}" if street_check_code != "Enter street number & street address" && !street_check_code.nil? && street_check_code != ""
	@user_bank.check_state = "#{bank_state}" if bank_state != nil && bank_state != "" && !bank_state.nil?
	@user_bank.check_city = "#{check_bank_city}"  if check_bank_city != nil && check_bank_city != "" && !check_bank_city.nil?
	@user_bank.check_zip_code = "#{check_z_code}" if check_z_code != nil && check_z_code != "" && !check_z_code.nil?
	@user_bank.check_country = "#{bank_country}" if bank_country != nil && bank_country != "" && !bank_country.nil?
	@user_bank.prefered_mode = "check"
	@user_bank.save
end #method ending
def self.user_bank_form(uid,bank_name,account_name,w_transfer,acc_number,bank_state,bank_city,bank_z_code,street_bank_code)
	@user_bank = UserBankDetail.new
	@user_bank.bank_name = "#{bank_name}"  if !bank_name.nil? && bank_name!="" && bank_name!="Name of bank"
	@user_bank.bank_account_name = "#{account_name}"  if !account_name.nil? && account_name!="" && account_name!="Enter your account name"
	@user_bank.bank_wire_transfer = "#{w_transfer}"  if !w_transfer.nil? && w_transfer!="" && w_transfer!="Enter the routing number"
	@user_bank.bank_account_number = "#{acc_number}" if !acc_number.nil? && acc_number!="" && acc_number!="Enter your account number"
	@user_bank.bank_state = "#{bank_state}"  if !bank_state.nil? && bank_state!=""
	@user_bank.bank_city = "#{bank_city}" if !bank_city.nil? && bank_city!=""
	@user_bank.bank_zip_code = "#{bank_z_code}" if !bank_z_code.nil? && bank_z_code!="" && bank_z_code!="Enter zip code"
	@user_bank.bank_street_address = "#{street_bank_code}"  if !street_bank_code.nil? && street_bank_code!="" && street_bank_code!="Enter street number & street address"
	@user_bank.user_id = "#{uid}" if uid != nil && uid != "" && !uid.nil?
	@user_bank.prefered_mode = "bank"
	@user_bank.save
 end #method ending
end

