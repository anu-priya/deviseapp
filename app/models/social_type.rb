class SocialType < ActiveRecord::Base
  attr_accessible :inserted_date, :social, :modified_date, :social_content_type, :social_file_name, :social_file_size, :social_id, :social_name, :social_updated_at

  has_attached_file :social, :styles => {:small => "25x25!"},
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
end
