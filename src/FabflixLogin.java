
/* A servlet to display the contents of the MySQL movieDB database */

import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FabflixLogin extends HttpServlet {
	public String getServletInfo() {
		return "Servlet connects to MySQL database and displays result of a SELECT";
	}

	// Use http GET

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		PrintWriter out = response.getWriter();
		String loginUser = "mytestuser";
		String loginPasswd = "mypassword";
		String loginUrl = "jdbc:mysql://localhost:3306/moviedb";

		String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
		System.out.println("gRecaptchaResponse=" + gRecaptchaResponse);
		boolean valid = VerifyUtils.verify(gRecaptchaResponse);
		if (!valid) {
			response.sendRedirect("/Fabflix/LoginFailure.html");
			return;
		}

		response.setContentType("text/html"); // Response mime type
//
//		// Output stream to STDOUT
//		PrintWriter out = response.getWriter();
		try {
			// Class.forName("org.gjt.mm.mysql.Driver");
			Class.forName("com.mysql.jdbc.Driver").newInstance();

			Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
			// Declare our statement

			PreparedStatement statement;
			String email = request.getParameter("email");
			String password = request.getParameter("password");
			String query = "SELECT * from customers where email = ? AND pswd = ?";
			statement = dbcon.prepareStatement(query);
			statement.setString(1, email);
			statement.setString(2, password);

			// Perform the query
			ResultSet rs = statement.executeQuery();
			if (!rs.isBeforeFirst()) {
				out.println("<HTML><HEAD><TITLE>Login Error</TITLE></HEAD>");
				out.println("<BODY><H1>Incorrect Password and/or Email</H1>");
				// return;
			} else {
				response.sendRedirect("/Fabflix/main.jsp");
			}

			rs.close();
			
			statement.close();
			dbcon.close();
		} catch (SQLException ex) {
			while (ex != null) {
				System.out.println("SQL Exception:  " + ex.getMessage());
				ex = ex.getNextException();
			} // end while
		} // end catch SQLException

		catch (java.lang.Exception ex) {
			out.println("<HTML>" + "<HEAD><TITLE>" + "MovieDB: Error" + "</TITLE></HEAD>\n<BODY>"
					+ "<P>SQL error in doGet: " + ex.getMessage() + "</P></BODY></HTML>");
			return;
		}
		out.close();
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		doGet(request, response);
	}

}
