class PolicyFile < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :policy_id,:inserted_date,:modified_date,:pdf, :pdf_file_name, :pdf_content_type, :pdf_file_size, :pdf_updated_at
  
  has_attached_file :pdf,
   :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
   :url => "/system/:attachment/:id/:style/:filename"

validates_attachment_content_type :pdf, :content_type => ['application/pdf', 'application/msword','application/octet-stream','application/vnd.openxmlformats-officedocument.wordprocessingml.document','application/vnd.oasis.opendocument.text','text/plain'], :if => :pdf_attached?

def pdf_attached?
  self.pdf.file?
end

end
