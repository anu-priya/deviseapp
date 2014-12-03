// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

/** Validating Register Form **/
function ChekRegValidation(){
	alert(29);
    var s_code = $("#s_code").val();
    var l_name = $("#l_name").val();
    var t_code = $("#t_code").val();
    var street_reg = $("#street_reg").val();
    var number_reg = $("#number_reg").val();
	var city_reg = $("#city_reg").val();
	var state_reg = $("#state_reg").val();
	var bank_state = $("#bank_state").val();
	var bank_city = $("#bank_city").val();
	var z_code =  $("#z_code").val();
	var bank_name =  $("#bank_name").val();
	var w_transfer = $("#w_transfer").val();
	var c_house = $("#c_house").val();
	var acc_number = $("#acc_number").val();
	var swift_code = $("#swift_code").val();
	var street_bank_code = $("#street_bank_code").val();
	var number_bank_code = $("#number_bank_code").val();
	var bank_z_code = $("#bank_z_code").val();
	var fax_num = $("#fax_num").val();
	var address_name = $("#address_name").val();
	
	
	s_code = s_code.replace(/^\s+|\s+$/g, "");
	l_name = l_name.replace(/^\s+|\s+$/g, "");
	t_code = t_code.replace(/^\s+|\s+$/g, "");
	street_reg = street_reg.replace(/^\s+|\s+$/g, "");
	number_reg = number_reg.replace(/^\s+|\s+$/g, "");
	city_reg = city_reg.replace(/^\s+|\s+$/g, "");
	z_code = z_code.replace(/^\s+|\s+$/g, "");
	state_reg = state_reg.replace(/^\s+|\s+$/g, "");
	bank_state = bank_state.replace(/^\s+|\s+$/g, "");
	bank_city = bank_city.replace(/^\s+|\s+$/g, "");
	bank_name = bank_name.replace(/^\s+|\s+$/g, "");
	w_transfer = w_transfer.replace(/^\s+|\s+$/g, "");
	c_house = c_house.replace(/^\s+|\s+$/g, "");
	acc_number = acc_number.replace(/^\s+|\s+$/g, "");
	swift_code = swift_code.replace(/^\s+|\s+$/g, "");
	street_bank_code = street_bank_code.replace(/^\s+|\s+$/g, "");
	number_bank_code = number_bank_code.replace(/^\s+|\s+$/g, "");
	bank_z_code = bank_z_code.replace(/^\s+|\s+$/g, "");
	fax_num = fax_num.replace(/^\s+|\s+$/g, "");
	address_name = address_name.replace(/^\s+|\s+$/g, "");

	$("#s_code").css("border","1px solid #BDD6DD");
	$("#l_name").css("border","1px solid #BDD6DD");
	$("#t_code").css("border","1px solid #BDD6DD");
	$("#street_reg").css("border","1px solid #BDD6DD");
	$("#number_reg").css("border","1px solid #BDD6DD");
    $("#city_reg").css("border","1px solid #BDD6DD");
    $("#state_reg").css("border","1px solid #BDD6DD");
	$("#z_code").css("border","1px solid #BDD6DD");
	$("#bank_name").css("border","1px solid #BDD6DD");
	$("#w_transfer").css("border","1px solid #BDD6DD");
	$("#c_house").css("border","1px solid #BDD6DD");
	$("#acc_number").css("border","1px solid #BDD6DD");
	$("#swift_code").css("border","1px solid #BDD6DD");
	$("#street_bank_code").css("border","1px solid #BDD6DD");
	$("#number_bank_code").css("border","1px solid #BDD6DD");
	$("#bank_z_code").css("border","1px solid #BDD6DD");
	$("#fax_num").css("border","1px solid #BDD6DD");
	$("#address_name").css("border","1px solid #BDD6DD");
	$(".selectBoxStateBankReg").css("border","none");
	$(".selectBoxCityBankReg").css("border","none");
	$(".selectBoxStateReg").css("border","none");
	$(".selectBoxCityReg").css("border","none");
	

	$("#s_code_error").html("");
	$("#legal_name_error").html("");
	$("#tax_code_error").html("");
	$("#street_error").html("");
	$("#number_error").html("");
	$("#city_error").html("");
	$("#state_error").html("");
	$("#zip_error").html("");
	$("#bank_name_error").html("");
	$("#wire_transfer_error").html("");
	$("#clear_house_error").html("");
	$("#acc_number_error").html("");
	$("#swift_code_error").html("");
	$("#street_bank_error").html("");
	$("#number_bank_error").html("");
	$("#city_bank_error").html("");
	$("#state_bank_error").html("");
	$("#bank_zip_error").html("");
	$("#fax_error").html("");
	$("#address_name_error").html("");

	
	$("#s_code_error").parent().css("display","none");
    $("#legal_name_error").parent().css("display","none")	
    $("#tax_code_error").parent().css("display","none");
    $("#city_error").parent().parent().css("display","none");
    $("#state_error").parent().parent().css("display","none");
    $("#zip_error").parent().css("display","none");
    $("#bank_name_error").parent().css("display","none");
    $("#wire_transfer_error").parent().css("display","none");
    $("#clear_house_error").parent().css("display","none");
    $("#acc_number_error").parent().css("display","none");
    $("#swift_code_error").parent().css("display","none");
    $("#street_bank_error").parent().css("display","none");
    $("#number_bank_error").parent().css("display","none");
	$("#street_bank_error").parent().parent().css("display","none");
	$("#number_bank_error").parent().parent().css("display","none");
    $("#city_bank_error").parent().parent().css("display","none");
    $("#state_bank_error").parent().parent().css("display","none");
    $("#bank_zip_error").parent().css("display","none");
    $("#fax_error").parent().css("display","none");
    $("#address_name_error").parent().css("display","none");
	
	var errorFlag = false;
	
    if(s_code == "" || s_code == "Enter your unique supplier code"){
        $("#s_code").css("border","1px solid #fc8989");
        $("#s_code_error").html("Please enter your supplier code");
        $("#s_code_error").parent().css("display","block");
        errorFlag = true;
    }
	else if(!validateName(s_code)){
        $("#s_code").css("border","1px solid #fc8989");
        $("#s_code_error").html("Please Use Only Alphabets");
        $("#s_code_error").parent().css("display","block");
        errorFlag = true;
    }

    if(l_name == "" || l_name == "First and Last name"){
        $("#l_name").css("border","1px solid #fc8989");
        $("#legal_name_error").html("Please enter your Legal name");
        $("#legal_name_error").parent().css("display","block");
        errorFlag = true;
    }

   else if(!validateName(l_name)){
        $("#l_name").css("border","1px solid #fc8989");
        $("#legal_name_error").html("Please Use Only Alphabets");
        $("#legal_name_error").parent().css("display","block");
        errorFlag = true;
    }

    if(t_code == "" || t_code == "Enter your tax code"){
        $("#t_code").css("border","1px solid #fc8989");
        $("#tax_code_error").html("Please enter your tax number");
        $("#tax_code_error").parent().css("display","block");
        errorFlag = true;
    }
    else if(isNaN(t_code)){
        $("#t_code").css("border","1px solid #fc8989");
        $("#tax_code_error").html("Please enter number");
        $("#tax_code_error").parent().css("display","block");
        errorFlag = true;
    }
    if(street_reg == "" || street_reg == "Enter street address"){
        $("#street_reg").css("border","1px solid #fc8989");
        $("#street_error").html("Please enter your street");
        $("#street_error").css("display","block");
        $("#stree_number").css("display","block");
        errorFlag = true;
    }

    if(number_reg == "" || number_reg == "Enter number"){
        $("#number_reg").css("border","1px solid #fc8989");
        $("#number_error").html("Please enter your number");
        $("#stree_number").css("display","block");
        errorFlag = true;
    }
	
	
    if(isNaN(number_reg)){
        $("#number_reg").css("border","1px solid #fc8989");
        $("#number_error").html("Please enter your number");
        $("#stree_number").css("display","block");
        errorFlag = true;
    }
	
    if(state_reg == "--Choose State--" || state_reg == ""){
		//alert(state_reg);
        $(".selectBoxStateReg").css("border","1px solid #fc8989");
        $("#state_error").html("Please select your state");
		$("#city_state").css("display","block");
		
        //$("#state_error").parent().parent().css("display","block");
        errorFlag = true;
    }

    if(city_reg == "--Choose City--" || city_reg == ""){
        $(".selectBoxCityReg").css("border","1px solid #fc8989");
        $("#city_error").html("Please select your city");
        $("#city_error").parent().parent().css("display","block");
        errorFlag = true;
    }
	
    if(z_code == "" || z_code == "Enter zip code"){
        $("#z_code").css("border","1px solid #fc8989");
        $("#zip_error").html("Please enter zipcode");
        $("#zip_error").parent().css("display","block");
        errorFlag = true;
    }
	
    else if(isNaN(z_code)){
        $("#z_code").css("border","1px solid #fc8989");
        $("#zip_error").html("Please enter number");
        $("#zip_error").parent().css("display","block");
        errorFlag = true;
    }
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
	
    if(w_transfer == "" || w_transfer == "Enter the ABA number"){
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
	 if(c_house == "" || c_house == "Enter the ABA number"){
		$("#c_house").css("border","1px solid #fc8989");
		$("#clear_house_error").html("Please enter the value");
		$("#clear_house_error").parent().css("display","block");
		errorFlag = true;
    }

    if(isNaN(c_house)){
        $("#c_house").css("border","1px solid #fc8989");
        $("#clear_house_error").html("Please enter number");
        $("#clear_house_error").parent().css("display","block");
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
	
    if(swift_code == "" || swift_code == "Enter the swift code"){
        $("#swift_code").css("border","1px solid #fc8989");
        $("#swift_code_error").html("Please enter swift code");
        $("#swift_code_error").parent().css("display","block");
        errorFlag = true;
    }
	
    if(street_bank_code == "" || street_bank_code == "Enter street address"){
        $("#street_bank_code").css("border","1px solid #fc8989");
        $("#street_bank_error").html("Please enter bank street");
		$("#street_bank_error").css("display","block");
		$("#bank_stree_number").css("display","block");
        $("#street_bank_error").parent().css("display","block");
        errorFlag = true;
    }


    if(number_bank_code == "" || number_bank_code == "Enter number"){
        $("#number_bank_code").css("border","1px solid #fc8989");
        $("#number_bank_error").html("Please enter bank number");
		$("#number_bank_error").css("display","block");
		$("#bank_stree_number").css("display","block");
        $("#number_bank_error").parent().css("display","block");
        errorFlag = true;
    }

    if(isNaN(number_bank_code)){
        $("#number_bank_code").css("border","1px solid #fc8989");
        $("#number_bank_error").html("Please enter bank number");
		$("#number_bank_error").css("display","block");
		$("#bank_stree_number").css("display","block");
        $("#number_bank_error").parent().css("display","block");
        errorFlag = true;
    }
	
    if(bank_state == "" || bank_state == "--Choose State--"){
        $(".selectBoxStateBankReg").css("border","1px solid #fc8989");
        $("#state_bank_error").html("Please select your state");
        $("#state_bank_error").parent().parent().css("display","block");
        errorFlag = true;
    }

    if(bank_city == "" || bank_city == "--Choose City--"){
        $(".selectBoxCityBankReg").css("border","1px solid #fc8989");
        $("#city_bank_error").html("Please select your city");
        $("#city_bank_error").parent().parent().css("display","block");
        errorFlag = true;
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
    if(fax_num == "" || fax_num == "Enter a fax number"){
        $("#fax_num").css("border","1px solid #fc8989");
        $("#fax_error").html("Please enter fax number");
        $("#fax_error").parent().css("display","block");
        errorFlag = true;
    }
	
    else if(isNaN(fax_num)){
        $("#fax_num").css("border","1px solid #fc8989");
        $("#fax_error").html("Please enter number");
        $("#fax_error").parent().css("display","block");
        errorFlag = true;
    }
	
    if(address_name == "" || address_name == "First and Last name"){
        $("#address_name").css("border","1px solid #fc8989");
        $("#address_name_error").html("Please enter address");
        $("#address_name_error").parent().css("display","block");
        errorFlag = true;
    }

if(errorFlag){	
        return false;
    }
    else{
        return true;
    }
  
}

function validateName(elementValue){
     var alphaExp = /^[a-zA-Z ]*$/;
    return alphaExp.test(elementValue);
}


function clear_payment_values(){
	
	$("#s_code").val('Enter your unique supplier code');
	$("#l_name").val('First and Last name');
	$("#t_code").val('Enter your tax code');
	$("#street_reg").val('Enter street address');
	$("#number_reg").val('Enter number');
	$("#select_city_reg").val('--Choose City--');
	$("#select_state_reg").val('--Choose State--');
	$("#z_code").val('Enter zip code');
	$("#bank_name").val('Name of bank');
	$("#w_transfer").val('Enter the ABA number');
	$("#c_house").val('Enter the ABA number');
	$("#acc_number").val('Enter your account number');
	$("#swift_code").val('Enter the swift code');
	$("#street_bank_code").val('Enter street address');
	$("#number_bank_code").val('Enter number');
	$("#select_state_bank_reg").val('--Choose City--');
	$("#select_city_bank_reg").val('--Choose State--');
	$("#bank_z_code").val('Enter zip code');
	$("#fax_num").val('Enter a fax number');
	$("#address_name").val('First and Last name');
	$("#reg_Statefield").html('--Choose State--');
	$("#reg_Cityfield").html('--Choose City--');
	$("#bank_Statefield").html('--Choose State--');
	$("#bank_Cityfield").html('--Choose City--');
	$("#dropDownDivBank2").html('');
	$("#dropDownDivBank4").html('');
	
	
	/*set color value while cancel*/	
	$("#select_city_reg").css("color","#999999");
	$("#select_state_reg").css("color","#999999");
	$("#reg_Statefield").css("color","#999999");
	$("#reg_Cityfield").css("color","#999999");
	$("#bank_Statefield").css("color","#999999");
	$("#bank_Cityfield").css("color","#999999");
	$("#s_code").css("color","#999999");
	$("#l_name").css("color","#999999");
	$("#t_code").css("color","#999999");
	$("#street_reg").css("color","#999999");
	$("#number_reg").css("color","#999999");
	$("#z_code").css("color","#999999");
	$("#bank_name").css("color","#999999");
	$("#w_transfer").css("color","#999999");
	$("#c_house").css("color","#999999");
	$("#acc_number").css("color","#999999");
	$("#swift_code").css("color","#999999");
	$("#street_bank_code").css("color","#999999");
	$("#number_bank_code").css("color","#999999");
	$("#bank_z_code").css("color","#999999");
	$("#fax_num").css("color","#999999");
	$("#address_name").css("color","#999999");
	
	$("#s_code").css("border","1px solid #BDD6DD");
	$("#l_name").css("border","1px solid #BDD6DD");
	$("#t_code").css("border","1px solid #BDD6DD");
	$("#street_reg").css("border","1px solid #BDD6DD");
	$("#number_reg").css("border","1px solid #BDD6DD");
    $("#select_city_reg").css("border","1px solid #BDD6DD");
	$("#z_code").css("border","1px solid #BDD6DD");
	$("#bank_name").css("border","1px solid #BDD6DD");
	$("#w_transfer").css("border","1px solid #BDD6DD");
	$("#c_house").css("border","1px solid #BDD6DD");
	$("#acc_number").css("border","1px solid #BDD6DD");
	$("#swift_code").css("border","1px solid #BDD6DD");
	$("#street_bank_code").css("border","1px solid #BDD6DD");
	$("#number_bank_code").css("border","1px solid #BDD6DD");
	$("#bank_z_code").css("border","1px solid #BDD6DD");
	$("#fax_num").css("border","1px solid #BDD6DD");
	$("#address_name").css("border","1px solid #BDD6DD");
	$(".selectBoxStateBankReg").css("border","none");
	$(".selectBoxCityBankReg").css("border","none");
	$(".selectBoxStateReg").css("border","none");
	$(".selectBoxCityReg").css("border","none");


	$("#s_code_error").html("");
	$("#legal_name_error").html("");
	$("#tax_code_error").html("");
	$("#street_error").html("");
	$("#number_error").html("");
	$("#city_error").html("");
	$("#state_error").html("");
	$("#zip_error").html("");
	$("#bank_name_error").html("");
	$("#wire_transfer_error").html("");
	$("#clear_house_error").html("");
	$("#acc_number_error").html("");
	$("#swift_code_error").html("");
	$("#street_bank_error").html("");
	$("#number_bank_error").html("");
	$("#city_bank_error").html("");
	$("#state_bank_error").html("");
	$("#bank_zip_error").html("");
	$("#fax_error").html("");
	$("#address_name_error").html("");
	
	$("#s_code_error").parent().css("display","none");
    $("#legal_name_error").parent().css("display","none")	
    $("#tax_code_error").parent().css("display","none");
    $("#city_error").parent().parent().css("display","none");
    $("#state_error").parent().parent().css("display","none");
    $("#zip_error").parent().css("display","none");
    $("#bank_name_error").parent().css("display","none");
    $("#wire_transfer_error").parent().css("display","none");
    $("#clear_house_error").parent().css("display","none");
    $("#acc_number_error").parent().css("display","none");
    $("#swift_code_error").parent().css("display","none");
    $("#street_bank_error").parent().css("display","none");
    $("#number_bank_error").parent().css("display","none");
	$("#street_bank_error").parent().parent().css("display","none");
	$("#number_bank_error").parent().parent().css("display","none");
    $("#city_bank_error").parent().parent().css("display","none");
    $("#state_bank_error").parent().parent().css("display","none");
    $("#bank_zip_error").parent().css("display","none");
    $("#fax_error").parent().css("display","none");
    $("#address_name_error").parent().css("display","none");
	
}
function cancelKeyDown(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        clear_payment_values();
    }
}
function signinKeyDown(e){
	//document.getElementById("dropDownDiv").style.display="none";
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==13 || KeyCode==32){
		ChekRegValidation();
    }
}
function selectBankStateUsrRegKeyDown(e){}
function selectBankCityUsrRegKeyDown(e){}
function selectStateBankUsrKeyDown(e){}
function selectCityBankUsrKeyDown(e){}
/**************pop up bid validation*****************/

	function bidamount_validate()
	{
		var error_flag=false;
		budget=$('#budget').val();
		bidamount=$('#bidamount').val();
		$('#budget').css('border','1px solid #CDE0E6');
		$('#bidamount').css('border','1px solid #CDE0E6');
		$('#error_budget').hide();
		$('#error_bidamount').hide();
		if($.trim(budget)=="" && $.trim(bidamount)=="")
		{
			$('#error_budget').show();
			$('#error_budget').html('Enter the budget amount');
			$('#error_bidamount').show();
			$('#error_bidamount').html('Enter the bid amount per click');
			$('#budget').css('border','1px solid #FC8989');
			$('#bidamount').css('border','1px solid #FC8989');
			error_flag=true;
			return false;
		}
		else
		{
			$('#error_budget').hide();
			$('#error_bidamount').hide();
			if($.trim(budget)=="")
			{
				$('#error_budget').show();
				$('#error_budget').html('Enter the budget amount');
				$('#budget').css('border','1px solid #FC8989');
				error_flag=true;
				$('#budget').focus();
				return false
			}

			if($.trim(bidamount)=="")
			{
				error_flag=true;
				$('#error_bidamount').show();
				$('#error_bidamount').html('Enter the bid amount per click');
				$('#bidamount').css('border','1px solid #FC8989');
				error_flag=true;
				$('#bidamount').focus();
				return false;
			}

		}
		
		if(!error_flag)
		{
			('#budget').css('border','');
			$('#bidamount').css('border','');
			return false;
		}
	}
	function clear_frmfield()
	{
		$('#budget').val('');
		$('#bidamount').val('');
		$('#error_budget').hide();
		$('#error_bidamount').hide();
		$('#error_budget').html('');
		$('#error_bidamount').html('');
		$('#budget').css('border','1px solid #BDD6DD');
		$('#bidamount').css('border','1px solid #BDD6DD');
	}
