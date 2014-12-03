
namespace :hello_world  do
 desc "display the hello world text"
   task :run_hello => :environment do
	  puts "---------------starting hello world---------------"
	        begin
	        puts "hello world"
		@pro_user="sithankumar@i-waves.com"
		UserMailer.delay(queue: "sample mail to user", priority: 1, run_at: 2.seconds.from_now).hello_world(@pro_user) if !@pro_user.nil?
		rescue Exception => exc
			puts "#{exc.message}"
		end
	
	  puts "---------------hello world ending here---------------"
   end
end