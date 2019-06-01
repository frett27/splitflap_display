var AmCategoryFlag = 1;


function AmAllCategoryInit(LayerID,SubID){
	 if(AmCategoryFlag == 0){
	      document.getElementById('AmAllCategoryBg').style.display = 'none';
		  AmCategoryFlag = 1;
		  document.getElementById('AmAllCategory').style.background = '#ffffff';
		  document.getElementById('AmAllCategory').style.color = '#3C3C3C';
		  //document.getElementById('AmAllCategory').innerHTML = 'All Category';
		  return true;
	 }else{
	      document.getElementById('AmAllCategoryBg').style.display = 'block';
		  document.getElementById('AmAllCategory').style.background = '#891f1f';
		  document.getElementById('AmAllCategory').style.color = '#ffffff';
		  //document.getElementById('AmAllCategory').innerHTML = 'Click Hidden';
		  AmCategoryFlag = 0;
		  AmAllCategory(LayerID,SubID);
		  return true;
	 }
}
function AmAllCategory(LayerID,SubID){
	 //Layer
	 var ObjLayer=document.getElementsByName("AmLayer");
	 if(document.getElementById('AmLayer_' + LayerID)){
          // 
	 }else{
		  return false;
	 }
	 //alert(5);
	 var ObjLayerId = 0;
	 for(var i=0;i<ObjLayer.length;i++){
	 	 if(i <= LayerID){
	 	 	 document.getElementById('AmLayer_' + i).style.display = 'block';
			 var ObjLayerId = i;
	 	 }else{
			 document.getElementById('AmLayer_' + i).style.display = 'none';
	 	 }
	 }
	 var ObjSub=document.getElementsByName("AmSub_" + ObjLayerId);
	 for(var i=0;i<ObjSub.length;i++){
		 //
		 if(ObjSub[i].attributes["id"].value && ObjSub[i].attributes["id"].value == ('AmSub_' + ObjLayerId + '_' + SubID)){
			 ObjSub[i].style.display = 'block';
			 if(LayerID > 0){
			      var ParentID = 'Cat_' + SubID;//AmSub_1_3
				  var ParentTop = document.getElementById(ParentID).offsetTop;
				  //alert(ParentTop);
				  document.getElementById('AmLayer_' + LayerID).style.marginTop = ParentTop + 'px';
			 }
	 	 }else{
			 ObjSub[i].style.display = 'none';
		 }
	 }		 
	 //alert(5);
	 return false;
}





function mousePosition(ev){
     if(ev.pageX || ev.pageY){//firefox¡¢chromeµÈä¯ÀÀÆ÷
          return {x:ev.pageX,y:ev.pageY};
     }
     return {// IEä¯ÀÀÆ÷
          x:ev.clientX + document.body.scrollLeft - document.body.clientLeft,
          y:ev.clientY + document.body.scrollTop - document.body.clientTop
     };
}
function mouseMove(ev){
     var DivTop = document.getElementById('AmAllCategoryBg').offsetTop;
     var DivHeight = document.getElementById('AmAllCategoryBg').offsetHeight;
     ev = ev || window.event;
     var mousePos = mousePosition(ev);
	 if(mousePos.y < (DivTop + DivHeight)){
	      //show
	 }else{
	      //hidden
	      document.getElementById('AmAllCategoryBg').style.display = 'none';
		  AmCategoryFlag = 1;
		  document.getElementById('AmAllCategory').style.background = '#ffffff';
		  document.getElementById('AmAllCategory').style.color = '#3C3C3C'; 
	 }
}
 document.onmousemove = mouseMove;



