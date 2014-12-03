module SearchHelper
	def age_month_calc(arr)
		arr.collect{|x| (x.to_f/12).round(2)}
	end
end
