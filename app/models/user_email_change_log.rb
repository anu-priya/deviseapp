class UserEmailChangeLog < ActiveRecord::Base
   attr_accessible :user_id, :email_from, :email_to, :email_updated_date
end


