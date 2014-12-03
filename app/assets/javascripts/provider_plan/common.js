/***************************/
/** Shopper Registration Form Validation */				 
/***************************/

$(document).ready(function(){
	
	
	//global vars
	//var letter = /^[a-zA-Z]*$/;
	var checkName = /^[a-z A-Z]*$/;
	//var numeric = /^[0-9]*$/;
	//var alphaNumeric = /^[a-zA-Z0-9]*$/;
	//var email = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
	var email = new RegExp(/^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$/i);
	
	var loginPopup = $("#popup_login");
	var forgotPassPopup = $("#forgot_pass_popup");
	var invitePopup = $("#invite_login");
	var shopperLogin = $("#shop_login");
	var merchantLogin = $("#merchant_login");
	var contact = $("#contact");
	
	//LoginPopup Variables
	var popUsername = $("#uname");
	var popUnameInfo = $("#user_name");
	var popPassword = $("#pass");
	var popPassInfo = $("#pwd");
	//var login = $("#log_as"); 
	var loginInfo = $("#log_sel");

	loginPopup.submit(function(){
		if(validateUser() & validatePass() & validateLogUser() ){
			var result = null;
			
			var log_as = $("#popup_login #log_as option:selected").val();

			switch(log_as){
				case "Shopper":
						emailOfMember = $("#popup_login #uname").val();
						passwordOfMemberEmail = $("#popup_login #pass").val();

						url = "emailOfMember="+emailOfMember+"&passwordOfMemberEmail="+passwordOfMemberEmail;

						$.ajax({
							  url: path+"/checkShopperLogin",
							  data: url,
							  cache: false,
							  async:false,
							  success: function(data){
								  if(data.status=="1"){
									  $("#popup_login #pwd").html("");
									  $("#popup_login #pwd").removeClass("error");
									  result = true;
								  }
								  else{
									  $("#popup_login #pwd").html("Invalid Email/password");
									  $("#popup_login #pwd").addClass("error");
									  result = false;
								  }
							  }
						});
					break;
				case "Merchant":
						merchantEmail = $("#popup_login #uname").val();
						passwordOfMerchantEmail = $("#popup_login #pass").val();	
				
						url = "merchantEmail="+merchantEmail+"&passwordOfMerchantEmail="+passwordOfMerchantEmail;
				
						$.ajax({
							  url: path+"/checkMerchantLogin",
							  data: url,
							  cache: false,
							  async:false,
							  success: function(data){
								  if(data.status=="1"){
									  $("#popup_login #pwd").html("");
									  $("#popup_login #pwd").removeClass("error");
									  result = true;
								  }
								  else{
									  $("#popup_login #pwd").html("Invalid Email/password");
									  $("#popup_login #pwd").addClass("error");
									  result = false;
								  }
							  }
						});
					break;
			}
			
			return result;
		}	
		else{
			return false;
		}	
	});

	function validateUser(){ 
		//if it's NOT valid
		if(popUsername.val() == "Eg: john@gmail.com") {
			popUsername.addClass("error");
			popUnameInfo.text("Please enter your Email");
			popUnameInfo.addClass("error");
			return false;
		}

		/*else if(!alphaNumeric.test(popUsername.val())){
			popUsername.addClass("error");
			popUnameInfo.text("Please enter only alpha numeric chars!");
			popUnameInfo.addClass("error");
			return false;
		}*/
		
		else if(!email.test(popUsername.val())){
			popUsername.addClass("error");
			popUnameInfo.text("Please enter valid Email");
			popUnameInfo.addClass("error");
			return false;
		}
		
		//if it's valid
		else{ 
			popUsername.removeClass("error");
			popUnameInfo.text("");
			popUnameInfo.removeClass("error");
			return true;
		}
	}
	
	function validatePass() {
		if(popPassword.val() == "Eg:pass") {
			popPassword.addClass("error");
			popPassInfo.text("Please enter your password");
			popPassInfo.addClass("error");
			return false;
		}
		else if(popPassword.val().length < 7) {
			popPassword.addClass("error");
			popPassInfo.text("Invalid Email/password");
			popPassInfo.addClass("error");
			return false;
		}
		else {
			popPassword.removeClass("error");
			popPassInfo.text("");
			popPassInfo.removeClass("error");
			return true;
		}
	}
	
	function validateLogUser() { 
		if($("#log_as option:selected").val() == 0) {
			$("#logSel").children().addClass("error");
			loginInfo.text("Please select login usertype");
			loginInfo.addClass("log_error");
			$(".popup_check").css('.margin','15px 0px 0px 128px');
			return false;
		}
		else { 
			$("#logSel").children().removeClass("error");
			loginInfo.text("");
			loginInfo.removeClass("log_error");
			return true;
		}
	}
	
	
	/*login.change(function() {
		if(login.val() != 0) {
			$("#logSel").children().removeClass("error");
			loginInfo.text("");
			loginInfo.removeClass("log_error");
			return true;
		}
		else {
			$("#logSel").children().addClass("error");
			loginInfo.text("please select login usertype");
			loginInfo.addClass("log_error");
			return false;
		}
	});*/
	
	
	
	//Forgot Password popup Variables
	
	
	var forgotMail = $("#pass_mail");
	var forgotInfo = $("#forgot_pass");
	var user = "";
		
	forgotPassPopup.submit(function(){  
		var userDet = document.getElementsByName("forget_user");
		for(var x=0;x < userDet.length;x++) {
			if(userDet[x].checked) {
				user = userDet[x].value;
			}
		}
		if(validateForgotPass())
			return true;
		else
			return false;
	});
	
	function validateForgotPass() { 
		if(forgotMail.val() == "Eg: john@gmail.com") {
			forgotMail.addClass("error");
			forgotInfo.text("Please enter your Email");
			forgotInfo.addClass("error");
			return false;
		}
		else if(!email.test(forgotMail.val())){
			forgotMail.addClass("error");
			forgotInfo.text("Please enter valid Email");
			forgotInfo.addClass("error");
			return false;
		}
		//if it's NOT valid
		else{
			$('.login-popup').css('display','none');
		//Getting the variable's value from a link 
		var passConfBox = $(".password_forgot").attr('action');
		var height = $(".wrapper").height();
		//Fade in the Popup
		$(passConfBox).fadeIn(300);
		
		//Set the center alignment padding + border see css style
		var popMargTop = ($(passConfBox).height() + 24) / 2;
		var popMargLeft = ($(passConfBox).width() + 24) / 2; 
		
		$(passConfBox).css({ 
			'margin-top' : -popMargTop,
			'margin-left' : -popMargLeft
		});
		
		// Add the mask to body
		$('body').append('<div id="mask"></div>');
		$("#mask").css("opacity","0.8");
		$('#mask').fadeIn(300);
		$('#mask').css('height',height+'px');
		return false;
		}
	}
	
	
	//Invite Friends Popup Variables
	var inviteName = $("#name");
	var inviteNameInfo = $("#invite_name");
	var inviteMail = $("#friend_mail");
	var inviteMailInfo = $("#invite_mail");
	var inviteAlter = $("#friend_alter_mail");
	var inviteAlterInfo = $("#invite_alter_mail");

	
	invitePopup.submit(function(){
		/*if(validateInviteName() & (validateInviteMail() | validateInviteAlter()))
			return true;
		else 
			return false;
		*/
		var alter_email_exist = $("#alter_email_exist").val();
		
		if(alter_email_exist == 1){
			if(validateInviteName() & validateInviteMail() & validateInviteAlter()){
				
				friendName = inviteName.val();
				friendEmail = inviteMail.val();	
				friendAlternativeEmail = $("#friend_alter_mail").length != 0 ? $("#friend_alter_mail").val() : "";
				if(friendAlternativeEmail == "Eg: john@gmail.com"){
					friendAlternativeEmail = "";
				}
				comments = $("#invite_comments").val();
					
				url = "friendName="+friendName+"&friendEmail="+friendEmail+"&friendAlternativeEmail="+friendAlternativeEmail+"&comments="+comments; 
					
				$.ajax({
					  url: path+"/inviteYourFriends",
					  data: url,
					  cache: false,
					  success: function(data){
						  if(data.status=="1"){
							  resetInvitePopup();
							  $('#mask , .login-popup').fadeOut(300 , function() {
									$('#mask').remove();  
								});
						  }
					  }
				});
				
				//return true;
			}	
			else{ 
				return false;
			}
		}
		
		if(alter_email_exist == 0){
			if(validateInviteName() & validateInviteMail()){
				
				friendName = inviteName.val();
				friendEmail = inviteMail.val();	
				friendAlternativeEmail = $("#friend_alter_mail").length != 0 ? $("#friend_alter_mail").val() : "";
				if(friendAlternativeEmail == "Eg: john@gmail.com"){
					friendAlternativeEmail = "";
				}
				comments = $("#invite_comments").val();
					
				url = "friendName="+friendName+"&friendEmail="+friendEmail+"&friendAlternativeEmail="+friendAlternativeEmail+"&comments="+comments; 
				
				$.ajax({
					  url: path+"/inviteYourFriends",
					  data: url,
					  cache: false,
					  async:false,
					  success: function(data){
						  if(data.status=="1"){
							  resetInvitePopup();
							  $('#mask , .login-popup').fadeOut(300 , function() {
									$('#mask').remove();  
								});
						  }
					  }
				});
				
				//return true;
			}	
			else{ 
				return false;
			}
		}
	});
	
	function validateInviteName() {
		if(inviteName.val() == "Eg: john") {
			inviteName.addClass("error");
			inviteNameInfo.text("Please enter your friend name");
			inviteNameInfo.addClass("error");
			return false;
		}
		else if(!checkName.test(inviteName.val())){
			inviteName.addClass("error");
			inviteNameInfo.text("Please enter only letters!");
			inviteNameInfo.addClass("error");
			return false;
		}
		//if it's valid
		else{ 
			inviteName.removeClass("error");
			inviteNameInfo.text("");
			inviteNameInfo.removeClass("error");
			return true;
		}		
	}
	
	function validateInviteMail() {
		if(inviteMail.val() == "Eg: john@gmail.com") {
			inviteMail.addClass("error");
			inviteMailInfo.text("Please enter your friend Email");
			inviteMailInfo.addClass("error");
			$(".mail_plus").css('margin-top','-32px');
			return false;
		}
		else if(!email.test(inviteMail.val())){
			inviteMail.addClass("error");
			inviteMailInfo.text("Please enter valid Email");
			inviteMailInfo.addClass("error");
			$(".mail_plus").css('margin-top','-32px');
			return false;
		}
		//if it's NOT valid
		else{
			inviteMail.removeClass("error");
			inviteMailInfo.text("");
			inviteMailInfo.removeClass("error");
			$(".mail_plus").css('margin-top','-10px');
			return true;
		}
	}
	
	function validateInviteAlter() {
		if(inviteAlter.val() == "Eg: john@gmail.com") {
			inviteAlter.addClass("error");
			inviteAlterInfo.text("Please enter your friend Email");
			inviteAlterInfo.addClass("alter_error");
			return false;
		}
		else if(!email.test(inviteAlter.val())){
			inviteAlter.addClass("error");
			inviteAlterInfo.text("Please enter valid Email");
			inviteAlterInfo.addClass("alter_error");
			return false;
		}
		else if(inviteAlter.val() == inviteMail.val()) {  
			inviteAlter.addClass("error");
			inviteAlterInfo.text("The Email is same as above, please invite a new friend.");
			inviteAlterInfo.addClass("alter_error");
			return false;
		}
		//if it's NOT valid
		else{
			inviteAlter.removeClass("error");
			inviteAlterInfo.text("");
			inviteAlterInfo.removeClass("alter_error");
			return true;
		}
	}
	
	
	//Shopper Login Variables
	var shopUser = $("#shop_username");
	var shopUserInfo = $("#shop_user");
	var shopPass = $("#shop_password");
	var shopPassInfo = $("#shop_pass");
	
	shopperLogin.submit(function(){
		if(validateShopUser() & validateShopPass()){
			var result = null;
		
			emailOfMember = $("#shop_username").val();
			passwordOfMemberEmail = $("#shop_password").val();	
	
			url = "emailOfMember="+emailOfMember+"&passwordOfMemberEmail="+passwordOfMemberEmail;
	
			$.ajax({
				  url: path+"/checkShopperLogin",
				  data: url,
				  cache: false,
				  async:false,
				  success: function(data){
					  if(data.status=="1"){
						  $("#shop_pass").html("");
						  $("#shop_pass").removeClass("error");
						  result = true;
					  }
					  else{
						  $("#shop_pass").html("Invalid Email/password");
						  $("#shop_pass").addClass("error");
						  result = false;
					  }
				  }
			});
	
			return result;
		}	
		else{ 
			return false;
		}	
	}); 
	

	function validateShopUser(){ 
		//if it's NOT valid
		if(shopUser.val() == "Eg: john@gmail.com") {
			shopUser.addClass("error");
			shopUserInfo.text("Please enter your Email");
			shopUserInfo.addClass("error");
			return false;
		}

		/*else if(!alphaNumeric.test(shopUser.val())){ 
			shopUser.addClass("error");
			shopUserInfo.text("Please enter only alpha numeric chars!");
			shopUserInfo.addClass("error");
			return false;
		}*/
		
		else if(!email.test(shopUser.val())){
			shopUser.addClass("error");
			shopUserInfo.text("Please enter valid Email");
			shopUserInfo.addClass("error");
			return false;
		}
		
		//if it's valid
		else{ 
			shopUser.removeClass("error");
			shopUserInfo.text("");
			shopUserInfo.removeClass("error");
			return true;
		}
	}
	
	function validateShopPass() {
		if(shopPass.val() == "Eg:pass") {
			shopPass.addClass("error");
			shopPassInfo.text("Please enter your password");
			shopPassInfo.addClass("error");
			return false;
		}
		else if(shopPass.val().length < 7) {
			shopPass.addClass("error");
			shopPassInfo.text("Invalid Email/password");
			shopPassInfo.addClass("error");
			return false;
		}
		else {
			shopPass.removeClass("error");
			shopPassInfo.text("");
			shopPassInfo.removeClass("error");
			return true;
		}
	}
	
	
	//Merchant Login Variables
	var merchantUser = $("#merchant_username");
	var merchantUserInfo = $("#merchant_user");
	var merchantPass = $("#merchant_password");
	var merchantPassInfo = $("#merchant_pass");
	
	
	merchantLogin.submit(function(){
		if(validatemerchantUser() & validatemerchantPass()){
			var result = null;
			
			merchantEmail = $("#merchant_username").val();
			passwordOfMerchantEmail = $("#merchant_password").val();	
	
			url = "merchantEmail="+merchantEmail+"&passwordOfMerchantEmail="+passwordOfMerchantEmail;
	
			$.ajax({
				  url: path+"/checkMerchantLogin",
				  data: url,
				  cache: false,
				  async:false,
				  success: function(data){
					  if(data.status=="1"){
						  $("#merchant_pass").html("");
						  $("#merchant_pass").removeClass("error");
						  result = true;
					  }
					  else{
						  $("#merchant_pass").html("Invalid Email/password");
						  $("#merchant_pass").addClass("error");
						  result = false;
					  }
				  }
			});

			return result;
		}	
		else{ 
			return false;
		}	
	}); 
	

	function validatemerchantUser(){ 
		//if it's NOT valid
		if(merchantUser.val() == "Eg: john@gmail.com") {
			merchantUser.addClass("error");
			merchantUserInfo.text("Please enter your Email");
			merchantUserInfo.addClass("error");
			return false;
		}
		
		else if(!email.test(merchantUser.val())){
			merchantUser.addClass("error");
			merchantUserInfo.text("Please enter valid Email");
			merchantUserInfo.addClass("error");
			return false;
		}
		
		//if it's valid
		else{ 
			merchantUser.removeClass("error");
			merchantUserInfo.text("");
			merchantUserInfo.removeClass("error");
			return true;
		}
	}
	
	function validatemerchantPass() {
		if(merchantPass.val() == "Eg:pass") {
			merchantPass.addClass("error");
			merchantPassInfo.text("Please enter your password");
			merchantPassInfo.addClass("error");
			return false;
		}
		else if(merchantPass.val().length < 7) {
			merchantPass.addClass("error");
			merchantPassInfo.text("Invalid Email/password");
			merchantPassInfo.addClass("error");
			return false;
		}
		else {
			merchantPass.removeClass("error");
			merchantPassInfo.text("");
			merchantPassInfo.removeClass("error");
			return true;
		}
	}
	
	
	//Contact Form Variables 
	var name = $("#name");
	var nameInfo = $("#contact_name");
	var contactMail = $("#email");
	var contactMailInfo = $("#contact_email");
    var relatedComents = $("#relatedTo");
    var relatedComentsInfo = $("#related_comment");
    //var country = $("#country");
	var countryInfo = $("#contact_country");
	var phone = $("#phone_num");
	var phoneInfo = $("#contact_phone");
	
	contact.submit(function(){
		if(validateContactName() & validateContactMail() /*& validateRelatedComment()*/ & validateCountry() & validatePhone()) {
			contactName = $("#name").val();
			contactEmail = $("#email").val();
			contactCountry = $("#country").val();
			countryCode = $("#country_code").val();
			phoneNumber = $("#phone_num").val();
			contactPhoneNumber = countryCode + phoneNumber;
			contactComments = $("#comments").val();
			
			var contConfBox = $(this).attr('action');
			
			$.ajax({
				  url: path+"/contactUsSubmit",
				  data: "contactName="+contactName+"&contactEmail="+contactEmail+"&contactCountry="+contactCountry+"&contactPhoneNumber="+contactPhoneNumber+"&contactComments="+contactComments,
				  cache: false,
				  success: function(data){
					  if(data.status=="0"){
						  alert(data.message);
					  }
					  else{
						//Getting the variable's value from a link 
						//var contConfBox = $(this).attr('action');
						var height = $(".wrapper").height();
						
						//Fade in the Popup
						$(contConfBox).fadeIn(300);
						
						//Set the center alignment padding + border see css style
						var popMargTop = ($(contConfBox).height() + 24) / 2;
						var popMargLeft = ($(contConfBox).width() + 24) / 2; 
						
						$(contConfBox).css({ 
							'margin-top' : -popMargTop,
							'margin-left' : -popMargLeft
						});
						
						// Add the mask to body
						$('body').append('<div id="mask"></div>');
						$("#mask").css("opacity","0.8");
						$('#mask').fadeIn(300);
						$('#mask').css('height',height+'px');
					  }
				  }
				});
			return false;
		}
		else
			return false;
	});
	
	function validateContactName() {
		if(name.val() == "Eg: john") {
			name.addClass("error");
			nameInfo.text("Please enter your name");
			nameInfo.addClass("error");
			return false;
		}
		else if(!checkName.test(name.val())){
			name.addClass("error");
			nameInfo.text("Please enter only letters!");
			nameInfo.addClass("error");
			return false;
		}
		//if it's valid
		else{ 
			name.removeClass("error");
			nameInfo.text("");
			nameInfo.removeClass("error");
			return true;
		}		
	}
	
	function validateContactMail() {
		if(contactMail.val() == "Eg: john@gmail.com") {
			contactMail.addClass("error");
			contactMailInfo.text("Please enter your Email");
			contactMailInfo.addClass("error");
			return false;
		}
		else if(!email.test(contactMail.val())){
			contactMail.addClass("error");
			contactMailInfo.text("Please enter valid email");
			contactMailInfo.addClass("error");
			return false;
		}
		//if it's NOT valid
		else{
			contactMail.removeClass("error");
			contactMailInfo.text("");
			contactMailInfo.removeClass("error");
			return true;
		}
	}
    
    function validateRelatedComment() {
        if(relatedComents.val() == 0) {
            $("#relSelect").children().addClass("error");
            relatedComentsInfo.text("Please select a related comments");
            relatedComentsInfo.addClass("error");
            return false;
        }
        else {
            $("#relSelect").children().removeClass("error");
            relatedComentsInfo.text("");
            relatedComentsInfo.removeClass("error"); 
            return true;
        }
    }
	
	function validateCountry() {
		if($("#country option:selected").val() == 0) {  
			$("#conSelect").children().addClass("error");
			countryInfo.text("Please select your country");
			countryInfo.addClass("error");
			return false;
		}
		else { 
			$("#conSelect").children().removeClass("error");
			countryInfo.text("");
			countryInfo.removeClass("error");
			return true;
		}
	}
	
	function validatePhone() {
		if( (phone.val() == "Eg: 0123456789") || (isNaN(phone.val())||phone.val().indexOf(" ")!=-1) || (phone.val().charAt(0)!=0) || (phone.val().length < 10) ) {
       // if((phone.val() == "Eg: 0123456789")) ||  (isNaN(phone.val())||phone.val().indexOf(" ")!=-1) || (phone.val().charAt(0)!="0") || (phone.val().length < 10)) {
			phone.addClass("phone_error");
			phoneInfo.text("Please enter 10 digit mobile number start with 0");
			phoneInfo.addClass("error");
			return false;		
		}
		//if it's valid
		else{ 
			phone.removeClass("phone_error");
			phoneInfo.text("");
			phoneInfo.removeClass("error");
			return true;
		}
	}
	
	
	//Validate Loyal Popup Form
	var loyalForm = $("#loyal_addmore");
	var loyalShort = $("#loyalShort_desc");
	var loyalShortInfo = $("#loyalShort_desc");
	
	loyalForm.submit(function(){
		if( validateLoyalShort() ) 
			return true;
		else
			return false;
		
		function validateLoyalShort() {
			if(loyalShort.val=="") {
				loyalShort.addClass("error");
				loyalShortInfo.addClass("error");
				loyalShortInfo.text("Please enter offer short description");
			}
		}
	});
});
	