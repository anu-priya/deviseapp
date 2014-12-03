class FamPost < ActiveRecord::Base
  attr_accessible :subject
  has_many :fam_network_posts
  has_attached_file :fam_network_post, :styles => { :thumb=>"190x190>", :small => "190x274>", :medium => "190x324>" }, :default_url => "/assets/default/fam_row_default.jpg",
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"

  def self.formatFileSupports(file_content)
    image = ["image/jpeg","image/png"]
  	pdf = ["application/pdf"]
    docs = ["text/x-script.zsh","application/octet-stream","multipart/x-zip","application/x-zip-compressed","application/plain","text/x-speech","application/x-wais-source","application/x-tbook","text/richtext","application/oda","application/base64","www/mime","application/x-frame","application/x-javascript","text/x-java-source","application/x-ip2","application/inf","x-conference/x-cooltalk","text/x-component","application/hta","text/x-h","multipart/x-gzip","application/x-gzip","application/x-compressed","application/octet-stream","application/x-director","text/css","application/x-pointplus","application/octet-stream","application/x-java-class","application/java-byte-code","application/java","application/vnd.ms-pki.seccat","text/x-c","application/x-bsh","application/x-binary","application/octet-stream","application/mac-binary","application/x-mplayer2","x-world/x-3dmf","x-world/x-3dmf","application/zip","application/x-bzip2","application/x-rar-compressed","text/plain","application/doc","application/docx","application/msword","application/vnd.openxmlformats-officedocument.wordprocessingml.document","application/vnd.openxmlformats-officedocument.wordprocessingml.template","application/vnd.ms-word.document.macroEnabled.12","application/vnd.ms-word.template.macroEnabled.12"]
    excel = ["text/csv","application/vnd.ms-excel", "application/xls", "application/xlsx", "application/vnd.oasis.opendocument.spreadsheet","application/vnd.openxmlformats-officedocument.spreadsheetml.sheet","application/vnd.openxmlformats-officedocument.spreadsheetml.template","application/vnd.ms-excel.sheet.macroEnabled.12","application/vnd.ms-excel.template.macroEnabled.12","application/vnd.ms-excel.addin.macroEnabled.12","application/vnd.ms-excel.sheet.binary.macroEnabled.12"]
    power = ["application/vnd.ms-powerpoint","application/vnd.openxmlformats-officedocument.presentationml.presentation","application/vnd.openxmlformats-officedocument.presentationml.template","application/vnd.openxmlformats-officedocument.presentationml.slideshow","application/vnd.ms-powerpoint.addin.macroEnabled.12","application/vnd.ms-powerpoint.presentation.macroEnabled.12","application/vnd.ms-powerpoint.presentation.macroEnabled.12","application/vnd.ms-powerpoint.slideshow.macroEnabled.12","application/vnd.oasis.opendocument.presentation"]
    html = ["message/rfc822","text/html","text/vnd.abc","text/x-audiosoft-intra","text/x-asm","text/asp"]
    autio_video = ["audio/x-voc","audio/voc","video/vivo","audio/x-pn-realaudio","audio/x-mpeg-3","audio/mpeg3","video/x-mpeq2a","audio/x-mpeg","video/x-sgi-movie","audio/x-mod","audio/mod","video/x-motion-jpeg","x-music/x-midi","music/crescendo","audio/x-midi","audio/x-mid","application/x-midi","audio/x-mpequrl","video/mpeg","audio/midi","audio/x-gsm","video/x-gl","video/gl","video/x-fli","video/fli","video/x-dv","video/avs-video","video/msvideo","video/avi","application/x-troff-msvideo","audio/x-au","audio/basic","video/x-ms-asf","audio/x-aiff","audio/aiff","video/animaflex","video/x-flv","video/mp4","application/x-mpegURL","video/MP2T","video/3gpp","video/quicktime","video/x-msvideo","video/x-ms-wmv","application/x-msdos-program","audio/x-ms-wma","application/mp4","video/3gpp","audio/x-wav","audio/mpeg"]
    if pdf.include?(file_content)
      result = '/assets/message/pdf_icon.jpg'
    elsif docs.include?(file_content)
      result = '/assets/message/word_icon.jpg'
    elsif excel.include?(file_content)
      result = '/assets/message/xls_icon.jpg'
    elsif power.include?(file_content)
      result = '/assets/message/ppt_icon.jpg'
    elsif html.include?(file_content)
      result = '/assets/message/html_icon.jpg'
    elsif autio_video.include?(file_content)
      result = '/assets/message/audio_video.jpg'
    else
      result = '/assets/message/icon_image.png'
    end
    result
  end
end
