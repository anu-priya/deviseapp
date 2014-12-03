//~ $(document).ready(function(){
$('#invite_friends').hide();

//display the text color bold for search results
var search_value = $("#search_value").val();
var count_auto = 2;
if(search_value!="Search Activities..."){
    $("#search_value").css("color","#666666");
}


$('#search_value').autocomplete({
    serviceUrl: '/data_entry',
    formatResult: function(suggestion, currentValue) {
        count_auto = 2;
        if(suggestion.data =="all"){
            $("#autocompleteappender_cur_set").val(suggestion.cur_set);
            $("#autocompleteappender_length").val(suggestion.total_p);
            return "<a id='value"+suggestion.data +"' class='allsearch' href='#'>"+suggestion.act+":"+currentValue+"</a>"
        }
        else if (suggestion.w_class == "user" ){
            return "<table><tr><td class='td1'><a id='value"+suggestion.data +"' href='#' class='redSearch'>" + "" + " </a></td><td class='td2'><a id='raj"+suggestion.data +"' class='blueSearch' title= 'Provider Name:"+ suggestion.w_provider_name +"' href='#' onclick='set_provider(\"" + suggestion.user_id + "\",\"" + escape(suggestion.w_provider_name) + "\",\"" + escape(suggestion.pass_value) + "\");'>" +suggestion.provider_name + "</a></td><td class='td3'><a id='raj"+suggestion.data +"' href='#' title= 'City:"+ suggestion.w_city +"' class='graySearch' onclick='set_city(\"" + suggestion.data + "\",\"" + escape(suggestion.city) + "\",\"" + escape(suggestion.pass_value) + "\")'>" + suggestion.city  + "</a></td></tr></table>";
        //   return "<table><tr><td class='td2'><a id='raj"+suggestion.data +"' class='blueSearch' title= 'Provider Name:"+ suggestion.w_provider_name +"' href='#' onclick='set_provider(\"" + suggestion.user_id + "\",\"" + suggestion.w_provider_name + "\",\"" + suggestion.pass_value + "\");'>" +suggestion.w_provider_name + "</a></td><td class='td3'></tr></table>";
        }
        else if (suggestion.w_class == "activity" ) {
            if(suggestion.w_city!=null){
                city = suggestion.w_city.toLowerCase().replace(/\s/g , "-")
            }
            else{
                city = suggestion.w_city;
            }
            act_url = "/"+unescape(city)+"/"+unescape(suggestion.up_slug)+"/"+unescape(suggestion.category.toLowerCase().replace(/\s/g , "-"))+"/"+unescape(suggestion.sub_category.toLowerCase().replace(/\s/g , "-"))+"/"+unescape(suggestion.w_slug)
            return "<table><tr><td class='td1'><a style='display:block; width:100%; 'id='value"+suggestion.data +"' title= 'Activity Name:"+ suggestion.w_activity_name +"' data-pjax onclick='setBreadAct(\"" + currentValue + "\"); set_act_name(\"" + escape(suggestion.w_activity_name) + "\",\"" + escape(suggestion.pass_value) + "\");' href='"+act_url+"' class='redSearch' >" + suggestion.activity_name+ " </a></td><td class='td2'><a style='display:block; width:100%;' id='raj"+suggestion.data +"' class='blueSearch' title= 'Provider Name:"+ suggestion.w_provider_name +"' href='#' onclick='set_provider(\"" + suggestion.user_id + "\",\"" + escape(suggestion.w_provider_name) + "\",\"" + escape(suggestion.pass_value) + "\");'>" +suggestion.provider_name + "</a></td><td class='td3'><a style='display:block; width:100%;' id='raj"+suggestion.data +"' href='#' title= 'City:"+ suggestion.w_city +"' class='graySearch' onclick='set_city(\"" + suggestion.data + "\",\"" + escape(suggestion.city) + "\",\"" + escape(suggestion.pass_value) + "\")'>" + suggestion.city  + "</a></td></tr></table>";
        }
    },
    onSelect: function (suggestion) {
        if(suggestion.data =="all"){
            $.get("/basic_search_count",{
                "event_search": suggestion.value
            }, function(data){
                if (data>0)
                {
                    window.location = "/search?event_search="+suggestion.value;
                }
                else{
                    $('.right_container').html('<div class="setBg1"><div width="100%" class="no_activities" style="text-align:center;height: 500px;">Sorry we found no results for your search.</div></div>');
                    $("#bsearch_norecord").bPopup({
                        modalClose:false
                    });
                    $("#bsearch_norecord").show();
                }
            }, "script"
            );

        }

    },
    width :575
})

//~ });

//~ function set_search_cookie(cookievalue)
//~ {
    //~ document.cookie="search_key=" + cookievalue;
//~ }
function set_city(id,cit,act_value){
    var c_value = act_value + cit;
    //show only city name
    $("#search_value").val(unescape(cit));
    //$("#search_value").val(unescape(c_value));
    window.location = "/search?type=city&event_search="+act_value+"&city_name="+cit;
}

function set_provider(pro,name,act_value){
    var c_value = act_value + name;
    //show only provider name
    $("#search_value").val(unescape(name));
    window.location = "/search?type=provider&user_id="+pro+"&event_search="+act_value+"&pro_name="+unescape(name);
}

function set_activity(id,provider_name,category,city,data){
    //~ function set_activity(id,city,provider_name,category,sub_category,activity_name){
    //~ alert(unescape(sub_category));
    //~ window.location = "/"+unescape(city.trim())+"/"+unescape(provider_name.trim())+"/"+unescape(category.trim())+"/"+unescape(sub_category.trim())+"/"+unescape(activity_name.trim());
    //~ //show only activity name
    $("#search_value").val(unescape(data));
    //~ //$("#search_value").val(unescape(provider_name));
    //~ /*IE11 Fixes-> Dont Remove*/
    if (history.pushState){
        window.history.pushState(null, "Activity Details", "/activitydetail_new?det="+id+"&mode=parent&act=landing_new','/activities/"+city+"-ca"+"/"+id+"-"+data);
        // window.history.pushState(null, "Activity Details", "/activitydetail_new?det="+id+"&mode=parent&act=landing_new','/activities/"+id+"/"+city+"/parent/"+category+"/"+data+"/");
        //window.history.pushState(null, "Activity Details", "/activitydetail_new?det="+id+"&mode=parent&act=landing_new','/activity_detail_iframe?det="+id+"/"+city+"/parent/"+category+"/"+data+"/");
        search_pop_Activity_Detail_dhtml("/activitydetail_new?det="+id+"&mode=parent");
    }
    else
    {
        search_pop_Activity_Detail_dhtml("/activitydetail_new?det="+id+"&mode=parent");
    }

//~ //setTimeout(function(){
//~ // $("#search_value").val(data);
//~ //$('#popup_container').css({'position':'absolute'});
//~ // },200)
}

function set_act_name(act_name,cookievalue){
    $("#autocomplete_appender1").remove();
    $("#search_value").val(unescape(act_name));
	 //~ document.cookie="search_key= ''";
    document.cookie="browse_category=;path=/";
    document.cookie="set_bread=;path=/";
    document.cookie="test_cook=" + unescape(cookievalue) + ";path=/";
}


$(document).ready(function(){
    atocomplete();
})
	
window.addEventListener('popstate', function(e) { 
    atocomplete();
});
	
function atocomplete(){
    invite_providers();
    var count_auto=2;
    search_processing = false;
    $(".autocomplete_appender").scroll(function(){

        if($(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight){
            var searc_val = $("#search_value").val();
            var total_p = $("#autocompleteappender_length").val();
            var cur_set = $("#autocompleteappender_cur_set").val();
            if (count_auto > parseInt(total_p)){
                $("#loading").css('display','none');
                return false;
            }
            else{
                if (search_processing == false){
                    search_processing = true;
                    $.ajax({
                        url: "/data_entry",
                        type:"post",
                        data: {
                            query: searc_val,
                            page:count_auto,
                            set_p:cur_set
                        },
                        success: function( data ) {
                            $.map (data.suggestions, function( item){
                                if(item.data =="all"){
                                    if (item.cur_set == "2" && item.cur_page == "1"){
                                        count_auto = 2;
                                        cur_set = 2;
                                    }
                                    else{
                                        count_auto++;
                                    }
                                    $("#autocompleteappender_cur_set").val(item.cur_set);
                                    $("#autocompleteappender_length").val(item.total_p);
                                    search_processing = false;
                                }
                                if(item.data !="all"){
				 
                                    if (item.w_class == "user" ){
					    
                                        //			         return "<table><tr onclick='set_provider(\"" + suggestion.user_id + "\",\"" + escape(suggestion.w_provider_name) + "\",\"" + escape(suggestion.pass_value) + "\");'><td class='td1'><a id='value"+suggestion.data +"' href='#' class='redSearch'>" + "" + " </a></td><td class='td2'><a id='raj"+suggestion.data +"' class='blueSearch' title= 'Provider Name:"+ suggestion.w_provider_name +"' href='#' onclick='set_provider(\"" + suggestion.user_id + "\",\"" + escape(suggestion.w_provider_name) + "\",\"" + escape(suggestion.pass_value) + "\");'>" +suggestion.provider_name + "</a></td><td class='td3'><a id='raj"+suggestion.data +"' href='#' title= 'City:"+ suggestion.w_city +"' class='graySearch' onclick='set_city(\"" + suggestion.data + "\",\"" + escape(suggestion.city) + "\",\"" + escape(suggestion.pass_value) + "\")'>" + suggestion.city  + "</a></td></tr></table>";
                                        //$(".autocomplete_appender").append("<div class='autocomplete-suggestion' data-index='"+item.data+"'><table><tr><td class='td1'><a id='value"+item.data +"' href='#' class='redSearch'>" + "" + " </a></td><td class='td2'><a id='raj"+item.data +"' class='blueSearch' title= 'Provider Name:"+ item.w_provider_name +"' href='#' onclick='set_provider(\"" + item.user_id + "\",\"" + escape(item.provider_name) + "\",\"" + escape(item.pass_value) + "\");'>" +item.provider_name + "</a></td><td class='td3'><a id='raj"+item.data +"' href='#' title= 'City:"+ item.w_city +"' class='graySearch' onclick='set_city(\"" + item.data + "\",\"" + escape(item.city) + "\",\"" + escape(item.pass_value) + "\")'>" + item.city  + "</a></td></tr></table></div>")

                                        $(".autocomplete_appender").append("<div class='autocomplete-suggestion' data-index='"+item.data+"'><table><tr><td class='td1'><a id='value"+item.data +"' href='#' class='redSearch'>" + "" + " </a></td><td class='td2'><a id='raj"+item.data +"' class='blueSearch' title= 'Provider Name:"+ item.w_provider_name +"' href='#' onclick='set_provider(\"" + item.user_id + "\",\"" + escape(item.w_provider_name) + "\",\"" + escape(item.pass_value) + "\");'>" +item.provider_name + "</a></td><td class='td3'><a id='raj"+item.data +"' href='#' title= 'City:"+ item.w_city +"' class='graySearch' onclick='set_city(\"" + item.data + "\",\"" + escape(item.city) + "\",\"" + escape(item.pass_value) + "\")'>" + item.city  + "</a></td></tr></table></div>")
                                    //  $("#autocomplete_appender").append("<div class='autocomplete-suggestion' data-index='"+item.data+"'><table><tr><td class='td2'><a id='raj"+item.data +"' class='blueSearch' title= 'Provider Name:"+ item.w_provider_name +"' href='#' onclick='set_provider(\"" + item.user_id + "\",\"" + item.w_provider_name + "\",\"" + item.pass_value + "\");'>" +item.w_provider_name + "</a></td><td class='td3'></tr></table></div>");
                                    }
                                    else{
                                        //~ act_url = "/"+unescape(city)+"-ca/"+unescape(item.up_slug)+"/"+unescape(item.category.toLowerCase().replace(/\s/g , "-"))+"/"+unescape(item.sub_category.toLowerCase().replace(/\s/g , "-"))+"/"+unescape(item.w_slug)
                                        if(item.w_city!=null){
                                            city = item.w_city.toLowerCase().replace(/\s/g , "-")
                                        }
                                        else{
                                            city = item.w_city;
                                        }

                                        act_url = "/"+unescape(city)+"/"+unescape(item.up_slug)+"/"+unescape(item.category.toLowerCase().replace(/\s/g , "-"))+"/"+unescape(item.sub_category.toLowerCase().replace(/\s/g , "-"))+"/"+unescape(item.w_slug)
                                        $(".autocomplete_appender").append("<div  class='autocomplete-suggestion' data-index='"+item.data+"'><table><tr><td class='td1'><a style='display:block; width:100%; 'id='value"+item.data +"' title= 'Activity Name:"+ item.w_activity_name +"' data-pjax onclick='set_act_name(\"" + escape(item.w_activity_name) + "\",\"" + escape(item.pass_value) + "\")' href='"+act_url+"' class='redSearch' >" + item.activity_name+ " </a></td><td class='td2'><a style='display:block; width:100%;' id='raj"+item.data +"' class='blueSearch' title= 'Provider Name:"+ item.w_provider_name +"' href='#' onclick='set_provider(\"" + item.user_id + "\",\"" + escape(item.w_provider_name) + "\",\"" + escape(item.pass_value) + "\");'>" +item.provider_name + "</a></td><td class='td3'><a style='display:block; width:100%;' id='raj"+item.data +"' href='#' title= 'City:"+ item.w_city +"' class='graySearch' onclick='set_city(\"" + item.data + "\",\"" + escape(item.city) + "\",\"" + escape(item.pass_value) + "\")'>" + item.city  + "</a></td></tr></table></div>");
                              
                                    // $(".autocomplete_appender").append("<div  class='autocomplete-suggestion' data-index='"+item.data+"'><table><tr><td class='td1'><div id='value"+item.data +"' title= 'Activity Name:"+ item.w_activity_name +"' href='#' class='redSearch'  onclick='set_activity(\"" + item.data + "\",\"" + escape(item.activity_name) + "\");'>" + item.activity_name + " </div></td><td class='td2'><a id='raj"+item.data +"' class='blueSearch' title= 'Provider Name:"+ item.w_provider_name +"' href='#' onclick='set_provider(\"" + item.user_id + "\",\"" + escape(item.provider_name) + "\",\"" + escape(item.pass_value) + "\");'>" +item.provider_name + "</a></td><td class='td3'><a id='raj"+item.data +"' href='#' title= 'City:"+ item.w_city +"' class='graySearch' onclick='set_city(\"" + item.data + "\",\"" + escape(item.city) + "\",\"" + escape(item.pass_value) + "\")'>" + item.city  + "</a></td></tr></table></div>");
                                    }
                                }
                            });

                        },
                        error: function(jqXHR, textStatus, errorThrown){
                            alert('ajax error:' + textStatus);
                        }
                    });
                    
                    var total_width = $(window).width()/2.4;
                    var total_height = $(window).height()/2-80;
                    $("#loading").css('top',total_height);
                    $("#loading").css('left',total_width);
                }
            //$("#loading").css('display','block');
            }
        }
    });
}
	
	
//quick link click funciton started here
function search_bar(qtype)
{
    if(qtype)
    {
        var search_word = $("#search_value").val('Search 20,000 + Local Activities & Counting...');
        window.location.href ="/quick-link/"+qtype
    }
}
	
var i=0;
function invite_providers(){
    setInterval(function(){

        invite_friends(i++);
    },
    5000);
}
function invite_friends(j){
    if(j%2==1){
        $("#invite_friends").hide();
        $("#invite_providers").show();
    }
    else{
        $("#invite_friends").show();
        $("#invite_providers").hide();
    }
}
function setBreadAct(val)
{
	var d = new Date();
	d.setTime(d.getTime() + (1*24*60*60*1000));
	var expires = "expires="+d.toUTCString();
	document.cookie = "search_activity="+val+"; " + expires + "path=/main";   
 
}
