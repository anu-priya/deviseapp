module InvitorListHelper

 def invitor_detail_list(email)
    user = User.where("email_address=?",email).first
    if user
      user_profile = user.user_profile 
      return user,user_profile
    end
 end

end
