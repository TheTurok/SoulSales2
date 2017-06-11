
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*, java.sql.*, java.lang.Integer" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@page import="java.sql.Connection"%>
<%@page import="ucsd.shoppingApp.*"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
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

	<!-- ULTIMATE QUERY GIVEN -->	
	<sql:query dataSource="${db}" var="theQuery">
		with overall_table as 
(select pc.product_id,c.state_id,sum(pc.price*pc.quantity) as amount  
 	from products_in_cart pc  
 	inner join shopping_cart sc on (sc.id = pc.cart_id and sc.is_purchased = true)
 	inner join product p on (pc.product_id = p.id) -- add category filter if any
 	inner join person c on (sc.person_id = c.id)
 	group by pc.product_id,c.state_id
),
top_state as
(select state_id, sum(amount) as dollar from (
	select state_id, amount from overall_table
	UNION ALL
	select id as state_id, 0.0 as amount from state
	) as state_union
 group by state_id order by dollar desc 
),
top_n_state as 
(select row_number() over(order by dollar desc) as state_order, state_id, dollar from top_state
),
top_prod as 
(select product_id, sum(amount) as dollar from (
	select product_id, amount from overall_table
	UNION ALL
	select id as product_id, 0.0 as amount from product
	) as product_union
group by product_id order by dollar desc 
),
top_n_prod as 
(select row_number() over(order by dollar desc) as product_order, product_id, dollar from top_prod
)
select ts.state_id, s.state_name, tp.product_id, pr.product_name, COALESCE(ot.amount, 0.0) as cell_sum, ts.dollar as state_sum, tp.dollar as product_sum
	from top_n_prod tp CROSS JOIN top_n_state ts 
	LEFT OUTER JOIN overall_table ot 
	ON ( tp.product_id = ot.product_id and ts.state_id = ot.state_id)
	inner join state s ON ts.state_id = s.id
	inner join product pr ON tp.product_id = pr.id
	order by ts.state_order, tp.product_order
		
	</sql:query>
	
	
	
	<!-- TOP K PRODUCT QUERY -->
	<sql:query dataSource="${db}" var="topkprod">
with overall_table as 
(select pc.product_id,c.state_id,sum(pc.price*pc.quantity) as amount  
 	from products_in_cart pc  
 	inner join shopping_cart sc on (sc.id = pc.cart_id and sc.is_purchased = true)
 	inner join product p on (pc.product_id = p.id) -- add category filter if any
 	inner join person c on (sc.person_id = c.id)
 	group by pc.product_id,c.state_id
),
top_state as
(select state_id, sum(amount) as dollar from (
	select state_id, amount from overall_table
	UNION ALL
	select id as state_id, 0.0 as amount from state
	) as state_union
 group by state_id order by dollar desc
),
top_n_state as 
(select row_number() over(order by dollar desc) as state_order, state_id, dollar from top_state
),
top_prod as 
(select product_id, sum(amount) as dollar from (
	select product_id, amount from overall_table
	UNION ALL
	select id as product_id, 0.0 as amount from product
	) as product_union
group by product_id order by dollar desc 
) 
select row_number() over(order by dollar desc) as product_order, product_id, dollar from top_prod
	</sql:query>
	

	
	<!-- STATE K Query -->
	<sql:query dataSource = "${db}" var = "state_k_query">
		with overall_table as 
(select pc.product_id,c.state_id,sum(pc.price*pc.quantity) as amount  
 	from products_in_cart pc  
 	inner join shopping_cart sc on (sc.id = pc.cart_id and sc.is_purchased = true)
 	inner join product p on (pc.product_id = p.id) -- add category filter if any
 	inner join person c on (sc.person_id = c.id)
 	group by pc.product_id,c.state_id
),
top_state as
(select state_id, sum(amount) as dollar from (
	select state_id, amount from overall_table
	UNION ALL
	select id as state_id, 0.0 as amount from state
	) as state_union
 group by state_id order by dollar desc
)
select row_number() over(order by dollar desc) as state_order, state_id, dollar from top_state
	</sql:query>
	
	

	
	
	
	<table id="theTable" >
		<tr>
			<td style= "font-weight: bold">XXXXXXXXXX</td>
			<c:forEach var="topkprod_row" items="${topkprod.rows}">
				<sql:query dataSource="${db}" var="state_name">
					select product_name from product
					where product.id = ?
					<sql:param value="${topkprod_row.product_id}"></sql:param>
				</sql:query>
				<c:forEach var="state_name_row" items="${state_name.rows}">
					<td style= "font-weight: bold"><c:out value="${fn:substring(state_name_row.product_name,0,10)}"></c:out></td>
				</c:forEach>
			</c:forEach>
		</tr>
		<c:forEach var="state_rows" items="${state_k_query.rows}">
			<tr>
					<sql:query dataSource="${db}" var = "state_finder">
						select state_name from state
						where state.id = ?
						<sql:param value = "${state_rows.state_id }"/>
					</sql:query>
					<c:forEach var="s_f" items="${state_finder.rows}">
						<td style= "font-weight: bold"><c:out value="${s_f.state_name}"/></td>
					</c:forEach>
			</tr>
		</c:forEach>
	</table> 
	
	
	
	
	
	
	
<script type="text/javascript" src="./js/salesAnalytics.js"></script>	


</body>
</html>