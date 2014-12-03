$(document).ready(function(){
    //initARC('r_form','altRadioOn','altRadioOff','altCheckboxOn','altCheckboxOff');
    //dropDown_new();

    //dropDown_repeat();
	dispYear(1);
	//dispProfileYear(1);
	//alert("ready");
	//sell_pay_dispYear(1);



});
$('body').click(function(){
    //dropDown_new();
    //dropDown_repeat();

});


//set year for payment dropdowm

function dispYear(value){
    var y='';
    var i=0;
    var curTime=new Date();
    var year = curTime.getFullYear();
	//alert(year);
    var cyear = parseInt(year);
	var eyear=parseInt(year)+10;
    for(i=cyear;i<eyear;i++){
        y+='<a href="#" onclick="setYearValPay('+i+','+value+')" title="">'+i+'</a>';
    }
    $(".dropDownDiv_small_"+value).html(y);
}

function setYearValPay(yvalue,value){
    $('#year_card_'+value).val(yvalue);
    $('#field2_'+value).html(yvalue);
	$('#field2_'+value).css("color","#444444");
}

/*// register sell payment 

function dispProfileYear(value){
    var y='';
    var i=0;
    var curTime=new Date();
    var year = curTime.getFullYear();
    var cyear = parseInt(year);
	var eyear=parseInt(year)+10;
    for(i=cyear;i<eyear;i++){
        y+='<a href="#" onclick="setProfileYearVal('+i+','+value+')" title="">'+i+'</a>';
    }
    $("#yearDisp_profile_"+value).html(y);
}
function setProfileYearVal(yvalue,value){
    $('#year_card_'+value).val(yvalue);
    $('#field2_'+value).html(yvalue);
	$('#field2_'+value).css('color','#444444');
	//$("#EditdropDownDiv3").css("display","none");
	
}
*/



function focusChangeBorderColor(id){

    switch(id){
		
        case "CardholderFirstName":
            if($('#'+id).val()== "Enter Cardholder First Name" ){
                $('#'+id).val('');
            }
            break;
			
        case "CardholderLastName":
            if($('#'+id).val()== "Enter Cardholder Last Name" ){
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
	case "chkout_city": 
            if($('#'+id).val() == "Enter City" ){
                $('#'+id).val('');
            }
            break;

        case "zip_code_chkout":
            if($('#'+id).val() == "Enter zip code" ){
                $('#'+id).val('');
            }
            break;
        case "phone_no":
            if($('#'+id).val() == "Enter your phone number" ){
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
		
        case "CardholderFirstName":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Cardholder First Name");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
			
        case "CardholderLastName":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Cardholder Last Name");
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
                $('#'+id).val("Enter zip code");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
	
	case "chkout_city":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter City");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
	    
        case "phone_no":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter your phone number");
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
    document.getElementById("payment_method").value=val;
    document.getElementById("field1").innerHTML=val;	
    $("#field").css("color","#444444");
    document.getElementById("dropDownDiv6").style.display="none";
    
   /* if(val == "Credit Card Account"){
        document.getElementById("card_payment").style.display="block";
        document.getElementById("paypal").style.display="none";


    }
   else if(val == "PayPal"){
       // alert("by");
        document.getElementById("paypal").style.display="block";
        document.getElementById("card_payment").style.display="none";
        $("#payment_method_error").html("");
        $("#selectpayment").css("border","none");
		
    }
*/}



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

/********************registerSponsor*********************/

dropDownDivSpo3 = '';
function setStateSponsorValue(val){
    document.getElementById("chkout_state").value=val;
    document.getElementById("field5").innerHTML=val;
    $(".ProviderCenterContent .selectBoxCountryBankReg").css("border","none");
   // document.getElementById("dropDownDivSpo5").style.display="none";
    $("#state_error_spo").html("");
    dropDownDivSpo3= '';
    switch(val){
		
        case "Alabama":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Birmingham\')" title="">Birmingham</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Huntsville\')" title="">Huntsville</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Montgomery\')" title="">Montgomery</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Mobile\')" title="">Mobile</a>';
            
            break;
			
        case "Alaska":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Anchorage\')" title="">Anchorage</a>';
            break;
	    
        case "Arizona":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Chandler\')" title="">Chandler</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Glendale\')" title="">Glendale</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Gilbert\')" title="">Gilbert</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Mesa\')" title="">Mesa</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Peoria\')" title="">Peoria</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Phoenix\')" title="">Phoenix</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Scottsdale\')" title="">Scottsdale</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Surprise\')" title="">Surprise</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Tempe\')" title="">Tempe</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Tucson\')" title="">Tucson</a>';
            break;
		   
        case "Arkansas":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Little Rock\')" title="">Little Rock</a>';
            break;

        case "California":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Anaheim\')" title="">Anaheim</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Antioch\')" title="">Antioch</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Bakersfield\')" title="">Bakersfield</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Berkeley\')" title="">Berkeley</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Burbank\')" title="">Burbank</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Carlsbad\')" title="">Carlsbad</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Chula Vista\')" title="">Chula Vista</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Concord\')" title="">Concord</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Corona\')" title="">Corona</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Costa Mesa\')" title="">Costa Mesa</a>';
			dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Danville\')" title="">Danville</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Daly City\')" title="">Daly City</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Downey\')" title="">Downey</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'El Monte\')" title="">El Monte</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Elk Grove\')" title="">Elk Grove</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Escondido\')" title="">Escondido</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Fairfield\')" title="">Fairfield</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Fontana\')" title="">Fontana</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Fremont\')" title="">Fremont</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Fresno\')" title="">Fresno</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Fullerton\')" title="">Fullerton</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Garden Grove\')" title="">Garden Grove</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Glendale\')" title="">Glendale</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Hayward\')" title="">Hayward</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Huntington Beach\')" title="">Huntington Beach</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Inglewood\')" title="">Inglewood</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Irvine\')" title="">Irvine</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Lancaster\')" title="">Lancaster</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Los Angeles\')" title="">Los Angeles</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Long Beach\')" title="">Long Beach</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Modesto\')" title="">Modesto</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Moreno Valley\')" title="">Moreno Valley</a>';
			dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Moraga\')" title="">Moraga</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Murrieta\')" title="">Murrieta</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Norwalk\')" title="">Norwalk</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Oakland\')" title="">Oakland</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Oceanside\')" title="">Oceanside</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Ontario\')" title="">Ontario</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Orange\')" title="">Orange</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Oxnard\')" title="">Oxnard</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Palmdale\')" title="">Palmdale</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Pasadena\')" title="">Pasadena</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Pomona\')" title="">Pomona</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Rancho Cucamonga\')" title="">Rancho Cucamonga</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Richmond\')" title="">Richmond</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Riverside\')" title="">Riverside</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'San Bernardino\')" title="">San Bernardino</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'San Diego\')" title="">San Diego</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'San Francisco\')" title="">San Francisco</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Sacramento\')" title="">Sacramento</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Santa Ana\')" title="">Santa Ana</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Santa Clarita\')" title="">Santa Clarita</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Santa Rosa\')" title="">Santa Rosa</a>';
			dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'San Ramon\')" title="">San Ramon</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Salinas\')" title="">Salinas</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Santa Clara\')" title="">Santa Clara</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'San Jose\')" title="">San Jose</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Simi Valley\')" title="">Simi Valley</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Stockton\')" title="">Stockton</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Sunnyvale\')" title="">Sunnyvale</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Temecula\')" title="">Temecula</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Thousand Oaks\')" title="">Thousand Oaks</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Torrance\')" title="">Torrance</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Vallejo\')" title="">Vallejo</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Ventura\')" title="">Ventura</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Visalia\')" title="">Visalia</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Victorville\')" title="">Victorville</a>';
			dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Walnut Creek\')" title="">Walnut Creek</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'West Covina\')" title="">West Covina</a>';
			
            break;
		   
        case "Colorado":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Arvada\')" title="">Arvada</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Aurora\')" title="">Aurora</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Centennial\')" title="">Centennial</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Colorado Springs\')" title="">Colorado Springs</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Denver\')" title="">Denver</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Fort Collins\')" title="">Fort Collins</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Lakewood\')" title="">Lakewood</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Pueblo\')" title="">Pueblo</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Thornton\')" title="">Thornton</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Westminster\')" title="">Westminster</a>';
            break;
		
        case "Connecticut":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Bridgeport\')" title="">Bridgeport</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Hartford\')" title="">Hartford</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'New Haven\')" title="">New Haven</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Stamford\')" title="">Stamford</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Waterbury\')" title="">Waterbury</a>';
            break;
		
        case "District of Columbia":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Washington\')" title="">Washington</a>';

            break;
		
        case "Florida":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Cape Coral\')" title="">Cape Coral</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Clearwater\')" title="">Clearwater</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Coral Springs\')" title="">Coral Springs</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Colorado Springs\')" title="">Colorado Springs</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Fort Lauderdale\')" title="">Fort Lauderdale</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Gainesville\')" title="">Gainesville</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Hialeah\')" title="">Hialeah</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Hollywood\')" title="">Hollywood</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Miami Gardens\')" title="">Miami Gardens</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Miramar\')" title="">Miramar</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Orlando\')" title="">Orlando</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Palm Bay\')" title="">Palm Bay</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Pembroke Pines\')" title="">Pembroke Pines</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Port St. Lucie\')" title="">Port St. Lucie</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'St. Petersburg\')" title="">St. Petersburg</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Tallahassee\')" title="">Tallahassee</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Tampa\')" title="">Tampa</a>';

            break;
		
        case "Georgia":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Atlanta\')" title="">Atlanta</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Athens\')" title="">Athens</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Augusta \')" title="">Augusta</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Columbus\')" title="">Columbus</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Savannah\')" title="">Savannah</a>';
            break;
		
        case "Hawaii":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Honolulu\')" title="">Honolulu</a>';
            break;
		
        case "Idaho":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Boise\')" title="">Boise</a>';
            break;
		
        case "Illinois":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Aurora\')" title="">Aurora</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Chicago\')" title="">Chicago</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Elgin \')" title="">Elgin</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Joliet\')" title="">Joliet</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Naperville\')" title="">Naperville</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Peoria \')" title="">Peoria</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Rockford\')" title="">Rockford</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Springfield\')" title="">Springfield</a>';
            break;
		
        case "Indiana":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Evansville\')" title="">Evansville</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Indianapolis\')" title="">Indianapolis</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Fort Wayne \')" title="">Fort Wayne</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'South Bend\')" title="">South Bend</a>';
            break;

        case "Iowa":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Cedar Rapids\')" title="">Cedar Rapids</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Des Moines\')" title="">Des Moines</a>';
            break;

        case "Kansas":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Olathe\')" title="">Olathe</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Overland Park\')" title="">Overland Park</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Kansas City \')" title="">Kansas City</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Topeka\')" title="">Topekad</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Wichita\')" title="">Wichita</a>';
            break;


        case "Kentucky":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Lexington\')" title="">Lexington</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Louisville\')" title="">Louisville</a>';
            break;


        case "Louisiana":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Baton Rouge\')" title="">Baton Rouge</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Lafayette\')" title="">Lafayette</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'New Orleans \')" title="">New Orleans</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Shreveport\')" title="">Shreveport</a>';
            break;


        case "Maryland":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Baltimore\')" title="">Baltimore</a>';
            break;


        case "Massachusetts":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Boston\')" title="">Boston</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Cambridge\')" title="">Cambridge</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Lowell \')" title="">Lowell</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Springfield\')" title="">Springfield</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Worcester\')" title="">Worcester</a>';
            break;
		
        case "Michigan":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Ann Arbor\')" title="">Ann Arbor</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Detroit\')" title="">Detroit</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Flint \')" title="">Flint</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Grand Rapids\')" title="">Grand Rapids</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Lansing\')" title="">Lansing</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Sterling Heights\')" title="">Sterling Heights</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Warren\')" title="">Warren</a>';
            break;

        case "Massachusetts":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Boston\')" title="">Boston</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Cambridge\')" title="">Cambridge</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Lowell \')" title="">Lowell</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Springfield\')" title="">Springfield</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Worcester\')" title="">Worcester</a>';
            break;

        case "Minnesota":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Minneapolis\')" title="">Minneapolis</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Rochester\')" title="">Rochester</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'St. Paul \')" title="">St. Paul</a>';
            break;

        case "Mississippi":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Jackson\')" title="">Jackson</a>';
            break;

        case "Missouri":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Columbia\')" title="">Columbia</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Independence\')" title="">Independence</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Kansas City \')" title="">Kansas City</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Springfield\')" title="">Springfield</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'St. Louis\')" title="">St. Louis</a>';
            break;

        case "Montana":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Billings\')" title="">Billings</a>';
            break;

        case "Nebraska":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Lincoln\')" title="">Lincoln</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Omaha\')" title="">Omaha</a>';
            break;
		
        case "Nevada":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Henderson\')" title="">Henderson</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Las Vegas\')" title="">Las Vegas</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'North Las Vegas \')" title="">North Las Vegas</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Reno\')" title="">Reno</a>';
            break;

        case "New Hampshire":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Manchester\')" title="">Manchester</a>';
            break;
		
        case "New Jersey":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Elizabeth\')" title="">Elizabeth</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Jersey City\')" title="">Jersey City</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Newark\')" title="">Newark</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Paterson\')" title="">Paterson</a>';
            break;

        case "New Mexico":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Albuquerque\')" title="">Albuquerque</a>';
            break;

        case "New York":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Buffalo\')" title="">Buffalo</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'New York\')" title="">New York</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Rochester\')" title="">Rochester</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Syracuse\')" title="">Syracuse</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Yonkers\')" title="">Yonkers</a>';
            break;

        case "North Carolina":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Cary\')" title="">Cary</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Charlotte\')" title="">Charlotte</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Durham\')" title="">Durham</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Fayetteville\')" title="">Fayetteville</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Greensboro\')" title="">Greensboro</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'High Point\')" title="">High Point</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Raleigh\')" title="">Raleigh</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Wilmington\')" title="">Wilmington</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Winston-Salem\')" title="">Winston-Salem</a>';
            break;

        case "North Dakota":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Fargo\')" title="">Fargo</a>';
            break;

        case "Ohio":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Akron\')" title="">Akron</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Cincinnati\')" title="">Cincinnati</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Cleveland\')" title="">Cleveland</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Columbus\')" title="">Columbus</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Dayton\')" title="">Dayton</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Toledo\')" title="">Toledo</a>';
            break;
        case "Oklahoma":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Norman\')" title="">Norman</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Oklahoma City\')" title="">Oklahoma City</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Tulsa\')" title="">Tulsa</a>';
            break;
        case "Oregon":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Eugene\')" title="">Eugene</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Gresham\')" title="">Gresham</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Portland\')" title="">Portland</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Salem\')" title="">Salem</a>';
            break;
		
        case "Pennsylvania":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Allentown\')" title="">Allentown</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Erie\')" title="">Erie</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Philadelphia\')" title="">Philadelphia</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Pittsburgh\')" title="">Pittsburgh</a>';
            break;

        case "Rhode Island":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Providence\')" title="">Providence</a>';
            break;
        case "South Carolina":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Charleston\')" title="">Charleston</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Columbia\')" title="">Columbia</a>';

            break;
        case "South Dakota":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Sioux Falls\')" title="">Sioux Falls</a>';
            break;
        case "Tennessee":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Chattanooga\')" title="">Chattanooga</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Clarksville\')" title="">Clarksville</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Knoxville\')" title="">Knoxville</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Memphis\')" title="">Memphis</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Murfreesboro\')" title="">Murfreesboro</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Nashville\')" title="">Nashville</a>';
            break;
		
        case "Texas":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Abilene\')" title="">Abilene</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Amarillo\')" title="">Amarillo</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Arlington\')" title="">Arlington</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Austin\')" title="">Austin</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Beaumont\')" title="">Beaumont</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Brownsville\')" title="">Brownsville</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Carrollton\')" title="">Carrollton</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Corpus Christi\')" title="">Corpus Christi</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Dallas\')" title="">Dallas</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Denton\')" title="">Denton</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'El Paso\')" title="">El Paso</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Fort Worth\')" title="">Fort Worth</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Frisco\')" title="">Frisco</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Garland\')" title="">Garland</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Grand Prairie\')" title="">Grand Prairie</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Houston\')" title="">Houston</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Irving\')" title="">Irving</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Killeen\')" title="">Killeen</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Laredo\')" title="">Laredo</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Lubbock\')" title="">Lubbock</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Mesquite\')" title="">Mesquite</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'McAllen\')" title="">McAllen</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'McKinney\')" title="">McKinney</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Midland\')" title="">Midland</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Pasadena\')" title="">Pasadena</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Plano\')" title="">Plano</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'San Antonio\')" title="">San Antonio</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Waco\')" title="">Waco</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Wichita Falls\')" title="">Wichita Falls</a>';
            break;

        case "Utah":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Provo\')" title="">Provo</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Salt Lake City\')" title="">Salt Lake City</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'West Jordan\')" title="">West Jordan</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'West Valley City\')" title="">West Valley City</a>';
            break;

        case "Virginia":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Alexandria\')" title="">Alexandria</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Arlington\')" title="">Arlington</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Chesapeake\')" title="">Chesapeake</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Hampton\')" title="">Hampton</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Newport News\')" title="">Newport News </a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Norfolk\')" title="">Norfolk</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Richmond\')" title="">Richmond</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Virginia Beach\')" title="">Virginia Beach</a>';
            break;

        case "Washington":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Bellevue\')" title="">Bellevue</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Everett\')" title="">Everett</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Tacoma\')" title="">Tacoma</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Seattle\')" title="">Seattle</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Spokane\')" title="">Spokane</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Vancouver\')" title="">Vancouver</a>';
            break;
		

        case "Wisconsin":
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Green Bay\')" title="">Green Bay</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Madison\')" title="">Madison</a>';
            dropDownDivSpo3 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo3(\'Milwaukee\')" title="">Milwaukee</a>';
            break;


    }
    //document.getElementById("dropDownDivSpo3").innerHTML=dropDownDivSpo3;
    //document.getElementById("chkout_city").value="--Choose City--";
    //document.getElementById("field3").innerHTML="--Choose City--";
}

dropDownDivSpo5 = '';
function setCountrySponsorValue(val){
    document.getElementById("chkout_country").value=val;
    document.getElementById("field4").innerHTML=val;
	$("#field4").css("color","#444444");
    $(".ProviderCenterContent .selectBoxCountryBankReg").css("border","none");
    //document.getElementById("dropDownDivSpo4").style.display="none";
    $("#country_error").html("");
    dropDownDivSpo5= '';
    switch(val){
        case "United States":
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Alabama\')" title="">Alabama</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Alaska\')" title="">Alaska</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Arizona\')" title="">Arizona</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Arkansas\')" title="">Arkansas</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'California\')" title="">California</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Colorado\')" title="">Colorado</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Connecticut\')" title="">Connecticut</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'District of Columbia\')" title="">District of Columbia</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Florida\')" title="">Florida</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Georgia\')" title="">Georgia</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Hawaii\')" title="">Hawaii</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Idaho\')" title="">Idaho</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Illinois\')" title="">Illinois</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Indiana\')" title="">Indiana</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Iowa\')" title="">Iowa</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Kansas\')" title="">Kansas</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Kentucky\')" title="">Kentucky</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Louisiana\')" title="">Louisiana</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Maryland\')" title="">Maryland</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Massachusetts\')" title="">Massachusetts</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Michigan\')" title="">Michigan</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Minnesota\')" title="">Minnesota</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Mississippi\')" title="">Mississippi</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Missouri\')" title="">Missouri</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Montana\')" title="">Montana</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Nebraska\')" title="">Nebraska</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Nevada\')" title="">Nevada</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'New Hampshire\')" title="">New Hampshire</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'New Jersey\')" title="">New Jersey</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'New Mexico\')" title="">New Mexico</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'New York\')" title="">New York</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'North Carolina\')" title="">North Carolina</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'North Dakota\')" title="">North Dakota</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Ohio\')" title="">Ohio</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Oklahoma\')" title="">Oklahoma</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Oregon\')" title="">Oregon</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Pennsylvania\')" title="">Pennsylvania</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Rhode Island\')" title="">Rhode Island</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'South Carolina\')" title="">South Carolina</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'South Dakota\')" title="">South Dakota</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Tennessee\')" title="">Tennessee</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Texas\')" title="">Texas</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Utah\')" title="">Utah</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Virginia\')" title="">Virginia</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Washington\')" title="">Washington</a>';
            dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Wisconsin\')" title="">Wisconsin</a>';
            
            break;
			
    /*        case "India":
			dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Birmingham\')" title="">Birmingham</a>';
			dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Huntsville\')" title="">Huntsville</a>';
			dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Montgomery\')" title="">Montgomery</a>';
			dropDownDivSpo5 += '<a href="javascript:void(0)" onclick="setDropDownValueSpo5(\'Mobile\')" title="">Mobile</a>';
            
            break;
*/	}
    //document.getElementById("dropDownDivSpo5").innerHTML=dropDownDivSpo5;
    //document.getElementById("chkout_state").value="--Choose State--";
    //document.getElementById("field5").innerHTML="--Choose State--";
}
function setDropDownValueSpo3(val){
    document.getElementById("chkout_city").value=val;
    document.getElementById("field3").innerHTML=val;
	$("#field3").css("color","#444444");
    document.getElementById("dropDownDivSpo3").style.display="none";
    $(".selectBoxCityBankReg").css("border","none");
    $("#city_error_spo").html("");
}

function setDropDownValueSpo4(val){
    document.getElementById("chkout_country").value=val;
    document.getElementById("field4").innerHTML=val;
	$("#field4").css("color","#444444");
    document.getElementById("dropDownDivSpo4").style.display="none";
    $(".selectBoxCityBankReg").css("border","none");
    $("#country_error").html("");
}

function setDropDownValueSpo5(val){
    document.getElementById("chkout_state").value=val;
    document.getElementById("field5").innerHTML=val;
	$("#field5").css("color","#444444");
    document.getElementById("dropDownDivSpo5").style.display="none";
    $(".selectBoxCityBankReg").css("border","none");
    $("#state_error").html("");
	
    setStateSponsorValue(val);
	
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
