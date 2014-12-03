class ActivityNetworkPermission < ActiveRecord::Base
  attr_accessible :activity_id, :edit_manager, :id, :inserted_date, :invite_attendies, :invite_managers, :manager_user_id, :modified_date, :provider_user_id, :schedule_id, :view_manager, :accept_status
    belongs_to :user, :foreign_key => :provider_user_id
end
