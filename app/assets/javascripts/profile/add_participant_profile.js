     var curTime = new Date();
    var cdate = curTime.getDate();
    var ccmonth = curTime.getMonth();
    var cyear = curTime.getFullYear();
    ccmonth = parseInt(ccmonth) + 1;

    var weekday = new Array(7);
    weekday[0] = "Sun";
    weekday[1] = "Mon";
    weekday[2] = "Tue";
    weekday[3] = "Wed";
    weekday[4] = "Thu";
    weekday[5] = "Fri";
    weekday[6] = "Sat";
    var cday = curTime.getDay();
    var incval = parseInt(cday) + 1;
      var dayname = weekday[cday];
    
    var monthNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];    
    var cmonth = monthNames[curTime.getMonth()];

    var cuday = dayname + ", " + cmonth + " " + cdate + ", " + cyear;
    var date_value = cyear + "-" + ccmonth + "-" + cdate;
$(document).ready(function(){

    
  //  dispYear(1);
    clearPartiValue();
});

function setyearParti(val1,val2){
    //alert(val1);
   // alert(val2);

   //var disp_pos=$("#year_setVal_'+val2'").val();
   //var disp_pos = $('#year_setVal_'+val2).val();
   //alert(disp_pos);
    $('#year_'+val2).val(val1);
    $('#year_setVal_'+val2).html(val1);
   

}

/*$(function(){
    $('.dispDayDiv li a').hover(function (){
        $(this).parent().parent().parent("li").children('a:first').addClass('selectedDayDiv');
    }, function(){
        $(this).parent().parent().parent("li").children('a:first').removeClass('selectedDayDiv');
    });
});
$(function(){
    $('.dispMonthDiv li a').hover(function (){
        $(this).parent().parent().parent("li").children('a:first').addClass('selectedMonthDiv');
    }, function(){
        $(this).parent().parent().parent("li").children('a:first').removeClass('selectedMonthDiv');
    });
});
$(function(){
    $('.dispYearDiv li a').hover(function (){
        $(this).parent().parent().parent("li").children('a:first').addClass('selectedYearDiv');
    }, function(){
        $(this).parent().parent().parent("li").children('a:first').removeClass('selectedYearDiv');
    });
});
*/$(function(){
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
    $('.scheduleDivMenu .dispScheduleDiv li a').hover(function (){
        $(this).parent().parent().parent("li").children('a:first').addClass('selectedScheduleDiv');
    }, function(){
        $(this).parent().parent().parent("li").children('a:first').removeClass('selectedScheduleDiv');
    });
});

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

var str='';
var msg='';
function addedDiv(){
    
    //$('#actionTitle').css('display','inline-block');
    var lengthDiv = $('.createDynamicDivs font table').length;
    //alert("lengthDiv");
    var length = $('.createDynamicDivs font').length;   
    //alert(length);
    if(length==0){
        
        d = $("#txt_count").val();
        //alert(d+'txtcount');
        db_count = parseInt(d)+1;
        db_count_dec=parseInt(db_count)-1
        //alert(db_count);
      $("#part_count").val(db_count_dec);


    }   
    else
    {
        d = $("#txt_count").val();
        db_count = parseInt(d)+length+1;
    }
    if(length<25){
        
        var currentDiv = db_count;
        //alert(currentDiv+"curr");
        var value = currentDiv; 
       //alert(value);
        //count increment       
        count=$("#part_count").val();
        //alert(count);
        if(currentDiv==2){
            count_inc=count+","+value;          
        }
        else{
            count_inc=count+","+value;          
        }
        
        $("#part_count").val(count_inc);
        
        //str = '<font id="participant_'+value+' multipleadd"><table cellspacing="0" cellspadding="0" border="0" width="100%"><tr><td colspan="7" class="errorDiv" id="errorDiv_'+value+'" style="display:none;"></td></tr><td width="156" class="tdata"><input type="text" id="participant_name_'+value+'" name="participant_name_'+value+'" class="lt textbox" value=""/></td><td width="80" class="tdata setIEcen"><input type="hidden" id="age_'+value+'" name="age_'+value+'" value="" /><div id="menu" class="lt ageDivMenu"><ul><li><a href="javascript:void(0)" class="ageDiv"><span id="age_setVal_'+value+'">Select</span><span><img src="/assets/event_index/dropdown_arrow.png" alt="" style=" position: relative; top: -1px; left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispAgeDiv"><li><a href="javascript:void(0)" onclick="setAgeVal(\'1-3\' , \''+value+'\')">1-3</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'4-6\' , \''+value+'\')">4-6</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'7-9\' , \''+value+'\')">7-9</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'10-12\' , \''+value+'\')">10-12</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'13-15\' , \''+value+'\')">13-15</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'16-18,'+value+')">16-18</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'Adults\' , \''+value+'\')">Adults</a></li>    </ul></li></ul><div class="clear"></div></div></td><td width="63" class="tdata setIEcen"><input type="hidden" id="gender_'+value+'" name="gender_'+value+'" value="" /><div id="menu" class="lt genderDivMenu"><ul><li><a href="javascript:void(0)" class="ageDiv genderDiv"><span id="gender_setVal_'+value+'">Select</span><span><img src="/assets/event_index/dropdown_arrow.png" alt="" style=" position: relative; top: -1px; left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispGenderDiv"><li><a href="javascript:void(0)" onclick="setGenderVal(\'Male\' , \''+value+'\')">Male</a></li><li><a href="javascript:void(0)" onclick="setGenderVal(\'Female\' , \''+value+'\')">Female</a></li></ul></li></ul><div class="clear"></div></div></td><td width="50" class="tdata">&nbsp;<span id="action_e_'+value+'"><a href="javascript:void(0)" titile="" class="lt" onclick="deleteTable('+value+')"><img src="/assets/provider_event_list/delete_icon.png" width="29" height="26" alt="" /></a></span></td></tr></table></font>';
        //without calender 
        //str = '<font id="participant_'+value+' multipleadd"><table cellspacing="0" cellspadding="0" border="0" width="100%"><tr><td colspan="5" class="errorDiv" id="errorDiv_'+value+'" style="display:none;"></td></tr><tr height="90"><td width="60" class="tdata tdata1"><span class="browse" id="filediv_'+value+'" style="top:3px;"><a href="javascript:void(0)" onClick="selectFile('+value+')" class="lt"><img src="/assets/create_new_activity/browse_image.png" width="65" height="67" /></a></span><input type="file" onchange="readURL_dy(this,'+value+');" size="21" id="photo_'+value+'" name="photo_'+value+'" value=""  style="display:none"/><div id="imagediv_'+value+'" class="browse1" style="display:none;"><a href="javascript:void(0)" onClick="selectFile('+value+')" class="lt"><img id="blah_'+value+'" src="#" alt="" /></a></div><div class="clear"></div></td><td width="166" class="tdata"><input type="text" id="participant_name_'+value+'" name="participant_name_'+value+'" class="lt textbox" value=""/></td><td width="80" class="tdata setIEcen"><input type="hidden" id="age_'+value+'" name="age_'+value+'" value="" /><div id="menu" class="lt ageDivMenu"><ul><li><a href="javascript:void(0)" class="ageDiv"><span id="age_setVal_'+value+'">Select</span><span><img src="/assets/event_index/dropdown_arrow.png" alt="" style=" position: relative; top: -1px; left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispAgeDiv"><li><a href="javascript:void(0)" onclick="setAgeVal(\'1-3\' , \''+value+'\')">1-3</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'4-6\' , \''+value+'\')">4-6</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'7-9\' , \''+value+'\')">7-9</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'10-12\' , \''+value+'\')">10-12</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'13-15\' , \''+value+'\')">13-15</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'16-18,'+value+')">16-18</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'Adults\' , \''+value+'\')">Adults</a></li>    </ul></li></ul><div class="clear"></div></div></td><td width="63" class="tdata setIEcen"><input type="hidden" id="gender_'+value+'" name="gender_'+value+'" value="" /><div id="menu" class="lt genderDivMenu"><ul><li><a href="javascript:void(0)" class="ageDiv genderDiv"><span id="gender_setVal_'+value+'">Select</span><span><img src="/assets/event_index/dropdown_arrow.png" alt="" style=" position: relative; top: -1px; left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispGenderDiv"><li><a href="javascript:void(0)" onclick="setGenderVal(\'Male\' , \''+value+'\')">Male</a></li><li><a href="javascript:void(0)" onclick="setGenderVal(\'Female\' , \''+value+'\')">Female</a></li></ul></li></ul><div class="clear"></div></div></td><td width="50" class="tdata">&nbsp;<span id="action_e_'+value+'"><a href="javascript:void(0)" titile="" class="lt" onclick="deleteTable('+value+')"><img src="/assets/provider_event_list/delete_icon.png" width="29" height="26" alt="" /></a></span></td></tr></table></font>';
        //all
        str = '<font id="participant_'+value+' multipleadd"><table cellspacing="0" cellspadding="0" border="0" width="100%"><tr><td colspan="7" class="errorDiv" id="errorDiv_'+value+'" style="display:none;"></td></tr><tr height="90"><td width="70" class="tdata tdata1"><span class="browse" id="filediv_'+value+'" style="top:3px;"><a href="javascript:void(0)" onClick="selectFile('+value+')" class="lt"><img src="/assets/create_new_activity/browse_image.png" width="65" height="67" /></a></span><input type="file" onchange="readURL_dy(this,'+value+');" size="21" id="photo_'+value+'" name="photo_'+value+'" value=""  style="display:none"/><div id="imagediv_'+value+'" class="browse1" style="display:none;"><a href="javascript:void(0)" onClick="selectFile('+value+')" class="lt"><img id="blah_'+value+'" src="#" alt="" /></a></div><div class="clear"></div></td><td width="156" class="tdata"><input type="text" id="participant_name_'+value+'" name="participant_name_'+value+'" class="lt textbox" value=""/></td><td width="155" class="tdata setIEcen"><input type="hidden" id="date_'+value+'" name="date_'+value+'" value="" /><div class="dateDiv"><input type="text"  id="dateFormate_'+value+'" name="dateFormate_'+value+'" class="dateTextbox" value="" readonly="readonly" style="outline: none;" tabindex="6"/><div class="clear"></div></div></td><td width="80" class="tdata setIEcen"><input type="hidden" id="age_'+value+'" name="age_'+value+'" value="" /><div id="menu" class="lt ageDivMenu"><ul><li><a href="javascript:void(0)" class="ageDiv"><span id="age_setVal_'+value+'">Select</span><span><img src="/assets/event_index/dropdown_arrow.png" alt="" style=" position: relative; top: -1px; left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispAgeDiv"><li><a href="javascript:void(0)" onclick="setAgeVal(\'1-3\' , \''+value+'\')">1-3</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'4-6\' , \''+value+'\')">4-6</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'7-9\' , \''+value+'\')">7-9</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'10-12\' , \''+value+'\')">10-12</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'13-15\' , \''+value+'\')">13-15</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'16-18,'+value+')">16-18</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'Adults\' , \''+value+'\')">Adults</a></li>    </ul></li></ul><div class="clear"></div></div></td><td width="63" class="tdata setIEcen"><input type="hidden" id="gender_'+value+'" name="gender_'+value+'" value="" /><div id="menu" class="lt genderDivMenu"><ul><li><a href="javascript:void(0)" class="ageDiv genderDiv"><span id="gender_setVal_'+value+'">Select</span><span><img src="/assets/event_index/dropdown_arrow.png" alt="" style=" position: relative; top: -1px; left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispGenderDiv"><li><a href="javascript:void(0)" onclick="setGenderVal(\'Male\' , \''+value+'\')">Male</a></li><li><a href="javascript:void(0)" onclick="setGenderVal(\'Female\' , \''+value+'\')">Female</a></li></ul></li></ul><div class="clear"></div></div></td><td width="50" class="tdata">&nbsp;<span id="action_e_'+value+'"><a href="javascript:void(0)" titile="" class="lt" onclick="deleteTable('+value+')"><img src="/assets/provider_event_list/delete_icon.png" width="29" height="26" alt="" /></a></span></td></tr></table></font>';

        $('.createDynamicDivs').append(str);
        dispYear(value);    
        
        $(function() {
            $("#dateFormate_"+value).datepicker({
              showOn : "button",
              buttonImage : "/assets/create_new_activity/date_icon.png",
              buttonImageOnly : true,
              maxDate: 0,
              dateFormat: "D, M d, yy",
              altField : "#date_"+value,
              altFormat : "yy-m-d"
            });

  });

      //alert(cuday);   
   // $("#dateFormate_"+value).val(cuday);
   // $("#date_"+value).val(date_value); 
    
    
        var pre_val = value - 1;        
        $('#action_e_'+value).show();
        
        if(value%2==0){
            $('#participant_'+value).css('background','#F7F9F8');
            $('#add_participant #participant_'+value+' td.tdata').css('background','none');
        }
        else{
            $('#participant_'+value).css('background','#ffffff');
            $('#add_participant #participant_'+value+' td.tdata').css('background','#ffffff');
        }
        
    }
/*    $(function(){
        $('.dispDayDiv li a').hover(function (){
            $(this).parent().parent().parent("li").children('a:first').addClass('selectedDayDiv');
        }, function(){
            $(this).parent().parent().parent("li").children('a:first').removeClass('selectedDayDiv');
        });
    });
    $(function(){
        $('.dispMonthDiv li a').hover(function (){
            $(this).parent().parent().parent("li").children('a:first').addClass('selectedMonthDiv');
        }, function(){
            $(this).parent().parent().parent("li").children('a:first').removeClass('selectedMonthDiv');
        });
    });
    $(function(){
        $('.dispYearDiv li a').hover(function (){
            $(this).parent().parent().parent("li").children('a:first').addClass('selectedYearDiv');
        }, function(){
            $(this).parent().parent().parent("li").children('a:first').removeClass('selectedYearDiv');
        });
    });
*/    $(function(){
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

function checkValidation(){
      var gopi=$('.multipleadd').length;
    
    
    var lengthDiv = $('.createDynamicDivs font table').length;
    var len = $('.createDynamicDivs font ').length;
     var j=[];
     for(i=0;i<=(len+1);i++){
       j.push(i);
  
     }
     //val ss= j.last

     // alert(ss)
      $('#total_value').val(j);
        
    //alert(len+"tot");
    if(lengthDiv==0){
        d = $("#txt_count").val();
        db_count = parseInt(d);
    }   
    else
    {
        d = $("#txt_count").val();
        db_count = parseInt(d)+parseInt(len);
    }
    var incDiv = db_count;

    var cDiv =  $("#txt_count").val();
    var msg='';
    for(var i=cDiv;i<=incDiv;i++){
        
       //var photo = $('#photo_'+i).val();
        var participant_name = $('#participant_name_'+i).val();
       // var day = $('#day_'+i).val();
        //var month = $('#month_'+i).val();
        //var year = $('#year_'+i).val();
        var age = $('#age_'+i).val();
        var gender = $('#gender_'+i).val();
        var schedule = $('#schedule_'+i).val();
       // var date_of_birth = $('#dateFormate_'+i).val();
        
      /*  if(photo == ''){
         msg+='upload image, ';
       } */
/*       if(participant_name == ''){
           if(msg!=''){
               msg+='participant name, ';
           }
           else{
               msg+='enter participant name, ';
           }
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






/*        if(date_of_birth == '')
        {
          if(msg!=''){
               msg+='date_of_birth, ';
           }
           else{
               msg+='select date_of_birth, ';
           }
       }
*/
        

    /*    if(day == ''){
            msg+=', day';
        }
        if(month == ''){
            msg+=', month';
        }
        if(year == ''){
            msg+=', year';
        }
         if(schedule == ''){
            msg+=', schedule';
        }

     
        if(age == ''){
          if(msg!=''){
               msg+='age, ';
           }
           else{
               msg+='select age, ';
           }
       }*/
       if(gender == ''){
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
       }
        
    }
    var flag=1;
    for(var i=cDiv;i<=incDiv;i++){
        if(participant_name!='' && gender!='' && age!=''){
            $('#errorDiv_'+i).hide();
            flag = 2;
        }
    }
    if(flag==2){
        addedDiv();
    }
    //alert('test');
    return false;   
}
function clearPartiValue(){
    total_len=$('.createDynamicDivs font table').length;
    div_index=total_len+1;
    $("#errorDiv_"+div_index).html('');
    $('#photo_'+div_index).val();
    $('#participant_name_'+div_index).val('');
    $('#day_'+div_index).val('');
    $("#imagediv_"+div_index).hide();
    $("#filediv_"+div_index).show();
/*  $('#day_setVal_'+div_index).html('Day');
    $('#month_setVal_'+div_index).html('Month');
    $('#year_setVal_'+div_index).html('Year');
*/  $('#age_setVal_'+div_index).html('Select');
    $('#gender_setVal_'+div_index).html('Select');
    $('#schedule_setVal_'+div_index).html('Choose Schedule');
    $('#month_'+div_index).val('');
    $('#year_'+div_index).val('');
    $('#age_'+div_index).val('');
    $('#gender_'+div_index).val('');
    $('#schedule_'+div_index).val('');
    //$(".createDynamicDivs").html('');   //clear inner add div content
}
function dispYear(value){
    var y='';
    var i=0;
    var curTime=new Date();
    var year = curTime.getFullYear();
    var cyear = parseInt(year)-1;
    for(i=cyear;i>2000;i--){
        y+='<li><a href="javascript:void(0)" onclick="setYearVal('+i+','+value+')" title="">'+i+'</a></li>';
    }
    $("#yearDisp_"+value).html(y);
}

/*function setDayVal(dvalue,inc){
    $('#day_'+inc).val(dvalue);
    $('#day_setVal_'+inc).html(dvalue);
}
function setMonthVal(mvalue,inc){
    $('#month_'+inc).val(mvalue);
    $('#month_setVal_'+inc).html(mvalue);
}
function setYearVal(yvalue,value){
    $('#year_'+value).val(yvalue);
    $('#year_setVal_'+value).html(yvalue);
}
*/function setAgeVal(agevalue,inc){
    $('#age_'+inc).val(agevalue);
    $('#age_setVal_'+inc).html(agevalue);
}
function setGenderVal(gvalue,inc){
    
    $('#gender_'+inc).val(gvalue);
    $('#gender_setVal_'+inc).html(gvalue);
}
function setScheduleVal(svalue,inc){
    $('#schedule_'+inc).val(svalue);
    $('#schedule_setVal_'+inc).html(svalue);
    $('#add_participant #schedule_div_'+inc+' .scheduleDiv').css('width','220px');
    $('#add_participant #menu #schedule_div_'+inc+' ul').addClass('dispScheduleDivSelected');
}
function selectFile(incVal){
    $('#photo_'+incVal).click();
}
function deleteTable(incVal){   
    var count=$("#part_count").val();
    var countSplit = count.split(",");
    var countLess = countSplit.length-1;
    var incValLess = incVal-1;      
    var removeVal = "";
    remove_count=$("#part_count").val();    
    
    for(var i=0;i<countSplit.length;i++){       
        if(countSplit[i]==incVal){
            removeVal = incVal+",";
            r_count=remove_count.replace(removeVal,"");         
            r_count=r_count.replace(incVal,"");         
            $("#part_count").val(r_count);          
        }
    }
    
    $('#participant_'+incVal).html('');
}

function clearPartiValue(){
    total_len=$('.createDynamicDivs font table').length;
    div_index=total_len+1;
    $("#errorDiv_"+div_index).html('');
    $('#photo_'+div_index).val();
    $('#participant_name_'+div_index).val('');
    $('#day_'+div_index).val('');
    $("#imagediv_"+div_index).hide();
    $("#filediv_"+div_index).show();
/*  $('#day_setVal_'+div_index).html('Day');
    $('#month_setVal_'+div_index).html('Month');
    $('#year_setVal_'+div_index).html('Year');
*/  $('#age_setVal_'+div_index).html('Select');
    $('#gender_setVal_'+div_index).html('Select');
    $('#schedule_setVal_'+div_index).html('Choose Schedule');
    $('#month_'+div_index).val('');
    $('#year_'+div_index).val('');
    $('#age_'+div_index).val('');
    $('#gender_'+div_index).val('');
    $('#schedule_'+div_index).val('');
    //$(".createDynamicDivs").html('');   //clear inner add div content
}
function raja(){
    var sub_category = $('#sub_category_apf').val();
    $.ajax({
        url: "/checkout/add_participant_success",
        data: "city="+sub_category,
        method:"POST",
        cache: false,
        success: function(data){
        //alert(data);
        }
    });

}