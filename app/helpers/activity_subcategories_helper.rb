module ActivitySubcategoriesHelper

  #remove categories from currently following rows
  def add_remove_followcategory(cat_add,cat_remove,userid)
    #add row start
    if !cat_add.nil? && cat_add !=""
      pro_act = cat_add.split(",")
      if pro_act.length > 0
        pro_act.each do |sid|
          @subcategory = ActivitySubcategory.find_by_subcateg_id(sid)
          if !@subcategory.nil? && @subcategory!='' && @subcategory.present?
            @row_exists = ActivityRow.find_by_subcateg_id_and_user_id(sid,userid)
            if @row_exists.nil?
              @row = ActivityRow.new
              @row.subcateg_id = sid
              @row.row_type = @subcategory.subcateg_name
              @row.user_id = userid
              @row.inserted_date = Time.now
              @row.save
            end
          end
        end
      end
    end
    if !cat_remove.nil? && cat_remove!=""
      pro_rem = cat_remove.split(",")
      pro_rem.each do |sid|
        @row = ActivityRow.find_by_sql("select a.* from activity_rows a left join activity_subcategories b on a.subcateg_id = b.subcateg_id where b.category_id = #{sid} and a.user_id = #{current_user.user_id}").map(&:id) if !current_user.nil?
	
        if !@row.nil? && @row!='' && @row.present?
          @row.each do |actrow|
            @rowdet = ActivityRow.find_by_id(actrow) if !actrow.nil?
            @rowdet.destroy() if !@rowdet.nil?
          end #do end
        end
      end if !pro_rem.nil? && pro_rem.length > 0
    end
  end
  
  def add_remove_subcategory(cat_add,cat_remove,userid)
    #add row start
    if !cat_add.nil? && cat_add !=""
      pro_act = cat_add.split(",")
      if pro_act.length > 0
        pro_act.each do |sid|
          @subcategory = ActivitySubcategory.find_by_subcateg_id(sid)
          cat_name = ActivityCategory.find_by_category_id(@subcategory.category_id) if !@subcategory.nil? && @subcategory!=''
          if !cat_name.nil? && !cat_name.category_name.nil?
            cookies[:follow_cat_val]=cat_name.category_name.downcase
          end
          if !@subcategory.nil? && @subcategory!='' && @subcategory.present?
            @row_exists = ActivityRow.find_by_subcateg_id_and_user_id(sid,userid)
            if @row_exists.nil?
              @row = ActivityRow.new
              @row.subcateg_id = sid
              @row.row_type = @subcategory.subcateg_name
              @row.user_id = userid
              @row.inserted_date = Time.now
              @row.save
            end
          end
        end
      end
    end
    if !cat_remove.nil? && cat_remove!=""
      pro_rem = cat_remove.split(",")
      pro_rem.each do |sid|
        @row = ActivityRow.find_by_subcateg_id_and_user_id(sid,userid)
        if !@row.nil? && @row!='' && @row.present?
          @row_delete = @row.destroy()
        end
      end if pro_rem.length > 0
    end
  end


  def add_remove_fam_network(fam_add,fam_remove,userid)
    #add row start
    if !fam_add.nil? && fam_add !=""
      pro_act = fam_add.split(",")
      if pro_act.length > 0
        pro_act.each do |sid|
          @row_exists = FamNetworkRow.find_by_contact_group_id_and_user_id(sid,userid)
          if @row_exists.nil?
            @row = FamNetworkRow.new
            @row.contact_group_id = sid
            @row.user_id = userid
            @row.inserted_date = Time.now
            @row.save
          end
        end
      end
    end
    if !fam_remove.nil? && fam_remove!=""
      pro_rem = fam_remove.split(",")
      pro_rem.each do |sid|
        @row = FamNetworkRow.find_by_contact_group_id_and_user_id(sid,userid)
        if !@row.nil? && @row!='' && @row.present?
          @row_delete = @row.destroy()
        end
      end if pro_rem.length > 0
    end
  end


  
  def add_user_row(add_row_id,remove_row_id,utype,userid)
    if !add_row_id.nil? && add_row_id!=""
      add_row = add_row_id.split(",")
      #add row start
      add_row.each do |sid|
        @f_user=UserProfile.find_by_user_id(add_row_id) if !add_row_id.nil?
        @u_user=User.find_by_user_id(add_row_id) if !add_row_id.nil?
        if !@f_user.nil? && !@f_user.business_name.nil?
          cookies[:follow_cat_val]=@f_user.business_name.downcase
        else
          cookies[:follow_cat_val]=@u_user.user_name.downcase
        end
        @user_row_chk = UserRow.where("user_id=#{userid} and user_type='#{utype}' and row_user_id=#{sid}")
        if @user_row_chk.length == 0
          @row = UserRow.new
          @row.row_user_id = sid
          @row.user_type = utype
          @row.user_id = userid
          @row.inserted_date = Time.now
          @row.save
        end
        #setting notification for parent when some one follows me
        @notify_setting_f = ParentNotificationDetail.find_by_sql("select p.* from parent_notification_details pn left join parent_notifications p on pn.parent_notify_id=p.parent_notify_id where pn.notify_action='3' and lower(pn.notify_status)='active' and p.user_id=#{sid} and p.notify_flag=true")
        @get_current_url = request.env['HTTP_HOST']
        if !@notify_setting_f.nil? && @notify_setting_f!='' && @notify_setting_f.present?
          @user_f = User.find_by_user_id(current_user.user_id) if current_user.present?
          @follow_u = User.find_by_user_id(sid)
          if !@follow_u.nil? && @follow_u!='' && @follow_u.present?
            if !@follow_u.email_address.nil? && @follow_u.user_flag== true
              #UserMailer.someone_followme(@user_f,@follow_u,@follow_u.email_address,@get_current_url).deliver
              UserMailer.delay(queue: "Someone Follow", priority: 2, run_at: 10.seconds.from_now).someone_followme(@user_f,@follow_u,@follow_u.email_address,@get_current_url)
            end
          end
        end
      end if add_row.length > 0
    end
    if !remove_row_id.nil? && remove_row_id!=""
      rem_row = remove_row_id.split(",")
      rem_row.each do |sid|         
        @user_row_chk = UserRow.where("user_id=#{userid} and lower(user_type)='#{utype.downcase}' and row_user_id=#{sid}").last
        if !@user_row_chk.nil? && @user_row_chk!='' && @user_row_chk.present?
          @row_delete = @user_row_chk.destroy()
        end
      end if rem_row.length > 0
    end 
  end


end
