//activity favorites function calling here
function checkfavorites(aid)
{
	$.ajax({
	url:'/activity_favorites/favorite_exist?activity_id='+aid,
	success:function(data){
		//flash message displayed for favorites activity
			if (data == "already_exist"){
				$(".flash-message").html("This activity is already in your favorites");
			}
			else if(data == "new_entry")
			{
				$(".flash-message").html("You have successfully favorite this activity");
			}
			var win=$(window).width();
			var con=$(".flash_content").width();
			var leftvalue=((win/2)-(con/2))
			$(".flash_content").css("left",leftvalue+"px");
			$(".flash_content").css("top","67px");
			$('.flash_content').fadeIn().delay(10000).fadeOut();
		//flash message displayed for favorites activity ending here
	}
	});
}

function close_page(){
	if (history.length > 1){
		history.go(-1);return false;
	}
	else
	{
		window.location.href = "/"
	}
}

	function closeform_cal(){
		$(".form_cal_pop").hide();
	}
           

      //~ $(document).ready(function(){
      //~ $("#howitwrks").css("visibility","hidden");
      //~ $("#getwrks").css("visibility","hidden");
      //~ var sear_box = $("#search_value").val();
      //~ if ((sear_box == "Search 20,000 + Local Activities & Counting...") || (sear_box=="")){
        //~ $("#autocomplete_appender1").css("display","none");
      //~ }
    //~ });
      
     
    //city submit values
    function city_submit(e)
    {
      var aa= $('#city_v').val(e);
      document.forms['city_select_val'].submit();
    }
	      
    //login feature bpopup displayed
    function login_feature(sav,actid)
    {
      var act=sav;
      var activity_id=actid;
	
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
	
    function login_feature_detail(act,arg)
    {
      var activity_id=act;
      var get_arg = arg;
      $('#login_use_feature').bPopup({
        fadeSpeed:100,
        followSpeed:100,
        opacity:0.8,
        positionStyle: 'absolute',
        modalClose: false
      },function(){
        $( "#loginFeature" ).click(function(){
          pop_Login('/login?activity_id='+activity_id+'&bcrum='+get_arg);
        });
      });
    }

    
  window.addEventListener('popstate', function(e) {
    $('#loadDivjax').css("display","none");
    //~ $("#autocomplete_appender1").remove();
  });
  
      function macfix(){
      var ua=navigator.userAgent;
      if(ua.indexOf("Mac")!=-1)
      {
        if(ua.indexOf("Firefox")!=-1){
          $('#marginLeftMac').css('border','1px solid red');
          $('#marginLeftMac').css('position','relative');
          $('#marginLeftMac').css('top','0px');
        }
        if(ua.indexOf("Safari")!=-1){
          $('.center_bg_scroll').css('height','538px');
        }
      }
    }
    macfix();