function dispViews(id){
	$('.tickesViewPage').hide();
	$('#'+id).show();
	$('.dispProviderActionDiv li a').css('color','#959292');	
	$('.dispProviderActionDiv li a#a_'+id).css('color','#F97C0E');	
}
//validation
function validate_ticket(){
    errorFlag = false;
    var ticket_name = $("#ticket_name").val();
    var activity_name = $("#activity_name").val();    

    $("#ticket_name").css("border","1px solid #CDE0E6");
    $("#activity_name").css("border","1px solid #CDE0E6");
    
    $("#ticket_name_error").html("");
    $("#activity_name_error").html("");    

    $("#ticket_name_error").parent().css("display","none");
    $("#activity_name_error").parent().css("display","none");    

    ticket_name = ticket_name.replace(/^\s+|\s+$/g, "");   
    activity_name = activity_name.replace(/^\s+|\s+$/g, "");
    
    if(ticket_name == ""){
        $("#ticket_name").css("border","1px solid #fc8989");
        $("#ticket_name_error").html("Please enter ticket name");
        $("#ticket_name_error").parent().css("display","block");
        errorFlag = true;
    }
    if(activity_name == ""){
        $("#activity_name").css("border","1px solid #fc8989");
        $("#activity_name_error").html("Please enter activity name");
        $("#activity_name_error").parent().css("display","block");
        errorFlag = true;
    }   
    if(errorFlag){
        return false;
    }
    else{
        return true;
    }
}
function selectRadioButton(className,id,val){
	$('.radioBox input').val(0);
	$('.select').hide();
	$('.not_select').show();	
	if(className == "select"){
		$('#ticket_'+id).val(val);
		$('#'+className+'_'+id).show();	
		$('#not_select_'+id).hide();	
	}	
}
function changedTicketDate(){
    var dateVal = $('#datepicker').val();	
	var splitDateVal = dateVal.split('/');
    var month = splitDateVal[0];
    var date = splitDateVal[1];
    var year = splitDateVal[2];
	
    var formatedDate = year+"-"+month+"-"+date;	
    var monthName = getMonthVal(month);
	
    $('#month').html(monthName);
    $('#date').html(date);
	
    $.get("/tickets/ticket_update",{
        "date":formatedDate,
        "cat_zc":"date"
    }, null, "script");
	   
}