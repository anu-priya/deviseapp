
function hide_error(){
$("#paye_name_error").hide();
$("#business_name_error").hide();
$("#check_zip_error").hide();
}

function check(type){
  if (type=="check")
  {
    $("#check").show();
    $("#bank_user").hide();
    $("#check_helptext").show();
    $("#bank_helptext").hide();
    $("#radio_value").val("check"); 
  }
 else if (type=="bankinfo")
  {
    $("#bank_user").show();
    $("#check").hide();
    $("#check_helptext").hide();
    $("#bank_helptext").show();
    $("#radio_value").val("bankinfo");
  }
 }

 function ChekRegValidation(){    

 	var l_name =  $("#radio_value").val();
      errorFlag = false;
    if (l_name=="check")     // check if start
    {
      var paye_name = $("#paye_name").val();
        var business_name = $("#business_name").val();
        var check_z_code = $("#check_z_code").val();
        var check_bank_city = $("#check_bank_city").val();
        check_z_code = check_z_code.replace(/^\s+|\s+$/g, "");
        paye_name = paye_name.replace(/^\s+|\s+$/g, "");
        business_name = business_name.replace(/^\s+|\s+$/g, "");
        $("#check_z_code").css("border","1px solid #d4d4d4");
        $("#paye_name").css("border","1px solid #d4d4d4");
        $("#business_name").css("border","1px solid #d4d4d4");
        
        if(paye_name == "" || paye_name == "Enter payee name"){
          $("#paye_name").css("border","1px solid #fc8989");
          $("#paye_name_error").html("Please enter payee name");
          $("#paye_name_error").parent().css("display","block");
          errorFlag = true;
        }
          if(business_name == "" || business_name == "Enter business name" ){
          $("#business_name").css("border","1px solid #fc8989");
          $("#business_name_error").html("Please enter business name");
          $("#business_name_error").parent().css("display","block");
          errorFlag = true; 
        }
	if(check_bank_city != "Enter City" || check_bank_city != ""){
	    if(!validateName(check_bank_city)){
		  $("#check_bank_city").css("border","1px solid #fc8989");
		  $("#check_bank_city_error").html("Please enter valid city");
		  $("#check_bank_city_error").parent().css("display","block");
		  errorFlag = true;
	      }
        }
         if(check_z_code == "" || check_z_code == "Enter zip code"){
            $("#check_z_code").css("border","1px solid #fc8989");
            $("#check_zip_error").html("Please enter zipcode");
            $("#check_zip_error").parent().css("display","block");
            errorFlag = true;
          }
          else if(isNaN(check_z_code)){
            $("#check_z_code").css("border","1px solid #fc8989");
            $("#check_zip_error").html("Please enter number");
            $("#check_zip_error").parent().css("display","block");
            errorFlag = true;
          }


    if(errorFlag){
      return false;
    }
    else{
       $.post($("#frmbank_details").attr('action'), $("#frmbank_details").serialize(), null, "script");
      return false;
    

    }

      }   // check if end

          if(l_name=="bankinfo")   // bank if start
    { 
    var bank_state = $("#bank_state").val();
    var bank_city = $("#bank_city").val();   
    var bank_name =  $("#bank_name").val();
    var w_transfer = $("#w_transfer").val();
    var account_name = $("#account_name").val();
    var acc_number = $("#acc_number").val();   
    var street_bank_code = $("#street_bank_code").val();
    //~ var number_bank_code = $("#number_bank_code").val();
    var bank_z_code = $("#bank_z_code").val();
    //~ var sell_agree_provider = $("#sell_agree_provider").val();
	

    bank_state = bank_state.replace(/^\s+|\s+$/g, "");
    bank_city = bank_city.replace(/^\s+|\s+$/g, "");
    bank_name = bank_name.replace(/^\s+|\s+$/g, "");
    w_transfer = w_transfer.replace(/^\s+|\s+$/g, "");
    account_name = account_name.replace(/^\s+|\s+$/g, "");
    acc_number = acc_number.replace(/^\s+|\s+$/g, "");   
    street_bank_code = street_bank_code.replace(/^\s+|\s+$/g, "");
   // number_bank_code = number_bank_code.replace(/^\s+|\s+$/g, "");
    bank_z_code = bank_z_code.replace(/^\s+|\s+$/g, "");


    $("#bank_name").css("border","1px solid #d4d4d4");
    $("#w_transfer").css("border","1px solid #d4d4d4");
    $("#account_name").css("border","1px solid #d4d4d4");
    $("#acc_number").css("border","1px solid #d4d4d4");   
    $("#street_bank_code").css("border","1px solid #d4d4d4");
    //~ $("#number_bank_code").css("border","1px solid #d4d4d4");
    $("#bank_z_code").css("border","1px solid #d4d4d4");
    $(".selectBoxStateBankReg").css("border","none");
    $(".selectBoxCityBankReg").css("border","none");
    $(".selectBoxStateReg").css("border","none");
    $(".selectBoxCityReg").css("border","none");
    $("#sell_agree_provider").css("border","1px solid #d4d4d4");
	

    $("#bank_name_error").html("");
    $("#wire_transfer_error").html("");
    $("#clear_house_error").html("");
    $("#acc_number_error").html("");   
    $("#street_bank_error").html("");
    $("#number_bank_error").html("");
    $("#city_bank_error").html("");
    $("#state_bank_error").html("");
    $("#bank_zip_error").html("");
    $("#sell_agree_provider_error").html("");

    $("#bank_name_error").parent().css("display","none");
    $("#wire_transfer_error").parent().css("display","none");
    $("#clear_house_error").parent().css("display","none");
    $("#acc_number_error").parent().css("display","none");
    $("#street_bank_error").parent().css("display","none");
    $("#number_bank_error").parent().css("display","none");
    $("#street_bank_error").parent().parent().css("display","none");
    $("#number_bank_error").parent().parent().css("display","none");
    $("#city_bank_error").parent().parent().css("display","none");
    $("#state_bank_error").parent().parent().css("display","none");
    $("#bank_zip_error").parent().css("display","none");
    $("#checkboxError").css("display","none");
   
    var errorFlag = false;
   
    if(bank_name == "" || bank_name == "Name of bank"){
      $("#bank_name").css("border","1px solid #fc8989");
      $("#bank_name_error").html("Please enter bank name");
      $("#bank_name_error").parent().css("display","block");
      errorFlag = true;
    }
    else if(!validateName(bank_name)){
      $("#bank_name").css("border","1px solid #fc8989");
      $("#bank_name_error").html("Please Use Only Alphabets");
      $("#bank_name_error").parent().css("display","block");
      errorFlag = true;
    }
    if(account_name == "" || account_name == "Enter your account name"){
      $("#account_name").css("border","1px solid #fc8989");
      $("#clear_house_error").html("Please enter account name");
      $("#clear_house_error").parent().css("display","block");
      errorFlag = true;
    }
    
    if(w_transfer == "" || w_transfer == "Enter the routing number"){
      $("#w_transfer").css("border","1px solid #fc8989");
      $("#wire_transfer_error").html("Please enter the value");
      $("#wire_transfer_error").parent().css("display","block");
      errorFlag = true;
    }
    else if(isNaN(w_transfer)){
      $("#w_transfer").css("border","1px solid #fc8989");
      $("#wire_transfer_error").html("Please enter number");
      $("#wire_transfer_error").parent().css("display","block");
      errorFlag = true;
    }

    if(acc_number == "" || acc_number == "Enter your account number"){
      $("#acc_number").css("border","1px solid #fc8989");
      $("#acc_number_error").html("Please enter account number");
      $("#acc_number_error").parent().css("display","block");
      errorFlag = true;
    }
    else if(isNaN(acc_number)){
      $("#acc_number").css("border","1px solid #fc8989");
      $("#acc_number_error").html("Please enter number");
      $("#acc_number_error").parent().css("display","block");
      errorFlag = true;
    }
    
    if(bank_state == "" || bank_state == "--Choose State--"){
      $(".selectBoxStateBankReg").css("border","1px solid #fc8989");
      $("#state_bank_error").html("Please select the state");
      $("#state_bank_error").parent().parent().css("display","block");
      errorFlag = true;
    }
    if(bank_city == "" || bank_city == "Enter City"){
      $("#bank_city").css("border","1px solid #fc8989");
      $("#city_bank_error").html("Please enter the city");
      $("#city_bank_error").parent().parent().css("display","block");
      errorFlag = true;
    }
	if(bank_city != "Enter City" || bank_city != ""){
	    if(!validateName(bank_city)){
		  $("#bank_city").css("border","1px solid #fc8989");
		  $("#city_bank_error").html("Please enter valid city");
		  $("#city_bank_error").parent().parent().css("display","block");
		  errorFlag = true;
	      }
        }
    if(bank_z_code == "" || bank_z_code == "Enter zip code"){
      $("#bank_z_code").css("border","1px solid #fc8989");
      $("#bank_zip_error").html("Please enter zipcode");
      $("#bank_zip_error").parent().css("display","block");
      errorFlag = true;
    }
	
    else if(isNaN(bank_z_code)){
      $("#bank_z_code").css("border","1px solid #fc8989");
      $("#bank_zip_error").html("Please enter number");
      $("#bank_zip_error").parent().css("display","block");
      errorFlag = true;
    }
    
	if($('#sell_checkbox_selected_agree_s').is(':checked')){
		$("#sell_checkbox_selected_agree_s").attr ( "checked" ,"checked" );
	}
	else
	{
		$("#checkboxError").css("display","block");
		$("#sell_agree_provider_error").html("Please check the terms of service box");
		errorFlag = true;
	}

    if(errorFlag){
      return false;
    }
    else{
       $.post($("#frmbank_details").attr('action'), $("#frmbank_details").serialize(), null, "script");
      return false;
    }
  }// bank if end 
  
  }
  
  function afterSuccess()
  {
    $('.loadingmessage').hide();
  }
  
  function validateName(elementValue){
    var alphaExp = /^[a-zA-Z ]*$/;
    return alphaExp.test(elementValue);
  }
  
  function validateAName(elementValue){
    var alphaExp =  /^[a-zA-Z. ]*$/;
    return alphaExp.test(elementValue);
  }