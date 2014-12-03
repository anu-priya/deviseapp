namespace :update_schedule_status  do
 desc "update schedule id for anywhere acitivity"
   task :price => :environment do
	  puts "---------------starting to update---------------"
	    @price=ActivityPrice.all
	    @price.each do |price|
	        @schedule=ActivitySchedule.where("schedule_mode !=? and activity_id=?","Schedule", price.activity_id).map(&:schedule_id)
	        price.update_attributes(:activity_schedule_id => @schedule[0]) if !@schedule.nil? && @schedule.present?
	    	puts "#{price.activity_id} is changed" if !@schedule.nil? && @schedule.present?
	    end
	  puts "---------------end of update---------------"
   end
end

