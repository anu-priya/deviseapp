//this function called when u submit the form in provider setting page.
//~ $(document).ready(function() {
function submitpassword(){
      var current_password= $("#current_password").val();
      var new_password= $("#new_pass").val();
      var confirm_password = $("#confirm_pass").val();
      var pwd = $("#pwd").val();

      $("#current_password").css("border","1px solid #d4d4d4");
      $("#new_pass").css("border","1px solid #d4d4d4");
      $("#confirm_pass").css("border","1px solid #d4d4d4");

      $("#current_password_error").html("");
      $("#new_pass_error").html("");
      $("#confirm_password_error").html("");

      $("#current_password_error").parent().css("display","none");
      $("#new_pass_error").parent().css("display","none")
      $("#confirm_password_error").parent().css("display","none");


      var errorFlag = false;

      $("#current_password").css("border","1px solid #d4d4d4");
      $("#current_password_error").html("");
      $("#current_password_error").parent().css("display","none");
      $("#new_pass").css("border","1px solid #d4d4d4");
      $("#new_pass_error").html("");
      $("#new_pass_error").parent().css("display","none");
      $("#confirm_pass").css("border","1px solid #d4d4d4");
      $("#confirm_password_error").html("");
      $("#confirm_password_error").parent().css("display","none");

      current_password = current_password.replace(/^\s+|\s+$/g, "");
      if(current_password == ""  || current_password =="password"){
        $("#current_password").css("border","1px solid #fc8989");
        $("#current_password_error").html("Please enter current password");
        $("#current_password_error").parent().css("display","block");
        errorFlag = true;
      }
      else if(current_password != pwd ){
        $("#current_password").css("border","1px solid #fc8989");
        $("#current_password_error").html("Please enter your correct current password");
        $("#current_password_error").parent().css("display","block");
        errorFlag = true;
      }

      new_password = new_password.replace(/^\s+|\s+$/g, "");
      if(new_password == "" || new_password == "password"){
        $("#new_pass").css("border","1px solid #fc8989");
        $("#new_pass_error").html("Please enter new password");
        $("#new_pass_error").parent().css("display","block");
        errorFlag = true;
      }
      else if(new_password.length<8){
        $("#new_pass").css("border","1px solid #fc8989");
        $("#new_pass_error").html("Must Have At least 8 Characters");
        $("#new_pass_error").parent().css("display","block");
        errorFlag = true;
      }
      else if(new_password == current_password){
        $("#new_pass").css("border","1px solid #fc8989");
        $("#new_pass_error").html("Your new password should be different");
        $("#new_pass_error").parent().css("display","block");
        errorFlag = true;
      }
      confirm_password = confirm_password.replace(/^\s+|\s+$/g, "");
      if(confirm_password == "" || confirm_password == "password"){
        $("#confirm_pass").css("border","1px solid #fc8989");
        $("#confirm_password_error").html("Please enter confirm password");
        $("#confirm_password_error").parent().css("display","block");
        errorFlag = true;
      }
      else if(confirm_password != new_password){
        $("#confirm_pass").css("border","1px solid #fc8989");
        $("#confirm_password_error").html("Please enter the correct confirm new password");
        $("#confirm_password_error").parent().css("display","block");
        errorFlag = true;
      }

      if(errorFlag){
        return false;
      }
      else{
       $.post("/update_userpassword", $("#change_password_form").serialize(), function(){	  
		$("#current_password").val('');
		$("#new_pass").val('');
		$("#confirm_pass").val('');
		//$("#pwd").val('');
}, "script");
	   
       return false;
      }
    }
  
     /*clear fields*/

  function clearpasswordfields(){
	  $("#current_password").val('');
	  $("#new_pass").val('');
	  $("#confirm_pass").val('');
      //$("#pwd").val('');
    $("#current_password").css("border","1px solid #d4d4d4");
    $("#new_pass").css("border","1px solid #d4d4d4");
    $("#confirm_pass").css("border","1px solid #d4d4d4");

    $("#current_password_error").html("");
    $("#new_pass_error").html("");

    $("#confirm_password_error").html("");

    $("#current_password_error").parent().css("display","none");
    $("#new_pass_error").parent().css("display","none")
    $("#confirm_password_error").parent().css("display","none");
    $('.success_update_info').css('display', 'none');
  }

//hide and reload the change password form
function reload(){
$('#cge_pwd_cfm').hide();
parent.location.reload(true);
}