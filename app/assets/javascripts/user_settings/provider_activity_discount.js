var sel_arr=new Array();

  $(document).ready(function () {
    selectAny();
  });
  function selectall(){
	var x = $("#select_all").is(":checked")
	sel_arr.length=0;
      if(x==true){
	    $(".get_chkbx input[type='checkbox']").each(function(){
		    curr_actid=(this.id).split('_');
		    sel_arr.push(curr_actid[1]);
		    if($("#"+this.id).is(":checked")==false){
			$("#"+this.id).click();
		    }
	    });
	$("#actid_chk").val(sel_arr);
    }
    else{
	    $(".get_chkbx input[type='checkbox']").each(function(){
		    if($("#"+this.id).is(":checked")==true){
			$("#"+this.id).click();
		    }
	    });
	$("#actid_chk").val('');
    }
  }

function save_new_discount_options()
  {
    var cdisc_name= $('#create_disc_name').val();
    var er_flag;
    var errorq='';
    if(cdisc_name==""||cdisc_name=="Enter Discount type")
    {
      errorq+=' Please enter  discount code name';
      er_flag=0;
    }
    if(er_flag==0){
      $('#parent_did_type_eror').css("display","block");
      $('#dis_type_error').css("display","block");
      $('#dis_type_error').text(errorq);
    }
    else{
      var disc_quantity = $("#create_disc_quantity").is(':checked');
      var disc_valid_date = $("#create_disc_valid").is(':checked');
      var discount_price = $("#create_disc_price").is(':checked');
      var note = $("#create_disc_notes").val();
      $.ajax({
        type: "POST",
        url: "/provider_discount_type",
        data: {
          "real":"yes",
          "disc_valid_date":disc_valid_date,
          "disc_name": cdisc_name,
          "disc_quantity":disc_quantity,
          "discount_price":discount_price,
          "note":note
        },
        dataType : 'script'
      });
      $('#parent_did_type_eror').css("display","none");
      $('#dis_type_error').css("display","none");
      $('#dis_type_error').text('');

    }
  }

  function edit_provider_discount_type(id){
    $("#edit_disc_type").html("<div id='loadingmessage' style='margin-top:-424px' align='center'><img src='assets/ajax-loader.gif'/></div>")
    $("#edit_disc_creat_pop").css("display","block");
    $("#edit_disc_creat_pop").css("opacity","1");
    create_pop();
    $.ajax({
      type: "POST",
      url: "/edit_discount_type",
      data: {
        "cu_value": id
      },
      dataType : 'script'
    });
  }

 function edit_display_popup(){
    $("#edit_disc_creat_pop").css("display","block");
    $("#edit_disc_creat_pop").css("opacity","1");
    remove_pop();
  }
  
  function cancel_edit_display_popup(){
	$("#edit_disc_creat_pop").css("display","none");
	$("#edit_disc_creat_pop").css("opacity","0");
	remove_pop();
  }

  function display_popup(){
	$("#create_disc_creat_pop").css("display","block");
	$("#create_disc_creat_pop").css("opacity","1");
	create_pop();
  }

  function cancel_display_popup(){
    $("#create_disc_creat_pop").css("display","none");
    $("#create_disc_creat_pop").css("opacity","0");
    remove_pop();
  }
  
  function create_pop()
  {
	//~ $("#providerEventList").css("opacity","0.3");
	$(".wrapper_contianer_inner_login").css("opacity","0.3");
	$(".menuSelection").css("opacity","0.3");
	$(".page_header").css("opacity","0.3");
	//~ $(".provider_header").css("opacity","0.3");
  }
  
  function remove_pop()
  {
	//~ $("#providerEventList").css("opacity","1");
	$(".wrapper_contianer_inner_login").css("opacity","1");
	$(".menuSelection").css("opacity","1");
	$(".page_header").css("opacity","1");  
	//~ $(".provider_header").css("opacity","1");
  }

  function before_delete_all(mul){
   var li= mul
   var a = $("#actid_chk").val();
   page = $("#page").val();
   if (a!=""){
   pop_delete_dicount('/delete_discount?mul='+li+'&id='+a+'&page='+page+'')
    }
    else {
      pop_delete_dicount('/delete_discount?&id='+a)
    }
  }
  function before_delete(a){
    var a;
    pop_delete_dicount('/delete_discount?id='+a)
  }
  function before_shedule_delete(a){
    var a;
    pop_shedule_delete_activity('/activities/shedule_delete?id='+a)
  }
  //get mutiple check box id and store to hidden field
     //~ function getchk_discount(curr_actid,span_)
   //~ {
    //~ curr_actid = curr_actid.split("&")[0];
    //~ id_arr.push(curr_actid);
    
    //~ var classes=$("#lbl_"+curr_actid).attr("class");
    
   //~ if(classes=="altCheckboxOn")
       //~ {
        //~ for (i=0;i<=id_arr.length;i++)
        //~ {
          //~ if (curr_actid==id_arr[i])
          //~ {
            //~ id_arr.splice(i,1);
          //~ }
         //~ // alert(id_arr);
        //~ }
       //~ $("#lbl_"+curr_actid).removeClass('altCheckboxOn'); 
        //~ $("#lbl_"+curr_actid).addClass('altCheckboxOff'); 
        
       //~ }
      //~ else{
        //~ $("#lbl_"+curr_actid).removeClass('altCheckboxOff'); 
        //~ $("#lbl_"+curr_actid).addClass('altCheckboxOn'); 
       
      //~ }
      //~ values_duplicates=jQuery.unique(id_arr);
      //~ $("#actid_chk").val(values_duplicates);
   //~ }
   
   
   
   function getchk_discount()
   {
	   var id_arr= new Array();
	   	    $(".get_chkbx input[type='checkbox']").each(function(){
		   
		    if($("#"+this.id).is(":checked")==true){
			var curr_actid=(this.id).split('_')[1];
			id_arr.push(curr_actid);
		    }
	    });
	    if($(".get_chkbx input[type='checkbox']").length == id_arr.length)
	    {
		    $("#select_all").attr("checked",true);
	    }
	    else
	    {
		    $("#select_all").attr("checked",false); 
	    }
	$("#actid_chk").val(id_arr);
   }
