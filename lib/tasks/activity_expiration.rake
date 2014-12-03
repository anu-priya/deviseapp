namespace :activity_expiration  do
  desc "update all the activityschedule with expiration date"
  task :expiration => :environment do
    @activity = Activity.all
    @fail_schedule_id = []
    @fail_price = []
    @activity.each do |s|
      @activity_schedule = ActivitySchedule.where("activity_id = #{s.activity_id}")
      if !@activity_schedule.nil?
        @activity_schedule.each do |c|
          if c.schedule_mode == "Schedule"
            @activity_repeat = ActivityRepeat.where("activity_schedule_id = #{c.schedule_id}").last
            if !@activity_repeat.nil?
              if @activity_repeat.ends_never == true
                ex_date = "2100-12-31"
              else
                if !@activity_repeat.ends_on.nil? && @activity_repeat.ends_on !=""
                  ex_date = @activity_repeat.ends_on
                elsif !@activity_repeat.end_occurences.nil? &&@activity_repeat.end_occurences!=""
                  #~ ex_date = c.start_date + (@activity_repeat.repeat_every.to_i * @activity_repeat.end_occurences.to_i).days
		  #####################################################################
		   if @activity_repeat.repeats == "Daily"
			ex_date = c.start_date + (@activity_repeat.repeat_every.to_i * @activity_repeat.end_occurences.to_i).days
                   elsif @activity_repeat.repeats == "Weekly"
			ex_date = c.start_date + (@activity_repeat.repeat_every.to_i * @activity_repeat.end_occurences.to_i * 7).days
                   elsif  @activity_repeat.repeats == "Monthly"
			ex_date = c.start_date + (@activity_repeat.repeat_every.to_i * @activity_repeat.end_occurences.to_i).months
                   elsif @activity_repeat.repeats == "Yearly"
			ex_date = c.start_date + (@activity_repeat.repeat_every.to_i * @activity_repeat.end_occurences.to_i).years
                  end
		  #####################################################################
                end
              end
            end
            if ex_date =="" || ex_date.nil?
              ex_date = c.start_date
            end
            @update = c.update_attributes(:note=> s.note,:price_type=>s.price_type,:expiration_date => ex_date)
          elsif c.schedule_mode == "By Appointment"
            @update = c.update_attributes(:note=> s.note,:start_date=> "",:end_date=>"",:price_type=>s.price_type,:expiration_date => "2100-12-31")
          elsif c.schedule_mode == "Camps/Workshop" || c.schedule_mode == "Whole Day"
            if !c.end_date.nil?
              ex_date = c.end_date
            else
              ex_date = c.start_date
            end
            @update =  c.update_attributes(:note=> s.note,:price_type=>s.price_type,:expiration_date => ex_date)
          elsif c.schedule_mode == "Any Time"
            @update = c.update_attributes(:note=> s.note,:price_type=>s.price_type,:expiration_date => "2100-12-31")
          end
        
          if @update != true
            @fail_schedule_id << c.schedule_id
            
          end
          @arr = []
          @act_price = ActivityPrice.where("activity_id = #{s.activity_id}")
          if !@act_price.nil? && @act_price.present?
            @act_price.each do |t|
              @up_price =  t.update_attributes(:activity_schedule_id=>c.schedule_id)
              if @up_price != true
              
                @fail_price << t.activity_price_id
              end
             end
	  else
	     if s.price_type!='3'
		if c.schedule_mode.downcase == 'any time'
			@create_price = ActivityPrice.create(:price => s.price,:activity_id => s.activity_id)
		else
			@create_price = ActivityPrice.create(:price => s.price,:activity_id => s.activity_id, :activity_schedule_id=>c.schedule_id)
		end
		if @create_price.save!=true
			
			@arr << s.activity_id
		end
	     end
          end
    
        @activity_attend = ActivityAttendDetail.where("activity_id = #{s.activity_id}")
        if !@activity_attend.nil? 
		@activity_attend.each do |at|
			@updated_success = at.update_attributes(:schedule_id=>c.schedule_id)
		  if @updated_success !=true
			 
			  @fail_attends << at.attend_id
		  end
		end
	end
    
        end
      end
      p "Activity id: #{s.activity_id}"
    end

    p "failed schedule id :#{@fail_schedule_id}"
    p "failed price id :#{@fail_price}"
    p "failed price id :#{@fail_attends}"

    p "faild for activity price: #{@arr}"
  end
end