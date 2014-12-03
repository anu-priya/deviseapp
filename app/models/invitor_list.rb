class InvitorList < ActiveRecord::Base
attr_accessible :status, :inserted_date, :modified_date, :accepted_date, :user_id, :invited_email, :description

	def self.invitor_list(email,inv_user_id,desc_status)
		invitor_list = InvitorList.new
		invitor_list.user_id = inv_user_id
		invitor_list.invited_email = email
		invitor_list.description = ((desc_status=='friend') ? 'Invited as Friend' : 'Invited as Provider')
		invitor_list.status = 'Pending'
		invitor_list.inserted_date=Time.now
		invitor_list.modified_date=Time.now
		invitor_list.save
	end


end
