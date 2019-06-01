
var AmLanguageFlag = 0;

function AmLanguageChange(DivID){
     //
	 //document.getElementById('AmAllCategoryBg').style.display = 'none';
	 
	 if(document.getElementById(DivID)){
		 
	 }else{
		return false; 
	 }
	 var Obj = document.getElementById(DivID);
	 if(AmLanguageFlag == 0){
		 AmLanguageFlag = 1;
		 Obj.style.display = 'block';
	 }else{
		 AmLanguageFlag = 0;
		 Obj.style.display = 'none';
	 }
	 //document.getElementById('AmLangIco').style.display = 'none';	 
	 if(document.getElementById('AmLangIco')){
		 
	 }else{
		return false; 
	 }
	 var Ico = document.getElementById('AmLangIco');
	 
	 var IcoTop = Ico.offsetTop;//3
	 var IcoHeight = Ico.offsetHeight;//22
	 var IcoLeft = Ico.offsetLeft;//1223
	 Obj.style.left=IcoLeft + 'px';
	 
	 
	 
	 Obj.style.top=IcoTop + IcoHeight + 'px';	 
	 
	 //alert(IcoLeft);
	 //alert(DivID);
	 
	 
	 
	 
	 
	 
	 //
}






//alert(4);








































