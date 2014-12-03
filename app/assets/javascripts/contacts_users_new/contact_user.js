$(document).ready(function(){
    $('#pe').val(0);
    $('#select').css('display','none');
    $('#not_select').css('display','inline-block');
	
    $('.activityName .contact_checkbox_selected').css('display','none');
    $('.activityName .contact_checkbox_normal').css('display','inline-block');
    
//    $('#menu_contact ul li ul li').mouseover(function(){
//	$('#contact_menu').css({"border":"1px solid #A9D3E1","border-bottom":"none","background":"#E6F5F8","font-weight":"bold"});
//    }).mouseout(function(){
//	$('#contact_menu').css({"border":"none","border-bottom":"none","background":"none","font-weight":"bold"});
//    });
//    
//    $('#menu_group ul li ul li').mouseover(function(){
//	$('#group_menu').css({"border":"1px solid #A9D3E1","border-bottom":"none","background":"#E6F5F8","font-weight":"bold"});
//    }).mouseout(function(){
//	$('#group_menu').css({"border":"none","border-bottom":"none","background":"none","font-weight":"bold"});
//    });

});
var checked = false;
function importAll () {
if (checked == false){checked = true}else{checked = false}
for (var i = 0; i < document.getElementById('contact_form').elements.length; i++) {
document.getElementById('contact_form').elements[i].checked = checked;
if(document.getElementById('parent_checkbox').checked == true){
	checked = true;
}
else{
	checked = false;
}
}
}
function unselect(){
		document.getElementById('parent_checkbox').checked =false;
}
function selectAnyCont(cname){	
    if(cname == 'select'){
        $('#select').css('display','none');
        $('#not_select').css('display','inline-block');
        
        $('.activityName .contact_checkbox_selected').css('display','none');
        $('.activityName .contact_checkbox_normal').css('display','inline-block');
        $('.activityName .net_contact_checkbox_selected').css('display','none');
        $('.activityName .net_contact_checkbox_normal').css('display','inline-block');

        $('#pe').val(0);
        $('input.contact_checkbox').val(0);
        $('#contact_names').val(' ');
        $('input.net_contact_checkbox').val(0);
        $('#net_contact_names').val(' ');
		
    }
    else if(cname == 'not_select'){
        $('#not_select').css('display','none');
        $('#select').css('display','inline-block');
        
        $('.activityName .contact_checkbox_normal').css('display','none');
        $('.activityName .contact_checkbox_selected').css('display','inline-block');
        $('.activityName .net_contact_checkbox_normal').css('display','none');
        $('.activityName .net_contact_checkbox_selected').css('display','inline-block');
		
        $('#pe').val(1);
        $('input.contact_checkbox').val(1);
        $('#contact_names').val(' ');
        $('input.net_contact_checkbox').val(1);
        $('#net_contact_names').val(' ');
	
        joinVal();
    }
check_request_message();	
}
function dispCheckSelected(incVal){
    $('#select').css('display','none');
    $('#not_select').css('display','inline-block');
    $('#pe').val(0);
	
    $('#contact_checkbox_selected_'+incVal).css('display','none');
    $('#contact_checkbox_normal_'+incVal).css('display','inline-block');
    $('#contact_checkbox_'+incVal).val(0);
    joinVal();
    check_request_message();
}
function dispCheckNormal(incVal){
    $('#contact_checkbox_selected_'+incVal).css('display','inline-block');
    $('#contact_checkbox_normal_'+incVal).css('display','none');
    $('#contact_checkbox_'+incVal).val(1);
    joinVal();
    check_request_message();
}
function joinVal(){
    var input_val='';
    var input_id ='';
    var joinStr1 ='';
    var joinStr2 ='';
    var cont_input_box_length=$('input.contact_checkbox').length;
	
    for(var i=1;i<=cont_input_box_length;i++)
    {
        input_val = $('#contact_checkbox_'+i).val();
        if(input_val!=0){
            input_id = $('#contact_id_'+i).val();
             if (input_id!=undefined){
                joinStr1 += input_id+",";
                }
		
        }
    }
    $('#contact_names').val(joinStr1);
    var cont_input_box_length=$('input.net_contact_checkbox').length;
    
    for(var i=1;i<=cont_input_box_length;i++)
    {
        input_val = $('#net_contact_checkbox_'+i).val();
        if(input_val!=0){
            input_id = $('#contact_id_'+i).val();
             if (input_id!=undefined){
                joinStr2 += input_id+",";
                }
        
        }
    }
    $('#net_contact_names').val(joinStr1);
}

function check_request_message() { 
	chk_val = $("#s_key").val();
	check_box_val = $(".contact_checkbox_selected").is(':visible');
	if(chk_val == "non_member" && check_box_val)
	{
	$("#text-type").show();
	$("#text-type").html("Send Invite to Join");
	}
	else if (chk_val == "member" && check_box_val)
	{
	$("#text-type").show();
	$("#text-type").html("Send Friend Request");
	}
	else
	{
	$("#text-type").hide();
	}	
}
function selectFile(incVal){
    $('#photo').click();
}
function dispPhotoName(){
    $('#uploadfile_name').html($('#photo').val());
}
function dispEditPhotoName(){
    $('#uploadfile_edit_name').html($('#photo').val());
}
//$('body').click(function(){
 //   dropDown_new();
//});
function cancelActivityClearData(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13 ){
        clearfields();
    }
}
function clearfields(){
    $("#uploadfile_edit_name").html('');
    $("#photo").val('');
    $("#photo1").val('');
    $("#contact_name").val('');
    $("#email_id").val('');
    $("#mobile_no").val('');
    $("#gender").val('');
    $("#field1").html('--Select--');
    $("#field1").css("color","#999999");
    $("#contact_name_error").html("");
    $("#email_id_error").html("");
    $("#mobile_no_error").html("");
    $("#gender_error").html("");
    $("#photo_error").html("");

    $("#photo1").css("border","1px solid #CDE0E6");
    $("#photo").css("border","none");
    $("#photo_error").html("");
    $("#photo_error").parent().css("display","none");
    $("#contact_name").css("border","1px solid #CDE0E6");
    $("#contact_name_error").html("");
    $("#contact_name_error").parent().css("display","none");
    $("#email_id").css("border","1px solid #CDE0E6");
    $("#email_id_error").html("");
    $("#email_id_error").parent().css("display","none");
    $("#mobile_no").css("border","1px solid #CDE0E6");
    $("#mobile_no_error").html("");
    $("#mobile_no_error").parent().css("display","none");
    $(".gender .selectBoxCity").css("background","url('/assets/create_new_activity/select_box_bg.png') no-repeat");
    $("#gender_error").html("");
    $("#gender_error").parent().css("display","none");
}

function validateName(elementValue){	
    /*var alphaExp = /^([a-zA-Z]+([ ]{0,1}[a-zA-Z]))+$/;*/
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
  var popSendMessagePage;
  var popCreateMessagePage;
  var popInviteSuccess;


    //send message
  
  function Pop_message_send(url){
    popSendMessagePage = dhtmlmodal.open("Delete Activity","iframe",url," ", "width=1007px,height=800px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({ scrollTop: 0 }, 100);
    //set height for iframe div
    var body = document.body,
    html = document.documentElement;
    var height = Math.max( body.scrollHeight, body.offsetHeight,
    html.clientHeight, html.scrollHeight, html.offsetHeight );
    $(".drag-contentarea").css("height",height+"px");
    return false;
  }

  //invite success
  
  function Pop_invite_success(url)
   {
    popInviteSuccess = dhtmlmodal.open("Delete Activity","iframe",url," ", "width=450px,height=600px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({ scrollTop: 0 }, 100);
    return false;
  }
  
  
  //create message
  
  function pop_create_message(url){
    popCreateMessagePage = dhtmlmodal.open("Delete Activity","iframe",url," ", "width=1007px,height=800px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({ scrollTop: 0 }, 100);
    //set height for iframe div
    var body = document.body,
    html = document.documentElement;
    var height = Math.max( body.scrollHeight, body.offsetHeight,
    html.clientHeight, html.scrollHeight, html.offsetHeight );
    $(".drag-contentarea").css("height",height+"px");
    return false;
  }

  // function before_deletes(){ 
  //   var raj = $('#contact_names').val();
  //   if (raj!="" && raj!=" ")
  //   {
  //     pop_delete_contact('/contact_users/delete?id='+raj)
  //   }
  //   else
  //   {
  //     pop_delete_contact_empty('/contact_users/delete_empty?id='+raj)
  //   }
  // }

    function before_mail(){ 
    var raj = $('#contact_names').val();
    if (raj!="" && raj!=" ")
    {
      pop_mail_contact('/contact_users/select_mail?id='+raj)
    }
    else
    {
      pop_mail_contact_empty('/contact_users/select_mail_empty?id='+raj)
    }
  }
  
    //basic search ajax call
  function search_ajax_contact()
  {
    var contact_username = $("#event_search").val();
	if(contact_username == 'Search for Friend')
	contact_username = "";
    var user_id= $("#uid").val();
    var search_key = $("#s_key").val();
	var represented = $("#represented").val();
	$("#represented").val("general");
	if(contact_username != "")
	{
		$("#error_search").html("");
		//ajax loader images
		$('#loadingmessage').show();
		$.get("/search_contact_user",{
		  "contact_user": contact_username,
		  "user_id": user_id,
		  "search_key":search_key,
		  "represented" : represented
		  }, function(data){
		  $('#loadingmessage').hide();
		}, "script"
		);
   }
 }

  
  //this function called while click the enter button for search the data..
 $(document).on('keypress', '#event_search', function(evt){     
    var evt = (evt) ? evt : ((event) ? event : null);
    var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
    if ((evt.keyCode == 13)  &&  (node.id=="event_search"))  {
      search_ajax_contact();
      return false;
    }
    });



//avoid window scroll 

/*$(document).ready(function(){
var docheight = $(window).height();
var innerHeight = docheight - parseInt(200);
innerHeight = innerHeight+"px";
$('.contactListContainer').css('height',innerHeight);
//$('.scroll-pane').jScrollPane();
});
window.onresize = function(event) {
var docheight = $(window).height();
var innerHeight = docheight - parseInt(200);
innerHeight = innerHeight+"px";
$('.contactListContainer').css('height',innerHeight);
//$('.scroll-pane').jScrollPane();
}*/


function validateCorrectEmail(elementValue){  
    var emailPattern = /^([a-zA-Z0-9]+([~{|}`^?=+*'#$!%._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,3}(?:\.[a-zA-Z]{2,3})?)$/;
    return emailPattern.test(elementValue);
} 

