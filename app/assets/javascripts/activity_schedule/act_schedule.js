function add_activity(){
    $("#added_activity").show();
}
function closeDiv(){
    $("#added_activity").hide();
}
function open_activity_detail(id,date){   
    $('.showActivityDetail').hide();
    $('#show_detail_'+id+'_'+date).show();
}
function close_activity_detail(id,date){
    $('#show_detail_'+id+'_'+date).hide();
}
