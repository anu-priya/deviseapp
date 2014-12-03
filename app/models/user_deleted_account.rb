class UserDeletedAccount < ActiveRecord::Base
  attr_accessible :manage_plan, :deleted_date, :email_address, :id, :inserted_date, :modified_date, :user_id, :user_plan, :user_type
  #call the method for inserting the data
  def self.deleted_user_info(user,bname)
	@usr_dlted_act = UserDeletedAccount.new
	@usr_dlted_act.business_name = bname if !bname.nil? && bname!="" && !bname.nil?
	@usr_dlted_act.user_id = "#{user.user_id}" if !user.nil? && user!="" && !user.user_id.nil?
	@usr_dlted_act.manage_plan = "#{user.manage_plan}" if !user.nil? && user!="" && !user.manage_plan.nil?
	@usr_dlted_act.user_plan = "#{user.user_plan}" if !user.nil? && user!="" && !user.user_plan.nil?
	@usr_dlted_act.deleted_date = Time.now
	@usr_dlted_act.user_type = "#{user.user_type}" if !user.nil? && user!="" && !user.user_type.nil?
	@usr_dlted_act.email_address = "#{user.email_address}" if !user.nil? && user!="" && !user.email_address.nil?
	@usr_dlted_act.inserted_date = Time.now
	@usr_dlted_act.modified_date = Time.now
	@usr_dlted_act.save
  end
  
end
