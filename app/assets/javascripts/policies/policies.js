
var StartVal=1;
var endVal=4;
var i;

//change radio button value, content, img
	
	function selectRadioButton(className,id,val){
	
	$('.radioBox input').val(0);
	$('.select').hide();
	$('.not_select').show();
	$('#HeadingDiv_'+id).hide();
		$('#content_'+i).hide();
		

	for(i=StartVal; i<endVal; i++){
		if(i==id){
			$('#HeadingDiv_'+i).show();
			$('#content_'+i).show();
		}
		else{
			$('#HeadingDiv_'+i).hide();
			$('#content_'+i).hide();
		}
	}
	if(className == "select"){
		$('#radio_'+id).val(val);
		$('#'+className+'_'+id).show();	
		$('#not_select_'+id).hide();
		$('#HeadingDiv_'+id).show();
			$('#content_'+i).show();
		var title= $('#terms_'+id).html();
		$('#terms_title').html(title);
		$('new_content_'+id).show();
				var textarea_value = $('#field_'+id).html();
		var p_normal_text = $('#field_'+id).html();
		
		$("#email_error").html("");
		$("#alertText").show();
		//var disp_mode = $("#edit_mode").attr('style');
		var disp_mode =$("#edit_mode").css('display');
		if(disp_mode == "none")
		{
			$("#alertText").show();
		}
		else{
			$("#alertText").hide();
		}
		if(p_normal_text == "") 
		{
			//alert("dya"); 
			//$("#alertText").show();
			//$("#note_change").show();
			//~ $("#btton_change img").attr("src","/assets/policies/add_button.png");
			$("#btton_change").text("Add");
			$('.nicEdit-main').focus();
		}
		else{
			//alert("aaa");
			$("#alertText").hide();
			//$("#note_change").hide();
			//~ $("#btton_change img").attr("src","/assets/register/edit_button.png");
			$("#btton_change").text("Edit");
			$('.nicEdit-main').focus();
		}
		$("#p_type").html(p_normal_text);
				$('.nicEdit-main').html(textarea_value);
	}	

}


	function add_menu(){
		$("#textBox").show();
		$("#clear_menu").show();
		 var title = $('#add_1').val();
		$('#add_1').css("border","1px solid #BDD6DD");
		$('#input_error').parent().css("display","none");
		$('#input_error').hide();
		$('#input_error').html('');
		$('#input_error').parent().css("display","none");
		 var errorFlag = false;
				if(title == ""){
		$('#add_1').css("border","1px solid #fc8989");
		$('#input_error').parent().css("display","block");
		$('#input_error').show();
		$('#input_error').html("please enter the value to add");
				errorFlag = true;
		
		}
	
	 else if(title !=""){
		$('#add_1').css("border","1px solid #BDD6DD");
		$('#input_error').parent().css("display","none");
		$('#input_error').hide();
		$('#input_error').html('');
		$('#input_error').parent().css("display","none");
		addedMenu();
				errorFlag = true;
		
		}
	}

//add menu
function addedMenu()
{

	var value_title=$('#add_1').val();
	$('#terms_'+value).html(value_title);
		var lengthDiv = $('.createDynamicDivs font').length;
	
		if(lengthDiv<11){
			var currentDiv = lengthDiv+4;
			var cDiv = 1;
			var value = currentDiv;
			//count increment
			count=$("#part_count").val();
			count_inc=count+","+value;
			$("#part_count").val(count_inc);
		
	str_menu='<font><div class="radio_Con_lt"><div class="lt radioBox" style="width:30px;"><input type="hidden" name="radio_'+value+'" id="radio_'+value+'" value="0" /><a href="javascript:void(0)" title="" id="select_'+value+'" onclick="selectRadioButton(\'not_select\','+value+',0)" class="select" style="display: none"><img src="/assets/tickets/radio_selected.png" alt=""/></a><a href="javascript:void(0)" title="" id="not_select_'+value+'" onclick="selectRadioButton(\'select\','+value+',1)" class="not_select" ><img src="/assets/tickets/radio_normal.png" alt=""/></a></div><div class="lt terms_text" id="terms_'+value+'">'+value_title+'</div><div class="clear"></div> </div></font>'
		
			$('.createDynamicDivs').append(str_menu);
		
		}
	}

//clear menu
function clear_menu(){
	$("#textBox").hide();
	$("#clear_menu").hide();
	$('#input_error').html('');
	$('#input_error').parent().css("display","none");
}
function Trim(str)
{  while(str.charAt(0) == (" ") )
	{  str = str.substring(1);
	}
	while(str.charAt(str.length-1) == " " )
	{  str = str.substring(0,str.length-1);
	}
	return str;
}
function policies_validation(){
	//alert("test");
	$('#email_error').html('');
	$('#email_error').parent().css("display","none");
	$('.nicEdit-main').focus();
	var text_value = $('.nicEdit-main').html();
	text_value = text_value.replace(/^\s+|\s+$/g, "");
	var nicE = new nicEditors.findEditor('content').getContent();
	str=nicE.replace(/[\t \n &nbsp;]+/g, "");
	str1=str.replace(/[\t \n &nbsp; <r>]+/g, "");
	str2=str1.replace('<r>','');	
	var edit_box_value = $.trim(text_value);	
	var errorFlag=false;	
	if(Trim(str1)=='')
	{
		var nicE = new nicEditors.findEditor('content').setContent('');
		$("#email_error").html("please edit properly");
		$("#email_error").parent().css("display","block");
		$('.nicEdit-main').focus();
		errorFlag = true;
	}
	if(edit_box_value == "" || edit_box_value == "<br>" || edit_box_value == " " || edit_box_value == "&nbsp;"){
			$("#email_error").html("please enter the text");
			$("#email_error").parent().css("display","block");
			$('.nicEdit-main').focus();
			errorFlag = true;
	}

	
if(errorFlag){
			return false;
		}
		else{
			return true;
		}

}

//cancel edit mode
function cancel_error(){
	$("#normal_mode").show();
	$("#edit_mode").hide();
	var source= $("#btton_change img").attr("src");
	if(source == "/assets/policies/add_button.png"){
		 $("#alertText").show();
	}
	else{
		 $("#alertText").hide();
	}
	return false;
}

	$(document).ready(function(){
 
 $("#all_checkbox_normal").click(function(){
	 $("#all_checkbox_normal").hide();
	 $("#all_checkbox_selected").show();
	 $('.downl_checkbox_normal').hide();
	 $('.downl_checkbox_selected').show();
	 $('input.f_downl_checkbox').val(1);
	 check_box_joinval();
});


 $("#all_checkbox_selected").click(function(){
	 $("#all_checkbox_selected").hide();
	 $("#all_checkbox_normal").show();
	 $('.downl_checkbox_selected').hide();
	 $('.downl_checkbox_normal').show();
	 $('input.f_downl_checkbox').val(0);
	 $("#test").val('');
});
	
	 $(".downl_checkbox_normal").click(function(){
		var test = this.id;
		var val = $("#"+test).attr('data');
		$('#downl_checkbox_normal_'+val).css('display','none');
		$('#downl_checkbox_selected_'+val).css('display','inline-block');
		$('#f_downl_checkbox_'+val).val(1);
		check_box_joinval();
	 });
	 
	$(".downl_checkbox_selected").click(function(){
		var test = this.id;
		var val = $("#"+test).attr('data');
		$('#all_checkbox_selected').css('display','none');
		$('#all_checkbox_normal').css('display','inline-block');
		$('#downl_checkbox_selected_'+val).css('display','none');
		$('#downl_checkbox_normal_'+val).css('display','inline-block');
		$('#f_downl_checkbox_'+val).val(0);
		check_box_joinval();
	 });
			 
 function check_box_joinval(){
		var input_val='';
		var input_id ='';
		var joinStr1 ='';
		var length=$('input.f_downl_checkbox').length;
		for(var i=1;i<=length;i++)
		{
				input_val = $('#f_downl_checkbox_'+i).val();
				if(input_val!=0){
						input_id = $('#f_downl_'+i).val();
						if(input_id!=undefined){
						  joinStr1 += input_id+",";
						}
				}
		}
		
		$('#test').val(joinStr1);
 }

 function downvalue() {
  var t_val = $("#test").val();
  var act_id = $("#acti_id").val();
  var r_val=t_val.replace(/undefined,undefined,/, '');
  var errorFlag = true;
    if (t_val.length==0)
    {
    errorFlag = false;
    }
      if (errorFlag == false)
      {
        //$("#up-down-pop").hide();
        //$("#checkboxImg").hide();
        $('#error-msg').fadeIn().delay(4000).fadeOut();
        //$("#error-msg").show();
        $("#send_zip").attr("href", "javascript:void(0)");
      }
      else
      {
        $("#send_zip").attr("href", "/multi_download?val="+r_val+"&id="+act_id);
      }
  }
 
/* $("#send_zip").click(function(){
	var t_val = $("#test").val();
	var act_id = $("#acti_id").val();
	var r_val=t_val.replace(/,undefined,undefined,/, '');
	var errorFlag = true;
		if (t_val.length==0)
		{
		errorFlag = false;
		}
			if (errorFlag == false)
			{
				$("#up-down-pop").hide();
				$("#checkboxImg").hide();
				$("#error-msg").show();
				$("#send_zip").attr("href", "javascript:void(0)");
			}
			else
			{
				$("#send_zip").attr("href", "/multi_download?val="+r_val+"&id="+act_id);
			}
}); */

});


