package servlet;

import db.DBConnection;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/UpdateToolServlet")
public class UpdateToolServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int toolId = Integer.parseInt(request.getParameter("toolId"));
        String toolName = request.getParameter("tool_name");
        String toolType = request.getParameter("tool_type");
        String rentalDuration = request.getParameter("rental_duration");
        BigDecimal rentalAmt = new BigDecimal(request.getParameter("rental_amt"));
        String status = request.getParameter("status");
 
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE Tools SET tool_name=?, tool_type=?, rental_duration=?, rental_amt=?, status=? WHERE toolId=?")) {
            ps.setString(1, toolName);
            ps.setString(2, toolType);
            ps.setString(3, rentalDuration);
            ps.setBigDecimal(4, rentalAmt);
            ps.setString(5, status);
            ps.setInt(6, toolId);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("adminToolManagement.jsp?success=Tool is updated");
    }
}
