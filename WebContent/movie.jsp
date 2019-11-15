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
<title>Movie</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js">
</head>
<body>
	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
		url="jdbc:mysql://localhost:3306/moviedb" user="mytestuser"
		password="mypassword" />

	<c:set var="title" value="${param.title}" />

	<sql:query dataSource="${snapshot}" var="result">
		SELECT * FROM movies WHERE title = ?<sql:param value="${title}" />
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
				<li class="active"><a href="#">Home</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="ShoppingCart"><span
						class="glyphicon glyphicon-shopping-cart"></span> Shopping Cart</a></li>
			</ul>
		</div>
	</div>
	</nav>

	<c:forEach var="row" items="${result.rows}">

		<c:set var="movieID" value="${row.id}" />
		<c:set var="movieTitle" value="${row.title}" />
		<c:set var="movieYear" value="${row.year}" />
		<c:set var="movieDirector" value="${row.director}" />

		<%-- Genre List Query --%>
		<sql:query dataSource="${snapshot}" var="genreResult">
	 		SELECT g.gname FROM movies m, genres_in_movies gm, genres g WHERE m.id = ? 
		AND m.id = gm.movie_id AND gm.genre_id = g.id
	 		<sql:param value="${movieID}" />
		</sql:query>

		<%-- Star List Query --%>
		<sql:query dataSource="${snapshot}" var="starResult">
			SELECT * FROM movies m, stars_in_movies sm, stars s WHERE m.id = ?
					 AND m.id = sm.movie_id AND sm.star_id = s.id
 			<sql:param value="${movieID}" />
		</sql:query>
		<div class="container-fluid">
			<div class="row">
				<div class="col-sm-4">
					<p>ID: ${row.id}</p>
					<a href="movie.jsp?title=${row.title}">Title: ${row.title}</a>
					<p>Year: ${row.yr}</p>
					<p>Director: ${row.director}</p>
					<img src="${row.banner_url}">
					<p>Trailer: ${row.trailer_url}</p>
				</div>
				<div class="col-sm-4">

					<p>Genre List:</p>
					<ul>
						<c:forEach var="row2" items="${genreResult.rows}">
							<li>${row2.gname}</li>
						</c:forEach>
					</ul>
				</div>
				<div class="col-sm-4">

					<p>Star List:</p>
					<ul>
						<c:forEach var="row3" items="${starResult.rows}">
							<li><a
								href="stars.jsp?first=${row3.first_name}&last=${row3.last_name}">${row3.first_name}
									${row3.last_name}</a></li>
						</c:forEach>
					</ul>
				</div>
	</c:forEach>

</body>
</html>