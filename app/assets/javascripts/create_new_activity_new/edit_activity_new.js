			/////////////////////////////////////////////////////
			//////////    global declrations     /////////////////////
			/////////////////////////////////////////////////////
			
			
			var myChoose_schedule = new Array();
			var selected_net_option = new Array();
			var selected_adv_option = new Array();
			var myNetdiv = new Array();
			var myAdvdiv = new Array();
			var selected_adv_option = new Array();
			
			
			/////////////////////////////////////////////////////
			//////////    add new schedules     /////////////////////
			/////////////////////////////////////////////////////
			
			function added_new_schedule()
			{
			        billing_type = $("#billing_type").val();
		
			        if(billing_type == "Schedule"){
				myChoose_schedule.length = 0;	
				var popId = 0;
				var ar=$('#schedule_tabs').val();
				var ar1=ar.split(',');
				var arLen = ar1.length;
				    
				var formate = '';
				var billing_type = '';
				var curTime = new Date();
				var cdate = curTime.getDate();
				var ccmonth = curTime.getMonth();
				var cyear = curTime.getFullYear();
				ccmonth = parseInt(ccmonth) + 1;
				var date_value = cyear + "-" + ccmonth + "-" + cdate;
				var t_sched='';
				var t_schedadv='';
				var t_schedadv1='';
				var t_schednet1='';
				   
				
				for(var i=0;i<arLen;i++)
				{
				    popId = ar1[i];
				    var repeat_check = $('#repeatCheck_'+popId).val();
				    //alert(repeat_check);
				    var radio_1 = $('#r1_'+popId).val();
				    var radio_2 = $('#r2_'+popId).val();
				    var radio_3 = $('#r3_'+popId).val();
			    
					    
				    var date_1 = $('#date_1_'+popId).val();   				// start hidden date
				   // var date_2 = $('#date_2_'+popId).val();
				    // end hidden date
							    
				    var dateFormate_1 = $('#dateFormate_1_'+popId).val();		// start display date
				//    var dateFormate_2 = $('#dateFormate_2_'+popId).val();		// end display date
						    
				    var schedule_stime_1 = $('#schedule_stime_1_'+popId).val();  	// schedule start time
				    var firstVal_ss = schedule_stime_1.charAt(0);				// schedule start time - first char
				    if(firstVal_ss ==0){
				    //    schedule_stime_1 = schedule_stime_1.charAt(1)+schedule_stime_1.charAt(2)+schedule_stime_1.charAt(3)+schedule_stime_1.charAt(4);
				    }
					    
				    var schedule_stime_2 = $('#schedule_stime_2_'+popId).val();
				    var schedule_etime_1 = $('#schedule_etime_1_'+popId).val();
				    var firstVal_se = schedule_etime_1.charAt(0);
				    if(firstVal_se ==0){
				   //     schedule_etime_1 = schedule_etime_1.charAt(1)+schedule_etime_1.charAt(2)+schedule_etime_1.charAt(3)+schedule_etime_1.charAt(4);
				    }
					    
				    var schedule_etime_2 = $('#schedule_etime_2_'+popId).val();
					    
					    
				    if(repeat_check == "yes" && radio_1 == 0 && radio_2 == 0 && radio_3 == 1){
				        var repeat_date = $('#repeat_on_date_'+popId).val();		// repeat hidden date
				        if( date_1 == repeat_date ) {
					formate = dateFormate_1+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
					$("#schedule_summary_"+popId+" #repeat_summary_text").css('display','none');
				        
				        }
				        else{
					formate = dateFormate_1+" - "+repeat_date+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
					$("#schedule_summary_"+popId+" #repeat_summary_text").css('display','block');
				         
				        }
				    }
				    else if(repeat_check == "yes" && radio_3 == 0){
				        formate = dateFormate_1+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
				        $("#schedule_summary_"+popId+" #repeat_summary_text").css('display','block');
				    
				    }
				/*    else if(date_1!=date_2 && date_2!=''){
				        formate = dateFormate_1+" - "+dateFormate_2+" "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
				    
				    }*/
				    else{
				        formate = dateFormate_1+", "+schedule_stime_1+" "+schedule_stime_2+" - "+schedule_etime_1+" "+schedule_etime_2+"_"+popId+"</br>";
				    
				    }
				    schedule_formate=formate.slice(0,-5);
				   myChoose_schedule.push(schedule_formate); // push to the schedule array.
				  
				   
				
			        }
			    }
		    else if(billing_type == "Whole Day"){
		        
				 myChoose_schedule.length = 0;	
				var popId = 0;
				var ar=$('#schedule_tabs').val();
				var ar1=ar.split(',');
				var arLen = ar1.length;
				    
				var formate = '';
				var billing_type = '';
				var curTime = new Date();
				var cdate = curTime.getDate();
				var ccmonth = curTime.getMonth();
				var cyear = curTime.getFullYear();
				ccmonth = parseInt(ccmonth) + 1;
				var date_value = cyear + "-" + ccmonth + "-" + cdate;
				 var ar=$('#whole_day_tabs').val();
				var ar1=ar.split(',');
				var arLen = ar1.length;
			           
					    var whole_net='';
					    var whole_adv='';
					    var t_schednet11='';
					    var t_schedadv11='';
									    var continue_click= $('#continue_click').val();
				for(a=0;a<arLen;a++)
				{
				    popId=ar1[a];
						        
				    $("#wholeday_summay_"+popId).css('display','block');
					    
				    var wday_1 = $("#wday_1_"+popId).val();
				    var wday_2 = $("#wday_2_"+popId).val();
						        
				    if(wday_1 == 1){
				        var whole_start = $('#datestartwhole_1_'+popId).val();
				        var whole_stime_1 = $('#whole_stime_1_'+popId).val();
				        var firstVal_ws = whole_stime_1.charAt(0);
				        if(firstVal_ws ==0){
					//whole_stime_1 = whole_stime_1.charAt(1)+whole_stime_1.charAt(2)+whole_stime_1.charAt(3)+whole_stime_1.charAt(4);
				        }
				        var whole_stime_2 = $('#whole_stime_2_'+popId).val();
				        var whole_etime_1 = $('#whole_etime_1_'+popId).val();
				        var firstVal_we = whole_etime_1.charAt(0);
				        if(firstVal_we ==0){
					//whole_etime_1 = whole_etime_1.charAt(1)+whole_etime_1.charAt(2)+whole_etime_1.charAt(3)+whole_etime_1.charAt(4);
				        }
				        var whole_etime_2 = $('#whole_etime_2_'+popId).val();
								        
				        formate = whole_start+" ,"+whole_stime_1+" "+whole_stime_2+" - "+whole_etime_1+" "+whole_etime_2+"_"+popId+"</br>";
				    }
						        
				    else if(wday_2 == 1){
				        var camps_start = $('#datestcamps_1_'+popId).val();
				        var camps_end = $('#dateencamps_2_'+popId).val();
							        
				        var datestartcamps_1 = $('#datestartcamps_1_'+popId).val();
				        var dateendcamps_2 = $('#dateendcamps_2_'+popId).val();
							        
				        var camps_stime_1 = $('#camps_stime_1_'+popId).val();
				        var firstVal_cs = camps_stime_1.charAt(0);
				        if(firstVal_cs ==0){
					//camps_stime_1 = camps_stime_1.charAt(1)+camps_stime_1.charAt(2)+camps_stime_1.charAt(3)+camps_stime_1.charAt(4);
				        }
				        var camps_stime_2 = $('#camps_stime_2_'+popId).val();
				        var camps_etime_1 = $('#camps_etime_1_'+popId).val();
				        var firstVal_ce = camps_etime_1.charAt(0);
				        if(firstVal_ce ==0){
					//camps_etime_1 = camps_etime_1.charAt(1)+camps_etime_1.charAt(2)+camps_etime_1.charAt(3)+camps_etime_1.charAt(4);
				        }
				        var camps_etime_2 = $('#camps_etime_2_'+popId).val();
						        
				        if( camps_start == camps_end ) {
					formate = datestartcamps_1+" ,"+camps_stime_1+" "+camps_stime_2+" - "+camps_etime_1+" "+camps_etime_2+"_"+popId+"</br>";
				        }
				        else{
					formate = datestartcamps_1+", "+camps_stime_1+" "+camps_stime_2+" - "+dateendcamps_2+", "+camps_etime_1+" "+camps_etime_2+"_"+popId+"</br>";
				        }
				           
					
				    }
				    schedule_formate1=formate.slice(0,-5);
				    myChoose_schedule.push(schedule_formate1); // push to the schedule array.		         
			     
			
			     }
			}
		        }	
			
			
			//////////////////////////////////////////////////
			//////////////  Schedule delete   //////////////////
			/////////////////////////////////////////////////
			
			    function  delete_the_schedules(v)
			    {
				    
				    for(i=0;i<mySchedule.length;i++)//indexof property not works ie<9 browsers .so removal divs like this
					{
						if(mySchedule[i]==v)
						{							
							mySchedule.splice(i,1);
							myChoose_schedule.splice(v,1);
							// $("#choose_schedule_net_"+myNetdiv[myNetdiv.length-1]+"_1").append('<option  value="' + deleted_schedule + '">' +deleted_schedule+ '</option>'); //apend to the open dropdwon
						}
						
					}
					
					
				
					
				        $('#schedule_tabs').val(''); // removing schedule tab numbers
				        $('#schedule_tabs').val(mySchedule);
				        $( "#schedule_rows_outer_"+v ).remove();// removing the schedule div
				        
				        
					if(mySchedule.length>1)// if net price div greater than one div add and delete button manage
					{
						for(i=0;i<(mySchedule.length);i++)
						{
							$("#add_schedule_"+mySchedule[i]).css("display","none");
							$("#delete_schedule_"+mySchedule[i]).css("display","block");
							$("#add_schedule_"+mySchedule[mySchedule.length-1]).css("display","block");
	
						}					

					}
					else if(((mySchedule.length==myNetdiv.length)||(mySchedule.length==myAdvdiv.length))&&(mySchedule.length>1))
					{
					    for(i=0;i<(mySchedule.length);i++)
					    {
							$("#add_schedule_"+mySchedule[i]).css("display","none");
							$("#delete_schedule_"+mySchedule[i]).css("display","block");
					        
					    }
					}
					else //if net price div only one 
					{
						$("#delete_schedule_"+mySchedule[mySchedule.length-1]).css("display","none");
						$("#add_schedule_"+mySchedule[mySchedule.length-1]).css("display","block");
					}
					
				////****************	removing the price divs on third step if it present   **************////
				
				/***************************************************************/
				/*****************               first net price            ********************/
				/**************************************************************/
				
				for(i=0;i<(myNetdiv.length);i++)
				{//alert(myNetdiv);
					var netdel= $("#chosen_sc_"+myNetdiv[i]+"_1").val();
					//alert(netdel+'netdel');
					if(v==netdel)
					{
					        delete_net_price(netdel);
					}
				}
				
				
				/***************************************************************/
				/*****************               Second advance  price           *************/
				/**************************************************************/
				for(i=0;i<(myAdvdiv.length);i++)
				{
					var advdel= $("#chosen_ad_sc_"+myAdvdiv[i]+"_1").val();
					if(v==advdel)
					{
					        delete_ad_net_price(advdel);
					}
				}
		
				        
			    }
			//////////////////////////////////////////////////
			//////////////  Array difference    //////////////////
			/////////////////////////////////////////////////

			function arr_diff(a1, a2)
			{
 				 var a=[], diff=[];
				 for(var i=0;i<a1.length;i++)
				 	 a[a1[i]]=true;
  				 for(var i=0;i<a2.length;i++)
  				 	 if(a[a2[i]]) delete a[a2[i]];
  					  else a[a2[i]]=true;
 				 for(var k in a)
 				  	 diff.push(k);
 				 return diff;
			}
			
			
			
			
			/////////////////////////////////////////////////////
			////////////net price whole div add ////////////////////
			////////////////////////////////////////////////////
			
			
			
			
			
function validate_notes_netprice(s,d)
{

		if(d==0){// price interchange 
						myNetdiv.length = 0;
						selected_net_option.length=0;
						$('.net_prices').remove();
						
						
			    }
    
		var net='net';
		 var e = document.getElementById('billing_type');
		 var strSelected = e.options[e.selectedIndex].value;
		if(strSelected=="Schedule")
		{
		    var cont_inue= $('#net_continue_sc').val();
			   
		}
		else{
			 var cont_inue= $('#net_continue_wsc').val();
		 }
		        
		if((s=='0')&&(cont_inue=='0')){
		     
		    $('#netPriceDiv .priceContainer').remove();
		     var netPriceDiv='';
		      var append_sc='';
		   
		     var schedules=$('#total_schedule').val();
		     schedules=schedules.slice(0,-5);
		        schedules=schedules.split("</br>");
		////////////////////
		
	
			        to_choose_net_opt=arr_diff(myChoose_schedule,selected_net_option);// get the remaing to choose
		
							
									append_sc+='<option value="">--choose--</option>';
								
		
							for(j=0;j<to_choose_net_opt.length;j++) // adding schedules as options to drop dwon
							{
								
								to_choose_net=to_choose_net_opt[j].split('_');
								append_sc+='<option value="'+to_choose_net_opt[j]+'">'+to_choose_net[0]+'</option>';
								
							}
			
		//////////////////
						
						
		       
						    
		        s++;				
		       myNetdiv.push(s);// push element to netprice array
   
			 myNetdiv=jQuery.unique(myNetdiv);
  
		          netPriceDiv+='<div class="priceContainer netprices" id="netPriceDiv_'+s+'"><input id="earlybid_decide_'+s+'" type="hidden" value="0" name="earlybid_decide_'+s+'"><input type="hidden" name="last_discount_id_'+s+'_1" id="last_discount_id_'+s+'_1" value="0"><input type="hidden" name="delete_discount_id_'+s+'_1" id="delete_discount_id_'+s+'_1" value="'+s+'_1_0"><input id="selected_net_value_'+s+'" type="hidden" value="" name="selected_net_value_'+s+'"><input type="hidden" name="last_in_discount_id_'+s+'" id="last_in_discount_id_'+s+'" value="'+s+'_1_0"><table cellpadding="0" cellspacing="0" border="0"><tr><td><div class="priceOuterDiv" id="net_priceOuterDiv_'+s+'">';
		        netPriceDiv+='<table cellpadding="0" cellspacing="0" border="0" id="net_price_div_1_'+s+'"><tr><td id="added_price_'+s+'"><table cellspacing="0" cellpadding="0" border="0"><tr><td><div class="lt  advancedPriceContainer" id="advancedPriceContainer_'+s+'_1" ><div id="chosen_sc_txt_'+s+'_2_0" style="display: none;" class="choosen_head"></div><div class="chosen_op"  id="chosen_sc_txt_'+s+'_1_0" style="display: none;" ></div><div class="priceRow1_top" style="padding-top:0px;"><div class="lt blackText setWidthPrice3">Choose Schedule</div><div class="lt blackText setWidthPrice"> Net Price</div><div class="clear"></div></div>';
		        netPriceDiv+='<div class="priceRow1_bottom"> <div class="lt"><select name="choose_schedule_net_'+s+'_1 " onchange="choose_schedule('+s+',\'net\')" id="choose_schedule_net_'+s+'_1" class="drop_down_left width_set7 choose_schedule" style="margin-left: 0px;"></select><input type="text" id="chosen_sc_txt_'+s+'_1_0"  size="30"  readonly="readonly" class="lt textbox1" name="chosen_sc_txt_1_1_4" value="" style="display: none;"><input type="hidden" id="chosen_sc_'+s+'_1" name="chosen_sc_'+s+'_1" value=""><input type="hidden" id="all_sc_'+s+'_1_0" name="all_sc_'+s+'_1_0" value=""/></div><input type="text" id="price_'+s+'_1" name="price_'+s+'_1" class="lt textbox" value="Enter Price" onfocus="focusChangeBorderColor1(\'price_'+s+'_1\')" maxlength="7" onKeyPress="return number(event);" onblur="blurChangeBorderColor1(\'price_'+s+'_1\')" style="width:152px;margin-left: 6px;" />';
						
		        netPriceDiv+='<div class="clear"></div></div>';
		        netPriceDiv+='<div class="clear"></div> <input type="hidden" name="multiple_discount_count_net_1_'+s+'_1" id="multiple_discount_count_net_1_'+s+'_1" value=""/><div class="createDynamicDiscount_net_1_1"></div><div class="clear"></div>';
		        /********************/
			/*
			netPriceDiv+='<div id="staticDiscount_net_1_1_0"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_net_'+s+'_'+1+'_0">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_net_'+s+'_1_0"style="width:185px">Discount Amount/Percentage</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_net_'+s+'_1_0"style="width:185px">Discount Amount/Percentage</div><div class="clear"></div></div>';
					 
					 
		        netPriceDiv+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type_net" id="discount_type_net_'+s+'_1_0"><select name="ad_discount_type_net_'+s+'_1_0" id="ad_discount_type_net_'+s+'_1_0" class="drop_down_left width_set6" onchange="discTypeChanged(\'net\','+s+',1,0,this.value,1);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'net\',1,1,this.value)"> <option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option> </select></div>    ';
		        netPriceDiv+='<div id="session_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li></ul></li></ul><div class="clear"></div></div></div>';
		        netPriceDiv+='<input type="text" id="ad_no_sess_net_'+s+'_1_0" name="ad_no_sess_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
		        netPriceDiv+='<input type="text" id="ad_discount_sess_price_net_'+s+'_1_0" name="ad_discount_sess_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
					
		        netPriceDiv+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_net_'+s+'_1_0" id="ad_discount_sess_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
		        netPriceDiv+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_session(\'net\','+s+',1,0,0,1)"  id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" style="display:block; position:relative;left:10px;"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_session_error_net_'+s+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
		        netPriceDiv+='<div id="participant_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
		        netPriceDiv+='<input type="text" id="ad_no_part_net_'+s+'_1_0" name="ad_no_part_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				
		        netPriceDiv+='<input type="text" id="ad_discount_part_price_net_'+s+'_1_0" name="ad_discount_part_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
		        netPriceDiv+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_net_'+s+'_1_0" id="ad_discount_part_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option> <option value="%">%</option></select></div>';
		        netPriceDiv+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_participant(\'net\','+s+',1,0,0,1)" id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" style="display:block; position:relative;left:10px;"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
		        netPriceDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_net_'+s+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div> ';
				
		        netPriceDiv+='<div class="clear"></div><div id="early_brid_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
		        netPriceDiv+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText" style="width:154px" >Valid  Until</div><div class="lt blackText setWidthDiscount" id="no_part_net_'+s+'_1_0"style="width:185px">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
		        netPriceDiv+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_net_'+s+'_1_0" name="ad_no_subs_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
		        netPriceDiv+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_net_'+s+'_1_0" name="ad_valid_date_net_'+s+'_1" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_net_'+s+'_1_0" name="ad_valid_date_alt_net_'+s+'_1_0" value="" /></div></div>    ';
				
		        netPriceDiv+='<input type="text" id="ad_discount_price_net_'+s+'_1_0" name="ad_discount_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
		        netPriceDiv+='<div class="lt price_type"><select name="ad_discount_price_type_net_'+s+'_1_0" id="ad_discount_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
		        netPriceDiv+='<div class="lt add_delete_icons" id="early_bid_icons_net_'+s+'_1_0"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" title="" onClick="validate_early_bid(\'net\','+s+',1,0,0,1)" style="display:block; position:relative;left:10px;" class="lt addButton_net_'+b+'_1 single_add_net_'+b+'_1_0"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
		        netPriceDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_net_'+s+'_1_0"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div>';
			*//***************/	    
						
		        netPriceDiv+='<div id="dynamicNetPrice_1"></div><div class="errorDiv" style="display:none;"><div id="net_advance_error_1_'+s+'_1"></div></div><div class="clear"></div></div>';
		        //netPriceDiv+='  <td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+s+'_1"> <div class="delete_schedule delete_schedule_'+s+'" id="inn_delete_schedule_'+s+'_1"style="margin-top:0px;display:none" onclick="delete_in_net_price('+s+',1)">&nbsp;</div><div onclick="add_net_advanced_price('+s+',1)" id="add_schedule_1" style="margin-top: 0px; display: block;" class="add_schedules add_schedules_'+s+'">&nbsp;</div> </div></td>';
						
						
		        netPriceDiv+='</tr></table><div class="clear"></div></td></tr></table><div class="clear"></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="neprice_error_net_'+s+'_1"></div></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
						
		        netPriceDiv+='<div class="Recuring_billing"><table  border="0"><tr>';
		        netPriceDiv+='<td width="165" valign="middle"><span class="left_billing_img"><span id= "img_show_'+s+'"class="select_billing_img_show" onclick="select_range_billing(0,'+s+')"></span><span id="img_hide_'+s+'" class="select_billing_img_hide" onclick="select_range_billing(1,'+s+')"></span></span><span class="select_billing_content">enable recurring billing</span></td>';
		        netPriceDiv+='<td><span class="inner">actuall billing will be base on  final discounted price if applicable</span></td></tr></table>';
		        netPriceDiv+='<div class="dynamicAdvancedPrice"></div><table  class="recurring_slide_dwon" id="recurring_slide_dwon_'+s+'" border="0" >';
		        netPriceDiv+='<tr><td width="200" valign="middle"><span class="terms">weekly</span></td> <td width="200" valign="middle"><div class="no_of">No.of  weeks</div><div class="cou_nts">48</div></td><td width="200" valign="middle"><span class="no_of">amount</span><span class="cou_nts">$ 8</span></td></tr>';
		        netPriceDiv+='<tr><td ><span class="terms">monthly</span></td> <td><div class="no_of">No.of months</div><div class="cou_nts">24</div></td><td><span class="no_of">amount</span><span class="cou_nts">$ 8</span></td></tr>';
		        netPriceDiv+='<tr><td><span class="terms">quartely</span></td> <td><div class="no_of">No.of terms</div><div class="cou_nts">8</div></td><td><span class="no_of">amount </span><span class="cou_nts">$ 8</span></td></tr></table></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
						
		        netPriceDiv+='<div class="notesDiv"><textarea name="net_notes_'+s+'_1" id="net_notes_'+s+'_1" rows="10" cols="40"  class="lt textbox descTextbox" style="height:50px; width:485px;" onfocus="if(this.value==\'Notes:\'){this.value=\'\';$(this).css(\'color\',\'#444444\');}" onblur="if(this.value==\'\'){this.value=\'Notes:\';$(this).css(\'color\',\'#999999\');}" >Notes:</textarea><div class="clear"></div></div>';
		        netPriceDiv+='<div class="clear"></div></div></td><td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+s+'"><div class="delete_schedule_net" id="o_delete_schedule_'+s+'"  style="margin-top:0px;" onclick="delete_net_price('+s+',0)">&nbsp;</div><div  onClick="validate_notes_netprice('+s+')" id="o_add_schedule_'+s+'"  style="margin-top:0px;"class="out_add_schedule">&nbsp;</div></div>';
		        netPriceDiv+='<div class="clear"></div></td></tr></table></div> </div><div class="clear"></div>';
		        
		        
		       
		        $("#netPriceDiv").append(netPriceDiv);
			$("#save_result").val('');// intilizing the total divs created ;
			$("#delete_discount_id_1_1").val('');// intilizing the delete the divs created;
			// $(netPriceDiv).appendTo ("#netPriceDiv");
			 ///////////////////////////
			 //       add the early divs /////
			 //////////////////////////
			$.ajax({
			    type: "POST",
			    url: "activity_detail/create_first_discount_type",
			    data:{
				"net":"net_",
				"id1":s,
				"id2":1,
				"id3":0
			    },
			    success: function(html){
				$("#advancedPriceContainer_"+s+"_1").append(html);
				
			    } 
			});
			
		   /*  $("#o_delete_schedule_1").css("display","none");
		   / * $(".add_schedule_"+s).css("display","block");*/
		     $("#choose_schedule_net_1_1").append(append_sc);
		     
		 //    alert(myChoose_schedule.length+'=='+myNetdiv.length);
		    if(myChoose_schedule.length==myNetdiv.length)// push the value to selected array list
					{
						
						to_remain_net_opt=arr_diff(myChoose_schedule,selected_net_option);
						selected_net_option.push(to_remain_net_opt[0]);
						$('#selected_net_value_'+s).val(to_remain_net_opt[0]);
						   strSelected12=to_remain_net_opt[0].split('_');
					
					$('#chosen_sc_'+myNetdiv[myNetdiv.length-1]+'_1').val(strSelected12[1]);

					}
				
		}
							
		
	          else{
		    var append_sc='';
			   
			
		    var ew = document.getElementById("choose_schedule_net_"+s+"_1");
		    var strSelectedw = ew.options[ew.selectedIndex].value;
			
				
		    var netPriceDiv='';
		    var h1=$("#last_in_discount_id_"+s).val();
		    var sd=h1.split(",")
		    for(var i=0;i<sd.length;i++){
		      
		        var select_box='ad_discount_type_net_'+sd[i];
		        h1=sd[i].split("_");
		        var b=s;
		        var q=h1[1];
		        var h=h1[2];
		        var e = document.getElementById(select_box);
		        var strSelected = e.options[e.selectedIndex].value;
					
		        if(strSelected!=""){
				
			var net='net_';
			var yes=validate_early_bid(net,b,q,h,0,0,'');
			if(yes=='0'){
			    break;
			}
						
		        }
		        
		        else{
					   
			var net='net';
					    
			var yes=validate_nothing_selected(net,b,q,h,0,0,'');
			if(yes=='0'){
			    break;
			}
						
		        }
		    }
				
				  
					
		    if(yes==1){
			
		        var  yt=$('#total_schedule').val();
		        var byt=yt.slice(0,-5);
		        $('#changing_schedule_net_base').val(byt);
		        $( "#choose_schedule_net_"+s+"_1" ).removeClass( "choose_schedule" );
		        
		        net_database=$('#net_database').val();
		        choose_schedules(s,'net',net_database) ;//
		        strSelectedw1= strSelectedw.split('_')
		        $( "#choose_schedule_net_"+s+"_1" ).css( "display"," none"  );
		        $(' .setWidthPrice3').css( "display"," none"  );
		        $( "#chosen_sc_txt_"+s+"_2_0" ).css( "display"," block"  );
		        $( "#chosen_sc_txt_"+s+"_2_0" ).text( "Chosen Schedule" );
		        $( "#chosen_sc_txt_"+s+"_1_0" ).css( "display"," block"  );
		        
		        var tt=$('#edit_schedule_div_net_count').val();
		        tt=tt.split(',');
		      
		        ttt=tt[tt.length-1].split('_');
		        if(ttt[0]!=s){
		      
			$( "#chosen_sc_txt_"+s+"_1_0" ).text( strSelectedw1[0]  );
		        }
		        $('#changing_schedule_decide').val('');
		        $('#changing_schedule_decide').val('1');
							
						       
		        //   $( "#choose_schedule_net_"+s+"_1" ).css( "pointer-events"," none"  );
		        //      $( "#choose_schedule_net_"+s+"_1" ).css(" cursor","default" );
		        s++;
		        myNetdiv.push(s);// push element to netprice array
		        
		     myNetdiv=jQuery.unique(myNetdiv);
		        var schedules=$('#changing_schedule_net').val();
		        schedules=schedules.split("</br>");
						
			
		
						
		     			
			to_choose_net_opt=arr_diff(myChoose_schedule,selected_net_option);// get the remaing to choose
		
							
									append_sc+='<option value="">choose</option>';
								
		
							for(j=0;j<to_choose_net_opt.length;j++) // adding schedules as options to drop dwon
							{
								to_choose_net=to_choose_net_opt[j].split('_');
								append_sc+='<option value="'+to_choose_net_opt[j]+'">'+to_choose_net[0]+'</option>';
								
							}			  
						
						
		     /*   if(s>1)
		        {
			$("#o_delete_schedule_1").css("display","block");
										    
		        }
					  
		        $(".out_add_schedule").css("display","none");
			*/		
						
		        netPriceDiv+='<div class="priceContainer netprices" id="netPriceDiv_'+s+'"><input id="earlybid_decide_'+s+'" type="hidden" value="0" name="earlybid_decide_'+s+'"><input type="hidden" name="last_in_discount_id_'+s+'" id="last_in_discount_id_'+s+'" value="'+s+'_1_0"><input type="hidden" name="last_discount_id_'+s+'_1" id="last_discount_id_'+s+'_1" value="0"><input id="selected_net_value_'+s+'" type="hidden" value="" name="selected_net_value_'+s+'"><input type="hidden" name="delete_discount_id_'+s+'_1" id="delete_discount_id_'+s+'_1" value="'+s+'_1_0"><table cellpadding="0" cellspacing="0" border="0"><tr><td><div class="priceOuterDiv" id="net_priceOuterDiv_'+s+'">';
		        netPriceDiv+='<table cellpadding="0" cellspacing="0" border="0" id="net_price_div_1_'+s+'"><tr><td id="added_price_'+s+'"><table cellspacing="0" cellpadding="0" border="0"><tr><td><div class="lt  advancedPriceContainer" id="advancedPriceContainer_'+s+'_1" ><div id="chosen_sc_txt_'+s+'_2_0" style="display: none;" class="choosen_head"></div><div class="chosen_op"  id="chosen_sc_txt_'+s+'_1_0" style="display: none;" ></div><div class="priceRow1_top" style="padding-top:0px;"><div class="lt blackText setWidthPrice3">Choose Schedule</div><div class="lt blackText setWidthPrice"> Net Price</div><div class="clear"></div></div>';
		        netPriceDiv+='<div class="priceRow1_bottom"> <div class="lt"><select name="choose_schedule_net_'+s+'_1 " onchange="choose_schedule('+s+',\'net\')" id="choose_schedule_net_'+s+'_1" class="drop_down_left width_set7 choose_schedule" style="margin-left: 0px;"></select><input type="text" id="chosen_sc_txt_'+s+'_1_0"  size="30"  readonly="readonly" class="lt textbox1" name="chosen_sc_txt_1_1_4" value="" style="display: none;"><input type="hidden" id="chosen_sc_'+s+'_1" name="chosen_sc_'+s+'_1" value=""><input type="hidden" id="all_sc_'+s+'_1_0" name="all_sc_'+s+'_1_0" value=""/></div><input type="text" id="price_'+s+'_1" name="price_'+s+'_1" class="lt textbox" value="Enter Price" onfocus="focusChangeBorderColor1(\'price_'+s+'_1\')" maxlength="7" onKeyPress="return number(event);" onblur="blurChangeBorderColor1(\'price_'+s+'_1\')" style="width:152px;margin-left: 6px;" />';
						
		        netPriceDiv+='<div class="clear"></div></div>';
		        netPriceDiv+='<div class="clear"></div> <input type="hidden" name="multiple_discount_count_net_1_'+s+'_1" id="multiple_discount_count_net_1_'+s+'_1" value=""/><div class="createDynamicDiscount_net_1_1"></div><div class="clear"></div>';
		     
		     /***/
		     /*
			netPriceDiv+='<div class="staticDiscount_net_1_1" id="staticDiscount_net_'+s+'_1_0"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_net_'+s+'_'+1+'_0">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_net_'+s+'_1_0"style="width:185px">Discount Amount/Percentage</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_net_'+s+'_1_0"style="width:185px">Discount Amount/Percentage</div><div class="clear"></div></div>';
					 
					 
		        netPriceDiv+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type_net" id="discount_type_net_'+s+'_1_0"><select name="ad_discount_type_net_'+s+'_1_0" id="ad_discount_type_net_'+s+'_1_0" class="drop_down_left width_set6" onchange="discTypeChanged(\'net\','+s+',1,0,this.value,1);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'net\',1,1,this.value)"> <option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option> </select></div>    ';
		        netPriceDiv+='<div id="session_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li></ul></li></ul><div class="clear"></div></div></div>';
		        netPriceDiv+='<input type="text" id="ad_no_sess_net_'+s+'_1_0" name="ad_no_sess_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
		        netPriceDiv+='<input type="text" id="ad_discount_sess_price_net_'+s+'_1_0" name="ad_discount_sess_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
					
		        netPriceDiv+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_net_'+s+'_1_0" id="ad_discount_sess_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
		        netPriceDiv+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_session(\'net\','+s+',1,0,0,1)"  id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" style="display:block; position:relative;left:10px;"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_session_error_net_'+s+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
		        netPriceDiv+='<div id="participant_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
		        netPriceDiv+='<input type="text" id="ad_no_part_net_'+s+'_1_0" name="ad_no_part_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				
		        netPriceDiv+='<input type="text" id="ad_discount_part_price_net_'+s+'_1_0" name="ad_discount_part_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
		        netPriceDiv+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_net_'+s+'_1_0" id="ad_discount_part_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option> <option value="%">%</option></select></div>';
		        netPriceDiv+='<div class="lt add_delete_icons"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_participant(\'net\','+s+',1,0,0,1)" id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" style="display:block; position:relative;left:10px;"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
		        netPriceDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_net_'+s+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div> ';
				
		        netPriceDiv+='<div class="clear"></div><div id="early_brid_net_'+s+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
		        netPriceDiv+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText" style="width:154px" >Valid  Until</div><div class="lt blackText setWidthDiscount" id="no_part_net_'+s+'_1_0"style="width:185px">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
		        netPriceDiv+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_net_'+s+'_1_0" name="ad_no_subs_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value =\'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
		        netPriceDiv+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_net_'+s+'_1_0" name="ad_valid_date_net_'+s+'_1" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_net_'+s+'_1_0" name="ad_valid_date_alt_net_'+s+'_1_0" value="" /></div></div>    ';
				
		        netPriceDiv+='<input type="text" id="ad_discount_price_net_'+s+'_1_0" name="ad_discount_price_net_'+s+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
		        netPriceDiv+='<div class="lt price_type"><select name="ad_discount_price_type_net_'+s+'_1_0" id="ad_discount_price_type_net_'+s+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
		        netPriceDiv+='<div class="lt add_delete_icons" id="early_bid_icons_net_'+s+'_1_0"><div class="delete_single_schedule delete_single_schedule_'+s+'_1" style="margin-top:0px;display:none" onclick="delete_single_net_price(\''+net+'\','+s+',1,0)">&nbsp;</div><a href="javascript:void(0)" id="single_add_net_'+s+'_1_0" class="addButton_net_'+s+'_1 single_add_net_'+s+'_1_0" title="" onClick="validate_early_bid(\'net\','+s+',1,0,0,1)" style="display:block; position:relative;left:10px;" class="lt addButton_net_'+b+'_1 single_add_net_'+b+'_1_0"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
		        netPriceDiv+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_net_'+s+'_1_0"></div></div><div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div></div>';
			*/	    
			/**************/			
		        netPriceDiv+='<div class="errorDiv" style="display:none;"><div id="net_advance_error_1_'+s+'_1"></div></div><div class="clear"></div></div>';
		        //netPriceDiv+='  <td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+s+'_1"> <div class="delete_schedule delete_schedule_'+s+'" id="inn_delete_schedule_'+s+'_1"style="margin-top:0px;display:none" onclick="delete_in_net_price('+s+',1)">&nbsp;</div><div onclick="add_net_advanced_price('+s+',1)" id="add_schedule_1" style="margin-top: 0px; display: block;" class="add_schedules add_schedules_'+s+'">&nbsp;</div> </div></td>';
						
						
		        netPriceDiv+='</tr></table><div class="clear"></div></td></tr></table><div class="clear"></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="neprice_error_net_'+s+'_1"></div></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
						
		        netPriceDiv+='<div class="Recuring_billing"><table  border="0"><tr>';
		        netPriceDiv+='<td width="165" valign="middle"><span class="left_billing_img"><span id= "img_show_'+s+'"class="select_billing_img_show" onclick="select_range_billing(0,'+s+')"></span><span id="img_hide_'+s+'" class="select_billing_img_hide" onclick="select_range_billing(1,'+s+')"></span></span><span class="select_billing_content">enable recurring billing</span></td>';
		        netPriceDiv+='<td><span class="inner">actuall billing will be base on  final discounted price if applicable</span></td></tr></table>';
		        netPriceDiv+='<div class="dynamicAdvancedPrice"></div><table  class="recurring_slide_dwon" id="recurring_slide_dwon_'+s+'" border="0" >';
		        netPriceDiv+='<tr><td width="200" valign="middle"><span class="terms">weekly</span></td> <td width="200" valign="middle"><div class="no_of">No.of  weeks</div><div class="cou_nts">48</div></td><td width="200" valign="middle"><span class="no_of">amount</span><span class="cou_nts">$ 8</span></td></tr>';
		        netPriceDiv+='<tr><td ><span class="terms">monthly</span></td> <td><div class="no_of">No.of months</div><div class="cou_nts">24</div></td><td><span class="no_of">amount</span><span class="cou_nts">$ 8</span></td></tr>';
		        netPriceDiv+='<tr><td><span class="terms">quartely</span></td> <td><div class="no_of">No.of terms</div><div class="cou_nts">8</div></td><td><span class="no_of">amount </span><span class="cou_nts">$ 8</span></td></tr></table></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
						
		        netPriceDiv+='<div class="notesDiv"><textarea name="net_notes_'+s+'_1" id="net_notes_'+s+'_1" rows="10" cols="40"  class="lt textbox descTextbox" style="height:50px; width:485px;" onfocus="if(this.value==\'Notes:\'){this.value=\'\';$(this).css(\'color\',\'#444444\');}" onblur="if(this.value==\'\'){this.value=\'Notes:\';$(this).css(\'color\',\'#999999\');}" >Notes:</textarea><div class="clear"></div></div>';
		        netPriceDiv+='<div class="clear"></div></div></td><td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+s+'"><div class="delete_schedule_net" id="o_delete_schedule_'+s+'"  style="margin-top:0px;" onclick="delete_net_price('+s+',0)">&nbsp;</div><div  onClick="validate_notes_netprice('+s+')" id="o_add_schedule_'+s+'"  style="margin-top:0px;"class="out_add_schedule">&nbsp;</div></div>';
		        netPriceDiv+='<div class="clear"></div></td></tr></table></div> </div><div class="clear"></div>';
		        
		        $("#netPriceDiv").append(netPriceDiv);
			
			///////////////////////////
			 //       add the early divs /////
			 //////////////////////////
			$.ajax({
			    type: "POST",
			    url: "activity_detail/create_first_discount_type",
			    data:{
				"net":"net_",
				"id1":s,
				"id2":1,
				"id3":0
			    },
			    success: function(html){
				$("#advancedPriceContainer_"+s+"_1").append(html);
				
			    } 
			});
						
		     /*   if(schedules.length==1)
		        {
			$("#o_add_schedule_"+s).css("display","none");
										    
		        }*/
		        $("#choose_schedule_net_"+s+"_1").append(append_sc);
		        save_result=$("#save_result").val();
		        var et=s+'_1_0';
		        save_result+=','+et;
			save_result=save_result.split(',');
			save_result1=jQuery.unique(save_result);
		        $("#save_result").val(save_result1);
		        var total_div_count=$("#total_div_count").val();
		        total_div_count+=','+s+'_1';
		        $("#total_div_count").val(total_div_count);
						
		        $('#saving_error').css("display","none");
		      //  alert(myChoose_schedule.length+'=='+myNetdiv.length);
		       if(myChoose_schedule.length==myNetdiv.length)// push the value to selected array list
					{//alert('dfg');
						
						to_remain_net_opt=arr_diff(myChoose_schedule,selected_net_option);
						selected_net_option.push(to_remain_net_opt[0]);
						$('#selected_net_value_'+s).val(to_remain_net_opt[0])
						   strSelected12=to_remain_net_opt[0].split('_');
					
					$('#chosen_sc_'+myNetdiv[myNetdiv.length-1]+'_1').val(strSelected12[1]);
		

					}
					
		    }
		 }
				
					
					

					if((myNetdiv.length>1)&&(myNetdiv.length<myChoose_schedule.length))// if more than one div and less thhan schedule
					{
						for(i=0;i<(myNetdiv.length);i++)
						{
							$("#o_add_schedule_"+myNetdiv[i]).css("display","none");
							$("#o_delete_schedule_"+myNetdiv[i]).css("display","block");
							$("#o_add_schedule_"+myNetdiv[myNetdiv.length-1]).css("display","block");
							
						}					

					}
					
					else if((myNetdiv.length==myChoose_schedule.length)&&(myNetdiv.length>1))	//if both netprice div and  schedule are equal			
					{
						for(i=0;i<(myNetdiv.length);i++)
						{
							$("#o_delete_schedule_"+myNetdiv[i]).css("display","block");
							$("#o_add_schedule_"+myNetdiv[i]).css("display","none");
						}

					}
					else if((myNetdiv.length==1)&&(myChoose_schedule.length>1))
					{
						$("#o_delete_schedule_1").css("display","none");
						$("#o_add_schedule_1").css("display","block");
					}

					else			// if only one schedule
					{
						$("#o_delete_schedule_1").css("display","none");
						$("#o_add_schedule_1").css("display","none");

					}
					 // set blue background
					NET_lastDivSetBg();
					
     
}

			/////////////////////////////////////////////////////
			////////////net price whole div delete/////////////////
			////////////////////////////////////////////////////



function delete_net_price(e,h)
{
		    //  alert(e+'anand');
		     var ew1 = document.getElementById("choose_schedule_net_"+e+"_1");
		     var strSelectedw1 = ew1.options[ew1.selectedIndex].value;
		     var schedulesw1=$('#changing_schedule_net').val();
		     var savecopy_array=schedulesw1.split("</br>");
		     var deleted_schedule=$('#selected_net_value_'+e).val();
		     //alert(strSelectedw1+'**1');
		     //alert(schedulesw1+'**21');
		     if((h!=1)&&(strSelectedw1!='')&&(schedulesw1!=strSelectedw1)){
		         strSelectedw1=strSelectedw1.replace("</br>","");
		         if(schedulesw1!=''){
			 var index101 = savecopy_array.indexOf(strSelectedw1);
			 if(index101==-1){
			     schedulesw1+='</br>'+strSelectedw1;
			 //     alert('if');
			 }
		         }
		         else{
			 schedulesw1+=strSelectedw1;
		         //    alert('else');
		         }
		         strSelectedw2=strSelectedw1.split('_');
		       //  $('select.choose_schedule').append('<option  value="' + strSelectedw1 + '">' + strSelectedw2[0]+ '</option>');
		     }
			 
		     //alert(schedulesw1+'**2');
		     $('#changing_schedule_net').val('');
		     $('#changing_schedule_net').val(schedulesw1);
		     var last_net_discount=$("#last_in_discount_id_"+e).val();
		     last_net_discount=last_net_discount.split(',');
		     save_result=$("#save_result").val();
		     save_result=save_result.split(',');
		      if(save_result.length>1){
			 for(m=0;m<save_result.length;m++)
			 {
			     for(n=0; n<last_net_discount.length;n++)
			     {
			         var index1 = save_result.indexOf(last_net_discount[n]);
			         if (index1 > -1) {
				 save_result.splice(index1, 1);
			         }
			     }
				         
			 }
		      }
		     $("#save_result").val(save_result);
		     if(save_result.length==1)
		     {
		       //  $(".delete_schedule_net").css("display","none");
		     }
		     var total_div_count=$("#total_div_count").val();
		     total_div_count=total_div_count.split(',');
		     if(total_div_count.length>1){
		         $( "#netPriceDiv_"+e ).remove();
		     }
		     var index1 = total_div_count.indexOf(e+'_1');
		     if (index1 > -1) {
		         total_div_count.splice(index1, 1);
		     }
		     $("#total_div_count").val(total_div_count);
		     if($('#changing_schedule_net').val()!=''){
		        // $( ".out_add_schedule" ).last().css("display","block");
			 
		     }
		     
		     
		     for(i=0;i<myNetdiv.length;i++)//indexof property not works ie<9 browsers .so removal divs like this
					{
						if(myNetdiv[i]==e)
						{	
						
							myNetdiv.splice(i,1);
							// $("#choose_schedule_net_"+myNetdiv[myNetdiv.length-1]+"_1").append('<option  value="' + deleted_schedule + '">' +deleted_schedule+ '</option>'); //apend to the open dropdwon
						}
						
					}
					
					//alert(selected_net_option+'123');
					

					for(i=0;i<selected_net_option.length;i++)//delete the selected value from selected_net_option(). 
					{
							
						sN=selected_net_option[i].split('_');
						dS=deleted_schedule.split('_');
							if(sN[1]==dS[1])
							{
								selected_net_option.splice(i,1);
								//selected_net_option.splice((selected_net_option.length-1),1);
							
							}
					}

					
					if(myNetdiv.length>1)// if net price div greater than one div add and delete button manage
					{
						for(i=0;i<(myNetdiv.length-1);i++)
						{
							$("#o_add_schedule_"+myNetdiv[i]).css("display","none");
							$("#o_delete_schedule_"+myNetdiv[i]).css("display","block");
							$("#o_add_schedule_"+myNetdiv[myNetdiv.length-1]).css("display","block");
	
						}					

					}
					else //if net price div only one 
					{
						$("#o_delete_schedule_"+myNetdiv[0]).css("display","none");
						$("#o_add_schedule_"+myNetdiv[0]).css("display","block");
					}
					NET_lastDivSetBg();
		     
}


			/////////////////////////////////////////////////////
			////////////adv price whole div add///////////////////
			////////////////////////////////////////////////////
			
			
function validate_notes_adprice(ad,d)
		{
			    if(d==0){// price interchange 
						myAdvdiv.length = 0;
						selected_adv_option.length=0;
						$('.net_prices').remove();
			    }
				var e = document.getElementById('billing_type');
					  var strSelected = e.options[e.selectedIndex].value;
				        if(strSelected=="Schedule"){
				           var cont_inue= $('#adv_continue_sc').val();
				        }
				    else{
				       var cont_inue= $('#adv_continue_wsc').val();
				    }
			        
				 
			    if((ad=='0')&&(cont_inue==0))
			    {
				 
				 $('#advancedPriceDiv .priceContainer').remove();
				   $("#choose_schedule_1_1").css( "display","block" );
				  var append_sc='';
			         
				 var schedules=$('#total_schedule').val();
			           
				 schedules=schedules.slice(0,-5);
				 schedules=schedules.split("</br>");
				    
				    ////////////////
				    //alert(ad+'s');
	
			           to_choose_adv_opt=arr_diff(myChoose_schedule,selected_adv_option);// get the remaing to choose
		
						
									append_sc+='<option value="">--choose--</option>';
								
		
							for(j=0;j<to_choose_adv_opt.length;j++) // adding schedules as options to drop dwon
							{
								to_choose_adv=to_choose_adv_opt[j].split('_');
								append_sc+='<option value="'+to_choose_adv_opt[j]+'">'+to_choose_adv[0]+'</option>';
								
							}
			
		//////////////////
						
						
		       
						    
				        ad++;				
				       myAdvdiv.push(ad);// push element to netprice array
					myAdvdiv=jQuery.unique(myAdvdiv);	    ///////////////
				   			          
				    var  advance_add='';
					          
				    advance_add+='<div class="priceContainer"  id="priceContainerDiv_'+ad+'"><input type="hidden" name="earlybid_decide_adv_'+ad+'_1" id="earlybid_decide_adv_'+ad+'_1" value="0"><input type="hidden" name="delete_ad_discount_id_'+ad+'_1" id="delete_ad_discount_id_'+ad+'_1" value="'+ad+'_1_0"><input type="hidden" name="inner_div_count_'+ad+'_1" id="inner_div_count_'+ad+'_1" value="'+ad+'_1"><input type="hidden" name="early_div_count_'+ad+'_1" id="early_div_count_'+ad+'_1" value="'+ad+'_1_0"><input type="hidden" name="selected_value_'+ad+'" id="selected_value_'+ad+'" value=""><input type="hidden" id="chosen_ad_sc_'+ad+'_1" name="chosen_ad_sc_'+ad+'_1" value=""><input type="hidden" name="last_in_ad_discount_id_'+ad+'" id="last_in_ad_discount_id_'+ad+'" value="'+ad+'_1_0"><input id="last_ad_in_discount_id_'+ad+'" type="hidden" value="'+ad+'_1_0" name="last_ad_in_discount_id_'+ad+'"><input id="last_ad_discount_id_'+ad+'_1" type="hidden" value="0" name="last_ad_discount_id_'+ad+'_1"><table cellpadding="0" cellspacing="0" border="0"><tr>	<td><div class="priceOuterDiv" id="priceOuterDiv_'+ad+'"><table cellpadding="0" cellspacing="0" border="0" id="advance_price_div_'+ad+'_1_0"><tr id="advance_row_'+ad+'_1"><td><div class="lt advancedPriceContainer" id="advanced_PriceContainer_adv_'+ad+'_1" ><div id="schedule_heading_'+ad+'"  class="schedule_heading_1" style="display:none">Chosen Schedule </div><div class="selected_schedule_ad_1" id="selected_schedule_ad_'+ad+'_1" style="display:block"></div><div class="priceRow1_top" style="padding-top:0px;"><div class="lt blackText setWidthPrice3"   style="width: :160px;" id="setWidthPrice3_'+ad+'">Choose Schedule</div><div class="lt blackText setWidthPrice">Payment Period</div><div class="lt blackText setWidthPrice1" id="display_fst_text_'+ad+'_1">Max No. of Hour(s)</div><div class="lt blackText setWidthPrice2" id="display_sec_text_'+ad+'_1" style="display:none;"></div><div class="lt blackText" id="pricelabel_'+ad+'_1">Price</div><div class="clear"></div></div>';
				    advance_add+='<div class="clear"></div><div class="priceRow1_bottom"><div class="lt"><select  onchange="choose_schedule('+ad+',\'adv\')" name="choose_schedule_'+ad+'_1" id="choose_schedule_'+ad+'_1" class="drop_down_left width_set7 choose_schedule" style="margin-right: 5px;display:block;"></select></div>  ';
				    advance_add+='<div class="lt"><select name="ads_payment_'+ad+'_1" id="ad_payment_'+ad+'_1" class="drop_down_left width_set5" onchange="payTypeChanged('+ad+',1,this.value)" onkeyup="payTypeChanged(1,1,this.value)"><option value="Per Hour" >Per Hour</option><option value="Class Card">Class Card</option><option value="Per Session">Per Session</option><option value="Weekly">Weekly</option><option value="Monthly">Monthly</option><option value="Yearly">Yearly</option></select></div>  ';
				    advance_add+='<input type="text" id="ad_payment_box_fst_'+ad+'_1" name="ad_payment_box_fst_'+ad+'_1" class="lt textbox" value="Eg: 3" maxlength="5" style="width:107px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<input type="text" id="ad_payment_box_sec_'+ad+'_1" name="ad_payment_box_sec_'+ad+'_1" class="lt textbox" value="Eg: 3" maxlength="5" style="display:none;width:100px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<input type="text" id="ad_price_'+ad+'_1" name="ad_price_'+ad+'_1" class="lt textbox" value="$" maxlength="7" style="width:100px" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='</div><div class="clear"></div>	<input type="hidden" name="multiple_discount_count_'+ad+'_1" id="multiple_discount_count_'+ad+'_1" value="1"/><div class="createDynamicDiscount_'+ad+'_1_0"></div><div class="clear"></div>';
				/*************/
				 /*   advance_add+='<div id="staticDiscount_'+ad+'_1_0"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_'+ad+'_1_0">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_'+ad+'_1_0"style="width:185px">Discount Amount/Percentage</div><div class="clear"></div></div>';
				    advance_add+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type" id="discount_type_'+ad+'_1_0"><select name="ad_discount_type_'+ad+'_1_0" id="ad_discount_type_'+ad+'_1_0" class="drop_down_left width_set6" onchange="discTypeChanged(\'\','+ad+',1,0,this.value);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'\',1,1,this.value)"><option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div>   ';
				    advance_add+='<div id="session_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li> </ul></li></ul><div class="clear"></div></div></div>';
				    advance_add+='<input type="text" id="ad_no_sess_'+ad+'_1_0" name="ad_no_sess_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<input type="text" id="ad_discount_sess_price_'+ad+'_1_0" name="ad_discount_sess_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_'+ad+'_1_0" id="ad_discount_sess_price_type_'+ad+'_1_0" class="drop_down_left width_set3"> <option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
				    advance_add+='<div class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_session(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>    ';
				    advance_add+='<div class="clear"></div> <div class="errorDiv" style="display:none"><div id="advance_session_error_'+ad+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
				    advance_add+='<div id="participant_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu">';
				    advance_add+='<ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li> </ul></li></ul>';
				    advance_add+='<div class="clear"></div></div></div><input type="text" id="ad_no_part_'+ad+'_1_0" name="ad_no_part_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<input type="text" id="ad_discount_part_price_'+ad+'_1_0" name="ad_discount_part_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_'+ad+'_1_0" id="ad_discount_part_price_type_'+ad+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option> </select></div>';
				    advance_add+='<div class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_participant(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
				    advance_add+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_'+ad+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div>    ';
				    advance_add+='<div class="clear"></div><div id="early_brid_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul>';
				    advance_add+='<li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
				    advance_add+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText" style="width:154px" >Valid  Until</div><div class="lt blackText setWidthDiscount" id="no_part_net_'+ad+'_1_0"style="width:185px">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
				    advance_add+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_'+ad+'_1_0" name="ad_no_subs_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_'+ad+'_1_0" name="ad_valid_date_'+ad+'_1_0" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_'+ad+'_1_0" name="ad_valid_date_alt_'+ad+'_1_0" value="" /></div></div>    ';
				    advance_add+='<input type="text" id="ad_discount_price_'+ad+'_1_0" name="ad_discount_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<div class="lt price_type"><select name="ad_discount_price_type_'+ad+'_1_0" id="ad_discount_price_type_'+ad+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
				    advance_add+='<div class="lt add_delete_icons" id="early_bid_icons_'+ad+'_1_0"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onclick="validate_early_bid(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img width="22" height="22" src="/assets/create_new_activity/add_icon.png" alt=""></a></div>';
				    advance_add+='<div class="clear"></div><div class="clear"></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_'+ad+'_1_0"></div></div><div class="clear"></div></div>';
				*/
				/************/
				    advance_add+='<div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div><div class="errorDiv" style="display:none;"><div id="advance_error_'+ad+'_1_0"></div></div><div class="clear"></div></div>';
				    advance_add+='</td>';
				    advance_add+='<td valign="bottom">  <div class="delete_schedule d_delete_schedule_'+ad+'"  id="adv_inn_delete_schedule_'+ad+'_1" style="margin-top:0px;display:none;" onclick="delete_ad_in_price('+ad+',1)">&nbsp;</div> <div class="add_ad_in_schedule add_ad_in_schedule_'+ad+'" style="margin-top:0px;" id="add_ad_in_schedule_'+ad+'_1" onClick="validate_ad_in_price('+ad+',1)">&nbsp;</div> </div>';
				    advance_add+='<div class="clear"></div></td></tr></table><div class="clear"></div><div class="errorDiv" style="display:none"><div id="neprice_error_'+ad+'_1"></div></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
				    advance_add+='<div class="notesDiv">	<textarea name="advance_notes_'+ad+'_1" id="advance_notes_1_'+ad+'" rows="10" cols="40"  class="lt textbox descTextbox" style="height:50px; width:485px;"  onfocus="if(this.value==\'Notes:\'){this.value=\'\';$(this).css(\'color\',\'#444444\');}" onblur="if(this.value==\'\'){this.value=\'Notes:\';$(this).css(\'color\',\'#999999\');}" >Notes:</textarea><div class="clear"></div></div>';
				    advance_add+='<div class="clear"></div> </div></td><td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+ad+'"><div onclick="delete_ad_net_price('+ad+',0)" style="margin-top:0px;" class="delete_schedule_adv" id="delete_first_adv1">&nbsp;</div>';
				    advance_add+='<div class="add_ad_schedule" style="margin-top:0px;" id="add_ad_schedule_'+ad+'" onClick="validate_notes_adprice('+ad+')">&nbsp;</div>    ';
				    advance_add+='</div><div class="clear"></div></td></tr></table></div><div class="clear"></div></div>';
			        
				    $("#advancedPriceDiv").append(advance_add);
				    $("#delete_ad_discount_id_1_1").val('');// intilizing the delete the divs created;
					$.ajax({
				       type: "POST",
				       url: "activity_detail/create_first_discount_type",
				       data:{
					   "net":"",
					   "id1":ad,
					   "id2":1,
					   "id3":0
				       },
				       success: function(html){
					   $("#advanced_PriceContainer_adv_"+ad+"_1").append(html);
					   
				       } 
				   });
				  //  $("#add_schedule_"+ad).css("display","block");
				//    $(".delete_schedule_adv").css("display","none");
				    $("#choose_schedule_"+ad+"_1").append(append_sc);
				  //  $("#choose_schedule_"+ad+"_1").css("display","block");
				  
				   if(myChoose_schedule.length==myAdvdiv.length)// push the value to selected array list
					{
						
						to_remain_adv_opt=arr_diff(myChoose_schedule,selected_adv_option);
						selected_adv_option.push(to_remain_adv_opt[0]);
						$('#selected_value_'+ad).val(to_remain_adv_opt[0])
						   strSelected12=to_remain_adv_opt[0].split('_');
					
					$('#chosen_ad_sc_'+myAdvdiv[myAdvdiv.length-1]+'_1').val(strSelected12[1]);

					}
					
					   $( "#ad_valid_date_"+ad+"_1_0").datepicker({
		showOn : "button",
		buttonImage : "/assets/create_new_activity/date_icon.png",
		buttonImageOnly : true,
		minDate: 0,
		dateFormat: "D, M d, yy",
		altField : "#ad_valid_date_alt_"+ad+"_1_0",
		altFormat : "yy-m-d"
	});
        
					
			     }
				
			    else
			    {
				var append_sc='';
				           
					        
				var ew = document.getElementById("choose_schedule_"+ad+"_1");
			           // var strSelectedw = ew.options[ew.selectedIndex].value;
			        
				         var strSelectedw = $("#selected_value_"+ad).val();
				var h2=$("#last_ad_in_discount_id_"+ad).val();
				var sd=h2.split(",")
				for(var i=0;i<sd.length;i++)
				{
				    var select_box='ad_discount_type_'+sd[i];
				    h3=sd[i].split("_");
				    var select_box='ad_discount_type_'+sd[i];
				    var b=ad;
				    var q=h3[1];
				    var h=h3[2];
				    var e = document.getElementById(select_box);
				    var strSelected = e.options[e.selectedIndex].value;
						        
				    if(strSelected!=""){
							        
				        var net='net';
				        var yes=validate_early_bid('',b,q,h,0,0,'');
				        if (yes=='0'){
					break;
				        }
				    }
				    else if(strSelected=="Multiple Session Discount"){
				        var net='net';
				        var yes=validate_session('',b,q,h,0,0,'');
				        if (yes=='0'){
					break;
				        }
								        
				    }
				    else if(strSelected=="Multiple Participant Discount"){
				        var net='net';
				        var yes=validate_participant('',b,q,h,0,0,'');
				        if (yes=='0'){
					break;
				        }
							        
							        
				    }
				    else{
					           
				        var net='';
				        var yes=validate_nothing_selected('',b,q,h,0,0,'');
				        if(yes=='0'){
					break;
				        }
				    //alert(yes);
				    }
				}
				if(yes==1)
				{
				    
				    var  yt=$('#total_schedule').val();
				    var byt=yt.slice(0,-5);
				    $('#changing_schedule_adv_base').val(byt);
				    $('#changing_schedule_decide_adv').val('');
				    $('#changing_schedule_decide_adv').val('1');
								          
								          
				    $( "#choose_schedule_"+ad+"_1" ).css( "display","none" );
				    $( "#setWidthPrice3_"+ad ).css( "display","none" );
					   
				    $( "#schedule_heading_"+ad ).css( "display","block" );
				    $( "#selected_schedule_ad_"+ad+"_1" ).css( "display","block" );
					   
				    strSelectedw=strSelectedw.split('_');
				    $( "#selected_schedule_ad_"+ad+"_1" ).text( strSelectedw[0]);
				          
				    $( "#choose_schedule_"+ad+"_1" ).removeClass( "choose_schedule" );
				       adv_database=$('#adv_database').val();
				    choose_schedules(ad,'adv',adv_database) ;
				    $( "#choose_schedule_"+ad+"_1" ).css( "pointer-events"," none"  );
				    $( "#choose_schedule_"+ad+"_1" ).css(" cursor","default" );
				    var schedules=$('#changing_schedule_adv').val();
				    schedules=schedules.split("</br>");
				    ad++;
				    myAdvdiv.push(ad);// push element to netprice array
					myAdvdiv=jQuery.unique(myAdvdiv);	    ///////////////
		/////////////////////	    
				     to_choose_adv_opt=arr_diff(myChoose_schedule,selected_adv_option);// get the remaing to choose
		
						
									append_sc+='<option value="">--choose--</option>';
								
		
							for(j=0;j<to_choose_adv_opt.length;j++) // adding schedules as options to drop dwon
							{
								to_choose_adv=to_choose_adv_opt[j].split('_');
								append_sc+='<option value="'+to_choose_adv_opt[j]+'">'+to_choose_adv[0]+'</option>';
								
							}
			
		
				    var  advance_add='';
					          
				    advance_add+='<div class="priceContainer"  id="priceContainerDiv_'+ad+'"><input type="hidden" name="earlybid_decide_adv_'+ad+'_1" id="earlybid_decide_adv_'+ad+'_1" value="0"><input type="hidden" name="delete_ad_discount_id_'+ad+'_1" id="delete_ad_discount_id_'+ad+'_1" value="'+ad+'_1_0"><input type="hidden" name="inner_div_count_'+ad+'_1" id="inner_div_count_'+ad+'_1" value="'+ad+'_1"><input type="hidden" name="early_div_count_'+ad+'_1" id="early_div_count_'+ad+'_1" value="'+ad+'_1_0"><input type="hidden" name="selected_value_'+ad+'" id="selected_value_'+ad+'" value=""><input type="hidden" id="chosen_ad_sc_'+ad+'_1" name="chosen_ad_sc_'+ad+'_1" value=""><input type="hidden" name="last_in_ad_discount_id_'+ad+'" id="last_in_ad_discount_id_'+ad+'" value="'+ad+'_1_0"><input id="last_ad_in_discount_id_'+ad+'" type="hidden" value="'+ad+'_1_0" name="last_ad_in_discount_id_'+ad+'"><input id="last_ad_discount_id_'+ad+'_1" type="hidden" value="0" name="last_ad_discount_id_'+ad+'_1"><table cellpadding="0" cellspacing="0" border="0"><tr>	<td><div class="priceOuterDiv" id="priceOuterDiv_'+ad+'"><table cellpadding="0" cellspacing="0" border="0" id="advance_price_div_'+ad+'_1_0"><tr id="advance_row_'+ad+'_1"><td><div class="lt advancedPriceContainer" id="advanced_PriceContainer_adv_'+ad+'_1" ><div id="schedule_heading_'+ad+'"  class="schedule_heading_1" style="display:none">Chosen Schedule </div><div class="selected_schedule_ad_1" id="selected_schedule_ad_'+ad+'_1" style="display:none"></div><div class="priceRow1_top" style="padding-top:0px;"><div class="lt blackText setWidthPrice3"   style="width: :160px;" id="setWidthPrice3_'+ad+'">Choose Schedule</div><div class="lt blackText setWidthPrice">Payment Period</div><div class="lt blackText setWidthPrice1" id="display_fst_text_'+ad+'_1">Max No. of Hour(s)</div><div class="lt blackText setWidthPrice2" id="display_sec_text_'+ad+'_1" style="display:none;"></div><div class="lt blackText" id="pricelabel_'+ad+'_1">Price</div><div class="clear"></div></div>';
				    advance_add+='<div class="clear"></div><div class="priceRow1_bottom"><div class="lt"><select  onchange="choose_schedule('+ad+',\'adv\')" name="choose_schedule_'+ad+'_1" id="choose_schedule_'+ad+'_1" class="drop_down_left width_set7 choose_schedule choose_schedule_'+ad+'_1" style="margin-right: 5px;"></select></div>  ';
				    advance_add+='<div class="lt"><select name="ads_payment_'+ad+'_1" id="ad_payment_'+ad+'_1" class="drop_down_left width_set5" onchange="payTypeChanged('+ad+',1,this.value)" onkeyup="payTypeChanged(1,1,this.value)"><option value="Per Hour" >Per Hour</option><option value="Class Card">Class Card</option><option value="Per Session">Per Session</option><option value="Weekly">Weekly</option><option value="Monthly">Monthly</option><option value="Yearly">Yearly</option></select></div>  ';
				    advance_add+='<input type="text" id="ad_payment_box_fst_'+ad+'_1" name="ad_payment_box_fst_'+ad+'_1" class="lt textbox" value="Eg: 3" maxlength="5" style="width:107px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<input type="text" id="ad_payment_box_sec_'+ad+'_1" name="ad_payment_box_sec_'+ad+'_1" class="lt textbox" value="Eg: 3" maxlength="5" style="display:none;width:100px;margin-right: 5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<input type="text" id="ad_price_'+ad+'_1" name="ad_price_'+ad+'_1" class="lt textbox" value="$" maxlength="7" style="width:100px" onKeyPress="return number(event);" onfocus="if (this.value==\'$\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'$\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='</div><div class="clear"></div>	<input type="hidden" name="multiple_discount_count_'+ad+'_1" id="multiple_discount_count_'+ad+'_1" value="1"/><div class="createDynamicDiscount_'+ad+'_1_0"></div><div class="clear"></div>';
				  /**************/ 
				   /* advance_add+='<div class="staticDiscount_'+ad+'_1_0" id="staticDiscount_'+ad+'_1_0"><div class="priceRow2_top"><div class="lt blackText setWidthDiscount">Discount Type and Price</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_sess_'+ad+'_1_0">Quantity</div><div class="lt blackText setWidthDiscount" style="display:none" id="no_part_'+ad+'_1_0"style="width:185px">Discount Amount/Percentage</div><div class="clear"></div></div>';
				    advance_add+='<div class="clear"></div><div class="priceRow2_bottom"><div class="lt discout_type" id="discount_type_'+ad+'_1_0"><select name="ad_discount_type_'+ad+'_1_0" id="ad_discount_type_'+ad+'_1_0" class="drop_down_left width_set6" onchange="discTypeChanged(\'\','+ad+',1,0,this.value);$(this).css(\'color\',\'#444444\');" onkeyup="discTypeChanged(\'\',1,1,this.value)"><option value="--Choose Discount Type--" selected="selected">--Choose Discount Type--</option><option value="Early Bird Discount">Early Bird Discount</option><option value="Multiple Session Discount">Multiple Session Discount</option><option value="Multiple Participant Discount">Multiple Participant Discount</option></select></div>   ';
				    advance_add+='<div id="session_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu"><ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 275px;" class="sub-menu dispParticipantToll"><li>A discount for those who buy multiple sessions</li> </ul></li></ul><div class="clear"></div></div></div>';
				    advance_add+='<input type="text" id="ad_no_sess_'+ad+'_1_0" name="ad_no_sess_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<input type="text" id="ad_discount_sess_price_'+ad+'_1_0" name="ad_discount_sess_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<div class="lt session_price_type"><select name="ad_discount_sess_price_type_'+ad+'_1_0" id="ad_discount_sess_price_type_'+ad+'_1_0" class="drop_down_left width_set3"> <option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
				    advance_add+='<div class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_session(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img  src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>    ';
				    advance_add+='<div class="clear"></div> <div class="errorDiv" style="display:none"><div id="advance_session_error_'+ad+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div>';
				    advance_add+='<div id="participant_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width: 25px;"><div id="menu_active" class="lt ActiveDivMenu">';
				    advance_add+='<ul><li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 446px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing activities for multiple participants, e.g. two children. Choose the number of participants required to qualify and the total discount</li> </ul></li></ul>';
				    advance_add+='<div class="clear"></div></div></div><input type="text" id="ad_no_part_'+ad+'_1_0" name="ad_no_part_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<input type="text" id="ad_discount_part_price_'+ad+'_1_0" name="ad_discount_part_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value =\'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<div class="lt participant_price_type"><select name="ad_discount_part_price_type_'+ad+'_1_0" id="ad_discount_part_price_type_'+ad+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option> </select></div>';
				    advance_add+='<div class="lt add_delete_icons"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onClick="validate_participant(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img src="/assets/create_new_activity/add_icon.png" width="22" height="22" alt=""/></a></div>';
				    advance_add+='<div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_participant_error_'+ad+'_1_0" style=".margin-left:-210px;"></div></div><div class="clear"></div></div></div>    ';
				    advance_add+='<div class="clear"></div><div id="early_brid_'+ad+'_1_0" style="display:none;"><div id="provider_event_list" style="float: left;width:0px;left: 206px;position: relative;top: -31px;"><div id="menu_active" class="lt ActiveDivMenu"><ul>';
				    advance_add+='<li><img alt="" src="/assets/provider_register/help.png" style="cursor: pointer;"><ul style="width: 315px;" class="sub-menu dispParticipantToll"><li>A discount for purchasing early. Specify the date Upto which the discount applies and the total discount</li></ul></li></ul><div class="clear"></div></div></div>';
				    advance_add+='<div class="priceRow3_top"><div class="lt blackText setWidthSubs">Quantity</div><div class="lt blackText" style="width:154px" >Valid  Until</div><div class="lt blackText setWidthDiscount" id="no_part_net_'+ad+'_1_0"style="width:185px">Discount Amount/Percentage</div><div class="clear"></div></div><div class="clear"></div>';
				    advance_add+='<div class="priceRow3_bottom"><input type="text" id="ad_no_subs_'+ad+'_1_0" name="ad_no_subs_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="5" style="width:123px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<div class="lt" ><div class="dateDiv" style="margin-right:5px;"><input type="text"  id="ad_valid_date_'+ad+'_1_0" name="ad_valid_date_'+ad+'_1_0" class="dateTextbox" value="" readonly="readonly" style="outline: none;" onKeyPress="return number(event);" onChange="$(this).css(\'color\',\'#444444\');"/><input type="hidden" id="ad_valid_date_alt_'+ad+'_1_0" name="ad_valid_date_alt_'+ad+'_1_0" value="" /></div></div>    ';
				    advance_add+='<input type="text" id="ad_discount_price_'+ad+'_1_0" name="ad_discount_price_'+ad+'_1_0" class="lt textbox" value="Eg: 3" maxlength="7" style="width:110px;margin-right:5px;" onKeyPress="return number(event);" onfocus="if (this.value==\'Eg: 3\') { this.value = \'\';$(this).css(\'color\',\'#444444\');}"  onblur="if (this.value==\'\'){ this.value = \'Eg: 3\';$(this).css(\'color\',\'#999999\');}" />';
				    advance_add+='<div class="lt price_type"><select name="ad_discount_price_type_'+ad+'_1_0" id="ad_discount_price_type_'+ad+'_1_0" class="drop_down_left width_set3"><option value="$" selected="selected">$</option><option value="%">%</option></select></div>';
				    advance_add+='<div class="lt add_delete_icons" id="early_bid_icons_'+ad+'_1_0"><div onclick="delete_single_net_price(\'\','+ad+',1,0)" style="margin-top:0px;display: none;" class="delete_single_schedule delete_single_schedule_'+ad+'_1">&nbsp;</div><a href="javascript:void(0)" title="" onclick="validate_early_bid(\'\','+ad+',1,0,0,1)" style="display:inline-block; position:relative;left:10px;" class="lt addButton_'+ad+'_1 single_add_'+ad+'_1_0"><img width="22" height="22" src="/assets/create_new_activity/add_icon.png" alt=""></a></div>';
				    advance_add+='<div class="clear"></div><div class="clear"></div><div class="clear"></div><div class="errorDiv" style="display:none"><div id="advance_early_bid_error_'+ad+'_1_0"></div></div><div class="clear"></div></div>';
				 */
				    /**********/
				    advance_add+='<div class="clear"></div></div><div class="clear"></div></div><div class="clear"></div><div class="errorDiv" style="display:none;"><div id="advance_error_'+ad+'_1_0"></div></div><div class="clear"></div></div>';
				    advance_add+='</td>';
				    advance_add+='<td valign="bottom">  <div class="delete_schedule d_delete_schedule_'+ad+'"  id="adv_inn_delete_schedule_'+ad+'_1" style="margin-top:0px;display:none;" onclick="delete_ad_in_price('+ad+',1)">&nbsp;</div> <div class="add_ad_in_schedule add_ad_in_schedule_'+ad+'" style="margin-top:0px;" id="add_ad_in_schedule_'+ad+'_1" onClick="validate_ad_in_price('+ad+',1)">&nbsp;</div> </div>';
				    advance_add+='<div class="clear"></div></td></tr></table><div class="clear"></div><div class="errorDiv" style="display:none"><div id="neprice_error_'+ad+'_1"></div></div><div class="clear"></div><div class="dynamicAdvancedPrice"></div><div class="clear"></div>';
				    advance_add+='<div class="notesDiv">	<textarea name="advance_notes_'+ad+'_1" id="advance_notes_1_'+ad+'" rows="10" cols="40"  class="lt textbox descTextbox" style="height:50px; width:485px;"  onfocus="if(this.value==\'Notes:\'){this.value=\'\';$(this).css(\'color\',\'#444444\');}" onblur="if(this.value==\'\'){this.value=\'Notes:\';$(this).css(\'color\',\'#999999\');}" >Notes:</textarea><div class="clear"></div></div>';
				    advance_add+='<div class="clear"></div> </div></td><td valign="bottom"><div class="lt add_del_icons" id="add_del_icons_1_'+ad+'"><div onclick="delete_ad_net_price('+ad+',0)" style="margin-top:0px;" class="delete_schedule_adv">&nbsp;</div>';
				    advance_add+='<div class="add_ad_schedule" style="margin-top:0px;" id="add_ad_schedule_'+ad+'" onClick="validate_notes_adprice('+ad+')">&nbsp;</div>    ';
				    advance_add+='</div><div class="clear"></div></td></tr></table></div><div class="clear"></div></div>';
					        
				//    $("add_schedule_"+ad).css("display","block");
				    $("#advancedPriceDiv").append(advance_add);
							
					 $.ajax({
					type: "POST",
					url: "activity_detail/create_first_discount_type",
					data:{
					    "net":"",
					    "id1":ad,
					    "id2":1,
					    "id3":0
					},
					success: function(html){
					    $("#advanced_PriceContainer_adv_"+ad+"_1").append(html);
					    
					} 
				    });
				 /*   if(schedules.length==1)
				    {
				        $("#add_ad_schedule_"+ad).css("display","none");
												
				    }*/
				    $("#choose_schedule_"+ad+"_1").append(append_sc);
				    result_save=$("#result_save").val();
				    var et=ad+'_1_0';
				    result_save+=','+et;
				    $("#result_save").val(result_save);
				    total_outer_div=$("#total_outer_div").val();
				    total_outer_div+=','+ad+'_1';
				    $("#total_outer_div").val(total_outer_div);
					        
				    $('#saving_error').css("display","none");
				     if(myChoose_schedule.length==myAdvdiv.length)// push the value to selected array list
					{
						
						to_remain_adv_opt=arr_diff(myChoose_schedule,selected_adv_option);
						selected_adv_option.push(to_remain_adv_opt[0]);
						$('#selected_value_'+ad).val(to_remain_adv_opt[0])
						   strSelected12=to_remain_adv_opt[0].split('_');
					
					$('#chosen_ad_sc_'+myAdvdiv[myAdvdiv.length-1]+'_1').val(strSelected12[1]);

					}	
				}
			     }
				
				
				////////////button symbols/////////////
						
					
					

					if((myAdvdiv.length>1)&&(myAdvdiv.length<myChoose_schedule.length))// if more than one div and less thhan schedule
					{
						for(i=0;i<(myAdvdiv.length);i++)
						{
							$("#add_ad_schedule_"+myAdvdiv[i]).css("display","none");
							$(".delete_schedule_adv").css("display","block");
							$("#add_ad_schedule_"+myAdvdiv[myAdvdiv.length-1]).css("display","block");
							
						}					

					}
					
					else if((myAdvdiv.length==myChoose_schedule.length)&&(myAdvdiv.length>1))	//if both netprice div and  schedule are equal			
					{
						for(i=0;i<(myAdvdiv.length);i++)
						{
							$(".delete_schedule_adv").css("display","block");
							$("#add_ad_schedule_"+myAdvdiv[i]).css("display","none");
						}

					}
					else if((myAdvdiv.length==1)&&(myChoose_schedule.length>1))
					{
						$(".delete_schedule_adv").css("display","none");
						$("#add_ad_schedule_1").css("display","block");
					}

					else			// if only one schedule
					{
						$(".delete_schedule_adv").css("display","none");
						$("#add_ad_schedule_1").css("display","none");

					}
					
		AD_lastDivSetBg();		    
		}

	    //////////////////////////////////////////////////////
	    /************Advance price whole delete***************/
	    /////////////////////////////////////////////////////
function delete_ad_net_price(d_ad,h)
			        {
				
				//$( ".add_schedule" ).css("display","none");
				var ew1 = document.getElementById("choose_schedule_"+d_ad+"_1");
				 var strSelectedw1 = $("#selected_value_"+d_ad).val();
			         //   var strSelectedw1 = ew1.options[ew1.selectedIndex].value;
				var schedulesw1=$('#changing_schedule_adv').val();
				var savecopy_array=schedulesw1.split("</br>");
				if((h!=1)&&(strSelectedw1!='')&&(schedulesw1!=strSelectedw1)){
				    if(schedulesw1!=''){
				        var index101 = savecopy_array.indexOf(strSelectedw1);
				        if(index101==-1){
					schedulesw1+='</br>'+strSelectedw1;
				        }
				    }
				    else{
				        schedulesw1+=strSelectedw1;
					
				    }
				    strSelectedw2=strSelectedw1.split('_');
				    $('select.choose_schedule').append('<option  value="' + strSelectedw1 + '">' + strSelectedw2[0]+ '</option>');
				}
				//else{// anand('456');}
				$('#changing_schedule_adv').val('');
				$('#changing_schedule_adv').val(schedulesw1);
				        
				var last_ad_discount=$("#last_ad_in_discount_id_"+d_ad).val();
				last_ad_discount=last_ad_discount.split(',');
				result_save=$("#result_save").val();
				result_save=result_save.split(',');
				
				if(result_save.length>1){
				        for(m=0;m<result_save.length;m++)
				        {
					for(n=0; n<last_ad_discount.length;n++)
					{
					    d=last_ad_discount[n].split('_');
					    var early_div_count=$("#early_div_count_"+d[0]+"_"+d[1]).val();
					    early_div_count=early_div_count.split(',');
					    
					    for(b=0;b<early_div_count.length;b++){
					        var index1 = result_save.indexOf(early_div_count[b]);
					        if (index1 > -1) {
						result_save.splice(index1, 1);
					        }
					    }
					}
						    
				        }
				}
				//alert(result_save);
				$("#result_save").val(result_save);
				total_outer_div=$("#total_outer_div").val();
				        
				total_outer_div=total_outer_div.split(',');
				//alert(total_outer_div);
				var index3= total_outer_div.indexOf(d_ad+'_1');
				//index3=jQuery.inArray( d_ad, total_outer_div );
				//alert(index3);alert(d_ad);
				if(total_outer_div.length>1){
				    $( "#priceContainerDiv_"+d_ad).remove();
				}
				if (index3 > -1) {
				    total_outer_div.splice(index3, 1);
				}
				//alert(total_outer_div+'last');
				$("#total_outer_div").val(total_outer_div);
					        
					        
			        
				if(total_outer_div.length==1)
				{
				//    $(".delete_schedule_adv").css("display","none");
				}
				$("#result_save").val(result_save);
				
			        
				//$( ".add_ad_schedule" ).last().css("display","block");
				//$( ".add_schedule" ).last().css("display","block");
				
				var deleted_schedule=strSelectedw1;
				
				  for(i=0;i<myAdvdiv.length;i++)//indexof property not works ie<9 browsers .so removal divs like this
					{
						if(myAdvdiv[i]==d_ad)
						{	
						
							myAdvdiv.splice(i,1);
							// $("#choose_schedule_net_"+myNetdiv[myNetdiv.length-1]+"_1").append('<option  value="' + deleted_schedule + '">' +deleted_schedule+ '</option>'); //apend to the open dropdwon
						}
						
					}
					
					
					

					for(i=0;i<selected_adv_option.length;i++)//delete the selected value from selected_net_option(). 
					{
							aN=selected_adv_option[i].split('_');
						dS=deleted_schedule.split('_');
							if(aN[1]==dS[1])
							{
						
								selected_adv_option.splice(i,1);
								//selected_net_option.splice((selected_net_option.length-1),1);
								

							}

					}
			       // alert(myAdvdiv+"myAdvdiv");alert(selected_adv_option+"selected_adv_option");
					
					if(myAdvdiv.length>1)// if net price div greater than one div add and delete button manage
					{
						for(i=0;i<(myAdvdiv.length-1);i++)
						{
							$("#add_ad_schedule_"+myAdvdiv[i]).css("display","none");
							$(".delete_schedule_adv").css("display","block");
							$("#add_ad_schedule_"+myAdvdiv[myAdvdiv.length-1]).css("display","block");
	
						}					

					}
					else //if net price div only one 
					{
						$(".delete_schedule_adv").css("display","none");
						$("#add_ad_schedule_"+myAdvdiv[0]).css("display","block");
					}
					
					AD_lastDivSetBg();		
			        }

/*********************************  set light and dark blue background color for last ADVANCE and NET  price divs  *******************************/
function NET_lastDivSetBg(){
	var totalOuterDiv = $("#total_div_count").val();
	var splitTotalOuterDiv = totalOuterDiv.split(",");
	var splitTotalOuterDivLength = splitTotalOuterDiv.length;
	var spID = splitTotalOuterDiv[splitTotalOuterDivLength-1];
	
	var splitSpID = spID.split("_");
	var lastID = splitSpID[0];
	
	if(splitTotalOuterDivLength>1){	
		$("#netPriceDiv .priceOuterDiv").css("background","#F9FBFA");
		$("#netPriceDiv #net_priceOuterDiv_"+lastID).css("background","#e9f6f9");

		$("#netPriceDiv .advancedPriceContainer").css("background","#EDF1F2");
		$("#netPriceDiv #net_priceOuterDiv_"+lastID+" .advancedPriceContainer").css("background","#d1e8ee");
		
		$("#netPriceDiv #net_priceOuterDiv_1").css("background","#F9FBFA");
		$("#netPriceDiv #net_priceOuterDiv_1 .advancedPriceContainer").css("background","#EDF1F2");
	}
	else{
		$("#netPriceDiv .priceOuterDiv").css("background","#F9FBFA");
		$("#netPriceDiv .advancedPriceContainer").css("background","#EDF1F2");
	}
}
function AD_lastDivSetBg(){
	var totalOuterDiv = $("#total_outer_div").val();
	var splitTotalOuterDiv = totalOuterDiv.split(",");
	var splitTotalOuterDivLength = splitTotalOuterDiv.length;
	var spID = splitTotalOuterDiv[splitTotalOuterDivLength-1];
	
	var splitSpID = spID.split("_");
	var lastID = splitSpID[0];
	
	if(splitTotalOuterDivLength>1){	
		$("#advancedPriceDiv .priceOuterDiv").css("background","#F9FBFA");
		$("#advancedPriceDiv #priceOuterDiv_"+lastID).css("background","#e9f6f9");

		$("#advancedPriceDiv .advancedPriceContainer").css("background","#EDF1F2");
		$("#advancedPriceDiv #priceOuterDiv_"+lastID+" .advancedPriceContainer").css("background","#d1e8ee");
		
		$("#advancedPriceDiv #priceOuterDiv_1").css("background","#F9FBFA");
		$("#advancedPriceDiv #priceOuterDiv_1 .advancedPriceContainer").css("background","#EDF1F2");
	}
	else{
		$("#advancedPriceDiv .priceOuterDiv").css("background","#F9FBFA");
		$("#advancedPriceDiv .advancedPriceContainer").css("background","#EDF1F2");
	}
}


function discTypeChanged(net,id1,id2,id3,cu_value,lstval){
	
    if(net == "net_"){
        var id = "net_"+id1+"_"+id2+"_"+id3;
	  
        if(lstval==1){
            var startVal = $("#multiple_discount_count_"+id).val();
				
        }
				
    }
    else{
        var id = id1+"_"+id2+"_"+id3;
    }
    /*  $('.popupContainer').css('opacity','1');//set the over lay
        $('#create_disc_creat_pop').css('display','none');// set the create new popup
    $("#early_brid_"+id).css('display','none');
    $('#session_'+id).css('display','none');
    $('#participant_'+id).css('display','none');
		    
    $("#no_sess_"+id).css('display','none');
    $("#no_part_"+id).css('display','none');
    $("#noe_part_"+id).css('display','none');
	
    var height = '';
	
    if(cu_value == "Early Bird Discount"){
	
        date_calculate(net,id1,id2,id3);// calling the function to append date.
        $("#early_brid_"+id).show();
        $("#noe_part_"+id).show();
        
        height =  $("#early_brid_"+id).css('height');
    }
    else if(cu_value == "Multiple Session Discount"){
        $("#no_part_"+id).show();
        $('#no_sess_'+id).show();
        $('#session_'+id).show();
        
	       
        $('#no_sess_'+id).css("width","140px");
        height =  $("#session_"+id).css('height');
    }
    else if(cu_value == "Multiple Participant Discount"){
        $("#no_part_"+id).show();
        $('#no_sess_'+id).show();
        $('#no_sess_'+id).css("width","140px");
        $('#participant_'+id).show();
        height =  $("#participant_"+id).css('height');
    }
    else if(cu_value == "createnew"){// here the create new type option starts
        
        $('.popupContainer').css('opacity','0');
        $('#create_disc_creat_pop').css('display','block');
    }
    // set height for ie browser
    if(navigator.appName=='Microsoft Internet Explorer'){
        var priceDivHeight = $('.priceDiv').css('height');
        priceDivHeight = parseInt(priceDivHeight) + parseInt(height);
        $('.priceDiv').css('height' ,priceDivHeight);
    }*/

    if(cu_value!=""){
	$("#discount_choose_"+id).css("display","block");
    $.ajax({
        type: "POST",
        url: "activity_detail/create_discount_type",
        data: {
            "net":net,
            "id1": id1,
            "id2":id2,
            "id3":id3,
            "cu_value":cu_value,
            "lstval":lstval
        },
        success:function(result){
            $("#discount_choose_"+id).html(result);
	    
	        date_calculates(net,id1,id2,id3);
		   
        }
    });
    }
    else{
	$("#discount_choose_"+id).css("display","none");
    }
}

function date_calculates_edit(net,id1,id2,id3){// this is function for edit date
			
    if(net=='net_'){
        var id=net+""+id1+"_"+id2+"_"+id3;
        
    }
    else{
        var id=id1+"_"+id2+"_"+id3;
           }
    $("#ad_valid_date_"+id).datepicker({
        showOn : "button",
        buttonImage : "/assets/create_new_activity/date_icon.png",
        buttonImageOnly : true,
        minDate: 0,
        dateFormat: "D, M d, yy",
        altField : "#ad_valid_date_alt_"+id,
        altFormat : "yy-m-d"
				       
    });
			     
}

function date_calculates_edit_any(net,id1,id2){// this is function for edit date
			
    if(net=='net_'){
        var id=net+""+id1+"_"+id2;
        
    }
    else{
        var id=id1+"_"+id2;
           }
    $("#ad_valid_date_"+id).datepicker({
        showOn : "button",
        buttonImage : "/assets/create_new_activity/date_icon.png",
        buttonImageOnly : true,
        minDate: 0,
        dateFormat: "D, M d, yy",
        altField : "#ad_valid_date_alt_"+id,
        altFormat : "yy-m-d"
				       
    });
			     
}


 

