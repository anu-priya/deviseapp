function validateDot(elementValue) {
    var emailSplitat = elementValue.split("@");
    var emailSplitdotf = emailSplitat[0].split(".");
    var emailSplitdotl = emailSplitat[1].split(".");
  	 
    /*    if(emailSplitat[0].length<4){
        return false;
    }
  	  	
    if(emailSplitdotf.length>3){
        return false;
    }
*/    if(emailSplitdotf.length<3){
        var filter = /[^a-z/g]+/gi;
        var filter1 = /^[0-9]+$/;
        if(filter.test( emailSplitdotf) && filter1.test( emailSplitdotf)){
            return false;
        }
    }
    if(emailSplitdotl.length>1){
        var prev = emailSplitdotl[0];
        var curr = emailSplitdotl[1];
        for(var i=1;i<emailSplitdotl.length;i++){
            if(prev == curr ){
                return false;
            }
            prev = curr;
            curr = 	emailSplitdotl[i+1];
        }
    }
    if(emailSplitdotl.length>3){
        return false;
    }
    return true;
}

  function removeunwantedSpace(username_usr,id){
    var values=username_usr;
    var str='';
    var p=values.charAt(0);
    var firstVal=p;
    var c='';
    var i=0;
    while(values.charAt(i)!=''){
        p=c;
        i++;
        c=values.charAt(i);
        if(p==' ' && c!=' '){ }
        if(p==' ' && c==' '){ }
        else{
            str+=values.charAt(i);
        }
    }
    document.getElementById(id).value=firstVal+str;
}  

function validateZipcode(elementValue){
    var numericReg = /^\d*[0-9](|.\d*[0-9]|,\d*[0-9])?$/;
    return numericReg.test(elementValue);
}

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

function show_sell(choosen_plan,chk_partner){
  $('#plan_sell_manage').val(choosen_plan);
  var chk_url = (chk_partner=='partner_register') ? 'partner_register' : 'register';
  $('#register_plan').val(chk_url);
    var stateObj = {
      foo: "bar"
    };
    myURL = document.location;
    if(navigator.appName=="Microsoft Internet Explorer"){
      window.location.hash="/"+chk_url+"/"+choosen_plan;
    }
    else{
      parent.history.pushState(stateObj, "Login", "/"+chk_url+"/"+choosen_plan);
    }
    _gaq.push(['_trackPageview', '/'+chk_url+'/'+choosen_plan]);
    $("#provider_sell").css("display","block");
    $("#provider_registr_sub").css("display","none");
    //~ $("#provider_sponsor").css("display","none");
    //~ $("#provider_plan").css("display","none");
    //~ $("#ParentRegister").css("display","none");
    //~ $("#provider_market").css("display","none");
    //~ $("#sponsorpaymentDiv").css("display","none");
    $("#sell_b_name").focus();
  }