function search_load(){
    var url = $(".pagination .next_page").last().attr('href');
    var win_url = url+"&page_load=yes";
    if(navigator.appName=="Microsoft Internet Explorer")
    {
        window.location.hash='';
    }
    else
    {
        window.history.replaceState("object or string", "Title",win_url);
    }
    if (url) {
        $('#search_load').show();
        return $.getScript(url);
    }
}


function category_mouse_over(id,type){
    if(type == "on"){
        $('#cat_sub_'+id).css('display','block');
        $('#arrow_cat_'+id).css('display','block');
        $('#cat_arrow_'+id).removeClass('cat_arrow').addClass('cat_arrow_hover');
        $('#cat_text_'+id).addClass('cat_text_hover');
    }else{
        $('#cat_sub_'+id).css('display','none');
        $('#arrow_cat_'+id).css('display','none');
        $('#cat_arrow_'+id).removeClass('cat_arrow_hover').addClass('cat_arrow');
        $('#cat_text_'+id).removeClass('cat_text_hover');
    }
}
function search_advance_load(){
    $('#search_load').show();
    $('#search_desc').html("");
    var search_value = $("#search_value").val();
    var url =  $('#advanced_search_form').serialize()+'&advance_search=yes&event_search='+search_value
    var set_url =$('#advanced_search_form').attr('action')+"?"+$('#advanced_search_form').serialize()+'&advance_search=yes&event_search='+search_value
    if(navigator.appName=="Microsoft Internet Explorer")
    {
        window.location.hash='';
    }
    else
    {
        window.history.replaceState("object or string", "Title",set_url);
    }
    $.get($('#advanced_search_form').attr('action'),url, null, "script");
    return false;
}
function clear_date(id){
    if(id=='date_start')
    {
        $("#date_start").val("Start Date");
        $("#date_start_alt").val('');
    }
    else if(id=='date_end')
    {
        $("#date_end").val("End Date");
        $("#date_end_alt").val('');
    }
}

$(document).ready(function(){
    $(".cust_scroll").mCustomScrollbar({
        theme:"dark-2"
    });
});

loc_value= new Array();
$(".city_select").change(function(){
	var arr_sort = new Array();
	ch_id= $(".city_select").index(this);
	loc_value1 = $(".city_select:eq( "+ch_id+")").val();	
	if($("#city_exist").val()=='yes'){
		$("#city_exist").val('no');
		ext_city =  $("#city").val();		
		loc_value = ext_city.split(",");
	}
	if($(".city_select:eq( "+ch_id+")").is(':checked'))
	{
		//check box checked add city		
		loc_value.push(loc_value1);
	}
	else
	{	//uncheck the city remove city from the string		
		var index = $.inArray(loc_value1, loc_value);
		if(index != -1)
		{
		  loc_value.splice(index, 1);
		}				
	}	
	/*$(".city_select").each(function(){
		if( $(this).is(':checked')){		
		arr_sort.push($(this).val());
		}
	});*/
	$("#city").val(loc_value); 
	str= $("#city").val();
	city_values=str.replace(/,/g,', '); 	
	search_head = "";
	if(loc_value.length > 0)
	{
		search_head = "<span style='color:#4b98af;'>Selected Location(s) - </span>";
	}

    $("#search_selectedval").html(search_head + city_values);
});

$(".parent_category_check").change(function(e){
    var arr_sort = new Array();

    $(".category_check").each(function(){
        var sub_cat_arr = new Array();
        var id= this.id
        if( $("#cat_all").is(':checked')){
            $(this).attr('checked', true);
        }else{
            $(this).attr('checked', false);
        }
        if( $(this).is(':checked')){
            arr_sort.push($(this).val());
            $(".sub_category_check."+id).each(function(){
                $(this).attr('checked', true);
                sub_cat_arr.push($(this).val());
            });
        }else{
            $(".sub_category_check."+id).each(function(){
                $(this).attr('checked', false);
            });
        }
        $("#sub_"+id).val(sub_cat_arr);
    });
    $("#category").val(arr_sort);    
}
);

$(".category_check").change(function(){
    var arr_sort = new Array();
    $(".category_check").each(function(){
        var sub_cat_arr = new Array();
        var id= this.id
        if( $(this).is(':checked')){
            arr_sort.push($(this).val());
            if($("#sub_"+id).val()==""){
                $(".sub_category_check."+id).each(function(){
                    $(this).attr('checked', true);
                    sub_cat_arr.push($(this).val());
                });
                $("#sub_"+id).val(sub_cat_arr);
            }
        }else{
            $(".sub_category_check."+id).each(function(){
                $(this).attr('checked', false);
            });
            $("#sub_"+id).val(sub_cat_arr);
        }
       
    });
    $("#category").val(arr_sort);
    if ($(".category_check").length == $(".category_check:checked").length ){
        $("#cat_all").attr('checked', true);
    }else{
        $("#cat_all").attr('checked', false);
    }

});



$(".sub_category_check").change(function(){
    var sub_cat_arr = new Array();
    var id = this.className.replace("sub_category_check","").trim();
    $(".sub_category_check."+id).each(function(){
        if( $(this).is(':checked')){
            sub_cat_arr.push($(this).val());
        }
    });
    if((!$("#"+id).is(':checked'))||(sub_cat_arr=="") ){
        if(sub_cat_arr==""){
            $("#"+id).attr('checked',false);
        }else{
            $("#"+id).attr('checked',true);
        }
        var arr_sort = new Array();
        $(".category_check").each(function(){
            if( $(this).is(':checked')){
                arr_sort.push($(this).val());
            }
        });
        $("#category").val(arr_sort);
    }
    if(sub_cat_arr==""){
        $("#"+id).attr('checked',false);
    }
    $("#sub_"+id).val(sub_cat_arr);
    if ($(".category_check").length == $(".category_check:checked").length ){
        $("#cat_all").attr('checked', true);
    }else{
        $("#cat_all").attr('checked', false);
    }
});

$(".age_check_parent").change(function(){
    if( $(this).is(':checked')){
        $(".age_check").each(function(){
            $(this).attr('checked',true);
        });
    }else{
        $(".age_check").each(function(){
            $(this).attr('checked',false);
        });
    }
})
$(".age_check").change(function(){
    if($(".age_check:checked").length == 5){
        $(".age_check_parent").attr('checked',true);
    }else{
        $(".age_check_parent").attr('checked',false);
    }
})

$(".day_check_parent").change(function(){
    var day_arr = new Array();
    if( $(this).is(':checked')){
        $(".day_check").each(function(){
            $(this).attr('checked',true);
            day_arr.push($(this).val());
        });
    }else{
        $(".day_check").each(function(){
            $(this).attr('checked',false);
        });
    }
    $("#day_range").val(day_arr);
})
$(".day_check").change(function(){
    var day_arr = new Array();

    $(".day_check").each(function(){
        if( $(this).is(':checked')){
            day_arr.push($(this).val());
        }
    });

    $("#day_range").val(day_arr);
    if($(".day_check:checked").length == 7){
        $(".day_check_parent").attr('checked',true);
    }else{
        $(".day_check_parent").attr('checked',false);
    }
})

$('#day_all').click(function() {
    if(this.checked) {
        $('.day_select').each(function() {
            this.checked = true;
        });
    }else{
        $('.day_select').each(function() {
            this.checked = false;
        });
    }

});

$("#date_all").click(function() {
    if(this.checked) {
        $("#date_start").val('Start Date');
        $("#date_end").val('End Date');
        $("#date_start_alt").val('');
        $("#date_end_alt").val('');
    }else{
}

});




