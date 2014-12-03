function validateName(elementValue){
    var alphaExp = /^[a-zA-Z ]*$/;
    return alphaExp.test(elementValue);
}
function validateNumber(elementValue){
    var alphaExp = /^[0-9]+$/;
    return alphaExp.test(elementValue);
}
function validatPrize(elementValue){
    var alphaExp = /^(\d+(?:[\.]\d{0,15})?)$/;
    return alphaExp.test(elementValue);
}
/*function validatePhoneNumber(elementValue){
    var alphaExp = /^((?:[\+]\d{1})?)$/;
    return alphaExp.test(elementValue);
}*/
//web address validation
function ValidateWebsiteAddress() {
    var url = document.getElementById('website').value;
    var urlIsValid = ValidateWebAddress(url);      //alert("Website Address is valid?:" +urlIsValid );
    return urlIsValid ;
}
function ValidateWebAddress(url) {
    var webSiteUrlExp = /^(([\w]+:)?\/\/)?(([\d\w]|%[a-fA-f\d]{2,2})+(:([\d\w]|%[a-fA-f\d]{2,2})+)?@)?([\d\w][-\d\w]{0,253}[\d\w]\.)+[\w]{2,4}(:[\d]+)?(\/([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)*(\?(&?([-+_~.\d\w]|%[a-fA-f\d]{2,2})=?)*)?(#([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)?[ ]*$/;
    if (webSiteUrlExp.test(url)) {
        return true;
    }
    else {
        return false;
    }
}
function validateBrowse(){
    var fup = document.getElementById('photo1');
    var fileName = fup.value;
    var ext = fileName.substring(fileName.lastIndexOf('.') + 1);
    if(ext == "gif" || ext == "GIF" || ext == "JPEG" || ext == "jpeg" || ext == "jpg" || ext == "JPG" || ext == "png" || ext == "PNG")
    {
        //errorFlag = false;
        return true;
    }
    else
    {
        $('#activity_photo_error').parent().css("display","block");
        $("#photo1").css("border","1px solid #fc8989");
        $('#activity_photo_error').html('Please select an valid image');
        return false;
    }
}
function editValidateBrowse(){
    var fup = document.getElementById('photo1');
    var fileName = fup.value;
    var ext = fileName.substring(fileName.lastIndexOf('.') + 1);
    if(ext == "gif" || ext == "GIF" || ext == "JPEG" || ext == "jpeg" || ext == "jpg" || ext == "JPG" || ext == "png" || ext == "PNG")
    {
        //errorFlag = false;
        return true;
    }
    else
    {
        $('#activity_photo_error').parent().css("display","block");
        $("#photo1").css("border","1px solid #fc8989");
        $('#activity_photo_error').html('Please select an valid image');
        return false;
    }
}
function validateCorrectEmail(elementValue){
    var emailPattern = /^([a-zA-Z0-9]+([~{|}._-]{0,1}[a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+([._-]{0,1}[a-zA-Z0-9]+)*)+(?:[\w-]+\.)*\w[\w-]{0,66})\.([a-zA-Z]{2,3}(?:\.[a-zA-Z]{2,3})?)$/;
    return emailPattern.test(elementValue);
}