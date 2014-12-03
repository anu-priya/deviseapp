class ActivitySubcategory < ActiveRecord::Base
  include IdentityCache
   extend FriendlyId
   friendly_id :slug_for_subcateg_name, use: :slugged
  attr_accessible :slug, :sub_category_file_name, :category_id, :sub_category_content_type, :sub_category_file_size, :sub_category_updated_at, :subcateg_id, :subcateg_name, :script_url, :href_url
  cache_index :slug,:unique => true  
  cache_index :subcateg_name
  belongs_to :activity_category
  has_attached_file :sub_category, :styles => {:medium=>"29x29", :small=>"20x20", :large=>"112x112"},
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  
  def slug_for_subcateg_name
    "#{subcateg_name}"
  end
  
  def self.getsubcategname(subcateg)
	@actsubcateg = ActivitySubcategory.fetch_by_slug(subcateg)
	@actsubcatresult = @actsubcateg.subcateg_name if @actsubcateg && @actsubcateg.subcateg_name
	return @actsubcatresult
  end
end
