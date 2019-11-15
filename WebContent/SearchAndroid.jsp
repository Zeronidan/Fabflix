<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>

<%
	String s = request.getParameter("val");
	String offset = request.getParameter("offset");
	String[] keywords = s.split(" ");
	String innerStr = "";
	for(int i = 0; i < keywords.length; i++){
		innerStr += "+" + keywords[i];
	}
	String query = "SELECT * FROM movies WHERE MATCH (title) AGAINST ('" + innerStr + "*' IN BOOLEAN MODE) LIMIT 10 OFFSET " + offset + ";";
	
	

	try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "mytestuser",
				"mypassword");
		PreparedStatement ps = con.prepareStatement(query);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			out.print("<li>" + rs.getString(2) + "</li>");
		}
		con.close();
	} catch (Exception e) {
		e.printStackTrace();
	}
%>