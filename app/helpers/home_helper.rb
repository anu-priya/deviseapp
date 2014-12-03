module HomeHelper
  	def getFamnetwork(famlist)
  		user=User.find_by_user_id(famlist.posted_by)
	    user_prof = user.user_profile if user && !user.nil? && user.present?
	    message = Message.find(famlist.message_id)
        thrd_last = message.message_threads.last
        fam_net = ContactGroup.find_by_group_id(message.contact_group_id)
        return user, user_prof,message,thrd_last,fam_net
	end    

	#displayed the activity name based on the price details,free,contact provider and price in activity card
	def display_actname(price)
		if price && price.present?
		    if price=="$ Price Details"
		    wth = "162px"
		    elsif price=="$ Free"
		    wth = "217px"
		    elsif price=="$ Contact Provider"
		    wth = "132px"
		    elsif price.length>1
			    if price.length==2
				    wth = "238px"
			    elsif price.length==3
				    wth = "232px"
			    elsif price.length==4
				    wth = "222px"
			    elsif price.length==5
				    wth = "215px"
			    elsif price.length==6
				    wth = "206px"
			    elsif price.length==7
				    wth = "197px"
			    elsif price.length==8
				    wth = "188px"
			    elsif price.length==9
				    wth = "179px"
			    elsif price.length==10
				    wth = "161px"
			    elsif price.length==11
				    wth = "152px"
			    elsif price.length==12
				    wth = "143px"
			    elsif price.length==13
				    wth = "140px"
			    elsif price.length==14
				    wth = "131px"
			    elsif price.length==15
				    wth = "126px"
			    elsif price.length>15
				    wth = "126px"
			    else
				     wth = "225px"
			    end
			    
		    else
		    wth = "225px"
		    end
		return wth
		end
	end

end
