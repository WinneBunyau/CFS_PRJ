package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/AddCropTypeServlet")
public class AddCropTypeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String cropTypeName = request.getParameter("crop_type_name");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO crop_type (crop_type_name) VALUES (?)")) {
            ps.setString(1, cropTypeName);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("adminCropTypeManagement.jsp?success=Crop type added");
    }
}
