
//~ $(document).ready(function(){
						 
    //~ providerDropDown();
	
//~ $('.settingsDropdown').click(function(){
    //~ providerDropDown();
//~ });
//~ });


/*****modified login******/


/*$(document).mousedown(function(){
	   $('#dispContactDiv').removeClass('dp');
       $("#dropDownDiv5").css('display','none');
	   $("#dropDownDiv6").css('display','none');
	   $("#dropDownDiv7").css('display','none');
	   $("#dropDownDiv8").css('display','none');
	   $("#dropDownDiv9").css('display','none');
	   $("#dropDownDiv10").css('display','none');
	   $("#dropDownDiv11").css('display','none');
	   $("#dropDownDiv12").css('display','none');
	   $("#dropDownDiv13").css('display','none');
 });
*/

var start_val=5;
var end_Val=9;
var flag5=false;
var flag6=false;
var flag7=false;
var flag8=false;
/*var flag9=false;
var flag10=false;
var flag11=false;
var flag12=false;
var flag13=false;
var trig=true;*/
var trig5=true;
var trig6=true;
var trig7=true;
var trig8=true;
/*var trig9=true;
var trig10=true;
var trig11=true;
var trig12=true;
var trig13=true;
var trig18=true;*/
function providerDropDown(){
    if(flag5){
        if(trig5){  
            if(document.getElementById("dropDownDiv5").innerHTML!=''){  
				//~ for(var i=start_val;i<end_Val;i++){	
					var drop=5
					if(drop){ 
						document.getElementById("dropDownDiv5").style.display="block";
               			 $(".selectBoxCity").css("background","url('/assets/register/selece_box_normal.png') no-repeat");
					}
					else{
						document.getElementById("dropDownDiv5").style.display="none";
						$(".dispContactDiv_5").removeClass('dp');
					}
				//~ }
			}

            trig5=false;           
        }
        else{
		
            document.getElementById("dropDownDiv5").style.display="none";
			$('.f_contacts5').css("border","1px solid #fff");
			$('.f_contacts5').css("background","none");
			$(".dispContactDiv_5").removeClass('dp');
            trig5=true;
        }
    }    
    else if(flag6){ 
        if(trig6){

            if(document.getElementById("dropDownDiv6").innerHTML!=''){               
              //~ for(var i=start_val;i<end_Val;i++){
					var drop=6
					if(drop){ 
						 document.getElementById("dropDownDiv6").style.display="block";
                		 $(".selectBoxLanguage").css("background","url(('/assets/register/selece_box_normal.png') no-repeat scroll 0 0 transparent");
					}
					else{
						document.getElementById("dropDownDiv6").style.display="none";
						$(".dispContactDiv_6").removeClass('dp');
					}
				//~ }
            }
            trig6=false;           
        }
        else{
            document.getElementById("dropDownDiv6").style.display="none";
			$('.f_contacts6').css("border","1px solid #fff");
			$('.f_contacts6').css("background","none");
			$(".dispContactDiv_6").removeClass('dp');
            trig6=true;
        }
    }    

    else if(flag7){ 
        if(trig7){

            if(document.getElementById("dropDownDiv7").innerHTML!=''){               
              //~ for(var i=start_val;i<end_Val;i++){
					var drop=7;
					if(drop){ 
						 document.getElementById("dropDownDiv7").style.display="block";
                		 $(".selectBoxLanguage").css("background","url(('/assets/register/selece_box_normal.png') no-repeat scroll 0 0 transparent");
					}
					else{
						document.getElementById("dropDownDiv7").style.display="none";
						$(".dispContactDiv_7").removeClass('dp');
					}
				//~ }
            }
            trig7=false;           
        }
        else{
            document.getElementById("dropDownDiv7").style.display="none";
			$('.f_contacts7').css("border","1px solid #fff");
			$('.f_contacts7').css("background","none");
			$(".dispContactDiv_7").removeClass('dp');
            trig7=true;
        }
    }    


/*    else if(flag8){ 
        if(trig8){

            if(document.getElementById("dropDownDiv8").innerHTML!=''){               
              for(var i=start_val;i<end_Val;i++){	
					if(i==8){ 
						 document.getElementById("dropDownDiv8").style.display="block";
                		 $(".selectBoxLanguage").css("background","url(('/assets/register/selece_box_normal.png') no-repeat scroll 0 0 transparent");
					}
					else{
						document.getElementById("dropDownDiv"+i).style.display="none";
						$(".dispContactDiv_"+i).removeClass('dp');
					}
				}
            }
            trig8=false;           
        }
        else{
            document.getElementById("dropDownDiv8").style.display="none";
			$('.f_contacts8').css("border","1px solid #fff");
			$('.f_contacts8').css("background","none");
			$(".dispContactDiv_8").removeClass('dp');
            trig8=true;
        }
    }    

    else if(flag9){ 
        if(trig9){

            if(document.getElementById("dropDownDiv9").innerHTML!=''){               
              for(var i=start_val;i<end_Val;i++){	
					if(i==9){ 
						 document.getElementById("dropDownDiv9").style.display="block";
                		 $(".selectBoxLanguage").css("background","url(('/assets/register/selece_box_normal.png') no-repeat scroll 0 0 transparent");
					}
					else{
						document.getElementById("dropDownDiv"+i).style.display="none";
						$(".dispContactDiv_"+i).removeClass('dp');
					}
				}
            }
            trig9=false;           
        }
        else{
            document.getElementById("dropDownDiv9").style.display="none";
			$('.f_contacts9').css("border","1px solid #fff");
			$('.f_contacts9').css("background","none");
			$(".dispContactDiv_9").removeClass('dp');
            trig9=true;
        }
    }    

    else if(flag10){ 
        if(trig10){

            if(document.getElementById("dropDownDiv10").innerHTML!=''){               
              for(var i=start_val;i<end_Val;i++){	
					if(i==10){ 
						 document.getElementById("dropDownDiv10").style.display="block";
                		 $(".selectBoxLanguage").css("background","url(('/assets/register/selece_box_normal.png') no-repeat scroll 0 0 transparent");
					}
					else{
						document.getElementById("dropDownDiv"+i).style.display="none";
						$(".dispContactDiv_"+i).removeClass('dp');
					}
				}
            }
            trig10=false;           
        }
        else{
            document.getElementById("dropDownDiv10").style.display="none";
			$('.f_contacts10').css("border","1px solid #fff");
			$('.f_contacts10').css("background","none");
			$(".dispContactDiv_10").removeClass('dp');
            trig10=true;
        }
    }   
	
    else if(flag11){ 
        if(trig11){

            if(document.getElementById("dropDownDiv11").innerHTML!=''){               
              for(var i=start_val;i<end_Val;i++){	
					if(i==11){ 
						 document.getElementById("dropDownDiv11").style.display="block";
                		 $(".selectBoxLanguage").css("background","url(('/assets/register/selece_box_normal.png') no-repeat scroll 0 0 transparent");
					}
					else{
						document.getElementById("dropDownDiv"+i).style.display="none";
						$(".dispContactDiv_"+i).removeClass('dp');
					}
				}
            }
            trig11=false;           
        }
        else{
            document.getElementById("dropDownDiv11").style.display="none";
			$('.f_contacts11').css("border","1px solid #fff");
			$('.f_contacts11').css("background","none");
			$(".dispContactDiv_11").removeClass('dp');
            trig11=true;
        }
    }  
    else if(flag12){ 
        if(trig12){

            if(document.getElementById("dropDownDiv12").innerHTML!=''){               
              for(var i=start_val;i<end_Val;i++){	
					if(i==12){ 
						 document.getElementById("dropDownDiv12").style.display="block";
                		 $(".selectBoxLanguage").css("background","url(('/assets/register/selece_box_normal.png') no-repeat scroll 0 0 transparent");
					}
					else{
						document.getElementById("dropDownDiv"+i).style.display="none";
						$(".dispContactDiv_"+i).removeClass('dp');
					}
				}
            }
            trig12=false;           
        }
        else{
            document.getElementById("dropDownDiv12").style.display="none";
			$('.f_contacts12').css("border","1px solid #fff");
			$('.f_contacts12').css("background","none");
			$(".dispContactDiv_12").removeClass('dp');
            trig12=true;
        }
    }    
	
    else if(flag13){ 
        if(trig13){

            if(document.getElementById("dropDownDiv13").innerHTML!=''){               
              for(var i=start_val;i<end_Val;i++){	
					if(i==13){ 
						 document.getElementById("dropDownDiv13").style.display="block";
                		 $(".selectBoxLanguage").css("background","url(('/assets/register/selece_box_normal.png') no-repeat scroll 0 0 transparent");
					}
					else{
						document.getElementById("dropDownDiv"+i).style.display="none";
						$(".dispContactDiv_"+i).removeClass('dp');
					}
				}
            }
            trig13=false;           
        }
        else{
            document.getElementById("dropDownDiv13").style.display="none";
			$('.f_contacts13').css("border","1px solid #fff");
			$('.f_contacts13').css("background","none");
			$(".dispContactDiv_13").removeClass('dp');
            trig13=true;
        }
    }    
*/	
    else{
	    
	document.getElementById("dropDownDiv5").style.display="none";
	trig5=true;
	document.getElementById("dropDownDiv6").style.display="none";
	trig6=true;
	document.getElementById("dropDownDiv7").style.display="none";
	trig7=true;
/*	document.getElementById("dropDownDiv8").style.display="none";
	trig8=true;
	document.getElementById("dropDownDiv9").style.display="none";
	trig9=true;
	document.getElementById("dropDownDiv10").style.display="none";
	trig10=true;
	document.getElementById("dropDownDiv11").style.display="none";
	trig11=true;
	document.getElementById("dropDownDiv12").style.display="none";
	trig12=true;
	document.getElementById("dropDownDiv13").style.display="none";
	trig13=true;
	$(".dispContactDiv_5").removeClass('dp');
	trig5=true;
	$("#dispContactDiv_6").removeClass('dp');
	trig6=true;
	$(".dispContactDiv_7").removeClass('dp');
	trig7=true;
	$(".dispContactDiv_8").removeClass('dp');
	trig8=true;
	$(".dispContactDiv_9").removeClass('dp');
	trig9=true;
	$(".dispContactDiv_10").removeClass('dp');
	trig10=true;
	$(".dispContactDiv_11").removeClass('dp');
	trig11=true;
	$(".dispContactDiv_12").removeClass('dp');
	trig12=true;
	$(".dispContactDiv_13").removeClass('dp');
	trig13=true;
*/	
	    
   }
}
//var cflag=0;
	var startVal=5;
	var endVal=8;
function setvalue(val1,val2,val3,drop_id,type_id,info_id){	
	//cflag=1;
	if(val1=='Famtivity Contacts')
	{
			  for(var i=startVal;i<endVal;i++)
			{
				if(i==drop_id){
					$(".dispContactDiv_"+i).addClass('dp');
					//$('.f_contacts').addClass('f_contacts'+i);
					 $('.f_contacts'+i).css("border","1px solid #afd5e0");
					 $('.f_contacts'+i).css("background","#e5f4f9");
					$("#dropDownDiv"+drop_id).css('display','block');
					document.getElementById('visible_to_'+val3).value=type_id;
				       document.getElementById('type_id_'+val3).value=info_id;
				       document.getElementById('visible_to_field_'+val3).innerHTML=val1;
				       document.getElementById('visible_to_field_'+val3).style.color='#444444';
				}

			else{
				$(".dispContactDiv_"+i).removeClass('dp');
				//$('.f_contacts').removeClass('f_contacts'+i);
				$('.f_contacts'+i).css("border","1px solid #fff");
				$('.f_contacts'+i).css("background","none");
				$("#dropDownDiv"+i).css('display','none');
			}
		     }
	
	}
	else{		
	  $('.f_contacts'+i).css("border","1px solid #fff");
	  $('.f_contacts'+i).css("background","none");
	  $(".dispContactDiv_"+drop_id).removeClass('dp');
	  $("#contact_id_"+val3).val('');
	$("#fam_contact #contactList_"+drop_id+" input[type='checkbox']").attr("checked", false);	
	$("#fam_contact #contactList_"+drop_id+" label").addClass("altCheckboxOff").removeClass("altCheckboxOn");
     	document.getElementById('visible_to_'+val3).value=type_id;
        document.getElementById('type_id_'+val3).value=info_id;
        document.getElementById('visible_to_field_'+val3).innerHTML=val1;
        document.getElementById('visible_to_field_'+val3).style.color='#444444';	
		$("#dropDownDiv"+drop_id).css('display','none');
	 // cflag=2;
	}
/*	a_index=$("#set_value").index();
	alert(a_index);
*/ 
    
    $("#dropDownDiv"+i).css('display','none');
	//alert(cflag);
}
function closeFamtivityContact(){
	  $('.f_contacts').css("border","1px solid #fff");
	  $('.f_contacts').css("background","none");
	  $(".dispContactDiv_"+val).removeClass('dp');
	  $("#dropDownDiv5").css('display','none');
	 // cflag=0;
}
function showFamtivityContact(){
	  $('.f_contacts').css("border","1px solid #fff");
	  $('.f_contacts').css("background","none");
	  $(".dispContactDiv_"+val).addClass('dp');
	  $("#dropDownDiv5").css('display','block');
	 // cflag=1;
	  
}

/******checkbox Sponosr********/

function dispCheckboxImg_sp(imgName){
    if(imgName == 'sp_checkbox_normal'){
        $('#sp_checkbox_normal').css('display','none');
        $('#sp_checkbox_error').css('display','none');
        $('#sp_checkbox_selected').css('display','block');
        $('#sp_agree_provider').val(7);
    }
    else if(imgName == 'sp_checkbox_error'){
        $('#sp_checkbox_normal').css('display','none');
        $('#sp_checkbox_error').css('display','none');
        $('#sp_checkbox_selected').css('display','block');
        $('#sp_agree_provider').val(7);
    }
	
	
    else{
        $('#sp_checkbox_selected').css('display','none');
        $('#sp_checkbox_normal').css('display','block');
        $('#sp_checkbox_error').css('display','none');
        $('#sp_agree_provider').val('');
    }
}


/******checkbox Sell********/

function dispCheckboxImg_sell(imgName){
    if(imgName == 'sell_checkbox_normal'){
        $('#sell_checkbox_normal').css('display','none');
        $('#sell_checkbox_error').css('display','none');
        $('#sell_checkbox_selected').css('display','block');
        $('#sell_agree_provider').val(7);
    }
    else if(imgName == 'sell_checkbox_error'){
        $('#sell_checkbox_normal').css('display','none');
        $('#sell_checkbox_error').css('display','none');
        $('#sell_checkbox_selected').css('display','block');
        $('#sell_agree_provider').val(7);
    }
	
	
    else{
        $('#sell_checkbox_selected').css('display','none');
        $('#sell_checkbox_normal').css('display','block');
        $('#sell_checkbox_error').css('display','none');
        $('#sell_agree_provider').val('');
    }
}


/*****************************************************

   Change password validation

*****************************************************/

    //~ function change_password_validation(){

      //~ var current_password= $("#current_password").val();
      //~ var new_password= $("#new_pass").val();
      //~ var confirm_password = $("#confirm_pass").val();
      //~ var pwd = $("#pwd").val();

      //~ $("#current_password").css("border","1px solid #BDD6DD");
      //~ $("#new_pass").css("border","1px solid #BDD6DD");
      //~ $("#confirm_pass").css("border","1px solid #BDD6DD");

      //~ $("#current_password_error").html("");
      //~ $("#new_pass_error").html("");
      //~ $("#confirm_password_error").html("");

      //~ $("#current_password_error").parent().css("display","none");
      //~ $("#new_pass_error").parent().css("display","none")
      //~ $("#confirm_password_error").parent().css("display","none");


      //~ var errorFlag = false;

      //~ $("#current_password").css("border","1px solid #CDE0E6");
      //~ $("#current_password_error").html("");
      //~ $("#current_password_error").parent().css("display","none");
      //~ $("#new_pass").css("border","1px solid #CDE0E6");
      //~ $("#new_pass_error").html("");
      //~ $("#new_pass_error").parent().css("display","none");
      //~ $("#confirm_pass").css("border","1px solid #CDE0E6");
      //~ $("#confirm_password_error").html("");
      //~ $("#confirm_password_error").parent().css("display","none");

      //~ current_password = current_password.replace(/^\s+|\s+$/g, "");
      //~ if(current_password == ""  || current_password =="password"){
        //~ $("#current_password").css("border","1px solid #fc8989");
        //~ $("#current_password_error").html("Please enter current password");
        //~ $("#current_password_error").parent().css("display","block");
        //~ errorFlag = true;
      //~ }
      //~ else if(current_password != pwd ){
       //~ // alert(pwd);
        //~ //alert(current_password);
        //~ $("#current_password").css("border","1px solid #fc8989");
        //~ $("#current_password_error").html("Please enter your correct current password");
        //~ $("#current_password_error").parent().css("display","block");
        //~ errorFlag = true;
      //~ }

      //~ new_password = new_password.replace(/^\s+|\s+$/g, "");
      //~ if(new_password == "" || new_password == "newpassword"){
        //~ $("#new_pass").css("border","1px solid #fc8989");
        //~ $("#new_pass_error").html("Please enter new password");
        //~ $("#new_pass_error").parent().css("display","block");
        //~ errorFlag = true;
      //~ }
      //~ else if(new_password.length<8){
        //~ $("#new_pass").css("border","1px solid #fc8989");
        //~ $("#new_pass_error").html("Must Have At least 8 Characters");
        //~ $("#new_pass_error").parent().css("display","block");
        //~ errorFlag = true;
      //~ }
      //~ else if(new_password == current_password){
        //~ $("#new_pass").css("border","1px solid #fc8989");
        //~ $("#new_pass_error").html("Your new password should be different");
        //~ $("#new_pass_error").parent().css("display","block");
        //~ errorFlag = true;
      //~ }
      //~ confirm_password = confirm_password.replace(/^\s+|\s+$/g, "");
      //~ if(confirm_password == "" || confirm_password == "newpassword"){
        //~ $("#confirm_pass").css("border","1px solid #fc8989");
        //~ $("#confirm_password_error").html("Please enter confirm password");
        //~ $("#confirm_password_error").parent().css("display","block");
        //~ errorFlag = true;
      //~ }
      //~ else if(confirm_password != new_password){
        //~ $("#confirm_pass").css("border","1px solid #fc8989");
        //~ $("#confirm_password_error").html("Please enter the correct confirm password");
        //~ $("#confirm_password_error").parent().css("display","block");
        //~ errorFlag = true;
      //~ }

      //~ if(errorFlag){
        //~ return false;
      //~ }
      //~ else{
      //~ //  $.post($(this).attr('action'), $(this).serialize(), null, "script");
        //~ return false;
      //~ }

	//~ }

  /*clear fields*/

  function clearpasswordfields(){
    $("#current_password").css("border","1px solid #BDD6DD");
    $("#new_pass").css("border","1px solid #BDD6DD");
    $("#confirm_pass").css("border","1px solid #BDD6DD");

    $("#current_password_error").html("");
    $("#new_pass_error").html("");

    $("#confirm_password_error").html("");

    $("#current_password_error").parent().css("display","none");
    $("#new_pass_error").parent().css("display","none")
    $("#confirm_password_error").parent().css("display","none");
    $('.success_update_info').css('display', 'none');

  }
  
  /**************************************

      Block User Validation
  
  **************************************/
  
  //~ function block_validation(){
	  
	  //~ var block_name= $("#block_name").val();
	  //~ var block_email= $("#block_email").val();
	  
	  //~ $("#block_name").css("border 1px solid #BDD6DD");
	  //~ $("#block_email").css("border 1px solid #BDD6DD");
	  
	  //~ $("#block_name_error").parent().css("display","none");
	  //~ $("#block_email_error").parent().css("display","none");
	  
	  //~ $("#block_name_error").html();
	  //~ $("#block_email_error").html();
	  
	  //~ var errorFlag=false;
	  
	  //~ if(block_name == ""){
        //~ $("#block_name").css("border 1px solid #fc8989");
		//~ $("#block_name_error").html("Please enter the name");
		//~ $("#block_name_error").parent().css("display","block");
		//~ errorFlag=true;
      //~ }
	  
	  //~ else if(!validateName(block_name)){
        //~ $("#block_name").css("border 1px solid #fc8989");
		//~ $("#block_name_error").html("Please enter the name");
		//~ $("#block_name_error").parent().css("display","block");
		//~ errorFlag=true;
      //~ }
	  
	  //~ if(block_email == ""){
                //~ $("#block_email").css("border 1px solid #fc8989");
		//~ $("#block_email_error").html("Please enter the email");
		//~ $("#block_email_error").parent().css("display","block");
		//~ errorFlag=true;
      //~ }
	 //~ else if(!validateCorrectEmail(block_email)){
                //~ $("#block_email").css("border 1px solid #fc8989");
		//~ $("#block_email_error").html("Please Check The Email Address Entered");
		//~ $("#block_email_error").parent().css("display","block");
		//~ errorFlag=true;
      //~ }
	  //~ if(errorFlag)
	  //~ {
		  	//~ return false;
	  //~ }
	  //~ else{
		    //~ return true;
	  //~ }
  //~ }

function validateName(elementValue){
    var alphaExp = /^[a-zA-Z ]*$/;
    return alphaExp.test(elementValue);
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


/***********************************

  mobile validation

**********************************/

function mobile_validation(){
	  var mobile_code= $("#cfm_code").val();
	  $("#block_name").css("border 1px solid #BDD6DD");
	  $("#confirm_code_error").parent().css("display","none");
	  $("#confirm_code_error").html();
	  
	  var errorFlag=false;
	  
	  if(mobile_code == "" || mobile_code == "Confirmation code"){
        $("#cfm_code").css("border 1px solid #fc8989");
		$("#confirm_code_error").html("Please enter the code");
		$("#confirm_code_error").parent().css("display","block");
		errorFlag=true;
      }
	  if(errorFlag)
	  {
		  	return false;
	  }
	  else{
		    return true;
	  }
}
function get_fb_value(val,id)
{
	var str="";
	
	//store the values in hidden fields
	if(val<4){
	str = $("#social_id_1").val();
	if ($("#row"+val).is(':checked')) 
		{
		str+=","+id;	
		}
	else
		{
			
		var a=$("#social_id_1").val(); 
			
			
		str=a.replace(id,"");
			
			
		}
	$("#social_id_1").val(str);  
	}
	//the values in 4 and 8
	if(val>3 && val<7)
	{
	str = $("#social_id_2").val();
	if ($("#row"+val).is(':checked')) 
		{
		str+=","+id;	
		}
	else
		{
		var a=$("#social_id_2").val(); 
		str=a.replace(id,"");
		}
	$("#social_id_2").val(str);  
	}
	//the values in 9 to 12
	if(val>6 && val<10){
	str = $("#social_id_3").val();
	if ($("#row"+val).is(':checked')) 
		{
		str+=","+id;	
		}
	else
		{
		var a=$("#social_id_3").val(); 
		str=a.replace(id,"");
		}
	$("#social_id_3").val(str);  
	}
		
}

//~ function get_gp_value(value,id)
//~ {
	//~ var str="";
	
	//~ if(id<5){
	//~ str = $("#group_id_1").val();
	//~ if ($("#g"+id).is(':checked')) 
		//~ {
			//~ alert('checked');
		//~ str+=","+id;	
		//~ }
	//~ else
		//~ {
			//~ alert('not');
		//~ var a=$("#group_id_1").val(); 
		//~ str=a.replace(","+id,"");
		//~ }
	//~ $("#group_id_1").val(str);  
	//~ }
	
//~ }



function validateCorrectEmail(elementValue){  
    var emailPattern = /^([a-zA-Z0-9]+([~{|}`^?=+*'#$!%._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,3}(?:\.[a-zA-Z]{2,3})?)$/;
    return emailPattern.test(elementValue);
}

/* Group Drop down */
function groupDropDown(i){
    if(flag8){
        if(trig8)
		{  
            if(document.getElementById("dropDownDiv8").innerHTML!='')
			{  
				if(i==8)
				{ 
					document.getElementById("dropDownDiv"+i).style.display="block";
				}
				else
				{
					document.getElementById("dropDownDiv"+i).style.display="none";
				}
				trig8=false;
            }			
        }
        else
		{
            document.getElementById("dropDownDiv8").style.display="none";
			$('.f_groups'+i).css("border","1px solid #fff");
			$('.f_groups'+i).css("background","none");
            trig8=true;
        }
    }
}

function setvalue_group(val,id_val,i_val,drop_id,gid)
{
   if(drop_id == 8)
   {
	 $('.f_groups'+drop_id).css("border","1px solid #afd5e0");
	 $('.f_groups'+drop_id).css("background","#e5f4f9");
	 $("#dropDownDiv"+drop_id).css('display','block');
	 document.getElementById('group_id'+i_val).value=gid;
	 document.getElementById('field'+i_val).innerHTML=val;
	 document.getElementById('field'+i_val).style.color='#444444';
   }
   else
   {
	$('.f_groups'+drop_id).css("border","1px solid #fff");
	$('.f_groups'+drop_id).css("background","none");
	$("#dropDownDiv"+drop_id).css('display','none');
   }
   $("#dropDownDiv"+drop_id).css('display','none');
}


//user account delete popup calling
function delete_account(){
	$('#delete_account_feature').bPopup({
	fadeSpeed:100,
	followSpeed:100,
	opacity:0.8,
	positionStyle: 'fixed',
	modalClose: false,
	});
}

//user delete ajax calling 
function user_delete_call()
{
var user_id = $('#user_id_delete').val();
    $('#loading_img_delete').css("display","block");
    $.post("/user_account_delete", {"user_id":user_id}, null, "script");
    return false;
}

//once updated the user information destory user session
function user_destroy_call()
{
$('#user_deleted').hide();
$('#delete_account_feature').hide();
window.location.href="/logout"
}
