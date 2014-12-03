//user account deactivate
function deactivate_account(){
$('#deactivate_account_feature').bPopup({
	fadeSpeed:100,
	followSpeed:100,
	opacity:0.8,
	positionStyle: 'fixed',
	modalClose: false,
	});
}

//user account activate popup for deactivate users by rajkumar
function activate_account(){
    $('#activate_account_feature').bPopup({
        fadeSpeed:100,
        followSpeed:100,
        opacity:0.8,
        positionStyle: 'fixed',
        modalClose: false,
    });
}

//user account delete popup calling
function delete_account(){
	$('#delete_account_feature').bPopup({
	fadeSpeed:100,
	followSpeed:100,
	opacity:0.8,
	positionStyle: 'fixed',
	modalClose: false,
	});
}
//user delete ajax calling 
function user_delete_call()
{
var user_id = $('#user_id_delete').val();
    $('#loading_img_delete').css("display","inline-block");
    $.post("/user_account_delete", {"user_id":user_id}, null, "script");
    return false;
}
//once updated the user information destory user session
function user_destroy_call()
{
$('#user_deleted').hide();
$('#delete_account_feature').hide();
window.location.href="/logout"
}
//use deactivate mail
function user_deactivate_call(){
var user_id = $('#user_id_delete').val();
    $('#loading_img_deact').css("display","inline-block");
    $.post("/user_account_deactivate", {"user_id":user_id,"user_status":"deactivate"}, null, "script");
    return false;
}
