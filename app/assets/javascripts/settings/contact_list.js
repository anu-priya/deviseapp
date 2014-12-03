//~ $(document).ready(function(){
    //~ initARC('settings','altCheckboxOn','altCheckboxOff');
//~ });
function closedispContactDiv(){
    $('#dispContactDiv').removeClass('dp');
}
function displayToList(){
    $('#dispContactDiv').toggleClass('dp');
    $('#dispTimeDiv').removeClass('dp');
}

function addcontactnames(contact_id,id,hid){
    var val = '';
    var i;
    if(!$("#fam_contact #contactList_"+contact_id+" input[type='checkbox']").is(":checked")){
        //alert("Please select minimum one contact");
        $(".flash-message").html("You have not selected any contacts. Please select a contact to proceed.");
        var win=$(window).width();
        var con=$(".flash_content").width();
        var leftvalue=((win/2)-(con/2))
        $(".flash_content").css("left",leftvalue+"px");
        $(".flash_content").css("top","67px");
        $('.flash_content').fadeIn().delay(10000).fadeOut();
        return false;
    }
    else{

        var contactListLen=$("#fam_contact #contactList_"+contact_id+" label").length;
	    var id = $("#fam_contact #contactList_"+contact_id+" input[type='checkbox']").attr("id");
	    var s1=id.split("c");
	   var total_length=(parseInt(s1[1])+parseInt(contactListLen))-1;	   
        for(i=s1[1];i<=total_length;i++){
            if($('#fam_contact #c'+i).is(":checked")){
                val+=$("#fam_contact #contactList_"+contact_id+" #c"+i).val()+",";
            }
            else{
                val+='';
            }
			
        }	//changed the famti contact hidden values to contact_id values
		//~ document.getElementById("famti_contact").value=val;
	//alert(document.getElementById("contact_id_"+hid).value);
	      // alert(hid);
		document.getElementById("contact_id_"+hid).value=val;
		$('#dispContactDiv_'+contact_id).removeClass('dp');
		$(".dispContactDiv_"+contact_id).removeClass('dp');
		$("dispContactDiv").removeClass('dp');
		document.getElementById("dropDownDiv5").style.display="none";
		document.getElementById("dropDownDiv6").style.display="none";
		document.getElementById("dropDownDiv7").style.display="none";
		//~ //document.getElementById("dropDownDiv8").style.display="none";
		//~ document.getElementById("dropDownDiv9").style.display="none";
		//~ document.getElementById("dropDownDiv10").style.display="none";
		//~ document.getElementById("dropDownDiv11").style.display="none";
		//~ document.getElementById("dropDownDiv12").style.display="none";
		//~ document.getElementById("dropDownDiv13").style.display="none";
		$('.f_contacts').css("border","1px solid #fff");
		$('.f_contacts').css("background","none");
        return true;
    }
}
function selectedContact(cid){		
      if($("#fam_contact #contact"+cid+" ").is(":checked")){
        $("#fam_contact #contactList_"+cid+" input[type='checkbox']").attr("checked", true);
        $("#fam_contact #contactList_"+cid+" label").addClass("altCheckboxOn");
        $("#fam_contact #contactList_"+cid+" label").removeClass("altCheckboxOff");
    }
    else{
        $("#fam_contact #contactList_"+cid+" input[type='checkbox']").attr("checked", false);
        $("#fam_contact #contactList_"+cid+" label").addClass("altCheckboxOff");
        $("#fam_contact #contactList_"+cid+" label").removeClass("altCheckboxOn");
    }
}
function selectedGroup(){
    if($('#fam_contact #group').is(":checked")){
       // $('#fam_contact #contact').attr('checked', true);
        //$('#fam_contact .contact label').addClass('altCheckboxOn');
       // $('#fam_contact .contact label').removeClass('altCheckboxOff');
        $('#fam_contact #groupList input[type="checkbox"]').attr('checked', true);
        $('#fam_contact #groupList label').addClass('altCheckboxOn');
        $('#fam_contact #groupList label').removeClass('altCheckboxOff');
        //$('#fam_contact #contactList input[type="checkbox"]').attr('checked', true);
        //$('#fam_contact #contactList label').addClass('altCheckboxOn');
        //$('#fam_contact #contactList label').removeClass('altCheckboxOff');
    }
    else{
        //$('#fam_contact #contact').attr('checked', false);
       // $('#fam_contact .contact label').addClass('altCheckboxOff');
       // $('#fam_contact .contact label').removeClass('altCheckboxOn');
        $('#fam_contact #groupList input[type="checkbox"]').attr('checked', false);
        $('#fam_contact #groupList label').addClass('altCheckboxOff');
        $('#fam_contact #groupList label').removeClass('altCheckboxOn');
       // $('#fam_contact #contactList label').addClass('altCheckboxOff');
       // $('#fam_contact #contactList label').removeClass('altCheckboxOn');
    }
}
function selectFriends(){	
    if($('#fam_contact #groupList #g1').is(":checked")){
        $('#fam_contact #contactList .contactFr input[type="checkbox"]').attr('checked', true);
        $('#fam_contact #contactList .contactFr label').addClass('altCheckboxOn');
        $('#fam_contact #contactList .contactFr label').removeClass('altCheckboxOff');
    }
    else{
        $('#fam_contact #contactList .contactFr input[type="checkbox"]').attr('checked', false);
        $('#fam_contact #contactList .contactFr label').addClass('altCheckboxOff');
        $('#fam_contact #contactList .contactFr label').removeClass('altCheckboxOn');
    }
}
function selectFmaily(){
    if($('#fam_contact #groupList #g2').is(":checked")){
        $('#fam_contact #contactList .contactFa input[type="checkbox"]').attr('checked', true);
        $('#fam_contact #contactList .contactFa label').addClass('altCheckboxOn');
        $('#fam_contact #contactList .contactFa label').removeClass('altCheckboxOff');
    }
    else{
        $('#fam_contact #contactList .contactFa input[type="checkbox"]').attr('checked', false);
        $('#fam_contact #contactList .contactFa label').addClass('altCheckboxOff');
        $('#fam_contact #contactList .contactFa label').removeClass('altCheckboxOn');
    }
}
function selectOffice(){
    if($('#fam_contact #groupList #g3').is(":checked")){
        $('#fam_contact #contactList .contactOf input[type="checkbox"]').attr('checked', true);
        $('#fam_contact #contactList .contactOf label').addClass('altCheckboxOn');
        $('#fam_contact #contactList .contactOf label').removeClass('altCheckboxOff');
    }
    else{
        $('#fam_contact #contactList .contactOf input[type="checkbox"]').attr('checked', false);
        $('#fam_contact #contactList .contactOf label').addClass('altCheckboxOff');
        $('#fam_contact #contactList .contactOf label').removeClass('altCheckboxOn');
    }
}
function selectTeam(){
    if($('#fam_contact #groupList #g4').is(":checked")){
        $('#fam_contact #contactList .contactTe input[type="checkbox"]').attr('checked', true);
        $('#fam_contact #contactList .contactTe label').addClass('altCheckboxOn');
        $('#fam_contact #contactList .contactTe label').removeClass('altCheckboxOff');
    }
    else{
        $('#fam_contact #contactList .contactTe input[type="checkbox"]').attr('checked', false);
        $('#fam_contact #contactList .contactTe label').addClass('altCheckboxOff');
        $('#fam_contact #contactList .contactTe label').removeClass('altCheckboxOn');
    }
}

