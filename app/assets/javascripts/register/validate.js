// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


/** Validating Register Form **/


function validateRegisterForm(){ 
    var username_usr_reg = $("#username_usr_reg").val();
    var email_usr_reg = $("#email_usr_reg").val();
    var password_usr_reg = $("#password_usr_reg").val();
    //alert(password_usr_reg);
    var confirm_password_usr = $("#confirm_password_usr").val();
    var agree_usr = $("#agree_usr").val();
    var reg_me_usr = $("#reg_me_usr").val();
	
    $('#forgotpass').css('display','none');
    $('#forgotpassfail').css('display','none');
	$('#error_explanation').css('display','none');
	
    $("#username_usr_reg").css("border","1px solid #BDD6DD");
    $("#email_usr_reg").css("border","1px solid #BDD6DD");
    $("#password_usr_reg").css("border","1px solid #BDD6DD");
    $("#confirm_password_usr").css("border","1px solid #BDD6DD");
	
    $("#username_usr_error").html("");
    $("#email_usr_error").html("");
    $("#password_usr_error").html("");
    $("#confirm_password_usr_error").html("");
    $("#agree_usr_error").html("");
    $("#reg_me_usr_error").html("");


    $("#username_usr_error").parent().css("display","none");
    $("#email_usr_error").parent().css("display","none");
    $("#password_usr_error").parent().css("display","none");
    $("#confirm_password_usr_error").parent().css("display","none");
    $("#agree_usr_error").parent().css("display","none");
    $("#reg_me_usr_error").parent().css("display","none");
		
    var errorFlag = false;
	
    //	var username_usrLen = username_usr.trim().length;
    if(username_usr_reg == "" || username_usr_reg == "Eg:john" || username_usr_reg == "eg:john" /*|| username_usrLen < 1*/ ){
        $("#username_usr_reg").css("border","1px solid #fc8989");
        $("#username_usr_error").html("Please enter your name");
        $("#username_usr_error").parent().css("display","block");
        errorFlag = true;
    }
    else if(!validateName(username_usr_reg)){
        $("#username_usr_reg").css("border","1px solid #fc8989");
        $("#username_usr_error").html("Please enter valid name");
        $("#username_usr_error").parent().css("display","block");
        errorFlag = true;
    }
    if(email_usr_reg == "" || email_usr_reg =="Eg:john@gmail.com" || email_usr_reg =="eg:john@gmail.com" ){
        $("#email_usr_reg").css("border","1px solid #fc8989");
        $("#email_usr_error").html("Please enter your email");
        $("#email_usr_error").parent().css("display","block");
        errorFlag = true;
    }
    else if(email_usr_reg){
        if(email_usr_reg.length<10){
            $("#email_usr_reg").css("border","1px solid #fc8989");
            $("#email_usr_error").html("Please enter the email address having minimum of 10 characters");
            $("#email_usr_error").parent().css("display","block");
            errorFlag = true;
        }
        else if(!validateCorrectEmail(email_usr_reg)){
            $("#email_usr_reg").css("border","1px solid #fc8989");
            $("#email_usr_error").html("Please enter a valid email");
            $("#email_usr_error").parent().css("display","block");
            errorFlag = true;
        }
    /*else if(!validateDot(email_usr_reg)){
            $("#email_usr_reg").css("border","1px solid #fc8989");
            $("#email_usr_error").html("Please enter a valid email address");
            $("#email_usr_error").parent().css("display","block");
            errorFlag = true;
        }*/
    }
    if (password_usr_reg == "" ||  password_usr_reg == "password"){
        $("#password_usr_reg").css("border","1px solid #fc8989");
        $("#password_usr_error").html("Please enter the password");
        $("#password_usr_error").parent().css("display","block");
        errorFlag = true;
    }
    else if(password_usr_reg.length<8){
        $("#password_usr_reg").css("border","1px solid #fc8989");
        $("#password_usr_error").html("Please enter the password having minimum of 8 characters");
        $("#password_usr_error").parent().css("display","block");
        errorFlag = true;
    }
	
    if(confirm_password_usr== "" || confirm_password_usr== "password") {
        $("#confirm_password_usr").css("border","1px solid #fc8989");
        $("#confirm_password_usr_error").html("Please enter the confirm password");
        $("#confirm_password_usr_error").parent().css("display","block");
        errorFlag = true;
    }

    if(confirm_password_usr != password_usr_reg){
        $("#confirm_password_usr").css("border","1px solid #fc8989");
        $("#confirm_password_usr_error").html("Please enter the correct confirm password");
        $("#confirm_password_usr_error").parent().css("display","block");
        errorFlag = true;
    }
    if(reg_me_usr == "Select" || reg_me_usr == ""){
        $(".selectBoxCity").css("background","url('/assets/register/select_box_error.png') no-repeat");
        $("#reg_me_usr_error").parent().css("display","block");
        $("#reg_me_usr_error").html("Please select register me as");
        errorFlag = true;
    }
	
    if (agree_usr == ""){
        $('#checkbox_error').css('display','block');
        $('#checkbox_normal').css('display','none');
        $("#agree_usr_error").html("In order to create an account, you must agree to Terms of Service and Privacy &amp; Refund Policies");
        $("#agree_usr_error").parent().css("display","block");
        errorFlag = true;
    }
	
    if(errorFlag){
        return false;
    }
    return true;
}
function validateName(elementValue){	
    /*var alphaExp = /^([a-zA-Z]+([ ]{0,1}[a-zA-Z]))+$/;*/
    var alphaExp = /^[a-zA-Z ]*$/;
    return alphaExp.test(elementValue);
}
function validateCorrectEmail(elementValue){
    var emailPattern = /^([a-zA-Z0-9]+([~{|}._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,3}(?:\.[a-zA-Z]{2,3})?)$/;
    return emailPattern.test(elementValue);
}
/** Clear the login form text fields **/
function clearData(){
	//alert("test");
    $("#username_usr_reg").val("Eg:john");
    $("#username_usr_reg").css("color","#999999");
    $("#email_usr_reg").val("Eg:john@gmail.com");
    $("#email_usr_reg").css("color","#999999");
    $("#password_usr_reg").val("password");
    $("#password_usr_reg").css("color","#999999");
    $("#confirm_password_usr").val("password");
    $("#confirm_password_usr").css("color","#999999");
    $("#reg_me_usr").val("Select");
    $("#reg_me_field").html("Select");
	$('#error_explanation').css('display','none');
    $('#agree_usr').val('');
	$('.setStyleEmail').parent().css('display','none');
    $('.setStyleEmail').css('display','none');
    $(".selectBoxCity").css("background","url('/assets/register/selece_box_normal.png') no-repeat");
    $('#checkbox_error').css('display','none');
    $('#checkbox_selected').css('display','none');
    $('#checkbox_normal').css('display','block');


    $("#username_usr_reg").css("border","1px solid #BDD6DD");
    $("#email_usr_reg").css("border","1px solid #BDD6DD");
    $("#password_usr_reg").css("border","1px solid #BDD6DD");
    $("#confirm_password_usr").css("border","1px solid #BDD6DD");
	
    $("#username_usr_error").html("");
    $("#email_usr_error").html("");
    $("#password_usr_error").html("");
    $("#confirm_assword_usr_error").html("");
    $("#reg_me_usr_error").html("");
    $("#agree_usr_error").html("");


    $("#username_usr_error").parent().css("display","none");
    $("#email_usr_error").parent().css("display","none");
    $("#password_usr_error").parent().css("display","none");
    $("#confirm_password_usr_error").parent().css("display","none");
    $("#agree_usr_error").parent().css("display","none");
    $("#reg_me_usr_error").parent().css("display","none");
	
	
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
function removeunwantedSpace(username_usr){
    var values=username_usr;
    var str='';
    var p=values.charAt(0);
    var firstVal=p;
    var c='';
    while(values.charAt(i)!=''){
        p=c;
        i++;
        c=values.charAt(i);
        if(p==' ' && c!=' '){ }
        if(p==' ' && c==' '){ }
        else{
            str+=values.charAt(i);
        }
    }
    document.getElementById('username_usr').value=firstVal+str;
}  