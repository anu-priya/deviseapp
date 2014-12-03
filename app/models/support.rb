class Support < ActiveRecord::Base
  attr_accessible :support_id, :comments, :email_address, :inserted_date, :labels, :modified_date, :support_content_type, :support, :support_file_size, :support_type, :support_updated_at
  
  has_attached_file :support, :styles => { :medium => "130x110!", :thumb => "21x21!" },  
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
end
