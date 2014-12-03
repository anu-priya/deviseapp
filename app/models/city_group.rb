class CityGroup < ActiveRecord::Base
  attr_accessible :group_id, :group_name, :inserted_date, :modified_date
  
  #get the group name list
  def self.getgroupnames
	  CityGroup.order(:group_id).select{|c|[c.group_name,c.group_id]}
  end
  
  #To get group_id
  def self.getgroupId(city_name)
	  citygrop = CityGroup.where("lower(group_name)=?",city_name.downcase).first if city_name && city_name.present?
	  citygrop.group_id if citygrop && citygrop.present?
  end
end
