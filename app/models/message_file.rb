class MessageFile < ActiveRecord::Base
belongs_to :message_thread

  #~ has_attached_file :message_file, :styles => { :small=>"85x87!",:medium => "130x110!", :thumb => "21x21!" }, :default_url => "/assets/profile/user_icon_69.png",
    #~ :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    #~ :url => "/system/:attachment/:id/:style/:filename"

  has_attached_file :message_file, :styles => lambda{ |a| ["image/jpeg", "image/png","image/gif","image/tiff","image/bmp"].include?( a.content_type ) ? { :small=>"190x274>",:medium => "190x324>", :thumb => "80x84!" ,:att_preview => "500x500>"} : {}  }, :default_url => "/assets/profile/user_icon_69.png",
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
end



