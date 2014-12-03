
namespace :transaction  do
 desc "update transaction details with famtivity_fee and credit_card_fee"
   task :update_fees => :environment do
      @user_tran = TransactionDetail.all
      @user_tran.each do |u|
	      if u && !u.nil? && u.present?
		 u.famtivity_fee = 2.5
		 u.credit_card_fee = 3
		 u.save
	      if u.save
		       p "Transaction Detail updated with famtivity_fee 2.5 and credit_card_fee 3"
	      end
	    end
      end
	@fam_fee = FamFeeDetail.new
	@fam_fee.famtivity_fee = 5
	@fam_fee.credit_card_fee = 3
	@fam_fee.save
		if @fam_fee.save
			p "In fam_fee_details new record inserted with famtivity_fee #{@fam_fee.famtivity_fee} and credit_card_fee #{@fam_fee.credit_card_fee}" 
		end
   end
end