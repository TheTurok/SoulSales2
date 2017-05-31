document.getElementById("row-specifier").addEventListener("change", function(){
	select = document.getElementById("row-specifier");
	order = document.getElementById("order-specifier");
	customers = document.getElementById("cust-table");
	states = document.getElementById("states-table");
	topkcust = document.getElementById("top-k-cust-table");
	topkstates = document.getElementById("top-k-states-table");
	if(select.options[select.selectedIndex].value == "Customers"){
		if(order.options[order.selectedIndex].value == "Alphabetical"){
			customers.style.display = "table";
			states.style.display = "none";
			topkcust.style.display = "none";
			topkstates.style.display = "none";
		}
		else {
			customers.style.display = "none";
			states.style.display = "none";
			topkcust.style.display = "table";
			topkstates.style.display = "none";
		}
	}
	else if(select.options[select.selectedIndex].value == "States"){
		if(order.options[order.selectedIndex].value == "Alphabetical"){
			customers.style.display = "none";
			states.style.display = "table";
			topkcust.style.display = "none";
			topkstates.style.display = "none";
		}
		else {
			customers.style.display = "none";
			states.style.display = "none";
			topkcust.style.display = "none";
			topkstates.style.display = "table";
		}
	}
});

document.getElementById("order-specifier").addEventListener("change", function(){
	select = document.getElementById("row-specifier");
	order = document.getElementById("order-specifier");
	customers = document.getElementById("cust-table");
	states = document.getElementById("states-table");
	topkcust = document.getElementById("top-k-cust-table");
	topkstates = document.getElementById("top-k-states-table");
	if(order.options[order.selectedIndex].value == "Top-K"){
		if(select.options[select.selectedIndex].value == "Customers"){
			customers.style.display = "none";
			states.style.display = "none";
			topkcust.style.display = "table";
			topkstates.style.display = "none";
		}
		else {
			customers.style.display = "none";
			states.style.display = "none";
			topkcust.style.display = "none";
			topkstates.style.display = "table";
		}
	}
	else if(order.options[order.selectedIndex].value == "Alphabetical"){
		if(select.options[select.selectedIndex].value == "Customers"){
			customers.style.display = "table";
			states.style.display = "none";
			topkcust.style.display = "none";
			topkstates.style.display = "none";
		}
		else {
			customers.style.display = "none";
			states.style.display = "table";
			topkcust.style.display = "none";
			topkstates.style.display = "none";
		}
	}
});