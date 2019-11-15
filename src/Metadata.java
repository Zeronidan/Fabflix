
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class Metadata
 */
@WebServlet("/Metadata")
public class Metadata extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Metadata() {
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
		HttpSession session = request.getSession();

		response.setContentType("text/html"); // Response mime type

		// Output stream to STDOUT
		PrintWriter out = response.getWriter();

		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();

			Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
			// Declare our statement
			Statement statement = dbcon.createStatement();

			DatabaseMetaData metadata = dbcon.getMetaData();
			ResultSet md = metadata.getTables(null, null, "%", null);
			while (md.next()) {

				// TODO: instead of console output, HTML output
				// table name: md.getString(3)
				String tableName = md.getString(3);
				out.println(String.format("Table: %s Attributes", tableName));
				out.println("<ol>");
				statement = dbcon.createStatement();
				ResultSet result = statement.executeQuery(String.format("Select * from %s", md.getString(3)));
				ResultSetMetaData rs = result.getMetaData();

				// Loop through columns to print them out along with its type
				for (int i = 1; i <= rs.getColumnCount(); i++) {
					out.println(String.format("<li>Attribute Name: %s, Attribute Type: %s</li>", rs.getColumnLabel(i),
							rs.getColumnTypeName(i)));
				}

				out.println("</ol>");
			}
			md.close();
			statement.close();
			dbcon.close();
		} catch (SQLException | InstantiationException | IllegalAccessException | ClassNotFoundException ex) {
			while (ex != null) {
				System.out.println("Exception:  " + ex.getMessage());
				//ex = ex.getNextException();
			} // end while
		}
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
