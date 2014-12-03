function validateForm()
  {
    var name = document.getElementById("name").value;
    //var phone = document.getElementById("phone").value;
    var phone1 = document.getElementById("profile_phone_1").value;
    var phone2 = document.getElementById("profile_phone_2").value;
    var phone3 = document.getElementById("profile_phone_3").value;
    var msg = document.getElementById("msg-area").value;
    var email=document.forms["myForm"]["email"].value;
    var atpos=email.indexOf("@");
    var dotpos=email.lastIndexOf(".");
    var areyou = document.getElementById('areyou').value;
    //alert(areyou);
    $(".inpt").css("margin-top", "0px");
    var errorFlag = false;
    if(name=="" || name == "Eg:john" || name == "eg:john")
    {
      $(".name").css("border-color","#FC8989");
      $("#name_span").css("display","block");
      errorFlag = true;
    
    }else{
    
      $(".name").css("border-color","#CDE0E6");
      $("#name_span").css("display","none");
        
    }
    if (atpos<1 || dotpos<atpos+2 || dotpos+2>=email.length)
    {
      $(".email").css("border-color","#FC8989");
      $("#email_span").show();
      $("#email_empty").hide();
      errorFlag = true;
    
    }
    else if (email =="Eg:john@gmail.com" || email =="eg:john@gmail.com")
     { 
      $(".email").css("border-color","#FC8989");
      $("#email_span").hide();
      $("#email_empty").show();
      errorFlag = true;
    }
    else{
      $(".email").css("border-color","#CDE0E6");
      $("#email_span").hide();
      $("#email_empty").hide();
    
    }
    if ( areyou=="select")	{
	  $(".areyoupp").css("border-color","#FC8989");
          $("#areyoupp_span").css("display","block");
          errorFlag = true;
	} else{
	  $(".areyoupp").css("border-color","#CDE0E6");
          $("#areyoupp_span").css("display","none");
    }
   /* if(phone=='')
    {
      $(".phone").css("border-color","#FC8989");
      $("#phone_span").show();
      errorFlag = true;
    }
    else if(isNaN(phone))
    {
      $(".phone").css("border-color","#FC8989");
      $("#phone_span").show();
      errorFlag = true;
    }
    else{
      $(".phone").css("border-color","#CDE0E6");
      $("#phone_span").hide();
        
    } */
if ( phone1 !="xxx" && phone2 != "xxx" && phone3 != "xxxx"){ 

    if( phone1 !="" ){
          if(phone1.length<3){
            

      $("#profile_phone_1").css("border","1px solid #fc8989");
      $("#phone_span").show();
      $("#phone_empty").hide();
      errorFlag = true;
    }
  }
  
    if( phone2 !="" ){
     if(phone2.length<3){  
     
      $("#profile_phone_2").css("border","1px solid #fc8989");
      $("#phone_span").show();
      $("#phone_empty").hide();
      errorFlag = true;     
    }
  }

    if( phone3 !="" ){
     if(phone3.length<4){ 
    
      $("#profile_phone_3").css("border","1px solid #fc8989");
       $("#phone_span").show();
       $("#phone_empty").hide();
      errorFlag = true;     
    }
  }
     if( phone1 == "000" &&  phone2 == "000" && phone3 == "0000" ){
    
    $("#profile_phone_1").css("border","1px solid #FC8989");
    $("#profile_phone_2").css("border","1px solid #FC8989");  
    $("#profile_phone_3").css("border","1px solid #FC8989");
    $("#phone_span").show();
    $("#phone_empty").hide();
    errorFlag = true;
    }
    else if( phone1 == "" &&  phone2 == "" && phone3 == ""){
   
    $("#profile_phone_1").css("border","1px solid #FC8989");
    $("#profile_phone_2").css("border","1px solid #FC8989");  
    $("#profile_phone_3").css("border","1px solid #FC8989");
    $("#phone_span").show();
    $("#phone_empty").hide();
    errorFlag = true;
    }
    else if((phone1 != "000" &&  phone2 != "000" && phone3 != "0000") && (phone1.length>=3 && phone2.length>=3 && phone3.length>=4) || (phone1 != "000" && phone1.length>=3  &&  phone2 == "000" && phone3 == "0000") ||  (phone2 != "000" && phone2.length>=3  &&  phone1 == "000" && phone3 == "0000") || (phone3 != "0000" && phone3.length>=4  &&  phone1 == "000" && phone2 == "000") || (phone1 != "000" && phone1.length>=3  &&  phone2 == "000" && phone3 != "0000" && phone3.length>=4 ) || (phone2 != "000" && phone2.length>=3  &&  phone1 == "000" && phone3 != "0000" && phone3.length>=4 ) ){

      $("#profile_phone_1").css("border-color","#CDE0E6");
      $("#profile_phone_2").css("border-color","#CDE0E6");
      $("#profile_phone_3").css("border-color","#CDE0E6");
      $("#phone_span").hide();
      $("#phone_empty").hide();
        
    }

}

if(phone1 == "xxx" &&  phone2 == "xxx" && phone3 == "xxxx" ){
  
    $("#profile_phone_1").css("border","1px solid #FC8989");
    $("#profile_phone_2").css("border","1px solid #FC8989");  
    $("#profile_phone_3").css("border","1px solid #FC8989");
    //$('#phone_span').css("display","block");
    //$('#phone_span').html('Please enter your phone number');
    $("#phone_empty").show();
    $("#phone_span").hide();
    errorFlag = true;
       
    }

   if(phone1 != "xxx" &&  phone2 == "xxx" && phone3 == "xxxx") {
  
      $("#profile_phone_2").css("border","1px solid #FC8989");  
      $("#profile_phone_3").css("border","1px solid #FC8989");
      $("#phone_span").show();
      $("#phone_empty").hide();
     }
   else if(phone1 == "xxx" &&  phone2 != "xxx" && phone3 == "xxxx") {
  
      $("#profile_phone_1").css("border","1px solid #FC8989");  
      $("#profile_phone_3").css("border","1px solid #FC8989");
      $("#phone_span").show();
      $("#phone_empty").hide();
        
    }
    else if(phone1 == "xxx" &&  phone2 == "xxx" && phone3 != "xxxx") {
  
      $("#profile_phone_1").css("border","1px solid #FC8989");  
      $("#profile_phone_2").css("border","1px solid #FC8989");
      $("#phone_span").show();
      $("#phone_empty").hide();
        
    }
    else if(phone1 != "xxx" &&  phone2 == "xxx" && phone3 != "xxxx") {
   
      $("#profile_phone_2").css("border","1px solid #FC8989");
      $("#phone_span").show();
      $("#phone_empty").hide();
        
    }
    else if(phone1 != "xxx" &&  phone2 != "xxx" && phone3 == "xxxx") {
  
      $("#profile_phone_3").css("border","1px solid #FC8989");
      $("#phone_span").show();
      $("#phone_empty").hide();
    }
    if(msg=='')
    {
      $(".msg").css("border-color","#FC8989");
      $("#msg_span").show();

      errorFlag = true;
    }
    else{
      $(".msg").css("border-color","#CDE0E6");
      $("#msg_span").hide();
    }
   
    if(errorFlag){
      return false;
    }

    else{
  
      $('#loading_img').show();
      $.ajax({
        type: "Post",
        url: "landing/contact_us_mail",
        data: {
          "msg":msg,
          "name":name,
          "phone1":phone1,
          "phone2":phone2,
          "phone3":phone3,
          "email": email,
          "usertype":areyou
        },
        cache: false,
        success: function(data){
          if (data == "failed"){
            $("#email_id").css("border","1px solid #fc8989");
            $("#email_id_error").html("Please enter valid Email");
            $("#email_id_error").parent().css("display","block");
            errorFlag = true;
          }
          else{
      $('#loading_img').hide();
            errorFlag = false;
      $("#name").val('Eg:john');
      $("#name").css("color","#999999");
      $("#email").val('Eg:john@gmail.com');
      $("#email").css("color","#999999");
      $("#areyou").val('--Select--');
      $("#profile_phone_1").val('xxx');
      $("#profile_phone_1").css("color","#999999");
      $("#profile_phone_2").val('xxx');
      $("#profile_phone_2").css("color","#999999");
      $("#profile_phone_3").val('xxxx');
      $("#profile_phone_3").css("color","#999999");
      $("#msg").val('');
          }

        }
      });
      return false;
    }
  
  }
  
  function number(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57 ) && (charCode != 46 ) ){
        //alert("Allow only Numbers");
        return false;     
    }
    return true;
}
//set automatically go to next textbox
  function movetoNext(current, nextFieldID) {
    if (current.value.length >= current.maxLength) {

      document.getElementById(nextFieldID).focus();
    }
    return true;
  }