package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/DeleteCropServlet")
public class DeleteCropServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int cropId = Integer.parseInt(request.getParameter("id"));
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM crops WHERE crop_id = ?")) {
            ps.setInt(1, cropId);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        HttpSession session = request.getSession(false);
        if(session != null && session.getAttribute("adminId") != null) {
            response.sendRedirect("adminCropManagement.jsp?success=Crop deleted");
        } else {
            response.sendRedirect("farmerCropManagement.jsp?success=Crop deleted");
        }
    }
}
