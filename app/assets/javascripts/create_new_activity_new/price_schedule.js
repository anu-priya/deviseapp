/***********************
	 Validations
 ***********************/

function validate_payment(fst_id,sec_id,th_id){  
    var ad_payment = $('#ad_payment_'+fst_id+'_'+sec_id).val();
    var ad_payment_box_fst = $('#ad_payment_box_fst_'+fst_id+'_'+sec_id).val();
    var ad_payment_box_sec = $('#ad_payment_box_sec_'+fst_id+'_'+sec_id).val();
    var ad_price = $('#ad_price_'+fst_id+'_'+sec_id).val();	
    
    ad_payment = ad_payment.replace(/^\s+|\s+$/g, "");
    ad_payment_box_fst = ad_payment_box_fst.replace(/^\s+|\s+$/g, "");
    ad_payment_box_sec = ad_payment_box_sec.replace(/^\s+|\s+$/g, "");
    ad_price = ad_price.replace(/^\s+|\s+$/g, "");
	
    var firstVal_ad_payment = ad_payment.charAt(0);
    var firstVal_ad_price = ad_price.charAt(0);
    var firstVal_ad_payment_box_fst = ad_payment_box_fst.charAt(0);
    var firstVal_ad_payment_box_sec = ad_payment_box_sec.charAt(0);
		
    var msg1='Please enter ';
    var msg='';
	
    if( ( ad_payment_box_fst == 'Eg: 3' || ad_payment_box_fst == ''  ) && ( ad_payment_box_sec == 'Eg: 3' || ad_payment_box_sec == '' ) ){
        if(ad_payment=="Per Hour"){
            msg+='no. of hour(s)';
        }
        if(ad_payment=="Class Card"){
            msg+='no. of classes';
        }
        if(ad_payment=="Per Session"){
            msg+='no. of day(s) or no. of hour(s)';
        }
        if(ad_payment=="Weekly"){
            msg+='no. of week(s)';
        }
        if(ad_payment=="Monthly"){
            msg+='no. of month(s)';
        }
        if(ad_payment=="Yearly"){
            msg+='no. of year(s)';
        }
    }
    if(ad_payment_box_fst != '' && ad_payment_box_fst != 'Eg: 3'  ){
        if(!validateNumber(ad_payment_box_fst)){
            if(ad_payment=="Per Hour"){
                msg+='valid no. of hour(s)';
            }
            if(ad_payment=="Class Card"){
                msg+='valid no. of class(s)';
            }
            if(ad_payment=="Per Session"){
                msg+='valid no. of days';
            }
            if(ad_payment=="Weekly"){
                msg+='valid no. of week(s)';
            }
            if(ad_payment=="Monthly"){
                msg+='valid no. of month(s)';
            }
            if(ad_payment=="Yearly"){
                msg+='valid no. of year(s)';
            }
        }
        else if(firstVal_ad_payment_box_fst == 0 ){
            if(ad_payment=="Per Hour"){
                msg+='do not use 0 as a first character(no. of hour(s))';
            }
            if(ad_payment=="Class Card"){
                msg+='do not use 0 as a first character(no. of classes)';
            }
            if(ad_payment=="Per Session"){
                msg+='do not use 0 as a first character(no. of day(s))';
            }
            if(ad_payment=="Weekly"){
                msg+='do not use 0 as a first character(no. of week(s))';
            }
            if(ad_payment=="Monthly"){
                msg+='do not use 0 as a first character(no. of month(s))';
            }
            if(ad_payment=="Yearly"){
                msg+='do not use 0 as a first character(no. of yea(s))';
            }
        }
    }
	
    if(ad_payment_box_sec != '' && ad_payment_box_sec != 'Eg: 3'){
        if(!validateNumber(ad_payment_box_sec)){
            if(msg!=''){
                if(ad_payment=="Per Session"){
                    msg+=', valid no. of hour(s)';
                }
            }
            else{
                if(ad_payment=="Per Session"){
                    msg+='valid no. of hour(s)';
                }
            }
        }
        else if(firstVal_ad_payment == 0 ){
            if(msg!=''){
                if(ad_payment=="Per Session"){
                    msg+=', do not use 0 as a first character(no. of hour(s))';
                }
            }
            else{
                if(ad_payment=="Per Session"){
                    msg+='do not use 0 as a first character(no. of hour(s))';
                }
            }
        }
    }
	
    if(ad_price == '$' || ad_price == '' ){
        if(msg!=''){
            msg+=', payment price';
        }
        else{
            msg+='payment price ';
        }
    }
    else if(ad_price != '' ){
        if(!validatPrize(ad_price)){
            if(msg!=''){
                msg+=', valid payment price';
            }
            else{
                msg+='valid payment price';
            }
        }
        else if(firstVal_ad_price == 0 ){
            if(msg!=''){
                msg+=', do not use 0 as a first character(payment price)';
            }
            else{
                msg+='do not use 0 as a first character(payment price)';
            }
        }
    }

    if(msg!=''){
        retVal=msg1+msg;
    }
    else{
        retVal='';
    }
    return retVal;
    
}
function validate_net_payment(fst_id,sec_id){  	
    var msg1='Please enter ';
    var msg='';
	
    var price_id='price_'+fst_id+'_'+sec_id;
    var price = $("#"+price_id).val();

    if(price=='' || price == 'Enter Price' ){
        $("#"+price_id+"").focus();
        msg+='net price';
    }
    else if(price != ''){
        if(!validatPrize(price)){
            msg+='valid net price';
        }
        else if(price == 0 ){
            msg+='valid net price';
        }
    }
	
    if(msg!=''){
        retVal=msg1+msg;
    }
    else{
        retVal='';
    }

    return retVal;
    
}

/*********************  Validate Default( **not selcted any thing **) Func Starts ****************************/
function  validate_nothing_selected(net,fst_id,sec_id,th_id,e_bid,add,opt)
{
    $('.errorDiv').css("display","none");

    if(net=='net'){
        nets='net_';
    }
    else{
        nets='';
    }
    $('#neprice_error_'+nets+fst_id+'_'+sec_id).parent().hide();
    $('#neprice_error_'+nets+fst_id+'_'+sec_id).html('');
    billing_type_sc=$('billing_type_sc').val();
    if(net == "net"){
	 
        var ad_price = $('#price_'+fst_id+'_'+sec_id).val();
        var id = "net_"+fst_id+"_"+sec_id+"_"+th_id;
		
        var msg = validate_net_payment(fst_id,sec_id);
        var select_box="choose_schedule_net_"+fst_id+"_1";
        if((billing_type_sc!='2')||(billing_type_sc!='3')){
		
            var e = document.getElementById(select_box);
		
		
            //var scheduleDropDown = e.options[e.selectedIndex].value;
            var scheduleDropDown=$('#selected_net_value_'+fst_id).val();
            //alert(scheduleDropDown);
            if(scheduleDropDown=='')
            {
                var msg2=' schedule';
		    
            }
            else{
		   
                var msg2='';
            }
	        
        }
	        
    }
    else{
	
        var id = fst_id+"_"+sec_id+"_"+th_id;
		
        var ad_price = $("#ad_price_"+fst_id+"_"+sec_id).val();
		
        var msg = validate_payment(fst_id,sec_id,th_id);
		
        var select_box="choose_schedule_"+fst_id+"_1";
        if((billing_type_sc!='2')||(billing_type_sc!='3')){
            var e = document.getElementById(select_box);
            //var scheduleDropDown = e.options[e.selectedIndex].value;
            var scheduleDropDown=$('#selected_value_'+fst_id).val();
		
            if(scheduleDropDown=='')
            {
                var msg2=' schedule, ';
            }
            else{
                var msg2='';
            }
        }
    }
	
    if(msg==''){
        if(msg2!=''){
            var msg='Please enter ';
            msg+=msg2;
		
        }
    }
    else{
        var msg1='';
        msg+=', '+msg2;
		
    }
        
    if(msg!=''){
        $('.errorDiv').css("display","block");
        $('#neprice_error_'+nets+fst_id+'_'+sec_id).parent().show();
        $('#neprice_error_'+nets+fst_id+'_'+sec_id).html(msg);
        retVal="f";
        // set height for ie support
        if ($.support.msie && $.support.version == 7){
            if(priceflag1==1){
                var priceDivHeight = 0 ;
                priceDivHeight = $('.priceDiv').css('height');
				
                priceDivHeight= parseInt(priceDivHeight) + parseInt(30);
						
                $('#early_brid_'+id).css('height','100px');
                $('.priceDiv').css('height' ,priceDivHeight);
                priceflag1=2;
            }
        }
		
    }
    else{
        $('.errorDiv').css("display","none");
        $('#neprice_error_'+nets+fst_id+'_'+sec_id).parent().hide();
        $('#neprice_error_'+nets+fst_id+'_'+sec_id).html('');
        retVal="t";
        // set height for ie support
        if ($.support.msie && $.support.version == 7){
            if(priceflag1==1){
                var priceDivHeight = 0 ;
                priceDivHeight = $('.priceDiv').css('height');
                priceDivHeight= parseInt(priceDivHeight) - parseInt(30);
						    
                $('#early_brid_'+id).css('height','70px');
                $('.priceDiv').css('height' ,priceDivHeight);
                priceflag1=2;
            }
        }
    }
	
    if(msg!=''){
        return 0;
    }
    else{
        return 1;
    }
}

/*********************   Validate Default( **not selcted any thing **) Func Ends ****************************/

/*********************  Validate Early Bid Func ****************************/
var priceflag1=1;
function validate_early_bid(net,fst_id,sec_id,th_id,e_bid,add,opt){
          
    $('#advance_error_'+sec_id+'_'+sec_id).parent().hide();
    $('#advance_error_'+sec_id+'_'+sec_id).html('');   
   
    if(net == "net_"){
	
        var ad_price = $('#price_'+fst_id+'_'+sec_id).val();
        var id = "net_"+fst_id+"_"+sec_id+"_"+th_id;
		
        var msg = validate_net_payment(fst_id,sec_id);
        var select_box="choose_schedule_net_"+fst_id+"_1";
        //alert(select_box);
        var e = document.getElementById(select_box);
        //var scheduleDropDown = e.options[e.selectedIndex].value;
        var scheduleDropDown=$('#selected_net_value_'+fst_id).val();
        var no_attends= $('#selected_net_value_'+fst_id).val();
		
        if(scheduleDropDown=='')
        {
            var msg2=' , schedule';
		        
        }
        else{
		     
            var msg2=' ';
        }
    }
    else{
        var id = fst_id+"_"+sec_id+"_"+th_id;
		
        var ad_price = $("#ad_price_"+fst_id+"_"+sec_id).val();
		
        var msg = validate_payment(fst_id,sec_id,th_id);
		
        var select_box="choose_schedule_"+fst_id+"_1";
		
        var e = document.getElementById(select_box);
        //var scheduleDropDown = e.options[e.selectedIndex].value;
        var scheduleDropDown=$('#selected_value_'+fst_id).val();
        var no_attends= $('#selected_value_'+fst_id).val();
        if(scheduleDropDown=='')
        {
            var msg2=' schedule, ';
        }
        else{
            var msg2='';
        }
    }
	
    if(msg==''){
        var msg1='Please enter ';
        msg1+=msg2;
    
    }
    else{
        var msg1=' ';
        msg+=msg2;
           
    }
    
    
   
    
   
    var ad_discount_price = $('#ad_discount_price_'+id).val();
    var ad_discount_price_type = $('#ad_discount_price_type_'+id).val();   
    
	
    if(typeof ad_discount_price!="undefined" ){
        ad_discount_price = ad_discount_price.replace(/^\s+|\s+$/g, "");
        var firstVal_ad_discount_price = ad_discount_price.charAt(0);
    }
    if(typeof ad_price!="undefined" ){
        ad_price = ad_price.replace(/^\s+|\s+$/g, "");
    }
  
    if($('#ad_no_subs_'+id).length>0){
 
        var ad_no_subs = $('#ad_no_subs_'+id).val();
        if( typeof ad_no_subs!="undefined" ){
            ad_no_subs = ad_no_subs.replace(/^\s+|\s+$/g, "");
            var firstVal_ad_no_subs = ad_no_subs.charAt(0);
        }
	// alert('1');
        /* if(ad_no_subs == 'Eg: 3' || ad_no_subs == '' ){
        
            if(msg!=''){
                msg+=', quantity';
            }
            else{
                msg+='quantity';
            }
        }
         */
        if(ad_no_subs != '' && ad_no_subs != 'Eg: 3'  ){
            if(!validateNumber(ad_no_subs)){
                if(msg!=''){
                    msg+=', valid quantity';
                }
                else{
                    msg+='valid quantity';
                }
            }
            if(firstVal_ad_no_subs == 0 ){
                if(msg!=''){
                    msg+=', do not use 0 as a first character(quantity)';
                }
                else{
                    msg+='do not use 0 as a first character(quantity)';
                }
            }
        }
    }
    
    // checking participants greater than the quantity
    
      
    var bill_type= $('#billing_type_sc').val();
            
    if(no_attends!=""){
        no_attends=no_attends.split('_');
        if(bill_type=='1'){
            var participant= $('#participant_'+no_attends[1]).val();
        }
        else if(bill_type=='4')
        {
			
		        
            var s_or_m= $('#wday_1_'+no_attends[1]).val();
            var m_or_s= $('#wday_2_'+no_attends[1]).val();
		        
            if(m_or_s=='1'){
                if( ($('#mul_day_participants_1_'+no_attends[1]).val()!="")&&($('#mul_day_participants_1_'+no_attends[1]).val()!="Specify Number")){
                    var participant= $('#mul_day_participants_1_'+no_attends[1]).val();
				      
                }
            }
            else if(s_or_m=='1')
            {
                if( ($('#single_day_participants_1_'+no_attends[1]).val()!="")&&($('#single_day_participants_1_'+no_attends[1]).val()!="Specify Number")){
                    var participant= $('#single_day_participants_1_'+no_attends[1]).val();
				
			          
			     
                }
            }
		   
        }
		    
        if(participant!=""){
            participant= parseInt(participant);
            ad_no_subs= parseInt(ad_no_subs);
            if(ad_no_subs>participant){
			
                if(msg!='')
                {
                    msg+=", quantity that's equal to or less than the total participant number "+participant +")";
                }
                else{
                    msg+="quantity that's equal to or less than the total participant number (" +participant +")";
                }
            }
            else{
                msg+='';
            }
        }
    }
    if(ad_discount_price == 'Eg: 3' || ad_discount_price == ''){
        if(msg!=''){
            msg+=', discount price ';
        }
        else{
            msg+='discount price ';
        }
	 	
    }
   
    else if(ad_discount_price != ''){
        if(!validatPrize(ad_discount_price)){
            if(msg!=''){
                msg+=', valid discount price';
            }
            else{
                msg+='valid discount price';
            }
        }
        else if(firstVal_ad_discount_price == 0 ){
            if(msg!=''){
                msg+=', do not use 0 as a first character(discount price)';
            }
            else{
                msg+='do not use 0 as a first character(discount price)';
            }
        }
        else if(parseInt(ad_price)<parseInt(ad_discount_price) && ad_discount_price_type=="$"){
	
            if(msg!=''){
                msg+=', the discount price cannot be more than the activity price';
            }
            else{
                msg1='';
                msg+='The discount price cannot be more than the activity price. Please reduce the discount price.';
            }
        }
        else if(parseInt(ad_discount_price)>100 && ad_discount_price_type=="%"){
            if(msg!=''){
                msg+=', valid discount price';
            }
            else{
                msg+='valid discount price';
            }
        }
	
    }
    
	
    if(msg!=''){
        $("#discount_choose_"+id).css("height","130px");
        $('#advance_early_bid_error_'+id).parent().show();
        $('#advance_early_bid_error_'+id).html(msg1+msg);
        retVal="f";
        // set height for ie support
        if ($.support.msie && $.support.version == 7){
            if(priceflag1==1){
                var priceDivHeight = 0 ;
                priceDivHeight = $('.priceDiv').css('height');
			
                priceDivHeight= parseInt(priceDivHeight) + parseInt(30);
					
                $('#early_brid_'+id).css('height','100px');
                $('.priceDiv').css('height' ,priceDivHeight);
                priceflag1=2;
            }
        }
	
    }
    else{
        $("#discount_choose_"+id).css("height","85px");
        $('#advance_early_bid_error_'+id).parent().hide();
        $('#advance_early_bid_error_'+id).html('');
        retVal="t";
        // set height for ie support
        if ($.support.msie && $.support.version == 7){
            if(priceflag1==1){
                var priceDivHeight = 0 ;
                priceDivHeight = $('.priceDiv').css('height');
                priceDivHeight= parseInt(priceDivHeight) - parseInt(30);
					
                $('#early_brid_'+id).css('height','70px');
                $('.priceDiv').css('height' ,priceDivHeight);
                priceflag1=2;
            }
        }
    }
    if(opt=="validation"){
        return retVal;
    }
    else{
        if(retVal=="t"){
            if(net == "net_"){
                var e_bid=$('#earlybid_decide_'+fst_id).val();
		    
                if(e_bid=='0'){
                    var  eb_id='1';
                }
                else{
                    var  eb_id='1';
                }
                if(add=='1'){
                    fst_id = parseInt(fst_id);
                    sec_id = parseInt(sec_id);
                    th_id = parseInt(th_id);
                    eb_id = parseInt(eb_id);
                    $("#ad_discount_type_"+id ).css( "pointer-events"," none"  );
                    $("#ad_discount_type_"+id ).css(" cursor","default" );
                    add_plus_discount('net_',fst_id,sec_id,th_id,eb_id);
                }
            }
            else{
                var e_bid=$('#earlybid_decide_adv_'+fst_id+'_'+sec_id).val();
		   
                if(e_bid=='0'){
                    var  eb_id='1';
                }
                else{
                    var  eb_id='1';
                }
                if(add=='1'){
                    $("#ad_discount_type_"+id ).css( "pointer-events"," none"  );
                    $("#ad_discount_type_"+id ).css(" cursor","default" );
                    add_plus_discount('',fst_id,sec_id,th_id,eb_id);
                    //add_early_bid('',fst_id,sec_id,th_id,eb_id);
                }
            }
		
            priceflag1=1;
        }
    }    
    
    if(msg!=''){
        return 0;
    }
    else{
        return 1;
    }
}

/*********************  Validate Session Func ****************************/
var priceflag2=1;
function validate_session(net,fst_id,sec_id,th_id,e_bid,add,opt){ 

    $('#advance_error_'+sec_id+'_'+sec_id).parent().hide();
    $('#advance_error_'+sec_id+'_'+sec_id).html('');
	
    if(net == "net"){
        var ad_price = $('#price_'+fst_id+'_'+sec_id).val();
        var id = "net_"+fst_id+"_"+sec_id+"_"+th_id;
        //var id = "net_1_"+fst_id+"_"+sec_id;
        var msg = validate_net_payment(fst_id,sec_id);
        var select_box="choose_schedule_net_"+fst_id+"_1";
		
        var e = document.getElementById(select_box);
        //var scheduleDropDown = e.options[e.selectedIndex].value;
        var scheduleDropDown=$('#selected_net_value_'+fst_id).val();
        if(scheduleDropDown=='')
        {
            var msg2=' schedule, ';
        }
        else{
            var msg2=' ';
        }
    }
    else{
        var id = fst_id+"_"+sec_id+"_"+th_id;
        //alert(id);
        var ad_price = $("#ad_price_"+fst_id+"_"+sec_id).val();
        var msg = validate_payment(fst_id,sec_id);
        var select_box="choose_schedule_"+fst_id+"_1";
		
        var e = document.getElementById(select_box);
        //var scheduleDropDown = e.options[e.selectedIndex].value;
        var scheduleDropDown=$('#selected_value_'+fst_id).val();
        if(scheduleDropDown=='')
        {
            var msg2=' schedule ,';
        }
        else{
            var msg2='';
        }
    }
	
    if(msg==''){
        var msg1='Please enter ';
        msg1+=msg2;
    
    }
    else{
        var msg1=' ';
        msg+=msg2;
           
    }
    
    var ad_no_sess = $('#ad_no_sess_'+id).val();
    var ad_discount_sess_price = $('#ad_discount_sess_price_'+id).val();
    var ad_discount_sess_price_type = $('#ad_discount_sess_price_type_'+id).val();   
	   
    ad_no_sess = ad_no_sess.replace(/^\s+|\s+$/g, "");
    ad_discount_sess_price = ad_discount_sess_price.replace(/^\s+|\s+$/g, "");
    ad_price = ad_price.replace(/^\s+|\s+$/g, "");
    
    var firstVal_ad_no_sess = ad_no_sess.charAt(0);
    var firstVal_ad_discount_sess_price = ad_discount_sess_price.charAt(0);
	
    if(ad_no_sess == 'Eg: 3' || ad_no_sess == '' ){
        if(msg!=''){
            msg+=', quantity';
        }
        else{
            msg+=' quantity';
        }
    }
    else if(ad_no_sess != '' ){
        if(!validateNumber(ad_no_sess)){
            if(msg!=''){
                msg+=', valid quantity';
            }
            else{
                msg+=' valid quantity';
            }
        }
        else if(firstVal_ad_no_sess == 0 ){
            if(msg!=''){
                msg+=', do not use 0 as a first character(quantity)';
            }
            else{
                msg+=' do not use 0 as a first character(quantity)';
            }
        }
   
    }
    if(ad_discount_sess_price == 'Eg: 3' || ad_discount_sess_price == ''){
        if(msg!=''){
            msg+=', discount price';
        }
        else{
            msg+=' discount price';
        }
		
    }
    else if(ad_discount_sess_price != ''){
        if(!validatPrize(ad_discount_sess_price)){
            if(msg!=''){
                msg+=', valid discount price';
            }
            else{
                msg+='valid discount price';
            }
        }
        else if(firstVal_ad_discount_sess_price == 0 ){
            if(msg!=''){
                msg+=', do not use 0 as a first character(discount price)';
            }
            else{
                msg+='do not use 0 as a first character(discount price)';
            }
        }
        else if(parseInt(ad_price) < parseInt(ad_discount_sess_price) && ad_discount_sess_price_type == "$"){
            if(msg!=''){
                msg+=', the discount price cannot be more than the activity price';
            }
            else{
                msg1='';
                msg+='The discount price cannot be more than the activity price. Please reduce the discount price.';
            }
        }
        else if(parseInt(ad_discount_sess_price) > 100 && ad_discount_sess_price_type == "%"){
            if(msg!=''){
                msg+=', valid discount price';
            }
            else{
                msg+='valid discount price';
            }
        }
    }
    if(msg!=''){
        $('#advance_session_error_'+id).parent().show();
        $('#advance_session_error_'+id).html(msg1+msg);
        retVal ="f";
        // set height for ie support
        if ($.support.msie && $.support.version == 7){
            if(priceflag2==1){
                var priceDivHeight = 0 ;
                priceDivHeight = $('.priceDiv').css('height');
                priceDivHeight= parseInt(priceDivHeight) + parseInt(30);
					
                $('#session_'+id).css('height','72px');
                $('.priceDiv').css('height' ,priceDivHeight);
                priceflag2=2;
            }
        }
	    
    }
    else{
        $('#advance_session_error_'+id).parent().hide();
        $('#advance_session_error_'+id).html('');
        retVal ="t";
        // set height for ie support
        if ($.support.msie && $.support.version == 7){
            if(priceflag2==1){
                var priceDivHeight = 0 ;
                priceDivHeight = $('.priceDiv').css('height');
                priceDivHeight= parseInt(priceDivHeight) - parseInt(30);
					
                $('#session_'+id).css('height','42px');
                $('.priceDiv').css('height' ,priceDivHeight);
                priceflag2=2;
            }
        }
    }
    if(opt=="validation"){
        return retVal;
    }
    else{ 
        if(retVal=="t"){
            if(net == "net"){
                var e_bid=$('#earlybid_decide_'+fst_id).val();
		   
                if(e_bid=='0'){
                    var  eb_id='0';
                }
                else{
                    var  eb_id='1';
                }
                if(add=='1'){
                    add_early_bid('net',fst_id,sec_id,th_id,eb_id);
                }
	
            }
            else{
                var e_bid=$('#earlybid_decide_adv_'+fst_id+'_'+sec_id).val();
		     
                if(e_bid=='0'){
                    var  eb_id='0';
                }
                else{
                    var  eb_id='1';
                }//add_early_bid('',sec_id);
                if(add=='1'){
                    add_early_bid('',fst_id,sec_id,th_id,eb_id);
                }
            }
            priceflag2=1;
        }
    }
    if(msg!=''){
        return 0;
    }
    else{
        return 1;
    }
}

/*********************  Validate Participant Func ****************************/
var priceflag3=1;
function validate_participant(net,fst_id,sec_id,th_id,e_bid,add,opt){ 
	
    $('#advance_error_'+sec_id+'_'+sec_id).parent().hide();
    $('#advance_error_'+sec_id+'_'+sec_id).html('');
    var ad_price='';
    if(net == "net"){
        ad_price = $('#price_'+fst_id+'_'+sec_id).val();
        var id = "net_"+fst_id+"_"+sec_id+"_"+th_id;
        //var id = "net_1_"+fst_id+"_"+sec_id;
        var msg = validate_net_payment(fst_id,sec_id);
        var select_box="choose_schedule_net_"+fst_id+"_1";
		
        var e = document.getElementById(select_box);
        //var scheduleDropDown = e.options[e.selectedIndex].value;
        var scheduleDropDown=$('#selected_net_value_'+fst_id).val();
        if(scheduleDropDown=='')
        {
            var msg2=' schedule, ';
        }
        else{
            var msg2='';
        }
    }
    else{
        var id = fst_id+"_"+sec_id+"_"+th_id;
		
        var ad_price = $("#ad_price_"+fst_id+"_"+sec_id).val();
        var msg = validate_payment(fst_id,sec_id);
        var select_box="choose_schedule_"+fst_id+"_1";
		
        var e = document.getElementById(select_box);
        //var scheduleDropDown = e.options[e.selectedIndex].value;
        var scheduleDropDown=$('#selected_value_'+fst_id).val();
        if(scheduleDropDown=='')
        {
            var msg2=' schedule, ';
        }
        else{
            var msg2=' ';
        }
    }
	
    if(msg==''){
        var msg1='Please enter ';
        msg1+=msg2;
    
    }
    else{
        var msg1=' ';
        msg+=msg2;
           
    }
   
    var ad_no_part = $('#ad_no_part_'+id).val();
    var ad_discount_part_price = $('#ad_discount_part_price_'+id).val();
    var ad_discount_part_price_type = $('#ad_discount_part_price_type_'+id).val();        
	   
    ad_no_part = ad_no_part.replace(/^\s+|\s+$/g, "");
    ad_discount_part_price = ad_discount_part_price.replace(/^\s+|\s+$/g, "");
    ad_price = ad_price.replace(/^\s+|\s+$/g, "");
    
    var firstVal_ad_no_part = ad_no_part.charAt(0);
    var firstVal_ad_discount_part_price = ad_discount_part_price.charAt(0);
	
    if(ad_no_part == 'Eg: 3' || ad_no_part == '' ){
        if(msg!=''){
            msg+=', quantity';
        }
        else{
            msg+=' quantity';
        }
    }
    else if(ad_no_part != '' ){
        if(!validateNumber(ad_no_part)){
            if(msg!=''){
                msg+=', valid quantity';
            }
            else{
                msg+=' valid quantity';
            }
        }
        if(firstVal_ad_no_part == 0 ){
            if(msg!=''){
                msg+=', do not use 0 as a first character(quantity)';
            }
            else{
                msg+=' do not use 0 as a first character(quantity)';
            }
        }
    }
    if(ad_discount_part_price == 'Eg: 3' || ad_discount_part_price == ''){
        if(msg!=''){
            msg+=', discount price';
        }
        else{
            msg+=' discount price';
        }
    }
    else if(ad_discount_part_price != ''){
        if(!validatPrize(ad_discount_part_price)){
            if(msg!=''){
                msg+=', valid discount price';
            }
            else{
                msg+='valid discount price';
            }
        }
        else if(firstVal_ad_discount_part_price == 0 ){
            if(msg!=''){
                msg+=', do not use 0 as a first character(discount price)';
            }
            else{
                msg+='do not use 0 as a first character(discount price)';
            }
        }
        else if(parseInt(ad_price) < parseInt(ad_discount_part_price) && ad_discount_part_price_type == "$"){
            if(msg!=''){
                msg+=', the discount price cannot be more than the activity price';
            }
            else{
                msg1='';
                msg+='The discount price cannot be more than the activity price. Please reduce the discount price.';
            }
        }
        else if(parseInt(ad_discount_part_price) > 100 && ad_discount_part_price_type == "%"){
            if(msg!=''){
                msg+=', valid discount price';
            }
            else{
                msg+='valid discount price';
            }
        }
    }
    if(msg!=''){
        $('#advance_participant_error_'+id).parent().show();
        $('#advance_participant_error_'+id).html(msg1+msg);
        retVal="f";
        // set height for ie support
        if ($.support.msie && $.support.version == 7){
            if(priceflag3==1){
                var priceDivHeight = 0 ;
                priceDivHeight = $('.priceDiv').css('height');
                priceDivHeight= parseInt(priceDivHeight) + parseInt(30);
					
                $('#participant_'+id).css('height','72px');
                $('.priceDiv').css('height' ,priceDivHeight);
                priceflag3=2;
            }
        }
    }
    else{
        $('#advance_participant_error_'+id).parent().hide();
        $('#advance_participant_error_'+id).html('');
        retVal="t";
        // set height for ie support
        if ($.support.msie && $.support.version == 7){
            if(priceflag3==1){
                var priceDivHeight = 0 ;
                priceDivHeight = $('.priceDiv').css('height');
                priceDivHeight= parseInt(priceDivHeight) - parseInt(30);
					
                $('#participant_'+id).css('height','42px');
                $('.priceDiv').css('height' ,priceDivHeight);
                priceflag3=2;
            }
        }
    }
    if(opt=="validation"){
        return retVal;
    }
    else{       
        if(retVal=="t"){
            if(net == "net"){
                var e_bid=$('#earlybid_decide_'+fst_id).val();
		    
                if(e_bid=='0'){
                    var  eb_id='0';
                }
                else{
                    var  eb_id='1';
                }
                if(add=='1'){
                    add_early_bid('net',fst_id,sec_id,th_id,eb_id);
                }
            }
            else{
                var e_bid=$('#earlybid_decide_adv_'+fst_id+'_'+sec_id).val();
		      
                if(e_bid=='0'){
                    var  eb_id='0';
                }
                else{
                    var  eb_id='1';
                }
                if(add=='1'){//add_participant('',sec_id);
                    add_early_bid('',fst_id,sec_id,th_id,eb_id);
                }
            }
            priceflag3=1;
        }
    }    
    if(msg!=''){
        return 0;
    }
    else
    {
        return 1;
    }
}

/********************* validate  advanced Func ****************************/
var priceflag4=1;
function validate_advanced_price(fst_id,sec_id,opt){
    var ad_discount_type = $('#ad_discount_type_'+fst_id+'_'+sec_id).val();   
	
    if(ad_discount_type=="--Choose Discount Type--" || ad_discount_type=="" ){
        var msg = validate_payment(fst_id,sec_id);
        if(msg!=''){
            $('#advance_error_'+sec_id+'_'+sec_id).parent().show();
            $('#advance_error_'+sec_id+'_'+sec_id).html(msg);
            retVal="f";
	    
            // set height for ie support
            if ($.support.msie && $.support.version == 7){
                if(priceflag4==1){
                    var priceDivHeight = 0 ;
                    priceDivHeight = $('.priceDiv').css('height');
                    priceDivHeight= parseInt(priceDivHeight) + parseInt(30);
                    $('#advance_error_'+sec_id+'_'+sec_id).parent().css('height','30px');
                    $('.priceDiv').css('height' ,priceDivHeight);
                    priceflag4=2;
                }
            }
        }
        else{
            $('#advance_error_'+sec_id+'_'+sec_id).parent().hide();
            $('#advance_error_'+sec_id+'_'+sec_id).html('');
            retVal="t";
            // set height for ie support
            if ($.support.msie && $.support.version == 7){
                if(priceflag4==1){
                    var priceDivHeight = 0 ;
                    priceDivHeight = $('.priceDiv').css('height');
                    priceDivHeight= parseInt(priceDivHeight) - parseInt(30);
                    $('#advance_error_'+sec_id+'_'+sec_id).parent().css('height','0');
                    $('.priceDiv').css('height' ,priceDivHeight);
                    priceflag4=2;
                }
            }
        }
        if(opt=="validation"){
            return retVal;
        }
        else{
            if(retVal=="t"){
                add_advanced_price();
                priceflag1=1;
                priceflag2=1;
                priceflag3=1;
                priceflag4=1;
            }
        }
    }
    else{
		
        $('#advance_error_'+sec_id+'_'+sec_id).parent().hide();
        $('#advance_error_'+sec_id+'_'+sec_id).html('');
		
        var retVal_bid='';
        var retVal_session='';
        var retVal_participant='';
        var retVal='';
		
        if(ad_discount_type=="Early Bird Discount"){
            retVal_bid = validate_early_bid('',fst_id,sec_id,"validation");
        }
        else if(ad_discount_type=="Multiple Session Discount"){
            retVal_session = validate_session('',fst_id,sec_id,"validation");
        }
        else if(ad_discount_type=="Multiple Participant Discount"){
            retVal_participant = validate_participant('',fst_id,sec_id,"validation");
        }
		
        if(retVal_bid == "f" ){
            retVal="f";
            // set height for ie support
            if ($.support.msie && $.support.version == 7){
                $('#early_brid_'+fst_id+'_'+sec_id).css('height','100px');
            }
        }
        else if( retVal_session == "f" ){
            retVal="f";
            // set height for ie support
            if ($.support.msie && $.support.version == 7){
                $('#session_'+fst_id+'_'+sec_id).css('height','72px');
            }
        }
        else if( retVal_participant =="f" ){
            retVal="f";
            // set height for ie support
            if ($.support.msie && $.support.version == 7){
                $('#participant_'+fst_id+'_'+sec_id).css('height','72px');
            }
        }
        else if( retVal_bid =="t" || retVal_session == "t" || retVal_participant == "t"){
            retVal="t";
            // set height for ie support
            if ($.support.msie && $.support.version == 7){
                $('#early_brid_'+fst_id+'_'+sec_id).css('height','70px');
                $('#session_'+fst_id+'_'+sec_id).css('height','42px');
                $('#participant_'+fst_id+'_'+sec_id).css('height','42px');
            }
        }
		
        if(opt=="validation"){
            return retVal;
        }
        else{
            if(retVal=="t"){
                add_advanced_price();
            }
        }
		
	
    }
}
function validate_net_price(fst_id,sec_id){
    var ad_discount_type = $('#ad_discount_type_net_'+fst_id+'_'+sec_id).val();   
	
    if(ad_discount_type=="--Choose Discount Type--" || ad_discount_type=="" ){
        var msg = validate_net_payment(fst_id,sec_id);
        if(msg!=''){
            $('#net_advance_error_1_1').parent().show();
            $('#net_advance_error_1_1').html(msg);
            retVal="f";    
        }
        else{
            $('#net_advance_error_1_1').parent().hide();
            $('#net_advance_error_1_1').html('');
            retVal="t";
        }       
        return retVal;
    }
    else{		
        $('#net_advance_error_1_1').parent().hide();
        $('#net_advance_error_1_1').html('');
		
        var retVal_bid='';
        var retVal_session='';
        var retVal_participant='';
        var retVal='';
		
        if(ad_discount_type=="Early Bird Discount"){
            retVal_bid = validate_early_bid('net',fst_id,sec_id,"validation");
        }
        else if(ad_discount_type=="Multiple Session Discount"){
            retVal_session = validate_session('net',fst_id,sec_id,"validation");
        }
        else if(ad_discount_type=="Multiple Participant Discount"){
            retVal_participant = validate_participant('net',fst_id,sec_id,"validation");
        }
		
        if(retVal_bid == "f" ){
            retVal="f";	    
        }
        else if( retVal_session == "f" ){
            retVal="f";	     
        }
        else if( retVal_participant =="f" ){
            retVal="f";	     
        }
        else if( retVal_bid =="t" || retVal_session == "t" || retVal_participant == "t"){
            retVal="t";	  
        }      
        return retVal;
	
    }
}


/*********************  Early Bird ADD Func  Start****************************/

function add_early_bid(net,b,q,h,eb_id){
    
    if(net=='net'){
   
			    
        var e12 = document.getElementById("ad_discount_type_"+net+"_"+b+"_"+q+"_"+h);
        var strSelected12 = e12.options[e12.selectedIndex].value;
        if(strSelected12=="Early Bird Discount")
        {
            $('#earlybid_decide_'+b).val('1');
        }
        $("#ad_discount_type_"+net+"_"+b+"_"+q+"_"+h).css("pointer-events"," none");
        $("#ad_discount_type_"+net+"_"+b+"_"+q+"_"+h).css("cursor"," default");
    }
    else{
				    
        var e12 = document.getElementById("ad_discount_type_"+b+'_'+q+'_'+h);
        var strSelected12 = e12.options[e12.selectedIndex].value;
        if(strSelected12=="Early Bird Discount")
        {
            $('#earlybid_decide_adv_'+b+'_'+q).val('1');
        }
        $("#ad_discount_type_"+b+'_'+q+'_'+h).css("pointer-events"," none");
        $("#ad_discount_type_"+b+'_'+q+'_'+h).css("cursor"," default");
    }
	   
    h++;
	
    if (net=='net'){
        $(".addButton_net_"+b+"_"+q).css("display","none");
	      
        net="net";
        var netapnd="net_";
    }
    else{
        $(".addButton_"+b+"_"+q).css("display","none");
        net="";
        var netapnd="";
    }
	         
    var inner_discountDiv='';
	       
    inner_discountDiv+='<div class="staticDiscount_'+netapnd+'1_1"  id="staticDiscount_'+netapnd+''+b+'_'+q+'_'+h+'"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_'+netapnd+''+b+'_'+q+'_'+h+'">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none;width:185px;" id="no_part_'+netapnd+''+b+'_'+q+'_'+h+'" >Discount Amount/Percentage</div><div class="clear"></div></div>';
    inner_discountDiv+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type_net" id="discount_type_'+netapnd+''+b+'_'+q+'_'+h+'"><select name="ad_discount_type_'+netapnd+''+b+'_'+q+'_'+h+'" id="ad_discount_type_'+netapnd+''+b+'_'+q+'_'+h+'" class="drop_down_left width_set6" onchange="discTypeChanged(\''+net+'\','+b+','+q+','+h+',this.value,1);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'net\',1,1,this.value)"> <option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option>';
    if(eb_id=='0'){
        inner_discountDiv+='<option value="Early Bird Discount">Early Bird Discount</option>';
    }
    if(net!='net'){
        inner_discountDiv+='<option value="Multiple Session Discount">Multiple Session Discount</option>';
    }
    inner_discountDiv+='<option value="Multiple Participant Discount">Multiple Participant Discount</option> </select></div>    ';
	    
	    
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
    inner_discountDiv+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText">Valid  Until</div><div class="lt blackText setWidthDiscount" style="display:none;width:185px;" id="noe_part_'+netapnd+''+b+'_'+q+'_'+h+'">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
    inner_discountDiv+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_'+netapnd+''+b+'_'+q+'_'+h+'" name="ad_no_subs_'+netapnd+''+b+'_'+q+'_'+h+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    inner_discountDiv+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_'+netapnd+''+b+'_'+q+'_'+h+'" name="ad_valid_date_'+netapnd+''+b+'_'+q+'_'+h+'" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_'+netapnd+''+b+'_'+q+'_'+h+'" name="ad_valid_date_alt_'+netapnd+''+b+'_'+q+'_'+h+'" value="" /></div></div>    ';
	    
    inner_discountDiv+='<input type="text" id="ad_discount_price_'+netapnd+''+b+'_'+q+'_'+h+'" name="ad_discount_price_'+netapnd+''+b+'_'+q+'_'+h+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    inner_discountDiv+='<div class="lt price_type"><select name="ad_discount_price_type_'+netapnd+''+b+'_'+q+'_'+h+'" id="ad_discount_price_type_'+netapnd+''+b+'_'+q+'_'+h+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
    inner_discountDiv+='<div class="lt add_delete_icons" id="early_bid_icons_'+netapnd+''+b+'_'+q+'_'+h+'"><div class="delete_single_schedule delete_single_schedule_'+b+'_'+q+'" style="margin-top:0px;" onclick="delete_single_net_price(\''+net+'\','+b+','+q+','+h+')">&nbsp;</div><a href="javascript:void(0)"  class="lt addButton_'+netapnd+''+b+'_'+q+' single_add_'+netapnd+''+b+'_'+q+'_'+h+'" id="single_add_'+netapnd+''+b+'_'+q+'_'+h+'" title="" onClick="validate_early_bid(\''+net+'\','+b+','+q+','+h+','+eb_id+',1)" style="display:inline-block; position:relative;left:0px;" class="lt addButton"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
    inner_discountDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_'+netapnd+''+b+'_'+q+'_'+h+'"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div>';

    if(net=="net"){
        $('#advancedPriceContainer_'+b+'_'+q).append(inner_discountDiv);
		
        $(".delete_single_schedule_"+b+'_'+q).css("display","block");
        var get_deletes=$("#delete_discount_id_"+b+"_"+q).val();
        var t=b+"_"+q+"_"+h;
        get_deletes+=','+t;
        save_result=$("#save_result").val();
        save_result+=','+t;
        $("#save_result").val(save_result);
        $("#delete_discount_id_"+b+"_"+q).val(get_deletes);
        $("#last_discount_id_"+b+"_"+q).val(h);
        var et=b+'_'+q+"_"+h;
        var values=$("#last_in_discount_id_"+b).val();
        values+=","+et;
        $("#last_in_discount_id_"+b).val(values);
		
        $("#single_add_net_"+b+"_"+q+"_"+h).css("display","block");
    }
    else{
        $('#advanced_PriceContainer_'+b+'_'+q).append(inner_discountDiv);
        $(".delete_single_schedule_"+b+'_'+q).css("display","block");
        var get_deletes=$("#delete_ad_discount_id_"+b+"_"+q).val();
        var t=b+"_"+q+"_"+h;
        get_deletes+=','+t;
        result_save=$("#result_save").val();
        result_save+=','+t;
        $("#result_save").val(result_save);
        $("#delete_ad_discount_id_"+b+"_"+q).val(get_deletes);
        $("#last_ad_discount_id_"+b+"_"+q).val(h);
        var et=b+'_'+q+"_"+h;
        var values=$("#last_ad_in_discount_id_"+b).val();
        values+=","+et;
        var early_values=$("#early_div_count_"+b+"_"+q).val();
        early_values+=","+et;
        $("#early_div_count_"+b+"_"+q).val(early_values);
        $("#last_ad_in_discount_id_"+b).val(values);
        // $("#last_ad_in_discount_id_"+b).val(et);
        $("#single_add_"+b+"_"+q+"_"+h).css("display","block");
		   
		   
		   
    }

}

function delete_single_net_price(net,b,q,h)
{
    if(net=='net_'){
    
        var del_id="net_"+b+"_"+q+"_"+h;
        var e12 = document.getElementById("ad_discount_type_"+del_id);
        var strSelected12 = e12.options[e12.selectedIndex].value;
        if(strSelected12=="Early Bird Discount")
        {
            $('#earlybid_decide_'+b).val('0');
        }
        var values=$("#last_in_discount_id_"+b).val();
        values=values.split(',');
        save_result=$("#save_result").val();
        save_result_array=save_result.split(",");
	    
        var get_delets=$("#delete_discount_id_"+b+"_"+q).val();
        var v=b+"_"+q+"_"+h;
        get_delets=get_delets.split(",");
        var index2= save_result_array.indexOf(v);
        var index1= values.indexOf(v);
	    
        var index = get_delets.indexOf(v);
        if (index2 > -1) {
            save_result_array.splice(index2, 1);
        }
        $("#save_result").val(save_result_array);
        if (index1 > -1) {
            values.splice(index1, 1);
        }
        $("#last_in_discount_id_"+b).val(values);
        if (index > -1) {
            get_delets.splice(index, 1);
        }
        $("#delete_discount_id_"+b+"_"+q).val(get_delets);
        if(get_delets.length==1){
            $(".delete_single_schedule_net_"+b+'_'+q).css("display","none");
	     
        }
        else{
            $(".delete_single_schedule_"+b+'_'+q).css("display","block");
            // $('.single_add_net_'+get_delets[(get_delets.length)-1]).css('display','none');
        }
	     
	      
        $("#staticDiscount_"+del_id).remove();
	  
        $('#single_add_net_'+get_delets[(get_delets.length)-1]).css('display','block');
	   
    }
        
    else{
         
        var del_id=b+"_"+q+"_"+h;
	
        var e12 = document.getElementById("ad_discount_type_"+del_id);
        var strSelected12 = e12.options[e12.selectedIndex].value;
        if(strSelected12=="Early Bird Discount")
        {
            $('#earlybid_decide_adv_'+b+'_'+q).val('0');
        }
        var values=$("#last_ad_in_discount_id_"+b).val();
        values=values.split(',');
        result_save=$("#result_save").val();
        result_save_array=result_save.split(",");
	    
        var get_delets=$("#delete_ad_discount_id_"+b+"_"+q).val();
        var v=b+"_"+q+"_"+h;
        var index1= values.indexOf(v);
	    
        var index2= result_save_array.indexOf(v);
        if (index2 > -1) {
            result_save_array.splice(index2, 1);
        }
        $("#result_save").val(result_save_array);
        get_delets=get_delets.split(",");
        var index = get_delets.indexOf(v);
        if (index1 > -1) {
            values.splice(index1, 1);
        }
        $("#last_ad_in_discount_id_"+b).val(values);
        if (index > -1) {
            get_delets.splice(index, 1);
        }
        $("#delete_ad_discount_id_"+b+"_"+q).val(get_delets);
        var early_values=$("#early_div_count_"+b+"_"+q).val();
        early_values=early_values.split(',');
        var index4 = early_values.indexOf(v);
        if (index4 > -1) {
            early_values.splice(index4, 1);
        }
		
        $("#early_div_count_"+b+"_"+q).val(early_values);
	
        if(get_delets.length==1){
            $(".delete_single_schedule_"+b+'_'+q).css("display","none");
	     
        }
        $('#single_add_'+get_delets[(get_delets.length)-1]).css('display','block');
      
	
        $("#staticDiscount_"+del_id).remove();
   
    }
  
    // $( ".addButton_"+b+"_"+q ).last().css("display","block");
    // alert(".addButton_"+b+"_"+q );
    
}


/*********************  Early Bird ADD Func  Ends****************************/
/*function add_early_bid(net,ad_id){ 
	
    var str='';
    var msg='';
    var count_inc = 0;
	
	if(net == "net"){
		 var adId = 'net_'+ad_id+'_'+ad_id;
		
	}
	else{
		 var adId = ad_id+'_'+ad_id;
		
	}
	
   
    var lengthDiv = $('.createDynamicDiscount_'+adId+' .multiple_discount').length;
		
    if(lengthDiv==0){
        $("#multiple_discount_count_"+adId).val(1);
    }


    var currentDiv = parseInt(lengthDiv) + parseInt(2);
    var value = currentDiv;

    var count=$("#multiple_discount_count_"+adId).val();
    if(currentDiv==2){
        count_inc=count+","+value;
    }
    else{
        count_inc=count+","+value;
    }
    
    if(net == "net"){
		 value = 'net_'+currentDiv+'_'+ad_id;
		  var param = "'net',"+currentDiv+","+ad_id;
		
	}
	else{
		  value = currentDiv+'_'+ad_id;
		   var param = "'',"+currentDiv+","+ad_id;
		
	}
	
    $("#multiple_discount_count_"+adId).val(count_inc);

    str ='<div id="multiple_discount_'+value+'" class="multiple_discount"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="clear"></div></div><div class="priceRow2_bottom"><div class="lt discout_type"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" class="drop_down_left width_set6" style="color:#444444;"><option value="Early Bird Discount" selected="selected">Early Bird Discount</option></select></div><div id="provider_event_list" style="float: left;width: 25px;display:block;" class="earlyHelpIcon_'+value+'"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div><div class="clear"></div><div class="priceRow3_top"><div class="lt blackText setWidthSubs">No.of  Subscription</div><div class="lt blackText">Valid  Until</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow3_bottom"><input type="text" id="ad_no_subs_'+value+'" name="ad_no_subs_'+value+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" /><div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_'+value+'" name="ad_valid_date_'+value+'" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_'+value+'" name="ad_valid_date_alt_'+value+'" value="" /></div></div><input type="text" id="ad_discount_price_'+value+'" name="ad_discount_price_'+value+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" /><div class="lt price_type"><select name="ad_discount_price_type_'+value+'" id="ad_discount_price_type_'+value+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="delete_discount('+param+')" style="display:inline-block; position:relative;left:10px;"><img class="lt addButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_'+value+'"></div></div><div class="clear"></div><div class="clear"></div></div><div class="clear"></div>';
    $('.createDynamicDiscount_'+adId).append(str);
    
    // set height for ie support
  if ($.support.msie && $.support.version == 7){	
	var advancedPriceHeight = $('#multiple_discount_'+value).css('height');     
	var priceDivHeight = $('.priceDiv').css('height');    
	priceDivHeight= parseInt(priceDivHeight) + parseInt(advancedPriceHeight);             

	$('#multiple_discount_'+value).css('height' ,advancedPriceHeight);
	$('#early_brid_'+value).css('height','100px');
	$('.priceDiv').css('height' ,priceDivHeight); 	     
    }
  
    	if(net == "net"){		
		params = 'net_1_'+ad_id;
	}
	else{		
		params = '1_'+ad_id;
	}
	
    
    $('.createDynamicDiscount_'+adId+' #ad_no_subs_'+value).val($("#ad_no_subs_"+params).val());
    $('.createDynamicDiscount_'+adId+' #ad_no_subs_'+value).css('color','#444444');
    $('.createDynamicDiscount_'+adId+' #ad_valid_date_'+value).val($("#ad_valid_date_"+params).val());
    $('.createDynamicDiscount_'+adId+' #ad_valid_date_'+value).css('color','#444444');
    $('.createDynamicDiscount_'+adId+' #ad_valid_date_alt_'+value).val($("#ad_valid_date_alt_"+params).val());
    $('.createDynamicDiscount_'+adId+' #ad_discount_price_'+value).val($("#ad_discount_price_"+params).val());
    $('.createDynamicDiscount_'+adId+' #ad_discount_price_'+value).css('color','#444444');
    $('.createDynamicDiscount_'+adId+' #ad_discount_price_type_'+value).val($("#ad_discount_price_type_"+params).val());

    $(".staticDiscount_"+params+" #ad_no_subs_"+params).val('Eg: 3');
    $(".staticDiscount_"+params+" #ad_no_subs_"+params).css('color','#999999');
    $(".staticDiscount_"+params+" #ad_valid_date_"+params).css('color','#999999');
    $(".staticDiscount_"+params+" #ad_discount_price_"+params).val('Eg: 3');
    $(".staticDiscount_"+params+" #ad_discount_price_"+params).css('color','#999999');
    $(".staticDiscount_"+params+" #ad_discount_price_type_"+params).val('$');

    
   if(net == "net"){
	   $(function() {
		$("#ad_valid_date_net_"+currentDiv+"_"+ad_id).datepicker({
		    showOn : "button",
		    buttonImage : "/assets/create_new_activity/date_icon.png",
		    buttonImageOnly : true,
		    minDate: 0,
		    dateFormat: "D, M d, yy",
		    altField : "#ad_valid_date_alt_"+value,
		    altFormat : "yy-m-d"
		});
	    });
    }
    
    else{	    
	    $(function() {
		$("#ad_valid_date_"+currentDiv+"_"+ad_id).datepicker({
		    showOn : "button",
		    buttonImage : "/assets/create_new_activity/date_icon.png",
		    buttonImageOnly : true,
		    minDate: 0,
		    dateFormat: "D, M d, yy",
		    altField : "#ad_valid_date_alt_"+value,
		    altFormat : "yy-m-d"
		});
	    });
    }
  
    var dateVal1 = $('#dateFormate_1').val();
    var dateVal2 = $('#date_1').val();
	  
 
    ///////  remove early brid option
  
        if(net == "net"){
		value = 'net_1_'+ad_id;
		param = "'net',1,"+ad_id;
	}
	else{
		value = '1_'+ad_id;
		param = "'',1,"+ad_id;
	}
	
	$("#ad_valid_date_"+value).val(dateVal1);
        $("#ad_valid_date_alt_"+value).val(dateVal2);	
	
  
    var removeEarly = '';
    $('.staticDiscount_'+value+' #early_brid_'+value).hide();
    removeEarly = '<div class="lt discout_type" id="discount_type_'+value+'"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" class="drop_down_left width_set6" onchange="discTypeChanged('+param+',this.value);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged('+param+',this.value);$(this).css(\'color\',\'#444444\');"><option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div>';

    $("#discount_type_"+value).html('');
    $("#discount_type_"+value).html(removeEarly);   
    
}
 */

function edit_early_bid(net,ad_id){
    var str='';
    var msg='';
    var count_inc = 0;
    if(net == "net"){
        var adId = 'net_'+ad_id+'_'+ad_id;
		
    }
    else{
        var adId = ad_id+'_'+ad_id;
		
    }
    var lengthDiv = $('.createDynamicDiscount_'+adId+' .multiple_discount').length;

    if(lengthDiv==0){
        $("#multiple_discount_count_"+adId).val(1);
    }

    var currentDiv = parseInt(lengthDiv) + parseInt(2);
    var value = currentDiv;

    var count=$("#multiple_discount_count_"+adId).val();
    if(currentDiv==2){
        count_inc=count+","+value;
    }
    else{
        count_inc=count+","+value;
    }  
    if(net == "net"){
        value = 'net_'+currentDiv+"_"+ad_id;
        var param = "'net',"+currentDiv+","+ad_id;
		
    }
    else{
        value = currentDiv+"_"+ad_id;
        var param = "'',"+currentDiv+","+ad_id;
		
    }
    $("#multiple_discount_count_"+adId).val(count_inc);

    str ='<div id="multiple_discount_'+value+'" class="multiple_discount"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="clear"></div></div><div class="priceRow2_bottom"><div class="lt discout_type"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" class="drop_down_left width_set6" style="color:#444444;"><option value="Early Bird Discount" selected="selected">Early Bird Discount</option></select></div><div id="provider_event_list" style="float: left;width: 25px;display:block;" class="earlyHelpIcon_'+value+'"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div><div class="clear"></div><div class="priceRow3_top"><div class="lt blackText setWidthSubs">No.of  Subscription</div><div class="lt blackText">Valid  Until</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow3_bottom"><input type="text" id="ad_no_subs_'+value+'" name="ad_no_subs_'+value+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" /><div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_'+value+'" name="ad_valid_date_'+value+'" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_'+value+'" name="ad_valid_date_alt_'+value+'" value="" /></div></div><input type="text" id="ad_discount_price_'+value+'" name="ad_discount_price_'+value+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" /><div class="lt price_type"><select name="ad_discount_price_type_'+value+'" id="ad_discount_price_type_'+value+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="delete_discount('+param+')" style="display:inline-block; position:relative;left:10px;"><img class="lt addButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_'+value+'"></div></div><div class="clear"></div><div class="clear"></div></div><div class="clear"></div>';
    $('.createDynamicDiscount_'+adId).append(str);
	
    // set height for ie support
    if ($.support.msie && $.support.version == 7){
        var advancedPriceHeight = $('#multiple_discount_'+value).css('height');
        var priceDivHeight = $('.priceDiv').css('height');
        priceDivHeight= parseInt(priceDivHeight) + parseInt(advancedPriceHeight);

        $('#multiple_discount_'+value).css('height' ,advancedPriceHeight);
        $('#early_brid_'+value).css('height','100px');
        $('.priceDiv').css('height' ,priceDivHeight);
    }

    if(net == "net"){
        $(function() {
            $("#ad_valid_date_net_"+currentDiv+"_"+ad_id).datepicker({
                showOn : "button",
                buttonImage : "/assets/create_new_activity/date_icon.png",
                buttonImageOnly : true,
                dateFormat: "D, M d, yy",
                altField : "#ad_valid_date_alt_"+value,
                altFormat : "yy-m-d"
            });
        });
    }
    
    else{	    
        $(function() {
            $("#ad_valid_date_"+currentDiv+"_"+ad_id).datepicker({
                showOn : "button",
                buttonImage : "/assets/create_new_activity/date_icon.png",
                buttonImageOnly : true,
                dateFormat: "D, M d, yy",
                altField : "#ad_valid_date_alt_"+value,
                altFormat : "yy-m-d"
            });
        });
    }
    //  remove early brid option
    if(net == "net"){
        var setId = "net_1_"+ad_id;
    }
    else{
        var setId = "1_"+ad_id;
    }
    $(".staticDiscount_"+setId+" #discount_type_"+setId+" #ad_discount_type_"+setId+" option[value='Early Bird Discount']").remove();
}

/*********************  Session ADD Func ****************************/
function add_session(net,ad_id){ 
    var str='';
    var msg='';
    var count_inc = 0;
    if(net == "net"){
        var adId = 'net_'+ad_id+'_'+ad_id;
		
    }
    else{
        var adId = ad_id+'_'+ad_id;
		
    }
    var lengthDiv = $('.createDynamicDiscount_'+adId+' .multiple_discount').length;

    if(lengthDiv==0){
        $("#multiple_discount_count_"+adId).val(1);
    }

    var currentDiv = parseInt(lengthDiv) + parseInt(2);
    var value = currentDiv;

    var count=$("#multiple_discount_count_"+adId).val();
    if(currentDiv==2){
        count_inc=count+","+value;
    }
    else{
        count_inc=count+","+value;
    }
    
    if(net == "net"){
        value = 'net_'+currentDiv+"_"+ad_id;
        var param = "'net',"+currentDiv+","+ad_id;
		
    }
    else{
        value = currentDiv+"_"+ad_id;
        var param = "'',"+currentDiv+","+ad_id;
    }
	
    $("#multiple_discount_count_"+adId).val(count_inc);

    str = '<div id="multiple_discount_'+value+'" class="multiple_discount"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" id="no_sess_'+value+'">Quantity</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" class="drop_down_left width_set6" style="color:#444444;"><option value="Multiple Session Discount" selected="selected">Multiple Session Discount</option></select></div><div id="session_'+value+'"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li></ul></li></ul><div class="clear"></div></div></div><input type="text" id="ad_no_sess_'+value+'" name="ad_no_sess_'+value+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_discount_sess_price_'+value+'" name="ad_discount_sess_price_'+value+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}"/><div class="lt session_price_type"><select name="ad_discount_sess_price_type_'+value+'" id="ad_discount_sess_price_type_'+value+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="delete_discount('+param+')"  style="display:inline-block; position:relative;left:10px;"><img class="lt deleteButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div>';
    $('.createDynamicDiscount_'+adId).append(str);
	
	
    // set height for ie support
    if ($.support.msie && $.support.version == 7){	
        var advancedPriceHeight = $('#multiple_discount_'+value).css('height');
        var priceDivHeight = $('.priceDiv').css('height');
        priceDivHeight= parseInt(priceDivHeight) + parseInt(advancedPriceHeight);

        $('#multiple_discount_'+value).css('height' ,advancedPriceHeight);
        $('#session_'+value).css('height','72px');
        $('.priceDiv').css('height' ,priceDivHeight);
    }
     
    if(net == "net"){
        params = 'net_1_'+ad_id;
    }
    else{
        params = '1_'+ad_id;
    }
	
    $('.createDynamicDiscount_'+adId+' #ad_no_sess_'+value).val($("#ad_no_sess_"+params).val());
    $('.createDynamicDiscount_'+adId+' #ad_no_sess_'+value).css('color','#444444');
    $('.createDynamicDiscount_'+adId+' #ad_discount_sess_price_'+value).val($("#ad_discount_sess_price_"+params).val());
    $('.createDynamicDiscount_'+adId+' #ad_discount_sess_price_'+value).css('color','#444444');
    $('.createDynamicDiscount_'+adId+' #ad_discount_sess_price_type_'+value).val($("#ad_discount_sess_price_type_"+params).val());


    $(".staticDiscount_"+params+"  #ad_no_sess_"+params).val('Eg: 3');
    $(".staticDiscount_"+params+" #ad_no_sess_"+params).css('color','#999999');
    $(".staticDiscount_"+params+" #ad_discount_sess_price_"+params).val('Eg: 3');
    $(".staticDiscount_"+params+" #ad_discount_sess_price_"+params).css('color','#999999');
    $(".staticDiscount_"+params+" #ad_discount_sess_price_type_"+params).val('$');

}

function edit_session(net,ad_id){
    var str='';
    var msg='';
    var count_inc = 0;
    if(net == "net"){
        var adId = 'net_'+ad_id+'_'+ad_id;
		
    }
    else{
        var adId = ad_id+'_'+ad_id;
		
    }
    var lengthDiv = $('.createDynamicDiscount_'+adId+' .multiple_discount').length;

    if(lengthDiv==0){
        $("#multiple_discount_count_"+adId).val(1);
    }

    var currentDiv = lengthDiv+2;
    var value = currentDiv;

    var count=$("#multiple_discount_count_"+adId).val();
    if(currentDiv==2){
        count_inc=count+","+value;
    }
    else{
        count_inc=count+","+value;
    }
    if(net == "net"){
        value = 'net_'+currentDiv+"_"+ad_id;
        var param = "'net',"+currentDiv+","+ad_id;
		
    }
    else{
        value = currentDiv+"_"+ad_id;
        var param = "'',"+currentDiv+","+ad_id;
		
    }

    $("#multiple_discount_count_"+adId).val(count_inc);

    str = '<div id="multiple_discount_'+value+'" class="multiple_discount"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" id="no_sess_'+value+'">Quantity</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" class="drop_down_left width_set6" style="color:#444444;"><option value="Multiple Session Discount" selected="selected">Multiple Session Discount</option></select></div><div id="session_'+value+'"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li></ul></li></ul><div class="clear"></div></div></div><input type="text" id="ad_no_sess_'+value+'" name="ad_no_sess_'+value+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_discount_sess_price_'+value+'" name="ad_discount_sess_price_'+value+'" class="lt textbox" value="Eg: 3" maxlength="7"  style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}"/><div class="lt session_price_type"><select name="ad_discount_sess_price_type_'+value+'" id="ad_discount_sess_price_type_'+value+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="delete_discount('+param+')"  style="display:inline-block; position:relative;left:10px;"><img class="lt deleteButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div>';
    $('.createDynamicDiscount_'+adId).append(str);
	
    
    // set height for ie support
    if ($.support.msie && $.support.version == 7){	
	     
        var advancedPriceHeight = $('#multiple_discount_'+value).css('height');
        var priceDivHeight = $('.priceDiv').css('height');
        priceDivHeight= parseInt(priceDivHeight) + parseInt(advancedPriceHeight);

        $('#multiple_discount_'+value).css('height' ,advancedPriceHeight);
        $('#session_'+value).css('height','72px');
        $('.priceDiv').css('height' ,priceDivHeight);
    }
}

/*********************  Participant ADD Func ****************************/
function add_participant(net,ad_id){
    var str='';
    var msg='';
    var count_inc = 0;
    if(net == "net"){
        var adId = 'net_'+ad_id+'_'+ad_id;
		
    }
    else{
        var adId = ad_id+'_'+ad_id;
		
    }
    var lengthDiv = $('.createDynamicDiscount_'+adId+' .multiple_discount').length;

    if(lengthDiv==0){
        $("#multiple_discount_count_"+adId).val(1);
    }

    var currentDiv = parseInt(lengthDiv) + parseInt(2);
    var value = currentDiv;

    count=$("#multiple_discount_count_"+adId).val();
    if(currentDiv==2){
        count_inc=count+","+value;
    }
    else{
        count_inc=count+","+value;
    }

    if(net == "net"){
        value = 'net_'+currentDiv+"_"+ad_id;
        var param = "'net',"+currentDiv+","+ad_id;
		
    }
    else{
        value = currentDiv+"_"+ad_id;
        var param = "'',"+currentDiv+","+ad_id;
		
    }

    $("#multiple_discount_count_"+adId).val(count_inc);

    str = '<div id="multiple_discount_'+value+'" class="multiple_discount"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" id="no_part_'+value+'">Quantity</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" class="drop_down_left width_set6" style="color:#444444;"><option value="Multiple Participant Discount" selected="selected">Multiple Participant Discount</option></select></div><div id="participant_'+value+'"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li></ul></li></ul><div class="clear"></div></div></div><input type="text" id="ad_no_part_'+value+'" name="ad_no_part_'+value+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_discount_part_price_'+value+'" name="ad_discount_part_price_'+value+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}"/><div class="lt participant_price_type"><select name="ad_discount_part_price_type_'+value+'" id="ad_discount_part_price_type_'+value+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="delete_discount('+param+')" style="display:inline-block; position:relative;left:10px;"><img class="lt deleteButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div>';
    $('.createDynamicDiscount_'+adId).append(str);
	
 
    // set height for ie support
    if ($.support.msie && $.support.version == 7){
        var advancedPriceHeight = $('#multiple_discount_'+value).css('height');
        var priceDivHeight = $('.priceDiv').css('height');
        priceDivHeight= parseInt(priceDivHeight) + parseInt(advancedPriceHeight);

        $('#multiple_discount_'+value).css('height' ,advancedPriceHeight);
        $('#participant_'+value).css('height','72px');
        $('.priceDiv').css('height' ,priceDivHeight);
    }

	
    if(net == "net"){
        params = 'net_1_'+ad_id;
    }
    else{
        params = '1_'+ad_id;
    }
	
    $('.createDynamicDiscount_'+adId+' #ad_no_part_'+value).val($("#ad_no_part_"+params).val());
    $('.createDynamicDiscount_'+adId+' #ad_no_part_'+value).css('color','#444444');
    $('.createDynamicDiscount_'+adId+' #ad_discount_part_price_'+value).val($("#ad_discount_part_price_"+params).val());
    $('.createDynamicDiscount_'+adId+' #ad_discount_part_price_'+value).css('color','#444444');
    $('.createDynamicDiscount_'+adId+' #ad_discount_part_price_type_'+value).val($("#ad_discount_part_price_type_"+params).val());

    $(".staticDiscount_"+params+" #ad_no_part_"+params).val('Eg: 3');
    $(".staticDiscount_"+params+" #ad_no_part_"+params).css('color','#999999');
    $(".staticDiscount_"+params+" #ad_discount_part_price_"+params).val('Eg: 3');
    $(".staticDiscount_"+params+" #ad_discount_part_price_"+params).css('color','#999999');
    $(".staticDiscount_"+params+" #ad_discount_part_price_type_"+params).val('$');
   
}

function edit_participant(net,ad_id){
    var str='';
    var msg='';
    var count_inc = 0;
    if(net == "net"){
        var adId = 'net_'+ad_id+'_'+ad_id;
		
    }
    else{
        var adId = ad_id+'_'+ad_id;
		
    }
    var lengthDiv = $('.createDynamicDiscount_'+adId+' .multiple_discount').length;

    if(lengthDiv==0){
        $("#multiple_discount_count_"+adId).val(1);
    }

    var currentDiv = lengthDiv+2;
    var value = currentDiv;

    count=$("#multiple_discount_count_"+adId).val();
    if(currentDiv==2){
        count_inc=count+","+value;
    }
    else{
        count_inc=count+","+value;
    }
    if(net == "net"){
        value = 'net_'+currentDiv+"_"+ad_id;
        var param = "'net',"+currentDiv+","+ad_id;
		
    }
    else{
        value = currentDiv+"_"+ad_id;
        var param = "'',"+currentDiv+","+ad_id;
		
    }

    $("#multiple_discount_count_"+adId).val(count_inc);

    str = '<div id="multiple_discount_'+value+'" class="multiple_discount"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" id="no_part_'+value+'">Quantity</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type" class="drop_down_left width_set6"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" style="color:#444444;"  class="drop_down_left width_set6"><option value="Multiple Participant Discount" selected="selected">Multiple Participant Discount</option></select></div><div id="participant_'+value+'"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li></ul></li></ul><div class="clear"></div></div></div><input type="text" id="ad_no_part_'+value+'" name="ad_no_part_'+value+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_discount_part_price_'+value+'" name="ad_discount_part_price_'+value+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}"/><div class="lt participant_price_type"><select name="ad_discount_part_price_type_'+value+'" id="ad_discount_part_price_type_'+value+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="delete_discount('+param+')" style="display:inline-block; position:relative;left:10px;"><img class="lt deleteButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div>';
    $('.createDynamicDiscount_'+adId).append(str);
	
    
    // set height for ie support
    if ($.support.msie && $.support.version == 7){	
        var advancedPriceHeight = $('#multiple_discount_'+value).css('height');
        var priceDivHeight = $('.priceDiv').css('height');
        priceDivHeight= parseInt(priceDivHeight) + parseInt(advancedPriceHeight);

        $('#multiple_discount_'+value).css('height' ,advancedPriceHeight);
        $('#participant_'+value).css('height','72px');
        $('.priceDiv').css('height' ,priceDivHeight);
    }
}

/*********************  Delete Func ****************************/
function delete_discount(net,incVal,ad_id){
    if(net == "net"){
        var adId = 'net_'+ad_id+'_'+ad_id;
		
    }
    else{
        var adId = ad_id+'_'+ad_id;
		
    }
    var count=$("#multiple_discount_count_"+adId).val();
    var countSplit = count.split(",");
    var countLess = countSplit.length-1;
    var incValLess = incVal-1;
    var removeVal = "";
    remove_count=$("#multiple_discount_count_"+adId).val();
	
    for(var i=0;i<countSplit.length;i++){
        if(countSplit[i]!=incVal){
            removeVal = ","+incVal
            r_count=remove_count.replace(removeVal,"");
            r_count=r_count.replace(incVal,"");
            $("#multiple_discount_count_"+adId).val(r_count);
        }
    }
    
    if(net == "net"){
        var incVal = 'net_'+incVal+"_"+ad_id;
		
    }
    else{
        var incVal = incVal+"_"+ad_id;
		
    }
	    
    // set height for ie support
    if ($.support.msie && $.support.version == 7){	
	     
        var priceDivHeight = $('.priceDiv').css('height');
        var advancedPriceHeight = $('#multiple_discount_'+incVal).css('height');
	      
        priceDivHeight = priceDivHeight.replace('px','');
        advancedPriceHeight = advancedPriceHeight.replace('px','');
	    
        priceDivHeight = parseInt(priceDivHeight) - parseInt(advancedPriceHeight);
        priceDivHeight = parseInt(priceDivHeight) - parseInt(5);
	   
        $('.priceDiv').css('height' ,priceDivHeight+'px');
        $('#multiple_discount_'+incVal).css('height','0px');
        $('.createDynamicDiscount_'+adId+' #multiple_discount_'+incVal).css('height','0px');
    }
     
    $('.createDynamicDiscount_'+adId+' #multiple_discount_'+incVal).html('');
    

    ///////  again  update early brid option
    
    var priceVal=$("#multiple_discount_count_"+adId).val();
    var priceSplitVal=priceVal.split(",");
    var priceLength = parseInt(priceSplitVal.length) ;
    var removeEarly = '';
    var selectedHour = 0;
     
    if(net == "net"){
        param = "'net',1,"+ad_id;
        for(var k=0;k<priceLength;k++){
            var selectVal = $("#discount_type_net_1_"+priceSplitVal[k]).val();
            if(selectVal != "Early Bird Discount" ){
                var selectedHour = 1;
            }
        }

        if(selectedHour==1){
            removeEarly = '<div class="lt discout_type" id="discount_type_net_1_'+ad_id+'"><select name="ad_discount_type_net_1_'+ad_id+'" id="ad_discount_type_net_1_'+ad_id+'" class="drop_down_left width_set6" onkeyup="discTypeChanged('+param+',this.value);$(this).css(\'color\',\'#444444\');" onchange="discTypeChanged('+param+',this.value);$(this).css(\'color\',\'#444444\');"><option value="--Choose Discount Type--">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div>';
        }

        var selectedDiscount = $('#ad_discount_type_net_1_'+ad_id).val();
	    
        $("#discount_type_net_1_"+ad_id).html('');
        $("#discount_type_net_1_"+ad_id).html(removeEarly);

        $('#ad_discount_type_net_1_'+ad_id+' option[value="' + selectedDiscount + '"]').attr("selected", "selected");
    }
    else{
        param = "'',1,"+ad_id;
        for(var k=0;k<priceLength;k++){
            var selectVal = $("#discount_type_1_"+priceSplitVal[k]).val();
            if(selectVal != "Early Bird Discount" ){
                var selectedHour = 1;
            }
        }

        if(selectedHour==1){
            removeEarly = '<div class="lt discout_type" id="discount_type_1_'+ad_id+'"><select name="ad_discount_type_1_'+ad_id+'" id="ad_discount_type_1_'+ad_id+'" class="drop_down_left width_set6" onkeyup="discTypeChanged('+param+',this.value);$(this).css(\'color\',\'#444444\');" onchange="discTypeChanged('+param+',this.value);$(this).css(\'color\',\'#444444\');"><option value="--Choose Discount Type--">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div>';
        }

        var selectedDiscount = $('#ad_discount_type_1_'+ad_id).val();
	    
        $("#discount_type_1_"+ad_id).html('');
        $("#discount_type_1_"+ad_id).html(removeEarly);

        $('#ad_discount_type_1_'+ad_id+' option[value="' + selectedDiscount + '"]').attr("selected", "selected");
    }
       
}

/****************** Advanced Price Add Func *************************/
function add_advanced_price(){
    var str='';
    var msg='';
    var count_inc = 0;

    var lengthDiv = $('.dynamicAdvancedPrice font').length;

    if(lengthDiv==0){
        $("#advance_price_count").val("1");
    }

    var currentDiv = parseInt(lengthDiv) + parseInt(2);
    var value = currentDiv;

    count=$("#advance_price_count").val();
    if(currentDiv==2){
        count_inc=count+","+value;
    }
    else{
        count_inc=count+","+value;
    }

    value = currentDiv+"_"+currentDiv;
    var param = currentDiv;

    $("#advance_price_count").val(count_inc);
    
    var priceVal=$("#advance_price_count").val();
    var priceSplitVal=priceVal.split(",");
    var priceLength = parseInt(priceSplitVal.length) - parseInt(1);
   

    var selectedHour = 0;
    for(var k=0;k<priceLength;k++){
        var selectVal = $("#ad_payment_1_"+priceSplitVal[k]).val();
        if(selectVal == "Per Hour" ){
            var selectedHour = 1;
        }
    }
	
    if(selectedHour==1){
        selectopt = '<select name="ad_payment_1_'+param+'" id="ad_payment_1_'+param+'" class="drop_down_left width_set5" onchange="payTypeChanged(1,'+param+',this.value)" onkeyup="payTypeChanged(1,'+param+',this.value)"><option value="Class Card" selected="selected">Class Card</option><option value="Per Session">Per Session</option><option value="Weekly">Weekly</option><option value="Monthly">Monthly</option><option value="Yearly">Yearly</option></select>';
        $('#ad_payment_1_'+param+'_container').css('height','110px');
    }
    else{
        selectopt = '<select name="ad_payment_1_'+param+'" id="ad_payment_1_'+param+'" class="drop_down_left width_set5" onchange="payTypeChanged(1,'+param+',this.value)" onkeyup="payTypeChanged(1,'+param+',this.value)"><option value="Per Hour" selected="selected">Per Hour</option><option value="Class Card">Class Card</option><option value="Per Session">Per Session</option><option value="Weekly">Weekly</option><option value="Monthly">Monthly</option><option value="Yearly">Yearly</option></select>';
        $('#ad_payment_1_'+param+'_container').css('height','132px');
    }
    var empty="''";
    str = '<font id="advance_price_div_'+value+'"><table cellspadding="0" cellspacing="0" border="0"><tr><td><div class="lt advanced_price_1_'+param+'" id="advancedPriceContainer"><div class="priceRow1_top"><div class="lt blackText setWidthPrice">Payment Period</div><div class="lt blackText setWidthPrice1" id="display_fst_text_1_'+param+'">No. of  Hour(s)</div><div class="lt blackText setWidthPrice2" id="display_sec_text_1_'+param+'" style="display:none;"></div><div class="lt blackText setWidthPrice">Price($)</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow1_bottom"><div class="lt">'+selectopt+'</div><input type="text" id="ad_payment_box_fst_1_'+param+'" name="ad_payment_box_fst_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:100px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_payment_box_sec_1_'+param+'" name="ad_payment_box_sec_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="5" style="display:none;width:100px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_price_1_'+param+'" name="ad_price_1_'+param+'" class="lt textbox" value="$" maxlength="7" style="width:100px;" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}"/></div><div class="clear"></div><input type="hidden" name="multiple_discount_count_'+value+'" id="multiple_discount_count_'+value+'" value="1"/><div class="createDynamicDiscount_'+value+'"></div><div class="clear"></div><div id="staticDiscount_1_'+param+'"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none;" id="no_sess_1_'+param+'">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_1_'+param+'">Quantity</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type" id="discount_type_1_'+param+'"><select name="ad_discount_type_1_'+param+'" id="ad_discount_type_1_'+param+'" class="drop_down_left width_set6" onchange="discTypeChanged('+empty+',1,'+param+',this.value);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged('+empty+',1,'+param+',this.value);$(this).css(\'color\',\'#444444\');"><option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div><div id="session_1_'+param+'" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li></ul></li></ul><div class="clear"></div></div></div><input type="text" id="ad_no_sess_1_'+param+'" name="ad_no_sess_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_discount_sess_price_1_'+param+'" name="ad_discount_sess_price_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><div class="lt session_price_type"><select name="ad_discount_sess_price_type_1_'+param+'" id="ad_discount_sess_price_type_1_'+param+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="validate_session('+empty+',1,'+currentDiv+')" style="display:inline-block; position:relative;left:10px;"><img class="lt addButton" src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none;"><div id="advance_session_error_1_'+param+'" style=".margin-left:-210px;"></div></div><div class="clear"></div></div><div id="participant_1_'+param+'" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li></ul></li></ul><div class="clear"></div></div></div><input type="text" id="ad_no_part_1_'+param+'" name="ad_no_part_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_discount_part_price_1_'+param+'" name="ad_discount_part_price_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><div class="lt participant_price_type"><select name="ad_discount_part_price_type_1_'+param+'" id="ad_discount_part_price_type_1_'+param+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="validate_participant('+empty+',1,'+param+')" style="display:inline-block; position:relative;left:10px;"><img class="lt addButton" src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none;"><div id="advance_participant_error_1_'+param+'" style=".margin-left:-210px;"></div></div><div class="clear"></div></div><div class="clear"></div><div id="early_brid_1_'+param+'" style="display:none;"><div id="provider_event_list" style="float: left;width: 0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div><div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText">Valid  Until</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow3_bottom"><input type="text" id="ad_no_subs_1_'+param+'" name="ad_no_subs_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="5"  style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}"/><div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_1_'+param+'" name="ad_valid_date_1_'+param+'" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onChange="$(this).css(\'color\',\'#444444\');" /><input type="hidden" id="ad_valid_date_alt_1_'+param+'" name="ad_valid_date_alt_1_'+param+'" value="" /></div></div> <input type="text" id="ad_discount_price_1_'+param+'" name="ad_discount_price_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="7"  style="width:100px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><div class="lt price_type"><select name="ad_discount_price_type_1_'+param+'" id="ad_discount_price_type_1_'+param+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="validate_early_bid('+empty+',1,'+param+')"  style="display:inline-block; position:relative;left:10px;"><img class="lt addButton" src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_1_'+param+'"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div><div class="errorDiv" style="display:none;"><div id="advance_error_'+value+'"></div></div><div class="clear"></div></div></div></td><td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_'+value+'"><a href="javascript:void(0)" title="" onClick="validate_advanced_price(1,'+param+')" ><img class="addButton" src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a><a href="javascript:void(0)" title="" onClick="delete_advanced_price('+param+')" ><img class="lt deleteButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div></div><div class="clear"></div></td></tr></table></font>';
    $('.dynamicAdvancedPrice').append(str);
	
    
    // set height for ie support
    if ($.support.msie && $.support.version == 7){	     
        $('#early_brid_1_'+param).css('height','100px');
        $('#session_1_'+param).css('height','72px');
        $('#participant_1_'+param).css('height','72px');
    }

    var cu_value = $('table #ad_payment_1_'+param).val();
     
    if(cu_value == "Per Hour" ){
        $("#display_fst_text_1_"+param).show();
        $("#display_fst_text_1_"+param).html('No. of Hour(s)');
    }
    if(cu_value == "Class Card" ){
        $("#display_fst_text_1_"+param).show();
        $("#display_fst_text_1_"+param).html('No. of Classes');
    }
	
    // create page
    $(function() {	
        $(".createPage #ad_valid_date_1_"+param).datepicker({
            showOn : "button",
            buttonImage : "/assets/create_new_activity/date_icon.png",
            buttonImageOnly : true,
            minDate : 0,
            dateFormat: "D, M d, yy",
            altField : "#ad_valid_date_alt_1_"+param,
            altFormat : "yy-m-d"
        });
    });  
    // edit page
    $(function() {	
        $(".editPage #ad_valid_date_1_"+param).datepicker({
            showOn : "button",
            buttonImage : "/assets/create_new_activity/date_icon.png",
            buttonImageOnly : true, 
            dateFormat: "D, M d, yy",
            altField : "#ad_valid_date_alt_1_"+param,
            altFormat : "yy-m-d"
        });
    });  
   

    var dateVal1 = $('#dateFormate_1').val();
    var dateVal2 = $('#date_1').val();
	  
    $("#ad_valid_date_1_"+param).val(dateVal1);
    $("#ad_valid_date_alt_1_"+param).val(dateVal2);
	  
    var maxValue = 0;
    var values=$("#advance_price_count").val();
    var splitVal=values.split(",");
    var mlength = splitVal.length;
    var mmlength = mlength-1;
    maxValue = splitVal[mmlength]; 
    maxValue = maxValue+"_"+maxValue;
	
    $(".dynamicAdvancedPrice .add_del_icons .addButton" ).hide();
    $(".dynamicAdvancedPrice .add_del_icons .deleteButton" ).show();
   	
    if(mlength < 3 ){
        if(splitVal[mmlength] == 1 && mlength == 1 ){
            $("#add_del_icons_1_1 .addButton" ).show();
            $("#add_del_icons_1_1 .deleteButton" ).hide();
        }
        else if(splitVal[0]  !=  1 && mlength == 2 ){
            $('.dynamicAdvancedPrice #add_del_icons_'+maxValue+' .addButton' ).show();
            $('.dynamicAdvancedPrice #add_del_icons_'+maxValue+' .deleteButton' ).hide();
        }
        else{
            $("#add_del_icons_1_1 .addButton" ).hide();
            $("#add_del_icons_1_1 .deleteButton" ).show();
		
            $('.dynamicAdvancedPrice #add_del_icons_'+maxValue+' .addButton' ).show();
            $('.dynamicAdvancedPrice #add_del_icons_'+maxValue+' .deleteButton' ).show();
        }
    }
    else{
        $("#add_del_icons_1_1 .addButton" ).hide();
        $("#add_del_icons_1_1 .deleteButton" ).show();
		
        $('.dynamicAdvancedPrice #add_del_icons_'+maxValue+' .addButton' ).show();
        $('.dynamicAdvancedPrice #add_del_icons_'+maxValue+' .deleteButton' ).show();	
    }

}

/****************** Advanced Price Delete Func *************************/
function delete_advanced_price(incVal){	
    var count=$("#advance_price_count").val();
    var countSplit = count.split(",");
    var countLess = countSplit.length-1;
    var incValLess = incVal-1;
    var removeVal = "";
    remove_count=$("#advance_price_count").val();
	
    for(var i=0;i<countSplit.length;i++){
        if(countSplit[i]!=incVal){
            removeVal = ","+incVal
            r_count=remove_count.replace(removeVal,"");
            r_count=r_count.replace(incVal,"");
            $("#advance_price_count").val(r_count);
        }
    }
    var maxValue = 0;
    var values=$("#advance_price_count").val();
    var splitVal=values.split(",");
    var mlength = splitVal.length;
    var mmlength = mlength-1;
    maxValue = splitVal[mmlength];
    maxValue = maxValue+"_"+maxValue;

    $(".dynamicAdvancedPrice .add_del_icons .addButton" ).hide();
    $(".dynamicAdvancedPrice .add_del_icons .deleteButton" ).show();
    
    if(mlength < 3 ){
        if(splitVal[mmlength] == 1 && mlength == 1 ){
            $("#add_del_icons_1_1 .addButton" ).show();
            $("#add_del_icons_1_1 .deleteButton" ).hide();
        }
        else if(splitVal[0]  !=  1 && mlength == 2 ){
            $('.dynamicAdvancedPrice #add_del_icons_'+maxValue+' .addButton' ).show();
            $('.dynamicAdvancedPrice #add_del_icons_'+maxValue+' .deleteButton' ).hide();
        }
        else{
            $("#add_del_icons_1_1 .addButton" ).hide();
            $("#add_del_icons_1_1 .deleteButton" ).show();
		
            $('.dynamicAdvancedPrice #add_del_icons_'+maxValue+' .addButton' ).show();
            $('.dynamicAdvancedPrice #add_del_icons_'+maxValue+' .deleteButton' ).show();
        }
    }
    else{
        $("#add_del_icons_1_1 .addButton" ).hide();
        $("#add_del_icons_1_1 .deleteButton" ).show();
		
        $('.dynamicAdvancedPrice #add_del_icons_'+maxValue+' .addButton' ).show();
        $('.dynamicAdvancedPrice #add_del_icons_'+maxValue+' .deleteButton' ).show();	
    }

    incVal = incVal+"_"+incVal;
    // Delete division !important
    $('#advance_price_div_'+incVal).html('');
}

function edit_provider_fee(id){
    $('.popupContainer').css("opacity","0");
    $('#edit_other_pop').css("display","block");
    $("#edit_other_pop").html('<div align="center" style="margin-top:170px;"><img src="/assets/loading_new.gif" /></div>');
    $("#edit_other_pop").css("display","block");
    $.ajax({
        type: "POST",
        url: "activity_detail/edit_provider_fee",
        data: {
            "fee_type_id": id
        },
        dataType : 'script'
    }); 
}



function save_edit_fee()// validation save fee added
{
    
    $('#loading_img3').css("display","block");
    var fee_name = $('#edit_fee_name').val();
    var fee_price = $('#edit_fee_price').val();
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

        $('#edit_err_tr').css("display","block");
        $('#edit_error_feee').css("display","block");
        $('#edit_error_feee').text(error);
        $('#loading_img3').css("display","none");

    }
    else{
        var fee_quantity = $("#edit_fee_quantity").is(':checked');
        var fee_mandatory = $("#edit_fee_mand").is(':checked');
        var note = $("#edit_fee_notes").val();
        var fee_id = $("#edit_id").val();
        $.ajax({
            type: "POST",
            url: "activity_detail/update_provider_fee",
            data: {
                "fee_type_id":fee_id,
                "fee_name": fee_name,
                "fee_price":fee_price,
                "fee_quantity":fee_quantity,
                "fee_mandatory":fee_mandatory,
                "note":note
            },
            dataType : 'script'
        });
        $('#edit_err_tr').css("display","none");
        $('#edit_error_feee').css("display","none");
        $('#edit_error_feee').text('');
    }
}


function cancel_edit_fee()//cancel close discount code add popup
{
    $('.popupContainer').css("opacity","1");
    $('#edit_other_pop').css("display","none");


}


function edit_discount_provider_fee(id){
    $('.popupContainer').css("opacity","0");
    $('#edit_disc_pop').css("display","block");
    $("#edit_disc_pop").html('<div align="center" style="margin-top:170px;"><img src="/assets/loading_new.gif" /></div>');
    $("#edit_disc_pop").css("display","block");
    $.ajax({
        type: "POST",
        url: "activity_detail/edit_provider_discount_fee",
        data: {
            "fee_type_id": id
        },
        dataType : 'script'
    });
}


function cancel_edit_discount()//cancel close discount code add popup
{
    $('.popupContainer').css("opacity","1");
    $('#edit_disc_pop').css("display","none");
}


function save_edit_discount()// validation save discount code added
{
    $('#loading_img4').css("display","block");
    var disc_name= $('#edit_discount_code_name').val();
    var disc_code= $('#edit_discount_code').val();
    var disc_code_price = $('#edit_discount_code_price').val();
    disc_name=disc_name.replace(/(\s+)+/g," ");
    disc_code=disc_code.replace(/(\s+)+/g," ");
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

        $('#edit_err_trr').css("display","block");
        $('#edit_error_disc').css("display","block");
        $('#edit_error_disc').text(error);
        $('#loading_img4').css("display","none");

    }
    else{
        var discount_code_start = $("#edit_alt_discount_code_start").val();
        var discount_code_end = $("#edit_alt_discount_code_end").val();
        var note = $("#edit_discount_notes").val();
        var id= $("#disc_fee_id").val();
        $.ajax({
            type: "POST",
            url: "activity_detail/update_provider_discount_fee",
            data: {
                "disc_price":disc_code_price,
                "fee_type_id":id,
                "disc_name": disc_name,
                "disc_code":disc_code,
                "discount_code_start":discount_code_start,
                "discount_code_end":discount_code_end,
                "note":note
            },
            dataType : 'script'
        });
        $('#edit_err_trr').css("display","none");
        $('#edit_error_disc').css("display","none");
        $('#edit_error_disc').text('');
    }
}


function set_time_edit_for_discount(){
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


    $("#edit_discount_code_start").datepicker({
        showOn : "button",
        buttonImage : "/assets/create_new_activity/date_icon.png",
        buttonImageOnly : true,
        minDate: 0,
        dateFormat: "D d/m/ yy",
        altField : "#edit_alt_discount_code_start",
        altFormat : "yy-m-d"
    });

    $("#edit_discount_code_end").datepicker({
        showOn : "button",
        buttonImage : "/assets/create_new_activity/date_icon.png",
        buttonImageOnly : true,
        minDate: 0,
        dateFormat:"D d/m/ yy",
        altField : "#edit_alt_discount_code_end",
        altFormat : "yy-m-d"
    });

}

function delete_other_provider_fee(id){
    $("#del_other_pop").val(id);
    $('.popupContainer').css("opacity","0");
    $('#delete_other_pop').css("display","block");
}


function delete_disc_provider_fee(id){
    $("#del_disc_pop").val(id);
    $('.popupContainer').css("opacity","0");
    $('#delete_disc_pop').css("display","block");
}

function delete_discount(){
    var del_ot = $("#del_disc_pop").val()
    $.ajax({
        type: "POST",
        url: "activity_detail/delete_provider_discount_fee",
        data: {
            "fee_type_id":del_ot
        },
        dataType : 'script'
    });
    
}
function del_other_fee(){
    var del_ot = $("#del_other_pop").val()
    $.ajax({
        type: "POST",
        url: "activity_detail/delete_provider_fee",
        data: {
            "fee_type_id":del_ot
        },
        dataType : 'script'
    });
}

function other_hid_fee(){
    $('.popupContainer').css("opacity","1");
    $('#delete_other_pop').css("display","none");
}

function dele_hid_discount(){
    $('.popupContainer').css("opacity","1");
    $('#delete_disc_pop').css("display","none");
}
/**************discount type valiation*******************/
function save_new_discount_options()
{
    
    var cdisc_name= $('#create_disc_name').val();
    
    var er_flag;
    var errorq='';
    if(cdisc_name==""||cdisc_name=="Enter Discount type")
    {
        errorq+=' Please enter  discount code name';
        er_flag=0;
    }
    if(er_flag==0){

        $('#parent_did_type_eror').css("display","block");
        $('#dis_type_error').css("display","block");
        $('#dis_type_error').text(errorq);

    }
    else{
        var disc_quantity = $("#create_disc_quantity").is(':checked');
        var disc_valid_date = $("#create_disc_valid").is(':checked');
        var discount_price = $("#create_disc_price").is(':checked');
        var note = $("#create_disc_notes").val();
        $.ajax({
            type: "POST",
            url: "activity_detail/provider_discount_type",
            data: {
                "disc_valid_date":disc_valid_date,
                "disc_name": cdisc_name,
                "disc_quantity":disc_quantity,
                "discount_price":discount_price,
                "note":note
            },
            dataType : 'script'
        });


        $('#parent_did_type_eror').css("display","none");
        $('#dis_type_error').css("display","none");
        $('#dis_type_error').text('');

    }
}
/*******************************/
function cancel_save_discount_options(){
    $('.popupContainer').css('opacity','1');//set the over lay
    $('#create_disc_creat_pop').css('display','none');
}

function open_createnew_discoption()
{
		    
    $('.popupContainer').css('opacity','0');
    $('#create_disc_creat_pop').css('display','block');
}

function add_plus_discount(net,id1,id2,id3,cu_value,lstval){
    $.ajax({
        type: "POST",
        url: "activity_detail/create_first_discount_type",
        data:{
            "net":net,
            "id1":id1,
            "id2":id2,
            "id3":id3+1,
            "cu_value":cu_value,
            "lstval":lstval,
            "rem":"yes"
        },
        success:function(result){
            if(net=="net_")
                $("#advancedPriceContainer_"+id1+"_1").append(result);
            else
                $("#advanced_PriceContainer_adv_"+id1+"_"+id2).append(result);
        }
    });
    
    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*********************************    set the time early bid   ********************************/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	    
function date_calculates(net,id1,id2,id3){
			
    if(net=='net_'){
        var id=net+""+id1+"_"+id2+"_"+id3;
        $("#ad_valid_date_"+id).val(formatDates_day());
        $("#ad_valid_date_alt_"+id).val( formatDates());
    }
    else{
        var id=id1+"_"+id2+"_"+id3;
        $("#ad_valid_date_"+id).val(formatDates_day());
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
function formatDates_day(){
    var d = new Date();
    var weekday = new Array(7);
    weekday[0] = "Sun";
    weekday[1] = "Mon";
    weekday[2] = "Tue";
    weekday[3] = "Wed";
    weekday[4] = "Thu";
    weekday[5] = "Fri";
    weekday[6] = "Sat";
    var monthNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];
                   
    var curr_day=weekday[d.getDay()];
    var curr_date = d.getDate();
    var curr_month = monthNames[d.getMonth()];
    var curr_year = d.getFullYear();
    return (curr_day+", "+curr_month+" "+ curr_date +", "+curr_year) ;
}

