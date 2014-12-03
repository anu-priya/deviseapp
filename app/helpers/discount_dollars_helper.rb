module DiscountDollarsHelper

  def detail_user(credit,type)
    if (type=='cred')
      de_user = User.where("user_id=?",credit.invitee_id).first
    else
      de_user = User.where("user_id=?",credit.provider_id).first
    end
    de_user
  end


  def provider_user_name(user)
    if (user.user_profile && user.user_profile.business_name.present? && !user.user_profile.business_name.nil? && user.user_name.present? && !user.user_name.nil?)
      name = user.user_profile.business_name+','+user.user_name
    elsif (user.user_name.present? && !user.user_name.nil?)
      name = user.user_name
    end
    name
  end

  def find_activity(act_id)
    activ = Activity.where("activity_id=?",act_id).first
  end

end
