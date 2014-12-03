/*******************************
		Schedule  
********************************/ 

var str = "";
dev_per_page = 1;
max_pagenum_limit = 5;
$(".schedule .schedPrev").hide();
	
$(document).ready(function(){
	//**************************************Send msg all ***********************************//	
	//~ var sID = $("#sucd_sendmsg_id_0").val();				
	//~ $("#sendmsg_all").val(sID);
	//**************************************end Send msg all *******************************//
	//~ $("#sendmsg_0").prop( "disabled", true );

	$(".schedule .schedPrev").hide();
	var totalrec = $(".schedule .schd_cont").length;
	
	if(totalrec>0)
	{
		for(i=0;i<=totalrec;i++)
		{
			if(i>=dev_per_page)
				$(".schedule #schd_cont_"+i).hide();
			else
				$(".schedule #schd_cont_"+i).show();
		}
	}

	totalpages = (parseInt((totalrec/dev_per_page)) + (totalrec%dev_per_page==0?0:1));

	str="";

	end=  (totalpages<max_pagenum_limit?totalpages:max_pagenum_limit);


	if(totalrec==1){
		$(".schedule .schedPrev").hide();
		$(".schedule .schedNext").hide();
	}
	else{		
		for(i=1;i<=end;i++){
			var pVal = i-1;
			str += '<a href="javascript:void(0)"  id="sched_number_'+pVal+'" title="" class="ftcBlue" onclick="showShedule()">'+i+'</a>&nbsp;';			
			
		}	
		$(".display_num").html(str);
		$(".sched_pagination div a").css('color','#4595AE');
		$(".schedule .display_num #sched_number_0").css('color','#FF6C04');
		for(i=1;i<=end;i++){
			var pVal = i-1;
			var schedule_curr_id =  $("#schedule_curr_id_"+pVal).val();					
			$(".schedule .display_num #sched_number_"+pVal).attr('onClick',"showShedule("+i+","+schedule_curr_id+")");
		}	
		
	}
	var schedule_next_id =  $("#schedule_next_id_0").val();	
	$(".sched_pagination .schedNext").attr('onClick',"showShedule(2,"+schedule_next_id+")");	
});

currentpage=1;
currentslot = 0;
function showShedule(number,schedule_id){ 
	str="";
	var totalrec = $(".schedule .schd_cont").length;
	totalpages = (parseInt((totalrec/dev_per_page)) + (totalrec%dev_per_page==0?0:1));
		
	$("#display_schedule").val(number);	
  	currentpage=number - 1;
	nextpage=number + 1;
	currentslot = parseInt(currentpage/max_pagenum_limit);
	 
	start = (currentpage * dev_per_page);
	end = start + dev_per_page;

	for(i=0;i<=totalrec;i++)
	 {
	 	if(i>=start && i<end){
			$(".schedule #schd_cont_"+i).show(); 
		}
		else
			$(".schedule #schd_cont_"+i).hide();
	 }
	 
	 if(number>0){
		var schedule_prev_id = $("#schedule_prev_id_"+currentpage).val();
		$(".sched_pagination .schedPrev").attr('onClick',"showShedule("+currentpage+","+schedule_prev_id+")");		
	 }
	 else{
	 	str = "";
	 }
	start=(currentslot * max_pagenum_limit)+1;
	end=start+max_pagenum_limit;
	if(end>totalpages)
		end=totalpages;
			
  	for(i=start;i<=end;i++){
		var pVal = i-1;
		str += '<a href="javascript:void(0)"  id="sched_number_'+pVal+'" title="" class="ftcBlue" onclick="showShedule()">'+i+'</a>&nbsp;';			

	}	
	$(".display_num").html(str);
	$(".sched_pagination div a").css('color','#4595AE');
	$(".schedule .display_num #sched_number_"+currentpage).css('color','#FF6C04');
	for(i=start;i<=end;i++){
		var pVal = i-1;
		var schedule_curr_id =  $("#schedule_curr_id_"+pVal).val();			
		$(".schedule .display_num #sched_number_"+pVal).attr('onClick',"showShedule("+i+","+schedule_curr_id+")");			
	}	
  	if(number<totalpages){
		var schedule_next_id = $("#schedule_next_id_"+currentpage).val();		
		$(".sched_pagination .schedNext").attr('onClick',"showShedule("+nextpage+","+schedule_next_id+")");		
	}	
	$(".schedule .schedPrev").show();
	$(".schedule .schedNext").show();
	if(totalrec==number){
		$(".schedule .schedNext").hide();
	}
	if(number<2){
		$(".schedule .schedPrev").hide();
	}

	
	//**************************************Send msg all ***********************************//
	var checkboxCount = $(".sendmsgSelectAny input:checkbox").length;
	for(var i=0;i<checkboxCount;i++){
		$("#sendmsg_"+i).prop( "disabled", false );
		$("#sendmsg_"+i).val("");
	}
	//~ $("#sendmsg_"+currentpage).prop( "checked", true );	
	//~ var sID = $("#sucd_sendmsg_id_"+currentpage).val();
	//~ $("#sendmsg_"+currentpage).val(sID);
	//~ $("#sendmsg_all").val(sID);
	//~ $("#sendmsg_"+currentpage).prop( "disabled", true );
	//*************************************************************************************//
	$("#network_all").prop("checked",false);
	$.ajax({
		url: "/network_next_prev_details",
		data:  {"activity_sch_id":schedule_id,"sch_num":number}
	});
    
}  

/*******************************
    Invite an d assign managers
********************************/ 
function invite_assign_manager(){
	$(".inviteAssingDiv div img#invite_and_assign_icon").attr("src","/assets/event/invite_and_assign_icon_red.png");
	$(".inviteAssingDiv div a u").css("color","#F92929");
	$('.holeManagerDiv').show();
	$('.inviteManagerFirstDiv').show();
	$('.inviteManager').hide();
	$('.assignManager').hide();
}
function invite_assign_manager_close(){
	$(".inviteAssingDiv div img#invite_and_assign_icon").attr("src","/assets/event/invite_and_assign_icon.png");
	$(".inviteAssingDiv div a u").css("color","#4595AE");
	$('.holeManagerDiv').hide();
	$('.inviteManagerFirstDiv').hide();
	$('.inviteManager').hide();
	$('.assignManager').hide();
}
function invite_manager_open(){
	$('.inviteManager').show();
	$('.assignManager').hide();
	$('.inviteManagerFirstDiv').hide();	
	reset_invite_manager_fields();
}
function assign_manager_open(){
	$('.assignManager').show();
	$('.inviteManager').hide();
	$('.inviteManagerFirstDiv').hide();
	reset_assign_manager_fields();
	// reset the checkbox fields
	$("#invite_manager_m").prop( "checked", false );
	$("#invite_attendees_m").prop( "checked", false );
	$("#edit_m").prop( "checked", false );
}
/*******************************
    Click here to invite attendees
********************************/ 
function invite_attendees_show(){
	$(".inviteAttendeesDiv div img#invite_attendees").attr("src","/assets/event/invite_attendees_icon_red.png");
	$(".inviteAttendeesDiv div a").css("color","#F92929");
	$("#invite_attendees_text").html("Click here to Add Attendees to the Group");	
	$('.inviteAttendeesJoin').show();
	$('.pendingAttendees').hide();		
	$('.pendingAttendeesTop').hide();	
	$("#invite_parent_message").val('Enter Message').css('color','#999999');
}
function invite_attendees_close(){
	clearPartiValue();
	$(".inviteAttendeesDiv div img#invite_attendees").attr("src","/assets/event/invite_attendees_icon.png");
	$(".inviteAttendeesDiv div a").css("color","#4595AE");
	$("#invite_attendees_text").html("Click here to Invite Attendees");
	$('.inviteAttendeesJoin').hide();
	$('.pendingAttendees').show();	
	$('.pendingAttendeesTop').show();	
}

/*******************************
	Form Func
********************************/
function showFormDetails(id){
	// corresponding price
	$('#formDiv_'+id+' div').removeClass('formNormalBg');
	$('#formDiv_'+id+' div').addClass('formBlueBg');	
	$('#pformContainerDiv_'+id).css('visibility','visible');
}
function hideFormDetails(){
	// all price
	$('.formDiv div').removeClass('formBlueBg');
	$('.formDiv div').addClass('formNormalBg');
	$('.pformContainerDiv').css('visibility','hidden');	
}
/*******************************
    Send message mouse over
********************************/ 
function displaySendMsg(){
	$("#sendMsgId").removeClass("sendMsgNormal");
	$("#sendMsgId").addClass("sendMsgSelected");
	$(".displaySendMsgDiv").show();
}
/*******************************
     Send message mouse out
********************************/ 
function hideSendMsg(){
	$("#sendMsgId").removeClass("sendMsgSelected");
	$("#sendMsgId").addClass("sendMsgNormal");
	$(".displaySendMsgDiv").hide();
}
/*********************************** 
	Edit Permission
************************************/
function displayEditPermission(id){
	closeEditPermissionAll();
	$(".more_schedule_text .ftcBlue").css('color','#4595AE');
	$("#edit_color_"+id).css('color','#F97C0E');
	$(".edit_permission").css('display','none');
	$("#edit_permission_"+id).css('display','block');
}
function closeEditPermission(id){
	$("#edit_color_"+id).css('color','#4595AE');
	$("#edit_permission_"+id).css('display','none');
}
function closeEditPermissionAll(){
	$(".more_schedule_text .blueText").css('color','#4595AE');
	$(".edit_permission").css('display','none');
}
/*******************************
    ShowBy mouse over
********************************/ 
function displayShowBy(){
	$("#showById").removeClass("showbyNormal");
	$("#showById").addClass("showbySelected");
	$(".displayshowbyDiv").show();
}
/*******************************
     ShowBy mouse out
********************************/ 
function hideShowBy(){
	$("#showById").removeClass("showbySelected");
	$("#showById").addClass("showbyNormal");
	$(".displayshowbyDiv").hide();
}
/*******************************
     Send Msg Select All Option
********************************/ 
	function select_sendmsg_all(){
	var checkStr="";
	var sendMsgText ="";
	var checkboxCount = $(".displaySendMsgCheck input:checkbox").length;
	if(checkboxCount>0){
		if($(".displaySendMsgCheck input:checked")){				
			for(var i=0;i<checkboxCount;i++){
				//~ $("#sendmsg_"+i).prop( "disabled", false );
				$("#sendmsg_"+i).prop( "checked", true );
				var sID = $("#sucd_sendmsg_id_"+i).val();				
				$("#sendmsg_"+i).val(sID);
				checkStr += $("#sendmsg_"+i).val()+",";
			}
			$("#sendmsg_all").val(checkStr);
		}
		else{
			for(var i=0;i<checkboxCount;i++){
				$("#sendmsg_"+i).prop( "checked", false );
				$("#sendmsg_"+i).val("");
			}
			$("#sendmsg_all").val("");
			$("#network_all").prop( "checked", false );
		}
	}
}
/****************************************
     Send Msg Select Any One Option
*****************************************/ 
function select_send_msg(idVal,schedIdval){
	var checkStr="";
	var sendMsgText ="";
	var checkboxCount = $(".displaySendMsgCheck input:checkbox").length;
	var checkedCont = $('.displaySendMsgCheck input:checked').length;	
	var sel_sched_id = $('#act_schedule_id').val();

	if(checkedCont == checkboxCount){ 
		for(var i=0;i<checkboxCount;i++){
			var sID = $("#sucd_sendmsg_id_"+i).val();				
			$("#sendmsg_"+i).val(sID);
			checkStr += $("#sendmsg_"+i).val()+",";
		}
		$("#sendmsg_all").prop( "checked", true );
		$("#sendmsg_all").val(checkStr);

		if((sel_sched_id==schedIdval)){
			$("#manager_all_"+schedIdval).prop( "checked", true );
			select_manager_all(schedIdval,'page_false');
			$("#attendees_all_"+schedIdval).prop( "checked", true );
			select_attendees_all(schedIdval,'page_false');
			$("#pending_invite_all_"+schedIdval).prop( "checked", true );
			select_pending_invite_all(schedIdval,'page_false');
		}
		
	}
	else{ 
		if($("#sendmsg_"+idVal).attr('checked')){
			$("#sendmsg_"+idVal).val(schedIdval);
			if((sel_sched_id==schedIdval)){
				$("#manager_all_"+schedIdval).prop( "checked", true );
				select_manager_all(schedIdval,'page_false');
				$("#attendees_all_"+schedIdval).prop( "checked", true );
				select_attendees_all(schedIdval,'page_false');
				$("#pending_invite_all_"+schedIdval).prop( "checked", true );
				select_pending_invite_all(schedIdval,'page_false');
			}
		}
		else{
			$("#sendmsg_"+idVal).val("");	
			if((sel_sched_id==schedIdval)){
				$("#manager_all_"+schedIdval).prop( "checked", false );
				select_manager_all(schedIdval,'page_false');
				$("#attendees_all_"+schedIdval).prop( "checked", false );
				select_attendees_all(schedIdval,'page_false');
				$("#pending_invite_all_"+schedIdval).prop( "checked", false );
				select_pending_invite_all(schedIdval,'page_false');
			}			
		}
		for(var i=0;i<checkboxCount;i++){
			if($("#sendmsg_"+i).attr('checked')){
				var sID = $("#sucd_sendmsg_id_"+i).val();				
				$("#sendmsg_"+i).val(sID);
				checkStr += $("#sendmsg_"+i).val()+",";
			}
		}
		
		$("#sendmsg_all").prop( "checked", false );
		$("#sendmsg_all").val(checkStr);
		$("#network_all").prop( "checked", false );
		
	}
	select_network(sel_sched_id); 
	select_sendmsg_all
}
/*******************************
ShowBy mouse over
********************************/
function displayShowBy(){
	$("#showById").removeClass("showbyNormal");
	$("#showById").addClass("showbySelected");
	$(".displayshowbyDiv").show();
}
/*******************************
ShowBy mouse out
********************************/
function hideShowBy(){
	$("#showById").removeClass("showbySelected");
	$("#showById").addClass("showbyNormal");
	$(".displayshowbyDiv").hide();
}

/*******************************
     Manager Select All Option
********************************/ 
function select_manager_all(sched_id,p_data){
	var checkStr="";
	var sendMsgText ="";
	var checkboxCount = $(".managerCheck input:checkbox").length;
	if(checkboxCount>0){
		if($("#manager_all_"+sched_id).attr('checked')){				
			for(var i=1;i<=checkboxCount;i++){
				$("#manager_name_"+i).prop( "checked", true );
				sendMsgText = $("#manager_text_"+i).html();
				$("#manger_mailid").val(sendMsgText);
				checkStr += $("#manger_mailid").val()+",";
			}
			$("#manger_mailid").val(checkStr);
		}
		else{
			for(var i=1;i<=checkboxCount;i++){
				$("#manager_name_"+i).prop( "checked", false );
				$("#manager_name_"+i).val("");
			}
			$("#manger_mailid").val("");	
			//~ $("#network_all").prop( "checked", false );	
		}
	}
	if (p_data=='page_true'){
	select_schedule_list(sched_id);
	}
	select_network(sched_id);

}
/****************************************
     Manager Select Any One Option
*****************************************/ 
function select_manager_single(idVal,sched_id){
	var checkStr="";
	var sendMsgText ="";
	var checkboxCount = $(".managerCheck input:checkbox").length;
	var checkedCont = $('.managerCheck input:checked').length;	
	if(checkedCont == checkboxCount){ 
		for(var i=1;i<=checkboxCount;i++){
			sendMsgText = $("#manager_text_"+i).html();
			$("#manger_mailid").val(sendMsgText);
			checkStr += $("#manger_mailid").val()+",";
		}
		$("#manager_all_"+manager_all).prop( "checked", true );
		$("#manger_mailid").val(checkStr);
		$(".act_schedule_list_"+sched_id).prop( "checked", true );
	}
	else{ 
		for(var i=1;i<=checkboxCount;i++){
			if($("#manager_name_"+i).is(':checked')){
			sendMsgText = $("#manager_text_"+i).html();
			$("#manger_mailid").val(sendMsgText);
			checkStr += $("#manger_mailid").val()+",";
			}	
		}
		$("#manger_mailid").val(checkStr);	
		$("#manager_all_"+manager_all).prop( "checked", false );	
		$("#network_all").prop( "checked", false );
		$(".act_schedule_list_"+sched_id).prop( "checked", false );
	}
	select_network(sched_id);
}
/*******************************
     Attendees Select All Option
********************************/ 
function select_attendees_all(sched_id,p_data){
	var checkStr="";
	var sendMsgText ="";
	var checkboxCount = $(".attendeesCheck input:checkbox").length;
	if(checkboxCount>0){
		if($("#attendees_all_"+sched_id).attr('checked')){	
		
			for(var i=1;i<=checkboxCount;i++){
				$("#attendees_name_"+i).prop( "checked", true );
				parentEmail = $("#parent_email_"+i).html();
				$("#attndees_email").val(parentEmail);
				checkStr += $("#attndees_email").val()+",";
			}
			$("#attndees_email").val(checkStr);
			//~ $(".act_schedule_list_"+sched_id).prop( "checked", true );
		}
		else{
			for(var i=1;i<=checkboxCount;i++){
				$("#attendees_name_"+i).prop( "checked", false );				
			}
			$("#attndees_email").val("");
			//~ $("#network_all").prop( "checked", false );
			//~ $(".act_schedule_list_"+sched_id).prop( "checked", false );
		}
	}
	if (p_data=='page_true'){
	select_schedule_list(sched_id);
	}
	select_network(sched_id);
}
/****************************************
     Attendees Select Any One Option
*****************************************/ 
function select_attendees_single(idVal,sched_id){
	var checkStr="";
	var sendMsgText ="";
	var checkboxCount = $(".attendeesCheck input:checkbox").length;
	var checkedCont = $('.attendeesCheck input:checked').length;	
	if(checkedCont == checkboxCount){ 
		for(var i=1;i<=checkboxCount;i++){
			parentEmail = $("#parent_email_"+i).html();
			$("#attndees_email").val(parentEmail);
			checkStr += $("#attndees_email").val()+",";
		}
		$("#attendees_all_"+sched_id).prop( "checked", true );
		$("#attndees_email").val(checkStr);
		//~ $(".act_schedule_list_"+sched_id).prop( "checked", true );
	}
	else{ 
		for(var i=1;i<=checkboxCount;i++){
			if($("#attendees_name_"+i).is(':checked')){
				parentEmail = $("#parent_email_"+i).html();
				$("#attndees_email").val(parentEmail);
				checkStr += $("#attndees_email").val()+",";
			}			
		}
		$("#attndees_email").val(checkStr);		
		$("#attendees_all_"+sched_id).prop( "checked", false );			
		$("#network_all").prop( "checked", false );
		//~ $(".act_schedule_list_"+sched_id).prop( "checked", false );
	}
	select_network(sched_id);
}
/*******************************
     Pending Invite  Select All Option
********************************/ 
function select_pending_invite_all(sched_id,p_data){
	var checkStr="";
	var sendMsgText ="";
	var checkboxCount = $(".pending_invite_check input:checkbox").length;
	if(checkboxCount>0){
		if($("#pending_invite_all_"+sched_id).attr('checked')){				
			for(var i=1;i<=checkboxCount;i++){
				$("#pending_invite_"+i).prop( "checked", true );
				sendMsgText = $("#pending_invite_email_"+i).html();
				$("#pending_invite_"+i).val(sendMsgText);
				checkStr += $("#pending_invite_"+i).val()+",";
			}
			$("#pending_invite_all_"+sched_id).val(checkStr);
			$("#pending_invitees_mailid").val(checkStr);
			//~ $(".act_schedule_list_"+sched_id).prop( "checked", true );
		}
		else{
			for(var i=1;i<=checkboxCount;i++){
				$("#pending_invite_"+i).prop( "checked", false );
				$("#pending_invite_"+i).val("");
			}
			$("#pending_invite_all_"+sched_id).val("");
			$("#pending_invitees_mailid").val("");			
			//~ $("#network_all").prop( "checked", false );
			//~ $(".act_schedule_list_"+sched_id).prop( "checked", false );
		}
	}
	if (p_data=='page_true'){
	select_schedule_list(sched_id);
	}
	select_network(sched_id);
}
/****************************************
     Pending Invite Select Any One Option
*****************************************/ 
function select_pending_invite_single(idVal,sched_id){
	var checkStr="";
	var sendMsgText ="";
	var checkboxCount = $(".pending_invite_check input:checkbox").length;
	var checkedCont = $('.pending_invite_check input:checked').length;	
	if(checkedCont == checkboxCount){ 
		for(var i=1;i<=checkboxCount;i++){
			sendMsgText = $("#pending_invite_email_"+i).html();
			$("#pending_invite_"+i).val(sendMsgText);
			checkStr += $("#pending_invite_"+i).val()+",";
		}
		$("#pending_invite_all_"+sched_id).prop( "checked", true );
		$("#pending_invite_all_"+sched_id).val(checkStr);
		$("#pending_invitees_mailid").val(checkStr);
		$(".act_schedule_list_"+sched_id).prop( "checked", true );
	}
	else{ 
		for(var i=1;i<=checkboxCount;i++){
			if($("#pending_invite_"+i).is(':checked')){
				parentEmail = $("#pending_invite_email_"+i).html();
				$("#pending_invite_"+i).val(parentEmail);
				checkStr += $("#pending_invite_"+i).val()+",";
			}			
		}
		$("#pending_invite_all_"+sched_id).val(checkStr);
		$("#pending_invitees_mailid").val(checkStr);
		$("#pending_invite_all_"+sched_id).prop( "checked", false );			
		$("#network_all").prop( "checked", false );
		$(".act_schedule_list_"+sched_id).prop( "checked", false );
	}
	select_network(sched_id);
}
// select all netweorks
function select_network_all(){
	var checkStr="";
	var checkboxCount = $(".displaySendMsgCheck input:checkbox").length;
	var sched_id = $('#act_schedule_id').val();
	if($("#network_all").attr('checked')){
		//$("#sendmsg_all").prop( "checked", true );
		select_sendmsg_all();
		$("#manager_all_"+sched_id).prop( "checked", true );
		select_manager_all(sched_id,'page_false');
		$("#attendees_all_"+sched_id).prop( "checked", true );
		select_attendees_all(sched_id,'page_false');
		$("#pending_invite_all_"+sched_id).prop( "checked", true );
		select_pending_invite_all(sched_id,'page_false');
			for(var i=0;i<checkboxCount;i++){
				//~ $("#sendmsg_"+i).prop( "disabled", false );
				$("#sendmsg_"+i).prop( "checked", true );
				var sID = $("#sucd_sendmsg_id_"+i).val();				
				$("#sendmsg_"+i).val(sID);
				checkStr += $("#sendmsg_"+i).val()+",";
			}
			$("#sendmsg_all").val(checkStr);
	}
	else{
		//$("#sendmsg_all").prop( "checked", true );
		select_sendmsg_all();
		$("#manager_all_"+sched_id).prop( "checked", false );
		select_manager_all(sched_id,'page_false');
		$("#attendees_all_"+sched_id).prop( "checked", false );
		select_attendees_all(sched_id,'page_false');
		$("#pending_invite_all_"+sched_id).prop( "checked", false );
		select_pending_invite_all(sched_id,'page_false');
			for(var i=0;i<checkboxCount;i++){
				$("#sendmsg_"+i).prop( "checked", false );
				$("#sendmsg_"+i).val("");
			}
			$("#sendmsg_all").val("");
			$("#network_all").prop( "checked", false );
	}
}
// select again all networks
function select_network(sched_id){
var mcheckboxCount = $(".managerCheck input:checkbox").length;
var acheckboxCount = $(".attendeesCheck input:checkbox").length;
var pcheckboxCount = $(".pending_invite_check input:checkbox").length;
var schcheckboxCount = $(".sendmsgSelectAny input:checkbox").length;
// 4 sets enable
if(mcheckboxCount > 0 && acheckboxCount > 0 && pcheckboxCount > 0 && schcheckboxCount > 0 ){
	if($("#manager_all_"+sched_id).attr('checked') && $("#attendees_all_"+sched_id).attr('checked') && $("#pending_invite_all_"+sched_id).attr('checked') &&  ($(".sendmsgSelectAny input:checked").length == schcheckboxCount)){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}

// 3 sets enable
if(mcheckboxCount > 0 && acheckboxCount > 0 && pcheckboxCount > 0 && schcheckboxCount == 0 ){
	if($("#manager_all_"+sched_id).attr('checked') && $("#attendees_all_"+sched_id).attr('checked') && $("#pending_invite_all_"+sched_id).attr('checked')){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}
if(mcheckboxCount > 0 && acheckboxCount > 0 && schcheckboxCount > 0 && pcheckboxCount == 0 ){
	if($("#manager_all_"+sched_id).attr('checked') && $("#attendees_all_"+sched_id).attr('checked') && ($(".sendmsgSelectAny input:checked").length == schcheckboxCount)){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}
if(mcheckboxCount > 0 && pcheckboxCount > 0 && schcheckboxCount > 0 && acheckboxCount == 0 ){
	if($("#manager_all_"+sched_id).attr('checked') && $("#pending_invite_all_"+sched_id).attr('checked') && ($(".sendmsgSelectAny input:checked").length == schcheckboxCount)){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}
if(acheckboxCount > 0 && pcheckboxCount > 0 && schcheckboxCount > 0 && mcheckboxCount == 0 ){
	if($("#attendees_all_"+sched_id).attr('checked') && $("#pending_invite_all_"+sched_id).attr('checked') && ($(".sendmsgSelectAny input:checked").length == schcheckboxCount)){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}


// if 2 sets enable
if(mcheckboxCount > 0 && acheckboxCount > 0 && pcheckboxCount == 0 && schcheckboxCount == 0 ){
	if($("#manager_all_"+sched_id).attr('checked') && $("#attendees_all_"+sched_id).attr('checked') ){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}
if(mcheckboxCount > 0 && pcheckboxCount == 0 && acheckboxCount > 0 && schcheckboxCount == 0 ){
	if($("#manager_all_"+sched_id).attr('checked') && $("#attendees_all_"+sched_id).attr('checked')){
		$("#network_all").prop( "checked", true );
	}
}
if(mcheckboxCount == 0 && acheckboxCount > 0 && pcheckboxCount > 0 && schcheckboxCount == 0 ){
	if($("#attendees_all_"+sched_id).attr('checked') && $("#pending_invite_all_"+sched_id).attr('checked')){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}
if(schcheckboxCount > 0 && acheckboxCount > 0 && pcheckboxCount == 0 && mcheckboxCount == 0 ){
	if(($(".sendmsgSelectAny input:checked").length == schcheckboxCount) && $("#attendees_all_"+sched_id).attr('checked') ){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}
if(mcheckboxCount > 0  && pcheckboxCount > 0 && acheckboxCount == 0 && mcheckboxCount == 0 ){
	if($("#manager_all_"+sched_id).attr('checked') && $("#pending_invite_all_"+sched_id).attr('checked')){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}
if(mcheckboxCount > 0 && schcheckboxCount > 0 && acheckboxCount == 0  && pcheckboxCount == 0 ){
	if($("#manager_all_"+sched_id).attr('checked') && ($(".sendmsgSelectAny input:checked").length == schcheckboxCount)){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}
if(pcheckboxCount > 0 && schcheckboxCount > 0 && acheckboxCount == 0  && mcheckboxCount == 0 ){
	if($("#pending_invite_all_"+sched_id).attr('checked') && ($(".sendmsgSelectAny input:checked").length == schcheckboxCount)){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}

// if any one sets enable
if(mcheckboxCount == 0 && acheckboxCount == 0 && schcheckboxCount == 0 && pcheckboxCount > 0 ){
	if($("#pending_invite_all_"+sched_id).attr('checked')){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}
if(mcheckboxCount > 0 && acheckboxCount == 0 && pcheckboxCount == 0 && schcheckboxCount == 0 ){
	if($("#manager_all_"+sched_id).attr('checked')){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}
if(mcheckboxCount == 0 && acheckboxCount > 0 && pcheckboxCount == 0 && schcheckboxCount == 0 ){
	if($("#attendees_all_"+sched_id).attr('checked')){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}
if(mcheckboxCount == 0 && acheckboxCount == 0 && pcheckboxCount == 0 && schcheckboxCount > 0 ){
	if(($(".sendmsgSelectAny input:checked").length == schcheckboxCount)){
		$("#network_all").prop( "checked", true );
	}
	else{
		$("#network_all").prop( "checked", false );
	}
}
//none
//~ if(mcheckboxCount == 0 && acheckboxCount == 0 && pcheckboxCount == 0 ){
	//~ $("#network_all").prop( "checked", false );
//~ }
}


function select_schedule_list(sched_id){
var mcheckboxCount = $(".managerCheck input:checkbox").length;
var acheckboxCount = $(".attendeesCheck input:checkbox").length;
var pcheckboxCount = $(".pending_invite_check input:checkbox").length;
//schedule select
if(mcheckboxCount > 0 && acheckboxCount > 0 && pcheckboxCount > 0){
	if($("#manager_all_"+sched_id).attr('checked') && $("#attendees_all_"+sched_id).attr('checked') && $("#pending_invite_all_"+sched_id).attr('checked')){
		$(".act_schedule_list_"+sched_id).prop( "checked", true );
	}
	else{
		$(".act_schedule_list_"+sched_id).prop( "checked", false );
	}
}

if(mcheckboxCount > 0 && acheckboxCount == 0 && pcheckboxCount == 0){
	if($("#manager_all_"+sched_id).attr('checked')){
		$(".act_schedule_list_"+sched_id).prop( "checked", true );
	}
	else{
		$(".act_schedule_list_"+sched_id).prop( "checked", false );
	}
}

if(acheckboxCount > 0 && mcheckboxCount == 0 && pcheckboxCount == 0){
	if($("#attendees_all_"+sched_id).attr('checked')){
		$(".act_schedule_list_"+sched_id).prop( "checked", true );
	}
	else{
		$(".act_schedule_list_"+sched_id).prop( "checked", false );
	}
}

if(pcheckboxCount > 0 && acheckboxCount == 0 && mcheckboxCount == 0){
	if($("#pending_invite_all_"+sched_id).attr('checked')){
		$(".act_schedule_list_"+sched_id).prop( "checked", true );
	}
	else{
		$(".act_schedule_list_"+sched_id).prop( "checked", false );
	}
}

if(mcheckboxCount > 0 && acheckboxCount > 0 && pcheckboxCount == 0){
	if($("#manager_all_"+sched_id).attr('checked') && $("#attendees_all_"+sched_id).attr('checked')){
		$(".act_schedule_list_"+sched_id).prop( "checked", true );
	}
	else{
		$(".act_schedule_list_"+sched_id).prop( "checked", false );
	}
}
if(mcheckboxCount > 0 && acheckboxCount == 0 && pcheckboxCount > 0){
	if($("#manager_all_"+sched_id).attr('checked') && $("#pending_invite_all_"+sched_id).attr('checked')){
		$(".act_schedule_list_"+sched_id).prop( "checked", true );
	}
	else{
		$(".act_schedule_list_"+sched_id).prop( "checked", false );
	}
}
if(mcheckboxCount == 0 && acheckboxCount > 0 && pcheckboxCount > 0){
	if($("#attendees_all_"+sched_id).attr('checked') && $("#pending_invite_all_"+sched_id).attr('checked')){
		$(".act_schedule_list_"+sched_id).prop( "checked", true );
	}
	else{
		$(".act_schedule_list_"+sched_id).prop( "checked", false );
	}
}
}

/*****************************************
	activity participant message form
*****************************************/ 
var participantMsgPage;
function pop_participant_message_form(url){
    participantMsgPage = dhtmlmodal.open("Participant Message","iframe",url," ", "width=923px,height=600px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({ scrollTop: 0 }, 100);
    return false;
}
/*****************************************
	Inviter manager Validation
*****************************************/ 
function reset_invite_manager_fields(){
	$("#invite_email").val('johnjoe@gmail.com,smith@yahoo.com');
	$("#invite_email").css('color','#999999');
        $("#invite_message").val('');
			     
	$("#invite_email").css("border","1px solid #BDD6DD");
	$("#invite_email_error").html("");
	$("#invite_email_error").parent().css("display","none");
	
	$("#invite_message").css("border","1px solid #BDD6DD");
	$("#invite_message_error").html("");	
	$("#invite_message_error").parent().css("display","none");
}
function validate_invite_managers(){
	var invite_activity_id = $("#invite_activity_id").val();
	var invite_email = $("#invite_email").val();
        var invite_message = $("#invite_message").val();
	invite_message = invite_message.replace(/^\s+|\s+$/g, "");
		     
	$("#invite_email").css("border","1px solid #BDD6DD");
	$("#invite_email_error").html("");
	$("#invite_email_error").parent().css("display","none");
	
	$("#invite_message").css("border","1px solid #BDD6DD");
	$("#invite_message_error").html("");	
	$("#invite_message_error").parent().css("display","none");

	var errorFlag = false;
	if(invite_email == "" || invite_email=='johnjoe@gmail.com,smith@yahoo.com'){
		$("#invite_email").css("border","1px solid #fc8989");
		$("#invite_email_error").parent().css("display","block");
		$("#invite_email_error").html("Please enter a email");
		errorFlag = true;
	}
	if(invite_email!="" && invite_email!='johnjoe@gmail.com,smith@yahoo.com')
	{
		if(!validateCorrectMultipleEmail(invite_email,'invite_email')){
			$("#invite_email").css("border","1px solid #fc8989");
			$("#invite_email_error").parent().css("display","block");
			$("#invite_email_error").html("Please enter a valid email address(Use comma separated value for mutiple email)");
			errorFlag = true;
		}
	}

	if(invite_message == "" || invite_message.length < 1 ){
		$("#invite_message").css("border","1px solid #fc8989");
		$("#invite_message_error").html("Please enter a message");
		$("#invite_message_error").parent().css("display","block");
		errorFlag = true;
	}
	if(errorFlag){
		return false;
	} 
	else{
		
		var p_business_name= $("#p_business_name").val()
		var p_email= $("#p_email").val()
		var name= $("#name").val();
		
		//ajax call for sending a mail to the provider
		$.ajax({
				type: "GET",
				data: {"invite_email":invite_email,"activity_id":invite_activity_id}, 
				url: "/invite_manager_exist",
				success: function(data){
					if (data !="")
					{ 
						$("#invite_email_error").parent().css("display","block");
						$("#invite_email_error").html(data+ "This provider has already in Famtivity! Try inviting another provider!");
					}
					else
					{ 
						$('html, body', window.parent.document).animate({scrollTop:0}, 'slow');
						$.get($("#invite_mngr").attr('action'), $("#invite_mngr").serialize()+"&activity_id="+invite_activity_id, null, "script");
					}
				}
		 }); 
		 return false;
		
		/**********************************/
		 //~ $('html, body', window.parent.document).animate({scrollTop:0}, 'slow');
		 //~ $.get($("#invite_mngr").attr('action'), $("#invite_mngr").serialize()+"&activity_id="+invite_activity_id, null, "script");
		//~ return false;
		 /*******************************/
	}
	
}

/*****************************************
	Inviter manager Validation
*****************************************/ 
function reset_assign_manager_fields(){
	$("#assign_manager_error").html("");
	$("#assign_manager_error").parent().css("display","none");
}
function validate_assign_managers(){
	var assign_activity_id = $("#invite_activity_id").val();
	var assign_schedule_id = $("#act_schedule_id").val();
	
	$("#assign_manager_error").html("");
	$("#assign_manager_error").parent().css("display","none");
	
	var checkCont = $('.assignManager .assMgDiv .checkInvite input[type=checkbox]').length;
	var checkedCont = $('.assignManager .assMgDiv .checkInvite input:checked').length;
	var errorFlag = false;
	if(checkCont!=0){
		if(checkedCont==0){			
			//$("#assign_manager_error").parent().css("display","block");
			//$("#assign_manager_error").html("Please select atleast one contact");
			$("#rm_all").val("unassined");
			$('html, body', window.parent.document).animate({scrollTop:0}, 'slow');
			$('#unassign_alert').bPopup({fadeSpeed:100,followSpeed:100,opacity:0.8,position: [241, 100], positionStyle: 'absolute',modalClose: false });
			errorFlag = true;
		}
	}
	if(checkedCont==0 && checkCont==0){			
		$("#assign_manager_error").parent().css("display","block");
		$("#assign_manager_error").html("Please invite manager");
		errorFlag = true;
	}
	if(errorFlag){
		return false;
	} 
	else{
		// ajax
		$('html, body', window.parent.document).animate({scrollTop:0}, 'slow');
		$.get($("#assign_mngr").attr('action'), $("#assign_mngr").serialize()+"&activity_id="+assign_activity_id+"&schedule_id="+assign_schedule_id, null, "script");
		return false;
	}
}
//
function unassined_manager(){
	var assign_activity_id = $("#invite_activity_id").val();
	var assign_schedule_id = $("#act_schedule_id").val();
	$('html, body', window.parent.document).animate({scrollTop:0}, 'slow');
		$.get($("#assign_mngr").attr('action'), $("#assign_mngr").serialize()+"&activity_id="+assign_activity_id+"&schedule_id="+assign_schedule_id, null, "script");
		return false;

}
function reset_manager_permission_fields(){
	$(".manager_permission_error").html("");
	$(".manager_permission_error").parent().css("display","none");
}
function validate_manager_permission(id){
	var invite_val = $("#permission_invite_"+id).val();
	var view_val = $("#permission_view_"+id).val();
	var edit_val = $("#permission_edit_"+id).val();
	var attend_val = $("#attendees_invite_"+id).val();
	$("#manager_permission_error_"+id).html("");
	$("#manager_permission_error_"+id).parent().css("display","none");
	
	var checkedCont = $('#edit_permission_'+id+' .permission_schedule_container_network input:checked').length;
	var errorFlag = false;	
	if(checkedCont==0){			
		$("#manager_permission_error_"+id).parent().css("display","block");
		$("#manager_permission_error_"+id).html("Please select atleast one");
		errorFlag = true;
	}
	if(errorFlag){
		return false;
	} 
	else{
		// ajax
		$.get($("#permn_mngr").attr('action'), $("#permn_mngr").serialize()+"&act_man_uid="+id+"&permission_invite="+invite_val+"&attendees_invite="+attend_val+"&permission_view="+view_val+"&permission_edit="+edit_val, null, "script");
		closeEditPermission(id);
		return false;
	}
}
//manager check box id
function check_permi_box(mid){
	var inviteIschecked = $('#permission_invite_' +mid).is(":checked")
	var attendIschecked = $('#attendees_invite_' +mid).is(":checked")
	var viewIschecked = $('#permission_view_' +mid).is(":checked")
	var editIschecked = $('#permission_edit_' +mid).is(":checked")
	if (inviteIschecked)
		$('#permission_invite_'+mid).val('true');
	else
		$('#permission_invite_'+mid).val('false');
		
	if (attendIschecked)
		$('#attendees_invite_'+mid).val('true');
	else
		$('#attendees_invite_'+mid).val('false');
		
	if (viewIschecked)
		$('#permission_view_'+mid).val('true');
	else
		$('#permission_view_'+mid).val('true');

	if (editIschecked)
		$('#permission_edit_' +mid).val('true');
	else
		$('#permission_edit_' +mid).val('false');
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
function validateCorrectMultipleEmail(elementValue,errorField){  
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
					$("#"+errorField).css("border","1px solid #BDD6DD");
					$("#"+errorField+"_error").html("");
					$("#"+errorField+"_error").parent().css("display","none");				  
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
			$("#"+errorField).css("border","1px solid #BDD6DD");
			$("#"+errorField+"_error").html("");
			$("#"+errorField+"_error").parent().css("display","none");
		}
	}
	if(!flag)
	{
		$("#"+errorField+"_error").show();
		return false;   
	}
	else
	{
		return true;
	}
	
}
