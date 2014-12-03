function dispCheckboxImg(imgName){
    if(imgName == 'checkbox_normal'){
        $('#checkbox_normal').css('display','none');
        $('#checkbox_selected').css('display','block');
        $('#automatic_login').val("al");
    }
    else{
        $('#checkbox_selected').css('display','none');
        $('#checkbox_normal').css('display','block');
        $('#automatic_login').val('');
    }
}

						   

/*function focusChangeBorderColor(id){
	alert("test");
     The text box to change border color 
    switch(id){
        case "email_usr":
            if($('#'+id).val()== "Eg:john@gmail.com" || $('#'+id).val()== "eg:john@gmail.com" ){
                $('#'+id).val('');
            }
            break;
        case "password_usr":
            if($('#'+id).val()== "password" ){
                $('#'+id).val('');
            }
            break;
        case "reg_email_usr":
            if($('#'+id).val()== "Eg:john@gmail.com" || $('#'+id).val()== "eg:john@gmail.com" ){
                $('#'+id).val('');
            }
            break;
    }
    $('#'+id).css("border","1px solid #9fd8eb");
    $('#'+id).css("color","#444444");
    $('#'+id).focus();
}
function blurChangeBorderColor(id){

   The text box to change border color 
    switch(id){
        case "email_usr":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Eg:john@gmail.com");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "password_usr":
            if($('#'+id).val()== "" ){
                $('#'+id).val("password");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "reg_email_usr":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Eg:john@gmail.com");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
    }
    $('#'+id).css("border","1px solid #BDD6DD");
}
*/function forgotPasswordDivDisp(){	
    $('#forgotPasswordDiv').css('display','block');
    $('.signinOtherText').css('marginTop','9px');
    $("#reg_email_usr").css("border","1px solid #BDD6DD");
    $("#reg_email_usr").val("Eg:john@gmail.com");
    $("#reg_email_usr_error").html("");
    $("#reg_email_usr_error").css("display","none");
	$("#dot_div").css("display","block");
	$("#lineDart").css("display","block");
	$("#lineDart").css("margin","17px 0px 22px 0px");
			
}
function  forgotPasswordDivClose(){
    $('#forgotPasswordDiv').css('display','none');
    $('.signinOtherText').css('marginTop','9px');
    $("#reg_email_usr").css("border","1px solid #BDD6DD");
    $("#reg_email_usr").val("Eg:john@gmail.com");
	$("#reg_email_usr").css("color","#999999");
    $("#reg_email_usr_error").html("");
    $("#reg_email_usr_error").css("display","none");
	$("#dot_div").css("display","none");
	$("#lineDart").css("display","none");
}
function  sendPasswordDivClose(){
    $('#sendPasswordDiv').css('display','none');
    $('.signinOtherText').css('marginTop','69px');
    $("#reg_email_usr").css("border","1px solid #BDD6DD");
    $("#reg_email_usr").val("Eg:john@gmail.com");
    $("#reg_email_usr_error").html("");
    $("#reg_email_usr_error").css("display","none");
}

function deletevalue(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==35){
        $("#email_usr").val("");
    }
}

function deletevaluepass(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==35){
        $("#password_usr").val("");
    }
}



function cancelKeyDown(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        clearData();
    }
}
function registerKeyDown(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        window.location.href="/register";
    }
}
function fpKeyDown(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        forgotPasswordDivDisp();
    }
}
function closeKeyDown(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        forgotPasswordDivClose();
    }
}
function sendpwdKeyDown(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        sendPasswordDivClose();
    }
}
function cbKeyDown(e,imgName){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        if(imgName == 'checkbox_normal'){
            $('#checkbox_normal').css('display','none');
            $('#checkbox_selected').css('display','block');
            $('#automatic_login').val("al");
            $('#checkbox_selected').focus();
        }
        else{
            $('#checkbox_selected').css('display','none');
            $('#checkbox_normal').css('display','block');
            $('#automatic_login').val('');
            $('#checkbox_normal').focus();
        }
    }
}
/*selectLanguageUsrKeyDown

function selectLoginUsrKeyDown(e){
	alert("test");
	var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13){    	
    	document.getElementById("dropDownDiv").style.display="block";
    	flag=false; 
    }		
}*/
