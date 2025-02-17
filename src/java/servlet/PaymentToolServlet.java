package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/PaymentToolServlet")
public class PaymentToolServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cardNumber = request.getParameter("cardNumber");
        String expiry = request.getParameter("expiry");
        String cvv = request.getParameter("cvv");
        int toolId = Integer.parseInt(request.getParameter("toolId"));
 
        // Simulate payment (mockup)
        boolean paymentSuccessful = true;
 
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("farmerId") == null) {
            response.sendRedirect("login.jsp?error=Please login first");
            return;
        }
        int farmerId = (int) session.getAttribute("farmerId");
 
        if(paymentSuccessful) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("UPDATE Tools SET status='rented', rented_by=? WHERE toolId=? AND status='available'")) {
                ps.setInt(1, farmerId);
                ps.setInt(2, toolId);
                int rows = ps.executeUpdate();
                if(rows > 0) {
                    response.sendRedirect("farmerToolList.jsp?success=Tool rented successfully");
                } else {
                    response.sendRedirect("farmerToolList.jsp?error=Tool not available");
                }
            } catch(Exception e) {
                e.printStackTrace();
                response.sendRedirect("farmerToolList.jsp?error=Database error");
            }
        } else {
            response.sendRedirect("farmerToolList.jsp?error=Payment failed");
        }
    }
}
