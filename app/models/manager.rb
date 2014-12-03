class Manager < ActiveRecord::Base
  attr_accessible :accept_status, :activity_id, :email_id, :id, :inserted_date, :invited_user_id, :manager_user_id, :modified_date
  
  belongs_to :user, :foreign_key => :invited_user_id
end
