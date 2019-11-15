
import java.io.IOException;
import java.io.PrintWriter;
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

/**
 * Servlet implementation class Search
 */
@WebServlet("/Search")
public class Search extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Search() {
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
		// response.getWriter().append("Served at:
		// ").append(request.getContextPath());
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
			// Declare our statement
			Statement statement = dbcon.createStatement();
			Statement statement2 = dbcon.createStatement();
			Statement statement3 = dbcon.createStatement();
			boolean specified = false;
			String title = request.getParameter("title");
			String year = request.getParameter("year");
			String director = request.getParameter("director");
//			String fname = request.getParameter("fname");
//			String lname = request.getParameter("lname");
			String query = "SELECT * FROM movies m WHERE ";

			if (title != null && !title.isEmpty()) {
				specified = true;
				query = query + "title LIKE '%" + title + "%' AND ";
			}
			if (year != null && !year.isEmpty()) {
				specified = true;
				query = query + "yr LIKE '%" + year + "%' AND ";
			}
			if (director != null && !director.isEmpty()) {
				specified = true;
				query = query + "director LIKE '%" + director + "%' AND ";
			}

			if (query.substring(query.length() - 4).equalsIgnoreCase("AND ")) {
				query = query.substring(0, query.length() - 4);
			}

			// Perform the query

			if (!specified) {
				out.println("<HTML><HEAD><TITLE>Search Error</TITLE></HEAD>");
				out.println("<BODY><H1>No attributes were specified</H1>");
				// return;
			} else {
				ResultSet rs = statement.executeQuery(query);
				out.println("<HTML><HEAD><TITLE>Search Success!</TITLE></HEAD>");
				out.println("<BODY><H1>Yay you put stuff in!</H1>");

				out.println("<p>Searching results for");
				if (title != null && !title.isEmpty()) {
					out.println(" Title: " + title);
				}
				if (year != null && !year.isEmpty()) {
					out.println(" Year: " + year);
				}
				if (director != null && !director.isEmpty()) {
					out.println(" Director: " + director);
				}
				// ADD MORE HERE
				out.println("</p>");
				if (!rs.isBeforeFirst()) {
					out.println("<p>No results found!</p>");
				} else {
					// Start printing table
					out.println("<TABLE border>");
					// NEED TO ADD GENRES AND STARS (RN ONLY USING MOVIE TABLE)
					// TITLE AND STARS SHOULD BE HYPERLINKED? - piazza
					out.println("<tr>" + "<td>" + "ID" + "</td>" + "<td>" + "Title" + "</td>" + "<td>" + "Year"
							+ "</td>" + "<td>" + "Director" + "</td>" + "<td>" + "Genres" + "</td>" + "<td>" + "Stars"
							+ "</td>" + "</tr>");
					while (rs.next()) {
						String m_ID = rs.getString("id");
						String m_title = rs.getString("title");
						String m_year = rs.getString("yr");
						String m_director = rs.getString("director");
						System.out.println("TESTING " + m_ID + " " + m_title + " " + m_year + " " + m_director);

						String queryGenres = "SELECT g.gname FROM movies m, genres_in_movies gm, genres g WHERE m.id = "
								+ m_ID + " AND m.id = gm.movie_id AND gm.genre_id = g.id";
						ResultSet rsGenres = statement2.executeQuery(queryGenres);
						String genre_list = getGenres(rsGenres);
						rsGenres.close();

						String queryStars = "SELECT * FROM movies m, stars_in_movies sm, stars s WHERE m.id = " + m_ID
								+ " AND m.id = sm.movie_id AND sm.star_id = s.id";
						ResultSet rsStars = statement3.executeQuery(queryStars);
						String stars_list = getStars(rsStars);
						rsStars.close();

						out.println("<tr>" + "<td>" + m_ID + "</td>" + "<td>" + m_title + "</td>" + "<td>" + m_year
								+ "</td>" + "<td>" + m_director + "</td>" + "<td>" + genre_list + "</td>" + "<td>"
								+ stars_list + "</td>" + "</tr>");
					}
					out.println("</TABLE>");
				}

				rs.close();
			}

			statement.close();
			statement2.close();
			statement3.close();
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

	private String getGenres(ResultSet r) {
		String genreStr = "";
		try {
			if (r.isBeforeFirst()) {
				while (r.next()) {
					genreStr = genreStr + r.getString("gname") + ", ";
				}
				genreStr = genreStr.substring(0, genreStr.length() - 2);
			}
		} catch (SQLException e) {
			System.out.println("genres");
			e.getMessage();
		}
		return genreStr;
	}

	private String getStars(ResultSet r) {
		String starStr = "";
		try {
			if (r.isBeforeFirst()) {
				while (r.next()) {
					starStr = starStr + r.getString("first_name") + " " + r.getString("last_name") + ", ";
				}
			}
			starStr = starStr.substring(0, starStr.length() - 2);
		} catch (SQLException e) {
			System.out.println("stars");
			e.getMessage();
		}
		return starStr;
	}

	// /**
	// * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	// response)
	// */
	// protected void doPost(HttpServletRequest request, HttpServletResponse
	// response) throws ServletException, IOException {
	// // TODO Auto-generated method stub
	// doGet(request, response);
	// }

}
