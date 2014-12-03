module MessagesHelper

def MsgThreadDetail(thread_id,curr_email,msgtype)
	if thread_id && thread_id.present? && !thread_id.nil?
	m_thrd = MessageThread.find(thread_id)
	posted_user = User.find_by_user_id(m_thrd.posted_by)  if m_thrd && m_thrd.present? && !m_thrd.nil?
	frm_user_email = posted_user.email_address if posted_user && posted_user.present? && !posted_user.nil?
	frm_user_email = (frm_user_email && frm_user_email.present?) ? frm_user_email : ((m_thrd && m_thrd.present? && m_thrd.posted_email && m_thrd.posted_email.present?) ? m_thrd.posted_email : '')
	m_thrd_viewers = m_thrd.receivers_email.split(',') if m_thrd && m_thrd.present? && !m_thrd.nil? && m_thrd.receivers_email && !m_thrd.receivers_email.nil? && m_thrd.receivers_email.present?
	#~ m_thrd_viewers = MessageThreadViewer.where("message_thread_id=?",thread_id).map(&:user_email) 
	#~ to_email = []
	to_name = ''

	m_thrd_viewers && m_thrd_viewers.each do |viewer|
		if viewer && viewer.present? && !viewer.nil?
				nam = ((curr_email && (viewer==curr_email)) ? 'me' : viewer.split('@').first)
				to_name = (to_name && to_name=='') ? (to_name+nam) : (to_name+','+nam)
		end
	end
	return frm_user_email,m_thrd_viewers,to_name
	end
end

def MsgFile(thrd_id)
	MessageFile.where("message_thread_id=?",thrd_id) if thrd_id && thrd_id.present? && !thrd_id.nil?
end


def formatFileSupports(file_content,image_type)
	#~ image = ["image/x-tiff","image/tiff","image/x-quicktime","image/pict","image/x-niff","image/jpeg","image/png","image/x-jg","image/bmp","image/x-windows-bmp","image/fif","image/gif"]
	image = ["image/jpeg","image/png","image/tiff","image/bmp"]
	pdf = ["application/pdf"]
	docs = ["text/x-script.zsh","application/octet-stream","multipart/x-zip","application/x-zip-compressed","application/plain","text/x-speech","application/x-wais-source","application/x-tbook","text/richtext","application/oda","application/base64","www/mime","application/x-frame","application/x-javascript","text/x-java-source","application/x-ip2","application/inf","x-conference/x-cooltalk","text/x-component","application/hta","text/x-h","multipart/x-gzip","application/x-gzip","application/x-compressed","application/octet-stream","application/x-director","text/css","application/x-pointplus","application/octet-stream","application/x-java-class","application/java-byte-code","application/java","application/vnd.ms-pki.seccat","text/x-c","application/x-bsh","application/x-binary","application/octet-stream","application/mac-binary","application/x-mplayer2","x-world/x-3dmf","x-world/x-3dmf","application/zip","application/x-bzip2","application/x-rar-compressed","text/plain","application/doc","application/docx","application/msword","application/vnd.openxmlformats-officedocument.wordprocessingml.document","application/vnd.openxmlformats-officedocument.wordprocessingml.template","application/vnd.ms-word.document.macroEnabled.12","application/vnd.ms-word.template.macroEnabled.12"]
	excel = ["text/csv","application/vnd.ms-excel", "application/xls", "application/xlsx", "application/vnd.oasis.opendocument.spreadsheet","application/vnd.openxmlformats-officedocument.spreadsheetml.sheet","application/vnd.openxmlformats-officedocument.spreadsheetml.template","application/vnd.ms-excel.sheet.macroEnabled.12","application/vnd.ms-excel.template.macroEnabled.12","application/vnd.ms-excel.addin.macroEnabled.12","application/vnd.ms-excel.sheet.binary.macroEnabled.12"]
	power = ["application/vnd.ms-powerpoint","application/vnd.openxmlformats-officedocument.presentationml.presentation","application/vnd.openxmlformats-officedocument.presentationml.template","application/vnd.openxmlformats-officedocument.presentationml.slideshow","application/vnd.ms-powerpoint.addin.macroEnabled.12","application/vnd.ms-powerpoint.presentation.macroEnabled.12","application/vnd.ms-powerpoint.presentation.macroEnabled.12","application/vnd.ms-powerpoint.slideshow.macroEnabled.12","application/vnd.oasis.opendocument.presentation"]
	html = ["message/rfc822","text/html","text/vnd.abc","text/x-audiosoft-intra","text/x-asm","text/asp"]
	autio_video = ["audio/x-voc","audio/voc","video/vivo","audio/x-pn-realaudio","audio/x-mpeg-3","audio/mpeg3","video/x-mpeq2a","audio/x-mpeg","video/x-sgi-movie","audio/x-mod","audio/mod","video/x-motion-jpeg","x-music/x-midi","music/crescendo","audio/x-midi","audio/x-mid","application/x-midi","audio/x-mpequrl","video/mpeg","audio/midi","audio/x-gsm","video/x-gl","video/gl","video/x-fli","video/fli","video/x-dv","video/avs-video","video/msvideo","video/avi","application/x-troff-msvideo","audio/x-au","audio/basic","video/x-ms-asf","audio/x-aiff","audio/aiff","video/animaflex","video/x-flv","video/mp4","application/x-mpegURL","video/MP2T","video/3gpp","video/quicktime","video/x-msvideo","video/x-ms-wmv","application/x-msdos-program","audio/x-ms-wma","application/mp4","video/3gpp","audio/x-wav","audio/mpeg"]
	if image.include?(file_content.message_file_content_type)
		result = file_content.message_file.url(image_type) if file_content && file_content.present? && !file_content.nil? && file_content.message_file && file_content.message_file.present? && !file_content.message_file.nil?
	elsif pdf.include?(file_content.message_file_content_type)
		result = '/assets/message/pdf_icon.jpg'
	elsif docs.include?(file_content.message_file_content_type)
		result = '/assets/message/word_icon.jpg'
	elsif excel.include?(file_content.message_file_content_type)
		result = '/assets/message/xls_icon.jpg'
	elsif power.include?(file_content.message_file_content_type)
		result = '/assets/message/ppt_icon.jpg'
	elsif html.include?(file_content.message_file_content_type)
		result = '/assets/message/html_icon.jpg'
	elsif autio_video.include?(file_content.message_file_content_type)
		result = '/assets/message/audio_video.jpg'
	else
		result = '/assets/message/icon_image.png'
	end
	result
end

def getMsgUnreadCount(message_id,user)
	result = MessageThreadViewer.find_by_sql(" select count(read_status) as read_count from message_thread_viewers mtv left join message_threads mt on mt.thread_id=mtv.message_thread_id where mtv.user_id=#{user.user_id} and mtv.read_status=false and mt.message_id=#{message_id}")
	result
end

def chkNetMem(group_id)
	group_mem = ContactUserGroup.where("contact_group_id=? and fam_accept_status=?",group_id,true)
	return group_mem.present? && !group_mem.empty?
end

end
