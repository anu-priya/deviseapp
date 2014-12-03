function validatePrize(elementValue){    
    var alphaExp = /^(\d+(?:[\.]\d{0,2})?)$/;
    return alphaExp.test(elementValue);
}
function focusChangeBorderColor(id){
    switch(id){
        case "bid_amount":
            if($('#'+id).val()== "Minimum bid amount $1" ){
                $('#'+id).val('');
            }
            break;
        case "bid_amount_monthly":
            if($('#'+id).val() == "Minimum Monthly Budget $100 / Activity" ){
                $('#'+id).val('');
            }
            break;
    }
    $('#'+id).css("border","1px solid #9fd8eb");
    $('#'+id).css("color","#444444");
//$('#'+id).focus();
}
function blurChangeBorderColor(id){
    switch(id){
        case "bid_amount":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Minimum bid amount $1");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
        case "bid_amount_monthly":
            if($('#'+id).val()== "" ){
                $('#'+id).val("Minimum Monthly Budget $100 / Activity");
                $('#'+id).css("border","1px solid #BDD6DD");
                $('#'+id).css("color","#999999");
            }
            break;
    }
    $('#'+id).css("border","1px solid #BDD6DD");
}
