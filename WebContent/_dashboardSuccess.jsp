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
</head>
<body>

	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
		url="jdbc:mysql://localhost:3306/moviedb" user="mytestuser"
		password="mypassword" />

	<!-- Add a star to the data base -->
	<FORM ACTION="/Fabflix/servlet/AddStar" METHOD="POST">
		<h1>Add an star to the database:</h1>
		First Name: <INPUT TYPE="TEXT" NAME="fname"><BR>
		Last Name: <INPUT TYPE="TEXT" NAME="lname"><BR>
		
		<INPUT TYPE="SUBMIT" VALUE="Submit">
	</FORM>
	
	<!-- Adding a single star or single genre to movie -->
	<FORM ACTION="/Fabflix/servlet/AddMovie" METHOD="POST">
		<h1>Add a single star or single genre to a movie:</h1>
		Movie name: <INPUT TYPE="TEXT" NAME="mtitle"><BR>
		Movie year: <INPUT TYPE="TEXT" NAME="yr"><BR>
		Star's ID: <INPUT TYPE="TEXT" NAME="s_id"><BR>
		Star's first name: <INPUT TYPE="TEXT" NAME="fname"><BR>
		Star's last name: <INPUT TYPE="TEXT" NAME="lname"><BR>
		Genre ID: <INPUT TYPE="TEXT" NAME="g_id"><BR>
		Genre name: <INPUT TYPE="TEXT" NAME="gname"><BR>
		<INPUT TYPE="SUBMIT" VALUE="Submit">
	</FORM>
	
	<!-- Metadata -->
	<FORM ACTION="/Fabflix/servlet/Metadata" METHOD="POST">
		<INPUT TYPE="SUBMIT" VALUE="Print metadata of the database">
	</FORM>	

</body>
</html>