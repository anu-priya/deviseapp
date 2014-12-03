/******checkbox Sponosr********/
function dispCheckboxImg_sp(imgName){
    if(imgName == 'sp_checkbox_normal'){
        $('#sp_checkbox_normal').css('display','none');
        $('#sp_checkbox_error').css('display','none');
        $('#sp_checkbox_selected').css('display','block');
        $('#sp_agree_provider').val(7);
    }
    else if(imgName == 'sp_checkbox_error'){
        $('#sp_checkbox_normal').css('display','none');
        $('#sp_checkbox_error').css('display','none');
        $('#sp_checkbox_selected').css('display','block');
        $('#sp_agree_provider').val(7);
    }	
    else{
        $('#sp_checkbox_selected').css('display','none');
        $('#sp_checkbox_normal').css('display','block');
        $('#sp_checkbox_error').css('display','none');
        $('#sp_agree_provider').val('');
    }
}
/******checkbox Sell********/
function dispCheckboxImg_sell(imgName){
    if(imgName == 'sell_checkbox_normal'){
        $('#sell_checkbox_normal').css('display','none');
        $('#sell_checkbox_error').css('display','none');
        $('#sell_checkbox_selected').css('display','block');
        $('#sell_agree_provider').val(7);
    }
    else if(imgName == 'sell_checkbox_error'){
        $('#sell_checkbox_normal').css('display','none');
        $('#sell_checkbox_error').css('display','none');
        $('#sell_checkbox_selected').css('display','block');
        $('#sell_agree_provider').val(7);
    }
    else{
        $('#sell_checkbox_selected').css('display','none');
        $('#sell_checkbox_normal').css('display','block');
        $('#sell_checkbox_error').css('display','none');
        $('#sell_agree_provider').val('');
    }
}
