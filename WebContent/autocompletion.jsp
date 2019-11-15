<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>

<%
	String s = request.getParameter("val");
	String[] keywords = s.split(" ");
	String innerStr = "";
	int len = 0;
	for(int i = 0; i < keywords.length; i++){
		if (keywords.length == 1){
			innerStr += "+" + keywords[i] + "*";
		} else {
			if (i < keywords.length - 1) {
				innerStr += "+\"" + keywords[i] + "\" ";
			} else {
				innerStr += "+" + keywords[i] + "*";
			}
		}
	}
	String query = "SELECT * FROM movies WHERE MATCH (title) AGAINST ('" + innerStr + "' IN BOOLEAN MODE) LIMIT 5;";
	

	try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "mytestuser",
				"mypassword");
		PreparedStatement ps = con.prepareStatement(query);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			out.print("<li><a href=\"movie.jsp?title=" + rs.getString(2) + "\">" + rs.getString(2) + "</a></li>");
		}
		con.close();
	} catch (Exception e) {
		e.printStackTrace();
	}
%>