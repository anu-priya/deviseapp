class FamNetwork < ActiveRecord::Base
  attr_accessible :fam_profile_id, :fam_contact_name, :fam_contact, :user_id, :fam_contact_type,:fam_contact_email,:fam_group_id

  has_attached_file :fam_contact, :styles => { :small=>"190x270",:medium => "190x190", :thumb => "190x360" },
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  belongs_to :contact_user
end
