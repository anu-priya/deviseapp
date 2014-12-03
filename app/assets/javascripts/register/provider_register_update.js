
/** Validating Register Form **/

function validateProviderForm(){
    var p_name = $("#p_name").val();
    p_name = p_name.replace(/^\s+|\s+$/g, "");
	var add_by = $("#add_by").val();
    var p_password = $("#p_password").val();
    var p_confirm_password = $("#p_confirm_password").val();
    var p_owner_firstname=$("#p_owner_firstname").val();
    var p_owner_lastname=$("#p_owner_lastname").val();
    var p_email=$("#p_email").val();
    var browse_photo=$("#browse_photo").val();
    var card_image_name=$("#card_image_name").val();
    var b_name= $("#b_name").val();
    var p_admin_firstname=$("#p_admin_firstname").val();
    var p_admin_lastname=$("#p_admin_lastname").val();
    var admin_provider = $("#admin_provider").val();	
    var p_description=$("#p_description").val();
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
    var email_val=$("#email_exist").val();
    $(".FileField").css("color","#444444");
	
    b_name = b_name.replace(/^\s+|\s+$/g, "");
    p_fax = p_fax.replace(/^\s+|\s+$/g, "");
    address1 = address1.replace(/^\s+|\s+$/g, "");
    p_phone = p_phone.replace(/^\s+|\s+$/g, "");
    p_description = p_description.replace(/^\s+|\s+$/g, "");
    web_addrs = web_addrs.replace(/^\s+|\s+$/g, "");
   

    $("#username_usr").css("border","1px solid #BDD6DD");
    $("#p_name").css("border","1px solid #BDD6DD");
    $("#b_name").css("border","1px solid #BDD6DD");
    $("#p_password").css("border","1px solid #BDD6DD");
    $("#p_confirm_password").css("border","1px solid #BDD6DD");
    $("#browse_photo").css("border","1px solid #BDD6DD");
    $("#card_image_name").css("border","1px solid #BDD6DD");
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
    $("#p_description").css("border","1px solid #BDD6DD");
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
    $("#b_card_error").html("");
    $("#p_admin_firstname_error").html("");
    $("#p_admin_lastname_error").html("");
    $("#admin_provider_error").html("");
    $("#p_description_error").html("");
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
    $("#b_card_error").parent().css("display","none");
    //$("#p_admin_firstname_error").parent().css("display","none");
    $("#p_admin_lastname_error").parent().css("display","none");
    $("#admin_provider_error").parent().css("display","none");
    $("#p_description_error").parent().css("display","none");
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
    if(email_val == "error" ){
        errorFlag = true;
    }
    /*else if(!validateName(p_name)){
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
    }*/

    if(b_name =="" || b_name == "Enter the Name Of your business"){
        $("#b_name").css("border","1px solid #fc8989");
        $("#b_name_error").html("Please enter the business name");
        $("#b_name_error").parent().css("display","block");
        errorFlag = true;
    }
	
   /* else if(!validateName(b_name)){
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
    }*/

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
    /* else if(!validateDot(p_email)){
        $("#p_email").css("border","1px solid #fc8989");
        $("#p_email_error").html("Please Check The Email Address Entered");
        $("#p_email_error").parent().css("display","block");
        errorFlag = true;
    }*/
     if(p_description =="Description should not exceed 1000 characters" || p_description==""){
        $("#p_description").css("border","1px solid #fc8989");
        $("#p_description_error").html("Please enter the description");
        $("#p_description_error").parent().css("display","block");
        errorFlag = true;
    }
     if(p_description.length>1000){
        $("#p_description").css("border","1px solid #fc8989");
        $("#p_description_error").html("Description should not exceed 1000 characters");
        $("#p_description_error").parent().css("display","block");
        errorFlag = true;
    }
    if(card_image_name == ""){
        $("#card_image_name").css("border","1px solid #fc8989");
        $("#b_card_error").parent().css("display","block");
        $("#b_card_error").html("Please select the image to upload");
        errorFlag = true;
    }
    if(card_image_name != ""){
        val=validateBrowse('card_image_name','b_card_error');
        if(!val){
            $('#b_card_error').html('Please Check The Format Of Card Image');
            errorFlag = true;
        }
    }
   /* if(browse_photo == ""){
        $("#browse_photo").css("border","1px solid #fc8989");
        $("#b_logo_error").parent().css("display","block");
        $("#b_logo_error").html("Please select the image to upload");
        errorFlag = true;
    } */
    if(browse_photo != ""){
        val=validateBrowse('browse_photo','b_logo_error');
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
   /* if(p_owner_firstname != "First Name" ){
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

    }*/
    if(address1 == ""){
        $("#address1").css("border","1px solid #fc8989");
        $("#address1_error").parent().css("display","block");
        $("#address1_error").html("Please enter the address line1");
		
        errorFlag = true;
    }
    if(p_state == "" || p_state == "--Choose state--"){
        $(".selectBoxPState").css("border","1px solid #fc8989");
        $("#p_state_error").parent().css("display","block");
        $("#p_state_error").html("Please select the state");
        errorFlag = true;
    }

    if(p_city == "" || p_city == "--Choose city--"){
        $(".selectBoxPCity").css("border","1px solid #fc8989");
        $("#p_city_error").parent().css("display","block");
        $("#p_city_error").html("Please select the city");
        errorFlag = true;
    }
    if(p_phone=="Enter Your Phone Number" || p_phone==""){ 	
        $("#p_phone").css("border","1px solid #fc8989");
        $("#p_phone_error").parent().css("display","block");
        $("#p_phone_error").html("Please enter phone number");
        errorFlag = true;
    }
    if(p_phone!=""){
        if(validatePhone(p_phone)){
            $("#p_phone").css("border","1px solid #fc8989");
            $("#p_phone_error").parent().css("display","block");
            $("#p_phone_error").html("Please enter valid phone number");
            errorFlag = true;
        }
    }
	
   /* if(p_mobile=="Enter Your Mobile Number" || p_mobile==""){
        $("#p_mobile").css("border","1px solid #fc8989");
        $("#p_mobile_error").html("Please enter mobile number");
        $("#p_mobile_error").parent().css("display","block");
        errorFlag = true;
    }
    if(p_mobile !=""){
        if(validatePhone(p_mobile)){
            $("#p_mobile").css("border","1px solid #fc8989");
            $("#p_mobile_error").html("Please enter mobile number");
            $("#p_mobile_error").parent().css("display","block");
            errorFlag = true;
        }
    }
    if(p_fax == "" || p_fax == "Enter Your Fax Number"){
        $("#p_fax").css("border","1px solid #fc8989");
        $("#p_fax_error").parent().css("display","block");
        $("#p_fax_error").html("Please enter fax number");
        errorFlag = true;
    }*/
	if(p_fax != "Enter Your Fax Number"){
		if(isNaN(p_fax)){
			$("#p_fax").css("border","1px solid #fc8989");
			$("#p_fax_error").parent().css("display","block");
			$("#p_fax_error").html("Please enter fax number");
			errorFlag = true;
		}
	}
    /*if(web_addrs == "" || web_addrs== "Enter The URL Of Your Website"){
        $("#web_addrs").css("border","1px solid #fc8989");
        $("#web_addrs_error").parent().css("display","block");
        $("#web_addrs_error").html("Please enter the web address");
        errorFlag = true;
    }*/    
    if(web_addrs!= "Enter The URL Of Your Website"){
		if(!ValidateWebAddress(web_addrs)){
			$("#web_addrs").css("border","1px solid #fc8989");
			$("#web_addrs_error").parent().css("display","block");
			$("#web_addrs_error").html("Please enter the valid web address");
			errorFlag = true;
		}
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
   
   if(add_by == "--Select--"){
        //$(".selectBoxProvider").css("background","url('/assets/register/select_box_error.png') no-repeat");
        $(".addby").css("border","1px solid #fc8989");
        $("#add_by_error").parent().css("display","block");
        $("#add_by_error").html("Please select the resource");
        errorFlag = true;
    }
		
    if(p_country == "" || p_country == "--Choose Country--"){
        //$(".selectBoxProvider").css("background","url('/assets/register/select_box_error.png') no-repeat");
        $(".selectBoxPCountry").css("border","1px solid #fc8989");
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
    //var characterReg = /^[0-9]\d{2}-\d{3}-\d{4}$/;
    var characterReg = /^[0-9+]$/;
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
/*
function ValidateWebsiteAddress() {
    var url = document.getElementById('web_addrs').value;
    var urlIsValid =       ValidateWebAddress(url);      //alert("Website Address is valid?:" +urlIsValid );
    return urlIsValid ;
}
 */   

function ValidateWebAddress(url) {
    var webSiteUrlExp = /^(([\w]+:)?\/\/)?(([\d\w]|%[a-fA-f\d]{2,2})+(:([\d\w]|%[a-fA-f\d]{2,2})+)?@)?([\d\w][-\d\w]{0,253}[\d\w]\.)+[\w]{2,4}(:[\d]+)?(\/([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)*(\?(&?([-+_~.\d\w]|%[a-fA-f\d]{2,2})=?)*)?(#([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)?$/;
    if (webSiteUrlExp.test(url)) {
        return true;
    }
    else {
        return false;
    }
}





function validateBrowse(id1,id2){
    var fup = document.getElementById(id1);
	
    var fileName = fup.value;
    var ext = fileName.substring(fileName.lastIndexOf('.') + 1);
    if(ext == "gif" || ext == "GIF" || ext == "JPEG" || ext == "jpeg" || ext == "jpg" || ext == "JPG" || ext == "png" || ext == "PNG")
    {
        //errorFlag = false;
        return true;
    }
    else
    {        
        $('#'+id2).parent().css("display","block");
        $("#"+id1).css("border","1px solid #fc8989");
        $('#'+id2).html('Please Check The Format');
        return false;
    }
}  

function validatePhone(p_phone) {
    /*var filter = /^[0-9+]+$/;*/
    var filter = /^[a-zA-Z]+$/;	
    return filter.test(p_phone);
}
function validateMobile(p_mobile) {
    var filter1 = /^[0-9-+]+$/;
    return filter1.test(p_mobile);
}
function ValidateEmail(inputText)
{
    var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    if(inputText.value.match(mailformat))
    {
        return true;
    }
    else
    {
        return false;
    }
}

function validateDot(elementValue) {
    var emailSplitat = elementValue.split("@");
    var emailSplitdotf = emailSplitat[0].split(".");
    var emailSplitdotl = emailSplitat[1].split(".");
  	 
    /*    if(emailSplitat[0].length<4){
        return false;
    }
  	  	
    if(emailSplitdotf.length>3){
        return false;
    }*/
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
/** Clear the login form text fields **/
function clearData(){
    $("#username_usr").val("Eg:john");
    $("#username_usr").css("color","#999999");
    $("#p_name").val("");
    $("#p_email").val("");
    $("#b_name").val("");
    $("#p_description").val("Description should not exceed 1000 characters");
     $("#p_description").css("color","#999999");
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
    $("#card_image_name").val("");
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
    $("#card_image_name").css("border","1px solid #BDD6DD");
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
    $("#p_description").css("border","1px solid #BDD6DD");
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
    $(".selectBoxFax").css("border","none");
    $("#browse_photo_spo").css("border","1px solid #BDD6DD");
    $(".selectBoxPTime").css("border","none");
     $(".FileField").css("color","#444444");	
	
	
	
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
    $("#b_card_error").html("");
    $("#p_owner_error").html("");
    $("#p_admin_error").html("");
    $("#p_language_error").html("");
    $("#web_addrs_error").html("");
    $("#agree_usr_error").html("");
    $("#p_description_error").html("");
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
    $("#p_description_error").parent().css("display","none");
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
    $("#b_card_error").parent().css("display","none");
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
 }   
function selectCityUsrKeyDown(e){}
function selectCountryUsrKeyDown(e){}    
function selectTimeUsrKeyDown(e){}
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
    var emailPattern = /^([a-zA-Z0-9]+([~{|}._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,3}(?:\.[a-zA-Z]{2,3})?)$/;
    return emailPattern.test(elementValue);
}

