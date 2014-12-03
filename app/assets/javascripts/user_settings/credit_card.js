
function sell_dispCheck_pop()
{
$("#sell_repeatPOPUPDiv").show();
}
function sell_closeRepeatDiv()
{
$("#sell_repeatPOPUPDiv").hide();
}

function sell_validateCard(){ 
        var payment_method = $("#sell_payment_method").val();
        var CardholderFirstName = $("#sell_CardholderFirstName").val();
        var chkout_card = $("#sell_chkout_card").val();
        var date_card= $("#sell_date_card").val();
        var year_card= $("#sell_year_card_1").val();
	
        var phone_no=$("#sell_phone_no").val();
        var cardnumber_1 = $("#sell_cardnumber_1").val();
        var cardnumber_2 = $("#sell_cardnumber_2").val();
        var cardnumber_3 = $("#sell_cardnumber_3").val();
        var cardnumber_4 = $("#sell_cardnumber_4").val();
        var cardnumber_5 = $("#sell_cardnumber_5").val();
	

        $("#sell_payment_method").css("border","1px solid #d4d4d4");
        $("#sell_CardholderFirstName").css("border","1px solid #d4d4d4");
      //  $("#sell_CardholderLastName").css("border","1px solid #CDE0E6");	
        $("#sell_add_1").css("border","1px solid #d4d4d4");
        $("#sell_add_2").css("border","1px solid #d4d4d4");
        $("#sell_chkout_city").css("border","1px solid #d4d4d4");
        $("#sell_zip_code_chkout").css("border","1px solid #d4d4d4");
        $(".selectBoxMedium").css("border","none");
        $("#sell_phone_no").css("border","1px solid #d4d4d4");
        $("#sell_checkbox_selected_agree").css("display","block");
        $("#sell_checkbox_normal_agree").css("display","none");
        $("#sell_checkbox_error_agree").css("display","none");
        //$("#email").css("border","1px solid #CDE0E6");
        $("#sell_cardnumber_1").css("border","1px solid #d4d4d4");
        $("#sell_cardnumber_2").css("border","1px solid #d4d4d4");
        $("#sell_cardnumber_3").css("border","1px solid #d4d4d4");
        $("#sell_cardnumber_4").css("border","1px solid #d4d4d4");
        $("#sell_cardnumber_5").css("border","1px solid #d4d4d4");
        $("#sell_chkout_card").css("border","1px solid #d4d4d4");
        $("#sell_Country_border").css("border","none");
        $("#sell_State_border").css("border","none");
        $("#sell_City_border").css("border","none");
        $("#sell_date_border").css("border","none");
        $("#sell_year_border").css("border","none");
        $("#sell_selectpayment").css("border","none");

        payment_method = payment_method.replace(/^\s+|\s+$/g, "");
        CardholderFirstName = CardholderFirstName.replace(/^\s+|\s+$/g, "");
        //CardholderLastName = CardholderLastName.replace(/^\s+|\s+$/g, "");
        phone_no = phone_no.replace(/^\s+|\s+$/g, "");
        //email = email.replace(/^\s+|\s+$/g, "");
        cardnumber_1 = cardnumber_1.replace(/^\s+|\s+$/g, "");
        cardnumber_2 = cardnumber_2.replace(/^\s+|\s+$/g, "");
        cardnumber_3 = cardnumber_3.replace(/^\s+|\s+$/g, "");
        cardnumber_3 = cardnumber_3.replace(/^\s+|\s+$/g, "");
        cardnumber_5 = cardnumber_5.replace(/^\s+|\s+$/g, "");

        $("#sell_payment_method_error").html("");
        $("#sell_card_holder_first_error").html("");
        $("#sell_card_holder_last_error").html("");
        $("#sell_card_error").html("");
        $("#sell_year_date_error").html("");
        $("#sell_venue_error").html("");
        $("#sell_city_error").html("");
        $("#sell_zip_code_error").html("");
        $("#sell_state_error").html("");
        $("#sell_country_error").html("");
        $("#sell_phone_error").html("");
        $("#sell_agree_error").html("");
        //$("#email_error").html("");
        $("#sell_card_number_error").html("");
        $("#sell_cvc_error").html("");


        $("#sell_payment_method_error").parent().css("display","none");
        $("#sell_card_holder_first_error").parent().css("display","none");
        $("#sell_card_holder_last_error").parent().css("display","none"); 
        $("#sell_card_error").parent().parent().css("display","none");
        $("#sell_venue_error").parent().css("display","none");
        $("#sell_phone_error").parent().css("display","none");
        $("#sell_agree_error").parent().css("display","none");
        //$("#email_error").parent().css("display","none");
        $("#sell_card_number_error").parent().parent().css("display","none");
        $("#sell_year_date_error").parent().parent().css("display","none");
        $("#sell_cvc_error").parent().parent().css("display","none");
        $("#sell_cvc_error").parent().css("display","none");       
        $("#sell_city_error").parent().parent().css("display","none");
        $("#sell_zipcode_error").parent().parent().css("display","none");
        $("#sell_country_error").parent().parent().css("display","none");
        $("#sell_state_error").parent().parent().css("display","none");

        var flag = 2;

        if (payment_method =="Select"){
          $("#sell_selectpayment").css("border","1px solid #fc8989");
          $("#sell_payment_method_error").html("Please select payment type");
          $("#sell_payment_method_error").parent().css("display","block");
          flag=1;
        }


        if (CardholderFirstName =="Enter Name On Your Card" || CardholderFirstName ==""){
          $("#sell_CardholderFirstName").css("border","1px solid #fc8989");
          $("#sell_card_holder_first_error").html("Please enter name on your card");
          $("#sell_card_holder_first_error").parent().css("display","block");
          flag=1;
        }
	
       if (chkout_card =="Choose Payment type" || chkout_card ==""){
          $("#sell_chkout_card").css("border","1px solid #fc8989");
          $("#sell_card_error").html("Please select payment type");
          $("#sell_card_error").parent().parent().css("display","block");
          flag=1;
        }

        if (date_card == "MM" && year_card =="YYYY" ){
          $("#sell_date_border").css("border","1px solid #fc8989");
          $("#sell_year_border").css("border","1px solid #fc8989");
          $("#sell_year_date_error").html("Please select date and year");
          $("#sell_year_date_error").parent().css("display","block");
          $("#sell_year_date_error").parent().parent().css("display","block");
          flag=1;
        }
	
        if (year_card == "YYYY" && date_card != "MM"){
          $("#sell_year_border").css("border","1px solid #fc8989");
          $("#sell_year_date_error").html("Please select year");
          $("#sell_year_date_error").parent().css("display","block");
          $("#sell_year_date_error").parent().parent().css("display","block");
          flag=1;
        }
	
        if (date_card == "MM" && year_card != "YYYY" ){
          $("#sell_date_border").css("border","1px solid #fc8989");
          $("#sell_year_date_error").html("Please select date");
          $("#sell_year_date_error").parent().css("display","block");
          $("#sell_year_date_error").parent().parent().css("display","block");
          flag=1;
        }


        if (cardnumber_1 ==""){
          $("#sell_cardnumber_1").css("border","1px solid #fc8989");
          $("#sell_card_number_error").html("Please enter card number");
          $("#sell_card_number_error").parent().css("display","block");
          $("#sell_card_number_error").css("display","block");
          flag=1;
        }

        else if (isNaN(cardnumber_1)){
          $("#sell_cardnumber_1").css("border","1px solid #fc8989");
          $("#sell_card_number_error").html("Please enter valid card number");
          $("#sell_card_number_error").parent().css("display","block");
          $("#sell_card_number_error").parent().parent().css("display","block");
          $("#sell_card_number_error").css("display","block");
          flag=1;
        }

        if (cardnumber_2 =="" ){
          $("#sell_cardnumber_2").css("border","1px solid #fc8989");
          $("#sell_card_number_error").html("Please enter card number");
          $("#sell_card_number_error").parent().css("display","block");
          $("#sell_card_number_error").parent().parent().css("display","block");
          $("#sell_card_number_error").css("display","block");
          flag=1;
        }
        else if (isNaN(cardnumber_2)){
          $("#sell_cardnumber_2").css("border","1px solid #fc8989");
          $("#sell_card_number_error").html("Please enter valid card number");
          $("#sell_card_number_error").parent().css("display","block");
          $("#sell_card_number_error").parent().parent().css("display","block");
          $("#sell_card_number_error").css("display","block");
          flag=1;
        }

        if (cardnumber_3 =="" ){
          $("#sell_cardnumber_3").css("border","1px solid #fc8989");
          $("#sell_card_number_error").html("Please enter card number");
          $("#sell_card_number_error").parent().parent().css("display","block");
          $("#sell_card_number_error").parent().css("display","block");
          $("#sell_card_number_error").css("display","block");
          flag=1;
        }
        else if (isNaN(cardnumber_3)){
          $("#sell_cardnumber_3").css("border","1px solid #fc8989");
          $("#sell_card_number_error").html("Please enter valid card number");
          $("#sell_card_number_error").parent().parent().css("display","block");
          $("#sell_card_number_error").parent().css("display","block");
          $("#sell_card_number_error").css("display","block");
          flag=1;
        }
        if (cardnumber_4 ==""){
          $("#sell_cardnumber_4").css("border","1px solid #fc8989");
          $("#sell_card_number_error").html("Please enter card number");
          $("#sell_card_number_error").parent().parent().css("display","block");
          $("#sell_card_number_error").parent().css("display","block");
          $("#sell_card_number_error").css("display","block");
          flag=1;
        }
        else if (isNaN(cardnumber_4)){
          $("#sell_cardnumber_4").css("border","1px solid #fc8989");
          $("#sell_card_number_error").html("Please enter valid card number");
          $("#sell_card_number_error").parent().parent().css("display","block");
          $("#sell_card_number_error").parent().css("display","block");
          $("#sell_card_number_error").css("display","block");
          flag=1;
        }
        if (cardnumber_5 ==""){
          $("#sell_cardnumber_5").css("border","1px solid #fc8989");
          $("#sell_cvc_error").html("Please enter cvc number");
          $("#sell_cvc_error").parent().css("display","block");
          $("#sell_cvc_error").parent().parent().css("display","block");
          $("#sell_date_year").css("display","block");
          $("#sell_cvc_error").css("display","block");
          flag=1;
        }
        else if (isNaN(cardnumber_5)){
          $("#sell_cardnumber_5").css("border","1px solid #fc8989");
          $("#sell_cvc_error").html("Please enter valid cvc number");
          $("#sell_cvc_error").parent().css("display","block");
          $("#sell_cvc_error").parent().parent().css("display","block");
          $("#sell_date_year").css("display","block");
          $("#sell_cvc_error").css("display","block");
          flag=1;
        }
        else if (cardnumber_5.length < 3){
          $("#sell_cardnumber_5").css("border","1px solid #fc8989");
          $("#sell_cvc_error").html("Please enter valid cvc number");
          $("#sell_cvc_error").parent().css("display","block");
          $("#sell_cvc_error").parent().parent().css("display","block");
          $("#sell_date_year").css("display","block");
          $("#sell_cvc_error").css("display","block");
          flag=1;
        }
      
	
	if($('#sell_checkbox_selected_agree_s').is(':checked')){
	  $("#sell_checkbox_selected_agree_s").attr ( "checked" ,"checked" );
	}
	else
	{
	  $("#sell_checkbox_error_agree").css("display","block");
          $("#sell_agree_error").html("Please check the terms of service box");
          $("#sell_agree_error").parent().css("display","block");
          flag=1;
	}
	
        if(flag==1){
          $('.loadingmessage').hide();
          return false;
        }
        else{    
                $(".loadingmessage").css("display","inline-block");
		$.post($("#updatecc_details").attr('action'), $("#updatecc_details").serialize(), null, "script");
		return false;
		
        }
 }

 function afterSuccess()
  {
    $('.loadingmessage').hide();
  }
  
    //set automatically go to next textbox
  function movetoNext(current, nextFieldID) {
    if (current.value.length >= current.maxLength) {
      document.getElementById(nextFieldID).focus();
    }
  }
  
function number(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57 ) && (charCode != 46 ) ){
        //alert("Allow only Numbers");
        return false;			
    }
    return true;
}