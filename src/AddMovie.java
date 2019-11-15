
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class AddMovie
 */
@WebServlet("/AddMovie")
public class AddMovie extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AddMovie() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		String loginUser = "mytestuser";
		String loginPasswd = "mypassword";
		String loginUrl = "jdbc:mysql://localhost:3306/moviedb";

		response.setContentType("text/html"); // Response mime type

		// Output stream to STDOUT
		PrintWriter out = response.getWriter();

		try {
			// Class.forName("org.gjt.mm.mysql.Driver");
			Class.forName("com.mysql.jdbc.Driver").newInstance();

			Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);

			String mtitle = request.getParameter("mtitle");
			String yr = request.getParameter("yr");
			String s_id = request.getParameter("s_id");
			String fname = request.getParameter("fname");
			String lname = request.getParameter("lname");
			String g_id = request.getParameter("g_id");
			String gname = request.getParameter("gname");

			String query = "{call add_movie (?, ?, ?, ?, ?, ?, ?,?)}";
			CallableStatement st = dbcon.prepareCall(query);

			st.setString(1, mtitle);
			st.setInt(2, Integer.parseInt(yr));
			st.setInt(3, Integer.parseInt(s_id));
			st.setString(4, fname);
			st.setString(5, lname);
			st.setInt(6, Integer.parseInt(g_id));
			st.setString(7, gname);

			st.registerOutParameter(8, java.sql.Types.VARCHAR);

			st.executeQuery();

//			System.out.println(st.getString(8));
			out.println("<HTML>" + "<HEAD><TITLE>" + "Fabflix Employee" + "</TITLE></HEAD>\n<BODY><center>");
			out.println("<h3> Messages </h3>");
			out.println(st.getString(8));
			out.println("<p><a href='_dashboardSuccess.jsp'>Add Another Movie or Star</a></p>");
			out.println("</center> </Body></HTML>");
			// Declare our statement
			// CallableStatement statement = null; //dbcon.createStatement();

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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
