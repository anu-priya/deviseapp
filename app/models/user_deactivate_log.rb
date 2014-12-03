class UserDeactivateLog < ActiveRecord::Base
  attr_accessible :business_name, :user_date, :email_id, :id, :inserted_date, :modified_date, :user_id, :user_status
  
   #store the user log details while deactivate the account
  def self.log_user_details(uid,email,status)
	@udl = UserDeactivateLog.new
	@udl.user_id = "#{uid}" if !uid.nil? && uid.present? && uid!=''
	@udl.email_id = "#{email}" if !email.nil? && email.present? && email!=''
	@udl.user_date = Time.now
	@udl.user_status = "#{status}" if !status.nil? && status.present? && status!=''
	@udl.inserted_date = Time.now	
	@udl.modified_date = Time.now
	@up = UserProfile.find_by_user_id(uid) if !uid.nil? && uid.present? && uid!=''
	@name = (@up && @up.business_name) ? (@up && @up.business_name) : ('')
	@udl.business_name = "#{@name}"
	@udl.save
  end
  
end
