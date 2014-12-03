// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

/** Validating Login Form **/
function validateLoginForm(){
    var email_usr = $("#email_usr").val();
    var password_usr = $("#password_usr").val();
    /*var login_me_usr = $("#login_me_usr").val();*/
	
    $("#email_usr_error").html("");
    $("#password_usr_error").html("");
    /*$("#login_usr_error").html("");*/
    $('#forgotpass').css('display','none');
    $('#forgotpassfail').css('display','none');
	
    $("#password_usr").css("border","1px solid #BDD6DD");
    $("#email_usr").css("border","1px solid #BDD6DD");
	
    $("#email_usr_error").parent().css("display","none");
    $("#password_usr_error").parent().css("display","none");
    $("#login_usr_error").parent().css("display","none");
	
    var errorFlag = false;

    if(email_usr == "" || email_usr =="Eg:john@gmail.com" || email_usr =="eg:john@gmail.com"){
        $("#email_usr").css("border","1px solid #fc8989");
        $("#temp_email_usr").css("border","1px solid #fc8989");
        $("#email_usr_error").html("Please enter your username");
        $("#email_usr_error").parent().css("display","block");
        errorFlag = true;
    }
	
    else if(!validateCorrectEmail(email_usr)){
        //alert("test");
        $("#email_usr").css("border","1px solid #fc8989");
        $("#temp_email_usr").css("border","1px solid #fc8989");
        $("#email_usr_error").html("Please enter valid username");
        $("#email_usr_error").parent().css("display","block");
        errorFlag = true;
    }
   /* else if(!validateDot(email_usr)){
        $("#email_usr").css("border","1px solid #fc8989");
        $("#temp_email_usr").css("border","1px solid #fc8989");
        $("#email_usr_error").html("Please enter valid  username");
        $("#email_usr_error").parent().css("display","block");
        errorFlag = true;
    }*/
    if (password_usr == "" ||  password_usr == "password"){
        $("#password_usr").css("border","1px solid #fc8989");
        $("#temp_password_usr").css("border","1px solid #fc8989");
        $("#password_usr_error").html("Please enter your password");
        $("#password_usr_error").parent().css("display","block");
        errorFlag = true;
    }
    else if(password_usr.length<8){
        $("#password_usr").css("border","1px solid #fc8989");
        $("#temp_password_usr").css("border","1px solid #fc8989");
        $("#password_usr_error").html("Please enter the password having minimum of 8 characters");
        $("#password_usr_error").parent().css("display","block");
        errorFlag = true;
    }
    /* if(login_me_usr == "Select" || login_me_usr == ""){
        $(".selectBoxLogin").css("border","1px solid #fc8989");
        $("#login_usr_error").parent().css("display","block");
        $("#login_usr_error").html("Please select login as");
        errorFlag = true;
    }*/
    if(errorFlag){
        return false;
    }
    return true;
}


/** Validating Lost your password **/
function validateEmail(){
    $("#notice").css("display","none");
    var reg_email_usr = $("#reg_email_usr").val();
    $("#reg_email_usr").css("border","1px solid #BDD6DD");
    $("#reg_email_usr_error").html("");
    $("#reg_email_usr_error").css("display","none");
		
    var errorFlag = false;
	
    if(reg_email_usr == "" || reg_email_usr == "Eg:john@gmail.com" || reg_email_usr =="eg:john@gmail.com"){
        $("#reg_email_usr").css("border","1px solid #fc8989");
        $("#temp_reg_email_usr").css("border","1px solid #fc8989");
        $("#reg_email_usr_error").html("Please enter your Email");
        $("#reg_email_usr_error").css("display","block");
        errorFlag = true;
    }
    else if(!validateCorrectEmail(reg_email_usr)){
        $("#reg_email_usr").css("border","1px solid #fc8989");
        $("#temp_reg_email_usr").css("border","1px solid #fc8989");
        $("#reg_email_usr_error").html("Please enter a valid Email");
        $("#reg_email_usr_error").css("display","block");
        errorFlag = true;
    }
   /* else if(!validateDot(reg_email_usr)){
        $("#reg_email_usr").css("border","1px solid #fc8989");
        $("#reg_email_usr_error").html("Please enter your valid email");
        $("#reg_email_usr_error").css("display","block");
        errorFlag = true;
    }*/


    if(errorFlag == false){
        $.ajax({
            type: "post",
            url: "forgot_password",
            dataType:"json",
            data: {
                "email": reg_email_usr
            },
            async: false,
            cache: false,
            success: function(data){
                if (data =="success"){
                    $("#forgotpass").css("display","block");
                    $("#forgotpassfail").css("display","none");
                    forgotPasswordDivClose();
                }
		else if(data == "failed_alert")
		  {
		   $("#forgotpass").css("display","none");
                    $("#forgotpassfail_alert").css("display","block");
		  }
		
		else{
                    $("#forgotpass").css("display","none");
                    $("#forgotpassfail").css("display","block");
                }
            },

            error : function(xhr,status,error){
                $("#forgotpassfail").css("display","block");
            }
        });
    }

//    if(errorFlag){
//        return false;
//    }
	
//    return true;
}
function validateCorrectEmail(elementValue){
    var emailPattern = /^([a-zA-Z0-9]+([~{|}._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,3}(?:\.[a-zA-Z]{2,3})?)$/;
    return emailPattern.test(elementValue);
}
 
function setLoginUserValue(val1,val2){	
    document.getElementById("login_me_usr").value=val1;
    document.getElementById("login_me_field").innerHTML=val2.innerHTML;
    selectedregion=val2.rel;
    $(".selectBoxLogin").css("border","none");
//    $("#login_usr_error").html("");
			
}
/** Clear the login form text fields **/

function clearData(){	
    $("#email_usr").val("Eg:john@gmail.com");
	$("#email_usr").css("color","#999999");
    $("#password_usr").val("password");
	$("#password_usr").css("color","#999999");
    $("#login_me_usr").val("Select");
    $('#forgotpass').css('display','none');
    $('#forgotpassfail').css('display','none');
	
    $("#email_usr_error").html("");
    $("#password_usr_error").html("");
    $("#login_usr_error").html("");
    $("#login_me_field").html("Select");
    $('#checkbox_error').css('display','none');
    $('#checkbox_selected').css('display','none');
    $('#checkbox_normal').css('display','block');
    $('#email_password_usr_error').css('display','none');
	
    $("#email_usr").css("border","1px solid #BDD6DD");
	
    $("#password_usr").css("border","1px solid #BDD6DD");
    //$("#login_me_usr").css("border","1px solid #BDD6DD");
    $(".selectBoxLogin").css("border","none");
	
    $("#email_usr_error").parent().css("display","none");
    $("#password_usr_error").parent().css("display","none");
    $("#login_usr_error").parent().css("display","none");
	//clear cookies 
	$.get('/login/clear_cookies', function(data){
	})
	//clear cookies
	$.get('/login/clear_cookies', function(data){							
    })
	
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

