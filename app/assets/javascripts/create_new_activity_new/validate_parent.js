function validateparentActivity_parent(){
        $("#sub_category_error").css("marginLeft","0px");
        $("#e_error").css("marginLeft","110px");
        $("#state_error").css("marginLeft","0px");

        var title = $("#title").val();
        $("#title").css("border","1px solid #CDE0E6");
        $("#title_error").html("");
        $("#title_error").parent().css("display","none");

        var category = $("#category").val();
        $("#category").css("border","1px solid #CDE0E6");
        $("#category_error").html("");
        $("#category_errorDiv").css("display","none");
	
        var sub_category = $("#sub_category").val();
        $("#sub_category").css("border","1px solid #CDE0E6");
        $("#sub_category_error").html("");
        $("#sub_category_error").parent().css("display","none");
	
        var desc= $("#desc").val();
        $("#desc").css("border","1px solid #CDE0E6");
        $("#desc_error").html("");
        $("#desc_error").parent().css("display","none");

        var add_1 = $("#add_1").val();
        $("#add_1").css("border","1px solid #CDE0E6");
        var add_2 = $("#add_2").val();
        $("#add_2").css("border","1px solid #CDE0E6");
        $("#venue_error").html("");
        $("#venue_error").parent().css("display","none");

        var state = $("#act_state").val();
        $("#act_state").css("border","1px solid #CDE0E6");
        $("#state_error").html("");
        var city = $("#act_city").val();
        $("#act_city").css("border","1px solid #CDE0E6");
        $("#city_error").html("");
        $("#cityState_errorDiv").css("display","none");
	
        var zip_code = $("#zip_code").val();
        $("#zip_code").css("border","1px solid #CDE0E6");
        $("#zipcode_error").html("");
        $("#zipcode_error").parent().css("display","none");

        var mon_age1 = $("#month_age1").val();
	var year_age1 = $("#year_age1").val();
	var mon_age2 = $("#month_age2").val();					    
	var year_age2 = $("#year_age2").val();
	$("#month_age1").css("border","1px solid #CDE0E6");
	$("#year_age1").css("border","1px solid #CDE0E6");
	$("#month_age2").css("border","1px solid #CDE0E6");
	$("#year_age2").css("border","1px solid #CDE0E6");
        $("#age_range_error").html("");
        $("#age_range_error").parent().css("display","none");

        var no_pat = $("#no_pat").val();
        $("#no_pat").css("border","1px solid #CDE0E6");
        $("#no_pat_error").html("");
        $("#no_pat_error").parent().css("display","none");

        var activity_photo = $("#photo1").val();
	$("#photo1").css("border","1px solid #ffffff");
        $("#activity_photo_error").html("");
        $("#activity_photo_error").parent().css("display","none");

       var billing_type = $("#billing_type").val(); 
        $("#billing_type").css("border","1px solid #CDE0E6");
        $("#billing_error").html("");
        $("#billing_error").parent().css("display","none");
	 
        var schedule_stime_1 = $('#schedule_stime_1_1').val();
        var schedule_stime_2 = $('#schedule_stime_2_1').val();
        var schedule_etime_1 = $('#schedule_etime_1_1').val();
        var schedule_etime_2 = $('#schedule_etime_2_1').val();
	
        var schedule_stime_1 = $('#schedule_stime_1_1').val();
        $('#schedule_stime_1_1').css('border','1px solid #CDE0E6');
        var schedule_stime_2 = $('#schedule_stime_2_1').val();
        var schedule_etime_1 = $('#schedule_etime_1_1').val();
        $('#schedule_etime_1_1').css('border','1px solid #CDE0E6');
        var schedule_etime_2 = $('#schedule_etime_2_1').val();
        $("#schedule_time_error").html("");
        $("#schedule_time_error").parent().css("display","none");

        var date_1 = $('#date_1_1').val();
        var date_2 = $('#date_2_1').val();

        var repeatCheck = $("#repeatCheck_1").val();
        var radio3 = $("#r3_1").val();
	
        var any_address = $("#any_address").val();
	
        var errorFlag = false;

        title = title.replace(/^\s+|\s+$/g, "");
        if(title == "" ||  title == "Enter Activity Name"){
          $("#title").css("border","1px solid #fc8989");
          $("#title_error").html("Please provide a title for the activity");
          $("#title_error").parent().css("display","block");
          errorFlag = true;
        }
        /*else if(title.length>26){
                $("#title").css("border","1px solid #fc8989");
                $("#title_error").html("Please do not exceed 25 characters");
                $("#title_error").parent().css("display","block");
                errorFlag = true;
        }*/

        if(desc == "" || desc == "Description should not exceed 1000 characters"){
          $("#desc").css("border","1px solid #fc8989");
          $("#desc_error").html("Please enter the description");
          $("#desc_error").parent().css("display","block");
          errorFlag = true;
        }
        if(desc != "" ){
          if(desc.length>1000){
            $("#desc").css("border","1px solid #fc8989");
            $("#desc_error").html("Please enter the description should not exceed 1000 characters");
            $("#desc_error").parent().css("display","block");
            errorFlag = true;
          }
        }
        if(billing_type =="Select" || billing_type ==""){
          $("#biling_type").css("border","1px solid #fc8989");
          $("#billing_error").html("Please select the billing type");
          $("#billing_error").parent().css("display","block");
          errorFlag = true;
        }
        var split_schedule_stime_1 = schedule_stime_1.split(":");
        var split_schedule_etime_1 = schedule_etime_1.split(":");

        var s_val_1 = split_schedule_stime_1[0];
        var s_val_2 = split_schedule_stime_1[1];

        var e_val_1 = split_schedule_etime_1[0];
        var e_val_2 = split_schedule_etime_1[1];

        if(billing_type == "Schedule"){
          if(repeatCheck == "yes"){
            if(radio3==1){
              if(date_1 == date_2 ){
                if(s_val_1 == e_val_1 && s_val_2 >= e_val_2 && schedule_stime_2 == schedule_etime_2){
                  $('#schedule_stime_1_1').css('border','1px solid #fc8989');
                  $('#schedule_etime_1_1').css('border','1px solid #fc8989');
                  $("#schedule_time_error").html("Invalid time");
                  $("#schedule_time_error").parent().css("display","block");
                  rrorFlag = true;
                }
                if( s_val_1 > e_val_1 && s_val_1 != 12 && e_val_1 != 12 && schedule_stime_2 == schedule_etime_2 ){
                  $('#schedule_stime_1_1').css('border','1px solid #fc8989');
                  $('#schedule_etime_1_1').css('border','1px solid #fc8989');
                  $("#schedule_time_error").html("Invalid time");
                  $("#schedule_time_error").parent().css("display","block");
                  errorFlag = true;
                }
                if( ((s_val_1 > 0 && s_val_1 != 12)  &&  e_val_1 == 12  && ( schedule_stime_2 == schedule_etime_2 ) ) || ( s_val_1 == 12 && e_val_1 > 12 ) ){
                  $('#schedule_stime_1_1').css('border','1px solid #fc8989');
                  $('#schedule_etime_1_1').css('border','1px solid #fc8989');
                  $("#schedule_time_error").html("Invalid time");
                  $("#schedule_time_error").parent().css("display","block");
                  errorFlag = true;
                }
              }
              else{
                if(s_val_1 == e_val_1 && s_val_2 >= e_val_2 && schedule_stime_2 == schedule_etime_2){
                  $('#schedule_stime_1_1').css('border','1px solid #fc8989');
                  $('#schedule_etime_1_1').css('border','1px solid #fc8989');
                  $("#schedule_time_error").html("Invalid time");
                  $("#schedule_time_error").parent().css("display","block");
                  rrorFlag = true;
                }
              }
            }
            else{
              if(s_val_1 == e_val_1 && s_val_2 >= e_val_2 && schedule_stime_2 == schedule_etime_2){
                $('#schedule_stime_1_1').css('border','1px solid #fc8989');
                $('#schedule_etime_1_1').css('border','1px solid #fc8989');
                $("#schedule_time_error").html("Invalid time");
                $("#schedule_time_error").parent().css("display","block");
                rrorFlag = true;
              }
              if( s_val_1 > e_val_1 && s_val_1 != 12 && e_val_1 != 12 && schedule_stime_2 == schedule_etime_2 ){
                $('#schedule_stime_1_1').css('border','1px solid #fc8989');
                $('#schedule_etime_1_1').css('border','1px solid #fc8989');
                $("#schedule_time_error").html("Invalid time");
                $("#schedule_time_error").parent().css("display","block");
                errorFlag = true;
              }
              if( ((s_val_1 > 0 && s_val_1 != 12)  &&  e_val_1 == 12  && ( schedule_stime_2 == schedule_etime_2 ) ) || ( s_val_1 == 12 && e_val_1 > 12 ) ){
                $('#schedule_stime_1_1').css('border','1px solid #fc8989');
                $('#schedule_etime_1_1').css('border','1px solid #fc8989');
                $("#schedule_time_error").html("Invalid time");
                $("#schedule_time_error").parent().css("display","block");
                errorFlag = true;
              }
            }
          }
          if(repeatCheck == ""){
            if(date_1 == date_2 ){
              if(s_val_1 == e_val_1 && s_val_2 >= e_val_2 && schedule_stime_2 == schedule_etime_2){
                $('#schedule_stime_1_1').css('border','1px solid #fc8989');
                $('#schedule_etime_1_1').css('border','1px solid #fc8989');
                $("#schedule_time_error").html("Invalid time");
                $("#schedule_time_error").parent().css("display","block");
                errorFlag = true;
              }
              if( s_val_1 > e_val_1 && s_val_1 != 12 && e_val_1 != 12 && schedule_stime_2 == schedule_etime_2 ){
                $('#schedule_stime_1_1').css('border','1px solid #fc8989');
                $('#schedule_etime_1_1').css('border','1px solid #fc8989');
                $("#schedule_time_error").html("Invalid time");
                $("#schedule_time_error").parent().css("display","block");
                errorFlag = true;
              }
              if( ((s_val_1 > 0 && s_val_1 != 12)  &&  e_val_1 == 12  && ( schedule_stime_2 == schedule_etime_2 ) ) || ( s_val_1 == 12 && e_val_1 > 12 ) ){
                $('#schedule_stime_1_1').css('border','1px solid #fc8989');
                $('#schedule_etime_1_1').css('border','1px solid #fc8989');
                $("#schedule_time_error").html("Invalid time");
                $("#schedule_time_error").parent().css("display","block");
                errorFlag = true;
              }
            }
          }
        }
        if(category == "--Select Category--" || category == ""){
          $("#category").css("border","1px solid #fc8989");
          $("#category_errorDiv").css("display","block");
          $("#category_error").html("Please select the category");
          errorFlag = true;
        }
        if(sub_category == "--Select Sub Category--" || sub_category == ""){
          $("#sub_category").css("border","1px solid #fc8989");
          $("#category_errorDiv").css("display","block");
          $("#sub_category_error").html("Please select the sub category");
          if(category == "Select" || category == "")
            $("#sub_category_error").css("marginLeft","0px");
          else
            $("#sub_category_error").css("marginLeft","275px");
          errorFlag = true;
        }
	
        if( (billing_type == "Any Time" && any_address == 1 ) || billing_type == "Schedule" ){
          add_1 = add_1.replace(/^\s+|\s+$/g, "");
          add_2 = add_2.replace(/^\s+|\s+$/g, "");
          if(add_1 == "" || add_1 == "Address Line1" ){
            $("#add_1").css("border","1px solid #fc8989");
            $("#venue_error").html("Please enter the venue details");
            $("#venue_error").parent().css("display","block");
            errorFlag = true;
          }
          if(city == "Select" || city == "" ){
            $("#act_city").css("border","1px solid #fc8989");
            $("#cityState_errorDiv").css("display","block");
            $("#city_error").html("Please select the city");
            errorFlag = true;
          }
          if(state == "Select" || state == ""){
            $("#act_state").css("border","1px solid #fc8989");
            $("#cityState_errorDiv").css("display","block");
            $("#state_error").html("Please select the state");
            if(city == "Select" || city == "")
              $("#state_error").css("marginLeft","0px");
            else
              $("#state_error").css("marginLeft","275px");
            errorFlag = true;
          }
          zip_code = zip_code.replace(/^\s+|\s+$/g, "");
          if(zip_code == "Enter Zip Code" ||  zip_code == ""){
            $("#zip_code").css("border","1px solid #fc8989");
            $("#zipcode_error").html("Please enter the zipcode");
            $("#zipcode_error").parent().css("display","block");
            errorFlag = true;
          }
          else if(isNaN(zip_code)){
            $("#zip_code").css("border","1px solid #fc8989");
            $("#zipcode_error").html("Please enter the valid zipcode");
            $("#zipcode_error").parent().css("display","block");
            errorFlag = true;
          }
        }
        /*if(age1 == '' && age2 != '' ){
          $(".age_range1 .selectBoxCity").css("border","1px solid #fc8989");
          $("#age_range_error").html("Please select min age range");
          $("#age_range_error").parent().css("display","block");
          errorFlag = true;
        }
        if(age1 != '' && age2 == '' ){
          $("#age2").css("border","1px solid #fc8989");
          $("#age_range_error").html("Please select max age range");
          $("#age_range_error").parent().css("display","block");
          errorFlag = true;
        }
        if((parseInt(age2) < parseInt(age1)) && (age1 != "Adults") && (age2 != "Adults") && (age1 != "All") && (age2 != "All")){
          $("#age2").css("border","1px solid #fc8989");
          $("#age_range_error").html("Please select valid max range");
          $("#age_range_error").parent().css("display","block");
          errorFlag = true;
        }*/
	/*validate the age ranges in create_new_activity.js */
	var min_age_type = $("#min_type").val();
	var max_age_type = $("#max_type").val();
	var age1 = ((min_age_type=='month') ? $("#month_age1").val() : $("#year_age1").val());
	var age2 = ((max_age_type=='month') ? $("#month_age2").val() : $("#year_age2").val());
	var min_age_type = $("#min_type").val();
	var max_age_type = $("#max_type").val();
	var age1 = ((min_age_type=='month') ? $("#month_age1").val() : $("#year_age1").val());
	var age2 = ((max_age_type=='month') ? $("#month_age2").val() : $("#year_age2").val());
	/*if((min_age_type!='' && max_age_type=='')  || (min_age_type=='' && max_age_type!=''))
	{
		$("#age_range_error").html("Please select age type");
		$("#age_range_error").parent().css("display","block");
		errorFlag=true;
	}
	else if(min_age_type=='month' || min_age_type=='year')
	{						
		if(min_age_type=='month' && $("#month_age1").val()=='')
		{							
			$("#age_range_error").html("Please select age type");
			$("#age_range_error").parent().css("display","block");
			errorFlag=true;
			
		}							
		if(min_age_type=='year' && $("#year_age1").val()=='')
		{
			$("#age_range_error").html("Please select age type");
			$("#age_range_error").parent().css("display","block");
			errorFlag=true;
		}												
	}
	else if(max_age_type=='month' || max_age_type=='year')
	{	if(max_age_type=='month' && $("#month_age2").val()=='')
		{	$("#age_range_error").html("Please select age type");
			$("#age_range_error").parent().css("display","block");
			errorFlag=true;
		}	
		if(max_age_type=='year' && $("#year_age2").val()=='')
		{
			$("#age_range_error").html("Please select age type");
			$("#age_range_error").parent().css("display","block");
			errorFlag=true;
		}
	}*/
	if(age1!='' || age2!='')
	{					   
	    var test = validate_age_ranges(min_age_type,max_age_type,age1,age2)
	    if (!test)
	    {
	    errorFlag = true;
	    }
	}
        no_pat = no_pat.replace(/^\s+|\s+$/g, "");
        var firstValPart = no_pat.charAt(0);
        if(no_pat != "Specify Number" ){
          if(!validateNumber(no_pat)){
            $("#no_pat").css("border","1px solid #fc8989");
            $("#no_pat_error").html("Please allow only valid number");
            $("#no_pat_error").parent().css("display","block");
            errorFlag = true;
          }
          if(firstValPart==0 && firstValPart !="" ){
            $("#no_pat").css("border","1px solid #fc8989");
            $("#no_pat_error").html("Please do not use 0 as a first character");
            $("#no_pat_error").parent().css("display","block");
            errorFlag = true;
          }
        }
        if(activity_photo != ""){
          val=editValidateBrowse();
          if(!val){
            $("#photo1").css("border","1px solid #fc8989");
            $("#activity_photo_error").html("Please select an valid image");
            $("#activity_photo_error").parent().css("display","block");
            errorFlag = true;
          }
        }
        if(errorFlag){
          return false;
        }

        else{
        return true;
      }
  
}

