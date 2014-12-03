module LandingHelper
  require 'rss'
  # exprire activity removed
  def get_upcoming_activities(before_check)
    before_check.each do |af|
      if af.class.to_s == 'MessageThread'
        @all_act << af
      else
        newact=ActivitySchedule.where("activity_id = ?",af.activity_id).last
        @check_newact=newact.expiration_date>=Date.today  if !newact.nil? && !newact.expiration_date.nil?
        @all_act << newact if !newact.nil? && !@check_newact.nil? && @check_newact.present?
      end
    end if !before_check.nil? && before_check.present? && before_check.length > 0
        
    @all_act.each do |al|
      if al.class.to_s == 'MessageThread'
        @act_free << al
      elsif !al.nil? && al.activity_id!=''
        id=al.activity_id
        act=Activity.where("activity_id = ?",id).last if id!=''
        @act_free << act if !act.nil? && act.present?
      end
    end if !@all_act.nil? && @all_act.present? && @all_act.length > 0
    return @act_free if !@act_free.nil?
  end

  #get the provider transaction information for buy now and getinfo button by rajkumar
  def provider_signup_amount(auid)
    #activity attend details limit checked for the monthly basis from the provider transaction table by Rajkumar 2014-1-24
    @tdy_date = Time.now.strftime("%Y-%m-%d")
    @p_tran = ProviderTransaction.find_by_sql("select * from provider_transactions where user_id='#{auid}' and (end_date >= date('#{@tdy_date}')) order by id desc limit 1") if !auid.nil?
    @start_date = @p_tran[0].start_date.strftime("%Y-%m-%d") if !@p_tran.nil? && !@p_tran[0].nil? && !@p_tran[0].start_date.nil? && @p_tran[0].start_date.present?
    @end_date = @p_tran[0].grace_period_date.strftime("%Y-%m-%d") if !@p_tran.nil? && !@p_tran[0].nil? && !@p_tran[0].grace_period_date.nil? && @p_tran[0].grace_period_date.present?
    @actattend = ActivityAttendDetail.find_by_sql("select attend_id from activity_attend_details where activity_id in (select activity_id from activities where user_id=#{auid}) and (inserted_date between date('#{@start_date}') and date('#{@end_date}'))") if !auid.nil? && !@start_date.nil? && !@end_date.nil?
    @usr=User.find(auid) if !auid.nil?
    return @usr,@actattend
  end

  #provider transaction amount checked here for the user buy now button.
  def provider_buy_amount(auid)
    @tdy_dte = Time.now.strftime("%Y-%m-%d")
    ProviderTransaction.find_by_sql("select * from provider_transactions where user_id='#{auid}' and (end_date >= date('#{@tdy_dte}')) order by id desc limit 1") if !auid.nil?
  end

  def provider_renew_limit(auid)
    @tdy_dte = Time.now.strftime("%Y-%m-%d")
    ProviderTransaction.find_by_sql("select * from provider_transactions where user_id=#{auid} and end_date >= date('#{@tdy_dte}') order by id desc limit 1")
  end

  #get the activity details for provider side
  def get_activity_provider(act_id)
    #~ activ = Activity.where("activity_id=?",act_id).last
    act_price = ""
    act_price= ActivityPrice.where("activity_id = ?", act_id) if !act_id.nil? && act_id.present?
    return act_price if !act_price.nil? && act_price!="" && act_price.present?
  end

  #get the activity details for not provider side
  def get_activity(act_id)
    #~ activ = Activity.where("activity_id=?",act_id).last
    act_price = ""
    act_price =  ActivityPrice.joins(:activity_schedule).where("activity_prices.activity_id = ? AND expiration_date >= ?",act_id,Date.today )if !act_id.nil? && act_id.present?
    #act_price= ActivityPrice.where("activity_id = ?", act_id) if !act_id.nil? && act_id.present?
    return act_price if !act_price.nil? && act_price!="" && act_price.present?
  end
  
  def get_embed_data
    @activity= Activity.find_by_sql("select * from activities where user_id=#{current_user.user_id} and cleaned=true and lower(active_status)='active' and lower(created_by)='provider' order by activity_id desc limit 200") if !current_user.nil? && current_user.present?
    @act_id = @activity.map(&:activity_id) if @activity
    return @act_id
  end
  
  
  #get the user current balance by rajkumar
  def get_balance(user_id)
    @cdt_lst = UserCredit.where("user_id=?",user_id)
    @dbt_lst = UserDebit.where("user_id=?",user_id)
    @t_cred_amt =  (!@cdt_lst.nil?) ? @cdt_lst.sum(&:credit_amount) : 0
    @t_debit_amt = (!@dbt_lst.nil?) ? @dbt_lst.sum(&:debited_amount) : 0
    @crt_balance = (@t_cred_amt-@t_debit_amt)
    return @crt_balance if !@crt_balance.nil? && @crt_balance.present?
  end
  
  #get the activity schedule values
  def activity_schedule(act_id)
    activ = ActivitySchedule.where("activity_id=?",act_id).last
  end
  
  #get the activity id
  def find_activity(act_id)
    activ = Activity.where("activity_id=?",act_id).last
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

  def selluser_list #In Famrivity user report page
    #get the sell users list for provider
    @sell_usr = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='sell' and account_active_status=true and lower(manage_plan) is null and is_partner=false").map(&:user_id).uniq
    if !@sell_usr.nil? && @sell_usr!="" && @sell_usr.present?
      @sel_tot = @sell_usr
    else
      @sel_tot = 0
    end
    return @sel_tot
  end #selluserlist end
  
  def selluser_list_withdate(sdate,edate) #In Famrivity user report page
    #get the sell users list for provider
    @sell_usr = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='sell' and account_active_status=true and lower(manage_plan) is null and is_partner=false and date(user_created_date) between date('#{sdate}') and date('#{edate}')").map(&:user_id).uniq
    if !@sell_usr.nil? && @sell_usr!="" && @sell_usr.present?
      @sel_tot = @sell_usr
    else
      @sel_tot = 0
    end
    return @sel_tot
  end #selluserlist end
  
  
  def market_and_sell_users #In Famrivity user report page
    #get the sell users list based on the market and sell provider
    @mkt_sell_users = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='sell' and lower(manage_plan)='market_sell' and account_active_status=true and is_partner=false").map(&:user_id).uniq
    if !@mkt_sell_users.nil? && @mkt_sell_users!="" && @mkt_sell_users.present?
      @mkt_sell_users_tot = @mkt_sell_users
    else
      @mkt_sell_users_tot = 0
    end
    return @mkt_sell_users_tot
  end #selluserlist end
  
  def market_and_sell_users_withdate(sdate,edate) #In Famrivity user report page
    #get the sell users list based on the market and sell provider
    @mkt_sell_users = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='sell' and lower(manage_plan)='market_sell' and account_active_status=true and is_partner=false and date(user_created_date) between date('#{sdate}') and date('#{edate}')").map(&:user_id).uniq
    if !@mkt_sell_users.nil? && @mkt_sell_users!="" && @mkt_sell_users.present?
      @mkt_sell_users_tot = @mkt_sell_users
    else
      @mkt_sell_users_tot = 0
    end
    return @mkt_sell_users_tot
  end #selluserlist end
  
  def marketsell_and_manage_users #In Famrivity user report page
    #get the sell users list based on the market and sell provider
    @mktsell_mge_users = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='sell' and lower(manage_plan)='market_sell_manage' and is_partner=false and account_active_status=true").map(&:user_id).uniq
    if !@mktsell_mge_users.nil? && @mktsell_mge_users!="" && @mktsell_mge_users.present?
      @mktsell_mge_users_tot = @mktsell_mge_users
    else
      @mktsell_mge_users_tot = 0
    end
    return @mktsell_mge_users_tot
  end #selluserlist end
  
  def marketsell_and_manage_users_withdate(sdate,edate) #In Famrivity user report page
    #get the sell users list based on the market and sell provider
    @mktsell_mge_users = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='sell' and lower(manage_plan)='market_sell_manage' and is_partner=false and account_active_status=true and date(user_created_date) between date('#{sdate}') and date('#{edate}')").map(&:user_id).uniq
    if !@mktsell_mge_users.nil? && @mktsell_mge_users!="" && @mktsell_mge_users.present?
      @mktsell_mge_users_tot = @mktsell_mge_users
    else
      @mktsell_mge_users_tot = 0
    end
    return @mktsell_mge_users_tot
  end #selluserlist end
  
  def marketsell_manageplus_users #In Famrivity user report page
    #get the sell users list based on the market and sell provider
    @mktsell_mgeplus_users = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='sell' and is_partner=false and lower(manage_plan)='market_sell_manage_plus' and account_active_status=true").map(&:user_id).uniq
    if !@mktsell_mgeplus_users.nil? && @mktsell_mgeplus_users!="" && @mktsell_mgeplus_users.present?
      @mktsell_mgeplus_users_tot = @mktsell_mgeplus_users
    else
      @mktsell_mgeplus_users_tot = 0
    end
    return @mktsell_mgeplus_users_tot
  end #selluserlist end
  
  def marketsell_manageplus_users_withdate(sdate,edate) #In Famrivity user report page
    #get the sell users list based on the market and sell provider
    @mktsell_mgeplus_users = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='sell' and is_partner=false and lower(manage_plan)='market_sell_manage_plus' and account_active_status=true and date(user_created_date) between date('#{sdate}') and date('#{edate}')").map(&:user_id).uniq
    if !@mktsell_mgeplus_users.nil? && @mktsell_mgeplus_users!="" && @mktsell_mgeplus_users.present?
      @mktsell_mgeplus_users_tot = @mktsell_mgeplus_users
    else
      @mktsell_mgeplus_users_tot = 0
    end
    return @mktsell_mgeplus_users_tot
  end #selluserlist end
  
  def curator_added #In Famrivity user report page
    #get the  users list for curator
    @curt_add = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='curator' and account_active_status=true").map(&:user_id).uniq
    if !@curt_add.nil? && @curt_add!="" && @curt_add.present?
      @curt_add_tot = @curt_add
    else
      @curt_add_tot = 0
    end
    return @curt_add_tot
  end #selluserlist end
  
  def curator_added_withdate(sdate,edate) #In Famrivity user report page
    #get the  users list for curator
    @curt_add = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='curator' and account_active_status=true and date(user_created_date) between date('#{sdate}') and date('#{edate}')").map(&:user_id).uniq
    if !@curt_add.nil? && @curt_add!="" && @curt_add.present?
      @curt_add_tot = @curt_add
    else
      @curt_add_tot = 0
    end
    return @curt_add_tot
  end #selluserlist end
  
  def partner_added #In Famrivity user report page
    #get the  users list for curator
    @curt_add = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='sell' and account_active_status=true and is_partner=true").map(&:user_id).uniq
    if !@curt_add.nil? && @curt_add!="" && @curt_add.present?
      @curt_add_tot = @curt_add
    else
      @curt_add_tot = 0
    end
    return @curt_add_tot
  end #selluserlist end
  
  def partner_added_withdate(sdate,edate) #In Famrivity user report page
    #get the  users list for curator
    @curt_add = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='sell' and is_partner=true and account_active_status=true and date(user_created_date) between date('#{sdate}') and date('#{edate}')").map(&:user_id).uniq
    if !@curt_add.nil? && @curt_add!="" && @curt_add.present?
      @curt_add_tot = @curt_add
    else
      @curt_add_tot = 0
    end
    return @curt_add_tot
  end #selluserlist end
  
  def spon_pro_list #In Famrivity user report page
    #get the sell users list for provider
    @spon_usr = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='sponsor' and account_active_status=true and is_partner=false").map(&:user_id).uniq
    if !@spon_usr.nil? && @spon_usr!="" && @spon_usr.present?
      @spon_usr_tot = @spon_usr
    else
      @spon_usr_tot = 0
    end
    return @spon_usr_tot
  end #selluserlist end
  
  def spon_pro_list_withdate(sdate,edate) #In Famrivity user report page
    #get the sell users list for provider
    @spon_usr = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='sponsor' and account_active_status=true and date(user_created_date) between date('#{sdate}') and date('#{edate}')").map(&:user_id).uniq
    if !@spon_usr.nil? && @spon_usr!="" && @spon_usr.present?
      @spon_usr_tot = @spon_usr
    else
      @spon_usr_tot = 0
    end
    return @spon_usr_tot
  end #selluserlist end
    
  def admin_user_lst #In Famrivity user report page
    #get the sell users list for admin
    @ad_usr = User.find_by_sql("select distinct user_id from users where lower(user_type)='a' and account_active_status=true").map(&:user_id).uniq
    if !@ad_usr.nil? && @ad_usr!="" && @ad_usr.present?
      @ad_usr_tot = @ad_usr
    else
      @ad_usr_tot = 0
    end
    return @ad_usr_tot
  end #selluserlist end
  
  def prouser_free #In Famrivity user report page
    #get the free users list for provider
    @free_usr = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='free' and account_active_status=true and is_partner=false").map(&:user_id).uniq
    if !@free_usr.nil? && @free_usr!="" && @free_usr.present?
      @free_tot = @free_usr
    else
      @free_tot = 0
    end
    return @free_tot
  end #selluserlist end
  
  def prouser_free_withdate(sdate,edate) #In Famrivity user report page
    #get the free users list for provider
    @free_usr = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and lower(user_plan)='free' and account_active_status=true and date(user_created_date) between date('#{sdate}') and date('#{edate}')").map(&:user_id).uniq
    if !@free_usr.nil? && @free_usr!="" && @free_usr.present?
      @free_tot = @free_usr
    else
      @free_tot = 0
    end
    return @free_tot
  end #selluserlist end

  def facebook_parent
  	#get the facebook parent list
    @fb_parent=User.find_by_sql(["select distinct user_id from users where lower(user_type)='u' and account_active_status='true' and fb_id is not null"]).map(&:user_id).uniq
    if !@fb_parent.nil? && @fb_parent!="" && @fb_parent.present?
   	  @fb_parent_total = @fb_parent
    else
      @fb_parent_total = 0
    end
    return @fb_parent_total
  end
   
  #face book parent with date
  def facebook_parent_withdate(sdate,edate)
  	#get the facebook parent list
    @fb_parent=User.find_by_sql(["select distinct user_id from users where lower(user_type)='u' and account_active_status='true' and fb_id is not null and date(user_created_date) between date('#{sdate}') and date('#{edate}')"]).map(&:user_id).uniq
    if !@fb_parent.nil? && @fb_parent!="" && @fb_parent.present?
   	  @fb_parent_total = @fb_parent
    else
      @fb_parent_total = 0
    end
    return @fb_parent_total
  end
  
  def facebook_provider
  	#get the facebook provider list
    @fb_provider=User.find_by_sql(["SELECT * FROM Users Where lower(user_type)='p' and account_active_status='true' and fb_id is not null"])
    if !@fb_provider.nil? && @fb_provider!="" && @fb_provider.present?
   	  @fb_provider_total = @fb_provider.length
    else
      @fb_provider_total = 0
    end
    return @fb_provider_total
  end

  def pro_inactive #In Famrivity user report page
    #get the inactive users list for provider
    @pro_inact = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and account_active_status=false").map(&:user_id).uniq
    if !@pro_inact.nil? && @pro_inact!="" && @pro_inact.present?
      @pro_inact_tot = @pro_inact
    else
      @pro_inact_tot = 0
    end
    return @pro_inact_tot
  end #selluserlist end
  
  def pro_inactive_withdate(sdate,edate) #In Famrivity user report page
    #get the inactive users list for provider
    @pro_inact = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and account_active_status=false and date(user_created_date) between date('#{sdate}') and date('#{edate}')").map(&:user_id).uniq
    if !@pro_inact.nil? && @pro_inact!="" && @pro_inact.present?
      @pro_inact_tot = @pro_inact
    else
      @pro_inact_tot = 0
    end
    return @pro_inact_tot
  end #selluserlist end
  
  def parent_free #In Famrivity user report page
    #get the free users list for provider
    @prt_free = User.find_by_sql("select distinct user_id from users where lower(user_type)='u' and lower(user_plan)='free' and account_active_status=true").map(&:user_id).uniq
    if !@prt_free.nil? && @prt_free!="" && @prt_free.present?
      @prt_free_tot = @prt_free.length
    else
      @prt_free_tot = 0
    end
    return @prt_free_tot
  end #selluserlist end
  
  def parent_inactive #In Famrivity user report page
    #get the free users list for provider
    @prt_inact = User.find_by_sql("select distinct user_id from users where lower(user_type)='u' and account_active_status=false").map(&:user_id).uniq
    if !@prt_inact.nil? && @prt_inact!="" && @prt_inact.present?
      @prt_inact_tot = @prt_inact
    else
      @prt_inact_tot = 0
    end
    return @prt_inact_tot
  end #selluserlist end
  
  def parent_inactive_withdate(sdate,edate) #In Famrivity user report page
    #get the free users list for provider
    @prt_inact = User.find_by_sql("select distinct user_id from users where lower(user_type)='u' and account_active_status=false and date(user_created_date) between date('#{sdate}') and date('#{edate}')").map(&:user_id).uniq
    if !@prt_inact.nil? && @prt_inact!="" && @prt_inact.present?
      @prt_inact_tot = @prt_inact
    else
      @prt_inact_tot = 0
    end
    return @prt_inact_tot
  end #selluserlist end
  
  def parent_active_usr #In Famrivity user report page
    #get the users list for parent
    @prt_act = User.find_by_sql("select distinct user_id from users where lower(user_type)='u' and account_active_status=true").map(&:user_id).uniq
    if !@prt_act.nil? && @prt_act!="" && @prt_act.present?
      @prt_act_tot = @prt_act
    else
      @prt_act_tot = 0
    end
    return @prt_act_tot
  end #selluserlist end
  
  #parent active user with dates
  def parent_active_usr_withdate(sdate,edate) #In Famrivity user report page
    #get the users list for parent
    @prt_act = User.find_by_sql("select distinct user_id from users where lower(user_type)='u' and account_active_status=true and date(user_created_date) between date('#{sdate}') and date('#{edate}')").map(&:user_id).uniq
    if !@prt_act.nil? && @prt_act!="" && @prt_act.present?
      @prt_act_tot = @prt_act
    else
      @prt_act_tot = 0
    end
    return @prt_act_tot
  end #selluserlist end
  
  def provider_iwave #In Famrivity user report page
    #get the free users list for provider  iwaves
    @pro_iw_usr = User.find_by_sql("select distinct user_id from users where lower(user_type)='p' and account_active_status=true and email_address like '%@i-waves%'").map(&:user_id).uniq
    if !@pro_iw_usr.nil? && @pro_iw_usr!="" && @pro_iw_usr.present?
      @pro_iw_usr_tot = @pro_iw_usr.length
    else
      @pro_iw_usr_tot = 0
    end
    return @pro_iw_usr_tot
  end #selluserlist end
  
  def parent_iwave #In Famrivity user report page
    #get the free users list for provider  iwaves
    @par_iw_usr = User.find_by_sql("select distinct user_id from users where lower(user_type)='u' and account_active_status=true and email_address like '%@i-waves%'").map(&:user_id).uniq
    if !@par_iw_usr.nil? && @par_iw_usr!="" && @par_iw_usr.present?
      @par_iw_usr_tot = @par_iw_usr.length
    else
      @par_iw_usr_tot = 0
    end
    return @par_iw_usr_tot
  end #selluserlist end
  
  def user_invited_by_all #In Famrivity general report page
    #get the users invited by all
    @user_invited = ContactUser.find_by_sql("select c.contact_email from contact_users c left join users u on c.user_id=u.user_id where u.account_active_status=true and c.contact_email is not null and c.invite_status is true and c.profile_id is null").map(&:contact_email).uniq
    @user_invited_fb = ContactUser.find_by_sql("select c.contact_email,c.profile_id from contact_users c left join users u on c.user_id=u.user_id where u.account_active_status=true and c.profile_id is not null and c.invite_status is true and c.contact_type='facebook'").map(&:profile_id).uniq
    if (!@user_invited.blank?) || (!@user_invited_fb.blank?)
      @user_tot = @user_invited.length + @user_invited_fb.length
    else
      @user_tot = 0
    end
    return @user_tot
  end
  
  def user_invited_by_all_withdate(sdate,edate)
    #get the users invited by all
    @u_invited = ContactUser.find_by_sql("select c.contact_email from contact_users c left join users u on c.user_id=u.user_id where u.account_active_status=true and c.contact_email is not null and c.invite_status is true and c.profile_id is null and date(modified_date) between date('#{sdate}') and date('#{edate}')").map(&:contact_email).uniq
    @u_invited_fb = ContactUser.find_by_sql("select c.contact_email,c.profile_id from contact_users c left join users u on c.user_id=u.user_id where u.account_active_status=true and c.profile_id is not null and c.invite_status is true and c.contact_type='facebook' and date(modified_date) between date('#{sdate}') and date('#{edate}')").map(&:profile_id).uniq
    if (!@u_invited.blank?) || (!@u_invited_fb.blank?)
      @user_tot = @u_invited.length + @u_invited_fb.length
    else
      @user_tot = 0
    end
    return @user_tot
  end

  def user_invited_by_parent #In Famrivity general report page
    #get the users invited by all
    @parent_invited = ContactUser.find_by_sql("select c.contact_email from contact_users c left join users u on c.user_id=u.user_id where lower(u.user_type)='u' and u.account_active_status=true and c.contact_email is not null and c.invite_status is true and c.profile_id is null").map(&:contact_email).uniq
    @parent_invited_fb = ContactUser.find_by_sql("select c.contact_email,c.profile_id from contact_users c left join users u on c.user_id=u.user_id where lower(u.user_type)='u' and u.account_active_status=true and c.profile_id is not null and c.invite_status is true and c.contact_type='facebook'").map(&:profile_id).uniq
    if (!@parent_invited.blank?) || (!@parent_invited_fb.blank?)
      @parent_tot = @parent_invited.length + @parent_invited_fb.length
    else
      @parent_tot = 0
    end
    return @parent_tot
  end

  def user_invited_by_parent_withdate(sdate,edate)
    #get the users invited by all
    @p_invited = ContactUser.find_by_sql("select c.contact_email from contact_users c left join users u on c.user_id=u.user_id where lower(u.user_type)='u' and u.account_active_status=true and c.contact_email is not null and c.invite_status is true and c.profile_id is null and date(modified_date) between date('#{sdate}') and date('#{edate}')").map(&:contact_email).uniq
    @p_invited_fb = ContactUser.find_by_sql("select c.contact_email,c.profile_id from contact_users c left join users u on c.user_id=u.user_id where lower(u.user_type)='u' and u.account_active_status=true and c.profile_id is not null and c.invite_status is true and c.contact_type='facebook' and date(modified_date) between date('#{sdate}') and date('#{edate}')").map(&:profile_id).uniq
    if (!@p_invited.blank?) || (!@p_invited_fb.blank?)
      @user_tot = @p_invited.length + @p_invited_fb.length
    else
      @user_tot = 0
    end
    return @user_tot
  end

  def parent_percent_calc
    @total_user = User.find_by_sql("select distinct user_id from users where lower(user_type)='u' and account_active_status=true").map(&:user_id).uniq
    @total_nonmember = ContactUser.find_by_sql("select c.contact_email from contact_users c left join users u on c.user_id=u.user_id where lower(u.user_type)='u' and u.account_active_status=true and c.contact_email is not null and c.invite_status is true and c.profile_id is null and lower(c.contact_user_type) ='non_member'").map(&:contact_email).uniq
    if (!@total_user.blank?) || (!@total_nonmember.blank?)
      total_count = @total_user.length + @total_nonmember.length
    end
    @parent_per_total = ((user_invited_by_parent.to_f / total_count.to_f).to_f) * 100
    return @parent_per_total.to_f.round(2)
  end
 
  def parent_percent_calc_withdate(sdate,edate)
    @total_user = User.find_by_sql("select distinct user_id from users where lower(user_type)='u' and account_active_status=true").map(&:user_id).uniq
    @total_nonmember = ContactUser.find_by_sql("select c.contact_email from contact_users c left join users u on c.user_id=u.user_id where lower(u.user_type)='u' and u.account_active_status=true and c.contact_email is not null and c.invite_status is true and c.profile_id is null and lower(c.contact_user_type) ='non_member'").map(&:contact_email).uniq
    if (!@total_user.blank?) || (!@total_nonmember.blank?)
      total_count = @total_user.length + @total_nonmember.length
    end
    @parent_per_total = ((user_invited_by_parent_withdate(sdate,edate).to_f / total_count.to_f).to_f) * 100
    return @parent_per_total.to_f.round(2)
  end

  def user_percent_calc
    @total_user = User.find_by_sql("select distinct user_id from users where account_active_status=true").map(&:user_id).uniq
    @total_nonmember = ContactUser.find_by_sql("select c.contact_email from contact_users c left join users u on c.user_id=u.user_id where u.account_active_status=true and c.contact_email is not null and c.invite_status is true and c.profile_id is null and lower(c.contact_user_type) ='non_member'").map(&:contact_email).uniq
    if (!@total_user.blank?) || (!@total_nonmember.blank?)
      total_count = @total_user.length + @total_nonmember.length
    end
    @user_per_total = ((user_invited_by_all.to_f / total_count.to_f).to_f) * 100
    return @user_per_total.to_f.round(2)
  end

  def user_percent_calc_withdate(sdate,edate)
    @total_user = User.find_by_sql("select distinct user_id from users where account_active_status=true").map(&:user_id).uniq
    #~ total_count = @total_user.blank? ? 0 : @total_user.length
    @total_nonmember = ContactUser.find_by_sql("select c.contact_email from contact_users c left join users u on c.user_id=u.user_id where u.account_active_status=true and c.contact_email is not null and c.invite_status is true and c.profile_id is null and lower(c.contact_user_type) ='non_member'").map(&:contact_email).uniq
    if (!@total_user.blank?) || (!@total_nonmember.blank?)
      total_count = @total_user.length + @total_nonmember.length
    end
    @user_per_total = ((user_invited_by_all_withdate(sdate,edate).to_f / total_count.to_f).to_f) * 100
    return @user_per_total.to_f.round(2)
  end

  
  #to form the url for seo search  city
  def url_format(val,url)
    if !val.nil? && !url.nil?
      test = url
      test_url = (test.concat("/"+val.downcase.gsub(/\s/,'-').gsub(',','')));
      return test_url
    end
  end
  
  def url_format_slug(city,val)
    if !city.nil? && !val.nil?
      #test = city 
      state = check_for_state_value(city) #get the states values
      test_url = ("/"+city.downcase.gsub(/\s/,'-')+state+"/"+val.downcase)
      return test_url
    end
  end

  def url_format_subcat_slug(city,cat_name,val)
    if !city.nil? && !cat_name.nil? && !val.nil?
      state = check_for_state_value(city)#get the states values
      subcategory_url = ("/"+city.downcase.gsub(/\s/,'-')+state+"/"+cat_name.downcase+"/"+val.downcase)
      return subcategory_url
    end
  end
  #to form the url for seo search  city
  def url_format_city(val,url)
    if !val.nil? && !url.nil?
      test = url
      #~ @state = State.find_by_state_id(1)
      #~ if @state && @state!="" && @state.state_name == "California"
      state = "-ca" #get the states values
      #~ end
      test_url = (val.downcase.gsub(/\s/,'-')+state)
      return test_url
    end
  end

  #to form the url for seo search  city
  def url_format_city_cate(val,url)
    if !val.nil? && !url.nil?
      #~ test = url
      test_url = url
      return test_url
    end
  end

  #to display min / max age range
  def age_range_cal(min,max)
    check_month1 = ''
    check_month2 = ''
    if min=="All" && max=="All"
      @return_value = 'All'
    elsif min=="Adults" && max=="Adults"
      @return_value = 'Adults'
    else
      if min=="Adults" || min=="All"
        min_age = min
        age_val_min = ''
        check_month1 = false
      else
        if min.to_f < 1
          min_age=(min.to_f*12).round
          age_val_min = min_age.to_i
          min_age = "#{min_age}M"
          check_month1 = true
        else
          age_val_min = min.to_i
          min_age = "#{min}Y"
          check_month1 = false
        end
      end
		
      if max=="Adults" || max=="All"
        max_age = max
        age_val_max = ''
        check_month2 = false
      else
        if max.to_f < 1
          max_age=(max.to_f*12).round
          age_val_max = max_age.to_i
          max_age = "#{max_age}M"
          check_month2 = true
        else
          age_val_max = max.to_i
          max_age = "#{max}Y"
          check_month2 = false
        end
      end
		
      if(check_month1 && check_month2)
        #Age Range Calculations for month and month
        if(age_val_min.kind_of?(Integer) && age_val_min.to_i == age_val_max.to_i)
          @return_value1 = (age_val_min.to_i == 0) ? "Birth" : "#{age_val_min.to_i} #{age_val_min.to_i > 1 ? 'Months' : 'Month'}"
        else
          check_month1 = ''
          check_month2 = ''
          @return_value1 = "#{min_age} - #{max_age}"
        end
      elsif(!check_month1 && !check_month2)
        #Age Range Calculations for year and year combinations
        if(age_val_min.kind_of?(Integer) && age_val_min.to_i == age_val_max.to_i)
          @return_value1 = "#{age_val_min.to_i} #{(age_val_min.to_i > 1) ? 'Years' : 'Year'}"
        else
          check_month1 = ''
          check_month2 = ''
          @return_value1 = "#{min_age} - #{max_age}"
        end
      else
        check_month1 = ''
        check_month2 = ''
        @return_value1 = "#{min_age} - #{max_age}"
      end
      @return_value = @return_value1
      #~ else
      #~ if min.to_f < 1
			#~ min_age=(min.to_f*12).round
			#~ min_age = "#{min_age}M"
			
      #~ else
			#~ min_age = "#{min}Y"
      #~ end
      #~ if max.to_f < 1
			#~ max_age=(max.to_f*12).round
			#~ max_age = "#{max_age}M"
      #~ else
			#~ max_age = max
			#~ max_age = "#{max}Y"
      #~ end
      #~ return "#{min_age}-#{max_age}"
    end
    return @return_value
  end

  #buy now get info button logic
  def get_purchase_status(activityid,userid)
    @str =''
		if !activityid.nil? && activityid!=''
			@userid = userid
			@activity = Activity.fetch(activityid)	
			#price - advance , net and free goes here
			@act_user = User.fetch(@activity.user_id)
			@today = Time.now.strftime("%Y-%m-%d")
			
			if !@activity.nil?			
				#~ @schedule = ActivitySchedule.find_by_sql("select distinct(activity_id) from activity_schedules where activity_id=#{activityid} and date(expiration_date) >= '#{@today}'")			
				@schedule = @activity.fetch_activity_schedule.where("expiration_date >= ?",Date.today) if @activity && @activity.present?	
				
				if !@activity.created_by.nil? && @activity.created_by!='' && @activity.created_by.downcase == 'provider'
					
					if !@act_user.nil?	
						if @act_user.user_flag == false
							@str = 'curator'
						elsif @act_user.user_flag == true	
							if !@activity.nil? && !@activity.purchase_url.nil? && @activity.purchase_url!='' && @activity.purchase_url.present?
								@str = 'buy now'
							else
								if @activity.price_type == '4'
									@str = 'get info'									
								elsif @activity.price_type == '3'
									if @act_user.user_plan.downcase == 'free'  && (@act_user.manage_plan.nil? || @act_user.manage_plan.empty?)
										@str = 'get info'
									else
										if !@schedule.nil? && @schedule.present? && @schedule.length > 0
											@str = 'attend'
										else										
											@str = 'get info'																				
										end
									end
								else		
									@pro_trans = ProviderTransaction.find_by_sql("select * from provider_transactions where user_id=#{@act_user.user_id} and date(grace_period_date) >= '#{@today}' order by id desc limit 1")
									
									if !@activity.schedule_mode.nil? && @activity.schedule_mode!='' && (@activity.schedule_mode.downcase == 'by appointment' || @activity.schedule_mode.downcase == 'any where' || @activity.schedule_mode.downcase == 'any time')
										#schedule - anytime, any where and by appoinment goes here
										if @act_user.user_plan.downcase == 'free' && (@act_user.manage_plan.nil? || @act_user.manage_plan.empty?)
											@str = 'get info'
										elsif @act_user.user_plan.downcase == 'sell'&& (@act_user.manage_plan.nil? || @act_user.manage_plan.empty?)
											@str = 'buy now'
										elsif @act_user.user_plan.downcase == 'sell' && !@act_user.manage_plan.nil? && @act_user.manage_plan != ''
											#check sales limit
											if !@pro_trans.nil? && @pro_trans.present? && @pro_trans.length > 0		
												@str = 'buy now'
												#~ if !@pro_trans[0].nil? && @pro_trans[0].sales_limit.to_i > @pro_trans[0].purchase_limit.to_i
													#~ @str = 'buy now'
												#~ else
													#~ @str ='get info'
												#~ end
											else									
												if @act_user.is_partner == true
													@str = 'buy now'
												else
													@str = 'get info'
												end
												
											end
										elsif @act_user.user_plan.downcase == 'curator'
											@str = 'get info'
										else
											@str = 'get info'
										end		
									else	
										#schedule - schedule and whole day
										if !@schedule.nil? && @schedule.present? && @schedule.length > 0
											if @act_user.user_plan.downcase == 'free'  && (@act_user.manage_plan.nil? || @act_user.manage_plan.empty?)
												@str = 'get info'
											elsif @act_user.user_plan.downcase == 'sell'  && (@act_user.manage_plan.nil? || @act_user.manage_plan.empty?)
												@str = 'buy now'
											elsif @act_user.user_plan.downcase == 'sell' && !@act_user.manage_plan.nil? && @act_user.manage_plan != ''
												#check sales limit
												if !@pro_trans.nil? && @pro_trans.present? && @pro_trans.length > 0	
													@str = 'buy now'
													#~ if !@pro_trans[0].nil? && @pro_trans[0].sales_limit.to_i > @pro_trans[0].purchase_limit.to_i											
														#~ @str = 'buy now'
													#~ else
														#~ @str ='get info'
													#~ end
												else									
													if @act_user.is_partner == true
														@str = 'buy now'
													else
														@str = 'get info'
													end
												end
											elsif @act_user.user_plan.downcase == 'curator'
												@str = 'get info'
											else
												@str = 'get info'
											end	
										else
											@str = 'get info'
										end									
									end
								end
							end
						else
							@str = 'get info'
						end					
					end
					
				elsif !@activity.created_by.nil? && @activity.created_by!='' && @activity.created_by.downcase == 'parent'					
					if !@activity.user_id.nil? && !@userid.nil? && @activity.user_id.to_i == @userid.to_i
						@str = 'edit'
					else
						if !@schedule.nil? && @schedule.present? && @schedule.length > 0							
							@str = 'buy now'
						else
							@str = 'get info'
						end
					end					
				else	
					#parent / provider not 
					@str = 'buy now'
				end
				
			else
				@str ='invalid'
			end
		else
			@str = 'invalid'
		end
		return @str
	end
	
	#landing page feature row code
	def landing_feature_activity
		#cookies.delete :feature_page #to avoid duplicate - delete cookies for first time page load
		#cookies.delete :other_city_page #to avoid duplicate - delete cookies for first time page load
   
    params[:mode]='parent'  #dont remove this
    #      if !session['ip_location'].nil?
    #        ip_location = session['ip_location']
    #      else
    #        ip_location = {'latitude'=>'37.9100783','longitude'=>'-122.0651819', 'city' => 'Walnut Creek'}
    #      end
    #      if (cookies[:selected_city].nil?)
    #        if(ip_location.present? && ip_location && !ip_location.nil? && !ip_location['city'].nil? && ip_location['city'].present? && ip_location['city']!="" )
    #          cookies[:city_new_usr] = ip_location['city'].titlecase  if(ip_location.present? && ip_location && !ip_location.nil? && !ip_location['city'].nil?)
    #        else #default values
    #          cookies[:city_new_usr] = 'Walnut Creek'
    #        end
    #        @city_value = request.url.split('/').last
    #        if (request.url.include? "=")
    #          if (@city_value.include? "?")
    #            cookies[:city_new_usr] = 'Walnut Creek'
    #          else
    #            cookies[:city_new_usr] = @city_value.titleize
    #          end
    #        else
    #          cookies[:city_new_usr] = 'Walnut Creek'
    #        end
    #      else #city selected values
    #        cookies[:city_new_usr] = cookies[:selected_city]
    #      end
    
    if !session['ip_location'].nil?
      ip_location = session['ip_location']
    else
      ip_location = {'latitude'=>'37.9100783','longitude'=>'-122.0651819', 'city' => 'Walnut Creek'}
    end
    if (cookies[:selected_city].nil?)
      if(ip_location.present? && ip_location && !ip_location.nil? && !ip_location['city'].nil? && ip_location['city'].present? && ip_location['city']!="" )
        cookies[:city_new_usr] = ip_location['city'].titlecase  if(ip_location.present? && ip_location && !ip_location.nil? && !ip_location['city'].nil?)
      else #default values
        cookies[:city_new_usr] = 'Walnut Creek'
      end
      @city_value = request.url.split('/').last
      if (request.url.include? "=")
        if (@city_value.include? "?")
          cookies[:city_new_usr] = 'Walnut Creek'
        else
          cookies[:city_new_usr] = @city_value.titleize
        end
      else
        cookies[:city_new_usr] = 'Walnut Creek'
      end
    else #city selected values
      cookies[:city_new_usr] = cookies[:selected_city]
    end
    
    session[:city] = cookies[:search_city]
    session[:city] = "Walnut Creek" if session[:city].nil?
    session[:cat_zc]="date"
    session[:date] = Time.now.strftime("%Y-%m-%d") if session[:date].nil?
     
    @provider_activites = []
    @follow_parent_user = []
    @follow_provider_user = []
    @category = []
    @sub_category = []
    @checck  = []
    @jump_to_act =[]
    if !current_user.nil?
      user_id = current_user.user_id
      @fam_post = FamNetworkRow.where("user_id=#{user_id}").map(&:contact_group_id).uniq
      @provider_activites_selected = []
      @provider_activites_combined = []
      categories_selected =  ActivityRow.select("Distinct(act.category_id)").joins("left join activity_subcategories as act on act.subcateg_id = activity_rows.subcateg_id").where("activity_rows.user_id = ?",cookies[:uid_usr]).group("act.category_id").map(&:category_id)
      @provider_activites_selected = ActivityCategory.select("Distinct(category_name)").where(:category_id => categories_selected).map(&:category_name)
      #user selected activities
      @provider_activites_combined<<@provider_activites_selected if @provider_activites_selected
      #make all the category to single array
      @provider_activites_get = @provider_activites_combined.flatten
      @provider_activites = @provider_activites_get.uniq{|x| x}
      #provider activities based on the user selection row with default row added
       
      @follow_parent_user = UserRow.where("user_id=#{user_id} and lower(user_type)='u'").map(&:row_user_id)
      @follow_provider_user = UserRow.where("user_id=#{user_id} and lower(user_type)='p'").map(&:row_user_id)
      @category =  ActivityRow.where(:user_id=>user_id).map(&:subcateg_id)
      @sub_category = ActivitySubcategory.where(:subcateg_id=>@category ).map(&:subcateg_name)
      @checck = ActivityRow.find(:all,:conditions=>["user_id = ? ",user_id],:select => "row_type")
      session[:category_row] = ""
      cookies[:subct_id] = ""
      session[:before_cat] = ""
      session[:before_prov] = ""
      session[:provider_row] = ""
      @provider_activites_check =[]
      @checck.each { |s| @provider_activites_check<< s.row_type }
    else
      
	
    end #current user end
#    if params[:page].nil?
#      cookies[:feature_page] = 1
#      cookies.delete :other_city_page
#    end
#    arr = []
    #~ get_total_feature_list(arr)
#    get_total_feature_list(arr,ip_location['latitude'],ip_location['longitude']) if !ip_location.nil? && ip_location!='' && ip_location.present? && !ip_location['latitude'].nil? && !ip_location['longitude'].nil? && ip_location['latitude']!='' && ip_location['longitude']!=''
#    featured = arr.uniq{|x| x[:id]}
#    if featured.length !=0 && featured.length <8
#      cookies[:feature_page] = 1 + cookies[:feature_page].to_i
#      #~ get_total_feature_list(arr)
#      get_total_feature_list(arr,ip_location['latitude'],ip_location['longitude']) if !ip_location.nil? && ip_location!='' && ip_location.present? && !ip_location['latitude'].nil? && !ip_location['longitude'].nil? && ip_location['latitude']!='' && ip_location['longitude']!=''
#    end
#    @activity_featured = arr.uniq{|x| x[:id]}
   @accordion = Activity.order("category Asc").find(:all,:select => "DISTINCT trim(category) as category",:conditions=>["lower(category)!=?",'default'])
#    @blog_value = []
#    url = URI.parse("http://blog.famtivity.com/?feed=rss2")
#    req = Net::HTTP.new(url.host, url.port)

    

	end
	
	def get_total_feature_list_a(arr,lat,long)
		featured = City.nearby_city_activities(lat,long,session[:city],cookies[:feature_page])
		#~ @admin_activity=[]
	  if featured[1]
      cookies[:other_city_page] = 1 +  cookies[:other_city_page].to_i if !cookies[:other_city_page].nil?
      cookies[:other_city_page] = 1 if cookies[:other_city_page].nil?
      #cookies[:other_city_page] = ((cookies[:other_city_page].nil?)  ? 1 : (cookies[:other_city_page].to_i+1))
      @admin_activity = featured[0].paginate(:page => cookies[:other_city_page], :per_page =>20)
    else
      @admin_activity = featured[0].paginate(:page => cookies[:feature_page], :per_page =>20)
    end
		@admin_activity.each do |actv|
			if actv.class.to_s=='Activity' || actv.class.to_s=='Array'
        activity = (actv.class.to_s=='Activity') ? actv : actv[0]
        mod_mode = (actv.class.to_s=='Activity') ? 'activity' : 'weekend'
        @schedule = ActivitySchedule.where("activity_id = ?",activity.activity_id).last
        #Activity.schedule_feature_list(session[:date],event,arr) if !event.nil?
        arr << {:model_mode=>mod_mode, :discount_eligible=>activity.discount_eligible, :schedule =>@schedule, :activity=>activity, :id => activity.activity_id, :leader=>activity.leader, :skill_level=>activity.skill_level, :schedule_mode=>activity.schedule_mode, :filter_id=>activity.filter_id, :min_age_range=>activity.min_age_range, :max_age_range=>activity.max_age_range, :price_type => activity.price_type, :city => activity.city, :activity_name => activity.activity_name, :description => activity.description,:avatar=> activity.avatar,:avatar_file_name=>activity.avatar_file_name,:category=>activity.category,:sub_category=>activity.sub_category,:price=>activity.price,:address_1=>activity.address_1,:address_2=>activity.address_2,:age_range=>activity.age_range,:no_participants=>activity.no_participants,:created_by=>activity.created_by,:user_id=>activity.user_id, :purchase_url=>activity.purchase_url}
			else
        arr << {:id => actv.user_id,:model_mode=>'user'}
			end
		end if !@admin_activity.nil? && @admin_activity.length > 0
		@total_pages = @admin_activity.total_pages
		@current_page = (cookies[:other_city_page] && cookies[:other_city_page].present? && !cookies[:other_city_page].nil?) ? cookies[:other_city_page] : cookies[:feature_page]
		return arr
	end   
	
	
  def getusername(uid)
    if uid
	    @user = User.find_by_user_id(uid)
	    name = @user.user_name if @user && @user.user_name
    end
    return name
  end
  
  def fndPrevPage(prev_url,throu_login)
	  if prev_url.present?
		  res = false
		  prev_url = prev_url.split("?")[0]
		  #~ is_quick_link_url = prev_url.split("-").last
		  quick_url = prev_url.split("/").last
		  quick_links = ["discount-dollar-activities","special-activities","free-activities","camp-activities","special-needs-activities"]
		  is_quick_link_url = quick_links.include?(quick_url)
		  if (prev_url==search_url) || (is_quick_link_url) || (throu_login && throu_login=='Search')
			  page = 'Search'
			  res = true
		  elsif (prev_url==root_url) || (throu_login && throu_login.present?) || (throu_login && throu_login=='Home')
			  page = 'Home'
			  res = true
		  end
		  return page,res
	  end
  end

      
end
