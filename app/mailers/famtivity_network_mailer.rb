require 'open-uri'
class FamtivityNetworkMailer < ActionMailer::Base
  require 'base64'
  layout 'email'
  default "from" => "no-reply@famtivity.com"
  $image_global_path='http://dev.famtivity.com:8080/'
  
  #~ default from: "support@famtivity.com"
  def network_invite_mail(curre_user,network,to,urlr,user)
    headers['X-No-Spam'] = 'True'
    @user=curre_user
    @network = network
    @to = to
    @user_id = user
    @url = "http://#{urlr}/accept_fam_network?group=#{network.group_id}&invite_user_id=#{to}"
    mail(:to => to, :subject => "Famtivity Network Invite")
  end


  def network_to_join_famtivity(curre_user,network,to,urlr,contact,message)
    headers['X-No-Spam'] = 'True'
    @to_user = to
    @from_user = curre_user
    @message = message
    @network = network
    @contact = contact
    en_user_id = Base64.encode64("#{@from_user.user_id}")
    #~ added  attend_track param for analytic tracking
    #~ @url = "http://#{urlr}?cid=#{contact.contact_id}&group=#{network.group_id}&parent_reg=true&sent_user=#{en_user_id}&sent_user_email=#{@to_user}&attend_track=true"
    @url = "http://#{urlr}/register?cid=#{contact.contact_id}&group=#{network.group_id}&parent_reg=true&sent_user=#{en_user_id}&sent_user_email=#{@to_user}&attend_track=true"
    @image_path = "http://#{urlr}"
    mail(:to => to, :subject => "Famtivity Network Invite")
  end

  def network_member_invite_mail(curre_user,network,to,urlr,user,contact_id,message)
    @from_user=curre_user
    @network = network
    @to = to
    @user_id = user.user_id
    @to_user = user.user_name
    @message = message
    @image_path = "http://#{urlr}"
    @url = "http://#{urlr}/contact_activate?cid=#{contact_id}&group=#{network.group_id}&user_id=#{user.user_id}"
    mail(:to => to, :subject => "Famtivity Network Invite")
  end
  
  def network_friend_invite_mail(curre_user,network,to,urlr,user,contact_id,message)
    @from_user=curre_user
    @network = network
    @to = to
    @user_id = user.user_id
    @to_user = user.user_name
    @message = message
    @image_path = "http://#{urlr}"
    @url = "http://#{urlr}/contact_activate?cid=#{contact_id}&group=#{network.group_id}&user_id=#{user.user_id}"
    mail(:to => to, :subject => "Famtivity Network Invite")
  end

  def fam_network_remove_contacts_to_owner(user,network,urlr)
    @image_path = "http://#{urlr}"
    @network = network
    @from_user= user
    email=Base64.encode64(user.email_address) if !user.email_address.nil?
    @url = "http://#{urlr}/?group=#{network.group_id}&msg_email=#{email}"
    mail(:to => user.email_address, :subject => "Famtivity Network Removed Contacts")
  end

  def fam_network_delete_to_owner(user,network,urlr)
    @image_path = "http://#{urlr}"
    @network = network
    @from_user= user
    email=Base64.encode64(user.email_address) if !user.email_address.nil?
    @url = "http://#{urlr}/?cnetwork=true&msg_email=#{email}"
    mail(:to => user.email_address, :subject => "Famtivity Network Removed Contacts")
  end

  def fam_create_network_mail(email_address,fam_post,urlr,fromuser,msg,msg_rec)
    to_user = Base64.encode64(email_address) if !email_address.nil?
    @image_path =  "http://#{urlr}" 
    @url = "http://#{urlr}/messages?msg_email=#{to_user}&view_more=true&rep_id=#{msg_rec.message_id}"
    @to = email_address
    @fam_post = fam_post
    @fromuser = fromuser
    @msg = msg
    @msg_subject = msg_rec.subject
    mail(:to => @to, :subject => "#{@msg_subject} | Fam Network - #{@fam_post.group_name if @fam_post}")
  end


  def fam_create_post_network_mail(curre_user,fam_post,urlr)
    @image_path = "http://#{urlr}"
    @to = curre_user.contact_name
    @fam_post = fam_post
    mail(:to => curre_user.contact_email, :subject => "Famtivity Network")
  end

  def contact_success_mail(email_address,group_name,contact_users,url)
    @image_path = "http://#{url}"
    @to = email_address
    @fam_post = group_name
    @contact = contact_users
    mail(:to => @to, :subject => "#{@contact.contact_email.split('@')[0] if @contact && @contact.contact_email} accepted your invitation | Fam Network - #{@fam_post.group_name}")
  end



#remove contacts from network
   def fam_network_remove_contacts_to_owner_api(user,network)
    @network = network
    @from_user= user
    email=Base64.encode64(user.email_address) if !user.email_address.nil?
    @url = "#{$image_global_path}?group=#{network.group_id}&msg_email=#{email}"
    mail(:to => user.email_address, :subject => "Famtivity Network Removed Contacts")
  end
  
   #remove network
  def fam_network_delete_to_owner_api(user,network)
    @network = network
    @from_user= user
    mail(:to => user.email_address, :subject => "Famtivity Network Removed Contacts")
  end
  
end
 