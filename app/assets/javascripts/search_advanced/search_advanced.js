/*	Display the Drop Down with city names */
function dispCategoryDiv(){	
	//alert("test")
	/* Adds the specified class if it is not present, and removes the specified class if it is present, using an optional transition.*/
	$('#dispAllCategoryDiv').toggleClass('dispBlock');
	
	if($('#category_name').hasClass('dispBlock')){	/* it return true */	
		
		/* Set display:none and remove class dispBlock on norml select box  */
		$('#category_name').removeClass('dispBlock');
		$('#category_name').css('display','none');
		$('#arrow1_cat').css('display','none');	
						
		/* Set display block on selected blue bg box  */	
		$('#selectdCatgryBg').css('display','inline-block');	
	}
	else{
		/* remove class dispblock on Drop Down box */
		$('#dispAllCategoryDiv').removeClass('dispBlock');
		/* Set display none on selected blue bg box  */
		$('#selectdCatgryBg').css('display','none');
		//$('#event_container .headerRight .selectedCity img').css('top','0px'); 	
		
		/* Set display:block and add class dispBlock on norml select box  */
		$('#category_name').css('display','inline-block');
		$('#category_name').addClass('dispBlock');
		$('#arrow1_cat').css('display','inline-block');
			
		}
}

/*	Change the city name  */
function changeCategoryName(name){	
	$('#category_name').html(name);
	$('#selected_city_name').html(name);
	
	/* remove class dispblock on Drop Down box  */
	$('#dispAllCategoryDiv').removeClass('dispBlock');
	/* Set display none on selected blue bg box  */	
	$('#selectdCatgryBg').css('display','none');
	$('#event_container .headerRight .selectedCity img').css('top','0px'); 
	
	/* Set display:block and add class dispBlock norml select box  */	
	$('#category_name').css('display','inline-block');
	$('#category_name').addClass('dispBlock');
	$('#arrow1_cat').css('display','inline-block');	
}
/* Display drop down for activity name */

function dispActivityDiv(){	
	//alert("test")
	/* Adds the specified class if it is not present, and removes the specified class if it is present, using an optional transition.*/
	$('#dispAllActivityDiv').toggleClass('dispBlock');
	
	if($('#activity_name').hasClass('dispBlock')){	/* it return true */	
		
		/* Set display:none and remove class dispBlock on norml select box  */
		$('#activity_name').removeClass('dispBlock');
		$('#activity_name').css('display','none');
		$('#arrow1_activity').css('display','none');	
						
		/* Set display block on selected blue bg box  */	
		$('#selectdActivityBg').css('display','inline-block');	
	}
	else{
		/* remove class dispblock on Drop Down box */
		$('#dispAllActivityDiv').removeClass('dispBlock');
		/* Set display none on selected blue bg box  */
		$('#selectdActivityBg').css('display','none');
		$('#event_container .headerRight .selectedCity img').css('top','0px'); 	
		
		/* Set display:block and add class dispBlock on norml select box  */
		$('#activity_name').css('display','inline-block');
		$('#activity_name').addClass('dispBlock');
		$('#arrow1_activity').css('display','inline-block');
			
		}
}

/*	Change the activity name  */
function changeActivityName(name){	
	$('#activity_name').html(name);
	$('#selectedCityActivity').html(name);
	
	/* remove class dispblock on Drop Down box  */
	$('#dispAllActivityDiv').removeClass('dispBlock');
	/* Set display none on selected blue bg box  */	
	$('#selectdActivityBg').css('display','none');
	$('#event_container .headerRight .selectedCity img').css('top','0px'); 
	
	/* Set display:block and add class dispBlock norml select box  */	
	$('#activity_name').css('display','inline-block');
	$('#activity_name').addClass('dispBlock');
	$('#arrow1_activity').css('display','inline-block');	
}


/* Display drop down for sub category name */

function dispsubCategoryDiv(){	
	//alert("test")
	/* Adds the specified class if it is not present, and removes the specified class if it is present, using an optional transition.*/
	$('#dispAllSubCategoryDiv').toggleClass('dispBlock');
	
	if($('#Subcategory_name').hasClass('dispBlock')){	/* it return true */	
		
		/* Set display:none and remove class dispBlock on norml select box  */
		$('#Subcategory_name').removeClass('dispBlock');
		$('#Subcategory_name').css('display','none');
		$('#arrow1_subCategory').css('display','none');	
						
		/* Set display block on selected blue bg box  */	
		$('#selectdSubCatgryBg').css('display','inline-block');	
	}
	else{
		/* remove class dispblock on Drop Down box */
		$('#dispAllSubCategoryDiv').removeClass('dispBlock');
		/* Set display none on selected blue bg box  */
		$('#selectdSubCatgryBg').css('display','none');
		$('#event_container .headerRight .selectedCity img').css('top','0px'); 	
		
		/* Set display:block and add class dispBlock on norml select box  */
		$('#Subcategory_name').css('display','inline-block');
		$('#Subcategory_name').addClass('dispBlock');
		$('#arrow1_subCategory').css('display','inline-block');
			
		}
}

/*	Change the sub category name  */
function changeSubcatgryName(name){	
	$('#Subcategory_name').html(name);
	$('#selectedsubCtgry').html(name);
	
	/* remove class dispblock on Drop Down box  */
	$('#dispAllSubCategoryDiv').removeClass('dispBlock');
	/* Set display none on selected blue bg box  */	
	$('#selectdSubCatgryBg').css('display','none');
	$('#event_container .headerRight .selectedCity img').css('top','0px'); 
	
	/* Set display:block and add class dispBlock norml select box  */	
	$('#Subcategory_name').css('display','inline-block');
	$('#Subcategory_name').addClass('dispBlock');
	$('#arrow1_subCategory').css('display','inline-block');	
}

/* Display drop down for Age name */

function dispAgeDiv(){	
	//alert("test")
	/* Adds the specified class if it is not present, and removes the specified class if it is present, using an optional transition.*/
	$('#dispAllageDiv').toggleClass('dispBlock');
	
	if($('#age_name').hasClass('dispBlock')){	/* it return true */	
		
		/* Set display:none and remove class dispBlock on norml select box  */
		$('#age_name').removeClass('dispBlock');
		$('#age_name').css('display','none');
		$('#arrow1_age').css('display','none');	
						
		/* Set display block on selected blue bg box  */	
		$('#selectdAgeBg').css('display','inline-block');	
	}
	else{
		/* remove class dispblock on Drop Down box */
		$('#dispAllageDiv').removeClass('dispBlock');
		/* Set display none on selected blue bg box  */
		$('#selectdAgeBg').css('display','none');
		$('#event_container .headerRight .selectedCity img').css('top','0px'); 	
		
		/* Set display:block and add class dispBlock on norml select box  */
		$('#age_name').css('display','inline-block');
		$('#age_name').addClass('dispBlock');
		$('#arrow1_age').css('display','inline-block');
			
		}
}

/*	Change the Age name  */
function changeAgeName(name){	
	$('#age_name').html(name);
	$('#selectedAge').html(name);
	
	/* remove class dispblock on Drop Down box  */
	$('#dispAllageDiv').removeClass('dispBlock');
	/* Set display none on selected blue bg box  */	
	$('#selectdAgeBg').css('display','none');
	$('#event_container .headerRight .selectedCity img').css('top','0px'); 
	
	/* Set display:block and add class dispBlock norml select box  */	
	$('#age_name').css('display','inline-block');
	$('#age_name').addClass('dispBlock');
	$('#arrow1_age').css('display','inline-block');	
}

/* Display drop down for Leader name */

function dispLeaderDiv(){	
	//alert("test")
	/* Adds the specified class if it is not present, and removes the specified class if it is present, using an optional transition.*/
	$('#dispAllLeaderDiv').toggleClass('dispBlock');
	
	if($('#leader_name').hasClass('dispBlock')){	/* it return true */	
		
		/* Set display:none and remove class dispBlock on norml select box  */
		$('#leader_name').removeClass('dispBlock');
		$('#leader_name').css('display','none');
		$('#arrow1_Leader').css('display','none');	
						
		/* Set display block on selected blue bg box  */	
		$('#selectdLeaderBg').css('display','inline-block');	
	}
	else{
		/* remove class dispblock on Drop Down box */
		$('#dispAllLeaderDiv').removeClass('dispBlock');
		/* Set display none on selected blue bg box  */
		$('#selectdLeaderBg').css('display','none');
		$('#event_container .headerRight .selectedCity img').css('top','0px'); 	
		
		/* Set display:block and add class dispBlock on norml select box  */
		$('#leader_name').css('display','inline-block');
		$('#leader_name').addClass('dispBlock');
		$('#arrow1_Leader').css('display','inline-block');
			
		}
}

/*	Change the Leader name  */
function changeLeaderName(name){	
	$('#leader_name').html(name);
	$('#selectedLeader').html(name);
	
	/* remove class dispblock on Drop Down box  */
	$('#dispAllLeaderDiv').removeClass('dispBlock');
	/* Set display none on selected blue bg box  */	
	$('#selectdLeaderBg').css('display','none');
	$('#event_container .headerRight .selectedCity img').css('top','0px'); 
	
	/* Set display:block and add class dispBlock norml select box  */	
	$('#leader_name').css('display','inline-block');
	$('#leader_name').addClass('dispBlock');
	$('#arrow1_Leader').css('display','inline-block');	
}

/* Display drop down for Price name */

function dispPriceDiv(){	
	//alert("test")
	/* Adds the specified class if it is not present, and removes the specified class if it is present, using an optional transition.*/
	$('#dispAllPriceDiv').toggleClass('dispBlock');
	
	if($('#price_name').hasClass('dispBlock')){	/* it return true */	
		
		/* Set display:none and remove class dispBlock on norml select box  */
		$('#price_name').removeClass('dispBlock');
		$('#price_name').css('display','none');
		$('#arrow1_price').css('display','none');	
						
		/* Set display block on selected blue bg box  */	
		$('#selectdPriceBg').css('display','inline-block');	
	}
	else{
		/* remove class dispblock on Drop Down box */
		$('#dispAllPriceDiv').removeClass('dispBlock');
		/* Set display none on selected blue bg box  */
		$('#selectdPriceBg').css('display','none');
		$('#event_container .headerRight .selectedCity img').css('top','0px'); 	
		
		/* Set display:block and add class dispBlock on norml select box  */
		$('#price_name').css('display','inline-block');
		$('#price_name').addClass('dispBlock');
		$('#arrow1_price').css('display','inline-block');
			
		}
}

/*	Change the Price name  */
function changePriceName(name){	
	$('#price_name').html(name);
	$('#selectedPrice').html(name);
	
	/* remove class dispblock on Drop Down box  */
	$('#dispAllPriceDiv').removeClass('dispBlock');
	/* Set display none on selected blue bg box  */	
	$('#selectdPriceBg').css('display','none');
	$('#event_container .headerRight .selectedCity img').css('top','0px'); 
	
	/* Set display:block and add class dispBlock norml select box  */	
	$('#price_name').css('display','inline-block');
	$('#price_name').addClass('dispBlock');
	$('#arrow1_price').css('display','inline-block');	
}
/* Change carousel activity */
function changeActivity(classname){			
	$('.jMyCarousel_header ul li a img').each(function() {		   
            var newSrc = $(this).attr("src");            
            newStr = newSrc.replace('selected','normal');
            $(this).attr("src", newStr);           
     });	
	var select_imgname = $('.jMyCarousel_header ul li a.'+classname+' img').attr("src");
	var select_change_image_name = select_imgname.replace('normal','selected');	
	$('.jMyCarousel_header ul li a.'+classname+' img').attr("src",select_change_image_name);
}
function selectDateVal(){	
	var selectVal = $('#datepicker').val();	
	var splitdate = selectVal.split("/");
	var date = splitdate[0];
	var month = splitdate[1];
	var year = splitdate[2];	
	
	$('#selected_month').html(month);
	$('#selected_date').html(date);
	$('#ui-datepicker-div').css('display','none');	
	
	/********************************************
	 *
	 * 		Display Month Dyanmically
	 *  
	 *******************************************/	
	
	var selectedVal = $('#dateEvent').val();	
	var spliteddate = selectedVal.split("-");
	var day1 = spliteddate[0]
	var year1 = spliteddate[1];
	var month1 = spliteddate[2];
	month1 = month1-1;
	var date1 = spliteddate[3];	
	
	
	strd=""; /***** empty is very important *****/
	strm=""; /***** empty is very important *****/
	stry=""; /***** empty is very important *****/
	
	displayCalender(year1,month1);
	
}
function  maccssfix(){
	var ua=navigator.userAgent;
	if(ua.indexOf("Mac")!=-1){
		if(ua.indexOf("Firefox")!=-1){	
			$('#event_container .centerContainer .menutaps').css('top','-10px');			
		}
		else
			$('#event_container .centerContainer .menutaps').css('top','-8px');
	}
}
