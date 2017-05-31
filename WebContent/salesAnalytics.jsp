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
	
	<c:if test = "${empty offset}">
		<c:set var="offset" scope="session" value="0" />
	</c:if>
	
	<c:if test= "${param.next_customers == 'Next 20 Customers'}">
		<c:set var="offset" scope="session" value= "${offset+20}" />
	</c:if>
	
	<c:if test = "${empty offstate}">
		<c:set var="offstate" scope="session" value="0" />
	</c:if>
	
	<c:if test= "${param.next_states == 'Next 20 States'}">
		<c:set var="offstate" scope="session" value= "${offstate+20}" />
	</c:if>
	
	<c:if test = "${empty offsetk}">
		<c:set var="offsetk" scope="session" value="0" />
	</c:if>
	
	<c:if test= "${param.next_customersk == 'Next 20 Customers'}">
		<c:set var="offsetk" scope="session" value= "${offsetk+20}" />
	</c:if>
	
	<c:if test = "${empty offstatek}">
		<c:set var="offstatek" scope="session" value="0" />
	</c:if>
	
	<c:if test= "${param.next_statesk == 'Next 20 States'}">
		<c:set var="offstatek" scope="session" value= "${offstatek+20}" />
	</c:if>
	
	<c:if test = "${empty offproduct}">
		<c:set var="offproduct" scope="session" value="0" />
	</c:if>
	
	<c:if test= "${param.next_products == 'Next 10 Products'}">
		<c:set var="offproduct" scope="session" value= "${offproduct+10}" />
	</c:if>
	<c:if test = "${empty offproductk}">
		<c:set var="offproductk" scope="session" value="0" />
	</c:if>
	
	<c:if test= "${param.next_productsk == 'Next 10 Products'}">
		<c:set var="offproductk" scope="session" value= "${offproductk+10}" />
	</c:if>

	
	<!-- Create row specifier dropdown -->
	<select name="rows" id="row-specifier">
		<option value="Customers" selected>Customers</option>
		<option value="States" >States</option>
	</select>
	
	<!-- Create order specifier drop-down -->
	<select name="order" id="order-specifier">
		<option value="Alphabetical">Alphabetical</option>
		<option value="Top-K">Top-K</option>
	</select>
	
	<!-- Query for alphabetical product abc list/names -->
	<sql:query dataSource="${db}" var="p_name_abc">
		SELECT id, product_name FROM product ORDER BY product_name LIMIT 10 OFFSET ?;
		<sql:param value  = "${Integer.parseInt(offproduct)}" />
	</sql:query>
	
	<!-- Query for alphabetical states abc list/names -->
	<sql:query dataSource="${db}" var="s_name_abc">
		SELECT id, state_name FROM state ORDER BY state_name LIMIT 20 OFFSET ?;
		<sql:param value  = "${Integer.parseInt(offstate)}" />
	</sql:query>
	
 	<!-- Query for alphabetical customer abc names -->
	<sql:query dataSource="${db}" var="c_name_abc">
		SELECT id, person_name FROM person ORDER BY person_name LIMIT 20 OFFSET ?;
		<sql:param value  = "${Integer.parseInt(offset)}" />
	</sql:query>
	
	
	<!-- Query for top-k product names -->
	<sql:query dataSource="${db}" var="p_name_k">
		select product_id, product_name, sum(products_in_cart.price*quantity) as total from products_in_cart
		left outer join shopping_cart on products_in_cart.cart_id = shopping_cart.id
		left outer join person on person.id = shopping_cart.person_id
		left outer join product on product.id = products_in_cart.product_id
		group by product_id, product_name
		order by total DESC
		LIMIT 10 OFFSET ?;
		<sql:param value  = "${Integer.parseInt(offproductk)}" />
	</sql:query>
	
	<!-- Query for top-k customer names -->
	<sql:query dataSource="${db}" var="c_name_k">
		select person.id, person_name, sum(price*quantity) as total from products_in_cart
		left outer join shopping_cart on products_in_cart.cart_id = shopping_cart.id
		left outer join person on person.id = shopping_cart.person_id
		group by person.id
		order by total DESC
		LIMIT 20 OFFSET ?;
		<sql:param value  = "${Integer.parseInt(offsetk)}" />
	</sql:query>
	
	<!-- Query for top-k states names -->
	<sql:query dataSource="${db}" var="s_name_k">
		select state.id, state_name, sum(price*quantity) as total from products_in_cart
		left outer join shopping_cart on products_in_cart.cart_id = shopping_cart.id
		left outer join person on person.id = shopping_cart.person_id
        left outer join state on state.id = person.state_id
		group by state.id
		order by total DESC
		LIMIT 20 OFFSET ?;
		<sql:param value  = "${Integer.parseInt(offstatek)}" />
	</sql:query>
	
  	<!-- Sales Analytics Table product k / state k -->
	<table id="top-k-states-table" style="display: none;">
		<tr>
			<td>XXXXX</td>
			<c:forEach var="p_name_row" items="${p_name_k.rows}">
				<td><c:out value="${p_name_row.product_name}" /></td>
			</c:forEach>
		</tr>
		<c:forEach var="s_name_row" items="${s_name_k.rows}">
			<tr>
				<td><c:out value="${s_name_row.state_name}"/></td>
				<c:forEach var="p_name_row" items="${p_name_k.rows}">
					<sql:query dataSource="${db}" var="calc_sum">
						select state_id, product_id, sum(price*quantity) as total from products_in_cart
						left outer join shopping_cart on products_in_cart.cart_id = shopping_cart.id
						left outer join person on person.id = shopping_cart.person_id
						where product_id = ? and state_id = ? and is_purchased = true
						group by state_id, product_id;
						<sql:param value="${p_name_row.product_id}"></sql:param>
						<sql:param value="${s_name_row.id}"></sql:param>
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
	<!-- END OF - Sales Analytics Table product k / state k -->
	

	
	
 	<!-- Sales Analytics Table product k / customer k -->
	<table id="top-k-cust-table" style="display: none;">
		<tr>
			<td>XXXXX</td>
			<c:forEach var="p_name_row" items="${p_name_k.rows}">
				<td><c:out value="${p_name_row.product_name}" /></td>
			</c:forEach>
		</tr>
		<c:forEach var="c_name_row" items="${c_name_k.rows}">
			<tr>
				<td><c:out value="${c_name_row.person_name}"/></td>
				<c:forEach var="p_name_row" items="${p_name_k.rows}">
					<sql:query dataSource="${db}" var="calc_sum">
						select person.id, product_id, sum(price*quantity) as total from products_in_cart
						left outer join shopping_cart on products_in_cart.cart_id = shopping_cart.id
						left outer join person on person.id = shopping_cart.person_id
						where product_id = ? and person.id = ? and is_purchased = true
						group by person.id, product_id;
						<sql:param value="${p_name_row.product_id}"></sql:param>
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
	<!-- END OF - Sales Analytics Table product k / customer k -->
	 
	

 	<!-- Sales Analytics Table product abc / customer abc -->
	<table id="cust-table">
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
						where product_id = ? and person.id = ? and is_purchased = true
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
	<!-- END OF - Sales Analytics Table product abc / customer abc -->
	
	

	<!-- Sales Analytics Table product abc / state abc -->
	<table id="states-table" style="display: none;">
		<tr>
			<td>XXXXX</td>
			<c:forEach var="p_name_row" items="${p_name_abc.rows}">
				<td><c:out value="${p_name_row.product_name}" /></td>
			</c:forEach>
		</tr>
		<c:forEach var="s_name_row" items="${s_name_abc.rows}">
			<tr>
				<td><c:out value="${s_name_row.state_name}"/></td>
				<c:forEach var="p_name_row" items="${p_name_abc.rows}">
					<sql:query dataSource="${db}" var="calc_sum">
						select state_id, product_id, sum(price*quantity) as total from products_in_cart
						left outer join shopping_cart on products_in_cart.cart_id = shopping_cart.id
						left outer join person on person.id = shopping_cart.person_id
                        where product_id = ? and state_id = ? and is_purchased = true
						group by state_id, product_id
						<sql:param value="${p_name_row.id}"></sql:param>
						<sql:param value="${s_name_row.id}"></sql:param>
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
	<!-- END OF - Sales Analytics Table product abc / state abc -->  
	
	
	<c:if test = "${not (c_name_abc.rowCount < 20 )}">
		<form>
			<input type="submit" name="next_customers" value="Next 20 Customers"/>
		</form>
	</c:if>
	<c:if test = "${not (s_name_abc.rowCount < 20 )}">
		<form>
			<input type="submit" name="next_states" value="Next 20 States"/>
		</form>
	</c:if>
	<c:if test = "${not (c_name_k.rowCount < 20)}">
		<form>
			<input type="submit" name="next_customersk" value="Next 20 Customers"/>
		</form>
	</c:if>
	<c:if test = "${not (s_name_k.rowCount < 20)}">
		<form>
			<input type="submit" name="next_statesk" value="Next 20 States"/>
		</form>
	</c:if>

		<form>
			<input type="submit" name="next_products" value="Next 10 Products"/>
		</form>
		<form>
			<input type="submit" name="next_productsk" value="Next 10 Products"/>
		</form>


	
	
<script type="text/javascript" src="./js/salesAnalytics.js"></script>	


</body>
</html>