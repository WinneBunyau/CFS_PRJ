package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve payment details and the farm ID.
        String cardNumber = request.getParameter("cardNumber");
        String expiry = request.getParameter("expiry");
        String cvv = request.getParameter("cvv");
        int farmId = Integer.parseInt(request.getParameter("farmId"));
        
        // Simulate a successful payment (mockup).
        boolean paymentSuccessful = true;
        
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("farmerId") == null) {
            response.sendRedirect("login.jsp?error=Please login first");
            return;
        }
        int farmerId = (int) session.getAttribute("farmerId");
        
        if(paymentSuccessful) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "UPDATE Farms SET status = 'rented', rented_by = ? WHERE farmId = ? AND status = 'available'")) {
                ps.setInt(1, farmerId);
                ps.setInt(2, farmId);
                int rows = ps.executeUpdate();
                if(rows > 0) {
                    response.sendRedirect("farmManagement.jsp?success=Farm rented successfully");
                } else {
                    response.sendRedirect("farmManagement.jsp?error=Farm is not available");
                }
            } catch(Exception e) {
                e.printStackTrace();
                response.sendRedirect("farmManagement.jsp?error=Database error");
            }
        } else {
            response.sendRedirect("farmManagement.jsp?error=Payment failed");
        }
    }
}
