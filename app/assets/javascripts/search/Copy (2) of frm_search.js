function ageDropAge(){
	$("#age_range_pop").toggle();
}

function adv_search_drop(){
    if(($("#advance_search_show img").attr('src')) =='/assets/search/search_arrow.png')
    {
        $("#advance_search_show img").attr('src','/assets/search/search_arrow_up.png');
    }
    else if(($("#advance_search_show img").attr('src')) =='/assets/search/search_arrow_up.png')
    {
        $("#advance_search_show img").attr('src','/assets/search/search_arrow.png');
    }
    if(($("#advance_search_show img").attr('src')) == '/assets/search/dropdown_arrow.png')
    {
        $("#advance_search_show img").attr('src','/assets/search/dropdown_arrow_up.png');
    }
    else if(($("#advance_search_show img").attr('src')) == '/assets/search/dropdown_arrow_up.png')
    {
        $("#advance_search_show img").attr('src','/assets/search/dropdown_arrow.png');
    }
    $("#advanceSearch_drop").slideToggle("slow");
}
		
		
$("#search_category").mouseover(function(){		
    $("#search_category_pop").show();
});
$("#search_category").mouseout(function(){		
    $(".drop_down").hide();
});
		
$("#age_range").mouseover(function(){		
    $("#age_range_pop").show();
});
$("#age_range").mouseout(function(){		
    $(".drop_down").hide();
});
$("#gender").mouseover(function(){		
    $("#gender_pop").show();
});
$("#gender").mouseout(function(){		
    $(".drop_down").hide();
});
$("#day_week").mouseover(function(){		
    $("#day_week_pop").show();
});
$("#day_week").mouseout(function(){		
    $(".drop_down").hide();
});
$("#search_price").mouseover(function(){		
    $("#search_price_pop").show();
});
$("#search_price").mouseout(function(){		
    $(".drop_down").hide();
});
		
function daterange_all_changes1()
{
    if($('input[name=aa_all]').is(':checked')){
        $('input[name=aa_r1]').attr('checked', true);
        $('input[name=aa_r4]').attr('checked', true);
        $('input[name=aa_r8]').attr('checked', true);
        $("#age_range7").val("All");
        $("#age_r1").val("");
        $("#age_r4").val("");
        $("#age_r8").val("");
    }
    else{
        $('input[name=aa_all]').attr('checked', false);
        $('input[name=aa_r1]').attr('checked', false);
        $('input[name=aa_r4]').attr('checked', false);
        $('input[name=aa_r8]').attr('checked', false);
        $("#age_range7").val("");
        $("#age_r1").val("");
        $("#age_r4").val("");
        $("#age_r8").val("");
    }
}

//New GUI age range drop down
function agerange_all_drop_changes()
{
    if($('#aa_all').is(':checked')){
        $('input[name=aa_m1]').attr('checked', true);
        $('input[name=aa_m2]').attr('checked', true);
        $('input[name=aa_r1]').attr('checked', true);
        $('input[name=aa_r4]').attr('checked', true);
        $('input[name=aa_r8]').attr('checked', true);
	$("#search-age-drop").text('All');
    }
    else{
	$('input[name=aa_m1]').attr('checked', false);
        $('input[name=aa_m2]').attr('checked', false);
        $('input[name=aa_all]').attr('checked', false);
        $('input[name=aa_r1]').attr('checked', false);
        $('input[name=aa_r4]').attr('checked', false);
        $('input[name=aa_r8]').attr('checked', false);
	$("#search-age-drop").text('');
    }
	$("#age_range7").val("");
	$("#age_m1").val("");
        $("#age_m2").val("");
        $("#age_r1").val("");
        $("#age_r4").val("");
        $("#age_r8").val("");
}


$(document).ready(function(){
    $(".checkbox1").click(function(){
        var val = [];
        $('#age_range7').val('');
        $('.checkbox1:checked').each(function(i){
            val[i] = $(this).val();
            $('#age_range7').val(val);
        });
    });

    $(".checkbox2").click(function(){
        var val1 = [];
        $('#age_range71').val('');
        $('.checkbox2:checked').each(function(i){
            val1[i] = $(this).val();
            $('#age_rangera').val(val1);
        });


    });

    $(".checkbox3").click(function(){
        var val2 = [];
        $('#age_range71_8').val('');
        $('.checkbox3:checked').each(function(i){
            val2[i] = $(this).val();
            $('#age_range71_8').val(val2);
        });
    });
    
    //city dropdown list displaying
    $("#city_dropdown_show").on("click", function(){
        if(($("#city_dropdown_show").attr('src')) =='/assets/search/search_arrow.png')
        {
            $("#city_dropdown_show").attr('src','/assets/search/search_arrow_up.png');
        }
        else if(($("#city_dropdown_show").attr('src')) =='/assets/search/search_arrow_up.png')
        {
            $("#city_dropdown_show").attr('src','/assets/search/search_arrow.png');
        }
        if(($("#city_dropdown_show").attr('src')) == '/assets/search/dropdown_arrow.png')
        {
            $("#city_dropdown_show").attr('src','/assets/search/dropdown_arrow_up.png');
        }
        else if(($("#city_dropdown_show").attr('src')) == '/assets/search/dropdown_arrow_up.png')
        {
            $("#city_dropdown_show").attr('src','/assets/search/dropdown_arrow.png');
        }
        $("#advanceCity_drop").slideToggle("slow");
    });
     
    //auto complete for city selection
    $("#zip_values").autocomplete({
        paramName: 'city',
        minLength: 1,
        lookup: city_values,
        appendTo: $("#zip_values_autocomplete"),
        onSelect: function(suggestion)
        {
            this.value = suggestion.value;
            $("#city_search").val(suggestion.value);
            var expires = new Date();
            expires = new Date(new Date().getTime() + parseInt(expires) * 1000 * 60 * 60 * 24);
            document.cookie = "search_city="+suggestion.value+ ";expires="+expires.toGMTString();
            $("#search_value").focus();
            var select_new_city=suggestion.value;
            //var new_city=(select_new_city.length<12)?select_new_city:(select_new_city.substring(0,9))+'...';
            var new_city = select_new_city;
            $('#zip_values').val(new_city);
		if(window.location.href.indexOf("/category") > -1) {
			window.location.href=window.location.href;
		}
		else
		{
			 event.preventDefault();
		}    
		}
    });
//auto complete for city selection ending hre

});

function date_range_changes1(){
    $("#camp_range7").val('');
    if(document.getElementById('aa_r1').checked )
    {
        $("#age_r1").val("0-3");
    }
    else{
        $("#age_r1").val("");
    }
    if(document.getElementById('aa_r4').checked )
    {
        $("#age_r4").val("4-7");
    }
    else{
        $("#age_r4").val("");
    }
    if(document.getElementById('aa_r8').checked )
    {
        $("#age_r8").val("8+");
    }
    else{
        $("#age_r8").val("");
    }
    if(document.getElementById('aa_r1').checked && document.getElementById('aa_r4').checked && document.getElementById('aa_r8').checked){
        $('input[name=aa_all]').attr('checked', true);
        $("#age_range7").val("All");
    }
    else{
        $('input[name=aa_all]').attr('checked', false);
    }
}


//Age search in landing page New GUI
function age_range_drpchanges(){
    $("#camp_range7").val('');
   if(document.getElementById('aa_m1').checked )
    {
        $("#age_m1").val("0-6");
	$("#search-age-drop").html("0 - 6");
    }
    else{
        $("#age_m1").val("");
    }
   if(document.getElementById('aa_m2').checked )
    {
        $("#age_m2").val("6-12");
	$("#search-age-drop").html("6 - 12");
    }
    else{
        $("#age_m2").val("");
    }
    if(document.getElementById('aa_r1').checked )
    {
        $("#age_r1").val("2-3");
	$("#search-age-drop").html("2 - 3");
    }
    else{
        $("#age_r1").val("");
    }
    if(document.getElementById('aa_r4').checked )
    {
        $("#age_r4").val("4-7");
	$("#search-age-drop").html("4 - 7");
    }
    else{
        $("#age_r4").val("");
    }
    if(document.getElementById('aa_r8').checked )
    {
        $("#age_r8").val("8+");
	$("#search-age-drop").html("8+");
    }
    else{
        $("#age_r8").val("");
    }
    if(document.getElementById('aa_m1').checked && document.getElementById('aa_m2').checked && document.getElementById('aa_r1').checked && document.getElementById('aa_r4').checked && document.getElementById('aa_r8').checked){
        $('input[name=aa_all]').attr('checked', true);
        $("#age_range7").val("All");
        $("#search-age-drop").html("All");
    }
    else if(!document.getElementById('aa_m1').checked && !document.getElementById('aa_m2').checked && !document.getElementById('aa_r1').checked && !document.getElementById('aa_r4').checked && !document.getElementById('aa_r8').checked){
    $("#search-age-drop").text("");
    }
    else{
        $('input[name=aa_all]').attr('checked', false);
    }
}

//when the user onclicking the the price_all check box it will call this function.
function price_all_changes(){
    if($('input[name=p_all]').is(':checked')){
        $('input[name=a_f]').attr('checked', true);
        $('input[name=paid]').attr('checked', true);
        $("#price_range").val("All");
    }
    else{
        $('input[name=p_all]').attr('checked', false);
        $('input[name=a_f]').attr('checked', false);
        $('input[name=paid]').attr('checked', false);
        $("#price_range").val("");
    }
}

//category listing

function get_subCat_id(id,val){
    var hidden_val="";
    var hidden_id_val =""
    //store the values in hidden fields
    if(id>0){
        hidden_val = $("#ad_sub_category_1").val();
        hidden_id_val = $("#ad_sub_category_id_1").val();
        if ($("#ad_cate_"+id).is(':checked'))
        {
            hidden_val+=","+val;
            hidden_id_val+=","+id;
        }
        else
        {
            var a=$("#ad_sub_category_1").val();
            var b = $("#ad_sub_category_id_1").val();
            hidden_val =a.replace(val,"");
            hidden_id_val= b.replace(id,"");
        }
        $("#ad_sub_category_1").val(hidden_val);
        $("#ad_sub_category_id_1").val(hidden_id_val);
    }
}

//while uncheck the check box it will cal for date range
function price_range_changes(){
    var act_type = $("#price_range").val();
    if(document.getElementById('price_free').checked && document.getElementById('price_paid').checked){
        $('input[name=p_all]').attr('checked', true);
        $("#price_range").val("All");
    }
    else{
        $('input[name=p_all]').attr('checked', false);
        $("#price_range").val("");
    }
}
var startDate = "";
var dateToday;
var date_order;
$("#sdate_start").mouseover(function(){					
    $( "#date_start").datepicker({
        onSelect: function(dateText)
        {
            startDate = dateText;
            var x=startDate.split("/");
            date_order=x[2]+","+x[0]+","+x[1];
            dateToday= new Date(date_order);
            $('#date_end').datepicker('option', 'minDate', dateToday);
            $( "#date_end" ).hide();
            $('#end_dates').val('');
            $('#end_dates_formate').html('End Date');
			
            if(x[0]=="01"){
                var a='Jan';
            }
            else  if(x[0]=="02"){
                var a='Feb';
            }
            else if(x[0]=="03"){
                var a='Mar';
            }
            else if(x[0]=="04"){
                var a='Apr';
            }
            else if(x[0]=="05"){
                var a='May';
            }
            else  if(x[0]=="06"){
                var a='Jun';
            }
            else if(x[0]=="07"){
                var a='Jul';
            }
            else if(x[0]=="08"){
                var a='Aug';
            }
            else if(x[0]=="09"){
                var a='Sep';
            }
            else if(x[0]=="10"){
                var a='Oct';
            }
            else if(x[0]=="11"){
                var a='Nov';
            }
            else{
                var a='Dec';
            }
            $('#start_dates').val(x[2]+"-"+x[0]+"-"+x[1]);
            $('#start_dates_formate').html(a+'&nbsp&nbsp;'+x[1]+',&nbsp;'+x[2]);
        }
    });
    //showDatepicker
    $("#date_start" ).show();
				
});
$("#sdate_start").mouseout(function(){		
    $(".drop_down").hide();
    $("#date_start").hide();
});
$("#sdate_end").mouseover(function(){	
    $( "#date_end" ).datepicker({
        onSelect: function(dateText)
        {
            var x=dateText.split("/");
            if(x[0]=="01"){
                var a='Jan';
            }
            else  if(x[0]=="02"){
                var a='Feb';
            }
            else if(x[0]=="03"){
                var a='Mar';
            }
            else if(x[0]=="04"){
                var a='Apr';
            }
            else if(x[0]=="05"){
                var a='May';
            }
            else  if(x[0]=="06"){
                var a='Jun';
            }
            else if(x[0]=="07"){
                var a='Jul';
            }
            else if(x[0]=="08"){
                var a='Aug';
            }
            else if(x[0]=="09"){
                var a='Sep';
            }
            else if(x[0]=="10"){
                var a='Oct';
            }
            else if(x[0]=="11"){
                var a='Nov';
            }
            else{
                var a='Dec';
            }
            $('#end_dates').val(x[2]+"-"+x[0]+"-"+x[1]);
            $('#end_dates_formate').html(a+'&nbsp&nbsp;'+x[1]+',&nbsp;'+x[2]);
        }
    });
    //showDatepicker
    $( "#date_end" ).show();
      
});
$("#sdate_end").mouseout(function(){		
    $(".drop_down").hide();
    $("#date_end").hide();
});
function clear_date(id){
    //$.datepicker._myClearDate('#date_start');
    var currentDate = new Date();
    $("#"+id).datepicker("setDate",currentDate);
    if(id=='date_start')
    {
        $("#start_dates_formate").text("Start date");
        $("#date_start").val('');
    }
    else if(id=='date_end')
    {
        $("#end_dates_formate").text("End date");
        $("#end_dates").val('');
    }
} 

/**Ajax submit in search event index page*/
	
function search_validation(){
    count = 2;
    var search_value =$("#search_value").val(); 
    var errorFlag=false; 
    if(search_value == "" || search_value == "Search 20,000 + Local Activities & Counting..." || search_value == "Search 20,000  Local Activities & Counting...")
    {
        //~ $("#searchboxtxtbox").css("border","1px solid #fc8989");
        /*$( ".lt.hmsearchIcon").on("click", function(e) {
		e.preventDefault();
		var city_search = $('#dynamic_cities').text();
		window.location.href="/search_event_index?"+city_search;
	});*/
        $('.search_removeicon').hide();
        $('#search_blank_error').css('display', 'block');
        advance_search_navigate();
        errorFlag =true;
    } 
    if(errorFlag) 
    { 
        return false;
    } 
    else{
        $(".formTxtbox").css("border","1px solid #2B91AF");
        $('.search_removeicon').show();
        $.get("/basic_search_count",{
            "event_search": search_value
        }, function(data){
            if (data>0)
            {
                var pathname = window.location.pathname;
                /* Search Index Fixes start- dont remove*/
                if (pathname == "/search"){
                    if ($('#basic_Search').css('display') == 'none') {
                        $("#search_event_index").html('<div style="display: block; margin: 0px auto; position: absolute; width: 98%; z-index: 1;" id="loadingmessagethrd" class="loadDiv"><div style="display:block; margin: 0px auto; width:52px; height:52px;" class="loadDiv_img"><img width="52" height="52" class="spinner_gif" src="/assets/loading_new.gif"></div></div>');
                        $('#search_reset').hide("");
                        $.ajax({
                            type: "GET",
                            //data: {"event_search":search_value},
                            url: "/search?event_search="+search_value+"&ajax_rqst=true",
                            dataType:"script"
                        //success: function(){
                        //$("#search_event_index").replaceWith("<%= escape_javascript(render(:partial => 'basic_search')) %>");
                        //}
                        });
                    }
                    else{
                        advance_search_navigate()
                    }
                }
                /* serach instance fixes end*/
                else {
                    if ($('#basic_Search').css('display') == 'none') {
                        window.location = "/search?event_search="+search_value;

                    }else{
                        advance_search_navigate()
                    }
                }
            }
            else{
                $('#fsearch_count').html('(0)');
                $('.right_container').html('<div class="setBg1"><div width="100%" class="no_activities" style="text-align:center;height: 500px;">Sorry we found no results for your search.</div></div>');
                $("#bsearch_norecord").bPopup({
                    modalClose:false
                });
                $("#bsearch_norecord").show();
            }
        }, "script"
        );
        return false;
    } 
}

/*Search functionality*/

/* Function for basic and advanced search*/
	  
function advance_search_navigate()
{
    count = 2;
    var search_word = $("#search_value").val();
    var search_wrd = "";
    if((search_word == "Search 20,000   Local Activities & Counting...") || (search_word == "Search 20,000 + Local Activities & Counting...") || (search_word == ""))
    {
        search_wrd = "";
    }
    else
    {
        search_wrd = search_word;
    }
    zip_value = $("#zip_values").val();
    if(zip_value == "Enter city (or) Zip code")
    {
        $("#city_search").val("");
    }
    $('.adv_search_image').hide();
    $('#loadmoreajaxloader').show();
    $('.normalclass').show();
    $('.displayclass').hide();
    //~ $('input', '#advanced_search_update').each(function(){
    //~ $(this).val() == "" || $(this).val() == "Search 20,000 + Local Activities & Counting..." && $(this).remove();
    //~ })
    var myData = $("#advanced_search_update").serialize() + '&advance_search=yes&ad_search_value='+search_wrd+ '&zip_value='+zip_value;
    window.location.href="/search?"+myData;
}

function advance_search_update()
{
    count = 2;
    $('.right_container').html("");
    var search_word = $("#search_value").val();
    var search_wrd = "";
    if((search_word == "Search 20,000   Local Activities & Counting...") || (search_word == "Search 20,000 + Local Activities & Counting...") || (search_word == ""))
    {
        search_wrd = "";
    }
    else
    {
        search_wrd = search_word;
    }
    zip_value = $("#zip_values").val();
    if(zip_value == "Enter city (or) Zip code")
    {
        $("#city_search").val("");
    }
    $("#basic_Search").slideUp();
    $(".hmsearchIcon").show();
    $("#search_img_down").show();
    $("#search_img_up").hide();
    $("#search_img_down").addClass('search_open').removeClass('search-close');
    $("#search_value").css("width","490px");
    $('.adv_search_image').hide();
    $('#loadmoreajaxloader').show();
    $('.normalclass').show();
    $('.displayclass').hide();
    $("#load_more").css('display','block');

    var myData = $("#advanced_search_update").serialize() + '&advance_search=yes&ad_search_value='+search_wrd;
    $.ajax({
        type: "GET",
        data: myData,
        url: $("#advanced_search_update").attr('action'),
        dataType:"script"
    });
}


function loadActivity(pageNumber) {
    if ($(".pagination a").length > 0) {
        var current_set = $("#curren_set").val();
        $.get($(".pagination .next_page").last().attr('href').replace("ajax_rqst=true","ajax_rqst=false"),
            "search_set_p="+current_set,
            function(){
                processing = false;
                $('#loadmoreajaxloader').hide();
                $('.adv_search_image').show();
            }, "script");
    }
}  
/* zipcode and city search*/
function content_checking_new(type,user,event)
{
    content_checking(type,user,event)
    if ((event.keyCode == 13) && ($("#search_button").is(":visible"))) {
        $("#search_button").click();
    }
}

function content_checking(type,user,event)
{
    if(type=="zip")
    {
        $("#autocomplete_append").css("width","175px").css("max-height","150px").css("overflow-x","hidden").css("z-index:1");
        if (event.keyCode == 13)
        {
            if($("#zip_values_autocomplete #autocomplete_append .autocomplete-suggestion").length ==1)
            {
                search_val = $("#zip_values_autocomplete #autocomplete_append .autocomplete-suggestion").text();
                $('#zip_values').val(search_val);
                var zipcode_city =search_val.substring(name.length,search_val.length)+','+' CA';
                // var new_zipcode_city = (zipcode_city.length < 13)?zipcode_city.replace(/\+/g, " "):(zipcode_city.substring(0,9).replace(/\+/g, " "))+'...';
                var new_zipcode_city = zipcode_city;
                $('#zip_values').val(search_val);
                $("#city_search").val(search_val);
                var expires = new Date();
                expires = new Date(new Date().getTime() + parseInt(expires) * 1000 * 60 * 60 * 24);
                document.cookie = "search_city="+search_val+ ";expires="+expires.toGMTString();
                $("#search_value").focus();
                $('#zip_values').val(new_zipcode_city);
                $(".autocomplete-suggestions").hide();
                event.preventDefault();
            }
            else{
                $("#search_button").click();
            }
            return false;
        }
    }
    else
    {
}
}
	
function clear_search(){
    $('.search_removeicon').hide();
    $("#search_value").val('Search Activities...').css("color","#999999");
}
	
/*zipcode or city search*/
function zip_code_geo(city_chk){
	var state_val
	if (city_chk=='true'){
		state_val = ', CA'
	}
	else
	{
		state_val = ''
	}
    var zip_value = $("#zip_values").val()+state_val;
    if (zip_value !="" && zip_value!="Enter city (or) Zip code" && !isNaN(zip_value)){
        $.ajax({
            url:'zip_search',
            data: {
                "zip_value": zip_value
            },
            success:function(data){
            }
        });
    }
    else{
        var name ="search_city=";
        var ca = document.cookie.split(';');

        for(var i=0; i<ca.length; i++)
        {
            var c = ca[i].trim();
            if (c.indexOf(name)==0){
                //$('#zip_values').hide();
                //$('.dynamic_cities').show();
                var zipcode_city = c.substring(name.length,c.length);
                //var new_zipcode_city = (zipcode_city.length < 13)?zipcode_city.replace(/\+/g, " "):(zipcode_city.substring(0,9).replace(/\+/g, " "))+'...';
                var new_zipcode_city =zipcode_city;
		    //~ alert(new_zipcode_city);
		var newzpcity = (new_zipcode_city.replace(/\+/g,' ').replace(/\%2C/g,',')); //replacing the string 
		if (navigator.userAgent.search("Safari") >= 0 && navigator.userAgent.search("Chrome") < 0) 
			{
				$("#zip_values").val(newzpcity+', CA');				
			}
		else
			{
				$("#zip_values").val(newzpcity);
			}
                $("#search_value").focus();
                //$(".hmsearchIcon").show();
                //$("#search_value").css("width","490px");
                return c.substring(name.length,c.length);
            }
        }
        return "Walnut Creek, CA";
    }
    return false;
}
/*Search text focus in and out */
	
//~ $("#search_value").focusin(function(){
//~ search_key_focus();
//~ });

//~ $("#search_value").focusout(function(){
//~ search_key_clearfocus()
//~ });
	
function search_key_focus() {
    var search_word = $("#search_value").val();
    if ((search_word == "Search 20,000   Local Activities & Counting...") || (search_word == "Search 20,000 + Local Activities & Counting..."))
    {
        $("#search_value").val("");
    }
}
function search_key_clearfocus() {
    var search_word = $("#search_value").val();
    if (search_word == "")
    {
        $("#search_value").val("Search 20,000 + Local Activities & Counting...");
    }
}

//browse location ajax calling
function getcityval(gid,gname)
{
    $(".loading_image_i").css("display","inline-block");
    $("#city_group").val(gname); //display the text val
    $("#advanceCity_drop").hide(); // hide the dropdown list
    $.get("/locations", {
        "gid":gid
    }, null, "script");
    return false;
}
//city onchange values
function cityselectedvalue(){

    var gid = $('#cityselectedval').val();
    if(gid =="all"){
        document.cookie="browse_city=All Cities";
    }
    else if(gid==1){
        document.cookie="browse_city=East Bay";
    }
    else if(gid==2){
        document.cookie="browse_city=Peninsula";
    }
    else if(gid==3){
        document.cookie="browse_city=South Bay";
    }
    else if(gid==4){
        document.cookie="browse_city=North Bay";
    }
    $(".loading_image_i").css("display","inline-block");
    $.get("/locations", {
        "gid":gid
    }, null, "script");
    return false;
}

/* To hide get $ 20 when scroll occurs  in New GUI  */
   $(window).scroll(function() {
      var height = $(window).scrollTop();
      if(height >120) {
        $('.get-credit').css('display','none');
      }else{
        $('.get-credit').css('display','block');
      }
    });
/* To hide get $ 20 when scroll occurs */
    
    
  
      