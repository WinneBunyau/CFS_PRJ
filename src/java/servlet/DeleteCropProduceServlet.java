package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/DeleteCropProduceServlet")
public class DeleteCropProduceServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, javax.servlet.http.HttpServletResponse response) 
            throws ServletException, IOException {
        int cropProduceId = Integer.parseInt(request.getParameter("id"));
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM crop_produce WHERE crop_produce_id=?")) {
            ps.setInt(1, cropProduceId);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        HttpSession session = request.getSession(false);
        if(session != null && session.getAttribute("adminId") != null) {
            response.sendRedirect("adminCropProduceManagement.jsp?success=Crop produce deleted");
        } else {
            response.sendRedirect("farmerCropProduceManagement.jsp?success=Crop produce deleted");
        }
    }
}
