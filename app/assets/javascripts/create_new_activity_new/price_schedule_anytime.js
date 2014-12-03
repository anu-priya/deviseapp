/***********************
	 Validations
***********************/

function validate_payment_anytime(fst_id,sec_id){  
    var ad_payment = $('#net_price_anytime #ad_payment_'+sec_id+'_'+sec_id).val();
    var ad_payment_box_fst = $('#net_price_anytime #ad_payment_box_fst_'+sec_id+'_'+sec_id).val();
    //  alert(ad_payment_box_fst);
    var ad_payment_box_sec = $('#net_price_anytime #ad_payment_box_sec_'+sec_id+'_'+sec_id).val();
    var ad_price = $('#net_price_anytime #ad_price_'+sec_id+'_'+sec_id).val();	
    
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
function validate_net_payment_anytime(fst_id,sec_id){  	
    var msg1='Please enter ';
    var msg='';
	
    var price = $("#net_price_anytime #price").val();

    if(price=='' || price == 'Net Amount' ){
        $("#price").focus()
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
/*********************  Validate Early Bid Func ****************************/

var priceflag1=1;
function new_validate_early_bid_anytime(net,fst_id,sec_id,opt){
 
    $('#net_price_anytime #advance_error_'+sec_id+'_'+sec_id).parent().hide();
    $('#net_price_anytime #advance_error_'+sec_id+'_'+sec_id).html('');   
   
    if(net == "net_"){
        var ad_price = $('#net_price_anytime #price').val();
        var id = "net_"+fst_id+"_"+sec_id;
        var msg = validate_net_payment_anytime(fst_id,sec_id);
		
        var neterror="net_price_error";
	
	
    }
    else{
        var id = fst_id+"_"+sec_id;
        var ad_price = $('#net_price_anytime #ad_price_'+sec_id+'_'+sec_id).val();
        var msg = validate_payment_anytime(fst_id,sec_id);
        var neterror="price_error_"+sec_id;
    }
	
    if(msg==''){
        var msg1='Please enter ';
    }
    else{
        var msg1=' ';
    }
    //  var ad_no_subs = $('#ad_no_subs_'+id).val();
   
     if($('#ad_discount_price_type_'+id).length>0){
    var ad_discount_price_type = $('#ad_discount_price_type_'+id).val();   
    
    //ad_no_subs = ad_no_subs.replace(/^\s+|\s+$/g, "");
     }
    ad_price = ad_price.replace(/^\s+|\s+$/g, "");
    
    
    //  var firstVal_ad_no_subs = ad_no_subs.charAt(0);
   
    
    if($('#ad_no_subs_'+id).length>0){
 
        var ad_no_subs = $('#ad_no_subs_'+id).val();
        if( typeof ad_no_subs!="undefined" ){
            ad_no_subs = ad_no_subs.replace(/^\s+|\s+$/g, "");
            var firstVal_ad_no_subs = ad_no_subs.charAt(0);
        }
	
        if(ad_no_subs == 'Eg: 3' || ad_no_subs == '' ){
            if(msg!=''){
                msg+=', quantity';
            }
            else{
                msg+='quantity';
            }
        }
    
        else if(ad_no_subs != '' ){
            if(!validateNumber(ad_no_subs)){
                if(msg!=''){
                    msg+=', valid quantity';
                }
                else{
                    msg+='valid quantityn';
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

     if($('#ad_discount_price_'+id).length>0){
    var ad_discount_price = $('#ad_discount_price_'+id).val();
    ad_discount_price = ad_discount_price.replace(/^\s+|\s+$/g, "");
     var firstVal_ad_discount_price = ad_discount_price.charAt(0);
    
    
    if(ad_discount_price == 'Eg: 3' || ad_discount_price == ''){
        if(msg!=''){
            msg+=', discount amount';
        }
        else{
            msg+='discount amount';
        }
		
    }
    else if(ad_discount_price != ''){
        if(!validatPrize(ad_discount_price)){
            if(msg!=''){
                msg+=', valid discount amount';
            }
            else{
                msg+='valid discount amount';
            }
        }
        else if(firstVal_ad_discount_price == 0 ){
            if(msg!=''){
                msg+=', do not use 0 as a first character(discount amount)';
            }
            else{
                msg+='do not use 0 as a first character(discount amount)';
            }
        }
        else if(parseInt(ad_price)<parseInt(ad_discount_price) && ad_discount_price_type=="$"){
            if(msg!=''){
                msg+=', the discount amount cannot be more than the activity price';
            }
            else{
                msg1='';
                msg+='The discount amount cannot be more than the activity price. Please reduce the discount amount.';
            }
        }
        else if(parseInt(ad_discount_price)>100 && ad_discount_price_type=="%"){
            if(msg!=''){
                msg+=', valid discount amount';
            }
            else{
                msg+='valid discount amount';
            }
        }
	
    }
}
	
	
    if(msg!=''){
        $('#any_advance_early_'+neterror).parent().show();
        $('#any_advance_early_'+neterror).html(msg1+msg);
	
        retVal="f";	
    }
    else{
        $('#any_advance_early_'+neterror).parent().hide();
        $('#any_advance_early_'+neterror).html('');
        retVal="t";
    }
    if(opt=="validation"){
        return retVal;
    }
    else{
        if(retVal=="t"){
            if(net == "net_"){
                $("#ad_discount_type_"+id ).css( "pointer-events"," none"  );
                $("#ad_discount_type_"+id ).css(" cursor","default" );
                new_earlybid_divadds('net_',fst_id,sec_id);
            }
            else{
                $("#ad_discount_type_"+id ).css( "pointer-events"," none"  );
                $("#ad_discount_type_"+id ).css(" cursor","default" );
                new_earlybid_divadds('',fst_id,sec_id);
            }
            priceflag1=1;
        }
    }    
}

var priceflag1=1;
function validate_early_bid_anytime(net,fst_id,sec_id,opt){
    
    
    $('#net_price_anytime #advance_error_'+sec_id+'_'+sec_id).parent().hide();
    $('#net_price_anytime #advance_error_'+sec_id+'_'+sec_id).html('');   
   
    if(net == "net"){
        var ad_price = $('#net_price_anytime #price').val();
        var id = "net_"+fst_id+"_"+sec_id;
        var msg = validate_net_payment_anytime(fst_id,sec_id);
    }
    else{
        var id = fst_id+"_"+sec_id;
        var ad_price = $('#net_price_anytime #ad_price_'+id).val();
        var msg = validate_payment_anytime(fst_id,sec_id);
    }
	
    if(msg==''){
        var msg1='Please enter ';
    }
    else{
        var msg1=' ';
    }
    var ad_no_subs = $('#ad_no_subs_'+id).val();
    var ad_discount_price = $('#ad_discount_price_'+id).val();
    var ad_discount_price_type = $('#ad_discount_price_type_'+id).val();   
    
    ad_no_subs = ad_no_subs.replace(/^\s+|\s+$/g, "");
    ad_discount_price = ad_discount_price.replace(/^\s+|\s+$/g, "");
    ad_price = ad_price.replace(/^\s+|\s+$/g, "");
    
    var firstVal_ad_no_subs = ad_no_subs.charAt(0);
    var firstVal_ad_discount_price = ad_discount_price.charAt(0);
	
    if(ad_no_subs == 'Eg: 3' || ad_no_subs == '' ){
        if(msg!=''){
            msg+=', quantity';
        }
        else{
            msg+='quantity';
        }
    }
    
    else if(ad_no_subs != '' ){
        if(!validateNumber(ad_no_subs)){
            if(msg!=''){
                msg+=', valid quantity';
            }
            else{
                msg+='valid quantityn';
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
	
    if(ad_discount_price == 'Eg: 3' || ad_discount_price == ''){
        if(msg!=''){
            msg+=', discount amount';
        }
        else{
            msg+='discount amount';
        }
		
    }
    else if(ad_discount_price != ''){
        if(!validatPrize(ad_discount_price)){
            if(msg!=''){
                msg+=', valid discount amount';
            }
            else{
                msg+='valid discount amount';
            }
        }
        else if(firstVal_ad_discount_price == 0 ){
            if(msg!=''){
                msg+=', do not use 0 as a first character(discount amount)';
            }
            else{
                msg+='do not use 0 as a first character(discount amount)';
            }
        }
        else if(parseInt(ad_price)<parseInt(ad_discount_price) && ad_discount_price_type=="$"){
            if(msg!=''){
                msg+=', the discount amount cannot be more than the activity price';
            }
            else{
                msg1='';
                msg+='The discount amount cannot be more than the activity price. Please reduce the discount amount.';
            }
        }
        else if(parseInt(ad_discount_price)>100 && ad_discount_price_type=="%"){
            if(msg!=''){
                msg+=', valid discount amount';
            }
            else{
                msg+='valid discount amount';
            }
        }
	
    }
        
	
    if(msg!=''){
        $('#net_price_anytime #advance_early_bid_error_'+id).parent().show();
        $('#net_price_anytime #advance_early_bid_error_'+id).html(msg1+msg);
        retVal="f";	
    }
    else{
        $('#net_price_anytime #advance_early_bid_error_'+id).parent().hide();
        $('#net_price_anytime #advance_early_bid_error_'+id).html('');
        retVal="t";
    }
    if(opt=="validation"){
        return retVal;
    }
    else{
        if(retVal=="t"){
            if(net == "net"){
                add_early_bid_anytime('net',sec_id);
            }
            else{
                add_early_bid_anytime('',sec_id);
            }
            priceflag1=1;
        }
    }    
    
}

/*********************  Validate Session Func ****************************/
var priceflag2=1;
function validate_session_anytime(net,fst_id,sec_id,opt){ 

    $('#net_price_anytime #advance_error_'+sec_id+'_'+sec_id).parent().hide();
    $('#net_price_anytime #advance_error_'+sec_id+'_'+sec_id).html('');
	
    if(net == "net"){
        var ad_price = $('#net_price_anytime #price').val();
        var id = "net_"+fst_id+"_"+sec_id;
        var msg = validate_net_payment_anytime(fst_id,sec_id);
    //alert('45');
    }
    else{
        var id = fst_id+"_"+sec_id;
        var ad_price = $('#net_price_anytime #ad_price_'+id).val();
        var msg = validate_payment_anytime(fst_id,sec_id);
    }
	
    if(msg==''){
        var msg1='Please enter ';
    }
    else{
        var msg1=' ';
    }
    var ad_no_sess = $('#net_price_anytime #ad_no_sess_'+id).val();
    var ad_discount_sess_price = $('#net_price_anytime #ad_discount_sess_price_'+id).val();
    var ad_discount_sess_price_type = $('#net_price_anytime #ad_discount_sess_price_type_'+id).val();   
	   
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
            msg+=', discount amount';
        }
        else{
            msg+=' discount amount';
        }
		
    }
    else if(ad_discount_sess_price != ''){
        if(!validatPrize(ad_discount_sess_price)){
            if(msg!=''){
                msg+=', valid discount amount';
            }
            else{
                msg+='valid discount amount';
            }
        }
        else if(firstVal_ad_discount_sess_price == 0 ){
            if(msg!=''){
                msg+=', do not use 0 as a first character(discount amount)';
            }
            else{
                msg+='do not use 0 as a first character(discount amount)';
            }
        }
        else if(parseInt(ad_price) < parseInt(ad_discount_sess_price) && ad_discount_sess_price_type == "$"){
            if(msg!=''){
                msg+=', the discount amount cannot be more than the activity price';
            }
            else{
                msg1='';
                msg+='The discount amount cannot be more than the activity price. Please reduce the discount amount.';
            }
        }
        else if(parseInt(ad_discount_sess_price) > 100 && ad_discount_sess_price_type == "%"){
            if(msg!=''){
                msg+=', valid discount amount';
            }
            else{
                msg+='valid discount amount';
            }
        }
    }
    if(msg!=''){
        $('#net_price_anytime #advance_session_error_'+id).parent().show();
        $('#net_price_anytime #advance_session_error_'+id).html(msg1+msg);
        retVal ="f";
        // set height for ie browser
        if ($.browser.msie && $.browser.version == 7){
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
        $('#net_price_anytime #advance_session_error_'+id).parent().hide();
        $('#net_price_anytime #advance_session_error_'+id).html('');
        retVal ="t";
        // set height for ie browser
        if ($.browser.msie && $.browser.version == 7){
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
                add_session_anytime('net',sec_id);
            }
            else{
                add_session_anytime('',sec_id);
            }
            priceflag2=1;
        }
    }

}

/*********************  Validate Participant Func ****************************/
var priceflag3=1;
function validate_participant_anytime(net,fst_id,sec_id,opt){ 
	
    $('#net_price_anytime #advance_error_'+sec_id+'_'+sec_id).parent().hide();
    $('#net_price_anytime #advance_error_'+sec_id+'_'+sec_id).html('');
    var ad_price='';
    if(net == "net"){
        ad_price = $('#net_price_anytime #price').val();
        var id = "net_"+fst_id+"_"+sec_id;
        var msg = validate_net_payment_anytime(fst_id,sec_id);
    }
    else{
        var id = fst_id+"_"+sec_id;
        ad_price = $('#net_price_anytime #ad_price_'+id).val();
        var msg = validate_payment_anytime(fst_id,sec_id);
    }
	
    if(msg==''){
        var msg1='Please enter ';
    }
    else{
        var msg1=' ';
    }
    var ad_no_part = $('#net_price_anytime #ad_no_part_'+id).val();
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
            msg+=', discount amount';
        }
        else{
            msg+=' discount amount';
        }
    }
    else if(ad_discount_part_price != ''){
        if(!validatPrize(ad_discount_part_price)){
            if(msg!=''){
                msg+=', valid discount amount';
            }
            else{
                msg+='valid discount amount';
            }
        }
        else if(firstVal_ad_discount_part_price == 0 ){
            if(msg!=''){
                msg+=', do not use 0 as a first character(discount amount)';
            }
            else{
                msg+='do not use 0 as a first character(discount amount)';
            }
        }
        else if(parseInt(ad_price) < parseInt(ad_discount_part_price) && ad_discount_part_price_type == "$"){
            if(msg!=''){
                msg+=', the discount amount cannot be more than the activity price';
            }
            else{
                msg1='';
                msg+='The discount amount cannot be more than the activity price. Please reduce the discount amount.';
            }
        }
        else if(parseInt(ad_discount_part_price) > 100 && ad_discount_part_price_type == "%"){
            if(msg!=''){
                msg+=', valid discount amount';
            }
            else{
                msg+='valid discount amount';
            }
        }
    }
    if(msg!=''){
        $('#net_price_anytime #advance_participant_error_'+id).parent().show();
        $('#net_price_anytime #advance_participant_error_'+id).html(msg1+msg);
        retVal="f";
    }
    else{
        $('#net_price_anytime #advance_participant_error_'+id).parent().hide();
        $('#net_price_anytime #advance_participant_error_'+id).html('');
        retVal="t";
    }
    if(opt=="validation"){
        return retVal;
    }
    else{       
        if(retVal=="t"){
            if(net == "net"){
                add_participant_anytime('net',sec_id);
            }
            else{
                add_participant_anytime('',sec_id);
            }
            priceflag3=1;
        }
    }    

}

/********************* validate  advanced Func ****************************/
var priceflag4=1;
function validate_advanced_price_anytime(fst_id,sec_id,opt){
    
    var xcount=$('#multiple_discount_count_'+sec_id+'_'+sec_id).val();
    xcount=xcount.split(',');
    for(i=0;i<xcount.length;i++)
    {
        var ad_discount_type = $('#net_price_anytime #ad_discount_type_'+xcount[i]+'_'+sec_id).val();
	    
        if(ad_discount_type=="--Choose Discount Type--" || ad_discount_type=="" ){
            var msg = validate_payment_anytime(fst_id,sec_id);
	    
            if(msg!=''){
                $('#net_price_anytime #advance_error_'+sec_id+'_'+sec_id).parent().show();
                $('#net_price_anytime #advance_error_'+sec_id+'_'+sec_id).html(msg);
                retVal="f";
            }
            else{
                $('#net_price_anytime #advance_error_'+sec_id+'_'+sec_id).parent().hide();
                $('#net_price_anytime #advance_error_'+sec_id+'_'+sec_id).html('');
                retVal="t";
            }
            if(opt=="validation"){
                return retVal;
            }
            else{
                if(retVal=="t"){
		    
                    priceflag1=1;
                    priceflag2=1;
                    priceflag3=1;
                    priceflag4=1;
                }
            }
        }
        else{
		    
            $('#net_price_anytime #advance_error_'+sec_id+'_'+sec_id).parent().hide();
            $('#net_price_anytime #advance_error_'+sec_id+'_'+sec_id).html('');
		    
            var retVal_bid='';
            var retVal_session='';
            var retVal_participant='';
            var retVal='';
		    
            if(ad_discount_type!=""){
                retVal_bid = new_validate_early_bid_anytime('',xcount[i],sec_id,"validation");
            }
            /*  else if(ad_discount_type=="Multiple Session Discount"){
		retVal_session = validate_session_anytime('',fst_id,sec_id,"validation");
	    }
	    else if(ad_discount_type=="Multiple Participant Discount"){
		retVal_participant = validate_participant_anytime('',fst_id,sec_id,"validation");
	    }*/
	    
            if(retVal_bid == "f" ){
                retVal="f";
            }
            else{
                retVal="t";
            }
        /*    else if( retVal_session == "f" ){
		retVal="f";
	    }
	    else if( retVal_participant =="f" ){
		retVal="f";
	    }
	    else if( retVal_bid =="t" || retVal_session == "t" || retVal_participant == "t"){
		retVal="t";
	    }*/
		    
        }
	    
    }
    
    if(opt=="validation"){
        return retVal;
    }
    else{
        if(retVal=="t"){
            add_advanced_price_anytime();
        }
    }
    
    
}
function validate_net_price_anytime(fst_id,sec_id){
    var ad_discount_type = $('#net_price_anytime #ad_discount_type_net_'+fst_id+'_'+sec_id).val();   
	
    if(ad_discount_type=="--Choose Discount Type--" || ad_discount_type=="" ){
        var msg = validate_net_payment_anytime(fst_id,sec_id);
        if(msg!=''){
            $('#net_price_anytime #net_advance_error_1_1').parent().show();
            $('#net_price_anytime #net_advance_error_1_1').html(msg);
            retVal="f";    
        }
        else{
            $('#net_price_anytime #net_advance_error_1_1').parent().hide();
            $('#net_price_anytime #net_advance_error_1_1').html('');
            retVal="t";
        }       
        return retVal;
    }
    else{		
        $('#net_price_anytime #net_advance_error_1_1').parent().hide();
        $('#net_price_anytime #net_advance_error_1_1').html('');
		
        var retVal_bid='';
        var retVal_session='';
        var retVal_participant='';
        var retVal='';
		
        if(ad_discount_type=="Early Bird Discount"){
            retVal_bid = validate_early_bid_anytime('net',fst_id,sec_id,"validation");
        }
        else if(ad_discount_type=="Multiple Session Discount"){
            retVal_session = validate_session_anytime('net',fst_id,sec_id,"validation");
        }
        else if(ad_discount_type=="Multiple Participant Discount"){
            retVal_participant = validate_participant_anytime('net',fst_id,sec_id,"validation");
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

/*********************  Early Bird ADD Func ****************************/
function new_earlybid_divadds(net,ad_id,sec_id){
    $.ajax({
        type: "POST",
        url: "activity_detail/create_first_discount_type",
        data:{
            "net":net,
            "id1":ad_id+1,
            "id2":sec_id,
            "any":"yes"
        },
        success: function(html){
            $('#net_price_anytime .createDynamicDiscount_'+net+''+sec_id+'_'+sec_id).append(html);
                                    
        }
    });
    
}
function add_early_bid_anytime(net,ad_id){ 
	
	
    var str='';
    var msg='';
    var count_inc = 0;
	
    if(net == "net"){
        var adId = 'net_'+ad_id+'_'+ad_id;
		
    }
    else{
        var adId = ''+ad_id+'_'+ad_id;
		
    }
	
   
    var lengthDiv = $('#net_price_anytime .createDynamicDiscount_'+adId+' .multiple_discount').length;
		
    if(lengthDiv==0){
        $("#net_price_anytime #multiple_discount_count_"+adId).val(1);
    }


    var currentDiv = parseInt(lengthDiv) + parseInt(2);
    var value = currentDiv;

    var count=$("#net_price_anytime #multiple_discount_count_"+adId).val();
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
	
    $("#net_price_anytime #multiple_discount_count_"+adId).val(count_inc);
    

    str ='<div id="multiple_discount_'+value+'" class="multiple_discount"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="clear"></div></div><div class="priceRow2_bottom"><div class="lt discout_type"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" class="drop_down_left width_set6" style="color:#444444;"><option value="Early Bird Discount" selected="selected">Early Bird Discount</option></select></div><div id="provider_event_list" style="float: left;width: 25px;display:block;" class="earlyHelpIcon_'+value+'"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div><div class="clear"></div><div class="priceRow3_top"><div class="lt blackText setWidthSubs">No.of  Subscription</div><div class="lt blackText setWidthSubs1">Valid  Upto</div><div class="lt blackText">Discount Amount</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow3_bottom"><input type="text" id="ad_no_subs_'+value+'" name="ad_no_subs_'+value+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" /><div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_'+value+'" name="ad_valid_date_'+value+'" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_'+value+'" name="ad_valid_date_alt_'+value+'" value="" /></div></div><input type="text" id="ad_discount_price_'+value+'" name="ad_discount_price_'+value+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" /><div class="lt price_type"><select name="ad_discount_price_type_'+value+'" id="ad_discount_price_type_'+value+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="delete_discount_anytime('+param+')" style="display:inline-block; position:relative;left:10px;"><img class="lt addButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_'+value+'"></div></div><div class="clear"></div><div class="clear"></div></div><div class="clear"></div>';
    
    $('#net_price_anytime .createDynamicDiscount_'+adId).append(str);
    
    
    if(net == "net"){
        params = 'net_1_'+ad_id;
    }
    else{
        params = '1_'+ad_id;
    }
	
    
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_no_subs_'+value).val($("#ad_no_subs_"+params).val());
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_no_subs_'+value).css('color','#444444');
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_valid_date_'+value).val($("#ad_valid_date_"+params).val());
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_valid_date_'+value).css('color','#444444');
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_valid_date_alt_'+value).val($("#ad_valid_date_alt_"+params).val());
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_discount_price_'+value).val($("#ad_discount_price_"+params).val());
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_discount_price_'+value).css('color','#444444');
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_discount_price_type_'+value).val($("#ad_discount_price_type_"+params).val());

    $("#net_price_anytime .staticDiscount_"+params+" #ad_no_subs_"+params).val('Eg: 3');
    $("#net_price_anytime .staticDiscount_"+params+" #ad_no_subs_"+params).css('color','#999999');
    $("#net_price_anytime .staticDiscount_"+params+" #ad_valid_date_"+params).css('color','#999999');
    $("#net_price_anytime .staticDiscount_"+params+" #ad_discount_price_"+params).val('Eg: 3');
    $("#net_price_anytime .staticDiscount_"+params+" #ad_discount_price_"+params).css('color','#999999');
    $("#net_price_anytime .staticDiscount_"+params+" #ad_discount_price_type_"+params).val('$');

    
    if(net == "net"){
        $(function() {
            $("#net_price_anytime #ad_valid_date_net_"+currentDiv+"_"+ad_id).datepicker({
                showOn : "button",
                buttonImage : "/assets/create_new_activity/date_icon.png",
                buttonImageOnly : true,
                minDate: 0,
                dateFormat: "D, M d, yy",
                altField : "#net_price_anytime #ad_valid_date_alt_"+value,
                altFormat : "yy-m-d",
                currentText: $.datepicker.formatDate('D, M d, yy', new Date()),
                altText: $.datepicker.formatDate('yy-m-d', new Date())
            });
        });
    }
    
    else{	    
        $(function() {
            $("#net_price_anytime #ad_valid_date_"+currentDiv+"_"+ad_id).datepicker({
                showOn : "button",
                buttonImage : "/assets/create_new_activity/date_icon.png",
                buttonImageOnly : true,
                minDate: 0,
                dateFormat: "D, M d, yy",
                altField : "#net_price_anytime #ad_valid_date_alt_"+value,
                altFormat : "yy-m-d",
                currentText: $.datepicker.formatDate('D, M d, yy', new Date()),
                altText: $.datepicker.formatDate('yy-m-d', new Date())
            });
        });
    }
  
    
	  
 
    ///////  remove early brid option
  
    if(net == "net"){
        value = 'net_1_'+ad_id;
        param = "'net',1,"+ad_id;
    }
    else{
        value = '1_'+ad_id;
        param = "'',1,"+ad_id;
    }
	
  
    var removeEarly = '';
	
    $('#net_price_anytime .staticDiscount_'+value+' #early_brid_'+value).hide();
    if(net == "net"){
        removeEarly = '<div class="lt discout_type" id="discount_type_'+value+'"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" class="drop_down_left width_set6" onchange="discTypeChanged_anytime('+param+',this.value);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged_anytime('+param+',this.value);$(this).css(\'color\',\'#444444\');"><option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div>';
    }
    else{
        removeEarly = '<div class="lt discout_type" id="discount_type_'+value+'"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" class="drop_down_left width_set6" onchange="discTypeChanged_anytime('+param+',this.value);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged_anytime('+param+',this.value);$(this).css(\'color\',\'#444444\');"><option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div>';
    }
	
    $("#net_price_anytime #discount_type_"+value).html('');
    $("#net_price_anytime #discount_type_"+value).html(removeEarly);   
    
}


function edit_early_bid_anytime(net,ad_id){
    var str='';
    var msg='';
    var count_inc = 0;
    if(net == "net"){
        var adId = 'net_'+ad_id+'_'+ad_id;
		
    }
    else{
        var adId = ''+ad_id+'_'+ad_id;
		
    }
    var lengthDiv = $('#net_price_anytime .createDynamicDiscount_'+adId+' .multiple_discount').length;

    if(lengthDiv==0){
        $("#net_price_anytime #multiple_discount_count_"+adId).val(1);
    }

    var currentDiv = parseInt(lengthDiv) + parseInt(2);
    var value = currentDiv;

    var count=$("#net_price_anytime #multiple_discount_count_"+adId).val();
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
    $("#net_price_anytime #multiple_discount_count_"+adId).val(count_inc);

    str ='<div id="multiple_discount_'+value+'" class="multiple_discount"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="clear"></div></div><div class="priceRow2_bottom"><div class="lt discout_type"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" class="drop_down_left width_set6" style="color:#444444;"><option value="Early Bird Discount" selected="selected">Early Bird Discount</option></select></div><div id="provider_event_list" style="float: left;width: 25px;display:block;" class="earlyHelpIcon_'+value+'"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div><div class="clear"></div><div class="priceRow3_top"><div class="lt blackText setWidthSubs">No.of  Subscription</div><div class="lt blackText setWidthSubs1">Valid  Upto</div><div class="lt blackText">Discount Amount</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow3_bottom"><input type="text" id="ad_no_subs_'+value+'" name="ad_no_subs_'+value+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" /><div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_'+value+'" name="ad_valid_date_'+value+'" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_'+value+'" name="ad_valid_date_alt_'+value+'" value="" /></div></div><input type="text" id="ad_discount_price_'+value+'" name="ad_discount_price_'+value+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" /><div class="lt price_type"><select name="ad_discount_price_type_'+value+'" id="ad_discount_price_type_'+value+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="delete_discount_anytime('+param+')" style="display:inline-block; position:relative;left:10px;"><img class="lt addButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_'+value+'"></div></div><div class="clear"></div><div class="clear"></div></div><div class="clear"></div>';

    $('#net_price_anytime .createDynamicDiscount_'+adId).append(str);

    if(net == "net"){
        $(function() {
            $("#net_price_anytime #ad_valid_date_net_"+currentDiv+"_"+ad_id).datepicker({
                showOn : "button",
                buttonImage : "/assets/create_new_activity/date_icon.png",
                buttonImageOnly : true,
                dateFormat: "D, M d, yy",
                altField : "#net_price_anytime #ad_valid_date_alt_"+value,
                altFormat : "yy-m-d"
            });
        });
    }
    
    else{	    
        $(function() {
            $("#net_price_anytime #ad_valid_date_"+currentDiv+"_"+ad_id).datepicker({
                showOn : "button",
                buttonImage : "/assets/create_new_activity/date_icon.png",
                buttonImageOnly : true,
                dateFormat: "D, M d, yy",
                altField : "#net_price_anytime #ad_valid_date_alt_"+value,
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
    $("#net_price_anytime .staticDiscount_"+setId+" #discount_type_"+setId+" #ad_discount_type_"+setId+" option[value='Early Bird Discount']").remove();
}


/*********************  Session ADD Func ****************************/
function add_session_anytime(net,ad_id){ 
    var str='';
    var msg='';
    var count_inc = 0;
    if(net == "net"){
        var adId = 'net_'+ad_id+'_'+ad_id;
		
    }
    else{
        var adId = ad_id+'_'+ad_id;
		
    }
    var lengthDiv = $('#net_price_anytime .createDynamicDiscount_'+adId+' .multiple_discount').length;

    if(lengthDiv==0){
        $("#net_price_anytime #multiple_discount_count_"+adId).val(1);
    }

    var currentDiv = parseInt(lengthDiv) + parseInt(2);
    var value = currentDiv;

    var count=$("#net_price_anytime #multiple_discount_count_"+adId).val();
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
	
    $("#net_price_anytime #multiple_discount_count_"+adId).val(count_inc);

    str = '<div id="multiple_discount_'+value+'" class="multiple_discount"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthQuantity" id="no_sess_'+value+'">Quantity</div><div class="lt blackText" id="discount_net_'+value+'">Discount Amount</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" class="drop_down_left width_set6" style="color:#444444;"><option value="Multiple Session Discount" selected="selected">Multiple Session Discount</option></select></div><div id="session_'+value+'"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li></ul></li></ul><div class="clear"></div></div></div><input type="text" id="ad_no_sess_'+value+'" name="ad_no_sess_'+value+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_discount_sess_price_'+value+'" name="ad_discount_sess_price_'+value+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}"/><div class="lt session_price_type"><select name="ad_discount_sess_price_type_'+value+'" id="ad_discount_sess_price_type_'+value+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="delete_discount_anytime('+param+')"  style="display:inline-block; position:relative;left:10px;"><img class="lt deleteButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div>';
    $('#net_price_anytime .createDynamicDiscount_'+adId).append(str);
	
	     
    if(net == "net"){
        params = 'net_1_'+ad_id;
    }
    else{
        params = '1_'+ad_id;
    }
	
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_no_sess_'+value).val($("#ad_no_sess_"+params).val());
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_no_sess_'+value).css('color','#444444');
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_discount_sess_price_'+value).val($("#ad_discount_sess_price_"+params).val());
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_discount_sess_price_'+value).css('color','#444444');
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_discount_sess_price_type_'+value).val($("#ad_discount_sess_price_type_"+params).val());


    $("#net_price_anytime .staticDiscount_"+params+"  #ad_no_sess_"+params).val('Eg: 3');
    $("#net_price_anytime .staticDiscount_"+params+" #ad_no_sess_"+params).css('color','#999999');
    $("#net_price_anytime .staticDiscount_"+params+" #ad_discount_sess_price_"+params).val('Eg: 3');
    $("#net_price_anytime .staticDiscount_"+params+" #ad_discount_sess_price_"+params).css('color','#999999');
    $("#net_price_anytime .staticDiscount_"+params+" #ad_discount_sess_price_type_"+params).val('$');

}

function edit_session_anytime(net,ad_id){
    var str='';
    var msg='';
    var count_inc = 0;
    if(net == "net"){
        var adId = 'net_'+ad_id+'_'+ad_id;
		
    }
    else{
        var adId = ad_id+'_'+ad_id;
		
    }
    var lengthDiv = $('#net_price_anytime .createDynamicDiscount_'+adId+' .multiple_discount').length;

    if(lengthDiv==0){
        $("#net_price_anytime #multiple_discount_count_"+adId).val(1);
    }

    var currentDiv = lengthDiv+2;
    var value = currentDiv;

    var count=$("#net_price_anytime #multiple_discount_count_"+adId).val();
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

    $("#net_price_anytime #multiple_discount_count_"+adId).val(count_inc);

    str = '<div id="multiple_discount_'+value+'" class="multiple_discount"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthQuantity" id="no_sess_'+value+'">Quantity</div><div class="lt blackText" id="discount_'+value+'">Discount Amount</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" class="drop_down_left width_set6" style="color:#444444;"><option value="Multiple Session Discount" selected="selected">Multiple Session Discount</option></select></div><div id="session_'+value+'"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li></ul></li></ul><div class="clear"></div></div></div><input type="text" id="ad_no_sess_'+value+'" name="ad_no_sess_'+value+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_discount_sess_price_'+value+'" name="ad_discount_sess_price_'+value+'" class="lt textbox" value="Eg: 3" maxlength="7"  style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}"/><div class="lt session_price_type"><select name="ad_discount_sess_price_type_'+value+'" id="ad_discount_sess_price_type_'+value+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="delete_discount_anytime('+param+')"  style="display:inline-block; position:relative;left:10px;"><img class="lt deleteButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div>';
    $('#net_price_anytime .createDynamicDiscount_'+adId).append(str);
	
}

/*********************  Participant ADD Func ****************************/
function add_participant_anytime(net,ad_id){
    var str='';
    var msg='';
    var count_inc = 0;
    if(net == "net"){
        var adId = 'net_'+ad_id+'_'+ad_id;
		
    }
    else{
        var adId = ad_id+'_'+ad_id;
		
    }
    var lengthDiv = $('#net_price_anytime .createDynamicDiscount_'+adId+' .multiple_discount').length;

    if(lengthDiv==0){
        $("#net_price_anytime #multiple_discount_count_"+adId).val(1);
    }

    var currentDiv = parseInt(lengthDiv) + parseInt(2);
    var value = currentDiv;

    count=$("#net_price_anytime #multiple_discount_count_"+adId).val();
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

    $("#net_price_anytime #multiple_discount_count_"+adId).val(count_inc);

    str = '<div id="multiple_discount_'+value+'" class="multiple_discount"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthQuantity" id="no_part_'+value+'">Quantity</div><div class="lt blackText" id="discount_'+value+'">Discount Amount</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" class="drop_down_left width_set6" style="color:#444444;"><option value="Multiple Participant Discount" selected="selected">Multiple Participant Discount</option></select></div><div id="participant_'+value+'"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li></ul></li></ul><div class="clear"></div></div></div><input type="text" id="ad_no_part_'+value+'" name="ad_no_part_'+value+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_discount_part_price_'+value+'" name="ad_discount_part_price_'+value+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}"/><div class="lt participant_price_type"><select name="ad_discount_part_price_type_'+value+'" id="ad_discount_part_price_type_'+value+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="delete_discount_anytime('+param+')" style="display:inline-block; position:relative;left:10px;"><img class="lt deleteButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div>';
    $('#net_price_anytime .createDynamicDiscount_'+adId).append(str);
	
	
    if(net == "net"){
        params = 'net_1_'+ad_id;
    }
    else{
        params = '1_'+ad_id;
    }
	
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_no_part_'+value).val($("#ad_no_part_"+params).val());
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_no_part_'+value).css('color','#444444');
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_discount_part_price_'+value).val($("#ad_discount_part_price_"+params).val());
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_discount_part_price_'+value).css('color','#444444');
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #ad_discount_part_price_type_'+value).val($("#ad_discount_part_price_type_"+params).val());

    $("#net_price_anytime .staticDiscount_"+params+" #ad_no_part_"+params).val('Eg: 3');
    $("#net_price_anytime .staticDiscount_"+params+" #ad_no_part_"+params).css('color','#999999');
    $("#net_price_anytime .staticDiscount_"+params+" #ad_discount_part_price_"+params).val('Eg: 3');
    $("#net_price_anytime .staticDiscount_"+params+" #ad_discount_part_price_"+params).css('color','#999999');
    $("#net_price_anytime .staticDiscount_"+params+" #ad_discount_part_price_type_"+params).val('$');
   
}

function edit_participant_anytime(net,ad_id){
    var str='';
    var msg='';
    var count_inc = 0;
    if(net == "net"){
        var adId = 'net_'+ad_id+'_'+ad_id;
		
    }
    else{
        var adId = ad_id+'_'+ad_id;
		
    }
    var lengthDiv = $('#net_price_anytime .createDynamicDiscount_'+adId+' .multiple_discount').length;

    if(lengthDiv==0){
        $("#net_price_anytime #multiple_discount_count_"+adId).val(1);
    }

    var currentDiv = lengthDiv+2;
    var value = currentDiv;

    count=$("#net_price_anytime #multiple_discount_count_"+adId).val();
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

    $("#net_price_anytime #multiple_discount_count_"+adId).val(count_inc);

    str = '<div id="multiple_discount_'+value+'" class="multiple_discount"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthQuantity" id="no_part_'+value+'">Quantity</div><div class="lt blackText" id="discount_'+value+'">Discount Amount</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type" class="drop_down_left width_set6"><select name="ad_discount_type_'+value+'" id="ad_discount_type_'+value+'" style="color:#444444;"  class="drop_down_left width_set6"><option value="Multiple Participant Discount" selected="selected">Multiple Participant Discount</option></select></div><div id="participant_'+value+'"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li></ul></li></ul><div class="clear"></div></div></div><input type="text" id="ad_no_part_'+value+'" name="ad_no_part_'+value+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_discount_part_price_'+value+'" name="ad_discount_part_price_'+value+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}"/><div class="lt participant_price_type"><select name="ad_discount_part_price_type_'+value+'" id="ad_discount_part_price_type_'+value+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="delete_discount_anytime('+param+')" style="display:inline-block; position:relative;left:10px;"><img class="lt deleteButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div>';
    $('#net_price_anytime .createDynamicDiscount_'+adId).append(str);
	
}

/*********************  Delete Func ****************************/
function delete_discount_anytime(net,f1,f2){
    
    if(net == "net_"){
        var adId = 'net_'+f1+'_'+f2;
	
	
        var count_inc=$("#net_price_anytime #multiple_discount_count_net_1_1").val();
        count_inc=count_inc.split(',');
        for(b=0;b<count_inc.length;b++){
            if(f1==count_inc[b])
            {
                count_inc.splice(b,1);
            }
					        
        }
        
        $("#net_price_anytime #multiple_discount_count_net_1_1").val(count_inc);
        $('#multiple_discount_'+adId).remove();
        if(count_inc.length>1)
        {
            $(".delete_single_schedule_any_net_1_1").css("display","block");
            $("#single_add_net_"+count_inc[count_inc.length-1]+"_"+f2).css("display","block");
        }
        else{
	     
            $(".delete_single_schedule_any_net_1_1").css("display","none");
            $("#single_add_net_"+count_inc[count_inc.length-1]+"_"+f2).css("display","block");
        }
		
    }
    else{
        var adId = f1+'_'+f2;
        var count_inc=$("#net_price_anytime #multiple_discount_count_"+f2+"_"+f2).val();
        count_inc=count_inc.split(',');
        for(b=0;b<count_inc.length;b++){
            if(f1==count_inc[b])
            {
                count_inc.splice(b,1);
            }
					        
        }
        
        $("#net_price_anytime #multiple_discount_count_"+f2+"_"+f2).val(count_inc);
        $('#multiple_discount_'+adId).remove();
        if(count_inc.length>1)
        {
		
            $(".delete_single_schedule_any_"+f2+"_"+f2).css("display","block");
            $("#single_add_"+count_inc[count_inc.length-1]+"_"+f2).css("display","block");
        }
        else{
	     
            $(".delete_single_schedule_any_"+f2+"_"+f2).css("display","none");
            $("#single_add_"+count_inc[count_inc.length-1]+"_"+f2).css("display","block");
        }
		
		
    }
    
}
function delete_discount_anytime_old(net,incVal,ad_id){
    if(net == "net_"){
        var adId = 'net_'+ad_id+'_'+ad_id;
	
		
    }
    else{
        var adId = ad_id+'_'+ad_id;
		
    }
    var count=$("#net_price_anytime #multiple_discount_count_"+adId).val();
    var countSplit = count.split(",");
    var countLess = countSplit.length-1;
    var incValLess = incVal-1;
    var removeVal = "";
    remove_count=$("#net_price_anytime #multiple_discount_count_"+adId).val();
	
    for(var i=0;i<countSplit.length;i++){
        if(countSplit[i]!=incVal){
            removeVal = ","+incVal
            r_count=remove_count.replace(removeVal,"");
            r_count=r_count.replace(incVal,"");
            $("#net_price_anytime #multiple_discount_count_"+adId).val(r_count);
        }
    }
    
    if(net == "net"){
        var incVal = 'net_'+incVal+"_"+ad_id;
		
    }
    else{
        var incVal = incVal+"_"+ad_id;
		
    }
     
    $('#net_price_anytime .createDynamicDiscount_'+adId+' #multiple_discount_'+incVal).html('');
    

    ///////  again  update early brid option
    
    var priceVal=$("#net_price_anytime #multiple_discount_count_"+adId).val();
    var priceSplitVal=priceVal.split(",");
    var priceLength = parseInt(priceSplitVal.length) ;
    var removeEarly = '';
    var selectedHour = 0;
     
    if(net == "net"){
        param = "'net',1,"+ad_id;
        for(var k=0;k<priceLength;k++){
            var selectVal = $("#net_price_anytime #discount_type_net_1_"+priceSplitVal[k]).val();
            if(selectVal != "Early Bird Discount" ){
                var selectedHour = 1;
            }
        }

        if(selectedHour==1){
            removeEarly = '<div class="lt discout_type" id="discount_type_net_1_'+ad_id+'"><select name="ad_discount_type_net_1_'+ad_id+'" id="ad_discount_type_net_1_'+ad_id+'" class="drop_down_left width_set6" onkeyup="discTypeChanged_anytime('+param+',this.value);$(this).css(\'color\',\'#444444\');" onchange="discTypeChanged_anytime('+param+',this.value);$(this).css(\'color\',\'#444444\');"><option value="--Choose Discount Type--">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div>';
        }

        var selectedDiscount = $('#ad_discount_type_net_1_'+ad_id).val();
	    
        $("#net_price_anytime #discount_type_net_1_"+ad_id).html('');
        $("#net_price_anytime #discount_type_net_1_"+ad_id).html(removeEarly);

        $('#ad_discount_type_net_1_'+ad_id+' option[value="' + selectedDiscount + '"]').attr("selected", "selected");
    }
    else{
        param = "'',1,"+ad_id;
        for(var k=0;k<priceLength;k++){
            var selectVal = $("#net_price_anytime #discount_type_1_"+priceSplitVal[k]).val();
            if(selectVal != "Early Bird Discount" ){
                var selectedHour = 1;
            }
        }

        if(selectedHour==1){
            removeEarly = '<div class="lt discout_type" id="discount_type_1_'+ad_id+'"><select name="ad_discount_type_1_'+ad_id+'" id="ad_discount_type_1_'+ad_id+'" class="drop_down_left width_set6" onkeyup="discTypeChanged_anytime('+param+',this.value);$(this).css(\'color\',\'#444444\');" onchange="discTypeChanged_anytime('+param+',this.value);$(this).css(\'color\',\'#444444\');"><option value="--Choose Discount Type--">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div>';
        }

        var selectedDiscount = $('#net_price_anytime #ad_discount_type_1_'+ad_id).val();
	    
        $("#net_price_anytime #discount_type_1_"+ad_id).html('');
        $("#net_price_anytime #discount_type_1_"+ad_id).html(removeEarly);

        $('#net_price_anytime #ad_discount_type_1_'+ad_id+' option[value="' + selectedDiscount + '"]').attr("selected", "selected");
    }
       
}

/****************** Advanced Price Add Func *************************/
function add_advanced_price_anytime(){
   
    var str='';
    var msg='';
    var count_inc = 0;

    var lengthDiv = $('#net_price_anytime .dynamicAdvancedPrice font').length;

    if(lengthDiv==0){
        $("#net_price_anytime #advance_price_count_anys").val("1");
    }

    var currentDiv = parseInt(lengthDiv) + parseInt(2);
    var value = currentDiv;

    count=$("#net_price_anytime #advance_price_count_anys").val();
    if(currentDiv==2){
        count_inc=count+","+value;
    }
    else{
        count_inc=count+","+value;
    }

    value = currentDiv+"_"+currentDiv;
    var param = currentDiv;

    $("#net_price_anytime #advance_price_count_anys").val(count_inc);
    
    var priceVal=$("#net_price_anytime #advance_price_count_anys").val();
    var priceSplitVal=priceVal.split(",");
    var priceLength = parseInt(priceSplitVal.length) - parseInt(1);
   

    var selectedHour = 0;
    for(var k=0;k<priceLength;k++){
        var selectVal = $("#net_price_anytime #ad_payment_1_"+priceSplitVal[k]).val();
        if(selectVal == "Per Hour" ){
            var selectedHour = 1;
        }
    }
	
    if(selectedHour==1){
        selectopt = '<select name="ad_payment_'+param+'_'+param+'" id="ad_payment_'+param+'_'+param+'" class="drop_down_left width_set5" onchange="payTypeChanged_anytime(1,'+param+',this.value)" onkeyup="payTypeChanged_anytime(1,'+param+',this.value)"><option value="Class Card" selected="selected">Class Card</option><option value="Per Session">Per Session</option><option value="Weekly">Weekly</option><option value="Monthly">Monthly</option><option value="Yearly">Yearly</option></select>';
        $('#net_price_anytime #ad_payment_1_'+param+'_container').css('height','110px');
    }
    else{
        selectopt = '<select name="ad_payment_'+param+'_'+param+'" id="ad_payment_'+param+'_'+param+'" class="drop_down_left width_set5" onchange="payTypeChanged_anytime(1,'+param+',this.value)" onkeyup="payTypeChanged_anytime(1,'+param+',this.value)"><option value="Per Hour" selected="selected">Per Hour</option><option value="Class Card">Class Card</option><option value="Per Session">Per Session</option><option value="Weekly">Weekly</option><option value="Monthly">Monthly</option><option value="Yearly">Yearly</option></select>';
        $('#net_price_anytime #ad_payment_1_'+param+'_container').css('height','132px');
    }
    var empty="''";
    var str='';
    //  str = '<font id="advance_price_div_'+value+'"><table cellspadding="0" cellspacing="0" border="0"><tr><td><div class="lt advanced_price_1_'+param+'" id="advancedPriceContainer"><div class="priceRow1_top"><div class="lt blackText setWidthPrice">Payment Period</div><div class="lt blackText setWidthPrice1" id="display_fst_text_1_'+param+'">No. of  Hour(s)</div><div class="lt blackText setWidthPrice2" id="display_sec_text_1_'+param+'" style="display:none;"></div><div class="lt blackText setWidthPrice">Price($)</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow1_bottom"><div class="lt">'+selectopt+'</div><input type="text" id="ad_payment_box_fst_1_'+param+'" name="ad_payment_box_anytime_fst_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:100px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_payment_box_sec_1_'+param+'" name="ad_payment_box_anytime_sec_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="5" style="display:none;width:100px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_price_1_'+param+'" name="ad_anytime_price_1_'+param+'" class="lt textbox" value="$" maxlength="7" style="width:100px;" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}"/></div><div class="clear"></div><input type="hidden" name="multiple_discount_count_'+value+'" id="multiple_discount_count_'+value+'" value="1"/><div class="createDynamicDiscount_'+value+'"></div><div class="clear"></div><div class="staticDiscount_1_'+param+'"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthQuantity" style="display:none;" id="no_sess_1_'+param+'">Quantity</div><div class="lt blackText setWidthQuantity" style="display:none" id="no_part_1_'+param+'">Quantity</div><div class="lt blackText" style="display:none" id="discount_1_'+param+'">Discount Amount</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type" id="discount_type_1_'+param+'"><select name="ad_discount_type_1_'+param+'" id="ad_discount_type_1_'+param+'" class="drop_down_left width_set6" onchange="discTypeChanged_anytime('+empty+',1,'+param+',this.value);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged_anytime('+empty+',1,'+param+',this.value);$(this).css(\'color\',\'#444444\');"><option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div><div id="session_1_'+param+'" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li></ul></li></ul><div class="clear"></div></div></div><input type="text" id="ad_no_sess_1_'+param+'" name="ad_no_sess_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_discount_sess_price_1_'+param+'" name="ad_discount_sess_price_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><div class="lt session_price_type"><select name="ad_discount_sess_price_type_1_'+param+'" id="ad_discount_sess_price_type_1_'+param+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="validate_session_anytime('+empty+',1,'+currentDiv+')" style="display:inline-block; position:relative;left:10px;"><img class="lt addButton" src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none;"><div id="advance_session_error_1_'+param+'" style=".margin-left:-210px;"></div></div><div class="clear"></div></div><div id="participant_1_'+param+'" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li></ul></li></ul><div class="clear"></div></div></div><input type="text" id="ad_no_part_1_'+param+'" name="ad_no_part_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><input type="text" id="ad_discount_part_price_1_'+param+'" name="ad_discount_part_price_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="7" style="width:90px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><div class="lt participant_price_type"><select name="ad_discount_part_price_type_1_'+param+'" id="ad_discount_part_price_type_1_'+param+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="validate_participant_anytime('+empty+',1,'+param+')" style="display:inline-block; position:relative;left:10px;"><img class="lt addButton" src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none;"><div id="advance_participant_error_1_'+param+'" style=".margin-left:-210px;"></div></div><div class="clear"></div></div><div class="clear"></div><div id="early_brid_1_'+param+'" style="display:none;"><div id="provider_event_list" style="float: left;width: 0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div><div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText setWidthSubs1">Valid  Upto</div><div class="lt blackText">Discount Amount</div><div class="clear"></div></div><div class="clear"></div><div class="priceRow3_bottom"><input type="text" id="ad_no_subs_1_'+param+'" name="ad_no_subs_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="5"  style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}"/><div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_1_'+param+'" name="ad_valid_date_1_'+param+'" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onChange="$(this).css(\'color\',\'#444444\');" /><input type="hidden" id="ad_valid_date_alt_1_'+param+'" name="ad_valid_date_alt_1_'+param+'" value="" /></div></div> <input type="text" id="ad_discount_price_1_'+param+'" name="ad_discount_price_1_'+param+'" class="lt textbox" value="Eg: 3" maxlength="7"  style="width:100px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" /><div class="lt price_type"><select name="ad_discount_price_type_1_'+param+'" id="ad_discount_price_type_1_'+param+'" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div></div><div class="lt add_delete_icons"><a href="javascript:void(0)" title="" onClick="validate_early_bid_anytime('+empty+',1,'+param+')"  style="display:inline-block; position:relative;left:10px;"><img class="lt addButton" src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_1_'+param+'"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div><div class="errorDiv" style="display:none;"><div id="advance_error_'+value+'"></div></div><div class="clear"></div></div></div></td><td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_'+value+'"><a href="javascript:void(0)" title="" onClick="validate_advanced_price_anytime(1,'+param+')" ><img class="addButton" src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a><a href="javascript:void(0)" title="" onClick="delete_advanced_price_anytime('+param+')" ><img class="lt deleteButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div></div><div class="clear"></div></td></tr></table></font>';
    str+='<font id="advance_price_div_'+value+'"><table cellspadding="0" cellspacing="0" border="0"><tr><td><div class="lt advanced_price_1_'+param+'" id="advancedPriceContainer">';
    str+='<div class="priceRow1_top"><div class="lt blackText setWidthPrice">Payment Period</div><div class="lt blackText setWidthPrice1" id="display_fst_text_1_'+param+'">No. of  Hour(s)</div>';
    str+='<div class="lt blackText setWidthPrice2" id="display_sec_text_1_'+param+'" style="display:none;"></div><div class="lt blackText setWidthPrice">Price($)</div><div class="clear"></div>';
    str+='</div><div class="clear"></div><div class="priceRow1_bottom"><div class="lt">'+selectopt+'</div>';
       
    str+='<input type="text" id="ad_payment_box_fst_'+param+'_'+param+'" name="ad_payment_box_anytime_fst_'+param+'_'+param+'" class="lt textbox" value="Eg: 3" maxlength="5" style="width:100px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    str+='<input type="text" id="ad_payment_box_sec_'+param+'_'+param+'" name="ad_payment_box_anytime_sec_'+param+'_'+param+'" class="lt textbox" value="Eg: 3" maxlength="5" style="display:none;width:100px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
    str+='<input type="text" id="ad_price_'+param+'_'+param+'" name="ad_anytime_price_'+param+'_'+param+'" class="lt textbox" value="$" maxlength="7" style="width:100px;" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}"/>';
    str+='</div><div class="clear"></div><input type="hidden" name="multiple_discount_count_'+value+'" id="multiple_discount_count_'+value+'" value=""/>';
    str+='<div class="createDynamicDiscount_'+value+'"></div><div class="clear"></div>';
       
    str+='<div class="staticDiscount_1_'+param+'"></div>';
       
    str+='<div class="clear"></div><div class="errorDiv" style="display:none;"><div id="advance_error_'+value+'"></div></div><div class="clear"></div></div></div><div class="errorDiv" style="none"><div id="any_advance_early_price_error_'+param+'" style="color: #ff0000;"></div></div></td><td valign="bottom">';
    str+='<div class="lt add_del_icons" id="add_del_icons_'+value+'">';
    str+='<a href="javascript:void(0)" title="" onClick="validate_advanced_price_anytime(1,'+param+')" ><img class="addButton" src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a>';
    str+='<a href="javascript:void(0)" title="" onClick="delete_advanced_price_anytime('+param+')" ><img class="lt deleteButton" src="/assets/create_new_activity/delete_icon.png" width="22" height="22" alt=""/></a>';
    str+='</div><div class="clear"></div></div><div class="clear"></div></td></tr></table></font>';
   
    $('#net_price_anytime .dynamicAdvancedPrice').append(str);
    $.ajax({
        type: "POST",
        url: "activity_detail/create_first_discount_type",
        data:{
            "net":"",
            "id1":1,
            "id2":param,
            "any":"yes"
        },
        success: function(html){
            $('#net_price_anytime .createDynamicDiscount_'+value).append(html);
                                    
        }
    });
	
    var cu_value = $('#net_price_anytime table #ad_payment_1_'+param).val();
     
    if(cu_value == "Per Hour" ){
        $("#net_price_anytime #display_fst_text_1_"+param).show();
        $("#net_price_anytime #display_fst_text_1_"+param).html('No. of Hour(s)');
    }
    if(cu_value == "Class Card" ){
        $("#net_price_anytime #display_fst_text_1_"+param).show();
        $("#net_price_anytime #display_fst_text_1_"+param).html('No. of Classes');
    }
	    
	    
    // create page
    $(function() {	
        $("#net_price_anytime .createPage #ad_valid_date_1_"+param).datepicker({
            showOn : "button",
            buttonImage : "/assets/create_new_activity/date_icon.png",
            buttonImageOnly : true,
            minDate : 0,
            dateFormat: "D, M d, yy",
            altField : "#net_price_anytime  #ad_valid_date_alt_1_"+param,
            altFormat : "yy-m-d",
            currentText: $.datepicker.formatDate('D, M d, yy', new Date()),
            altText: $.datepicker.formatDate('yy-m-d', new Date())
        });
    });  
    // edit page
    $(function() {	
        $("#net_price_anytime .editPage #ad_valid_date_1_"+param).datepicker({
            showOn : "button",
            buttonImage : "/assets/create_new_activity/date_icon.png",
            buttonImageOnly : true, 
            dateFormat: "D, M d, yy",
            altField : "#net_price_anytime #ad_valid_date_alt_1_"+param,
            altFormat : "yy-m-d",
            currentText: $.datepicker.formatDate('D, M d, yy', new Date()),
            altText: $.datepicker.formatDate('yy-m-d', new Date())
        });
    });  
  
  
    var maxValue = 0;
    var values=$("#net_price_anytime  #advance_price_count_anys").val();
    var splitVal=values.split(",");
    var mlength = splitVal.length;
    var mmlength = mlength-1;
    maxValue = splitVal[mmlength]; 
    maxValue = maxValue+"_"+maxValue;
	
    $("#net_price_anytime .dynamicAdvancedPrice .add_del_icons .addButton" ).hide();
    $("#net_price_anytime .dynamicAdvancedPrice .add_del_icons .deleteButton" ).show();
   	
    if(mlength < 3 ){
        if(splitVal[mmlength] == 1 && mlength == 1 ){
            $("#net_price_anytime #add_del_icons_1_1 .addButton" ).show();
            $("#net_price_anytime #add_del_icons_1_1 .deleteButton" ).hide();
        }
        else if(splitVal[0]  !=  1 && mlength == 2 ){
            $('#net_price_anytime .dynamicAdvancedPrice #add_del_icons_'+maxValue+' .addButton' ).show();
            $('#net_price_anytime .dynamicAdvancedPrice #add_del_icons_'+maxValue+' .deleteButton' ).hide();
        }
        else{
            $("#net_price_anytime #add_del_icons_1_1 .addButton" ).hide();
            $("#net_price_anytime #add_del_icons_1_1 .deleteButton" ).show();
		
            $('#net_price_anytime .dynamicAdvancedPrice #add_del_icons_'+maxValue+' .addButton' ).show();
            $('#net_price_anytime .dynamicAdvancedPrice #add_del_icons_'+maxValue+' .deleteButton' ).show();
        }
    }
    else{
        $("#net_price_anytime #add_del_icons_1_1 .addButton" ).hide();
        $("#net_price_anytime #add_del_icons_1_1 .deleteButton" ).show();
		
        $('#net_price_anytime .dynamicAdvancedPrice #add_del_icons_'+maxValue+' .addButton' ).show();
        $('#net_price_anytime .dynamicAdvancedPrice #add_del_icons_'+maxValue+' .deleteButton' ).show();	
    }

}

/****************** Advanced Price Delete Func *************************/
function delete_advanced_price_anytime(incVal){	
    var count=$("#net_price_anytime #advance_price_count_anys").val();
    var countSplit = count.split(",");
    var countLess = countSplit.length-1;
    var incValLess = incVal-1;
    var removeVal = "";
    remove_count=$("#net_price_anytime #advance_price_count_anys").val();
	
    for(var i=0;i<countSplit.length;i++){
        if(countSplit[i]!=incVal){
            removeVal = ","+incVal
            r_count=remove_count.replace(removeVal,"");
            r_count=r_count.replace(incVal,"");
            $("#net_price_anytime #advance_price_count_anys").val(r_count);
        }
    }
    var maxValue = 0;
    var values=$("#net_price_anytime #advance_price_count_anys").val();
    var splitVal=values.split(",");
    var mlength = splitVal.length;
    var mmlength = mlength-1;
    maxValue = splitVal[mmlength];
    maxValue = maxValue+"_"+maxValue;

    $("#net_price_anytime .dynamicAdvancedPrice .add_del_icons .addButton" ).hide();
    $("#net_price_anytime .dynamicAdvancedPrice .add_del_icons .deleteButton" ).show();
    
    if(mlength < 3 ){
        if(splitVal[mmlength] == 1 && mlength == 1 ){
            $("#net_price_anytime #add_del_icons_1_1 .addButton" ).show();
            $("#net_price_anytime #add_del_icons_1_1 .deleteButton" ).hide();
        }
        else if(splitVal[0]  !=  1 && mlength == 2 ){
            $('#net_price_anytime .dynamicAdvancedPrice #add_del_icons_'+maxValue+' .addButton' ).show();
            $('#net_price_anytime .dynamicAdvancedPrice #add_del_icons_'+maxValue+' .deleteButton' ).hide();
        }
        else{
            $("#net_price_anytime #add_del_icons_1_1 .addButton" ).hide();
            $("#net_price_anytime #add_del_icons_1_1 .deleteButton" ).show();
		
            $('#net_price_anytime .dynamicAdvancedPrice #add_del_icons_'+maxValue+' .addButton' ).show();
            $('#net_price_anytime .dynamicAdvancedPrice #add_del_icons_'+maxValue+' .deleteButton' ).show();
        }
    }
    else{
        $("#net_price_anytime #add_del_icons_1_1 .addButton" ).hide();
        $("#net_price_anytime #add_del_icons_1_1 .deleteButton" ).show();
		
        $('#net_price_anytime .dynamicAdvancedPrice #add_del_icons_'+maxValue+' .addButton' ).show();
        $('#net_price_anytime .dynamicAdvancedPrice #add_del_icons_'+maxValue+' .deleteButton' ).show();	
    }

    incVal = incVal+"_"+incVal;
    // Delete division !important
    $('#net_price_anytime #advance_price_div_'+incVal).html('');
}

function discTypeChanged_anytime(net,id1,id2,cu_value,lstval){  
    if(net == "net"){
        if(lstval==1){
            var startVal = $("#net_price_anytime #multiple_discount_count_net_1_1").val();
            if(startVal.length==''){               
                $("#net_price_anytime #multiple_discount_count_net_1_1").val(1);
            }			
        }
        var id = "net_"+id1+"_"+id2;
    }
    else{
	    
        var id = ""+id1+"_"+id2;
    }
    $("#net_price_anytime #early_brid_"+id).css('display','none');
    $('#net_price_anytime #session_'+id).css('display','none');
    $('#net_price_anytime #participant_'+id).css('display','none');
		
    $("#net_price_anytime #no_sess_"+id).css('display','none');
    $("#net_price_anytime #no_part_"+id).css('display','none');
    $("#net_price_anytime #discount_"+id).css('display','none');
	
    if(cu_value == "Early Bird Discount"){
        $("#net_price_anytime #early_brid_"+id).show();
    }
    else if(cu_value == "Multiple Session Discount"){
        $("#net_price_anytime #no_sess_"+id).show();
        $('#net_price_anytime #session_'+id).show();
        $('#net_price_anytime #discount_'+id).show();
	 
    }
    else if(cu_value == "Multiple Participant Discount"){
        $("#net_price_anytime #no_part_"+id).show();
        $('#net_price_anytime #participant_'+id).show();
        $('#net_price_anytime #discount_'+id).show();
    }
    
}
function payTypeChanged_anytime(id1,id2, cu_value){	
    var id = id1+"_"+id2;
    $("#advancedPriceDiv1 #display_fst_text_"+id).show();
    $("#advancedPriceDiv1 #display_fst_text_"+id).html('No of Hour(s)');
    
    $("#advancedPriceDiv1 #display_sec_text_"+id).hide();
    $("#advancedPriceDiv1 #display_sec_text_"+id).html('');
	
    $("#advancedPriceDiv1 #ad_payment_box_fst_"+id).show();
    $("#advancedPriceDiv1 #ad_payment_box_sec_"+id2+"_"+id2).hide();

    if(cu_value == "Per Hour" ){
        $("#advancedPriceDiv1 #display_fst_text_"+id).show();
        $("#advancedPriceDiv1 #display_fst_text_"+id).html('No. of Hour(s)');
    }
    if(cu_value == "Class Card" ){
        $("#advancedPriceDiv1 #display_fst_text_"+id).show();
        $("#advancedPriceDiv1 #display_fst_text_"+id).html('No. of Classes');
    }
    if(cu_value == "Per Session" ){
        $("#advancedPriceDiv1 #display_fst_text_"+id).show();
        $("#advancedPriceDiv1 #display_fst_text_"+id).html('No. of Day(s)');
	
        $("#advancedPriceDiv1 #display_sec_text_"+id).show();
        $("#advancedPriceDiv1 #display_sec_text_"+id).html('No. of Hour(s)');
        $("#advancedPriceDiv1 #ad_payment_box_sec_"+id2+"_"+id2).show();
    }
    if(cu_value == "Weekly" ){
        $("#advancedPriceDiv1 #display_fst_text_"+id).show();
        $("#advancedPriceDiv1 #display_fst_text_"+id).html('No. of Week(s)');
    }
    if(cu_value == "Monthly" ){
        $("#advancedPriceDiv1 #display_fst_text_"+id).show();
        $("#advancedPriceDiv1 #display_fst_text_"+id).html('No. of Month(s)');
    }
    if(cu_value == "Yearly" ){
        $("#advancedPriceDiv1 #display_fst_text_"+id).show();
        $("#advancedPriceDiv1 #display_fst_text_"+id).html('No. of Year(s)');
    }
    $("#advancedPriceDiv1 #ad_payment_box_fst_"+id).val('Eg: 3');
    $("#advancedPriceDiv1 #ad_payment_box_sec_"+id).val('Eg: 3');
    $("#advancedPriceDiv1 #ad_price_"+id).val('$');
}

//////////////////////////////////////////////////
////////////       address_anywehere       ////////////
/////////////////////////////////////////////////
	    
function disp_addres_anywhere(selcted,id)
{
		
    $(".selected_addres_anywhere").css("display","none");
    $(".normal_addres_anywhere").css("display","block");
    if(selcted=="radio_normal")
    {
        $("#selected_addres_anywhere_"+id).css("display","none");
        $("#normal_addres_anywhere_"+id).css("display","block");
    }
    else{
        $("#selected_addres_anywhere_"+id).css("display","block");
        $("#normal_addres_anywhere_"+id).css("display","none");
    }
    if(id==1)
    {
        $("#addres_anywhere_id").val('1');
        $("#hide_address_anywhere").css("display","block");
        $("#cancel_1").css("display","block");
        $("#cancel_2").css("display","none");
    }
    else{
        $("#addres_anywhere_id").val('2');
        $("#hide_address_anywhere").css("display","none");
        $("#cancel_2").css("display","block");
        $("#cancel_1").css("display","none");
    }
}
	         
	         
//////////////////////////////////////////////////
////////////   clear_values_in _netprice  ////////////
/////////////////////////////////////////////////
function clear_net_values(){
    var net_arr=$("#multiple_discount_count_net_1_1").val();
    net_arr=net_arr.split(',');
    for(i=0;i<net_arr.length;i++)
    {
        delete_discount_anytime('net',net_arr[i],1);
        $("#multiple_discount_net_"+net_arr[i]+"_1").remove();
        $('#net_price_anytime .createDynamicDiscount_net_'+net_arr[i]+'_1 #ad_no_part_net_'+net_arr[i]+'_1').val('');
        $('#net_price_anytime .createDynamicDiscount_net_'+net_arr[i]+'_1 #ad_no_part_net_'+net_arr[i]+'_1').css('color','#444444');
        $('#net_price_anytime .createDynamicDiscount_net_'+net_arr[i]+'_1 #ad_discount_part_price_net_'+net_arr[i]+'_1').val($("#ad_discount_part_price_net_"+net_arr[i]+"_1").val());
        $('#net_price_anytime .createDynamicDiscount_net_'+net_arr[i]+'_1  #ad_discount_part_price_net_'+net_arr[i]+'_1').css('color','#444444');
        $('#net_price_anytime .createDynamicDiscount_net_'+net_arr[i]+'_1 #ad_discount_part_price_type_net_'+net_arr[i]+'_1').val($("#ad_discount_part_price_type_net_"+net_arr[i]+"_1").val());
		
        $("#net_price_anytime .staticDiscount_net_"+net_arr[i]+"_1 #ad_no_part_net_"+net_arr[i]+"_1").val('Eg: 3');
        $("#net_price_anytime .staticDiscount_net_"+net_arr[i]+"_1 #ad_no_part_net_"+net_arr[i]+"_1").css('color','#999999');
        $("#net_price_anytime .staticDiscount_net_"+net_arr[i]+"_1 #ad_discount_part_price_net_"+net_arr[i]+"_1").val('Eg: 3');
        $("#net_price_anytime .staticDiscount_net_"+net_arr[i]+"_1 #ad_discount_part_price_net_"+net_arr[i]+"_1").css('color','#999999');
        $("#net_price_anytime .staticDiscount_net_"+net_arr[i]+"_1 #ad_discount_part_price_type_net_"+net_arr[i]+"_1").val('$');
    }
    $("#price").val('');
    $("#price").val('Net Amount');
    $("#ad_discount_type_net_1_1").val('');
    $("#ad_discount_type_net_1_1").val('--Choose Discount Type--');
    $("#participant_net_1_1").css("display","none");
    $("#early_brid_net_1_1").css("display","none");
    $("#no_part_net_1_1").css("display","none");
    $("#discount_net_1_1").css("display","none");
    net_arr=$("#multiple_discount_count_net_1_1").val('1');
		
}
	         
	         
//////////////////////////////////////////////////
////////////        provider url paste           ////////////
/////////////////////////////////////////////////
	        
function call_providerurl(url)
{
    if(url=='check_normal')
    {
        $('#url_pasted').val('0');
        $("#providerurl_reg_on").css("display","none");
        $("#providerurl_reg_off").css("display","block");
        $("#provider_url").css("display","none");
		
        $("#providerurl").css("height","25px");
    }
    else{
        $("#providerurl_reg_on").css("display","block");
        $('#url_pasted').val('1');
        $("#providerurl_reg_off").css("display","none");
        $("#provider_url").css("display","block");
        $("#providerurl").css("height","62px");
    }
}

//////////////////////////////////////////////////
////////////       address_anywehere       ////////////
/////////////////////////////////////////////////
	    
function disp_addres_anywhere(selcted,id)
{
		
    $(".selected_addres_anywhere").css("display","none");
    $(".normal_addres_anywhere").css("display","block");
    if(selcted=="radio_normal")
    {
        $("#selected_addres_anywhere_"+id).css("display","none");
        $("#normal_addres_anywhere_"+id).css("display","block");
    }
    else{
        $("#selected_addres_anywhere_"+id).css("display","block");
        $("#normal_addres_anywhere_"+id).css("display","none");
    }
    if(id==1)
    {
        $("#addres_anywhere_id").val('1');
        $("#hide_address_anywhere").css("display","block");
        $("#cancel_1").css("display","block");
        $("#cancel_2").css("display","none");
        $('#billing_type_sc').val('1');
    }
    else if(id==2){
        $("#addres_anywhere_id").val('2');
        $("#hide_address_anywhere").css("display","none");
        $("#cancel_2").css("display","block");
        $("#cancel_1").css("display","none");
        $('#billing_type_sc').val('5');
    }
}
	         
	         
//////////////////////////////////////////////////
////////////   clear_values_in _netprice  ////////////
/////////////////////////////////////////////////
function clear_net_values(){
    var net_arr=$("#multiple_discount_count_net_1_1").val();
    net_arr=net_arr.split(',');
    for(i=0;i<net_arr.length;i++)
    {
        delete_discount_anytime('net',net_arr[i],1);
        $("#multiple_discount_net_"+net_arr[i]+"_1").remove();
        $('#net_price_anytime .createDynamicDiscount_net_'+net_arr[i]+'_1 #ad_no_part_net_'+net_arr[i]+'_1').val('');
        $('#net_price_anytime .createDynamicDiscount_net_'+net_arr[i]+'_1 #ad_no_part_net_'+net_arr[i]+'_1').css('color','#444444');
        $('#net_price_anytime .createDynamicDiscount_net_'+net_arr[i]+'_1 #ad_discount_part_price_net_'+net_arr[i]+'_1').val($("#ad_discount_part_price_net_"+net_arr[i]+"_1").val());
        $('#net_price_anytime .createDynamicDiscount_net_'+net_arr[i]+'_1  #ad_discount_part_price_net_'+net_arr[i]+'_1').css('color','#444444');
        $('#net_price_anytime .createDynamicDiscount_net_'+net_arr[i]+'_1 #ad_discount_part_price_type_net_'+net_arr[i]+'_1').val($("#ad_discount_part_price_type_net_"+net_arr[i]+"_1").val());
		
        $("#net_price_anytime .staticDiscount_net_"+net_arr[i]+"_1 #ad_no_part_net_"+net_arr[i]+"_1").val('Eg: 3');
        $("#net_price_anytime .staticDiscount_net_"+net_arr[i]+"_1 #ad_no_part_net_"+net_arr[i]+"_1").css('color','#999999');
        $("#net_price_anytime .staticDiscount_net_"+net_arr[i]+"_1 #ad_discount_part_price_net_"+net_arr[i]+"_1").val('Eg: 3');
        $("#net_price_anytime .staticDiscount_net_"+net_arr[i]+"_1 #ad_discount_part_price_net_"+net_arr[i]+"_1").css('color','#999999');
        $("#net_price_anytime .staticDiscount_net_"+net_arr[i]+"_1 #ad_discount_part_price_type_net_"+net_arr[i]+"_1").val('$');
    }
    $("#price").val('');
    $("#price").val('Net Amount');
    $("#ad_discount_type_net_1_1").val('');
    $("#ad_discount_type_net_1_1").val('--Choose Discount Type--');
    $("#participant_net_1_1").css("display","none");
    $("#early_brid_net_1_1").css("display","none");
    $("#no_part_net_1_1").css("display","none");
    $("#discount_net_1_1").css("display","none");
    var net_arr=$("#multiple_discount_count_net_1_1").val('1');
		
}
	         
	         
//////////////////////////////////////////////////
////////////        provider url paste           ////////////
/////////////////////////////////////////////////
	        
function call_providerurl(url)
{
    if(url=='check_normal')
    {
        $('#url_pasted').val('0');
        $("#providerurl_reg_on").css("display","none");
        $("#providerurl_reg_off").css("display","block");
        $("#provider_url").css("display","none");
		
        $("#url_error").css("display","none");
        $("#providerurl").css("height","25px");
    }
    else{
        $("#providerurl_reg_on").css("display","block");
        $('#url_pasted').val('1');
        $("#providerurl_reg_off").css("display","none");
        $("#provider_url").css("display","block");
        $("#providerurl").css("height","62px");
    }
}
		
		
function disc_any_TypeChanged(net,id1,id2,cu_value){
    $("#loading_img_change").css("display","block");
    var id=net+""+id1+"_"+id2;
    if(cu_value!=""){

        $("#discount_choose_"+id).css("display","block");

        $.ajax({
            type: "POST",
            url: "activity_detail/create_discount_type",
            data: {
	    
                "net":net,
                "id1": id1,
                "id2":id2,
                "any":"yes",
                "cu_value":cu_value
          
            },
            success:function(result){
                $("#discount_choose_"+id).html(result);
                any_date_calculates(net,id1,id2);
            }
        });
    }
    else{
        $("#discount_choose_"+id).css("display","none");
    }
}

function any_date_calculates(net,id1,id2,id3){
			
    if(net=='net_'){
        var id=net+""+id1+"_"+id2;
        $("#ad_valid_date_"+id).val(formatDates_day());
        $("#ad_valid_date_alt_"+id).val( formatDates());
    }
    else{
        var id=id1+"_"+id2;
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
        altFormat : "yy-m-d",
				       
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