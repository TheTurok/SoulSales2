<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
	<sql:setDataSource
	var="db"
	driver="org.postgresql.Driver"
	url="jdbc:postgresql://localhost:5432/SoulSales2"
	user="postgres" password="admin"
	/>
	
	<sql:query var = "log" dataSource = "${db }" >
		select product_name, state_name from productsaddedLog 
        left outer join shopping_cart on productsaddedlog.cart_id = shopping_cart.id
		left outer join person on productsaddedlog.person_id = person.id 
        left outer join state on state.id = person.state_id
        left outer join products_in_cart on products_in_cart.id = productsaddedlog.cart_id
        left outer join product on product.id = products_in_cart.product_id
	</sql:query>

	<c:forEach var="log_row" items="${log.rows}">
	<c:set var = "pn" value = "${log_row.product_name }" />
	<c:set var = "sn" value = "${log_row.state_name }" />
		<%
		String name = (String)pageContext.getAttribute("pn") + (String)pageContext.getAttribute("sn");
		response.getWriter().write(name);
		response.getWriter().write(",");
		%>
	</c:forEach>