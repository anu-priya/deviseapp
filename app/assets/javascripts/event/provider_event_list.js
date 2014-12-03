//actuvutt netwrok form
var activityNetworkkPage;
function pop_activity_network_form(url){

    activityNetworkkPage = dhtmlmodal.open("Activity Network","iframe",url," ", "width=920px,height=2100px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");

    $("html, body").animate({ scrollTop: 0 }, 100);
    return false;
}
/*********************************** 
	More Schedule
************************************/
function displayMoreSchedule(id){
	close_click_function();
	// find window height and changed the popup position
	var wh= $(window).height();	
	var offTop = $("#color_"+id).offset().top;  
	var findTop = wh - offTop;
	//alert(findTop);
	if(findTop<250){
		var setTop = $("#more_schedule_"+id+" .middleContainer").length;
		var setheight = $("#more_schedule_"+id+" .more_schedule_container").height();				
		setheight = setheight  + 39 ;
		if( findTop<200 && setTop>1 || findTop<300 && setTop>3){
			$("#more_schedule_"+id+" .more_schedule_container").css('marginTop','-'+setheight+'px');
			$("#more_schedule_"+id+" .schedule_arrow_outer div").removeClass('schedule_top_arrow');
			$("#more_schedule_"+id+" .schedule_arrow_outer div").addClass('schedule_bottom_arrow');
		}
		else{
			$("#more_schedule_"+id+" .more_schedule_container").css('marginTop','0px');		
			$("#more_schedule_"+id+" .schedule_arrow_outer div").removeClass('schedule_bottom_arrow');
			$("#more_schedule_"+id+" .schedule_arrow_outer div").addClass('schedule_top_arrow');
		}
	}
	else{
		$("#more_schedule_"+id+" .more_schedule_container").css('marginTop','0px');		
		$("#more_schedule_"+id+" .schedule_arrow_outer div").removeClass('schedule_bottom_arrow');
		$("#more_schedule_"+id+" .schedule_arrow_outer div").addClass('schedule_top_arrow');
	}	
	$(".more_schedule_text .blueText").css('color','#4595AE');
	$("#color_"+id).css('color','#F97C0E');
	$(".more_schedule").css('visibility','hidden');
	$("#more_schedule_"+id).css('visibility','visible');
}
function closeMoreSchedule(id){
	$("#color_"+id).css('color','#4595AE');
	$("#more_schedule_"+id).css('visibility','hidden');
}
function closeMoreScheduleAll(){
	$(".more_schedule_text .blueText").css('color','#4595AE');
	$(".more_schedule").css('visibility','hidden');
}
/*********************************** 
	Edit Permission
************************************/
function displayEditPermission(id){
	close_click_function();
	// find window height and changed the popup position
	var wh= $(window).height();	
	var offTop = $("#edit_color_"+id).offset().top;  
	var findTop = wh - offTop;
	//alert(findTop);
	if(findTop<100){			
		$("#edit_permission_"+id+" .permission_schedule_container").css('marginTop','-174px');
		$("#edit_permission_"+id+" .permission_arrow_outer div").removeClass('permission_top_arrow_add');
		$("#edit_permission_"+id+" .permission_arrow_outer div").addClass('permission_bottom_arrow');		
	}
	else{
		$("#edit_permission_"+id+" .permission_schedule_container").css('marginTop','13px');		
		$("#edit_permission_"+id+" .permission_arrow_outer div").removeClass('permission_bottom_arrow');
		$("#edit_permission_"+id+" .permission_arrow_outer div").addClass('permission_top_arrow_add');
	}	
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
/*********************************** 
		Price Func
************************************/
function showPriceDetails(id){
	close_click_function();
	// find window height and changed the popup position
	var wh= $(window).height();	
	var offTop = $("#priceImgDiv_"+id).offset().top;  
	var findTop = wh - offTop;
	//alert(findTop);
	if(findTop<250){
		var setheight = $("#priceContainerDiv_"+id).height();
		setheight = setheight  + 27 ;				
		$("#priceContainerDiv_"+id).css('marginTop','-'+setheight+'px');		
	}
	else{
		$("#priceContainerDiv_"+id).css('marginTop','0px');		
	}	
	// corresponding price
	$('#priceImgDiv_'+id+' div span').removeClass('bluebgImg');
	$('#priceImgDiv_'+id+' div span').addClass('redbgImg');
	
	$('#priceImgDiv_'+id+' div').removeClass('nsetBg');
	$('#priceImgDiv_'+id+' div').addClass('setBg');	
	
	$('#priceContainerDiv_'+id).show();
	
	var sched_count = $("#priceContainerDiv_"+id+" .schd_cont").length;
	if(sched_count==1){
		$("#priceContainerDiv_"+id+" #schedPrev").hide();
		$("#priceContainerDiv_"+id+" #schedNext").hide();
	}	
}
function hidePriceDetails(){
	// all price
	$('.priceImgDiv div span').removeClass('redbgImg');	
	$('.priceImgDiv div span').addClass('bluebgImg');	
	
	$('.priceImgDiv div').removeClass('setBg');
	$('.priceImgDiv div').addClass('nsetBg');
	
	$('.priceContainerDiv').hide();
}
function prevData(id){
	var incVal = $("#display_price_"+id).val();
	incVal--;
	$("#display_price_"+id).val(incVal);	
	var sched_count = $("#priceContainerDiv_"+id+" .schd_cont").length;
	if(incVal<2){
		$("#priceContainerDiv_"+id+" #schedPrev").hide();
	}
	
	$("#priceContainerDiv_"+id+" #schedNext").show();		
	$("#priceContainerDiv_"+id+" .schd_cont").hide();
	$("#priceContainerDiv_"+id+" #schd_cont_"+incVal).show();
	
	$("#priceContainerDiv_"+id+" .price_cont").hide();
	$("#priceContainerDiv_"+id+" #price_cont_"+incVal).show();
}
function nextData(id){
	var incVal = $("#display_price_"+id).val();
	incVal++;	
	$("#display_price_"+id).val(incVal);	
	var sched_count = $("#priceContainerDiv_"+id+" .schd_cont").length;
	if(sched_count==incVal){
		$("#priceContainerDiv_"+id+" #schedNext").hide();
	}
	$("#priceContainerDiv_"+id+" #schedPrev").show();
	$("#priceContainerDiv_"+id+" .schd_cont").hide();
	$("#priceContainerDiv_"+id+" #schd_cont_"+incVal).show();
	
	$("#priceContainerDiv_"+id+" .price_cont").hide();
	$("#priceContainerDiv_"+id+" #price_cont_"+incVal).show();
}
/*******************************
	Form Func
********************************/
function showFormDetails(id){
     
	close_click_function();
	// find window height and changed the popup position
	var wh= $(window).height();	
	var offTop = $("#formDiv_"+id).offset().top;  
	var findTop = wh - offTop;
	//alert(findTop+"--"+wh+"=="+offTop);
	if(findTop<350){
		var setheight = $("#pformContainerDiv_"+id).height();
		setheight = setheight  + 46 ;	
		$("#pformContainerDiv_"+id).css('marginTop','-'+setheight+'px');		
	}
	else{
		$("#pformContainerDiv_"+id).css('marginTop','-4px');		
	}
	var width = $("#pformContainerDiv_"+id+" .existForm").width();
	$("#pformContainerDiv_"+id+" .existForm .Eform").css("width",+width+"px");
	// corresponding price
	$('#formDiv_'+id+' div').removeClass('formNormalBg');
	$('#formDiv_'+id+' div').addClass('formBlueBg');
	$('#pformContainerDiv_'+id).css('visibility','visible');
	$('#pformContainerDiv_'+id).show();
	$('#pformContainerDiv_'+id).css('z-index','9');
	$('#pformContainerDiv_'+id).css('position','absolute');
}
/*******************************
	All Func Closed
********************************/
function close_click_function(){
	closeMoreScheduleAll();
	closeEditPermissionAll();
	hidePriceDetails();
	hideFormDetails();
}
function hideFormDetails(){
	$('.formDiv div').removeClass('formBlueBg');
	$('.formDiv div').addClass('formNormalBg');
	$('.pformContainerDiv').css('visibility','hidden');	
}
/*******************************
	More Less Func
********************************/
function stu_more(){	
	var innerVal = $("#stu_text_more").html();
	if(innerVal == "More" ){
		$("#stu_text_more").html("Less");
		$(".mCol").show();
		$(".lCol").hide();
	}
	else{
		$("#stu_text_more").html("More");
		$(".mCol").hide();		
		$(".lCol").show();
	}
}
/*******************************
	represented form
*******************************/
var representedDetailsPage;
function represented_form(url){
    representedDetailsPage = dhtmlmodal.open("Represented Form","iframe",url," ", "width=910px,height=780px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}  

