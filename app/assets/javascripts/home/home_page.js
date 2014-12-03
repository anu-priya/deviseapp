

   /*GUEST ROLE*/
         //guest feature bpopup displayed
	function guest_feature(act,act_schd,form_present)
	{ 
	var activity_id=act;
	var act_sched_id=act_schd;
    	 $(".guest_radio").removeClass("role_selected").addClass("role_nt_selected");
	 $("#guest_error").css("display","none");
	 $("#guest_error").html("");
	if(form_present && form_present=='true')
	{
	$("#form_display").css("display","block");
	}
	else{
	$("#form_display").css("display","none");
	}
	//~ var before_login_value=beforelogin;
	$('#guest_use_feature').bPopup({
		fadeSpeed:100,
		followSpeed:100,
		opacity:0.8,
		positionStyle: 'absolute',
		modalClose: false
	},
	function(){
		$( "#guestFeature" ).click(function(){
		var chk_radio = $(".role_selected").attr("id");
			if(chk_radio==undefined){
				$("#guest_error").css("display","block");
				$("#guest_error").html("select atleast one value.");
				return false;
			}
			else{
			        $("#guestFeature").addClass("b-close");
				var select_id = chk_radio.split('_')[2];
				if(select_id==1)
				{
					pop_Login('/login?activity_id='+activity_id);
				}
				else if(select_id==2)
				{
				show_pop_up(30); 
				pop_Parent_Login('/parent_register');
					//~ //window.location.href="/parent_register";
				}
				else if(select_id==3)
				{
					parent.pop_add_participant('/activities/add_participant?activity_id='+act+'&activity_schedule_id='+act_schd+'&guest_register=true');
				}
				
			}
		}); 
	}
	)
	} 
	
 function role_select(val){
 $(".guest_radio").removeClass("role_selected").addClass("role_nt_selected");
   $("#guest_radio_"+val).removeClass("role_nt_selected").addClass("role_selected");
 }

//Guest Login from Email
 	function guest_login(){
		$('#guest_login_fm').bPopup({
		fadeSpeed:100,
		followSpeed:100,
		opacity:0.8,
		positionStyle: 'absolute',
		modalClose: false
		},
		function(){
		$("#guest_lgn_sub").click(function(){
		$("#auto_loading").css("display","block");
		var username_usr_reg = $("#username_usr_reg").val();
		var email_usr_reg = $("#email_usr_reg").val();
		var password_usr_reg = $("#password_usr_reg").val();
		var confirm_usr_reg = $("#confirm_password_usr").val();
		var news_let_city = $("#news_let_city").val();
		var  errorFlag = false;
	      $("#guest_pwd_error").html("");
              $("#guest_confirm_pwd_error").html("");
	      $("#password_usr_reg").css("border","1px solid #BDD6DD");
              $("#confirm_password_usr").css("border","1px solid #BDD6DD");
			
		if (password_usr_reg == ""){
                $("#password_usr_reg").css("border","1px solid #fc8989");
                $("#guest_pwd_error").html("Please enter your password");
                $("#guest_pwd_error").parent().css("display","block");
		$("#guest_login_fm").css("height","250px");
	        $("#password_usr_reg").css("margin-top","5px");
	        $("#confirm_password_usr").css("margin-top","5px");
                errorFlag = true;
              }
              else if(password_usr_reg.length<8){
                $("#password_usr_reg").css("border","1px solid #fc8989");
                $("#guest_pwd_error").html("Please enter a password with a minimum of 8 characters");
                $("#guest_pwd_error").parent().css("display","block");
		$("#guest_login_fm").css("height","250px");
	        $("#password_usr_reg").css("margin-top","5px");
	        $("#confirm_password_usr").css("margin-top","5px");
                errorFlag = true;
              }

              if(confirm_usr_reg== "") {
                $("#confirm_password_usr").css("border","1px solid #fc8989");
                $("#guest_confirm_pwd_error").html("Please confirm your password");
                $("#guest_confirm_pwd_error").parent().css("display","block");
		$("#guest_login_fm").css("height","250px");
	       $("#password_usr_reg").css("margin-top","5px");
	       $("#confirm_password_usr").css("margin-top","5px");
                errorFlag = true;
              }

              if(confirm_usr_reg != password_usr_reg){
                $("#confirm_password_usr").css("border","1px solid #fc8989");
                $("#guest_confirm_pwd_error").html("The passwords do not match. Please enter them again");
                $("#guest_confirm_pwd_error").parent().css("display","block");
		$("#guest_login_fm").css("height","250px");
	       $("#password_usr_reg").css("margin-top","5px");
	       $("#confirm_password_usr").css("margin-top","5px");
                errorFlag = true;
              }
	      if (errorFlag==true){
	      $("#auto_loading").css("display","none");
	      return false;
	      }
	      else{
				 $.ajax({
				  url:"/user_submit",
				  type:"post",
				  dataType:"json",
				  data:{
				    "username_usr":username_usr_reg,
				    "password_usr_reg":password_usr_reg,
				    "news_let_city":news_let_city,
				    "guest_user":'true',
				    "email_usr":email_usr_reg
				},
				success:function(data){
					if(data=='success'){
					window.location.href="/?gst_activate=true";
					}
				}
				});
				
				//~ $.post('/user_submit', {
				    //~ "username_usr":username_usr_reg,
				    //~ "password_usr_reg":password_usr_reg,
				    //~ "guest_user":'true',
				    //~ "news_let_city":news_let_city,
				    //~ "email_usr":email_usr_reg
				//~ }, null, "script");
				
		}		
			});
  
		}
		)
	}