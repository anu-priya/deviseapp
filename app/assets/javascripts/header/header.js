/***********************************header****************************************************/
function getQuerystring(key, default_)
{
    if (default_==null) default_="";
    key = key.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
    var regex = new RegExp("[\\?&]"+key+"=([^&#]*)");
    var qs = regex.exec(window.location.href);
    if(qs == null)
        return default_;
    else
        return qs[1];
}
$(document).ready(function(){	
    //set value to change mode
    //menu over change image
    $(".jumpDiv").mousemove(function(event){
        var wh= $(window).height();
        var x=(wh*0.4);
        var y=wh-x;
		
        if(event.clientY>y){
            // $(".jumpDivMenu ul .sub-menu").css("margin-right","5px");
            $(".jumpDivMenu ul .sub-menu").css("margin-top","-161px");
            $(".jumpDivMenu ul .sub-menu").css("position","absolute");
        }
        else{
            $(".jumpDivMenu ul .sub-menu").css("margin-top","");
            $(".jumpDivMenu ul .sub-menu").css("position","relative");
        }
    });
	
    var browserWidth=$( window ).width();
    var browserHeight=$( window ).innerHeight ();
	
    $('#parent_page').css("height",(browserHeight-20)+"px");
    $('#parent_page').css("width",(browserWidth-2)+"px");
	
    $("#top_menu ul li").mouseover(function(){
        $("#menu_follow").attr('src','/assets/header/following_img_orange.png');
        $(".selectedCity23244").show();
    });
    //$("#top_menu ul li").mouseout(function(){
    //	$("#menu_follow").attr('src','/assets/header/following_img_blue.png');
    //})
    $("#top_menu_add ul li").mouseover(function(){
        $("#menu_add").attr('src','/assets/header/add_orange.png');
    });
    $("#top_menu_add ul li").mouseout(function(){
        $("#menu_add").attr('src','/assets/header/add_blue.png');
    });
    $("#top_menu_contact ul li").mouseover(function(){
        $("#menu_friend").attr('src','/assets/header/contact_img_orange.png');
    });
    $("#top_menu_contact ul li").mouseout(function(){
        $("#menu_friend").attr('src','/assets/header/contact_img_blue.png');
    });
    $("#top_menu_message ul li").mouseover(function(){ 
        $("#menu_message").attr('src','/assets/header/message_icon_over.png');
    });
    $("#top_menu_message ul li").mouseout(function(){
        $("#menu_message").attr('src','/assets/header/message_icon.png');
    });
   
    $("#top_menu_location ul li").mouseover(function(){
        $("#menu_location").attr('src','/assets/header/location_icon_over.png');
    });
    $("#top_menu_location ul li").mouseout(function(){
        $("#menu_location").attr('src','/assets/header/location_icon.png');
    });
});
function filter_land_zip_code(){	
    var zip_code = document.getElementById("zp").value;
    $("#zp").css("border","1px solid #CDE0E6");
    $(".zp_error").css("display","none");
    var errorFlag=false;
    if(zip_code == ""){
        $("#zp").css("border","1px solid #fc8989");
        $(".zp_error").html("Please enter value");
        $(".zp_error").css("display","block");
        errorFlag=true;
    }
    else if(isNaN(zip_code)){
        $("#zp").css("border","1px solid #fc8989");
        $(".zp_error").html("Please enter valid zip code");
        $(".zp_error").css("display","block");
        errorFlag=true;
    }
    if(errorFlag){
        return false;
    }
    else{
        $.ajax({
            url:'update_ses_date',
            type:"get",
            data: {
                "zip_code": zip_code
            },
            success:function(data){
            }
        });
    }
    return false;
}
//splash page open on click the logo
function landing_splash_popup(){
    if(window.sessionStorage==undefined)
    {
    }
    else{
        sessionStorage.setItem("mySplashPage", "firsttime");
    }
	
}
//basic search for provider
var t=$('#search_hidden').val();
if(t=="provider")
{
    document.onkeypress =  enter_key_press_for_search_provider; //calling the function while press the enter key...
}
else if(t=="provider_thumb")
{
    document.onkeypress =  enter_key_press_for_thumb_provider; //calling the function while press the enter key...
}
//this function called while click the enter button for search the data..
function enter_key_press_for_search_provider(evt) {
    var evt = (evt) ? evt : ((event) ? event : null);
    var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
    if ((evt.keyCode == 13)  &&  (node.id=="advace_search"))  {
        search_ajax_call_provider();
        return false;
    }
}

//this function called while click the enter button for search the data..
function enter_key_press_for_thumb_provider(evt) {
    var evt = (evt) ? evt : ((event) ? event : null);
    var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
    if ((evt.keyCode == 13)  &&  (node.id=="advace_search"))  {
        search_thumb_provider();
        return false;
    }
}

//basic search ajax call for thumb provider page
function search_thumb_provider()
{
    var advace_search = $("#advace_search").val();
    $(".top_search").css("border","1px solid #CDE0E6");
    var errorFlag = false;
    if(advace_search == "" || advace_search == "Search")
    {
        $(".top_search").css("border","1px solid #fc8989");
        var errorFlag = true;
    }
    if(errorFlag){
        return false;
    }
    else
    {
        var search_text= $("#advace_search").val()
        var user_id= $("#uid").val();
        $.get("/provider_basic_search",{
            "search_text": search_text,
            "user_id": user_id
        }, function(data){
            }, "script"
            );
    }
}

//basic search ajax call for event list page
function search_ajax_call_provider()
{
    var advace_search = $("#advace_search").val();
    $(".top_search").css("border","1px solid #CDE0E6");
    var errorFlag = false;
    if(advace_search == "" || advace_search == "Enter activity name...")
    {
        $(".top_search").css("border","1px solid #fc8989");
        var errorFlag = true;
    }
    if(errorFlag){
        return false;
    }
    else
    {
        $('.search_submenu').hide();
        var search_text= $("#advace_search").val()
        var user_id= $("#uid").val();
        $.get("/search_index",{
            "search_text": search_text,
            "user_id": user_id
        }, function(data){
            $('.search_submenu').hide();
        }, "script"
        );
    }
}
//folloe tab close
function close_follow_top(){
    $(".selectedCity23244").hide();
}
function show_follow_top(){
    $(".selectedCity23244").show();
}
/*******************************************end*****************************************************/
var newContactPage;
var inviteproviderPage;
var becomeproviderPage;
var popInviteSuccess;
var popSendMessagePage;
var popCreateMessagePage;
var gmailImportPage;
var contactlistPage;
var facebookImportPage;
var mailContactPage;
var mailContactPageEmpty;
var newContactPage;
var contactImportPage;
var activityFeedbackPage;
var add_form_builder;
//feedback form
function pop_feedback_form(url){
	
     /*SEO URL*/
  var stateObj = {
        foo: "bar"
    };
    if(navigator.appName=="Microsoft Internet Explorer")
    {
        window.location.hash='/';
    }
    else
    {
        history.replaceState(stateObj, "Feedback", url);
    }
	
    activityFeedbackPage = dhtmlmodal.open("Feedback","iframe",url," ", "width=910px,height=780px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}  
/********contact page popup ********/  
function pop_new_contact(url){
    /*SEO Optimization url for  New Contact start*/
    var stateObj = {
        foo: "bar"
    };
    myURL = document.location;
    if(navigator.appName=="Microsoft Internet Explorer")
    {
        window.location.hash='';
    }
    else
    {
        history.replaceState(stateObj, "New Contact", "/contact_users/new");
    }
    /*SEO Optimization ends*/
    newContactPage = dhtmlmodal.open("Event New Contact","iframe",url," ", "width=910px,height=510px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    $("#photo").val('');
    $("#contact_name").val('');
    $("#email_id").val('');
    $("#mobile_no").val('');
    $("#gender").val('Select');
    $("#field1").val(''); 
    selectAny('select');  
    return false;
}  
//contactImportPage
function pop_contact_import(url){
    contactImportPage = dhtmlmodal.open("Edit Activity","iframe",url," ", "width=1007px,height=700px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
//gmailImportPage
function pop_gmail_import(url){
    gmailImportPage = dhtmlmodal.open("Edit Activity","iframe",url," ", "width=1007px,height=900px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
//facebookImportPage
function pop_facebook_import(url){
    facebookImportPage = dhtmlmodal.open("Edit Activity","iframe",url," ", "width=1007px,height=900px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
//contactlistImportPage
function pop_contact_list(url){
    contactlistPage = dhtmlmodal.open("Edit Activity","iframe",url," ", "width=1007px,height=900px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
//contactSuccessPage
function pop_contact_success(url){
    contactSuccessPage = dhtmlmodal.open("Edit Activity","iframe",url," ", "width=910px,height=900px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
//send message  
function Pop_message_send(url){
    popSendMessagePage = dhtmlmodal.open("Delete Activity","iframe",url," ", "width=1007px,height=900px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
//invite success  
function Pop_invite_success(url)
{
    popInviteSuccess = dhtmlmodal.open("Delete Activity","iframe",url," ", "width=450px,height=600px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}

function pop_mail_contact(url){
    mailContactPage = dhtmlmodal.open("Event Delete Contact","iframe",url," ", "width=450px,height=286px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
 
    return false;
}
function pop_mail_contact_empty(url){
    mailContactPageEmpty = dhtmlmodal.open("Event Delete Contact","iframe",url," ", "width=450px,height=286px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
  
function pop_invite_friend_check(url){
    var check = url.split("?")[1].split("=")[1];
    contact_invite(check);
    $('#popup_friend').bPopup({
        fadeSpeed:100,
        followSpeed:100,
        opacity:0.8,
        positionStyle: 'absolute',
        modalClose: false,
        onOpen: function() {
            $("#popup_friend").html('<div align ="center" style="position: fixed;top: 50%;left: 50%;display:block" id="invite_friend_loader_img"><img src="/assets/loading.gif" /></div>');
        } ,
        onClose: function() {
            $("#invite_friend_loader_img").css("display","block");
            $("#invite_friend_container").remove();
        },
        loadCallback: function(){
            $("#invite_friend_loader_img").css("display","none");
        },
        loadUrl:url
    },
    function() {
        setTimeout(function(){
            $("#invite_friend_loader_img").css("display","none");
            $('.b-ajax-wrapper').show();
        },5000)
    });
    window.scrollTo(0,0);
}
var newActivityPage;
var shareActivityPage;
var actDetailPage;
var addparticipantpage;
var editActivityPage;
var secureCheckoutPage;
var proceedCheckoutPage;
var contactproviderinfoPage;
var editactivitypage;
var FavoriteActivityPage;
var providerinfoPage;
var popInviteFriendPage
var PopTellUsPage;
var PopVidepPage;
var activityDeletePage;
var dicountDeletePage
var providerDetailPage;
var newActivitysuccessPage;
var registerStautsPage
var embedPage3;
var embedPage2;
var embedPage1;
var activitysheduleDeletePage;
var invitesuccessPage;
function bpopup_close()
{
    var stateObj = {
        foo: "bar"
    };
    myURL = document.location;
    if(navigator.appName=="Microsoft Internet Explorer")
    {
        window.location.hash='';
    }
    else
    {
        history.replaceState(stateObj, "Activity Details", "/");
    }
}
function pop_Activity_Detail(url){
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    $("#activity_detail_loader_img").css("display","block");
    var stateObj = {
        foo: "bar"
    };
    myURL = document.location;
    if(navigator.appName=="Microsoft Internet Explorer")
    {
        window.location.hash=url;
    }
    else
    {
        history.pushState(stateObj, "Activity Details", url);
    }
    $('#popup_container').bPopup({
        fadeSpeed:100,
        followSpeed:100,
        opacity:0.8,
        modalClose:false,
        positionStyle: 'absolute',
        onOpen: function() {
            $("#popup_container").html('<div align ="center" style="left:48%;top:30%;position:absolute;display:block" id="activity_detail_loader_img"><img src="/assets/loading.gif" /></div>')
        },
        onClose: function() {
            if(navigator.appName=="Microsoft Internet Explorer")
            {
                window.location.hash="/";
            }
            else
            {
                history.pushState(stateObj, "Activity Details", "/");
            }
            $("#activity_detail_loader_img").css("display","block");
        },
        loadCallback: function(){
            $("#activity_detail_loader_img").css("display","none");
        },
        loadUrl:url
    },
    function(){
        setTimeout(function(){
            $("#activity_detail_loader_img").css("display","none");
            $('.b-ajax-wrapper').show();
        //$('#popup_container').css({'position':'absolute'});
        },5000)
    });
}


function pop_fam_network_Detail_dhtml(url){
    var stateObj = {
        foo: "bar"
    };
    // myURL = document.location;
    // if(navigator.appName=="Microsoft Internet Explorer"){
    //     window.location.hash=ifrm;
    // }
    // else{
    //     history.pushState(stateObj, "Activity Details", ifrm);
    //  }
    famnetDetailPage = dhtmlmodal.open("famnetDetailPage","iframe",url,"", "width=970px,height=1125px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}



//iframe activity details page
function pop_Activity_Detail_dhtml(url,ifrm){
    var stateObj = {
        foo: "bar"
    };
    myURL = document.location;
    if(navigator.appName=="Microsoft Internet Explorer"){
        window.location.hash=ifrm;
    }
    else{
        history.pushState(stateObj, "Activity Details", ifrm);
    }
    actDetailPage = dhtmlmodal.open("Activity Details","iframe",url,"", "width=970px,height=1125px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}

//iframe for embed functionality
function pop_embed_Activity_Detail_dhtml(url,ifrm){
    var stateObj = {
        foo: "bar"
    };
    myURL = document.location;
    if(navigator.appName=="Microsoft Internet Explorer"){
        window.location.hash=ifrm;
    }
    else{
        history.pushState(stateObj, "Activity Details", ifrm);
    }
    actDetailPage = dhtmlmodal.open("Activity Details","iframe",url,"", "width=970px,height=1125px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}


function pop_provider_Detail_dhtml(url,show_url){
    var stateObj = {
        foo: "bar"
    };
    history.pushState(stateObj, "Provider Details", show_url);
    providerDetailPage = dhtmlmodal.open("Activity Details","iframe",url,"", "width=970px,height=1125px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}



function search_pop_Activity_Detail_dhtml(url){
 
    actDetailPage = dhtmlmodal.open("Activity Details","iframe",url,"", "width=970px,height=1125px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}

function pop_add_participant(url){
    addparticipantpage = dhtmlmodal.open("Add Participant","iframe",url,"", "width=910px,height=1600px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; border:1px solid red; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
function pop_secure_checkout(url){
    secureCheckoutPage = dhtmlmodal.open("Add Participant","iframe",url,"", "width=910px,height=570px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
}
function save_to_parent_index(activity_id,user_id){
    $.post("/activity_favorites/add_favorite", {
        "activity_id":activity_id,
        "user_id":user_id
    }, null, "json");
}
function pop_proceed_checkout(url){
    proceedCheckoutPage = dhtmlmodal.open("proceed_to_checkout","iframe",url," ", "width=910px,height=570px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    var body = document.body,
    html = document.documentElement;
    var height = Math.max( body.scrollHeight, body.offsetHeight,
        html.clientHeight, html.scrollHeight, html.offsetHeight );
    $(".drag-contentarea").css("height",height+"px");
    return false;
}
function pop_email_Detail(url){
    emailPage = dhtmlmodal.open("Activity Detail ","iframe",url,"", "width=910px,height=960px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    //set height for iframe div
    var body = document.body,
    html = document.documentElement;
    var height = Math.max( body.scrollHeight, body.offsetHeight,
        html.clientHeight, html.scrollHeight, html.offsetHeight );
    $(".drag-contentarea").css("height",height+"px");
    return false;
}
function pop_embed_Detail(url){
    embedPage1 = dhtmlmodal.open("Embed Activity ","iframe",url," ", "width=950px,height=850px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
//~ Pop Up for embed provider
function pop_provider_embed_Detail(url){
    embedPage2 = dhtmlmodal.open("Embed Activity ","iframe",url," ", "width=950px,height=1000px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
//~ Pop Up for Find us on Famtivity
function find_us_on_famtivity(url){
    /*SEO Optimization url for  find_us_on_famtivity start*/
    var stateObj = {
        foo: "bar"
    };
    if(navigator.appName=="Microsoft Internet Explorer")
    {
        window.location.hash='/';
    }
    else
    {
        history.replaceState(stateObj, "Find us on Famtivity", url);
    }
    /*SEO Optimization ends*/
	
    embedPage3 = dhtmlmodal.open("Find us on Famtivity","iframe",url," ", "width=950px,height=1000px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
function pop_provider_preview_embed_Detail(url){
    //alert(url);
    embedPage3 = dhtmlmodal.open("Embed Activity Preview  ","iframe",url," ", "width=930px,height=820px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
function pop_share_activity(url){
    //$("#Activity Details").css("z-index","100000");
    //$("#Activity Details").css("border","1px solid red");
    shareActivityPage = dhtmlmodal.open("Share Activity","iframe",url," ", "width=910px,height=800px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
function pop_new_activity(url){	
    newActivityPage = dhtmlmodal.open("Event New Activity","iframe",url," ", "width=1013px,height=1450px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px;background:none;' ", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    $(".dispProviderActivityDiv").hide();
    $('.actDivMenu ul li a:first').removeClass('selectedActDiv');
    return false;
}
function pop_success_activity(url){
    newActivitysuccessPage = dhtmlmodal.open("Event New Activity","iframe",url," ", "width=404px,height=164px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px;background:none;' ", "recal");
    $("html, body", window.parent.document).animate({
        scrollTop: 0
    }, 100);
    return false;
}
function pop_success_register(url){
    registerStautsPage = dhtmlmodal.open("Regiset Status","iframe",url," ", "width=800px,height=300px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px;background:none;' ", "recal");
    $("html, body", window.parent.document).animate({
        scrollTop: 0
    }, 100);
    return false;
}
function pop_success_activity_edit(url){	
    newActivitysuccessPage = dhtmlmodal.open("Event New Activity","iframe",url," ", "width=404px,height=220px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px;background:none;' ", "recal");
    $("html, body", window.parent.document).animate({
        scrollTop: 0
    }, 100);
    return false;
}
function pop_success_invite(url){ 
    invitesuccessPage = dhtmlmodal.open("Event New Activity","iframe",url," ", "width=450px,height=164px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px;background:none;' ", "recal");
    $("html, body", window.parent.document).animate({
        scrollTop: 0
    }, 100);
    return false;
}
function pop_share_activity_thank(url){
    shareActivityPagethank = dhtmlmodal.open("Share Activity","iframe",url," ", "width=910px,height=350px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
function pop_edit_activity(url){
    editActivityPage = dhtmlmodal.open("Edit Activity","iframe",url," ", "width=1013px,height=1050px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    //set height for iframe div
    var body = document.body,
    html = document.documentElement;
    var height = Math.max( body.scrollHeight, body.offsetHeight,
        html.clientHeight, html.scrollHeight, html.offsetHeight );
    
    $(".drag-contentarea").css("height",height+"px");
    return false;
}
function pop_favorite_activity(url){
    FavoriteActivityPage = dhtmlmodal.open("Edit Activity","iframe",url," ", "width=910px,height=300px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
function pop_provider_info(url){
    providerinfoPage = dhtmlmodal.open("Edit Activity","iframe",url," ", "width=910px,height=1050px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
// login and register popup
var LoginPage;
var parentLoginPage;
function pop_Parent_Login(url){
    var stateObj = {
        foo: "bar"
    };
    myURL = document.location;
    if(navigator.appName=="Microsoft Internet Explorer"){
        window.location.hash=url;
    }
    else{
        history.pushState(stateObj, "Login", url);
    }
    parentLoginPage = dhtmlmodal.open("Activity Detail ","iframe",url,"", "width=1085px,height=2000px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
function pop_Login(url){
    var stateObj = {
        foo: "bar"
    };
    myURL = document.location;
    if(navigator.appName=="Microsoft Internet Explorer"){
        window.location.hash=url;
    }
    else{
        history.pushState(stateObj, "Login", url);
    }
    $('#activity_new .popupContainer').css('z-index','9999');
    //~ LoginPage = dhtmlmodal.open("Activity Detail ","iframe",url,"", "width=570px,height=1000px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    //~ $("html, body").animate({
        //~ scrollTop: 0
    //~ }, 100);
    //~ return false;
      $('#login_popup').bPopup({
            content:'ajax', //'ajax', 'iframe' or 'image'
            contentContainer:'.contnt',
            loadUrl:url,//Uses jQuery.load()
	    modalClose: false,
	      afteropen: function() {
                $("#email_usr").focus();
		      alert(44444)
            }
        });
}


function fam_pop_network(url){
    var stateObj = {
        foo: "bar"
    };
    //myURL = document.location;
    //if(navigator.appName=="Microsoft Internet Explorer"){
    // window.location.hash=url;
    // }
    //else{
    //history.pushState(stateObj, "fam_group", url);
    // }
    $('#activity_new .popupContainer').css('z-index','9999');
    FamGroupPage = dhtmlmodal.open("Activity Detail ","iframe",url,"", "width=900px,height=1050px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}


//support form popup
function pop_support_form(url){
    activitySupportPage = dhtmlmodal.open("Delete Activity","iframe",url," ", "width=910px,height=1050px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
//invite provider popup
function pop_invite_provider(url){
    var pro = location.protocol;
    var stateObj = {
        foo: "bar"
    };

    myURL = pro+"//"+window.location.host+"/invite_provider?discount_dollar_provider";
    if(navigator.appName=="Microsoft Internet Explorer"){
        window.location.hash='/invite_provider?discount_dollar_provider';
    }
    else{
        history.pushState(stateObj, "Activity Details", myURL);
    }
    inviteproviderPage = dhtmlmodal.open("Edit Activity","iframe",url," ", "width=910px,height=1050px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
//Become a provider popup
function pop_become_provider(url){
    becomeproviderPage = dhtmlmodal.open("Edit Activity","iframe",url," ", "width=910px,height=1050px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
//contact provider popup
function pop_contact_provider_info(url){
    contactproviderinfoPage = dhtmlmodal.open("Contact Info","iframe",url," ", "width=910px,height=1050px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
//tell us yourself popup
function Pop_tellUs_page(url){
    PopTellUsPage = dhtmlmodal.open("Delete Activity","iframe",url," ", "width=910px,height=1050px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    //set height for iframe div
    var body = document.body,
    html = document.documentElement;
    var height = Math.max( body.scrollHeight, body.offsetHeight,
        html.clientHeight, html.scrollHeight, html.offsetHeight );
    $(".drag-contentarea").css("height",height+"px");
    return false;
}
function Pop_video(url){
    PopVidepPage = dhtmlmodal.open("Delete Activity","iframe",url," ", "width=1150px,height=750px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}

function pop_delete_activity(url){
    activityDeletePage = dhtmlmodal.open("Delete Activity","iframe",url," ", "width=650px,height=675px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
function pop_delete_dicount(url){
    dicountDeletePage = dhtmlmodal.open("Delete Activity","iframe",url," ", "width=650px,height=675px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
/*function pop_shedule_delete_activity(url){
    activitysheduleDeletePage = dhtmlmodal.open("Delete Activity","iframe",url," ", "width=650px,height=630px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}*/
function filter_parent_update_state(state,id,action){
    $.ajax({
        url:'update_ses_date',
        type:"get",
        data: {
            "state": state,
            "page_a":action
        },
        success:function(data){
        }
    });
}  
function filter_land_zip_code(){
    var zip_code = document.getElementById("zp").value;
    $("#zp").css("border","1px solid #CDE0E6");
    $(".zp_error").css("display","none");
    var errorFlag=false;
    if(zip_code == ""){
        $("#zp").css("border","1px solid #fc8989");
        $(".zp_error").html("Please enter value");
        $(".zp_error").css("display","block");
        errorFlag=true;
    }
    else if(isNaN(zip_code)){
        $("#zp").css("border","1px solid #fc8989");
        $(".zp_error").html("Please enter valid zip code");
        $(".zp_error").css("display","block");
        errorFlag=true;
    }
    if(errorFlag){
        return false;
    }
    else{
        $.ajax({
            url:'update_ses_date',
            type:"get",
            data: {
                "zip_code": zip_code
            },
            success:function(data){
            }
        });
    }
    return false;
}
function showwindow(page){
    //var width=700;var height=550; //var left=(screen.width/2)-(width/2);var top=(screen.height/2)-(height/2);window.open(page,"Flyer","scrollbars=1,top=1,left="+left+",height="+height+",width="+width);
    var width=600;
    var height=550;

    if (navigator.appName == 'Microsoft Internet Explorer')
    {
        myWindow=window.open(page,"Survey Monkey","scrollbars=1,top=1,height=500,width=500,fullscreen=yes,resizable=yes");
        myWindow.moveto('50','50');
    }else{
        myWindow=window.open(page,"Survey Monkey","scrollbars=1,top=1,height=500,width=500,fullscreen=yes,resizable=yes");
        myWindow.moveto('50','50');
    }
}   
var t=$('#search_hidden').val();
if(t=="parent")
{
    document.onkeypress =  enter_key_press_for_search; //calling the function while press the enter key...
}
else if(t=="provider_thumb")
{
    document.onkeypress =  enter_key_press_for_thumb_provider; //calling the function while press the enter key for provider thumb list page
} 
else
{
    document.onkeypress =  enter_key_press_for_search_provider; //calling the function while press the enter key...
} 
//advanced search submit form
function submit_form()
{
    document.forms['advanced_search_form'].submit() ;
} 
function detailedView(user_type){
    $("#"+user_type).show();
}

function detailedClose(user_type){
    $("#"+user_type).hide();
}
function close_follow(){
    $('#menu ul.sub-menu').css("display","none");
    $('.actDivMenu ul li a:first').removeClass('selectedActDiv');
    $("#follw_image").attr("src","/assets/landing/following_img_blue.png");
}
function open_follow(){
    $('#menu ul.sub-menu').css("display","block");
    $('.actDivMenu ul li a:first').addClass('selectedActDiv');
    $("#follw_image").attr("src","/assets/landing/following_img_orange.png");
}  
function showAct(){
    $('.actDivMenu ul li a:first').addClass('selectedActDiv');
}
function show_location(){
    $('ul.dropdown li a:first').addClass("hoverDiv");
    $('ul.dropdown li a:first').addClass("hover");
    $('.dropdown li a:first').css("border","1px solid #b1d7e3");
}
function hide_location(){
    $('ul.dropdown li a:first').removeClass("hoverDiv");
    $('ul.dropdown li a:first').removeClass("hover");
}  
function jumpto(act){
    var offset = $('#'+act).offset();
    var xPos = offset.left;
    var yPos = (offset.top)-80;
    window.scrollTo(xPos, yPos);
}
function show_pop_up(exdays){
    var exdate=new Date();
    exdate.setDate(exdate.getDate() + exdays);
    var c_value=escape(1) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
    document.cookie="show_again=" + c_value;
    if(window.sessionStorage==undefined)
    {
    }
    else{
        sessionStorage.setItem("mySplashPage", "opened");
    }
}
function filter_state(category,idinc)
{
    $.get("/event/activity_update",{
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
function filter_provider_update_state(state){
    window.location.href = "provider_activites?cat_zc=city&city="+state;
}
function filter_by_zip_code(){
    var zip_code = document.getElementById("zp").value;
    $.get("/event/activity_update",{
        "zip_code":zip_code,
        "cat_zc":"zip"
    }, null, "script");
}
function filter_state_user(category)
{
    window.location.href = category
}

function filter_userby_zip_code(){
    var zip_code = document.getElementById("zpu").value;
    window.location.href ="/event/event_index_update?cat_zc=zip&zip_code="+zip_code;
}
function a_test(){
    var zip_code = document.getElementById("zpu").value;
    $.ajax({
        url: "event/activity_update",
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
function parent_row(testVal,in_val){
    if($("#subCat_"+testVal+" input").is(":checked")){
        $(".add_favorite").css("display","block");
        parent_item = $("#subCat_"+testVal+" input").val();
        parent_add_fav.push(parent_item);
        $('#parentadd_val').val(parent_add_fav);

        var index = parent_remove_fav.indexOf(parent_item);
        if (index != -1){
            parent_remove_fav.splice(index, 1);
            $('#parentremove_val').val(parent_remove_fav);
        }
    }
    else{
        var remove_item = $("#subCat_"+testVal+" input").val();
        var index = parent_add_fav.indexOf(remove_item);
        parent_add_fav.splice(index, 1);
        $('#parentadd_val').val(parent_add_fav);
        if (parent_remove_fav.indexOf(remove_item) == -1){
            parent_remove_fav.push(remove_item);
            $('#parentremove_val').val(parent_remove_fav);
        }
    }
}


function modifyText_fam_ev(testVal,in_val){
    if($("#subCat_"+testVal+" input").is(":checked")){
        $(".add_favorite").css("display","block");
        fam_net_item = $("#subCat_"+testVal+" input").val();
        fam_net_add_fav.push(fam_net_item);
        $('#fam_net_val').val(fam_net_add_fav);

        var index = fam_net_remove_fav.indexOf(fam_net_item);
        if (index != -1){
            fam_net_remove_fav.splice(index, 1);
            $('#rem_fam_net_val').val(fam_net_remove_fav);
        }
    }
    else{
        var remove_item = $("#subCat_"+testVal+" input").val();
        var index = fam_net_add_fav.indexOf(remove_item);
        fam_net_add_fav.splice(index, 1);
        $('#fam_net_val').val(fam_net_add_fav);
        if (fam_net_remove_fav.indexOf(remove_item) == -1){
            fam_net_remove_fav.push(remove_item);
            $('#rem_fam_net_val').val(fam_net_remove_fav);
        }
    }
}

function provider_row(testVal,in_val){
    if($("#subCat_"+testVal+" input").is(":checked")){
        $(".add_favorite").css("display","block");
        provider_item = $("#subCat_"+testVal+" input").val();
        provider_add_fav.push(provider_item);
        $('#provideradd_val').val(provider_add_fav);
        var index = provider_remove_fav.indexOf(provider_item);
        if (index != -1){
            provider_remove_fav.splice(index, 1);
            $('#providerremove_val').val(provider_remove_fav);
        }
    }
    else{
        var remove_item = $("#subCat_"+testVal+" input").val();
        var index = provider_add_fav.indexOf(remove_item);
        provider_add_fav.splice(index, 1);
        $('#provideradd_val').val(provider_add_fav);
        if (provider_remove_fav.indexOf(remove_item) == -1){
            provider_remove_fav.push(remove_item);
            $('#providerremove_val').val(provider_remove_fav);
        }
    }
}
function provider_row_cat(testVal,in_val){
    if($("#subCat_"+testVal+" input").is(":checked")){
        $(".add_favorite").css("display","block");
        provider_item = $("#subCat_"+testVal+" input").val();
        provider_add_fav.push(provider_item);
        $('#providercatadd_val').val(provider_add_fav);
        var index = provider_remove_fav.indexOf(provider_item);
        if (index != -1){
            provider_remove_fav.splice(index, 1);
            $('#providercatremove_val').val(provider_remove_fav);
        }
    }
    else{
        var remove_item = $("#subCat_"+testVal+" input").val();
        var index = provider_add_fav.indexOf(remove_item);
        provider_add_fav.splice(index, 1);
        $('#providercatadd_val').val(provider_add_fav);
        if (provider_remove_fav.indexOf(remove_item) == -1){
            provider_remove_fav.push(remove_item);
            $('#providercatremove_val').val(provider_remove_fav);
        }
    }
}
function search_provider(user_type){
    if(user_type == "p"){
        var provider = $("#provider_search").val();
        $("#ProviderSearch").css("border","1px solid #CDE0E6");
        var errorFlag=false;
        if(provider == '' || provider=='Search Following')
        {
            $("#ProviderSearch").css("border","1px solid #fc8989");
            var errorFlag = true;
        }
    }else{
        var provider = $("#parent_search_user").val();
        $("#ParentSearch").css("border","1px solid #CDE0E6");
        var errorFlag=false;
        if(provider == '' || provider=='Search Following')
        {
            $("#ParentSearch").css("border","1px solid #fc8989");
            var errorFlag = true;
        }
    }
    if (provider !="" && provider !="Search Following"){
        $.ajax({
            url:'update_parent_provider',
            type:"get",
            data: {
                "user": provider,
                "user_type":user_type
            },
            success:function(data){
                $("#update_follow").html(data);
                if (user_type =='p'){
                    $("#provider_search").focus();
                    $("#provider_search").val(provider);
                    $("#ProviderSearch").css("border","1px solid #CDE0E6");
                    var errorFlag=false;
                    if(provider == '' || provider=='Search Following')
                    {
                        $("#ProviderSearch").css("border","1px solid #fc8989");
                        var errorFlag = true;
                    }
                    $("#ProviderSearch").css("color","#444444;");
                }else{
                    $("#parent_search_user").focus();
                    $("#parent_search_user").val(provider);
                    $("#parent_search_user").focus();
                    $("#ParentSearch").css("border","1px solid #CDE0E6");
                    var errorFlag=false;
                    if(provider == '' || provider=='Search Following')
                    {
                        $("#ParentSearch").css("border","1px solid #fc8989");
                        var errorFlag = true;
                    }
                    $("#parent_search_user").css("color","#444444;");
                }
                initARC('event_more','altCheckboxOn','altCheckboxOff');
            }
        });
    }
}     
function disp_parent(id,parent_type){
    if(parent_type =="Provider"){
        var pro_search=$('#pro_search_follow').val('p');
    }
    else if(parent_type =="Parent")
    {
        var par_search=$('#pro_search_follow').val('u');
    }
	
    //all
    $('.categoryCont a').removeClass("selectedCat");
    $('.categoryCont a').addClass("nselectedCat");
    // selected field
    $('.categoryCont a#type_'+id).removeClass("nselectedCat");
    $('.categoryCont a#type_'+id).addClass("selectedCat");
    $('#update_follow').html('<div align="center" style="margin:0 auto; margin-top:120px;"><img src="/assets/loading_small.gif" alt="Loading..."></div>');
    $.get('/activity_subcategories/get_follow_user?id=' + parent_type, function(data){
        $("#update_follow").html(data);
        initARC('event_more','altCheckboxOn','altCheckboxOff');
    });
	
}
function handleEnter(inField, e) {
    var charCode;
    if(e && e.which){
        charCode = e.which;
    }else if(window.event){
        e = window.event;
        charCode = e.keyCode;
    }
    if(charCode == 13) {
        var s_value =$('#pro_search_follow').val();
        search_provider(s_value);
        return false;
    }
    return false;
}
//this function called while click the enter button for search the data..
function enter_key_press_for_search(evt) {
    var evt = (evt) ? evt : ((event) ? event : null);
    var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
    if ((evt.keyCode == 13)  &&  (node.id=="advace_search"))  {
        search_ajax_call();
        //clearAutoCompleteInput();
        return false;
    }
}
//calling for basic search while enter the text in search box.
function search_ajax_call()
{
    var advace_search = $("#advace_search").val();
    $(".ad_textbox").css("border","1px solid #CDE0E6");
    var errorFlag = false;
    if(advace_search == "" || advace_search == "Search")
    {
        $(".ad_textbox").css("border","1px solid #fc8989");
        var errorFlag = true;
    }
    if(errorFlag){
        return false;
    }
    else{
        var event_search= $("#advace_search").val();
        //window.location.href ="/search_event_index?event_search="+event_search;
        window.location.href ="/search?event_search="+event_search;
        return true;
    }
}  
/*event and provider activities search*/  
     
//clear autocomplete input..
function clearAutoCompleteInput() {
    $("#advace_search").val('');
}      
$(document).ready(function(){
    var curTime=new Date();
    var date = curTime.getDate();
    var month = curTime.getMonth();
    var year = curTime.getFullYear();	
    var monthName = getMonthVal(month);
    $('#month').html(monthName);
    $('#date').html(date);
    $('#month_ad').html(monthName);
    $('#date_ad').html(date);
    
    /*******************follow button hover show****************************/
    //$('#menu_follow').attr('src','/assets/header/following_img_orange.png');
    $('.befor_login #top_menu ').mouseover(function(){
        $('#top_menu ul li ul').show();
        $('#top_menu ul li ul li').show();
    /*   $('#top_menu ul li').css({
            'border':'1px solid #a9d3e1',
            'background':'#e6f5f8'
        });
        $('#menu_follow').attr('src','/assets/header/following_img_orange.png');
        */            
    });
    $('.parent_header #top_menu ').mouseover(function(){
        $('#top_menu ul li ul').show();
        $('#top_menu ul li ul li').show();
        $('#top_menu ul li').css({
            'border':'1px solid #a9d3e1',
            'background':'#e6f5f8'
        });
        $('#menu_follow').attr('src','/assets/header/following_img_orange.png');
                   
    });
    
    /*.mouseout(function(){
      $('#menu_follow').attr('src','/assets/header/following_img_orange.png'); 
      });*/
    //    $('#top_menu ul li').mouseout(function(){
    //	 $('#menu_follow').attr('src','/assets/header/following_img_orange.png');
    //	});
    $('#top_menu_add').mouseover(function(){
        $('#top_menu ul li ul').hide();
        $('#top_menu ul li ul li').hide();
        $('#top_menu ul li').css({
            'border':'1px solid #DBEEF4',
            'background':'none'
        });
        $('#menu_follow').attr('src','/assets/header/following_img_blue.png');
    });
    $('#top_menu_location').mouseover(function(){
        $('#top_menu ul li ul').hide();
        $('#top_menu ul li ul li').hide();
        $('#top_menu ul li').css({
            'border':'1px solid #DBEEF4',
            'background':'none'
        });
        $('#menu_follow').attr('src','/assets/header/following_img_blue.png');
    });
    $('#top_menu_contact').mouseover(function(){
        $('#top_menu ul li ul').hide();
        $('#top_menu ul li ul li').hide();
        $('#top_menu ul li').css({
            'border':'1px solid #DBEEF4',
            'background':'none'
        });
        $('#menu_follow').attr('src','/assets/header/following_img_blue.png');
    });
    $('#top_menu_user').mouseover(function(){
        $('#top_menu ul li ul').hide();
        $('#top_menu ul li ul li').hide();
        $('#top_menu ul li').css({
            'border':'1px solid #DBEEF4',
            'background':'none'
        });
        $('#menu_follow').attr('src','/assets/header/following_img_blue.png');
    });
    $('.closeHover').click(function(){
        $('#top_menu ul li ul').hide();
        $('#top_menu ul li ul li').hide();
        $('#top_menu ul li').css({
            'border':'1px solid #DBEEF4',
            'background':'none'
        });
        $('#menu_follow').attr('src','/assets/header/following_img_blue.png');
    });
});
function changedAdSearchFormateDate(){
    var dateVal = $('#datepicker_ad').val();	
    var splitDateVal = dateVal.split('/');
    var month = splitDateVal[0];	
    var date = splitDateVal[1];
    var year = splitDateVal[2];	
    var formatedDate = year+"-"+month+"-"+date;
    var monthName = getMonthVal(month);	
    $('#datepicker_ad').val(formatedDate);	
    var monthName = getMonthValue(month);
    $('#month_ad').html(monthName);
    $('#date_ad').html(date);
    var formatedendDate = year_end+"-"+month_end+"-"+date_end;
    $('#datepicker_ad').val(formatedendDate);	
    $('#month_ad').html(monthName);
    $('#date_ad').html(date);
}
function selectAny(cname){	
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
        chk_len=$(".centerContainer .activityName input:checkbox").length;
        $("#actid_chk").val('');
        selected_ids="";
        //alert(chk_len);
        for(i=0; i<chk_len; i++)
        {
            chk_id=$(".centerContainer .activityName input:checkbox:eq("+i+")").attr('id');
            //alert(chk_id)
            chk_id_rep=chk_id.replace("pe","");
            if(i=="0")
            {
                selected_ids=","+chk_id_rep;
            }
            else
            {
                selected_ids=selected_ids+","+chk_id_rep;
            }
        }
        $("#actid_chk").val(selected_ids);
    }
}
function getMonthVal(month)
{
    var selected_month;
    switch(month){
        case 0:
            selected_month='Jan';
            break;
        case 1:
            selected_month='Feb';
            break;
        case 2:
            selected_month='Mar';
            break;
        case 3:
            selected_month='Apr';
            break;
        case 4:
            selected_month='May';
            break;
        case 5:
            selected_month='Jun';
            break;
        case 6:
            selected_month='Jul';
            break;
        case 7:
            selected_month='Aug';
            break;
        case 8:
            selected_month='Sep';
            break;
        case 9:
            selected_month='Oct';
            break;
        case 10:
            selected_month='Nov';
            break;
        case 11:
            selected_month='Dec';
            break; 	
    }
    return selected_month;
}
function getMonthValue(month)
{
    var selected_month;
    switch(month){
        case "01":
            selected_month='Jan';
            break;
        case "02":
            selected_month='Feb';
            break;
        case "03":
            selected_month='Mar';
            break;
        case "04":
            selected_month='Apr';
            break;
        case "05":
            selected_month='May';
            break;
        case "06":
            selected_month='Jun';
            break;
        case "07":
            selected_month='Jul';
            break;
        case "08":
            selected_month='Aug';
            break;
        case "09":
            selected_month='Sep';
            break;
        case "10":
            selected_month='Oct';
            break;
        case "11":
            selected_month='Nov';
            break;
        case "12":
            selected_month='Dec';
            break;
    }
    return selected_month;
}
/*******Jump to***********/
$(function(){
    $('.dispParentjumpDiv').hover(function (){
        var idx=$('.dispParentjumpDiv').index(this);
        $('.jumpDivMenu:eq('+idx+') ul li a:first').addClass('selectedJumpDiv');
        $('.jumpDiv:eq('+idx+')').css('border','1px solid #A9D3E1');
    }, function(){
        var idx=$('.dispParentjumpDiv').index(this);
        $('.jumpDivMenu:eq('+idx+') ul li a:first').removeClass('selectedJumpDiv');
        $('.jumpDiv:eq('+idx+')').css('border','1px solid #F7F9F8');
    });
});  
$(function(){
    $('.jumpDiv').hover(function (){	   
        var idx=$('.jumpDiv').index(this);
        $('.jumpDivMenu:eq('+idx+') ul li a:first').addClass('selectedJumpDiv');
        $('.jumpDiv:eq('+idx+')').css('border','1px solid #A9D3E1');
    }, function(){
        var idx=$('.jumpDiv').index(this);
        $('.jumpDivMenu:eq('+idx+') ul li a:first').removeClass('selectedJumpDiv');
        $('.jumpDiv:eq('+idx+')').css('border','1px solid #F7F9F8');
    });
});

function showLocationDiv(){
    $("#LocationMenu ul.sub-menu").css("display","block");
    $('.LocationDivMenu ul li a:first').addClass('selectedLocationDiv');
    $(".search_submenu").css("display","none");
    $('#menu ul.sub-menu').css("display","none");
    $('.actDivMenu ul li a:first').removeClass('selectedActDiv');
    $("#follw_image").attr("src","/assets/landing/following_img_blue.png");
}
function hideLocation(){
    $("#LocationMenu ul.sub-menu").css("display","none");
    $('.LocationDivMenu ul li a:first').removeClass('selectedLocationDiv');
}
$(function() {
    $('.eventListContainer').bind('mouseover', function () {
        $("#LocationMenu ul.sub-menu").css("display","none");
        $('.LocationDivMenu ul li a:first').removeClass('selectedLocationDiv');
    });
});
function changedTranctionDate(){
    var dateVal = $('#datepicker').val();
    var splitDateVal = dateVal.split('/');
    var month = splitDateVal[0];
    var date = splitDateVal[1];
    var year = splitDateVal[2];
    var formatedDate = year+"-"+month+"-"+date;
    var monthName = getMonthVal(month);
    $('#month').html(monthName);
    $('#date').html(date); 	
}	
function detectTab(e) {
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==9){
        document.getElementById("dropDownDiv").style.display="none";
    }
}
function tryitlinkKeyDown(e) {
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        window.location.href="event";
    }
}
function signinKeyDown(e) {
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        window.location.href="login";
    }
}
function registerKeyDown(e) {
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32){
        //window.location.href="/user_usrs";
        window.location.href="/users";
    }
}
function selectCityKeyDown(e){
    //alert("tert");
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13){    	
        document.getElementById("dropDownDiv").style.display="block";
        flag=false;
    }		
}
function selectRegUsrKeyDown(e){
    //alert("tert");
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13){    	
        document.getElementById("dropDownDiv").style.display="block";
        flag=false;
    }		
}

function doFormSubmit(action){
    document.getElementById("action_new_usr").value=action;
    document.landingForm.submit();
}
      
$(function() {
    $('.off').hover(function(){
        $(this).css('color', '#f58112');
    },
    function(){
        $(this).css('color', '#313332');
    });
});

function visible_color(id){
    $(this).css('color', '#f58112');
}

function acti_fav(){
    var favorite_list_string = $("#provider_val").val();
    var favorite_list = favorite_list_string

    for(k=1;k<=110;k++){
        favorite_item = $('#acc #d'+k).val();


        if (favorite_list.indexOf(favorite_item) != -1){
            $('#d'+k).attr('checked', true);
            $('.d'+k+'_customizeCheckbox label').addClass('altCheckboxOn');
            $('.d'+k+'_customizeCheckbox label').removeClass('altCheckboxOff');

            $(".add_favorite").css("display","block");
        }
    }
}

function show_favour(){
    $('#GotoFavour').css("display","block");
    $('#GotoFeatured').css("display","none");
    $('#GotoShared').css("display","none");
    $('.free_list').css("display","none");

}
function show_featured(){
    $('#GotoFavour').css("display","none");
    $('#GotoFeatured').css("display","block");
    $('#GotoShared').css("display","none");
    $('.free_list').css("display","none");

}
function show_shared(){
    $('#GotoShared').css("display","block");
    $('#GotoFavour').css("display","none");
    $('#GotoFeatured').css("display","none");
    $('.free_list').css("display","none");
}
function show_free(){
    $('.free_list').css("display","block");
    $('#GotoFavour').css("display","none");
    $('#GotoFeatured').css("display","none");
    $('#GotoShared').css("display","none");
}
function follow_user(testVal,in_val){
    if($("#subCat_"+testVal+" input").is(":checked")){
        /*$("#subCat_"+testVal+" input").attr('checked', false);
      $("#subCat_"+testVal+" label").addClass('altCheckboxOff');
      $("#subCat_"+testVal+" label").removeClass('altCheckboxOn');*/
        $(".add_favorite").css("display","block");

        follow_item = $("#subCat_"+testVal+" input").val();
        follow_add_fav.push(follow_item);
        $('#followadd_val').val(follow_add_fav);
        var index = follow_remove_fav.indexOf(follow_item);
        if (index != -1){
            follow_remove_fav.splice(index, 1);
            $('#followremove_val').val(follow_remove_fav);
        }
    }
    else{
        var remove_item = $("#subCat_"+testVal+" input").val();
        var index = follow_add_fav.indexOf(remove_item);
        follow_add_fav.splice(index, 1);
        $('#followadd_val').val(follow_add_fav);
        if (follow_remove_fav.indexOf(remove_item) == -1){
            follow_remove_fav.push(remove_item);
            $('#followremove_val').val(follow_remove_fav);
        }
    }
}


function following_you_user(testVal){
    if($("#subCatyou_"+testVal+" input").is(":checked")){
        /*$("#subCat_"+testVal+" input").attr('checked', false);
      $("#subCat_"+testVal+" label").addClass('altCheckboxOff');
      $("#subCat_"+testVal+" label").removeClass('altCheckboxOn');*/
        $(".add_favorite").css("display","block");

        followuser_item = $("#subCatyou_"+testVal+" input").val();
        followuser_add_fav.push(followuser_item);
        $('#followuseradd_val').val(followuser_add_fav);
        var index = followuser_remove_fav.indexOf(followuser_item);
        if (index != -1){
            followuser_remove_fav.splice(index, 1);
            $('#followuserremove_val').val(followuser_remove_fav);
        }
    }
    else{
        var remove_item = $("#subCatyou_"+testVal+" input").val();
        var index = followuser_add_fav.indexOf(remove_item);
        followuser_add_fav.splice(index, 1);
        $('#followuseradd_val').val(followuser_add_fav);
        if (followuser_remove_fav.indexOf(remove_item) == -1){
            followuser_remove_fav.push(remove_item);
            $('#followuserremove_val').val(followuser_remove_fav);
        }
    }
}

function provider_row(testVal,in_val){
    if($("#subCat_"+testVal+" input").is(":checked")){
        /*$("#subCat_"+testVal+" input").attr('checked', false);
      $("#subCat_"+testVal+" label").addClass('altCheckboxOff');
      $("#subCat_"+testVal+" label").removeClass('altCheckboxOn');*/
        $(".add_favorite").css("display","block");

        provider_item = $("#subCat_"+testVal+" input").val();
        provider_add_fav.push(provider_item);
        $('#provideradd_val').val(provider_add_fav);
        var index = provider_remove_fav.indexOf(provider_item);
        if (index != -1){
            provider_remove_fav.splice(index, 1);
            $('#providerremove_val').val(provider_remove_fav);
        }
    }
    else{
        var remove_item = $("#subCat_"+testVal+" input").val();
        var index = provider_add_fav.indexOf(remove_item);
        provider_add_fav.splice(index, 1);
        $('#provideradd_val').val(provider_add_fav);
        if (provider_remove_fav.indexOf(remove_item) == -1){
            provider_remove_fav.push(remove_item);
            $('#providerremove_val').val(provider_remove_fav);
        }
    }
}
 
var startVal=1;
var endVal=17;

function close_pop_social(id){
    for(var i=startVal;i<endVal;i++){
        if(i==id){
            $("#show_"+i).css("display","none");
        }
    }
}


function show_fb_count(value){
    var startVal=1;
    var endVal=17;
    if(value)
    {
        for(var i=startVal;i<endVal;i++)
        {
            if(i==value){
                $("#show_"+i).css("display","block");
            }

            else{
                $("#show_"+i).css("display","none");
            }
        }
    }
    else{
        alert("false");
    }
}
$(function(){
    $('.dispActiveDiv li a').hover(function (){
        $(this).parent().parent().parent("li").children('a:first').addClass('selectedGenderDiv');
    }, function(){
        $(this).parent().parent().parent("li").children('a:first').removeClass('selectedGenderDiv');
    });
});
function setActiveVal(gvalue,inc,rep_present,rep_iid){
    $('#gender_'+inc).val(gvalue);
    $('#gender_setVal_'+inc).html(gvalue);
    //~ if (rep_present=='true' && rep_iid!=0)
    //~ {
    //~ $("#edit-del-permission_"+act_id).replaceWith('<div class="lt" style="width:130px;" id="edit-del-permission_'+act_id+'" align="center"><img  src="/assets/loading_small.gif" /></div>');
    //~ }
    $.post("update_active_status", {
        id: inc,
        school_r_present: rep_present,
        school_r_id: rep_iid,
        status: gvalue
    }, null, "script");
}

function setdiscountVal(gvalue,inc){
    $.post("update_discount_active_status", {
        id: inc,
        status: gvalue
    }, null, "script");
    return false;
}



function setFormVal(fvalue,inc){
    $('#gender_'+inc).val(gvalue);
    $('#gender_setVal_'+inc).html(gvalue);
    $.post("update_active_status", {
        id: inc,
        status: gvalue
    }, null, "script");
}
$(function(){
    $('.dispProviderActivityDiv li a').hover(function (){
        $('.actDivMenu ul li a:first').addClass('selectedActDiv');
    }, function(){
        $('.actDivMenu ul li a:first').removeClass('selectedActDiv');
    });
});
$(function(){
    $('.dispProviderActionDiv li a').hover(function (){
        $('.actionDivMenu ul li a:first').addClass('selectedActionDiv');
    }, function(){
        $('.actionDivMenu ul li a:first').removeClass('selectedActionDiv');
    });
});
$(function(){
    $('.dispProviderCatDiv').hover(function (){
        $('.catDivMenu ul li a').addClass('selectedCatDiv');
    }, function(){
        $('.catDivMenu ul li a').removeClass('selectedCatDiv');
    });
});
$(function(){
    $('.dispviewDiv li a').hover(function (){
        $('.viewDivMenu ul li a:first').addClass('selectedviewDiv');
    }, function(){
        $('.viewDivMenu ul li a:first').removeClass('selectedviewDiv');
    });
});
$(function(){
    $('#providers').hover(function (){
        $('.actDivMenu ul li a:first').addClass('selectedActDiv');
    }, function(){
        $('.actDivMenu ul li a:first').removeClass('selectedActDiv');
    //$(".dispProviderActivityDiv").css('display','none');
    });
});
$(function(){
    $('#provideract').hover(function (){
        $('#provideract li a:first').addClass('selectedActDiv');
    }, function(){
        $('provideract li a:first').removeClass('selectedActDiv');
    // $(".dispProviderCatDiv").css('display','none');
    });
});
$(function(){
    $('#activity').hover(function (){
        $(".dispProviderActivityDiv").css('display','block');
    }, function(){
        $(".dispProviderActivityDiv").css('display','none');
    });
});
/*Status sub menu*/ 
$(function(){
    $('.by_status').hover(function (){
        $("#status").css('display','block');
        $(".dispProviderActivityDiv").css('display','block');
    });
});
$(function(){
    $('#status').hover(function (){
        $('.actDivMenu ul li a:first').addClass('selectedActDiv');
    }, function(){
        $('.actDivMenu ul li a:first').removeClass('selectedActDiv');
        $(".dispProviderActivityDiv").css('display','none');
    });
});
function activity_admin(ad_val){
    var view = $("#view_det").val();
    if(ad_val == "activity"){
        $("#filter_admin_date").css('display','none');
        $("#filter_admin_date1").css('display','none');
        $("#filter_admin_category").css('display','none');
        $("#filter_by_provider").css('display','none');
        $("#filter_by_curator").css('display','none');
        $("#filter_by_provider_card_filter").css('display','none');
        $.get("admin/index_update",{
            "view":view,
            "cat_zc":"index"
        }, null, "script");
        $("#setActivity").html('All Activity');
        $(".actDiv").css('width','85px');
        $("#activity").css('width','90px');
    }
    if(ad_val == "approve"){
        $("#filter_admin_date").css('display','none');
        $("#filter_admin_date1").css('display','none');
        $("#filter_admin_category").css('display','none');
        $("#filter_by_provider").css('display','none');
        $("#filter_by_curator").css('display','none');
        $("#filter_by_provider_card_filter").css('display','inline-block');
        $.get("admin/provider_curator",{
            "view":view,
            "cat_zc":"index"
        }, null, "script");
        $("#setActivity").html('Provider Card');
        $(".actDiv").css('width','110px');
        $("#activity").css('width','90px');
    }


    if(ad_val == "next_7_days"){
        $.get("admin/index_update",{
            "view":view,
            "cat_zc":"next_7_days"
        }, null, "script");
        $("#setActivity").html('Next 7 days');
        $(".actDiv").css('width','115px');
        $("#filter_admin_category").css('display','none');
        $("#filter_admin_date").css('display','none');
        $("#filter_admin_date1").css('display','none');
        $("#filter_by_provider").css('display','none');
        $("#filter_by_curator").css('display','none');
        $("#filter_by_provider_card_filter").css('display','none');
    }
    if(ad_val == "approved"){
        $.get("admin/index_update",{
            "view":view,
            "cat_zc":"approved"
        }, null, "script");
        $("#setActivity").html('Approved');
        $(".actDiv").css('width','115px');
        $("#filter_admin_category").css('display','none');
        $("#filter_admin_date").css('display','none');
        $("#filter_admin_date1").css('display','none');
        $("#filter_by_provider").css('display','none');
        $("#filter_by_curator").css('display','none');
        $("#filter_by_provider_card_filter").css('display','none');
    }
    if(ad_val == "unapproved"){
        $.get("admin/index_update",{
            "view":view,
            "cat_zc":"unapproved"
        }, null, "script");
        $("#setActivity").html('Unapproved');
        $(".actDiv").css('width','115px');
        $("#filter_admin_category").css('display','none');
        $("#filter_admin_date").css('display','none');
        $("#filter_admin_date1").css('display','none');
        $("#filter_by_provider").css('display','none');
        $("#filter_by_curator").css('display','none');
    }

    if(ad_val == "created_date"){
        $("#setActivity").html('By Created Date');
        $(".actDiv").css('width','125px');
        $("#filter_admin_category").css('display','none');
        $("#filter_admin_date").css('display','none');
        $("#filter_admin_date1").css('display','inline-block');
        $("#filter_by_provider").css('display','none');
        $("#filter_by_curator").css('display','none');
        $("#filter_by_provider_card_filter").css('display','none');
    }
    if(ad_val == "category"){
        $("#setActivity").html('By Category');
        $("#filter_admin_date1").css('display','none');
        $("#filter_admin_date").css('display','none');
        $("#filter_admin_category").css('display','inline-block');
        $("#filter_by_provider").css('display','none');
        $("#filter_by_curator").css('display','none');
        $("#filter_by_provider_card_filter").css('display','none');
        $(".actDiv").css('width','95px');
        $("#activity").css('width','100px');
    }
    if(ad_val == "date"){
        $("#setActivity").html('By Date');
        $("#filter_admin_category").css('display','none');
        $("#filter_admin_date").css('display','inline-block');
        $("#filter_admin_date1").css('display','none');
        $("#filter_by_provider").css('display','none');
        $("#filter_by_curator").css('display','none');
        $("#filter_by_provider_card_filter").css('display','none');
        $(".actDiv").css('width','65px');
        $("#activity").css('width','70px');
    }
    if(ad_val == "by_provider"){
        $("#setActivity").html('By Provider');
        $("#filter_admin_date").css('display','none');
        $("#filter_admin_date1").css('display','none');
        $("#filter_admin_category").css('display','none');
        $("#filter_by_curator").css('display','none');
        $("#filter_by_provider").css('display','block');
        $("#filter_by_provider_card_filter").css('display','none');
        $(".actDiv").css('width','95px');
        $("#activity").css('width','100px');
    }
    if(ad_val == "by_curator"){
        $("#setActivity").html('By Curator');
        $("#filter_admin_date").css('display','none');
        $("#filter_admin_date1").css('display','none');
        $("#filter_admin_category").css('display','none');
        $("#filter_by_provider").css('display','none');
        $("#filter_by_curator").css('display','block');
        $("#filter_by_provider_card_filter").css('display','none');
        $(".actDiv").css('width','95px');
        $("#activity").css('width','100px');
    }
}

function activity_provider_card(){
    var view = $("#view_det").val();
    var show_c = $("#provider_card_view").val();
    $.get("admin/provider_curator",{
        "view":view,
        "show":show_c
    }, null, "script");
}

function activity_provider(){
    if ($("#filter_by_provider").is(':visible'))
    {
        var user_id = $("#provider_list_view").val();
    }
    else if($("#filter_by_curator").is(':visible'))
    {
        var user_id = $("#curator_list_view").val();
    }
    var view = $("#view_det").val();
    $.get("admin/index_update",{
        "view":view,
        "cat":user_id,
        "cat_zc":"provider"
    }, null, "script");
}
//onclick function for report filter
function trans_activityname(){
    if ($("#byActivityDiv").is(':visible'))
    {
        var trans_actname = $("#trans_list_view").val();
    }
    $.get("/transaction",{
        "act_name":trans_actname,
        "trans_act":"activity"
    }, null, "script");
}

//onclick function for report filter 
function admin_trans_reprt(pro){
    $.get("/admin_transaction",{
        "report_trans":pro
    }, null, "script");
}
 
function activity_transaction(ad_val){
    if(ad_val == "activity"){
        $("#setActivity").html('By Activity');
        $("#filter_admin_date").css('display','none');
        $("#byActivityDiv").css('display','inline-block');
        $("#trans_list_view").val('-- Select Activity Name--');
        $("#activity_stat").css("width","95px");
        trans_activityname();
    }
    if(ad_val == "date"){
        $("#setActivity").html('By Date');
        $("#filter_admin_date").css('display','inline-block');
        $("#byActivityDiv").css('display','none');
        $("#activity_stat").css("width","95px");
    }
    if(ad_val == "by_date"){
        $("#setActivity").html('Date');
        $("#filter_admin_date").css('display','inline-block');
        $("#byActivityDiv").css('display','none');
        $("#activity_stat").css("width","95px");
    }
    if(ad_val =="activity_stats"){
        $("#setActivity").html('By Activity Stats');
        $("#filter_admin_date").css('display','none');
        $("#byActivityDiv").css('display','none');
        $("#activity_stat").css("width","145px");
        //displayed provider activity stats by rajkumar
        $.get("/transaction",{
            "activity_stats":"activity_stats"
        }, null, "script");
    }
}


//invite page
function show_contact(id){
    $("#toemailaddress").val("Enter friends email here to invite");
    if(id=='1')
    {   
        $("#inviteAccount_3").hide();
        $("#cre_to_msg").val("Eg:john@gmail.com");
        $("#cre_to_msg").css("color","#999999");
        //$("#redactor_content").empty();
        $("#redactor_content").text("Enter your invite text here. (Famtivity will send your friend and invite that includes your text)!");
        $("#redactor_content").css("color","#999999");
        $("#redactor_content").css("border","none");
        $("#cre_to_msg").css("border","1px solid    #BDD6DD");
        $("#cre_send_to_error").css("display","none");
        $("#cre_message_error").css("display","none");
        $("#inviteAccount_1").show();
        $("#inviteAccount_2").hide();
        $(".text_1").css("font-weight","bold");
        $(".text_3").css("font-weight","normal");
        $(".text_2").css("font-weight","normal");
    }
    if(id=='2')
    {
        $("#inviteAccount_2").show();
        $("#inviteAccount_1").hide();
        $("#inviteAccount_3").hide();        
        $(".text_2").css("font-weight","bold");
        $(".text_1").css("font-weight","normal");
        $(".text_3").css("font-weight","normal");
    }   
    if(id=='3'){        
        $("#inviteAccount_1").hide();
        $("#inviteAccount_2").hide();
        $("#text-name").val("Search for famtivity Member");
        $("#text-name").css("color","#999999");
        $("#fam-list-show").css("display","none");
        $("#inviteAccount_3").show();
        $("#import_friends").show();
        $("#existInivtefriend").hide();
        if ($(".ffifTxt").is(":visible") == false)
        {
            $("#list_no_frnds").append('<p class="ffifTxt">Find Friends in Famtivity</p>');
        }
        $(".text_3").css("font-weight","bold");
        $(".text_1").css("font-weight","normal");
        $(".text_2").css("font-weight","normal");
    }
   
}

//add calender function
function add_calender(aid,uid,sid)
{
    var activity_id =aid;
    var user_id=uid;
    var schedule_id=sid;
    $.post("/activity_favorites/add_calender", {
        "activity_id":activity_id,
        "user_id":user_id,
        "schedule_id":schedule_id
    },null, "script");
}

//add calender function
function add_fam_calender(aid,uid,sid)
{
    var activity_id =aid;
    var user_id=uid;
    var schedule_id=sid;
    $.post("/activity_favorites/add_famtivity_calender", {
        "activity_id":activity_id,
        "user_id":user_id,
        "schedule_id":schedule_id
    },null, "script");
}

function cityletter(city) {
      
    $.ajax({
        url:'footercity',
        type:"get",
        data: {
            "cityfot": city
        },
        success:function(data){
            if (data!=0) {
                document.getElementById('cityvalueDisplay').innerHTML=data;
            }else{
                document.getElementById('cityvalueDisplay').innerHTML='<a>No city found</a>';
            }
	  
        }
    });      
}
    
    
//website click function added by rajkumar
function web_click(actid,actuid)
{
    var activity_id = actid;
    var user_id = actuid;
    $.post("/activity_detail/link_clicked", {
        "activity_id":activity_id,
        "user_id":user_id
    },null, "script");
}
//Detail page email click count by rajkumar
function email_click(actid,actuid,val)
{
    var activity_id = actid;
    var user_id = actuid;
    var email = val
    $.post("/activity_detail/link_clicked", {
        "activity_id":activity_id,
        "user_id":user_id,
        "pemail":email
    },null, "script");
}


function display_helptxt_show()
{
    $('#helptext').show();
}
function display_helptxt_hide()
{
    $('#helptext').hide();
}
// allow numbers only
function number(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57 ) && (charCode != 46 ) ){
        return false;			
    }
    return true;
}
//set automatically go to next textbox 
function movetoNext(current, nextFieldID) { 
    if (current.value.length >= current.maxLength) {
        document.getElementById(nextFieldID).focus();
    }
}
var add_form_builder;
//form builder popup - open add form
function pop_add_form_builder(url){
    //alert(url);
    add_form_builder = dhtmlmodal.open("Add Form Builder ","iframe",url," ", "width=930px,height=1000px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
var preview_form_builder;
//preview the form
function popup_preview_form(url){
    //alert(url);
    preview_form_builder = dhtmlmodal.open("Preview Form Builder ","iframe",url," ", "width=910px,height=900px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}
var edit_form_builder;
//form builder popup - open edit form
function pop_edit_form_builder(url){
    //alert(url);
    edit_form_builder = dhtmlmodal.open("Edit Form Builder ","iframe",url," ", "width=930px,height=1000px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}

function validateCorrectEmail(elementValue){  
   // var emailPattern = /^([a-zA-Z0-9]+([~{|}`^?=+*'#$!%._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,3}(?:\.[a-zA-Z]{2,3})?)$/;
	var emailPattern = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return emailPattern.test(elementValue);
}

/* Add Group function */
function new_grp(){
    $('#new_group').hide();
    $("#menu_group li:hover ul.sub-menu").css("display:block;");
    $('#new_group_create').show();
}

function grp_create(){
    $.ajax({
        type: "POST",
        data: {
            "fam_net":$('#fam_net').is(':checked'),
            "contact_group_name": $("#contact_group_name").val()
        },
        url: "/contact_groups"
    });
}

function grp_cancel(){
    $("#contact_group_name").val("");
    $(".crte_grp").hide();
}

function grp_close(){
    $("#sub-group-menu").hide();
}
$(function(){
    $("#menu_group").mouseover(function(){
        $("#menu_group li ul.sub-menu").css("display:block;");
        $(".crte_grp").show();
    });

    $("#menu_group_friend ul li").mouseover(function(){
        $("#menu_group_friend li ul.sub-menu").css("display:block;");
        $("#sub-group-menu").show();
    });
});

/* Add Group function end */

/************* New Contact group (Jan 21) **************/
function dispCheckSelectedGroup(incVal){
    $('#select_group').css('display','none');
    $('#not_select_group').css('display','inline-block');
    $('#pe_group').val(0);
	
    $('#group_checkbox_selected_'+incVal).css('display','none');
    $('#group_checkbox_normal_'+incVal).css('display','inline-block');
    $('#group_checkbox_'+incVal).val(0);
    joinValGroup();
}

function dispCheckNormalGroup(incVal){
    $('#group_checkbox_selected_'+incVal).css('display','inline-block');
    $('#group_checkbox_normal_'+incVal).css('display','none');
    $('#group_checkbox_'+incVal).val(1);
    joinValGroup();
}


function dispCheckSelectedOthernetwork(incVal){
    $('#select_group').css('display','none');
    $('#not_select_group').css('display','inline-block');
    $('#pe_group').val(0);
    
    $('#othernetwork_checkbox_selected_'+incVal).css('display','none');
    $('#othernetwork_checkbox_normal_'+incVal).css('display','inline-block');
    $('#othernetwork_checkbox_'+incVal).val(0);
    joinValGroup();
}

function dispCheckNormalOthernetwork(incVal){
    $('#othernetwork_checkbox_selected_'+incVal).css('display','inline-block');
    $('#othernetwork_checkbox_normal_'+incVal).css('display','none');
    $('#othernetwork_checkbox_'+incVal).val(1);
    joinValGroup();
}

function dispCheckSelectedActivity(incVal){
    $('#select_group').css('display','none');
    $('#not_select_group').css('display','inline-block');
    $('#pe_group').val(0);
	
    $('#act_checkbox_selected_'+incVal).css('display','none');
    $('#act_checkbox_normal_'+incVal).css('display','inline-block');
    $('#act_checkbox_'+incVal).val(0);
    joinValGroup();
}

function dispCheckNormalActivity(incVal){
    $('#act_checkbox_selected_'+incVal).css('display','inline-block');
    $('#act_checkbox_normal_'+incVal).css('display','none');
    $('#act_checkbox_'+incVal).val(1);
    joinValGroup();
}

function selectAnyGroup(cname){	
    if(cname == 'select'){
        $('#select_group').css('display','none');
        $('#not_select_group').css('display','inline-block');
        
        $('.list .checkbox_selected_s').css('display','none');
        $('.list .checkbox_normal_s').css('display','inline-block');

        $('.list .checkbox_selected_other_network').css('display','none');
        $('.list .checkbox_normal_other_network').css('display','inline-block');

        $('.list .checkbox_selected_act').css('display','none');
        $('.list .checkbox_normal_act').css('display','inline-block');

        $('#pe_group').val(0);
        $('input.group_checkbox').val(0);
        $('input.other_network_checkbox').val(0);
        $('input.act_checkbox').val(0);
        
        $('#group_names').val(' ');
        $('#other_network_names').val(' ');
        $('#act_names').val(' ');
        $('#frm_contacts').val(' ');
        $('#frm_group').val(' ');

    }
    else if(cname == 'not_select'){
        $('#not_select_group').css('display','none');
        $('#select_group').css('display','inline-block');
        
        $('.list .checkbox_normal_s').css('display','none');
        $('.list .checkbox_selected_s').css('display','inline-block');

        $('.list .checkbox_normal_other_network').css('display','none');
        $('.list .checkbox_selected_other_network').css('display','inline-block');

        $('.list .checkbox_normal_act').css('display','none');
        $('.list .checkbox_selected_act').css('display','inline-block');
		
        $('#pe_group').val(1);
        $('input.group_checkbox').val(1);
        $('input.other_network_checkbox').val(1);
        $('input.act_checkbox').val(1);
        $('#act_names').val(' ');
        $('#other_network_names').val(' ');
        $('#group_names').val(' ');
        $('#frm_contacts').val(' ');
        $('#frm_group').val(' ');
	
        joinValGroup();
    }
}

function joinValGroup(){
    var input_val='';
    var input_id ='';
    var joinStr1 ='';
    var joinStr2 ='';
    var joinStr3 ='';

    var cont_input_box_length=$('input.group_checkbox').length;
    for(var i=1;i<=cont_input_box_length;i++)
    {
        input_val = $('#group_checkbox_'+i).val();
        if(input_val!=0){
            input_id = $('#group_id_'+i).val();
            if (input_id!=undefined){
               joinStr1 += input_id+",";
            }    		
        }
    }
    $('#group_names').val(joinStr1);

    var cont_input_box_length=$('input.other_network_checkbox').length;
    for(var i=1;i<=cont_input_box_length;i++)
    {
        input_val = $('#othernetwork_checkbox_'+i).val();
        if(input_val!=0){
            input_id = $('#othernetwork_id_'+i).val();
            if (input_id!=undefined){
               joinStr2 += input_id+",";
            }           
        }
    }
    $('#other_network_names').val(joinStr2);
    var cont_input_box_length=$('input.act_checkbox').length;
	
    for(var i=1;i<=cont_input_box_length;i++)
    {
        input_val = $('#act_checkbox_'+i).val();
        if(input_val!=0){
            input_id = $('#act_id_'+i).val();
            joinStr3 += input_id+",";
		
        }
    }
    $('#act_names').val(joinStr3);
}

function filter_grp_name(id,click){
    $(".contact_tablebdr").css('border','1px solid #ededed');
    //$(".contact_tablebdr").css('background-color','#FFFFFF');
    //$(".contactbrdr").css('background-color','#FFFFFF');
    if(click=='groups')
    {
        var id_value = $("#grpid_"+id).val();
        var val = $("#group-list-tr_"+id).attr('data');
        $(".full_table_"+val).css('border','1px solid #ffa0a0');
        //$("#group-list-table_"+val).css('background-color','#F4F0EF');
        //$(".full_table_"+val).css('background-color','#F4F0EF');
    }
    else if(click=='others')
    {
        var id_value = $("#otrid_"+id).val();
        var val = $("#group-list-tr_"+id).attr('data');
        $(".fam_table_"+val).css('border','1px solid #ffa0a0');
    }
    else
    {
        var id_value = $("#actid_"+id).val();
        var val = $("#act-list-tr_"+id).attr('data');
        //$("#act_id_"+val).css('border','1px solid #ffa0a0');
        //$("#act-list-table_"+val).css('background-color','#F4F0EF');
        //$(".activity_contact_"+val).css('background-color','#F4F0EF');
        $(".activity_contact_"+val).css('border','1px solid #ffa0a0');
        
    }
    $("#loadimg").show();
    $.ajax({
        type: "GET",
        url: "/contact_groups/"+id_value+"/filter_contacts_by_groups?click="+click+""
    });
}

/* Edit Group popup*/
function displayEditGroup(id,name){
    $(".full_table_0").css('border','1px solid #ededed');
    $(".contact_tablebdr").css('border','1px solid #ededed');
    $('.popupDeleteClose').css('display','none')
    close_click_function();
    $('.g_name').val(name);
    // find window height and changed the popup position
    /*var wh= $(window).height();
	var offTop = $("#edit_grp_btn_"+id).offset().top;  
	var findTop = wh - offTop;
	if(findTop>300 && findTop<500){
		var setheight = $("#edit_grp_"+id).height();
		setheight = setheight  + 27;		
		$("#edit_grp_"+id+" .permission_schedule_container").css('marginTop','-'+setheight+'px');
		$("#edit_grp_"+id+" .permission_arrow_outer div").removeClass('permission_top_arrow');
		$("#edit_grp_"+id+" .permission_arrow_outer div").addClass('permission_bottom_arrow');		
	}
	else{
		$("#edit_grp_"+id+" .permission_schedule_container").css('marginTop','0px');		
		$("#edit_grp_"+id+" .permission_arrow_outer div").removeClass('permission_bottom_arrow');
		$("#edit_grp_"+id+" .permission_arrow_outer div").addClass('permission_top_arrow');
	}	*/
    $(".delfongroup").css('color','#4595AE');
    $(".contactpadding .ftcBlue").css('color','#4595AE');
    $("#edit_grp_btn_"+id).css('color','#F97C0E');
    $(".edit_grp_page").css('display','none');
    $("#edit_grp_"+id).css('display','block');
}
function closeEditGroup(id){
    $("#edit_grp_btn_"+id).css('color','#4595AE');
    $("#edit_grp_"+id).css('display','none');
}
function closeEditGroupAll(){
    //~ $(".more_schedule_text .blueText").css('color','#4595AE');
    $(".edit_grp_page").css('display','none');
}
function close_click_function(){
    closeEditGroupAll();
}

function UpdateGroup(id)
{
    $('.loaderedit').css("display","block");
    $.ajax({
        type: "PUT",
        data: {
            "fam_net":$('#fam_net_'+id).is(':checked'),
            "contact_group_name": $("#edit_group_name_"+id).val()
        },
        url: "/contact_groups/"+id+""
    });
}

function pop_delete_group(url){
    deleteContactPage = dhtmlmodal.open("Event Delete Contact","iframe",url," ", "width=466px,height=290px,overflow:hidden,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}

function DeleteGroup(id)
{
    pop_delete_group("/contact_groups/"+id+"/delete_group");
}

/* contact edit group drop down script */

function show_edit_grp_dropdown()
{
    $("#list_edit_grp_drop").slideToggle();
}


function selected_group(){
    $('#update_group_ids').val(true);
    var arr_ids = new Array();
    var arr_val = new Array();
    $("input:checkbox[name=drop_selected]:checked").each(function(){
        arr_val.push($(this).val());
        arr_ids.push($(this).attr('data'));
    });
    if(arr_val == "")
    {
        $("#input_text_box").text("-- Select Network --");
    }
    else
    {
        var grp_txt = arr_val.toString();
        if(grp_txt.length > 53)
        {
            var shortText = grp_txt.substr(0,50);
            $("#input_text_box").text(shortText).append('...');
        }
        else
        {
            $("#input_text_box").text(grp_txt);
        }
    }
    $("#edit_grp_ids").val(arr_ids);
}
/**********************************deactivate changes starting****************************************************/
//user account activate popup for deactivate users by rajkumar
function activate_account(){
    $('#activate_account_feature').bPopup({
        fadeSpeed:100,
        followSpeed:100,
        opacity:0.8,
        positionStyle: 'fixed',
        modalClose: false,
    });
}

//user activate mail
function user_activate_call(){
    var user_id = $('#user_id_delete').val();
    $('#loading_img_act').css("display","inline-block");
    $.post("/user_account_deactivate", {
        "user_id":user_id,
        "user_status":"activate"
    }, null, "script");
    return false;
}
//activate and change popup for deactivate user
function user_activate_and_change(){
    $('#activate_account_feature').hide();
    window.location.href="/provider_plan"
}
//display the acitvate state
function deactivate_update_div(){
    $('#UsrActDeact').hide();
    $('#UsrActivateState').show();
    $('#UsrDeActivateState').hide();
    window.location.href="/provider_settings"
}

//display credit card page if cc details are failure
function check_cc_details()
{
	$('#UsrActDeact').hide();
	$('#UsrActivateState').hide();
	$('#UsrDeActivateState').show();
	window.location.href="/get_credit_card_info"
}

//display the deacitvate state
function activate_update_div(){
    $('#UsrActDeact').hide();
    $('#UsrActivateState').hide();
    $('#UsrDeActivateState').show();
    window.location.href="/provider_settings"
}
function deactivate_user_added_act(){
    $('#deactivate_user_activity').bPopup({
        fadeSpeed:100,
        followSpeed:100,
        opacity:0.8,
        positionStyle: 'fixed',
        modalClose: false,
    });
}

/**********************************deactivate changes ending here****************************************************/


//display the attachment popup for message card preview
function preview_attachment_popup(url)
{
    MessagePreviewPopup = dhtmlmodal.open("Attachements","iframe",url,"", "width=1000px,height=700px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");	
    $("html, body").animate({
        scrollTop: 0
    }, 100);
    return false;
}

/*SEO Optimization URL changes for invite flow*/
function contact_invite(check_url)
{
{
    var stateObj = {
        foo: "bar"
    };
    if(navigator.appName=="Microsoft Internet Explorer")
    {
        window.location.hash='';
    }
    else if (check_url=="invite")
    {
        history.replaceState(stateObj, "Invite a Friend", "invite-a-friend");
    }
    else if (check_url=="find")
    {
        history.replaceState(stateObj, "Find Famtivity Members", "find-famtivity-members");
    }
    else if (check_url=="contact_import")
    {
        history.replaceState(stateObj, "Import & Invite Friends", "import-invite-friends");
    }
    else
    {
/*TODO if none of the above condition satisify*/
}
}
}


/* How it works calling here*/
function howitworks(url){
    /*SEO URL*/
    var stateObj = {
      foo: "bar"
    };
    if(navigator.appName=="Microsoft Internet Explorer")
    {
      window.location.hash='/';
    }
    else
    {
      history.replaceState(stateObj, "How It Works", url);
    }
	
    HowitworksPopupPage = dhtmlmodal.open("How it works","iframe",url,"", "width=1000px,height=700px,center=1,resize=0,scrolling=0,style='margin:0px; padding:0px; background:none;'", "recal");	
    $("html, body").animate({ scrollTop: 0 }, 100);
    return false;
  }

  window.fbAsyncInit = function() {
  FB.init({
    appId      : fb_id, // App ID
    status     : true, // check login status
    cookie     : true // enable cookies to allow the server to access the session
  });
};
(function(d){
  var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
  if (d.getElementById(id)) {return;}
  js = d.createElement('script'); js.id = id; js.async = true;
  js.src = "//connect.facebook.net/en_US/all.js";
  ref.parentNode.insertBefore(js, ref);
}(document));
function testAPI(s_user,invited) {
  FB.api('/me', {fields: "id,name,picture,email,username,name"},function(response)
  {
    $.get("login/fb_login?s_user="+s_user+"&invited="+invited, {"fb_res": response},function(data) {
      // 'data' contains a 'user' object with 'email' and 'name' in it.
    });
  });
}

function facebook_login(s_user,invited) {
  FB.login(function(response) {
    if (response.status === 'connected') {
      testAPI(s_user,invited);
    } else if (response.status === 'not_authorized') {
         
    } else {
      FB.login();
    }
  }, {scope: 'email,user_likes'},{perms:'user_address, user_mobile_phone'});
}

