
$(document).ready(function(){
						 
    providerSettingsDropDown();
	
$('.settingsDropdown').click(function(){
    providerSettingsDropDown();
});
});
/*$(document).mousedown(function(){
	   $('#dispContactDiv').removeClass('dispBlock');
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
var end_Val=7;
var flag5=false;
var flag6=false;
//~ var flag7=false;
//~ var flag8=false;



var trig5=true;
var trig6=true;
//~ var trig7=true;
//~ var trig8=true;


function providerSettingsDropDown(){
    if(flag5){
        if(trig5){  
            if(document.getElementById("dropDownDiv5").innerHTML!=''){  
				for(var i=start_val;i<end_Val;i++){	
					if(i==5){ 
						document.getElementById("dropDownDiv5").style.display="block";
               			 $(".selectBoxCity").css("background","url('/assets/register/selece_box_normal.png') no-repeat");
					}
					else{
						//~ document.getElementById("dropDownDiv"+i).style.display="none";
						$(".dispContactDiv_"+i).removeClass('dispBlock');
					}
				}
			}

            trig5=false;           
        }
        else{
		
            document.getElementById("dropDownDiv5").style.display="none";
			$('.f_contacts5').css("border","1px solid #fff");
			$('.f_contacts5').css("background","none");
			$(".dispContactDiv_5").removeClass('dispBlock');
            trig5=true;
        }
    }    
    else if(flag6){ 
        if(trig6){

            if(document.getElementById("dropDownDiv6").innerHTML!=''){               
              for(var i=start_val;i<end_Val;i++){	
					if(i==6){ 
						 document.getElementById("dropDownDiv6").style.display="block";
                		 $(".selectBoxLanguage").css("background","url(('/assets/register/selece_box_normal.png') no-repeat scroll 0 0 transparent");
					}
					else{
						document.getElementById("dropDownDiv"+i).style.display="none";
						$(".dispContactDiv_"+i).removeClass('dispBlock');
					}
				}
            }
            trig6=false;           
        }
        else{
            document.getElementById("dropDownDiv6").style.display="none";
			$('.f_contacts6').css("border","1px solid #fff");
			$('.f_contacts6').css("background","none");
			$(".dispContactDiv_6").removeClass('dispBlock');
            trig6=true;
        }
    }    

    //~ else if(flag7){ 
        //~ if(trig7){

            //~ if(document.getElementById("dropDownDiv7").innerHTML!=''){               
              //~ for(var i=start_val;i<end_Val;i++){	
					//~ if(i==7){ 
						 //~ document.getElementById("dropDownDiv7").style.display="block";
                		 //~ $(".selectBoxLanguage").css("background","url(('/assets/register/selece_box_normal.png') no-repeat scroll 0 0 transparent");
					//~ }
					//~ else{
						//~ document.getElementById("dropDownDiv"+i).style.display="none";
						//~ $(".dispContactDiv_"+i).removeClass('dispBlock');
					//~ }
				//~ }
            //~ }
            //~ trig7=false;           
        //~ }
        //~ else{
            //~ document.getElementById("dropDownDiv7").style.display="none";
			//~ $('.f_contacts7').css("border","1px solid #fff");
			//~ $('.f_contacts7').css("background","none");
			//~ $(".dispContactDiv_7").removeClass('dispBlock');
            //~ trig7=true;
        //~ }
    //~ }    


    //~ else if(flag8){ 
        //~ if(trig8){

            //~ if(document.getElementById("dropDownDiv8").innerHTML!=''){               
              //~ for(var i=start_val;i<end_Val;i++){	
					//~ if(i==8){ 
						 //~ document.getElementById("dropDownDiv8").style.display="block";
                		 //~ $(".selectBoxLanguage").css("background","url(('/assets/register/selece_box_normal.png') no-repeat scroll 0 0 transparent");
					//~ }
					//~ else{
						//~ document.getElementById("dropDownDiv"+i).style.display="none";
						//~ $(".dispContactDiv_"+i).removeClass('dispBlock');
					//~ }
				//~ }
            //~ }
            //~ trig8=false;           
        //~ }
        //~ else{
            //~ document.getElementById("dropDownDiv8").style.display="none";
			//~ $('.f_contacts8').css("border","1px solid #fff");
			//~ $('.f_contacts8').css("background","none");
			//~ $(".dispContactDiv_8").removeClass('dispBlock');
            //~ trig8=true;
        //~ }
    //~ }    
	
    else{
	document.getElementById("dropDownDiv5").style.display="none";
	$(".dispContactDiv_5").removeClass('dispBlock');
	trig5=true;
	//~ document.getElementById("dropDownDiv6").style.display="none";
	$("#dispContactDiv_6").removeClass('dispBlock');
	trig6=true;
	//~ document.getElementById("dropDownDiv7").style.display="none";
	//~ $(".dispContactDiv_7").removeClass('dispBlock');
	//~ trig7=true;
	//~ document.getElementById("dropDownDiv8").style.display="none";
	//~ $(".dispContactDiv_8").removeClass('dispBlock');
	//~ trig8=true;
	
   }
}
	var startVal=5;
	var endVal=14;
function setvalue(val1,val2,val3,drop_id,info_id,selection_id){
	if(val1=='Famtivity Contacts')
	{
			  for(var i=startVal;i<endVal;i++)
			{
				if(i==drop_id){
					$(".dispContactDiv_"+i).addClass('dispBlock');
					//$('.f_contacts').addClass('f_contacts'+i);
					 $('.f_contacts'+i).css("border","1px solid #afd5e0");
					 $('.f_contacts'+i).css("background","#e5f4f9");
					$("#dropDownDiv"+drop_id).css('display','block');
					document.getElementById('visible_to_'+val3).value=selection_id;
				       document.getElementById('type_id_'+val3).value=info_id;
				       document.getElementById('visible_to_field_'+val3).innerHTML=val1;
				       document.getElementById('visible_to_field_'+val3).style.color='#444444';
				}

			else{
				$(".dispContactDiv_"+i).removeClass('dispBlock');
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
	  $(".dispContactDiv_"+drop_id).removeClass('dispBlock');
	  $("#contact_id_"+val3).val('');
	$("#fam_contact #contactList_"+drop_id+" input[type='checkbox']").attr("checked", false);	
	$("#fam_contact #contactList_"+drop_id+" label").addClass("altCheckboxOff").removeClass("altCheckboxOn");
     	document.getElementById('visible_to_'+val3).value=selection_id;
        document.getElementById('type_id_'+val3).value=info_id;
        document.getElementById('visible_to_field_'+val3).innerHTML=val1;
        document.getElementById('visible_to_field_'+val3).style.color='#444444';	
		$("#dropDownDiv"+drop_id).css('display','none');
	}
    
    $("#dropDownDiv"+i).css('display','none');
}
function closeFamtivityContact(){
	  $('.f_contacts').css("border","1px solid #fff");
	  $('.f_contacts').css("background","none");
	  $(".dispContactDiv_"+val).removeClass('dispBlock');
	  $("#dropDownDiv5").css('display','none');
	 // cflag=0;
}
function showFamtivityContact(){
	  $('.f_contacts').css("border","1px solid #fff");
	  $('.f_contacts').css("background","none");
	  $(".dispContactDiv_"+val).addClass('dispBlock');
	  $("#dropDownDiv5").css('display','block');
	  
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
	//alert(val+id);
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
	if(val>3&& val<7)
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



