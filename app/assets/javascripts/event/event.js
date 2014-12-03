//when the user onclicking the schedule all check box it will call this function.
function schedule_all_changes(){
    if($('input[name=sch_1]').is(':checked')){
        $('input[name=sch_2]').attr('checked', true);
        $('input[name=sch_3]').attr('checked', true);
        $('input[name=sch_4]').attr('checked', true);
        $('input[name=sch_5]').attr('checked', true);
        $("#activity_type").val("All");
    }
    else{
        $('input[name=sch_1]').attr('checked', false);
        $('input[name=sch_2]').attr('checked', false);
        $('input[name=sch_3]').attr('checked', false);
        $('input[name=sch_4]').attr('checked', false);
        $('input[name=sch_5]').attr('checked', false);
        $("#activity_type").val("");
    }
}
//while unchecking the check box it will call in activity type
function schedule_changes(){
    var act_type = $("#activity_type").val();
    if(document.getElementById('schedule').checked && document.getElementById('by_appoinment').checked && document.getElementById('any_time').checked && document.getElementById('camps').checked ){
        $('input[name=sch_1]').attr('checked', true);
        $("#activity_type").val("All");
    }
    else{
        $('input[name=sch_1]').attr('checked', false);
        $("#activity_type").val("");
    }
}
//while uncheck the check box it will cal for date range
function date_range_changes(id,value){
    if(document.getElementById('a_r'+id).checked){
        $('#age_r'+id).val(value);
    }
    else{
        $('#age_r'+id).val('');
    }
}
//display city the div on mouse over the data.
$(function(){
    $('.chooseCityMenu').hover(function (){
        $(".chooseCityMenu").css("border","1px solid #BDD6DD");
        $(".chooseCityMenu").css("background","#e5f4f9");
        $("#city_detail").show();
    }, function(){
        $(".chooseCityMenu").css("border","1px solid #fff");
        $(".chooseCityMenu").css("background","#fff");
        $("#city_detail").hide();
    });
});
//display category the div on mouse over the data.
$(function(){
    $('.advanceChooseCategory').hover(function (){
        $(".advanceChooseCategory").css("border","1px solid #BDD6DD");
        $(".advanceChooseCategory").css("background","#e5f4f9");
        $("#category_detail").show();
    }, function(){
        $(".advanceChooseCategory").css("border","1px solid #fff");
        $(".advanceChooseCategory").css("background","#fff");
        $("#category_detail").hide();
    });
});
function showCity()
{
    $(".chooseCityMenu").css("border","1px solid #BDD6DD");
    $(".chooseCityMenu").css("background","#e5f4f9");
    $("#city_detail").show();
    $('#datepicker_ad').removeClass('hasDatepicker').datepicker();
    $('#ui-datepicker-div').hide();
    $('#datePickerOver_ad').removeClass('datePickerOverAdvancedSelected');
    $('#datePickerOver_ad').addClass('datePickerOver_ad');
}
function hideCity()
{
    $("#city_detail").hide();
    $(".chooseCityMenu").css("border","1px solid #fff");
    $(".chooseCityMenu").css("background","#fff");
}
//while click the city it will the data
function city_select(value,id)
{
    $('#city_detail .cityNameText span').removeClass("on");
    $('#city_detail .cityNameText span').addClass("off");
    $('.cityNameText span#ct_'+id).removeClass('off');
    $('.cityNameText span#ct_'+id).addClass('on');
    var a=$("#city_1").val(value);
}
//show categories values
function showCategory()
{
    $(".advanceChooseCategory").css("border","1px solid #BDD6DD");
    $(".advanceChooseCategory").css("background","#e5f4f9");
    $("#category_detail").show();
    $('#datepicker_ad').removeClass('hasDatepicker').datepicker();
    $('#ui-datepicker-div').hide();
    $('#datePickerOver_ad').removeClass('datePickerOverAdvancedSelected');
    $('#datePickerOver_ad').addClass('datePickerOver_ad');
}
function hideCategory()
{
    $(".advanceChooseCategory").css("border","1px solid #fff");
    $(".advanceChooseCategory").css("background","#fff");
    $("#category_detail").hide();
}
/*save the checked value in hidden field*/
function addcategory(){
    var val = '';
    var i;

    if(!$('#advancesearch_vert #adv_category_detail input[type="checkbox"]').is(":checked") ){
        alert("Please choose atleast one subCategry");
        return false;
    }
    else{
        document.getElementById("adv_category_detail").style.display="none";
        return true;
    }

}

/*settings for mobile*/

