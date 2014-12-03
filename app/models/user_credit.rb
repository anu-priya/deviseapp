class UserCredit < ActiveRecord::Base
  belongs_to :user
  
  def self.discount_calc_check(credit_list,debit_list)
    t_cred_amount=0
    t_debit_amount=0
    if (!credit_list.nil?)
      if (!credit_list.credit_amount.nil? && !credit_list.used_amount.nil? && credit_list.credit_amount >= credit_list.used_amount)
        amt = (credit_list.credit_amount - credit_list.used_amount)
      elsif (!credit_list.credit_amount.nil?)
        amt = credit_list.credit_amount
      end
      t_cred_amount = t_cred_amount+amt
    end
    
    if (!debit_list.nil?)
      t_debit_amount = t_debit_amount+ debit_list.discounted_amount
    end
    return t_cred_amount,t_debit_amount
  end
end
