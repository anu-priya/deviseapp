
namespace :activity_total_count  do
 desc "update activity_counts details with total_activity_count"
   task :total_display_count_update => :environment do
	  puts "---------------starting to update---------------"
		Activity.all.each do |act|
			a_count = ActivityCount.where("activity_id=?",act.activity_id)
			total = a_count.sum(:activity_count)
			act_tot_count = ActivityTotalCount.where("activity_id=?",act.activity_id)
			if act_tot_count && !act_tot_count.empty? && act_tot_count.present? && act_tot_count.last && !act_tot_count.last.nil?
				act_tot_count.last.update_attributes(:activity_display_count => total) 
				puts "#{act.activity_id} is updated"
			else
				act_dis = ActivityTotalCount.new
				act_dis.activity_id = act.activity_id
				act_dis.activity_display_count = total
				act_dis.save
				puts "#{act.activity_id} is inserted"
			end
			
		end
	  puts "---------------end of update---------------"
   end
end