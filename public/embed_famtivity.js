var xhr = new XMLHttpRequest();
xhr.onreadystatechange = function () { 
if (xhr.readyState == 4 && xhr.status == 200) {
	act_val=xhr.responseText;
	document.getElementById('embed_activity').innerHTML=act_val;
	
}
};
xhr.open("GET", "http://10.37.4.159:3000/activity_embed?provider_token="+provider_token, true);
xhr.send();

