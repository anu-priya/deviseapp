  $(document).ready(function () {
    $(".div_slider_post").smoothDivScroll({
      //mousewheelScrolling: "allDirections",
      // manualContinuousScrolling: true,
      //autoScrollingMode: "onStart"
      //hotSpotScrollingInterval: 45
                        
    });
  });
        
  function change_invite_detail_tabs(x){
  
    $('.single_img').removeClass('selct_borders');
    $('.div_slider_down').css('display','none');
    $('#'+x).css('display','block');
    $('.common').removeClass('document_normal_select').addClass('document_normal');
    $('.common').removeClass('photo_normal_select').addClass('photo_normal');
    $('.common_txt').removeClass('text_span_select').addClass('text_span');
    $('.'+x).removeClass(x+'_normal').addClass(x+'_normal_select');
    $('.'+x+'_txt').removeClass('text_span').addClass('text_span_select');
    $('#'+x+'_border').addClass('selct_borders');
    
  }


  function close_pop_create(fvalue){
    parent.famnetDetailPage.hide();
    parent.jumpto(fvalue);
  }
  function post_fam_comments(msg_id){
var rly_msg = $("#reply_post").val();
	if ((rly_msg!='')&&(rly_msg!='Write your comments...'))
	{
		$.ajax({
			url: '/reply_fam_post',
			data: {"message_id":msg_id,"reply_post":rly_msg},
			success: function(data){
				 if (data)
				 {
				 $('#fam_post_details').html(data);
				 $("#reply_post").val('');
				 }
			}
		});
	}
  else{
    $(".flash-message").html(" Please enter message.");
      var win=$(window).width();
      var con=$(".flash_content").width();
      var leftvalue=((win/2)-(con/2))
      $(".flash_content").css("left",leftvalue+"px");
      $(".flash_content").css("top","4%");
      $('.flash_content').fadeIn().delay(5000).fadeOut();
  }
}

function Msg_in()
    {
      var boxval=$("#reply_post").val()
      desc = boxval.replace(/^\s+|\s+$/g, "");
      if(desc == "" || desc == "Write your comments..."){
        $("#reply_post").css("color","#000")
        $("#reply_post").val("")
      }
    }

    function Msg_out()
    {
      var boxval1=$("#reply_post").val()
       if (boxval1==""){
        $("#reply_post").val("Write your comments...")
        $("#reply_post").css("color","#9C9C9C")
      }
      
    }

function attach(){
	
	 var id=$('.file_uploder').attr("id");
	$('#'+id).click();
	}

  $(document).ready(function()
  {
    $("#attach_post_files").uploadFile({
      url:"/add_to_temp",
      multiple:true,
      fileName:"myfile",
      formData: {fam_file_type: "I"},
      onSuccess:function(files,data,xhr)
      {
      }
    });
    });


    
function famPost_delete(thrd_id)
{
	
    $('html, body', window.parent.document).animate({
        scrollTop:0
    }, 'slow');
    $('#fampost_delete_alert').bPopup({
        fadeSpeed:100,
        followSpeed:100,
        modalClose: false
    });
    $("#post_delete_id").val(thrd_id);
}

function deleteFamPost(){
    var thread_id = $("#post_delete_id").val();
    $.ajax({
        url:'/delete_fam_post',
        data: {
            "thrd_id": thread_id,
        },
        dataType: 'script'
         //~ success:function(data){
        	//~ $('#fam_post_details').html(data);
		 
	//~ }
	/*	msg = data.split('$')
            if (msg[0]=='true'){
                $("#error-message").css("display","block");
                //~ window.location.reload();
		if (msg[1]=='last'){
		window.location.reload();	
		}
		else{
		window.location.href='/messages?mode='+mode+'&rep_id='+msg_id
		}
            }
        } */
    });
}
   $(document).ready(function(){
    $(".attachments").click(function(){
       var ids=$(this).attr("id");
        var id=ids.split("_");
      if($(this).hasClass("attachments_open")){
      
        $(this).removeClass("attachments_open").addClass("attachments_close");
        $("#open_div_"+id[1]).slideDown();
        $("#dwon-load-div-"+id[1]).show();
        
        
      }
      else{
         $(this).removeClass("attachments_close").addClass("attachments_open");
         $("#open_div_"+id[1]).slideUp();
         $("#dwon-load-div-"+id[1]).hide();
      }
      });
    });
    