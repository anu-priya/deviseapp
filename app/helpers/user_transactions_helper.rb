module UserTransactionsHelper

#reports activity status for views
def reports_activity_views(acid)
    @week_start = Date.today.beginning_of_week.strftime("%Y-%m-%d")
    @week_end = Date.today.end_of_week.strftime("%Y-%m-%d")
    @total_views = Activity.find_by_sql("select sum(view_count) as view_count from activity_counts where activity_id = #{acid} and (date(inserted_date) between date('#{@week_start}') and date('#{@week_end}')) and view_count is not null") if !acid.nil? && acid!="" && acid.present?
	 if @total_views && @total_views!=[] && !@total_views.nil? && @total_views!="" && @total_views.present?
			@total_views && @total_views.present? && @total_views.each do |view_t| 
			if view_t.view_count!="" && view_t.view_count!=nil && view_t.view_count.present?
			@tot_view_act = view_t.view_count
			else
			@tot_view_act = 0
			end
		end #do ending here
	else
		@tot_view_act=0
	end
	return @tot_view_act
end

#reports activity status for shared
def reports_activity_shared(acid)
    @week_start = Date.today.beginning_of_week.strftime("%Y-%m-%d")
    @week_end = Date.today.end_of_week.strftime("%Y-%m-%d")
    @total_shares = Activity.find_by_sql("select sum(share_count) as share_count from activity_counts where activity_id = #{acid} and (date(inserted_date) between date('#{@week_start}') and date('#{@week_end}')) and share_count is not null") if !acid.nil? && acid!="" && acid.present?
	 if @total_shares && @total_shares!=[] && !@total_shares.nil? && @total_shares!="" && @total_shares.present?
			@total_shares && @total_shares.present? && @total_shares.each do |view_t| 
			if view_t.share_count!="" && view_t.share_count!=nil && view_t.share_count.present?
			@tot_share_act = view_t.share_count
			else
			@tot_share_act = 0
			end
		end #do ending here
	else
		@tot_share_act=0
	end
	return @tot_share_act
end

#displayed the activity status for the provider activities list(Active,Inactive,Expired)
def reports_activity_status(acid,uid)
	#~ @activity_exp = Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id left join school_representatives school on act.activity_id = school.activity_id where act_sch.expiration_date < '#{Date.today.strftime("%Y-%m-%d")}' and (lower(act.active_status)='inactive' or lower(act.active_status)='active') and lower(act.created_by)='provider' and (act.user_id=#{uid} or school.vendor_id=#{uid}) and act.activity_id=#{acid}") if !acid.nil? && acid!="" && acid.present? && uid.present?
	@activity_exp = Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id left join school_representatives school on act.activity_id = school.activity_id where act_sch.expiration_date < '#{Date.today.strftime("%Y-%m-%d")}' and (lower(act.active_status)='inactive' or lower(act.active_status)='active') and lower(act.created_by)='provider' and (act.user_id=#{uid} or school.vendor_id=#{uid}) and act.activity_id not in (select act.activity_id from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where lower(act.created_by)='provider' and act.activity_id=#{acid} and act.user_id=#{uid} and act_sch.expiration_date >= '#{Date.today.strftime("%Y-%m-%d")}') and act.activity_id=#{acid}") if !acid.nil? && acid!="" && acid.present? && uid.present?
	#checked the expired activities for the provider users list
	if @activity_exp && @activity_exp!=[] && !@activity_exp.nil? && @activity_exp!="" && @activity_exp.present?
		expired_act = "Expired"
	else
		act_status = Activity.find_by_activity_id(acid) if !acid.nil?
		expired_act = act_status.active_status if !act_status.nil? && !act_status.active_status.nil?
	end
	return expired_act
end


def calculate_fam_fee(amt)
	if (amt && amt!='free' && amt.to_f > 0)
	   tot_amt = amt.to_f
	   disc = (tot_amt*2.5)/100
	   net_pay_disc = (tot_amt*3)/100
	   disc_per = (disc!=0 && disc > 0.99) ? disc : 0.99 
	   net_pay_disc1 = (net_pay_disc!=0 && net_pay_disc > 0.99) ? net_pay_disc : 0.99
	   tot_discount = net_pay_disc1 + disc_per
	   amount = (tot_amt > tot_discount) ? (tot_amt-tot_discount) : tot_amt
	   return disc_per,amount,net_pay_disc1
	end
end

#admin transaction page calculate share and fee
def calculate_share_fee_for_both(amt,act_id,rep_flag,rep_share,pro_share,tran_date)
	tot_amt=amt.to_f	
	if rep_flag
		fam_fee = (tot_amt*5)/100
		card_pay = (tot_amt*3)/100	
	
		 repshare = rep_share.round
		 proshare = (100-repshare).round
		
		rep_fee = (tot_amt*2.5)/100
		
		rep_reduce = (rep_fee!=0 && rep_fee > 0.99) ? rep_fee : 0.99 
		fam_reduce = (fam_fee!=0 && fam_fee > 0.99) ? fam_fee : 0.99 
		card_reduce = (card_pay!=0 && card_pay > 0.99) ? card_pay : 0.99 	
		
		if fam_fee!=0 && fam_fee > 0.99
			fam_reduce = fam_fee 
			tot_reduce = fam_reduce + card_reduce
			r_share = rep_share.round
			p_share = (100-r_share).round
			if tot_amt > tot_reduce
				t_amt = tot_amt-tot_reduce		
				r_amount = (t_amt*r_share)/100	
				p_net_amount = (t_amt*p_share)/100				
				r_net_amount = ((tran_date >= Date.parse("2013-12-27")) && fam_reduce && !fam_reduce.nil? && fam_reduce!=0)  ? (r_amount+(fam_reduce/2)) : r_amount
			else
				r_net_amount = (tot_amt*r_share)/100	
				p_net_amount = (tot_amt*p_share)/100				
			end			
		else
			tot_reduce = fam_reduce + card_reduce
			r_share = rep_share.round
			p_share = (100-r_share).round
			if tot_amt > tot_reduce
				t_amt = tot_amt-tot_reduce		
				r_amount = (t_amt*r_share)/100	
				p_net_amount = (t_amt*p_share)/100				
				r_net_amount = ((tran_date >= Date.parse("2013-12-27")) && fam_reduce && !fam_reduce.nil? && fam_reduce!=0)  ? (r_amount+(fam_reduce/2)) : r_amount
			else
				r_net_amount = (tot_amt*r_share)/100	
				p_net_amount = (tot_amt*p_share)/100				
			end
		end
		fam_fee_text = "-5% = $#{fam_reduce}"
		rep_fee_text = "+2.5% = $#{rep_reduce}"
		return fam_fee_text,card_reduce,p_net_amount,rep_fee_text,repshare,proshare,r_net_amount
	else
		fam_fee = (tot_amt*2.5)/100
		card_pay = (tot_amt*3)/100
		fam_reduce = (fam_fee!=0 && fam_fee > 0.99) ? fam_fee : 0.99 
		card_reduce = (card_pay!=0 && card_pay > 0.99) ? card_pay : 0.99 
		tot_reduce = fam_reduce + card_reduce
		net_amount = (tot_amt > tot_reduce) ? (tot_amt-tot_reduce) : tot_amt
		fam_fee_text = "-2.5% = $#{fam_reduce}"
		return fam_fee_text,card_reduce,net_amount
	end
end

#provider reports page
def calculate_fam_fee_for_provider_reports(amt,act_id,current_u_id,fam_fee,credit_fee,tran_date)
	if (!credit_fee.nil? && amt && amt!='free' && amt.to_f > 0)
	   tot_amt = amt.to_f
	   #credit fee calculation
	   cred_fee = (tot_amt*credit_fee)/100
	   cred_fee_per = (cred_fee!=0 && cred_fee > 0.99) ? cred_fee : 0.99 
	   amount = (tot_amt > cred_fee_per) ? (tot_amt-cred_fee_per) : tot_amt
	   #credit fee calculation
	   
	   #Main calculation before and after 27th of dec 2013
		net_amt = checkRepresentativeShare(act_id,current_u_id,tot_amt,amount,fam_fee,credit_fee,tran_date)
		
	   tot_net_amt = (net_amt && !net_amt.nil? && net_amt[2] && !net_amt[2].nil? && net_amt[2].present?) ? net_amt[2] : amount
	   rep_share = (net_amt && !net_amt.nil? && net_amt[0] && !net_amt[0].nil? && net_amt[0].present?) ? net_amt[0] : ''
	   ven_share = (net_amt && !net_amt.nil? && net_amt[1] && !net_amt[1].nil? && net_amt[1].present?) ? net_amt[1] : ''
	   fam_fee_amt = (net_amt && !net_amt.nil? && net_amt[3] && !net_amt[3].nil? && net_amt[3].present?) ? net_amt[3] : ''
	   return fam_fee_amt,tot_net_amt,cred_fee_per,rep_share,ven_share
	end
end


#provider reports page
def checkRepresentativeShare(act_id,curr_user_id,tot_amt,amount,fam_fees,credit_fees,tran_date)
   if act_id && curr_user_id && amount && !act_id.nil? && !curr_user_id.nil? && !amount.nil? && tot_amt && !tot_amt.nil?
	school_rep = SchoolRepresentative.where("activity_id=?",act_id).last
	if ((tran_date < Date.parse("2013-12-27")) || ((tran_date >= Date.parse("2013-12-27")) && (school_rep && !school_rep.nil? && school_rep.present?)))
		#fam fee calculation
		fam_fee = (tot_amt*fam_fees)/100
		fam_fee_per = (fam_fee!=0 && fam_fee > 0.99) ? fam_fee : 0.99 
		tot_amount = (fam_fee_per && !fam_fee_per.nil? && fam_fee_per.present? && amount > fam_fee_per) ? (amount-fam_fee_per) : amount
		#fam fee calculation
		
			fam_fee_text = "-"+fam_fees.to_s+"%"+" = $#{fam_fee}" if fam_fee && !fam_fee.nil?

		
		#school fee calculation
		if school_rep && !school_rep.nil? && school_rep.present?
		rep_share = school_rep.share.round
		ven_share = (100-rep_share).round
			if (school_rep.representative_id == curr_user_id)
				net_amount = (tot_amount*rep_share)/100
				net_amount = ((tran_date >= Date.parse("2013-12-27")) && fam_fee && !fam_fee.nil? && fam_fee!=0)  ? (net_amount+(fam_fee/2)) : net_amount
				fam_fee_text = ((tran_date >= Date.parse("2013-12-27")) && fam_fee && !fam_fee.nil? && fam_fee!=0)  ? "+"+(fam_fees/2).to_s+"%"+" = $#{(fam_fee/2).to_s}" : fam_fee_text
			elsif (school_rep.vendor_id == curr_user_id)
				net_amount = (tot_amount*ven_share)/100
			end
		end
		#school fee calculation
		net_amount = (net_amount && !net_amount.nil? && net_amount.present?) ? net_amount : tot_amount
		return rep_share,ven_share,net_amount,fam_fee_text
	end
   end
end

end
