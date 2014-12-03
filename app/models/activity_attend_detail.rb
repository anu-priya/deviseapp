class ActivityAttendDetail < ActiveRecord::Base
  include IdentityCache
  attr_accessible :activity_id, :age_range, :attend_id, :dob, :gender,:payment_status, :ticket_id,	:ticket_code, :image_content_type, :image_file_size, :image_updated_at, :inserted_date, :modified_date, :participant_name, :price, :schedule_id, :user_id, :attendies_email
  cache_index :activity_id, :payment_status #identity cache
  def self.earlyBirdApp(disc_number,attendees_count)
	if disc_number!=0
		if attendees_count!=0 && disc_number > attendees_count
			early_applicable = disc_number - attendees_count
		elsif(attendees_count==0)
			early_applicable = disc_number
		end
	end
end

def self.attendeesCount(act_sched,disc_id, provider_disc_id)
	if act_sched && disc_id && provider_disc_id
		check_attendeesCount = (act_sched.schedule_mode.downcase=='any time') ? ActivityAttendDetail.where("activity_id=? and lower(payment_status)=? and discount_id=? and provider_discount_type_id = ?",act_sched.activity_id,'paid',disc_id,provider_disc_id).count : ActivityAttendDetail.where("schedule_id=? and lower(payment_status)=? and discount_id=? and provider_discount_type_id = ?",act_sched.schedule_id,'paid',disc_id,provider_disc_id).count
	end
end
  

end
