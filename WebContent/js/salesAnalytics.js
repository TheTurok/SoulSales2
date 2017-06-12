
function theRefresh()
{
	var xmlHttp;
	  xmlHttp=new XMLHttpRequest();
	  var responseHandler = function(text)
	   {
	    if(xmlHttp.readyState==4)
	     { 
	       var text = xmlHttp.responseText;
	       text = text.split(',');
	       console.log(text);
	       for (i = 0; i < text.length-1; i++){
	    	   var cell = document.getElementById(text[i]);
	    	   if(cell != null){
	    		   console.log("appeared");
	    		   document.getElementById(text[i]).style.backgroundColor = "red";
	    	   }
	    	   else{
	    		   console.log("null");
	    	   }
	       }
	     }
	   }

	  xmlHttp.onreadystatechange = responseHandler ;

	  xmlHttp.open("GET","change.jsp",true);
	  xmlHttp.send(null);
}


function theRun(){
	location.reload(true);
}