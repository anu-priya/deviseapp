

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
           

      $(document).ready(function(){
      $("#howitwrks").css("visibility","hidden");
      $("#getwrks").css("visibility","hidden");
      var sear_box = $("#search_value").val();
      if ((sear_box == "Search 20,000 + Local Activities & Counting...") || (sear_box=="")){
        $("#autocomplete_appender1").css("display","none");
      }
    });
      
    window.addEventListener('popstate', function(e) {
      var sear_box = $("#search_value").val();
      if ((sear_box == "Search 20,000 + Local Activities & Counting...") || (sear_box=="")){
        $("#autocomplete_appender1").css("display","none");
      }
    });
      
    //city submit values
    function city_submit(e)
    {
      var aa= $('#city_v').val(e);
      document.forms['city_select_val'].submit();
    }
	
    //show following button in bottom link
    function show_follow()
    {
      $(".selectedCity23244").show();
      $('#top_menu ul li ul, #top_menu ul li ul li').css("display","block");
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
    var array_fav = new Array();
    var remove_fav = new Array();
    var parent_add_fav = new Array();
    var parent_remove_fav = new Array();
    var provider_add_fav = new Array();
    var provider_remove_fav = new Array();
    var follow_add_fav = new Array();
    var follow_remove_fav = new Array();
    var followuser_add_fav = new Array();
    var followuser_remove_fav = new Array();

    function modifyText_ev(testVal){
      if($("#subCat_"+testVal+" input").is(":checked")){
        $(".add_favorite").css("display","block");
        favorite_item = $("#subCat_"+testVal+" input").val();
        array_fav.push(favorite_item);
        $('#fav_val').val(array_fav);
      }
      else{
        var remove_item = $("#subCat_"+testVal+" input").val();
        var index = array_fav.indexOf(remove_item);
        array_fav.splice(index, 1);
        $('#fav_val').val(array_fav);
        if (remove_fav.indexOf(remove_item) == -1){
          remove_fav.push(remove_item);
          $('#rem_fav_val').val(remove_fav);
        }
      }
    }
    


  window.addEventListener('popstate', function(e) {
    $('#loadDivjax').css("display","none");
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