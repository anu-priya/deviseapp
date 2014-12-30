# to get the name and time  
#commited from my laptop
require "time"
require "pry"

class Conference
    #constructer for name and time
    def initialize(name,time)
	    @name=name
	    @time = time
    end
    #set the name
    def name
	    @name
    end
    #set the duration in mins
    def time
	    @time
    end
end

puts "Enter the Total number of talks(in nos)"
 total_talk = gets #get the total no of input values from the user
	if !total_talk.match(/[a-z]/).nil?
	  exit #exit if it is invalid
	else
		total_record = {} #init the hash
		for i in 1..total_talk.to_i
		    puts "Enter your talk #{i} title"
		    talk_des=gets
		    puts "Enter your talk #{i} time(in mins)"
		    talk_time=gets.to_i
		    con = Conference.new(talk_des,talk_time) #constructure 
		    
		    #store the keys and values in hash
		    total_record ["#{con.name.strip}"]="#{con.time}"
		end
		 
		     #do values here
		begin 
			 track1,track2={},{}
			    ["mor","eve"].each do |session|
				    time=(session=="mor") ? (180) : (240)
				     for j in 1..2  #for track1 and track2
					     loop=0
					     tot = 0
					     total_record.each do |k,v|
						     #loop for morning and evening
						     if (tot.to_i+v.to_i<=time)
							if (loop==0)			    
							     eval("track#{j}")["#{session}"]={}
							     @starttime=(session=="mor") ? (Time.parse("9:00 AM")) : (Time.parse("1:00 PM"))				      
						     end
							tot=tot.to_i+v.to_i  #add the duation values
							eval("track#{j}")["#{session}"][k] = "#{@starttime.strftime("%l:%M %p")},#{v}"					
							total_record.delete_if {|key, value| key == k } #remove the key from original once pushed to track
							min_v = v.to_i*60 #no for minutes
							@starttime= @starttime+min_v			      
						     end #if ending
						loop=loop+1
					    end #do ending
				    end #for ending
			    end #do ending here
		rescue Exception => exc
			puts "#{exc.message}"
		end

		#display the track1 and track2 values dynamically.
		puts "\n\n Schedule Details"
		begin 
			for k in 1..2
				puts "Track #{k}:"
				["mor","eve"].each do |sesn|
				   hsh=eval("track#{k}['#{sesn}']")
				   track_time=''
				   hsh && hsh.each do |key,value|
					v=value.split(",")
					track_time=track_time+"#{v[0]} #{key} #{v[1]}min\n"   # the time,name,duration
				end    
				puts "#{track_time}\n"   # the time,name,duration
				(sesn=="mor") ? (puts "12:00PM Lunch") : (puts "05:00PM Networking Event\n\n")	
				end
			end
		rescue Exception => exc
			puts "#{exc.message}"
		end
         end
	  
	   
 
     
	    


     

