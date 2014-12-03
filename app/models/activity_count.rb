class ActivityCount < ActiveRecord::Base
  attr_accessible :activity_count, :activity_count_id, :activity_id, :inserted_date, :modified_date,:share_count,:view_count
  scope :find_activity_count, lambda { |id| where('activity_id = ?', id) }
  
  def self.updateViewCount(act_id)
    act_count = find_activity_count(act_id).last #from scope
    @last=act_count.inserted_date.strftime("%a, %b %d, %Y").to_date if !act_count.nil?
    @today =Date.today
    views_count =  (act_count && act_count.present? && !act_count.nil? && !@last.nil? && !@today.nil? && @today==@last && act_count.view_count &&  !act_count.view_count.nil?) ? (act_count.view_count.to_i+1) : 1
    (act_count && act_count.present? && !act_count.nil? && !@last.nil? && !@today.nil? && @today==@last) ? act_count.update_attributes(:view_count => views_count) :  ActivityCount.create(:activity_id=>act_id, :activity_count=>0, :share_count=>0, :view_count=>views_count, :inserted_date=>Time.now, :modified_date=>Time.now)
  end
  
  
  def self.updateShareCount(act_id)
    act_count = find_activity_count(act_id).last #from scope
    @last=act_count.inserted_date.strftime("%a, %b %d, %Y").to_date if !act_count.nil?
    @today =Date.today
    share_counts =  (act_count && act_count.present? && !act_count.nil? && !@last.nil? && !@today.nil? && @today==@last && act_count.share_count &&  !act_count.share_count.nil?) ? (act_count.share_count.to_i+1) : 1
    (act_count && act_count.present? && !act_count.nil? && !@last.nil? && !@today.nil? && @today==@last) ? act_count.update_attributes(:share_count => share_counts) : ActivityCount.create(:activity_id=>act_id, :activity_count=>0, :share_count=>share_counts, :view_count=>0, :inserted_date=>Time.now, :modified_date=>Time.now)
  end
  
end
