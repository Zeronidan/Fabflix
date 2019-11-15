import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;

public class UpdateQuantity extends HttpServlet {
	public String getServletInfo() {
		return "";
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		HttpSession session = request.getSession();
		ArrayList<MovieItem> cart = (ArrayList<MovieItem>) session.getAttribute("cart");
		if (cart == null) {
			cart = new ArrayList<MovieItem>();
			session.setAttribute("cart", cart);
		}

		String[] ids = request.getParameterValues("id");
		String[] quantities = request.getParameterValues("quantity");
		for (int i = 0; i < ids.length; i++) {
			if (cart.get(i).getId().equalsIgnoreCase(ids[i])) {
				cart.get(i).setQuantity(quantities[i]);
			}
		}
		response.sendRedirect("/Fabflix/ShoppingCart");
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		doGet(request, response);
	}

}
