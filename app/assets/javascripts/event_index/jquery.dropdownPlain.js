$(function(){
    $("ul.dropdown li a").hover(function(){
		$('.dropdown li a:first').css("border","1px solid #b1d7e3");
		//$('.dropdown li a:first').css("text-decoration","underline");
    	$('ul.dropdown li a:first').addClass("hoverDiv");
        $('ul.dropdown li a:first').addClass("hover");
        $('ul:first',this).css('visibility', 'visible');
		$(".search_submenu").css("display","none");
		$('#event_index_container .headerPart1 ul.dropdown ul').css('visibility','visible');
    
    }, function(){
    	$('.dropdown li a:first').css("border","1px solid #DBEEF4");
        $('ul.dropdown li a:first').removeClass("hover");
        $('ul:first',this).css('visibility', 'hidden');
		$('#event_index_container .headerPart1 ul.dropdown ul').css('visibility','hidden');
    	$('ul.dropdown li a:first').removeClass("hoverDiv");
    });


    $("ul.dropdownDate li a").hover(function(){
		$('.dropdownDate li a:first').css("border","1px solid #b1d7e3");
		$(".hoverDiv").css("marginLeft","20px");
        $('ul.dropdownDate li a').addClass("hoverDivDate");
        $(this).addClass("hover");
        $('ul:first',this).css('visibility', 'visible');
		$(".search_submenu").css("display","none");
    
    }, function(){
    	$('.dropdownDate li a:first').css("border","1px solid #DBEEF4");	
        $(this).removeClass("hover");
        $('ul:first',this).css('visibility', 'hidden');
    	$('ul.dropdownDate li a').removeClass("hoverDivDate");
	
    });



		 //  $('#GoToDivGoTo').addClass("hoverDivGoto");
    $("ul.dropdownGoTo li a").hover(function(){
		$('.dropdownGoTo li a:first').css("font-size","14px");
		$('.dropdownGoTo li a:first').css("border","1px solid #b1d7e3");
		$(".dropdownGoTo li ul .sub_menuGoTo li a").css("border","1px solid #F7F9F8");
		$("#event_index_container #topHeaderRt ul.dropdownGoTo ul li a ").css("border","none");
		//$('.dropdownGoTo li a:first').css("border-right","1px solid #b1d7e3");
	//	$('.dropdownGoTo li ul .sub_menu li').css("border-right","1px solid #b1d7e3");
    	$('#GoToDivGoTo').addClass("hoverDivGoto");
        $(this).addClass("hover");
        $('ul:first',this).css('visibility', 'visible');
    
    }, function(){
    	$('.dropdownGoTo li a:first').css("border","1px solid #F7F9F8");	
		$(".dropdownGoTo li ul .sub_menuGoTo li a").css("border","1px solid #F7F9F8");
        $(this).removeClass("hover");
        $('ul:first',this).css('visibility', 'hidden');
    	$('#GoToDivGoTo').removeClass("hoverDivGoto");
    });



	
    $("ul.dropdownName li a").hover(function(){
		$('.dropdownName li a:first').css("font-size","14px");
		$('.dropdownName li a:first').css("border","1px solid #b1d7e3");
		$('.dropdownName li ul .sub_menuName li a').css("border","1px solid #b1d7e3");
		$('.dropdownName .firstDiv li a #GoToDivName').css("background","red");
		$("#event_index_container #topHeaderRt ul.dropdownName ul li a ").css("border","none");
		$("#event_index_container #topHeaderRt ul.dropdownName ul li:first-child a").css("border-top","1px solid #B1D7E3");		
		$(".hoverDiv").css("marginLeft","20px");
		//$("#event_index_container #topHeaderRt ul.dropdownName ul li a ").css("width","124px");
        $('.dropdownName li a:first').addClass("hoverDivName");
        $(this).addClass("hover");
        $('ul:first',this).css('visibility', 'visible');
    
    }, function(){
    	$('.dropdownName li a:first').css("border","1px solid #DBEEF4");	
		$(".dropdownName li ul .sub_menuName li a").css("border","1px solid #F7F9F8");
        $(this).removeClass("hover");
        $('ul:first',this).css('visibility', 'hidden');
    	$('.dropdownName li a:first').removeClass("hoverDivName");
	
    });



	
    $("ul.dropdownService li a").hover(function(){
		$('.dropdownService li a:first').css("font-size","14px");
		$('.dropdownService li a:first').css("border","1px solid #b1d7e3");
		$('.dropdownService li ul .sub_menuService li a').css("border","1px solid #b1d7e3");
		$("#event_index_container #topHeaderRt ul.dropdownService ul li a ").css("border","none");
		$("#event_index_container #topHeaderRt ul.dropdownService ul li:first-child a").css("border-top","1px solid #B1D7E3");
		$("#event_index_container #topHeaderRt ul.dropdownService ul li:first-child a").css("margin-left","-2px");
		$(".hoverDiv").css("marginLeft","20px");
        $('.dropdownService li a:first').addClass("hoverDivService");
        $(this).addClass("hover");
        $('ul:first',this).css('visibility', 'visible');
    
    }, function(){
    	$('.dropdownService li a:first').css("border","1px solid #DBEEF4");	
		$(".dropdownService li ul .sub_menuService li a").css("border","1px solid #F7F9F8");
        $(this).removeClass("hover");
        $('ul:first',this).css('visibility', 'hidden');
    	$('.dropdownService li a:first').removeClass("hoverDivService");
	
    });



		 //  $('#GoToDivGoTo').addClass("hoverDivGoto");
    $("ul.dropdownGoToFavour li a").hover(function(){
		$('.dropdownGoToFavour li a:first').css("font-size","14px");
		$('.dropdownGoToFavour li a:first').css("border","1px solid #b1d7e3");
		$(".dropdownGoToFavour li ul .sub_menuGoToFavour li a").css("border","1px solid #F7F9F8");
		$("#event_index_container #topHeaderRt ul.dropdownGoToFavour ul li a ").css("border","none");
		//$('.dropdownGoTo li a:first').css("border-right","1px solid #b1d7e3");
	//	$('.dropdownGoTo li ul .sub_menu li').css("border-right","1px solid #b1d7e3");
    	$('#GoToDivGoToFavour').addClass("hoverDivGotoFavour");
		$('#event_index_container  ul.dropdownGoToFavour ul').css('visibility','visible');
      //  $(this).addClass("hover");
        //$('ul:first',this).css('visibility', 'visible');
    
    }, function(){
    	$('.dropdownGoToFavour li a:first').css("border","1px solid #F7F9F8");	
		$(".dropdownGoToFavour li ul .sub_menuGoToFavour li a").css("border","1px solid #F7F9F8");
        $(this).removeClass("hover");
        $('ul:first',this).css('visibility', 'hidden');
    	$('#GoToDivGoToFavour').removeClass("hoverDivGotoFavour");
    });




		 //  $('#GoToDivGoTo').addClass("hoverDivGoto");
    $("ul.dropdownGoToShared li a").hover(function(){
		$('.dropdownGoToShared li a:first').css("font-size","14px");
		$('.dropdownGoToShared li a:first').css("border","1px solid #b1d7e3");
		$(".dropdownGoToShared li ul .sub_menuGoToShared li a").css("border","1px solid #F7F9F8");
		$("#event_index_container #topHeaderRt ul.dropdownGoToShared ul li a ").css("border","none");
		//$('.dropdownGoTo li a:first').css("border-right","1px solid #b1d7e3");
	//	$('.dropdownGoTo li ul .sub_menu li').css("border-right","1px solid #b1d7e3");
    	$('#GoToDivGoToShared').addClass("hoverDivGotoShare");
		$('#event_index_container  ul.dropdownGoToShared ul').css('visibility','visible');
       // $(this).addClass("hoverDivGotoShare");
       // $('ul:first',this).css('visibility', 'visible');
    
    }, function(){
    	$('.dropdownGoToShared li a:first').css("border","1px solid #F7F9F8");	
		$(".dropdownGoToShared li ul .sub_menuGoToShared li a").css("border","1px solid #F7F9F8");
        $(this).removeClass("hover");
        $('ul:first',this).css('visibility', 'hidden');
    	$('#GoToDivGoToShared').removeClass("hoverDivGotoShare");
    });



		 //  $('#GoToDivGoTo').addClass("hoverDivGoto");
    $("ul.dropdownGoToFree li a").hover(function(){	
												 //alert("test");
		$('.dropdownGoToFree li a:first').css("font-size","14px");
		$('.dropdownGoToFree li a:first').css("border","1px solid #b1d7e3");
		$(".dropdownGoToFree li ul .sub_menuGoToFree li a").css("border","1px solid #F7F9F8");
		$("#event_index_container #topHeaderRt ul.dropdownGoToFree ul li a ").css("border","none");		
    	$('#GoToDivGoToFree').addClass("hoverDivGotoFree");
		$('#event_index_container  ul.dropdownGoToFree ul').css('visibility','visible');
        //$(this).addClass("hover");
       // $('ul:first',this).css('visibility', 'visible');
    
    }, function(){
    	$('.dropdownGoToFree li a:first').css("border","1px solid #F7F9F8");	
		$(".dropdownGoToFree li ul .sub_menuGoToFree li a").css("border","1px solid #F7F9F8");
        $(this).removeClass("hover");
        //$('ul:first',this).css('visibility', 'hidden');
    	$('#GoToDivGoToFree').removeClass("hoverDivGotoFree");
    });

$(".dottedDiv ul").hover(function(){
										   //alert("tesT");
 $("ul .sub_menuGoToShared").css("display","block");
										
    }, function(){
    });
});


  function showcolor(){
	$("#GoToDivName").css("background","#e5f4f9");
  }
    function hidecolor(){
	$("#GoToDivName").css("background","none");
  }
  
    function showcolorService(){
	$("#GoToDivService").css("background","#e5f4f9");
  }
    function hidecolorService(){
	$("#GoToDivService").css("background","none");
  }




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

    $("#ShowPop_purchase").hover(function(){
    //alert("test");
        $('#pop_purchase').addClass("dispBlock");
        $('#pop_purchase').css('visibility', 'visible');
    
    }, function(){
    
        $('#pop_purchase').removeClass("dispBlock");
        $('#pop_purchase').css('visibility', 'hidden');
    
    });
    
    $("ul.dropdown li ul li:has(ul)").find("a:first").append(" &raquo; ");

});
