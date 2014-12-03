function closepopup(url){
	if(navigator.appName=="Microsoft Internet Explorer")
    {
        window.location.hash='/';
    }
    else
    {
        parent.history.replaceState("", "", url);
    }
	
	parent.newMessageForm.hide();	
}
function send_message(cmode){
	$('#loadingmessage').show();
	var send_to = $("#msg_send_to").val();
	var subject = $("#subject").val();	
	var messager_photo=$("#messager_photo").val();
	var message_html = $("#message_content").val();
	//~ var message_html = $("#redactor_content").html();
	$("#cmt").val(message_html);        
	var message = $("#message_content").val(); 	
	message = message.replace(/^\s+|\s+$/g, "");
	var ext = messager_photo.split('.').pop().toLowerCase();
	$("#msg_send_to").css("border","1px solid #CDE0E6");
	$("#send_to_error").parent().css("display","none");
	$("#send_to_error").html("");
	
	$("#subject").css("border","1px solid #BDD6DD");	
	$("#subject_error").html("");
	$("#subject_error").parent().css("display","none");
	
	$("#h_image").css("border","1px solid #BDD6DD");
	$("#messager_photo_error").parent().css("display","none");
	$("#messager_photo_error").html("");
	
	$(".redactor_box").css("border","1px solid #BDD6DD");
	$("#message_error").html("");
	$("#message_error").parent().css("display","none");

	var errorFlag = false;
	if(send_to == ""){
		$("#sendto_text_dv").css("border","1px solid #fc8989");
		$("#send_to_error").parent().css("display","block");
		$("#send_to_error").html("Please specify at least one recipient");
		errorFlag = true;
	}
	else{
		$("#sendto_text_dv").css("border","1px solid #CDE0E6");
	}
	if(send_to!="")
	{
		if(!validateCorrectEmailtest(send_to)){
			$("#sendto_text_dv").css("border","1px solid #fc8989");
			$("#send_to_error").parent().css("display","block");
			$("#send_to_error").html("Please enter a valid email address(Use comma separated value for mutiple email)");
			errorFlag = true;
		}
		else{
		$("#sendto_text_dv").css("border","1px solid #CDE0E6");
	}
	}
	
	if((subject=="Enter your Subject*") || (subject == "" )){
		$("#subject_text_dv").css("border","1px solid #fc8989");
		$("#subject_error").html("Please enter a subject");
		$("#subject_error").parent().css("display","block");
		errorFlag = true;
	}
	else{
		$("#subject_text_dv").css("border","1px solid #CDE0E6");
	}
	//if(messager_photo == ""){
	//	$("#messager_photo").css("border","1px solid #fc8989");
	//	$("#messager_photo_error").parent().css("display","block");
	//	$("#messager_photo_error").html("Please select a messager image");
	//	errorFlag = true;
	//}
	//if(messager_photo != ""){
	//	val_sell = validateBrowse();
	//	if(!val_sell){
	//		$('#messager_photo_error').html('Please select a messager image');
	//		errorFlag = true;
	//	}
	//}
	
      if(messager_photo != "" && messager_photo != "Image for the Post"){
	if($.inArray(ext, ['gif','png','jpg','jpeg','bmp']) == -1) {
		$("#h_image").css("border","1px solid #fc8989");
		$("#messager_photo_error").html("Please select an valid image");
		$("#messager_photo_error").parent().css("display","block");
		errorFlag = true;
	}
     }
	
	if((message == "" ) || (message=="Enter your Message*")){
		//~ $(".redactor_box").css("border","1px solid #fc8989");
		$("#message_content").css("border","1px solid #fc8989");
		$("#message_error").html("Please enter the message");
		$("#message_error").parent().css("display","block");
		errorFlag = true;
	}
	else{
		$("#message_content").css("border","1px solid #CDE0E6");
	}
	if(errorFlag){
		$(".popupContainer").css("height","800px")
		$('#loadingmessage').hide();
		return false;
	} 
	else{
	
    $('#createMessageNetwork').ajaxSubmit({
               success: function(data) {
		       if (data=='true'){
		       	window.location.href="/messages?mode="+cmode
			//$('html, body', window.parent.document).animate({scrollTop:0}, 'slow');
			//$('#new_act_container').hide();
		     //   $('#messageSuccess').bPopup({fadeSpeed:100,followSpeed:100,opacity:0.8,position: 'absolute',modalClose: false}); 
	               }
		}
        });
		return false;
	}
}


function validateBrowse(){
	var fup = document.getElementById('messager_photo');
	var fileName = fup.value;
	var ext = fileName.substring(fileName.lastIndexOf('.') + 1);
	if(ext == "gif" || ext == "GIF" || ext == "JPEG" || ext == "jpeg" || ext == "jpg" || ext == "JPG" || ext == "png" || ext == "PNG")
	{
		//errorFlag = false;
		return true;
	}
	else
	{        
		$('#messager_photo').parent().css("display","block");
		$("#messager_photo_error").css("border","1px solid #fc8989");
		$('#messager_photo_error').html('Please Check The Format Of Your Image');
		return false;
	}
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
function validateCorrectEmailtest(elementValue){  
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
function fakepath(filepath){
	inputNode = filepath.replace('C:\\fakepath\\', '');
	var pos = filepath.lastIndexOf( filepath.charAt( filepath.indexOf(":")+1) );
	var filename = filepath.substring( pos+1);

	var ua=navigator.userAgent;

	if(ua.indexOf("Firefox")!=-1){
	$("#messager_photo").val(filepath);
	}
	else {
	$("#messager_photo").val(filename);
	}
}


$(document).ready(function (){ 
    //~ $('#redactor_content').redactor({ focus: true });
    $("#message_count").hide();
    $('#activity_table').hide();
	$('#offer_table').hide();
	$('#valid_table').hide();
	
	/*  Find Current time */
    var curTime = new Date();

    var curTime = new Date();
    var cdate = curTime.getDate();
    var ccmonth = curTime.getMonth();
    var cyear = curTime.getFullYear();
    ccmonth = parseInt(ccmonth) + 1;
    var weekday = new Array(7);
    weekday[0] = "Sun";
    weekday[1] = "Mon";
    weekday[2] = "Tue";
    weekday[3] = "Wed";
    weekday[4] = "Thu";
    weekday[5] = "Fri";
    weekday[6] = "Sat";
    var cday = curTime.getDay();
    var incval = parseInt(cday) + 1;
    var dayname = weekday[cday];
  
    var monthNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];    
    var cmonth = monthNames[curTime.getMonth()];

    var cuday = dayname + ", " + cmonth + " " + cdate + ", " + cyear;
    var repeat_day = ccmonth + "/" + cdate + "/" + cyear;
    //var date_value = cdate + "-" + cmonth + "-" + cyear;
    var date_value = cyear + "-" + ccmonth + "-" + cdate;

    //$('#date_1_1').val(date_value);
    //$('#dateFormate_1_1').val(cuday);
    //$('#date_2_1').val(date_value);
   // $('#dateFormate_2_1').val(cuday);
    
    $('#message_type').change(function() {    
    var item=$(this);
    var type=item.val();
    
    if(type == 'message')
    {
	$('#activity_table').hide();
	$('#offer_table').hide();
	$('#valid_table').hide();
	$('#attachment_table').show();
    }
    else if(type == 'offer')
    {
	$('#activity_table').show();
	$('#offer_table').show();
	$('#valid_table').show();
	$('#subject_table').hide();
	$('#img_table').hide();
	$('#attachment_table').hide();
	$('#attachfile_table').hide();
    }
    else
    {
	$('#activity_table').show();
	$('#subject_table').show();
	$('#offer_table').hide();
	$('#valid_table').hide();
	$('#img_table').hide();
	$('#attachfile_table').show();
    }
    
    });
   
});
 
function dispCheck(status)
{
	var checked;   // 0(unchecked)-- 1(checked)
	if(status=='checkbox_selected')
	{
	$("#checkbox_selected").css("display","none");
	$("#checkbox_normal").css("display","block");
	//~ $("#checkbox_normal").attr("disp","0");
	//~ checked=$("#checkbox_normal").attr("disp");
	$("#show_msg_card").val('0');
	$("#message_count").hide();
	}
	else{
	$("#checkbox_normal").css("display","none");
	$("#checkbox_selected").css("display","block");
	//~ $("#checkbox_selected").attr("disp","1");
	//~ checked=$("#checkbox_selected").attr("disp");
	$("#show_msg_card").val('1');
	$("#message_count").show();
	}
	//alert(checked);
}
