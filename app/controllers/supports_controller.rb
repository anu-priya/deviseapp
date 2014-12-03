class SupportsController < ApplicationController
  require 'net/http'
  # GET /supports
  # GET /supports.json
  def index
    @supports = Support.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @supports }
    end
  end

  # GET /supports/1
  # GET /supports/1.json
  def show
    @support = Support.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @support }
    end
  end

  # GET /supports/new
  # GET /supports/new.json
  def new
    @support = Support.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @support }
    end
  end

  # GET /supports/1/edit
  def edit
    @support = Support.find(params[:id])
  end

  # POST /supports
  # POST /supports.json
  def create
    @support = Support.new(params[:support])

    respond_to do |format|
      if @support.save
        format.html { redirect_to @support, notice: 'Support was successfully created.' }
        format.json { render json: @support, status: :created, location: @support }
      else
        format.html { render action: "new" }
        format.json { render json: @support.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /supports/1
  # PUT /supports/1.json
  def update
    @support = Support.find(params[:id])

    respond_to do |format|
      if @support.update_attributes(params[:support])
        format.html { redirect_to @support, notice: 'Support was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @support.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supports/1
  # DELETE /supports/1.json
  def destroy
    @support = Support.find(params[:id])
    @support.destroy

    respond_to do |format|
      format.html { redirect_to supports_url }
      format.json { head :no_content }
    end
  end
  
  # support form 
  def support
    #uri = URI.parse("http://www.showontherun.com/application/JsonApi/getfeedbackLabel?product_id=4")
    uri = URI.parse("http://www.showonthecloud.com/application/JsonApi/getfeedbackLabel?product_id=3")
    # uri = URI.parse("https://upload.twitter.com/1/statuses/update_with_media.json")
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)
    @parsed=JSON.parse(response.body)
    p response
  end
  
  #support form create action
  def support_create
    params[:email_address] if params[:email_address] !=""
    params[:label] if params[:label]  !=""
    params[:message] if params[:message] !=""
    @support_type=params[:support_type] if params[:support_type]!=""
    @baattachment =""
    @get_current_url = request.env['HTTP_HOST']
    if params[:support]!="" && !params[:support].nil?
      file_data = params[:support]
      if file_data.respond_to?(:read)
        str_to_encode = file_data.read
      elsif file_data.respond_to?(:path)
        str_to_encode = File.read(file_data.path)
      else
        logger.error "Bad file_data: #{file_data.class.name}: #{file_data.inspect}"
      end

      @baattachment = Base64.encode64(str_to_encode)
      @baattachment = @baattachment.gsub(/\n/, '')
    end

    post_args1 = { 'femail' =>params[:email_address],'label_id'=>params[:label_id],'productname'=>'Famtivity','fmessage'=>params[:message],'ferror_type'=>params[:support_type],'imagebyte'=>@baattachment }
    x = Net::HTTP.post_form(URI.parse("http://www.showonthecloud.com/application/JsonApi/UserSendfeedback"), post_args1)
    p x

    #    @support = Support.create(:support_type=>params[:support_type], :email_address=>params[:email_address], :labels=>params[:label], :support=>image, :comments=>params[:message], :inserted_date=>createtime, :modified_date=>createtime)
    #    if @support.save
    #
    #      #send a mail to the users.
    #      if current_user.present? && current_user.user_flag==TRUE
    #        user=current_user.email_address if !current_user.email_address.nil?
    #        @result = UserMailer.support_user_mail(current_user,params[:email_address],@get_current_url,params[:subject]).deliver
    #      else
    #        #mailer to non user.
    #        @result = UserMailer.support_nouser_mail(params[:email_address],@get_current_url,params[:subject]).deliver
    #      end
    #
    #      #sending mail to the support team.
    #      team_member="urajkumar@i-waves.com"
    #      if @support.support_file_name!=''&& !@support.support_file_name.nil? && @support.support_file_name.present? && !@support.nil?
    #        image=@support.support.url if @support.support.url.present?
    #      else
    #        image=''
    #      end
    #
    #      #send a mail to the support team
    #      #~ if current_user.present? && current_user.user_flag==TRUE
    #      #~ user=current_user.email_address if !current_user.email_address.nil?
    #      #~ @result = UserMailer.support_team_mail(image,team_member,user,params[:label],params[:message],@get_current_url,params[:subject],params[:support_type]).deliver
    #      #~ else
    #      if params[:email_address]
    #        @result = UserMailer.support_team_mail(image,team_member,params[:email_address],params[:label],params[:message],@get_current_url,params[:subject],params[:support_type]).deliver
    #      end
    #
    #      #success popup through the html.
    #
    #    end if @support.present?
    redirect_to :action => "support_form_thank"
  
  end
  
  def support_form_thank
    
  end
  
  def feedback_thank
  
  end
  
  # feedback form 
  def feedback
    #uri = URI.parse("http://www.showonthecloud.com/application/JsonApi/getfeedbackLabel?product_id=3&search=html")
    #http = Net::HTTP.new(uri.host, uri.port)
    #request = Net::HTTP::Get.new(uri.request_uri)
    #response = http.request(request)
    #if !response.nil? && !response.code.nil? &&response.code!="500"
    # @parsed=JSON.parse(response.body)
    #else
     @parsed=JSON.parse("{\"results\":[{\"fbk_label_id\":98,\"fbk_label_name\":\"HTML-Registration\\/SignIn\",\"fbk_label_desc\":\"Issues related to Registration \\/Sign,Forgot password,Remember Password\",\"date_of_creation\":\"2013-05-06 05:05:25+00\",\"ref_product_id\":3},{\"fbk_label_id\":99,\"fbk_label_name\":\"HTML-Landing Page\",\"fbk_label_desc\":\"Issues related to category listing in Landing page before and after login\",\"date_of_creation\":\"2013-05-06 05:06:17+00\",\"ref_product_id\":3},{\"fbk_label_id\":100,\"fbk_label_name\":\"HTML-My Scheduled\",\"fbk_label_desc\":\"HTML-My Scheduled-Issues related to My Scheduled page\\r\",\"date_of_creation\":\"2013-05-06 05:08:10+00\",\"ref_product_id\":3},{\"fbk_label_id\":101,\"fbk_label_name\":\"HTML-Search\",\"fbk_label_desc\":\"Issues related to Search and Advance Search\",\"date_of_creation\":\"2013-05-06 05:08:40+00\",\"ref_product_id\":3},{\"fbk_label_id\":102,\"fbk_label_name\":\"HTML-Profile and Settings\",\"fbk_label_desc\":\"Issues related to Profile,Participants and Settings\",\"date_of_creation\":\"2013-05-06 05:15:24+00\",\"ref_product_id\":3},{\"fbk_label_id\":103,\"fbk_label_name\":\"HTML-FeedBack\",\"fbk_label_desc\":\"Issues related to Beta Feedback \",\"date_of_creation\":\"2013-05-06 05:15:47+00\",\"ref_product_id\":3},{\"fbk_label_id\":104,\"fbk_label_name\":\"HTML-Contacts\",\"fbk_label_desc\":\"Issues related to add, edit,delete, import contacts.\",\"date_of_creation\":\"2013-05-06 05:16:11+00\",\"ref_product_id\":3},{\"fbk_label_id\":105,\"fbk_label_name\":\"HTML-General\",\"fbk_label_desc\":\"How it Works,Blog,Newsletter\",\"date_of_creation\":\"2013-05-06 05:16:35+00\",\"ref_product_id\":3},{\"fbk_label_id\":109,\"fbk_label_name\":\"HTML-Activity\",\"fbk_label_desc\":\"Isses related to Create, edit,delete,attend,view and share activity to other users social networks,Email notifications\",\"date_of_creation\":\"2013-05-06 11:11:40+00\",\"ref_product_id\":3},{\"fbk_label_id\":106,\"fbk_label_name\":\"HTML-Reports\",\"fbk_label_desc\":\"Activity Tickets, Transaction reports, Sponsorship (Bid flow reports)\\n\",\"date_of_creation\":\"2013-05-06 08:59:19+00\",\"ref_product_id\":3},{\"fbk_label_id\":135,\"fbk_label_name\":\"HTML-Newsletter\",\"fbk_label_desc\":\"Newletter issues\",\"date_of_creation\":\"2013-07-04 05:28:30+00\",\"ref_product_id\":3},{\"fbk_label_id\":137,\"fbk_label_name\":\"HTML-Admin\",\"fbk_label_desc\":\"Issues related to the admin screen\",\"date_of_creation\":\"2013-07-16 05:35:14+00\",\"ref_product_id\":3},{\"fbk_label_id\":149,\"fbk_label_name\":\"HTML-Messaging\",\"fbk_label_desc\":\"Issues logged in Message Section\",\"date_of_creation\":\"2014-01-29 11:59:53+00\",\"ref_product_id\":3}]}")
    #end
    #p response.code

  end
  
  def feedback_create
    params[:email_address] if params[:email_address] !=""
    params[:field1] if params[:field1]  !=""
    params[:cmt] if params[:cmt] !=""
    @support_type=params[:support_type] if params[:support_type]!=""
    @baattachment =""
    @get_current_url = request.env['HTTP_HOST']
    if params[:support]!="" && !params[:support].nil?
      file_data = params[:support]
      if file_data.respond_to?(:read)
        str_to_encode = file_data.read
      elsif file_data.respond_to?(:path)
        str_to_encode = File.read(file_data.path)
      else
        logger.error "Bad file_data: #{file_data.class.name}: #{file_data.inspect}"
      end

      @baattachment = Base64.encode64(str_to_encode)
      @baattachment = @baattachment.gsub(/\n/, '')
    end

    #post_args1 = { 'femail' => params[:email_address],'label_id'=>params[:label_id],'productname'=>'Famtivity','fmessage'=>params[:cmt],'ferror_type'=>params[:support_type],'imagebyte'=>@baattachment }
    #x = Net::HTTP.post_form(URI.parse("http://www.showonthecloud.com/application/JsonApi/UserSendfeedback"), post_args1)
    #p x
     #if x.code!="200"
       @subject="#{params[:field1]}"" | Feedback | Famtivity!" if params[:field1] !=""
       @email=params[:email_address] if params[:email_address] !=""
       @name=current_user.user_name if !current_user.nil? && !current_user.user_name.nil?
       @msg =params[:cmt] if params[:field1] !=""
       @get_current_url = request.env['HTTP_HOST']
       if params[:support]!="" && !params[:support].nil?
       @result = UserMailer.delay(queue: "Beta Feedback ", priority: 2, run_at: 10.seconds.from_now).beta_feedback_image(@subject,@msg,@name,@email,@get_current_url,str_to_encode)
       else
       @result = UserMailer.delay(queue: "Beta Feedback ", priority: 2, run_at: 10.seconds.from_now).beta_feedback(@subject,@msg,@name,@email,@get_current_url)
       end    
    #end



    #    @support = Support.create(:support_type=>params[:support_type], :email_address=>params[:email_address], :labels=>params[:label], :support=>image, :comments=>params[:message], :inserted_date=>createtime, :modified_date=>createtime)
    #    if @support.save
    #
    #      #send a mail to the users.
    #      if current_user.present? && current_user.user_flag==TRUE
    #        user=current_user.email_address if !current_user.email_address.nil?
    #        @result = UserMailer.support_user_mail(current_user,params[:email_address],@get_current_url,params[:subject]).deliver
    #      else
    #        #mailer to non user.
    #        @result = UserMailer.support_nouser_mail(params[:email_address],@get_current_url,params[:subject]).deliver
    #      end
    #
    #      #sending mail to the support team.
    #      team_member="urajkumar@i-waves.com"
    #      if @support.support_file_name!=''&& !@support.support_file_name.nil? && @support.support_file_name.present? && !@support.nil?
    #        image=@support.support.url if @support.support.url.present?
    #      else
    #        image=''
    #      end
    #
    #      #send a mail to the support team
    #      #~ if current_user.present? && current_user.user_flag==TRUE
    #      #~ user=current_user.email_address if !current_user.email_address.nil?
    #      #~ @result = UserMailer.support_team_mail(image,team_member,user,params[:label],params[:cmt],@get_current_url,params[:subject],params[:support_type]).deliver
    #      #~ else
    #      if params[:email_address]
    #        @result = UserMailer.support_team_mail(image,team_member,params[:email_address],params[:label],params[:cmt],@get_current_url,params[:subject],params[:support_type]).deliver
    #      end
    #
    #      #success popup through the html.
    #
    #    end if @support.present?
    redirect_to :action => "feedback_thank"
  
  end
  def survey_monkey
  
  end
  
  
end
