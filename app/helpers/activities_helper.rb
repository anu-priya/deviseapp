module ActivitiesHelper

  def get_all_subcategory_fromactivity(category)
	  @ac_sub = Activity.find(:all,:conditions=>["lower(category) = ?",category], :select =>"DISTINCT lower(trim(sub_category)) as sub_category").uniq if !category.nil? && category!=''
  end
  
  def getmangerdashbord(aid,pid,uid)
    ant = ActivityNetworkPermission.find_by_activity_id_and_provider_user_id_and_manager_user_id(aid,pid,uid) if !aid.nil? && !pid.nil? && !uid.nil?
  end

  #get the activity details
  def get_activity(act_id)
    #~ activ = Activity.where("activity_id=?",act_id).last
    act_price = ""
    act_price =  ActivityPrice.joins(:activity_schedule).where("activity_prices.activity_id = ? AND expiration_date >= ?",act_id,Date.today )if !act_id.nil? && act_id.present?
    #act_price= ActivityPrice.where("activity_id = ?", act_id) if !act_id.nil? && act_id.present?
    return act_price if !act_price.nil? && act_price!="" && act_price.present?
  end

  def add_to_activity_row(act_row,remove_row)
    if !act_row.nil?
      pro_act = act_row.split(",")
      if pro_act.length > 0
        pro_act.each do |s|
          if s !="" && !s.nil?
            act = ActivityRow.find_by_row_type_and_user_id(s,cookies[:uid_usr])
            if act.nil?
              @activity = ActivityRow.new
              @activity.row_type = s
              @activity.user_id = cookies[:uid_usr]
              @activity.inserted_date = Time.now
              @activity.save
            end
          end
        end
      end
    end
    if !remove_row.nil?
      pro_act = remove_row.split(",")
      if pro_act.length > 0
        pro_act.each do |s|
          act = ActivityRow.find_by_row_type_and_user_id(s,cookies[:uid_usr])if s !="" && !s.nil?
          act.destroy() if !act.nil?
        end
      end
    end
  end

  #get the anytime activities business hours
  def any_time_activity(act_id)
    @a_time=""
    @a_time= ActivitySchedule.where("activity_id = ?",act_id)
    @act = Activity.find(act_id)
    if @act.created_by.downcase=='provider' && !@a_time.nil? && @a_time.present? && !@a_time.first.schedule_mode.nil? && @a_time.first.schedule_mode.present? && @a_time.first.schedule_mode=="Any Time"
      @repeat_days=""
      @repeat_days=[]
      @a_time.each do |any_time|
        @repeat_days<<any_time.business_hours.downcase if !any_time.nil?
      end
    end
    return @repeat_days
  end
  
  def user_download_file(u_id)
    d_file = PolicyFile.where("user_id=?",u_id) if (!u_id.nil? && u_id.present?)
  end
  
  def SchoolRepDetail(user_id,schoolrep)
    if schoolrep && !schoolrep.nil? && user_id &&  !user_id.nil?
      sch_text = CheckUserSchoolType(schoolrep,user_id)
      if sch_text && sch_text=='vendor'
        title = 'Represented By:'
        u_id = schoolrep.representative_id
      elsif sch_text && sch_text=='representative'
        title = 'Vendor:'
        u_id = schoolrep.vendor_id
      end
      user = User.find(u_id)
      user_p_name = (user && !user.user_profile.nil? && !user.user_profile.business_name.nil?) ? user.user_profile.business_name : ''
      return title,user_p_name,user.user_name
    end
  end
  
  
  def CheckUserSchoolType(schoolrep,user_id)
    if schoolrep && !schoolrep.nil? && user_id && !user_id.nil?
      if schoolrep.vendor_id==user_id
        text = 'vendor'
      elsif schoolrep.representative_id==user_id
        text = 'representative'
      end
      return text
    end
  end
  
  
  
  def ActivityDetPermission(schoolrep,user_id,act)
    if !schoolrep && schoolrep.nil? && user_id==act.user_id
      set = true
    elsif !schoolrep.nil?
      set = true
    else
      set = false
    end
    return set
  end
  
  
  def EditDelPermission(schoolrep,user_id,act,set_status)
    if schoolrep && !schoolrep.nil?
      sch_text = CheckUserSchoolType(schoolrep,user_id)
      if sch_text=='vendor'
        set_p = true
      elsif sch_text=='representative'
        if schoolrep.status.downcase=='accepted'
          if set_status=='edit'
            set_p = (!schoolrep.edit_p.nil? && schoolrep.edit_p) ? true : false
            p set_p
          elsif set_status=='delete'
            set_p = (!schoolrep.delete_p.nil? && schoolrep.delete_p) ? true : false
          end
        else
          set_p = false
        end
      end
    else
      set_p = true
    end
    return set_p
  end
  
  
  #~ def ActivityDetPermission(schoolrep,user_id,act)
	#~ if schoolrep && !schoolrep.nil? && user_id && act && !act.nil?
	#~ sch_text = CheckUserSchoolType(schoolrep,user_id)
  #~ if !schoolrep && 	user_id==act.user_id
  #~ set = true
	#~ else
  #~ if sch_text=='vendor'
  #~ set = true
  #~ elsif sch_text=='representative'
  #~ if act.active_status.downcase=='active' && schoolrep.status.downcase=='accepted' && !schoolrep.edit_p.nil? && schoolrep.edit_p
  #~ set = true
  #~ end
  #~ else
  #~ set = false
  #~ end
	#~ end
	#~ else
  #~ set = false
	#~ end
	#~ return set
  #~ end

  def add_to_provider_discount_code(act_discount_row,remove_discount_row,activity_id)
    if !act_discount_row.nil?
      pro_act = act_discount_row.split(",")
      if pro_act.length > 0
        pro_act.each do |s|
          if s !="" && !s.nil?
            act = ProviderDiscountCode.find_by_discount_code_id_and_activity_id_and_user_id(s,activity_id,cookies[:uid_usr])if s !="" && !s.nil?
            if act.nil?
              @provider_discount_code = ProviderDiscountCode.new
              @provider_discount_code.discount_code_id = s
              @provider_discount_code.activity_id = activity_id
              @provider_discount_code.user_id = cookies[:uid_usr]
              @provider_discount_code.inserted_date = Time.now
              @provider_discount_code.save
            end
          end
        end
      end
    end
    if !remove_discount_row.nil?
      pro_act = remove_discount_row.split(",")
      if pro_act.length > 0
        pro_act.each do |s|
          act = ProviderDiscountCode.find_by_discount_code_id_and_activity_id_and_user_id(s,activity_id,cookies[:uid_usr])if s !="" && !s.nil?
          act.destroy() if !act.nil?
        end
      end
    end
  end
  
  def add_to_provider_fee(act_row,remove_row,activity_id)
    if !act_row.nil?
      pro_act = act_row.split(",")
      if pro_act.length > 0
        pro_act.each do |s|
          if s !="" && !s.nil?
            act = ProviderActivityFee.find_by_fee_type_id_and_activity_id_and_user_id(s,activity_id,cookies[:uid_usr])if s !="" && !s.nil?
            if act.nil?
              @provider_activity = ProviderActivityFee.new
              @provider_activity.fee_type_id = s
              @provider_activity.activity_id = activity_id
              @provider_activity.user_id = cookies[:uid_usr]
              @provider_activity.inserted_date = Time.now
              @provider_activity.save
            end
          end
        end
      end
    end
    if !remove_row.nil?
      pro_act = remove_row.split(",")
      if pro_act.length > 0
        pro_act.each do |s|
          act = ProviderActivityFee.find_by_fee_type_id_and_activity_id_and_user_id(s,activity_id,cookies[:uid_usr])if s !="" && !s.nil?
          act.destroy() if !act.nil?
        end
      end
    end
  end
  
  #settings for provider
  def user_setting(user_id)
	@flag = false
	@created_setting = ProviderSettingDetail.find_by_sql("select p.* from provider_setting_details s left join provider_settings p on s.provider_setting_id=p.provider_setting_id where s.setting_action='created' and p.user_id=#{user_id}")
	if !@created_setting.nil? && @created_setting!='' && @created_setting.present?
		#setting_option 1, show to famtiivty everyone
		@created_setting.each do |set_val|
			if set_val["setting_option"] == "1"
				@flag=true
			end
			if  current_user
				# setting_option 2, famtivity contact user only
				if set_val["setting_option"]=="2"
					@con_user = set_val["contact_user"].split(",")
					if @con_user.include?("#{current_user.user_id.to_i}")
						@flag=true
					end
				end
				# setting_option 3, just me activity only show to that person only
				if set_val["setting_option"]=="3"
					if user_id.to_i == current_user.user_id.to_i
						@flag=true
					end
				end
			end
		end #each loop end
	end
	# Default setting ,show to famtivity everyone
	if @created_setting == []
		@flag=true
	end
   end
   
   def find_activity_record(act_id)
     act = Activity.find_by_activity_id(act_id)
     return act.blank? ? nil : act
   end
   
   def find_parents(act_id)
    act = ActivityAttendDetail.where(:activity_id=>act_id)
    user_ids = act.map(&:user_id) if !act.blank?
    users = User.where("user_id IN (?)", user_ids) if !user_ids.blank?
    return users
   end
   
   def find_attendees(act_id,user_id)
	groups = ActivityAttendDetail.where(:activity_id=>act_id)
    participants = groups.collect(&:participant_id) if !groups.blank?
    participant_count = Participant.where("participant_id IN (?)", participants).count if !participants.blank?
    return participant_count.blank? ? 0 : participant_count
   end
   
   
   def providerDisType(type_id)
	   if type_id && !type_id.nil?
		   result = ProviderDiscountType.find(type_id)
		   return result
	   end
   end
   
   #add activity count - 
   def update_activity_count(activityid)
	 n_count = 0
               @activity = Activity.find_by_activity_id(activityid)
               if !@activity.nil? && @activity.present?
                       @date = Time.now.strftime("%Y-%m-%d")
                       @activity_count = ActivityCount.where("activity_id=? and date(inserted_date)=?",activityid,@date)  
		       @activity_total_count = ActivityTotalCount.where("activity_id=?",activityid).last
                       if !@activity_count.nil? && @activity_count.present? && @activity_count!='' && @activity_count.length > 0        
                               ex_count = @activity_count[0].activity_count.to_i
                               n_count = ex_count + 1
                               @activity_count[0].update_attributes(:activity_count => n_count,:modified_date => Time.now)                        
                       else
                               n_count = 1
                               @count_add = ActivityCount.create(:activity_id => activityid, :activity_count => n_count, :inserted_date=>Time.now,:modified_date=>Time.now, :view_count=>0, :share_count=>0)                        
                       end
		       if @activity_total_count  && @activity_total_count.present?
			       tot_count = @activity_total_count.activity_display_count+1
			       @activity_total_count.update_attributes(:activity_display_count => tot_count)  
		       end
               end
	return n_count
   end 
   
   def activity_valid_date(activityid)
       @discount_price=""
       @a=[]
       @discount_price = ActivityPrice.where("activity_id = ?", activityid) if !activityid.nil? && activityid.present?
            @discount_price.each do |dprice|
            @dis_price=dprice.activity_discount_price
            @dis_price.each do |dprice|
            @early_bird_date = dprice.discount_valid.strftime("%Y-%m-%d") if !dprice.nil? && !dprice.discount_valid.nil?
            @max_date = @early_bird_date if !@early_bird_date.nil? && @early_bird_date.present? && @early_bird_date!=""
            @cday = Time.now.strftime("%Y-%m-%d")
            if !@early_bird_date.nil? && @early_bird_date.present? && @early_bird_date >= @cday
            @a << "test"
            elsif !dprice.nil? && dprice.discount_valid.nil?
            @a << "test" 
            end
            end
        end
    return @a
   end 
	
   
end
