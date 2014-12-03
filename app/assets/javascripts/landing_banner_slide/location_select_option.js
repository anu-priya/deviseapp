function banner_validation(){
    var email_banr= $("#email_first").val();
    var location_banr= $("#banner_location_first").val();
    $("#email").css("border","1px solid #cde0e6");
    $("#banner_location_first").css("border","1px solid #A3A3A3");
   // $(".selectBoxLocation").css("background","url('/assets/landing_banner/location.png')");
	
    errorFlag=false;
    if(email_banr =="" || email_banr=="Email address")
    {
        $("#email").css("border","1px solid #fc8989");
        errorFlag = true;
    }
    else if(!validateCorrectEmail(email_banr)){
        $("#email").css("border","1px solid #fc8989");
        errorFlag = true;
    }
    else if(!validateDot(email_banr)){
        $("#email").css("border","1px solid #fc8989");
        errorFlag = true;
    }
	
     if(location_banr =="" || location_banr=="Location")
     {
	$("#banner_location_first").css("border","1px solid #fc8989");
         errorFlag = true;
     }
	
    if(errorFlag)
    {
        return false;
    }
    else{
	    $('.content_popup').hide();
		$('.content_popup_error').hide();
		$('#thankyou_newsletter').bPopup();
		$.ajax({
		type: "GET",
		url: "newsletter_subscripe",
		data: "email=" + $('#email_first').val()+"&banner_location="+$('#banner_location_first').val(),
		success: function(data){	
		$('#email_first').css('color','#999999');
		$('#email_first').val('Email address');
		$('#banner_location_first').val('Location').attr("selected","selected");
		$('#banner_location_first').css('color','#999999');
		//$('#banner_location_first').html('Location');		
		if(data=="subscribed")
		{
			$('.content_popup').show();
			$('.content_popup_error').hide();	
		}
		else
		{
			if(data=="alreadysubscribed")
			{
				$('.content_popup_error').show();
				$('.content_popup').hide();
				$("#div_exist").show();
				$("#div_apierror").hide();
			}
			else
			{
				if(data=="Problem on API")
				{
					$('.content_popup_error').show();
					$('.content_popup').hide();
					$("#div_exist").hide();			
					$("#div_apierror").html("Having problem on server!<br>Please try again later");
					$("#div_apierror").show();
				}
				else{
					$('.content_popup_error').show();
					$('.content_popup').hide();
					$("#div_exist").hide();			
					$("#div_apierror").html(data);
					$("#div_apierror").show();
				}
			}

		}
		}
		});
        return false;
    }
	
}

function news_banner_validation(){
    var email= $("#email").val();
    var banner_location_2= $("#banner_location_2").val();
    $("#email").css("border","1px solid #cde0e6");   
	$("#banner_location_2").css("border","1px solid #cde0e6");
	
    errorFlag=false;
    if(email =="" || email=="Email address")
    {
        $("#email").css("border","1px solid #fc8989");
        errorFlag = true;
    }
    /*else if(!validateCorrectEmail(email)){
        $("#email").css("border","1px solid #fc8989");
        errorFlag = true;
    }
    else if(!validateDot(email)){
        $("#email").css("border","1px solid #fc8989");
        errorFlag = true;
    }	*/
  
	var atpos=email.indexOf("@");
	var dotpos=email.lastIndexOf(".");
	if (atpos<1 || dotpos<atpos+2 || dotpos+2>=email.length)
	{
		 $("#email").css("border","1px solid #fc8989");
		errorFlag = true;
	}
    if(banner_location_2 =="" || banner_location_2=="Location")
    {	          
	     $("#banner_location_2").css("border","1px solid #fc8989");	    
        errorFlag = true;
    }	
    if(errorFlag)
    {
        return false;
    }
    else{
	    $('.content_popup').hide();
	    $('.newspopup_show').hide();
		$('.content_popup_error').hide();
		$('#thankyou_newsletter').bPopup();
		$.ajax({
		type: "GET",
		url: "newsletter_subscripe",
		data: "email=" + $('#email').val()+"&banner_location="+$('#banner_location_2').val(),
		success: function(data){	
		$('#email').css('color','#999999');
		$('#email').val('Email address');
		$('#banner_location_2').val('Location').attr("selected","selected");
		$('#banner_location_2').css('color','#999999');				
		if(data=="subscribed")
		{
			$('.content_popup').show();
			$('.content_popup_error').hide();	
		}
		else
		{
		if(data=="alreadysubscribed")
		{
			$('.content_popup_error').show();
			$('.content_popup').hide();
			$("#div_exist").show();
			$("#div_apierror").hide();
		}
		else
		{
			if(data=="Problem on API")
			{
				$('.content_popup_error').show();
				$('.content_popup').hide();
				$("#div_exist").hide();			
				$("#div_apierror").html("Having problem on server!<br>Please try again later");
				$("#div_apierror").show();
			}
			else{
				$('.content_popup_error').show();
				$('.content_popup').hide();
				$("#div_exist").hide();			
				$("#div_apierror").html(data);
				$("#div_apierror").show();
			}
		}

		}
		}
		});
       return false;
    }	
}
function close_newsletter(){
	$("#email").css("border","1px solid #cde0e6");
	$('#email').css('color','#999999');
	$('#email').val('Email address');
	$('#banner_location_2').val('Location').attr("selected","selected");
	$('#banner_location_2').css('color','#999999');	
	$("#banner_location_2").css("border","1px solid #cde0e6");
	$(".newspopup_show").hide();
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

function validateCorrectEmail(elementValue){  
    var emailPattern = /^([a-zA-Z0-9]+([~{|}`^?=+*'#$!%._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,3}(?:\.[a-zA-Z]{2,3})?)$/;
    return emailPattern.test(elementValue);
/*var e = elementValue;
	elementValue = e.trim();
	var filter = /^[A-Za-z0-9][A-Za-z0-9\_\-\.]*\@[A-Za-z0-9][A-Za-z0-9\_\-\.]*\.[A-Za-z]{2,}$/;
	var filter2 = /(\.\.+)|(\@\@+)|(\_\_+)|(\-\-+)/;
	var filter3 = /(\.ac|\.ad|\.ae|\.aero|\.af|\.ag|\.ai|\.al|\.am|\.an|\.ao|\.aq|\.ar|\.arpa|\.as|\.at|\.au|\.aw|\.ax|\.az|\.ba|\.bb|\.bd|\.be|\.bf|\.bg|\.bh|\.bi|\.biz|\.bj|\.bm|\.bn|\.bo|\.br|\.bs|\.bt|\.bv|\.bw|\.by|\.bz|\.ca|\.cat|\.cc|\.cd|\.cf|\.cg|\.ch|\.ci|\.ck|\.cl|\.cm|\.cn|\.co|\.com|\.coop|\.cr|\.cu|\.cv|\.cx|\.cy|\.cz|\.de|\.dj|\.dk|\.dm|\.do|\.dz|\.ec|\.edu|\.ee|\.eg|\.er|\.es|\.et|\.eu|\.fi|\.fj|\.fk|\.fm|\.fo|\.fr|\.ga|\.gb|\.gd|\.ge|\.gf|\.gg|\.gh|\.gi|\.gl|\.gm|\.gn|\.gov|\.gp|\.gq|\.gr|\.gs|\.gt|\.gu|\.gw|\.gy|\.hk|\.hm|\.hn|\.hr|\.ht|\.hu|\.id|\.ie|\.il|\.im|\.in|\.info|\.int|\.io|\.iq|\.ir|\.is|\.it|\.je|\.jm|\.jo|\.jobs|\.jp|\.ke|\.kg|\.kh|\.ki|\.km|\.kn|\.kr|\.kw|\.ky|\.kz|\.la|\.lb|\.lc|\.li|\.lk|\.lr|\.ls|\.lt|\.lu|\.lv|\.ly|\.ma|\.mc|\.md|\.mg|\.mh|\.mil|\.mk|\.ml|\.mm|\.mn|\.mo|\.mobi|\.mp|\.mq|\.mr|\.ms|\.mt|\.mu|\.museum|\.mv|\.mw|\.mx|\.my|\.mz|\.na|\.name|\.nc|\.ne|\.net|\.nf|\.ng|\.ni|\.nl|\.no|\.np|\.nr|\.nu|\.nz|\.om|\.org|\.pa|\.pe|\.pf|\.pg|\.ph|\.pk|\.pl|\.pm|\.pn|\.pr|\.pro|\.ps|\.pt|\.pw|\.py|\.qa|\.re|\.ro|\.ru|\.rw|\.sa|\.sb|\.sc|\.sd|\.se|\.sg|\.sh|\.si|\.sj|\.sk|\.sl|\.sm|\.sn|\.so|\.sr|\.st|\.su|\.sv|\.sy|\.sz|\.tc|\.td|\.tel|\.tf|\.tg|\.th|\.tj|\.tk|\.tl|\.tm|\.tn|\.to|\.tp|\.tr|\.travel|\.tt|\.tv|\.tw|\.tz|\.ua|\.ug|\.uk|\.um|\.us|\.uy|\.uz|\.va|\.vc|\.ve|\.vg|\.vi|\.vn|\.vu|\.wf|\.ws|\.ye|\.yt|\.yu|\.za|\.zm|\.zw)$/i;
	
	
	if( (!filter.test( elementValue ))  || ( filter2.test( elementValue )) || ( !filter3.test( elementValue )) ) {
		return false;
	}	
	return true;*/	
} 
