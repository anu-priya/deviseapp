
/** Validating Register Form **/
function validateProviderForm(){
	
	
    var p_name = $("#p_name").val();
    p_name = p_name.replace(/^\s+|\s+$/g, "");
	
    var p_password = $("#p_password").val();
    var p_confirm_password = $("#p_confirm_password").val();
    var p_owner_firstname=$("#p_owner_firstname").val();
    var p_owner_lastname=$("#p_owner_lastname").val();
    var p_email=$("#p_email").val();
    var browse_photo=$("#browse_photo").val();
    var b_name= $("#b_name").val();
    var p_admin_firstname=$("#p_admin_firstname").val();
    var p_admin_lastname=$("#p_admin_lastname").val();
    var admin_provider = $("#admin_provider").val();
    var address1=$("#address1").val();
    var address2=$("#address2").val();
    var p_state=$("#p_state").val();
    var p_city=$("#p_city").val();
    var p_zipcode=$("#p_zipcode").val();
    var p_country=$("#p_country").val();
    var agree_provider = $("#agree_provider").val();
    var p_time = $("#p_time").val();
    var p_phone=$("#p_phone").val();
    var p_mobile=$("#p_mobile").val();
    var p_fax=$("#p_fax").val();
    var web_addrs=$("#web_addrs").val();
    $(".FileField").css("color","#444444");
	
    b_name = b_name.replace(/^\s+|\s+$/g, "");
    p_fax = p_fax.replace(/^\s+|\s+$/g, "");
    address1 = address1.replace(/^\s+|\s+$/g, "");
    p_phone = p_phone.replace(/^\s+|\s+$/g, "");
    web_addrs = web_addrs.replace(/^\s+|\s+$/g, "");
    p_owner_firstname = p_owner_firstname.replace(/^\s+|\s+$/g, "");
    p_owner_lastname = p_owner_lastname.replace(/^\s+|\s+$/g, "");
   

    $("#username_usr").css("border","1px solid #BDD6DD");
    $("#p_name").css("border","1px solid #BDD6DD");
    $("#b_name").css("border","1px solid #BDD6DD");
    $("#p_password").css("border","1px solid #BDD6DD");
    $("#p_confirm_password").css("border","1px solid #BDD6DD");
    $("#browse_photo").css("border","1px solid #BDD6DD");
    $("#p_owner_firstname").css("border","1px solid #BDD6DD");
    $("#p_owner_lastname").css("border","1px solid #BDD6DD");
    $("#p_admin_firstname").css("border","1px solid #BDD6DD");
    $("#p_admin_lastname").css("border","1px solid #BDD6DD");
    $("#admin_provider").css("border","1px solid #BDD6DD");
    $("#p_time").css("border","1px solid #BDD6DD");
    $("#web_addrs").css("border","1px solid #BDD6DD");
    $("#p_email").css("border","1px solid #BDD6DD");
    $("#p_phone").css("border","1px solid #BDD6DD");
    $("#p_mobile").css("border","1px solid #BDD6DD");
    $("#p_fax").css("border","1px solid #BDD6DD");
    $("#address1").css("border","1px solid #BDD6DD");
    $("#address2").css("border","1px solid #BDD6DD");
    $("#agree_provider").css("border","1px solid #BDD6DD");
    $("#p_zipcode").css("border","1px solid #BDD6DD");
	
    $("#p_name_error").html("");
    $("#b_name_error").html("");
    $("#p_password_error").html("");
    $("#p_confirm_password_error").html("");
    $("#p_owner_firstname_error").html("");
    $("#p_owner_lastname_error").html("");
    $("#p_email_error").html("");
    $("#b_logo_error").html("");
    $("#p_admin_firstname_error").html("");
    $("#p_admin_lastname_error").html("");
    $("#admin_provider_error").html("");
    $("#address1_error").html("");
    $("#address2_error").html("");
    $("#p_state_error").html("");
    $("#p_city_error").html("");
    $("#p_zipcode_error").html("");
    $("#p_country_error").html("");
    $("#agree_provider_error").html("");
    $("#p_time_error").html("");
    $("#p_phone_error").html("");
    $("#p_mobile_error").html("");
    $("#p_fax_error").html("");
    $("#web_addrs_error").html("");

    /*
    $("#p_language_error").html("");
      $("#p_admin_error").html("");*/		
	
    $("#p_name_error").parent().css("display","none");
    $("#b_name_error").parent().css("display","none")	
    $("#p_email_error").parent().css("display","none");
    $("#p_password_error").parent().css("display","none");
    $("#p_confirm_password_error").parent().css("display","none");
    // $("#p_owner_firstname_error").parent().css("display","none");
    $("#p_owner_lastname_error").parent().css("display","none");
    $("#b_logo_error").parent().css("display","none");
    //$("#p_admin_firstname_error").parent().css("display","none");
    $("#p_admin_lastname_error").parent().css("display","none");
    $("#admin_provider_error").parent().css("display","none");
    $("#address1_error").parent().css("display","none");
    $("#address2_error").parent().css("display","none");
    $("#p_state_error").parent().css("display","none");
    $("#p_city_error").parent().css("display","none");
    $("#p_zipcode_error").parent().css("display","none");
    $("#p_country_error").parent().css("display","none");
    $("#agree_provider_error").parent().css("display","none");
    $("#p_time_error").parent().css("display","none");
    $("#p_phone_error").parent().css("display","none");
    $("#p_mobile_error").parent().css("display","none");
    $("#p_fax_error").parent().css("display","none");
    $("#web_addrs_error").parent().css("display","none");
    
    /*  
    $("#p_owner_error").parent().css("display","none");	
    $("#p_language_error").parent().css("display","none");
    /*$("#p_admin_error").parent().css("display","none");*/
		
    var errorFlag = false;
    //$("#city_height").css("margin-top","18px");
	
    if(p_name == "" || p_name == "Eg: John Smith"){
        $("#p_name").css("border","1px solid #fc8989");
        $("#p_name_error").html("Please enter your name");
        $("#p_name_error").parent().css("display","block");
        errorFlag = true;
    }
    else if(!validateName(p_name)){
        $("#p_name").css("border","1px solid #fc8989");
        $("#p_name_error").html("Please Use Only Alphabets");
        $("#p_name_error").parent().css("display","block");
        errorFlag = true;
    }
    else if(p_name.length>25){
        $("#p_name").css("border","1px solid #fc8989");
        $("#p_name_error").html("Please Do Not Exceed 25 Characters");
        $("#p_name_error").parent().css("display","block");
        errorFlag = true;
    }

    if(b_name =="" || b_name == "Enter the Name Of your business"){
        $("#b_name").css("border","1px solid #fc8989");
        $("#b_name_error").html("Please enter the business name");
        $("#b_name_error").parent().css("display","block");
        errorFlag = true;
    }
	
    else if(!validateName(b_name)){
        $("#b_name").css("border","1px solid #fc8989");
        $("#b_name_error").html("Please Use Only Alphabets");
        $("#b_name_error").parent().css("display","block");
        errorFlag = true;
    }
    else if(b_name.length>50){
        $("#b_name").css("border","1px solid #fc8989");
        $("#b_name_error").html("Please Do Not Exceed 50 Characters");
        $("#b_name_error").parent().css("display","block");
        errorFlag = true;
    }

    if (p_password == "" ||  p_password == "password"){
        $("#p_password").css("border","1px solid #fc8989");
        $("#p_password_error").html("Please enter the password");
        $("#p_password_error").parent().css("display","block");
        errorFlag = true;
    }
    else if(p_password.length<8){
        $("#p_password").css("border","1px solid #fc8989");
        $("#p_password_error").html("Must Have At least 8 Characters");
        $("#p_password_error").parent().css("display","block");
        errorFlag = true;
    }
    if(p_confirm_password ==""){
        $("#p_confirm_password").css("border","1px solid #fc8989");
        $("#p_confirm_password_error").html("Please enter the correct confirm password");
        $("#p_confirm_password_error").parent().css("display","block");
        errorFlag = true;
    }
    else if(p_confirm_password != p_password){
        $("#p_confirm_password").css("border","1px solid #fc8989");
        $("#p_confirm_password_error").html("Please enter the correct confirm password");
        $("#p_confirm_password_error").parent().css("display","block");
        errorFlag = true;
    }
    if(p_email == "" || p_email=="Eg:john@gmail.com"){
        $("#p_email").css("border","1px solid #fc8989");
        $("#p_email_error").html("Please enter your email address");
        $("#p_email_error").parent().css("display","block");
        errorFlag = true;
    }
    else if(!validateCorrectEmail(p_email)){
        $("#p_email").css("border","1px solid #fc8989");
        $("#p_email_error").html("Please Check The Email Address Entered");
        $("#p_email_error").parent().css("display","block");
        errorFlag = true;
    }
    else if(!validateDot(p_email)){
        $("#p_email").css("border","1px solid #fc8989");
        $("#p_email_error").html("Please Check The Email Address Entered");
        $("#p_email_error").parent().css("display","block");
        errorFlag = true;
    }
    if(browse_photo == ""){
        $("#browse_photo").css("border","1px solid #fc8989");
        $("#b_logo_error").parent().css("display","block");
        $("#b_logo_error").html("Please select the image to upload");
        errorFlag = true;
    }
    if(browse_photo != ""){
        val=validateBrowse();
        if(!val){
            $('#b_logo_error').html('Please Check The Format Of Your Logo');
            errorFlag = true;
        }
    }
    if(p_admin_firstname == "" || p_admin_firstname == "First Name" ){
        $("#p_admin_firstname").css("border","1px solid #fc8989");
        $("#p_admin_firstname_error").parent().css("display","block");
        $("#p_admin_firstname_error").html("Please enter the first name");
        //$("#p_admin_lastname_error").css('marginLeft','298px');
       
        errorFlag = true;
    }
    if(p_admin_lastname == "" || p_admin_lastname == "Last Name" ){
     	
        $("#p_admin_lastname").css("border","1px solid #fc8989");
        $("#p_admin_lastname_error").parent().css("display","block");           
        $("#p_admin_lastname_error").html("Please enter the last name");
        $(".marginTop12").css('marginTop','-5px');
        $(".marginTop12").css('float','left');
        errorFlag = true;
    }
    if(p_owner_firstname != "First Name" ){
        if(!validateName(p_owner_firstname)){
            $("#p_owner_firstname").css("border","1px solid #fc8989");
            $("#p_owner_firstname_error").parent().css("display","block");
            $("#p_owner_firstname_error").html("Please enter the valid name");
            errorFlag = true;
        }
        if(p_owner_firstname.length>25){
            $("#p_owner_firstname").css("border","1px solid #fc8989");
            $("#p_owner_firstname_error").parent().css("display","block");
            $("#p_owner_firstname_error").html("Please Do Not Exceed 25 Characters");
            errorFlag = true;

        }
    }
	
    if(p_owner_lastname != "Last Name" ){
        if(!validateName(p_owner_lastname)){
            $("#p_owner_lastname").css("border","1px solid #fc8989");
            $("#p_owner_lastname_error").parent().css("display","block");
            $("#p_owner_lastname_error").html("Please enter the valid name");
            errorFlag = true;
        }
        if(p_owner_lastname.length>25){
            $("#p_owner_lastname").css("border","1px solid #fc8989");
            $("#p_owner_lastname_error").parent().css("display","block");
            $("#p_owner_lastname_error").html("Please Do Not Exceed 25 Characters");
            errorFlag = true;
        }

    }
    if(address1 == ""){
        $("#address1").css("border","1px solid #fc8989");
        $("#address1_error").parent().css("display","block");
        $("#address1_error").html("Please enter the address line1");
		
        errorFlag = true;
    }
    if(p_state == "" || p_state == "--Choose State--"){
        $("#m_state").css("border","1px solid #fc8989");
        $("#p_state_error").parent().css("display","block");
        $("#p_state_error").html("Please select the state");
        errorFlag = true;
    }

    if(p_city == "" || p_city == "--Choose City--"){
        $("#m_city").css("border","1px solid #fc8989");
        $("#p_city_error").parent().css("display","block");
        $("#p_city_error").html("Please select the city");
        errorFlag = true;
    }
    if((p_phone=="Enter Your Phone Number" && p_mobile=="Enter Your Mobile Number") || (p_phone!="Enter Your Phone Number" || p_mobile!="Enter Your Mobile Number")){
        if(!validate_Phone(p_phone) && !validate_Mobilephone(p_mobile)){
            $("#p_mobile").css("border","1px solid #fc8989");
            $("#p_mobile_error").html("Please enter mobile number as xxx-xxx-xxxx Digit format");
            $("#p_mobile_error").parent().css("display","block");
            $("#p_phone").css("border","1px solid #fc8989");
            $("#p_phone_error").parent().css("display","block");
            $("#p_phone_error").html("Please enter phone number as xxx-xxx-xxxx Digit format");
            errorFlag = true;
        }
    }




    if(p_fax == "" || p_fax == "Enter Your Fax Number"){
        $("#p_fax").css("border","1px solid #fc8989");
        $("#p_fax_error").parent().css("display","block");
        $("#p_fax_error").html("Please enter fax number");
        errorFlag = true;
    }
    else if(isNaN(p_fax)){
        $("#p_fax").css("border","1px solid #fc8989");
        $("#p_fax_error").parent().css("display","block");
        $("#p_fax_error").html("Please enter fax number");
        errorFlag = true;
    }

    if(web_addrs == "" || web_addrs== "Enter The URL Of Your Website"){
        $("#web_addrs").css("border","1px solid #fc8989");
        $("#web_addrs_error").parent().css("display","block");
        $("#web_addrs_error").html("Please enter the web address");
        errorFlag = true;
    }
    else if(!ValidateWebsiteAddress(web_addrs)){
        $("#web_addrs").css("border","1px solid #fc8989");
        $("#web_addrs_error").parent().css("display","block");
        $("#web_addrs_error").html("Please enter the valid web address");
        errorFlag = true;
    }
    else if(!ValidateWebAddress(web_addrs)){
        $("#web_addrs").css("border","1px solid #fc8989");
        $("#web_addrs_error").parent().css("display","block");
        $("#web_addrs_error").html("Please enter the valid web address");
        errorFlag = true;
    }
    if(p_zipcode == "Enter Zip Code"){
        $("#p_zipcode").css("border","1px solid #fc8989");
        $("#p_zipcode_error").parent().css("display","block");
        $("#p_zipcode_error").html("Please enter the Zipcode");
        errorFlag = true;
    }
    else if(!validateZipcode(p_zipcode)){
        $("#p_zipcode").css("border","1px solid #fc8989");
        $("#p_zipcode_error").html("Please enter the valid Zipcode");
        $("#p_zipcode_error").parent().css("display","block");
        errorFlag = true;
    }
   
		
    if(p_country == "" || p_country == "--Choose Country--"){
        //$(".selectBoxProvider").css("background","url('/assets/register/select_box_error.png') no-repeat");
        $("#m_country").css("border","1px solid #fc8989");
        $("#p_country_error").parent().css("display","block");
        $("#p_country_error").html("Please select the country");
        errorFlag = true;
    }

    /*    if(p_time =="" || p_time!= "--Choose Time Zone--"){
        $(".selectBoxProvider").css("background","url('/assets/register/select_box_error.png') no-repeat");
        $(".selectBoxPTime").css("border","1px solid #fc8989");
        $("#p_time_error").parent().css("display","block");
        $("#p_time_error").html("Please select the time zone");
        errorFlag = true;
    }
*/   if (agree_provider == ""){
        $('#p_checkbox_error').css('display','block');
        $('#p_checkbox_normal').css('display','none');
        $("#agree_provider_error").html("Please Check The Terms Of Service");
        $("#agree_provider_error").parent().css("display","block");
        //$("#p_checkbox_normal").css("border","1px solid #fc8989");
        errorFlag = true;
    }

	
    if(errorFlag){	
        return false;
    }
    else{
        return true;
    }
  
}
function validateName(elementValue){
    var alphaExp = /^[a-zA-Z ]*$/;
    return alphaExp.test(elementValue);
}
function validate_Phone(elementValue){
    var characterReg = /^[0-9]\d{2}-\d{3}-\d{4}$/;
    return characterReg.test(elementValue);
}
function validate_Mobilephone(elementValue){
    var characterReg = /^[0-9]\d{2}-\d{3}-\d{4}$/;
    return characterReg.test(elementValue);
}

function validateZipcode(elementValue){
    var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
    return numericReg.test(elementValue);
}

function ValidateWebsiteAddress() {
    var url = document.getElementById('web_addrs').value;
    var urlIsValid =       ValidateWebAddress(url);      //alert("Website Address is valid?:" +urlIsValid );
    return urlIsValid ;
}
    

function ValidateWebAddress(url) {
    var webSiteUrlExp = /^(([\w]+:)?\/\/)?(([\d\w]|%[a-fA-f\d]{2,2})+(:([\d\w]|%[a-fA-f\d]{2,2})+)?@)?([\d\w][-\d\w]{0,253}[\d\w]\.)+[\w]{2,4}(:[\d]+)?(\/([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)*(\?(&?([-+_~.\d\w]|%[a-fA-f\d]{2,2})=?)*)?(#([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)?$/;
    if (webSiteUrlExp.test(url)) {
        return true;
    }
    else {
        return false;
    }
}





function validateBrowse(){
    var fup = document.getElementById('browse_photo');
	
    var fileName = fup.value;
    var ext = fileName.substring(fileName.lastIndexOf('.') + 1);
    if(ext == "gif" || ext == "GIF" || ext == "JPEG" || ext == "jpeg" || ext == "jpg" || ext == "JPG" || ext == "png" || ext == "PNG")
    {
        //errorFlag = false;
        return true;
    }
    else
    {        
        $('#b_logo_error').parent().css("display","block");
        $("#browse_photo").css("border","1px solid #fc8989");
        $('#b_logo_error').html('Please Check The Format Of Your Logo');
        return false;
    }
}  

function validatePhone(txtPhone) {
    var filter = /^[0-9-+]+$/;
    return filter.test(txtPhone);
}
function validateMobile(txtMobile) {
    var filter1 = /^[0-9-+]+$/;
    return filter1.test(txtMobile);
}
function validateDot(elementValue) {
    var emailSplitat = elementValue.split("@");
    var emailSplitdotf = emailSplitat[0].split(".");
    var emailSplitdotl = emailSplitat[1].split(".");
  	 
    if(emailSplitat[0].length<4){
        return false;
    }
  	  	
    if(emailSplitdotf.length>3){
        return false;
    }
    if(emailSplitdotf.length<3){
        var filter = /[^a-z/g]+/gi;
        var filter1 = /^[0-9]+$/;
        if(filter.test( emailSplitdotf) && filter1.test( emailSplitdotf)){
            return false;
        }
    }
    if(emailSplitdotl.length>1){
        var prev = emailSplitdotl[0];
        var curr = emailSplitdotl[1];
        for(var i=1;i<emailSplitdotl.length;i++){
            if(prev == curr ){
                return false;
            }
            prev = curr;
            curr = 	emailSplitdotl[i+1];
        }
    }
    if(emailSplitdotl.length>3){
        return false;
    }
    return true;
}


function addressLine2(){
	
    if(address2 == ""){
        $("#address2").css("border","1px solid #fc8989");
        $("#address2_error").parent().css("display","block");
        $("#address2_error").html("Please enter the address line1");
    //$("#city_height").css("margin-top","18px");
    // errorFlag = true;
    }
}
/*************set country wise state**************/



/*************set state wise cities**************/
dropDownDiv1 = '';
function setStateProviderValue(val){
    document.getElementById("p_state").value=val;
    document.getElementById("p_Statefield").innerHTML=val;
    document.getElementById("p_Statefield").style.color='#444444';
    $(".ProviderCenterContent .selectBoxPState").css("border","none");
    $("#p_state_error").html("");
    dropDownDiv1 = '';
    switch(val){
		
        case "Alabama":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Birmingham\')" title="">Birmingham</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Huntsville\')" title="">Huntsville</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Montgomery\')" title="">Montgomery</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Mobile\')" title="">Mobile</a>';
            
            break;
			
        case "Alaska":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Anchorage\')" title="">Anchorage</a>';
            break;
	    
        case "Arizona":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Chandler\')" title="">Chandler</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Glendale\')" title="">Glendale</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Gilbert\')" title="">Gilbert</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Mesa\')" title="">Mesa</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Peoria\')" title="">Peoria</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Phoenix\')" title="">Phoenix</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Scottsdale\')" title="">Scottsdale</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Surprise\')" title="">Surprise</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Tempe\')" title="">Tempe</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Tucson\')" title="">Tucson</a>';
            break;
		   
        case "Arkansas":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Little Rock\')" title="">Little Rock</a>';
            break;

        case "California":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Anaheim\')" title="">Anaheim</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Antioch\')" title="">Antioch</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Bakersfield\')" title="">Bakersfield</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Berkeley\')" title="">Berkeley</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Burbank\')" title="">Burbank</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Carlsbad\')" title="">Carlsbad</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Chula Vista\')" title="">Chula Vista</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Concord\')" title="">Concord</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Corona\')" title="">Corona</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Costa Mesa\')" title="">Costa Mesa</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Daly City\')" title="">Daly City</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Downey\')" title="">Downey</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'El Monte\')" title="">El Monte</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Elk Grove\')" title="">Elk Grove</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Escondido\')" title="">Escondido</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Fairfield\')" title="">Fairfield</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Fontana\')" title="">Fontana</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Fremont\')" title="">Fremont</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Fresno\')" title="">Fresno</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Fullerton\')" title="">Fullerton</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Garden Grove\')" title="">Garden Grove</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Glendale\')" title="">Glendale</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Hayward\')" title="">Hayward</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Huntington Beach\')" title="">Huntington Beach</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Inglewood\')" title="">Inglewood</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Irvine\')" title="">Irvine</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Lancaster\')" title="">Lancaster</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Los Angeles\')" title="">Los Angeles</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Long Beach\')" title="">Long Beach</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Modesto\')" title="">Modesto</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Moreno Valley\')" title="">Moreno Valley</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Murrieta\')" title="">Murrieta</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Norwalk\')" title="">Norwalk</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Oakland\')" title="">Oakland</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Oceanside\')" title="">Oceanside</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Ontario\')" title="">Ontario</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Orange\')" title="">Orange</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Oxnard\')" title="">Oxnard</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Palmdale\')" title="">Palmdale</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Pasadena\')" title="">Pasadena</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Pomona\')" title="">Pomona</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Rancho Cucamonga\')" title="">Rancho Cucamonga</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Richmond\')" title="">Richmond</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Riverside\')" title="">Riverside</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'San Bernardino\')" title="">San Bernardino</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'San Diego\')" title="">San Diego</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'San Francisco\')" title="">San Francisco</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Sacramento\')" title="">Sacramento</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Santa Ana\')" title="">Santa Ana</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Santa Clarita\')" title="">Santa Clarita</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Santa Rosa\')" title="">Santa Rosa</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Salinas\')" title="">Salinas</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Santa Clara\')" title="">Santa Clara</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'San Jose\')" title="">San Jose</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Simi Valley\')" title="">Simi Valley</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Stockton\')" title="">Stockton</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Sunnyvale\')" title="">Sunnyvale</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Temecula\')" title="">Temecula</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Thousand Oaks\')" title="">Thousand Oaks</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Torrance\')" title="">Torrance</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Vallejo\')" title="">Vallejo</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Ventura\')" title="">Ventura</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Visalia\')" title="">Visalia</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Victorville\')" title="">Victorville</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'West Covina\')" title="">West Covina</a>';
            break;
		   
        case "Colorado":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Arvada\')" title="">Arvada</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Aurora\')" title="">Aurora</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Centennial\')" title="">Centennial</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Colorado Springs\')" title="">Colorado Springs</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Denver\')" title="">Denver</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Fort Collins\')" title="">Fort Collins</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Lakewood\')" title="">Lakewood</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Pueblo\')" title="">Pueblo</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Thornton\')" title="">Thornton</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Westminster\')" title="">Westminster</a>';
            break;
		
        case "Connecticut":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Bridgeport\')" title="">Bridgeport</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Hartford\')" title="">Hartford</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'New Haven\')" title="">New Haven</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Stamford\')" title="">Stamford</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Waterbury\')" title="">Waterbury</a>';
            break;
		
        case "District of Columbia":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Washington\')" title="">Washington</a>';
            break;
		
        case "Florida":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Cape Coral\')" title="">Cape Coral</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Clearwater\')" title="">Clearwater</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Coral Springs\')" title="">Coral Springs</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Colorado Springs\')" title="">Colorado Springs</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Fort Lauderdale\')" title="">Fort Lauderdale</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Gainesville\')" title="">Gainesville</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Hialeah\')" title="">Hialeah</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Hollywood\')" title="">Hollywood</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Miami Gardens\')" title="">Miami Gardens</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Miramar\')" title="">Miramar</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Orlando\')" title="">Orlando</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Palm Bay\')" title="">Palm Bay</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Pembroke Pines\')" title="">Pembroke Pines</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Port St. Lucie\')" title="">Port St. Lucie</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'St. Petersburg\')" title="">St. Petersburg</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Tallahassee\')" title="">Tallahassee</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Tampa\')" title="">Tampa</a>';

            break;
		
        case "Georgia":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Atlanta\')" title="">Atlanta</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Athens\')" title="">Athens</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Augusta \')" title="">Augusta</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Columbus\')" title="">Columbus</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Savannah\')" title="">Savannah</a>';
            break;
		
        case "Hawaii":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Honolulu\')" title="">Honolulu</a>';
            break;
		
        case "Idaho":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Boise\')" title="">Boise</a>';
            break;
		
        case "Illinois":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Aurora\')" title="">Aurora</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Chicago\')" title="">Chicago</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Elgin \')" title="">Elgin</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Joliet\')" title="">Joliet</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Naperville\')" title="">Naperville</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Peoria \')" title="">Peoria</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Rockford\')" title="">Rockford</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Springfield\')" title="">Springfield</a>';
            break;
		
        case "Indiana":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Evansville\')" title="">Evansville</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Indianapolis\')" title="">Indianapolis</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Fort Wayne \')" title="">Fort Wayne</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'South Bend\')" title="">South Bend</a>';
            break;

        case "Iowa":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Cedar Rapids\')" title="">Cedar Rapids</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Des Moines\')" title="">Des Moines</a>';
            break;

        case "Kansas":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Olathe\')" title="">Olathe</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Overland Park\')" title="">Overland Park</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Kansas City \')" title="">Kansas City</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Topeka\')" title="">Topekad</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Wichita\')" title="">Wichita</a>';
            break;


        case "Kentucky":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Lexington\')" title="">Lexington</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Louisville\')" title="">Louisville</a>';
            break;


        case "Louisiana":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Baton Rouge\')" title="">Baton Rouge</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Lafayette\')" title="">Lafayette</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'New Orleans \')" title="">New Orleans</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Shreveport\')" title="">Shreveport</a>';
            break;


        case "Maryland":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Baltimore\')" title="">Baltimore</a>';
            break;


        case "Massachusetts":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Boston\')" title="">Boston</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Cambridge\')" title="">Cambridge</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Lowell \')" title="">Lowell</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Springfield\')" title="">Springfield</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Worcester\')" title="">Worcester</a>';
            break;
		
        case "Michigan":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Ann Arbor\')" title="">Ann Arbor</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Detroit\')" title="">Detroit</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Flint \')" title="">Flint</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Grand Rapids\')" title="">Grand Rapids</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Lansing\')" title="">Lansing</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Sterling Heights\')" title="">Sterling Heights</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Warren\')" title="">Warren</a>';
            break;

        case "Massachusetts":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Boston\')" title="">Boston</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Cambridge\')" title="">Cambridge</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Lowell \')" title="">Lowell</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Springfield\')" title="">Springfield</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Worcester\')" title="">Worcester</a>';
            break;

        case "Minnesota":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Minneapolis\')" title="">Minneapolis</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Rochester\')" title="">Rochester</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'St. Paul \')" title="">St. Paul</a>';
            break;

        case "Mississippi":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Jackson\')" title="">Jackson</a>';
            break;

        case "Missouri":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Columbia\')" title="">Columbia</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Independence\')" title="">Independence</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Kansas City \')" title="">Kansas City</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Springfield\')" title="">Springfield</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'St. Louis\')" title="">St. Louis</a>';
            break;

        case "Montana":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Billings\')" title="">Billings</a>';
            break;

        case "Nebraska":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Lincoln\')" title="">Lincoln</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Omaha\')" title="">Omaha</a>';
            break;
		
        case "Nevada":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Henderson\')" title="">Henderson</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Las Vegas\')" title="">Las Vegas</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'North Las Vegas \')" title="">North Las Vegas</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Reno\')" title="">Reno</a>';
            break;

        case "New Hampshire":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Manchester\')" title="">Manchester</a>';
            break;
		
        case "New Jersey":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Elizabeth\')" title="">Elizabeth</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Jersey City\')" title="">Jersey City</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Newark\')" title="">Newark</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Paterson\')" title="">Paterson</a>';
            break;

        case "New Mexico":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Albuquerque\')" title="">Albuquerque</a>';
            break;

        case "New York":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Buffalo\')" title="">Buffalo</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'New York\')" title="">New York</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Rochester\')" title="">Rochester</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Syracuse\')" title="">Syracuse</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Yonkers\')" title="">Yonkers</a>';
            break;

        case "North Carolina":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Cary\')" title="">Cary</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Charlotte\')" title="">Charlotte</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Durham\')" title="">Durham</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Fayetteville\')" title="">Fayetteville</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Greensboro\')" title="">Greensboro</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'High Point\')" title="">High Point</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Raleigh\')" title="">Raleigh</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Wilmington\')" title="">Wilmington</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Winston-Salem\')" title="">Winston-Salem</a>';
            break;

        case "North Dakota":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Fargo\')" title="">Fargo</a>';
            break;

        case "Ohio":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Akron\')" title="">Akron</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Cincinnati\')" title="">Cincinnati</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Cleveland\')" title="">Cleveland</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Columbus\')" title="">Columbus</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Dayton\')" title="">Dayton</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Toledo\')" title="">Toledo</a>';
            break;
        case "Oklahoma":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Norman\')" title="">Norman</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Oklahoma City\')" title="">Oklahoma City</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Tulsa\')" title="">Tulsa</a>';
            break;
        case "Oregon":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Eugene\')" title="">Eugene</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Gresham\')" title="">Gresham</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Portland\')" title="">Portland</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Salem\')" title="">Salem</a>';
            break;
		
        case "Pennsylvania":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Allentown\')" title="">Allentown</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Erie\')" title="">Erie</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Philadelphia\')" title="">Philadelphia</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Pittsburgh\')" title="">Pittsburgh</a>';
            break;

        case "Rhode Island":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Providence\')" title="">Providence</a>';
            break;
        case "South Carolina":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Charleston\')" title="">Charleston</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Columbia\')" title="">Columbia</a>';

            break;
        case "South Dakota":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Sioux Falls\')" title="">Sioux Falls</a>';
            break;
        case "Tennessee":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Chattanooga\')" title="">Chattanooga</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Clarksville\')" title="">Clarksville</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Knoxville\')" title="">Knoxville</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Memphis\')" title="">Memphis</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Murfreesboro\')" title="">Murfreesboro</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Nashville\')" title="">Nashville</a>';
            break;
		
        case "Texas":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Abilene\')" title="">Abilene</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Amarillo\')" title="">Amarillo</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Arlington\')" title="">Arlington</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Austin\')" title="">Austin</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Beaumont\')" title="">Beaumont</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Brownsville\')" title="">Brownsville</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Carrollton\')" title="">Carrollton</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Corpus Christi\')" title="">Corpus Christi</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Dallas\')" title="">Dallas</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Denton\')" title="">Denton</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'El Paso\')" title="">El Paso</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Fort Worth\')" title="">Fort Worth</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Frisco\')" title="">Frisco</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Garland\')" title="">Garland</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Grand Prairie\')" title="">Grand Prairie</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Houston\')" title="">Houston</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Irving\')" title="">Irving</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Killeen\')" title="">Killeen</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Laredo\')" title="">Laredo</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Lubbock\')" title="">Lubbock</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Mesquite\')" title="">Mesquite</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'McAllen\')" title="">McAllen</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'McKinney\')" title="">McKinney</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Midland\')" title="">Midland</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Pasadena\')" title="">Pasadena</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Plano\')" title="">Plano</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'San Antonio\')" title="">San Antonio</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Waco\')" title="">Waco</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Wichita Falls\')" title="">Wichita Falls</a>';
            break;

        case "Utah":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Provo\')" title="">Provo</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Salt Lake City\')" title="">Salt Lake City</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'West Jordan\')" title="">West Jordan</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'West Valley City\')" title="">West Valley City</a>';
            break;

        case "Virginia":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Alexandria\')" title="">Alexandria</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Arlington\')" title="">Arlington</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Chesapeake\')" title="">Chesapeake</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Hampton\')" title="">Hampton</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Newport News\')" title="">Newport News </a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Norfolk\')" title="">Norfolk</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Richmond\')" title="">Richmond</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Virginia Beach\')" title="">Virginia Beach</a>';
            break;

        case "Washington":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Bellevue\')" title="">Bellevue</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Everett\')" title="">Everett</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Tacoma\')" title="">Tacoma</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Seattle\')" title="">Seattle</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Spokane\')" title="">Spokane</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Vancouver\')" title="">Vancouver</a>';
            break;
		

        case "Wisconsin":
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Green Bay\')" title="">Green Bay</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Madison\')" title="">Madison</a>';
            dropDownDiv1 += '<a href="javascript:void(0)" onclick="setDropDownValueReg1(\'Milwaukee\')" title="">Milwaukee</a>';
            break;


    }
    document.getElementById("dropDownDiv1").innerHTML=dropDownDiv1;
    document.getElementById("p_city").value="--Choose City--";
    document.getElementById("p_Cityfield").innerHTML="--Choose City--";
}
function setDropDownValueReg1(val){
    document.getElementById("p_city").value=val;
    document.getElementById("p_Cityfield").innerHTML=val;
    document.getElementById("p_Cityfield").style.color='#444444';
    document.getElementById("dropDownDiv1").style.display="none";
    $(".ProviderCenterContent .selectBoxPCity").css("border","none");
    $("#p_city_error").html("");
}


dropDownDiv = '';
function setCountryProviderValue(val){
    document.getElementById("p_country").value=val;
    document.getElementById("p_Countryfield").innerHTML=val;
    document.getElementById("p_Countryfield").style.color='#444444';
    document.getElementById("dropDownDiv2").style.display="none";
    $(".selectBoxPCountry").css("border","none");
    $("#p_country_error").html("");
    dropDownDiv= '';
    switch(val){
        case "United States":
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Alabama\')" title="">Alabama</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Alaska\')" title="">Alaska</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Arizona\')" title="">Arizona</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Arkansas\')" title="">Arkansas</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'California\')" title="">California</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Colorado\')" title="">Colorado</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Connecticut\')" title="">Connecticut</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'District of Columbia\')" title="">District of Columbia</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Florida\')" title="">Florida</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Georgia\')" title="">Georgia</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Hawaii\')" title="">Hawaii</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Idaho\')" title="">Idaho</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Illinois\')" title="">Illinois</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Indiana\')" title="">Indiana</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Iowa\')" title="">Iowa</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Kansas\')" title="">Kansas</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Kentucky\')" title="">Kentucky</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Louisiana\')" title="">Louisiana</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Maryland\')" title="">Maryland</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Massachusetts\')" title="">Massachusetts</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Michigan\')" title="">Michigan</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Minnesota\')" title="">Minnesota</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Mississippi\')" title="">Mississippi</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Missouri\')" title="">Missouri</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Montana\')" title="">Montana</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Nebraska\')" title="">Nebraska</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Nevada\')" title="">Nevada</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'New Hampshire\')" title="">New Hampshire</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'New Jersey\')" title="">New Jersey</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'New Mexico\')" title="">New Mexico</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'New York\')" title="">New York</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'North Carolina\')" title="">North Carolina</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'North Dakota\')" title="">North Dakota</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Ohio\')" title="">Ohio</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Oklahoma\')" title="">Oklahoma</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Oregon\')" title="">Oregon</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Pennsylvania\')" title="">Pennsylvania</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Rhode Island\')" title="">Rhode Island</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'South Carolina\')" title="">South Carolina</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'South Dakota\')" title="">South Dakota</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Tennessee\')" title="">Tennessee</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Texas\')" title="">Texas</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Utah\')" title="">Utah</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Virginia\')" title="">Virginia</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Washington\')" title="">Washington</a>';
            dropDownDiv += '<a href="javascript:void(0)" onclick="setDropDownStateValue(\'Wisconsin\')" title="">Wisconsin</a>';
            break;
			
    /*        case "India":
			dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Birmingham\')" title="">Birmingham</a>';
			dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Huntsville\')" title="">Huntsville</a>';
			dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Montgomery\')" title="">Montgomery</a>';
			dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Mobile\')" title="">Mobile</a>';
            
            break;
*/	}
    document.getElementById("dropDownDiv").innerHTML=dropDownDiv;
    document.getElementById("p_state").value="--Choose State--";
    document.getElementById("p_Statefield").innerHTML="--Choose State--";
}
function setDropDownStateValue(val){
    document.getElementById("p_state").value=val;
    document.getElementById("p_Statefield").innerHTML=val;
    document.getElementById("p_Statefield").style.color='#444444';
    document.getElementById("dropDownDiv2").style.display="none";
    $(".selectBoxCityBankReg").css("border","none");
    $("#p_state_error").html("");
	
    setStateProviderValue(val);
}

/** Clear the login form text fields **/
function clearData(){
    $("#username_usr").val("Eg:john");
    $("#username_usr").css("color","#999999");
    $("#p_name").val("");
    $("#p_email").val("");
    $("#b_name").val("");
    $("#email_usr").val("Eg:john@gmail.com");
    $("#email_usr").css("color","#999999");
    $("#password_usr").val("password");
    $("#p_password").val("");
    $("#p_confirm_password").val("");
    $("#confirm_password_usr").val("password");
    $("#p_owner_firstname").val("First Name");
    $("#p_owner_firstname").css("color","#999999");
    $("#p_owner_lastname").val("Last Name");
    $("#p_owner_lastname").css("color","#999999");
    $("#browse_photo").val();
    $("#browse_photo_spo").val();
    $("#p_admin_firstname").val("");
    $("#p_admin_lastname").val("");
    $("#admin_provider").val("");
    $("#reg_me_usr").val("Select");
    $("#b_logo").val("");
    $("#p_time").val("--Choose Time Zone--");
    $("#p_time").css("color","#999999");
    // $("#p_owner").val("");
    /*$("#p_admin").val("");*/
    $("#web_addrs").val("");
    $("#p_language").val("Select");
    $("#address1").val("");
    $("#address2").val("");
    $("#p_zipcode").val("Enter Zip Code");
    $("#p_zipcode").css("color","#999999");
    $("#p_city").val("--Choose City--");
    $("#p_state").val("--Choose State--");
    $("#p_country").val("--Choose Country--");
    $("#browse_photo").val("");
    $("#p_Cityfield").html("--Choose City--");
    $("#p_Statefield").html("--Choose State--");
    $("#p_Countryfield").html("--Choose Country--");
    $("#p_timefield").html("--Choose Time Zone--");
    
    $("#web_addrs").val("Enter The URL Of Your Website");
    $("#web_addrs").css("color","#999999");
    $("#p_mobile").val("Enter Your Mobile Number");
    $("#p_mobile").css("color","#999999");
    $("#p_phone").val("Enter Your Phone Number");
    $("#p_phone").css("color","#999999");
    $("#p_name").val("Eg: John Smith");
    $("#p_name").css("color","#999999");
    $("#p_email").val("Eg:john@gmail.com");
    $("#p_email").css("color","#999999");
    $("#b_name").val("Enter the Name Of your business");
    $("#b_name").css("color","#999999");
    $("#p_fax").val("Enter Your Fax Number");
    $("#p_fax").css("color","#999999");
    //$("#language_field").html("Select");
    $("#city_height").css("margin-top","0px");

    $("#p_Countryfield").css("color","#999999");
    $("#p_Statefield").css("color","#999999");
    $("#p_Cityfield").css("color","#999999");
    $("#p_timefield").css("color","#999999");
    //$(".ProviderCenterContent .selectBoxPCountry .selectDiv").css("color","#444444");

    $("#reg_me_field").html("Select");
    $('#agree_usr').val('');
    $(".selectBoxCity").css("border","1px solid #BDD6DD");
    $(".selectBoxProvider").css("border","1px solid #BDD6DD");
    $(".selectBoxLanguage").css("border","1px solid #BDD6DD");
    $(".selectBoxPCountry").css("border","1px solid #BDD6DD");
    $("#browse_photo").css("border","1px solid #BDD6DD");
    $('#checkbox_error').css('display','none');
    $('#checkbox_selected').css('display','none');
    $('#checkbox_normal').css('display','block');
    $('#p_checkbox_error').css('display','none');
    $('#p_checkbox_selected').css('display','none');
    $('#p_checkbox_normal').css('display','block');
    $('#p_checkboxInternal_selected').css('display','none');
    $('#p_checkboxInternal_error').css('display','none');
    $('#p_checkboxInternal_normal').css('display','block');
    $("#p_name").css("border","1px solid #BDD6DD");
    //$("#username_usr").css("border","1px solid #BDD6DD");
    $("#b_name").css("border","1px solid #BDD6DD");
    $("#email_usr").css("border","1px solid #BDD6DD");
    $("#password_usr").css("border","1px solid #BDD6DD");
    $("#p_password").css("border","1px solid #BDD6DD");
    $("#p_confirm_password").css("border","1px solid #BDD6DD");
    $("#confirm_password_usr").css("border","1px solid #BDD6DD");
    $("#p_email").css("border","1px solid #BDD6DD");
    $("#p_owner_firstname").css("border","1px solid #BDD6DD");
    $("#p_owner_lastname").css("border","1px solid #BDD6DD");
    $("#p_admin_firstname").css("border","1px solid #BDD6DD");
    $("#p_admin_lastname").css("border","1px solid #BDD6DD");
    $("#p_phone").css("border","1px solid #BDD6DD");
    $("#p_mobile").css("border","1px solid #BDD6DD");
    $("#p_fax").css("border","1px solid #BDD6DD");
    $("#b_name").css("border","1px solid #BDD6DD");
    $("#b_logo").css("border","1px solid #BDD6DD");
    $("#p_owner").css("border","1px solid #BDD6DD");
    $("#p_admin").css("border","1px solid #BDD6DD");
    $("#p_language").css("border","1px solid #BDD6DD");
    $("#web_addrs").css("border","1px solid #BDD6DD");
    $("#address1").css("border","1px solid #BDD6DD");
    $("#address2").css("border","1px solid #BDD6DD");
    $("#p_zipcode").css("border","1px solid #BDD6DD");
    $("#p_city").css("border","1px solid #BDD6DD");
    $("#p_state").css("border","1px solid #BDD6DD");
    $("#p_country").css("border","1px solid #BDD6DD");
    $(".selectBoxPCountry").css("border","none");
    $(".selectBoxPState").css("border","none");
    $(".selectBoxPCity").css("border","none");
    $(".selectBoxLanguage").css("border","none");
    $("#activity_photo").css("border","1px solid #BDD6DD");
    $(".selectBoxFax").css("border","none");
    $("#activity_photo").css("border","1px solid #BDD6DD");
    $("#browse_photo_spo").css("border","1px solid #BDD6DD");
    $(".selectBoxPTime").css("border","none");
	
	
	
	
    // $("#username_usr_error").html("");
    $("#P_name_error").html("");
    $("#b_name_error").html("");
    $("#p_email_error").html("");
    $("#email_usr_error").html("");
    $("#password_usr_error").html("");
    $("#p_password_error").html("");
    $("#p_confirm_password_error").html("");
    $("#confirm_assword_usr_error").html("");
    $("#reg_me_usr_error").html("");
    $("#p_phone_error").html("");
    $("#p_mobile_error").html("");
    $("#p_fax_error").html("");
    $("#b_logo_error").html("");
    $("#p_owner_error").html("");
    $("#p_admin_error").html("");
    $("#p_language_error").html("");
    $("#web_addrs_error").html("");
    $("#agree_usr_error").html("");
    $("#address1_error").html("");
    $("#address2_error").html("");
    $("#p_zipcode_error").html("");
    $("#p_language_error").html("");
    $("#p_city_error").html("");
    $("#p_state_error").html("");
    $("#p_country_error").html("");
    $("#agree_provider_error").html("");
    $(".msg").html("");
    $("#p_owner_firstname_error").html("");
    $("#p_owner_lastname_error").html("");
    $("#p_admin_firstname_error").html("");
    $("#p_admin_lastname_error").html("");
    $("#admin_provider_error").html("");
    //$("#p_time_error").css("border","1px solid #BDD6DD");
    
	
    $('#admin_checkbox_normal').css('display','block');
    $('#admin_checkbox_error').css('display','none');
    $('#admin_checkbox_selected').css('display','none');
	


    // $("#username_usr_error").parent().css("display","none");
    $("#p_name_error").parent().css("display","none");
    $("#b_name_error").parent().css("display","none");
    $("#email_usr_error").parent().css("display","none");
    $("#password_usr_error").parent().css("display","none");
    $("#p_password_error").parent().css("display","none");
    $("#p_confirm_password_error").parent().css("display","none");
    $("#confirm_password_usr_error").parent().css("display","none");
    $("#agree_usr_error").parent().css("display","none");
    $("#reg_me_usr_error").parent().css("display","none");
    $("#p_phone_error").parent().css("display","none");
    $("#p_mobile_error").parent().css("display","none");
    $("#p_fax_error").parent().css("display","none");
    $("#p_owner_error").parent().css("display","none");
    $("#p_admin_error").parent().css("display","none");
    $("#web_addrs_error").parent().css("display","none");
    $("#agree_usr_error").parent().css("display","none");
    $("#address1_error").parent().css("display","none");
    $("#address2_error").parent().css("display","none");
    $("#p_zipcode_error").parent().css("display","none");
    $("#p_language_error").parent().css("display","none");
    $("#p_city_error").parent().css("display","none");
    $("#p_state_error").parent().css("display","none");
    $("#p_country_error").parent().css("display","none");
    $("#agree_provider_error").parent().css("display","none");
    $("#p_email_error").parent().css("display","none");
    $("#b_logo_error").parent().css("display","none");
    $("#p_time_error").parent().css("display","none");
    // $(".set_height").css("height","99px");
	
	
	
	
    /** onfocus the text box to change border color **/
    $('input[type="text"]').focus(function() {
        $(this).css("border","1px solid #9fd8eb");
    });

    /** onblur the text box to change border color **/
    $('input[type="text"]').blur(function() {
        $(this).css("border","1px solid #BDD6DD");
    });
	
    /** onfocus the password text box to change border color **/
    $('input[type="password"]').focus(function() {
        $(this).css("border","1px solid #9fd8eb");
    });
 
    /** onblur the password text box to change border color **/
    $('input[type="password"]').blur(function() {
        $(this).css("border","1px solid #BDD6DD");
    });
	
//location.href = "/landing"
}
function setRegisterProviderValue(val1,val2){	
    document.getElementById("p_fax").value=val1;
    document.getElementById("p_field").innerHTML=val2.innerHTML;
    selectedregion=val2.rel;
    document.getElementById("dropDownDiv").style.display="none";
			
}
function setRegisterLanguageValue(val1,val2){	
    document.getElementById("p_fax").value=val1;
    document.getElementById("p_field").innerHTML=val2.innerHTML;
    selectedregion=val2.rel;
    document.getElementById("dropDownDiv").style.display="none";
			
}
function setLanguageUserValue(val1,val2){	
    document.getElementById("p_language").value=val1;
    document.getElementById("language_field").innerHTML=val2.innerHTML;
    selectedregion=val2.rel;
    document.getElementById("dropDownDiv1").style.display="none";
    $(".selectBoxLanguage").css("border","none");
    $("#p_language_error").html("");
			
}
/*function setCityProviderValue(val1,val2){	
    document.getElementById("p_city").value=val1;
    document.getElementById("p_Cityfield").innerHTML=val2.innerHTML;
    selectedregion=val2.rel;
    document.getElementById("dropDownDiv1").style.display="none";
    $(".selectBoxPCity").css("border","none");
    $("#p_city_error").html("");
			
}
function setStateProviderValue1(val1,val2){
    document.getElementById("p_state").value=val1;
    document.getElementById("p_Statefield").innerHTML=val2.innerHTML;
    selectedregion=val2.rel;
    document.getElementById("dropDownDiv").style.display="none";
    $(".selectBoxPState").css("border","none");
    $("#p_state_error").html("");
			
}
function setCountryProviderValue(val1,val2){	
    document.getElementById("p_country").value=val1;
    document.getElementById("p_Countryfield").innerHTML=val2.innerHTML;
    $("#p_country_error").css("display","none");
    document.getElementById("dropDownDiv3").style.display="none";
    $(".selectBoxPCountry").css("border","none");
    $("#p_country_error").html("");
			
}*/
function setTimeProviderValue(val1,val2){

    document.getElementById("p_time").value=val1;
    document.getElementById("p_timefield").innerHTML=val2.innerHTML;
    document.getElementById("p_timefield").style.color='#444444';
    $("#p_country_error").css("display","none");
    document.getElementById("dropDownDiv3").style.display="none";
    $(".selectBoxPTime").css("border","none");
    $("#p_time_error").html("");
			
}

var flag;
/*function selectLanguageUsrKeyDown(e){
    //alert("test");
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13){    	
        document.getElementById("dropDownDiv").style.display="block";
        flag=false;
    }	
    else{
        document.getElementById("dropDownDiv").style.display="none";
        flag=true;
    }
}*/

function selectCityUsrKeyDown(e){
    //alert("test");
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13){   
        document.getElementById("dropDownDiv1").style.display="block";
        document.getElementById("dropDownDiv").style.display="none";
        document.getElementById("dropDownDiv2").style.display="none";
        document.getElementById("dropDownDiv3").style.display="none";
        flag=false;
    }	
    else{
        document.getElementById("dropDownDiv1").style.display="none";
        flag=true;
    }
}

function selectStateUsrKeyDown(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13){   
        document.getElementById("dropDownDiv").style.display="block";
        document.getElementById("dropDownDiv1").style.display="none";
        document.getElementById("dropDownDiv2").style.display="none";
        document.getElementById("dropDownDiv3").style.display="none";
        flag=false;
    }	
    else{
        document.getElementById("dropDownDiv").style.display="none";
		
        flag=true;
    }
}


function selectCountryUsrKeyDown(e){
    //alert("test");
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13){   
        document.getElementById("dropDownDiv2").style.display="block";
        document.getElementById("dropDownDiv").style.display="none";
        document.getElementById("dropDownDiv1").style.display="none";
        //document.getElementById("dropDownDiv2").style.display="none";
		
        flag=false;
    }	
    else{
        document.getElementById("dropDownDiv2").style.display="none";
        flag=true;
    }
}
    
function selectTimeUsrKeyDown(e){
    //alert("test");
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13){   
        document.getElementById("dropDownDiv3").style.display="block";
        document.getElementById("dropDownDiv").style.display="none";
        document.getElementById("dropDownDiv1").style.display="none";
        document.getElementById("dropDownDiv2").style.display="none";
		
        flag=false;
    }	
    else{
        document.getElementById("dropDownDiv3").style.display="none";
        flag=true;
    }
}
function dispCheckboxImgProvider(imgName){
    //alert(imgName);
    var p_owner_firstname=$("#p_owner_firstname").val();
    var p_owner_lastname=$("#p_owner_lastname").val();
    if(imgName == 'admin_checkbox_normal'){
        //alert(imgName);

        $("#p_admin_firstname").val(p_owner_firstname);
        $("#p_admin_lastname").val(p_owner_lastname);


        $('#admin_checkbox_normal').css('display','none');
        $('#admin_checkbox_error').css('display','none');
        $('#admin_checkbox_selected').css('display','block');
        $('#admin_provider').val(7);
    }
    else if(imgName == 'admin_checkbox_selected'){
        //alert("selected");
        //alert(imgName);
        $("#p_admin_firstname").val('');
        $("#p_admin_lastname").val('');
        $('#admin_checkbox_normal').css('display','block');
        $('#admin_checkbox_error').css('display','none');
        $('#admin_checkbox_selected').css('display','none');
        $('#admin_provider').val(7);
    }
    else if(imgName == 'admin_checkbox_error'){
        $('#admin_checkbox_normal').css('display','none');
        $('#admin_checkbox_error').css('display','none');
        $('#admin_checkbox_selected').css('display','block');
        $("#p_admin_firstname").val(p_owner_firstname);
        $("#p_admin_lastname").val(p_owner_lastname);
        $('#admin_provider').val(7);
    }
    else{
        $('#admin_checkbox_selected').css('display','none');
        $('#admin_checkbox_normal').css('display','block');
        $('#admin_checkbox_error').css('display','none');
        $('#admin_provider').val('');
    }
}



function validateCorrectEmail(elementValue){  
    var emailPattern = /^([a-zA-Z0-9]+([~{|}`^?=+*'#$!%._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,3}(?:\.[a-zA-Z]{2,3})?)$/;
    return emailPattern.test(elementValue);
/*var e = elementValue;
	elementValue = e.trim();
	var filter = /^[A-Za-z0-9][A-Za-z0-9\_\-\.]*\@[A-Za-z0-9][A-Za-z0-9\_\-\.]*\.[A-Za-z]{2,}$/;
	var filter2 = /(\.\.+)|(\@\@+)|(\_\_+)|(\-\-+)/;
	var filter3 = /(\.ac|\.ad|\.ae|\.aero|\.af|\.ag|\.ai|\.al|\.am|\.an|\.ao|\.aq|\.ar|\.arpa|\.as|\.at|\.au|\.aw|\.ax|\.az|\.ba|\.bb|\.bd|\.be|\.bf|\.bg|\.bh|\.bi|\.biz|\.bj|\.bm|\.bn|\.bo|\.br|\.bs|\.bt|\.bv|\.bw|\.by|\.bz|\.ca|\.cat|\.cc|\.cd|\.cf|\.cg|\.ch|\.ci|\.ck|\.cl|\.cm|\.cn|\.co|\.com|\.coop|\.cr|\.cu|\.cv|\.cx|\.cy|\.cz|\.de|\.dj|\.dk|\.dm|\.do|\.dz|\.ec|\.edu|\.ee|\.eg|\.er|\.es|\.et|\.eu|\.fi|\.fj|\.fk|\.fm|\.fo|\.fr|\.ga|\.gb|\.gd|\.ge|\.gf|\.gg|\.gh|\.gi|\.gl|\.gm|\.gn|\.gov|\.gp|\.gq|\.gr|\.gs|\.gt|\.gu|\.gw|\.gy|\.hk|\.hm|\.hn|\.hr|\.ht|\.hu|\.id|\.ie|\.il|\.im|\.in|\.info|\.int|\.io|\.iq|\.ir|\.is|\.it|\.je|\.jm|\.jo|\.jobs|\.jp|\.ke|\.kg|\.kh|\.ki|\.km|\.kn|\.kr|\.kw|\.ky|\.kz|\.la|\.lb|\.lc|\.li|\.lk|\.lr|\.ls|\.lt|\.lu|\.lv|\.ly|\.ma|\.mc|\.md|\.mg|\.mh|\.mil|\.mk|\.ml|\.mm|\.mn|\.mo|\.mobi|\.mp|\.mq|\.mr|\.ms|\.mt|\.mu|\.museum|\.mv|\.mw|\.mx|\.my|\.mz|\.na|\.name|\.nc|\.ne|\.net|\.nf|\.ng|\.ni|\.nl|\.no|\.np|\.nr|\.nu|\.nz|\.om|\.org|\.pa|\.pe|\.pf|\.pg|\.ph|\.pk|\.pl|\.pm|\.pn|\.pr|\.pro|\.ps|\.pt|\.pw|\.py|\.qa|\.re|\.ro|\.ru|\.rw|\.sa|\.sb|\.sc|\.sd|\.se|\.sg|\.sh|\.si|\.sj|\.sk|\.sl|\.sm|\.sn|\.so|\.sr|\.st|\.su|\.sv|\.sy|\.sz|\.tc|\.td|\.tel|\.tf|\.tg|\.th|\.tj|\.tk|\.tl|\.tm|\.tn|\.to|\.tp|\.tr|\.travel|\.tt|\.tv|\.tw|\.tz|\.ua|\.ug|\.uk|\.um|\.us|\.uy|\.uz|\.va|\.vc|\.ve|\.vg|\.vi|\.vn|\.vu|\.wf|\.ws|\.ye|\.yt|\.yu|\.za|\.zm|\.zw)$/i;
	
	
	if( (!filter.test( elementValue ))  || ( filter2.test( elementValue )) || ( !filter3.test( elementValue )) ) {
		return false;
	}	
	return true;*/	
} 

function validateCorrectEmail_sell(elementValue){  
    var emailPattern = /^([a-zA-Z0-9]+([~{|}`^?=+*'#$!%._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,3}(?:\.[a-zA-Z]{2,3})?)$/;
    return emailPattern.test(elementValue);
/*var e = elementValue;
	elementValue = e.trim();
	var filter = /^[A-Za-z0-9][A-Za-z0-9\_\-\.]*\@[A-Za-z0-9][A-Za-z0-9\_\-\.]*\.[A-Za-z]{2,}$/;
	var filter2 = /(\.\.+)|(\@\@+)|(\_\_+)|(\-\-+)/;
	var filter3 = /(\.ac|\.ad|\.ae|\.aero|\.af|\.ag|\.ai|\.al|\.am|\.an|\.ao|\.aq|\.ar|\.arpa|\.as|\.at|\.au|\.aw|\.ax|\.az|\.ba|\.bb|\.bd|\.be|\.bf|\.bg|\.bh|\.bi|\.biz|\.bj|\.bm|\.bn|\.bo|\.br|\.bs|\.bt|\.bv|\.bw|\.by|\.bz|\.ca|\.cat|\.cc|\.cd|\.cf|\.cg|\.ch|\.ci|\.ck|\.cl|\.cm|\.cn|\.co|\.com|\.coop|\.cr|\.cu|\.cv|\.cx|\.cy|\.cz|\.de|\.dj|\.dk|\.dm|\.do|\.dz|\.ec|\.edu|\.ee|\.eg|\.er|\.es|\.et|\.eu|\.fi|\.fj|\.fk|\.fm|\.fo|\.fr|\.ga|\.gb|\.gd|\.ge|\.gf|\.gg|\.gh|\.gi|\.gl|\.gm|\.gn|\.gov|\.gp|\.gq|\.gr|\.gs|\.gt|\.gu|\.gw|\.gy|\.hk|\.hm|\.hn|\.hr|\.ht|\.hu|\.id|\.ie|\.il|\.im|\.in|\.info|\.int|\.io|\.iq|\.ir|\.is|\.it|\.je|\.jm|\.jo|\.jobs|\.jp|\.ke|\.kg|\.kh|\.ki|\.km|\.kn|\.kr|\.kw|\.ky|\.kz|\.la|\.lb|\.lc|\.li|\.lk|\.lr|\.ls|\.lt|\.lu|\.lv|\.ly|\.ma|\.mc|\.md|\.mg|\.mh|\.mil|\.mk|\.ml|\.mm|\.mn|\.mo|\.mobi|\.mp|\.mq|\.mr|\.ms|\.mt|\.mu|\.museum|\.mv|\.mw|\.mx|\.my|\.mz|\.na|\.name|\.nc|\.ne|\.net|\.nf|\.ng|\.ni|\.nl|\.no|\.np|\.nr|\.nu|\.nz|\.om|\.org|\.pa|\.pe|\.pf|\.pg|\.ph|\.pk|\.pl|\.pm|\.pn|\.pr|\.pro|\.ps|\.pt|\.pw|\.py|\.qa|\.re|\.ro|\.ru|\.rw|\.sa|\.sb|\.sc|\.sd|\.se|\.sg|\.sh|\.si|\.sj|\.sk|\.sl|\.sm|\.sn|\.so|\.sr|\.st|\.su|\.sv|\.sy|\.sz|\.tc|\.td|\.tel|\.tf|\.tg|\.th|\.tj|\.tk|\.tl|\.tm|\.tn|\.to|\.tp|\.tr|\.travel|\.tt|\.tv|\.tw|\.tz|\.ua|\.ug|\.uk|\.um|\.us|\.uy|\.uz|\.va|\.vc|\.ve|\.vg|\.vi|\.vn|\.vu|\.wf|\.ws|\.ye|\.yt|\.yu|\.za|\.zm|\.zw)$/i;
	
	
	if( (!filter.test( elementValue ))  || ( filter2.test( elementValue )) || ( !filter3.test( elementValue )) ) {
		return false;
	}	
	return true;*/	
} 
