document.getElementById("row-specifier").addEventListener("change", function(){
	select = document.getElementById("row-specifier");
	order = document.getElementById("order-specifier");
	customers = document.getElementById("cust-table");
	states = document.getElementById("states-table");
	topkcust = document.getElementById("top-k-cust-table");
	topkstates = document.getElementById("top-k-states-table");
	custform = document.getElementById("abc-cust-form");
	stateform = document.getElementById("abc-state-form");
	prodform = document.getElementById("abc-prod-form");
	kcustform = document.getElementById("k-cust-form");
	kstateform = document.getElementById("k-state-form");
	kprodform = document.getElementById("k-prod-form");
	if(select.options[select.selectedIndex].value == "Customers"){
		if(order.options[order.selectedIndex].value == "Alphabetical"){
			customers.style.display = "table";
			states.style.display = "none";
			topkcust.style.display = "none";
			topkstates.style.display = "none";
			custform.style.display = "block";
			stateform.style.display = "none";
			prodform.style.display = "block";
			kcustform.style.display = "none";
			kstateform.style.display = "none";
			kprodform.style.display = "none";
		}
		else {
			customers.style.display = "none";
			states.style.display = "none";
			topkcust.style.display = "table";
			topkstates.style.display = "none";
			custform.style.display = "none";
			stateform.style.display = "none";
			prodform.style.display = "none";
			kcustform.style.display = "block";
			kstateform.style.display = "none";
			kprodform.style.display = "block";
		}
	}
	else if(select.options[select.selectedIndex].value == "States"){
		if(order.options[order.selectedIndex].value == "Alphabetical"){
			customers.style.display = "none";
			states.style.display = "table";
			topkcust.style.display = "none";
			topkstates.style.display = "none";
			custform.style.display = "none";
			stateform.style.display = "block";
			prodform.style.display = "block";
			kcustform.style.display = "none";
			kstateform.style.display = "none";
			kprodform.style.display = "none";
		}
		else {
			customers.style.display = "none";
			states.style.display = "none";
			topkcust.style.display = "none";
			topkstates.style.display = "table";
			custform.style.display = "none";
			stateform.style.display = "none";
			prodform.style.display = "none";
			kcustform.style.display = "none";
			kstateform.style.display = "block";
			kprodform.style.display = "block";
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
	custform = document.getElementById("abc-cust-form");
	stateform = document.getElementById("abc-state-form");
	prodform = document.getElementById("abc-prod-form");
	kcustform = document.getElementById("k-cust-form");
	kstateform = document.getElementById("k-state-form");
	kprodform = document.getElementById("k-prod-form");
	if(order.options[order.selectedIndex].value == "Top-K"){
		if(select.options[select.selectedIndex].value == "Customers"){
			customers.style.display = "none";
			states.style.display = "none";
			topkcust.style.display = "table";
			topkstates.style.display = "none";
			custform.style.display = "none";
			stateform.style.display = "none";
			prodform.style.display = "none";
			kcustform.style.display = "block";
			kstateform.style.display = "none";
			kprodform.style.display = "block";
		}
		else {
			customers.style.display = "none";
			states.style.display = "none";
			topkcust.style.display = "none";
			topkstates.style.display = "table";
			custform.style.display = "none";
			stateform.style.display = "none";
			prodform.style.display = "none";
			kcustform.style.display = "none";
			kstateform.style.display = "block";
			kprodform.style.display = "block";
		}
	}
	else if(order.options[order.selectedIndex].value == "Alphabetical"){
		if(select.options[select.selectedIndex].value == "Customers"){
			customers.style.display = "table";
			states.style.display = "none";
			topkcust.style.display = "none";
			topkstates.style.display = "none";
			custform.style.display = "block";
			stateform.style.display = "block";
			prodform.style.display = "none";
			kcustform.style.display = "none";
			kstateform.style.display = "none";
			kprodform.style.display = "none";
		}
		else {
			customers.style.display = "none";
			states.style.display = "table";
			topkcust.style.display = "none";
			topkstates.style.display = "none";
			custform.style.display = "none";
			stateform.style.display = "block";
			prodform.style.display = "block";
			kcustform.style.display = "none";
			kstateform.style.display = "none";
			kprodform.style.display = "none";
		}
	}
});