var mySchedule = new Array();
mySchedule[0] ="1";


/*********************************************
	        VALIDATE Schedule
**********************************************/
function validate_schedule(x,y,d,opt){	
	
    var msg1="";
    var msg2="";
    var retVal ="";
    var repeatWeekVal = $("#repeatWeekVal_"+x).val();
    var schedule_stime_1 = $('#schedule_stime_1_'+x).val();
    $('#schedule_stime_1_'+x).css('border','1px solid #CDE0E6');
    var schedule_stime_2 = $('#schedule_stime_2_'+x).val();
    var schedule_etime_1 = $('#schedule_etime_1_'+x).val();
    $('#schedule_etime_1_'+x).css('border','1px solid #CDE0E6');
    var schedule_etime_2 = $('#schedule_etime_2_'+x).val();
    $('#leader_'+x).css('border','1px solid #CDE0E6');
    $('#location_'+x).css('border','1px solid #CDE0E6');
    $("#schedule_time_error_"+x).html("");
    $("#schedule_time_error_"+x).parent().css("display","none");
	
    var leader = $("#leader_"+x).val();
    var location = $("#location_"+x).val();

    var sched_start = $('#date_1'+x).val();
    var sched_end = $('#repeat_alt_on_date_'+x).val();

    var radio_3 = $('#r3_'+x).val();
    var repeatCheck = $("#repeatCheck").val();
	
    var split_schedule_stime_1 = schedule_stime_1.split(":");
    var split_schedule_etime_1 = schedule_etime_1.split(":");
    var s_val_1 = split_schedule_stime_1[0];
    var s_val_2 = split_schedule_stime_1[1];

    var e_val_1 = split_schedule_etime_1[0];
    var e_val_2 = split_schedule_etime_1[1];
	
    //msg1="Please ";
    msg2="";
	
    if(radio_3==1 &&  repeatCheck == "yes"){
        if(sched_start == sched_end ){
            if(s_val_1 == e_val_1 && s_val_2 >= e_val_2 && schedule_stime_2 == schedule_etime_2){
                $('#schedule_stime_1_'+x).css('border','1px solid #fc8989');
                $('#schedule_etime_1_'+x).css('border','1px solid #fc8989');
                msg2 += 'select valid time';
            }
            if( s_val_1 > e_val_1 && s_val_1 != 12 && e_val_1 != 12 && schedule_stime_2 == schedule_etime_2 ){
                $('#schedule_stime_1_'+x).css('border','1px solid #fc8989');
                $('#schedule_etime_1_'+x).css('border','1px solid #fc8989');
                msg2 += 'select valid time';
            }
            if( ((s_val_1 > 0 && s_val_1 != 12)  &&  e_val_1 == 12  && ( schedule_stime_2 == schedule_etime_2 ) ) || ( s_val_1 == 12 && e_val_1 > 12 ) ){
                $('#schedule_stime_1_'+x).css('border','1px solid #fc8989');
                $('#schedule_etime_1_'+x).css('border','1px solid #fc8989');
                msg2 += 'select valid time';
            }
        }
    }
    else{
        if(s_val_1 == e_val_1 && s_val_2 >= e_val_2 && schedule_stime_2 == schedule_etime_2){
            $('#schedule_stime_1_'+x).css('border','1px solid #fc8989');
            $('#schedule_etime_1_'+x).css('border','1px solid #fc8989');
            msg2 += 'select valid time';
        }
        if( s_val_1 > e_val_1 && s_val_1 != 12 && e_val_1 != 12 && schedule_stime_2 == schedule_etime_2 ){
            $('#schedule_stime_1_'+x).css('border','1px solid #fc8989');
            $('#schedule_etime_1_'+x).css('border','1px solid #fc8989');
            msg2 += 'select valid time';
        }
        if( ((s_val_1 > 0 && s_val_1 != 12)  &&  e_val_1 == 12  && ( schedule_stime_2 == schedule_etime_2 ) ) || ( s_val_1 == 12 && e_val_1 > 12 ) ){
            $('#schedule_stime_1_'+x).css('border','1px solid #fc8989');
            $('#schedule_etime_1_'+x).css('border','1px solid #fc8989');
            msg2 += 'select valid time';
        }
    }
  
    var participant_=$('#participant_'+x).val();

    participant_=parseInt(participant_);
    if(participant_==0)
    {
        if(msg2=='')
            msg2 += 'enter valid participants number ';
        else
            msg2 += ', enter valid participants number ';
								 
    }
    /***********same schedule checking function calling *************/
    var sc_flag=$('#sc_chk_flag').val();
    if((y!=1)&&(sc_flag=='1')){
        var msg=same_schedule_check_process(x);
        msg2+=msg;
    }
	
    /***********same schedule checking*************/
		
    if(leader == "" || leader == "Enter Leader" ){
        $('#leader_'+x).css('border','1px solid #fc8989');
        if(msg2=='')
            msg2 += 'enter leader name';
        else
            msg2 += ', enter leader name';
    }
    if(location == "" ){
        $('#location_'+x).css('border','1px solid #fc8989');
        if(msg2=='')
            msg2 += 'choose location';
        else
            msg2 += ', choose location';
    }
	
    if(msg2!=''){
        if(msg2!='' ){
            msg2= msg2.replace('1','')
            $("#schedule_time_error_"+x).html(msg1+msg2);
            $("#schedule_time_error_"+x).parent().css("display","block");
        }
        //$('.dateDiv').css("border","1px red solid");
        retVal="f";
    }
	

    else{
        retVal="t";
    }
    if(opt=="validation"){
        return retVal;
    }
    else if(opt=="change"){
        return retVal;
    }
	
    else{
        if(retVal=="t")  add_schedule(x,d);
    }
	

}

function setOk()
{
	
    var setvalue=$('#setSched').val();
	
	
    add_schedule(setvalue);
//$('#setSched').val('1');
}

function setCancel()
{
//$('#setSched').val('');
//$('#setSched').val('0');
	
}

// checking same schedule added or not
function same_schedule_check_process(x)
{
	
    date_select=$('#date_1_'+x).val();
    summary_weekText=$('#summary_weekText_'+x).text();
    summary_occur=$('#summary_occur_'+x).text();
    if(summary_weekText1="")
    {
        summary_weekText=$('#summary_weekText_'+x).text();
    }
    else{
        summary_weekText=$('#summary_occur_'+x).text();
    }
    var repeat_on_date=$('#repeat_alt_on_date_'+x).val();
    var msg2='';
    var select_box11='schedule_stime_1_'+x;
    var e11 = document.getElementById(select_box11);
    var strSelected11 = e11.options[e11.selectedIndex].value;
    var select_box21='schedule_stime_2_'+x;
    var e21 = document.getElementById(select_box21);
    var strSelected21 = e21.options[e21.selectedIndex].value;
    var select_box31='schedule_etime_1_'+x;
    var e31= document.getElementById(select_box31);
    var strSelected31 = e31.options[e31.selectedIndex].value;
    var select_box41='schedule_etime_2_'+x;
    var e41= document.getElementById(select_box41);
    var strSelected41 = e41.options[e41.selectedIndex].value;
    schedule_tabs=$('#schedule_tabs').val();
    schedule_tabs=schedule_tabs.split(',');
    if(schedule_tabs.length>1){
		
        for(var i=0; i<schedule_tabs.length-1;i++){
				
            date_select1=$('#date_1_'+schedule_tabs[i]).val();
            summary_weekText1=$('#summary_weekText_'+schedule_tabs[i]).text();
            summary_occur1=$('#summary_occur_'+schedule_tabs[i]).text();
            if(summary_weekText1="")
            {
                summary_weekText1=$('#summary_weekText_'+schedule_tabs[i]).text();
            }
            else{
                summary_weekText1=$('#summary_occur_'+schedule_tabs[i]).text();
            }
	
            var repeat_on_date1=$('#repeat_alt_on_date_'+schedule_tabs[i]).val();
				
            var select_box1='schedule_stime_1_'+schedule_tabs[i];
		
            var e1 = document.getElementById(select_box1);
            var strSelected1 = e1.options[e1.selectedIndex].value;
					
            var select_box2='schedule_stime_2_'+schedule_tabs[i];
				
            var e2 = document.getElementById(select_box2);
            var strSelected2 = e2.options[e2.selectedIndex].value;
            var select_box3='schedule_etime_1_'+schedule_tabs[i];
            var e3 = document.getElementById(select_box3);
            var strSelected3 = e3.options[e3.selectedIndex].value;
            var select_box4='schedule_etime_2_'+schedule_tabs[i];
            var e4 = document.getElementById(select_box4);
            var strSelected4 = e4.options[e4.selectedIndex].value;
		
            if((strSelected11==strSelected1)&&(strSelected21==strSelected2)&&(strSelected31==strSelected3)&&(strSelected41==strSelected4)&&(date_select==date_select1)&&(repeat_on_date==repeat_on_date1)&&(summary_weekText==summary_weekText1))
            {
                var is_add='1';
                break;
					
            }
            else	{
                var is_add='0';
					
            }
			
			
        }
    }
    var total_count=$('#schedule_tabs').val();
    
    var splitNumber=total_count.split(",");
       
    var last_id=splitNumber[splitNumber.length-1];
   
    if((is_add=='1')&&(last_id==x)){
			
			
        //$('.content_popup').css("display","block");
        //	 $('#same_schedule_ck').bPopup();
        var r=confirm("do you want to add the same schedule again?");
        if (r==true)
        {
            var msg3='';
				
        }
        else
        {
            var msg3='1';
        }
        msg2+=msg3;
    }
		
    var participant=$("#participant_"+x).val();
	
    if(participant!="Specify Number" ){
		
        if(isNaN(participant) ){
            $('#participant_'+x).css('border','1px solid #fc8989');
            if(msg2=='')
                msg2 += 'Please enter valid participant number';
            else
                msg2 += 'Please enter valid participant number';
        }
        else{
            $('#participant_'+x).css('border','1px solid #CDE0E6');
        }
    }
		
		
		
    return msg2;
}
/*****************************************
Scheduke date add (summary)
********************************************/
function schedule_date_add()
{
    tabs=$('#schedule_tabs').val();
    str ='';
    tabs_arr = tabs.split(",");
    for(var i=0; i<tabs_arr.length; i++)
    {
        summary_date_time_changes(tabs_arr[i]);
        $('#schedule_summary_'+tabs_arr[i]).show();
        date_val = $('#schedule_summary_'+tabs_arr[i]+' #dateSummay').html();
        str=str+'$'+date_val;
    }
    $('#schedule_date').val(str);
    $('#schedule_date_count').val(tabs_arr.length);

                }
/*********************************************
		 ADD Schedule
**********************************************/
var i=1;
function add_schedule(i,d){
   
    summary_date_time_changes(i);
    $('#delete_schedule_1').css("display","block");
	
    i++;
   // mySchedule.push(i); //push in to schedule arrray

    var arr= '';
    var html=' ';
    var pop_up='';
    arry=$('#schedule_tabs').val();
    if(i!=1){
        arr+=arry+',';
    }
    arr+=i+',';
    ar1=arry.split(',');
    // $('#delete_schedule_'+ar1[0]).css("display","block");
    //  $( "#add_schedule_"+i ).css("display","block");
    //$( ".add_schedule").css("display","none");
	 
    $('#setSched').val('');
    $('#setSched').val(i);
    pop_up+='<div class="repeatContainer" id="repeatPOPUPDiv_'+i+'" style="display:none;"><div class="repeatContainerTop"></div><div class="repeatContainerCenter"><div class="innerContainer"><div class="headTab">';
    pop_up+='<div class="heading"><div class="headCont">Repeat</div></div><div class="closeButton" style="padding:0px;"><input type="hidden" id="repeat_save_'+i+'"  value="" />';
    pop_up+='<a href="javascript:void(0)" onClick="closeRepeatDiv('+i+')" onkeydown="cancelRepeatKeyDown(event,'+i+')" title=""><img src="/assets/global/pop_up/button_close.png" alt="" width="15" height="15" /></a>';
    pop_up+='</div></div><div class="repeatFormContent"><div class="row"><div class="lt ltField ">Repeats</div><div class="lt">';
    pop_up+='<select id="repeatWeekVal_'+i+'" name="repeatWeekVal_'+i+'" size="1" tabindex="8" class="drop_down_left width_set4" onkeyup="repeatsValue('+i+')" onChange="repeatsValue('+i+')"><option value="Daily" selected="selected">Daily</option>';
    pop_up+='<option value="Weekly">Weekly</option><option value="Monthly">Monthly</option><option value="Yearly">Yearly</option></select></div><div class="clear"></div></div><div class="row repeatEvery">';
    pop_up+='<div class="lt ltField">Repeat Every</div><div class="lt"><select id="repeatNumWeekVal_'+i+'" name="repeatNumWeekVal_'+i+'"  size="1" tabindex="9" class="drop_down_left width_set3" onkeyup="repeatEveryValue('+i+')" onChange="repeatEveryValue('+i+')">';
    pop_up+='<option value="1" selected="selected">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="6">6</option><option value="7">7</option><option value="8">8</option><option value="9">9</option><option value="10">10</option><option value="11">11</option><option value="12">12</option><option value="13">13</option><option value="14">14</option><option value="15">15</option><option value="16">16</option><option value="17">17</option><option value="18">18</option><option value="19">19</option><option value="20">20</option><option value="21">21</option><option value="22">22</option><option value="23">23</option><option value="24">24</option><option value="25">25</option><option value="26">26</option><option value="27">27</option><option value="28">28</option><option value="29">29</option><option value="30">30</option></select>';
    pop_up+='</div><div class="lt weekText repeatEveryText_'+i+'">Day</div><div class="clear"></div></div><div class="row repeatOn"><div class="lt ltField" >Repeat On </div><div class="lt" style="padding-left:2px;">';
    pop_up+='<input id="repeat_no_of_days_'+i+'" name="repeat_no_of_days_'+i+'" type="hidden" value=""/><input id="repeat_days_'+i+'" name="repeat_days_'+i+'" type="hidden" value="0"/>';
    pop_up+='<span  class="lt checkbox"><input id="day1_'+i+'" name="day1_'+i+'" type="hidden" value=""/><a href="javascript:void(0)" title="" class="checkbox_selected_repeat" id="checkbox_selected_repeat_1_'+i+'" onclick="dispCheckRepeat(\'checkbox_selected_repeat\',1,\'Sun\','+i+')" style="display: none" tabindex="10"><img src="/assets/register/checkbox_selected.png" alt=""/></a> <a href="javascript:void(0)" title="" class="checkbox_normal_repeat" id="checkbox_normal_repeat_1_'+i+'" onclick="dispCheckRepeat(\'checkbox_normal_repeat\',1,\'Sun\','+i+')" tabindex="10"><img src="/assets/register/checkbox_normal.png" alt=""/></a> </span><span class="lt checkboxText">S</span>';
    pop_up+='<span  class="lt checkbox"><input id="day2_'+i+'" name="day2_'+i+'" type="hidden" value=""/><a href="javascript:void(0)" title="" class="checkbox_selected_repeat" id="checkbox_selected_repeat_2_'+i+'" onclick="dispCheckRepeat(\'checkbox_selected_repeat\',2,\'Mon\','+i+')" style="display: none" tabindex="11"><img src="/assets/register/checkbox_selected.png" alt=""/></a> <a href="javascript:void(0)" title="" class="checkbox_normal_repeat"  id="checkbox_normal_repeat_2_'+i+'" onclick="dispCheckRepeat(\'checkbox_normal_repeat\',2,\'Mon\','+i+')" tabindex="11"><img src="/assets/register/checkbox_normal.png" alt=""/></a> </span><span class="lt checkboxText">M</span>';
    pop_up+='<span  class="lt checkbox"><input id="day3_'+i+'" name="day3_'+i+'" type="hidden" value=""/><a href="javascript:void(0)" title="" class="checkbox_selected_repeat" id="checkbox_selected_repeat_3_'+i+'" onclick="dispCheckRepeat(\'checkbox_selected_repeat\',3,\'Tue\','+i+')" style="display: none" tabindex="12"><img src="/assets/register/checkbox_selected.png" alt=""/></a> <a href="javascript:void(0)" title="" class="checkbox_normal_repeat" id="checkbox_normal_repeat_3_'+i+'" onclick="dispCheckRepeat(\'checkbox_normal_repeat\',3,\'Tue\','+i+')" tabindex="12"><img src="/assets/register/checkbox_normal.png" alt=""/></a> </span><span class="lt checkboxText">T</span>';
    pop_up+='<span  class="lt checkbox"><input id="day4_'+i+'" name="day4_'+i+'" type="hidden" value=""/><a href="javascript:void(0)" title="" class="checkbox_selected_repeat" id="checkbox_selected_repeat_4_'+i+'" onclick="dispCheckRepeat(\'checkbox_selected_repeat\',4,\'Wed\','+i+')" style="display: none" tabindex="13"><img src="/assets/register/checkbox_selected.png" alt=""/></a> <a href="javascript:void(0)" title="" class="checkbox_normal_repeat" id="checkbox_normal_repeat_4_'+i+'" onclick="dispCheckRepeat(\'checkbox_normal_repeat\',4,\'Wed\','+i+')" tabindex="13"><img src="/assets/register/checkbox_normal.png" alt=""/></a> </span><span class="lt checkboxText">W</span>';
    pop_up+='<span  class="lt checkbox"><input id="day5_'+i+'" name="day5_'+i+'" type="hidden" value=""/><a href="javascript:void(0)" title="" class="checkbox_selected_repeat" id="checkbox_selected_repeat_5_'+i+'" onclick="dispCheckRepeat(\'checkbox_selected_repeat\',5,\'Thu\','+i+')" style="display: none" tabindex="14"><img src="/assets/register/checkbox_selected.png" alt=""/></a> <a href="javascript:void(0)" title="" class="checkbox_normal_repeat" id="checkbox_normal_repeat_5_'+i+'" onclick="dispCheckRepeat(\'checkbox_normal_repeat\',5,\'Thu\','+i+')" tabindex="14"><img src="/assets/register/checkbox_normal.png" alt=""/></a> </span><span class="lt checkboxText">T</span>';
    pop_up+='<span  class="lt checkbox"><input id="day6_'+i+'" name="day6_'+i+'" type="hidden" value=""/><a href="javascript:void(0)" title="" class="checkbox_selected_repeat" id="checkbox_selected_repeat_6_'+i+'" onclick="dispCheckRepeat(\'checkbox_selected_repeat\',6,\'Fri\','+i+')" style="display: none" tabindex="15"><img src="/assets/register/checkbox_selected.png" alt=""/></a> <a href="javascript:void(0)" title="" class="checkbox_normal_repeat" id="checkbox_normal_repeat_6_'+i+'" onclick="dispCheckRepeat(\'checkbox_normal_repeat\',6,\'Fri\','+i+')" tabindex="15"><img src="/assets/register/checkbox_normal.png" alt=""/></a> </span><span class="lt checkboxText">F</span>';
    pop_up+='<span  class="lt checkbox"><input id="day7_'+i+'" name="day7_'+i+'" type="hidden" value=""/><a href="javascript:void(0)" title="" class="checkbox_selected_repeat" id="checkbox_selected_repeat_7_'+i+'" onclick="dispCheckRepeat(\'checkbox_selected_repeat\',7,\'Sat\','+i+')" style="display: none" tabindex="16"><img src="/assets/register/checkbox_selected.png" alt=""/></a> <a href="javascript:void(0)" title="" class="checkbox_normal_repeat" id="checkbox_normal_repeat_7_'+i+'" onclick="dispCheckRepeat(\'checkbox_normal_repeat\',7,\'Sat\','+i+')" tabindex="16"><img src="/assets/register/checkbox_normal.png" alt=""/></a> </span><span class="lt checkboxText">S</span>';
    pop_up+=' <div class="clear"></div> </div><div class="clear"></div> </div> <div class="errorDiv" style="display:none"><div class="lt ltField">&nbsp;</div> <div id="repeat_on_error_'+i+'"></div></div><div class="clear"></div>';
    pop_up+=' <div class="row repeated_by" style="display:none;"><div class="lt ltField">Repeated by</div><div class="lt"><div class="col month"><span class="lt radio"> <input id="month1_'+i+'" name="month1_'+i+'" value="1" type="hidden"/>';
    pop_up+='<a href="javascript:void(0)" title="" class="month_selected_repeat" id="month_selected_repeat_1_'+i+'" onclick="dispCheckMonthlyRepeat(\'month_selected_repeat\',1,'+i+')" tabindex="17"><img src="/assets/create_new_activity/repeat/radio_on.png" alt=""/></a><a href="javascript:void(0)" title="" class="month_normal_repeat" id="month_normal_repeat_1_'+i+'" onclick="dispCheckMonthlyRepeat(\'month_normal_repeat\',1,'+i+')" style="display: none" tabindex="17"><img src="/assets/create_new_activity/repeat/radio_off.png" alt=""/></a></span><span class="lt radioText'+i+'">Day of the month&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>';
    pop_up+=' <span class="lt radio"><input id="month2_'+i+'" name="month2_'+i+'" value="0" type="hidden"/><a href="javascript:void(0)" title="" class="month_selected_repeat" id="month_selected_repeat_2_'+i+'" onclick="dispCheckMonthlyRepeat(\'month_selected_repeat\',2,'+i+')" style="display: none" tabindex="18"><img src="/assets/create_new_activity/repeat/radio_on.png" alt=""/></a><a href="javascript:void(0)" title="" class="month_normal_repeat" id="month_normal_repeat_2_'+i+'" onclick="dispCheckMonthlyRepeat(\'month_normal_repeat\',2,'+i+')" tabindex="18"><img src="/assets/create_new_activity/repeat/radio_off.png" alt=""/></a></span><span class="lt radioText">Day of the week</span>';
    pop_up+=' <div class="clear"></div></div></div><div class="clear"></div></div><div class="row"><div class="lt ltField">Starts On</div><div class="lt"><input type="hidden" value="" class="repeatTextBox" id="started_date_'+i+'" name="started_date" onChange="changed_summary()" />';
    pop_up+=' <input type="text" value="" class="repeatTextBox" id="started_date_disp_'+i+'" disabled /> </div><div class="clear"></div></div> <div class="row"><div class="lt ltField">Ends</div>';
    pop_up+=' <div class="lt"> <div class="col"><span class="lt radio r_value"><input id="r1_'+i+'" name="r1_'+i+'" value="0" type="hidden"/> <a href="javascript:void(0)" title="" class="radio_selected_repeat" id="radio_selected_repeat_1_'+i+'" onclick="dispCheckRepeat(\'radio_selected_repeat\',1,1,'+i+')" tabindex="19"><img src="/assets/create_new_activity/repeat/radio_on.png" alt=""/></a><a href="javascript:void(0)" title="" class="radio_normal_repeat" id="radio_normal_repeat_1_'+i+'" onclick="dispCheckRepeat(\'radio_normal_repeat\',1,1,'+i+')" style="display: none" tabindex="19"><img src="/assets/create_new_activity/repeat/radio_off.png" alt=""/></a></span><span class="lt radioText">Never</span>';
    pop_up+=' <div class="clear"></div></div>  <div class="col"> <span class="lt radio r_value"> <input id="r2_'+i+'" name="r2_'+i+'" value="0" type="hidden"/>';
    pop_up+=' <a href="javascript:void(0)" title="" class="radio_selected_repeat" id="radio_selected_repeat_2_'+i+'" onclick="dispCheckRepeat(\'radio_selected_repeat\',2,1,'+i+')" style="display: none" tabindex="20"><img src="/assets/create_new_activity/repeat/radio_on.png" alt=""/></a><a href="javascript:void(0)" title="" class="radio_normal_repeat" id="radio_normal_repeat_2_'+i+'" onclick="dispCheckRepeat(\'radio_normal_repeat\',2,1,'+i+')" tabindex="20"><img src="/assets/create_new_activity/repeat/radio_off.png" alt=""/></a></span><span class="lt radioText">After&nbsp;&nbsp;&nbsp;</span>';
    pop_up+='    <input type="text" maxlength="10" value="5" class="repeatTextBox afterTextBox" id="after_occ_'+i+'" name="after_occ_'+i+'" onKeyPress="return number(event,'+i+');" onkeyUp="changed_summary('+i+');" onFocus="$(this).css(\'color\',\'#444444\')" tabindex="21"/>';
    pop_up+='  <span class="lt radioText">&nbsp;&nbsp;&nbsp;occurrences</span> <div class="clear"></div> </div> <div class="errorDiv" style="display:none">';
    pop_up+=' <div id="after_occ_error_'+i+'" style="padding:0 0 10px 62px;"></div></div> <div class="col"><span class="lt radio r_value"> <input id="r3_'+i+'" name="r3_'+i+'" value="1" type="hidden" />';
    pop_up+=' <a href="javascript:void(0)" title="" class="radio_selected_repeat" id="radio_selected_repeat_3_'+i+'" onclick="dispCheckRepeat(\'radio_selected_repeat\',3,1,'+i+')" style="display: none" tabindex="22"><img src="/assets/create_new_activity/repeat/radio_on.png" alt=""/></a><a href="javascript:void(0)" title="" class="radio_normal_repeat"  id="radio_normal_repeat_3_'+i+'" onclick="dispCheckRepeat(\'radio_normal_repeat\',3,1,'+i+')" tabindex="22"><img src="/assets/create_new_activity/repeat/radio_off.png" alt=""/></a></span><span class="lt radioText">On&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>';
    pop_up+=' <div class="lt dateDivRepeat">';
    pop_up+=' <input type="text" id="repeat_on_date_'+i+'" name="repeat_on_date_'+i+'" class="rdateTextbox" value="" style="outline: none;" tabindex="23" onChange="changedEndsonDate('+i+');$(this).css(\'color\',\'#444444\');" readonly="readonly" />';
    pop_up+=' <input type="hidden" id="repeat_alt_on_date_'+i+'" name="repeat_alt_on_date_'+i+'" value=""   /></div><div class="clear"></div> </div><div class="errorDiv" style="display:none"><div id="repeat_alt_error_'+i+'"></div> </div></div>';
    pop_up+=' <div class="clear"></div></div><div class="summaryDiv " id="repeat_summary_'+i+'"> <div class="lt ltField">Summary<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></div>';
    pop_up+=' <div class="lt"><span class="lt summaryText "><span id="summary_weekText_'+i+'" class="summary weekText summText">Weekly on Wednesday</span></span> </div><div class="clear"></div>';
    pop_up+='</div> <div class="buttonDiv"> <div class="lt ltField"> &nbsp; </div> <div class="lt"> <a href="javascript:void(0)" tabindex="24" onclick="saveRepeatDiv(\'provider\','+i+')" onkeydown="cancelRepeatKeyDown(event,'+i+')"><img src="/assets/create_new_activity/repeat/save.png" alt="" ></a>';
    pop_up+='<a href="javascript:void(0)" tabindex="25" onClick="cancelRepeatDiv('+i+')" onkeydown="cancelRepeatKeyDown(event,'+i+')"><img src="/assets/create_new_activity/repeat/cancel.png" alt="" ></a>';
    pop_up+=' </div><div class="clear"></div></div> </div> </div></div><div class="repeatContainerBottom"></div> <div class="clear"></div> </div>';
    
    html+='<div class="schedule_rows_outer"  id ="schedule_rows_outer_'+i+'"><table cellspacing="0" cellpadding="0" border="0"><tr><td valign="top"><div class="schedule_rows"><div class="separate_summary"><div class="lt" style="width: 155px;"><div class="dateDiv">';
    html+='<input type="text"  id="dateFormate_1_'+i+'" name="dateFormate_1_'+i+' "  class="dateTextbox" value="" readonly="readonly" style="outline: none;" tabindex="2" onChange="$(this).css(\'color\',\'#444444\');modifyDate('+i+');"/>';
    html+='<input type="hidden" id="date_1_'+i+'" name="date_1_'+i+'" value="" /><input type="hidden"  id="dateFormate_2_'+i+'" value="" /><input type="hidden"  id="date_2_'+i+'" value="" /></div></div>';
    html+='<div class="lt marginLt5" id="multipledate_'+i+'"><div class="multipledate" style="width:350px;"><div class="timStart" id="schedule_start_time_1'+i+'" style="width: 120px;">';
    html+='<select  id="schedule_stime_1_'+i+'" name="schedule_stime_1_'+i+'" size="1" tabindex="2" class="drop_down_left width_set3" onkeyup="callSummay('+i+')" onChange="callSummay('+i+')">';
    html+='<option value="01:00">01:00</option><option value="01:15">01:15</option><option value="01:30">01:30</option><option value="01:45">01:45</option><option value="02:00">02:00</option><option value="02:15">02:15</option><option value="02:30">02:30</option><option value="02:45">02:45</option><option value="03:00">03:00</option><option value="03:15">03:15</option><option value="03:30">03:30</option><option value="03:45">03:45</option><option value="04:00">04:00</option><option value="04:15">04:15</option><option value="04:30">04:30</option><option value="04:45">04:45</option><option value="05:00">05:00</option><option value="05:15">05:15</option><option value="05:30">05:30</option><option value="05:45">05:45</option><option value="06:00">06:00</option><option value="06:15">06:15</option><option value="06:30">06:30</option><option value="06:45">06:45</option><option value="07:00">07:00</option><option value="07:15">07:15</option><option value="07:30">07:30</option><option value="07:45">07:45</option><option value="08:00">08:00</option><option value="08:15">08:15</option><option value="08:30">08:30</option><option value="08:45">08:45</option><option value="09:00" selected="selected">09:00</option><option value="09:15">09:15</option><option value="09:30">09:30</option><option value="09:45">09:45</option><option value="10:00">10:00</option><option value="10:15">10:15</option><option value="10:30">10:30</option><option value="10:45">10:45</option><option value="11:00">11:00</option><option value="11:15">11:15</option><option value="11:30">11:30</option><option value="11:45">11:45</option><option value="12:00">12:00</option><option value="12:15">12:15</option><option value="12:30">12:30</option><option value="12:45">12:45</option></select>';
    html+='&nbsp;<select  id="schedule_stime_2_'+i+'" name="schedule_stime_2_'+i+'" size="1" tabindex="3" class="drop_down_left width_set3" onkeyup="callSummay('+i+')" onChange="callSummay('+i+')" style="width: 45px;"><option value="AM" selected="selected">AM</option><option value="PM" >PM</option></select> </div>'  ;
    html+='<div class="timStart" id="schedule_end_time_1_'+i+'" style="width: 120px;"><select  id="schedule_etime_1_'+i+'" name="schedule_etime_1_'+i+'" size="1" tabindex="4" class="drop_down_left width_set3" onkeyup="callSummay('+i+')" onChange="callSummay('+i+')">';
    html+='<option value="01:00">01:00</option><option value="01:15">01:15</option><option value="01:30">01:30</option><option value="01:45">01:45</option><option value="02:00">02:00</option><option value="02:15">02:15</option><option value="02:30">02:30</option><option value="02:45">02:45</option><option value="03:00">03:00</option><option value="03:15">03:15</option><option value="03:30">03:30</option><option value="03:45">03:45</option><option value="04:00">04:00</option><option value="04:15">04:15</option><option value="04:30">04:30</option><option value="04:45">04:45</option><option value="05:00">05:00</option><option value="05:15">05:15</option><option value="05:30">05:30</option><option value="05:45">05:45</option><option value="06:00" selected="selected">06:00</option><option value="06:15">06:15</option><option value="06:30">06:30</option><option value="06:45">06:45</option><option value="07:00">07:00</option><option value="07:15">07:15</option><option value="07:30">07:30</option><option value="07:45">07:45</option><option value="08:00">08:00</option><option value="08:15">08:15</option><option value="08:30">08:30</option><option value="08:45">08:45</option><option value="09:00">09:00</option><option value="09:15">09:15</option><option value="09:30">09:30</option><option value="09:45">09:45</option><option value="10:00">10:00</option><option value="10:15">10:15</option><option value="10:30">10:30</option><option value="10:45">10:45</option><option value="11:00">11:00</option><option value="11:15">11:15</option><option value="11:30">11:30</option><option value="11:45">11:45</option><option value="12:00">12:00</option><option value="12:15">12:15</option><option value="12:30">12:30</option><option value="12:45">12:45</option></select>';
    html+='&nbsp;<select id="schedule_etime_2_'+i+'" name="schedule_etime_2_'+i+'" size="1" tabindex="5" class="drop_down_left width_set3" onkeyup="callSummay('+i+')" onChange="callSummay('+i+')" style="width: 45px;"><option value="AM">AM</option><option value="PM" selected="selected">PM</option></select></div>';
    html+='<div class="_repeat"><input type="hidden" name="repeatCheck_'+i+'" id="repeatCheck_'+i+'" value="" />';
    html+='<span  class="lt checkbox setstyle" style="margin-right:0px;"> <a href="javascript:void(0)" title="" class="checkbox_selected_s" id="checkbox_selected_s1_'+i+'" onclick="dispCheck(\'checkbox_selected\',' +i+')" style="display: none" tabindex="6"><img src="/assets/register/checkbox_selected.png" alt=""/></a> <a href="javascript:void(0)" title="" class="checkbox_normal_s" id="checkbox_normal_s1_'+i+'" onclick="dispCheck(\'checkbox_normal\','+i+')" tabindex="6"><img src="/assets/register/checkbox_normal.png" alt=""/></a> </span>';
    html+='<span class="lt"><a style="display:none;position:relative;top:6px;left:3px;right:5px;" tabindex="7" onclick="disp_edit('+i+')" id="repeatEdit_'+i+'" title="Edit Repeat" href="javascript:void(0)"><img width="29" height="26" align="absbottom" alt="" src="/assets/provider_event_list/edit_icon.png"></a></span>';
    html+='<span class="lt repeatTest ftSz13Clr">Repeat</span></div><div class="clear"></div></div><div class="clear"></div></div>';
    html+='<div class="lt leader"><input type="text" name="participant_'+i+'" id="participant_'+i+'" value="Specify Number" maxlength="4" onkeypress="return number(event);" onfocus="if(this.value==\'Specify Number\'){this.value=\'\';this.style.color=\'#444444\'}"  onblur="if(this.value==\'\'){this.value=\'Specify Number\';this.style.color=\'#999999\'}" class="leaders"></div>';

    if(d==0){
        delete_schedules='<div class="delete_schedule"  id="delete_schedule_'+i+'" onclick="delete_schedule('+i+')">';
    }
    else{
        delete_schedules='<div class="delete_schedule"  id="delete_schedule_'+i+'" onclick="delete_the_schedules('+i+')">';
    }
    //html+='<div class="lt leader"><input type="text" name="leader_'+i+'" id="leader_'+i+'" value="Enter Leader" onfocus="if(this.value==\'Enter Leader\'){this.value=\'\';this.style.color=\'#444444\'}"  onblur="if(this.value==\'\'){this.value=\'Enter Leader\';this.style.color=\'#999999\'}" class="leaders"></div><div class="lt location"><select name="location_'+i+'" id="location_'+i+'" class="locations" onchange="activity_location('+i+',this.value);$(\'#location_'+i+'\').css(\'color\',\'#444444\');"><option value="" selected="selected">--Choose Location--</option><option value="new">Create New Location</option></select></div><div class="clear"></div>';
    html+='</div><div class="clear"></div>'+pop_up;
    html+='<div class="clear"></div><div class="errorDiv" style="display:none;margin-top:0;"><div class="lt" id="schedule_time_error_'+i+'"></div><div class="clear"></div></div><div class="clear"></div><div class="new_summary" id="schedule_summary_'+i+'" style="display:none;"><div class="lt" style="border-top:none"><span class="lt">Summary&nbsp;&nbsp;:&nbsp;&nbsp;</span><div class="lt"><div class="outSummary" id="dateSummay"></div><div class="outSummary" id="repeat_summary_text" style="display:none;"><span id="repeatText">Repeats&nbsp;</span><span  id="summary_occur_'+i+'"class="summary"></span></div><div class="clear"></div></div><div class="clear"></div></div></div>';
    html+='</div></div></div></td><td valign="bottom">'+delete_schedules+'&nbsp;</div><div class="add_schedule" id="add_schedule_'+i+'" onclick="validate_schedule('+i+',0,'+d+')">&nbsp;</div></td></tr></table>';

    $( "#schedule_table" ).append(html);
    if(i==1){
	
    //	$('#delete_schedule_1').css("display","none");
    }
    current_dates_schdule(i);
    $('#sc_chk_flag').val('1');
    arr1 = arr.split(',');
    arr1.pop();
mySchedule=arr1;
    $('#schedule_tabs').val(arr1);
    
    
    /*///////////////*/
     
     
    if(mySchedule.length>1)// if more than one div and less thhan schedule
    {
        for(i=0;i<(mySchedule.length);i++)
        {
            $("#add_schedule_"+mySchedule[i]).css("display","none");
            $("#delete_schedule_"+mySchedule[i]).css("display","block");
            $("#add_schedule_"+mySchedule[mySchedule.length-1]).css("display","block");
							
        }

    }
									

    else			// if only one schedule
    {
        $("#add_schedule_1").css("display","block");
        $("#delete_schedule_1").css("display","none");

    }
/* ///////////*/
} 
/*********************************************
		DELETE  Schedule
**********************************************/
function delete_schedule(v)
{
	
    v= v.toString();
    var ar=$('#schedule_tabs').val();
    var ar1=ar.split(',');
    var n= jQuery.inArray(v, ar1);
    ar1.splice(n, 1);
    var y=ar1[ar1.length-1];
    $('#schedule_tabs').val(ar1);
    
    $( "#schedule_rows_outer_"+v ).remove();
    /* if(y=="")
     //   $( "#add_schedule_1").css("display","block");
    else
   //     $( "#add_schedule_"+y ).css("display","block");
    
   // $('#delete_schedule_1').css("display","block");
    if(ar1.length<2){
     //   $('#delete_schedule_'+ar1[0]).css("display","none");
    }*/
    //delete schedule in sep2 remove that schedule in 3rd step also  nov4
    //netprice
	
	
    s=$('#total_div_count').val();
    s1=s.split(',');
    s2=s.split(',');
    selected_id = '';
    for(var i=0; i<s1.length; i++)
    {
		
        sc_val=$('#chosen_sc_'+s1[i]).val();
        if(v==sc_val)
        {
            t=s1[i].split('_');
            $('#netPriceDiv_'+t[0]).remove();
            s2.splice($.inArray(s1[i], s2), 1 );
        }
        else
        {
            if(selected_id!='')
            {
                selected_id = selected_id +','+s1[i];
            }
            else
            {
                selected_id = s1[i];
            }
        }
    }

    $('#total_div_count').val(selected_id);
    if(selected_id=='')
    {
        $('#total_div_count').val('1_1');
        $('#net_continue_sc').val(0);
        $('#net_continue_wsc').val(0);
        validate_notes_netprice(0,0);
    }
    //Advance price
    as=$('#total_outer_div').val();
    as1=as.split(',');
    as2=as.split(',');
    aselected_id = '';
    for(var i=0; i<as1.length; i++)
    {
        asc_val=$('#chosen_ad_sc_'+as1[i]).val();
        if(v==asc_val)
        {
            t=as1[i].split('_');
            $('#priceContainerDiv_'+t[0]).remove();
            as2.splice($.inArray(as1[i], as2), 1 );
        }
        else
        {
            if(aselected_id!='')
            {
                aselected_id = aselected_id +','+as1[i];
            }
            else
            {
                aselected_id = as1[i];
            }
        }
    }
    $('#total_outer_div').val(aselected_id);
    if(aselected_id=='')
    {
        $('#total_outer_div').val('1_1');
        $('#adv_continue_sc').val(0);
        $('#adv_continue_wsc').val(0);
        validate_notes_adprice(0);
    }
    /*nov4*/
    for(i=0;i<mySchedule.length;i++)//indexof property not works ie<9 browsers .so removal divs like this
    {
        if(mySchedule[i]==v)
        {
						
            mySchedule.splice(i,1);
        // $("#choose_schedule_net_"+myNetdiv[myNetdiv.length-1]+"_1").append('<option  value="' + deleted_schedule + '">' +deleted_schedule+ '</option>'); //apend to the open dropdwon
        }
						
    }
    if(mySchedule.length>1)// if more than one div and less thhan schedule
    {
        for(i=0;i<(mySchedule.length);i++)
        {
            $("#add_schedule_"+mySchedule[i]).css("display","none");
            $("#delete_schedule_"+mySchedule[i]).css("display","block");
            $("#add_schedule_"+mySchedule[mySchedule.length-1]).css("display","block");
							
        }

    }
									

    else			// if only one schedule
    {
        $("#add_schedule_"+mySchedule[mySchedule.length-1]).css("display","block");
        $("#delete_schedule_"+mySchedule[mySchedule.length-1]).css("display","none");

    }
}



function delete_schedule_olds(v)

{
	
    v= v.toString();
    var ar=$('#schedule_tabs').val();
    var ar1=ar.split(',');
    var n= jQuery.inArray(v, ar1);
    ar1.splice(n, 1);
    var y=ar1[ar1.length-1];
    $('#schedule_tabs').val(ar1);
    if(y=="")
        $( "#add_schedule_1").css("display","block");
    else
        $( "#add_schedule_"+y ).css("display","block");
    $( "#schedule_rows_outer_"+v ).remove();
    $('#delete_schedule_1').css("display","block");
    if(ar1.length<2){
        $('#delete_schedule_'+ar1[0]).css("display","none");
    }
    remove_sc=$('#total_div_count').val()
    remove_sc=remove_sc.split(',');
			        
    var schedulesw12='';
    var ar3='';
    var r_val='';
    var ar21='';
    // removing the schedule for netprice from 2nd step and if it deleted already in third /or not
    for(var c=0; c<remove_sc.length;c++)
    {
        if($('#chosen_sc_'+remove_sc[c]).val()!=''){
            ar3+=$('#chosen_sc_'+remove_sc[c]).val()+',';
        }
    }
    ar3=ar3.slice(0,-1);
    ar3=ar3.split(',');
					        
    var index1 = ar3.indexOf(v);
    if(index1!=-1)
    {
						        
        delete_net_price(v,1);
    }
    else{
						        
						        
        var delete_sche_dule=$('#changing_schedule_net').val();
        var delt=delete_sche_dule.split("</br>");
						        
        for(w=0;w<delt.length;w++)
        {
            var arrays=delt[w].split('_');
            r_val+=arrays[1]+',';
        /*    if(v==arrays[1])
									        {
									           delt.splice(w, 1);
									        }*/
        }
        r_val=r_val.slice(0,-1);
        var indexr = r_val.indexOf(v);
								        
        if(indexr>-1)
        {
            delt.splice(indexr, 1);
								        
        }
        for(w=0;w<delt.length;w++){
            if(w!=(delt.length-1)){
                schedulesw12+=delt[w]+'</br>';
            }
            else{
                schedulesw12+=delt[w];
            }
        }
								        
        $('#changing_schedule_net').val(schedulesw12);
    }
					        
				        
					        
    // removing the schedule for netprice from 2nd step and if itdeleted already in third /or not ends
				        
    // removing the schedule for advprice from 2nd step and if itdeleted already in third /or not
    var r_val1='';
    adv_remove_sc=$('#total_outer_div').val()
				        
    adv_remove_sc=adv_remove_sc.split(',');
				        
    for(var c=0; c<adv_remove_sc.length;c++)
    {
        if($('#chosen_ad_sc_'+adv_remove_sc[c]).val()!=''){
            ar21+=$('#chosen_ad_sc_'+adv_remove_sc[c]).val()+',';
        }
    }
			        
    ar21=ar21.slice(0,-1);
    ar21=ar21.split(',');
					        
						        
    var index12 = ar21.indexOf(v);
					         
    if(index12!=-1)
    {
        delete_ad_net_price(v,1 );
    }
    else{
						        
        var delete_sche_dule1=$('#changing_schedule_adv').val();
						        
        var delt=delete_sche_dule1.split("</br>");
						        
						        
        for(w=0;w<delt.length;w++)
        {
            var arrays2=delt[w].split('_');
            r_val1+=arrays2[1]+',';
								        
        }
								        
								        
								        
        r_val1=r_val1.slice(0,-1);
        var indexr1 = r_val1.indexOf(v);
							        
        if(indexr1>-1)
        {
            delt.splice(indexr1, 1);
								        
        }
        for(w=0;w<delt.length;w++){
            if(w!=(delt.length-1)){
                schedulesw12+=delt[w]+'</br>';
            }
            else{
                schedulesw12+=delt[w];
            }
        }
							        
        $('#changing_schedule_adv').val(schedulesw12);
    }
					        
    // removing the schedule for advprice from 2nd step and if itdeleted already in third /or not ends
				        
					        
    // remove the schedule from base field of net price
    var byt=$('#changing_schedule_net_base').val();
    var schedulesw102='';
    byt=byt.split("</br>");
					        
    for(u=0;u<byt.length;u++)
    {
        var arrays1=byt[u].split('_');
        if(v==arrays1[1])
        {
									        
            byt.splice(u, 1);
        }
						        
    }
					        
					        
    for(w=0;w<byt.length;w++){
        if(w!=(byt.length-1)){
            schedulesw102+=byt[w]+'</br>';
        }
        else{
            schedulesw102+=byt[w];
        }
    }
					        
    $('#changing_schedule_net_base').val(schedulesw102);
					        
    // remove the schedule from base field of adv price
    var byt=$('#changing_schedule_adv_base').val();
    var schedulesw103='';
    byt=byt.split("</br>");
				        
    for(u=0;u<byt.length;u++)
    {
        var arrays1=byt[u].split('_');
        if(v==arrays1[1])
        {
								        
            byt.splice(u, 1);
        }
						        
    }
				        
					        
    for(w=0;w<byt.length;w++){
        if(w!=(byt.length-1)){
            schedulesw103+=byt[w]+'</br>';
        }
        else{
            schedulesw103+=byt[w];
        }
    }
					        
    $('#changing_schedule_adv_base').val(schedulesw103);
    // remove the open select box if removing schedule from second step
    //var last_openid=$("#netPriceDiv select.choose_schedule").attr("id"):last;
    var last_openid=$("#total_div_count").val();
    last_openid=last_openid.split(',');
    var lk=last_openid[(last_openid.length)-1];
    var last_chosen_sc=$("#chosen_sc_"+lk).val();
				        
					        
    last_id= lk.split('_');
					        
    if(last_chosen_sc==''){
									      
        delete_net_price(last_id[0],'1');
								      
    }
    //  var last_openid1=$("#advancedPriceDiv select.choose_schedule").attr("id");
    var last_openid1=$("#total_outer_div").val();
    last_openid1=last_openid1.split(',');
    var lk1=last_openid1[(last_openid1.length)-1];
    var last_chosen_ad_sc=$("#chosen_ad_sc_"+lk1).val();
					        
					        
    last_id1= lk1.split('_');
					        
    if(last_chosen_ad_sc==''){
        //last_openid1= last_openid1.split('_');
						      
        delete_ad_net_price(last_id1[0],'1');
							        
    }
					        
		
//$( ".delete_schedule" ).last().css("display","none");
}
/*********************************************
	        VALIDATE Whole Day
**********************************************/
/*********************same schedule checking for same day or multiple day start*********************/

function same_schedule_check_process_for_multiple(x)

{
    var msg2='';
    whole_day_tabs=$('#whole_day_tabs').val();
    whole_day_tabs=whole_day_tabs.split(',');

    wday_1=$('#wday_1_'+x).val();
    wday_2=$('#wday_2_'+x).val();
    if(wday_1==1)
    {
		
	
        datestartwhole_alt_11=$('#datestartwhole_alt_1_'+x).val();
        var select_box11='whole_stime_1_'+x;
        var e11 = document.getElementById(select_box11);
        var strSelected11 = e11.options[e11.selectedIndex].value;
        var select_box21='whole_stime_1_'+x;
        var e21 = document.getElementById(select_box21);
        var strSelected21 = e21.options[e21.selectedIndex].value;
        var select_box31='whole_etime_1_'+x;
        var e31= document.getElementById(select_box31);
        var strSelected31 = e31.options[e31.selectedIndex].value;
        var select_box41='whole_etime_1_'+x;
        var e41= document.getElementById(select_box41);
        var strSelected41 = e41.options[e41.selectedIndex].value;
    }
	
    else if(wday_2==1){
		                                                                                                                        
        datestcamps_11=$('#datestcamps_1_'+x).val();
        dateendcamps_21=$('#dateendcamps_2_'+x).val();
        var select_box11='camps_stime_1_'+x;
        var e11 = document.getElementById(select_box11);
        var strSelected11 = e11.options[e11.selectedIndex].value;
        var select_box21='camps_stime_2_'+x;
        var e21 = document.getElementById(select_box21);
        var strSelected21 = e21.options[e21.selectedIndex].value;
        var select_box31='camps_etime_1_'+x;
        var e31= document.getElementById(select_box31);
        var strSelected31 = e31.options[e31.selectedIndex].value;
        var select_box41='camps_etime_2_'+x;
        var e41= document.getElementById(select_box41);
        var strSelected41 = e41.options[e41.selectedIndex].value;
    }
	
	
	
	
    if(whole_day_tabs.length>1){
	
        for(var i=0; i<whole_day_tabs.length-1;i++){
				
            wday_11=$('#wday_1_'+whole_day_tabs[i]).val();
            wday_21=$('#wday_2_'+whole_day_tabs[i]).val();
            if(wday_11==1)
            {
				
                datestartwhole_alt_1=$('#datestartwhole_alt_1_'+whole_day_tabs[i]).val();
                var select_box11='whole_stime_1_'+whole_day_tabs[i];
                var e11 = document.getElementById(select_box11);
                var strSelected1 = e11.options[e11.selectedIndex].value;
                var select_box21='whole_stime_1_'+whole_day_tabs[i];
                var e21 = document.getElementById(select_box21);
                var strSelected2 = e21.options[e21.selectedIndex].value;
                var select_box31='whole_etime_1_'+whole_day_tabs[i];
                var e31= document.getElementById(select_box31);
                var strSelected3 = e31.options[e31.selectedIndex].value;
                var select_box41='whole_etime_1_'+whole_day_tabs[i];
                var e41= document.getElementById(select_box41);
                var strSelected4 = e41.options[e41.selectedIndex].value;
                if((strSelected11==strSelected1)&&(strSelected21==strSelected2)&&(strSelected31==strSelected3)&&(strSelected41==strSelected4)&&(datestartwhole_alt_11==datestartwhole_alt_1))
                {
						
							  
				
                    var is_aded='1';
					
                    break;
						
                }
                else	{
                    var is_aded='0';
						
                }
					
			
            }
				
            else if(wday_21==1){
					
                datestcamps_1=$('#datestcamps_1_'+whole_day_tabs[i]).val();
                dateendcamps_2=$('#dateendcamps_2_'+whole_day_tabs[i]).val();
                var select_box11='camps_stime_1_'+whole_day_tabs[i];
                var e11 = document.getElementById(select_box11);
                var strSelected1 = e11.options[e11.selectedIndex].value;
                var select_box21='camps_stime_2_'+whole_day_tabs[i];
                var e21 = document.getElementById(select_box21);
                var strSelected2 = e21.options[e21.selectedIndex].value;
                var select_box31='camps_etime_1_'+whole_day_tabs[i];
                var e31= document.getElementById(select_box31);
                var strSelected3 = e31.options[e31.selectedIndex].value;
                var select_box41='camps_etime_2_'+whole_day_tabs[i];
                var e41= document.getElementById(select_box41);
                var strSelected4 = e41.options[e41.selectedIndex].value;
					
                if((strSelected11==strSelected1)&&(strSelected21==strSelected2)&&(strSelected31==strSelected3)&&(strSelected41==strSelected4)&&(datestcamps_11==datestcamps_1)&&(dateendcamps_2==dateendcamps_21))
                {
                    var is_aded='1';
                    break;
						
                }
                else	{
                    var is_aded='0';
						
                }
					
            }
        }
        var wd= whole_day_tabs[whole_day_tabs.length-1]
        if((is_aded=='1')&&(wd==x)){
            var r=confirm("do you want to add the same  day schedule again?");
            if (r==true)
            {
                var msg3='';
							
            }
            else
            {
                var msg3='1';
            }
            msg2+=msg3;
					
        }
    }
	
    /*var participant=$("#participant_"+x).val();
	
		if(participant!="Specify Number" ){	
		
			if(isNaN(participant) ){
				$('#participant_'+x).css('border','1px solid #fc8989');
				if(msg2=='')
					msg2 += 'Please enter valid participant number';
				else
					msg2 += 'Please enter valid participant number';		
			}
			else{
				$('#participant_'+x).css('border','1px solid #CDE0E6');
			}
		}*/
    return msg2;
}

/*********************same schedule checking for same day or multiple day end*********************/
function validate_whole_day_block(x,y,opt){
    
    var msg1="";
    var msg2="";
    var retVal ="";
    var selectedDay="";

    var wday_1 = $("#wday_1_"+x).val();
    var wday_2 = $("#wday_2_"+x).val();
	
    var camps_stime_1 = $('#camps_stime_1_'+x).val();
    $('#camps_stime_1_'+x).css('border','1px solid #CDE0E6');
    var camps_stime_2 = $('#camps_stime_2_'+x).val();
    var camps_etime_1 = $('#camps_etime_1_'+x).val();
    $('#camps_etime_1_'+x).css('border','1px solid #CDE0E6');
    var camps_etime_2 = $('#camps_etime_2_'+x).val();
    var camps_start = $('#datestcamps_1_'+x).val();
    var camps_end = $('#dateencamps_2_'+x).val();
	
    $("#multiple_days_error_"+x).html("");
    $("#multiple_days_error_"+x).parent().css("display","none");

    var whole_stime_1 = $('#whole_stime_1_'+x).val();
    $('#whole_stime_1_'+x).css('border','1px solid #CDE0E6');
    var whole_stime_2 = $('#whole_stime_2_'+x).val();
    var whole_etime_1 = $('#whole_etime_1_'+x).val();
    $('#whole_etime_1_'+x).css('border','1px solid #CDE0E6');
    var whole_etime_2 = $('#whole_etime_2_'+x).val();
	
    $("#single_day_error_"+x).html("");
    $("#single_day_error_"+x).parent().css("display","none");
	
    var split_camps_stime_1 = camps_stime_1.split(":");
    var split_camps_etime_1 = camps_etime_1.split(":");

    var scamps_1 = split_camps_stime_1[0];
    var scamps_2 = split_camps_stime_1[1];

    var ecamps_1 = split_camps_etime_1[0];
    var ecamps_2 = split_camps_etime_1[1];

    var split_whole_stime_1 = whole_stime_1.split(":");
    var split_whole_etime_1 = whole_etime_1.split(":");

    var swhole_1 = split_whole_stime_1[0];
    var swhole_2 = split_whole_stime_1[1];

    var ewhole_1 = split_whole_etime_1[0];
    var ewhole_2 = split_whole_etime_1[1];
	
    msg1="Please ";
    msg2="";
    ///////
	
    /////////
    if(wday_2 == 1){
        selectedDay="multiple";
        if(camps_start == camps_end){
            if(scamps_1 == ecamps_1 && scamps_2 >= ecamps_2 && camps_stime_2 == camps_etime_2){
                $('#camps_stime_1_'+x).css('border','1px solid #fc8989');
                $('#camps_etime_1_'+x).css('border','1px solid #fc8989');
                msg2 += 'select valid time';
				
            }
            if( scamps_1 > ecamps_1 && scamps_1 != 12 && ecamps_1 != 12 && camps_stime_2==camps_etime_2){
                $('#camps_stime_1_'+x).css('border','1px solid #fc8989');
                $('#camps_etime_1_'+x).css('border','1px solid #fc8989');
                msg2 += 'select valid time';
            }
            if( ( ( (scamps_1 > 0 && scamps_1 != 12) &&  ecamps_1 == 12 && ( camps_stime_2 == camps_etime_2 ) ) || ( scamps_1 == 12 && ecamps_1 > 12 )) ){
                $('#camps_stime_1_'+x).css('border','1px solid #fc8989');
                $('#camps_etime_1_'+x).css('border','1px solid #fc8989');
                msg2 += 'select valid time';
            }
	    
        }
	
        var participant_=$('#mul_day_participants_1_'+x).val();

        participant_=parseInt(participant_);
        if(participant_==0)
        {
				
            msg4=' enter valid participants number';
        }
        else{
            msg4='';
        }
        if(msg2!=''||msg4!=""){
            if(msg2!=''){
                $("#multiple_days_error_"+x).html(msg1+msg2);
                $("#multiple_days_error_"+x).parent().css("display","block");
                retVal="f";

            }
            else if(msg4!=''){
                $(".schedule_time_app_error_1").css("display","none");
			
                $("#schedule_time_app_error_1_"+x).css("display","block");
                $("#schedule_time_app_error_1_"+x).css("margin-left","0px");
                $("#schedule_time_app_error_1_"+x).html(' enter valid participants number');
                msg2+=msg4;
            }
        }
			
       
        else
            retVal="t";
    }
    if(wday_1 == 1){
        selectedDay="single";
        if(swhole_1 == ewhole_1 && swhole_2 >= ewhole_2 && whole_stime_2 == whole_etime_2){
            $('#whole_stime_1_'+x).css('border','1px solid #fc8989');
            $('#whole_etime_1_'+x).css('border','1px solid #fc8989');
            msg2 += 'select valid time';
        }
        if( swhole_1 > ewhole_1 && swhole_1 != 12 && ewhole_1 != 12 && whole_stime_2==whole_etime_2){
            $('#whole_stime_1_'+x).css('border','1px solid #fc8989');
            $('#whole_etime_1_'+x).css('border','1px solid #fc8989');
            msg2 += 'select valid time';
        }
        if( ( ( (swhole_1 > 0 && swhole_1 != 12) &&  ewhole_1 == 12 &&  ( whole_stime_2 == whole_etime_2 ) ) || ( swhole_1 == 12 && ewhole_1 > 12 )) ){
            $('#whole_stime_1_'+x).css('border','1px solid #fc8989');
            $('#whole_etime_1_'+x).css('border','1px solid #fc8989');
            msg2 += 'select valid time';
        }
        var participant_=$('#single_day_participants_1_'+x).val();

        participant_=parseInt(participant_);
				
        if(participant_==0)
        {
				
            msg4=' enter valid participants number';
        }
        else{
            msg4='';
        }
        if(msg2!=''||msg4!=""){
            if(msg2!=''){
                $("#single_day_error_"+x).html(msg1+msg2);
                $("#single_day_error_"+x).parent().css("display","block");

            }
            else if(msg4!=''){
                $(".schedule_time_app_error_2").css("display","none");
                $("#schedule_time_app_error_2_"+x).css("display","block");
                $("#schedule_time_app_error_2_"+x).css("margin-left","0px");
                $("#schedule_time_app_error_2_"+x).html(' enter valid participants number');
                msg2+=msg4;
            }
        }
        else
            retVal="t";
    }
    if(y!=1 && opt!='db'){
        var msg5=same_schedule_check_process_for_multiple(x);
      
        msg2+=msg5;
    }
    if( msg2!='')
    {
        retVal="f";
		
    }
    else{
        retVal="t";
    }
    
    if(opt=="validation"){
        return retVal;
    }
    else{
        if(retVal=="t"){
            $(".schedule_time_app_error_1").css("display","none");
            $(".schedule_time_app_error_2").css("display","none");
            add_whole_day_block(x,selectedDay,opt);
        }
    }

}
/*********************************************
	           ADD Whole day
**********************************************/
var j=1;
function add_whole_day_block(j,selectedDay,opt){
	
    j++;
    var arr= '';
    var ahtml=' ';
    arry=$('#whole_day_tabs').val();
    if(j!=1){
        arr+=arry+',';
    }
    arr+=j+',';
    
    
    $( "#add_whole_day_"+j).css("display","block");
	
    $( ".add_whole_day").css("display","none");

    ahtml+='<div id="outer_whole_day_'+j+'"><div class="lt leftSideField">&nbsp;</div><table cellpadding="0" cellspacing="0" border="0"><tr><td valign="top"><div id="outer_whole_day"><div id=" whole_day_'+j+'"><div class="lt setBlueBG" id="camps_date_time" style="margin-top:5px;padding-bottom:8px;"><div class="daysRow" id="daysRow_'+j+'"><input id="wday_1_'+j+'" name="wday_1_'+j+'" value="1" type="hidden" />';
    ahtml+='<a href="javascript:void(0)" title="" class="lt price_Checkbox radio_selected_day_'+j+'" id="radio_selected_day_1_'+j+'" onclick="dispCheckDays(\'radio_normal_day\',1,'+j+')" tabindex="67"><img src="/assets/create_new_activity/repeat/radio_on.png" alt=""/>';
    ahtml+='</a><a href="javascript:void(0)" title="" class="lt price_Checkbox radio_normal_day_'+j+'"  id="radio_normal_day_1_'+j+'" onclick="dispCheckDays(\'radio_normal_day\',1,'+j+')" tabindex="67" style="display: none"  >';
    ahtml+='<img src="/assets/create_new_activity/repeat/radio_off.png" alt=""/></a><span class="lt priceTt">Single Day</span><input id="wday_2_'+j+'" name="wday_2_'+j+'" value="0" type="hidden" />';
    ahtml+='<a href="javascript:void(0)" title="" class="lt price_Checkbox radio_selected_day_'+j+'" id="radio_selected_day_2_'+j+'" onclick="dispCheckDays(\'radio_normal_day\',2,'+j+')" style="display: none"  tabindex="68"><img src="/assets/create_new_activity/repeat/radio_on.png" alt=""/></a><a href="javascript:void(0)" title="" class="lt price_Checkbox radio_normal_day_'+j+'"  id="radio_normal_day_2_'+j+'" onclick="dispCheckDays(\'radio_normal_day\',2,'+j+')" tabindex="68">';
    ahtml+='<img src="/assets/create_new_activity/repeat/radio_off.png" alt=""/></a><span class="lt priceTt">Multiple Days</span><div class="clear"></div></div><div class="clear"></div>';
	
    ahtml+='<div style="width: 545px;display:none;" id="multipleDays_'+j+'"><div class="CalenderDiv" style="width:280px;"><div class="StrtTxt" style="width:88px;">Start Date</div>';
    ahtml+='<div class="StrtDte"><div class="dateDiv CampsStartDateDiv" id="CampsDateDiv" style="height:27px; padding: 2px 5px 0;">';
    ahtml+='<input type="text"  id="datestartcamps_1_'+j+'" name="datestartcamp_1_'+j+'" class="dateTextbox" value="" readonly="readonly" tabindex="69" onChange="$(this).css(\'color\',\'#444444\');summary_date_time_changes('+j+');"/>';
    ahtml+='<input type="hidden" id="datestcamps_1_'+j+'" name="datestcamps_1_'+j+'" value=""/></div><div class="clear"></div></div>';
    ahtml+='<div><div class="StrtTxt" style="width:88px;">End Date</div>';
    ahtml+='<div class="StrtDte" style="margin-bottom:0;"><div class="dateDiv CampsEndDateDiv" id="CampsDateDiv" style="height:27px; padding: 2px 5px 0;"><input type="text"  id="dateendcamps_2_'+j+'" name="dateendcamp_2_'+j+'" class="dateTextbox" value="" readonly="readonly" tabindex="70" onChange="$(this).css(\'color\',\'#444444\');summary_date_time_changes('+j+')"/>';
    ahtml+='<input type="hidden" id="dateencamps_2_'+j+'" name="dateencamps_2_'+j+'" value=""/></div></div><div class="clear"></div> </div></div> <div class="lt"><div> <div class="StrtTxt" style="width: 70px;">Start Time </div>';
    ahtml+=' <div class="timStart" style="width: 140px;margin-top: 0px;"><select  id="camps_stime_1_'+j+'" name="camps_stime_1_'+j+'" size="1" tabindex="71" class="drop_down_left width_set3" onkeyup="summary_date_time_changes('+j+')" onChange="summary_date_time_changes('+j+')">';
    ahtml+='<option value="01:00">01:00</option><option value="01:15">01:15</option><option value="01:30">01:30</option><option value="01:45">01:45</option><option value="02:00">02:00</option><option value="02:15">02:15</option><option value="02:30">02:30</option><option value="02:45">02:45</option><option value="03:00">03:00</option><option value="03:15">03:15</option><option value="03:30">03:30</option><option value="03:45">03:45</option><option value="04:00">04:00</option><option value="04:15">04:15</option><option value="04:30">04:30</option><option value="04:45">04:45</option><option value="05:00">05:00</option><option value="05:15">05:15</option><option value="05:30">05:30</option><option value="05:45">05:45</option><option value="06:00">06:00</option><option value="06:15">06:15</option><option value="06:30">06:30</option><option value="06:45">06:45</option><option value="07:00">07:00</option><option value="07:15">07:15</option><option value="07:30">07:30</option><option value="07:45">07:45</option><option value="08:00">08:00</option><option value="08:15">08:15</option><option value="08:30">08:30</option><option value="08:45">08:45</option><option value="09:00" selected="selected">09:00</option><option value="09:15">09:15</option><option value="09:30">09:30</option><option value="09:45">09:45</option><option value="10:00">10:00</option><option value="10:15">10:15</option><option value="10:30">10:30</option><option value="10:45">10:45</option><option value="11:00">11:00</option><option value="11:15">11:15</option><option value="11:30">11:30</option><option value="11:45">11:45</option><option value="12:00">12:00</option><option value="12:15">12:15</option><option value="12:30">12:30</option><option value="12:45">12:45</option></select>';
    ahtml+='&nbsp;<select  id="camps_stime_2_'+j+'" name="camps_stime_2_'+j+'" size="1" tabindex="72" class="drop_down_left width_set3" onkeyup="summary_date_time_changes('+j+')" onChange="summary_date_time_changes('+j+')"><option value="AM" selected="selected">AM</option><option value="PM">PM</option></select></div><div class="clear"></div></div>';
    ahtml+='<div><div class="StrtTxt" style="width: 70px;margin-top:3px; position:relative;">End Time </div><div class="timStart" style="width: 140px; margin-top: -4px;margin-bottom:0;"><select  id="camps_etime_1_'+j+'" name="camps_etime_1_'+j+'" size="1" tabindex="73" class="drop_down_left width_set3" onkeyup="summary_date_time_changes('+j+')" onChange="summary_date_time_changes('+j+')">';
    ahtml+='<option value="01:00">01:00</option><option value="01:15">01:15</option><option value="01:30">01:30</option><option value="01:45">01:45</option><option value="02:00">02:00</option><option value="02:15">02:15</option><option value="02:30">02:30</option><option value="02:45">02:45</option><option value="03:00">03:00</option><option value="03:15">03:15</option><option value="03:30">03:30</option><option value="03:45">03:45</option><option value="04:00">04:00</option><option value="04:15">04:15</option><option value="04:30">04:30</option><option value="04:45">04:45</option><option value="05:00">05:00</option><option value="05:15">05:15</option><option value="05:30">05:30</option><option value="05:45">05:45</option><option value="06:00" selected="selected" >06:00</option><option value="06:15">06:15</option><option value="06:30">06:30</option><option value="06:45">06:45</option><option value="07:00">07:00</option><option value="07:15">07:15</option><option value="07:30">07:30</option><option value="07:45">07:45</option><option value="08:00">08:00</option><option value="08:15">08:15</option><option value="08:30">08:30</option><option value="08:45">08:45</option><option value="09:00">09:00</option><option value="09:15">09:15</option><option value="09:30">09:30</option><option value="09:45">09:45</option><option value="10:00">10:00</option><option value="10:15">10:15</option><option value="10:30">10:30</option><option value="10:45">10:45</option><option value="11:00">11:00</option><option value="11:15">11:15</option><option value="11:30">11:30</option><option value="11:45">11:45</option><option value="12:00">12:00</option><option value="12:15">12:15</option><option value="12:30">12:30</option><option value="12:45">12:45</option></select>';
    ahtml+='&nbsp;<select  id="camps_etime_2_'+j+'" name="camps_etime_2_'+j+'" size="1" tabindex="74" class="drop_down_left width_set3" onkeyup="summary_date_time_changes('+j+')" onChange="summary_date_time_changes('+j+')"><option value="AM">AM</option><option value="PM" selected="selected">PM</option></select></div> </div> </div> <div class="clear"></div>';
    ahtml+='<div style="display:none;" class="errorDiv"><div id="multiple_days_error_'+j+'" class="lt" style="padding-bottom:5px;"></div></div><div class="clear"></div>';
	
    ahtml+=' <div class="clear"></div><div style="display: block; width: 610px;" id="by_wholeday" class="paddingTop10" ><div class="lt leftSideField" style="margin-left: 0px;">No of Participants</div>';
    ahtml+='<input style="width: 315px" type="text" onkeypress="return number(event);" maxlength="4" onfocus="if (this.value==\'Specify Number\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}" onblur="if (this.value==\'\'){ this.value = \'Specify Number\';$(this).css(\'color\',\'#999999\');}" tabindex="16" maxlength="10" value="Specify Number" class="lt textbox" id="mul_day_participants_1_'+j+'" name="mul_day_participants_1_'+j+'"><div class="clear"></div> <div style="display: none; color: #ff0000;margin-left:180px" class="schedule_time_app_error_1" id="schedule_time_app_error_1_'+j+'"></div></div><div class="clear"></div></div><div class="clear"></div>';
	
    ahtml+='<div style="width: 610px; display:block;" id="singleDay_'+j+'" ><div class="CalenderDiv" style="width:610px;"><div class="StrtDte" style="margin-bottom:0"><div class="dateDiv CampsStartDateDiv" id="CampsDateDiv_'+j+'" style="margin-left:0px;height:27px; padding: 2px 5px 0;">';
    ahtml+='<input type="text"  id="datestartwhole_1_'+j+'" name="datestartwhole_1_'+j+'" class="dateTextbox" value="" readonly="readonly" tabindex="75" onChange="$(this).css(\'color\',\'#444444\');summary_date_time_changes('+j+');"/>';
    ahtml+='<input type="hidden" id="datestartwhole_alt_1_'+j+'" name="datestartwhole_alt_1_'+j+'" value="" /></div>   <div class="clear"></div></div><div class="lt"><div class="lt"> <div class="StrtTxt" style="width: 65px; margin-left: 20px;">Start Time </div>';
    ahtml+='<div class="timStart" style="width: 140px;margin-bottom:0;"><select  id="whole_stime_1_'+j+'" name="whole_stime_1_'+j+'" size="1" tabindex="76" class="drop_down_left width_set3" onkeyup="summary_date_time_changes('+j+')" onChange="summary_date_time_changes('+j+')">';
    ahtml+='<option value="01:00">01:00</option><option value="01:15">01:15</option><option value="01:30">01:30</option><option value="01:45">01:45</option><option value="02:00">02:00</option><option value="02:15">02:15</option><option value="02:30">02:30</option><option value="02:45">02:45</option><option value="03:00">03:00</option><option value="03:15">03:15</option><option value="03:30">03:30</option><option value="03:45">03:45</option><option value="04:00">04:00</option><option value="04:15">04:15</option><option value="04:30">04:30</option><option value="04:45">04:45</option><option value="05:00">05:00</option><option value="05:15">05:15</option><option value="05:30">05:30</option><option value="05:45">05:45</option><option value="06:00">06:00</option><option value="06:15">06:15</option><option value="06:30">06:30</option><option value="06:45">06:45</option><option value="07:00">07:00</option><option value="07:15">07:15</option><option value="07:30">07:30</option><option value="07:45">07:45</option><option value="08:00">08:00</option><option value="08:15">08:15</option><option value="08:30">08:30</option><option value="08:45">08:45</option><option value="09:00" selected="selected">09:00</option><option value="09:15">09:15</option><option value="09:30">09:30</option><option value="09:45">09:45</option><option value="10:00">10:00</option><option value="10:15">10:15</option><option value="10:30">10:30</option><option value="10:45">10:45</option><option value="11:00">11:00</option><option value="11:15">11:15</option><option value="11:30">11:30</option><option value="11:45">11:45</option><option value="12:00">12:00</option><option value="12:15">12:15</option><option value="12:30">12:30</option><option value="12:45">12:45</option></select>&nbsp;&nbsp;';
    ahtml+='<select  id="whole_stime_2_'+j+'" name="whole_stime_2_'+j+'" size="1" tabindex="77" class="drop_down_left width_set3" onkeyup="summary_date_time_changes('+j+')" onChange="summary_date_time_changes('+j+')"><option value="AM" selected="selected">AM</option><option value="PM">PM</option></select>   </div>  <div class="clear"></div></div>';
    ahtml+='<div class="lt"><div class="StrtTxt" style="width: 60px; margin-left: 10px;  margin-top:7px; position:relative;">End Time</div><div class="timStart"  style="width: 140px; margin-top: -1px;margin-bottom:0;"><select  id="whole_etime_1_'+j+'" name="whole_etime_1_'+j+'" size="1" tabindex="78" class="drop_down_left width_set3" onkeyup="summary_date_time_changes('+j+')" onChange="summary_date_time_changes('+j+')">';
    ahtml+='<option value="01:00">01:00</option><option value="01:15">01:15</option><option value="01:30">01:30</option><option value="01:45">01:45</option><option value="02:00">02:00</option><option value="02:15">02:15</option><option value="02:30">02:30</option><option value="02:45">02:45</option><option value="03:00">03:00</option><option value="03:15">03:15</option><option value="03:30">03:30</option><option value="03:45">03:45</option><option value="04:00">04:00</option><option value="04:15">04:15</option><option value="04:30">04:30</option><option value="04:45">04:45</option><option value="05:00">05:00</option><option value="05:15">05:15</option><option value="05:30">05:30</option><option value="05:45">05:45</option><option value="06:00" selected="selected">06:00</option><option value="06:15">06:15</option><option value="06:30">06:30</option><option value="06:45">06:45</option><option value="07:00">07:00</option><option value="07:15">07:15</option><option value="07:30">07:30</option><option value="07:45">07:45</option><option value="08:00">08:00</option><option value="08:15">08:15</option><option value="08:30">08:30</option><option value="08:45">08:45</option><option value="09:00">09:00</option><option value="09:15">09:15</option><option value="09:30">09:30</option><option value="09:45">09:45</option><option value="10:00">10:00</option><option value="10:15">10:15</option><option value="10:30">10:30</option><option value="10:45">10:45</option><option value="11:00">11:00</option><option value="11:15">11:15</option><option value="11:30">11:30</option><option value="11:45">11:45</option><option value="12:00">12:00</option><option value="12:15">12:15</option><option value="12:30">12:30</option><option value="12:45">12:45</option></select>';
    ahtml+='&nbsp;<select  id="whole_etime_2_'+j+'" name="whole_etime_2_'+j+'" size="1" tabindex="79" class="drop_down_left width_set3" onkeyup="summary_date_time_changes('+j+')" onChange="summary_date_time_changes('+j+')"><option value="AM">AM</option><option value="PM" selected="selected">PM</option></select> </div></div><div class="clear"></div></div>';
    ahtml+='<div class="clear"></div><div style="display:none;margin-top:0;" class="errorDiv"><div id="single_day_error_'+j+'" class="lt" style="padding-bottom:5px;"></div></div><div class="clear"></div> </div><div class="clear"></div>';
    ahtml+='<div class="clear"></div><div style="display: block; width: 610px;" id="by_wholeday" class="paddingTop10" ><div class="lt leftSideField" style="margin-left: 0px;">No of Participants</div> ';
	
    ahtml+=' <input style="width: 420px" type="text" onfocus="if (this.value==\'Specify Number\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}" onblur="if (this.value==\'\'){ this.value = \'Specify Number\';$(this).css(\'color\',\'#999999\');}" tabindex="16" maxlength="10" value="Specify Number" class="lt textbox" id="single_day_participants_1_'+j+'" name="single_day_participants_1_'+j+'"><div class="clear"></div> <div style="display: none; color: #ff0000;margin-left:180px" class="schedule_time_app_error_2" id="schedule_time_app_error_2_'+j+'"></div></div><div class="clear"></div></div> ';
    ahtml+='<div class="new_summary" id="wholeday_summay_'+j+'" style="display:none;margin:10px 0 0 0;"><div class="lt">Summary&nbsp;&nbsp;:&nbsp;&nbsp;</div><div class="outSummary" id="dateSummay"></div><div class="clear"></div></div><div class="clear"></div></div></div></td><td valign="bottom"><div class="delete_whole_day" id="delete_whole_day_'+j+'" onclick="delete_whole_day_block('+j+')">&nbsp;</div><div class="add_whole_day" id="add_whole_day_'+j+'" onclick="validate_whole_day_block('+j+',0)">&nbsp;</div></td></tr></table></div>';
		    
    $( ".dynamic_whole_day" ).append(ahtml);
    current_dates_schdule(j);
	
    arr1 = arr.split(',');
    arr1.pop();
    $('#whole_day_tabs').val(arr1);

    $( "#add_whole_day_"+j).css("display","block");
    ex_id=j-1;
    $( "#delete_whole_day_"+ex_id).css("display","block");
    /******************set the prev time in whole day*********************/
   if(selectedDay=="multiple" && opt!='db'){
    var camps_stime_1 = $('#camps_stime_1_'+ex_id).val();
    
    set_time_drop('camps_stime_1_'+j,camps_stime_1);
    var camps_stime_2 = $('#camps_stime_2_'+ex_id).val();
    set_time_drop('camps_stime_2_'+j,camps_stime_2);
    var camps_etime_1 = $('#camps_etime_1_'+ex_id).val();
    set_time_drop('camps_etime_1_'+j,camps_etime_1);
    var camps_etime_2 = $('#camps_etime_2_'+ex_id).val();
    set_time_drop('camps_etime_2_'+j,camps_etime_2);
    }
    else if(selectedDay=="single" && opt!='db'){
    var whole_stime_1 = $('#whole_stime_1_'+ex_id).val();
     set_time_drop('whole_stime_1_'+j,whole_stime_1);
    var whole_stime_2 = $('#whole_stime_2_'+ex_id).val();
     set_time_drop('whole_stime_2_'+j,whole_stime_2);
    var whole_etime_1 = $('#whole_etime_1_'+ex_id).val();
     set_time_drop('whole_etime_1_'+j,whole_etime_1);
   
    var whole_etime_2 = $('#whole_etime_2_'+ex_id).val();
     set_time_drop('whole_etime_2_'+j,whole_etime_2);
	
	}
    
	
     /***************************************/
    
    if(selectedDay=="single")
        dispCheckDays('radio_normal_day',1,j);
    if(selectedDay=="multiple")
        dispCheckDays('radio_normal_day',2,j);

}
/*********************************************
	         DELETE  Whole day
**********************************************/
function delete_whole_day_block(v)
{	
    v= v.toString();
    var schedulesw12='';
    var ar=$('#whole_day_tabs').val();
    var ar1=ar.split(',');
    var n= jQuery.inArray(v, ar1);
    ar1.splice(n, 1);
    var y=ar1[ar1.length-1];
    $('#whole_day_tabs').val(ar1);	
    if(y=="")
        $( "#add_whole_day_1" ).css("display","block");
    else
        $( "#add_whole_day_"+y ).css("display","block");
    $( ".dynamic_whole_day #outer_whole_day_"+v ).remove();
    $("#outer_whole_day_"+v ).remove();
	
    remove_sc=$('#total_div_count').val()
    remove_sc=remove_sc.split(',');
    adv_remove_sc=$('#total_outer_div').val()
    adv_remove_sc=adv_remove_sc.split(',');
    if(ar1.length==1){
			
        $('.delete_whole_day').css("display","none");
    }
    for(var c=0; c<remove_sc.length;c++)
    {
        var ar3=$('#chosen_sc_'+remove_sc[c]).val();
        if(ar3==''){
            var delete_sche_dule=$('#changing_schedule_net').val();
            delt=delete_sche_dule.split("</br>");
		
		
		
            for(w=0;w<delt.length;w++)
            {
                var arrays=delt[w].split('_');
					   
                if(v==arrays[1])
                {
							
                    delt.splice(w, 1);
                }
					 
					        
            }
            for(w=0;w<delt.length;w++){
                if(w!=(delt.length-1)){
                    schedulesw12+=delt[w]+'</br>';
                }
                else{
                    schedulesw12+=delt[w];
                }
            }
					 
					
            $('#changing_schedule_net').val(schedulesw12);
            if($('#changing_schedule_net').val()==''){
                $('.add_ad_schedule ').css("display","none");
            }
        }
        else{
		
            if(v==ar3){
                removing=remove_sc[c].split('_');
                delete_net_price(removing[0],1 );// removes the inner div seting as 1
            //$( "#netPriceDiv_"+removing[0] ).remove();
            }
        }
			
    }
    for(var c=0; c<adv_remove_sc.length;c++)
    {
        var ar21=$('#chosen_ad_sc_'+adv_remove_sc[c]).val();
        if(ar21==''){
            var delete_sche_dule=$('#changing_schedule_adv').val();
            delt=delete_sche_dule.split("</br>");
		
		
		
            for(w=0;w<delt.length;w++)
            {
                var arrays=delt[w].split('_');
					   
                if(v==arrays[1])
                {
						
                    delt.splice(w, 1);
                }
					 
					        
            }
            for(w=0;w<delt.length;w++){
                if(w!=(delt.length-1)){
                    schedulesw12+=delt[w]+'</br>';
                }
                else{
                    schedulesw12+=delt[w];
                }
            }
					 
			
            $('#changing_schedule_adv').val(schedulesw12);
            if($('#changing_schedule_adv').val()==''){
                $('.add_ad_schedule ').css("display","none");
            }
        }
        else{
            if(v==ar21){
                removing=adv_remove_sc[c].split('_');
                delete_ad_net_price(removing[0],1 );
            //$( "#netPriceDiv_"+removing[0] ).remove();
            }
        }
    }
    
    if((mySchedule.length==myNetdiv.length)||(mySchedule.length==myAdvdiv.length))
    {
        for(i=0;i<(mySchedule.length);i++)
        {
            $("#add_whole_day_"+mySchedule[i]).css("display","none");
            $("#delete_whole_day_"+mySchedule[i]).css("display","block");
					        
        }
    }
	
    for(i=0;i<mySchedule.length;i++)//indexof property not works ie<9 browsers .so removal divs like this
    {
        if(mySchedule[i]==v)
        {
            mySchedule.splice(i,1);
            myChoose_schedule.splice(v,1);
        // $("#choose_schedule_net_"+myNetdiv[myNetdiv.length-1]+"_1").append('<option  value="' + deleted_schedule + '">' +deleted_schedule+ '</option>'); //apend to the open dropdwon
        }
						
    }
		
}

function set_time_drop(selectbox_id,optionValue)
{
   
    $('#'+selectbox_id).find('option[value="'+optionValue+'"]').attr('selected', true);
}

