// JavaScript Document


function AmSearch(){
     //
	 //document.getElementById('AmLayer_').attributes["id"].value
	 var sText = document.getElementById('AmSearchText').value;
	 var sUrl = document.getElementById('AmSearchTarget').value;
	 var sLink = '';
	 sLink = sLink + sUrl + '/?s=' + sText;
	 window.location.href=sLink;
}