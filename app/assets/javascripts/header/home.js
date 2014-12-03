
var inc=0,total_img=3,refreshIntervalId,mytime,mytimeplay;
function preload_image(arrayOfImages) {
    $(arrayOfImages).each(function(){
        $('<img/>')[0].src = this;       
    });
}
preload_image([
    '/assets/loading_small.gif'
    
]);
  $(function(){
    
    $('.videoChg').click(function(){
      var vv =$('.videoChg').index(this);
      if (vv==0) {
	$('#videoplayerhm img').hide();
        $('.videoChg:eq('+(vv+1)+') img').attr('src','/assets/landing/Provider_normal.png');
        $('.videoChg:eq('+(vv)+') img').attr('src','/assets/landing/Parent_select.png');
        $('#videoplayerhm').html('<iframe width="393" height="247" src="//www.youtube.com/embed/XQj0hdpvdA8?autohide=1&rel=0" frameborder="0" allowfullscreen></iframe>');
      }else if (vv==1) {
        $('.videoChg:eq('+(vv-1)+') img').attr('src','/assets/landing/Parent_normal.png');
        $('.videoChg:eq('+(vv)+') img').attr('src','/assets/landing/Provider_select.png');
        $('#videoplayerhm').html('<iframe width="393" height="247" src="//www.youtube.com/embed/J143fxG7lz0?autohide=1&rel=0" frameborder="0" allowfullscreen></iframe>');
      }else{
        $('.videoChg:eq('+(0)+') img').attr('src','/assets/landing/Parent_select.png');
        $('.videoChg:eq('+(1)+') img').attr('src','/assets/landing/Provider_normal.png');
        $('#videoplayerhm').html('<iframe width="393" height="247" src="//www.youtube.com/embed/XQj0hdpvdA8?autohide=1&rel=0" frameborder="0" allowfullscreen></iframe>');
      }
    });
    
    $('.videoPlay').click(function(){
	$('#videoplayerhm img').hide();
	$('#videoplayerhm').html('<iframe width="393" height="247" src="//www.youtube.com/embed/XQj0hdpvdA8?autohide=1&rel=0&autoplay=1" frameborder="0" allowfullscreen></iframe>');
    });
    
      //#total_img=$(".blogDesign .blog").size();      
       for(cnt=1;cnt<total_img;cnt++){
          $(".blog:eq("+cnt+")").css("display","none");
          $(".blueDot:eq("+cnt+")").css({'border':' 1px solid #AED7E9','background':'#AED7E9'});
       }
       clearInterval(mytimeplay);
       mytime=setInterval ( "doSomething()", 5000 );
       
});
function doSomething(){
       $(".blog:eq("+inc+")").fadeOut(700);
       $(".blueDot:eq("+inc+")").css({'border':' 1px solid #AED7E9','background':'#AED7E9'});
       inc++;
       if(inc>=total_img)
       inc=0;
       $(".blog:eq("+inc+")").fadeIn(3000);         
       $(".blueDot:eq("+inc+")").css({'border':' 1px solid #76BDDB','background':'#76BDDB'});        
}

function doSomethingplay(){
	inc=inc;
	$(".blog:eq("+inc+")").fadeOut(700);	
	$(".blueDot:eq("+inc+")").css({'border':' 1px solid #AED7E9','background':'#AED7E9'});
	inc++;
	if(inc>=total_img)
	inc=0;
	$(".blog:eq("+inc+")").fadeIn(3000);
	$(".blueDot:eq("+inc+")").css({'border':' 1px solid #76BDDB','background':'#76BDDB'}); 
}

function pause()
{
	clearInterval(mytime);
	clearInterval(mytimeplay);
}
function resume()
{
	clearInterval(mytime);
	clearInterval(mytimeplay);
	mytime=setInterval ( "doSomething()", 5000 );
}
function play(number)
{ 
	clearInterval(mytime);
	inc=number;
	for(cnt=0;cnt<total_img;cnt++){
		$(".blog:eq("+cnt+")").css("display","none");		
		$(".blueDot:eq("+cnt+")").css({'border':' 1px solid #AED7E9','background':'#AED7E9'});
	}
	
	$(".blog:eq("+inc+")").fadeIn(3000);  	
	$(".blueDot:eq("+inc+")").css({'border':' 1px solid #76BDDB','background':'#76BDDB'}); 	

	id=inc;
	if(id==total_img){	
		inc=0;
	}
	if(id<0 && id<total_img){
		inc=parseInt(id)+parseInt(1);
	}

	//mytimeplay=setInterval ( "doSomethingplay('"+inc+"')", 5000 );
	
}