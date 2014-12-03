function ticket_filter_state(category,idinc)
{

    $.get("/tickets/ticket_update",{
        "city":category,
        "cat_zc":"city"
    }, null, "script");
    $("#city_value").html(category);
    $('#event_index_container .headerPart1 ul.dropdown ul').css('visibility','hidden');
    $('#event_index_container .headerPart1 ul.dropdown ul .description span').addClass('off');
    $('#event_index_container .headerPart1 ul.dropdown ul .description span#st_'+idinc).removeClass('off');
    $('#event_index_container .headerPart1 ul.dropdown ul .description span#st_'+idinc).addClass('on');
}


function filter_parent_state(state){
    window.location.href = "event/event_index_update?cat_zc=city&city="+state;
}

function filter_parent_update_state(state){
    window.location.href = "/event/event_index_update?cat_zc=city&city="+state;
}


function filter_provider_update_state(state){
    window.location.href = "provider_activites?cat_zc=city&city="+state;
}

function filter_by_zip_code(){
    var zip_code = document.getElementById("zp").value;
    $.get("/ticket/ticket_update",{
        "zip_code":zip_code,
        "cat_zc":"zip"
    }, null, "script");
}

function filter_state_user(category)
{
    window.location.href = category
//    $.get("/event/event_index_update",{
//        "city":category,
//        "cat_zc":"city"
//    }, null, "script");
}

function filter_userby_zip_code(){
    var zip_code = document.getElementById("zpu").value;
    window.location.href ="/ticket/ticket_update?cat_zc=zip&zip_code="+zip_code;
//    alert(zip_code);
//    $.get("/event/event_index_update",{
//        "zip_code":zip_code,
//        "cat_zc":"zip"
//    }, null, "script");
}


function a_test(){
    var zip_code = document.getElementById("zpu").value;
    $.ajax({
        url: "ticket/ticket_update",
        type: 'GET',
        dataType: 'json',
        data: {
            cat_zc :'city',
            city:'New York'
        },
        complete: function(xhr, textStatus) {

        },
        success: function(data, textStatus, xhr) {
           
            $length = data.length;
            $('#makeMeScrollable').html("")
            $.each(data, function(i,image){
                var $newItems = $('<div id="field" style="width: 228px;float:left;"><div class="lt"><img src="/assets/event_index/top.png" width="229" height="13" alt="Field"  id="marginLeftMac" /></div><div class="center_bg_scroll" id="setHeightMac"><div align="center" class="setPaddingImg1" id="getid1"><a href="javascript:void(0)" title=""></a></div><div class="ImgbottomDiv" id="bottomDiv" ><div class="Title" style="width:205px;"><b></b></div><div style="float: left; width: 205px; padding-top: 4px;" class="description" style=" padding-top: 5px;"></div><div class="BottomContent"><a href="#" title="" id="ShowPop_purchase"><img src="/assets/event_index/plus_button.png" width="23" height="23" class="lt"/></a><div class="description lt" style="margin:3px 0 0 5px;">06/21,2p.m.</div><span class="SetStarImg"><img src="/assets/activity_detail_view/star_blue.png" width="11" height="11"></span><span class="SetStarImg1"><img src="/assets/activity_detail_view/star_blue.png" width="11" height="11"></span><span class="SetStarImg1"><img src="/assets/activity_detail_view/star_blue.png" width="11" height="11"></span><span class="SetStarImg1"><img src="/assets/activity_detail_view/star_gray.png" width="11" height="11"></span><span class="SetStarImg1"><img src="/assets/activity_detail_view/star_gray.png" width="11" height="11"></span><span class="SetStarImg1"><a href="javascript:void(0)" title=""><img src="/assets/event_index/chat_message_icon.png" width="23" height="23"></a></span></div><div class="ftSz12" style="width: 205px;"> Address</div><div class="clear"></div><div class="description" style=" padding-top: 9px; width:205px;"><%= share.address_1%>,<br> <%= share.address_2%></div><div class="description" style=" padding-top: 5px; width:205px;"><span class="ftSz12">Leader</span> <span>Ana Wilson</span></div><div class="description paddTop"><span class="ftSz12">Shared by</span> <span>John mchancy</span></div></div><div class="CommentDiv"><div class="SetBgColorDiv"><div class="setTopImg"><div class="lt"><img src="/assets/event_index/photo_register.png"></div><div class="lt ftSz12Photo" style="padding-top: 4px;">Abby Roundy</div><br><div class="clear"></div></div><div class="clear"></div><div class="description" id="desc" style="padding-bottom: 4px; .padding-top:4px;">Lorem ipsum dolor sit amet</div></div><div class="SetBgColorDiv" style="border-top:1px solid #E6EBEE;"><div class="setTopImg"><div class="lt"><img src="/assets/event_index/photo_register.png"></div><div class="lt ftSz12Photo" style="padding-top: 4px;">Abby Roundy</div><br><div class="clear"></div></div><div class="clear"></div><div class="description" id="desc" style="padding-bottom: 4px;">Lorem ipsum dolor sit amet</div></div></div></div><div><img src="/assets/event_index/box_bottom.png" alt="Field"  class="box_bottom_img" /></div></div>');
                $('#makeMeScrollable').append($newItems)
                
            });
            $("div#makeMeScrollable").smoothDivScroll({});

        },
        error: function(xhr, textStatus, errorThrown) {

        }
    });



}
