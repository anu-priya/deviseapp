class Participant < ActiveRecord::Base
  attr_accessible :participant, :participant_file_name, :participant_name, :participant_age,:participant_gender,:participant_schedule,:participant_birth_date,:payment_status
  has_attached_file :participant, :styles => { :small=>"190x270!",:medium => "190x190!", :thumb => "190x360!" },
   #:convert_options => {:small => "-quality 80 -interlace plane", :medium => "-quality 80 -interlace plane", :thumb => "-quality 80 -interlace plane"}, 
    #:processors => [:thumbnail,:compression],
     :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
    
    
  belongs_to :user

  validates :participant_name, :presence => true
end
