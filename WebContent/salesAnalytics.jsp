<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*, java.sql.*, java.lang.Integer" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@page import="java.sql.Connection"%>
<%@page import="ucsd.shoppingApp.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sales Analytics</title>
</head>
<body>
	<sql:setDataSource
	var="db"
	driver="org.postgresql.Driver"
	url="jdbc:postgresql://localhost:5432/SoulSales2"
	user="postgres" password="admin"
	/>
	
	<!-- Create row specifier dropdown -->
	<select name="rows">
		<option value="" disabled selected>Row Specifier</option>
		<option value="Customers">Customers</option>
		<option value="States">States</option>
	</select>
	
	<!-- Create order specifier drop-down -->
	<select name="order">
		<option value="" disabled selected>Order Specifier</option>
		<option value="Alphabetical">Alphabetical</option>
		<option value="Top-K">Top-K</option>
	</select>
	
	<!-- Query for alphabetical product list/names -->
	<sql:query dataSource="${db}" var="p_name_abc">
		SELECT id, product_name FROM product ORDER BY product_name LIMIT 10;
	</sql:query>
	
	<!-- Query for alphabetical customer names -->
	<sql:query dataSource="${db}" var="c_name_abc">
		SELECT id, person_name FROM person ORDER BY person_name LIMIT 20;
	</sql:query>
	
	<!-- Sales Analytics Table -->
	<table>
		<tr>
			<td>XXXXX</td>
			<c:forEach var="p_name_row" items="${p_name_abc.rows}">
				<td><c:out value="${p_name_row.product_name}" /></td>
			</c:forEach>
		</tr>
		<c:forEach var="c_name_row" items="${c_name_abc.rows}">
			<tr>
				<td><c:out value="${c_name_row.person_name}"/></td>
				<c:forEach var="p_name_row" items="${p_name_abc.rows}">
					<sql:query dataSource="${db}" var="calc_sum">
						select person.id, product_id, sum(price*quantity) as total from products_in_cart
						left outer join shopping_cart on products_in_cart.cart_id = shopping_cart.id
						left outer join person on person.id = shopping_cart.person_id
						where product_id = ? and person.id = ?
						group by person.id, product_id;
						<sql:param value="${p_name_row.id}"></sql:param>
						<sql:param value="${c_name_row.id}"></sql:param>
					</sql:query>
					<c:forEach var="calc_sum_row" items="${calc_sum.rows}">
						<td><c:out value="${calc_sum_row.total}"/></td>
					</c:forEach>
					<c:if test="${empty calc_sum.rows}">
						<td>0</td>
					</c:if>
				</c:forEach>
			</tr>
		</c:forEach>
	</table>
</body>
</html>