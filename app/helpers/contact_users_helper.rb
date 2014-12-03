module ContactUsersHelper

def check_friends(contact)
friend = ContactUser.where("contact_email = ? and user_id = ? and contact_user_type = ?",contact.email_address,current_user.id,'friend').first
friend.present? ? true : false
end

def check_owner(con,mail)
  user_id=ContactGroup.where("group_id=?",con).map(&:user_id) if !con.nil? && con.present? 
    email=User.where("user_id=?",user_id).map(&:email_address) if !user_id.nil?
    owner=(email[0]==mail) if !con.nil? && con.present?
    owner.present? ? true : false
end

def display_member_type(key_word)
if(key_word == "non_member")
  type = key_word.titlecase.gsub(" ","-")
else
  type = key_word.titlecase	
end
  type
end

def display_phone_format(phone)
  if (phone.length==10 && phone.at(3)!="-" && phone.at(7)!="-")
    phone=phone.insert 3, "-"
	phone=phone.insert 7, "-"
  else
    phone
  end
end

end
