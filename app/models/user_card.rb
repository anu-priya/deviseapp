class UserCard < ActiveRecord::Base
  attr_accessible :card_number, :cvc_no, :expiration_date, :first_name, :last_name,:country,:zip_code,:state,:address_1,:address_2,:city,:email,:supplier_code,
    :legal_name,:tax_code,:street,:number_reg, :state_reg,:zip_code,:bank_name,:bank_street,:bank_number,:bank_state,:bank_city,:bank_zip_code,:fax_number,
    :wire_transfer,:clear_house,:account_no,:swift_code
end


