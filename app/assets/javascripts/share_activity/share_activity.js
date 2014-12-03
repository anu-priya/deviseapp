$(document).ready(function(){
    initARC('share_activity','altCheckboxOn','altCheckboxOff');
});
function addcontactnames(){		
    var val = '';
    var i;
    var send_to = $('#send_to').val();
	
    if(!$('#createactivity #contactList input[type="checkbox"]').is(":checked") ){
        alert("Please choose atleast one contact");
        return false;
    }
    else{
        var contactListLen=$('#createactivity #contactList label').length;
        for(i=1;i<=contactListLen;i++){
            if($('#createactivity #c'+i).is(":checked")){
                var send_list1 = $('#createactivity #contactList #c'+i).val()
				
                //var send_list2 = send_to.split(', ');
                //alert(send_list2);
				
                /*for(j=0;j<send_list2.length;j++){
					var list_detail = send_list2[j];
					if(list_detail!='' && send_list1 != list_detail){	
						alert(list_detail+":"+send_list1);																	
						val+=send_list1;
						val+=', ';												
					}					
				}*/					
                val+=send_list1;
                val+=', ';
											
            }
            else{
                val+='';
            }
        }
        $('#send_to').val(val);
        $('#dispContactDiv').removeClass('dispBlock');
        return true;
    }
}
function closedispContactDiv(){
    $('#dispContactDiv').removeClass('dispBlock');
}
function displayToList(){
    $('#dispContactDiv').toggleClass('dispBlock');
    $('#dispTimeDiv').removeClass('dispBlock');
}

function addcontactnames(){	
    var val = '';
    var i;
    $('#send_to').val('');
    $('#to_list').html('');
	
    if(!$('#createactivity #contactList input[type="checkbox"]').is(":checked")){
        alert("Please select minimum one contact");
        return false;
    }
    else{
        var contactListLen=$('#createactivity #contactList label').length;
        for(i=1;i<=contactListLen;i++){
            if($('#createactivity #c'+i).is(":checked")){
                val+=$('#createactivity #contactList #c'+i).val()+", ";
            }
            else{
                val+='';
            }
			
        }
        $('#send_to').val(val);
        $('#to_list').html(val);
        $('#dispContactDiv').removeClass('dispBlock');
        return true;
    }
}
function selectedContact(){	
    if($('#createactivity #contact').is(":checked")){
        $('#createactivity #contactList input[type="checkbox"]').attr('checked', true);
        $('#createactivity #contactList label').addClass('altCheckboxOn');
        $('#createactivity #contactList label').removeClass('altCheckboxOff');
    }
    else{
        $('#createactivity #contactList input[type="checkbox"]').attr('checked', false);
        $('#createactivity #contactList label').addClass('altCheckboxOff');
        $('#createactivity #contactList label').removeClass('altCheckboxOn');
    }
}
function selectedGroup(){
    if($('#createactivity #group').is(":checked")){
        $('#createactivity #contact').attr('checked', true);
        $('#createactivity .contact label').addClass('altCheckboxOn');
        $('#createactivity .contact label').removeClass('altCheckboxOff');
        $('#createactivity #groupList input[type="checkbox"]').attr('checked', true);
        $('#createactivity #groupList label').addClass('altCheckboxOn');
        $('#createactivity #groupList label').removeClass('altCheckboxOff');
        $('#createactivity #contactList input[type="checkbox"]').attr('checked', true);
        $('#createactivity #contactList label').addClass('altCheckboxOn');
        $('#createactivity #contactList label').removeClass('altCheckboxOff');
    }
    else{
        $('#createactivity #contact').attr('checked', false);
        $('#createactivity .contact label').addClass('altCheckboxOff');
        $('#createactivity .contact label').removeClass('altCheckboxOn');
        $('#createactivity #groupList input[type="checkbox"]').attr('checked', false);
        $('#createactivity #groupList label').addClass('altCheckboxOff');
        $('#createactivity #groupList label').removeClass('altCheckboxOn');
        $('#createactivity #contactList label').addClass('altCheckboxOff');
        $('#createactivity #contactList label').removeClass('altCheckboxOn');
    }
}
function selectFriends(){	
    if($('#createactivity #groupList #g1').is(":checked")){
        $('#createactivity #contactList .contactFr input[type="checkbox"]').attr('checked', true);
        $('#createactivity #contactList .contactFr label').addClass('altCheckboxOn');
        $('#createactivity #contactList .contactFr label').removeClass('altCheckboxOff');
    }
    else{
        $('#createactivity #contactList .contactFr input[type="checkbox"]').attr('checked', false);
        $('#createactivity #contactList .contactFr label').addClass('altCheckboxOff');
        $('#createactivity #contactList .contactFr label').removeClass('altCheckboxOn');
    }
}
function selectFmaily(){
    if($('#createactivity #groupList #g2').is(":checked")){
        $('#createactivity #contactList .contactFa input[type="checkbox"]').attr('checked', true);
        $('#createactivity #contactList .contactFa label').addClass('altCheckboxOn');
        $('#createactivity #contactList .contactFa label').removeClass('altCheckboxOff');
    }
    else{
        $('#createactivity #contactList .contactFa input[type="checkbox"]').attr('checked', false);
        $('#createactivity #contactList .contactFa label').addClass('altCheckboxOff');
        $('#createactivity #contactList .contactFa label').removeClass('altCheckboxOn');
    }
}
function selectOffice(){
    if($('#createactivity #groupList #g3').is(":checked")){
        $('#createactivity #contactList .contactOf input[type="checkbox"]').attr('checked', true);
        $('#createactivity #contactList .contactOf label').addClass('altCheckboxOn');
        $('#createactivity #contactList .contactOf label').removeClass('altCheckboxOff');
    }
    else{
        $('#createactivity #contactList .contactOf input[type="checkbox"]').attr('checked', false);
        $('#createactivity #contactList .contactOf label').addClass('altCheckboxOff');
        $('#createactivity #contactList .contactOf label').removeClass('altCheckboxOn');
    }
}
function selectTeam(){
    if($('#createactivity #groupList #g4').is(":checked")){
        $('#createactivity #contactList .contactTe input[type="checkbox"]').attr('checked', true);
        $('#createactivity #contactList .contactTe label').addClass('altCheckboxOn');
        $('#createactivity #contactList .contactTe label').removeClass('altCheckboxOff');
    }
    else{
        $('#createactivity #contactList .contactTe input[type="checkbox"]').attr('checked', false);
        $('#createactivity #contactList .contactTe label').addClass('altCheckboxOff');
        $('#createactivity #contactList .contactTe label').removeClass('altCheckboxOn');
    }
}

