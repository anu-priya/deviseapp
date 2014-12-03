function dispCheckboxImg(imgName){
    if(imgName == 'checkbox_normal'){
        //alert("test");
        $('#checkbox_normal').css('display','none');
        $('#checkbox_error').css('display','none');
        $('#checkbox_selected').css('display','block');
        $('#agree_usr').val(7);
    }
    else if(imgName == 'checkbox_error'){
        $('#checkbox_normal').css('display','none');
        $('#checkbox_error').css('display','none');
        $('#checkbox_selected').css('display','block');
        $('#agree_usr').val(7);
    }
    else if(imgName == 'p_checkbox_normal'){
        $('#p_checkbox_normal').css('display','none');
        $('#p_checkbox_error').css('display','none');
        $('#p_checkbox_selected').css('display','block');
        $('#agree_provider').val(7);
    }
    else if(imgName == 'p_checkbox_error'){
        $('#p_checkbox_normal').css('display','none');
        $('#p_checkbox_error').css('display','none');
        $('#p_checkbox_selected').css('display','block');
        $('#agree_provider').val(7);
    }
	
    else if(imgName == 'p_checkboxInternal_normal'){
        $('#p_checkboxInternal_normal').css('display','none');
        $('#p_checkboxInternal_error').css('display','none');
        $('#p_checkboxInternal_selected').css('display','block');
        $('#user_mail').val('1');
		
    }
    else if(imgName == 'p_checkboxInternal_selected'){
        $('#p_checkboxInternal_selected').css('display','none');
        $('#p_checkboxInternal_error').css('display','none');
        $('#p_checkboxInternal_normal').css('display','block');
        $('#user_mail').val('0');

    }
    else if(imgName == 'p_checkboxInternal_error'){
        $('#p_checkboxInternal_normal').css('display','none');
        $('#p_checkboxInternal_error').css('display','none');
        $('#p_checkboxInternal_selected').css('display','block');
        $('#user_mail').val('0');
    }
	
    else{
        $('#checkbox_selected').css('display','none');
        $('#checkbox_normal').css('display','block');
        $('#checkbox_error').css('display','none');
        $('#p_checkbox_selected').css('display','none');
        $('#p_checkbox_normal').css('display','block');
        $('#p_checkbox_error').css('display','none');
        $('#p_checkboxInternal_selected').css('display','none');
        $('#p_checkboxInternal_normal').css('display','block');
        $('#p_checkboxInternal_error').css('display','none');
        $('#admin_checkbox_selected').css('display','none');
        $('#admin_checkbox_normal').css('display','block');
        $('#admin_checkbox_error').css('display','none');
        $('#agree_usr').val('');
        $('#agree_provider').val('');
        $('#admin_provider').val('');
        $('#user_mail').val('');
    }
}
function focusChangeBorderColorReg(id){
    switch(id){
        case "p_name":
            if($('#'+id).val()== "Eg: John Smith" || $('#'+id).val()== "Eg: John Smith" ){
                $('#'+id).val('');

            }
            break;

        case "username_usr_reg":
            if($('#'+id).val()== "Eg:john" || $('#'+id).val()== "eg:john" ){
                $('#'+id).val('');

            }
            break;
        case "password_usr_reg":
            if($('#'+id).val()== "password" ){
                $('#'+id).val('');
				
            }
            break;
        case "email_usr_reg":
            if($('#'+id).val() == "Eg:john@gmail.com" || $('#'+id).val() == "eg:john@gmail.com" ){
                $('#'+id).val('');
				
            }
            break;
        case "p_owner":
            if($('#'+id).val()== "Enter Name"){
                $('#'+id).val('');
				
            }
            break;
        case "p_admin":
            if($('#'+id).val()== "Enter Name"){
                $('#'+id).val('');
				
            }
            break;
        case "email_usr_reg":
            if($('#'+id).val() == "Eg:john@gmail.com" || $('#'+id).val() == "eg:john@gmail.com" ){
                $('#'+id).val('');
				
            }
            break;
        case "p_owner":
            if($('#'+id).val()== "First Name"){
                $('#'+id).val('');
            }
            break;
        case "p_owner_firstname":
            if($('#'+id).val()== "First Name"){
                $('#'+id).val('');
				
            }
            break;
        case "b_name":
            if($('#'+id).val()== "Enter the Name Of your business" || $('#'+id).val("Enter The Name Of Your Business")){
                $('#'+id).val('');
				
            }
            break;
        case "p_owner_lastname":
            if($('#'+id).val()== "Last Name"){
                $('#'+id).val('');
            }
            break;
        case "p_email":
            if($('#'+id).val() == "Eg:john@gmail.com" || $('#'+id).val() == "eg:john@gmail.com" ){
                $('#'+id).val('');
				
            }
            break;
        /*case "email_usr":
				if($('#'+id).val() == "Eg:john@gmail.com" || $('#'+id).val() == "eg:john@gmail.com" ){
					$('#'+id).val('');
				}
			break;*/
			
        /*case "password_usr":
				if($('#'+id).val()== "password" ){
					$('#'+id).val('');
				}
			break;*/
        case "confirm_password_usr":
            if($('#'+id).val()== "password" ){
                $('#'+id).val('');
				
            }
            break;
        case "p_zipcode":
            if($('#'+id).val()== "Enter Zip Code"){
                $('#'+id).val('');
				
            }
            break;
        case "reg_email_usr":
            if($('#'+id).val()== "Eg:john" || $('#'+id).val()== "eg:john"){
                $('#'+id).val('');
				
            }
            break;
        case "p_fax":
            if($('#'+id).val()== "Enter Your Fax Number"){
                $('#'+id).val('');
				
            }
            break;
        case "p_phone":
            if($('#'+id).val()== "Enter Your Phone Number"){
                $('#'+id).val('');
				
            }
            break;
        case "p_mobile":
            if($('#'+id).val()== "Enter Your Mobile Number"){
                $('#'+id).val('');
				
            }
            break;
        case "web_addrs":
            if($('#'+id).val()== "Enter The URL Of Your Website"){
                $('#'+id).val('');
				
            }
            break;
  
			
    }
    $('#'+id).css("border","1px solid #9fd8eb");
    $('#'+id).css("color","#444444");
    $('#'+id).focus();
    	
}	
function blurChangeBorderColorReg(id){
    switch(id){
		
        case "p_name":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Eg: John Smith");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;

        case "username_usr_reg":
            if($('#'+id).val()== "" ){
					
                $('#'+id).val("Eg:john");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "password_usr_reg":
            if($('#'+id).val()== "" ){
                $('#'+id).val("password");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "reg_email_usr":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Eg:john");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "p_owner":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Name");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "p_admin":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Name");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "p_zipcode":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Zip Code");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;


        case "p_fax":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Your Fax Number");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }

            break;
        case "p_phone":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Your Phone Number");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "p_mobile":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Your Mobile Number");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "web_addrs":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter The URL Of Your Website");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;

        /*case "email_usr":
				if($('#'+id).val()== "" ){
					$('#'+id).val("Eg:john@gmail.com");
					$('#'+id).css("border","1px solid #BDD6DD");     	
     				$('#'+id).css("color","#999999");
				}
			break;*/
        case "email_usr_reg":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Eg:john@gmail.com");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        //raja
        case "p_owner_firstname":
            if($('#'+id).val()== "" ){
                $('#'+id).val("First Name");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "b_name":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter the Name Of your business");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "p_owner_lastname":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Last Name");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "p_email":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Eg:john@gmail.com");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;


        /*case "password_usr":
				if($('#'+id).val()== "" ){
					$('#'+id).val("password");
					$('#'+id).css("border","1px solid #BDD6DD");     	
     				$('#'+id).css("color","#999999");
				}
			break;*/
        case "confirm_password_usr":
            if($('#'+id).val()== "" ){
                $('#'+id).val("password");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
    }
    $('#'+id).css("border","1px solid #BDD6DD");
//$('#'+id).css("color","#999999");
}
function DetectTab(e) {
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==9){
        document.getElementById("dropDownDiv").style.display="none";
    }
}
function termsKeyDown(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
//window.location.href="http://10.37.4.22:3000/terms#";
}
}
function cancelKeyDown(e){
    /*var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        clearData();
    }*/
}
function signinKeyDown(e){
    //document.getElementById("dropDownDiv").style.display="none";
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==13 || KeyCode==32){
        window.location.href="/login";
    }
}
function ag_cb_keydown(e,imgName){	
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        if(imgName == 'checkbox_normal'){
            $('#checkbox_normal').css('display','none');
            $('#checkbox_error').css('display','none');
            $('#checkbox_selected').css('display','block');
            $('#agree_usr').val(7);
            $('#checkbox_selected').focus();
        }
        else if(imgName == 'checkbox_error'){
            $('#checkbox_normal').css('display','none');
            $('#checkbox_error').css('display','none');
            $('#checkbox_selected').css('display','block');
            $('#agree_usr').val(7);
            $('#checkbox_selected').focus();
        }
        else if(imgName == 'p_checkbox_normal'){
            $('#p_checkbox_normal').css('display','none');
            $('#p_checkbox_error').css('display','none');
            $('#p_checkbox_selected').css('display','block');
            $('#agree_provider').val(7);
            $('#p_checkbox_selected').focus();
        }
        else if(imgName == 'p_checkbox_error'){
            $('#p_checkbox_normal').css('display','none');
            $('#p_checkbox_error').css('display','none');
            $('#p_checkbox_selected').css('display','block');
            $('#agree_provider').val(7);
            $('#p_checkbox_selected').focus();
        }
        else if(imgName == 'p_checkboxInternal_normal'){
            $('#p_checkboxInternal_normal').css('display','none');
            $('#p_checkboxInternal_error').css('display','none');
            $('#p_checkboxInternal_selected').css('display','block');
            $('#user_mail').val('1');

		
        }
        else if(imgName == 'p_checkboxInternal_selected'){
            $('#p_checkboxInternal_selected').css('display','none');
            $('#p_checkboxInternal_error').css('display','none');
            $('#p_checkboxInternal_normal').css('display','block');
            $('#user_mail').val('0');

        }
        else if(imgName == 'p_checkboxInternal_error'){
            $('#p_checkboxInternal_normal').css('display','none');
            $('#p_checkboxInternal_error').css('display','none');
            $('#p_checkboxInternal_selected').css('display','block');
            $('#user_mail').val('0');
        }
        else{
            $('#checkbox_selected').css('display','none');
            $('#checkbox_normal').css('display','block');
            $('#checkbox_error').css('display','none');
            $('#p_checkbox_selected').css('display','none');
            $('#p_checkbox_normal').css('display','block');
            $('#p_checkbox_error').css('display','none');
            $('#p_checkboxInternal_normal').css('display','block');
            $('#p_checkboxInternal_selected').css('display','none');
            $('#p_checkboxInternal_error').css('display','none');
            $('#user_mail').val('');
            $('#agree_provider').val('');
            $('#agree_provider').val('');
            $('#checkbox_normal').focus();
            $('#p_checkbox_normal').focus();
        }
    }
}
function selectRegUsrKeyDown(e){
    //alert("key");
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13){
        document.getElementById("dropDownDiv").style.display="block";
        flag=false;
    }
}
/*function  selectCityUsrKeyDown(e){
	//alert("test");
	var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13){    	
    	document.getElementById("dropDownDiv2").style.display="block";
    	flag2=false; 
    }		
}
function detectkeyDown(e) {
    var KeyCode = (e.which) ? e.which : e.keyCode    
    if(KeyCode==13){
    	document.getElementById("dropDownDiv").style.display="none";
    	flag=true;   
    }    
}*/ 