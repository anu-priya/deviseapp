function DetectTab(e) {
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==9){
        document.getElementById("dropDownDiv").style.display="none";
    }
}
function selectUsrKeyDown(e){
    var KeyCode = (e.which) ? e.which : e.keyCode
    if(KeyCode==32 || KeyCode==13){    	
        document.getElementById("dropDownDiv").style.display="block";
        flag=false;
    }		
}
function accDiv(idinc){
    $('#nested .accDiv span').removeClass('setImgIconSelected');
    $('#nested .accDiv span').addClass('setImgIconNormal');
			
    var acc_cn = $('#nested #acc'+idinc+' h3').attr('class');
    if(acc_cn == "acc-selected"){
        $('#nested #acc'+idinc+' span').toggleClass('setImgIconSelected');
    }
}

    function deselectCheckbox(){
        var category_length = $('#nested h3').size();
	
        for(var i=1;i<=category_length;i++){
            var acc_cn = $('#nested #acc'+i+' h3').attr('class');
		
            if(acc_cn == "acc-selected"){
                $('#nested .acc'+i+' input').attr('checked', false);
                $('#nested .acc'+i+' label').addClass('altCheckboxOff');
                $('#nested .acc'+i+' label').removeClass('altCheckboxOn');
                $('#nested .acc'+i+' .addFavText').html('');
            //$('#nested .acc'+i+' .addFavText img').attr('src','');
            }
        }
    }
    function selectCheckbox(){
        alert("4");
	
        var category_length = $('#nested  h3').size();
	
        for(var i=1;i<=category_length;i++){
            var acc_cn = $('#nested #acc'+i+' h3').attr('class');
            if(acc_cn == "acc-selected"){
                $('#nested .acc'+i+' input').attr('checked', true);
                $('#nested .acc'+i+' label').addClass('altCheckboxOn');
                $('#nested .acc'+i+' label').removeClass('altCheckboxOff');
                $('#nested .acc'+i+' .addFavText').html('Remove from favorite bar');
                $('#nested .acc'+i+' .addFavText').html('<img src="/assets/event_index/add_to_favor.png" width="102" height="26" />');
            }
        }
	
    }

