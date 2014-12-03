function focusChangeBorderColorActivity(id){
    /** The text box to change border color **/
    switch(id){
        case "textarea":
            if($('#'+id).val()== "Lorem ipsum dolor sit amet, consectectur adipiscing elit Morbi volutpat, logula ut tristique gravide,"){
                $('#'+id).val('');
            }
            break;
        case "textarea_comment":
            if($('#'+id).val()== "Add a Comment..."){
                $('#'+id).val('');
            }
            break;
        
    }
   // $('#'+id).css("border","1px solid #9fd8eb");
    $('#'+id).css("color","#999999");
    $('#'+id).focus();
}
function blurChangeBorderColorActivity(id){
    /** The text box to change border color **/
    switch(id){
        case "textarea":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Lorem ipsum dolor sit amet, consectectur adipiscing elit Morbi volutpat, logula ut tristique gravide, felis nisi elementum elrt,");
                //$('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "textarea_comment":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Add a Comment...");
                //$('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
            
      
    }
   // $('#'+id).css("border","1px solid #BDD6DD");
}

function ShowReminder(){
	
	$('#ShowDivActivity').toggleClass('dispBlock');
	var body = document.body,
    html = document.documentElement;
    var height = Math.max( body.scrollHeight, body.offsetHeight,
    html.clientHeight, html.scrollHeight, html.offsetHeight );
	//$('.drag-contentarea', window.parent.document).css("height",height+"px");
	//alert($('.drag-contentarea', window.parent.document).css("height",height+"px"));

	if($('#ShowDivActivity').hasClass('dispBlock')){	/* it return true */	
		var body = document.body,
    html = document.documentElement;
    var height = Math.max( body.scrollHeight, body.offsetHeight,
    html.clientHeight, html.scrollHeight, html.offsetHeight );
	//$('.drag-contentarea', window.parent.document).css("height",height+"px");
	$('#ShowDivActivity').removeClass('dispNone')
		$("#MoreDetail").html("Less");
		//$("#description").css('margin-top','44px');
		$("#activity_arrow").css('left','-21px');
		$("#MoreDetail").css("left","-30px");
		$("#MoreDetail").css("position","relative");
		$("#activity_arrow").css('position','relative');
		$("#activity_arrow").css('top','0px');
		$("#activity_arrow").attr({ 
	  	src: "/assets/activity_detail_view/less_arrow.jpg",
	  	/*title: "jQuery"*,*/
	 	width:"13",
		height:"17",
	  	alt: "details_arrow"	

		
		
});

		
	}
	else{
		$('#ShowDivActivity').addClass('dispNone')
		$("#MoreDetail").html("More Details");
		$("#MoreDetail").css("left","0px");
		$("#MoreDetail").css("position","");
		$("#activity_arrow").css('left','18px');
		//$("#description").css('margin-top','87px');
		$("#activity_arrow").css('position','relative');
		$("#activity_arrow").css('top','0px');
		$("#activity_arrow").attr({ 
	    src: "/assets/activity_detail_view/more_details_arrow.png",
	    /*title: "jQuery"*,*/
	    width:"36",
	    height:"28",
	    alt: "less_arrow.jpg"});
	}
}

function ShowPop_purchase(){
		$('#pop_purchase').toggleClass('dispBlock');
		if($('#pop_purchase').hasClass('dispBlock')){	/* it return true */	
		$(".details_wrap").css("paddingBottom","119px");
//});
}
else{
	$(".details_wrap").css("paddingBottom","8px");

}
		
		
}