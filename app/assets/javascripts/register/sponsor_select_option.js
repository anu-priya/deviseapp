$(document).ready(function(){
	dropDown_sponsor();

});

$('body').click(function(){
    dropDown_sponsor();
});
var flagSpo1=false;
var flagSpo2=false;
var flagSpo3=false;
var flagSpo4=false;
var flagSpo5=false;


var trigSpo1=true;
var trigSpo2=true;
var trigSpo3=true;
var trigSpo4=true;
var trigSpo5=true;



function dropDown_sponsor(){
    
     if(flagSpo1){ 
        if(trigSpo1){
            if(document.getElementById("dropDownDivSpo1").innerHTML!=''){
                document.getElementById("dropDownDivSpo1").style.display="block";
                $(".sub_category .selectBoxCity").css("background","url('/assets/create_new_activity/select_medium_bg.png') no-repeat scroll 0 0 transparent");
               document.getElementById("dropDownDivSpo2").style.display="none";
                document.getElementById("dropDownDivSpo3").style.display="none";
                document.getElementById("dropDownDivSpo4").style.display="none";
                document.getElementById("dropDownDivSpo5").style.display="none";

            }
            trigSpo1=false;           
        }
        else{
            document.getElementById("dropDownDivSpo1").style.display="none";
            trigSpo1=true;
        }
    }    
    else if(flagSpo2){ 
        if(trigSpo2){

            if(document.getElementById("dropDownDivSpo2").innerHTML!=''){
                document.getElementById("dropDownDivSpo2").style.display="block";
                document.getElementById("dropDownDivSpo1").style.display="none";
                document.getElementById("dropDownDivSpo3").style.display="none";
                document.getElementById("dropDownDivSpo4").style.display="none";
                document.getElementById("dropDownDivSpo5").style.display="none";

            }
            trigSpo2=false;           
        }
        else{
            document.getElementById("dropDownDivSpo2").style.display="none";
            trigSpo2=true;
        }
    }   
    else if(flagSpo3){ 
        if(trigSpo3){
            if(document.getElementById("dropDownDivSpo3").innerHTML!=''){
                document.getElementById("dropDownDivSpo3").style.display="block";
                document.getElementById("dropDownDivSpo1").style.display="none";
                document.getElementById("dropDownDivSpo2").style.display="none";
                document.getElementById("dropDownDivSpo4").style.display="none";
                document.getElementById("dropDownDivSpo5").style.display="none";
;
            }
            trigSpo3=false;           
        }
        else{
            document.getElementById("dropDownDivSpo3").style.display="none";
            trigSpo3=true;
        }
    }
    else if(flagSpo4){
        if(trigSpo4){
            if(document.getElementById("dropDownDivSpo4").innerHTML!=''){
                document.getElementById("dropDownDivSpo4").style.display="none";
                document.getElementById("dropDownDivSpo1").style.display="none";
                document.getElementById("dropDownDivSpo2").style.display="none";
                document.getElementById("dropDownDivSpo3").style.display="none";
                document.getElementById("dropDownDivSpo5").style.display="none";

            }
            trigSpo4=false;           
        }
        else{
            document.getElementById("dropDownDivSpo4").style.display="none";
            trigSpo4=true;
        }
    }
    else if(flagSpo5){
        if(trigSpo5){
            if(document.getElementById("dropDownDivSpo5").innerHTML!=''){
                document.getElementById("dropDownDivSpo5").style.display="none";
                $(".city .selectBoxCity").css("background","url('/assets/create_new_activity/select_medium_bg.png') no-repeat scroll 0 0 transparent");
                document.getElementById("dropDownDivSpo1").style.display="none";
                document.getElementById("dropDownDivSpo2").style.display="none";
                document.getElementById("dropDownDivSpo3").style.display="none";
                document.getElementById("dropDownDivSpo4").style.display="none";

            }
            trigSpo5=false;
        }
        else{
            document.getElementById("dropDownDivSpo5").style.display="none";
            trigSpo5=true;
        }
    }



	
    else{
        document.getElementById("dropDownDivSpo1").style.display="none";
        trigSpo1=true;
       document.getElementById("dropDownDivSpo2").style.display="none";
        trigSpo2=true;
        document.getElementById("dropDownDivSpo3").style.display="none";
        trigSpo3=true;
        document.getElementById("dropDownDivSpo4").style.display="none";
        trigSpo4=true;
        document.getElementById("dropDownDivSpo5").style.display="none";
        trigSpo5=true;
    }
    
}
function setDropDownValue1(val){	
    document.getElementById("sub_category").value=val;
    document.getElementById("field1").innerHTML=val;
    document.getElementById("dropDownDivSpo1").style.display="none";
}
function setDropDownValue2(val){
    document.getElementById("billing_type").value=val;
    document.getElementById("field2").innerHTML=val;
    document.getElementById("dropDownDivSpo2").style.display="none";
}
