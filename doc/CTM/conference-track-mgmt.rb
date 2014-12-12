# to get the name and time 
require "time"
class Conference
    #constructer for name and time
    def initialize(name,time)
	    @name=name
	    @time = time
    end
    def name
	    @name
    end
    def time
	    @time
    end
end

puts "Enter the Total number of talks"
 total_talk = gets.to_i
 total_record = {} #init the hash
 total_time_t1 = []
 total_time_t2 = []
for i in 1..total_talk
    puts "Enter your talk #{i} title"
    talk_des=gets
    puts "Enter your talk #{i} time"
    talk_time=gets.to_i
    con = Conference.new(talk_des,talk_time) #constructure 
    
    #store the keys and values in hash
    total_record ["#{con.name.strip}"]="#{con.time}"
end
 
     #do values here
 track1,track2={},{}
    ["mor","eve"].each do |session|
	    time=(session=="mor") ? (180) : (240)
	     for j in 1..2  #for track1 and track2
		     loop=0
		     tot = 0
		     total_record.each do |k,v|
			     if (tot.to_i+v.to_i<=time)
				if (loop==0)			    
				     eval("track#{j}")["#{session}"]={}
				      @starttime=Time.parse("9:00 AM")				     
			     end
				tot=tot.to_i+v.to_i 	
				eval("track#{j}")["#{session}"][k] = "#{@starttime.strftime("%H:%M %p")},#{v}"					
				total_record.delete_if {|key, value| key == k } #remove the key from original once pushed to track
				min_v = v.to_i*60
				@starttime= @starttime+min_v			      
			     end #if ending
			loop=loop+1
		    end #do ending
	    end #for ending
    end #do ending here

   #display the output here
   @track_one_mor = ''
   @track_two_mor = ''
   @track_one_eve = ''
   @track_two_eve = ''
     puts "Track 1:"
	track1["mor"] && track1["mor"].each do |ks,vl|
		v=vl.split(",")
	  @track_one_mor=@track_one_mor+"#{v[0]} #{ks} #{v[1]}min\n"
       end
     puts @track_one_mor
     puts "12:00PM Lunch\n"
        track1["eve"] && track1["eve"].each do |ks,vl|
		v=vl.split(",")
	  @track_one_eve=@track_one_eve+"#{v[0]} #{ks} #{vl[1]}min\n"
      end
     puts @track_one_eve
     puts "05:00PM Networking Event\n"
     
     puts "==============================================="
     puts "Track 2:"
      track2["mor"] && track2["mor"].each do |kys,vls|
	      v=vls.split(",")
	  @track_two_mor=@track_two_mor+"#{v[0]} #{kys} #{v[1]}min\n"
     end
     puts @track_two_mor 
     puts "12:00PM Lunch\n"
        track1["eve"] && track1["eve"].each do |ks,vl|
		v=vls.split(",")
	  @track_two_eve=@track_two_eve+"#{v[0]} #{ks} #{v[1]}min\n"
      end
     puts @track_two_eve
     puts "05:00PM Networking Event\n"

     

