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
    $('.scheduleDivMenu .dispScheduleDiv li a').hover(function (){
        $(this).parent().parent().parent("li").children('a:first').addClass('selectedScheduleDiv');
    }, function(){
        $(this).parent().parent().parent("li").children('a:first').removeClass('selectedScheduleDiv');
    });
});

// dislayed participant image
/*function readURL_dy(input,value) {
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
}*/
//  automatic click the input(file)
/*function selectFile(incVal){
    $('#photo_'+incVal).click();
}*/
//  added new participant

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
        
        
          str = '<font id="participant_'+value+'"><table cellspacing="0" cellspadding="0" border="0" width="100%"><tr><td colspan="4" class="errorDiv ftcRedff" id="errorDiv_'+value+'" style="display:none;"></td></tr><tr height="90"><td width="300" class="tdata tdata1"><input type="text" id="participant_name_'+value+'" name="participant_name_'+value+'" class="lt textbox" value=""/></td><td width="150" class="tdata setIEcen"><input type="hidden" id="age_'+value+'" name="age_'+value+'" value="" /><div id="menu" class="lt ageDivMenu"><ul><li><a href="javascript:void(0)" class="ageDiv"><span id="age_setVal_'+value+'">Select</span><span><img src="/assets/event_index/dropdown_arrow.png" alt="" style=" position: relative; top: -1px; left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispAgeDiv"><li><a href="javascript:void(0)" onclick="setAgeVal(\'1-3\' , \''+value+'\')">1-3</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'4-6\' , \''+value+'\')">4-6</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'7-9\' , \''+value+'\')">7-9</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'10-12\' , \''+value+'\')">10-12</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'13-15\' , \''+value+'\')">13-15</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'16-18,'+value+')">16-18</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'Adults\' , \''+value+'\')">Adults</a></li>    </ul></li></ul><div class="clear"></div></div></td><td width="150" class="tdata setIEcen"><input type="hidden" id="gender_'+value+'" name="gender_'+value+'" value="" /><div id="menu" class="lt genderDivMenu"><ul><li><a href="javascript:void(0)" class="ageDiv genderDiv"><span id="gender_setVal_'+value+'">Select</span><span><img src="/assets/event_index/dropdown_arrow.png" alt="" style=" position: relative; top: -1px; left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispGenderDiv"><li><a href="javascript:void(0)" onclick="setGenderVal(\'Male\' , \''+value+'\')">Male</a></li><li><a href="javascript:void(0)" onclick="setGenderVal(\'Female\' , \''+value+'\')">Female</a></li></ul></li></ul><div class="clear"></div></div></td><td width="85" class="tdata">&nbsp;<span id="action_e_'+value+'"><a href="javascript:void(0)" titile="" class="lt" onclick="deleteTable('+value+')"><img src="/assets/provider_event_list/delete_icon.png" width="29" height="26" alt="" /></a></span></td></tr></table></font>';
        //str = '<font id="participant_'+value+' multipleadd"><table cellspacing="0" cellspadding="0" border="0" width="100%"><tr><td colspan="7" class="errorDiv" id="errorDiv_'+value+'" style="display:none;"></td></tr><tr height="90"><td width="70" class="tdata tdata1"><span class="browse" id="filediv_'+value+'" style="top:3px;"><a href="javascript:void(0)" onClick="selectFile('+value+')" class="lt"><img src="/assets/create_new_activity/browse_image.png" width="65" height="67" /></a></span><input type="file" onchange="readURL_dy(this,'+value+');" size="21" id="photo_'+value+'" name="photo_'+value+'" value=""  style="display:none"/><div id="imagediv_'+value+'" class="browse1" style="display:none;"><a href="javascript:void(0)" onClick="selectFile('+value+')" class="lt"><img id="blah_'+value+'" src="#" alt="" /></a></div><div class="clear"></div></td><td width="156" class="tdata"><input type="text" id="participant_name_'+value+'" name="participant_name_'+value+'" class="lt textbox" value=""/></td><td width="155" class="tdata setIEcen"><input type="hidden" id="date_'+value+'" name="date_'+value+'" value="" /><div class="dateDiv"><input type="text"  id="dateFormate_'+value+'" name="dateFormate_'+value+'" class="dateTextbox" value="" readonly="readonly" style="outline: none;" tabindex="6"/><div class="clear"></div></div></td><td width="80" class="tdata setIEcen"><input type="hidden" id="age_'+value+'" name="age_'+value+'" value="" /><div id="menu" class="lt ageDivMenu"><ul><li><a href="javascript:void(0)" class="ageDiv"><span id="age_setVal_'+value+'">Select</span><span><img src="/assets/event_index/dropdown_arrow.png" alt="" style=" position: relative; top: -1px; left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispAgeDiv"><li><a href="javascript:void(0)" onclick="setAgeVal(\'1-3\' , \''+value+'\')">1-3</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'4-6\' , \''+value+'\')">4-6</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'7-9\' , \''+value+'\')">7-9</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'10-12\' , \''+value+'\')">10-12</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'13-15\' , \''+value+'\')">13-15</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'16-18,'+value+')">16-18</a></li><li><a href="javascript:void(0)" onclick="setAgeVal(\'Adults\' , \''+value+'\')">Adults</a></li>    </ul></li></ul><div class="clear"></div></div></td><td width="63" class="tdata setIEcen"><input type="hidden" id="gender_'+value+'" name="gender_'+value+'" value="" /><div id="menu" class="lt genderDivMenu"><ul><li><a href="javascript:void(0)" class="ageDiv genderDiv"><span id="gender_setVal_'+value+'">Select</span><span><img src="/assets/event_index/dropdown_arrow.png" alt="" style=" position: relative; top: -1px; left:5px;" height="4" width="7"/></span></a><ul class="sub-menu dispGenderDiv"><li><a href="javascript:void(0)" onclick="setGenderVal(\'Male\' , \''+value+'\')">Male</a></li><li><a href="javascript:void(0)" onclick="setGenderVal(\'Female\' , \''+value+'\')">Female</a></li></ul></li></ul><div class="clear"></div></div></td><td width="50" class="tdata">&nbsp;<span id="action_e_'+value+'"><a href="javascript:void(0)" titile="" class="lt" onclick="deleteTable('+value+')"><img src="/assets/provider_event_list/delete_icon.png" width="29" height="26" alt="" /></a></span></td></tr></table></font>';

        $('.createDynamicDivs').append(str);
    
        var pre_val = value - 1;        
        $('#action_e_'+value).show();
        
    }
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
function checkValidation(){

    var lengthDiv = $('.createDynamicDivs font table').length;
    var len = $('.createDynamicDivs font ').length;
     var j=[];
     for(i=0;i<=(len+1);i++){
       j.push(i);
  
     }
      $('#total_value').val(j);

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
        
       var participant_name = $('#participant_name_'+i).val();
        var age = $('#age_'+i).val();
        var gender = $('#gender_'+i).val();
	    
	if(participant_name == ''){        
		msg+='enter participant name';
	}
	
         if(age == ''){
          if(msg!=''){
               msg+=', select age';
           }
           else{
               msg+='select gender';
           }
       }


         if(gender == ''){
          if(msg!=''){
               msg+=', select gender';
           }
           else{
               msg+='select gender';
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
function setAgeVal(agevalue,inc){
    $('#age_'+inc).val(agevalue);
    $('#age_setVal_'+inc).html(agevalue);
}
function setGenderVal(gvalue,inc){    
    $('#gender_'+inc).val(gvalue);
    $('#gender_setVal_'+inc).html(gvalue);
}

function deleteTable(incVal){   
    $('#participant_'+incVal).html('');
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
}
function clearPartiValue(){	
	$("#attendees_parent_email").val("jhonjoe@gmail.com,smith@yahoo.com");
	$("#attendees_parent_email").css("color","#999999");
	$("#participant_name_1").val("");	
	$("#age_1").val("");
	$("#age_setVal_1").html("Select");
	$("#gender_1").val("");
	$("#gender_setVal_1").html("Select");	
	$(".createDynamicDivs").html("");
	
	$("#attendees_parent_email").css("border","1px solid #CDE0E6");
	$("#attendees_parent_email_error").html("");
	$("#attendees_parent_email_error").parent().css("display","none");
	
	$("#add_participant .errorDiv").html("");
	$("#add_participant .errorDiv").css("display","none");
}