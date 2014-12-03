$(document).ready(function() {
	// provider plan Popup
	$('a.plan_down').click(function() {
		
		//Getting the variable's value from a link 
		var planbox = $(this).attr('href');
		//~ var height = $("#page_wrapper").height();
		var height = $(".wrapper_contianer_inner_login").height();
		
		//Fade in the Popup
		$(planbox).fadeIn(300);
		
		//Set the center alignment padding + border see css style
		var popMargTop = ($(planbox).height() + 24) / 2;
		var popMargLeft = ($(planbox).width() + 24) / 2; 
		
		$(planbox).css({ 
			'margin-top' : -popMargTop,
			'margin-left' : -popMargLeft
		});
		
		// Add the mask to body
		$('body').append('<div id="mask"></div>');
		$("#mask").css("display","block");
		$("#mask").css("opacity","0.8");
		$("#mask").css("z-index","9999");
		$("#mask").css("background-color","#fff");
		$('#mask').fadeIn(300);
		$('#mask').css('height',height+'px');
		
		return false;
	});
	
	if (!$.browser.opera) {
	
			$('select.log_select').each(function(){ 
			var title = $(this).attr('title');
			if( $('option:selected', this).val() != ''  ) title = $('option:selected',this).text();
			$(this)
				.css({'z-index':10,'opacity':0,'-khtml-appearance':'none'})
				.after('<span class="log_select">' + title + '</span>')
				.change(function(){
					val = $('option:selected',this).text();
						$(this).next().text(val);
					});
			});

		};
	
		
	
	// Our Merchant Category Popup
	/*$('a.category1,a.category2,a.category3,a.category4,a.category5,a.category6,a.category7,a.category8').click(function() {
		
        //Getting the variable's value from a link 
		var catgBox = $(this).attr('href');
		var height = $(".wrapper").height();
		
		//Fade in the Popup
		$(catgBox).fadeIn(300);
		
		//Set the center alignment padding + border see css style
		var popMargTop = ($(catgBox).height() + 24) / 2;
		var popMargLeft = ($(catgBox).width() + 24) / 2; 
		
		$(catgBox).css({ 
			'margin-top' : -popMargTop,
			'margin-left' : -popMargLeft
		});

		// Add the mask to body
		$('body').append('<div id="mask"></div>');
		$("#mask").css("opacity","0.8"); 
		$('#mask').fadeIn(300);
		$('#mask').css('height',height+'px');
		return false;
	});*/
	
	// When clicking on the button close or the mask layer the popup closed
	$('a.close').live('click', function() { 
	  $('#mask , .plan-popup').fadeOut(300 , function() {
		$('#mask').remove();  
	}); 
	
	return false;
	});
	
	$(".plan-popup .cancel").live('click', function() {
		 $('#mask , .plan-popup').fadeOut(300 , function() {											
		$('#mask').remove();  
	});
		 return false;
	});
	
	$(".invite-popup a.close").live('click', function() {
		resetInvitePopup();
	});
	
	$(".forgot-pass-popup a.close").live('click', function() {
		resetForgetPopup();
	});
	
});

/*function resetLoginPopup(){
	var popUsername = $("#uname");
	var popUnameInfo = $("#user_name");
	var popPassword = $("#pass");
	var popPassInfo = $("#pwd");
	var login = $("#log_as"); 
	var loginInfo = $("#log_sel");

	popUsername.removeClass("error");
	popUnameInfo.text("");
	popUnameInfo.removeClass("error");

	popPassword.removeClass("error");
	popPassInfo.text("");
	popPassInfo.removeClass("error");

	$("#logSel").children().removeClass("error");
	loginInfo.text("");
	loginInfo.removeClass("log_error");

	log_as = "0";
	for(var i=0;i<$("#popup_login #log_as option").length;i++){
		if($("#popup_login #log_as option:eq("+i+")").attr("value") == log_as){
			$("#popup_login #log_as option:eq("+i+")").attr("selected","selected");	
    	}	
    }
	$("#popup_login span.log_select").html("Select");
	$("#popup_login span.log_select").css("color","#999");

	$("#popup_login").attr("action","#");
	$("#popup_login #uname").attr("name","uname");
	$("#popup_login #pass").attr("name","pass");
	$("#popup_login #checkbox").attr("name","checkbox");
	input.checked = 'checked';
	checkChange();
	$("#popup_login #uname").val("Eg: john@gmail.com");
	$("#popup_login #pass").val("Eg:pass");
	$("#popup_login #uname").css("color","#999");
	$("#popup_login #pass").css("color","#999");
}

function resetInvitePopup(){
	var inviteName = $("#name");
	var inviteNameInfo = $("#invite_name");
	var inviteMail = $("#friend_mail");
	var inviteMailInfo = $("#invite_mail");
	var inviteAlter = $("#friend_alter_mail");
	var inviteAlterInfo = $("#invite_alter_mail");
	
	inviteName.removeClass("error");
	inviteName.val("Eg: john");
	inviteName.css("color","#999");
	inviteNameInfo.text("");
	inviteNameInfo.removeClass("error");
	
	inviteMail.removeClass("error");
	inviteMail.val("Eg: john@gmail.com");
	inviteMail.css("color","#999");
	inviteMailInfo.text("");
	inviteMailInfo.removeClass("error");
	$(".mail_plus").css('margin-top','-10px');
	
	inviteAlter.removeClass("error");
	inviteAlterInfo.text("");
	inviteAlterInfo.removeClass("alter_error");
	
	$(".mail_alter").css('display','none');
	//$(".invite_submit").css('margin','44px 0px 0px 303px');
	$(".mail_plus").css('display','block');
	$("#alter_email_exist").val(0);
	
	inviteAlter.removeClass("error");
	inviteAlter.val("Eg: john@gmail.com");
	inviteAlter.css("color","#999");
	inviteAlterInfo.text("");
	inviteAlterInfo.removeClass("alter_error");
	
	$("#invite_comments").val("");
}

function resetForgetPopup(){
	var forgotMail = $("#pass_mail");
	var forgotInfo = $("#forgot_pass");
	
	forgotMail.removeClass("error");
	forgotMail.val("Eg: john@gmail.com");
	forgotMail.css("color","#999");
	forgotInfo.text("");
	forgotInfo.removeClass("error");
}*/