/*****************************************************
	actuvutt participant message form validaton
*****************************************************/ 
var participantMsgPage;
function pop_participant_message_form(url){
    participantMsgPage = dhtmlmodal.open("Participant Message","iframe",url," ", "width=923px,height=600px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({ scrollTop: 0 }, 100);
    return false;
}
function send_message(){
	var send_to = $("#send_to").val();
	var subject = $("#subject").val();
	var message = $("#message").val();
	message = message.replace(/^\s+|\s+$/g, "");

	$("#send_to").css("border","1px solid #CDE0E6");
	$("#send_to_error").parent().css("display","none");
	$("#send_to_error").html("");
	
	$("#subject").css("border","1px solid #BDD6DD");	
	$("#subject_error").html("");
	$("#subject_error").parent().css("display","none");
	
	$("#message").css("border","1px solid #BDD6DD");
	$("#message_error").html("");
	$("#message_error").parent().css("display","none");

	var errorFlag = false;
	if(send_to == ""){
		$("#send_to").css("border","1px solid #fc8989");
		$("#send_to_error").parent().css("display","block");
		$("#send_to_error").html("Please enter one contact");
		errorFlag = true;
	}
	if(send_to!="")
	{
		if(!validateCorrectEmailMessage(send_to)){
			$("#send_to").css("border","1px solid #fc8989");
			$("#send_to_error").parent().css("display","block");
			$("#send_to_error").html("Please enter a valid email address(Use comma separated value for mutiple email)");
			errorFlag = true;
		}
	}
	if(subject == "" ){
		$("#subject").css("border","1px solid #fc8989");
		$("#subject_error").html("Please enter a subject");
		$("#subject_error").parent().css("display","block");
		errorFlag = true;
	}
	if(message == "" ){
		$("#message").css("border","1px solid #fc8989");
		$("#message_error").html("Please enter the message");
		$("#message_error").parent().css("display","block");
		errorFlag = true;
	}
	if(errorFlag){
		return false;
	} 
	else{
		
		//~ pop_participant_message_success('/participant_message_success');
		//~ $("#sendMessageNetwork").submit();
		 //~ $.get($("#sendMessageNetwork").attr('action'), $("#sendMessageNetwork").serialize(), null, "script");
		     $.ajax({
			url:'participant_message_success',
			data : $('#sendMessageNetwork').serialize(),
			success:function(data){
			if(data=='true'){
			 //~ closepopup();	
			 $('#messageSuccess').bPopup({fadeSpeed:100,followSpeed:100,opacity:0.8,positionStyle: 'absolute',modalClose: false});
		 
			 }
			}
		    }); 
		
		
		return false;
	}
}
/*****************************************
	actuvutt participant message form
*****************************************/ 
var participantMsgPage;
function pop_participant_message_success(url){
    participantMsgSuccPage = dhtmlmodal.open("Participant Message","iframe",url," ", "width=503px,height=225px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({ scrollTop: 0 }, 100);
    return false;
}

function Trim(str){  
	while(str.charAt(0) == (" ") )
	{ 
		str = str.substring(1);
	}
	while(str.charAt(str.length-1) == " " )
	{  
		str = str.substring(0,str.length-1);
	}
	return str;
}
function validateCorrectEmailMessage(elementValue){  
	flag=true;
	tot_len = elementValue.length;
	search_len = tot_len-2;
	to_chk_rem = elementValue.substring(search_len,tot_len);
	check_for_comma= jQuery.inArray( ",", to_chk_rem )
	if (check_for_comma!=-1){
		e=elementValue.substring(0,elementValue.length-2); 
	}
	else{
		e=elementValue
	}
	var emailSplitComma= e.split(",");
	if(emailSplitComma.length>0)
	{
		for(i=0;i<emailSplitComma.length; i++)
		{
			
			
			//if(Trim(emailSplitComma[i])!="")
			//{
				email=Trim(emailSplitComma[i]);

				var emailPattern = /^([a-zA-Z0-9]+([~{|}`^?=+*'#$!%._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,4}(?:\.[a-zA-Z]{2,3})?)$/;	

				if(emailPattern.test(email) == false)
				{
					flag=false;		
				}
				else
				{
					$("#msg_send_to").css("border","1px solid #CDE0E6");
					$("#send_to_error").parent().css("display","none");
					$("#send_to_error").html("");				  
				}
			//}
			//else{
			//	flag=false;	
			//}

		
		}
	}
	else
	{
		var emailPattern = /^([a-zA-Z0-9]+([~{|}`^?=+*'#$!%._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,4}(?:\.[a-zA-Z]{2,3})?)$/;
		if(emailPattern.test(email) == false)
		{
			flag=false;
			
		}
		else
		{
			$("#msg_send_to").css("border","1px solid #CDE0E6");
			$("#send_to_error").parent().css("display","none");
			$("#send_to_error").html("");
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

function validateEmail(field) { 
    var regex=/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i; 
    return (regex.test(field)) ? true : false; 
}
