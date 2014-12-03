class ActivityPrice < ActiveRecord::Base
  attr_accessible :activity_schedule_id,:no_of_class, :discount, :payment_period, :price,:no_of_hour,:discount_type,:discount_price,:discount_week,:discount_start_date,:discount_end_date,:activity_id
  include IdentityCache
  cache_index :activity_id
  cache_index :activity_schedule_id
  belongs_to :activites
  belongs_to :activity_schedule
  has_many :activity_discount_price
  cache_has_many :activity_discount_price,:embed=>true

  #discount price details checked with activity_id
  def self.get_price_details(activity_id)
    @activity_price = ""
    @activity_price = ActivityPrice.eager_load(:activity_discount_price).where("activity_id = ?", activity_id).to_a if !activity_id.nil? && activity_id.present?
    @early_bird_date=[]
    @disp=[]
    @activity_price.each do |dic_price|
      @price_discount=""
      @price_discount = dic_price.fetch_activity_discount_price if !dic_price.nil? && dic_price.present?
      if @price_discount.length==1 && !@price_discount[0].discount_type.nil? && @price_discount[0].discount_type=="Early Bird Discount"
        #subscription
        @sub = ""
        @sub = @price_discount[0].discount_number if !@price_discount.nil?
        #activity participants
        participant = ""
        #~ participant = ActivityAttendDetail.select("distinct participant_id").where("activity_id=? and lower(payment_status)=?",activity_id,'paid').map(&:participant_id)
        participant = ActivityAttendDetail.fetch_by_activity_id_and_payment_status(activity_id,'paid').map(&:participant_id) #identity cache
        @no_of_part = ""
        @no_of_part = participant.length if !participant.nil? && participant.present? && participant!=""
        #comparing the subscription and no of participants values by rajkumar
        if !@no_of_part.nil? && @no_of_part.present? && @no_of_part!="" && !@sub.nil? && @sub.present?
          #sub is greater to participants
          if ((!@sub.nil? && @sub.present? && @sub!="" && @sub) > (!@no_of_part.nil? && @no_of_part.present? && @no_of_part!="" && @no_of_part))
            if !@price_discount[0].discount_valid.nil? && @price_discount[0].discount_valid.present?
              @early_bird_date<<@price_discount[0].discount_valid.strftime("%Y-%m-%d")
            end
          else
            @disp<<"false"
          end
        else
          if !@price_discount[0].discount_valid.nil? && @price_discount[0].discount_valid.present?
            @early_bird_date<<@price_discount[0].discount_valid.strftime("%Y-%m-%d")
          end
        end
			  #multiple discount length more than 1
      elsif !@price_discount.nil? && @price_discount.present?
				@disp<<"true"
      end
    end if !@activity_price.nil? && @activity_price.present? #do end
		  
    #Early bird discount date for multiple price
    if !@early_bird_date.nil? && @early_bird_date.present? && @early_bird_date!=""
      @max_date = @early_bird_date.max if !@early_bird_date.nil?
      @cday = Time.now.strftime("%Y-%m-%d")
      if !@max_date.nil? && @max_date.present? && @max_date >= @cday
				@disp<<"true"
      else
				@disp<<"false"
      end
    end
    #return the activity price values
    if !@disp.nil? && @disp.present? && @disp!="" && @disp.any?
      if @disp.include?('true')
        return @price_discount
      else
        return ""
      end #include end
    end #disp end
  end #method end
end #model end


############################ old activity price details
#~ def self.get_price_details(activity_id)
#~ @activity_price = ""
#~ @activity_price = ActivityPrice.where("activity_id = ?", activity_id) if !activity_id.nil? && activity_id.present?
#~ @d_flag="false"
#~ @ebird_flag="false"
#~ @early_bird_type=[]
#~ @early_bird_date=[]
#~ @activity_price.each do |dic_price|
#~ @price_discount=""
#~ @price_discount = ActivityDiscountPrice.where("activity_price_id = ?", dic_price.activity_price_id) if !dic_price.nil? && dic_price.present?
#~ if @price_discount.length==1 && !@price_discount[0].discount_type.nil? && @price_discount[0].discount_type=="Early Bird Discount"
#~ @early_bird_type<<"yes"
#~ if !@price_discount[0].discount_valid.nil? && @price_discount[0].discount_valid.present?
#~ @early_bird_date<<@price_discount[0].discount_valid.strftime("%Y-%m-%d")
#~ end
#~ elsif !@price_discount.nil? && @price_discount.present?
#~ @early_bird_type<<"no"
#~ @ebird_flag="true"
#~ end
#~ end if !@activity_price.nil? && @activity_price.present? #do end
		  
#~ if !@ebird_flag.nil? && @ebird_flag && @ebird_flag=="true"
#~ @d_flag="true" 
#~ elsif !@early_bird_date.nil? && @early_bird_date.present?
#~ @max_date = @early_bird_date.max if !@early_bird_date.nil?
#~ @cday = Time.now.strftime("%Y-%m-%d")
#~ if !@max_date.nil? && @max_date.present? && @max_date >= @cday
#~ @d_flag="true"
#~ else
#~ @d_flag="false"
#~ end
#~ end
		  
#~ #return @d_flag
#~ return @price_discount
#~ end
############################