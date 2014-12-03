module PoliciesHelper

def GoogleCalTest(date,time)
   res_date = date.strftime("%Y-%m-%d")
   res_time = time.strftime("%H:%M:%S")
   res = res_date+'T'+res_time
   start_date = Time.parse(res).utc.to_i*1000
   return start_date
end


end
