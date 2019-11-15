<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Browse By Title</title>
</head>
<body>
<a href = "ShoppingCart">shopping cart</a>

	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
		url="jdbc:mysql://localhost:3306/moviedb" user="mytestuser"
		password="mypassword" />
		
	<c:set var="alphabet" value ="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"/>
	<%-- 
	<c:forEach var="i" begin="0" end="${fn:length(str)}" step="1">
    	<c:out value="${fn:substring(str, i, i + 1)}" />     
	</c:forEach>
	--%>
	<c:forEach var="i" begin="0" end="${fn:length(alphabet)}" step="1">
		<a href="movieList.jsp?firstLetter=${fn:substring(alphabet, i, i+1)}" name="firstLetter">${fn:substring(alphabet, i, i+1)}<br></a>
	</c:forEach>
	<%-- 
	<sql:query dataSource="${snapshot}" var="result">
		Select title from movies;
	</sql:query>

	<c:forEach var="row" items="${result.rows}">
		<a href="movieList.jsp?title=${row.title}" name="mtitle">${row.title}<br></a>
	</c:forEach>
	--%>
	
	

</body>
</html>