function validateShareActivity(){	
    var send_to = $("#send_to").val();
    var subject = $("#subject").val();
    var act_id = $("#activity_id").val();
    var subjectLen = $.trim(subject).length;
    var message = $("#message").val();
    var messageLen = $.trim(message).length;
	
    $("#new_act_container .textboxDiv").css("border","1px solid #CDE0E6");
    $("#subject").css("border","1px solid #BDD6DD");
    $("#message").css("border","1px solid #BDD6DD");
	
    $("#send_to_error").html("");
    $("#subject_error").html("");
    $("#message_error").html("");
	
    $("#send_to_error").parent().css("display","none");
    $("#subject_error").parent().css("display","none");
    $("#message_error").parent().css("display","none");
	
    var errorFlag = false;


    if(send_to == ""){
        $("#new_act_container .textboxDiv").css("border","1px solid	#fc8989");
        $("#send_to_error").parent().css("display","block");
        $("#send_to_error").html("Please enter one contact");
        errorFlag = true;
    }
	if(send_to!="")
	{
		if(!validateCorrectEmail(send_to)){
        $("#new_act_container .textboxDiv").css("border","1px solid	#fc8989");
        $("#send_to_error").parent().css("display","block");
        $("#send_to_error").html("Please enter a valid email address");
        errorFlag = true;
		}
    }
/*    else if(!validateDot(send_to)){
        $("#new_act_container .textboxDiv").css("border","1px solid	#fc8989");
        $("#send_to_error").parent().css("display","block");
        $("#send_to_error").html("Please enter a valid email address");
        errorFlag = true;
    }*/

    if(subject == "" || subjectLen < 1 ){
        $("#subject").css("border","1px solid #fc8989");
        $("#subject_error").html("Please enter a subject for the share activity");
        $("#subject_error").parent().css("display","block");
        errorFlag = true;
    }
    if(message == "" || messageLen < 1 ){
        $("#message").css("border","1px solid #fc8989");
        $("#message_error").html("Please enter a message for the share activity");
        $("#message_error").parent().css("display","block");
        errorFlag = true;
    }
	
    if(errorFlag){
        return false;

    }
    return true;
    
//    if(errorFlag == false){
//        $.ajax({
//            type: "POST",
//            url: "share_activity_success",
//            data: {
//                "msg": message,
//                "subject":subject,
//                "to":send_to,
//                "id":act_id
//            },
//            dataType : 'json',
//            cache: false,
//            success: function(data){
//                parent.shareActivityPage.hide();
//                //parent.shareActivityPagethank.show();
//                pop_share_activity_thank('/share_activity_thank');
//            },
//            error : function(xhr,status,error){
//                alert(status);
//            }
//        });
//    }else{
//    //formSubmission();
//    //return false;
//
//
//    }
}

function formSubmission()
{
    alert("submt");
    $("#send").click(function()
    {
        //alert("test");
        // pop_share_activity_success('/share_activity_success');
        $("#createactivity").submit();
        //.shareActivityPage.hide();
        return true;
	

    });
//
}

function closepopup(){	
    /*
	 * Clear the fileds
	 */			
    $("#send_to").val('');
    $("#subject").val('');
    $("#message").val('');
	
    $("#new_act_container .textboxDiv").css("border","1px solid #CDE0E6");
    $("#subject").css("border","1px solid #BDD6DD");
    $("#message").css("border","1px solid #BDD6DD");
	
    $("#send_to_error").html("");
    $("#subject_error").html("");
    $("#message_error").html("");
	
    $("#send_to_error").parent().css("display","none");
    $("#subject_error").parent().css("display","none");
    $("#message_error").parent().css("display","none");
	
    parent.shareActivityPage.hide();
	//flag=2;
    
}
/*
var flag=1;
$(parent.window.document).click(function(){	
	if(flag==1){				
		parent.shareActivityPage.hide();	
		flag=2;
	}
});	*/
function clearShareFields(){
    $("#send_to").val('');
    $("#subject").val('');
    $("#message").val('');
	
    $("#new_act_container .textboxDiv").css("border","1px solid #CDE0E6");
    $("#subject").css("border","1px solid #BDD6DD");
    $("#message").css("border","1px solid #BDD6DD");
	
    $("#send_to_error").html("");
    $("#subject_error").html("");
    $("#message_error").html("");
	
    $("#send_to_error").parent().css("display","none");
    $("#subject_error").parent().css("display","none");
    $("#message_error").parent().css("display","none");

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
function Trim(str)
{  while(str.charAt(0) == (" ") )
  {  str = str.substring(1);
  }
  while(str.charAt(str.length-1) == " " )
  {  str = str.substring(0,str.length-1);
  }
  return str;
}

function validateEmail(field) { 
    var regex=/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i; 
    return (regex.test(field)) ? true : false; 
}

function validateCorrectEmail(elementValue){  
	flag=true;
	 var emailSplitComma= elementValue.split(",");
	 //alert(emailSplitComma);
	if(emailSplitComma.length>0)
	{
		for(i=0;i<emailSplitComma.length; i++)
		{
			if(Trim(emailSplitComma[i])!="")
			{
				email=Trim(emailSplitComma[i]);
				var emailPattern = /^([a-zA-Z0-9]+([~{|}`^?=+*'#$!%._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,3}(?:\.[a-zA-Z]{2,3})?)$/;
				if(emailPattern.test(email) == false)
				{
					flag=false;		
				}
				
				else
				{
				   $("#send_to_error").hide();
				   $("#new_act_container .textboxDiv").css("border","1px solid	#BDD6DD");
					$("#send_to_error").parent().css("display","none");
				}
			}
		
		}
	}
	else
	{
		var emailPattern = /^([a-zA-Z0-9]+([~{|}`^?=+*'#$!%._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,3}(?:\.[a-zA-Z]{2,3})?)$/;
		if(emailPattern.test(email) == false)
		{
			flag=false;
			
		}
		
		else
		{
		   $("#send_to_error").hide();
		   $("#new_act_container .textboxDiv").css("border","1px solid	#BDD6DD");
			$("#send_to_error").parent().css("display","none");
		}
	}
	if(!flag)
	{
	   $("#send_to_error").show();
	   return false;
	   
	}
	else
	{
		return true;
	}
	
	}







