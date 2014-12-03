var displaySummaryFirst=1;
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

// start date - parent and provider pages 
function modifyDate(popId){
	var formate1 = $("#dateFormate_1_"+popId).val();
	var formate2 =$("#date_1_"+popId).val();
	
	$("#started_date_disp_"+popId).val(formate1);
	$("#started_date_"+popId).val(formate2);
	
	var repeat_check = $('#repeatCheck_'+popId).val();
	
	if(repeat_check=="yes"){		
		setTimeout(function() { changedDayFormate(popId); } , 10)
	}
	setTimeout(function() { summary_date_time_changes(popId); } , 10)
}

// end date - parent page
function modifyDateTo(popId){
	var formate1 = "";
	var formate2 = "";
	
	formate1 = $("#dateFormate_2_"+popId).val();	
	
	if(formate1 != "" ){ 
		formate1 = $("#dateFormate_2_"+popId).val();
		formate2 = $("#date_2_"+popId).val();
	}
	else{ 
		formate1 = $("#dateFormate_1_"+popId).val();
		formate2 =$("#date_1_"+popId).val();
	}		
	
	var repeat_check = $('#repeatCheck_'+popId).val();
	
	if(repeat_check=="yes"){		
		$("#repeat_on_date_"+popId).val(formate1);
		$("#repeat_alt_on_date_"+popId).val(formate2);
	}
}

// ends on date - provider page 
function changedEndsonDate(popId){
	changed_summary(popId);
}

// ends on date - parent page 
function modifyDateEndsOn(popId){

	var formate1 = $("#repeat_on_date_"+popId).val();
	var formate2 =$("#repeat_alt_on_date_"+popId).val();
	
	$("#dateFormate_2_"+popId).val(formate1);
	$("#date_2_"+popId).val(formate2);		
	changed_summary(popId);
	summary_date_time_changes(popId);	
}
// summary date display  for parent and provider pages
function summary_date_time_changes(popId){  
	// current date
	var formate = '';
	var billing_type = '';
	var curTime = new Date();
	var cdate = curTime.getDate();
	var ccmonth = curTime.getMonth();
	var cyear = curTime.getFullYear();
	ccmonth = parseInt(ccmonth) + 1;
	var date_value = cyear + "-" + ccmonth + "-" + cdate;
	
	billing_type = $("#billing_type").val(); 
	
	if(billing_type == "Schedule"){
		$("#schedule_summary_"+popId).css('display','block');
		// if check repeat and repeat radio option
		var repeat_check = $('#repeatCheck_'+popId).val();
		var radio_1 = $('#r1_'+popId).val();
		var radio_2 = $('#r2_'+popId).val();	
		var radio_3 = $('#r3_'+popId).val();	


		var date_1 = $('#date_1_'+popId).val();   				// start hidden date
		var date_2 = $('#date_2_'+popId).val();  	
		// end hidden date

		var dateFormate_1 = $('#dateFormate_1_'+popId).val();		// start display date
		var dateFormate_2 = $('#dateFormate_2_'+popId).val();		// end display date

		var schedule_stime_1 = $('#schedule_stime_1_'+popId).val();  	// schedule start time	
		var firstVal_ss = schedule_stime_1.charAt(0);				// schedule start time - first char	
		if(firstVal_ss ==0){				
			schedule_stime_1 = schedule_stime_1.charAt(1)+schedule_stime_1.charAt(2)+schedule_stime_1.charAt(3)+schedule_stime_1.charAt(4);
		}

		var schedule_stime_2 = $('#schedule_stime_2_'+popId).val();	
		var schedule_etime_1 = $('#schedule_etime_1_'+popId).val();
		var firstVal_se = schedule_etime_1.charAt(0);
		if(firstVal_se ==0){
			schedule_etime_1 = schedule_etime_1.charAt(1)+schedule_etime_1.charAt(2)+schedule_etime_1.charAt(3)+schedule_etime_1.charAt(4);
		}
		var schedule_etime_2 = $('#schedule_etime_2_'+popId).val();		
			
		if(repeat_check == "yes" && radio_1 == 0 && radio_2 == 0 && radio_3 == 1){  
			var repeat_date = $('#repeat_alt_on_date_'+popId).val();		// repeat hidden date
			if( date_1 == repeat_date ) { 
				formate = dateFormate_1+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"</br>";
				$("#schedule_summary_"+popId+" #repeat_summary_text").css('display','none');	
			}
			else{
				formate = dateFormate_1+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"</br>";
				$("#schedule_summary_"+popId+" #repeat_summary_text").css('display','block');	
			}
		}
		else if(repeat_check == "yes" && radio_3 == 0){   
			formate = dateFormate_1+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"</br>";	
			$("#schedule_summary_"+popId+" #repeat_summary_text").css('display','block');	
		}
		/*else if(date_1!=date_2 && date_2!=''){
			formate = dateFormate_1+" - "+dateFormate_2+" "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"</br>";			
		}*/
		else{
			formate = dateFormate_1+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"</br>";	
		}
		
		$("#schedule_summary_"+popId+" #dateSummay").html(formate);	
	}	
	else if(billing_type == "Whole Day"){ 
		$("#wholeday_summay_"+popId).css('display','block');
		
		var wday_1 = $("#wday_1_"+popId).val();
		var wday_2 = $("#wday_2_"+popId).val();
		
		if(wday_1 == 1){  
			var whole_start = $('#datestartwhole_1_'+popId).val();		
			var whole_stime_1 = $('#whole_stime_1_'+popId).val();
			var firstVal_ws = whole_stime_1.charAt(0);
			if(firstVal_ws ==0){
				whole_stime_1 = whole_stime_1.charAt(1)+whole_stime_1.charAt(2)+whole_stime_1.charAt(3)+whole_stime_1.charAt(4);
			}			
			var whole_stime_2 = $('#whole_stime_2_'+popId).val();
			var whole_etime_1 = $('#whole_etime_1_'+popId).val();
			var firstVal_we = whole_etime_1.charAt(0);
			if(firstVal_we ==0){
				whole_etime_1 = whole_etime_1.charAt(1)+whole_etime_1.charAt(2)+whole_etime_1.charAt(3)+whole_etime_1.charAt(4);
			}			
			var whole_etime_2 = $('#whole_etime_2_'+popId).val();			
				
			formate = whole_start+", "+whole_stime_1+" "+whole_stime_2+" - "+whole_etime_1+" "+whole_etime_2+"</br>";	
		}
		
		else if(wday_2 == 1){
			var camps_start = $('#datestcamps_1_'+popId).val();
			var camps_end = $('#dateencamps_2_'+popId).val();
			
			var datestartcamps_1 = $('#datestartcamps_1_'+popId).val();
			var dateendcamps_2 = $('#dateendcamps_2_'+popId).val();
			
			var camps_stime_1 = $('#camps_stime_1_'+popId).val();
			var firstVal_cs = camps_stime_1.charAt(0);
			if(firstVal_cs ==0){
				camps_stime_1 = camps_stime_1.charAt(1)+camps_stime_1.charAt(2)+camps_stime_1.charAt(3)+camps_stime_1.charAt(4);
			}		
			var camps_stime_2 = $('#camps_stime_2_'+popId).val();
			var camps_etime_1 = $('#camps_etime_1_'+popId).val();
			var firstVal_ce = camps_etime_1.charAt(0);
			if(firstVal_ce ==0){
				camps_etime_1 = camps_etime_1.charAt(1)+camps_etime_1.charAt(2)+camps_etime_1.charAt(3)+camps_etime_1.charAt(4);
			}		
			var camps_etime_2 = $('#camps_etime_2_'+popId).val();			
		
			if( camps_start == camps_end ) { 
				formate = datestartcamps_1+", "+camps_stime_1+" "+camps_stime_2+" - "+camps_etime_1+" "+camps_etime_2+"</br>";	
			}			
			else{				
				formate = datestartcamps_1+", "+camps_stime_1+" "+camps_stime_2+" to "+dateendcamps_2+", "+camps_etime_1+" "+camps_etime_2+"</br>";	
			}			
		}
		$("#wholeday_summay_"+popId+" #dateSummay").html(formate);		
	}
	
}