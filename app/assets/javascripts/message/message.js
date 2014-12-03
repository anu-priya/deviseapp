
function findMsgHt(){
    // set center area height
    var windowHt = $( window ).height();
    var centerHt = windowHt-185;
    
    // set center area height
    adjust_height=centerHt+51;
    $(".message_list .listLt").css("height",centerHt+"px");
    //$(".listRt").css("height",adjust_height+"px");
    $(".listRt").css("height","795px");
    
    // center align message
    padding_to_center=(centerHt/2)-(207/2);
    $(".crt_new").css("position","relative").css("top",padding_to_center+"px");
    
    // set Width & Height for Right message content
    var windowWidth = $( window ).width();
    right_content=(windowWidth*30)/100;
    adjust_width=windowWidth-right_content;
    $("#content_accordian").css("width",adjust_width+"px").css("word-wrap","break-word");
    $(".ui-accordion-content").css("height","auto");
}

$(document).ready(function () {
    findMsgHt();
});
$( window ).resize(function() {
  //  findMsgHt();
});
//get mutiple check box id and store to hidden field

/*var scrollHandler = function(){
    myScroll = $(window).scrollTop();
}

$("#itemBind").click(function(){
    $(window).scroll(scrollHandler);
}).click(); // .click() will execute this handler immediately

$("#itemUnbind").click(function(){
    $(window).off("scroll", scrollHandler);
});*/
function getchk_actid(curr_actid,curr_status,mess_id)
{   
    $("#select").hide()
    $("#not_select").show()
    span_index=$(".checkboxImg").index(curr_status);
    chk_staus=$(".checkboxImg:eq("+span_index+") label").attr('class');
    txt_id = ''
    if(chk_staus=="altCheckboxOn")
    {
        //add selected checkbox id
        txt_id=$("#actid_chk").val();
        //~ selected_ids=txt_id+","+curr_actid;
        selected_ids = txt_id.replace(mess_id+",",'').replace(mess_id,'').replace(","+mess_id,'');
        if (selected_ids==","){
            selected_ids=selected_ids.replace(",",'');
        }
        //selected_ids = txt_id.replace(","+mess_id,'');
        $("#actid_chk").val(selected_ids);
        $(".checkboxImg:eq("+span_index+") label").removeClass("altCheckboxOn");
        $(".checkboxImg:eq("+span_index+") label").addClass("altCheckboxOff");
    }
    else
    {
        //remove the id
        txt_id=$("#actid_chk").val();
        //~ selected_ids=txt_id.replace(","+curr_actid,'');
        selected_ids=txt_id+","+mess_id;
        $("#actid_chk").val(selected_ids);
        $('#select').css('display','none');
        $('#not_select').css('display','inline-block');
        $('#pe').val(0);
        $(".checkboxImg:eq("+span_index+") label").removeClass("altCheckboxOff");
        $(".checkboxImg:eq("+span_index+") label").addClass("altCheckboxOn");
    }
    //alert("ss");
    //$(window).scroll(scrollHandler);
}


//Select Any in Messages
function selectAnyMessage(cname){   
    if(cname == 'select'){
        $('#select').css('display','none');
        $('#not_select').css('display','inline-block');
        $('#pe').val(0);
        $('.activityName label').removeClass('altCheckboxOn');
        $('.activityName label').addClass('altCheckboxOff');
        $("#actid_chk").val('');
    }
    else if(cname == 'not_select'){
        $('#not_select').css('display','none');
        $('#select').css('display','inline-block');
        $('#pe').val(1);
        $('.activityName label').removeClass('altCheckboxOff');
        $('.activityName label').addClass('altCheckboxOn');
        //select all checkbox id to add hidden field
        chk_len=$("#provider_partial_event_list .activityName input:checkbox").length;
        $("#actid_chk").val('');
        selected_ids="";
        for(i=1; i<=chk_len; i++)
        {
            //~ chk_id=$(".centerContainer .activityName input:checkbox:eq("+i+")").attr('id');
            chk_id=$("#pe"+i).attr('data');
            //~ chk_id_rep=chk_id.replace("pe","");
            if(i=="0")
            {
                selected_ids=chk_id;
            }
            else
            {
                selected_ids=(selected_ids=="") ? chk_id : (selected_ids+","+chk_id);
            }
        }
        $("#actid_chk").val(selected_ids);
    }
}


//To delete messages
function deleteMessage(u_id){
    var msg_ids_del = $("#actid_chk").val();
    $.ajax({
        url:'/message_delete',
        data: {
            "msg_ids": msg_ids_del,
            "user_id": u_id
        },
        success:function(data){
            if (data=='true'){
                $("#error-message").css("display","block");
                window.location.reload();
            }
        }
    }); 
    
}


// display right side (Detailed Messge list)
function show_msg_detail_list(leftId,u_mode,msgtype){
       if(navigator.appName!="Microsoft Internet Explorer"){
    var stateObj = {foo: "bar"};
        history.pushState(stateObj, 'Message', '/messages?mode='+u_mode);
     }

  //  $("#msgThreadDetList").html('<div align="center" style="display: block; margin: 0px auto; position: absolute; width: 98%; z-index: 1;" id="loadingmessagethrd" class="loadDiv"><div style="display:block; margin:200px 0px 200px 0px; margin-right:50%;" class="loadDiv_img"><img class="spinner_gif" src="/assets/loading.gif"></div></div>');
    $.ajax({
        
        url:'/message_thread_listing',
        data: {
            "message_id": leftId,
            "user_mode": u_mode,
            "msgtype": msgtype
        },
        success:function(data){
            //var msg_cnt=$("#msg_cnt").val();
        $("#msgThreadDetList").html(data);
        $(".msgShortList").removeClass("setDarkBg");
        $("#msgShortList_"+leftId).addClass("setDarkBg");
        $(".image_circle").addClass("normal_circleimage");
        $(".image_circle").removeClass("blue_circleimage");
        $("#list_circle_"+leftId).addClass("blue_circleimage");
        $("#msg_subject_"+leftId).removeClass("msgsubject");

           // Last thread to be open
            var thr_count = $("#thread_count").val();
            var accordOptions={
            collapsible:true,
            active:(thr_count-1)
            };
            // Refresh message right side contents................
            $(".msgDetailList").show();
            //~ $( "#accordion" ).accordion(accordOptions);
            // unread msg
            //~ $("#unreadMsg").removeClass("unreadMsg");
            //set center area height
            findMsgHt();
            $.ajax({
                url:'/message_thread_listing',
                data:{ "count": "msg_count"},
                    success:function(data){
            if (data==0)
            {
            $(".message_count").hide();
            $("#notification_msg_count_"+leftId).hide();
            $("#message_count_icon").css("background","url('/assets/message/message_plain.png')no-repeat center center")
            $("#msg").hide();
            }
            else{
                        //$("#msg").text(data);
                        if (data>9)
                           { var cnt="9+"}
                        else
                           { var cnt=data }
                        $("#msg").text(cnt);
                        $("#notification_msg_count_"+leftId).hide();
                        //$("#notification_msg_count_"+).removeClass("notification_count");
            }
                    }
             }); 
         }
    }); 
    
    
}
//actuvutt netwrok form
var newMessageForm;
function pop_create_message_form(url,u_mode){
    var stateObj = {foo: "bar"};
     if(navigator.appName!="Microsoft Internet Explorer"){
        history.pushState(stateObj, 'Message', '/messages?mode='+u_mode);
     }
    newMessageForm = dhtmlmodal.open("Message Network","iframe",url," ", "width=920px,height=2100px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}

//actuvutt netwrok form
function pop_reply_message_form(url,u_mode){
    var stateObj = {foo: "bar"};
     if(navigator.appName!="Microsoft Internet Explorer"){
        history.pushState(stateObj, 'Message', '/messages?mode='+u_mode);
     }    newMessageForm = dhtmlmodal.open("Message Network","iframe",url," ", "width=920px,height=2100px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}


//post message for network
var newMessageForm;
function post_message_form(url,u_mode,users){
    var stateObj = {foo: "bar"};
     if(navigator.appName!="Microsoft Internet Explorer"){
        history.pushState(stateObj, 'Message', '/messages?mode='+u_mode);
     }
    newMessageForm = dhtmlmodal.open("Message Network","iframe",url," ", "width=920px,height=2100px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}

//Message delete
function message_delete()
{
    var ids = $("#actid_chk").val();
    var myarray=new Array();
    myarray = ids.split(",");
    var msglnt= (myarray.length)
    //if (ids!=''){
        if (ids!=''){
        //if (msglnt!=0){
        if(msglnt==2) {
            $('#del_msg').html("Would you like to delete this message?");
        }
        else{
             $('#del_msg').html("Would you like to delete these messages?");
        }
        $('html, body', window.parent.document).animate({
            scrollTop:0
        }, 'slow');
        $('#message_delete_alert').bPopup({
            fadeSpeed:100,
            followSpeed:100,
            modalClose: false
        });
    }
    else{
        $('html, body', window.parent.document).animate({
            scrollTop:0
        }, 'slow');
        $('#message_before_delete_alert').bPopup({
            fadeSpeed:100,
            followSpeed:100,
            modalClose: false
        });
    }
}



//Thread delete
function messagethread_delete(thrd_id)
{
    $('html, body', window.parent.document).animate({
        scrollTop:0
    }, 'slow');
    $('#messagethread_delete_alert').bPopup({
        fadeSpeed:100,
        followSpeed:100,
        modalClose: false
    });
    $("#thrd_delete_id").val(thrd_id);
}



//Message Reply and To field to be shown only for active thread
function displayReplyMenus(thrd_id){
$('.to_display').css("display","none");
$('.reply_menu_style').css("display","none");
$("#to_display_"+thrd_id).css("display","block");
$("#reply_menu_"+thrd_id).css("display","block");
}

//Forward MessageDelete
function delMessFile(m_id){
var file_ids = $("#forw_mess_delete").val();
var final_ids;
final_ids = file_ids+','+m_id;
 $("#forw_mess_delete").val(final_ids);
$("#fwd_msg_"+m_id).remove();
}

