document.getElementById("row-specifier").addEventListener("change", function(){
	select = document.getElementById("row-specifier");
	customers = document.getElementById("cust-table");
	states = document.getElementById("states-table");
	if(select.options[select.selectedIndex].value == "Customers"){
		customers.style.display = "table";
		states.style.display = "none";
	}
	else if(select.options[select.selectedIndex].value == "States"){
		customers.style.display = "none";
		states.style.display = "table";
	}
});