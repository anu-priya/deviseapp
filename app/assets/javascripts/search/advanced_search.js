var startDate = "";
var dateToday;
var date_order;
$(document).ready(function(){
    $("#chose_city .cities").mouseover(function(){
        $(this).css("color","#ff0000");
    });

    $("#chose_city .cities").mouseout(function(){

        $(this).css("color","");
    });

    $("#zip_enter").click(function(){
        $("#zip_enter").hide();
        $("#zip_value").show();
        $("#zip_values").val("Enter city (or) Zip code");
        $("#zip_values").css("color","#999999");
        $("#zip_code").css("padding", "3px 1px 3px 12px");

    });
    $("#zip_values").focusin(function(){
        var zipValue = $("#zip_values").val();

        if(zipValue=="Enter city (or) Zip code"){

            $("#zip_values").val("");

        }
        $("#zip_values").css("color","#444444");
    });
    $("#zip_values").focusout(function(){
        if($("#zip_values").val()==""){
            $("#zip_values").val("Enter city (or) Zip code");
            $("#zip_values").css("color","#999999");
        }
    });

    $("#price_enter").click(function(){

        $("#price_enter").hide();
        $("#price_value").show();
        $("#price_values").val("Enter price");
        $("#price_values").css("color","#999999");
        $("#Price").css("padding", "3px 1px 3px 12px");

    });
    $("#price_values").focusin(function(){

        $("#price_values").val("");
        $("#price_values").css("color","#000000");
    });
    $("#price_values").focusout(function(){
        if($("#price_values").val()==""){
            $("#price_values").val("Enter price");
            $("#price_values").css("color","#999999");
        }
    });
	
    $("#search_value").focusin(function(){
        var search_word = $("#search_value").val();
        if ((search_word == "Search 20,000   Local Activities & Counting...") || (search_word == "Search 20,000 + Local Activities & Counting..."))
        {
            $("#search_value").val("");
        }
    });

    $("#search_value").focusout(function(){
        var search_word = $("#search_value").val();
        if (search_word == "")
        {
            $("#search_value").val("Search 20,000 + Local Activities & Counting...");
        }
    });

    $(".cityText").click(function(){
        var selectedCity = $("#city_search").val();
        $("#selecteCity").html(selectedCity);
        $(".cityText").css("font-weight","normal");
        $(this).css("font-weight","bold");
    });
    
    $(".cityText").mouseover(function(){        
        $(this).addClass("city_highlight");
	    
    });
    $(".cityText").mouseout(function(){
        $(this).removeClass("city_highlight");        
    });

    $(".cityText").click(function(){

        $(".cityText").css("font-weight","normal");

        $(this).css("font-weight","bold");

        var svalue = $(this).html();

        $("#selectedCity").html(svalue);

        $("#city_search").val(svalue);
    });
    
    $(".bS_menus").mouseover(function(){
        //alert($(this).attr('id'));
        var id=$(this).attr('id');
        if(id=="activity_type"){
            $("#activity_typ").show();
        }
        else{
            $("#activity_typ").hide();
        }
        if(id=="category"){
            //alert('hi')
            showCategory();
        }
        else{
            hideCategory();
        }
        if(id=="gend_r"){
            $("#gender").show();
        }
        else{
            $("#gender").hide();
        }


        if(id=="day_W"){
            $("#d_week").show();
        }
        else{
            $("#d_week").hide();
        }


        if(id=="ca_mp"){
            $("#camp").show();
        }
        else{
            $("#camp").hide();
        }



        if(id=="Price"){
            $("#chose_price").show();
        }
        else{
            $("#chose_price").hide();
        }


        if(id=="start_D"){
            $( "#date_start" ).datepicker({
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
            $( "#date_start" ).show();		
        }
        else{
            //hideDatepicker
            $( "#date_start" ).hide();
        }
        if(id=="end_D"){ 
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
        }
        else{
            //hideDatepicker
            $( "#date_end" ).hide();
        }
        if(id=="age_range"){
            $("#range_age").show();
        }
        else{
            $("#range_age").hide();
        }
        if(id=="city_choose"){
            $("#chose_city").show();
        }
        else{
            $("#chose_city").hide();
        }
    });


    $(".bS_menus").mouseout(function(){
        $(".drop_dwon").hide();
    });
    
    $("#age_range").mouseover(function(){
	
	
        $("#range_age").show();
       
    });
    $("#age_range").mouseout(function(){
	
        $(".drop_dwon").hide();
       
    });
    
    /*$("#search_advance").click(function(){
	$("#basic_Search").toggleClass("show_search");
    });    */
    
    
    $(".search_advance").click(function () {
        //alert($(this).attr("id"));
        var clas=$(this).attr("id");
        if(clas=="search_img_up"){
            $('#search_img_down').show();
            $('#search_img_up').hide();
        }
        else if(clas=="search_img_down"){
            $('#search_img_down').hide();
            $('#search_img_up').show();
        }
        if ( $(this).hasClass('search_open') )
        {
            $("#search_img_up").addClass('search-close').removeClass('search_open');
            var pathArray = window.location.pathname.split( '/' );
            if( pathArray[1]=="search")
            {
		
                setTimeout("$('.topbanner').css('height','253px');",100);
            }
            else{
                setTimeout("$('.topbanner').css('height','243px');",100);
            }
            $(this).addClass('search-close').removeClass('search_open');
            $('#dynamic_cities').addClass('search-close').removeClass('search_open');
            $("#basic_Search").slideDown();
        }
        else if ( $(this).hasClass('search-close') )  { 
            $("#basic_Search").slideUp();
            $("#search_img_down").addClass('search_open').removeClass('search-close');
            var pathArray = window.location.pathname.split( '/' );
            // alert(pathArray);
            if( pathArray[1]=="search")
            {
		
                setTimeout("$('.topbanner').css('height','253px');",200);
            }
            else{
                setTimeout("$('.topbanner').css('height','243px');",200);
            }
            $(this).addClass('search_open').removeClass('search-close');
            $('#dynamic_cities').addClass('search_open').removeClass('search-close');
	    
            
            var name ="search_city=";
            var ca = document.cookie.split(';');
	    
            for(var i=0; i<ca.length; i++)
            {
                var c = ca[i].trim();
                if (c.indexOf(name)==0){
                    //$('#zip_values').hide();
                    //$('.dynamic_cities').show();
                    var zipcode_city = c.substring(name.length,c.length);
                    var new_zipcode_city = (zipcode_city.length < 13)?zipcode_city.replace(/\+/g, " "):(zipcode_city.substring(0,9).replace(/\+/g, " "))+'...';
                    $(".dynamic_cities").text(new_zipcode_city);
                    //$(".dynamic_cities").text(c.substring(name.length,c.length).replace(/\+/g, " "));
                    //$("#mouseover_effect").hide();
                    $("#search_value").focus();
                    var select_new_city=c.substring(name.length,c.length);
                    var new_city=(select_new_city.length<13)?select_new_city.replace(/\+/g, " "):(select_new_city.substring(0,9).replace(/\+/g, " "))+'...';
                    $(".dynamic_cities").text(new_city);
		   
                    return c.substring(name.length,c.length);
			
                }
            }
            return "Walnut Creek";
	
        }
    });
/*     $(".search_open").click(function () {
	 $("#basic_Search").slideDown();
	    $('.topbanner').css("height","236px");
	$(this).addClass('search-close').removeClass('search_open');
       });*/
       
/*$(".search-close").click(function () {
	alert(close);
	//   $('.topbanner').css("height","200px");
	//$(this).addClass('search_open').removeClass('search_close');
	//$("#basic_Search").slideUp();
       });*/
       
/* $("#search_advance").click(function () {
        $('#basic_Search').slideToggle();
         $('.topbanner').css("height","200px");
    })*/
    

});

function showCategory()
{
    $(".advance_ChooseCategory").addClass("chooseCategorySelected");
    $("#adv_category_detail").show();
}

function week_range_changes(){
    var val1 = [];
    $('#age_rangera').val('');
    if(document.getElementById('day_of_week_1').checked )
    {
        val1+=",Mon";
    }
    if(document.getElementById('day_of_week_2').checked )
    {
        val1+=",Tue";
    }
    if(document.getElementById('day_of_week_3').checked )
    {
        val1+=",Wed";
    }
    if(document.getElementById('day_of_week_4').checked )
    {
        val1+=",Thu";
    }
    if(document.getElementById('day_of_week_5').checked )
    {
        val1+=",Fri";
    }
    if(document.getElementById('day_of_week_6').checked )
    {
        val1+=",Sat";
    }
    if(document.getElementById('day_of_week_7').checked )
    {
        val1+=",Sun";
    }
    $('#age_rangera').val(val1);
}


function hideCategory()
{
    $(".advance_ChooseCategory").removeClass("chooseCategorySelected");
    $("#adv_category_detail").hide();
}
function showCity()
{
    $(".adv_chooseCityMenu").addClass("cityselected");
    $("#adv_city_detail").show();
}
function hideCity()
{
    $(".adv_chooseCityMenu").removeClass("cityselected");
    $("#adv_city_detail").hide();
}

//login feature bpopup displayed
function login_feature(sav,actid)
{
    var act=sav;
    var activity_id=actid;
    //~ $('.popupContainer').css('z-index','9998');
    $('#login_use_feature').bPopup({
        fadeSpeed:100,
        followSpeed:100,
        opacity:0.8,
        positionStyle: 'absolute',
        modalClose: false
    },function(){
        $( "#loginFeature" ).click(function(){
            pop_Login('/login?act='+act+'&activity_id='+actid);
        });
    });
}

	
function login_feature_detail(act)
{
    var activity_id=act;
    $('#login_use_feature').bPopup({
        fadeSpeed:100,
        followSpeed:100,
        opacity:0.8,
        positionStyle: 'absolute',
        modalClose: false
    },function(){
        $( "#loginFeature" ).click(function(){
            pop_Login('/login?activity_id='+activity_id);
        });
    });
}

	
//~  ajax formsubmit_ajax_form by rajkumar
function parent_advancesearch()
{
    var search_word = $("#search_value").val();
    var search_page = $("#passing_page").val();
    if ((search_word != "Search Activities...") && (search_word != ""))
    {
        var search_wrd = search_word;
    }
    else
    {
        var search_wrd = "";
    }
    $('.adv_search_image').hide();
    $('#loadmoreajaxloader').show();
    $('.normalclass').show();
    $('.displayclass').hide();
    $.get($("#advanced_search_form").attr('action'), $("#advanced_search_form").serialize() + '&event_search=lafa'+search_wrd + '&search='+search_wrd + '&act='+search_page, function(){
        $('#loadmoreajaxloader').hide();
        $('.adv_search_image').show();
    }, "script");
    return false;
}


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
    var myData = $("#advanced_search_update").serialize() + '&advance_search=yes&ad_search_value='+search_wrd+ '&zip_value='+zip_value;
    window.location.href="/search?"+myData;
}




function advance_search_update()
{
    processing = false;
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


/*function city_search(city_name){
    $("#city_search").val(city_name);
}*/
 

function loadActivity(pageNumber) {
    if ($(".pagination a").length > 0) {
        var current_set = $("#curren_set").val();
        $.get($(".pagination a")[0].href.replace("ajax_rqst=true","ajax_rqst=false"),
            "search_set_p="+current_set+"&page="+pageNumber,
            function(){
                processing = false;
                $('#loadmoreajaxloader').hide();
                $('.adv_search_image').show();
            }, "script");
    }
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

});
function camp_all_changes(){
    if($('input[name=a_all]').is(':checked')){
        $('input[name=c_r1]').attr('checked', true);
        $('input[name=c_r4]').attr('checked', true);
        $("#camp_range_1").val("All");
    }
    else{
        $('input[name=a_all]').attr('checked', false);
        $('input[name=c_r1]').attr('checked', false);
        $('input[name=c_r4]').attr('checked', false);
        $("#camp_range_1").val("");
    }
}
function camp_range_changes(){
    $("#camp_range_1").val('');
    if(document.getElementById('a_r1').checked )
    {
        $("#camp_range_1").val("specials");
    }
    if(document.getElementById('a_r4').checked )
    {
        $("#camp_range_1").val("camp");
    }
    if(document.getElementById('a_r1').checked && document.getElementById('a_r4').checked){
        $('input[name=a_all]').attr('checked', true);
        $("#camp_range_1").val("All");
    }
    else{
        $('input[name=a_all]').attr('checked', false);
    }
}
function daterange_all_changes1()
{
    if($('input[name=aa_all]').is(':checked')){
        $('input[name=aa_r1]').attr('checked', true);
        $('input[name=aa_r4]').attr('checked', true);
        $('input[name=aa_r8]').attr('checked', true);
        $("#age_range7").val("All");
    }
    else{
        $('input[name=aa_all]').attr('checked', false);
        $('input[name=aa_r1]').attr('checked', false);
        $('input[name=aa_r4]').attr('checked', false);
        $('input[name=aa_r8]').attr('checked', false);
        $("#age_range7").val("");
    }
}

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
// allow numbers only
function number(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57 ) && (charCode != 46 ) ){
        //alert("Allow only Numbers");
        return false;



    }
    return true;
}

function content_checking_new(type,user,event)
{
    
    content_checking(type,user,event)
    if ((event.keyCode == 13) && ($("#search_button").is(":visible"))) {
        $("#search_button").click();
    }
}

function content_checking(type,user,event)
{
   // alert('advance')
    if(type=="zip")
    {
        $("#autocomplete_append").css("width","175px").css("max-height","150px");
        if (event.keyCode == 13)
        {
            if($("#zip_values_autocomplete #autocomplete_append .autocomplete-suggestion").length ==1)
            {
                search_val = $("#zip_values_autocomplete #autocomplete_append .autocomplete-suggestion").text();
                $('#zip_values').val(search_val);
                var zipcode_city =search_val.substring(name.length,search_val.length);
                //var new_zipcode_city = (zipcode_city.length < 13)?zipcode_city.replace(/\+/g, " "):(zipcode_city.substring(0,9).replace(/\+/g, " "))+'...';
               var new_zipcode_city = zipcode_city;
			
                $('#zip_values').val(search_val);
			
                $("#city_search").val(search_val);
                var expires = new Date();
                expires = new Date(new Date().getTime() + parseInt(expires) * 1000 * 60 * 60 * 24);
                document.cookie = "search_city="+search_val+ ";expires="+expires.toGMTString();
                //$.cookie("search_city", suggestion.value);
                // $('#zip_values').hide();
                // $('#zip_values').val(search_val);

                //$("#mouseover_effect").hide();
                $("#search_value").focus();
                //$('.dynamic_cities').show();
                $('.dynamic_cities').text(new_zipcode_city);
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
        if( user !="")
        {
            $(".autocomplete-suggestions").css("top","233px");
        }
        else
        {
            $(".autocomplete-suggestions").css("top","333px"); //343
        }
    }
}