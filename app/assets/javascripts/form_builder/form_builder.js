//form validation 
function Trim(str)
{  while(str.charAt(0) == (" ") )
  {  str = str.substring(1);
  }
  while(str.charAt(str.length-1) == " " )
  {  str = str.substring(0,str.length-1);
  }
  return str;
}
function frmTitle() {	 
	 	var name = $("#frmtitle").val();
		if(name=="Enter name for the form" || Trim(name)==''){
			$("#frmtitle").css("border","1px solid #fc8989");
			document.getElementById("errorName").innerHTML = "Please enter form name";
			$("#frmtitle").focus();
			$("#errorName").show();
			formheight();
			return false;
		}else $("#frmtitle").css("border","1px solid #CDE0E6"); return true;
}
function desc() {	 
	 	var desc= $("#frmdesc").val();
		if(desc=="Enter the description" || Trim(desc)==''){
		    $("#frmdesc").css("border","1px solid #fc8989");
			document.getElementById("errorDesc").innerHTML = "Please enter form description";
			$("#frmdesc").focus();
			$("#errorDesc").show();
			formheight();
			return false;
		}else $("#frmdesc").css("border","1px solid #CDE0E6"); return true;
}
function fieldName() {	 
	 	var fldname= $("#fieldname").val();
		if(fldname=="Enter Field Name" || Trim(fldname)==''){
			 $("#fieldname").css("border","1px solid #fc8989");
			document.getElementById("erroField").innerHTML = "Please enter field name";
			$("#fieldname").focus();
			$("#erroField").show();
			formheight();
			return false;
		}else $("#fieldname").css("border","1px solid #CDE0E6"); return true;
}
function helpTxt() {	 
	 	var helptxt= $("#helptxt").val();
		if(Trim(helptxt)==""){
			 $("#helptxt").css("border","1px solid #fc8989");
			 document.getElementById("errorHelptxt").innerHTML = "Please enter helpt text";
			 $("#helptxt").focus();
			 $("#errorHelptxt").show();
			 formheight();
			return false;
		}else $("#helptxt").css("border","1px solid #CDE0E6"); return true;
}
function fieldType() {	 
	 	var fldtype= $("#fieldtype").val();
		if(Trim(fldtype)==""){
			$("#fieldtype").css("border","1px solid #fc8989");
		    document.getElementById("errorType").innerHTML="Please select field type";
			$("#fieldtype").focus();
			$("#errorType").show();
			formheight();
			return false;
		}else  $("#fieldtype").css("border","1px solid #CDE0E6");  return true;
}
function noofftype() {	 
	 	var nofftype= $("#nooffiledtype").val();
		if(nofftype=="Eg:2"){
		   $("#nooffiledtype").css("border","1px solid #fc8989");
		   document.getElementById("errorNooftype").innerHTML = "Please enter no";
		   $("#nooffiledtype").focus();
		   $("#errorNooftype").show();
		   formheight();
		   return false;
		}else $("#nooffiledtype").css("border","1px solid #CDE0E6"); return true;
}
function frmfields() {
		var nofftype= $("#nooffiledtype").val();
		if(nofftype=="Eg:2"){
		  $("#nooffiledtype").css("border","1px solid #fc8989");
		  document.getElementById("errorNooftype").innerHTML = "Please enter no";
		  $("#nooffiledtype").focus();
		  $("#errorNooftype").show();
		  formheight();
		  return false;
		}else $("#nooffiledtype").css("border","1px solid #CDE0E6"); return true;
	
}
function frmfields() {
		var nofftype= $("#frm_field").val();
		if(nofftype==""){
		  $("#frm_field").css("border","1px solid #fc8989");
		 // document.getElementById("errorNooftype").innerHTML = "Please enter no";
		  $("#frm_field").focus();
		  formheight();
		  return false;
		}else $("#frm_field").css("border","1px solid #CDE0E6"); return true;
	
}
//form validation end
$(document).ready(function() {
	$("#fieldtype").change(function(){			
		var e = document.getElementById("fieldtype");
		var str_type = e.options[e.selectedIndex].value;		
		if(str_type!='')
		{
			type_split=str_type.split('|');
			type_val=type_split[1].toLowerCase();
			if(type_val=="textbox" || type_val=="paragraph" ){
				$("#fieldtype").css('color','#000000');
				$("input#nooffiledtype").attr('disabled','disabled');
				$("input#nooffiledtype").val('');
				 $("#nooffiledtype").css("border","1px solid #CDE0E6");
				$("#errorNooftype").hide();
				$('#changeField').empty();
			}
			else { 					
				$("#fieldtype").css('color','#000000');
				$("input#nooffiledtype").removeAttr('disabled','');
				$("input#nooffiledtype").css('color','#9e9e9e');
				$("input#nooffiledtype").val('Eg:2');
				$('#changeField').empty();						
			}	
		}
		else
		{
			$("#fieldtype").css('color','#000000');
			$("input#nooffiledtype").attr('disabled','disabled');
			$("input#nooffiledtype").val('');
			$("#nooffiledtype").css("border","1px solid #CDE0E6");
			$("#errorNooftype").hide();
			$('#changeField').empty();	
		}
	});
		$("#nooffiledtype").keyup(function() { 
			var e = document.getElementById("fieldtype");
			var str_type = e.options[e.selectedIndex].value;			
			if(str_type!='')
			{
				type_split=str_type.split("|");
				type_val=type_split[1].toLowerCase();				
				if(type_val=="radio"){
					$('#changeField').empty();
					var textValue = $("#nooffiledtype").val();
					var msg = '';
					for(i=1; i<=textValue; i++){
						msg += "\n <div class='radiobutton_wrapper mTop10'><input type='radio' name='radio[]' /><span class='radioTxt'><input type='text' id='frm_field' class='inputField' name='option_value[]'  style='color:#000000;'/></span></div>";
					}
					$("#changeField").prepend(msg);
				}else if(type_val=="checkbox"){
					$('#changeField').empty();
					var textValue = $(this).val();
					var msg = '';
					for(i=1; i<=textValue; i++){
						msg += "\n <div class='checkbox_wrapper'><input type='checkbox'  name='check[]'/><span class='radioTxt'><input type='text' id='frm_field' class='inputField' name='option_value[]' style='color:#000000;' /></span></div>";
					}
					$("#changeField").prepend(msg);
				}else if(type_val=="list"){
					$('#changeField').empty();
					var textValue = $(this).val();
					var msg = '';
					for(i=1; i<=textValue; i++){
						msg += "\n <div class='listBox'><span class='listTxt'>"+i+"</span><span class='chooselistTxt'><input type='text' class='chooseinputField' id='frm_field' name='option_value[]'  style='color:#000000;' /></span></div>";
					}
					$("#changeField").prepend(msg);
				}else {
					$("#fieldtype").css('color','#000000');
					$("input#nooffiledtype").attr('disabled','disabled');
					$("input#nooffiledtype").val('');
					$("#nooffiledtype").css("border","1px solid #CDE0E6");
					$("#errorNooftype").hide();
					$('#changeField').empty();
				}
			}
		});		
	
});
//dynamic add field validation
function validoption()
{
	var tbflase=true;
	var tbtrue=true;
	var i=0;
	 $('#changeField div input[type=text]').each(function(){
	       if (Trim(this.value) == "") {
			$('#changeField div input[type=text]:eq('+i+')').css('border','1px solid red');	
			this.value='';		       
		       //textBox=true;
		       tbflase=false;
	       } 
	       else
	       {
		       $('#changeField div input[type=text]:eq('+i+')').css('border','1px solid #CDE0E6');
		       tbtrue=true;
	       }
	       i = i+1;
       });
       if(tbflase)
       {
	       return true;
       }
       else
       {
	       return false;
       }
    
}
function checkForm(){
	 $(".error").hide();
	  if(frmfields() & noofftype() & fieldType() & fieldName()  & desc() & frmTitle() & validoption()){	
		$.get($("#frmadd").attr('action'), $("#frmadd").serialize(), null, "script");
		//if question id exit don't add the add count
		if($('#editquestion_id').val()=='')
		{
			add_count=$('#add_count').val();
			if(add_count!='')
			{  acount = parseInt(add_count)+1;
			}else { acount=1; }
			$('#add_count').val(acount);  
			$('#preview_link').show();
		}
		clear_add_field();
		formheight();
		return false;
	  }else{ 
		return false;
		formheight();
	}
	
}	

function formheight(){
	var detailheight=$('#event_index_container').height();
	parent.$('.drag-contentarea').css('height', (detailheight+40)+'px');

}
//after click the add clear the form field
function clear_add_field()
{
	$("#fieldname").val('Enter Field Name');
	$("#fieldname").css('color','#9e9e9e');
	$("#helptxt").val('');
	$("#fieldtype").val('');	
	$('#editquestion_id').val('');
	$("#option_id").val('');
	$("#fieldtype").css('color','#9e9e9e');
	$("input#nooffiledtype").attr('disabled','disabled');
	$("input#nooffiledtype").val('');
	 $("#nooffiledtype").css("border","1px solid #CDE0E6");
	$("#errorNooftype").hide();
	$('#changeField').empty();
	$('#chkrequired').val('0').removeAttr('checked');
	
}
//required field onchange set value
function chkvalidate(ch)
{
	if(ch)
	{ $('#chkrequired').val('1'); 	}
	else{$('#chkrequired').val('0');
	}	
}
//Edit question field in add form
function edit_field(qid)
{
	$.ajax({
            url:'/edit_field_option',
            type:"post",
            data: "questionid="+qid,
            success:function(data){
            }
          });
}
//Delete question in add form
function delete_field(qid,rowid)
{
	$.ajax({
            url:'/delete_question',
            type:"post",
            data: "questionid="+qid,
            success:function(data){	
		$('#'+rowid).remove();		
		add_count=$('#add_count').val();
		if(add_count!='')
		{  			
			acount = parseInt(add_count)-1;
			if(acount > 0)
			{
				$('#norecord').hide();
				$('#preview_link').show();
			}else{ $('#preview_link').hide();  $('#norecord').show(); }
		}
		$('#add_count').val(acount);  
		clear_add_field();		
            }
          });
}
//save form 
function save_form_builder()
{
	var error_flag=true;
	formid=$('#form_id').val();
	add_count=$('#add_count').val();
	if(formid=='')
	{
		$(".error").hide();
		if(frmfields() & noofftype() & fieldType() & fieldName()  & desc() & frmTitle() & validoption()){
			error_flag=true;
		}		
	}	
	else{
		error_flag=false;
	}
	if(add_count <= 0)
	{
		var detailheight=$('#event_index_container').height();
		parent.$('.drag-contentarea').css('height', (detailheight+15)+'px');
		error_flag=true;
		$('#error_form').show();
		$('#error_form').html('Please add atleast one field');
	}
	else
	{
		$('#error_form').html('');
		error_flag=false;
	}
	if(error_flag)
	{
		return false;
	}
	else
	{	
		//if they change anything in tilte and desc update to form
		title=$('#frmtitle').val();
		desc=$('#frmdesc').val();
		fid=$('#form_id').val();
		document.frm.action='/save_form_question?formid='+fid+'&title='+encodeURI(title)+'&desc='+encodeURI(desc);
		document.frm.submit();
		//document.location.href='/save_form_question?formid='+$('#form_id').val();
		return true;
	}	
}
//edit form builder validate
function edit_form_builder()
{
	var error_flag=true;
	formid=$('#form_id').val();
	add_count=$('#add_count').val();
	if(formid=='')
	{
		$(".error").hide();
		if(frmfields() & noofftype() & fieldType() & fieldName()  & desc() & frmTitle() & validoption()){	
			error_flag=true;
		}		
	}	
	else{
		error_flag=false;
	}	
	if(add_count <= 0)
	{
		error_flag=true;
		$('#error_form').show();
		$('#error_form').html('Please add atleast one field');
	}
	else
	{
		$('#error_form').html('');
		error_flag=false;
	}	
	if(error_flag)
	{
		return false;
	}
	else
	{
		//if they change anything in tilte and desc update to form
		title=$('#frmtitle').val();
		desc=$('#frmdesc').val();
		fid=$('#form_id').val();
		document.frm.action='/edit_form_question?formid='+fid+'&title='+encodeURI(title)+'&desc='+encodeURI(desc);
		document.frm.submit();
		//document.location.href='/save_form_question?formid='+$('#form_id').val();
		return true;
	}	
}
//close button click and cancel button click

//preview the form
function call_form_preview()
{
	//document.location.href='/form_preview?formid='+$('#form_id').val();
	popup_preview_form('/form_preview?formid='+$('#form_id').val());
}
