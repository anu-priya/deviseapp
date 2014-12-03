class ActivityCategory < ActiveRecord::Base
   include IdentityCache
   extend FriendlyId
   friendly_id :slug_for_category_name, use: :slugged
  attr_accessible :slug, :category_id, :category_name, :category, :category_file_name, :category_content_type, :category_file_size, :category_updated_at
  cache_index :slug,:unique => true
  cache_index :category_name
  has_many :activity_subcategory,:class_name => 'ActivitySubcategory',:foreign_key =>"category_id"
  
  has_attached_file :category, :styles => {:medium=>"29x29", :small=>"20x20", :large=>"112x112"},
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename"

 def slug_for_category_name
    "#{category_name}"
  end
  
 def self.getcategname(categ)
	 @actcateg = ActivityCategory.fetch_by_slug(categ)
	 @actcatresult = @actcateg.category_name if @actcateg && @actcateg.category_name
	 return @actcatresult
 end
 
end
