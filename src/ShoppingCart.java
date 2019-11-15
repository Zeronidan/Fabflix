
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class ShoppingCart
 */
@WebServlet("/ShoppingCart")
public class ShoppingCart extends HttpServlet {
	public ShoppingCart() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		HttpSession session = request.getSession();
		ArrayList<MovieItem> cart = (ArrayList<MovieItem>) session.getAttribute("cart");
		if (cart == null) {
			cart = new ArrayList<MovieItem>();
			session.setAttribute("cart", cart);
		}
		String id = request.getParameter("id");
		String mtitle = request.getParameter("mtitle");
		String year = request.getParameter("year");
		String director = request.getParameter("director");
		String remove = request.getParameter("remove");
		String quantity = request.getParameter("quantity");

		if (remove != "") {
			for (int i = 0; i < cart.size(); i++) {
				if (cart.get(i).getId().equalsIgnoreCase(remove)) {
					cart.remove(i);
				}
			}
		}

		if (quantity != "") {
			for (int i = 0; i < cart.size(); i++) {
				if (cart.get(i).getId().equalsIgnoreCase(id)) {
					cart.get(i).setQuantity(quantity);
				}
			}
		}

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		String docType = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 ";
		out.println(docType + "<HTML>\n<HEAD><TITLE>Fabflix</Title>");
		out.println(
				"<link rel=\"stylesheet\"href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css\">");
		out.println(
				"<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js\"></HEAD>\n");
		out.println("<Body><nav class=\"navbar navbar-inverse\">");
		out.println("<div class=\"container-fluid\">");
		out.println("<div class=\"navbar-header\">");
		out.println(
				"<button type=\"button\" class=\"navbar-toggle\" data-toggle=\"collapse\" data-target=\"#myNavbar\">");
		out.println(
				"<span class=\"icon-bar\"></span> <span class=\"icon-bar\"></span> <span class=\"icon-bar\"></span> </button>");
		out.println("<a class=\"navbar-brand\" href=\"main.jsp\">Fabflix</a></div>");
		out.println("<div class=\"collapse navbar-collapse\" id=\"myNavbar\">");
		out.println("<ul class=\"nav navbar-nav\">");
		out.println("<li class=\"active\"><a href=\"main.jsp\">Home</a></li></ul>");
		out.println("<ul class=\"nav navbar-nav navbar-right\">");
		out.println(
				"<li><a href=\"ShoppingCart\"><spanclass=\"glyphicon glyphicon-shopping-cart\"></span> Shopping Cart</a></li></ul></div></div> </nav>");

		synchronized (cart) {
			if (mtitle != null) {
				MovieItem item = new MovieItem(id, mtitle, year, director);
				cart.add(item);
			}
			if (cart.size() == 0) {
				out.println("Your cart is empty.");
				out.println("<a href=\"main.jsp\"> Return to Main Page</a>");

			} else {

				out.println(
						"<div class=\"container\"><table id=\"cart\" class=\"table\"><thead><td><h2>Movie</h2></td><td><h2>Quantity</h2></td></thead><tbody>");
				for (int i = 0; i < cart.size(); i++) {
					out.println("<tr><div class=\"row\">");
					out.println("<td>");
					out.println("<h4>" + cart.get(i).getTitle() + "</h4>");
					out.println("<p>ID: " + cart.get(i).getId() + "</p>");
					out.println("<p>YEAR: " + cart.get(i).getYear() + "</p>");
					out.println("<p>DIRECTOR: " + cart.get(i).getDirector() + "</p>");
					out.println(
							"</td><td><form action=\"servlet/UpdateQuantity\"><input type=\"hidden\" name=\"id\" value=\""
									+ cart.get(i).getId()
									+ "\"><input type=\"number\" name=\"quantity\" min=\"1\" value=\""
									+ cart.get(i).getQuantity()
									+ "\"></td><td><input class=\"btn btn-info\" type=\"submit\" value=\"Update\">");

					out.println(
							"<a class=\"btn btn-danger\" href=\"?remove=" + cart.get(i).getId() + "\">Delete</a></td>");
					out.println("</tr>");

				}
				out.println("</tbody>");
				out.println("<tfoot>");
				out.println(
						"<tr><td><a href=\"javascript:window.history.back()\" class=\"btn btn-warning\">Back</a></td>");
				out.println("<td><a href=\"checkoutForm.html\" class=\"btn btn-success btn-block\">Checkout</a></td>");
				out.println("</tfoot>");

			}
		}
		out.println("</BODY></HTML>");
		// response.getWriter().append("Served at:
		// ").append(request.getContextPath());
	}

	// makes doPost identical to doGet
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

}
