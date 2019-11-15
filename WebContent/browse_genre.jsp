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
<title>Browse By Genre</title>
</head>
<body>
<a href = "ShoppingCart">shopping cart</a>

	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
		url="jdbc:mysql://localhost:3306/moviedb" user="mytestuser"
		password="mypassword" />

	<sql:query dataSource="${snapshot}" var="result">
		Select gname from genres;
	</sql:query>

	<c:forEach var="row" items="${result.rows}">
		<a href="movieList.jsp?genre=${row.gname}" name="genre">${row.gname}<br></a>
	</c:forEach>

</body>
</html>