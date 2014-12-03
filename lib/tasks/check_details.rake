namespace :check_details  do
  desc "update all the discount price table with activity id"
  task :bank => :environment do
   @user_bank= UserBankDetail.find(:all) 
   @user_bank.each do |user_bank|
      if !user_bank.nil? && !user_bank.payee_name.nil? && user_bank.payee_name.present?
        user_bank.check_street_address=  user_bank.street_address
        user_bank.check_state= user_bank.bank_state
        user_bank.check_city=  user_bank.bank_city
        user_bank.check_zip_code=  user_bank.bank_zip_code
        user_bank.check_country= user_bank.bank_country
        user_bank.prefered_mode= "check"
      else
        user_bank.bank_street_address=  user_bank.street_address
        user_bank.prefered_mode= "bank"
      end
      user_bank.save
      p "Updated check details: #{user_bank.user_id}"
   end  if !@user_bank.nil? && @user_bank.present?
  end
end

