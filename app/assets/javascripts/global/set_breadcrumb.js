//get current location
$(document).ready(function(){
	/*if (document.cookie.indexOf("current_city") >= 0) {			
	}
	else {*/
	domain=window.location.hostname;
		var d = new Date();
		d.setTime(d.getTime() + (1*24*60*60*1000));
		var expires = "expires="+d.toUTCString();
	if (typeof geoip_city != 'undefined') {
		document.cookie = "current_city="+geoip_city()+"; " + expires + ";path=/;domain="+domain;
	 }
	//}
});
