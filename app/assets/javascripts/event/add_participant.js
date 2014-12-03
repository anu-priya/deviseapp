// checkbox click func
function dispCheckParticipant(imgName,incval){
    var index = participant_val.indexOf(incval);
    if(imgName == 'checkbox_selected_participant'){
        $('#checkbox_selected_participant_'+incval).css('display','none');
        $('#checkbox_normal_participant_'+incval).css('display','inline-block');
        $("#db_part_static_"+incval).val('');       
    }
    else if(imgName == 'checkbox_normal_participant'){	    	
        $('#checkbox_normal_participant_'+incval).css('display','none');
        $('#checkbox_selected_participant_'+incval).css('display','inline-block');
        var setVal = $("#db_part_"+incval).val();
        $("#db_part_static_"+incval).val(","+setVal);
    }

    if (index == -1){
        participant_val.push(incval);
        $("#db_part_count").val(participant_val);
    }
    else{
        participant_val.splice(index, 1);
        $('#db_part_count').val(participant_val);
    }    
}

// dislayed participant image
function readURL_dy(input,value) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            $('#filediv_'+value).hide();
            $('#imagediv_'+value).show();
            $('#blah_'+value)
            .attr('src', e.target.result)
            .width(65)
            .height(65);
        };
        reader.readAsDataURL(input.files[0]);
    }
}
//  automatic click the input(file)
function selectFile(incVal){
    $('#photo_'+incVal).click();
}
//  added new participant
var str='';
var msg='';
var count_inc = 0;
function addedDiv(){	   
    var lengthDiv = $('.createDynamicDivs font').length;
    
    var lengthTable = $('.createDynamicDivs font table').length;	
		
    if(lengthTable<10){
        var currentDiv = lengthDiv+1;
        var value = currentDiv;	
        //count increment
        count=$("#part_count").val();
        count_inc=count+","+value;
				
        $("#part_count").val(count_inc);
		
        str = '<font class="participant_'+value+'"><table cellspacing="0" cellspadding="0" border="0" width="100%"><tr><td colspan="5" class="errorDiv" id="errorDiv_'+value+'" style="display:none;"></td></tr><tr height="90"><td width="70" class="tdata tdata1"><span class="lt" style="width:24px;">&nbsp;</span><span class="browse" id="filediv_'+value+'"><a href="javascript:void(0)" onClick="selectFile('+value+')" class="lt"><img src="/assets/create_new_activity/browse_image.png" width="65" height="67" /></a></span><input type="file" onchange="readURL_dy(this,'+value+');" size="21" id="photo_'+value+'" name="photo_'+value+'" value=""  style="display:none"/><div id="imagediv_'+value+'" class="browse1" style="display:none;"><a href="javascript:void(0)" onClick="selectFile('+value+')" class="lt"><img id="blah_'+value+'" src="" alt="" /></a></div><div class="clear"></div></td><td width="160" class="tdata"><input type="text" id="participant_name_'+value+'" name="participant_name_'+value+'" class="lt textbox" value=""/></td><!--td width="155" class="tdata setIEcen"><input type="hidden" id="day_'+value+'" name="day_'+value+'" value="" /><div id="menu" class="lt dayDivMenu"><ul><li><a href="javascript:void(0)" class="dayDiv"><span id="day_setVal_'+value+'">Day</span><span><img src="/assets/event_index/dropdown_arrow.png" alt="" style="position:relative;top:-1px;left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispDayDiv"><li><a href="javascript:void(0)" onclick="setDayVal(01,'+value+')">1</a></li><li><a href="javascript:void(0)" onclick="setDayVal(02,'+value+')">2</a></li><li><a href="javascript:void(0)" onclick="setDayVal(03,'+value+')">3</a></li><li><a href="javascript:void(0)" onclick="setDayVal(04,'+value+')">4</a></li><li><a href="javascript:void(0)" onclick="setDayVal(05,'+value+')">5</a></li><li><a href="javascript:void(0)" onclick="setDayVal(06,'+value+')">6</a></li><li><a href="javascript:void(0)" onclick="setDayVal(07,'+value+')">7</a></li><li><a href="javascript:void(0)" onclick="setDayVal(08,'+value+')">8</a></li><li><a href="javascript:void(0)" onclick="setDayVal(09,'+value+')">9</a></li><li><a href="javascript:void(0)" onclick="setDayVal(10,'+value+')">10</a></li><li><a href="javascript:void(0)" onclick="setDayVal(11,'+value+')">11</a></li><li><a href="javascript:void(0)" onclick="setDayVal(12,'+value+')">12</a></li><li><a href="javascript:void(0)" onclick="setDayVal(13,'+value+')">13</a></li><li><a href="javascript:void(0)" onclick="setDayVal(14,'+value+')">14</a></li><li><a href="javascript:void(0)" onclick="setDayVal(15,'+value+')">15</a></li><li><a href="javascript:void(0)" onclick="setDayVal(16,'+value+')">16</a></li><li><a href="javascript:void(0)" onclick="setDayVal(17,'+value+')">17</a></li><li><a href="javascript:void(0)" onclick="setDayVal(18,'+value+')">18</a></li><li><a href="javascript:void(0)" onclick="setDayVal(19,'+value+')">19</a></li><li><a href="javascript:void(0)" onclick="setDayVal(20,'+value+')">20</a></li><li><a href="javascript:void(0)" onclick="setDayVal(21,'+value+')">21</a></li><li><a href="javascript:void(0)" onclick="setDayVal(22,'+value+')">22</a></li><li><a href="javascript:void(0)" onclick="setDayVal(23,'+value+')">23</a></li><li><a href="javascript:void(0)" onclick="setDayVal(24,'+value+')">24</a></li><li><a href="javascript:void(0)" onclick="setDayVal(25,'+value+')">25</a></li><li><a href="javascript:void(0)" onclick="setDayVal(26,'+value+')">26</a></li><li><a href="javascript:void(0)" onclick="setDayVal(27,'+value+')">27</a></li><li><a href="javascript:void(0)" onclick="setDayVal(28,'+value+')">28</a></li><li><a href="javascript:void(0)" onclick="setDayVal(29,'+value+')">29</a></li><li><a href="javascript:void(0)" onclick="setDayVal(30,'+value+')">30</a></li><li><a href="javascript:void(0)" onclick="setDayVal(31,'+value+')">31</a></li></ul></li></ul><div class="clear"></div></div><input type="hidden" id="month_'+value+'" name="month_'+value+'" value="" /><div id="menu" class="lt monthDivMenu"><ul><li><a href="javascript:void(0)" class="monthDiv"><span id="month_setVal_'+value+'">Month</span><span><img  src="/assets/event_index/dropdown_arrow.png" alt="" style=" position: relative; top: -1px; left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispMonthDiv"><li><a href="javascript:void(0)" onclick="setMonthVal(\'Jan\' , \''+value+'\')">January</a></li><li><a href="javascript:void(0)" onclick="setMonthVal(\'Feb\' , \''+value+'\')">February</a></li><li><a href="javascript:void(0)" onclick="setMonthVal(\'Mar\' , \''+value+'\')">March</a></li><li><a href="javascript:void(0)" onclick="setMonthVal(\'Apr\' , \''+value+'\')">April</a></li><li><a href="javascript:void(0)" onclick="setMonthVal(\'May\' , \''+value+'\')">May</a></li><li><a href="javascript:void(0)" onclick="setMonthVal(\'Jun\' , \''+value+'\')">June</a></li><li><a href="javascript:void(0)" onclick="setMonthVal(\'Jul\' , \''+value+'\')">July</a></li><li><a href="javascript:void(0)" onclick="setMonthVal(\'Aug\' , \''+value+'\')">August</a></li><li><a href="javascript:void(0)" onclick="setMonthVal(\'Sep\' , \''+value+'\')">September</a></li><li><a href="javascript:void(0)" onclick="setMonthVal(\'Oct\' , \''+value+'\')">October</a></li><li><a href="javascript:void(0)" onclick="setMonthVal(\'Nov\' , \''+value+'\')">November</a></li><li><a href="javascript:void(0)" onclick="setMonthVal(\'Dec\' , \''+value+'\')">December</a></li></ul></li></ul><div class="clear"></div></div><input type="hidden" id="year_'+value+'" name="year_'+value+'" value="" /><div id="menu" class="lt yearDivMenu"><ul><li><a href="javascript:void(0)" class="yearDiv"><span id="year_setVal_'+value+'">Year</span><span><img src="/assets/event_index/dropdown_arrow.png" alt="" style=" position: relative; top: -1px; left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispYearDiv" id="yearDisp_'+value+'"></ul></li></ul><div class="clear"></div></div></td--><td width="81" class="tdata setIEcen"><input type="hidden" id="age_'+value+'" name="age_'+value+'" value="" /><div id="menu" class="lt ageDivMenu"><ul><li><a href="javascript:void(0)" class="ageDiv"><span id="age_setVal_'+value+'">Select</span><span><img src="/assets/event_index/dropdown_arrow.png" alt="" style=" position: relative; top: -1px; left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispAgeDiv"><li><a href="javascript:void(0)" onclick="setAgeVal(\'1-3\' , \''+value+'\')">1-3</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'4-6\' , \''+value+'\')">4-6</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'7-9\' , \''+value+'\')">7-9</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'10-12\' , \''+value+'\')">10-12</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'13-15\' , \''+value+'\')">13-15</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'16-18\' , \''+value+'\')">16-18</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'Adults\' , \''+value+'\')">Adults</a></li>	</ul></li></ul><div class="clear"></div></div></td><td width="67" class="tdata setIEcen"><input type="hidden" id="gender_'+value+'" name="gender_'+value+'" value="" /><div id="menu" class="lt genderDivMenu"><ul><li><a href="javascript:void(0)" class="ageDiv genderDiv"><span id="gender_setVal_'+value+'">Select</span><span><img src="/assets/event_index/dropdown_arrow.png" alt="" style=" position: relative; top: -1px; left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispGenderDiv"><li><a href="javascript:void(0)" onclick="setGenderVal(\'Male\' , \''+value+'\')">Male</a></li><li><a href="javascript:void(0)" onclick="setGenderVal(\'Female\' , \''+value+'\')">Female</a></li></ul></li></ul><div class="clear"></div></div></td><td width="48" class="tdata">&nbsp;<span id="action_del_'+value+'" class="action_del"><a href="javascript:void(0)" titile="" class="lt" onclick="deleteTable('+value+')"><img src="/assets/provider_event_list/delete_icon.png" width="29" height="26" alt="" /></a></span></td></tr></table></font>';
        
        $('.createDynamicDivs').append(str);
	$("#action").show();	
        hideDeleteIcon();
    }
    else{
	     $("#db_fields_added_error").css('display','block');
	     $("#db_fields_added_error").html('Allow maximum 10 new pariticipants');
    }
    // mouse over / mouse out - menu top highlighted
    $(function(){
        $('.dispAgeDiv li a').hover(function (){
            $(this).parent().parent().parent("li").children('a:first').addClass('selectedAgeDiv');
        }, function(){
            $(this).parent().parent().parent("li").children('a:first').removeClass('selectedAgeDiv');
        });
    });
    $(function(){
        $('.dispGenderDiv li a').hover(function (){
            $(this).parent().parent().parent("li").children('a:first').addClass('selectedGenderDiv');
        }, function(){
            $(this).parent().parent().parent("li").children('a:first').removeClass('selectedGenderDiv');
        });
    });
    $(function(){
        $('.dispScheduleDiv li a').hover(function (){
            $(this).parent().parent().parent("li").children('a:first').addClass('selectedScheduleDiv');
        }, function(){
            $(this).parent().parent().parent("li").children('a:first').removeClass('selectedScheduleDiv');
        });
    });
}
// hide delete icon func
function hideDeleteIcon(){
    // new participant
    var count_first=$("#part_count").val();
    var countSplitFirst = count_first.split(",");

    var lengthTable = $('.createDynamicDivs font table').length;	
	
    // exist participant
    /*var db_count_first=$("#db_part_count").val();
    var db_count_first_len = db_count_first.length;*/

   var dbLengthTable = $('.db_participant').length;	
	
    if(lengthTable>0){	
	    if(dbLengthTable<1){
		$("#action_del_"+countSplitFirst[1]).hide();
	    }
	    else{
		$('.action_del').show();
		$("#action").show();
	    }
    }
}
// validation
function checkValidation(){
    var lengthDiv = $('.createDynamicDivs font').length;
    validateArr = new Array();
    var setVal = "";
    var setFlagPart = 1;
	
    if( lengthDiv == 0 ){
        addedDiv();
    }
    else{
        var incDiv = lengthDiv;
        var cDiv = 1;
        var msg='';
        for(var i=cDiv;i<=incDiv;i++){
	       
            var participant_name = $('#participant_name_'+i).val();
            var age = $('#age_'+i).val();
            var gender = $('#gender_'+i).val();
		      
/*            if(participant_name == ''){
                msg+='enter participant name, ';
            }
*/			 

			if((participant_name == '' || age == '' || gender == '') && (participant_name == '' || age == '' || gender != '') && (participant_name == '' || age != '' || gender == ''))
			{
				msg+='enter participant name,';
			}
			
			if(participant_name != '' && age == '' && gender == '') 
			{
				if(msg=="enter participant name,"){
					msg="";
				}
				msg+='';
			}

			if(participant_name == '' && age != '' && gender != '') {
               
				if(msg=="enter participant name,"){
					msg="";
					msg+='enter participant name';
				 }
				 else{
					 msg+='';
				 }

            }
			if((age == '' || participant_name == '' || gender == '') && (participant_name == '' || age == '' || gender != '') && (participant_name != '' || age == '' || gender == '') ){
				msg+='select age,';
			}
			if(age != '' && participant_name == '' && gender == '') 
			{
				if(msg=="enter participant name,select age,"){
					msg="enter participant name,";
				}
				msg+='';
			}
			if(age == '' && participant_name != '' && gender != '') {
				if(msg=="select age,"){
					msg="";
					msg+='select age';
				 }
				 else{
					 msg+='';
				 }

            }
			
			if(age == '' && participant_name == '' && gender != '') {
				if(msg=="enter participant name,select age,"){
					msg="";
					msg+='enter participant name,select age';
				 }
				 else{
					 msg+='';
				 }

            }
			

/*            if(age == ''){
                if(msg!=''){
                    msg+='';
                }
                else{
                    msg+='select age, ';
                }
            }
*/            if(gender == ''){
                if(msg!=''){
                    msg+='gender ';
                }
                else{
                    msg+='select gender ';
                }
            }
            var msg1='Please ';

            if(msg!=''){
                $('#errorDiv_'+i).show();
                $('#errorDiv_'+i).html(msg1+msg);
		setVal = "f";
		validateArr.push(setVal);
            }
	    else{
		 $('#errorDiv_'+i).hide();
                $('#errorDiv_'+i).html("");
	    }

        }
	for(var i=0;i<=validateArr.length;i++){
		if(validateArr[i]=="f"){			
			setFlagPart = 2;
		}		  
	}
	if(setFlagPart==1){
		addedDiv();
	}
	else{
		return false;
	}
		
    }
    
}
// age value set to input box
function setAgeVal(agevalue,inc){
    $('#age_'+inc).val(agevalue);
    $('#age_setVal_'+inc).html(agevalue);
}
// gender value set to input box
function setGenderVal(gvalue,inc){
    $('#gender_'+inc).val(gvalue);
    $('#gender_setVal_'+inc).html(gvalue);
}

function raja(){
    var sub_category = $('#sub_category_apf').val();
    $.ajax({
        url: "/checkout/add_participant_success",
        data: "city="+sub_category,
        method:"POST",
        cache: false,
        success: function(data){
        }
    });

}
// deleted the new particpant list
function deleteTable(incVal){
	$("#db_fields_added_error").css('display','none');
	$("#db_fields_added_error").html('');
	
    var count=$("#part_count").val();
    var countSplit = count.split(",");
    var countlength = countSplit.length;
    var countLess = countSplit.length-1;
	
    /*var count1=$("#db_part_count").val();
    var countSplit1 = count1.split(",");
    var countLess1 = countSplit1.length-1;*/
   var dbLengthTable = $('.db_participant').length;
	
		
    if(countLess < 3 ){
        var remove_count2=$("#part_count").val();
        var removeVal2 = '';
        var r_count2 ='';
        for(var i=0;i<countSplit.length;i++){
            if(countSplit[i]==incVal){
                removeVal2 = ","+incVal;
                r_count2=remove_count2.replace(removeVal2,"");
                $("#part_count").val(r_count2);
            }
        }
        $('.participant_'+incVal).html('');

        if(dbLengthTable>0){
            for(var i=0;i<countSplit.length;i++){
                if(countSplit[i]==incVal){
                    removeVal2 = ","+incVal;
                    r_count2=remove_count2.replace(removeVal2,"");
                    $("#part_count").val(r_count2);
                }
            }
            $('.participant_'+incVal).html('');
	    $("#action").hide();
        }
        else{
            var count_first=$("#part_count").val();
            var countSplitFirst = count_first.split(",");
            $("#action_del_"+countSplitFirst[1]).hide();
	    $("#action").hide();
        }
    }
    else{
        var remove_count2=$("#part_count").val();
        var removeVal2 = '';
        var r_count2 ='';
        for(var i=0;i<countSplit.length;i++){
            if(countSplit[i]==incVal){
                removeVal2 = ","+incVal;
                r_count2=remove_count2.replace(removeVal2,"");
                $("#part_count").val(r_count2);
            }
        }
        $('.participant_'+incVal).html('');
		
    }
	
}
// participant cancel button func
function show_price(){
	$(".paymentDuration input").css('border','1px solid #CDE0E6');
	$("#scheduleActError").hide();
	$("#scheduleActError").html("");
	
	$("#add_partic_change").hide();
	 $("#guest_get_details").hide();
	$("#schedule_price_show").show();
	$("#parti_schedu_change").html('Schedule &amp; Price Details');
}
// proceed to checkout  cancel button func
function show_participant_back(){
	var guest_val = $("#guest_check").val();
	$("#db_fields_added_error").css('display','none');
	$("#db_fields_added_error").html('');
	$('.createDynamicDivs .errorDiv').css('display','none');      
      
	
	$("#checkout #check_out_total").hide();
	if (guest_val=='true'){
		$("#guest_get_details").css('display','block');
	}
	$("#add_partic_change").show();
	$("#parti_schedu_change").html('Add Participant');
}
// pay-checkout cancel button func
function show_proceed_checkout(){	
	$("#checkout_provider").hide();
	$("#check_out_total").show();
	$("#parti_schedu_change").html('Proceed to checkout');
}
// rotate next tap
function autotab(id1,id2){ 
	var firstVal = $("#"+id1).val(); 
	var firstValLength = firstVal.length; 
	
	if(firstValLength>3){ 
		$("#"+id2).focus();
	}
}
// checkbox Terms and Conditions
function dispCheckAgree(imgName){
    $("#checkbox_error_agree").css("display","none");	
    if(imgName == 'checkbox_selected_agree'){
        $('#checkbox_selected_agree').css('display','none');
        $('#checkbox_normal_agree').css('display','inline-block');
        $("#agree").val('');       
    }
    else if(imgName == 'checkbox_normal_agree'){	    	
        $('#checkbox_normal_agree').css('display','none');
        $('#checkbox_selected_agree').css('display','inline-block');        
        $("#agree").val(1);
    }    
}
// validate number
function validateNumber(elementValue){
    var alphaExp = /^[0-9]+$/;
    return alphaExp.test(elementValue);
}
// allow numbers
function isNumberKey(evt,id){ 
	var charCode = (evt.which) ? evt.which : event.keyCode;
	if ( charCode > 31 && (charCode < 48 || charCode > 57) && (charCode < 96 || charCode > 105) )
		return false;	
	return true;
}

// allow numbers and dot
/*function isNumberKey(evt){
          var charCode = (evt.which) ? evt.which : event.keyCode;
          if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57))
             return false;

          return true;
}*/