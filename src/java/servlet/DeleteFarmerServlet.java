package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import db.DBConnection;

//@WebServlet("/DeleteFarmerServlet")
public class DeleteFarmerServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int farmerId = Integer.parseInt(request.getParameter("id"));

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM Farmers WHERE farmerId=?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, farmerId);
            ps.executeUpdate();

            response.sendRedirect("farmerManagement.jsp?success=deleted");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("farmerManagement.jsp?error=delete_failed");
        } finally {
            try { if (ps != null) ps.close(); if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
