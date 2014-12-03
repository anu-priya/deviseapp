class ContactUserGroup < ActiveRecord::Base
  attr_accessible :contact_group_id, :contact_user_id, :user_mode, :inserted_date, :modified_date, :user_id, :fam_accept_status
  belongs_to :contact_user
  belongs_to :contact_group
  belongs_to :user
end
