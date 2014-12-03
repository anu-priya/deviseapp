$(document).ready(function(){
	showPriceDetails();
});
function showPriceDetails(){   
    $("#pricingDetail").show();
    var height = $("#pricingDetail").height();
    if(height>180){
	   $(".setHeightScroll").css('height','187px');
    }
}
function hidePriceDetails(){
    $("#pricingDetail").hide();
}
function showPriceDetails_land(c){
    $("#pricingDetail_"+c).show();
    //document.getElementById('pricingDetail_'+c).style.display = "block";
}
function hidePriceDetails_lands(d){
     //document.getElementById('pricingDetail_'+d).style.display = "none";
     $(".pricingDetail1").css('display','none');
}
function setSessionVal(gvalue,inc){
    $('#multiple_session_'+inc).val(gvalue);
    $('#multiple_session_setVal_'+inc).html(gvalue);
}
/*****************************************
		Price Div Func
******************************************/
function dispCheckPayment(cname,id){
    radio_index=$(".radio_normal_pay_period").index($("#radio_normal_pay_period_"+id));
   $(".paymentDuration input[type=text]").val('');
   $(".paymentDuration input:eq("+radio_index+")").focus();
	$('.radio_selected_pay_period').css('display','none');
    $('.radio_normal_pay_period').css('display','inline-block');
	
    if(cname == 'radio_normal_pay_period'){
        $('#radio_selected_pay_period_'+id).css('display','inline-block');  
        $('#radio_normal_pay_period_'+id).css('display','none');
        var period = $('#pay_period_'+id).val();
        $('#pay_period').val(period);
        var price = $('#pay_id_'+id).val();
        $('#select_price').val(price);
    }
}
function dispCheckActivityPayment(cname,id){
    $('.radio_selected_activity_payment').css('display','none');
    $('.radio_normal_activity_payment').css('display','inline-block');
	
    if(cname == 'radio_normal_activity_payment'){
        $('#radio_selected_activity_payment_'+id).css('display','inline-block');  
        $('#radio_normal_activity_payment_'+id).css('display','none');
        var payment = $('#activity_payment_'+id).val();
        $('#activity_payment').val(payment);
    }

}
$(function(){
    $('.dispSessionDiv li a').hover(function (){
        $(this).parent().parent().parent("li").children('a:first').addClass('selectedSessionDiv');
    }, function(){
        $(this).parent().parent().parent("li").children('a:first').removeClass('selectedSessionDiv');
    });
});
$(function(){
    $('.dispParticipantDiv li a').hover(function (){
        $(this).parent().parent().parent("li").children('a:first').addClass('selectedParticipantDiv');
    }, function(){
        $(this).parent().parent().parent("li").children('a:first').removeClass('selectedParticipantDiv');
    });
});
/*contact provider validation checked.....*/
function validateSendMsg(){
	var provider_email = $("#provider_email").val();
	$("#provider_email").css("border","1px solid #CDE0E6");
	$(".sendEmailError").hide();
	$(".sendEmailError").html("");
	
	var sendVal = $("#send_msg").val();
	$("#send_msg").css("border","1px solid #CDE0E6");
	//$("#send_msg").css("border-bottom","none");
	//$("#send_msg").css("border-right","none");
	$(".sendMsgError").hide();
	$(".sendMsgError").html("");
	
	var errorFlag = false;    
		
	if(provider_email=="Enter your Email" || provider_email=="" ){ 
		$("#provider_email").css("border","1px solid #FC8989");
		$(".sendEmailError").show();
		$(".sendEmailError").html("Please enter email ");
		errorFlag = true;
	}
	if(provider_email != "Enter your Email" && provider_email != ""){
		if(!validateCorrectEmail(provider_email)){
			$("#provider_email").css("border","1px solid #FC8989");
			$(".sendEmailError").show();
			$(".sendEmailError").html("Please enter valid email ");
			errorFlag = true;
		}
	}
	if(sendVal=="Enter your message, the provider will get back to you shortly" || sendVal=="" ){ 	
		$("#send_msg").css("border","1px solid #FC8989");
		$(".sendMsgError").show();
		$(".sendMsgError").html("Please enter the message");
		errorFlag = true;
	}
	if(errorFlag){
		return false;
	}
	else{
               //ajax call sending a mail to provider in details page
	       
               $.get($("#send_to-provider").attr('action'), $("#send_to-provider").serialize(), null, "script");
	        parent.$( "#autocomplete_appender1" ).hide();
		
		 parent.$('#search_value').val('Search 20,000 + Local Activities & Counting...');
		return true;
	}
}
/*contact provider validation checked.....*/
function validateSendMsgpro(){ 
	var sendVal = $("#send_msg").val();
	$("#send_msg").css("border","1px solid #BDD6DD");
	$(".sendMsgError").hide();
	$(".sendMsgError").html("");
	
	if(sendVal=="Enter your message, the provider will get back to you shortly" || sendVal=="" ){
		$("#send_msg").css("border","1px solid #FC8989");
		$(".sendMsgError").show();
		$(".sendMsgError").html("Please enter the valid message");
		return false;
	}
	else{
               //ajax call sending a mail to provider in details page
               $.get($("#send_to-provider").attr('action'), $("#send_to-provider").serialize(), null, "script");
	        parent.$( "#autocomplete_appender1" ).hide();
		
		 parent.$('#search_value').val('Search 20,000 + Local Activities & Counting...');
		return true;
	}
}
function validateCorrectEmail(elementValue){
    var emailPattern = /^([a-zA-Z0-9]+([~{|}._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,3}(?:\.[a-zA-Z]{2,3})?)$/;
    return emailPattern.test(elementValue);
}

    function ShowMore()
  {
   $("#card-details1").show();
   $("#test-more").hide();
   $("#activity_arrow_more").hide();
   $("#activity_arrow_less").show();
   $("#test-less").show();
  }
  
    function ShowLess()
  {
   $("#card-details1").hide();
   $("#test-less").hide();
   $("#activity_arrow_less").hide();
   $("#activity_arrow_more").show();
   $("#test-more").show();
  }