class ActivitySchedulesController < ApplicationController
  before_filter :authenticate_user
  layout 'landing_layout'

  def activity_provider_schedule
	  @get_current_url = request.env['HTTP_HOST']
	  render :layout=>"provider_layout"
  end

  def activity_parent_schedule
    @get_current_url = request.env['HTTP_HOST']
  end

  def schedule_repeat_append(event,events,type_icon,pmode)
    if pmode.downcase =='parent'
      paction = 'activity_parent_schedule'
    else
      paction ='activity_provider_schedule'
    end
    
   #Accept button for school representative flow
   school_rep = SchoolRepresentative.where("activity_id=? and representative_id=?",event.activity_id,current_user.user_id).last
   @test_val = (school_rep && !school_rep.nil? && school_rep.present? && school_rep.status.downcase=='pending') ? 'true' : 'false'
   @edit_test_val = (school_rep && !school_rep.nil? &&school_rep.present? && !school_rep.edit_p.nil? && school_rep.edit_p) ? 'true' : ((school_rep.nil?) ? 'true' : 'false')
   @del_test_val = (school_rep && !school_rep.nil? &&school_rep.present? && !school_rep.delete_p.nil? && school_rep.delete_p)  ? 'true' : ((school_rep.nil?) ? 'true' : 'false')
   @school_rep_present = (school_rep && !school_rep.nil?) ? 'true' : 'false'
   

    if @schedule.schedule_mode == "Schedule"
      sta_time = @schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?
      en_time = @schedule.end_time.strftime('%H:%M:00') if !@schedule.end_time.nil?
      start_date = "#{@schedule.start_date} #{sta_time}" 
      end_date = "#{@schedule.start_date} #{en_time}"
      @repeat = ActivityRepeat.where("activity_schedule_id =?",@schedule.schedule_id).last
      info = false
      js_start_date = Time.at(params['start'].to_i)
      js_end_date =Time.at(params['end'].to_i)
      @type_icon = type_icon
      if @repeat
        if @repeat.repeats == "Daily"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            repeat_schedule(event, events, js_end_date, js_start_date, running_date,'daily',info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              repeat_schedule_end(event, events, js_end_date, js_start_date, occ, running_date,'daily',info)
            else
              occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
              repeat_schedule_occurance(event, events, js_end_date, js_start_date, occ, running_date,'daily',info)
            end
          end
        end
        if @repeat.repeats == "yearly"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            repeat_schedule(event, events, js_end_date, js_start_date, running_date,'yearly',info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              repeat_schedule_end(event, events, js_end_date, js_start_date, occ, running_date,'yearly',info)
            else
              occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
              repeat_schedule_end(event, events, js_end_date, js_start_date, occ, running_date,'yearly',info)
            end
          end
        end
        if @repeat.repeats == "Weekly"
          running_date = @schedule.start_date
          @wek =[]
          @ss =[]
          rep = @repeat.repeat_on.split(",") if !@repeat.nil? && !@repeat.repeat_on.nil?
          rep.each do|s|
            if s=="Mon"||s=="mon"
              @wek.push(1)
              @ss.push(:monday)
            elsif s =="Tue"||s=="tue"
              @wek.push(2)
              @ss.push(:tuesday)
            elsif s =="Wed"||s=="wed"
              @wek.push(3)
              @ss.push(:wednesday)
            elsif s =="Thu"||s=="thu"
              @wek.push(4)
              @ss.push(:thursday)
            elsif s =="Fri"||s=="fri"
              @wek.push(5)
              @ss.push(:friday)
            elsif s =="Sat"||s=="sat"
              @wek.push(6)
              @ss.push(:saturday)
            elsif s =="Sun"||s=="sun"
              @wek.push(0)
              @ss.push(:sunday)
            end if s!=""
          end if !rep.nil?
          if @repeat.ends_never == true
            repeat_weekly_never(event, events, js_end_date, js_start_date, running_date,info) if !@ss.nil? && !@ss.empty?
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              repeat_weekly(event, events, js_end_date, js_start_date, occ, running_date,info) if !@ss.nil? && !@ss.empty?
            else
              occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i * 7).days
              repeat_weekly(event, events, js_end_date, js_start_date, occ, running_date,info) if !@ss.nil? && !@ss.empty?
            end
          end
        end
        if @repeat.repeats == "Monthly"
          running_date = @schedule.start_date
          if @repeat.repeated_by_month == true
            s = week_of_month_for_date(running_date)
            if s == 1
              se = :first
            elsif s==2
              se = :second
            elsif s==3
              se = :third
            elsif s>=4
              se = :last
            end

            if @repeat.ends_never == true
              repeat_monthly_day_never(event, events, js_end_date, js_start_date, running_date,se,info)
            else
              if !@repeat.ends_on.nil?
                occ = @repeat.ends_on
                repeat_monthly_day(event, events, js_end_date, js_start_date, occ, running_date,se,info)
              else
                occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
                repeat_monthly_day(event, events, js_end_date, js_start_date, occ, running_date,se,info)
              end
            end
          else
            if @repeat.ends_never == true
              repeat_monthly_date_never(event, events, js_end_date, js_start_date, running_date,se,info)
            else
              if !@repeat.ends_on.nil?
                occ = @repeat.ends_on
                repeat_monthly_date(event, events, js_end_date, js_start_date, occ, running_date,se,info)
              else
                occ = @schedule.start_date + (@repeat.repeat_every.to_i * @repeat.end_occurences.to_i).days
                repeat_monthly_date(event, events, js_end_date, js_start_date, occ, running_date,se,info)
              end
            end
          end
        end
        if @repeat.repeats == "Every week (Monday to Friday)"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            every_week_mon_to_fri_never(event, events, js_end_date, js_start_date, running_date,info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              every_week_mon_to_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
            else
              occ = @schedule.start_date + (@repeat.end_occurences.to_i * 7).days
              every_week_mon_to_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
            end
          end
        end
        if @repeat.repeats == "Every Monday,Wednesday and Friday"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            every_mon_wed_fri_never(event, events, js_end_date, js_start_date, running_date,info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              every_mon_wed_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
            else
              occ = @schedule.start_date + (@repeat.end_occurences.to_i * 7).days
              every_mon_wed_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
            end
          end
        end
        if @repeat.repeats == "Every Tuesday and Thursday"
          running_date = @schedule.start_date
          if @repeat.ends_never == true
            every_tue_thu_never(event, events, js_end_date, js_start_date, running_date,info)
          else
            if !@repeat.ends_on.nil?
              occ = @repeat.ends_on
              every_tue_thu(event, events, js_end_date, js_start_date, occ, running_date,info)
            else
              occ = @schedule.start_date + (@repeat.end_occurences.to_i * 7).days
              every_tue_thu(event, events, js_end_date, js_start_date, occ, running_date,info)
            end
          end
        end
      else
        sta_time = @schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?
        en_time = @schedule.end_time.strftime('%H:%M:00') if !@schedule.end_time.nil?
        start_date = "#{@schedule.start_date} #{sta_time}"
        end_date = "#{@schedule.start_date} #{en_time}"
        p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{sta_time} to #{en_time}" if !@schedule.start_date.nil?
        st_change_time = @schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?
        en_change_time = @schedule.end_time.strftime('%l:%M %p') if !@schedule.end_time.nil?
        #address changes
        if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
          address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
        elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
          address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
        elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
        elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}"
        end
        p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{st_change_time} - #{en_change_time}"
        events << {:pmode=>pmode,:paction=>paction,:id => event.activity_id, :title => event.activity_name,:leader=>event.leader, :pop_change_date =>p_change_date, :pop_date=>p_date,:address=>address, :description => event.description,:uni_date=>@schedule.start_date, :start => "#{start_date}", :end => "#{end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}
      end
    elsif @schedule.schedule_mode == "Camps/Workshop" || @schedule.schedule_mode == "Whole Day"
      sta_time = @schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?
      en_time = @schedule.end_time.strftime('%H:%M:00') if !@schedule.end_time.nil?
      start_date = "#{@schedule.start_date} #{sta_time}" if !@schedule.start_time.nil?
      end_date = "#{@schedule.end_date} #{en_time}" if !@schedule.end_date.nil?
      p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{sta_time} - #{@schedule.end_date.strftime("%a %m/%d/%Y") if !@schedule.end_date.nil?} #{en_time}"
      #date format changes
      st_change_time = @schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?
      en_change_time = @schedule.end_time.strftime('%l:%M %p') if !@schedule.end_time.nil?
      p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{st_change_time} - #{@schedule.end_date.strftime("%a, %b %d, %Y") if !@schedule.end_date.nil?} #{en_change_time}"

      #address changes
      if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
        address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
      elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
        address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
      elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
        address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
      elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
        address = "#{event.address_1}"
      end
      if pmode.downcase =='parent'
        #data_ran = ("#{start_date}".."#{end_date}").to_a
        r = Recurrence.new(:every => :day, :starts => start_date, :until => end_date)
        r.events.each { |date|
          events << {:pmode=>pmode,:paction=>paction,:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date, :pop_change_date => p_change_date, :address=>address, :description => event.description,:uni_date=>@schedule.start_date, :start => "#{date} #{sta_time}", :end => "#{date} #{en_time}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}
        }
      else

        if @schedule.start_date==@schedule.end_date
          events << {:pmode=>pmode,:paction=>paction,:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date, :pop_change_date => p_change_date, :address=>address, :description => event.description,:uni_date=>@schedule.start_date, :start => "#{start_date}", :end => "#{end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}
        else
          events << {:pmode=>pmode,:paction=>paction,:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date, :pop_change_date => p_change_date, :address=>address, :description => event.description,:uni_date=>@schedule.start_date, :start => "#{start_date}", :end => "#{end_date}", :allDay =>1,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}
        end
      end
    elsif @schedule.schedule_mode == "Any Time"
      any_time = ActivitySchedule.where("activity_id = ?",event.activity_id)

      any_time.each do|s|
        if s.business_hours =="mon"
          r = Recurrence.new(:every => :week, :on => :monday,:starts =>event.inserted_date.strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          p_date = "#{s.start_time.strftime('%I:%M %p') if !s.nil? && !s.start_time.nil? } to #{s.end_time.strftime('%I:%M %p') if !s.nil? && !s.end_time.nil?}"
          p_change_date = "#{s.start_time.strftime("%l:%M %p") if !s.nil? && !s.start_time.nil?} - #{s.end_time.strftime('%l:%M %p') if !s.nil? && !s.end_time.nil?}"
          #address changes
          if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
            address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
          elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
            address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
          elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
          elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}"
          end
          r.events.each { |date| events << {:pmode=>pmode,:paction=>paction,:id => event.activity_id, :title => event.activity_name, :description => event.description,:leader=>event.leader, :pop_change_date =>p_change_date, :pop_date=>p_date,:address=>address,:uni_date=>"#{date.to_s}#{event.activity_id}", :start => "#{date.to_s}", :end => "#{date.to_s}", :allDay =>1,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present } }
        elsif s.business_hours =="tue"
          #address changes
          if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
            address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
          elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
            address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
          elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
          elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}"
          end
          p_date = "#{s.start_time.strftime('%I:%M %p') if !s.nil? && !s.start_time.nil?} to #{s.end_time.strftime('%I:%M %p') if !s.nil? && !s.end_time.nil?}"
          p_change_date = "#{s.start_time.strftime("%l:%M %p") if !s.nil? && !s.start_time.nil?} - #{s.end_time.strftime('%l:%M %p') if !s.nil? && !s.end_time.nil?}"
          r = Recurrence.new(:every => :week, :on => :tuesday,:starts =>event.inserted_date.strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:pmode=>pmode,:paction=>paction,:id => event.activity_id, :title => event.activity_name, :description => event.description,:leader=>event.leader, :pop_change_date =>p_change_date, :pop_date=>p_date,:address=>address,:uni_date=>"#{date.to_s}#{event.activity_id}", :start => "#{date.to_s}", :end => "#{date.to_s}", :allDay =>1,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present } }
        elsif s.business_hours =="wed"
          #address changes
          if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
            address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
          elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
            address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
          elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
          elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}"
          end
          p_date = "#{s.start_time.strftime('%I:%M %p') if !s.nil? && !s.start_time.nil?} to #{s.end_time.strftime('%I:%M %p') if !s.nil? && !s.end_time.nil?}"
          p_change_date = "#{s.start_time.strftime("%l:%M %p") if !s.nil? && !s.start_time.nil?} - #{s.end_time.strftime('%l:%M %p') if !s.nil? && !s.end_time.nil?}"
          r = Recurrence.new(:every => :week, :on => :wednesday,:starts =>event.inserted_date.strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:pmode=>pmode,:paction=>paction,:id => event.activity_id, :title => event.activity_name, :description => event.description,:leader=>event.leader, :pop_change_date =>p_change_date, :pop_date=>p_date,:address=>address,:uni_date=>"#{date.to_s}#{event.activity_id}", :start => "#{date.to_s}", :end => "#{date.to_s}", :allDay =>1,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present } }
        elsif s.business_hours =="thu"
          #address changes
          if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
            address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
          elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
            address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
          elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
          elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}"
          end
          p_date = "#{s.start_time.strftime('%I:%M %p') if !s.nil? && !s.start_time.nil?} to #{s.end_time.strftime('%I:%M %p') if !s.nil? && !s.end_time.nil?}"
          p_change_date = "#{s.start_time.strftime("%l:%M %p") if !s.nil? && !s.start_time.nil?} - #{s.end_time.strftime('%l:%M %p') if !s.nil? && !s.end_time.nil?}"
          r = Recurrence.new(:every => :week, :on =>:thursday,:starts =>event.inserted_date.strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:pmode=>pmode,:paction=>paction,:id => event.activity_id, :title => event.activity_name, :description => event.description,:leader=>event.leader, :pop_change_date =>p_change_date, :pop_date=>p_date,:address=>address,:uni_date=>"#{date.to_s}#{event.activity_id}", :start => "#{date.to_s}", :end => "#{date.to_s}", :allDay =>1,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present } }
        elsif s.business_hours =="fri"
          #address changes
          if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
            address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
          elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
            address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
          elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
          elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}"
          end
          p_date = "#{s.start_time.strftime('%I:%M %p') if !s.nil? && !s.start_time.nil?} to #{s.end_time.strftime('%I:%M %p') if !s.nil? && !s.end_time.nil? }"
          p_change_date = "#{s.start_time.strftime("%l:%M %p") if !s.nil? && !s.start_time.nil?} - #{s.end_time.strftime('%l:%M %p') if !s.nil? && !s.end_time.nil?}"
          r = Recurrence.new(:every => :week, :on =>:friday,:starts =>event.inserted_date.strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:pmode=>pmode,:paction=>paction,:id => event.activity_id, :title => event.activity_name, :description => event.description,:leader=>event.leader,:pop_change_date =>p_change_date, :pop_date=>p_date,:address=>address,:uni_date=>"#{date.to_s}#{event.activity_id}", :start => "#{date.to_s}", :end => "#{date.to_s}", :allDay =>1,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present } }
        elsif s.business_hours =="sat"
          #address changes
          if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
            address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
          elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
            address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
          elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
          elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}"
          end
          p_date = "#{s.start_time.strftime('%I:%M %p') if !s.nil? && !s.start_time.nil?} to #{s.end_time.strftime('%I:%M %p') if !s.nil? && !s.end_time.nil?}"
          p_change_date = "#{s.start_time.strftime("%l:%M %p") if !s.nil? && !s.start_time.nil?} - #{s.end_time.strftime('%l:%M %p') if !s.nil? && !s.end_time.nil?}"
          r = Recurrence.new(:every => :week, :on => :saturday,:starts =>event.inserted_date.strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:pmode=>pmode,:paction=>paction,:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_change_date =>p_change_date, :pop_date=>p_date,:address=>address, :description => event.description,:uni_date=>"#{date.to_s}#{event.activity_id}", :start => "#{date.to_s}", :end => "#{date.to_s}", :allDay =>1,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present } }
        elsif s.business_hours =="sun"
          #address changes
          if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
            address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
          elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
            address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
          elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
          elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}"
          end
          p_date = "#{s.start_time.strftime('%I:%M %p') if !s.nil? && !s.start_time.nil?} to #{s.end_time.strftime('%I:%M %p') if !s.nil? && !s.end_time.nil?}"
          p_change_date = "#{s.start_time.strftime("%l:%M %p") if !s.nil? && !s.start_time.nil?} - #{s.end_time.strftime('%l:%M %p') if !s.nil? && !s.end_time.nil?}"
          r = Recurrence.new(:every => :week, :on => :sunday,:starts =>event.inserted_date.strftime("%Y-%m-%d"),:until => Time.at(params['end'].to_i).strftime("%Y-%m-%d"))
          r.events.each { |date| events << {:pmode=>pmode,:paction=>paction,:id => event.activity_id, :title => event.activity_name,:leader=>event.leader, :pop_change_date =>p_change_date, :pop_date=>p_date,:address=>address, :description => event.description,:uni_date=>"#{date.to_s}#{event.activity_id}", :start => "#{date.to_s}", :end => "#{date.to_s}", :allDay =>1,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present } }
        end if s.business_hours!=""
      end
    end if @schedule

  end #single shedule end

  def get_provider_cal
    #~ @activity_created = Activity.find_by_sql("select * from activities where user_id =#{cookies[:uid_usr]} and created_by='Provider'and (lower(active_status)='active') order by activity_id desc").uniq
    
    @activity_created = Activity.find_by_sql("select a.* from activities a left join school_representatives s on a.activity_id=s.activity_id where (user_id=#{cookies[:uid_usr]} or vendor_id=#{cookies[:uid_usr]} or representative_id=#{cookies[:uid_usr]}) and cleaned=true and lower(active_status)!='delete' and lower(created_by)='provider' order by a.activity_id desc").uniq
    events = []
    @activity_created.each do |event|
     @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id)
     @by = ActivitySchedule.where("activity_id = ? and schedule_mode =?",event.activity_id,"Any Time").last
      if @schedule.count ==1 
            @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
            schedule_repeat_append(event,events,"created",'provider') if !@schedule.nil?
     elsif @schedule.count !=1  && !@by.nil?  && @by.present?  
            @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
            schedule_repeat_append(event,events,"created",'provider') if !@schedule.nil?
     elsif @schedule.count >1 
        @schedule.each do |ss|
          @schedule=ss
          schedule_repeat_append(event,events,"created",'provider') if !@schedule.nil?
      end
  end
    end
    response.content_type = Mime::JSON
    render :text => events.to_json
  end

  def get_provider_calold
    @activity_created = Activity.find_by_sql("select * from activities where user_id =#{cookies[:uid_usr]} and created_by='Provider'and (lower(active_status)='active') order by activity_id desc").uniq
    events = []
    @activity_created.each do |event|
      @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
      schedule_repeat_append(event,events,"created",'provider') if !@schedule.nil?
    end
    response.content_type = Mime::JSON
    render :text => events.to_json
  end

  def get_sched_cal
    events = []
    #created activity
    @activity_created = Activity.find_by_sql("select * from activities where user_id =#{cookies[:uid_usr]} and created_by='Parent' and (lower(active_status)='active') order by activity_id desc").uniq
    #activity created list
    @activity_created.each do |event|
       @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
      if event.created_by =="Parent" && event.schedule_mode =="Any Time"
        js_start_date = Time.at(params['start'].to_i).strftime("%Y-%m-%d")
        js_end_date =Time.at(params['end'].to_i).strftime("%Y-%m-%d")
        p_date = ""
        p_change_date = ""
        #address changes
        if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
          address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
        elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
          address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
        elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
        elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}"
        end
        events << {:pmode=>'parent',:paction=>'activity_parent_schedule',:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date, :pop_change_date => p_change_date, :address=>address, :description => event.description,:uni_date=>js_start_date, :start => "#{js_start_date}", :end => "#{js_end_date}", :allDay =>1,:type_icon=>"created", :recurring => true,:schedule_type=>event.schedule_mode}
      elsif !@schedule.nil?
        schedule_repeat_append(event,events,"created",'parent')
      end
    end if !@activity_created.nil?
    
     ##############################################
     #~ @user_calender_old = Activity.find_by_sql("select * from activities where activity_id in(select activity_id from user_calenders where user_id = #{current_user.user_id}) and lower(active_status)='active' order by activity_id desc").uniq
      #activiy add calender list
     @user_calender = ActivitySchedule.find_by_sql("select * from activity_schedules where schedule_id in(select Distinct(schedule_id) from user_calenders where user_id = #{current_user.user_id}) order by schedule_id desc").uniq if !current_user.nil?
     if !@user_calender.nil? && @user_calender.present?
	      @schedule = @user_calender
	      if @user_calender.count ==1
			event = Activity.find_by_activity_id(@user_calender[0].activity_id)
			@schedule = ''
			@schedule = ActivitySchedule.where("activity_id = ?",@user_calender[0].activity_id).last
			schedule_repeat_append(event,events,"ucalender",'parent')
	       elsif @user_calender.count >1
			@user_calender.each do |ss|
				@schedule = ''
				@schedule = ss if !ss.nil?
				event = ''
				event = Activity.find_by_activity_id(ss.activity_id) if !ss.nil?
				schedule_repeat_append(event,events,"ucalender",'parent') if !event.nil?
			end if !@user_calender.nil? #do end
	       end #if end
       end #schedule act end
      #activiy add calender list end
    #############################################
     #favorite activity
    @activity_fav = Activity.find_by_sql("select * from activities where activity_id in(select activity_id from activity_favorites where user_id = #{current_user.user_id} ) and (lower(active_status)='active') order by activity_id desc").uniq
      #activiy favorites list
     @activity_fav.each do |event|
     @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id)
     if @schedule.count ==1 
            @schedule = ActivitySchedule.where("activity_id = ?",event.activity_id).last
            schedule_repeat_append(event,events,"saved",'parent') if !@schedule.nil?
     elsif @schedule.count >1 
        @schedule.each do |ss|
		@schedule = ''
		@schedule = ss if !ss.nil?
		event = ''
		event = Activity.find_by_activity_id(ss.activity_id) if !ss.nil?
		schedule_repeat_append(event,events,"saved",'parent') if !event.nil?
        end #do end
     elsif event.created_by =="Parent" && event.schedule_mode =="Any Time"
        js_start_date = Time.at(params['start'].to_i).strftime("%Y-%m-%d")
        js_end_date =Time.at(params['end'].to_i).strftime("%Y-%m-%d")
        p_date = ""
        p_change_date = ""
        #address changes
        if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
          address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
        elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
          address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
        elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
        elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}"
        end
        events << {:pmode=>'parent',:paction=>'activity_parent_schedule',:id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date, :pop_change_date => p_change_date, :address=>address, :description => event.description,:uni_date=>js_start_date, :start => "#{js_start_date}", :end => "#{js_end_date}", :allDay =>1,:type_icon=>"saved", :recurring => true,:schedule_type=>event.schedule_mode}
     end #if end
    end if !@activity_fav.nil? #do end
      #activiy favorites list end
    #############################################
      #~ @activit_purchased_old = Activity.find_by_sql("select * from activities where activity_id in(select Distinct(activity_id) from activity_attend_details where lower(payment_status) = 'paid' and user_id = #{current_user.user_id} ) and (lower(active_status)='active') order by activity_id desc").uniq
      #activiy purchased list
     @activit_purchased = ActivitySchedule.find_by_sql("select * from activity_schedules where schedule_id in(select Distinct(schedule_id) from activity_attend_details where lower(payment_status) = 'paid' and user_id = #{current_user.user_id}) order by schedule_id desc").uniq if !current_user.nil?
      if !@activit_purchased.nil? && @activit_purchased.present?
	      @schedule = @activit_purchased
	      if @activit_purchased.count ==1
			event = Activity.find_by_activity_id(@activit_purchased[0].activity_id)
			@schedule = ''
			@schedule = ActivitySchedule.where("activity_id = ?",@activit_purchased[0].activity_id).last
			schedule_repeat_append(event,events,"purchase",'parent')
	       elsif @activit_purchased.count >1
			@activit_purchased.each do |ss|
				@schedule = ''
				@schedule = ss if !ss.nil?
				event = ''
				event = Activity.find_by_activity_id(ss.activity_id) if !ss.nil?
				schedule_repeat_append(event,events,"purchase",'parent') if !event.nil?
			end if !@activit_purchased.nil? #do end
	       end #if end
       end #schedule act end
      #activiy purchased list end
    #############################################

    response.content_type = Mime::JSON
    render :text => events.to_json
  end #get schedule call method end for parent page

  # TODO Comment
  def repeat_weekly(event, events, js_end_date, js_start_date, occ, running_date,info)
    date_un = DateTime.parse(js_end_date.to_s)
    if !@ss.nil? && @ss!=""
      if @repeat.repeat_every.to_i !=0
        r = Recurrence.new(:every => :week, :on => @ss,:starts =>running_date,:until => date_un,:interval=>@repeat.repeat_every.to_i)
      else
        r = Recurrence.new(:every => :week, :on => @ss,:starts =>running_date,:until => date_un)
      end
      p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil?} to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
      p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"

      if !running_date.nil?
        while js_end_date >= running_date
          if js_start_date <= running_date
            if running_date <= occ
              if r.events.include?(running_date)
                p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
                repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
                repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00') if !@schedule.end_time.nil?}"
                #address changes
                if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
                  address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
                elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
                  address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
                elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
                  address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
                elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
                  address = "#{event.address_1}"
                end
                events << {:id => event.activity_id, :title => event.activity_name,:address=>address,:uni_date=>running_date.strftime("%Y-%m-%d"),:leader=>event.leader,:pop_date=>p_date,  :pop_change_date => p_change_date, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but => @test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}

                #            events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
              end
            end
          end
          running_date = running_date + 1.days
        end
      end
    end
    return running_date
  end

  # TODO Comment
  def repeat_weekly_never(event, events, js_end_date, js_start_date, running_date,info)
    date_js = DateTime.parse(js_end_date.to_s)
    if !@ss.nil? && @ss!=""
      if @repeat.repeat_every.to_i !=0
        r = Recurrence.new(:every => :week, :on => @ss,:starts =>running_date,:until => date_js,:interval=>@repeat.repeat_every.to_i)
      else
        r = Recurrence.new(:every => :week, :on => @ss,:starts =>running_date,:until => date_js)
      end
      p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil? } to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
      p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
      
      while js_end_date >= running_date
        if js_start_date <= running_date
          if r.events.include?(running_date)
            p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
            #address changes
            if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
              address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
            elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
              address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
            elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
              address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
            elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
              address = "#{event.address_1}"
            end
            repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
            repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00') if !@schedule.end_time.nil?}"
            events << {:pop_change_date => p_change_date, :id => event.activity_id, :title => event.activity_name,:address=>address,:uni_date=>running_date.strftime("%Y-%m-%d"), :leader=>event.leader,:pop_date=>p_date, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but => @test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}
   
            #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
          end
        end
        running_date = running_date + 1.days
      end
    end
    return running_date
  end

  # TODO Comment
  def repeat_monthly_day(event, events, js_end_date, js_start_date, occ, running_date,se,info)
    w_day = running_date.strftime("%A")
    r = Recurrence.new(:every => :month, :on => se,  :weekday =>:"#{w_day.downcase}" , :interval => @repeat.repeat_every.to_i)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil?} to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
    p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
    
    while js_end_date >= running_date
      if running_date <= occ
        if r.events.include?(running_date)
          p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
          #address changes
          if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
            address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
          elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
            address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
          elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
          elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}"
          end
          repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
          repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')if !@schedule.end_time.nil?}"
          events << {:pop_change_date => p_change_date, :id => event.activity_id, :title => event.activity_name,:address=>address,:uni_date=>running_date.strftime("%Y-%m-%d"),:leader=>event.leader,:pop_date=>p_date,:description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}

          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end if js_start_date < running_date
      end
      running_date = running_date + 1.days
    end

    return repeat_end_date, repeat_start_date, running_date
  end

  # TODO Comment
  def repeat_monthly_day_never(event, events, js_end_date, js_start_date,running_date,se,info)
    w_day = running_date.strftime("%A")
    r = Recurrence.new(:every => :month, :on => se,  :weekday =>:"#{w_day.downcase}" , :interval => @repeat.repeat_every.to_i)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y")  if !@schedule.start_date.nil? } #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil? } to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
    p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
     
    while js_end_date >= running_date
      if js_start_date <= running_date
        if r.events.include?(running_date)
          #address changes
          if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
            address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
          elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
            address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
          elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
          elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}"
          end
          p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
          repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
          repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00') if !@schedule.end_time.nil?}"
          events << {:pop_change_date => p_change_date, :id => event.activity_id, :title => event.activity_name,:address=>address, :leader=>event.leader,:pop_date=>p_date, :uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}
   
          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      running_date = running_date + 1.days
    end
    return repeat_end_date, repeat_start_date, running_date
  end
  
  # TODO Comment
  def repeat_monthly_date_never(event, events, js_end_date, js_start_date,running_date,se,info)
    w_date = running_date.strftime("%d")
    r = Recurrence.new(:every => :month, :on => w_date.to_i, :interval => @repeat.repeat_every.to_i)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil? } #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil?} to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
    p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
     
    while js_end_date >= running_date
      if js_start_date <= running_date
        if r.events.include?(running_date)
          #address changes
          if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
            address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
          elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
            address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
          elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
          elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}"
          end
          repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
          repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')  if !@schedule.end_time.nil?}"
          events << {:pop_change_date => p_change_date, :id => event.activity_id, :title => event.activity_name,:address=>address, :leader=>event.leader,:pop_date=>p_date, :uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}

          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      running_date = running_date + 1.days
    end
    return repeat_end_date, repeat_start_date, running_date
  end

  def repeat_monthly_date(event, events, js_end_date, js_start_date, occ, running_date,se,info)
    w_date = running_date.strftime("%d")
    r = Recurrence.new(:every => :month, :on => w_date.to_i, :interval => @repeat.repeat_every.to_i)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil?} to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
    p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"

    while js_end_date >= running_date
      if running_date <= occ
        if r.events.include?(running_date)
          #address changes
          if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
            address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
          elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
            address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
          elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
          elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}"
          end
          repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
          repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00') if !@schedule.end_time.nil?}"
          events << {:pop_change_date => p_change_date, :id => event.activity_id, :title => event.activity_name,:address=>address,:uni_date=>running_date.strftime("%Y-%m-%d"),:leader=>event.leader,:pop_date=>p_date,:description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}

          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end if js_start_date <= running_date
      end
      running_date = running_date + 1.days
    end

    return repeat_end_date, repeat_start_date, running_date
  end

  # TODO Comment
  def every_week_mon_to_fri_never(event, events, js_end_date, js_start_date, running_date,info)

    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil?} to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
    p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"

    while js_end_date >= running_date
      if running_date.wday !=0 && running_date.wday !=6
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00') if !@schedule.end_time.nil?}"
        #address changes
        if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
          address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
        elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
          address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
        elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
        elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}"
        end
        events << {:pop_change_date => p_change_date, :id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>address,:uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}

        #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
      end if js_start_date <= running_date

      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def every_week_mon_to_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil?} to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
    p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
     
    while js_end_date >= running_date
      if running_date.wday !=0 && running_date.wday !=6
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')  if !@schedule.end_time.nil?}"
        #address changes
        if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
          address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
        elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
          address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
        elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
        elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}"
        end
        events << {:pop_change_date => p_change_date, :id => event.activity_id, :title => event.activity_name,:uni_date=>running_date.strftime("%Y-%m-%d"),:leader=>event.leader,:pop_date=>p_date,:address=>address, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}
   
        #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
      end if running_date <= occ if js_start_date <= running_date
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def every_mon_wed_fri_never(event, events, js_end_date, js_start_date, running_date,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil?} to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
    p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
     
    while js_end_date >= running_date
      if running_date.wday ==1 || running_date.wday == 3 || running_date.wday == 5
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00') if !@schedule.end_time.nil?}"
        #address changes
        if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
          address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
        elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
          address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
        elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
        elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}"
        end
        events << {:pop_change_date => p_change_date, :id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>address,:uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}
   
        #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}

      end if js_start_date <= running_date
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def every_mon_wed_fri(event, events, js_end_date, js_start_date, occ, running_date,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil?} to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
    p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"

    while js_end_date >= running_date
      if running_date.wday ==1 || running_date.wday == 3 || running_date.wday == 5
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00') if !@schedule.end_time.nil?}"
        #address changes
        if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
          address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
        elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
          address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
        elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
        elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}"
        end
        events << {:pop_change_date => p_change_date, :id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>address,:uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}

        #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
      end if running_date <= occ if js_start_date <= running_date
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def every_tue_thu_never(event, events, js_end_date, js_start_date, running_date,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil?} to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
    p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
  
    while js_end_date >= running_date
      if running_date.wday ==2 || running_date.wday == 4
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00') if !@schedule.end_time.nil?}"
        #address changes
        if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
          address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
        elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
          address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
        elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
        elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}"
        end
        events << {:pop_change_date => p_change_date, :id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>address,:uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}
   
        #         events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
      end if js_start_date <= running_date
      running_date = running_date + 1.days
    end
    return running_date
  end

  # TODO Comment
  def every_tue_thu(event, events, js_end_date, js_start_date, occ, running_date,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil?} to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
    p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
    
    while js_end_date >= running_date
      if running_date.wday ==2 || running_date.wday == 4
        #address changes
        if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
          address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
        elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
          address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
        elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
        elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}"
        end
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00') if !@schedule.end_time.nil?}"
        events << {:pop_change_date => p_change_date, :id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>address,:uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}
   
      end if running_date <= occ if js_start_date <= running_date
      running_date = running_date + 1.days
    end
  end


  # TODO Comment
  def repeat_schedule_occurance(event, events, js_end_date, js_start_date, occ, running_date,type,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil?} to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
    p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
   
    while js_end_date >= running_date
      if running_date <= occ
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')  if !@schedule.end_time.nil?}"
        #address changes
        if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
          address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
        elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
          address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
        elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
        elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}"
        end
        events << {:pop_change_date => p_change_date, :id => event.activity_id, :title => event.activity_name,:leader=>event.leader,:pop_date=>p_date,:address=>address,:uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}
        #        events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
      end if js_start_date <= running_date
      rep = @repeat.repeat_every.to_i.days if type == 'daily'
      rep = @repeat.repeat_every.to_i.years if type == 'yearly'
      running_date = running_date + rep
    end
    return running_date
  end

  
  # TODO Comment
  def repeat_schedule_end(event, events, js_end_date, js_start_date, occ, running_date,type,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil?} to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
    p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
     
    while js_end_date >= running_date
      if js_start_date <= running_date
        if running_date <= occ
          repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
          repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00') if !@schedule.end_time.nil?}"
          #address changes
          if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
            address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
          elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
            address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
          elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
          elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
            address = "#{event.address_1}"
          end
          events << {:pop_change_date => p_change_date, :id => event.activity_id, :leader=>event.leader,:pop_date=>p_date,:address=>address,:title => event.activity_name,:uni_date=>running_date.strftime("%Y-%m-%d"), :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}
          #          events << {:id => event.activity_id, :title => event.activity_name, :description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :allDay =>0, :recurring => true}
        end
      end
      rep = @repeat.repeat_every.to_i.days if type == 'daily'
      rep = @repeat.repeat_every.to_i.years if type == 'yearly'

      running_date = running_date + rep
    end
    return running_date
  end
  
  # TODO Comment
  def repeat_schedule(event, events, js_end_date, js_start_date,running_date,type,info)
    p_date = "#{@schedule.start_date.strftime("%a %m/%d/%Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%I:%M %p') if !@schedule.start_time.nil? } to #{@schedule.end_time.strftime('%I:%M %p') if !@schedule.end_time.nil?}"
    p_change_date = "#{@schedule.start_date.strftime("%a, %b %d, %Y") if !@schedule.start_date.nil?} #{@schedule.start_time.strftime('%l:%M %p') if !@schedule.start_time.nil?} - #{@schedule.end_time.strftime("%l:%M %p") if !@schedule.end_time.nil?}"
     
    while js_end_date >= running_date
      if js_start_date <= running_date
        repeat_start_date = "#{running_date.strftime("%Y-%m-%d")} #{@schedule.start_time.strftime('%H:%M:00') if !@schedule.start_time.nil?}"
        repeat_end_date ="#{running_date.strftime("%Y-%m-%d")} #{@schedule.end_time.strftime('%H:%M:00')  if !@schedule.end_time.nil?}"
        #address changes
        if !event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present? && event.address_1[-1]==','
          address = "#{event.address_1} #{event.address_2}" if (!event.address_1.nil? && !event.address_2.nil?)
        elsif !event.address_1.nil? && event.address_1.present? && event.address_1[-1]==','
          address = "#{event.address_1[0..-2]}" if (!event.address_1.nil?)
        elsif (!event.address_1.nil? && !event.address_2.nil? && event.address_1.present? && event.address_2.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}, #{event.address_2}" if (!event.address_1.nil? || !event.address_2.nil?)
        elsif (!event.address_1.nil? && event.address_1.present?) && event.address_1[-1]!=','
          address = "#{event.address_1}"
        end
        events << {:pop_change_date => p_change_date, :id => event.activity_id, :leader=>event.leader,:pop_date=>p_date,:address=>address,:title => event.activity_name,:description => event.description, :start => "#{repeat_start_date}", :end => "#{repeat_end_date}", :uni_date=>running_date.strftime("%Y-%m-%d"),:info=>info, :allDay =>0,:type_icon=>@type_icon, :recurring => true,:schedule_type=>event.schedule_mode, :school_accept_but=>@test_val,:school_edit_permi=>@edit_test_val, :school_del_permi=>@del_test_val,:school_rep_present=>@school_rep_present}
      end
      rep = @repeat.repeat_every.to_i.days if type == 'daily'
      rep = @repeat.repeat_every.to_i.years if type == 'yearly'

      running_date = running_date + rep
    end

    return  running_date
  end

  
  def week_of_month_for_date(date)
    my_date = date
    week_of_target_date = my_date.strftime("%U").to_i
    week_of_beginning_of_month = my_date.beginning_of_month.strftime("%U").to_i
    week_of_target_date - week_of_beginning_of_month + 1
  end

  #  def sched
  #  end
  def sched
    edate = "2012-11-21"
    @activity = Activity.select("activities.*").joins(:activity_schedule).where("lower(active_status)='active' And (start_date in ('#{edate}') or (start_date<='#{edate}' and end_date > '#{edate}'))").uniq
  end

  def schedule_contact

  end
  
  def schedule_check
    
  end
end
