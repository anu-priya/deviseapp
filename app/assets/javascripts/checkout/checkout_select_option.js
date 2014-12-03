//$(document).ready(function(){
//	dropDown_payment();
//
//});
//
//
//$('body').click(function(){
//    dropDown_payment();
//});
//var flag1=false;
//var flag2=false;
//var flag3=false;
//var flag4=false;
//var flag5=false;
//var flag6=false;
//var flag7=false;
//
//var trig1=true;
//var trig2=true;
//var trig3=true;
//var trig4=true;
//var trig5=true;
//var trig6=true;
//var trig7=true;
//
//function dropDown_payment(){
//   // alert("drop");
//     if(flag1){ 
//        if(trig1){
//
//            if(document.getElementById("dropDownDiv1").innerHTML!=''){
//                document.getElementById("dropDownDiv1").style.display="block";
//                document.getElementById("dropDownDiv2").style.display="none";
//               document.getElementById("dropDownDiv3").style.display="none";
//                document.getElementById("dropDownDiv4").style.display="none";
//                document.getElementById("dropDownDiv5").style.display="none";
//                document.getElementById("dropDownDiv6").style.display="none";
//		document.getElementById("dropDownDiv7").style.display="none";
//            }
//            trig1=false;           
//        }
//        else{
//            document.getElementById("dropDownDiv1").style.display="none";
//            trig1=true;
//        }
//    }    
//    else if(flag2){ 
//        if(trig2){
//
//            if(document.getElementById("dropDownDiv2").innerHTML!=''){
//                document.getElementById("dropDownDiv2").style.display="block";
//                document.getElementById("dropDownDiv1").style.display="none";
//                document.getElementById("dropDownDiv3").style.display="none";
//                document.getElementById("dropDownDiv4").style.display="none";
//                document.getElementById("dropDownDiv5").style.display="none";
//                document.getElementById("dropDownDiv6").style.display="none";
//		    document.getElementById("dropDownDiv7").style.display="none";
//            }
//            trig2=false;           
//        }
//        else{
//            document.getElementById("dropDownDiv2").style.display="none";
//            trig2=true;
//        }
//    }   
//    else if(flag3){ 
//        if(trig3){
//            if(document.getElementById("dropDownDiv3").innerHTML!=''){
//                document.getElementById("dropDownDiv3").style.display="block";
//                document.getElementById("dropDownDiv1").style.display="none";
//                document.getElementById("dropDownDiv2").style.display="none";
//                document.getElementById("dropDownDiv4").style.display="none";
//                document.getElementById("dropDownDiv5").style.display="none";
//                document.getElementById("dropDownDiv6").style.display="none";
//		    document.getElementById("dropDownDiv7").style.display="none";
//            }
//            trig3=false;           
//        }
//        else{
//            document.getElementById("dropDownDiv3").style.display="none";
//            trig3=true;
//        }
//    }
//    else if(flag4){
//        if(trig4){
//            if(document.getElementById("dropDownDiv4").innerHTML!=''){
//                document.getElementById("dropDownDiv4").style.display="block";
//                document.getElementById("dropDownDiv1").style.display="none";
//                document.getElementById("dropDownDiv2").style.display="none";
//                document.getElementById("dropDownDiv3").style.display="none";
//                document.getElementById("dropDownDiv5").style.display="none";
//                document.getElementById("dropDownDiv6").style.display="none";
//		document.getElementById("dropDownDiv7").style.display="none";
//            }
//            trig4=false;           
//        }
//        else{
//            document.getElementById("dropDownDiv4").style.display="none";
//            trig4=true;
//        }
//    }
//    else if(flag5){
//        if(trig5){
//            if(document.getElementById("dropDownDiv5").innerHTML!=''){
//                document.getElementById("dropDownDiv5").style.display="block";                
//                document.getElementById("dropDownDiv1").style.display="none";
//                document.getElementById("dropDownDiv2").style.display="none";
//                document.getElementById("dropDownDiv3").style.display="none";
//                document.getElementById("dropDownDiv4").style.display="none";
//                document.getElementById("dropDownDiv6").style.display="none";
//		document.getElementById("dropDownDiv7").style.display="none";
//            }
//            trig5=false;
//        }
//        else{
//            document.getElementById("dropDownDiv5").style.display="none";
//            trig5=true;
//        }
//    }
//
//
//    else if(flag6){
//        if(trig6){
//            if(document.getElementById("dropDownDiv6").innerHTML!=''){
//                document.getElementById("dropDownDiv6").style.display="block";                
//                document.getElementById("dropDownDiv1").style.display="none";
//                document.getElementById("dropDownDiv2").style.display="none";
//                document.getElementById("dropDownDiv3").style.display="none";
//                document.getElementById("dropDownDiv4").style.display="none";
//                document.getElementById("dropDownDiv5").style.display="none";
//		document.getElementById("dropDownDiv7").style.display="none";
//            }
//            trig6=false;
//        }
//        else{
//            document.getElementById("dropDownDiv6").style.display="none";
//            trig6=true;
//        }
//    }
//     else if(flag7){
//        if(trig7){
//            if(document.getElementById("dropDownDiv7").innerHTML!=''){
//                document.getElementById("dropDownDiv7").style.display="block";               
//                document.getElementById("dropDownDiv1").style.display="none";
//                document.getElementById("dropDownDiv2").style.display="none";
//                document.getElementById("dropDownDiv3").style.display="none";
//                document.getElementById("dropDownDiv4").style.display="none";
//                document.getElementById("dropDownDiv5").style.display="none";
//		document.getElementById("dropDownDiv6").style.display="none";
//            }
//            trig7=false;
//        }
//        else{
//            document.getElementById("dropDownDiv7").style.display="none";
//            trig7=true;
//        }
//    }
//
//	
//    else{
//        document.getElementById("dropDownDiv1").style.display="none";
//        trig1=true;
//        document.getElementById("dropDownDiv2").style.display="none";
//        trig2=true;
//        document.getElementById("dropDownDiv3").style.display="none";
//        trig3=true;
//        document.getElementById("dropDownDiv4").style.display="none";
//        trig4=true;
//        document.getElementById("dropDownDiv5").style.display="none";
//        trig5=true;
//        document.getElementById("dropDownDiv6").style.display="none";
//        trig6=true;
//	document.getElementById("dropDownDiv7").style.display="none";
//        trig7=true;
//    }
//    
//}
//function setDropDownValue(val){   
//    document.getElementById("payment_method").value=val;
//    document.getElementById("field1").innerHTML=val;	
//    $("#field1").css("color","#444444");
//    document.getElementById("dropDownDiv6").style.display="none";
//    
//   /* if(val == "Credit Card Account"){
//        document.getElementById("card_payment").style.display="block";
//        document.getElementById("paypal").style.display="none";
//
//
//    }
//   else if(val == "PayPal"){
//       // alert("by");
//        document.getElementById("paypal").style.display="block";
//        document.getElementById("card_payment").style.display="none";
//        $("#payment_method_error").html("");
//        $("#selectpayment").css("border","none");
//		
//    }
//*/}


//function setDropDownValue1(val){	
//    document.getElementById("sub_category").value=val;
//    document.getElementById("field1").innerHTML=val;
//	$("#field1").css("color","#444444");
//    document.getElementById("dropDownDiv1").style.display="none";
//}
//function setDropDownValue2(val){
//    document.getElementById("billing_type").value=val;
//    document.getElementById("field2").innerHTML=val;
//	$("#field2").css("color","#444444");
//    document.getElementById("dropDownDiv2").style.display="none";
//}


//
//
//dropDownDiv5 = '';
//function setCountryPaymentValue(val){
//    document.getElementById("chkout_country").value=val;
//    document.getElementById("field4").innerHTML=val;
//	$("#field4").css("color","#444444");
//    $(".ProviderCenterContent .selectBoxCountryBankReg").css("border","none");
//    document.getElementById("dropDownDiv4").style.display="none";
//    $("#country_error").html("");
//    dropDownDiv5= '';
//    switch(val){
//        case "United States":
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Alabama\')" title="">Alabama</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Alaska\')" title="">Alaska</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Arizona\')" title="">Arizona</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Arkansas\')" title="">Arkansas</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'California\')" title="">California</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Colorado\')" title="">Colorado</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Connecticut\')" title="">Connecticut</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'District of Columbia\')" title="">District of Columbia</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Florida\')" title="">Florida</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Georgia\')" title="">Georgia</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Hawaii\')" title="">Hawaii</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Idaho\')" title="">Idaho</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Illinois\')" title="">Illinois</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Indiana\')" title="">Indiana</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Iowa\')" title="">Iowa</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Kansas\')" title="">Kansas</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Kentucky\')" title="">Kentucky</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Louisiana\')" title="">Louisiana</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Maryland\')" title="">Maryland</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Massachusetts\')" title="">Massachusetts</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Michigan\')" title="">Michigan</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Minnesota\')" title="">Minnesota</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Mississippi\')" title="">Mississippi</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Missouri\')" title="">Missouri</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Montana\')" title="">Montana</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Nebraska\')" title="">Nebraska</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Nevada\')" title="">Nevada</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'New Hampshire\')" title="">New Hampshire</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'New Jersey\')" title="">New Jersey</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'New Mexico\')" title="">New Mexico</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'New York\')" title="">New York</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'North Carolina\')" title="">North Carolina</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'North Dakota\')" title="">North Dakota</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Ohio\')" title="">Ohio</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Oklahoma\')" title="">Oklahoma</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Oregon\')" title="">Oregon</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Pennsylvania\')" title="">Pennsylvania</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Rhode Island\')" title="">Rhode Island</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'South Carolina\')" title="">South Carolina</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'South Dakota\')" title="">South Dakota</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Tennessee\')" title="">Tennessee</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Texas\')" title="">Texas</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Utah\')" title="">Utah</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Virginia\')" title="">Virginia</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Washington\')" title="">Washington</a>';
//            dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Wisconsin\')" title="">Wisconsin</a>';
//            
//            break;
//			
//    /*        case "India":
//			dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Birmingham\')" title="">Birmingham</a>';
//			dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Huntsville\')" title="">Huntsville</a>';
//			dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Montgomery\')" title="">Montgomery</a>';
//			dropDownDiv5 += '<a href="javascript:void(0)" onclick="setDropDownValue5(\'Mobile\')" title="">Mobile</a>';
//            
//            break;
//*/	}
//    document.getElementById("dropDownDiv5").innerHTML=dropDownDiv5;
//    document.getElementById("chkout_state").value="--Choose State--";
//    document.getElementById("field5").innerHTML="--Choose State--";
//}


function setDropDownValue3(val){
    document.getElementById("chkout_city").value=val;
    document.getElementById("field3").innerHTML=val;
    document.getElementById("dropDownDiv3").style.display="none";
    $(".selectBoxCityBankReg").css("border","none");
    $("#city_error").html("");
}

dropDownDiv3 = '';
function setStatePaymentValue(val){
    document.getElementById("chkout_state").value=val;
    document.getElementById("field5").innerHTML=val;
	$("#field5").css("color","#444444");
    $(".ProviderCenterContent .selectBoxCountryBankReg").css("border","none");
    document.getElementById("dropDownDiv5").style.display="none";
    $("#state_error").html("");
    dropDownDiv3= '';
    switch(val){
		
        case "Alabama":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Birmingham\')" title="">Birmingham</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Huntsville\')" title="">Huntsville</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Montgomery\')" title="">Montgomery</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Mobile\')" title="">Mobile</a>';
            
            break;
			
        case "Alaska":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Anchorage\')" title="">Anchorage</a>';
            break;
	    
        case "Arizona":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Chandler\')" title="">Chandler</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Glendale\')" title="">Glendale</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Gilbert\')" title="">Gilbert</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Mesa\')" title="">Mesa</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Peoria\')" title="">Peoria</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Phoenix\')" title="">Phoenix</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Scottsdale\')" title="">Scottsdale</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Surprise\')" title="">Surprise</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Tempe\')" title="">Tempe</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Tucson\')" title="">Tucson</a>';
            break;
		   
        case "Arkansas":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Little Rock\')" title="">Little Rock</a>';
            break;

        case "California":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Anaheim\')" title="">Anaheim</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Antioch\')" title="">Antioch</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Bakersfield\')" title="">Bakersfield</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Berkeley\')" title="">Berkeley</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Burbank\')" title="">Burbank</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Carlsbad\')" title="">Carlsbad</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Chula Vista\')" title="">Chula Vista</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Concord\')" title="">Concord</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Corona\')" title="">Corona</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Costa Mesa\')" title="">Costa Mesa</a>';
			dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Danville\')" title="">Danville</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Daly City\')" title="">Daly City</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Downey\')" title="">Downey</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'El Monte\')" title="">El Monte</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Elk Grove\')" title="">Elk Grove</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Escondido\')" title="">Escondido</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Fairfield\')" title="">Fairfield</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Fontana\')" title="">Fontana</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Fremont\')" title="">Fremont</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Fresno\')" title="">Fresno</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Fullerton\')" title="">Fullerton</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Garden Grove\')" title="">Garden Grove</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Glendale\')" title="">Glendale</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Hayward\')" title="">Hayward</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Huntington Beach\')" title="">Huntington Beach</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Inglewood\')" title="">Inglewood</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Irvine\')" title="">Irvine</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Lancaster\')" title="">Lancaster</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Los Angeles\')" title="">Los Angeles</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Long Beach\')" title="">Long Beach</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Modesto\')" title="">Modesto</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Moreno Valley\')" title="">Moreno Valley</a>';
			dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Moraga\')" title="">Moraga</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Murrieta\')" title="">Murrieta</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Norwalk\')" title="">Norwalk</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Oakland\')" title="">Oakland</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Oceanside\')" title="">Oceanside</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Ontario\')" title="">Ontario</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Orange\')" title="">Orange</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Oxnard\')" title="">Oxnard</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Palmdale\')" title="">Palmdale</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Pasadena\')" title="">Pasadena</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Pomona\')" title="">Pomona</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Rancho Cucamonga\')" title="">Rancho Cucamonga</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Richmond\')" title="">Richmond</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Riverside\')" title="">Riverside</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'San Bernardino\')" title="">San Bernardino</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'San Diego\')" title="">San Diego</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'San Francisco\')" title="">San Francisco</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Sacramento\')" title="">Sacramento</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Santa Ana\')" title="">Santa Ana</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Santa Clarita\')" title="">Santa Clarita</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Santa Rosa\')" title="">Santa Rosa</a>';
			dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'San Ramon\')" title="">San Ramon</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Salinas\')" title="">Salinas</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Santa Clara\')" title="">Santa Clara</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'San Jose\')" title="">San Jose</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Simi Valley\')" title="">Simi Valley</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Stockton\')" title="">Stockton</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Sunnyvale\')" title="">Sunnyvale</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Temecula\')" title="">Temecula</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Thousand Oaks\')" title="">Thousand Oaks</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Torrance\')" title="">Torrance</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Vallejo\')" title="">Vallejo</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Ventura\')" title="">Ventura</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Visalia\')" title="">Visalia</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Victorville\')" title="">Victorville</a>';
			dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Walnut Creek\')" title="">Walnut Creek</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'West Covina\')" title="">West Covina</a>';
			
            break;
		   
        case "Colorado":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Arvada\')" title="">Arvada</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Aurora\')" title="">Aurora</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Centennial\')" title="">Centennial</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Colorado Springs\')" title="">Colorado Springs</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Denver\')" title="">Denver</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Fort Collins\')" title="">Fort Collins</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Lakewood\')" title="">Lakewood</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Pueblo\')" title="">Pueblo</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Thornton\')" title="">Thornton</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Westminster\')" title="">Westminster</a>';
            break;
		
        case "Connecticut":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Bridgeport\')" title="">Bridgeport</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Hartford\')" title="">Hartford</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'New Haven\')" title="">New Haven</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Stamford\')" title="">Stamford</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Waterbury\')" title="">Waterbury</a>';
            break;
		
        case "District of Columbia":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Washington\')" title="">Washington</a>';

            break;
		
        case "Florida":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Cape Coral\')" title="">Cape Coral</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Clearwater\')" title="">Clearwater</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Coral Springs\')" title="">Coral Springs</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Colorado Springs\')" title="">Colorado Springs</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Fort Lauderdale\')" title="">Fort Lauderdale</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Gainesville\')" title="">Gainesville</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Hialeah\')" title="">Hialeah</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Hollywood\')" title="">Hollywood</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Miami Gardens\')" title="">Miami Gardens</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Miramar\')" title="">Miramar</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Orlando\')" title="">Orlando</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Palm Bay\')" title="">Palm Bay</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Pembroke Pines\')" title="">Pembroke Pines</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Port St. Lucie\')" title="">Port St. Lucie</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'St. Petersburg\')" title="">St. Petersburg</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Tallahassee\')" title="">Tallahassee</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Tampa\')" title="">Tampa</a>';

            break;
		
        case "Georgia":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Atlanta\')" title="">Atlanta</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Athens\')" title="">Athens</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Augusta \')" title="">Augusta</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Columbus\')" title="">Columbus</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Savannah\')" title="">Savannah</a>';
            break;
		
        case "Hawaii":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Honolulu\')" title="">Honolulu</a>';
            break;
		
        case "Idaho":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Boise\')" title="">Boise</a>';
            break;
		
        case "Illinois":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Aurora\')" title="">Aurora</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Chicago\')" title="">Chicago</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Elgin \')" title="">Elgin</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Joliet\')" title="">Joliet</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Naperville\')" title="">Naperville</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Peoria \')" title="">Peoria</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Rockford\')" title="">Rockford</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Springfield\')" title="">Springfield</a>';
            break;
		
        case "Indiana":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Evansville\')" title="">Evansville</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Indianapolis\')" title="">Indianapolis</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Fort Wayne \')" title="">Fort Wayne</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'South Bend\')" title="">South Bend</a>';
            break;

        case "Iowa":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Cedar Rapids\')" title="">Cedar Rapids</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Des Moines\')" title="">Des Moines</a>';
            break;

        case "Kansas":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Olathe\')" title="">Olathe</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Overland Park\')" title="">Overland Park</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Kansas City \')" title="">Kansas City</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Topeka\')" title="">Topekad</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Wichita\')" title="">Wichita</a>';
            break;


        case "Kentucky":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Lexington\')" title="">Lexington</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Louisville\')" title="">Louisville</a>';
            break;


        case "Louisiana":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Baton Rouge\')" title="">Baton Rouge</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Lafayette\')" title="">Lafayette</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'New Orleans \')" title="">New Orleans</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Shreveport\')" title="">Shreveport</a>';
            break;


        case "Maryland":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Baltimore\')" title="">Baltimore</a>';
            break;


        case "Massachusetts":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Boston\')" title="">Boston</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Cambridge\')" title="">Cambridge</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Lowell \')" title="">Lowell</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Springfield\')" title="">Springfield</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Worcester\')" title="">Worcester</a>';
            break;
		
        case "Michigan":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Ann Arbor\')" title="">Ann Arbor</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Detroit\')" title="">Detroit</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Flint \')" title="">Flint</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Grand Rapids\')" title="">Grand Rapids</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Lansing\')" title="">Lansing</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Sterling Heights\')" title="">Sterling Heights</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Warren\')" title="">Warren</a>';
            break;

        case "Massachusetts":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Boston\')" title="">Boston</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Cambridge\')" title="">Cambridge</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Lowell \')" title="">Lowell</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Springfield\')" title="">Springfield</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Worcester\')" title="">Worcester</a>';
            break;

        case "Minnesota":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Minneapolis\')" title="">Minneapolis</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Rochester\')" title="">Rochester</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'St. Paul \')" title="">St. Paul</a>';
            break;

        case "Mississippi":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Jackson\')" title="">Jackson</a>';
            break;

        case "Missouri":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Columbia\')" title="">Columbia</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Independence\')" title="">Independence</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Kansas City \')" title="">Kansas City</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Springfield\')" title="">Springfield</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'St. Louis\')" title="">St. Louis</a>';
            break;

        case "Montana":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Billings\')" title="">Billings</a>';
            break;

        case "Nebraska":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Lincoln\')" title="">Lincoln</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Omaha\')" title="">Omaha</a>';
            break;
		
        case "Nevada":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Henderson\')" title="">Henderson</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Las Vegas\')" title="">Las Vegas</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'North Las Vegas \')" title="">North Las Vegas</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Reno\')" title="">Reno</a>';
            break;

        case "New Hampshire":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Manchester\')" title="">Manchester</a>';
            break;
		
        case "New Jersey":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Elizabeth\')" title="">Elizabeth</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Jersey City\')" title="">Jersey City</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Newark\')" title="">Newark</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Paterson\')" title="">Paterson</a>';
            break;

        case "New Mexico":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Albuquerque\')" title="">Albuquerque</a>';
            break;

        case "New York":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Buffalo\')" title="">Buffalo</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'New York\')" title="">New York</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Rochester\')" title="">Rochester</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Syracuse\')" title="">Syracuse</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Yonkers\')" title="">Yonkers</a>';
            break;

        case "North Carolina":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Cary\')" title="">Cary</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Charlotte\')" title="">Charlotte</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Durham\')" title="">Durham</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Fayetteville\')" title="">Fayetteville</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Greensboro\')" title="">Greensboro</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'High Point\')" title="">High Point</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Raleigh\')" title="">Raleigh</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Wilmington\')" title="">Wilmington</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Winston-Salem\')" title="">Winston-Salem</a>';
            break;

        case "North Dakota":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Fargo\')" title="">Fargo</a>';
            break;

        case "Ohio":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Akron\')" title="">Akron</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Cincinnati\')" title="">Cincinnati</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Cleveland\')" title="">Cleveland</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Columbus\')" title="">Columbus</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Dayton\')" title="">Dayton</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Toledo\')" title="">Toledo</a>';
            break;
        case "Oklahoma":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Norman\')" title="">Norman</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Oklahoma City\')" title="">Oklahoma City</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Tulsa\')" title="">Tulsa</a>';
            break;
        case "Oregon":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Eugene\')" title="">Eugene</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Gresham\')" title="">Gresham</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Portland\')" title="">Portland</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Salem\')" title="">Salem</a>';
            break;
		
        case "Pennsylvania":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Allentown\')" title="">Allentown</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Erie\')" title="">Erie</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Philadelphia\')" title="">Philadelphia</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Pittsburgh\')" title="">Pittsburgh</a>';
            break;

        case "Rhode Island":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Providence\')" title="">Providence</a>';
            break;
        case "South Carolina":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Charleston\')" title="">Charleston</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Columbia\')" title="">Columbia</a>';

            break;
        case "South Dakota":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Sioux Falls\')" title="">Sioux Falls</a>';
            break;
        case "Tennessee":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Chattanooga\')" title="">Chattanooga</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Clarksville\')" title="">Clarksville</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Knoxville\')" title="">Knoxville</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Memphis\')" title="">Memphis</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Murfreesboro\')" title="">Murfreesboro</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Nashville\')" title="">Nashville</a>';
            break;
		
        case "Texas":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Abilene\')" title="">Abilene</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Amarillo\')" title="">Amarillo</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Arlington\')" title="">Arlington</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Austin\')" title="">Austin</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Beaumont\')" title="">Beaumont</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Brownsville\')" title="">Brownsville</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Carrollton\')" title="">Carrollton</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Corpus Christi\')" title="">Corpus Christi</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Dallas\')" title="">Dallas</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Denton\')" title="">Denton</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'El Paso\')" title="">El Paso</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Fort Worth\')" title="">Fort Worth</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Frisco\')" title="">Frisco</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Garland\')" title="">Garland</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Grand Prairie\')" title="">Grand Prairie</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Houston\')" title="">Houston</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Irving\')" title="">Irving</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Killeen\')" title="">Killeen</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Laredo\')" title="">Laredo</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Lubbock\')" title="">Lubbock</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Mesquite\')" title="">Mesquite</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'McAllen\')" title="">McAllen</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'McKinney\')" title="">McKinney</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Midland\')" title="">Midland</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Pasadena\')" title="">Pasadena</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Plano\')" title="">Plano</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'San Antonio\')" title="">San Antonio</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Waco\')" title="">Waco</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Wichita Falls\')" title="">Wichita Falls</a>';
            break;

        case "Utah":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Provo\')" title="">Provo</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Salt Lake City\')" title="">Salt Lake City</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'West Jordan\')" title="">West Jordan</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'West Valley City\')" title="">West Valley City</a>';
            break;

        case "Virginia":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Alexandria\')" title="">Alexandria</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Arlington\')" title="">Arlington</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Chesapeake\')" title="">Chesapeake</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Hampton\')" title="">Hampton</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Newport News\')" title="">Newport News </a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Norfolk\')" title="">Norfolk</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Richmond\')" title="">Richmond</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Virginia Beach\')" title="">Virginia Beach</a>';
            break;

        case "Washington":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Bellevue\')" title="">Bellevue</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Everett\')" title="">Everett</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Tacoma\')" title="">Tacoma</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Seattle\')" title="">Seattle</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Spokane\')" title="">Spokane</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Vancouver\')" title="">Vancouver</a>';
            break;
		

        case "Wisconsin":
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Green Bay\')" title="">Green Bay</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Madison\')" title="">Madison</a>';
            dropDownDiv3 += '<a href="javascript:void(0)" onclick="setDropDownValue3(\'Milwaukee\')" title="">Milwaukee</a>';
            break;


    }
    document.getElementById("dropDownDiv3").innerHTML=dropDownDiv3;
    //document.getElementById("chkout_city").value="--Choose City--";
    document.getElementById("field3").innerHTML="--Choose City--";
}


function setDropDownValue4(val){
    document.getElementById("chkout_country").value=val;
    document.getElementById("field4").innerHTML=val;
	$("#field4").css("color","#444444");
    document.getElementById("dropDownDiv4").style.display="none";
    $(".selectBoxCityBankReg").css("border","none");
    $("#country_error").html("");
}

function setDropDownValue5(val){
    document.getElementById("chkout_state").value=val;
    document.getElementById("field5").innerHTML=val;
	$("#field5").css("color","#444444");
    document.getElementById("dropDownDiv5").style.display="none";
    $(".selectBoxCityBankReg").css("border","none");
    $("#state_error").html("");
	
    setStatePaymentValue(val);
	
}
function setDropDownCardValue(val){   
    document.getElementById("chkout_card").value=val;
    document.getElementById("field7").innerHTML=val;	
    $("#field7").css("color","#444444");
    document.getElementById("dropDownDiv7").style.display="none";
 }