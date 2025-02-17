package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdateCropTypeServlet")
public class UpdateCropTypeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int cropTypeId = Integer.parseInt(request.getParameter("crop_type_id"));
        String cropTypeName = request.getParameter("crop_type_name");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE crop_type SET crop_type_name = ? WHERE crop_type_id = ?")) {
            ps.setString(1, cropTypeName);
            ps.setInt(2, cropTypeId);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("adminCropTypeManagement.jsp?success=Crop type updated");
    }
}
