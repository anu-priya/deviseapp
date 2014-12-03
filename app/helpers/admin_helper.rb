module AdminHelper

#provider current status list of status for the subscription provider users
def provider_current_status(uid)
	@user = User.find_by_user_id(uid) if !uid.nil?
	if @user && @user!='' && !@user.nil? && @user.present?
		@tdy_date = Time.now.strftime("%Y-%m-%d")
		@p_tran = ProviderTransaction.find_by_sql("select id from provider_transactions where user_id='#{uid}' and (end_date > date('#{@tdy_date}')) order by id desc limit 1") if !uid.nil?
			if @p_tran && @p_tran!='' && @p_tran.present?
				#deactivate status
				if @user && @user!='' && !@user.nil? && @user.present? && @user.user_status == "deactivate"
					@cstatus = "Deactivated"
				else
					@cstatus = "Renewed"
				end
				  
			else
			  @cstatus = "Not-Renewed"
			end
	else #user else part
		@cstatus = "Deleted"
	end
	
	return @cstatus
end

#provider current status list of status for the subscription provider users
def email_report_provider_status(uid)
	@user = User.find_by_user_id(uid) if !uid.nil?
	if @user && @user!='' && !@user.nil? && @user.present?
		@tdy_date = Time.now.strftime("%Y-%m-%d")
		@p_tran = ProviderTransaction.find_by_sql("select id,start_date from provider_transactions where user_id='#{uid}' and (end_date > date('#{@tdy_date}')) order by id desc limit 1") if !uid.nil?
			if @p_tran && @p_tran!='' && @p_tran.present?
				#deactivate status
				if @user && @user!='' && !@user.nil? && @user.present? && @user.user_status == "deactivate"
					@cstatus = "Deactivated"
				else
					date_cal = (Date.today - @user.user_created_date.to_date).to_i
					if(date_cal) >= 30						
						@cstatus = "Renewed"
					else
						@cstatus = "New user"
					end
				end
				  
			else
			  @cstatus = "Not-Renewed"
			end
	else #user else part
		@cstatus = "Deleted"
	end
	
	return @cstatus
end

def email_status(uid,email)
	@user = User.find_by_user_id(uid) if !uid.nil?
	if !@user.blank?
		if email != @user.email_address
			status = "Yes, #{@user.email_address}"
		else
			status = "No"
		end
	else
		status = "Deleted"
	end
	return status
end


def user_active_act(uid)
	#list out the active activities
	 @active = Activity.find_by_sql("select a.activity_id from activities a left join school_representatives s on a.activity_id=s.activity_id where (user_id = #{uid}  or vendor_id = #{uid}) and lower(created_by)='provider' and lower(active_status)='active'") if !uid.nil? && uid!="" && uid.present?
	if !@active.nil? && @active.present? && @active!=""
	@active_count = @active.length
	else
	@active_count = 0
        end
        return @active_count
end

def user_inactive_act(uid)
	#list out the active activities
	  @inactive = Activity.find_by_sql("select a.activity_id from activities a left join school_representatives s on a.activity_id=s.activity_id where (user_id = #{uid}  or vendor_id = #{uid}) and lower(created_by)='provider' and lower(active_status)='inactive'") if !uid.nil? && uid!="" && uid.present?
	 #inactive activities
	if !@inactive.nil? && @inactive.present? && @inactive!=""
	@inactcount = @inactive.length
	else
	@inactcount = 0
	end
        return @inactcount
end

def user_expired_act(uid)
	#list out the active activities
	@expired =  Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id left join school_representatives school on act.activity_id = school.activity_id where act_sch.expiration_date < '#{Date.today.strftime("%Y-%m-%d")}' and (lower(act.active_status)='inactive' or lower(act.active_status)='active') and lower(act.created_by)='provider' and (act.user_id=#{uid} or school.vendor_id=#{uid}) and act.activity_id not in (select act.activity_id from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where lower(act.created_by)='provider' and act.user_id=#{uid} and act_sch.expiration_date >= '#{Date.today.strftime("%Y-%m-%d")}')") if !uid.nil? && uid!="" && uid.present?
	if !@expired.nil? && @expired.present? && @expired!=""
	@expired_count = @expired.length
	else
	@expired_count = 0
	end
        return @expired_count
end

def user_discount_dollar_act(uid)
	#list out user discount dollar
	@ddollar = Activity.find_by_sql("select distinct act.* from activities act left join activity_schedules act_sch on act.activity_id=act_sch.activity_id where act_sch.expiration_date >= '#{Date.today.strftime("%Y-%m-%d")}' and (act.price_type ='1' or act.price_type ='2') and cleaned=true and lower(act.active_status)='active' and lower(act.created_by)='provider' and (act.discount_eligible IS NOT NULL) and act.user_id=#{uid}") if !uid.nil? && uid!="" && uid.present?
	if !@ddollar.nil? && @ddollar.present? && @ddollar!=""
	@ddollar_count = @ddollar.length
	else
	@ddollar_count = 0
	end
        return @ddollar_count
end

def user_top_view_act(uid,sdate,edate)
 #Top view activities list
        if sdate && sdate!="" && !sdate.nil? && sdate.present? && edate && edate!="" && !edate.nil? && edate.present?
	    @week_start = "#{sdate}"
	    @week_end = "#{edate}"
	else
		#show last 30-days value
		@today = Date.today
		@week_start = (@today-30.days).strftime('%Y-%m-%d')
		@week_end = @today.strftime("%Y-%m-%d")
        #@week_start = Date.today.beginning_of_week.strftime("%Y-%m-%d")
	    #@week_end = Date.today.end_of_week.strftime("%Y-%m-%d")

	end
	#@top_view = Activity.find_by_sql("select activity_id from activity_counts where activity_id in(select activity_id from activities where user_id=#{uid}) and (date(inserted_date) between date('#{@week_start}') and date('#{@week_end}')) and view_count is not null order by view_count desc limit 3").uniq if !uid.nil? && uid!="" && uid.present?
		#@top_view = ActivityCount.find_by_sql("select distinct(ac.activity_id),a.activity_name,(select sum(activity_count) from activity_counts where activity_id=ac.activity_id and date(inserted_date) between '#{@week_start}' and '#{@week_end}') as activity_count from activity_counts ac 
		#left join activities a on ac.activity_id=a.activity_id where a.user_id=#{uid} and date(ac.inserted_date) between '#{@week_start}' and '#{@week_end}' order by activity_count desc limit 3")
@top_view =  ActivityCount.find_by_sql("select ac.activity_id, a.activity_name, sum(ac.activity_count) as activity_count from activity_counts ac left join activities a on ac.activity_id = a.activity_id where 
   a.user_id=#{uid} and date(ac.inserted_date) between '#{@week_start}' and '#{@week_end}' GROUP BY ac.activity_id, a.activity_name order by activity_count desc limit 3")
		#~ if @top_view && !@top_view.nil? && @top_view!="" && @top_view.present?
			#~ act_name = []
			#~ @top_view.each do |activity_id|
			#~ act = Activity.find_by_activity_id(activity_id.activity_id) if activity_id
			#~ act_name<<act.activity_name.capitalize if act && act.present? && !act.activity_name.nil?
		     #~ end
			#~ act_val = act_name.to_s.gsub('["','').gsub('"]','').gsub('"','') if act_name
		#~ else
	              #~ act_val = 0
	      #~ end
	        act_val = ''
	        if @top_view && !@top_view.nil? && @top_view!="" && @top_view.present?
			@top_view.each do |tact|
				if act_val!=''
					act_val = "#{act_val}, #{tact.activity_name}"
				else
					act_val = tact.activity_name
				end
			end
		else
	              act_val = 0
		end
		
	      return act_val
end
      
def user_top_shareview_act(uid,sdate,edate)
 #Top view activities list
        if sdate && sdate!="" && !sdate.nil? && sdate.present? && edate && edate!="" && !edate.nil? && edate.present?
	    @week_start = "#{sdate}"
	    @week_end = "#{edate}"
	else
        #show last 30-days value
		@today = Date.today
		@week_start = (@today-30.days).strftime('%Y-%m-%d')
		@week_end = @today.strftime("%Y-%m-%d")
        #@week_start = Date.today.beginning_of_week.strftime("%Y-%m-%d")
	    #@week_end = Date.today.end_of_week.strftime("%Y-%m-%d")
	end
	# @top_share = Activity.find_by_sql("select activity_id from activity_counts where activity_id in(select activity_id from activities where user_id=#{uid}) and (date(inserted_date) between date('#{@week_start}') and date('#{@week_end}')) and share_count is not null order by share_count desc limit 3").uniq if !uid.nil? && uid!="" && uid.present?
		
		#@top_share = ActivityCount.find_by_sql("select distinct(ac.activity_id), a.activity_name, (select sum(share_count) from activity_counts where activity_id=ac.activity_id and 
		#date(inserted_date) between '#{@week_start}' and '#{@week_end}') as share_count from activity_counts ac left join activities a on ac.activity_id=a.activity_id where 
		#a.user_id=#{uid} and date(ac.inserted_date) between '#{@week_start}' and '#{@week_end}' and share_count is not null order by share_count desc limit 3")
@top_share =  ActivityCount.find_by_sql("select ac.activity_id, a.activity_name, sum(ac.share_count) as share_count from activity_counts ac left join activities a on ac.activity_id = a.activity_id where 
   a.user_id=#{uid} and date(ac.inserted_date) between '#{@week_start}' and '#{@week_end}' GROUP BY ac.activity_id, a.activity_name order by share_count desc limit 3")
		#~ if @top_share && !@top_share.nil? && @top_share!="" && @top_share.present?
			#~ act_name = []
			#~ @top_share.each do |activity_id|
			#~ act = Activity.find_by_activity_id(activity_id.activity_id) if activity_id
			#~ act_name<<act.activity_name.capitalize if act && act.present? && !act.activity_name.nil?
		     #~ end
			#~ act_val = act_name.to_s.gsub('["','').gsub('"]','').gsub('"','') if act_name
		#~ else
	              #~ act_val = 0
	      #~ end
	      
	      act_val = ''
	        if @top_share && !@top_share.nil? && @top_share!="" && @top_share.present?
			@top_share.each do |tact|
				if act_val!=''
					act_val = "#{act_val}, #{tact.activity_name}"
				else
					act_val = tact.activity_name
				end
			end
		else
	              act_val = 0
	      end
	      
	      return act_val
end  

def user_website_count(uid,sdate,edate)
 #user_website_count list
        if sdate && sdate!="" && !sdate.nil? && sdate.present? && edate && edate!="" && !edate.nil? && edate.present?
	    @week_start = "#{sdate}"
	    @week_end = "#{edate}"
	else
        #show last 30-days value
		@today = Date.today
		@week_start = (@today-30.days).strftime('%Y-%m-%d')
		@week_end = @today.strftime("%Y-%m-%d")
	end
	@web = ProviderWebsiteTrack.find_by_sql("select * from provider_website_tracks where user_id=#{uid} and (date(inserted_date) between date('#{@week_start}') and date('#{@week_end}'))")
		if @web && !@web.nil? && @web!="" && @web.present?
			web_cnt = []
			@web.each do |web|
				if !web.activity_website_count.nil? && !web.provider_website_count.nil?
				 web_cnt<<web.activity_website_count + web.provider_website_count
			    elsif !web.activity_website_count.nil?
			     web_cnt<< web.activity_website_count
			    elsif !web.provider_website_count.nil?
			     web_cnt<< web.provider_website_count
			    end
		     end
		else
	             web_cnt = 0
	    end
	    return web_cnt
end  

      
def user_tot_count_list(uid,sdate,edate)
	#Total views count list
	@tot_view_act=0
	if sdate && sdate!="" && !sdate.nil? && sdate.present? && edate && edate!="" && !edate.nil? && edate.present?
	    @week_start = "#{sdate}"
	    @week_end = "#{edate}"
	else
		#show last 30-days value
		@today = Date.today
		@week_start = (@today-30.days).strftime('%Y-%m-%d')
		@week_end = @today.strftime("%Y-%m-%d")
        #@week_start = Date.today.beginning_of_week.strftime("%Y-%m-%d")
	    #@week_end = Date.today.end_of_week.strftime("%Y-%m-%d")
	end
	@total_views = Activity.find_by_sql("select sum(view_count) as view_count from activity_counts where activity_id in(select activity_id from activities where user_id=#{uid}) and (date(inserted_date) between date('#{@week_start}') and date('#{@week_end}')) and view_count is not null") if !uid.nil? && uid!="" && uid.present?
	     if @total_views && @total_views!=[] && !@total_views.nil? && @total_views!="" && @total_views.present?
			@total_views && @total_views.present? && @total_views.each do |view_t| 
			if view_t.view_count!="" && view_t.view_count!=nil && view_t.view_count.present?
			@tot_view_act = view_t.view_count
			else
			@tot_view_act = 0
			end
		end
	    else
		@tot_view_act=0
	    end
	return @tot_view_act
end

def user_tot_viewscount_list(uid,sdate,edate)
	#Total views count list
	@tot_view_act=0
	if sdate && sdate!="" && !sdate.nil? && sdate.present? && edate && edate!="" && !edate.nil? && edate.present?
	    @week_start = "#{sdate}"
	    @week_end = "#{edate}"
	else
		#show last 30-days value
		@today = Date.today
		@week_start = (@today-30.days).strftime('%Y-%m-%d')
		@week_end = @today.strftime("%Y-%m-%d")
        #@week_start = Date.today.beginning_of_week.strftime("%Y-%m-%d")
	    #@week_end = Date.today.end_of_week.strftime("%Y-%m-%d")
	end
	@total_views = Activity.find_by_sql("select sum(activity_count) as activity_count from activity_counts where activity_id in(select activity_id from activities where user_id=#{uid}) and (date(inserted_date) between date('#{@week_start}') and date('#{@week_end}')) and activity_count is not null") if !uid.nil? && uid!="" && uid.present?
	     if @total_views && @total_views!=[] && !@total_views.nil? && @total_views!="" && @total_views.present?
			@total_views && @total_views.present? && @total_views.each do |view_t| 
			if view_t.activity_count!="" && view_t.activity_count!=nil && view_t.activity_count.present?
			@tot_view_act = view_t.activity_count
			else
			@tot_view_act = 0
			end
		end
	    else
		@tot_view_act=0
	    end
	return @tot_view_act
end

end
