class ActivityTrack < ActiveRecord::Base
  attr_accessible :activity_id, :inserted_date, :modified_date, :track_id, :parent_user_id, :from_email, :to_email, :message, :date, :activity_name
  def self.store_providercard_withuser(uid,date,email,proemail,msg)
	@clk_track = ActivityTrack.new #insert the data
	#~ @clk_track.activity_id = params[:activity_id] if !params[:activity_id].nil? && params[:activity_id]!="" && params[:activity_id].present?
	#~ @clk_track.activity_name = @activity.activity_name if !@activity.nil? && !@activity.activity_name.nil?
	@clk_track.parent_user_id = "#{uid}" if !uid.nil? && uid.present? && uid!=''
	@clk_track.date = "#{date}"
	@clk_track.from_email = "#{email}" if !email.nil?
	@clk_track.to_email = "#{proemail}" if !proemail.nil?
	@clk_track.message = "#{msg}" if !msg.nil?
	@clk_track.message_type = "provider"
	@clk_track.inserted_date = Time.now
	@clk_track.modified_date = Time.now
	@clk_track.save
   end
  
end
