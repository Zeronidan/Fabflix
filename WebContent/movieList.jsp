<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<TITLE>Fabflix</TITLE>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js">
<link rel="stylesheet" type="text/css" href="hoverBox.css">
</head>
<body>

	<!-- NAV BAR -->
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
	<%-- SET UP DATABASE CONNECTION --%>
	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
		url="jdbc:mysql://localhost:3306/moviedb" user="mytestuser"
		password="mypassword" />

	<%-- 
	VARIABLES 
	
	the equivalent to request.getparameter 
	var: what it's going to be called here
	value ${param.___what ever you called it here__}
	--%>

	<c:set var="firstLetter" value="${param.firstLetter}" scope="session" />
	<c:set var="mgenre" value="${param.genre}" scope="session" />
	<c:set var="title" value="${param.title}" scope="session" />
	<c:set var="year" value="${param.year}" scope="session" />
	<c:set var="director" value="${param.director}" scope="session" />
	<c:set var="fname" value="${param.fname}" scope="session" />
	<c:set var="lname" value="${param.lname}" scope="session" />
	<c:set var="titleNum" value="0" scope="session" />
	
	

	<c:set var="query"
		value="SELECT distinct m.id, m.title, m.yr, 
	m.director FROM movies m, stars_in_movies sm, stars s WHERE " />

	<%--SORT Vars--%>
	<%
		request.setAttribute("origin", request.getRequestURL());
	%>
	<c:set var="origquery" value="${pageContext.request.queryString}" />
	<c:set var="sortType" value="${param.sortType}" scope="session" />

	<%-- Pagination Var --%>
	<c:set var="perPage" value="${param.perPage}" scope="session" />



	<%-- Search--%>
	<%-- Title --%>
	<c:if test="${not empty title}">
		<%--movie id --%>
		<c:set var="query" value="${query} m.title LIKE '%${title}%' AND" />
	</c:if>
	<%-- Year --%>
	<c:if test="${not empty year}">
		<c:set var="query" value="${query} m.yr LIKE '%${year}%' AND" />
	</c:if>
	<%-- Director --%>
	<c:if test="${not empty director}">
		<c:set var="query"
			value="${query} m.director LIKE '%${director}%' AND" />
	</c:if>
	<%-- First Name --%>
	<c:if test="${not empty fname}">
		<c:set var="query" value="${query} s.first_name LIKE '%${fname}%' AND" />
	</c:if>
	<%-- Last Name --%>
	<c:if test="${not empty lname}">
		<c:set var="query" value="${query} s.last_name LIKE '%${lname}%' AND" />
	</c:if>
	<%-- First and Last Name --%>
	<c:if test="${not empty fname || not empty lname}">
		<c:set var="query"
			value="${query} m.id = sm.movie_id AND sm.star_id = s.id AND" />
	</c:if>

	<!-- HTML SEARCH AND ENTRY LIMITING -->

	<p>Sort by:</p>
	<form
		action="movieList.jsp?title=${title}&year=${year}&director=${director}&fname=${fname}&lname=${lname}&genre=${mgenre}&firstLetter=${firstLetter}&perPage=${perPage}"
		METHOD="POST">
		<input type="radio" name="sortType" value="title" checked>Title<br>
		<input type="radio" name="sortType" value="yr">Year<br> <input
			type="submit" value="Sort!"><br> <br>
	</form>

	<%-- entries per page --%>
	View
	<form
		action="movieList.jsp?title=${title}&year=${year}&director=${director}&fname=${fname}&lname=${lname}&genre=${mgenre}&firstLetter=${firstLetter}&sortType=${sortType}"
		METHOD="POST">

		<select name="perPage">
			<option value="10">10</option>
			<option value="25">25</option>
			<option value="50">50</option>
			<option value="100">100</option>
		</select> entries per page <input type="submit">
	</form>

	<%-- PAGINATION --%>
	<c:if test="${empty perPage}">
		<c:set var="perPage" value="10" />
	</c:if>
	<c:set var="currentPage" value="${param.page}" />
	<c:if test="${empty currentPage}">
		<c:set var="currentPage" value="1" />
	</c:if>
	<c:set var="offsetVal" value="${(currentPage - 1) * perPage}" />

	<%-- Finalizing Search Query --%>
	<c:if
		test="${not empty title || not empty year || not empty director || not empty fname || not empty lname}">
		<c:set var="end" value="${fn:length(query)}" />
		<c:set var="query" value="${fn:substring(query, 0, end-4)}" />

		<c:if test="${not empty sortType}">
			<c:set var="query" value="${query} ORDER BY ${sortType}" />
		</c:if>

		<c:set var="query" value="${query} LIMIT ${perPage} " />
		<c:if test="${offsetVal > '0'}">
			<c:set var="query"
				value="${query} OFFSET ${(currentPage - 1) * perPage}" />
		</c:if>
		<sql:query dataSource="${snapshot}" var="result" sql="${query}">
		</sql:query>
	</c:if>



	<%-- Browsing by Genres --%>
	<c:if test="${not empty mgenre}">
		<c:set var="query"
			value="SELECT distinct * FROM genres_in_movies gm, movies m WHERE gm.movie_id = m.id AND gm.genre_id IN 
					(SELECT id FROM genres WHERE gname = '${mgenre}') " />

		<c:if test="${not empty sortType}">
			<c:set var="query" value="${query}ORDER BY m.${sortType}" />
		</c:if>

		<c:set var="query" value="${query} LIMIT ${perPage}" />
		<c:if test="${offsetVal > '0'}">
			<c:set var="query"
				value="${query} OFFSET ${(currentPage - 1) * perPage}" />
		</c:if>
		<sql:query dataSource="${snapshot}" var="result" sql="${query}">
		</sql:query>

	</c:if>

	<%--Browsing by Titles (First Letter)--%>
	<c:if test="${not empty firstLetter}">
		<c:set var="query"
			value="SELECT * FROM movies m WHERE title LIKE '${firstLetter}%' " />
		<c:if test="${not empty sortType}">
			<c:set var="query" value="${query}ORDER BY m.${sortType}" />
		</c:if>

		<c:set var="query" value="${query} LIMIT ${perPage}" />
		<c:if test="${offsetVal > '0'}">
			<c:set var="query"
				value="${query} OFFSET ${(currentPage - 1) * perPage}" />
		</c:if>
		<sql:query dataSource="${snapshot}" var="result" sql="${query}">
		</sql:query>

	</c:if>


	<%-- After running a query getting a result (either from search, browse by genre, or browse by title), print all the information!
	All result queries are able to be passed into this for each to print the movie list --%>
	<c:forEach var="row" items="${result.rows}">

		<c:set var="movieID" value="${row.id}" />
		<c:set var="movieTitle" value="${row.title}" />
		<c:set var="movieYear" value="${row.yr}" />
		<c:set var="movieDirector" value="${row.director}" />
		<c:set var="titleNum" value="${titleNum+1}" />
		

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

		<%--HTML --%>
		<div class="container-fluid">

			<div id="movieAndDetails">
				<h2>
					<a href="movie.jsp?title=${row.title}"><span id="titleLink" class="titleLink" onmouseover="displayBox(${titleNum})" onmouseout="hideBox(${titleNum})">${row.title}</span></a>
				</h2>
				<div id="box${titleNum}" class="box" onmouseover="displayBox(${titleNum})" onmouseout="hideBox(${titleNum})">
					<p>ID: ${row.id}</p>
					<p>Year: ${row.yr}</p>
					<p>Director: ${row.director}</p>
					<img src="${row.banner_url}">
					<p>Trailer: ${row.trailer_url}</p>
					<a
						href="ShoppingCart?id=${movieID}&mtitle=${movieTitle}&year=${movieYear}&director=${movieDirector}">Add
						to Cart</a>
				</div>
			</div>
			
			<script>
				function displayBox(titleNum){
					var box = document.getElementById("box"+titleNum);
					box.style.display="block";
						$(box).mouseout(function() {
							 box.style.display="none";
							});
				}
				function hideBox(titleNum){
					var box = document.getElementById("box"+titleNum);
					box.style.display="none";
				}

			</script>


			<div class="row">
				<div class="col-sm-4">
					<p>ID: ${row.id}</p>
					<p>Year: ${row.yr}</p>
					<p>Director: ${row.director}</p>
					<a
						href="ShoppingCart?id=${movieID}&mtitle=${movieTitle}&year=${movieYear}&director=${movieDirector}">Add
						to Cart</a>
				</div>
				<div class="col-sm-4">
					<p>Star List:</p>
					<ul>
						<c:forEach var="row3" items="${starResult.rows}">
							<li><a
								href="stars.jsp?first=${row3.first_name }&last=${row3.last_name}">${row3.first_name}
									${row3.last_name}</a></li>
						</c:forEach>
					</ul>
				</div>
				<div class="col-sm-4">
					<p>Genre List:</p>
					<ul>
						<c:forEach var="row2" items="${genreResult.rows}">
							<li>${row2.gname}</li>
						</c:forEach>
					</ul>
				</div>
			</div>
		</div>

	</c:forEach>

	<c:set var="url" value="${ pageContext.request.queryString}" />


	<c:if test="${currentPage != '1'}">
		<a
			href="movieList.jsp?title=${title}&year=${year}&director=${director}&fname=${fname}&lname=${lname}&genre=${mgenre}&firstLetter=${firstLetter}&page=${currentPage - 1}&sortType=${sortType}&perPage=${perPage}">previous</a>

	</c:if>
	<%-- needs to stop having currentPage when current page is greater than total possible pages --%>
	<a
		href="movieList.jsp?title=${title}&year=${year}&director=${director}&fname=${fname}&lname=${lname}&genre=${mgenre}&firstLetter=${firstLetter}&page=${currentPage + 1}&sortType=${sortType}&perPage=${perPage}">next</a>

</body>
</html>