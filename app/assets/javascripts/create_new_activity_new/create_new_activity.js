(function($){

    var _old = $.unique;

    $.unique = function(arr){

        // do the default behavior only if we got an array of elements
        if (!!arr[0].nodeType){
            return _old.apply(this,arguments);
        } else {
            // reduce the array to contain no dupes via grep/inArray
            return $.grep(arr,function(v,k){
                return $.inArray(v,arr) === k;
            });
        }
    };
})(jQuery);

var other_fav = new Array();
var other_remove_fav = new Array();
var other_fav_disc = new Array();
var other_remove_discfav = new Array();

function modify_provider_fee(testVal){
    if($("#other_fee_"+testVal).is(":checked")){
        other_item = $("#other_fee_"+testVal).val();
        other_fav.push(other_item);
        $('#add_other_org').val(other_fav);
        if (other_remove_fav!=""){
            var index = other_remove_fav.indexOf(remove_item);
            other_remove_fav.splice(index, 1);
            $('#rem_other_org').val(other_remove_fav);
        }
    }
    else{
        var remove_item = $("#other_fee_"+testVal).val();
        var index = other_fav.indexOf(remove_item);
        other_fav.splice(index, 1);
        $('#add_other_org').val(other_fav);
        if (other_remove_fav.indexOf(remove_item) == -1){
            other_remove_fav.push(remove_item);
            $('#rem_other_org').val(other_remove_fav);
        }
    }
}


function modify_discount_fee(testVal){
    if($("#other_discount_"+testVal).is(":checked")){
        other_item_disc = $("#other_discount_"+testVal).val();
        other_fav_disc.push(other_item_disc);
        $('#add_otherdiscount_org').val(other_fav_disc);
        if (other_remove_discfav!=""){
            var index = other_remove_discfav.indexOf(other_item_disc);
            other_remove_discfav.splice(index, 1);
            $('#rem_otherdiscount_org').val(other_remove_discfav);
        }
    }
    else{
        var remove_item_discount = $("#other_discount_"+testVal).val();
        var index = other_fav_disc.indexOf(remove_item_discount);
        other_fav_disc.splice(index, 1);
        $('#add_otherdiscount_org').val(other_fav_disc);
        if (other_remove_discfav.indexOf(remove_item_discount) == -1){
            other_remove_discfav.push(remove_item_discount);
            $('#rem_otherdiscount_org').val(other_remove_discfav);
        }
    }
}

function dd_eligible_check_box()
{
    if ($("#ddlicheck").is(':checked')){
        $(".ddeligPriceinput").show();
        $("#discount_dollar_check").css("height","84px");
    }
    else
    {
        $(".ddeligPriceinput").hide();
        $("#dd-eligible-error").hide();
        $("#discount_dollar_check").css("height","22px");
    }
}

function dd_helptxt_show(){
    $("#dd_eligible_helptext").show();
}
function dd_helptxt_hide(){
    $("#dd_eligible_helptext").hide();
}

function other_fee_check_box()
{
    if ($("#other_fe_check").is(':checked')){
        $("#other_fee_options").show();
        $("#other_fee_open").val('1');
    // $("#discount_dollar_check").css("height","84px");
    }
    else
    {
        $("#other_fee_options").hide();
        $("#other_fee_open").val('0');
    //$("#dd-eligible-error").hide();
    //     $("#discount_dollar_check").css("height","22px");
    }
    
}

function discount_options_check_box()
{
    if ($("#discounts_check").is(':checked')){
        $("#discount_options").show();
        $("#discount_code_open").val('1');
        
    // $("#discount_dollar_check").css("height","84px");
    }
    else
    {
        $("#discount_code_open").val('0');
        $("#discount_options").hide();
    //$("#dd-eligible-error").hide();
    //     $("#discount_dollar_check").css("height","22px");
    }
    
}

function continueKeyDown(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13){
        activity_validation();
    }
}
function backKeyDown(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13){
        changeStep('step1');
    }
}
function cancelKeyDown(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        closepopup();
    }
}
function cancelRepeatKeyDown(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        closeRepeatDiv();
    }
}
/*************************
          steps
 **************************/
function changeStep(steps){ 
    $("html, body", window.parent.document).animate({
        scrollTop: 0
    }, 100);
    if(steps=="step1"){
        $("#step1_Img img").attr("src","/assets/provider_register/step_1inactive.png");
        $("#step2_Img img").attr("src","/assets/provider_register/step_2active.png");
        $("#step3_Img img").attr("src","/assets/provider_register/step_3active.png");

        $("#step1_text span").addClass("setfontWeight");
        $("#step2_text span").removeClass("setfontWeight");
        $("#step3_text span").removeClass("setfontWeight");
	
        $("#activityStep1").show();
        $("#priceStep2").hide();
        $("#price_Step3").hide();
    }   
    if(steps=="step2"){
        $("#step1_Img img").attr("src","/assets/provider_register/step_1active.png");
        $("#step2_Img img").attr("src","/assets/provider_register/step_2inactive.png");
        $("#step3_Img img").attr("src","/assets/provider_register/step_3active.png");
		
        $("#step1_text span").removeClass("setfontWeight");
        $("#step2_text span").addClass("setfontWeight");
        $("#step3_text span").removeClass("setfontWeight");
	
        $("#activityStep1").hide();
        $("#priceStep2").show();
        $("#price_Step3").hide();
	
        //step3 to back step 2 - schedule and whole day add mutiple schedule means , first schedule dont have plus option
        billing_type_sc=$('#billing_type_sc').val();
        if(billing_type_sc=='1')
        {
            tabs_c=$('#schedule_tabs').val();
            tabs=tabs_c.split(',');
            if(tabs.length > 1)
            {
                $('#add_schedule_'+tabs[0]).hide();
            }
		
        }
        if(billing_type_sc=='4')
        {
            tabs_c=$('#whole_day_tabs').val();
            tabs=tabs_c.split(',');
            if(tabs.length > 1)
            {
                $('#add_whole_day_'+tabs[0]).hide();
            }
        }
	
    }
    
    if(steps=="step3"){
        $("#step1_Img img").attr("src","/assets/provider_register/step_1active.png");
        $("#step2_Img img").attr("src","/assets/provider_register/step_2active.png");
        $("#step3_Img img").attr("src","/assets/provider_register/step_3inactive.png");
		
        $("#step1_text span").removeClass("setfontWeight");
        $("#step2_text span").removeClass("setfontWeight");
        $("#step3_text span").addClass("setfontWeight");
	
        $("#activityStep1").hide();
        $("#priceStep2").hide();
        $("#price_Step3").show();
        added_new_schedule();
    }  
}
function focusChangeBorderColor1(id)
{
    if($('#'+id).val() == "Enter Price" ){
        $('#'+id).val('');
    }
}
function blurChangeBorderColor1(id){
    if($('#'+id).val()== "" ){
        $('#'+id).val("Enter Price");
        $('#'+id).css("border","1px solid #BDD6DD");
        $('#'+id).css("color","#999999");
    }
}
function focusChangeBorderColor(id){
    switch(id){
        case "title":
            if($('#'+id).val()== "Enter Activity Name" ){
                $('#'+id).val('');
            }
            break;
        case "desc":
            if($('#'+id).val() == "Description should not exceed 5000 characters" ){
                $('#'+id).val('');
            }
            break;
        case "add_1":
            if($('#'+id).val() == "Address Line 1" ){
                $('#'+id).val('');
            }
            break;
        case "add_2":
            if($('#'+id).val() == "Address Line 2" ){
                $('#'+id).val('');
            }
            break;
        case "zip_code":
            if($('#'+id).val() == "Enter Zip Code" ){
                $('#'+id).val('');
            }
            break;
        case "no_pat":
            if($('#'+id).val() == "Specify Number" ){
                $('#'+id).val('');
            }
            break;
        case "phone_no":
            if($('#'+id).val() == "Eg 987654321" ){
                $('#'+id).val('');
            }
            break;
        case "website":
            if($('#'+id).val() == "Enter URL" ){
                $('#'+id).val('');
            }
            break;
        case "email_id":
            if($('#'+id).val() == "Enter Email" ){
                $('#'+id).val('');
            }
            break;
        case "price":
            if($('#'+id).val() == "Net Amount" ){
                $('#'+id).val('');
            }
            break;
        case "leader":
            if($('#'+id).val() == "Enter Leader Name" ){
                $('#'+id).val('');
            }
            break;
			
    }
    $('#'+id).css("border","1px solid #9fd8eb");
    $('#'+id).css("color","#444444");
}	
function blurChangeBorderColor(id){
    switch(id){
        case "title":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Activity Name");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "desc":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Description should not exceed 5000 characters");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "add_1":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Address Line 1");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "add_2":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Address Line 2");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "zip_code":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Zip Code");
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
        case "phone_no":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Eg 987654321");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "email_id":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Email");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "website":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter URL");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "price":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Net Amount");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;

        case "leader":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Enter Leader Name");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;

    }
    $('#'+id).css("border","1px solid #BDD6DD");
}
function dispCheckboxImg(imgName){
	
    if(imgName == 'checkbox_normal'){
        $('#checkbox_normal').css('display','none');
        $('#checkbox_error').css('display','none');
        $('#checkbox_selected').css('display','inline-block');
        $("#anytime_closed_mon").val(0);
        $("#close_1").css('display','inline-block');
    }
    else if(imgName == 'checkbox_selected'){
        $('#checkbox_normal').css('display','inline-block');
        $('#checkbox_error').css('display','none');
        $('#checkbox_selected').css('display','none');
        $("#anytime_closed_mon").val(1);
        $("#close_1").css('display','none');
    }
    else if(imgName == 'checkbox_normal1'){
        $('#checkbox_normal1').css('display','none');
        $('#checkbox_error1').css('display','none');
        $('#checkbox_selected1').css('display','inline-block');
        $("#anytime_closed_tue").val(0);
        $("#close_2").css('display','inline-block');
    }
    else if(imgName == 'checkbox_selected1'){
        $('#checkbox_normal1').css('display','inline-block');
        $('#checkbox_error1').css('display','none');
        $('#checkbox_selected1').css('display','none');
        $("#anytime_closed_tue").val(1);
        $("#close_2").css('display','none');
    }
    else if(imgName == 'checkbox_normal2'){
        $('#checkbox_normal2').css('display','none');
        $('#checkbox_error2').css('display','none');
        $('#checkbox_selected2').css('display','inline-block');
        $("#anytime_closed_wed").val(0);
        $("#close_3").css('display','inline-block');
    }
    else if(imgName == 'checkbox_selected2'){
        $('#checkbox_normal2').css('display','inline-block');
        $('#checkbox_error2').css('display','none');
        $('#checkbox_selected2').css('display','none');
        $("#anytime_closed_wed").val(1);
        $("#close_3").css('display','none');
    }
    else if(imgName == 'checkbox_normal3'){
        $('#checkbox_normal3').css('display','none');
        $('#checkbox_error3').css('display','none');
        $('#checkbox_selected3').css('display','inline-block');
        $("#anytime_closed_thu").val(0);
        $("#close_4").css('display','inline-block');
    }
    else if(imgName == 'checkbox_selected3'){
        $('#checkbox_normal3').css('display','inline-block');
        $('#checkbox_error3').css('display','none');
        $('#checkbox_selected3').css('display','none');
        $("#anytime_closed_thu").val(1);
        $("#close_4").css('display','none');
    }
    else if(imgName == 'checkbox_normal4'){
        $('#checkbox_normal4').css('display','none');
        $('#checkbox_error4').css('display','none');
        $('#checkbox_selected4').css('display','inline-block');
        $("#anytime_closed_fri").val(0);
        $("#close_5").css('display','inline-block');
    }
    else if(imgName == 'checkbox_selected4'){
        $('#checkbox_normal4').css('display','inline-block');
        $('#checkbox_error4').css('display','none');
        $('#checkbox_selected4').css('display','none');
        $("#anytime_closed_fri").val(1);
        $("#close_5").css('display','none');
    }
    else if(imgName == 'checkbox_normal5'){
        $('#checkbox_normal5').css('display','none');
        $('#checkbox_error5').css('display','none');
        $('#checkbox_selected5').css('display','inline-block');
        $("#anytime_closed_sat").val(0);
        $("#close_6").css('display','inline-block');
    }
    else if(imgName == 'checkbox_selected5'){
        $('#checkbox_normal5').css('display','inline-block');
        $('#checkbox_error5').css('display','none');
        $('#checkbox_selected5').css('display','none');
        $("#anytime_closed_sat").val(1);
        $("#close_6").css('display','none');
    }
    else if(imgName == 'checkbox_normal6'){
        $('#checkbox_normal6').css('display','none');
        $('#checkbox_error6').css('display','none');
        $('#checkbox_selected6').css('display','inline-block');
        $("#anytime_closed_sun").val(0);
        $("#close_7").css('display','inline-block');
    }
    else if(imgName == 'checkbox_selected6'){
        $('#checkbox_normal6').css('display','inline-block');
        $('#checkbox_error6').css('display','none');
        $('#checkbox_selected6').css('display','none');
        $("#anytime_closed_sun").val(1);
        $("#close_7").css('display','none');
    }
    else{
        $('#checkbox_selected').css('display','none');
        $('#checkbox_normal').css('display','inline-block');
        $('#checkbox_error').css('display','none');
		
        $('#checkbox_selected1').css('display','none');
        $('#checkbox_normal1').css('display','inline-block');
        $('#checkbox_error1').css('display','none');
		
        $('#checkbox_selected2').css('display','none');
        $('#checkbox_normal2').css('display','inline-block');
        $('#checkbox_error2').css('display','none');
		
        $('#checkbox_selected3').css('display','none');
        $('#checkbox_normal3').css('display','inline-block');
        $('#checkbox_error3').css('display','none');
		
        $('#checkbox_selected4').css('display','none');
        $('#checkbox_normal4').css('display','inline-block');
        $('#checkbox_error4').css('display','none');
		
        $('#checkbox_selected5').css('display','none');
        $('#checkbox_normal5').css('display','inline-block');
        $('#checkbox_error5').css('display','none');
		
        $('#checkbox_selected6').css('display','none');
        $('#checkbox_normal6').css('display','inline-block');
        $('#checkbox_error6').css('display','none');
    }
}
function set_category(category){

    if(category == "");
    $.get('/activities/edit_update_sub_category',{
        "id":category
    }, function(data){
        $("#sub_category").html(data);
    });
    $("#category").css('color','#444444');
    $("#sub_category").css('color','#444444');
    return false;
}
/*****************************************
		Whole Day
 *****************************************/
function dispCheckDays(cname,id,incId){

    $('.radio_selected_day_'+incId).css('display','none');
    $('.radio_normal_day_'+incId).css('display','inline-block');
    $('#daysRow_'+incId+' input').val(0);
    var tabs=$('#whole_day_tabs').val();
	var t=tabs.split(',');
    if(cname == 'radio_normal_day'){
        $('#radio_selected_day_'+id+'_'+incId).css('display','inline-block');  
        $('#radio_normal_day_'+id+'_'+incId).css('display','none');
        $('#wday_'+id+'_'+incId).val(1);
    	   
        if(id==1){
            $("#singleDay_"+incId).show();
            $("#multipleDays_"+incId).hide();
	    for(var h=t.length-1;h>=0;h--){
		 if($('#wday_'+id+'_'+t[h]).val()==1){
		    var ex_id=t[h];
		   
		    var j=t[t.length-1];
		   
		  var whole_stime_1 = $('#whole_stime_1_'+ex_id).val();
		    
		    set_time_drop('whole_stime_1_'+j,whole_stime_1);
		   var whole_stime_2 = $('#whole_stime_2_'+ex_id).val();
		    set_time_drop('whole_stime_2_'+j,whole_stime_2);
		   var whole_etime_1 = $('#whole_etime_1_'+ex_id).val();
		    set_time_drop('whole_etime_1_'+j,whole_etime_1);
		  
		   var whole_etime_2 = $('#whole_etime_2_'+ex_id).val();
		    set_time_drop('whole_etime_2_'+j,whole_etime_2);
		
				  
		 }
	    }
        }
        if(id==2){
            $("#singleDay_"+incId).hide();
            $("#multipleDays_"+incId).show();
	     for(var h=t.length-1;h>=0;h--){
		 if($('#wday_'+id+'_'+t[h]).val()==1){
		    var ex_id=t[h];
		    
		    var j=t[t.length-1];
		   var camps_stime_1 = $('#camps_stime_1_'+ex_id).val();
    
		    set_time_drop('camps_stime_1_'+j,camps_stime_1);
		    var camps_stime_2 = $('#camps_stime_2_'+ex_id).val();
		    set_time_drop('camps_stime_2_'+j,camps_stime_2);
		    var camps_etime_1 = $('#camps_etime_1_'+ex_id).val();
		    set_time_drop('camps_etime_1_'+j,camps_etime_1);
		    var camps_etime_2 = $('#camps_etime_2_'+ex_id).val();
		    set_time_drop('camps_etime_2_'+j,camps_etime_2);
		 
		     

		 }
	     }
        }
    }
}

/*****************************************
		Price Div Func
 ******************************************/
function dispCheckPrice(cname,id){ 
    pnet_count=$('#total_div_count').val();
    padv_count=$('#total_outer_div').val();
    pnet_count_split=pnet_count.split(',');
	
    if (confirm('Do you want change the price'))
    {
        $('.radio_selected_price').css('display','none');
        $('.radio_normal_price').css('display','inline-block');
        $('#value_seting input').val(0);
        var priceDivHeight = $('.priceDiv').css('height');
	    

        /*  net price  */
        $("#price").css("border","1px solid #CDE0E6");
        $("#net_price_error").html("");
        $("#net_price_error").parent().css("display","none");
		
        /*  advanced price  */
        $("#advancedPriceContainer .errorDiv").hide();
        $("#advancedPriceContainer .errorDiv div").html("");
		
        if(cname == 'radio_normal_price'){
            $('#radio_selected_price_'+id).css('display','inline-block');
            $('#radio_normal_price_'+id).css('display','none');
            $('#price_'+id).val(1);
        }
        //billing_type_sc=1;
        billing_type_sc=$('#billing_type_sc').val();
        //  alert(billing_type_sc);
        if((billing_type_sc=='1')||(billing_type_sc=='4'))
        {
		
            if(id==1){//alert('net');
                //alert(id);
                $("#netPriceDiv").show();
                $("#netPriceDiv").css('display','block');
                $("#netPriceDiv1").css('display','block');
                $("#advancedPriceDiv").css('display','none');
                $("#advancedPriceDiv").hide();
                $("#advancedPriceDiv1").hide();
                $('.priceDiv').css('height','240px');
                $(".ddEligble").show();
                $("#descion_id").val('net');
                //if we change the price will clear the schedule price - net price
                s=$('#total_div_count').val();
                s = s+',';
                s1=s.split(',');
                for(var i=0; i<s1.length; i++)
                {
                    if(s!='')
                    {
                        t=s1[i].split('_');
                        $('#netPriceDiv_'+t[0]).remove();
                    }
                }
                $('#total_div_count').val('1_1');
                $('#net_continue_sc').val(0);
                $('#net_continue_wsc').val(0);
                validate_notes_netprice(0);
				
            }
            else if(id==2){
                //  alert('adv');alert(id);
                $("#advancedPriceDiv").show();
                $("#netPriceDiv").css('display','none');
                $("#netPriceDiv1").css('display','none');
                $("#advancedPriceDiv").css('display','block');
                $("#advancedPriceDiv1").css('display','block');
                $("#netPriceDiv").hide();
                $('.priceDiv').css('height','100%');
                $(".ddEligble").show();
                $("#descion_id").val('adv');
				
                //if we change the price will clear the schedule price  - advance price
                as=$('#total_outer_div').val();
                as = as+',';
                as1=as.split(',');
                for(var i=0; i<as1.length; i++)
                {
                    if(as!='')
                    {
                        t=as1[i].split('_');
                        $('#added_price_'+t[0]).remove();
                    }
                }
                $('#total_outer_div').val('1_1');
                $('#adv_continue_sc').val(0);
                $('#adv_continue_wsc').val(0);
                validate_notes_adprice(0);
            }
            else{
                $("#advancedPriceDiv").hide();
                $("#netPriceDiv").css('display','none');
                $("#netPriceDiv1").css('display','none');
                $("#netPriceDiv").css('display','none');
                $("#advancedPriceDiv").css('display','none');
                $("#advancedPriceDiv1").css('display','none');
                $('.priceDiv').css('height','200px');
                $(".ddEligble").hide();
                $("#descion_id").val('nothing');
            }
        }
        else{
            if(id==1){
                $("#netPriceDiv1").show();
                $("#netPriceDiv1").css('display','block');
                $("#advancedPriceDiv1").hide();
                $("#advancedPriceDiv1").hide();
                $("#descion_id").val('net');
                $("#netPriceDiv1").css('display','block');
                $("#advancedPriceDiv1").css('display','none');
                $(".ddEligble").show();
            }
		 
            else if(id==2){
                $("#advancedPriceDiv1").show();
                $("#netPriceDiv1").hide();
                $("#netPriceDiv1").css('display','none');
                $("#descion_id").val('adv');
                $("#netPriceDiv1").css('display','none');
                $("#advancedPriceDiv1").css('display','block');
			
            }
            else{
                $("#advancedPriceDiv1").hide();
                $("#netPriceDiv1").hide();
                $("#netPriceDiv1").css('display','none');
                $('.priceDiv').css('height','200px');
                $(".ddEligble").hide();
                $("#descion_id").val('nothing');
                $("#netPriceDiv1").css('display','none');
                $("#advancedPriceDiv1").css('display','none');
			
            }
        }
        price_form_reset_value();
    }
    
}
/***************************************
		Age DropDown
 ****************************************/
/* validate the age ranges in create edit activities for provider*/
 function changeAgeRange(dval,range)
  {	
	$('#'+range+"_type").css("color","#444444");
	age_type = dval.toLowerCase();						
	if(age_type=='')
	{
		$('#div_'+range+'_month').hide();
		$('#div_'+range+'_year').hide();
	}
	if(age_type=='month')
	{ 
		$('#div_'+range+'_month').show();
		$('#div_'+range+'_year').hide();
	}						
	if(age_type=='year')
	{ 
		$('#div_'+range+'_year').show();	
		$('#div_'+range+'_month').hide();
	}
  }
function setAgeDropDownValue(range,type,age){  
	if(range=='min')
	{
		document.getElementById(type+"_age1").style.color="#444444";	
	}
	if(range=='max')
	{
		document.getElementById(type+"_age2").style.color="#444444";	
	}
	if(age=="All" || age=="Adults"){
		if(range=="min"){			
			document.getElementById("year_age1").value=age;
			document.getElementById("max_type").value="year";
			document.getElementById("div_max_month").style.display='none'
			document.getElementById("div_max_year").style.display='block'
			document.getElementById("year_age2").style.color="#444444";
			document.getElementById("year_age2").value=age;
		}
	}
	else{
		if(range=="max"){		
		    var t = document.getElementById("min_type").value();
			var age1=document.getElementById(t+"_age1").value();
		    if(age1=="All" || age1=="Adults"){
			document.getElementById("year_age1").value="1";
		    }
		}
	}	
}
/**************************************
	Provider Schedule DropDown
 **************************************/
function scheduleDropDown(val){    
    document.getElementById("billing_type").style.color="#444444" ;
    $(".priceDiv").css("margin-top","0px");
    $(".priceDiv .setBlueBG").css("border-top","none");
	
    $("#billing_error").html("");
    $("#schedule_time_error").html("");
    $("#preferred_time_error").html("");
    $("#hours_mon_time_error").html("");
    $("#hours_tue_time_error").html("");
    $("#hours_wed_time_error").html("");
    $("#hours_thu_time_error").html("");
    $("#hours_fri_time_error").html("");
    $("#hours_sat_time_error").html("");
    $("#hours_sun_time_error").html("");
    $("#camps_error").html("");	  
	      
    $("#billing_error").parent().css("display","none");
    $("#schedule_time_error").parent().css("display","none");
    $("#preferred_time_error").parent().css("display","none");
    $("#hours_mon_time_error").parent().css("display","none");
    $("#hours_tue_time_error").parent().css("display","none");
    $("#hours_wed_time_error").parent().css("display","none");
    $("#hours_thu_time_error").parent().css("display","none");
    $("#hours_fri_time_error").parent().css("display","none");
    $("#hours_sat_time_error").parent().css("display","none");
    $("#hours_sun_time_error").parent().css("display","none");
    $("#camps_error").parent().css("display","none");
	
    if(val == "Schedule"){        
        document.getElementById("dtstyle").style.display="block";
        document.getElementById("any_time_disp").style.display="none";
        document.getElementById("bill_cams_works").style.display="none";
        document.getElementById("by_appoinment").style.display="none";
        $('#buttons_left').css("margin-left","50px");
      
        form_reset_values();
        $('#billing_type_sc').val('1');
    //dispCheckPrice('radio_normal_price',1);
    }
    else if(val == "By Appointment"){  
        document.getElementById("dtstyle").style.display="none";
        document.getElementById("any_time_disp").style.display="none";
        document.getElementById("bill_cams_works").style.display="none";
        document.getElementById("by_appoinment").style.display="block";
        $('#billing_type_sc').val('2');
        $(".priceDiv").css("margin-top","10px");
        $(".priceDiv .setBlueBG").css("border-top","1px solid #EEF2F3");
        $('#buttons_left').css("margin-left","200px");
    }
    else if(val == "Any Time"){      
        document.getElementById("any_time_disp").style.display="block";
        document.getElementById("dtstyle").style.display="none";
        document.getElementById("bill_cams_works").style.display="none";
        document.getElementById("by_appoinment").style.display="none";
        $('#buttons_left').css("margin-left","200px");
        $('#billing_type_sc').val('3');
    }   
    else if(val == "Whole Day"){        
        document.getElementById("bill_cams_works").style.display="block";
        document.getElementById("dtstyle").style.display="none";
        document.getElementById("any_time_disp").style.display="none";
        $('#buttons_left').css("margin-left","200px");
        document.getElementById("by_appoinment").style.display="none";
        
        form_reset_values();
        $('#billing_type_sc').val('4');
    //dispCheckPrice('radio_normal_price',1);
    }
    else{
        document.getElementById("dtstyle").style.display="none";
        document.getElementById("any_time_disp").style.display="none";
        document.getElementById("bill_cams_works").style.display="none";
        document.getElementById("by_appoinment").style.display="none";
        $(".priceDiv").css("margin-top","10px");
        $(".priceDiv .setBlueBG").css("border-top","1px solid #EEF2F3");
    }
    
    
}

function form_reset_values(){
      
    $('#net_price_schedules').find('input:text').val('');
    $('#changing_schedule_decide').val('0');
    $('#changing_schedule_decide_adv').val('0');
    $('#changing_schedule_adv_base').val('0');
    $('#changing_schedule_net_base').val('0');
    $('#changing_schedule_adv_count').val('0');
	
    // $('#billing_type_sc').val('1');
    $('#descion_id').val('net');
    $('#changing_schedule_net_count').val('0');
        
    $('#save_result').val('1_1_0');
    $('#last_discount_id_1_1').val('0');
    $('#last_in_discount_id_1').val('1_1_0');
	
    $('#delete_discount_id_1_1').val('1_1_0');
    $('#total_div_count').val('1_1');
    $('#changing_schedule_adv_count').val('0');
        
    $('#result_save').val('1_1_0');
    $('#total_outer_div').val('1_1');
    $('#advance_price_count').val('1');
	
    $('#last_ad_discount_id_1_1').val('0');
    $('#last_ad_in_discount_id_1').val('1_1_0');
    $('#delete_ad_discount_id_1_1').val('1_1_0');
        
    $('#inner_div_count_1_1').val('1_1');
    $('#early_div_count_1_1').val('1_1_0');
	
    $('#multiple_discount_count_1_1_0').val('1');
        
}
/************************************
  step 3 text value clear
*************************************/
function price_form_reset_value()
{
    $('#changing_schedule_net_count').val('0');
        
    $('#save_result').val('1_1_0');
    $('#last_discount_id_1_1').val('0');
    $('#last_in_discount_id_1').val('1_1_0');
	
    $('#delete_discount_id_1_1').val('1_1_0');
    $('#total_div_count').val('1_1');
    $('#changing_schedule_adv_count').val('0');
        
    $('#result_save').val('1_1_0');
    $('#total_outer_div').val('1_1');
    $('#advance_price_count').val('1');
	
    $('#last_ad_discount_id_1_1').val('0');
    $('#last_ad_in_discount_id_1').val('1_1_0');
    $('#delete_ad_discount_id_1_1').val('1_1_0');
        
    $('#inner_div_count_1_1').val('1_1');
    $('#early_div_count_1_1').val('1_1_0');
	
    $('#multiple_discount_count_1_1_0').val('1');
}
/**************************************
	Parent Schedule DropDown
 **************************************/
function parentScheduleDropDown(val){
    if(val == "Schedule"){
        $("#billing_any").hide();
        $("#dtstyle").show();
        $("#address").show();
        $("#city_state").show();
        $("#zipcode").show();
    }
    else if(val == "Any Time"){
        $("#dtstyle").hide();
        $("#billing_any").show();
    }
    diffSchedules();
}
/*****************************************
		AnyTime or Any Where
 *****************************************/
function dispCheckAnytime(cname,id){
    $("#billing_any").show();
    $('.radio_selected_anytime').css('display','none');
    $('.radio_normal_anytime').css('display','inline-block');
    $('#camps_date_time input').val(0);
	
    if(cname == 'radio_normal_anytime'){
        $('#radio_selected_anytime_'+id).css('display','inline-block');  
        $('#radio_normal_anytime_'+id).css('display','none');        
    	   
        if(id==1){
            $("#any_address").val(1);
            $("#address").show();
            $("#city_state").show();
            $("#zipcode").show();
            $("#any_where").val(0);
        }
	    
        if(id==2){
            $("#any_where").val(1);
            $("#address").hide();
            $("#city_state").hide();
            $("#zipcode").hide();
            $("#any_address").val(0);
        }
    }
}
// called summary display func...
function callSummay(popId){ 
    summary_date_time_changes(popId);
}

/******************************************

	Select Option for discount type

 ******************************************/
function payTypeChanged(id1,id2, cu_value){	
    var id = id1+"_"+id2;
    $("#display_fst_text_"+id).show();
    $("#display_fst_text_"+id).html('Max No of Hour(s)');
    
    $("#display_sec_text_"+id).hide();
    $("#display_sec_text_"+id).html('');
	
    $("#ad_payment_box_fst_"+id).show();
    $("#ad_payment_box_sec_"+id).hide();
        
    if(cu_value == "Per Hour" ){
        $("#display_fst_text_"+id).show();
        $("#display_fst_text_"+id).html(' Max No. of Hour(s)');
    }
    if(cu_value == "Class Card" ){
        $("#display_fst_text_"+id).show();
        $("#display_fst_text_"+id).html('No. of Classes');
    }
    if(cu_value == "Per Session" ){
        $("#display_fst_text_"+id).show();
        $("#display_fst_text_"+id).html(' No. of Day(s)');
		
        $("#display_sec_text_"+id).show();
        $("#display_sec_text_"+id).html('Max No. of Hour(s)');
		
        $("#display_sec_text_"+id).css("width","123px");
        $("#display_fst_text_"+id).css("width","100px");
        $("#pricelabel_"+id).css("width","85px");
        $("#ad_price_"+id).css("width","74px");
        $("#ad_payment_box_sec_"+id).show();
        $("#ad_payment_box_fst_"+id).css("width","85px");
        $("#ad_payment_box_sec_"+id).css("width","108px");
    }
    if(cu_value == "Weekly" ){
        $("#display_fst_text_"+id).show();
        $("#display_fst_text_"+id).html('No. of Week(s)');
    }
    if(cu_value == "Monthly" ){
        $("#display_fst_text_"+id).show();
        $("#display_fst_text_"+id).html('No. of Month(s)');
    }
    if(cu_value == "Yearly" ){
        $("#display_fst_text_"+id).show();
        $("#display_fst_text_"+id).html('No. of Year(s)');
    }
}
/**************************************
	     
		discTypeChanged function start
		
 ************************************/

function discTypeChanged(net,id1,id2,id3,cu_value,lstval){
    $("#loading_img_change").css("display","block");
   
    if(net == "net_"){
        var id = "net_"+id1+"_"+id2+"_"+id3;
	  
        if(lstval==1){
            var startVal = $("#multiple_discount_count_"+id).val();
				
        }
				
    }
    else{
        var id = id1+"_"+id2+"_"+id3;
    }
    /*  $('.popupContainer').css('opacity','1');//set the over lay
        $('#create_disc_creat_pop').css('display','none');// set the create new popup
    $("#early_brid_"+id).css('display','none');
    $('#session_'+id).css('display','none');
    $('#participant_'+id).css('display','none');
		    
    $("#no_sess_"+id).css('display','none');
    $("#no_part_"+id).css('display','none');
    $("#noe_part_"+id).css('display','none');
	
    var height = '';
	
    if(cu_value == "Early Bird Discount"){
	
        date_calculate(net,id1,id2,id3);// calling the function to append date.
        $("#early_brid_"+id).show();
        $("#noe_part_"+id).show();
        
        height =  $("#early_brid_"+id).css('height');
    }
    else if(cu_value == "Multiple Session Discount"){
        $("#no_part_"+id).show();
        $('#no_sess_'+id).show();
        $('#session_'+id).show();
        
	       
        $('#no_sess_'+id).css("width","140px");
        height =  $("#session_"+id).css('height');
    }
    else if(cu_value == "Multiple Participant Discount"){
        $("#no_part_"+id).show();
        $('#no_sess_'+id).show();
        $('#no_sess_'+id).css("width","140px");
        $('#participant_'+id).show();
        height =  $("#participant_"+id).css('height');
    }
    else if(cu_value == "createnew"){// here the create new type option starts
        
        $('.popupContainer').css('opacity','0');
        $('#create_disc_creat_pop').css('display','block');
    }
    // set height for ie browser
    if(navigator.appName=='Microsoft Internet Explorer'){
        var priceDivHeight = $('.priceDiv').css('height');
        priceDivHeight = parseInt(priceDivHeight) + parseInt(height);
        $('.priceDiv').css('height' ,priceDivHeight);
    }*/
    
    if(cu_value!=""){
	$("#discount_choose_"+id).css("display","block");
    $.ajax({
        type: "POST",
        url: "activity_detail/create_discount_type",
        data: {
            "net":net,
            "id1": id1,
            "id2":id2,
            "id3":id3,
            "cu_value":cu_value,
            "lstval":lstval
        },
        success:function(result){
            $("#discount_choose_"+id).html(result);
	        date_calculates(net,id1,id2,id3);
        }
    });
    }
    else{
	$("#discount_choose_"+id).css("display","none");
    }
}


function activity_location(id,value){
    if(value=="new"){
        pop_create_location("/create_new_location");
    }
}
/************************************************************************
			Open create new location popup
 ************************************************************************/
var createNewLocation;
function pop_create_location(url){
    createNewLocation = dhtmlmodal.open("Create Location","iframe",url," ", "width=650px,height=350px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
/************************************************************************
			Append Choose Location Option
 ************************************************************************/
function added_new_location(){
    var str="";
    var add_1 = $("#add_1").val();
    var add_2 = $("#add_2").val();
    var act_country = $("#act_country").val();
    var act_state = $("#act_state").val();
    var act_city = $("#act_city").val();
    var zip_code = $("#zip_code").val();
	
    if( add_1 != "Address Line 1" || add_1 != "" ){
        str += add_1+", ";
    }
    if( add_2 !="Address Line 1" || add_2 != "" ){
        str += add_2+", ";
    }
    if( act_country !="" ){
        str += act_country+", ";
    }
    if( act_state != "" ){
        str += act_state+", ";
    }
    if( act_city != "" ){
        str += act_city+", ";
    }
    if( zip_code != "Enter Zip Code" || zip_code != "" ){
        str += zip_code;
    }
    //alert(str);
    $('.locations').append('<option value="' + str + '">' + str + '</option>');
//alert($('.locations').html());
//$('select.locations').append('<option value="new">Create New Location</option>');
}

/************************************************************************
			Append Choose Schedule Option
 ************************************************************************/
function added_new_schedule(){
    form_reset_values();
    billing_type = $("#billing_type").val();
    if(billing_type == "Schedule"){
        var popId = 0;
        var ar=$('#schedule_tabs').val();
        var ar1=ar.split(',');
        var arLen = ar1.length;
		
        var formate = '';
        var billing_type = '';
        var curTime = new Date();
        var cdate = curTime.getDate();
        var ccmonth = curTime.getMonth();
        var cyear = curTime.getFullYear();
        ccmonth = parseInt(ccmonth) + 1;
        var date_value = cyear + "-" + ccmonth + "-" + cdate;
		
        /*if(arLen>1){
		    $('select.choose_schedule').html('<option value=""  selected="selected">--Choose--</option><option   id="0" value="select all_0" >select all</option>');
		    var yt='select all_0</br>';
		    var sc_len='0'
		}
		else{
		    $('select.choose_schedule').html('<option value=""  selected="selected">--Choose--</option>');
		    var yt='';
		    
		}*/
        $('select.choose_schedule').html('<option value=""  selected="selected">--Choose--</option>');
        var yt='';
        for(var i=0;i<arLen;i++){
            popId = ar1[i];
            //alert(popId)      ;
            // if check repeat and repeat radio option
            var repeat_check = $('#repeatCheck_'+popId).val();
            //alert(repeat_check);
            var radio_1 = $('#r1_'+popId).val();
            var radio_2 = $('#r2_'+popId).val();
            var radio_3 = $('#r3_'+popId).val();

			
            var date_1 = $('#date_1_'+popId).val();   				// start hidden date
            var date_2 = $('#date_2_'+popId).val();
            // end hidden date
					
            var dateFormate_1 = $('#dateFormate_1_'+popId).val();		// start display date
            var dateFormate_2 = $('#dateFormate_2_'+popId).val();		// end display date
				
            var schedule_stime_1 = $('#schedule_stime_1_'+popId).val();  	// schedule start time
            var firstVal_ss = schedule_stime_1.charAt(0);				// schedule start time - first char
            if(firstVal_ss ==0){
                schedule_stime_1 = schedule_stime_1.charAt(1)+schedule_stime_1.charAt(2)+schedule_stime_1.charAt(3)+schedule_stime_1.charAt(4);
            }
			
            var schedule_stime_2 = $('#schedule_stime_2_'+popId).val();
            var schedule_etime_1 = $('#schedule_etime_1_'+popId).val();
            var firstVal_se = schedule_etime_1.charAt(0);
            if(firstVal_se ==0){
                schedule_etime_1 = schedule_etime_1.charAt(1)+schedule_etime_1.charAt(2)+schedule_etime_1.charAt(3)+schedule_etime_1.charAt(4);
            }
			
            var schedule_etime_2 = $('#schedule_etime_2_'+popId).val();
			
			
            if(repeat_check == "yes" && radio_1 == 0 && radio_2 == 0 && radio_3 == 1){
                var repeat_date = $('#repeat_on_date_'+popId).val();		// repeat hidden date
                if( date_1 == repeat_date ) {
                    formate = dateFormate_1+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
                    $("#schedule_summary_"+popId+" #repeat_summary_text").css('display','none');
			
                }
                else{
                    formate = dateFormate_1+" - "+repeat_date+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
                    $("#schedule_summary_"+popId+" #repeat_summary_text").css('display','block');
			 
                }
            }
            else if(repeat_check == "yes" && radio_3 == 0){
                formate = dateFormate_1+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
                $("#schedule_summary_"+popId+" #repeat_summary_text").css('display','block');
		    
            }
            else if(date_1!=date_2 && date_2!=''){
                formate = dateFormate_1+" - "+dateFormate_2+" "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
		    
            }
            else{
                formate = dateFormate_1+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
		    
            }
				
            yt+=formate;
        }
        $('#total_schedule').val(yt);
        //net price scheduleprice clear
        s=$('#total_div_count').val();
        s=s+',';
        s1=s.split(',');
        for(var i=0; i<s1.length; i++)
        {
            if(s1[i]!='')
            {
                sc_val=$('#chosen_sc_'+s1[i]).val();
                t=s1[i].split('_');
                $('#netPriceDiv_'+t[0]).remove();
            }
        }
        $('#total_div_count').val('1_1');
        $('#net_continue_sc').val(0);
        $('#net_continue_wsc').val(0);
        validate_notes_netprice(0);
        //advance price scheduleprice clear
        as=$('#total_outer_div').val();
        as=as+',';
        as1=as.split(',');
        for(var j=0; j<as1.length; j++)
        {
            if(as1[j]!='')
            {
                asc_val=$('#chosen_ad_sc_'+as1[j]).val();
                t=as1[j].split('_');
                $('#priceContainerDiv_'+t[0]).remove();
            }
        }
        $('#total_outer_div').val('1_1');
        $('#adv_continue_sc').val(0);
        $('#adv_continue_wsc').val(0);
        validate_notes_adprice(0);
        if($('#price_1').val()=="1")
        {
            $("#netPriceDiv").show();
            $("#netPriceDiv_1").show();
            $("#advancedPriceDiv").hide();
            $("#advancedPriceDiv_1").hide();
            $('#net_price_anytime').hide();
            $('#netPriceDiv1').hide();
            $('#advancedPriceDiv1').hide();
        }
        if($('#price_2').val()=="1")
        {
            $("#netPriceDiv").hide();
            $("#netPriceDiv_1").hide();
            $("#advancedPriceDiv").show();
            $("#advancedPriceDiv_1").show();
            $('#net_price_anytime').hide();
            $('#netPriceDiv1').hide();
            $('#advancedPriceDiv1').hide();
        }
        if($('#price_3').val()=="1" || $('#price_4').val()=="1")
        {
            $("#netPriceDiv").hide();
            $("#netPriceDiv_1").hide();
            $("#advancedPriceDiv").hide();
            $("#advancedPriceDiv_1").hide();
            $('#net_price_anytime').hide();
            $('#netPriceDiv1').hide();
            $('#advancedPriceDiv1').hide();
        }
    }
    else if(billing_type == "Whole Day"){
        $('#net_price_anytime #netPriceDiv1').hide();
        var formate = '';
        var ar=$('#whole_day_tabs').val();
        var ar1=ar.split(',');
        var arLen = ar1.length;
        $('select.choose_schedule').html('<option value=""  selected="selected">--Choose--</option>');
        var yt='';
        for(a=0;a<arLen;a++)
        {
            popId=ar1[a];
				    
            $("#wholeday_summay_"+popId).css('display','block');
			
            var wday_1 = $("#wday_1_"+popId).val();
            var wday_2 = $("#wday_2_"+popId).val();
				    
            if(wday_1 == 1){
                var whole_start = $('#datestartwhole_1_'+popId).val();
                var whole_stime_1 = $('#whole_stime_1_'+popId).val();
                var firstVal_ws = whole_stime_1.charAt(0);
                if(firstVal_ws ==0){
                    whole_stime_1 = whole_stime_1.charAt(1)+whole_stime_1.charAt(2)+whole_stime_1.charAt(3)+whole_stime_1.charAt(4);
                }
                var whole_stime_2 = $('#whole_stime_2_'+popId).val();
                var whole_etime_1 = $('#whole_etime_1_'+popId).val();
                var firstVal_we = whole_etime_1.charAt(0);
                if(firstVal_we ==0){
                    whole_etime_1 = whole_etime_1.charAt(1)+whole_etime_1.charAt(2)+whole_etime_1.charAt(3)+whole_etime_1.charAt(4);
                }
                var whole_etime_2 = $('#whole_etime_2_'+popId).val();
						    
                formate = whole_start+", "+whole_stime_1+" "+whole_stime_2+" - "+whole_etime_1+" "+whole_etime_2+"_"+popId+"</br>";
            }
				    
            else if(wday_2 == 1){
                var camps_start = $('#datestcamps_1_'+popId).val();
                var camps_end = $('#dateencamps_2_'+popId).val();
					    
                var datestartcamps_1 = $('#datestartcamps_1_'+popId).val();
                var dateendcamps_2 = $('#dateendcamps_2_'+popId).val();
					    
                var camps_stime_1 = $('#camps_stime_1_'+popId).val();
                var firstVal_cs = camps_stime_1.charAt(0);
                if(firstVal_cs ==0){
                    camps_stime_1 = camps_stime_1.charAt(1)+camps_stime_1.charAt(2)+camps_stime_1.charAt(3)+camps_stime_1.charAt(4);
                }
                var camps_stime_2 = $('#camps_stime_2_'+popId).val();
                var camps_etime_1 = $('#camps_etime_1_'+popId).val();
                var firstVal_ce = camps_etime_1.charAt(0);
                if(firstVal_ce ==0){
                    camps_etime_1 = camps_etime_1.charAt(1)+camps_etime_1.charAt(2)+camps_etime_1.charAt(3)+camps_etime_1.charAt(4);
                }
                var camps_etime_2 = $('#camps_etime_2_'+popId).val();
				    
                if( camps_start == camps_end ) {
                    formate = datestartcamps_1+", "+camps_stime_1+" "+camps_stime_2+" - "+camps_etime_1+" "+camps_etime_2+"_"+popId+"</br>";
                }
                else{
                    formate = datestartcamps_1+", "+camps_stime_1+" "+camps_stime_2+" to "+dateendcamps_2+", "+camps_etime_1+" "+camps_etime_2+"_"+popId+"</br>";
                }
            }
            yt+=formate;
            var  formate1=formate.split("_");
            formate1=formate1[0];
        }
        $('#total_schedule').val(yt);
        //net price scheduleprice clear
        s=$('#total_div_count').val();
        s =s+',';
        s1=s.split(',');
        for(var k=0; k<s1.length; k++)
        {
            if(s1[k]!='')
            {
                sc_val=$('#chosen_sc_'+s1[k]).val();
                t=s1[k].split('_');
                $('#netPriceDiv_'+t[0]).remove();
            }
        }
        $('#total_div_count').val('1_1');
        $('#net_continue_sc').val(0);
        $('#net_continue_wsc').val(0);
        validate_notes_netprice(0);
        //advance price scheduleprice clear
        as=$('#total_outer_div').val();
        as=as+',';
        as1=as.split(',');
        for(var j=0; j<as1.length; j++)
        {
            if(as1[j]!='')
            {
                asc_val=$('#chosen_ad_sc_'+as1[j]).val();
                t=as1[j].split('_');
                $('#priceContainerDiv_'+t[0]).remove();
            }
        }
        $('#total_outer_div').val('1_1');
        $('#adv_continue_sc').val(0);
        $('#adv_continue_wsc').val(0);
        validate_notes_adprice(0);
        if($('#price_1').val()=="1")
        {
            $("#netPriceDiv").show();
            $("#netPriceDiv_1").show();
            $("#advancedPriceDiv").hide();
            $("#advancedPriceDiv_1").hide();
            $('#net_price_anytime').hide();
            $('#netPriceDiv1').hide();
            $('#advancedPriceDiv1').hide();
        }
        if($('#price_2').val()=="1")
        {
            $("#netPriceDiv").hide();
            $("#netPriceDiv_1").hide();
            $("#advancedPriceDiv").show();
            $("#advancedPriceDiv_1").show();
            $('#net_price_anytime').hide();
            $('#netPriceDiv1').hide();
            $('#advancedPriceDiv1').hide();
        }
        if($('#price_3').val()=="1" || $('#price_4').val()=="1")
        {
            $("#netPriceDiv").hide();
            $("#netPriceDiv_1").hide();
            $("#advancedPriceDiv").hide();
            $("#advancedPriceDiv_1").hide();
            $('#net_price_anytime').hide();
            $('#netPriceDiv1').hide();
            $('#advancedPriceDiv1').hide();
        }
    }
    else{
        $("#netPriceDiv").hide();
        $("#netPriceDiv_1").hide();
        $("#advancedPriceDiv").hide();
        $("#advancedPriceDiv_1").hide();
        $('#net_price_anytime').show();
        if($('#price_1').val()=="1")
        {
            $('#netPriceDiv1').show();
            $('#advancedPriceDiv1').hide();
        }
        if($('#price_2').val()=="1")
        {
            $('#netPriceDiv1').hide();
            $('#advancedPriceDiv1').show();
        }
        if($('#price_3').val()=="1" || $('#price_4').val()=="1")
        {
            $('#netPriceDiv1').hide();
            $('#advancedPriceDiv1').hide();
        }
    }
}
function added_new_schedule_(){
    
    billing_type = $("#billing_type").val();
		
    if(billing_type == "Schedule"){
    
        var popId = 0;
        var ar=$('#schedule_tabs').val();
        var ar1=ar.split(',');
        var arLen = ar1.length;
	
        var formate = '';
        var billing_type = '';
        var curTime = new Date();
        var cdate = curTime.getDate();
        var ccmonth = curTime.getMonth();
        var cyear = curTime.getFullYear();
        ccmonth = parseInt(ccmonth) + 1;
        var date_value = cyear + "-" + ccmonth + "-" + cdate;
	
        /*if(arLen>1){
	    $('select.choose_schedule').html('<option value=""  selected="selected">--Choose--</option><option   id="0" value="select all_0" >select all</option>');
	    var yt='select all_0</br>';
	    var sc_len='0'
	}
	else{
	    $('select.choose_schedule').html('<option value=""  selected="selected">--Choose--</option>');
	    var yt='';
	    
	}*/
        $('select.choose_schedule').html('<option value=""  selected="selected">--Choose--</option>');
        var yt='';
        for(var i=0;i<arLen;i++){
            popId = ar1[i];
            //alert(popId)      ;
            // if check repeat and repeat radio option
            var repeat_check = $('#repeatCheck_'+popId).val();
            //alert(repeat_check);
            var radio_1 = $('#r1_'+popId).val();
            var radio_2 = $('#r2_'+popId).val();
            var radio_3 = $('#r3_'+popId).val();

		
            var date_1 = $('#date_1_'+popId).val();   				// start hidden date
            var date_2 = $('#date_2_'+popId).val();
            // end hidden date
				
            var dateFormate_1 = $('#dateFormate_1_'+popId).val();		// start display date
            var dateFormate_2 = $('#dateFormate_2_'+popId).val();		// end display date
			
            var schedule_stime_1 = $('#schedule_stime_1_'+popId).val();  	// schedule start time
            var firstVal_ss = schedule_stime_1.charAt(0);				// schedule start time - first char
            if(firstVal_ss ==0){
                schedule_stime_1 = schedule_stime_1.charAt(1)+schedule_stime_1.charAt(2)+schedule_stime_1.charAt(3)+schedule_stime_1.charAt(4);
            }
		
            var schedule_stime_2 = $('#schedule_stime_2_'+popId).val();
            var schedule_etime_1 = $('#schedule_etime_1_'+popId).val();
            var firstVal_se = schedule_etime_1.charAt(0);
            if(firstVal_se ==0){
                schedule_etime_1 = schedule_etime_1.charAt(1)+schedule_etime_1.charAt(2)+schedule_etime_1.charAt(3)+schedule_etime_1.charAt(4);
            }
		
            var schedule_etime_2 = $('#schedule_etime_2_'+popId).val();
		
		
            if(repeat_check == "yes" && radio_1 == 0 && radio_2 == 0 && radio_3 == 1){
                var repeat_date = $('#repeat_on_date_'+popId).val();		// repeat hidden date
                if( date_1 == repeat_date ) {
                    formate = dateFormate_1+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
                    $("#schedule_summary_"+popId+" #repeat_summary_text").css('display','none');
                
                }
                else{
                    formate = dateFormate_1+" - "+repeat_date+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
                    $("#schedule_summary_"+popId+" #repeat_summary_text").css('display','block');
                 
                }
            }
            else if(repeat_check == "yes" && radio_3 == 0){
                formate = dateFormate_1+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
                $("#schedule_summary_"+popId+" #repeat_summary_text").css('display','block');
            
            }
	    /*
            else if(date_1!=date_2 && date_2!=''){
                formate = dateFormate_1+" - "+dateFormate_2+" "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
            
            }*/
            else{
                formate = dateFormate_1+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
            
            }
			
            yt+=formate;
            formate21=formate.split("_");
            formate1=formate21[0];
            for(var iq=0; iq<arLen;iq++)
            {
                var scd=$('#chosen_sc_'+iq+'_1').val();
                var res21 = formate21[1].replace("</br>","");
                if(res21==scd)
                {
			    
                    $('#chosen_sc_txt_'+iq+'_1_0').text(formate1);
                }
            }
			
            $("#schedule_summary_"+popId+" #dateSummay").html(formate1);
			
			
            var scd=$('#total_schedule').val();
			
            scd=scd.split('</br>');
            schedules=$('#changing_schedule_net').val();
            var  net_count=  $('#changing_schedule_net_count').val();
            var  adv_count=  $('#changing_schedule_adv_count').val();
            var schedules111='';
			
            if((schedules!='' )&&(net_count=='0'))
            {
                // if this is the second time after hiting the continue button and same for others
                schedules=schedules.split("</br>");
                if(schedules.length>1){
                    $('.out_add_schedule ').last().css("display","block");//for display add button and same for others
                }
                // checking the options are already added and same for others
                for(f=0;f<schedules.length;f++)
                {
                    var res = formate.replace("</br>","");
                    result_1=res;
                    res=res.split('_');
                    schedules_split=schedules[f].split('_');
                    if(res[1]==schedules_split[1])
                    {
                        $('#netPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
							
                    }
                }
                // if a new option is added (schedule added )     and same for others
                if((arLen>(scd.length-1))&&(i==(arLen-1)))
                {
							    
                    $('#netPriceDiv select.choose_schedule').append('<option name="'+(i+'yu')+'" id="'+(i+11)+'" value="' + formate + '">' + formate1+ '</option>');
                    schedules1=$('#changing_schedule_net').val();
                    schedules1+='</br>'+result_1;
                    $('#changing_schedule_net').val(schedules1);
                   					
                }
            }
            else if(($('#changing_schedule_decide').val()=='1')&&(schedules=='' ))
            {
                	
                var bases=$('#changing_schedule_net_base').val();
                bases= bases.split('</br>');
                var myCars='';
                for(ba=0;ba<bases.length;ba++)
                {
                    base_res=bases[ba].split('_');
                    myCars+=base_res[1]+',';
                }
                //   alert(myCars);
                myCars.slice(0,-1);
                myCars=myCars.split(',');
                // alert(myCars);	 alert(popId);
                var ides=myCars.indexOf(popId);
                //alert(ides);
                if(ides==-1)	{
                    $('#netPriceDiv select.choose_schedule').append('<option name="'+(i+'yu')+'" id="'+(i+11)+'" value="' + formate + '">' + formate1+ '</option>');
                    schedules1=$('#changing_schedule_net').val();
                    var res = formate.replace("</br>","");
                    schedules1+=res;
                    $('#changing_schedule_net').val(schedules1);
                //    alert(schedules1+'anand');
                }
            }
			
            // after the saving of the schedules edit( save a copy function goes down) and same for others
            else if(net_count!='0')
            {
                //    alert('else if');
		   	
                var bases=$('#changing_schedule_net_base').val();
                bases= bases.split('</br>');
                var myCars='';
                for(ba=0;ba<bases.length;ba++)
                {
                    base_res=bases[ba].split('_');
                    myCars=+base_res[1]+',';
                }
                //   alert(myCars);
                myCars.slice(0,-1);
                myCars=myCars.split(',');
                var ides=myCars.indexOf(popId);
        
            

			  
                if(ides==-1)					// if  a new schedule adding after saving.
                {//alert('else if if');
                    $('#netPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                    var Schedules1=$('#changing_schedule_net').val();
                    if(Schedules1=='')
                    {
                        Schedules1=formate1;
                    }
                    else{
                        Schedules1+='</br>'+formate1;
                    }
                    $('#changing_schedule_net').val(Schedules1);
                }
                else{
                    //   alert('else if else');// else checking the old schedule after saveing
                    schedules=schedules.split("</br>");
                    //alert(schedules);
                    if(schedules.length>1){
                        $('.out_add_schedule ').last().css("display","block");//for display add button and same for others
                    }
                    // checking the options are already added and same for others
                    for(f=0;f<schedules.length;f++)
                    {//alert(f+"_kg");
                        var res = formate.replace("</br>","");
                        result_1=res;
                        res=res.split('_');
                        schedules_split=schedules[f].split('_');
                        if(res[1]!=schedules_split[1])
                        {
                            //alert(f);
                            $('#netPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                        }
                    }
                    // if a new option is added (schedule added )     and same for others
                    if((arLen>(scd.length-1))&&(i==(arLen-1))){
									  
                        //alert('it');
                        $('#netPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                        schedules1=$('#changing_schedule_net').val();
                        schedules1+='</br>'+result_1;
									    
                        $('#changing_schedule_net').val(schedules1);
                    }
				        
				    
                }
			   
			    
			    
            }
			
            else{	
                //   if this is the first time after hiting the continue button
                $('#netPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
            }
			
            /****************for advance price******************/
            schedules_adv=$('#changing_schedule_adv').val();
	
            if((schedules_adv!='' )&&(adv_count=='0'))
            {
			  
                schedules_adv=schedules_adv.split("</br>");
                if(schedules_adv.length>1)
                {
                    $('.add_ad_schedule ').last().css("display","block");
                }
                for(f=0;f<schedules_adv.length;f++)
                {
                    var res1 = formate.replace("</br>","");
                    result_11=res1;
                    //   alert(res+'_f');        alert(schedules[f]);
                    res1=res1.split('_');
                    schedules_split1=schedules_adv[f].split('_');
                    if(res1[1]==schedules_split1[1])
                    {
                        $('#advancedPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                    }
                }
                if((arLen>(scd.length-1))&&(i==(arLen-1))){
								
                    $('#advancedPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                    schedules12=$('#changing_schedule_adv').val();
                    schedules12+='</br>'+result_11;
                    $('#changing_schedule_adv').val(schedules12);
                }
            }
            else if(($('#changing_schedule_decide_adv').val()=='1')&&(schedules=='' ))
            {
                
                var bases=$('#changing_schedule_adv_base').val();
                bases= bases.split('</br>');
                var myCars='';
                for(ba=0;ba<bases.length;ba++)
                {
                    base_res=bases[ba].split('_');
                    myCars+=base_res[1]+',';
                }
                //   alert(myCars);
                myCars.slice(0,-1);
                myCars=myCars.split(',');
                // alert(myCars);	 alert(popId);
                var ides=myCars.indexOf(popId);
                //alert(ides);
                if(ides==-1)	{
                    $('#advancedPriceDiv select.choose_schedule').append('<option name="'+(i+'yu')+'" id="'+(i+11)+'" value="' + formate + '">' + formate1+ '</option>');
                    schedules111=$('#changing_schedule_adv').val();
                    var res = formate.replace("</br>","");
                    schedules111+=res;
                    $('#changing_schedule_adv').val(schedules111);
                //     alert(schedules1+'anand');
                }
            }
			
            else if(adv_count!='0')
            {
                //    alert('else if');
		  
                var bases=$('#changing_schedule_adv_base').val();
                bases= bases.split('</br>');
                var myCars='';
                for(ba=0;ba<bases.length;ba++)
                {
                    base_res=bases[ba].split('_');
                    myCars=+base_res[1]+',';
                }
                //   alert(myCars);
                myCars.slice(0,-1);
                myCars=myCars.split(',');
                var ides=myCars.indexOf(popId);
		       
		           
	           
					 
                if(ides==-1)					// if  a new schedule adding after saving.
                {//alert('else if if');
                    $('#advancedPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                    var Schedules11=$('#changing_schedule_adv').val();
                    if(Schedules11=='')
                    {
                        Schedules11=formate1;
                    }
                    else{
                        Schedules11+='</br>'+formate1;
                    }
                    $('#changing_schedule_adv').val(Schedules11);
                }
                else{
                    schedules_adv=schedules_adv.split("</br>");
                    if(schedules_adv.length>1)
                    {
                        $('.add_ad_schedule ').last().css("display","block");
                    }
                    for(f=0;f<schedules_adv.length;f++)
                    {
                        var res1 = formate.replace("</br>","");
                        result_11=res1;
                        //   alert(res+'_f');        alert(schedules[f]);
                        res1=res1.split('_');
                        schedules_split1=schedules_adv[f].split('_');
                        if(res1[1]==schedules_split1[1])
                        {
                            $('#advancedPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                        }
                    }
                    if((arLen>(scd.length-1))&&(i==(arLen-1))){
									           
                        $('#advancedPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                        schedules12=$('#changing_schedule_adv').val();
                        schedules12+='</br>'+result_11;
                        $('#changing_schedule_adv').val(schedules12);
                    }
						       
						   
                }
					  
			    
			    
            }
            else{
                $('#advancedPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
			      
            }

			
			
			
			
			
			
        // $( ".choose_schedule" ).last().append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
        //$('select.choose_schedule').parent.appendChild('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
			
        }
			
        $('#total_schedule').val(yt);
    //var byt=yt.slice(0,-5);
			
    //$('#changing_schedule_net_base').val(byt);
			
			
			
    }
	
    else if(billing_type == "Whole Day"){
        var formate = '';
        var ar=$('#whole_day_tabs').val();
        var ar1=ar.split(',');
        var arLen = ar1.length;
        $('select.choose_schedule').html('<option value=""  selected="selected">--Choose--</option>');
        var yt='';
        for(a=0;a<arLen;a++)
        {
            popId=ar1[a];
			    
            $("#wholeday_summay_"+popId).css('display','block');
		
            var wday_1 = $("#wday_1_"+popId).val();
            var wday_2 = $("#wday_2_"+popId).val();
			    
            if(wday_1 == 1){
                var whole_start = $('#datestartwhole_1_'+popId).val();
                var whole_stime_1 = $('#whole_stime_1_'+popId).val();
                var firstVal_ws = whole_stime_1.charAt(0);
                if(firstVal_ws ==0){
                    whole_stime_1 = whole_stime_1.charAt(1)+whole_stime_1.charAt(2)+whole_stime_1.charAt(3)+whole_stime_1.charAt(4);
                }
                var whole_stime_2 = $('#whole_stime_2_'+popId).val();
                var whole_etime_1 = $('#whole_etime_1_'+popId).val();
                var firstVal_we = whole_etime_1.charAt(0);
                if(firstVal_we ==0){
                    whole_etime_1 = whole_etime_1.charAt(1)+whole_etime_1.charAt(2)+whole_etime_1.charAt(3)+whole_etime_1.charAt(4);
                }
                var whole_etime_2 = $('#whole_etime_2_'+popId).val();
					    
                formate = whole_start+", "+whole_stime_1+" "+whole_stime_2+" - "+whole_etime_1+" "+whole_etime_2+"_"+popId+"</br>";
            }
			    
            else if(wday_2 == 1){
                var camps_start = $('#datestcamps_1_'+popId).val();
                var camps_end = $('#dateencamps_2_'+popId).val();
				    
                var datestartcamps_1 = $('#datestartcamps_1_'+popId).val();
                var dateendcamps_2 = $('#dateendcamps_2_'+popId).val();
				    
                var camps_stime_1 = $('#camps_stime_1_'+popId).val();
                var firstVal_cs = camps_stime_1.charAt(0);
                if(firstVal_cs ==0){
                    camps_stime_1 = camps_stime_1.charAt(1)+camps_stime_1.charAt(2)+camps_stime_1.charAt(3)+camps_stime_1.charAt(4);
                }
                var camps_stime_2 = $('#camps_stime_2_'+popId).val();
                var camps_etime_1 = $('#camps_etime_1_'+popId).val();
                var firstVal_ce = camps_etime_1.charAt(0);
                if(firstVal_ce ==0){
                    camps_etime_1 = camps_etime_1.charAt(1)+camps_etime_1.charAt(2)+camps_etime_1.charAt(3)+camps_etime_1.charAt(4);
                }
                var camps_etime_2 = $('#camps_etime_2_'+popId).val();
			    
                if( camps_start == camps_end ) {
                    formate = datestartcamps_1+", "+camps_stime_1+" "+camps_stime_2+" - "+camps_etime_1+" "+camps_etime_2+"_"+popId+"</br>";
                }
                else{
                    formate = datestartcamps_1+", "+camps_stime_1+" "+camps_stime_2+" to "+dateendcamps_2+", "+camps_etime_1+" "+camps_etime_2+"_"+popId+"</br>";
                }
            }
            yt+=formate;
            var  formate1=formate.split("_");
            formate1=formate1[0];
				  
				  
				  
				 
            /*    var scd=$('#total_schedule').val();
			
            scd=scd.split('</br>');
            schedules=$('#changing_schedule_net').val();
			
			
			
            if(schedules!=''){
			    
                schedules=schedules.split("</br>");
                //alert(schedules+'_'+a);
                for(f=0;f<schedules.length;f++)
                {    var res = formate.replace("</br>","");
                    result_12=res;
                    //   alert(res+'_f');        alert(schedules[f]);
                    res=res.split('_');
                    schedules_split=schedules[f].split('_');
                    if(res[1]==schedules_split[1])
                    {
                        $('select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                    }
                }
                if((arLen>(scd.length-1))&&(i==(arLen-1))){
				    
                    $('select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                    schedules1=$('#changing_schedule_net').val();
                    schedules1+='</br>'+result_12;
                    $('#changing_schedule_net').val(schedules1);
                }
            }*/
			
            var scd=$('#total_schedule').val();
			
            scd=scd.split('</br>');
            schedules=$('#changing_schedule_net').val();
            var  net_count=  $('#changing_schedule_net_count').val();
            var  adv_count=  $('#changing_schedule_adv_count').val();
            var schedules111='';
	
			
            if((schedules!='' )&&(net_count=='0'))
            {
                // if this is the second time after hiting the continue button and same for others
			    
                schedules=schedules.split("</br>");
                if(schedules.length>1){
                    $('.out_add_schedule ').last().css("display","block");//for display add button and same for others
                }
                // checking the options are already added and same for others
                for(f=0;f<schedules.length;f++)
                {
                    var res = formate.replace("</br>","");
                    result_1=res;
                    res=res.split('_');
                    schedules_split=schedules[f].split('_');
                    if(res[1]==schedules_split[1])
                    {
                        $('#netPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
							
                    }
                }
                // if a new option is added (schedule added )     and same for others
                if((arLen>(scd.length-1))&&(i==(arLen-1)))
                {
							    
                    $('#netPriceDiv select.choose_schedule').append('<option name="'+(i+'yu')+'" id="'+(i+11)+'" value="' + formate + '">' + formate1+ '</option>');
                    schedules1=$('#changing_schedule_net').val();
                    schedules1+='</br>'+result_1;
                    $('#changing_schedule_net').val(schedules1);
                   					
                }
            }
            else if(($('#changing_schedule_decide').val()=='1')&&(schedules=='' ))
            {
                var bases=$('#changing_schedule_net_base').val();
                bases= bases.split('</br>');
                var myCars='';
                for(ba=0;ba<bases.length;ba++)
                {
                    base_res=bases[ba].split('_');
                    myCars+=base_res[1]+',';
                }
                //   alert(myCars);
                myCars.slice(0,-1);
                myCars=myCars.split(',');
                // alert(myCars);	 alert(popId);
                var ides=myCars.indexOf(popId);
                //alert(ides);
                if(ides==-1)	{
                    $('#netPriceDiv select.choose_schedule').append('<option name="'+(i+'yu')+'" id="'+(i+11)+'" value="' + formate + '">' + formate1+ '</option>');
                    schedules1=$('#changing_schedule_net').val();
                    var res = formate.replace("</br>","");
                    schedules1+=res;
                    $('#changing_schedule_net').val(schedules1);
                //    alert(schedules1+'anand');
                }
            }
			
            // after the saving of the schedules edit( save a copy function goes down) and same for others
            else if(net_count!='0')
            {
                //    alert('else if');
                var bases=$('#changing_schedule_net_base').val();
                bases= bases.split('</br>');
                var myCars='';
                for(ba=0;ba<bases.length;ba++)
                {
                    base_res=bases[ba].split('_');
                    myCars=+base_res[1]+',';
                }
                //   alert(myCars);
                myCars.slice(0,-1);
                myCars=myCars.split(',');
                var ides=myCars.indexOf(popId);
        
            

			  
                if(ides==-1)					// if  a new schedule adding after saving.
                {//alert('else if if');
                    $('#netPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                    var Schedules1=$('#changing_schedule_net').val();
                    if(Schedules1=='')
                    {
                        Schedules1=formate1;
                    }
                    else{
                        Schedules1+='</br>'+formate1;
                    }
                    $('#changing_schedule_net').val(Schedules1);
                }
                else{
                    //   alert('else if else');// else checking the old schedule after saveing
                    schedules=schedules.split("</br>");
                    //alert(schedules);
                    if(schedules.length>1){
                        $('.out_add_schedule ').last().css("display","block");//for display add button and same for others
                    }
                    // checking the options are already added and same for others
                    for(f=0;f<schedules.length;f++)
                    {//alert(f+"_kg");
                        var res = formate.replace("</br>","");
                        result_1=res;
                        res=res.split('_');
                        schedules_split=schedules[f].split('_');
                        if(res[1]!=schedules_split[1])
                        {
                            //alert(f);
                            $('#netPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                        }
                    }
                    // if a new option is added (schedule added )     and same for others
                    if((arLen>(scd.length-1))&&(i==(arLen-1))){
									  
                        //alert('it');
                        $('#netPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                        schedules1=$('#changing_schedule_net').val();
                        schedules1+='</br>'+result_1;
									    
                        $('#changing_schedule_net').val(schedules1);
                    }
				        
				    
                }
			   
			    
			    
            }
	          
			
            else{
                //   if this is the first time after hiting the continue button
                $('#netPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
            }
	
            /*else{
			      $('select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
			}
			
			/****************for advance price******************/
            schedules_adv=$('#changing_schedule_adv').val();
	
            if((schedules_adv!='' )&&(adv_count=='0'))
            {
			    
                schedules_adv=schedules_adv.split("</br>");
                if(schedules_adv.length>1)
                {
                    $('.add_ad_schedule ').last().css("display","block");
                }
                for(f=0;f<schedules_adv.length;f++)
                {
                    var res1 = formate.replace("</br>","");
                    result_11=res1;
                    //   alert(res+'_f');        alert(schedules[f]);
                    res1=res1.split('_');
                    schedules_split1=schedules_adv[f].split('_');
                    if(res1[1]==schedules_split1[1])
                    {
                        $('#advancedPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                    }
                }
                if((arLen>(scd.length-1))&&(i==(arLen-1))){
								
                    $('#advancedPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                    schedules12=$('#changing_schedule_adv').val();
                    schedules12+='</br>'+result_11;
                    $('#changing_schedule_adv').val(schedules12);
                }
            }
            else if(($('#changing_schedule_decide_adv').val()=='1')&&(schedules=='' ))
            {
                var bases=$('#changing_schedule_adv_base').val();
                bases= bases.split('</br>');
                var myCars='';
                for(ba=0;ba<bases.length;ba++)
                {
                    base_res=bases[ba].split('_');
                    myCars+=base_res[1]+',';
                }
                //   alert(myCars);
                myCars.slice(0,-1);
                myCars=myCars.split(',');
                // alert(myCars);	 alert(popId);
                var ides=myCars.indexOf(popId);
                //alert(ides);
                if(ides==-1)	{
                    $('#advancedPriceDiv select.choose_schedule').append('<option name="'+(i+'yu')+'" id="'+(i+11)+'" value="' + formate + '">' + formate1+ '</option>');
                    schedules111=$('#changing_schedule_adv').val();
                    var res = formate.replace("</br>","");
                    schedules111+=res;
                    $('#changing_schedule_adv').val(schedules111);
                //     alert(schedules1+'anand');
                }
            }
			
            else if(adv_count!='0')
            {
                //    alert('else if');
                var bases=$('#changing_schedule_adv_base').val();
                bases= bases.split('</br>');
                var myCars='';
                for(ba=0;ba<bases.length;ba++)
                {
                    base_res=bases[ba].split('_');
                    myCars=+base_res[1]+',';
                }
                //   alert(myCars);
                myCars.slice(0,-1);
                myCars=myCars.split(',');
                var ides=myCars.indexOf(popId);
		       
		           
	           
					 
                if(ides==-1)					// if  a new schedule adding after saving.
                {//alert('else if if');
                    $('#advancedPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                    var Schedules11=$('#changing_schedule_adv').val();
                    if(Schedules11=='')
                    {
                        Schedules11=formate1;
                    }
                    else{
                        Schedules11+='</br>'+formate1;
                    }
                    $('#changing_schedule_adv').val(Schedules11);
                }
                else{
                    schedules_adv=schedules_adv.split("</br>");
                    if(schedules_adv.length>1)
                    {
                        $('.add_ad_schedule ').last().css("display","block");
                    }
                    for(f=0;f<schedules_adv.length;f++)
                    {
                        var res1 = formate.replace("</br>","");
                        result_11=res1;
                        //   alert(res+'_f');        alert(schedules[f]);
                        res1=res1.split('_');
                        schedules_split1=schedules_adv[f].split('_');
                        if(res1[1]==schedules_split1[1])
                        {
                            $('#advancedPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                        }
                    }
                    if((arLen>(scd.length-1))&&(i==(arLen-1))){
									           
                        $('#advancedPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
                        schedules12=$('#changing_schedule_adv').val();
                        schedules12+='</br>'+result_11;
                        $('#changing_schedule_adv').val(schedules12);
                    }
						       
						   
                }
					  
			    
			    
            }
            else{
                $('#advancedPriceDiv select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
			      
            }

				 
				 
				 
				  
        //$('select.choose_schedule').append('<option name="'+(i+1)+'" id="'+(i+1)+'" value="' + formate + '">' + formate1+ '</option>');
        // $("#wholeday_summay_"+popId+" #dateSummay").html(format);
        }
			
        $('#total_schedule').val(yt);
    }
	
	
}

/*******************discTypeChanged  function ends*****************/

/**************************************
		      date calculate function start
 ************************************/

function date_calculate(net,id1,id2,id3){
    if(net=='net'){
        var id=net+"_"+id1+"_"+id2+"_"+id3;
        $("#ad_valid_date_"+id).val(new Date());
        $("#ad_valid_date_alt_"+id).val( formatDates());
    }
    else{
        var id=id1+"_"+id2+"_"+id3;
        $("#ad_valid_date_"+id).val(new Date());
        $("#ad_valid_date_alt_"+id).val(formatDates());
    }
    $("#ad_valid_date_"+id).datepicker({
        showOn : "button",
        buttonImage : "/assets/create_new_activity/date_icon.png",
        buttonImageOnly : true,
        minDate: 0,
        dateFormat: "D, M d, yy",
        altField : "#ad_valid_date_alt_"+id,
        altFormat : "yy-m-d"
		   
    });
	 
}
function formatDates(){
    var d = new Date();
    var curr_date = d.getDate();
    var curr_month = d.getMonth() + 1; //Months are zero based
    var curr_year = d.getFullYear();
    return (curr_year  + "-" + curr_month + "-" + curr_date);
}

/*******************date calculate function ends*****************/



	
/********************************************************************************************
	 
		        save the new activity function starts
		        
 *********************************************************************************************/
function save_the_schedule()
{
	    
	    
    var descion= $('#descion_id').val();
    var billing_type_sc= $('#billing_type_sc').val();
    var biling_type = $("#billing_type").val();
	    
    if((billing_type_sc=='1')||(billing_type_sc=='4'))
    {
        if (descion=='net')
        {
            var loop=$("#save_result").val();
            var  sp=loop.split(',');
			   
            for(var i=0;i<sp.length;i++)
            {
                var t1=sp[i].split('_');
                b=t1[0];
                q=t1[1];
                h=t1[2];
                var select_box='ad_discount_type_net_'+b+'_'+q+'_'+h;
                var e = document.getElementById(select_box);
                var strSelected = e.options[e.selectedIndex].value;
                if(strSelected!=""){
						
                    var net='net_';
                    var yes=validate_early_bid(net,b,q,h,0,0,'');
                    if (yes=='0'){
                        break;
                    }
                }
                else if(strSelected=="Multiple Session Discount"){
                    var net='net';
                    var yes=validate_session(net,b,q,h,0,0,'');
                    if (yes=='0'){
                        break;
                    }
                }
                else if(strSelected=="Multiple Participant Discount"){
                    var net='net';
                    var yes=validate_participant(net,b,q,h,0,0,'');
						
                    if (yes=='0'){
                        break;
                    }
                }
                else{
			     
		 var net='net';
                    var yes=validate_nothing_selected(net,b,q,h,0,0,'');
                    if(yes=='0'){
                        break;
                    }
					        
                }
					
            }
            if(yes==1){
                check_s=sp[(sp.length-1)];
                check_s=check_s.split('_');
                if(check_s[0]=='1')
                {
                    var t_schedules=$('#total_schedule').val();
                    var    get_values=t_schedules.slice(0,-5);
                }
                else{
                    var get_values=$('#changing_schedule_net').val();
						        
                }
                //choose_schedules( check_s[0],'net');
                //var get_values=$('#changing_schedule_net').val();
                get_values=get_values.split('</br>');
                //alert(get_values.length);
                var select_box12='choose_schedule_net_'+check_s[0]+'_1';
                var e12 = document.getElementById(select_box12);
                //     var strSelected12 = e12.options[e12.selectedIndex].value;
                var strSelected12 =$('#selected_net_value_'+check_s[0]).val();
                // alert(strSelected12);
                if((get_values.length==1)&&(strSelected12!=''))
                {
                    strSelected12=strSelected12.split('_');
                    strSelected12[1]=strSelected12[1].replace("</br>","");
                    $('#chosen_sc_'+check_s[0]+'_1').val(strSelected12[1]);
				    
                    get_values.splice(0, 1);
                    $('#changing_schedule_net').val(get_values);
                }
                if (get_values.length>0)
                //   if( (strSelected12!="select all_0")&&(get_values.length>0))
                {
                    $('#saving_error').css("display","block");
                    //alert('error');
                    return false;
                }
                else{
                    $('#saving_error').css("display","none");
                    sp2=loop.split(',');
                    var select_box12='choose_schedule_net_'+check_s[0]+'_1';
                    var e12 = document.getElementById(select_box12);
                    // var strSelected12 = e12.options[e12.selectedIndex].value;
                    var strSelected12 =$('#selected_net_value_'+check_s[0]).val();
			     
                    var t2=sp2[(sp2.length)-1].split('_');
                    strSelected12=strSelected12.split('_');
                    s=t2[0];
                    $( "#choose_schedule_net_"+s+"_1" ).removeClass( "choose_schedule" );
                    //    choose_schedules(s,'net') ;
                    //    strSelectedw1= strSelectedw.split('_')
                    $( "#choose_schedule_net_"+s+"_1" ).css( "display"," none"  );
                    $(' .setWidthPrice3').css( "display"," none"  );
                    $( "#chosen_sc_txt_"+s+"_2_0" ).css( "display"," block"  );
                    $( "#chosen_sc_txt_"+s+"_2_0" ).text( "Chosen Schedule" );
                    $( "#chosen_sc_txt_"+s+"_1_0" ).css( "display"," block"  );
                    $( "#chosen_sc_txt_"+s+"_1_0" ).text( strSelected12[0]  );
				
				  
                    return true;
                }
            }
        }
        else if (descion=='adv')
        {
            var loop=$("#result_save").val();
            sp=loop.split(',');
            for(var i=0;i<sp.length;i++)
            {
                var t1=sp[i].split('_');
                b=t1[0];
                q=t1[1];
                h=t1[2];
                var select_box='ad_discount_type_'+b+'_'+q+'_'+h;
                var e = document.getElementById(select_box);
                var strSelected = e.options[e.selectedIndex].value;
                if(strSelected!=""){
						
                    var net='';
                    var yes=validate_early_bid(net,b,q,h,0,0,'');
                    if (yes=='0'){
                        break;
                    }
                }
                else if(strSelected=="Multiple Session Discount"){
                    var net='';
                    var yes=validate_session(net,b,q,h,0,0,'');
                    if (yes=='0'){
                        break;
                    }
						
                }
                else if(strSelected=="Multiple Participant Discount"){
                    var net='';
                    var yes=validate_participant(net,b,q,h,0,0,'');
						
                    if (yes=='0'){
                        break;
                    }
						
                }
                else{
			       
                    var net='';
                    var yes=validate_nothing_selected(net,b,q,h,0,0,'');
                    if(yes=='0'){
                        break;
                    }
					        
                }
            }
            if(yes==1){
                check_s=sp[(sp.length-1)];
                check_s=check_s.split('_');
			        
                // choose_schedules( check_s[0],'adv');
                if(check_s[0]=='1'){
                    var t_schedules=$('#total_schedule').val();
						      
                    var    get_values=t_schedules.slice(0,-5);
                }
                else{
                    var get_values=$('#changing_schedule_adv').val();
							      
                }
				
                //var get_values=$('#changing_schedule_adv').val();
                get_values=get_values.split('</br>');
                var select_box12='choose_schedule_'+check_s[0]+'_1';
                var e12 = document.getElementById(select_box12);
                //  var strSelected12 = e12.options[e12.selectedIndex].value;
                var strSelected12 =$('#selected_value_'+check_s[0]).val();
			     
                if((get_values.length==1)&&(strSelected12!=''))
                {
                    strSelected12=strSelected12.split('_');
                    //alert("#chosen_sc_"+check_s[0]+"_0");
                    strSelected12[1]=strSelected12[1].replace("</br>","");
                    $('#chosen_ad_sc_'+check_s[0]+'_1').val(strSelected12[1]);
                    get_values.splice(0, 1);
                    $('#changing_schedule_adv').val(get_values);
                }
                if (get_values.length>0)
                //    if( (strSelected12!="select all_0")&&(get_values.length>1))
                {
			          
                    $('#saving_error').css("display","block");
				
                    return false;
                }
                else{
                    $('#saving_error').css("display","none");
                    sp2=loop.split(',');
                    var select_box12='choose_schedule_'+check_s[0]+'_1';
                    var e12 = document.getElementById(select_box12);
                    var strSelected12 = e12.options[e12.selectedIndex].value;
                    var t2=sp2[(sp2.length)-1].split('_');
                    strSelected12=strSelected12.split('_');
                    s=t2[0];
				       
                    $( "#choose_schedule_"+s+"_1" ).css( "display","none" );
                    $( "#setWidthPrice3_"+s ).css( "display","none" );
			          
                    $( "#schedule_heading_"+s ).css( "display","block" );
                    $( "#selected_schedule_ad_"+s ).css( "display","block" );
			          
                    //  strSelectedw=strSelectedw.split('_');
                    $( "#selected_schedule_ad_"+s ).text( strSelected12[0]);
			          
                    $( "#choose_schedule_"+s+"_1" ).removeClass( "choose_schedule" );
						   
				
                    return true;
                }
            }
        }
		           
        else{
            yes='1';
		
        }
		        
		        
    }
    /////////////second part of billing type/////////////
    else{
	  
        if (descion=='net'){
		    
            fst_id=1;
            sec_id=1;
            opt='validation';
            var multiple_discount_count=$('#multiple_discount_count_net_1_1').val();
		    
            multiple_discount_count=multiple_discount_count.split(',');
            if(multiple_discount_count.length>1){
                // alert(multiple_discount_count.length);
                for(var i=0;i<multiple_discount_count.length;i++)
                {
                    var select_box='ad_discount_type_net_'+multiple_discount_count[i]+'_1';
				   
                    var e = document.getElementById(select_box);
                    var strSelected = e.options[e.selectedIndex].value;
                    if(strSelected=="Early Bird Discount"){
					
                        var yes=validate_early_bid_anytime('net',fst_id,sec_id,opt);
                        if(yes=='f'){
                            break;
                        }
                        else{
                            yes=1;
                        }
                    }
                    else if(strSelected=="Multiple Session Discount"){
				    
                        var yes= validate_session_anytime('net',fst_id,sec_id,opt);
                        if(yes=='f'){
                            break;
                        }
                        else{
                            yes=1;
                        }
				       
                    }
                    else if(strSelected=="Multiple Participant Discount"){
                        var yes=validate_participant_anytime('net',fst_id,sec_id,opt);
                        if(yes=='f'){
                            break;
                        }
                        else{
                            yes=1;
                        }
				     

                    }
			           
                    else{
                        var yes= nothing_is_selected('net',fst_id,sec_id,opt);
                        if(yes=='f'){
                            break;
                        }
                        else{
                            yes=1;
                        }
                    }
			           
                }
            }
            else{
                if(($('#price').val()== "" )||($('#price').val()== "Net Amount" )){
                    $('#price').css("border","1px solid #BDD6DD");
                    $('#price').css("color","#999999");
                    $('#net_price_error').css("display","block");
                    $('#net_price_error').text("please enter price");
                }
                else{
                    yes=1;
                }
		 
            }
        }
	         
        else if (descion=='adv'){
		        
            fst_id=1;
            //sec_id=1;
            opt='validation';
            var multiple_discount_count=$('#advance_price_count_anys').val();
		    
            multiple_discount_count=multiple_discount_count.split(',');
            // alert(multiple_discount_count);
            for(var i=0;i<multiple_discount_count.length;i++)
            {
                var select_box='ad_discount_type_1_'+multiple_discount_count[i];
                var  sec_id=multiple_discount_count[i];
				   
                var e = document.getElementById(select_box);
                var strSelected = e.options[e.selectedIndex].value;
                if(strSelected=="Early Bird Discount"){
					
                    var yes=validate_early_bid_anytime('',fst_id,sec_id,opt);
                    if(yes=='f'){
                        break;
                    }
                    else{
                        yes=1;
                    }
                }
                else if(strSelected=="Multiple Session Discount"){
				    
                    var yes= validate_session_anytime('',fst_id,sec_id,opt);
                    if(yes=='f'){
                        break;
                    }
                    else{
                        yes=1;
                    }
				       
                }
                else if(strSelected=="Multiple Participant Discount"){
                    var yes=validate_participant_anytime('',fst_id,sec_id,opt);
                    if(yes=='f'){
                        break;
                    }
                    else{
                        yes=1;
                    }
				     

                }
                else{
                    var yes= nothing_is_selected('',fst_id,sec_id,opt);
                    if(yes=='f'){
                        break;
                    }
                    else{
                        yes=1;
                    }
                }
            }
	    
        }
        else{
            yes='1';
		
        }
	        
    }
	
	
    return  yes;
	    
}
	
	
	
	
/*********************************************************
				
					    Function adding changing whole div  starts
				
 **********************************************************/
function choose_schedule(s,net) {
		   
		   
    if(net=='net'){
        var select_box12='choose_schedule_net_'+s+'_1';
				 
        var e12 = document.getElementById(select_box12);
        var strSelected12 = e12.options[e12.selectedIndex].value;
        strSelected12= strSelected12.replace("</br>","");
        
        $('#selected_net_value_'+s).val('');
        $('#selected_net_value_'+s).val(strSelected12);
        if(strSelected12=="select all_0"){
		      
            $("#o_add_schedule_"+s).css("display","none");
        }
        else{
            $('#o_add_schedule_'+s).css('display','block');
        }
				
        if(s=='1'){
            var t_schedules=$('#total_schedule').val();
				    
            t_schedules=t_schedules.slice(0,-5);
        }
        else{
            var t_schedules=$('#changing_schedule_net').val();
					    
        }
			        
        schedules=t_schedules.split("</br>");
		    
        if(schedules.length==1)
        {
            $("#o_add_schedule_"+s).css("display","none");
									        
        }
        else{
            $("#o_add_schedule_"+s).css("display","block");
        }
    }
		    
    else{

        var select_box12='choose_schedule_'+s+'_1';
        var e12 = document.getElementById(select_box12);
        var strSelected12 = e12.options[e12.selectedIndex].value;
        strSelected12= strSelected12.replace("</br>","");
        $('#selected_value_'+s).val('');
        $('#selected_value_'+s).val(strSelected12);
        if(strSelected12=="select all_0"){
		      
            $("#add_ad_schedule_"+s).css("display","none");
        }
        else{
            $('#add_ad_schedule_'+s).css('display','block');
        }
				
        if(s=='1'){
            var t_schedules=$('#total_schedule').val();
				    
            t_schedules=t_schedules.slice(0,-5);
        }
        else{
            var t_schedules=$('#changing_schedule_adv').val();
					    
        }
			        
        schedules=t_schedules.split("</br>");
		    
        if(schedules.length==1)
        {
            $("#add_ad_schedule_"+s).css("display","none");
									        
        }
        else{
            $("#add_ad_schedule_"+s).css("display","block");
        }
		            
    }
}

function choose_schedules(s,net) {
    
    if(s=='1'){
        var t_schedules=$('#total_schedule').val();
		
        t_schedules=t_schedules.slice(0,-5);
    }
    else{
        var t_schedules=$('#changing_schedule_'+net).val();
		
    }
	     
	     
    if(net=='net'){
        var select_box12='choose_schedule_net_'+s+'_1';
		 
        var e12 = document.getElementById(select_box12);
        var strSelected12 = e12.options[e12.selectedIndex].value;
        strSelected12= strSelected12.replace("</br>","");
		            
        t_schedules1=t_schedules.split("</br>");
        var index1 = t_schedules1.indexOf(strSelected12);
		
        if (index1 > -1)
        {
            t_schedules1.splice(index1, 1);
        }
				        
        var t_schedules11='';
        if(strSelected12=="select all_0"){
				
					
				
            t_schedules=t_schedules.split("</br>");
            for(f=1;f<t_schedules.length;f++)
            {
                t_schedules5=t_schedules[f].split('_');
                t_schedules11+=t_schedules5[1]+',';
            }
            $('#chosen_sc_'+s+'_1').val(t_schedules11);
					
            $('#all_sc_'+s+'_1_0').val(t_schedules11);
					
				   
					
        }
			    
        else{
            strSelected12=strSelected12.split('_');
			      
            $('#chosen_sc_'+s+'_1').val(strSelected12[1]);
				
            $('#all_sc_'+s+'_1_0').val(strSelected12[1]);
			        
        }
			        
        var t_schedules2='';
        var index2 = t_schedules1.indexOf("select all_0");
			
        if((index2>-1)&&(t_schedules1.length==2)){
            t_schedules1.splice(index2, 1);
        }
			
        for(var z=0;z<(t_schedules1.length);z++){
			 
            if(z==(t_schedules1.length-1)){
                t_schedules2+=t_schedules1[z];
            }
            else{
                t_schedules2+=t_schedules1[z]+'</br>';
            }
        }
			
        //    if(t_schedules1.length>2){
        //	t_schedules2=t_schedules2.slice(0,-5);
        //    }
        $('#changing_schedule_net').val(t_schedules2);
			
        if((strSelected12=="select all_0")||(t_schedules1.length==1)){
	      
            $("#o_add_schedule_"+s).css("display","none");
        }
        else{
            $('#o_add_schedule_'+s).css('display','block');
        }
		    
    }
	     
    else{
	       
        var t_schedules11='';
        var select_box12='choose_schedule_'+s+'_1';
        var e12 = document.getElementById(select_box12);
        //     var strSelected12 = e12.options[e12.selectedIndex].value;
        var strSelected12=$('#selected_value_'+s).val();
        strSelected12= strSelected12.replace("</br>","");
        //     $('#selected_value_'+s).val('');
        //	$('#selected_value_'+s).val(strSelected12);
        t_schedules1=t_schedules.split("</br>");
		          
        var index1 = t_schedules1.indexOf(strSelected12);
        if (index1 > -1) {
            t_schedules1.splice(index1, 1);
        }
        //  alert(t_schedules1)     ;
        if(strSelected12=="select all_0"){
            t_schedules=t_schedules.split("</br>");
            for(f=0;f<t_schedules.length-1;f++)
            {
                t_schedules5=t_schedules[f].split('_');
                t_schedules11+=t_schedules5[1]+',';
            }
            $('#chosen_ad_sc_'+s+'_1').val(t_schedules11);
        }
				       
        else{
            strSelected12=strSelected12.split('_');
				         
            $('#chosen_ad_sc_'+s+'_1').val(strSelected12[1]);
				           
        }
			
        var t_schedules2='';
        var index2 = t_schedules1.indexOf("select all_0");
        if((index2>-1)&&(t_schedules1.length==2))
        {
            t_schedules1.splice(index2, 1);
        }
				   
        for(var z=0;z<(t_schedules1.length);z++){
            if(z==(t_schedules1.length-1)){
                t_schedules2+=t_schedules1[z];
            }
            else{
                t_schedules2+=t_schedules1[z]+'</br>';
            }
			       
        }
        //alert(t_schedules2)     ;
			   
        //  if(t_schedules1.length>2){
        //          t_schedules2=t_schedules2.slice(0,-5);
        //  }
        // alert(t_schedules1.length+'sc');
        $('#changing_schedule_adv').val(t_schedules2);
        if((strSelected12=="select all_0")||(t_schedules1.length==1)){
		     
            $("#add_schedule_"+s).css("display","none");
        }
        else{
            $('#add_schedule_'+s).css('display','block');
        }
			       
    }
}




/*********************************************************
				
					    Function Adding and Editing Net Price whole div  starts
				
 **********************************************************/

function validate_notes_netprice(s)
{	
    net='net';
    var e = document.getElementById('billing_type');
    var strSelected = e.options[e.selectedIndex].value;
    if(strSelected=="Schedule"){
        var cont_inue= $('#net_continue_sc').val();
	   
    }
    else{
        var cont_inue= $('#net_continue_wsc').val();
    }
    if((s=='0')&&(cont_inue=='0')){
     
        $('#netPriceDiv .priceContainer').remove();
        var netPriceDiv='';
        var append_sc='';
   
        var schedules=$('#total_schedule').val();
        schedules=schedules.slice(0,-5);
        schedules=schedules.split("</br>");				    
        for(k=0;k<schedules.length;k++)
        {
            sc_hed=schedules[k].split('_');
            append_sc+= '<option  id="'+k+'" value="' + schedules[k] + '">' + sc_hed[0] + '</option>';
        }
        s++;
       
        netPriceDiv+='<div><div class="priceContainer" id="netPriceDiv_'+s+'"><input id="earlybid_decide_'+s+'" type="hidden" value="0" name="earlybid_decide_'+s+'"><input id="selected_net_value_'+s+'" type="hidden" value="" name="selected_value_'+s+'"><input type="hidden" name="last_in_discount_id_'+s+'" id="last_in_discount_id_'+s+'" value=""><table cellpadding="0" cellspacing="0" border="0"><tr><td><div class="priceOuterDiv" id="net_priceOuterDiv_'+s+'">';
        netPriceDiv+='<table cellpadding="0" cellspacing="0" border="0" id="net_price_div_1_'+s+'"><tr><td id="added_price_'+s+'"><table cellspacing="0" cellpadding="0" border="0"><tr><td><div class="lt  advancedPriceContainer" id="advancedPriceContainer_'+s+'_1" ><div id="chosen_sc_txt_'+s+'_2_0" style="display: none;" class="choosen_head"></div><div class="chosen_op"  id="chosen_sc_txt_'+s+'_1_0" style="display: none;" ></div><div class="priceRow1_top" style="padding-top:0px;"><div class="lt blackText setWidthPrice3">Choose Schedule</div><div class="lt blackText setWidthPrice"> Net Price</div><div class="clear"></div></div>';
        netPriceDiv+='<div class="priceRow1_bottom"> <div class="lt"><select name="choose_schedule_net_'+s+'_1 " onchange="choose_schedule('+s+',\'net\')" id="choose_schedule_net_'+s+'_1" class="drop_down_left width_set7 choose_schedule" style="margin-left: 0px;"><option value="" selected="selected">--Choose--</option></select><input type="text" id="chosen_sc_txt_'+s+'_1_0"  size="30"  readonly="readonly" class="lt textbox1" name="chosen_sc_txt_1_1_4" value="" style="display: none;"><input type="hidden" id="chosen_sc_'+s+'_1" name="chosen_sc_'+s+'_1" value=""><input type="hidden" id="all_sc_'+s+'_1_0" name="all_sc_'+s+'_1_0" value=""/></div><input type="text" id="price_'+s+'_1" name="price_'+s+'_1" class="lt textbox" value="Enter Price" onfocus="focusChangeBorderColor1(\'price_'+s+'_1\')" maxlength="7" onKeyPress="return number(event);" onblur="blurChangeBorderColor1(\'price_'+s+'_1\')" style="width:152px;margin-left: 6px;" />';
				
        netPriceDiv+='<div class="clear"></div></div>';
        netPriceDiv+='<div class="clear"></div> <input type="hidden" name="multiple_discount_count_net_1_'+s+'_1" id="multiple_discount_count_net_1_'+s+'_1" value=""/><div class="createDynamicDiscount_net_1_1"></div><div class="clear"></div>';
        netPriceDiv+='<div id="staticDiscount_net_1_1_0_1">';
			 
        /*
        netPriceDiv+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type_net" id="discount_type_net_'+s+'_1_0"><select name="ad_discount_type_net_'+s+'_1_0" id="ad_discount_type_net_'+s+'_1_0" class="drop_down_left width_set6" onchange="discTypeChanged(\'net\','+s+',1,0,this.value,1);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'net\',1,1,this.value)"> <option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="2">Early Bird Discount</option><option value="3">Multiple Participant Discount</option><option value="createnew"> Create new</option></select></div><div class="create_new" onclick="open_createnew_discoption()"><b>+&nbsp;create new</b></div>';
        netPriceDiv+='<div id="session_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li></ul></li></ul><div class="clear"></div></div></div>';
        netPriceDiv+='<input type="text" id="ad_no_sess_net_'+s+'_1_0" name="ad_no_sess_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        netPriceDiv+='<input type="text" id="ad_discount_sess_price_net_'+s+'_1_0" name="ad_discount_sess_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
			
        netPriceDiv+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_net_'+s+'_1_0" id="ad_discount_sess_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
        netPriceDiv+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_session(\''+net+'\','+s+',1,0,0,1)"  id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" style="display:block; position:relative;left:10px;"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_session_error_net_'+s+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
        netPriceDiv+='<div id="participant_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
        netPriceDiv+='<input type="text" id="ad_no_part_net_'+s+'_1_0" name="ad_no_part_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
		
        netPriceDiv+='<input type="text" id="ad_discount_part_price_net_'+s+'_1_0" name="ad_discount_part_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        netPriceDiv+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_net_'+s+'_1_0" id="ad_discount_part_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option> <option value="%">%</option></select></div>';
        netPriceDiv+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_participant(\''+net+'\','+s+',1,0,0,1)" id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" style="display:block; position:relative;left:10px;"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
        netPriceDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_net_'+s+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div> ';
		
        netPriceDiv+='<div class="clear"></div><div id="early_brid_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
        netPriceDiv+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText" style="width:154px" >Valid  Until</div><div class="lt blackText setWidthDiscount" id="no_part_net_'+s+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
        netPriceDiv+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_net_'+s+'_1_0" name="ad_no_subs_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        netPriceDiv+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_net_'+s+'_1_0" name="ad_valid_date_net_'+s+'_1" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_net_'+s+'_1_0" name="ad_valid_date_alt_net_'+s+'_1_0" value="" /></div></div>    ';
		
        netPriceDiv+='<input type="text" id="ad_discount_price_net_'+s+'_1_0" name="ad_discount_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        netPriceDiv+='<div class="lt price_type"><select name="ad_discount_price_type_net_'+s+'_1_0" id="ad_discount_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
        netPriceDiv+='<div class="lt add_delete_icons" id="early_bid_icons_net_'+s+'_1_0"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" title="" onClick="validate_early_bid(\''+net+'\','+s+',1,0,0,1)" style="display:block; position:relative;left:10px;" class="lt addButton_net_'+b+'_1 single_add_net_'+b+'_1_0"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
        netPriceDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_net_'+s+'_1_0"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div>';
		    
	*/
        netPriceDiv+='<div class="errorDiv" style="display:none;"><div id="net_advance_error_1_'+s+'_1"></div></div><div class="clear"></div></div>';
        //netPriceDiv+='  <td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+s+'_1"> <div class="delete_schedule delete_schedule_'+s+'" id="inn_delete_schedule_'+s+'_1"style="margin-top:0px;display:none" onclick="delete_in_net_price('+s+',1)">&nbsp;</div><div onclick="add_net_advanced_price('+s+',1)" id="add_schedule_1" style="margin-top: 0px; display: block;" class="add_schedules add_schedules_'+s+'">&nbsp;</div> </div></td>';
				
				
        netPriceDiv+='</tr></table><div class="clear"></div></td></tr></table><div class="clear"></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="neprice_error_net_'+s+'_1"></div></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
				
        netPriceDiv+='<div class="Recuring_billing"><table  border="0"><tr>';
        netPriceDiv+='<td width="165" valign="middle"><span class="left_billing_img"><span id= "img_show_'+s+'"class="select_billing_img_show" onclick="select_range_billing(0,'+s+')"></span><span id="img_hide_'+s+'" class="select_billing_img_hide" onclick="select_range_billing(1,'+s+')"></span></span><span class="select_billing_content">enable recurring billing</span></td>';
        netPriceDiv+='<td><span class="inner">actuall billing will be base on  final discounted price if applicable</span></td></tr></table>';
        netPriceDiv+='<div class="dynamicAdvancedPrice"></div><table  class="recurring_slide_dwon" id="recurring_slide_dwon_'+s+'" border="0" >';
        netPriceDiv+='<tr><td width="200" valign="middle"><span class="terms">weekly</span></td> <td width="200" valign="middle"><div class="no_of">No.of  weeks</div><div class="cou_nts">48</div></td><td width="200" valign="middle"><span class="no_of">amount</span><span class="cou_nts">$ 8</span></td></tr>';
        netPriceDiv+='<tr><td ><span class="terms">monthly</span></td> <td><div class="no_of">No.of months</div><div class="cou_nts">24</div></td><td><span class="no_of">amount</span><span class="cou_nts">$ 8</span></td></tr>';
        netPriceDiv+='<tr><td><span class="terms">quartely</span></td> <td><div class="no_of">No.of terms</div><div class="cou_nts">8</div></td><td><span class="no_of">amount </span><span class="cou_nts">$ 8</span></td></tr></table></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
				
        netPriceDiv+='<div class="notesDiv"><textarea name="net_notes_'+s+'_1" id="net_notes_'+s+'_1" rows="10" cols="40"  class="lt textbox descTextbox" style="height:50px; width:485px;" onfocus="if(this.value==\'Notes:\'){this.value=\'\';$(this).css(\'color\',\'#444444\');}" onblur="if(this.value==\'\'){this.value=\'Notes:\';$(this).css(\'color\',\'#999999\');}" >Notes:</textarea><div class="clear"></div></div>';
        netPriceDiv+='<div class="clear"></div></div></td><td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+s+'"><div class="delete_schedule_net" id="o_delete_schedule_'+s+'"  style="margin-top:0px;" onclick="delete_net_price('+s+',0)">&nbsp;</div><div  onClick="validate_notes_netprice('+s+')" id="o_add_schedule_'+s+'"  style="margin-top:0px;"class="out_add_schedule">&nbsp;</div></div>';
        netPriceDiv+='<div class="clear"></div></td></tr></table></div> </div><div class="clear"></div><input type="hidden" name="last_discount_id_'+s+'_1" id="last_discount_id_'+s+'_1" value="0"><input type="hidden" name="delete_discount_id_'+s+'_1" id="delete_discount_id_'+s+'_1" value=""></div>';
        
        $("#netPriceDiv").append(netPriceDiv);
	$("#save_result").val('');// intilizing the total divs created ;
	$("#delete_discount_id_1_1").val('');// intilizing the delete the divs created;
        // $(netPriceDiv).appendTo ("#netPriceDiv");
        $.ajax({
            type: "POST",
            url: "activity_detail/create_first_discount_type",
            data:{
                "net":"net_",
                "id1":s,
                "id2":1,
                "id3":0
            },
            success: function(html){
                $("#advancedPriceContainer_"+s+"_1").append(html);
		
            } 
        });

        //  $("#netPriceDiv").appendTo(netPriceDiv);
        $("#o_delete_schedule_1").css("display","none");
        $("add_schedule_"+s).css("display","block");
        $("#choose_schedule_net_1_1").append(append_sc);
	
    }

    else{

        var append_sc='';	   
	
        var ew = document.getElementById("choose_schedule_net_"+s+"_1");
        var strSelectedw = ew.options[ew.selectedIndex].value;
	
		
        var netPriceDiv='';
        var h1=$("#last_in_discount_id_"+s).val();
        var sd=h1.split(",")
        for(var i=0;i<sd.length;i++){
            //alert(sd[i]);
            var select_box='ad_discount_type_net_'+sd[i];
            h1=sd[i].split("_");
            var b=s;
            var q=h1[1];
            var h=h1[2];
            var e = document.getElementById(select_box);
            var strSelected = e.options[e.selectedIndex].value;
			
            if(strSelected!=""){// if selected something in dropdwon 
                var net='net_';
		
              var yes=validate_early_bid(net,b,q,h,0,0,'');
                if(yes=='0'){
                    break;
                }
		yes=1;		
            }
           /* else if(strSelected=="Multiple Session Discount"){
                var net='net';
                var yes=validate_session(net,b,q,h,0,0,'');
                //alert(yes+"ms");
                if(yes=='0'){
                    break;
                }
				
            }
            else if(strSelected=="Multiple Participant Discount"){
                var net='net';
                var yes=validate_participant(net,b,q,h,0,0,'');
                //alert(yes+"mp");
                if(yes=='0'){
                    break;
                }
				
            }*/
            else{
			   
                var net='net';
			    
                var yes=validate_nothing_selected(net,b,q,h,0,0,'');
                if(yes=='0'){
                    break;
                }
				
            }
        }
		
	  
			
        if(yes==1){
            var  yt=$('#total_schedule').val();
            var byt=yt.slice(0,-5);
            $('#changing_schedule_net_base').val(byt);
            $( "#choose_schedule_net_"+s+"_1" ).removeClass( "choose_schedule" );
            choose_schedules(s,'net') ;
            strSelectedw1= strSelectedw.split('_')
            $( "#choose_schedule_net_"+s+"_1" ).css( "display"," none"  );
            $(' .setWidthPrice3').css( "display"," none"  );
            $( "#chosen_sc_txt_"+s+"_2_0" ).css( "display"," block"  );
            $( "#chosen_sc_txt_"+s+"_2_0" ).text( "Chosen Schedule" );
            $( "#chosen_sc_txt_"+s+"_1_0" ).css( "display"," block"  );
            $( "#chosen_sc_txt_"+s+"_1_0" ).text( strSelectedw1[0]  );
            $('#changing_schedule_decide').val('');
            $('#changing_schedule_decide').val('1');
					
				       
            //   $( "#choose_schedule_net_"+s+"_1" ).css( "pointer-events"," none"  );
            //      $( "#choose_schedule_net_"+s+"_1" ).css(" cursor","default" );
            s++;
            var schedules=$('#changing_schedule_net').val();
            schedules=schedules.split("</br>");
				
				
				
            if(schedules.length>=1 && strSelectedw!="select all" ){
				    
                for(k=0;k<schedules.length;k++)
                {
                    sc_hed=schedules[k].split('_');
                    append_sc+= '<option  id="'+k+'" value="' + schedules[k] + '">' + sc_hed[0] + '</option>';
                }
					
            }
				  
				
				
            if(s>1)
            {
                $("#o_delete_schedule_1").css("display","block");
				    				    
            }
			  
            $(".out_add_schedule").css("display","none");
			
				
            netPriceDiv+='<div class="priceContainer" id="netPriceDiv_'+s+'"><input id="earlybid_decide_'+s+'" type="hidden" value="0" name="earlybid_decide_'+s+'"><input id="selected_net_value_'+s+'" type="hidden" value="" name="selected_value_'+s+'"><input type="hidden" name="last_in_discount_id_'+s+'" id="last_in_discount_id_'+s+'" value=""><table cellpadding="0" cellspacing="0" border="0"><tr><td><div class="priceOuterDiv" id="net_priceOuterDiv_'+s+'">';
            netPriceDiv+='<table cellpadding="0" cellspacing="0" border="0" id="net_price_div_1_'+s+'"><tr><td id="added_price_'+s+'"><table cellspacing="0" cellpadding="0" border="0"><tr><td><div class="lt  advancedPriceContainer" id="advancedPriceContainer_'+s+'_1" ><div id="chosen_sc_txt_'+s+'_2_0" style="display: none;" class="choosen_head"></div><div class="chosen_op"  id="chosen_sc_txt_'+s+'_1_0" style="display: none;" ></div><div class="priceRow1_top" style="padding-top:0px;"><div class="lt blackText setWidthPrice3">Choose Schedule</div><div class="lt blackText setWidthPrice"> Net Price</div><div class="clear"></div></div>';
            netPriceDiv+='<div class="priceRow1_bottom"> <div class="lt"><select name="choose_schedule_net_'+s+'_1 " onchange="choose_schedule('+s+',\'net\')" id="choose_schedule_net_'+s+'_1" class="drop_down_left width_set7 choose_schedule" style="margin-left: 0px;"><option value="" selected="selected">--Choose--</option></select><input type="text" id="chosen_sc_txt_'+s+'_1_0"  size="30"  readonly="readonly" class="lt textbox1" name="chosen_sc_txt_1_1_4" value="" style="display: none;"><input type="hidden" id="chosen_sc_'+s+'_1" name="chosen_sc_'+s+'_1" value=""><input type="hidden" id="all_sc_'+s+'_1_0" name="all_sc_'+s+'_1_0" value=""/></div><input type="text" id="price_'+s+'_1" name="price_'+s+'_1" class="lt textbox" value="Enter Price" onfocus="focusChangeBorderColor1(\'price_'+s+'_1\')" maxlength="7" onKeyPress="return number(event);" onblur="blurChangeBorderColor1(\'price_'+s+'_1\')" style="width:152px;margin-left: 6px;" />';
				
            netPriceDiv+='<div class="clear"></div></div>';
            netPriceDiv+='<div class="clear"></div> <input type="hidden" name="multiple_discount_count_net_1_'+s+'_1" id="multiple_discount_count_net_1_'+s+'_1" value=""/><div class="createDynamicDiscount_net_1_1"></div><div class="clear"></div>';
         /*   netPriceDiv+='<div id="staticDiscount_net_'+s+'_1_0"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_net_'+s+'_'+1+'_0">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_net_'+s+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_net_'+s+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div>';
			 
			 
            netPriceDiv+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type_net" id="discount_type_net_'+s+'_1_0"><select name="ad_discount_type_net_'+s+'_1_0" id="ad_discount_type_net_'+s+'_1_0" class="drop_down_left width_set6" onchange="discTypeChanged(\'net\','+s+',1,0,this.value,1);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'net\',1,1,this.value)"> <option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option><option value="createnew"> Create new</option></select></div>    ';
            netPriceDiv+='<div id="session_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li></ul></li></ul><div class="clear"></div></div></div>';
            netPriceDiv+='<input type="text" id="ad_no_sess_net_'+s+'_1_0" name="ad_no_sess_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
            netPriceDiv+='<input type="text" id="ad_discount_sess_price_net_'+s+'_1_0" name="ad_discount_sess_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
			
            netPriceDiv+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_net_'+s+'_1_0" id="ad_discount_sess_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
            netPriceDiv+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\'net\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_session(\'net\','+s+',1,0,0,1)"  id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" style="display:block; position:relative;left:10px;"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_session_error_net_'+s+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
            netPriceDiv+='<div id="participant_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
            netPriceDiv+='<input type="text" id="ad_no_part_net_'+s+'_1_0" name="ad_no_part_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
		
            netPriceDiv+='<input type="text" id="ad_discount_part_price_net_'+s+'_1_0" name="ad_discount_part_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
            netPriceDiv+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_net_'+s+'_1_0" id="ad_discount_part_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option> <option value="%">%</option></select></div>';
            netPriceDiv+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\'net\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_participant(\'net\','+s+',1,0,0,1)" id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" style="display:block; position:relative;left:10px;"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
            netPriceDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_net_'+s+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div> ';
		
            netPriceDiv+='<div class="clear"></div><div id="early_brid_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
            netPriceDiv+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText" style="width:154px" >Valid  Until</div><div class="lt blackText setWidthDiscount" id="no_part_net_'+s+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
            netPriceDiv+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_net_'+s+'_1_0" name="ad_no_subs_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
            netPriceDiv+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_net_'+s+'_1_0" name="ad_valid_date_net_'+s+'_1" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_net_'+s+'_1_0" name="ad_valid_date_alt_net_'+s+'_1_0" value="" /></div></div>    ';
		
            netPriceDiv+='<input type="text" id="ad_discount_price_net_'+s+'_1_0" name="ad_discount_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
            netPriceDiv+='<div class="lt price_type"><select name="ad_discount_price_type_net_'+s+'_1_0" id="ad_discount_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
            netPriceDiv+='<div class="lt add_delete_icons" id="early_bid_icons_net_'+s+'_1_0"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\'net\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" title="" onClick="validate_early_bid(\'net\','+s+',1,0,0,1)" style="display:block; position:relative;left:10px;" class="lt addButton_net_'+b+'_1 single_add_net_'+b+'_1_0"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
            netPriceDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_net_'+s+'_1_0"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div>';
		    
		*/
            netPriceDiv+='<div class="errorDiv" style="display:none;"><div id="net_advance_error_1_'+s+'_1"></div></div><div class="clear"></div></div>';
            //netPriceDiv+='  <td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+s+'_1"> <div class="delete_schedule delete_schedule_'+s+'" id="inn_delete_schedule_'+s+'_1"style="margin-top:0px;display:none" onclick="delete_in_net_price('+s+',1)">&nbsp;</div><div onclick="add_net_advanced_price('+s+',1)" id="add_schedule_1" style="margin-top: 0px; display: block;" class="add_schedules add_schedules_'+s+'">&nbsp;</div> </div></td>';
				
				
            netPriceDiv+='</tr></table><div class="clear"></div></td></tr></table><div class="clear"></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="neprice_error_net_'+s+'_1"></div></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
				
            netPriceDiv+='<div class="Recuring_billing"><table  border="0"><tr>';
            netPriceDiv+='<td width="165" valign="middle"><span class="left_billing_img"><span id= "img_show_'+s+'"class="select_billing_img_show" onclick="select_range_billing(0,'+s+')"></span><span id="img_hide_'+s+'" class="select_billing_img_hide" onclick="select_range_billing(1,'+s+')"></span></span><span class="select_billing_content">enable recurring billing</span></td>';
            netPriceDiv+='<td><span class="inner">actuall billing will be base on  final discounted price if applicable</span></td></tr></table>';
            netPriceDiv+='<div class="dynamicAdvancedPrice"></div><table  class="recurring_slide_dwon" id="recurring_slide_dwon_'+s+'" border="0" >';
            netPriceDiv+='<tr><td width="200" valign="middle"><span class="terms">weekly</span></td> <td width="200" valign="middle"><div class="no_of">No.of  weeks</div><div class="cou_nts">48</div></td><td width="200" valign="middle"><span class="no_of">amount</span><span class="cou_nts">$ 8</span></td></tr>';
            netPriceDiv+='<tr><td ><span class="terms">monthly</span></td> <td><div class="no_of">No.of months</div><div class="cou_nts">24</div></td><td><span class="no_of">amount</span><span class="cou_nts">$ 8</span></td></tr>';
            netPriceDiv+='<tr><td><span class="terms">quartely</span></td> <td><div class="no_of">No.of terms</div><div class="cou_nts">8</div></td><td><span class="no_of">amount </span><span class="cou_nts">$ 8</span></td></tr></table></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
				
            netPriceDiv+='<div class="notesDiv"><textarea name="net_notes_'+s+'_1" id="net_notes_'+s+'_1" rows="10" cols="40"  class="lt textbox descTextbox" style="height:50px; width:485px;" onfocus="if(this.value==\'Notes:\'){this.value=\'\';$(this).css(\'color\',\'#444444\');}" onblur="if(this.value==\'\'){this.value=\'Notes:\';$(this).css(\'color\',\'#999999\');}" >Notes:</textarea><div class="clear"></div></div>';
            netPriceDiv+='<div class="clear"></div></div></td><td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+s+'"><div class="delete_schedule_net" id="o_delete_schedule_'+s+'"  style="margin-top:0px;" onclick="delete_net_price('+s+',0)">&nbsp;</div><div  onClick="validate_notes_netprice('+s+')" id="o_add_schedule_'+s+'"  style="margin-top:0px;"class="out_add_schedule">&nbsp;</div></div>';
            netPriceDiv+='<div class="clear"></div></td></tr></table></div> </div><div class="clear"></div><input type="hidden" name="last_discount_id_'+s+'_1" id="last_discount_id_'+s+'_1" value="0"><input type="hidden" name="delete_discount_id_'+s+'_1" id="delete_discount_id_'+s+'_1" value="">';
            $("add_schedule_"+s).css("display","block");
            $("#netPriceDiv").append(netPriceDiv);
	     $.ajax({
			type: "POST",
			url: "activity_detail/create_first_discount_type",
			data:{
			    "net":"net_",
			    "id1":s,
			    "id2":1,
			    "id3":0
			},
			success: function(html){
			    $("#advancedPriceContainer_"+s+"_1").append(html);
			  
			    
			} 
		});
            var e = document.getElementById('billing_type');
            var strSelected = e.options[e.selectedIndex].value;
            if(strSelected=="Schedule"){
                $('#net_continue_sc').val('');
                $('#net_continue_sc').val('1');
            }
            else{
                $('#net_continue_wsc').val('');
                $('#net_continue_wsc').val('1');
            }
	
	
            if(schedules.length==1)
            {
                $("#o_add_schedule_"+s).css("display","none");
				    				    
            }
            $("#choose_schedule_net_"+s+"_1").append(append_sc);
           // save_result=$("#save_result").val();
            var et=s+'_1_0';
          //  save_result+=','+et;
          //  $("#save_result").val(save_result);
            var total_div_count=$("#total_div_count").val();
            total_div_count+=','+s+'_1';
            $("#total_div_count").val(total_div_count);
				
            $('#saving_error').css("display","none");
			
        }
   
    }
    NET_lastDivSetBg();
}


/*************Delete whole div function**************/
function delete_net_price(e,h)
{
	
    var ew1 = document.getElementById("choose_schedule_net_"+e+"_1");
    var strSelectedw1 = $('#selected_net_value_'+e).val();

    // var strSelectedw1 = ew1.options[ew1.selectedIndex].value;
    var schedulesw1=$('#changing_schedule_net').val();
    var savecopy_array=schedulesw1.split("</br>");
    //alert(strSelectedw1+'**1');
    //alert(schedulesw1+'**21');
    if((h!=1)&&(strSelectedw1!='')&&(schedulesw1!=strSelectedw1)){
        // strSelectedw1=strSelectedw1.replace("</br>","");
        strSelectedw1=strSelectedw1
        if(schedulesw1!=''){
            var index101 = savecopy_array.indexOf(strSelectedw1);
            if(index101==-1){
                schedulesw1+='</br>'+strSelectedw1;
            // alert('if');
            }
        }
        else{
            schedulesw1+=strSelectedw1;
        //   alert('else');
        }
        strSelectedw2=strSelectedw1.split('_');
        $('select.choose_schedule').append('<option  value="' + strSelectedw1 + '">' + strSelectedw2[0]+ '</option>');
    }
	
    //alert(schedulesw1+'**2');
    $('#changing_schedule_net').val('');
    $('#changing_schedule_net').val(schedulesw1);
    var last_net_discount=$("#last_in_discount_id_"+e).val();
    last_net_discount=last_net_discount.split(',');
    save_result=$("#save_result").val();
    save_result=save_result.split(',');
    
    if((save_result.length>1)&&($('#selected_net_value_'+e).val()!='')){
        for(m=0;m<save_result.length;m++)
        {
            for(n=0; n<last_net_discount.length;n++)
            {
                var index1 = save_result.indexOf(last_net_discount[n]);
                if (index1 > -1) {
                    save_result.splice(index1, 1);
                }
            }
		        
        }
        $("#save_result").val(save_result);
    }
    if(save_result.length==1)
    {
        $(".delete_schedule_net").css("display","none");
    }
    var total_div_count=$("#total_div_count").val();
    total_div_count=total_div_count.split(',');

    //alert(save_result.length);
    if(total_div_count.length>1){
        $( "#netPriceDiv_"+e ).remove();
	
        var index1 = total_div_count.indexOf(e+'_1');
        if (index1 > -1) {
            total_div_count.splice(index1, 1);
        }
    }
    $("#total_div_count").val(total_div_count);
    if($('#changing_schedule_net').val()!=''){
        $( ".out_add_schedule" ).last().css("display","block");
	
    }
    NET_lastDivSetBg();
}


/******************Edit net price whole div starts************************/
var edit_netPriceDiv='';
function edit_netprice_whole_div(s)
{
    net='net';
    //alert(s);
    edit_netPriceDiv+='<div class="priceContainer" id="netPriceDiv_'+s+'"><input id="earlybid_decide_'+s+'" type="hidden" value="0" name="earlybid_decide_'+s+'"><input id="selected_value_'+s+'" type="hidden" value="" name="selected_value_'+s+'"><input type="hidden" name="last_in_discount_id_'+s+'" id="last_in_discount_id_'+s+'" value="'+s+'_1_0"><table cellpadding="0" cellspacing="0" border="0"><tr><td><div class="priceOuterDiv" id="net_priceOuterDiv_'+s+'">';
    edit_netPriceDiv+='<table cellpadding="0" cellspacing="0" border="0" id="net_price_div_1_'+s+'"><tr><td id="added_price_'+s+'"><table cellspacing="0" cellpadding="0" border="0"><tr><td><div class="lt  advancedPriceContainer" id="advancedPriceContainer_'+s+'_1" ><div id="chosen_sc_txt_'+s+'_2_0" style="display: none;" class="choosen_head"></div><div class="chosen_op"  id="chosen_sc_txt_'+s+'_1_0" style="display: none;" ></div><div class="priceRow1_top" style="padding-top:0px;"><div class="lt blackText setWidthPrice3">Choose Schedule</div><div class="lt blackText setWidthPrice"> Net Price</div><div class="clear"></div></div>';
    edit_netPriceDiv+='<div class="priceRow1_bottom"> <div class="lt"><select name="choose_schedule_net_'+s+'_1 " onchange="choose_schedule('+s+',\'net\')" id="choose_schedule_net_'+s+'_1" class="drop_down_left width_set7 choose_schedule" style="margin-left: 0px;"><option value="" selected="selected">--Choose--</option></select><input type="text" id="chosen_sc_txt_'+s+'_1_0"  size="30"  readonly="readonly" class="lt textbox1" name="chosen_sc_txt_1_1_4" value="" style="display: none;"><input type="hidden" id="chosen_sc_'+s+'_1" name="chosen_sc_'+s+'_1" value=""><input type="hidden" id="all_sc_'+s+'_1_0" name="all_sc_'+s+'_1_0" value=""/></div><input type="text" id="price_'+s+'_1" name="price_'+s+'_1" class="lt textbox" value="Enter Price" onfocus="focusChangeBorderColor1(\'price_'+s+'_1\')" maxlength="7" onKeyPress="return number(event);" onblur="blurChangeBorderColor1(\'price_'+s+'_1\')" style="width:152px;margin-left: 6px;" />';
					    
    edit_netPriceDiv+='<div class="clear"></div></div>';
    edit_netPriceDiv+='<div class="clear"></div> <input type="hidden" name="multiple_discount_count_net_1_'+s+'_1" id="multiple_discount_count_net_1_'+s+'_1" value=""/><div class="createDynamicDiscount_net_1_1"></div><div class="clear"></div>';
    //////////////////
    
    // edit_netPriceDiv_ad=edit_earlybid_and_session_whole_div(s) ;
    
    edit_netPriceDiv+='<div id="staticDiscount_net_1_1_0"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_net_'+s+'_'+1+'_0">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_net_'+s+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_net_'+s+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div>';
    edit_netPriceDiv+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type_net" id="discount_type_net_'+s+'_1_0"><select name="ad_discount_type_net_'+s+'_1_0" id="ad_discount_type_net_'+s+'_1_0" class="drop_down_left width_set6" onchange="discTypeChanged(\'net\','+s+',1,0,this.value,1);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'net\',1,1,this.value)"> <option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option> </select></div>    ';
    edit_netPriceDiv+='<div id="session_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li></ul></li></ul><div class="clear"></div></div></div>';
    edit_netPriceDiv+='<input type="text" id="ad_no_sess_net_'+s+'_1_0" name="ad_no_sess_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    edit_netPriceDiv+='<input type="text" id="ad_discount_sess_price_net_'+s+'_1_0" name="ad_discount_sess_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    
    edit_netPriceDiv+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_net_'+s+'_1_0" id="ad_discount_sess_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
    edit_netPriceDiv+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_session(\'net\','+s+',1,0,0,1)"  id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" style="display:block; position:relative;left:10px;"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_session_error_net_'+s+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
    edit_netPriceDiv+='<div id="participant_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
    edit_netPriceDiv+='<input type="text" id="ad_no_part_net_'+s+'_1_0" name="ad_no_part_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
			    
    edit_netPriceDiv+='<input type="text" id="ad_discount_part_price_net_'+s+'_1_0" name="ad_discount_part_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    edit_netPriceDiv+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_net_'+s+'_1_0" id="ad_discount_part_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option> <option value="%">%</option></select></div>';
    edit_netPriceDiv+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_participant(\'net\','+s+',1,0,0,1)" id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" style="display:block; position:relative;left:10px;"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
    edit_netPriceDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_net_'+s+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div> ';
			    
    edit_netPriceDiv+='<div class="clear"></div><div id="early_brid_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
    edit_netPriceDiv+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText" style="width:154px" >Valid  Until</div><div class="lt blackText setWidthDiscount" id="no_part_net_'+s+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
    edit_netPriceDiv+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_net_'+s+'_1_0" name="ad_no_subs_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    edit_netPriceDiv+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_net_'+s+'_1_0" name="ad_valid_date_net_'+s+'_1" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_net_'+s+'_1_0" name="ad_valid_date_alt_net_'+s+'_1_0" value="" /></div></div>    ';
			    
    edit_netPriceDiv+='<input type="text" id="ad_discount_price_net_'+s+'_1_0" name="ad_discount_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    edit_netPriceDiv+='<div class="lt price_type"><select name="ad_discount_price_type_net_'+s+'_1_0" id="ad_discount_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
    edit_netPriceDiv+='<div class="lt add_delete_icons" id="early_bid_icons_net_'+s+'_1_0"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" title="" onClick="validate_early_bid(\'net\','+s+',1,0,0,1)" style="display:block; position:relative;left:10px;" class="lt addButton_net_'+s+'_1 single_add_net_'+s+'_1_0"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
    edit_netPriceDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_net_'+s+'_1_0"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div>';
			
    
    
    //    edit_netPriceDiv+=edit_netPriceDiv_ad;
    edit_netPriceDiv+=' <div id="dynamicNetPrice_'+s+'"></div><div id="staticDiscount_net_'+s+'_1" id="staticDiscount_net_1_1"></div>';
    ///////////////
					    
    edit_netPriceDiv+='<div class="errorDiv" style="display:none;"><div id="net_advance_error_1_'+s+'_1"></div></div><div class="clear"></div></div>';
    //edit_netPriceDiv+='  <td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+s+'_1"> <div class="delete_schedule delete_schedule_'+s+'" id="inn_delete_schedule_'+s+'_1"style="margin-top:0px;display:none" onclick="delete_in_net_price('+s+',1)">&nbsp;</div><div onclick="add_net_advanced_price('+s+',1)" id="add_schedule_1" style="margin-top: 0px; display: block;" class="add_schedules add_schedules_'+s+'">&nbsp;</div> </div></td>';
					    
					    
    edit_netPriceDiv+='</tr></table><div class="clear"></div></td></tr></table><div class="clear"></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="neprice_error_net_'+s+'_1"></div></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
					    
    edit_netPriceDiv+='<div class="Recuring_billing"><table  border="0"><tr>';
    edit_netPriceDiv+='<td width="165" valign="middle"><span class="left_billing_img"><span id= "img_show_'+s+'"class="select_billing_img_show" onclick="select_range_billing(0,'+s+')"></span><span id="img_hide_'+s+'" class="select_billing_img_hide" onclick="select_range_billing(1,'+s+')"></span></span><span class="select_billing_content">enable recurring billing</span></td>';
    edit_netPriceDiv+='<td><span class="inner">actuall billing will be base on  final discounted price if applicable</span></td></tr></table>';
    edit_netPriceDiv+='<div class="dynamicAdvancedPrice"></div><table  class="recurring_slide_dwon" id="recurring_slide_dwon_'+s+'" border="0" >';
    edit_netPriceDiv+='<tr><td width="200" valign="middle"><span class="terms">weekly</span></td> <td width="200" valign="middle"><div class="no_of">No.of  weeks</div><div class="cou_nts">48</div></td><td width="200" valign="middle"><span class="no_of">amount</span><span class="cou_nts">$ 8</span></td></tr>';
    edit_netPriceDiv+='<tr><td ><span class="terms">monthly</span></td> <td><div class="no_of">No.of months</div><div class="cou_nts">24</div></td><td><span class="no_of">amount</span><span class="cou_nts">$ 8</span></td></tr>';
    edit_netPriceDiv+='<tr><td><span class="terms">quartely</span></td> <td><div class="no_of">No.of terms</div><div class="cou_nts">8</div></td><td><span class="no_of">amount </span><span class="cou_nts">$ 8</span></td></tr></table></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
					    
    edit_netPriceDiv+='<div class="notesDiv"><textarea name="net_notes_'+s+'_1" id="net_notes_'+s+'_1" rows="10" cols="40"  class="lt textbox descTextbox" style="height:50px; width:485px;" onfocus="if(this.value==\'Notes:\'){this.value=\'\';$(this).css(\'color\',\'#444444\');}" onblur="if(this.value==\'\'){this.value=\'Notes:\';$(this).css(\'color\',\'#999999\');}" >Notes:</textarea><div class="clear"></div></div>';
    edit_netPriceDiv+='<div class="clear"></div></div></td><td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+s+'"><div class="delete_schedule_net" id="o_delete_schedule_'+s+'"  style="margin-top:0px;" onclick="delete_net_price('+s+',0)">&nbsp;</div><div  onClick="validate_notes_netprice('+s+')" id="o_add_schedule_'+s+'"  style="margin-top:0px;"class="out_add_schedule">&nbsp;</div></div>';
    edit_netPriceDiv+='<div class="clear"></div></td></tr></table></div> </div><div class="clear"></div><input type="hidden" name="last_discount_id_'+s+'_1" id="last_discount_id_'+s+'_1" value="0"><input type="hidden" name="delete_discount_id_'+s+'_1" id="delete_discount_id_'+s+'_1" value="'+s+'_1_0">';
    $("add_schedule_"+s).css("display","block");
    $("#netPriceDiv").append(edit_netPriceDiv);
}

var netPriceDiv_early='';
function edit_earlybid_and_session_whole_div(s)
{
    net='net';
    netPriceDiv_early+='<div id="staticDiscount_net_1_1_0"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_net_'+s+'_'+1+'_0">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_net_'+s+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_net_'+s+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div>';
    netPriceDiv_early+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type_net" id="discount_type_net_'+s+'_1_0"><select name="ad_discount_type_net_'+s+'_1_0" id="ad_discount_type_net_'+s+'_1_0" class="drop_down_left width_set6" onchange="discTypeChanged(\'net\','+s+',1,0,this.value,1);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'net\',1,1,this.value)"> <option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option> </select></div>    ';
    netPriceDiv_early+='<div id="session_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li></ul></li></ul><div class="clear"></div></div></div>';
    netPriceDiv_early+='<input type="text" id="ad_no_sess_net_'+s+'_1_0" name="ad_no_sess_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    netPriceDiv_early+='<input type="text" id="ad_discount_sess_price_net_'+s+'_1_0" name="ad_discount_sess_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    
    netPriceDiv_early+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_net_'+s+'_1_0" id="ad_discount_sess_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
    netPriceDiv_early+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_session(\'net\','+s+',1,0,0,1)"  id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" style="display:block; position:relative;left:10px;"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_session_error_net_'+s+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
    netPriceDiv_early+='<div id="participant_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
    netPriceDiv_early+='<input type="text" id="ad_no_part_net_'+s+'_1_0" name="ad_no_part_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
			    
    netPriceDiv_early+='<input type="text" id="ad_discount_part_price_net_'+s+'_1_0" name="ad_discount_part_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    netPriceDiv_early+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_net_'+s+'_1_0" id="ad_discount_part_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option> <option value="%">%</option></select></div>';
    netPriceDiv_early+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_participant(\'net\','+s+',1,0,0,1)" id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" style="display:block; position:relative;left:10px;"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
    netPriceDiv_early+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_net_'+s+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div> ';
			    
    netPriceDiv_early+='<div class="clear"></div><div id="early_brid_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
    netPriceDiv_early+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText" style="width:154px" >Valid  Until</div><div class="lt blackText setWidthDiscount" id="no_part_net_'+s+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
    netPriceDiv_early+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_net_'+s+'_1_0" name="ad_no_subs_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    netPriceDiv_early+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_net_'+s+'_1_0" name="ad_valid_date_net_'+s+'_1" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_net_'+s+'_1_0" name="ad_valid_date_alt_net_'+s+'_1_0" value="" /></div></div>    ';
			    
    netPriceDiv_early+='<input type="text" id="ad_discount_price_net_'+s+'_1_0" name="ad_discount_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    netPriceDiv_early+='<div class="lt price_type"><select name="ad_discount_price_type_net_'+s+'_1_0" id="ad_discount_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
    netPriceDiv_early+='<div class="lt add_delete_icons" id="early_bid_icons_net_'+s+'_1_0"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" title="" onClick="validate_early_bid(\'net\','+s+',1,0,0,1)" style="display:block; position:relative;left:10px;" class="lt addButton_net_'+s+'_1 single_add_net_'+s+'_1_0"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
    netPriceDiv_early+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_net_'+s+'_1_0"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div>';
			
//$("#staticDiscount_net_"+s+"_1").append(netPriceDiv_early);
	
}


/******************Edit net price whole div ends************************/




/*********************Function adding and Editing Net Price whole div  ends************************/



/*********************************************************
				
					    Function adding Net Price Inner div  starts
				
 **********************************************************/
function add_net_advanced_price(b,q)
{
    var select_box1='choose_schedule_net_'+b+'_1';
    var e1 = document.getElementById(select_box1);
    var strSelected1 = e1.options[e1.selectedIndex].value;
    var append_sc='';
    var schedules=$('#total_schedule').val();
    schedules=schedules.split("</br>");  //alert(schedules+"asd");
    schedules = jQuery.unique( schedules );
    //    alert(schedules);    alert(schedules.length);
    for(var k=1; k<schedules.length;k++)
    {
        append_sc+= '<option value="' + schedules[k] + '">' + schedules[k] + '</option>';
	   
    }
    //alert(append_sc);

    var h=$("#last_discount_id_"+b+"_"+q).val();
    var loop=$("#delete_discount_id_"+b+"_"+q).val();
    sp=loop.split(',');
    for(var i=0;i<sp.length;i++){
        var t1=sp[i].split('_');
        b=t1[0];
        q=t1[1];
        h=t1[2];
        var select_box='ad_discount_type_net_'+b+'_'+q+'_'+h;
        var e = document.getElementById(select_box);
        var strSelected = e.options[e.selectedIndex].value;
		
        if(strSelected=="Early Bird Discount"){
			
            var net='net';
            var yes=validate_early_bid(net,b,q,h,0,0,'');
            if (yes=='0'){
                break;
            }
        }
        else if(strSelected=="Multiple Session Discount"){
            var net='net';
            var yes=validate_session(net,b,q,h,0,0,'');
            if (yes=='0'){
                break;
            }
        }
        else if(strSelected=="Multiple Participant Discount"){
            var net='net';
            var yes=validate_participant(net,b,q,h,0,0,'');
            if (yes=='0'){
                break;
            }
        }
        else{
		   
            var net='net';
	
            var yes=validate_nothing_selected(net,b,q,h,0,0,'');
            if(yes=='0'){
                break;
            }
        //alert(yes);
        }
		
    }
    if(yes==1){
		
        q++;
        if(q>1){
            $("#inn_delete_schedule_"+b+"_1").css("display","block");
        }
			
        p=q-1;
        $(".add_schedules_"+b).css("display","none");
        var inner_netPriceDiv='';
			
        inner_netPriceDiv+='<input type="hidden" name="delete_discount_id_'+b+'_'+q+'" id="delete_discount_id_'+b+'_'+q+'" value="'+b+'_'+q+'_0"><input type="hidden" name="last_discount_id_'+b+'_'+q+'" id="last_discount_id_'+b+'_'+q+'" value="0">';
        inner_netPriceDiv+='<table id="advancedPriceContainer_table_'+b+'_'+q+'"><tr><td><div   class="lt  advancedPriceContainer" id="advancedPriceContainer_'+b+'_'+q+'"><div class="priceRow1_top" style="padding-top:0px;"><div class="lt blackText setWidthPrice">Net Price</div><div class="clear"></div></div><div class="priceRow1_bottom"><div class="lt1">';
			
        inner_netPriceDiv+='<table><tr><td><input type="text" id="price_'+b+'_'+q+'" name="price_'+b+'_'+q+'" class="lt textbox" value="Enter Price" onfocus="focusChangeBorderColor1(\'price_'+b+'_'+q+'\')" maxlength="7" onKeyPress="return number(event);" onblur="blurChangeBorderColor1(\'price_'+b+'_'+q+'\')" style="width:152px;" /></td><td><div style="margin-left:10px;">Selected Schedule :'+strSelected1+'</div><input type="hidden" name="choose_schedule_net_'+b+'_'+q+' "   id="choose_schedule_net_'+b+'_'+q+' " value="'+strSelected1+'"></td></tr></table>';
        //inner_netPriceDiv+='<select name="choose_schedule_net_'+b+'_'+q+' " id="choose_schedule_net_'+b+'_'+q+'" class="drop_down_left width_set7 choose_schedule" style="margin-right: 5px;"><option value="" selected="selected">--Choose--</option></select>';
			
        inner_netPriceDiv+='</div><div class="clear"></div></div>';
        inner_netPriceDiv+='<div class="clear"></div> <input type="hidden" name="multiple_discount_count_net_1_'+b+'_'+q+'" id="multiple_discount_count_net_1_'+b+'_'+q+'" value=""/><div class="createDynamicDiscount_net_1_1"></div><div class="clear"></div>';
        inner_netPriceDiv+='rrr<div id="staticDiscount_net_'+b+'_'+q+'_0" ><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_net_1_'+b+'_'+q+'">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_net_1_'+b+'_'+q+'">Quantity</div><div class="clear"></div></div>';
			
			
        inner_netPriceDiv+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type_net" id="discount_type_net_'+b+'_'+q+'_0"><select name="ad_discount_type_net_'+b+'_'+q+'_0" id="ad_discount_type_net_'+b+'_'+q+'_0" class="drop_down_left width_set6" onchange="discTypeChanged(\'net\','+b+','+q+',0,this.value,1);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'net\',1,1,this.value)"> <option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option> </select></div>    ';
        inner_netPriceDiv+='<div id="session_net_'+b+'_'+q+'_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li></ul></li></ul><div class="clear"></div></div></div>';
        inner_netPriceDiv+='<input type="text" id="ad_no_sess_net_'+b+'_'+q+'_0" name="ad_no_sess_net_'+b+'_'+q+'_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        inner_netPriceDiv+='<input type="text" id="ad_discount_sess_price_net_'+b+'_'+q+'_0" name="ad_discount_sess_price_net_'+b+'_'+q+'_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
			
        inner_netPriceDiv+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_net_'+b+'_'+q+'_0" id="ad_discount_sess_price_type_net_'+b+'_'+q+'_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
        inner_netPriceDiv+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+b+'_'+q+'" style="margin-top:0px;" onclick="delete_single_net_price(\''+net+'\','+b+','+q+',0)">&nbsp;</div><a href="javascript:void(0)" title="" id="single_add_net_'+b+'_'+q+'_0" class="addButton_net_'+b+'_'+q+' single_add_net_'+b+'_'+q+'_0" onClick="validate_session(\'net\','+b+','+q+',0,0,1)" style="display:inline-block; position:relative;left:10px;"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_session_error_net_'+b+'_'+q+'_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
        inner_netPriceDiv+='<div id="participant_net_'+b+'_'+q+'_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
        inner_netPriceDiv+='<input type="text" id="ad_no_part_net_'+b+'_'+q+'_0" name="ad_no_part_net_'+b+'_'+q+'_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
			
        inner_netPriceDiv+='<input type="text" id="ad_discount_part_price_net_'+b+'_'+q+'_0" name="ad_discount_part_price_net_'+b+'_'+q+'_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        inner_netPriceDiv+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_net_'+b+'_'+q+'_0" id="ad_discount_part_price_type_net_'+b+'_'+q+'_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option> <option value="%">%</option></select></div>';
        inner_netPriceDiv+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+b+'_'+q+'" style="margin-top:0px;" onclick="delete_single_net_price(\''+net+'\','+b+','+q+',0)">&nbsp;</div><a href="javascript:void(0)" title="" id="single_add_net_'+b+'_'+q+'_0" class="addButton_net_'+b+'_'+q+' single_add_net_'+b+'_'+q+'_0" onClick="validate_participant(\'net\','+b+','+q+',0,0,1)" style="display:inline-block; position:relative;left:10px;"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
        inner_netPriceDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_net_'+b+'_'+q+'_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div> ';
			
        inner_netPriceDiv+='<div class="clear"></div><div id="early_brid_net_'+b+'_'+q+'_0" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
        inner_netPriceDiv+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText">Valid  Until</div><div class="clear"></div></div><div class="clear"></div>';
        inner_netPriceDiv+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_net_'+b+'_'+q+'_0" name="ad_no_subs_net_1__'+b+'_'+q+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        inner_netPriceDiv+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_net_'+b+'_'+q+'_0" name="ad_valid_date_net_'+b+'_'+q+'_0" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_net_'+b+'_'+q+'_0" name="ad_valid_date_alt_net_1_1" value="" /></div></div>    ';
			
        inner_netPriceDiv+='<input type="text" id="ad_discount_price_net_'+b+'_'+q+'_0" name="ad_discount_price_net_'+b+'_'+q+'_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        inner_netPriceDiv+='<div class="lt price_type"><select name="ad_discount_price_type_net_'+b+'_'+q+'_0" id="ad_discount_price_type_net_'+b+'_'+q+'_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
        inner_netPriceDiv+='<div class="lt add_delete_icons" id="early_bid_icons_net_'+b+'_'+q+'_0"><div class="delete_single_schedule delete_single_schedule_'+b+'_'+q+'" style="margin-top:0px;" onclick="delete_single_net_price(\''+net+'\','+b+','+q+',0)">&nbsp;</div><a href="javascript:void(0)" title=""  id="single_add_net_'+b+'_'+q+'_0"  onClick="validate_early_bid(\'net\','+b+','+q+',0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_net_'+b+'_'+q+'  single_add_net_'+b+'_'+q+'_0"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
        inner_netPriceDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_net_'+b+'_'+q+'_0"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div>';
        inner_netPriceDiv+='<div class="errorDiv" style="display:none;"><div id="net_advance_error_'+b+'_'+q+'_0"></div></div><div class="clear"></div></div></td><td valign="bottom"><div onclick="delete_in_net_price('+b+','+q+')" style="margin-top:0px;" class="delete_schedule delete_schedule_'+b+'">&nbsp;</div><div class="add_schedules add_schedules_'+b+'" style="margin-top:0px;" id="add_schedule_'+q+'" onclick="add_net_advanced_price('+b+','+q+')">&nbsp;</div></td></tr></table><div class="clear"></div><div class="errorDiv" style="display:none"><div id="neprice_error_net_'+b+'_'+q+'"></div></div><div class="clear"></div>';
			
        $("#add_schedule_"+q).css("display","block");
		
				
        $("#added_price_"+b).append(inner_netPriceDiv);
        $("#choose_schedule_net_"+b+"_"+q).append(append_sc);
        var et=b+'_'+q+"_0";
        var values=$("#last_in_discount_id_"+b).val();
        values+=","+et;
        $("#last_in_discount_id_"+b).val(values);
			
        save_result=$("#save_result").val();
        save_result+=','+et;
        $("#save_result").val(save_result);
    //$('#last_in_discount_id_'+b).val(et);
		
    }
		
}




/*************Delete Inner div function**************/

function delete_in_net_price(b,q)
{
    var in_net_delets=$("#delete_discount_id_"+b+"_"+q).val();
    var values=$("#last_in_discount_id_"+b).val();
    values=values.split(',');
    in_net_delets=in_net_delets.split(',');
	
    for(i=0;i<values.length;i++)
    {
        for(j=0; j<in_net_delets.length;j++)
        {
            var index = values.indexOf(in_net_delets[j]);
            if (index > -1) {
                values.splice(index, 1);
            }
        }
    }
    $("#last_in_discount_id_"+b).val(values);
    save_result=$("#save_result").val();
    save_result=save_result.split(',');
    for(m=0;m<save_result.length;m++)
    {
        for(n=0; n<in_net_delets.length;n++)
        {
            var index1 = save_result.indexOf(in_net_delets[n]);
            if (index1 > -1) {
                save_result.splice(index1, 1);
            }
        }
		
    }
    $("#save_result").val(save_result);
    var ids=b+"_"+q;
	
    $( "#advancedPriceContainer_table_"+ids ).remove();
    if(q>1){
        $("#inn_delete_schedule_"+b+"_1").css("display","block");
    }
    if(values.length==1){
		    
        $( ".delete_schedule_"+b ).css("display","none");
    }
		
    $( ".add_schedules_"+b ).last().css("display","block");
	
//alert(e);
}



/*********************Function adding Net Price Inner div  ends************************/

/*********************************************************function edit early bids_advance and net starts*********************************************************/
function addding_earlybids_divs(netapnd,b,q,h)
{

    if (netapnd == 'net_'){
        eb_id='0';
        net='net';
    }
    else{
        net='';
        eb_id='1';
    }

    
    var inner_discountDiv='';
	       
    inner_discountDiv+='<div class="staticDiscount_'+netapnd+'1_1"  id="staticDiscount_'+netapnd+''+b+'_'+q+'_'+h+'"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_'+netapnd+''+b+'_'+q+'_'+h+'">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_'+netapnd+''+b+'_'+q+'_'+h+'"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div>';
    inner_discountDiv+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type_net" id="discount_type_'+netapnd+''+b+'_'+q+'_'+h+'"><select name="ad_discount_type_'+netapnd+''+b+'_'+q+'_'+h+'" id="ad_discount_type_'+netapnd+''+b+'_'+q+'_'+h+'" class="drop_down_left width_set6" onchange="discTypeChanged(\''+net+'\','+b+','+q+','+h+',this.value,1);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'net\',1,1,this.value)"> <option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option>';
    if(eb_id=='0'){
        inner_discountDiv+='<option value="1">Early Bird Discount</option>';
    }
    if(net!='net'){
        inner_discountDiv+='<option value="2">Multiple Session Discount</option>';
    }
    inner_discountDiv+='<option value="3">Multiple Participant Discount</option> </select></div>    ';
	    
	    
    inner_discountDiv+='<div id="session_'+netapnd+''+b+'_'+q+'_'+h+'" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li></ul></li></ul><div class="clear"></div></div></div>';
    inner_discountDiv+='<input type="text" id="ad_no_sess_'+netapnd+''+b+'_'+q+'_'+h+'" name="ad_no_sess_'+netapnd+''+b+'_'+q+'_'+h+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    inner_discountDiv+='<input type="text" id="ad_discount_sess_price_'+netapnd+''+b+'_'+q+'_'+h+'" name="ad_discount_sess_price_'+netapnd+''+b+'_'+q+'_'+h+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
	    
    inner_discountDiv+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_'+netapnd+''+b+'_'+q+'_'+h+'" id="ad_discount_sess_price_type_'+netapnd+''+b+'_'+q+'_'+h+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
    inner_discountDiv+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+b+'_'+q+'" style="margin-top:0px;" onclick="delete_single_net_price(\''+net+'\','+b+','+q+','+h+')">&nbsp;</div><a href="javascript:void(0)" title="" class="lt addButton_'+netapnd+''+b+'_'+q+' single_add_'+netapnd+''+b+'_'+q+'_'+h+'" id="single_add_'+netapnd+''+b+'_'+q+'_'+h+'"  onClick="validate_session(\''+net+'\','+b+','+q+','+h+','+eb_id+',1)" style="display:inline-block; position:relative;left:0px;"><img class="lt addButton" src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_session_error_'+netapnd+''+b+'_'+q+'_'+h+'" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
    inner_discountDiv+='<div id="participant_'+netapnd+''+b+'_'+q+'_'+h+'" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
    inner_discountDiv+='<input type="text" id="ad_no_part_'+netapnd+''+b+'_'+q+'_'+h+'" name="ad_no_part_'+netapnd+''+b+'_'+q+'_'+h+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
	    
    inner_discountDiv+='<input type="text" id="ad_discount_part_price_'+netapnd+''+b+'_'+q+'_'+h+'" name="ad_discount_part_price_'+netapnd+''+b+'_'+q+'_'+h+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    inner_discountDiv+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_'+netapnd+''+b+'_'+q+'_'+h+'" id="ad_discount_part_price_type_'+netapnd+''+b+'_'+q+'_'+h+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option> <option value="%">%</option></select></div>';
    inner_discountDiv+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+b+'_'+q+'" style="margin-top:0px;" onclick="delete_single_net_price(\''+net+'\','+b+','+q+','+h+')">&nbsp;</div><a href="javascript:void(0)" class="lt addButton_'+netapnd+''+b+'_'+q+' single_add_'+netapnd+''+b+'_'+q+'_'+h+'"  id="single_add_'+netapnd+''+b+'_'+q+'_'+h+'" title="" onClick="validate_participant(\''+net+'\','+b+','+q+','+h+','+eb_id+',1)" style="display:inline-block; position:relative;left:0px;"><img class="lt addButton" src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
    inner_discountDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_'+netapnd+''+b+'_'+q+'_'+h+'" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div> ';
	    
    inner_discountDiv+='<div class="clear"></div><div id="early_brid_'+netapnd+''+b+'_'+q+'_'+h+'" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
    inner_discountDiv+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText">Valid  Until</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_'+netapnd+''+b+'_'+q+'_'+h+'"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
    inner_discountDiv+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_'+netapnd+''+b+'_'+q+'_'+h+'" name="ad_no_subs_'+netapnd+'1__'+b+'_'+q+'_'+h+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    inner_discountDiv+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_'+netapnd+''+b+'_'+q+'_'+h+'" name="ad_valid_date_'+netapnd+''+b+'_'+q+'_'+h+'" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_'+netapnd+''+b+'_'+q+'_'+h+'" name="ad_valid_date_alt_'+netapnd+'1_1" value="" /></div></div>    ';
	    
    inner_discountDiv+='<input type="text" id="ad_discount_price_'+netapnd+''+b+'_'+q+'_'+h+'" name="ad_discount_price_'+netapnd+''+b+'_'+q+'_'+h+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    inner_discountDiv+='<div class="lt price_type"><select name="ad_discount_price_type_'+netapnd+''+b+'_'+q+'_'+h+'" id="ad_discount_price_type_'+netapnd+''+b+'_'+q+'_'+h+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
    inner_discountDiv+='<div class="lt add_delete_icons" id="early_bid_icons_'+netapnd+''+b+'_'+q+'_'+h+'"><div class="delete_single_schedule delete_single_schedule_'+b+'_'+q+'" style="margin-top:0px;" onclick="delete_single_net_price(\''+net+'\','+b+','+q+','+h+')">&nbsp;</div><a href="javascript:void(0)"  class="lt addButton_'+netapnd+''+b+'_'+q+' single_add_'+netapnd+''+b+'_'+q+'_'+h+'" id="single_add_'+netapnd+''+b+'_'+q+'_'+h+'" title="" onClick="validate_early_bid(\''+net+'\','+b+','+q+','+h+','+eb_id+',1)" style="display:inline-block; position:relative;left:0px;" class="lt addButton"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
    inner_discountDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_'+netapnd+''+b+'_'+q+'_'+h+'"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div>';
    if (netapnd == 'net_'){
        $("#dynamicNetPrice_"+b).append(inner_discountDiv);
    }
    else{
        $("#createDynamicDiscount_"+b+"_"+q+"_"+h).append(inner_discountDiv);
    }
    
}


/*********************************************************function edit early bids_advance and net starts*********************************************************/


/*********************************************************
				
					    Function adding Advance Price whole div  starts
				
 **********************************************************/
function validate_notes_adprice(ad)
{  
    var e = document.getElementById('billing_type');
    var strSelected = e.options[e.selectedIndex].value;
    if(strSelected=="Schedule"){
        var cont_inue= $('#adv_continue_sc').val();
    }
    else{
        var cont_inue= $('#adv_continue_wsc').val();
    }

    //alert('cont_inue');
    if((ad=='0')&&(cont_inue==0)){
     
        $('#advancedPriceDiv .priceContainer').remove();
     
        var append_sc='';
 
        var schedules=$('#total_schedule').val();
        schedules=schedules.slice(0,-5);
        schedules=schedules.split("</br>");
				
				
				
       
				    
        for(k=0;k<schedules.length;k++)
        {
            sc_hed=schedules[k].split('_');
            append_sc+= '<option  id="'+k+'" value="' + schedules[k] + '">' + sc_hed[0] + '</option>';
        }
        ad++;
	  
	
        var  advance_add='';
		  
        advance_add+='<div class="priceContainer"  id="priceContainerDiv_'+ad+'">  <input type="hidden" name="earlybid_decide_adv_'+ad+'_1" id="earlybid_decide_adv_'+ad+'_1" value="0"><input type="hidden" name="delete_ad_discount_id_'+ad+'_1" id="delete_ad_discount_id_'+ad+'_1" value="'+ad+'_1_0"><input type="hidden" name="inner_div_count_'+ad+'_1" id="inner_div_count_'+ad+'_1" value="'+ad+'_1"><input type="hidden" name="early_div_count_'+ad+'_1" id="early_div_count_'+ad+'_1" value="'+ad+'_1_0"><input type="hidden" name="selected_value_'+ad+'" id="selected_value_'+ad+'" value=""><input type="hidden" id="chosen_ad_sc_'+ad+'_1" name="chosen_ad_sc_'+ad+'_1" value=""><input type="hidden" name="last_in_ad_discount_id_'+ad+'" id="last_in_ad_discount_id_'+ad+'" value="'+ad+'_1_0"><input id="last_ad_in_discount_id_'+ad+'" type="hidden" value="'+ad+'_1_0" name="last_ad_in_discount_id_'+ad+'"><input id="last_ad_discount_id_'+ad+'_1" type="hidden" value="0" name="last_ad_discount_id_'+ad+'_1"><table cellpadding="0" cellspacing="0" border="0"><tr>	<td><div class="priceOuterDiv" id="priceOuterDiv_'+ad+'"><table cellpadding="0" cellspacing="0" border="0" id="advance_price_div_'+ad+'_1_0"><tr id="advance_row_1_1"><td><div class="lt advancedPriceContainer" id="advanced_PriceContainer_adv_'+ad+'_1" ><div id="schedule_heading_'+ad+'"  class="schedule_heading_1" style="display:none">Chosen Schedule </div><div class="selected_schedule_ad_1" id="selected_schedule_ad_'+ad+'" style="display:none"></div><div class="priceRow1_top" style="padding-top:0px;"><div class="lt blackText setWidthPrice3"   style="width: :160px;" id="setWidthPrice3_'+ad+'">Choose Schedule</div><div class="lt blackText setWidthPrice">Payment Period</div><div class="lt blackText setWidthPrice1" id="display_fst_text_'+ad+'_1">Max No. of Hour(s)</div><div class="lt blackText setWidthPrice2" id="display_sec_text_'+ad+'_1" style="display:none;"></div><div class="lt blackText" id="pricelabel_'+ad+'_1">Price</div><div class="clear"></div></div>';
        advance_add+='<div class="clear"></div><div class="priceRow1_bottom"><div class="lt"><select  onchange="choose_schedule('+ad+',\'adv\')" name="choose_schedule_'+ad+'_1" id="choose_schedule_'+ad+'_1" class="drop_down_left width_set7 choose_schedule" style="margin-right: 5px;"><option value="" selected="selected">--Choose--</option></select></div>  ';
        advance_add+='<div class="lt"><select name="ads_payment_'+ad+'_1" id="ad_payment_'+ad+'_1" class="drop_down_left width_set5" onchange="payTypeChanged('+ad+',1,this.value)" onkeyup="payTypeChanged(1,1,this.value)"><option value="Per Hour">Per Hour</option><option value="Class Card">Class Card</option><option value="Per Session">Per Session</option><option value="Weekly">Weekly</option><option value="Monthly">Monthly</option><option value="Yearly">Yearly</option></select></div>  ';
        advance_add+='<input type="text" id="ad_payment_box_fst_'+ad+'_1" name="ad_payment_box_fst_'+ad+'_1" class="lt textbox" value="Eg: 3" maxlength="5" style="width:107px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_add+='<input type="text" id="ad_payment_box_sec_'+ad+'_1" name="ad_payment_box_sec_'+ad+'_1" class="lt textbox" value="Eg: 3" maxlength="5" style="display:none;width:100px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_add+='<input type="text" id="ad_price_'+ad+'_1" name="ad_price_'+ad+'_1" class="lt textbox" value="$" maxlength="7" style="width:100px" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" />';
        advance_add+='</div><div class="clear"></div>	<input type="hidden" name="multiple_discount_count_'+ad+'_1" id="multiple_discount_count_'+ad+'_1" value="1"/><div class="createDynamicDiscount_'+ad+'_1_0"></div><div class="clear"></div>';
       /******************/
     /*   advance_add+='<div id="staticDiscount_'+ad+'_1_0"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_'+ad+'_1_0">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_'+ad+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div>';
        advance_add+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type" id="discount_type_'+ad+'_1_0"><select name="ad_discount_type_'+ad+'_1_0" id="ad_discount_type_'+ad+'_1_0" class="drop_down_left width_set6" onchange="discTypeChanged(\'\','+ad+',1,0,this.value);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'\',1,1,this.value)"><option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div>   ';
        advance_add+='<div id="session_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li> </ul></li></ul><div class="clear"></div></div></div>';
        advance_add+='<input type="text" id="ad_no_sess_'+ad+'_1_0" name="ad_no_sess_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_add+='<input type="text" id="ad_discount_sess_price_'+ad+'_1_0" name="ad_discount_sess_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_add+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_'+ad+'_1_0" id="ad_discount_sess_price_type_'+ad+'_1_0" class="drop_down_left width_set3"> <option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
        advance_add+='<div class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_session(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>    ';
        advance_add+='<div class="clear"></div> <div class="errorDiv" style="display:none"><div id="advance_session_error_'+ad+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
        advance_add+='<div id="participant_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu">';
        advance_add+='<ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li> </ul></li></ul>';
        advance_add+='<div class="clear"></div></div></div><input type="text" id="ad_no_part_'+ad+'_1_0" name="ad_no_part_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_add+='<input type="text" id="ad_discount_part_price_'+ad+'_1_0" name="ad_discount_part_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_add+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_'+ad+'_1_0" id="ad_discount_part_price_type_'+ad+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option> </select></div>';
        advance_add+='<div class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_participant(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
        advance_add+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_'+ad+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div>    ';
        advance_add+='<div class="clear"></div><div id="early_brid_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul>';
        advance_add+='<li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
        advance_add+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText" style="width:154px" >Valid  Until</div><div class="lt blackText setWidthDiscount" id="no_part_net_'+ad+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
        advance_add+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_'+ad+'_1_0" name="ad_no_subs_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_add+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_'+ad+'_1_0" name="ad_valid_date_'+ad+'_1_0" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_'+ad+'_1_0" name="ad_valid_date_alt_'+ad+'_1_0" value="" /></div></div>    ';
        advance_add+='<input type="text" id="ad_discount_price_'+ad+'_1_0" name="ad_discount_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_add+='<div class="lt price_type"><select name="ad_discount_price_type_'+ad+'_1_0" id="ad_discount_price_type_'+ad+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
        advance_add+='<div class="lt add_delete_icons" id="early_bid_icons_'+ad+'_1_0"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onclick="validate_early_bid(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img width="22" height="22" src="/assets/create_new_activity/add_icon.png" alt=""></a></div>';
        advance_add+='<div class="clear"></div><div class="clear"></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_'+ad+'_1_0"></div></div><div class="clear"></div></div>';
       **************/
        advance_add+='<div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div><div class="errorDiv" style="display:none;"><div id="advance_error_'+ad+'_1_0"></div></div><div class="clear"></div></div>';
        advance_add+='</td>';
        advance_add+='<td valign="bottom">  <div class="delete_schedule d_delete_schedule_'+ad+'"  id="adv_inn_delete_schedule_'+ad+'_1" style="margin-top:0px;display:none;" onclick="delete_ad_in_price('+ad+',1)">&nbsp;</div> <div class="add_ad_in_schedule add_ad_in_schedule_'+ad+'" style="margin-top:0px;" id="add_ad_in_schedule_'+ad+'_1" onClick="validate_ad_in_price('+ad+',1)">&nbsp;</div> </div>';
        advance_add+='<div class="clear"></div></td></tr></table><div class="clear"></div><div class="errorDiv" style="display:none"><div id="neprice_error_'+ad+'_1"></div></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
        advance_add+='<div class="notesDiv"><textarea name="advance_notes_'+ad+'_1" id="advance_notes_1_'+ad+'" rows="10" cols="40"  class="lt textbox descTextbox" style="height:50px; width:485px;"  onfocus="if(this.value==\'Notes:\'){this.value=\'\';$(this).css(\'color\',\'#444444\');}" onblur="if(this.value==\'\'){this.value=\'Notes:\';$(this).css(\'color\',\'#999999\');}" >Notes:</textarea><div class="clear"></div></div>';
        advance_add+='<div class="clear"></div> </div></td><td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+ad+'"><div onclick="delete_ad_net_price('+ad+',0)" style="margin-top:0px;" class="delete_schedule_adv">&nbsp;</div>';
        advance_add+='<div class="add_ad_schedule" style="margin-top:0px;" id="add_ad_schedule_'+ad+'" onClick="validate_notes_adprice('+ad+')">&nbsp;</div>    ';
        advance_add+='</div><div class="clear"></div></td></tr></table></div><div class="clear"></div></div>';
		

        
        $("#advancedPriceDiv").append(advance_add);
	$("#result_save").val('');// intilizing the total divs created ;
	$("#delete_ad_discount_id_1_1").val('');// intilizing the delete the divs created;
	     $.ajax({
            type: "POST",
            url: "activity_detail/create_first_discount_type",
            data:{
                "net":"",
                "id1":ad,
                "id2":1,
                "id3":0
            },
            success: function(html){
                $("#advanced_PriceContainer_adv_"+ad+"_1").append(html);
		
            } 
        });
        $("#add_schedule_"+ad).css("display","block");
        $(".delete_schedule_adv").css("display","none");
        $("#choose_schedule_"+ad+"_1").append(append_sc);
    }
    else{
        var append_sc='';
	   
	    	
        var ew = document.getElementById("choose_schedule_"+ad+"_1");
        //var strSelectedw = ew.options[ew.selectedIndex].value;
        var strSelectedw = $("#selected_value_"+ad).val();
	
        var h2=$("#last_ad_in_discount_id_"+ad).val();
        var sd=h2.split(",")
        for(var i=0;i<sd.length;i++){
            var select_box='ad_discount_type_net_'+sd[i];
            h3=sd[i].split("_");
            var select_box='ad_discount_type_'+sd[i];
            var b=ad;
            var q=h3[1];
            var h=h3[2];
            var e = document.getElementById(select_box);
            var strSelected = e.options[e.selectedIndex].value;
			
            if(strSelected!=""){
				
                var net='net';
                var yes=validate_early_bid('',b,q,h,0,0,'');
                if (yes=='0'){
                    break;
                }
            }
            else if(strSelected=="Multiple Session Discount"){
                var net='net';
                var yes=validate_session('',b,q,h,0,0,'');
                if (yes=='0'){
                    break;
                }
					
            }
            else if(strSelected=="Multiple Participant Discount"){
                var net='net';
                var yes=validate_participant('',b,q,h,0,0,'');
                if (yes=='0'){
                    break;
                }
				
				
            }
            else{
		   
                var net='';
                var yes=validate_nothing_selected('',b,q,h,0,0,'');
                if(yes=='0'){
                    break;
                }
            //alert(yes);
            }
        }
        if(yes==1){
        
            var  yt=$('#total_schedule').val();
            var byt=yt.slice(0,-5);
            $('#changing_schedule_adv_base').val(byt);
            $('#changing_schedule_decide_adv').val('');
            $('#changing_schedule_decide_adv').val('1');
					  
					  
            $( "#choose_schedule_"+ad+"_1" ).css( "display","none" );
            $( "#setWidthPrice3_"+ad ).css( "display","none" );
	       
            $( "#schedule_heading_"+ad ).css( "display","block" );
            $( "#selected_schedule_ad_"+ad).css( "display","block" );
	       
            strSelectedw=strSelectedw.split('_');
            $( "#selected_schedule_ad_"+ad ).text( strSelectedw[0]);
	       
            $( "#choose_schedule_"+ad+"_1" ).removeClass( "choose_schedule" );
            choose_schedules(ad,'adv') ;
            $( "#choose_schedule_"+ad+"_1" ).css( "pointer-events"," none"  );
            $( "#choose_schedule_"+ad+"_1" ).css(" cursor","default" );
            var schedules=$('#changing_schedule_adv').val();
            schedules=schedules.split("</br>");
            ad++;
            if(schedules.length>=1 && strSelectedw!="select all" ){
				    
                for(k=0;k<schedules.length;k++)
                {
                    sc_hed=schedules[k].split('_');
                    append_sc+= '<option value="' + schedules[k] + '">' + sc_hed[0] + '</option>';
                }
					
            }
            if(ad>1)
            {
                $(".delete_schedule_adv").css("display","block");
				    				    
            }
				
				
				
            $(".add_ad_schedule").css("display","none");
            var  advance_add='';
            advance_add+='<div class="priceContainer"  id="priceContainerDiv_'+ad+'">  <input type="hidden" name="earlybid_decide_adv_'+ad+'_1" id="earlybid_decide_adv_'+ad+'_1" value="0"><input type="hidden" name="delete_ad_discount_id_'+ad+'_1" id="delete_ad_discount_id_'+ad+'_1" value="'+ad+'_1_0"><input type="hidden" name="inner_div_count_'+ad+'_1" id="inner_div_count_'+ad+'_1" value="'+ad+'_1"><input type="hidden" name="early_div_count_'+ad+'_1" id="early_div_count_'+ad+'_1" value="'+ad+'_1_0"><input type="hidden" name="selected_value_'+ad+'" id="selected_value_'+ad+'" value=""><input type="hidden" id="chosen_ad_sc_'+ad+'_1" name="chosen_ad_sc_'+ad+'_1" value=""><input type="hidden" name="last_in_ad_discount_id_'+ad+'" id="last_in_ad_discount_id_'+ad+'" value="'+ad+'_1_0"><input id="last_ad_in_discount_id_'+ad+'" type="hidden" value="'+ad+'_1_0" name="last_ad_in_discount_id_'+ad+'"><input id="last_ad_discount_id_'+ad+'_1" type="hidden" value="0" name="last_ad_discount_id_'+ad+'_1"><table cellpadding="0" cellspacing="0" border="0"><tr>	<td><div class="priceOuterDiv" id="priceOuterDiv_'+ad+'"><table cellpadding="0" cellspacing="0" border="0" id="advance_price_div_'+ad+'_1_0"><tr  id="advance_row_'+ad+'_1"><td><div class="lt advancedPriceContainer" id="advanced_PriceContainer_adv_'+ad+'_1" ><div id="schedule_heading_'+ad+'"  class="schedule_heading_1" style="display:none">Chosen Schedule </div><div class="selected_schedule_ad_1" id="selected_schedule_ad_'+ad+'" style="display:none"></div><div class="priceRow1_top" style="padding-top:0px;"><div class="lt blackText setWidthPrice3"   style="width: :160px;" id="setWidthPrice3_'+ad+'">Choose Schedule</div><div class="lt blackText setWidthPrice">Payment Period</div><div class="lt blackText setWidthPrice1" id="display_fst_text_'+ad+'_1">Max No. of Hour(s)</div><div class="lt blackText setWidthPrice2" id="display_sec_text_'+ad+'_1" style="display:none;"></div><div class="lt blackText" id="pricelabel_'+ad+'_1">Price</div><div class="clear"></div></div>';
            advance_add+='<div class="clear"></div><div class="priceRow1_bottom"><div class="lt"><select  onchange="choose_schedule('+ad+',\'adv\')" name="choose_schedule_'+ad+'_1" id="choose_schedule_'+ad+'_1" class="drop_down_left width_set7 choose_schedule" style="margin-right: 5px;"><option value="" selected="selected">--Choose--</option></select></div>  ';
            advance_add+='<div class="lt"><select name="ads_payment_'+ad+'_1" id="ad_payment_'+ad+'_1" class="drop_down_left width_set5" onchange="payTypeChanged('+ad+',1,this.value)" onkeyup="payTypeChanged(1,1,this.value)"><option value="Per Hour" >Per Hour</option><option value="Class Card">Class Card</option><option value="Per Session">Per Session</option><option value="Weekly">Weekly</option><option value="Monthly">Monthly</option><option value="Yearly">Yearly</option></select></div>  ';
            advance_add+='<input type="text" id="ad_payment_box_fst_'+ad+'_1" name="ad_payment_box_fst_'+ad+'_1" class="lt textbox" value="Eg: 3" maxlength="5" style="width:107px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
            advance_add+='<input type="text" id="ad_payment_box_sec_'+ad+'_1" name="ad_payment_box_sec_'+ad+'_1" class="lt textbox" value="Eg: 3" maxlength="5" style="display:none;width:100px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
            advance_add+='<input type="text" id="ad_price_'+ad+'_1" name="ad_price_'+ad+'_1" class="lt textbox" value="$" maxlength="7" style="width:100px" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" />';
            advance_add+='</div><div class="clear"></div>	<input type="hidden" name="multiple_discount_count_'+ad+'_1" id="multiple_discount_count_'+ad+'_1" value="1"/><div class="createDynamicDiscount_'+ad+'_1_0"></div><div class="clear"></div>';
          /********/
	 /*   advance_add+='<div id="staticDiscount_'+ad+'_1_0"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_'+ad+'_1_0">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_'+ad+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div>';
            advance_add+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type" id="discount_type_'+ad+'_1_0"><select name="ad_discount_type_'+ad+'_1_0" id="ad_discount_type_'+ad+'_1_0" class="drop_down_left width_set6" onchange="discTypeChanged(\'\','+ad+',1,0,this.value);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'\',1,1,this.value)"><option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div>   ';
            advance_add+='<div id="session_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li> </ul></li></ul><div class="clear"></div></div></div>';
            advance_add+='<input type="text" id="ad_no_sess_'+ad+'_1_0" name="ad_no_sess_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
            advance_add+='<input type="text" id="ad_discount_sess_price_'+ad+'_1_0" name="ad_discount_sess_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
            advance_add+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_'+ad+'_1_0" id="ad_discount_sess_price_type_'+ad+'_1_0" class="drop_down_left width_set3"> <option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
            advance_add+='<div class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_session(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>    ';
            advance_add+='<div class="clear"></div> <div class="errorDiv" style="display:none"><div id="advance_session_error_'+ad+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
            advance_add+='<div id="participant_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu">';
            advance_add+='<ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li> </ul></li></ul>';
            advance_add+='<div class="clear"></div></div></div><input type="text" id="ad_no_part_'+ad+'_1_0" name="ad_no_part_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
            advance_add+='<input type="text" id="ad_discount_part_price_'+ad+'_1_0" name="ad_discount_part_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
            advance_add+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_'+ad+'_1_0" id="ad_discount_part_price_type_'+ad+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option> </select></div>';
            advance_add+='<div class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_participant(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
            advance_add+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_'+ad+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div>    ';
            advance_add+='<div class="clear"></div><div id="early_brid_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul>';
            advance_add+='<li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
            advance_add+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText" style="width:154px" >Valid  Until</div><div class="lt blackText setWidthDiscount" id="no_part_net_'+ad+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
            advance_add+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_'+ad+'_1_0" name="ad_no_subs_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
            advance_add+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_'+ad+'_1_0" name="ad_valid_date_'+ad+'_1_0" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_'+ad+'_1_0" name="ad_valid_date_alt_'+ad+'_1_0" value="" /></div></div>    ';
            advance_add+='<input type="text" id="ad_discount_price_'+ad+'_1_0" name="ad_discount_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
            advance_add+='<div class="lt price_type"><select name="ad_discount_price_type_'+ad+'_1_0" id="ad_discount_price_type_'+ad+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
            advance_add+='<div class="lt add_delete_icons" id="early_bid_icons_'+ad+'_1_0"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onclick="validate_early_bid(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img width="22" height="22" src="/assets/create_new_activity/add_icon.png" alt=""></a></div>';
            advance_add+='<div class="clear"></div><div class="clear"></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_'+ad+'_1_0"></div></div><div class="clear"></div></div>';
          */
           /******************/
	    advance_add+='<div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div><div class="errorDiv" style="display:none;"><div id="advance_error_'+ad+'_1_0"></div></div><div class="clear"></div></div>';
            advance_add+='</td>';
            advance_add+='<td valign="bottom">  <div class="delete_schedule d_delete_schedule_'+ad+'"  id="adv_inn_delete_schedule_'+ad+'_1" style="margin-top:0px;display:none;" onclick="delete_ad_in_price('+ad+',1)">&nbsp;</div> <div class="add_ad_in_schedule add_ad_in_schedule_'+ad+'" style="margin-top:0px;" id="add_ad_in_schedule_'+ad+'_1" onClick="validate_ad_in_price('+ad+',1)">&nbsp;</div> </div>';
            advance_add+='<div class="clear"></div></td></tr></table><div class="clear"></div><div class="errorDiv" style="display:none"><div id="neprice_error_'+ad+'_1"></div></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
            advance_add+='<div class="notesDiv">	<textarea name="advance_notes_'+ad+'_1" id="advance_notes_1_'+ad+'" rows="10" cols="40"  class="lt textbox descTextbox" style="height:50px; width:485px;"  onfocus="if(this.value==\'Notes:\'){this.value=\'\';$(this).css(\'color\',\'#444444\');}" onblur="if(this.value==\'\'){this.value=\'Notes:\';$(this).css(\'color\',\'#999999\');}" >Notes:</textarea><div class="clear"></div></div>';
            advance_add+='<div class="clear"></div> </div></td><td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+ad+'"><div onclick="delete_ad_net_price('+ad+',0)" style="margin-top:0px;" class="delete_schedule_adv">&nbsp;</div>';
            advance_add+='<div class="add_ad_schedule" style="margin-top:0px;" id="add_ad_schedule_'+ad+'" onClick="validate_notes_adprice('+ad+')">&nbsp;</div>    ';
            advance_add+='</div><div class="clear"></div></td></tr></table></div><div class="clear"></div></div>';
		
        
            $("#advancedPriceDiv").append(advance_add);
	     
		
		
		     $.ajax({
		    type: "POST",
		    url: "activity_detail/create_first_discount_type",
		    data:{
			"net":"",
			"id1":ad,
			"id2":1,
			"id3":0
		    },
		    success: function(html){
			$("#advanced_PriceContainer_adv_"+ad+"_1").append(html);
			
		    } 
		});
            $("#add_schedule_"+ad).css("display","block");
            var e = document.getElementById('billing_type');
            var strSelected = e.options[e.selectedIndex].value;
            if(strSelected=="Schedule"){
                $('#adv_continue_sc').val('');
                $('#adv_continue_sc').val('1');
            }
            else{
                $('#adv_continue_wsc').val('');
                $('#adv_continue_wsc').val('1');
            }
      
            if(schedules.length==1)
            {
                $("#add_ad_schedule_"+ad).css("display","none");
				    				    
            }
            $("#choose_schedule_"+ad+"_1").append(append_sc);
            result_save=$("#result_save").val();
            var et=ad+'_1_0';
            result_save+=','+et;
            $("#result_save").val(result_save);
            total_outer_div=$("#total_outer_div").val();
            total_outer_div+=','+ad+'_1';
            $("#total_outer_div").val(total_outer_div);
		
            $('#saving_error').css("display","none");
        }
    }
    AD_lastDivSetBg();
}

/************Advance price whole delete***************/
function delete_ad_net_price(d_ad,h)
{
    $( ".add_schedule" ).css("display","none");
    var ew1 = document.getElementById("choose_schedule_"+d_ad+"_1");
    // var strSelectedw1 = ew1.options[ew1.selectedIndex].value;
    var strSelectedw1 = $("#selected_value_"+d_ad).val();
    var schedulesw1=$('#changing_schedule_adv').val();
    var savecopy_array=schedulesw1.split("</br>");
    if((h!=1)&&(strSelectedw1!='')&&(schedulesw1!=strSelectedw1)){
        if(schedulesw1!=''){
            var index101 = savecopy_array.indexOf(strSelectedw1);
            if(index101==-1){
                schedulesw1+='</br>'+strSelectedw1;
            }
        }
        else{
            schedulesw1+=strSelectedw1;
	    
        }
        strSelectedw2=strSelectedw1.split('_');
        $('select.choose_schedule').append('<option  value="' + strSelectedw1 + '">' + strSelectedw2[0]+ '</option>');
    }
    //else{// anand('456');}
    $('#changing_schedule_adv').val('');
    $('#changing_schedule_adv').val(schedulesw1);
	
    var last_ad_discount=$("#last_ad_in_discount_id_"+d_ad).val();
    last_ad_discount=last_ad_discount.split(',');
    result_save=$("#result_save").val();
    result_save=result_save.split(',');
    if((result_save.length>1)&&($('#selected_value_'+d_ad).val()!='')){
        for(m=0;m<result_save.length;m++)
        {
            for(n=0; n<last_ad_discount.length;n++)
            {
                var index1 = result_save.indexOf(last_ad_discount[n]);
                if (index1 > -1) {
                    result_save.splice(index1, 1);
                }
            }
		        
        }
        $("#result_save").val(result_save);
    }
    total_outer_div=$("#total_outer_div").val();
	
    total_outer_div=total_outer_div.split(',');
    //alert(total_outer_div);
    var index3= total_outer_div.indexOf(d_ad+'_1');
    //index3=jQuery.inArray( d_ad, total_outer_div );
    //alert(index3);alert(d_ad);
    if(total_outer_div.length>1){
        $( "#priceContainerDiv_"+d_ad).remove();
        if (index3 > -1) {
            total_outer_div.splice(index3, 1);
        }
    }
   
    //alert(total_outer_div+'last');
    $("#total_outer_div").val(total_outer_div);	
		
	
    if(result_save.length==1)
    {
        $(".delete_schedule_adv").css("display","none");
    }
    $("#result_save").val(result_save);
    

    $( ".add_ad_schedule" ).last().css("display","block");
    $( ".add_schedule" ).last().css("display","block");
    AD_lastDivSetBg();
}

/*********************Function adding Advance Price Inner div  ends************************/
				
/*********************************************************
				
					    Function adding Advance Price Inner div  starts
				
 **********************************************************/
				
var ad_in=1;
var g1;
function validate_ad_in_price(ad,ad_in)
{
    var select_box1="choose_schedule_"+ad+"_1";
    var e1 = document.getElementById(select_box1);
    //var strSelected1 = e1.options[e1.selectedIndex].value;
    var strSelected1 = $("#selected_value_"+ad).val();
    var append_sc='';
    var schedules=$('#total_schedule').val();
    schedules=schedules.split("</br>");
    for(k=0;k<schedules.length-1;k++)
    {
        append_sc+= '<option value="' + schedules[k] + '">' + schedules[k] + '</option>';
    }
	    
    var h=$("#last_ad_discount_id_"+ad+"_"+ad_in).val();
	
    var loop=$("#delete_ad_discount_id_"+ad+"_"+ad_in).val();
    sp=loop.split(',');
    for(var i=0;i<sp.length;i++){
        var t1=sp[i].split('_');
        b=t1[0];
        q=t1[1];
        h=t1[2];
        var select_box='ad_discount_type_'+ad+'_'+ad_in+'_'+h;
        var e = document.getElementById(select_box);
        var strSelected = e.options[e.selectedIndex].value;
        if(strSelected!=""){
				
            var net='net';
            var yes=validate_early_bid('',b,q,h,0,0,'');
            if (yes=='0'){
                break;
            }
        }
        else if(strSelected=="Multiple Session Discount"){
            var net='net';
            var yes=validate_session('',b,q,h,0,0,'');
            if (yes=='0'){
                break;
            }
				
        }
        else if(strSelected=="Multiple Participant Discount"){
            var net='net';
            var yes=validate_participant('',b,q,h,0,0,'');
				
            if (yes=='0'){
                break;
            }
				
        }
        else{
		   
            var net='';
            var yes=validate_nothing_selected('',b,q,h,0,0,'');
            if(yes=='0'){
                break;
            }
        //alert(yes);
        }
    }
	
    if(yes==1){
	  
        var p_hour=$( "#inner_div_count_"+ad+"_1" ).val( );
        p_hour=p_hour.split(',');
	   
        for(p_h=0;p_h<p_hour.length;p_h++)
        {
            var selected_box1="ad_payment_"+p_hour[p_h];
            var e12 = document.getElementById(selected_box1);
            var strSelected12 = e12.options[e12.selectedIndex].value;
		
            if(strSelected12=='Per Hour')
            {
		    
                var perhour='';
		   
                break;
            }
            else{
		   
                var perhour='<option  value="Per Hour">Per Hour</option>';
		     
            }
	        
        }
        $( "#choose_schedule_"+ad+"_1" ).css( "display","none" );
        $( "#setWidthPrice3_"+ad ).css( "display","none" );
	       
        $( "#schedule_heading_"+ad ).css( "display","block" );
        $( "#selected_schedule_ad_"+ad ).css( "display","block" );
	       
        strSelectedw=strSelected1.split('_');
        $( "#selected_schedule_ad_"+ad ).text( strSelectedw[0]);
	       
        //    $( "#choose_schedule_"+ad+"_1" ).removeClass( "choose_schedule" );
        $( "#choose_schedule__"+ad+"_1" ).removeClass( "choose_schedule" );
        ad_in++;
        $( "#choose_schedule_"+ad+"_1" ).css( "pointer-events"," none"  );
        $( "#choose_schedule_"+ad+"_1" ).css(" cursor","default" );
        //	$("#chosen_ad_sc_'+ad+'_1_0").css("display","none");
        $(".add_ad_in_schedule_"+ad).css("display","none");
        if(ad_in>1){
            $("#adv_inn_delete_schedule_"+ad+"_1").css("display","block");
        }
        var advance_in_add='';
        strSelected1=strSelected1.split('_');	
        advance_in_add+='<tr id="advance_row_'+ad+'_'+ad_in+'"><td><div class="lt advancedPriceContainer" id="advanced_PriceContainer_adv_'+ad+'_'+ad_in+'" ><div   class="schedule_heading_1" style="display:block">Chosen Schedule </div><div class="selected_schedule_ad_1"  style="display:block">'+strSelected1[0]+'</div><b style="font-size:14px;"><input id="choose_schedule_'+ad+'_'+ad_in+'" type="hidden" value="'+strSelected1[1]+'" name="choose_schedule_'+ad+'_'+ad_in+'"></b><div class="clear"></div><div class="priceRow1_top" style="padding-top:0px;"><div class="lt blackText setWidthPrice">Payment Period</div><div class="lt blackText setWidthPrice1" id="display_fst_text_'+ad+'_'+ad_in+'">Max No. of Hour(s)</div><div class="lt blackText setWidthPrice2" id="display_sec_text_'+ad+'_'+ad_in+'" style="display:none;"></div><div class="lt blackText" id="pricelabel_'+ad+'_'+ad_in+'">Price</div><div class="clear"></div></div>';
		
		
        advance_in_add+='<div class="clear"></div><div class="priceRow1_bottom"><div class="lt"><div class="lt"><input type="hidden" name="earlybid_decide_adv_'+ad+'_'+ad_in+'" id="earlybid_decide_adv_'+ad+'_'+ad_in+'" value="0"><input id="choose_schedule_'+ad+'_'+ad_in+'" type="hidden" value="'+strSelected1+'" name="choose_schedule_'+ad+'_'+ad_in+'"></div>  ';
			
		
        //advance_in_add+='<div class="lt blackText setWidthPrice3">Choose Schedule</div>';
		
        advance_in_add+='<div class="lt"><select name="ads_payment_'+ad+'_'+ad_in+'" id="ad_payment_'+ad+'_'+ad_in+'" class="drop_down_left width_set5" onchange="payTypeChanged('+ad+','+ad_in+',this.value)" onkeyup="payTypeChanged(1,1,this.value)">'+perhour+'<option value="Class Card">Class Card</option><option value="Per Session">Per Session</option><option value="Weekly">Weekly</option><option value="Monthly">Monthly</option><option value="Yearly">Yearly</option></select></div>  ';
        advance_in_add+='<input type="text" id="ad_payment_box_fst_'+ad+'_'+ad_in+'" name="ad_payment_box_fst_'+ad+'_'+ad_in+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:107px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_in_add+='<input type="text" id="ad_payment_box_sec_'+ad+'_'+ad_in+'" name="ad_payment_box_sec_'+ad+'_'+ad_in+'" class="lt textbox" value="Eg: 3" maxlength="5" style="display:none;width:100px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_in_add+='<input type="text" id="ad_price_'+ad+'_'+ad_in+'" name="ad_price_'+ad+'_'+ad_in+'" class="lt textbox" value="$" maxlength="7" style="width:100px" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" />';
        advance_in_add+='</div><div class="clear"></div>	<input type="hidden" name="multiple_discount_count_'+ad+'_'+ad_in+'_0" id="multiple_discount_count_'+ad+'_'+ad_in+'_0" value="1"/><div class="createDynamicDiscount_'+ad+'_'+ad_in+'_0"></div><div class="clear"></div>';
        /***********/
	/*advance_in_add+='<div id="staticDiscount_'+ad+'_'+ad_in+'_0"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_'+ad+'_'+ad_in+'_0">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_'+ad+'_'+ad_in+'_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div>';
        advance_in_add+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type" id="discount_type_'+ad+'_'+ad_in+'_0"><select name="ad_discount_type_'+ad+'_'+ad_in+'_0" id="ad_discount_type_'+ad+'_'+ad_in+'_0" class="drop_down_left width_set6" onchange="discTypeChanged(\'\','+ad+','+ad_in+',0,this.value);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'\',1,1,this.value)"><option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div>   ';
        advance_in_add+='<div id="session_'+ad+'_'+ad_in+'_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li> </ul></li></ul><div class="clear"></div></div></div>';
        advance_in_add+='<input type="text" id="ad_no_sess_'+ad+'_'+ad_in+'_0" name="ad_no_sess_'+ad+'_'+ad_in+'_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_in_add+='<input type="text" id="ad_discount_sess_price_'+ad+'_'+ad_in+'_0" name="ad_discount_sess_price_'+ad+'_'+ad_in+'_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_in_add+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_'+ad+'_'+ad_in+'_0" id="ad_discount_sess_price_type_'+ad+'_'+ad_in+'_0" class="drop_down_left width_set3"> <option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
        advance_in_add+='<div class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+','+ad_in+',0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_'+ad_in+'">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_session(\'\','+ad+','+ad_in+',0,0,1)"  class="lt addButton_'+ad+'_'+ad_in+' single_add_'+ad+'_'+ad_in+'_0" style="display:inline-block; position:relative;left:10px;"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>    ';
        advance_in_add+='<div class="clear"></div> <div class="errorDiv" style="display:none"><div id="advance_session_error_'+ad+'_'+ad_in+'_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
        advance_in_add+='<div id="participant_'+ad+'_'+ad_in+'_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu">';
        advance_in_add+='<ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li> </ul></li></ul>';
        advance_in_add+='<div class="clear"></div></div></div><input type="text" id="ad_no_part_'+ad+'_'+ad_in+'_0" name="ad_no_part_'+ad+'_'+ad_in+'_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_in_add+='<input type="text" id="ad_discount_part_price_'+ad+'_'+ad_in+'_0" name="ad_discount_part_price_'+ad+'_'+ad_in+'_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_in_add+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_'+ad+'_'+ad_in+'_0" id="ad_discount_part_price_type_'+ad+'_'+ad_in+'_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option> </select></div>';
        advance_in_add+='<div class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+','+ad_in+',0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_'+ad_in+'">&nbsp;</div><a href="javascript:void(0)" id="single_add_'+ad+'_'+ad_in+'_0" class="lt addButton_'+ad+'_'+ad_in+' single_add_'+ad+'_'+ad_in+'_0" title="" onClick="validate_participant(\'\','+ad+','+ad_in+',0,0,1)" style="display:inline-block; position:relative;left:10px;"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
        advance_in_add+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_'+ad+'_'+ad_in+'_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div>    ';
        advance_in_add+='<div class="clear"></div><div id="early_brid_'+ad+'_'+ad_in+'_0" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul>';
        advance_in_add+='<li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
        advance_in_add+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText">Valid  Until</div><div class="lt blackText setWidthDiscount" id="no_part_net_'+ad+'_'+ad_in+'_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
        advance_in_add+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_'+ad+'_'+ad_in+'_0" name="ad_no_subs_'+ad+'_'+ad_in+'_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_in_add+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_'+ad+'_'+ad_in+'_0" name="ad_valid_date_'+ad+'_'+ad_in+'_0" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_'+ad+'_'+ad_in+'_0" name="ad_valid_date_alt_'+ad+'_'+ad_in+'_0" value="" /></div></div>    ';
        advance_in_add+='<input type="text" id="ad_discount_price_'+ad+'_'+ad_in+'_0" name="ad_discount_price_'+ad+'_'+ad_in+'_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
        advance_in_add+='<div class="lt price_type"><select name="ad_discount_price_type_'+ad+'_'+ad_in+'_0" id="ad_discount_price_type_'+ad+'_'+ad_in+'_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
        advance_in_add+='<div id="early_bid_icons_'+ad+'_'+ad_in+'_0" class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+','+ad_in+',0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_'+ad_in+'">&nbsp;</div><a class="lt addButton_'+ad+'_'+ad_in+'  single_add_'+ad+'_'+ad_in+'_0" style="display:inline-block; position:relative;left:10px;" onclick="validate_early_bid(\'\','+ad+','+ad_in+',0,0,1)" title="" href="javascript:void(0)"><img width="22" height="22" alt="" src="/assets/create_new_activity/add_icon.png"></a></div>';
        advance_in_add+='<div class="clear"></div></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_'+ad+'_'+ad_in+'_0"></div></div><div class="clear"></div></div>';
        */
	/*****************/
	advance_in_add+='<div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div><div class="errorDiv" style="display:none;"><div id="advance_error_'+ad+'_'+ad_in+'_0"></div></div><div class="clear"></div></div><div class="clear"></div>';
		
        advance_in_add+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="neprice_error_'+ad+'_'+ad_in+'"></div></div><div class="clear"></div></td><td valign="bottom"><div onclick="delete_ad_in_price('+ad+','+ad_in+')" style="margin-top:0px;" class="delete_schedule d_delete_schedule_'+ad+'">&nbsp;</div><div class="add_ad_in_schedule add_ad_in_schedule_'+ad+'" style="margin-top:0px;" id="add_ad_in_schedule_'+ad+'_'+ad_in+'" onClick="validate_ad_in_price('+ad+','+ad_in+')">&nbsp;</div> </div>';
        advance_in_add+='<input type="hidden" name="delete_ad_discount_id_'+ad+'_'+ad_in+'" id="delete_ad_discount_id_'+ad+'_'+ad_in+'" value="'+ad+'_'+ad_in+'_0"><input type="hidden" name="last_ad_discount_id_'+ad+'_'+ad_in+'" id="last_ad_discount_id_'+ad+'_'+ad_in+'" value="0"><input type="hidden" name="early_div_count_'+ad+'_'+ad_in+'" id="early_div_count_'+ad+'_'+ad_in+'" value="'+ad+'_'+ad_in+'_0"><div class="clear"></div></td></tr>';
        advance_in_add+='';
		
        var values=$("#last_ad_in_discount_id_"+b).val();
        var et=ad+'_'+ad_in+"_0";
        values+=","+et;
		
        $("#last_ad_in_discount_id_"+ad).val(values);
	
        $('.d_delete_schedule_'+ad).css('display','block');
        //$("#last_in_discount_id_"+b).val(values);
        var disp_add='add_ad_in_schedule_'+ad+'_'+ad_in;
        $("#"+disp_add).css("display","block");
        var idw='advance_price_div_'+ad+'_1_0';
        $("#"+idw).append(advance_in_add);
	$("#choose_schedule_"+ad+"_"+ad_in).append(append_sc);
        $('#adv_continue_sc').val('');
        $('#adv_continue_sc').val('1');
        result_save=$("#result_save").val();
        result_save+=','+et;
        $("#result_save").val(result_save);
        var inner_div_count=$("#inner_div_count_"+ad+"_1").val();
        inner_div_count+=','+ad+'_'+ad_in;
        $("#inner_div_count_"+ad+"_1").val(inner_div_count);
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	/**************************  adding early bid divs into loop            **************************/
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	  $.ajax({
            type: "POST",
            url: "activity_detail/create_first_discount_type",
            data:{
                "net":"",
                "id1":ad,
                "id2":ad_in,
                "id3":0
            },
            success: function(html){
                $("#advanced_PriceContainer_adv_"+ad+"_"+ad_in).append(html);
		
            } 
        });
		
    }
}

/**************inner advance Delete***************/

function delete_ad_in_price(ad,ad_in)
{
    var b=ad;
    var q=ad_in;
   
    var in_net_delets=$("#delete_ad_discount_id_"+b+"_"+q).val();
    var values=$("#last_ad_in_discount_id_"+b).val();
    values=values.split(',');

    in_net_delets=in_net_delets.split(',');

    for(i=0;i<values.length;i++)
    {
        for(j=0; j<in_net_delets.length;j++)
        {
            var index = values.indexOf(in_net_delets[j]);
            if (index > -1) {
                values.splice(index, 1);
            }
        }
    }
    result_save=$("#result_save").val();
    result_save=result_save.split(',');
    for(m=0;m<result_save.length;m++)
    {
        for(n=0; n<in_net_delets.length;n++)
        {
            var index1 = result_save.indexOf(in_net_delets[n]);
            if (index1 > -1) {
                result_save.splice(index1, 1);
            }
        }
		
    }
	
    if(q>1){
        $("#adv_inn_delete_schedule_"+ad+"_1").css("display","block");
    }
    if(values.length==1){
		    
        $( ".d_delete_schedule_"+ad ).css("display","none");
    }
		
    $("#result_save").val(result_save);
    $("#last_ad_in_discount_id_"+b).val(values);
    var del_id='advance_row_'+ad+'_'+ad_in;
	
    var inner_div_count=$("#inner_div_count_"+ad+"_1").val();
	
    var cou_nt=ad+'_'+ad_in;
    inner_div_count=inner_div_count.split(',');
    var index1 = inner_div_count.indexOf(cou_nt);
    if (index1 > -1) {
        inner_div_count.splice(index1, 1);
    }
    $("#inner_div_count_"+ad+"_1").val(inner_div_count);
	
    $( "#"+del_id).remove();
    
    $( ".add_ad_in_schedule_"+ad ).last().css("display","block");
	AD_lastDivSetBg();
}

/*********************Function adding Advance Price Inner div  ends************************/

/*********************Functions Editing Advance Price and its Inner div  starts************************/

  
  
function advance_edit_price(ad){
    var  advance_add_edit='';
		  
    advance_add_edit+='<div class="priceContainer"  id="priceContainerDiv_'+ad+'"><input type="hidden" name="earlybid_decide_adv_'+ad+'_1" id="earlybid_decide_adv_'+ad+'_1" value="0"><input type="hidden" id="chosen_ad_sc_'+ad+'_1" name="chosen_ad_sc_'+ad+'_1" value=""><input type="hidden" name="last_in_ad_discount_id_'+ad+'" id="last_in_ad_discount_id_'+ad+'" value="'+ad+'_1_0"><input id="last_ad_in_discount_id_'+ad+'" type="hidden" value="'+ad+'_1_0" name="last_ad_in_discount_id_'+ad+'"><input id="last_ad_discount_id_'+ad+'_1" type="hidden" value="0" name="last_ad_discount_id_'+ad+'_1"><table cellpadding="0" cellspacing="0" border="0"><tr>	<td><div class="priceOuterDiv" id="priceOuterDiv_'+ad+'"><table cellpadding="0" cellspacing="0" border="0" id="advance_price_div_'+ad+'_1_0"><tr><td><div class="lt advancedPriceContainer" id="advanced_PriceContainer_'+ad+'_1" ><div id="schedule_heading_'+ad+'"  class="schedule_heading_1" style="display:none">Chosen Schedule </div><div class="selected_schedule_ad_1" id="selected_schedule_ad_'+ad+'" style="display:none"></div><div class="priceRow1_top" style="padding-top:0px;"><div class="lt blackText setWidthPrice3"   style="width: :160px;" id="setWidthPrice3_'+ad+'">Choose Schedule</div><div class="lt blackText setWidthPrice">Payment Period</div><div class="lt blackText setWidthPrice1" id="display_fst_text_'+ad+'_1">Max No. of Hour(s)</div><div class="lt blackText setWidthPrice2" id="display_sec_text_'+ad+'_1" style="display:none;"></div><div class="lt blackText" id="pricelabel_'+ad+'_1">Price</div><div class="clear"></div></div>';
    advance_add_edit+='<div class="clear"></div><div class="priceRow1_bottom"><div class="lt"><select  onchange="choose_schedule('+ad+',\'adv\')" name="choose_schedule_'+ad+'_1" id="choose_schedule_'+ad+'_1" class="drop_down_left width_set7 choose_schedule" style="margin-right: 5px;"><option value="" selected="selected">--Choose--</option></select></div>  ';
    advance_add_edit+='<div class="lt"><select name="ads_payment_'+ad+'_1" id="ad_payment_'+ad+'_1" class="drop_down_left width_set5" onchange="payTypeChanged('+ad+',1,this.value)" onkeyup="payTypeChanged(1,1,this.value)"><option value="Per Hour" selected="selected">Per Hour</option><option value="Class Card">Class Card</option><option value="Per Session">Per Session</option><option value="Weekly">Weekly</option><option value="Monthly">Monthly</option><option value="Yearly">Yearly</option></select></div>  ';
    advance_add_edit+='<input type="text" id="ad_payment_box_fst_'+ad+'_1" name="ad_payment_box_fst_'+ad+'_1" class="lt textbox" value="Eg: 3" maxlength="5" style="width:107px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_add_edit+='<input type="text" id="ad_payment_box_sec_'+ad+'_1" name="ad_payment_box_sec_'+ad+'_1" class="lt textbox" value="Eg: 3" maxlength="5" style="display:none;width:100px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_add_edit+='<input type="text" id="ad_price_'+ad+'_1" name="ad_price_'+ad+'_1" class="lt textbox" value="$" maxlength="7" style="width:100px" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" />';
    advance_add_edit+='</div><div class="clear"></div>	<input type="hidden" name="multiple_discount_count_'+ad+'_1" id="multiple_discount_count_'+ad+'_1" value="1"/><div class="clear"></div>';
    advance_add_edit+='<div id="staticDiscount_'+ad+'_1_0"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_'+ad+'_1_0">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_'+ad+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div>';
    advance_add_edit+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type" id="discount_type_'+ad+'_1_0"><select name="ad_discount_type_'+ad+'_1_0" id="ad_discount_type_'+ad+'_1_0" class="drop_down_left width_set6" onchange="discTypeChanged(\'\','+ad+',1,0,this.value);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'\',1,1,this.value)"><option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div>   ';
    advance_add_edit+='<div id="session_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li> </ul></li></ul><div class="clear"></div></div></div>';
    advance_add_edit+='<input type="text" id="ad_no_sess_'+ad+'_1_0" name="ad_no_sess_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_add_edit+='<input type="text" id="ad_discount_sess_price_'+ad+'_1_0" name="ad_discount_sess_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_add_edit+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_'+ad+'_1_0" id="ad_discount_sess_price_type_'+ad+'_1_0" class="drop_down_left width_set3"> <option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
    advance_add_edit+='<div class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_session(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>    ';
    advance_add_edit+='<div class="clear"></div> <div class="errorDiv" style="display:none"><div id="advance_session_error_'+ad+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
    advance_add_edit+='<div id="participant_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu">';
    advance_add_edit+='<ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li> </ul></li></ul>';
    advance_add_edit+='<div class="clear"></div></div></div><input type="text" id="ad_no_part_'+ad+'_1_0" name="ad_no_part_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_add_edit+='<input type="text" id="ad_discount_part_price_'+ad+'_1_0" name="ad_discount_part_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_add_edit+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_'+ad+'_1_0" id="ad_discount_part_price_type_'+ad+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option> </select></div>';
    advance_add_edit+='<div class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_participant(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
    advance_add_edit+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_'+ad+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div>    ';
    advance_add_edit+='<div class="clear"></div><div id="early_brid_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul>';
    advance_add_edit+='<li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
    advance_add_edit+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText" style="width:154px" >Valid  Until</div><div class="lt blackText setWidthDiscount" id="no_part_net_'+ad+'_1_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
    advance_add_edit+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_'+ad+'_1_0" name="ad_no_subs_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_add_edit+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_'+ad+'_1_0" name="ad_valid_date_'+ad+'_1_0" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_'+ad+'_1_0" name="ad_valid_date_alt_'+ad+'_1_0" value="" /></div></div>    ';
    advance_add_edit+='<input type="text" id="ad_discount_price_'+ad+'_1_0" name="ad_discount_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_add_edit+='<div class="lt price_type"><select name="ad_discount_price_type_'+ad+'_1_0" id="ad_discount_price_type_'+ad+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
    advance_add_edit+='<div class="lt add_delete_icons" id="early_bid_icons_'+ad+'_1_0"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onclick="validate_early_bid(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img width="22" height="22" src="/assets/create_new_activity/add_icon.png" alt=""></a></div>';
    advance_add_edit+='<div class="clear"></div><div class="clear"></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_'+ad+'_1_0"></div></div><div class="clear"></div></div>';
    advance_add_edit+='<div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div><div class="errorDiv" style="display:none;"><div id="advance_error_'+ad+'_1_0"></div></div><div class="clear"></div><div class="createDynamicDiscount_'+ad+'_1_0"></div></div>';
    advance_add_edit+='</td>';
    advance_add_edit+='<td valign="bottom">  <div class="delete_schedule d_delete_schedule_'+ad+'"  id="adv_inn_delete_schedule_'+ad+'_1" style="margin-top:0px;display:none;" onclick="delete_ad_in_price('+ad+',1)">&nbsp;</div> <div class="add_ad_in_schedule add_ad_in_schedule_'+ad+'" style="margin-top:0px;" id="add_ad_in_schedule_'+ad+'_1" onClick="validate_ad_in_price('+ad+',1)">&nbsp;</div> </div>';
    advance_add_edit+='<div class="clear"></div></td></tr></table><div class="clear"></div><div class="errorDiv" style="display:none"><div id="neprice_error_'+ad+'_1"></div></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
    advance_add_edit+='<div class="notesDiv">	<textarea name="advance_notes_'+ad+'_1" id="advance_notes_1_'+ad+'" rows="10" cols="40"  class="lt textbox descTextbox" style="height:50px; width:485px;"  onfocus="if(this.value==\'Notes:\'){this.value=\'\';$(this).css(\'color\',\'#444444\');}" onblur="if(this.value==\'\'){this.value=\'Notes:\';$(this).css(\'color\',\'#999999\');}" >Notes:</textarea><div class="clear"></div></div>';
    advance_add_edit+='<div class="clear"></div> </div></td><td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+ad+'"><div onclick="delete_ad_net_price('+ad+',0)" style="margin-top:0px;" class="delete_schedule_adv">&nbsp;</div>';
    advance_add_edit+='<div class="add_ad_schedule" style="margin-top:0px;" id="add_ad_schedule_'+ad+'" onClick="validate_notes_adprice('+ad+')">&nbsp;</div>    ';
    advance_add_edit+='</div><div class="clear"></div></td></tr></table></div><div class="clear"></div></div><input type="hidden" name="delete_ad_discount_id_'+ad+'_1" id="delete_ad_discount_id_'+ad+'_1" value="'+ad+'_1_0"><input type="hidden" name="inner_div_count_'+ad+'_1" id="inner_div_count_'+ad+'_1" value="'+ad+'_1"><input type="hidden" name="early_div_count_'+ad+'_1" id="early_div_count_'+ad+'_1" value="'+ad+'_1_0">';
		
    $("add_schedule_"+ad).css("display","block");
    $("#advancedPriceDiv").append(advance_add_edit);
        
        
}
function advance_inner_edit(ad,ad_in)
{
    var advance_in_edit='';
    
    advance_in_edit+='<tr id="advance_row_'+ad+'_'+ad_in+'"><td><div class="lt advancedPriceContainer" id="advanced_PriceContainer_'+ad+'_'+ad_in+'" ><div   class="schedule_heading_1" style="display:block">Chosen Schedule </div><div class="selected_schedule_ad_1"  style="display:block">'+strSelected1[0]+'</div><b style="font-size:14px;"><input id="choose_schedule_'+ad+'_'+ad_in+'" type="hidden" value="'+strSelected1[1]+'" name="choose_schedule_'+ad+'_'+ad_in+'"></b><div class="clear"></div><div class="priceRow1_top" style="padding-top:0px;"><div class="lt blackText setWidthPrice">Payment Period</div><div class="lt blackText setWidthPrice1" id="display_fst_text_'+ad+'_'+ad_in+'">Max No. of Hour(s)</div><div class="lt blackText setWidthPrice2" id="display_sec_text_'+ad+'_'+ad_in+'" style="display:none;"></div><div class="lt blackText" id="pricelabel_'+ad+'_'+ad_in+'">Price</div><div class="clear"></div></div>';
		
		
    advance_in_edit+='<div class="clear"></div><div class="priceRow1_bottom"><div class="lt"><input type="hidden" name="earlybid_decide_adv_'+ad+'_'+ad_in+'" id="earlybid_decide_adv_'+ad+'_'+ad_in+'" value="0"><input id="choose_schedule_'+ad+'_'+ad_in+'" type="hidden" value="'+strSelected1+'" name="choose_schedule_'+ad+'_'+ad_in+'"></div>  ';
			
		
    //advance_in_edit+='<div class="lt blackText setWidthPrice3">Choose Schedule</div>';
		
    advance_in_edit+='<div class="lt"><select name="ads_payment_'+ad+'_'+ad_in+'" id="ad_payment_'+ad+'_'+ad_in+'" class="drop_down_left width_set5" onchange="payTypeChanged('+ad+','+ad_in+',this.value)" onkeyup="payTypeChanged(1,1,this.value)">perhour<option value="Class Card">Class Card</option><option value="Per Session">Per Session</option><option value="Weekly">Weekly</option><option value="Monthly">Monthly</option><option value="Yearly">Yearly</option></select></div>  ';
    advance_in_edit+='<input type="text" id="ad_payment_box_fst_'+ad+'_'+ad_in+'" name="ad_payment_box_fst_'+ad+'_'+ad_in+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:107px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_in_edit+='<input type="text" id="ad_payment_box_sec_'+ad+'_'+ad_in+'" name="ad_payment_box_sec_'+ad+'_'+ad_in+'" class="lt textbox" value="Eg: 3" maxlength="5" style="display:none;width:100px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_in_edit+='<input type="text" id="ad_price_'+ad+'_'+ad_in+'" name="ad_price_'+ad+'_'+ad_in+'" class="lt textbox" value="$" maxlength="7" style="width:100px" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" />';
    advance_in_edit+='</div><div class="clear"></div>	<input type="hidden" name="multiple_discount_count_'+ad+'_'+ad_in+'_0" id="multiple_discount_count_'+ad+'_'+ad_in+'_0" value="1"/><div class="clear"></div>';
    advance_in_edit+='<div class="staticDiscount_'+ad+'_'+ad_in+'_0"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_'+ad+'_'+ad_in+'_0">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_'+ad+'_'+ad_in+'_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div>';
    advance_in_edit+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type" id="discount_type_'+ad+'_'+ad_in+'_0"><select name="ad_discount_type_'+ad+'_'+ad_in+'_0" id="ad_discount_type_'+ad+'_'+ad_in+'_0" class="drop_down_left width_set6" onchange="discTypeChanged(\'\','+ad+','+ad_in+',0,this.value);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'\',1,1,this.value)"><option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div>   ';
    advance_in_edit+='<div id="session_'+ad+'_'+ad_in+'_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li> </ul></li></ul><div class="clear"></div></div></div>';
    advance_in_edit+='<input type="text" id="ad_no_sess_'+ad+'_'+ad_in+'_0" name="ad_no_sess_'+ad+'_'+ad_in+'_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_in_edit+='<input type="text" id="ad_discount_sess_price_'+ad+'_'+ad_in+'_0" name="ad_discount_sess_price_'+ad+'_'+ad_in+'_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_in_edit+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_'+ad+'_'+ad_in+'_0" id="ad_discount_sess_price_type_'+ad+'_'+ad_in+'_0" class="drop_down_left width_set3"> <option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
    advance_in_edit+='<div class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+','+ad_in+',0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_'+ad_in+'">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_session(\'\','+ad+','+ad_in+',0,0,1)"  class="lt addButton_'+ad+'_'+ad_in+' single_add_'+ad+'_'+ad_in+'_0" style="display:inline-block; position:relative;left:10px;"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>    ';
    advance_in_edit+='<div class="clear"></div> <div class="errorDiv" style="display:none"><div id="advance_session_error_'+ad+'_'+ad_in+'_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
    advance_in_edit+='<div id="participant_'+ad+'_'+ad_in+'_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu">';
    advance_in_edit+='<ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li> </ul></li></ul>';
    advance_in_edit+='<div class="clear"></div></div></div><input type="text" id="ad_no_part_'+ad+'_'+ad_in+'_0" name="ad_no_part_'+ad+'_'+ad_in+'_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_in_edit+='<input type="text" id="ad_discount_part_price_'+ad+'_'+ad_in+'_0" name="ad_discount_part_price_'+ad+'_'+ad_in+'_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_in_edit+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_'+ad+'_'+ad_in+'_0" id="ad_discount_part_price_type_'+ad+'_'+ad_in+'_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option> </select></div>';
    advance_in_edit+='<div class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+','+ad_in+',0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_'+ad_in+'">&nbsp;</div><a href="javascript:void(0)" id="single_add_'+ad+'_'+ad_in+'_0" class="lt addButton_'+ad+'_'+ad_in+' single_add_'+ad+'_'+ad_in+'_0" title="" onClick="validate_participant(\'\','+ad+','+ad_in+',0,0,1)" style="display:inline-block; position:relative;left:10px;"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
    advance_in_edit+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_'+ad+'_'+ad_in+'_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div>    ';
    advance_in_edit+='<div class="clear"></div><div id="early_brid_'+ad+'_'+ad_in+'_0" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul>';
    advance_in_edit+='<li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
    advance_in_edit+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText">Valid  Until</div><div class="lt blackText setWidthDiscount" id="no_part_net_'+ad+'_'+ad_in+'_0"style="width:185px;">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
    advance_in_edit+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_'+ad+'_'+ad_in+'_0" name="ad_no_subs_'+ad+'_'+ad_in+'_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_in_edit+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_'+ad+'_'+ad_in+'_0" name="ad_valid_date_'+ad+'_'+ad_in+'_0" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_'+ad+'_'+ad_in+'_0" name="ad_valid_date_alt_'+ad+'_'+ad_in+'_0" value="" /></div></div>    ';
    advance_in_edit+='<input type="text" id="ad_discount_price_'+ad+'_'+ad_in+'_0" name="ad_discount_price_'+ad+'_'+ad_in+'_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    advance_in_edit+='<div class="lt price_type"><select name="ad_discount_price_type_'+ad+'_'+ad_in+'_0" id="ad_discount_price_type_'+ad+'_'+ad_in+'_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
    advance_in_edit+='<div id="early_bid_icons_'+ad+'_'+ad_in+'_0" class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+','+ad_in+',0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_'+ad_in+'">&nbsp;</div><a class="lt addButton_'+ad+'_'+ad_in+'  single_add_'+ad+'_'+ad_in+'_0" style="display:inline-block; position:relative;left:10px;" onclick="validate_early_bid(\'\','+ad+','+ad_in+',0,0,1)" title="" href="javascript:void(0)"><img width="22" height="22" alt="" src="/assets/create_new_activity/add_icon.png"></a></div>';
    advance_in_edit+='<div class="clear"></div></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_'+ad+'_'+ad_in+'_0"></div></div><div class="clear"></div></div>';
    advance_in_edit+='<div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div><div class="errorDiv" style="display:none;"><div id="advance_error_'+ad+'_'+ad_in+'_0"></div></div><div class="clear"></div></div><div class="clear"></div>';	
    advance_in_edit+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="neprice_error_'+ad+'_'+ad_in+'"></div></div><div class="clear"></div>  <div class="createDynamicDiscount_'+ad+'_'+ad_in+'_0"></div> </td><td valign="bottom"><div onclick="delete_ad_in_price('+ad+','+ad_in+')" style="margin-top:0px;" class="delete_schedule d_delete_schedule_'+ad+'">&nbsp;</div><div class="add_ad_in_schedule add_ad_in_schedule_'+ad+'" style="margin-top:0px;" id="add_ad_in_schedule_'+ad+'_'+ad_in+'" onClick="validate_ad_in_price('+ad+','+ad_in+')">&nbsp;</div> </div>';
    advance_in_edit+='<input type="hidden" name="delete_ad_discount_id_'+ad+'_'+ad_in+'" id="delete_ad_discount_id_'+ad+'_'+ad_in+'" value="'+ad+'_'+ad_in+'_0"><input type="hidden" name="last_ad_discount_id_'+ad+'_'+ad_in+'" id="last_ad_discount_id_'+ad+'_'+ad_in+'" value="0"><input type="hidden" name="early_div_count_'+ad+'_'+ad_in+'" id="early_div_count_'+ad+'_'+ad_in+'" value="'+ad+'_'+ad_in+'_0"><div class="clear"></div></td></tr>';
    var idw='advance_price_div_'+ad+'_1_0';
    $("#"+idw).append(advance_in_edit);
}


/*********************Functions Editing Advance Price and its Inner div  starts************************/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      /*********************************   function for discount other fee start   ********************************/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
function save_new_fee()// validation save fee added
{
    $('#loading_img2').css("display","block");
    var fee_name = $('#create_fee_name').val();
    var fee_price = $('#create_fee_price').val();
    fee_name=fee_name.replace(/(\s+)+/g," ");
    fee_price=fee_price.replace(/(\s+)+/g," ");
    var er_flag;
    var error='';
    if(fee_name==" "||fee_name=="Enter Other Fee Name")
    {
        error+=' Please enter other fee name';
        er_flag=0;
    }
    if(fee_price==" "||fee_price=="Enter Price")
    {

        if(error==""){
            error+=' Please enter other fee price ';
            er_flag=0;
        }

        else{
            error+=' , other fee price ';
            er_flag=0;
        }
    }

    else if(( isNaN(fee_price))||(parseInt(fee_price)==0)){
        if(error==""){
            error+=' Please enter a valid fee price ';
            er_flag=0;
        }

        else{
            error+=' , valid fee price ';
            er_flag=0;
        }
    }
    else if(parseFloat(fee_price)<1){
        if(error==""){
            error+=' Please enter a valid fee price greater than  1 ';
            er_flag=0;
        }

        else{
            error+=' , valid fee price greater than  1  ';
            er_flag=0;
        }
    }
    if(er_flag==0){

        $('#err_tr').css("display","block");
        $('#error_feee').css("display","block");
        $('#error_feee').text(error);
        $('#loading_img2').css("display","none");    
    }
    else{
        var fee_quantity = $("#create_fee_quantity").is(':checked');
        var fee_mandatory = $("#create_fee_mand").is(':checked');
        var note = $("#create_fee_notes").val();
        $.ajax({
            type: "POST",
            url: "activity_detail/provider_fee",
            data: {
                "fee_name": fee_name,
                "fee_price":fee_price,
                "fee_quantity":fee_quantity,
                "fee_mandatory":fee_mandatory,
                "note":note
            },
            dataType : 'script'
        });
        $('#err_tr').css("display","none");
        $('#error_feee').css("display","none");
        $('#error_feee').text('');
    }
}
	
function open_add_fee()//open fee add popup
{
    $('.popupContainer').css("opacity","0");
    $('#create_fees_pop').css("display","block");
	       
	    
}

function cancel_save_fee() //cancel close fee add popup
{
    $('.popupContainer').css("opacity","1");
    $('#create_fees_pop').css("display","none");
	       
	    
}
	
function close_fee_popup() //close fee add popup
{
    $('.popupContainer').css("opacity","1");
    $('#create_fees_pop').css("display","none");
	       
	    
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
      /*********************************   funcyion for discount code start   ********************************/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
		    function set_time_for_discount(){
			var curTime = new Date();
			var cdate = curTime.getDate();
			var ccmonth = curTime.getMonth();
			var cyear = curTime.getFullYear();
			ccmonth = parseInt(ccmonth) + 1;
			      
			var weekday = new Array(7);
			weekday[0] = "Sun";
			weekday[1] = "Mon";
			weekday[2] = "Tue";
			weekday[3] = "Wed";
			weekday[4] = "Thu";
			weekday[5] = "Fri";
			weekday[6] = "Sat";
			var cday = curTime.getDay();
			var incval = parseInt(cday) + 1;
			var dayname = weekday[cday];
			      
			var monthNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];
			var cmonth = monthNames[curTime.getMonth()];
		    
			var cuday = dayname + " "+ cdate +"/"+ cmonth +"/"+ cyear;
			var alt_cuday = cyear+"-"+ cmonth +"-"+ cdate;
			$("#discount_code_start").val(cuday);
			$("#discount_code_end").val(cuday);
		    
			$("#alt_discount_code_start").val(alt_cuday);
			$("#alt_discount_code_end").val(alt_cuday);
		    
			$("#discount_code_start").datepicker({
			    showOn : "button",
			    buttonImage : "/assets/create_new_activity/date_icon.png",
			    buttonImageOnly : true,
			    minDate: 0,
			    dateFormat: "D d/m/ yy",
			    altField : "#alt_discount_code_start",
			    altFormat : "yy-m-d"
			});
			    
			$("#discount_code_end").datepicker({
			    showOn : "button",
			    buttonImage : "/assets/create_new_activity/date_icon.png",
			    buttonImageOnly : true,
			    minDate: 0,
			    dateFormat:"D d/m/ yy",
			    altField : "#alt_discount_code_end",
			    altFormat : "yy-m-d"
			});
			    
		    }
		    function open_add_discount()//open discount code add popup
		    {
			set_time_for_discount();// set the date for the start and end of disount
			$('.popupContainer').css("opacity","0");
			$('#create_disc_pop').css("display","block");
				   
				
		    }
			    
		    function cancel_save_discount()//cancel close discount code add popup
		    {
			$('.popupContainer').css("opacity","1");
			$('#create_disc_pop').css("display","none");
				   
				
		    }
			    
		    function close_discount_popup() //close discount code add popup
		    {
			$('.popupContainer').css("opacity","1");
			$('#create_disc_pop').css("display","none");
				   
				
		    }
	
	
		    function save_new_discount()// validation save discount code added
		    {
			$('#loading_img1').css("display","block");
			var disc_name= $('#discount_code_name').val();
			var disc_code= $('#discount_code').val();
			var disc_code_price = $('#discount_code_price').val();
			disc_name=disc_name.replace(/(\s+)+/g," ");
			;
			disc_code=disc_code.replace(/(\s+)+/g," ");
			;
			disc_code_price=disc_code_price.replace(/(\s+)+/g," ");
			var er_flag;
			var error='';
			if(disc_name==" "||disc_name=="Enter Discount Code Name")
			{
			    error+=' Please enter  discount code name';
			    er_flag=0;
			}
			if(disc_code==" "||disc_code=="Enter Discount Code")
			{
				  
			    if(error==""){
				error+=' Please enter discount code';
				er_flag=0;
			    }
				      
			    else{
				error+=' , discount code';
				er_flag=0;
			    }
			}
			if(disc_code_price==" "||disc_code_price=="Enter Price")
			{
				  
			    if(error==""){
				error+=' Please enter discount price';
				er_flag=0;
			    }
				      
			    else{
				error+=' , discount price';
				er_flag=0;
			    }
			}
			else if(( isNaN(disc_code_price))||(parseInt(disc_code_price)==0)){
			    if(error==""){
				error+=' Please enter a valid discount price ';
				er_flag=0;
			    }
		    
			    else{
				error+=' , valid discount price ';
				er_flag=0;
			    }
			}
			else if(parseFloat(disc_code_price)<1){
			    if(error==""){
				error+=' Please enter a valid discount price greater than  1 ';
				er_flag=0;
			    }
		    
			    else{
				error+=' , valid discount price greater than  1  ';
				er_flag=0;
			    }
			}
			if(er_flag==0){
			    
			    $('#err_trr').css("display","block");
			    $('#error_disc').css("display","block");
			    $('#error_disc').text(error);
			    $('#loading_img1').css("display","none");
			}
			else{
			    var discount_code_start = $("#alt_discount_code_start").val();
			    var discount_code_end = $("#alt_discount_code_end").val();
			    var note = $("#create_discount_notes").val();
			    $.ajax({
				type: "POST",
				url: "activity_detail/provider_discount_fee",
				data: {
				    "disc_price":disc_code_price,
				    "disc_name": disc_name,
				    "disc_code":disc_code,
				    "discount_code_start":discount_code_start,
				    "discount_code_end":discount_code_end,
				    "note":note
				},
				dataType : 'script'
			    });
			    $('#err_trr').css("display","none");
			    $('#error_disc').css("display","none");
			    $('#error_disc').text('');
			}
		    }
		    
	
	

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/*********************************  set light and dark blue background color for last ADVANCE and NET  price divs  *******************************/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		function NET_lastDivSetBg(){
			var totalOuterDiv = $("#total_div_count").val();
			var splitTotalOuterDiv = totalOuterDiv.split(",");
			var splitTotalOuterDivLength = splitTotalOuterDiv.length;
			var spID = splitTotalOuterDiv[splitTotalOuterDivLength-1];
			
			var splitSpID = spID.split("_");
			var lastID = splitSpID[0];
			
			if(splitTotalOuterDivLength>1){	
				$("#netPriceDiv .priceOuterDiv").css("background","#F9FBFA");
				$("#netPriceDiv #net_priceOuterDiv_"+lastID).css("background","#e9f6f9");
		
				$("#netPriceDiv .advancedPriceContainer").css("background","#EDF1F2");
				$("#netPriceDiv #net_priceOuterDiv_"+lastID+" .advancedPriceContainer").css("background","#d1e8ee");
				
				$("#netPriceDiv #net_priceOuterDiv_1").css("background","#F9FBFA");
				$("#netPriceDiv #net_priceOuterDiv_1 .advancedPriceContainer").css("background","#EDF1F2");
			}
			else{
				$("#netPriceDiv .priceOuterDiv").css("background","#F9FBFA");
				$("#netPriceDiv .advancedPriceContainer").css("background","#EDF1F2");
			}
		}
		function AD_lastDivSetBg(){
			var totalOuterDiv = $("#total_outer_div").val();
			var splitTotalOuterDiv = totalOuterDiv.split(",");
			var splitTotalOuterDivLength = splitTotalOuterDiv.length;
			var spID = splitTotalOuterDiv[splitTotalOuterDivLength-1];
			
			var splitSpID = spID.split("_");
			var lastID = splitSpID[0];
			
			if(splitTotalOuterDivLength>1){	
				$("#advancedPriceDiv .priceOuterDiv").css("background","#F9FBFA");
				$("#advancedPriceDiv #priceOuterDiv_"+lastID).css("background","#e9f6f9");
		
				$("#advancedPriceDiv .advancedPriceContainer").css("background","#EDF1F2");
				$("#advancedPriceDiv #priceOuterDiv_"+lastID+" .advancedPriceContainer").css("background","#d1e8ee");
				
				$("#advancedPriceDiv #priceOuterDiv_1").css("background","#F9FBFA");
				$("#advancedPriceDiv #priceOuterDiv_1 .advancedPriceContainer").css("background","#EDF1F2");
			}
			else{
				$("#advancedPriceDiv .priceOuterDiv").css("background","#F9FBFA");
				$("#advancedPriceDiv .advancedPriceContainer").css("background","#EDF1F2");
			}
		}
		
		
/* change the drop downs for age range month or year*/
function change_age_value(val,type)
{
if (type=='min')
{
if(val=='month')
{
$("#empty_min_sel").hide();
$("#min-year-col").hide();
$("#min-mon-col").show();
}
else if(val=='year')
{
$("#empty_min_sel").hide();
$("#min-mon-col").hide();
$("#min-year-col").show();
}
else
{
$("#min-mon-col").hide();
$("#min-year-col").hide();
$("#empty_min_sel").show();
}
}
else
{
if(val=='month')
{
$("#empty_max_sel").hide();
$("#max-year-col").hide();
$("#max-mon-col").show();
}
else if(val=='year')
{
$("#empty_max_sel").hide();
$("#max-mon-col").hide();
$("#max-year-col").show();
}
else
{
$("#max-mon-col").hide();
$("#max-year-col").hide();
$("#empty_max_sel").show();
}
}
}

/* validate the age ranges in create edit activities for parent and provider*/
function validate_age_ranges(min,max,age1,age2)
{
	if((min!='' && max=='') || (min=='' && max!=''))
	{
		$("#age_range_error").html("Please select age type");
		$("#age_range_error").parent().css("display","block");
		return false;
	}
	else
	{
		if(min!='' && max!='')
		{
			if(age1 == '' && age2 == '' ){
				$('#'+min+'_age1').css("border","1px solid #fc8989");
				$('#'+max+'_age2').css("border","1px solid #fc8989");
				$("#age_range_error").html("Please select age range");
				$("#age_range_error").parent().css("display","block");
				return false;
			}
			if(age1 == '' && age2 != '' ){
				$('#'+min+'_age1').css("border","1px solid #fc8989");
				$("#age_range_error").html("Please select min age range");
				$("#age_range_error").parent().css("display","block");
				return false;
			}
			if(age1 != '' && age2 == '' ){
				$('#'+max+'_age2').css("border","1px solid #fc8989");
				$("#age_range_error").html("Please select max age range");
				$("#age_range_error").parent().css("display","block");
				return false;
			}

			if(min=='year' && max=='year')
			{
				if(age1 == "Adults" && age2 != "Adults") {
					$('#'+max+'_age2').css("border","1px solid #fc8989");
					$("#age_range_error").html("Please select valid max range");
					$("#age_range_error").parent().css("display","block");
					return false;
				}
				if(age1 == "All" && age2 != "All") {
					$('#'+max+'_age2').css("border","1px solid #fc8989");
					$("#age_range_error").html("Please select valid max range");
					$("#age_range_error").parent().css("display","block");
					return false;
				}
				if((parseInt(age2) < parseInt(age1)) && (age1 != "Adults") && (age2 != "Adults") && (age1 != "All") && (age2 != "All")){
					$('#'+max+'_age2').css("border","1px solid #fc8989");
					$("#age_range_error").html("Please select valid max range");
					$("#age_range_error").parent().css("display","block");
					return false;
				}
			}

			if(min=='month' && max=='month')
			{
				if((parseInt(age2) < parseInt(age1)) /*|| ((parseInt(age1) == 0) && (parseInt(age2) == 0))*/){
                                       $('#'+max+'_age2').css("border","1px solid #fc8989");
				       $("#age_range_error").html("Please select valid max range");
				       $("#age_range_error").parent().css("display","block");
				       return false;
				}
			}

			if (min=='year' && max=='month')
			{
				$('#'+max+'_age2').css("border","1px solid #fc8989");
				$("#age_range_error").html("Please select valid max range");
				$("#age_range_error").parent().css("display","block");
				return false;
			}
			else
			{
				return true;
			}
		}
		else
		{
			return true;
		}
	}
}