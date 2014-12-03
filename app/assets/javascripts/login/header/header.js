$(document).ready(function(){
    //initARC('provider_event_list','altCheckboxOn','altCheckboxOff');
    var curTime=new Date();
    var date = curTime.getDate();
    var month = curTime.getMonth();
    var year = curTime.getFullYear();
/*    k=date;
    if(k==1 || k==21 || k==31){
        selected_date=date+"<sup class='top'>st</sup>";
    }
    else if(k==3 || k==23){
        selected_date=date+"<sup class='top'>rd</sup>";
    }
    else if(k==2 || k==22)
    {
        selected_date=date+"<sup class='top'>nd</sup>";
    }
    else{
        selected_date=date+"<sup class='top'>th</sup>";
    }
*/	
    var monthName = getMonthVal(month);
    $('#month').html(monthName);
    $('#date').html(date);
});
$('body').click(function(){
    dropDown_new();
});
var actionflag=false;
var actiontrig=true;
function dropDown_new(){   
    if(actionflag){
        if(actiontrig){      	
            if(document.getElementById("actionDropDownDiv").innerHTML!=''){
                document.getElementById("actionDropDownDiv").style.display="block";
                $('#actionDiv').removeClass('actionboxNormal');
                $('#actionDiv').addClass('actionboxSelected');
            }
            actiontrig=false;           
        }
        else{
            document.getElementById("actionDropDownDiv").style.display="none";
            $('#actionDiv').removeClass('actionboxSelected');
            $('#actionDiv').addClass('actionboxNormal');
            actiontrig=true;
        }
    }    
    else{
        document.getElementById("actionDropDownDiv").style.display="none";
        $('#actionDiv').removeClass('actionboxSelected');
        $('#actionDiv').addClass('actionboxNormal');
        actiontrig=true;
    }    
}
function setDropDownValue(val){	
    document.getElementById("action_type").value=val;
    document.getElementById("actionDropDownDiv").style.display="none";
    $('#actionDiv').toggleClass('actionboxSelected');
    $('#actionDiv').toggleClass('actionboxNormal');
}
function selectAny(cname){	
    if(cname == 'select'){
        $('#select').css('display','none');
        $('#not_select').css('display','inline-block');
        $('#pe').val(0);
        $('.activityName label').removeClass('altCheckboxOn');
        $('.activityName label').addClass('altCheckboxOff');
        $("#actid_chk").val('');
    }
    else if(cname == 'not_select'){
        $('#not_select').css('display','none');
        $('#select').css('display','inline-block');
        $('#pe').val(1);
        $('.activityName label').removeClass('altCheckboxOff');
        $('.activityName label').addClass('altCheckboxOn');
        //select all checkbox id to add hidden field
        chk_len=$(".centerContainer input:checkbox").length;
        $("#actid_chk").val('');
        selected_ids="";
        for(i=0; i<chk_len; i++)
        {
            chk_id=$(".centerContainer input:checkbox:eq("+i+")").attr('id');
            chk_id_rep=chk_id.replace("pe","");
            if(i=="0")
            {
                selected_ids=chk_id_rep;
            }
            else
            {
                selected_ids=selected_ids+","+chk_id_rep;
            }
        }
        $("#actid_chk").val(selected_ids);
    }
}

$(function(){
    $('.dispProviderActivityDiv li a').hover(function (){

        $('.actDivMenu ul li a:first').addClass('selectedActDiv');
    }, function(){
        $('.actDivMenu ul li a:first').removeClass('selectedActDiv');
    });
});
$(function(){
    $('.dispProviderActionDiv li a').hover(function (){
        $('.actionDivMenu ul li a:first').addClass('selectedActionDiv');
    }, function(){
        $('.actionDivMenu ul li a:first').removeClass('selectedActionDiv');
    });
});
$(function(){
    $('.dispProviderCatDiv').hover(function (){
        $('.catDivMenu ul li a').addClass('selectedCatDiv');
    }, function(){
        $('.catDivMenu ul li a').removeClass('selectedCatDiv');
    });
});



function changedPFormateDate(){	
    var dateVal = $('#datepicker').val();
    var splitDateVal = dateVal.split('/');
    var month = splitDateVal[0];
    var date = splitDateVal[1];
    var year = splitDateVal[2];
	
    var formatedDate = year+"-"+month+"-"+date;
	
    /*k=date;
    if(k==1 || k==21 || k==31){
        selected_date=date+"<sup class='top'>st</sup>";
    }
    else if(k==3 || k==23){
        selected_date=date+"<sup class='top'>rd</sup>";
    }
    else if(k==2 || k==22)
    {
        selected_date=date+"<sup class='top'>nd</sup>";
    }
    else{
        selected_date=date+"<sup class='top'>th</sup>";
    }*/
	
    var monthName = getMonthValue(month);
	
    $('#month').html(monthName);
    $('#date').html(date);

    $.get("/event/activity_update",{
        "date":formatedDate,
        "cat_zc":"date"
    }, null, "script");
    
//    window.location.href ="/event/event_index_update?cat_zc=date&date="+formatedDate;
}



function changedproviderFormateDate_val(){
    var dateVal = $('#datepicker').val();
    var splitDateVal = dateVal.split('/');
    var month = splitDateVal[0];
    var date = splitDateVal[1];
    var year = splitDateVal[2];

    var formatedDate = year+"-"+month+"-"+date;

/*    k=date;
    if(k==1 || k==21 || k==31){
        selected_date=date+"<sup class='top'>st</sup>";
    }
    else if(k==3 || k==23){
        selected_date=date+"<sup class='top'>rd</sup>";
    }
    else if(k==2 || k==22)
    {
        selected_date=date+"<sup class='top'>nd</sup>";
    }
    else{
        selected_date=date+"<sup class='top'>th</sup>";
    }
*/
    var monthName = getMonthValue(month);

    $('#month').html(monthName);
    $('#date').html(selected_date);

    window.location.href ="provider_activities?cat_zc=date&date="+formatedDate;
}


function changedFormateDate(){
    var dateVal = $('#datepicker').val();
    var splitDateVal = dateVal.split('/');
    var month = splitDateVal[0];
    var date = splitDateVal[1];
    var year = splitDateVal[2];
	
    var formatedDate = year+"-"+month+"-"+date;
	
/*    k=date;
    if(k==1 || k==21 || k==31){
        selected_date=date+"<sup class='top'>st</sup>";
    }
    else if(k==3 || k==23){
        selected_date=date+"<sup class='top'>rd</sup>";
    }
    else if(k==2 || k==22)
    {
        selected_date=date+"<sup class='top'>nd</sup>";
    }
    else{
        selected_date=date+"<sup class='top'>th</sup>";
    }
*/	
    var monthName = getMonthVal(month);
	
    $('#month').html(monthName);
    $('#date').html(selected_date);
    window.location.href ="/event/event_index_update?cat_zc=date&date="+formatedDate;
}

function changedproviderFormateDate(){
    var dateVal = $('#datepicker').val();
    var splitDateVal = dateVal.split('/');
    var month = splitDateVal[0];
    var date = splitDateVal[1];
    var year = splitDateVal[2];

    var formatedDate = year+"-"+month+"-"+date;

/*    k=date;
    if(k==1 || k==21 || k==31){
        selected_date=date+"<sup class='top'>st</sup>";
    }
    else if(k==3 || k==23){
        selected_date=date+"<sup class='top'>rd</sup>";
    }
    else if(k==2 || k==22)
    {
        selected_date=date+"<sup class='top'>nd</sup>";
    }
    else{
        selected_date=date+"<sup class='top'>th</sup>";
    }
*/
    var monthName = getMonthVal(month);

    $('#month').html(monthName);
    $('#date').html(selected_date);
    window.location.href ="/provider_activites?cat_zc=date&date="+formatedDate;
}

/* get month text */
function getMonthVal(month)
{
    var selected_month;
    switch(month){
        case 0:
            selected_month='Jan';
            break;
        case 1:
            selected_month='Feb';
            break;
        case 2:
            selected_month='Mar';
            break;
        case 3:
            selected_month='Apr';
            break;
        case 4:
            selected_month='May';
            break;
        case 5:
            selected_month='Jun';
            break;
        case 6:
            selected_month='Jul';
            break;
        case 7:
            selected_month='Aug';
            break;
        case 8:
            selected_month='Sep';
            break;
        case 9:
            selected_month='Oct';
            break;
        case 10:
            selected_month='Nov';
            break;
        case 11:
            selected_month='Dec';
            break; 	
    }
    return selected_month;
}

function getMonthValue(month)
{
    var selected_month;
    switch(month){
        case "01":
            selected_month='Jan';
            break;
        case "02":
            selected_month='Feb';
            break;
        case "03":
            selected_month='Mar';
            break;
        case "04":
            selected_month='Apr';
            break;
        case "05":
            selected_month='May';
            break;
        case "06":
            selected_month='Jun';
            break;
        case "07":
            selected_month='Jul';
            break;
        case "08":
            selected_month='Aug';
            break;
        case "09":
            selected_month='Sep';
            break;
        case "10":
            selected_month='Oct';
            break;
        case "11":
            selected_month='Nov';
            break;
        case "12":
            selected_month='Dec';
            break;
    }
    return selected_month;
}


function dispDate(){	
    $('#datepicker').datepicker({
        showOn: 'focus'
    }).focus();	
    $('#datepicker').addClass('hasDatepicker');
    $("#ui-datepicker-div").show();
    $("#ui-datepicker-div").css('top','35px');
    $('#datePickerOver').removeClass('datePickerOver');
    $('#datePickerOver').addClass('datePickerOverSelected');
}  
$(function(){
    $('#ui-datepicker-div').hover(function (){
											
        $('#datepicker').datepicker({
            showOn: 'focus'
        }).focus();
        $('#datepicker').addClass('hasDatepicker');
        $(this).show();
        $("#ui-datepicker-div").css('top','35px');
        $('#datePickerOver').removeClass('datePickerOver');
        $('#datePickerOver').addClass('datePickerOverSelected');
    }, function(){
        $('#datepicker').removeClass('hasDatepicker').datepicker();
        $('#ui-datepicker-div').hide();
        $('#datePickerOver').removeClass('datePickerOverSelected');
        $('#datePickerOver').addClass('datePickerOver');
    });
});

$(function() {
    $('.eventListContainer').bind('mouseover', function () {
        $('#datepicker').removeClass('hasDatepicker').datepicker();
        $('#ui-datepicker-div').hide();
        $('#datePickerOver').removeClass('datePickerOverSelected');
        $('#datePickerOver').addClass('datePickerOver');
    });
});
$(function() {
    $('#providerEventList').bind('mouseover', function () {
        $('#datepicker').removeClass('hasDatepicker').datepicker();
        $('#ui-datepicker-div').hide();
        $('#datePickerOver').removeClass('datePickerOverSelected');
        $('#datePickerOver').addClass('datePickerOver');
    });
});
$(function() {
    $('#city_value').bind('mouseover', function () {
        $('#datepicker').removeClass('hasDatepicker').datepicker();
        $('#ui-datepicker-div').hide();
        $('#datePickerOver').removeClass('datePickerOverSelected');
        $('#datePickerOver').addClass('datePickerOver');
    });
});
$(function() {
    $('.selectedCity2').bind('mouseover', function () {
        $('#datepicker').removeClass('hasDatepicker').datepicker();
        $('#ui-datepicker-div').hide();
        $('#datePickerOver').removeClass('datePickerOverSelected');
        $('#datePickerOver').addClass('datePickerOver');
    });
});
$(function() {
    $('#HeaderRt').bind('mouseover', function () {
        $('#datepicker').removeClass('hasDatepicker').datepicker();
        $('#ui-datepicker-div').hide();
        $('#datePickerOver').removeClass('datePickerOverSelected');
        $('#datePickerOver').addClass('datePickerOver');
    });
});
$(function() {
    $('#center_content_div').bind('mouseover', function () {
        $('#datepicker').removeClass('hasDatepicker').datepicker();
        $('#ui-datepicker-div').hide();
        $('#datePickerOver').removeClass('datePickerOverSelected');
        $('#datePickerOver').addClass('datePickerOver');
    });
});
/*******Jump to***********/
  $(function(){
    $('.dispParentjumpDiv li a').hover(function (){
        $('.jumpDivMenu ul li a:first').addClass('selectedJumpDiv');
		 $('.jumpDiv').css('border','1px solid #A9D3E1');
    }, function(){
        $('.jumpDivMenu ul li a:first').removeClass('selectedJumpDiv');
		 $('.jumpDiv').css('border','1px solid #F7F9F8');
    });
});
  
    $(function(){
    $('.jumpDiv').hover(function (){
        $('.jumpDivMenu ul li a:first').addClass('selectedJumpDiv');
		 $('.jumpDiv').css('border','1px solid #A9D3E1');
    }, function(){
        $('.jumpDivMenu ul li a:first').removeClass('selectedJumpDiv');
		 $('.jumpDiv').css('border','1px solid #F7F9F8');
    });
});


/************parent & provider Header Div *******************/


  $(function(){
    $('.dispParentUserDiv li a').hover(function (){
        $('.UserDivMenu ul li a:first').addClass('selectedUserDiv');
		 $('.userDiv').css('border','1px solid #A9D3E1');
    }, function(){
        $('.UserDivMenu ul li a:first').removeClass('selectedUserDiv');
		 $('.userDiv').css('border','1px solid #DBEEF4');
    });
});


  $(function(){
    $('.dispParentServiceDiv li a').hover(function (){
        $('.serviceDivMenu ul li a:first').addClass('selectedUserDiv');
		 $('.serviceDiv').css('border','1px solid #A9D3E1');
    }, function(){
        $('.serviceDivMenu ul li a:first').removeClass('selectedUserDiv');
		 $('.serviceDiv').css('border','1px solid #DBEEF4');
    });
});


  $(function(){
    $('.userDiv').hover(function (){
        $('.UserDivMenu ul li a:first').addClass('selectedUserDiv');
		 $('.userDiv').css('border','1px solid #A9D3E1');
    }, function(){
        $('.UserDivMenu ul li a:first').removeClass('selectedUserDiv');
		 $('.userDiv').css('border','1px solid #DBEEF4');
    });
});

  $(function(){
    $('.serviceDiv').hover(function (){
        $('.serviceDivMenu ul li a:first').addClass('selectedUserDiv');
		 $('.serviceDiv').css('border','1px solid #A9D3E1');
    }, function(){
        $('.serviceDivMenu ul li a:first').removeClass('selectedUserDiv');
		 $('.serviceDiv').css('border','1px solid #DBEEF4');
    });
});
