class ActivityBid < ActiveRecord::Base
  attr_accessible :activity_id, :balance_budget, :bid_amount, :bid_status, :city_id, :no_clicks, :total_bid_amount, :userid,:click_count_amount

  def self.activity_user_bids(user_id)
    @sdate=Time.now.beginning_of_month.strftime("%Y-%m-%d")
    @edate=Time.now.end_of_month.strftime("%Y-%m-%d")
    return act = Activity.find_by_sql("select sum(activity_clicks.no_of_attempts) as click,sum(activity_clicks.click_amount)as amount,activities.activity_id,activities.activity_name from activities,activity_clicks where activities.activity_id = activity_clicks.activity_id and activities.user_id = #{user_id} and click_date between '#{@sdate}' and '#{@edate}' group by activity_clicks.activity_id,activities.activity_id,activities.activity_name order by click desc").uniq
  end


end
