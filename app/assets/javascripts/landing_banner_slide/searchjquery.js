//header bar search results page 0 to 3
/* function search_age_range()
      {
        var search_age = $(".search_age_range").val();
        var search_word = $("#search_value").val();
        //window.location.href ="/search?arange="+search_age;
        if ((search_word != "Search Activities...") && (search_word != ""))
          {
            var event_search = search_word;
          }
          else
            {
             var event_search = "";
            }
        window.location.href ="/search_event_index?arange="+search_age+"&event_search="+event_search;
      }
      //header bar search results page 4 to 7
      function search_range_47()
      {
        var search_age = $(".search_range_47").val();
	 var search_wrd = $("#search_value").val();
        //window.location.href ="/search?arange="+search_age;
        if ((search_wrd != "Search Activities...") && (search_wrd != ""))
          {
            var event_search = search_wrd;
          }
          else
            {
             var event_search = "";
            }
        window.location.href ="/search_event_index?arange="+search_age+"&event_search="+event_search;
      }
      //header bar search results page 8 to 12
      function search_range_8to12()
      {
        var search_age = $(".search_range_8to12").val();
	 var search_wrd = $("#search_value").val();
        //window.location.href ="/search?arange="+search_age;
        if ((search_wrd != "Search Activities...") && (search_wrd != ""))
          {
            var event_search = search_wrd;
          }
          else
            {
             var event_search = "";
            }
        window.location.href ="/search_event_index?arange="+search_age+"&event_search="+event_search;
      }
      //header bar search results page 8 and above
      function search_range_13()
      {
        var search_age = $(".search_range_13").val();
	 var search_word = $("#search_value").val();
        //~ window.location.href ="/search?age="+search_age;
	 if ((search_word != "Search Activities...") && (search_word != ""))
	  {
	    var event_search = search_word;
	  }
          else
	    {
	     var event_search = "";
	    }
        window.location.href ="/search_event_index?age="+search_age+"&event_search="+event_search;
      }      
      //header bar search results page camps
      function search_camps()
      {
        var search_age = $(".search_camps").val();
        //~ window.location.href ="/search?camps="+search_age;
	 var search_word = $("#search_value").val();
	 if ((search_word != "Search Activities...") && (search_word != ""))
	  {
	    var event_search = search_word;
	  }
          else
	    {
	     var event_search = "";
	    }
        window.location.href ="/search_event_index?camps="+search_age+"&event_search="+event_search;
      }      
       //header bar search results page camps
      function search_specials()
      {
        var search_age = $(".search_specials").val();
        //~ window.location.href ="/search?camps="+search_age;
	 var search_word = $("#search_value").val();
	 if ((search_word != "Search Activities...") && (search_word != ""))
	  {
	    var event_search = search_word;
	  }
          else
	    {
	     var event_search = "";
	    }
        window.location.href ="/search_event_index?specials="+search_age+"&event_search="+event_search;
      }*/
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
               // if (pathname == "/search_event_index"){
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
function clear_search(){
    $('.search_removeicon').hide();
    $("#search_value").val('Search Activities...').css("color","#999999");
}
function newspopup_show()
{
    $(".newspopup_show").show();
}
function newspopup_hide()
{
    $(".newspopup_show").hide();
}