<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<TITLE>Fabflix</TITLE>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js">
<script>
	var request;
	function sendInfo() {
		var v = document.vinform.t1.value;
		var url = "autocompletion.jsp?val=" + v;

		if (window.XMLHttpRequest) {
			request = new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			request = new ActiveXObject("Microsoft.XMLHTTP");
		}

		try {
			request.onreadystatechange = getInfo;
			request.open("GET", url, true);
			request.send();
		} catch (e) {
			alert("Unable to connect to server");
		}
	}

	function getInfo() {
		if (request.readyState == 4) {
			var val = request.responseText;
			document.getElementById('amit').innerHTML = val;
		}
	}
</script>
</head>
<body>

	<!-- NAVIGATION aka just says home and shopping cart -->
	<nav class="navbar navbar-inverse">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#myNavbar">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="#">Fabflix</a>
			</div>
			<div class="collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav">
					<li class="active"><a href="#">Home</a></li>
					<!-- 
					<li><a href="browse_genre.jsp">Browse by Genre</a></li>
					<li><a href="browse_title.jsp">Browse by Title</a></li>
					 -->
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li><a href="ShoppingCart"><span
							class="glyphicon glyphicon-shopping-cart"></span> Shopping Cart</a></li>
				</ul>
			</div>
		</div>
	</nav>
	<!-- Database connecting -->
	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
		url="jdbc:mysql://localhost:3306/moviedb" user="mytestuser"
		password="mypassword" />
		
		
		
	<!--  autocompletion search -->

	<form name="vinform">
		<input type="text" name="t1" onkeyup="sendInfo()">
	</form>

	<ol id="amit" list-style-type=none>
	</ol>

	<!--  End autocompletion search -->
	
	
		
	<!-- Searching -->
	<FORM ACTION="movieList.jsp" METHOD="GET">
		<h1>Search by any attributes!</h1>
		Title: <INPUT TYPE="TEXT" NAME="title"><BR> Year: <INPUT
			TYPE="TEXT" NAME="year"><BR> Director: <INPUT
			TYPE="TEXT" NAME="director"><BR> First Name: <INPUT
			TYPE="TEXT" NAME="fname"><BR> Last Name: <INPUT
			TYPE="TEXT" NAME="lname"><BR> <INPUT TYPE="SUBMIT"
			VALUE="Submit">
	</FORM>
	<!-- search by letter -->
	

	
<div class="container">
  <div class="btn-toolbar">
    <div class="btn-group btn-group-sm">
      <c:set var="alphabet" value="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" />
	<c:forEach var="i" begin="0" end="${fn:length(alphabet)-1}" step="1">
		<a href="movieList.jsp?firstLetter=${fn:substring(alphabet, i, i+1)}"
			name="firstLetter"><button class="btn btn-default">${fn:substring(alphabet, i, i+1)}</button></a>
	</c:forEach>
    </div>
  </div>
</div>

	<!-- Search by genre -->
	<sql:query dataSource="${snapshot}" var="result">
		Select gname from genres;
	</sql:query>

	<c:forEach var="row" items="${result.rows}">
		<a href="movieList.jsp?genre=${row.gname}" name="genre">${row.gname}<br></a>
	</c:forEach>



</body>
</html>