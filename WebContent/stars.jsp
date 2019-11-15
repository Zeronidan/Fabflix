<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Stars</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js">
</head>
<body>
	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
		url="jdbc:mysql://localhost:3306/moviedb" user="mytestuser"
		password="mypassword" />

	<c:set var="first" value="${param.first}" />
	<c:set var="last" value="${param.last}" />

	<sql:query dataSource="${snapshot}" var="result">
		SELECT * FROM stars WHERE first_name = ?<sql:param value="${first}" /> AND last_name =  ?<sql:param
			value="${last}" />
	</sql:query>
	<!-- NAVIGATION aka just says home and shopping cart -->
	<nav class="navbar navbar-inverse">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target="#myNavbar">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">Fabflix</a>
		</div>
		<div class="collapse navbar-collapse" id="myNavbar">
			<ul class="nav navbar-nav">
				<li class="active"><a href="main.jsp">Home</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="ShoppingCart"><span
						class="glyphicon glyphicon-shopping-cart"></span> Shopping Cart</a></li>
			</ul>
		</div>
	</div>
	</nav>

	<c:forEach var="row" items="${result.rows}">
		<c:set var="starID" value="${row.id}" />
		<%-- Star List Query --%>
		<sql:query dataSource="${snapshot}" var="movieResult">
			SELECT m.title FROM movies m, stars_in_movies sm, stars s WHERE s.id = ?
					 AND s.id = sm.star_id AND sm.movie_id = m.id
 			<sql:param value="${starID}" />
		</sql:query>


		<div class="container-fluid">
			<div class="row">
				<div class="col-sm-6">
					<img src="${row.photo_url}">
					<p>ID: ${row.id}</p>
					<p>First Name: ${row.first_name}</p>
					<p>Last Name: ${row.last_name}</p>
					<p>Day of Birth: ${row.dob}</p>
				</div>
				<div class="col-sm-6">
					<p>Movie List:</p>
					<ul>
						<c:forEach var="row3" items="${movieResult.rows}">
							<li><a href="movie.jsp?title=${row3.title}">${row3.title}
							</a></li>
						</c:forEach>
					</ul>
				</div>

			</div>
		</div>
	</c:forEach>

</body>
</html>