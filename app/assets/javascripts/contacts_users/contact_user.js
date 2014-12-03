$(document).ready(function(){
    $('#contact_names').val(' ');
    $('#pe').val(0);
    $('#select').css('display','none');
    $('#not_select').css('display','inline-block');
	
    $('.activityName .contact_checkbox_selected').css('display','none');
    $('.activityName .contact_checkbox_normal').css('display','inline-block');
});
function selectAny(cname){ alert("test");	
    if(cname == 'select'){
        $('#select').css('display','none');
        $('#not_select').css('display','inline-block');
        
        $('.activityName .contact_checkbox_selected').css('display','none');
        $('.activityName .contact_checkbox_normal').css('display','inline-block');

        $('#pe').val(0);
        $('input.contact_checkbox').val(0);
        $('#contact_names').val(' ');
		
    }
    else if(cname == 'not_select'){ alert("test");	
        $('#not_select').css('display','none');
        $('#select').css('display','inline-block');
        
        $('.activityName .contact_checkbox_normal').css('display','none');
        $('.activityName .contact_checkbox_selected').css('display','inline-block');
		
        $('#pe').val(1);
        $('input.contact_checkbox').val(1);
        $('#contact_names').val(' ');
	
        joinVal();
    }
	
}
function dispCheckSelected(incVal){
    $('#select').css('display','none');
    $('#not_select').css('display','inline-block');
    $('#pe').val(0);
	
    $('#contact_checkbox_selected_'+incVal).css('display','none');
    $('#contact_checkbox_normal_'+incVal).css('display','inline-block');
    $('#contact_checkbox_'+incVal).val(0);
    joinVal();
}
function dispCheckNormal(incVal){
    $('#contact_checkbox_selected_'+incVal).css('display','inline-block');
    $('#contact_checkbox_normal_'+incVal).css('display','none');
    $('#contact_checkbox_'+incVal).val(1);
    joinVal();
}
function joinVal(){
    var input_val='';
    var input_id ='';
    var joinStr1 ='';
    var cont_input_box_length=$('input.contact_checkbox').length;
	
    for(var i=1;i<=cont_input_box_length;i++)
    {
        input_val = $('#contact_checkbox_'+i).val();
        if(input_val!=0){
            input_id = $('#contact_id_'+i).val();
            joinStr1 += input_id+",";
		
        }
    }
    $('#contact_names').val(joinStr1);
}
function selectFile(incVal){
    $('#photo').click();
}
function dispPhotoName(){
    $('#uploadfile_name').html($('#photo').val());
}
function dispEditPhotoName(){
    $('#uploadfile_edit_name').html($('#photo').val());
}
function cancelActivityClearData(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13 ){
        clearfields();
    }
}
function clearfields(){
    $("#uploadfile_edit_name").html('');
    $("#photo").val('');
    $("#photo1").val('');
    $("#contact_name").val('');
    $("#email_id").val('');
    $("#mobile_no").val('');
    $("#gender").val('');
    $("#field1").html('--Select--');
    $("#field1").css("color","#999999");
    $("#contact_name_error").html("");
    $("#email_id_error").html("");
    $("#mobile_no_error").html("");
    $("#gender_error").html("");
    $("#photo_error").html("");

    $("#photo1").css("border","1px solid #CDE0E6");
    $("#photo").css("border","none");
    $("#photo_error").html("");
    $("#photo_error").parent().css("display","none");
    $("#contact_name").css("border","1px solid #CDE0E6");
    $("#contact_name_error").html("");
    $("#contact_name_error").parent().css("display","none");
    $("#email_id").css("border","1px solid #CDE0E6");
    $("#email_id_error").html("");
    $("#email_id_error").parent().css("display","none");
    $("#mobile_no").css("border","1px solid #CDE0E6");
    $("#mobile_no_error").html("");
    $("#mobile_no_error").parent().css("display","none");
    $(".gender .selectBoxCity").css("background","url('/assets/create_new_activity/select_box_bg.png') no-repeat");
    $("#gender_error").html("");
    $("#gender_error").parent().css("display","none");
}

function validateName(elementValue){	
    /*var alphaExp = /^([a-zA-Z]+([ ]{0,1}[a-zA-Z]))+$/;*/
    var alphaExp = /^[a-zA-Z ]*$/;
    return alphaExp.test(elementValue);
}
function validateDot(elementValue) {
    var emailSplitat = elementValue.split("@");
    var emailSplitdotf = emailSplitat[0].split(".");
    var emailSplitdotl = emailSplitat[1].split(".");
  	 
    if(emailSplitat[0].length<4){
        return false;
    }
  	  	
    if(emailSplitdotf.length>3){
        return false;
    }
    if(emailSplitdotf.length<3){
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

function validateCorrectEmail(elementValue){  
    var emailPattern = /^([a-zA-Z0-9]+([~{|}`^?=+*'#$!%._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,3}(?:\.[a-zA-Z]{2,3})?)$/;
    return emailPattern.test(elementValue);
} 

