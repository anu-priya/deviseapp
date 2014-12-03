var errorFlag = false;
var displaySummaryFirst = '';
// repeat checkbox tic
function dispCheck(imgName,popId){   
	if(imgName == 'checkbox_selected'){
		$('#checkbox_selected_s1_'+popId).css('display','none');
		$('#checkbox_normal_s1_'+popId).css('display','inline-block');
		$('#repeatPOPUPDiv_'+popId).css('display','none');
		$('#repeatCheck_'+popId).val(''); 
		$('#repeatEdit_'+popId).css('display','none');
				
		$('#sched_end_date2_'+popId).css('display','none'); // parent
		$('#sched_end_date1_'+popId).css('display','inline-block'); // parent
		$("#toText_"+popId).css('display','block'); // parent
		$("#schedule_summary_"+popId+" #repeat_summary_text").css('display','none');
		clearRepeatDiv(popId);		
	}
	else if(imgName == 'checkbox_normal'){
		close_repeat_popup();
		$('#checkbox_normal_s1_'+popId).css('display','none');
		$('#checkbox_selected_s1_'+popId).css('display','inline-block');
		$('#repeatPOPUPDiv_'+popId).css('display','block');
		$('#repeatCheck_'+popId).val('yes');		
		clearRepeatDiv(popId);	
	}
	summary_date_time_changes(popId);
}
function close_repeat_popup(){
	$('.repeatContainer').css('display','none');
	var total_count=$('#schedule_tabs').val();
	if(total_count!=0){
		var splitNumber=total_count.split(",");
		var numberLength=splitNumber.length;
		for(var i=1;i<=numberLength;i++){ 
			var repeat_save = $('#repeat_save_'+i).val();	
			if(repeat_save!=1){ 
				$('#checkbox_selected_s1_'+i).css('display','none');
				$('#checkbox_normal_s1_'+i).css('display','inline-block');
			}
		}
	}
}
$('.repeatContainer').css('display','none');
// Clear repeat div all fields
function clearRepeatDiv(popId){	
	// input set empty
	$('#repeat_save_'+popId).val("");	  
	
	// Repeats
	$("#repeatWeekVal_"+popId).val('Daily');
	
	// Repeat every
	$("#repeatNumWeekVal_"+popId).val(1);	
	
	$('#repeatPOPUPDiv_'+popId+' .repeatEvery').show();
	$('#repeatPOPUPDiv_'+popId+' .repeatEveryText_'+popId).html("Day");
	
	// Repeat on
	$('#repeatPOPUPDiv_'+popId+' .repeatOn').hide();
	$("#repeat_no_of_days_"+popId).val("");
	$("#repeat_days_"+popId).val("");
	$("#repeatPOPUPDiv_"+popId+" .repeatOn .checkbox input").val("");
	
	// Repeat by
	$('#repeatPOPUPDiv_'+popId+' .repeated_by').hide();

	// Starts on
	var date_r = $('#date_1_'+popId).val();
	var dateFormate_1 = $('#dateFormate_1_'+popId).val();
	$('#started_date_'+popId).val(date_r);
	$('#started_date_disp_'+popId).val(dateFormate_1);
	
	$('#started_date_disp_'+popId).attr("disabled",true);
	$('#started_date_disp_'+popId).css('background-color','#ECE9D8');	
	
	// Ends
	$('#repeatPOPUPDiv_'+popId+' .radio_selected_repeat').css('display','none');
	$('#repeatPOPUPDiv_'+popId+' .radio_normal_repeat').css('display','block');
	
	// Ends - Occrrences
	$('#repeatPOPUPDiv_'+popId+' #after_occ_'+popId).val('');	
	$('#repeatPOPUPDiv_'+popId+' #after_occ_'+popId).css('background-color','#ECE9D8');
	$('#repeatPOPUPDiv_'+popId+' #after_occ_'+popId).attr('disabled',true);
	
	// Ends - On
	$('#r3_'+popId).val(1);
	modifyDateTo(popId);
	$('#radio_selected_repeat_3_'+popId).css('display','block');
	$('#radio_normal_repeat_3_'+popId).css('display','none');
	$('#repeat_on_date_'+popId).parent().css('background-color','#ffffff');
        $('#repeatPOPUPDiv_'+popId+' .dateDivRepeat img').show();
        $('#repeatPOPUPDiv_'+popId+' .dateDivRepeat input').show();	
	
	// Error hide func
	$("#repeat_on_error_"+popId).html("");
	$("#repeat_on_error_"+popId).parent().css("display","none");
	$("#after_occ_error_"+popId).html("");
	$("#after_occ_error_"+popId).parent().css("display","none");
	$("#repeat_alt_error_"+popId).html("");
	$("#repeat_alt_error_"+popId).parent().css("display","none");

	// ser normal color value
	$('#after_occ_'+popId).css('color','#999999');
	$('#repeat_on_date_'+popId).css('color','#999999');    
	changedDayFormate(popId);
	repeatsValue(popId);
}

// Display current day 
// Ex:today wed day --- to selected the wed day checkbox
function changedDayFormate(popId){ 
	var dateF = $("#dateFormate_1_"+popId).val();		
	var dateSplit = dateF.split(",");
	cday = dateSplit[0];
	var arr = new Array("Sun","Mon","Tue","Wed","Thu","Fri","Sat");
	for(var i=0;i<7;i++){
		if(cday==arr[i]){
			incval = i+1;
			$("#day"+incval+"_"+popId).val(cday);
			$('#checkbox_normal_repeat_'+incval+'_'+popId).css('display','none');
			$('#checkbox_selected_repeat_'+incval+'_'+popId).css('display','block');
		}
		else{
			incval = i+1;
			$("#day"+incval+"_"+popId).val('');
			$('#checkbox_normal_repeat_'+incval+'_'+popId).css('display','block');
			$('#checkbox_selected_repeat_'+incval+'_'+popId).css('display','none');
		}
	}
	$("#repeat_no_of_days_"+popId).val(cday);
	$("#repeat_days_"+popId).val(cday);	
	changed_summary(popId);
}
// Repeated by monthly - radio option
function dispCheckMonthlyRepeat(imgName,incval,popId){
    if(imgName == 'month_normal_repeat'){
        $('#repeatPOPUPDiv_'+popId+' .month_selected_repeat').css('display','none');
        $('#repeatPOPUPDiv_'+popId+' .month_normal_repeat').css('display','inline-block');
        $('#repeatPOPUPDiv_'+popId+' .month input').val(0);
        $('#month_normal_repeat_'+incval+'_'+popId).css('display','none');
        $('#month_selected_repeat_'+incval+'_'+popId).css('display','inline-block');
        $('#month'+incval+'_'+popId).val(1);
        changed_summary(popId);
    }
}
//singular or plural values
function single_double(popId){ 	
	var val = $("#repeatNumWeekVal_"+popId).val();	
	var ele1=$("#repeatWeekVal_"+popId).val();	
	
	if(ele1=="Weekly"){
		if (val!=1){
			$('#repeatPOPUPDiv_'+popId+' .repeatEveryText_'+popId).html("Weeks");
		}
		else{
			$('#repeatPOPUPDiv_'+popId+' .repeatEveryText_'+popId).html("Week");
		}
	}
	
	if(ele1=="Daily"){
		if (val!=1){
			$('#repeatPOPUPDiv_'+popId+' .repeatEveryText_'+popId).html("Days");
		}
		else{
			$('#repeatPOPUPDiv_'+popId+' .repeatEveryText_'+popId).html("Day");
		}
	}
	
	if(ele1=="Monthly"){
		if (val!=1){
			$('#repeatPOPUPDiv_'+popId+' .repeatEveryText_'+popId).html("Months");
		}
		else{
			$('#repeatPOPUPDiv_'+popId+' .repeatEveryText_'+popId).html("Month");
		}
	}
	
	if(ele1=="Yearly"){
		if (val!=1){
			$('#repeatPOPUPDiv_'+popId+' .repeatEveryText_'+popId).html("Years");
		}
		else{
			$('#repeatPOPUPDiv_'+popId+' .repeatEveryText_'+popId).html("Year");
		}
	}

}

// repeats - first dropdown
// change func
function repeatsValue(popId){
	single_double(popId);
	changedWeekDays(popId);
}
// repeats - first dropdown
function changedWeekDays(popId){
    /*  Dynamic change.....*/	
    var repeatSt="";
    var statement = '';
    var occu_times = '';
    var repeats = $("#repeatWeekVal_"+popId).val();
    var repeatsVal = $("#repeatNumWeekVal_"+popId).val();	
    var radio_1 = $('#r1_'+popId).val();
    var radio_2 = $('#r2_'+popId).val();
    occu_times = $('#after_occ_'+popId).val();
    var radio_3 = $('#r3_'+popId).val();
    var repeat_date = $('#repeat_on_date_'+popId).val();
    if(repeat_date=='' && radio_3 == 1){
	    modifyDateTo(popId);
	    repeat_date = $('#repeat_on_date_'+popId).val();
    }	
    switch(repeats){		
        case 'Daily': 
            $('#repeatPOPUPDiv_'+popId+' .repeatEvery').show();
            $('#repeatPOPUPDiv_'+popId+' .repeatOn').hide();
            $('#repeat_no_of_days_'+popId).val('Daily');
            $('#repeatPOPUPDiv_'+popId+' .repeated_by').hide();
            break;       
        case 'Weekly':			
            $('#repeatPOPUPDiv_'+popId+' .repeatEvery').show();
            $('#repeatPOPUPDiv_'+popId+' .repeatOn').show();
	    $('#repeat_no_of_days_'+popId).val('');
	    $('#repeat_days_'+popId).val('');
	    changedDayFormate(popId);
            $('#repeatPOPUPDiv_'+popId+' .repeated_by').hide();
            break;
        case 'Monthly':
            $('#repeatPOPUPDiv_'+popId+' .repeatEvery').show();
            $('#repeatPOPUPDiv_'+popId+' .repeatOn').hide();
            $('#repeat_no_of_days_'+popId).val('Monthly');
            $('#repeatPOPUPDiv_'+popId+' .repeated_by').show();
            break;
        case 'Yearly':            
            $('#repeatPOPUPDiv_'+popId+' .repeatEvery').show();
            $('#repeatPOPUPDiv_'+popId+' .repeatOn').hide();
            $('#repeat_no_of_days_'+popId).val('Yearly');
            $('#repeatPOPUPDiv_'+popId+' .repeated_by').hide();
            break;
    }
    changed_summary(popId);
}

// repeats - every second dropdown
function repeatEveryValue(popId){	
	single_double(popId);
	changed_summary(popId);
}

// Repeat On  -- check box choose func
//  Ends - radion option
var day_val='';
var joinStr ='';
var i=1;
function dispCheckRepeat(imgName,incval,day_val,popId){ 
    if(imgName == 'checkbox_selected_repeat'){
        $('#checkbox_selected_repeat_'+incval+'_'+popId).css('display','none');
        $('#checkbox_normal_repeat_'+incval+'_'+popId).css('display','inline-block');
        $("#day"+incval+'_'+popId).val('');
        var days = $('#repeat_days_'+popId).val();
        var splitofdays = days.split(",");
        var len = splitofdays.length;
        joinStr = "";
        for(var i=0;i<len;i++){
            if(splitofdays[i] != day_val && splitofdays[i] != "," && splitofdays[i] != "" && len>0){
                joinStr += splitofdays[i]+",";
            }
            else if(len == 1){
                joinStr += '';
            }	    
        }
        $('#repeat_no_of_days_'+popId).val(joinStr);
        $('#repeat_days_'+popId).val(joinStr);
    }
    else if(imgName == 'checkbox_normal_repeat'){
	$("#repeat_on_error_"+popId).html("");
    	$("#repeat_on_error_"+popId).parent().css("display","none");
        $('#checkbox_normal_repeat_'+incval+'_'+popId).css('display','none');
        $('#checkbox_selected_repeat_'+incval+'_'+popId).css('display','inline-block');
        $("#day"+incval+'_'+popId).val(day_val);
        var days = $('#repeat_days_'+popId).val();
        var splitofdays = days.split(",");
        var len = splitofdays.length;
		
        for(var i=1;i<=len;i++){
            if(splitofdays[i] != day_val && days != '' ){
                $('#repeat_no_of_days_'+popId).val(days+","+day_val);
                $('#repeat_days_'+popId).val(days+","+day_val);
            }
            else if(len==1){
                $('#repeat_no_of_days_'+popId).val(day_val);
                $('#repeat_days_'+popId).val(day_val);
            }
        }
    }
    else if(imgName == 'radio_normal_repeat'){
	$("#after_occ_error_"+popId).html("");
	$("#after_occ_error_"+popId).parent().css("display","none");
        if(incval == 1){
            $('#repeatPOPUPDiv_'+popId+' #after_occ_'+popId).val('');
            $('#repeatPOPUPDiv_'+popId+' #after_occ_'+popId).css('background-color','#ECE9D8');
            $('#repeatPOPUPDiv_'+popId+' #after_occ_'+popId).attr('disabled',true);
	    
	    $('#repeat_on_date_'+popId).val('');
	    $('#repeat_alt_on_date1_'+popId).val('');
            $('#repeat_on_date_'+popId).parent().css('background-color','#ECE9D8');
            $('#repeatPOPUPDiv_'+popId+' .dateDivRepeat img').hide();
            $('#repeatPOPUPDiv_'+popId+' .dateDivRepeat input').hide();
        }
        if(incval == 2){          
            $('#repeatPOPUPDiv_'+popId+' #after_occ_'+popId).val(5);			
            $('#repeatPOPUPDiv_'+popId+' #after_occ_'+popId).css('background-color','#ffffff');
            $('#repeatPOPUPDiv_'+popId+' #after_occ_'+popId).removeAttr('disabled');
		
	    $('#repeat_on_date_'+popId).val('');
	    $('#repeat_alt_on_date1_'+popId).val('');
            $('#repeat_on_date_'+popId).parent().css('background-color','#ECE9D8');
            $('#repeatPOPUPDiv_'+popId+' .dateDivRepeat img').hide();
            $('#repeatPOPUPDiv_'+popId+' .dateDivRepeat input').hide();
        }
        if(incval == 3){
	    modifyDateTo(popId);
	    $('#repeatPOPUPDiv_'+popId+' #after_occ_'+popId).val('');
            $('#repeatPOPUPDiv_'+popId+' #after_occ_'+popId).css('background-color','#ECE9D8');
            $('#repeatPOPUPDiv_'+popId+' #after_occ_'+popId).attr('disabled',true);
            $('#repeat_on_date_'+popId).parent().css('background-color','#ffffff');
            $('#repeatPOPUPDiv_'+popId+' .dateDivRepeat img').show();
            $('#repeatPOPUPDiv_'+popId+' .dateDivRepeat input').show();
        }
        $('#repeatPOPUPDiv_'+popId+' .radio_selected_repeat').css('display','none');
        $('#repeatPOPUPDiv_'+popId+' .radio_normal_repeat').css('display','inline-block');
        $('#repeatPOPUPDiv_'+popId+' .r_value input').val(0);
		
        $('#repeatPOPUPDiv_'+popId+' #radio_normal_repeat_'+incval+'_'+popId).css('display','none');
        $('#repeatPOPUPDiv_'+popId+' #radio_selected_repeat_'+incval+'_'+popId).css('display','inline-block');
        $('#repeatPOPUPDiv_'+popId+' #r'+incval+'_'+popId).val(1);        	
    }
    changed_summary(popId);	
}

// summary display func
function changed_summary(popId){
	displaySummaryFirst=2;
	$("#schedule_summary_"+popId).show();	

	$("#repeat_alt_error_"+popId).html("");
	$("#repeat_alt_error_"+popId).parent().css("display","none");

	$("#repeat_on_error_"+popId).html("");
	$("#repeat_on_error_"+popId).parent().css("display","none");
	var repeat_check = $('#repeatCheck_'+popId).val();
	
	if(repeat_check == "yes"){
		$("#schedule_summary_"+popId+" #repeat_summary_text").css('display','block');	
		$("#schedule_summary_"+popId+" #repeatText").css('display','inline-block');
	}

	var str = '';
	var statement = "";
	var days = " ";
	var dayval = "";
	var find_full_day = "";
	var i=1;
	var month1 = $("#month1_"+popId).val();
	var month2 = $("#month2_"+popId).val();
	var month_day = '';
	var cu_month = '';

	var elem1 = $("#repeatWeekVal_"+popId).val();
	var elem2 = $("#repeatNumWeekVal_"+popId).val();

	var radio_1 = $('#r1_'+popId).val();
	var radio_2 = $('#r2_'+popId).val();
	var occu_times = $('#after_occ_'+popId).val();
	var radio_3 = $('#r3_'+popId).val();

	var repeat_date ="";
	var fm_end = '';
	
	if(repeat_check == "yes"){
		repeat_date = $('#repeat_on_date_'+popId).val();
		fm_end = $('#repeat_alt_on_date_'+popId).val();	
		if(repeat_date=='' && radio_1 == 0 && radio_2 == 0 && radio_3 == 1){
			modifyDateTo(popId);			
		}		
	} 
	repeat_date = $('#repeat_on_date_'+popId).val();	
	fm_end = $('#repeat_alt_on_date_'+popId).val();	

	var splitdate = fm_end.split('-');
	var year = splitdate[0];
	var month = splitdate[1];
	month = parseInt(month)-1;
	var date = splitdate[2];

	var fm_start = $('#date_1_'+popId).val();    

	var splitdate_start = fm_start.split('-');
	var year_start = splitdate_start[0];
	var month_start = splitdate_start[1];
	month_start = parseInt(month_start)-1;
	var date_start = splitdate_start[2];    

	var date1 =  new Date(month_start+"/"+date_start+"/"+year_start);
	var date2 =  new Date(month+"/"+date+"/"+year);		

	var dayCal = 1000 * 60 * 60 * 24;
	var weekCal = 1000 * 60 * 60 * 24 * 6;
	var monthCal = 1000 * 60 * 60 * 24 * 30;
	var yearCal = 1000 * 60 * 60 * 24 * 365;

	var dayCount = Math.ceil((date2.getTime() - date1.getTime()) / (dayCal));
	var weekCount = Math.ceil((date2.getTime() - date1.getTime()) / (weekCal));	
	var monthCount = Math.ceil((date2.getTime() - date1.getTime()) / (monthCal));
	var yearCount = Math.ceil((date2.getTime() - date1.getTime()) / (yearCal));	

	var d = new Date();
	d.setFullYear(year);
	var month=new Array();
	month[0]="Jan";
	month[1]="Feb";
	month[2]="Mar";
	month[3]="Apr";
	month[4]="May";
	month[5]="Jun";
	month[6]="Jul";
	month[7]="Aug";
	month[8]="Sep";
	month[9]="Oct";
	month[10]="Nov";
	month[11]="Dec";
	var monthName = month[d.getMonth()];
	
	function weekAndDay(popId) {
		var fm = $('#date_1_'+popId).val();    

		var splitdate = fm.split('-');
		var year = splitdate[0];
		var month = splitdate[1];
		var month = parseInt(month)-1;
		var date = splitdate[2];

		var cu_date = new Date;
		cu_date.setDate(date);
		cu_date.setMonth(month);
		cu_date.setFullYear(year);	

		var dayy = new Array();
		var prefixes = new Array();

		dayy = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'],
		prefixes = ['First', 'Second', 'Third', 'Fourth', 'Fifth'];        

		var weekNum = 0 | cu_date.getDate() / 7;
		weekNum = ( cu_date.getDate() % 7 === 0 ) ? weekNum - 1 : weekNum;

		return prefixes[ weekNum ] + ' ' + dayy[ cu_date.getDay() ];   
	}
	cu_month = weekAndDay(popId);

	if(month2 == 1)
		month_day = "the "+cu_month;
	else
		month_day = "Day "+date_start;

	if(elem1 == "Weekly"){
		var str = '';
		var j=0;
		for(i=1;i<8;i++){
			var dayval = $("#day"+i+"_"+popId).val();			
			if(dayval != ''){
				var str = '';
				switch(dayval){
					case 'Sun':
						str = "Sun";
					break;
					case 'Mon':
						str = "Mon";
					break;
					case 'Tue':
						str = "Tue";
					break;
					case 'Wed':
						str = "Wed";
					break;
					case 'Thu':
						str = "Thu";
					break;
					case 'Fri':
						str = "Fri";
					break;
					case 'Sat':
						str = "Sat";
					break;
					default:
						str = dayval;
					break;
				}  
				if(j=="0"){	days += str	}
				else{	days += ", "+ str; }
				j++;
			}

		}
		if(elem2>1){
			if(days == " Sun, Mon, Tue, Wed, Thu, Fri, Sat"){
				if(radio_2==1 && occu_times>0){ 
					if(occu_times==1){
						statement = "Every "+elem2+" Weeks on All Days, Once";
					}
					else{
						statement = "Every "+elem2+" Weeks on All Days, "+occu_times+" times";
					}					
				}
				else if(radio_3==1 && repeat_date!=''){
					if(elem2<weekCount){
						statement = "Every "+elem2+" Weeks on All Days, until "+repeat_date;
					}
					else{
						statement = "Ends On "+repeat_date;
						if(fm_start == fm_end){
							$("#schedule_summary_"+popId+" #repeat_summary_text").hide();
						}
						else{
							$("#schedule_summary_"+popId+" #repeatText").hide();
						}
					}			
				}
				else
					statement = "Every "+elem2+" Weeks on All Days";
			}
			else{
				if(radio_2==1 && occu_times>0){
					if(occu_times==1){
						statement = "Every "+elem2+" Weeks on "+days+", Once";
					}
					else{
						statement = "Every "+elem2+" Weeks on "+days+", "+occu_times+" times";
					}
				}
				else if(radio_3==1 && repeat_date!=''){              
					if(elem2<weekCount){
						statement = "Every "+elem2+" Weeks on "+days+", until "+repeat_date;
					}
					else{
						statement = "Ends On "+repeat_date;
						if(fm_start == fm_end){
							$("#schedule_summary_"+popId+" #repeat_summary_text").hide();
						}
						else{
							$("#schedule_summary_"+popId+" #repeatText").hide();
						}
					}
				}
				else
					statement = "Every "+elem2+" Weeks on "+days;

				var dayTotalVal = $("#repeat_days_"+popId).val();					
				if(elem1 == "Weekly"){
					if(dayTotalVal==""){
						statement = "";
						$("#repeat_on_error_"+popId).html("Please choose any one day");
						$("#repeat_on_error_"+popId).parent().css("display","block");
					}
				}
			}
		}
		else{
			if(days == " Sun, Mon, Tue, Wed, Thu, Fri, Sat"){
				if(radio_2==1 && occu_times>0){
					if(occu_times==1){
						statement = elem1+" on All Days, Once";
					}
					else{
						statement = elem1+" on All Days, "+occu_times+" times";
					}
				}

				else if(radio_3==1 && repeat_date!=''){
					if(weekCount>1){
						statement = elem1+" on All Days, until "+repeat_date;
					}
					else{
						statement = "Ends On "+repeat_date;
						if(fm_start == fm_end){
							$("#schedule_summary_"+popId+" #repeat_summary_text").hide();
						}
						else{
							$("#schedule_summary_"+popId+" #repeatText").hide();
						}
					}
				}                    
				else
				statement = elem1+" on All Days";
			}
			else{
				if(radio_2==1 && occu_times>0){
					if(occu_times==1){
						statement = elem1+" on "+days+", Once";
					}
					else{
						statement = elem1+" on "+days+", "+occu_times+" times";
					}			
				}

				else if(radio_3==1 && repeat_date!=''){
					if(weekCount>1){
						statement = elem1+" on "+days+", until "+repeat_date;
					}
					else{
						statement = "Ends On "+repeat_date;
						if(fm_start == fm_end){
							$("#schedule_summary_"+popId+" #repeat_summary_text").hide();
						}
						else{
							$("#schedule_summary_"+popId+" #repeatText").hide();
						}				
					}			
				}				
				else
				statement = elem1+" on "+ days;	

				var dayTotalVal = $("#repeat_no_of_days").val();					
				if(elem1 == "Weekly"){
					if(dayTotalVal==""){
						statement = "";
						$("#repeat_on_error_"+popId).html("Please choose any one day");
						$("#repeat_on_error_"+popId).parent().css("display","block");
					}
				}				
			}
		}
	}
	else if(elem1 == 'Daily'){
			if(elem2==1){
				if(radio_2==1 && occu_times>0){
					if(occu_times==1){
						statement = "Once";
					}
					else{
						statement = elem1+", "+occu_times+" times";
					}			
				}
				else if(radio_3==1 && repeat_date!='' ){
					if(dayCount>0){
						statement = elem1+", until "+repeat_date;
					}
					else{
						statement = "Ends On "+repeat_date;
						if(fm_start == fm_end){
							$("#schedule_summary_"+popId+" #repeat_summary_text").hide();
						}
						else{
							$("#schedule_summary_"+popId+" #repeatText").hide();
						}
					}		    
				}
				else
					statement = elem1;
			}
			else{
				if(radio_2==1 && occu_times>0){                
					if(occu_times==1){
						statement = "Every "+elem2+" Days, Once";
					}
					else{
						statement = "Every "+elem2+" Days, "+occu_times+" times";
					}
				}
				else if(radio_3==1 && repeat_date!=''){
					if(elem2<=dayCount){
						statement = "Every "+elem2+" Days, until "+repeat_date;
					}
					else{
						statement = "Ends On "+repeat_date;
						if(fm_start == fm_end){
							$("#schedule_summary_"+popId+" #repeat_summary_text").hide();
						}
						else{
							$("#schedule_summary_"+popId+" #repeatText").hide();
						}
					}		    
				}
				else
					statement = "Every "+elem2+" Days";
			}
		}    

	else if(elem1 == 'Monthly'){
		if(elem2==1){
			if(radio_2==1 && occu_times>0){
				if(occu_times==1){
					statement = elem1+" on "+month_day+", Once";
				}
				else{
					statement = elem1+" on "+month_day+", "+occu_times+" times";
				}		
			}                
			else if(radio_3==1 && repeat_date!=''){
				if(dayCount > 29){
					statement = elem1+" on "+month_day+", until "+repeat_date;
				}
				else{
					statement = "Ends On "+repeat_date;
					if(fm_start == fm_end){
						$("#schedule_summary_"+popId+" #repeat_summary_text").hide();
					}
					else{
						$("#schedule_summary_"+popId+" #repeatText").hide();
					}
				}
			}	
			else
			statement = elem1+" on "+month_day;
		}
		else{
			if(radio_2==1 && occu_times>0){
				if(occu_times==1){
					statement = "Every "+elem2+" Months on "+month_day+", Once";
				}
				else{
					statement = "Every "+elem2+" Months on "+month_day+", "+occu_times+" times";
				}		
			}                
			else if(radio_3==1 && repeat_date!=''){
				if(elem2 < monthCount){
					statement = "Every "+elem2+" Months on "+month_day+", until "+repeat_date;
				}
				else{
					statement = "Ends On "+repeat_date;
					if(fm_start == fm_end){
						$("#schedule_summary_"+popId+" #repeat_summary_text").hide();
					}
					else{
						$("#schedule_summary_"+popId+" #repeatText").hide();
					}
				}
			}			
			else
				statement = "Every "+elem2+" Months on "+month_day;
		}
	}
	else if(elem1 == 'Yearly' ){
		if(elem2==1){
			if(radio_2==1 && occu_times>0){
				if(occu_times==1){
					statement = "Annually on "+monthName+" "+date_start+", Once";
				}
				else{
					statement = "Annually on "+monthName+" "+date_start+", "+occu_times+" times";
				}		
			}                
			else if(radio_3==1 && repeat_date!=''){
				if(dayCount > 364 ){
					statement = "Annually on "+monthName+" "+date_start+", until "+repeat_date;
				}
				else{
					statement = "Ends On "+repeat_date;
					if(fm_start == fm_end){
						$("#schedule_summary_"+popId+" #repeat_summary_text").hide();
					}
					else{
						$("#schedule_summary_"+popId+" #repeatText").hide();
					}
				}
			}			
			else
				statement = "Annually on "+monthName+" "+date_start;
		}
		else{
			if(radio_2==1 && occu_times>0){
				if(occu_times==1){
					statement = "Every "+elem2+" Years on "+monthName+" "+date_start+", Once";
				}
				else{
					statement = "Every "+elem2+" Years on "+monthName+" "+date_start+", "+occu_times+" times";
				}		
			}                
			else if(radio_3==1 && repeat_date!=''){
				if(elem2 < yearCount){
					statement = "Every "+elem2+" Years on "+monthName+" "+date_start+", until "+repeat_date;
				}
				else{
					statement = "Ends On "+repeat_date;
					if(fm_start == fm_end){
						$("#schedule_summary_"+popId+" #repeat_summary_text").hide();
					}
					else{
						$("#schedule_summary_"+popId+" #repeatText").hide();
					}
				}
			}			
			else
			statement = "Every "+elem2+" Years on "+monthName+" "+date_start;
		}
	}
	$("#repeat_summary_"+popId+" .summary").html(statement);
	$("#schedule_summary_"+popId+" .summary").html(statement);
}	
// Edit icon
function repeat_edit(popId){
    $('#checkbox_normal_s1_'+popId).css('display','none');
    $('#repeatPOPUPDiv_'+popId).css('display','block');
    $('#repeatCheck_'+popId).val('yes');
    clearRepeatDiv(popId);
}
// Edit page Edit icon
function disp_edit(popId){	 
         var repeatOn = $('#repeatCheck_'+popId).val();
	 var radio3 = $("#r3_"+popId).val();
	 if(radio3==0){
		$("#repeatPOPUPDiv_"+popId+" .dateDivRepeat img").hide();
	 }
	 if(repeatOn=="yes"){
		close_repeat_popup();
		$('#repeatPOPUPDiv_'+popId).css('display','block'); 
	 }	 
	 else{
		close_repeat_popup();
		clearRepeatDiv();
		$('#repeatPOPUPDiv_'+popId).css('display','block');
	 }
}

// Close icon
function closeRepeatDiv(popId){	
	var saveCheck = $('#repeat_save_'+popId).val();
	var radio_1 = $('#r1_'+popId).val();
	var radio_2 = $('#r2_'+popId).val();
	var radio_3 = $('#r3_'+popId).val();
	var startDate = $("#date_1_"+popId).val();
	var repeat_alt = $("#repeat_alt_on_date_"+popId).val();
	
	var after_occ = $("#after_occ_"+popId).val();
	var startDate = $("#date_1_"+popId).val();
	var repeat_alt = $("#repeat_alt_on_date_"+popId).val();
	var repeatWeekVal = $("#repeatWeekVal_"+popId).val();
	var no_of_days = $("#repeat_no_of_days_"+popId).val();

	if(saveCheck!=1){		
		clearRepeatDiv(popId);
		$('#checkbox_selected_s1_'+popId).css('display','none');
		$('#checkbox_normal_s1_'+popId).css('display','inline-block');		
		$('#repeatCheck_'+popId).val(''); 
		$('#repeatEdit_'+popId).css('display','none');
		$("#schedule_summary_"+popId+" #repeat_summary_text_"+popId).css('display','none');	
		if(errorFlag){ errorFlag = false; }
	}
	else{
		if(no_of_days == '' && repeatWeekVal == "Weekly"){ 
			$("#repeat_days_"+popId).val(0);
			changedDayFormate(popId);
		}
		if(radio_1 == 0 && radio_2 == 1 && radio_3 == 0 ){
			var firstValOcc = after_occ.charAt(0);
			if(after_occ=='' || firstValOcc==0){
				dispCheckRepeat('radio_selected_repeat',2,popId);
				$("#after_occ_"+popId).val(5);	
			}
			changed_summary(popId);
		}
		if(errorFlag){ errorFlag = false; }			
	}	
	$('#repeatPOPUPDiv_'+popId).css('display','none');
	$("#repeat_on_error_"+popId).html("");
	$("#repeat_on_error_"+popId).parent().css("display","none");
	$("#after_occ_error_"+popId).html("");
	$("#after_occ_error_"+popId).parent().css("display","none");
	$("#repeat_alt_error_"+popId).html("");
	$("#repeat_alt_error_"+popId).parent().css("display","none");	
}

// save button
function saveRepeatDiv(opt,popId){
    var errorFlag = false;
    var radio_1 = $('#r1_'+popId).val();
    var radio_2 = $('#r2_'+popId).val();
    var radio_3 = $('#r3_'+popId).val();
    $("#repeat_on_error_"+popId).html("");
    $("#repeat_on_error_"+popId).parent().css("display","none");
    $("#after_occ_error_"+popId).html("");
    $("#after_occ_error_"+popId).parent().css("display","none");
    $("#repeat_alt_error_"+popId).html("");
    $("#repeat_alt_error_"+popId).parent().css("display","none");
	
    var after_occ = $("#after_occ_"+popId).val();
    var startDate = $("#date_1_"+popId).val();
    var repeat_alt = $("#repeat_alt_on_date_"+popId).val();
    var repeatWeekVal = $("#repeatWeekVal_"+popId).val();
    var no_of_days = $("#repeat_no_of_days_"+popId).val();
	
    if(no_of_days == '' && repeatWeekVal == "Weekly"){
        $("#repeat_on_error_"+popId).html("Please choose any one day");
        $("#repeat_on_error_"+popId).parent().css("display","block");
        errorFlag = true;
    }
    if(radio_1 == 0 && radio_2 == 1 && radio_3 == 0 ){
	var firstValOcc = after_occ.charAt(0);
	if(firstValOcc == 0){
	    $("#after_occ_error_"+popId).html("Please do not use 0 as a first character");
            $("#after_occ_error_"+popId).parent().css("display","block");
            errorFlag = true;
	}
        if(after_occ == "" ){
            $("#after_occ_error_"+popId).html("Please enter occurrences");
            $("#after_occ_error_"+popId).parent().css("display","block");
            errorFlag = true;
        }	
    }
    if(errorFlag){ 
        return false;
    }
     else{
		$('#repeat_save_'+popId).val(1);	  	
		$('#repeatPOPUPDiv_'+popId).css('display','none');			
		$('#repeatEdit_'+popId).css('display','inline-block');	        
		$('.repeatEdit_db_'+popId).attr('onClick','disp_edit(popId)');	
  
		if(opt=="parent"){
			if(radio_1 == 1){
				$("#toText").hide();
				$("#sched_end_date1").hide();
				$("#sched_end_date2").show();
				
				$(".finalResult").html("Ends Never");					
			}
			if(radio_2 == 1){
				$("#toText").hide();
				$("#sched_end_date1").hide();
				$("#sched_end_date2").show();
				
				$(".finalResult").html("After "+after_occ+" occurrences");				
			}
			if(radio_3 == 1){
				$("#toText").show();
				$("#sched_end_date1").show();
				$("#sched_end_date2").hide();				
			}
		}
		return true;		
        }	
}
// Cancel button
function cancelRepeatDiv(popId){ 	
	closeRepeatDiv(popId);
}
// Edit page Cancel Button
function cancelRepeatDivDb(popId){ 	
	closeRepeatDiv(popId);	
}
function disp_edit_db(popId){
    var radio3 = $("#r3_"+popId).val();
    if(radio3==0){
        $("#repeatPOPUPDiv_"+popId+" .dateDivRepeat img").hide();
    }
    $(".repeatEdit_db_"+popId).attr("onClick","disp_edit()");
    $("#repeatPOPUPDiv_"+popId+" .cancelButton").attr("onClick","cancelRepeatDivDb(1)");
    $('#schedule_summary_'+popId).css('display','block');

    close_repeat_popup();
    $('#repeatPOPUPDiv_'+popId).css('display','block');
    $('#repeatCheck_'+popId).val('yes');
    $('#repeat_save_'+popId).val(1);
}
