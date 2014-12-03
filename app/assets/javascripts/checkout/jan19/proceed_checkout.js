$(document).ready(function(){
    //initARC('r_form','altRadioOn','altRadioOff','altCheckboxOn','altCheckboxOff');
    //dropDown_new();

    //dropDown_repeat();


});

$('body').click(function(){
    //dropDown_new();
    //dropDown_repeat();

});

function validateSecureActivity(){
    var body = document.body,
    html = document.documentElement;
    var height = Math.max( body.scrollHeight, body.offsetHeight,
        html.clientHeight, html.scrollHeight, html.offsetHeight );
    $(".drag-contentarea").css("height",height+"px");

    
    var payment_method = $("#payment_method").val();
    var CardholderName = $("#CardholderName").val();
    var date_card= $("#date_card").val();
    var year_card= $("#year_card").val();
    var add_1 = $("#add_1").val();
    var add_2 = $("#add_2").val();
    var city = $("#chkout_city").val();
    var zip_code = $("#zip_code_chkout").val();
    var state = $("#chkout_state").val();
    var country = $("#chkout_country").val();
    var phone_no=$("#phone_no").val();
    var email = $("#email").val();
    var cardnumber_1 = $("#cardnumber_1").val();
    var cardnumber_2 = $("#cardnumber_2").val();
    var cardnumber_3 = $("#cardnumber_3").val();
    var cardnumber_4 = $("#cardnumber_4").val();
    var cardnumber_5 = $("#cardnumber_5").val();
 
    $("#payment_method").css("border","1px solid #CDE0E6");
    $("#CardholderName").css("border","1px solid #CDE0E6");
    $("#add_1").css("border","1px solid #CDE0E6");
    $("#add_2").css("border","1px solid #CDE0E6");
    $("#chkout_city").css("border","1px solid #CDE0E6");
    $("#zip_code_chkout").css("border","1px solid #CDE0E6");
    $(".selectBoxMedium").css("border","none");
    $("#phone_no").css("border","1px solid #CDE0E6");
    $("#email").css("border","1px solid #CDE0E6");
    $("#cardnumber_1").css("border","1px solid #CDE0E6");
    $("#cardnumber_2").css("border","1px solid #CDE0E6");
    $("#cardnumber_3").css("border","1px solid #CDE0E6");
    $("#cardnumber_4").css("border","1px solid #CDE0E6");
    $("#cardnumber_5").css("border","1px solid #CDE0E6");
    $("#Country_border").css("border","none");
    $("#State_border").css("border","none");
    $("#City_border").css("border","none");
    $("#date_border").css("border","none");
    $("#year_border").css("border","none");
    $("#selectpayment").css("border","none");
	
    payment_method = payment_method.replace(/^\s+|\s+$/g, "");
    CardholderName = CardholderName.replace(/^\s+|\s+$/g, "");
    phone_no = phone_no.replace(/^\s+|\s+$/g, "");
    email = email.replace(/^\s+|\s+$/g, "");
    cardnumber_1 = cardnumber_1.replace(/^\s+|\s+$/g, "");
    cardnumber_2 = cardnumber_2.replace(/^\s+|\s+$/g, "");
    cardnumber_3 = cardnumber_3.replace(/^\s+|\s+$/g, "");
    cardnumber_3 = cardnumber_3.replace(/^\s+|\s+$/g, "");
    cardnumber_5 = cardnumber_5.replace(/^\s+|\s+$/g, "");

	

	
	
    $("#payment_method_error").html("");
    $("#card_holder_error").html("");
    $("#year_date_error").html("");
    $("#venue_error").html("");
    $("#city_error").html("");
    $("#zip_code_error").html("");
    $("#state_error").html("");
    $("#country_error").html("");
    $("#phone_error").html("");
    $("#email_error").html("");
    $("#card_number_error").html("");
    $("#cvc_error").html("");
	

    $("#payment_method_error").parent().css("display","none");
    $("#card_holder_error").parent().css("display","none");
    $("#venue_error").parent().css("display","none");
    $("#phone_error").parent().css("display","none");
    $("#email_error").parent().css("display","none");
    $("#card_number_error").parent().parent().css("display","none");
    $("#year_date_error").parent().parent().css("display","none");
    $("#cvc_error").parent().parent().css("display","none");
    $("#cvc_error").parent().css("display","none");
    $("#city_error").parent().css("display","none");
    $("#city_error").parent().parent().css("display","none");
    $("#zipcode_error").parent().css("display","none");
    $("#zipcode_error").parent().parent().css("display","none");
    $("#country_error").parent().parent().css("display","none");
    $("#state_error").parent().parent().css("display","none");
	
    var errorFlag = false;
	
    if (payment_method =="Select" || CardholderName == "" ){
        $("#selectpayment").css("border","1px solid #fc8989");
        $("#payment_method_error").html("Please select payment type");
        $("#payment_method_error").parent().css("display","block");
        errorFlag = true;
    }

	
    if (CardholderName =="Enter Cardholder Name" || CardholderName ==""){
        $("#CardholderName").css("border","1px solid #fc8989");
        $("#card_holder_error").html("Please enter cardholder name");
        $("#card_holder_error").parent().css("display","block");
        errorFlag = true;
    }
	

	
    if(country == "--Choose Country--" || country == "" ){
        $("#Country_border").css("border","1px solid #fc8989");
        $("#country_error").html("Please select the country");
        $("#country_state").css("display","block");
        errorFlag = true;
    }

    if(state == "--Choose State--" || state == "" ){
        $("#State_border").css("border","1px solid #fc8989");
        $("#state_error").html("Please select the state");
        $("#state_error").parent().parent().css("display","block");
        errorFlag = true;
    }

    if (date_card =="Select" || year_card =="Select"){
        $("#date_border").css("border","1px solid #fc8989");
        $("#year_border").css("border","1px solid #fc8989");
        $("#year_date_error").html("Please select date and year");
        $("#year_date_error").parent().css("display","block");
        $("#year_date_error").css("display","block");
        errorFlag = true;
    }
	

    if (cardnumber_1 ==""){
        $("#cardnumber_1").css("border","1px solid #fc8989");
        $("#card_number_error").html("Please enter card number");
        $("#card_number_error").parent().css("display","block");
        $("#card_number_error").css("display","block");
        errorFlag = true;
    }

    else if (isNaN(cardnumber_1)){
        $("#cardnumber_1").css("border","1px solid #fc8989");
        $("#card_number_error").html("Please enter card number");
        $("#card_number_error").parent().css("display","block");
        $("#card_number_error").parent().parent().css("display","block");
        $("#card_number_error").css("display","block");
        errorFlag = true;
    }
	
    if (cardnumber_2 =="" ){
        $("#cardnumber_2").css("border","1px solid #fc8989");
        $("#card_number_error").html("Please enter card number");
        $("#card_number_error").parent().css("display","block");
        $("#card_number_error").parent().parent().css("display","block");
        $("#card_number_error").css("display","block");
        errorFlag = true;
    }
    else if (isNaN(cardnumber_2)){
        $("#cardnumber_2").css("border","1px solid #fc8989");
        $("#card_number_error").html("Please enter card number");
        $("#card_number_error").parent().css("display","block");
        $("#card_number_error").parent().parent().css("display","block");
        $("#card_number_error").css("display","block");
        errorFlag = true;
    }
	
    if (cardnumber_3 =="" ){
        $("#cardnumber_3").css("border","1px solid #fc8989");
        $("#card_number_error").html("Please enter card number");
        $("#card_number_error").parent().parent().css("display","block");
        $("#card_number_error").parent().css("display","block");
        $("#card_number_error").css("display","block");
        errorFlag = true;
    }
    else if (isNaN(cardnumber_3)){
        $("#cardnumber_3").css("border","1px solid #fc8989");
        $("#card_number_error").html("Please enter card number");
        $("#card_number_error").parent().parent().css("display","block");
        $("#card_number_error").parent().css("display","block");
        $("#card_number_error").css("display","block");
        errorFlag = true;
    }
    if (cardnumber_4 ==""){
        $("#cardnumber_4").css("border","1px solid #fc8989");
        $("#card_number_error").html("Please enter card number");
        $("#card_number_error").parent().parent().css("display","block");
        $("#card_number_error").parent().css("display","block");
        $("#card_number_error").css("display","block");
        errorFlag = true;
    }
    else if (isNaN(cardnumber_4)){
        $("#cardnumber_4").css("border","1px solid #fc8989");
        $("#card_number_error").html("Please enter card number");
        $("#card_number_error").parent().parent().css("display","block");
        $("#card_number_error").parent().css("display","block");
        $("#card_number_error").css("display","block");
        errorFlag = true;
    }
    if (cardnumber_5 ==""){
        $("#cardnumber_5").css("border","1px solid #fc8989");
        $("#cvc_error").html("Please enter number");
        $("#cvc_error").parent().css("display","block");
        $("#cvc_error").parent().parent().css("display","block");
        $("#date_year").css("display","block");
        $("#cvc_error").css("display","block");
        errorFlag = true;
    }
    else if (isNaN(cardnumber_5)){
        $("#cardnumber_5").css("border","1px solid #fc8989");
        $("#cvc_error").html("Please enter number");
        $("#cvc_error").parent().css("display","block");
        $("#cvc_error").parent().parent().css("display","block");
        $("#date_year").css("display","block");
        $("#cvc_error").css("display","block");
        errorFlag = true;
    }
    add_1 = add_1.replace(/^\s+|\s+$/g, "");
    if(add_1 == "" || add_1 == "Address Line1"){
        $("#add_1").css("border","1px solid #fc8989");
        $("#venue_error").html("Please enter the venue details");
        $("#venue_error").parent().css("display","block");
        errorFlag = true;
    }
    add_2 = add_2.replace(/^\s+|\s+$/g, "");
    if(add_2 == "" || add_2 == "Address Line2"){
        $("#add_2").css("border","1px solid #fc8989");
        $("#venue_error").html("Please enter the billing address details");
        $("#venue_error").parent().css("display","block");
        errorFlag = true;
    }
    if(city == "--Choose City--" || city == "" ){
        $("#City_border").css("border","1px solid #fc8989");
        $("#city_error").html("Please select the city");
        $("#city_error").parent().css("display","block");
        $("#city_error").parent().parent().css("display","block");
        $("#city_error").css("display","block");
        errorFlag = true;
    }
	
    zip_code = zip_code.replace(/^\s+|\s+$/g, "");
    if(zip_code == "" || zip_code == "Enter Zip Code" ){
		
        $("#zip_code_chkout").css("border","1px solid #fc8989");
        $("#zipcode_error").html("Please enter the Zipcode");
        $("#zipcode_error").parent().css("display","block");
        $("#zipcode_error").parent().parent().css("display","block");
        $("#zipcode_error").css("display","block");
        errorFlag = true;
    }
	
    else if(isNaN(zip_code)){
        $("#zip_code_chkout").css("border","1px solid #fc8989");
        $("#zipcode_error").html("Please enter number");
        $("#zipcode_error").parent().css("display","block");
        $("#zipcode_error").parent().parent().css("display","block");
        $("#zipcode_error").css("display","block");
        errorFlag = true;
    }
	
	
    if(phone_no == "" || phone_no == "Enter Phone Number"){
        $("#phone_no").css("border","1px solid #fc8989");
        $("#phone_error").html("Please enter the contact number");
        $("#phone_error").parent().css("display","block");
        errorFlag = true;
    }

    else if(isNaN(phone_no)){
        $("#phone_no").css("border","1px solid #fc8989");
        $("#phone_error").html("Please enter the number");
        $("#phone_error").parent().css("display","block");
        errorFlag = true;
    }
	
    if(email == "" /*|| email =="Eg:john@gmail.com" || email =="eg:john@gmail.com"*/ ){
        $("#email").css("border","1px solid #fc8989");
        $("#email_error").html("Please enter your email address");
        $("#email_error").parent().css("display","block");
        errorFlag = true;
    }
    else if(email){
        if(email.length<10){
            $("#email").css("border","1px solid #fc8989");
            $("#email_error").html("Please enter the email address having minimum of 10 characters");
            $("#email_error").parent().css("display","block");
            errorFlag = true;
        }
        else if(!validateCorrectEmail(email)){
            $("#email").css("border","1px solid #fc8989");
            $("#email_error").html("Please enter a valid email address");
            $("#email_error").parent().css("display","block");
            errorFlag = true;
        }
        else if(!validateDot(email)){
            $("#email").css("border","1px solid #fc8989");
            $("#email_error").html("Please enter a valid email address");
            $("#email_error").parent().css("display","block");
            errorFlag = true;
        }
    }

    if(errorFlag){	
        var body = document.body,
        html = document.documentElement;
        var height = Math.max( body.scrollHeight, body.offsetHeight,
            html.clientHeight, html.scrollHeight, html.offsetHeight );
        $('.drag-contentarea', window.parent.document).css("height",height+"px");
      
        return false;
    }
    else{
        return true;
    }
	
} 


function focusChangeBorderColor(id){

    switch(id){
		
        case "CardholderName":
            if($('#'+id).val()== "Enter Cardholder Name" ){
                $('#'+id).val('');
            }
            break;
			
        case "first_name":
            if($('#'+id).val()== "First Name" ){
                $('#'+id).val('');
            }
            break;
			
        case "last_name":
            if($('#'+id).val()== "Last Name" ){
                $('#'+id).val('');
            }
            break;

        case "zip_code_chkout":
            if($('#'+id).val() == "Enter Zip Code" ){
                $('#'+id).val('');
            }
            break;
        case "phone_no":
            if($('#'+id).val() == "Enter Phone Number" ){
                $('#'+id).val('');
            }
            break;
        case "add_1":
            if($('#'+id).val() == "Address Line1" ){
                $('#'+id).val('');
            }
            break;
        case "add_2":
            if($('#'+id).val() == "Address Line2" ){
                $('#'+id).val('');
            }
            break;
        case "no_pat":
            if($('#'+id).val() == "Specify Number" ){
                $('#'+id).val('');
            }
            break;
			
    }
    $('#'+id).css("border","1px solid #9fd8eb");
    $('#'+id).css("color","#444444");
    	
}	
function blurChangeBorderColor(id){
    //alert(id);
    switch(id){
		
        case "CardholderName":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Cardholder Name");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
			
        case "first_name":
            if($('#'+id).val()== "" ){
                $('#'+id).val("First Name");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
			
        case "last_name":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Last Name");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;


        case "last_name":
            if($('#'+id).val()== "" ){
                $('#'+id).val("last_name");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
			
        case "zip_code_chkout":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Zip Code");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "phone_no":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Phone Number");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "add_1":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Address Line1");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "add_2":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Address Line2");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "no_pat":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Specify Number");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
    }
    $('#'+id).css("border","1px solid #BDD6DD");
}

function setDropDownValueChkout(val){
    document.getElementById("date_card").value=val;
    document.getElementById("field_date").innerHTML=val;
	$("#field_date").css("color","#444444");
    document.getElementById("dropDownDiv1").style.display="none";
}
function setDropDownValuey(val){
	
    document.getElementById("year_card").value=val;
    document.getElementById("field2").innerHTML=val;
	$("#field2").css("color","#444444");
    document.getElementById("dropDownDiv2").style.display="none";
}

function setDropDownValue(val){
    //alert(val);
	
    document.getElementById("payment_method").value=val;
    document.getElementById("field").innerHTML=val;
	$("#field").css("color","#444444");
    document.getElementById("dropDownDiv6").style.display="none";
    $(".billing .selectBoxCity").css("background","url('/assets/create_new_activity/select_box_bg.png') no-repeat");
    if(val == "Credit Card Account"){
        //alert("block");
        document.getElementById("card_payment").style.display="block";
        document.getElementById("paypal").style.display="none";


    }
    else if(val == "PayPal"){
        //alert("by");
        document.getElementById("paypal").style.display="block";
        document.getElementById("card_payment").style.display="none";
        $("#payment_method_error").html("");
        $("#selectpayment").css("border","none");
		
    }
}

function setDropDownValue3(val){
    document.getElementById("chkout_city").value=val;
    document.getElementById("field3").innerHTML=val;
	$("#field3").css("color","#444444");
    document.getElementById("dropDownDiv3").style.display="none";
}

/*function setDropDownValue4(val){
	
    document.getElementById("chkout_country").value=val;
    document.getElementById("field4").innerHTML=val;
    document.getElementById("dropDownDiv3").style.display="none";
}
function setDropDownValue5(val){
	
    document.getElementById("chkout_state").value=val;
    document.getElementById("field5").innerHTML=val;
    document.getElementById("dropDownDiv5").style.display="none";
}*/

function selectRegdateUsrKeyDown(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13){   
        document.getElementById("dropDownDiv1").style.display="block";
        document.getElementById("dropDownDiv2").style.display="none";
        document.getElementById("dropDownDiv3").style.display="none";
        document.getElementById("dropDownDiv4").style.display="none";
        flag1=false;
    }	
    else{
        document.getElementById("dropDownDiv1").style.display="none";
		
        flag1=true;
    }
}




var flag;
function selectKeyDown(e){	
    var KeyCode_pay = (e.which) ? e.which : e.keyCode
    if(KeyCode_pay==32 || KeyCode_pay==13){   
        document.getElementById("dropDownDiv").style.display="block";
        document.getElementById("dropDownDiv1").style.display="none";
        document.getElementById("dropDownDiv2").style.display="none";
        document.getElementById("dropDownDiv3").style.display="none";
        document.getElementById("dropDownDiv4").style.display="none";
        document.getElementById("dropDownDiv5").style.display="none";
        flag=false;
    }	
    else{
        document.getElementById("dropDownDiv").style.display="none";
        flag=true;
    }
}


function CancelPayment(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        CancelPaymentKeyDown();
    }
}
function signinPaymentKeyDown(e){
    //document.getElementById("dropDownDiv").style.display="none";
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==13 || KeyCode==32){
        validateCardActivity();
    }
}



/***********display Popup***********/

function dispCheck_pop(){
    //alert("test");
    $('#repeatPOPUPDiv_1').css('display','block');
		
    //cancelRepeatDiv();
}

function closeRepeatDiv(){
    $('#repeatPOPUPDiv_1').css('display','none');
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
	return true;	*/
} 
/*function CardClearData(){
	 $("#payment_method").val('');
	 $("#CardholderName").val('');
	 
	  $(".billing .selectBoxCity").css("background","url('/assets/create_new_activity/select_box_bg.png') no-repeat");
	   $("#CardholderName").css("border","1px solid #CDE0E6");
	  
	  $("#payment_method_error").html("");
	  $("#card_holder_error").html("");
	  
	  $("#payment_method_error").parent().css("display","none");
	  $("#card_holder_error").parent().css("display","none");
}*/
