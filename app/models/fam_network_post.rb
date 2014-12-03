class FamNetworkPost < ActiveRecord::Base
  attr_accessible :subject

  has_attached_file :fam_net_post, :default_url => "/images/no_image.png",
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"


  belongs_to :fam_post
end
