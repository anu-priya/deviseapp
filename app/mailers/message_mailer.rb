class MessageMailer < ActionMailer::Base
  require 'base64'
  layout 'email'
  #~ default "from" => "user@famtivity.com"
 

 def send_message_to_viewers(to_user,msg,from_user,url)
	headers['X-No-Spam'] = 'True'
	@to_user = to_user
	@url=url
	@member = User.where("lower(email_address)=?",to_user.downcase).first
	@user = from_user
	@msg = msg
	@thrd = msg.message_threads.last if msg && msg.present? && !msg.nil? && msg.message_threads && msg.message_threads.present? &&  msg.message_threads.last && msg.message_threads.last.present? 
	@message = msg.message_threads.last.content  if @thrd && @thrd.content && !@thrd.content.nil? && @thrd.content.present?
	@m_files = @thrd.message_files if @thrd && !@thrd.nil? && @thrd.present? && @thrd.message_files && @thrd.message_files.present?	 
	@m_files && @m_files.each do |attach_file|
	  attachments["#{attach_file.message_file_file_name}"] = File.read("#{attach_file.message_file.path}")
	end
	mail(:from=>@user.email_address,:to => @to_user, :subject => "#{msg.subject if msg && msg.present? && !msg.nil? && msg.subject && msg.subject.present? && !msg.subject.nil?}") 
	#~ do |format|
	  #~ format.html { render 'send_message_to_viewers',layout: 'email' }
	#~ end
 end

  def send_message_to_famnetwork(to_user,msg,from_user,url,cid,group,contact)
	headers['X-No-Spam'] = 'True'
	@contact = contact
	@from_user = from_user
	@cid=cid
	@group=group
	@to_user = to_user
	@url=url
	@member = User.where("lower(email_address)=?",to_user.downcase).first
	@image_path = "http://#{url}"
	@thrd = msg.message_threads.last if msg && msg.present? && !msg.nil? && msg.message_threads && msg.message_threads.present? &&  msg.message_threads.last && msg.message_threads.last.present? 
	@msg = msg
	@thrd = msg.message_threads.last if msg && msg.present? && !msg.nil? && msg.message_threads && msg.message_threads.present? &&  msg.message_threads.last && msg.message_threads.last.present? 
	@message = msg.message_threads.last.content  if @thrd && @thrd.content && !@thrd.content.nil? && @thrd.content.present?
	@m_files = @thrd.message_files if @thrd && !@thrd.nil? && @thrd.present? && @thrd.message_files && @thrd.message_files.present?	 
	@m_files && @m_files.each do |attach_file|
	  attachments["#{attach_file.message_file_file_name}"] = File.read("#{attach_file.message_file.path}")
	end
	#@message = msg.message_threads.last.content  if @thrd && @thrd.content && !@thrd.content.nil? && @thrd.content.present?
	mail(:from=>@from_user.email_address,:to => @to_user, :subject => "Famtivity Network Invite")
 end

def send_to_famnetwork(to_user,msg,from_user,url,cid,group,contact)
	headers['X-No-Spam'] = 'True'
	@contact = contact
	@from_user = from_user
	@cid=cid
	@group=group
	@to_user = to_user
	@url=url
	@member = User.where("lower(email_address)=?",to_user.downcase).first
	@image_path = "http://#{url}"
	mail(:from=>@from_user.email_address,:to => @to_user, :subject => "Famtivity Network Invite")
 end
 def send_message_to_viewers_api(to_user,msg,from_user,url)
	headers['X-No-Spam'] = 'True'
	@to_user = to_user
	@url=url
	@member = User.where("lower(email_address)=?",to_user.downcase).first
	@user = from_user
	@msg = msg
	@thrd = msg.message_threads.last if msg && msg.present? && !msg.nil? && msg.message_threads && msg.message_threads.present? &&  msg.message_threads.last && msg.message_threads.last.present? 
	@message = msg.message_threads.last.content  if @thrd && @thrd.content && !@thrd.content.nil? && @thrd.content.present?
	@m_files = @thrd.message_files if @thrd && !@thrd.nil? && @thrd.present? && @thrd.message_files && @thrd.message_files.present?	 
	@m_files && @m_files.each do |attach_file|
	  attachments["#{attach_file.message_file_file_name}"] = File.read("#{attach_file.message_file.path}")
	end
	mail(:from=>@user.email_address,:to => @to_user, :subject => "#{msg.subject if msg && msg.present? && !msg.nil? && msg.subject && msg.subject.present? && !msg.subject.nil?}") 
	#~ do |format|
	  #~ format.html { render 'send_message_to_viewers',layout: 'email' }
	#~ end
 end
  
end
