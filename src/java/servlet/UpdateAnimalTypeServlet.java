package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/UpdateAnimalTypeServlet")
public class UpdateAnimalTypeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int animalTypeId = Integer.parseInt(request.getParameter("animal_type_id"));
        String animalTypeName = request.getParameter("animal_type_name");
 
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE AnimalTypes SET animal_type_name=? WHERE animal_type_id=?")) {
            ps.setString(1, animalTypeName);
            ps.setInt(2, animalTypeId);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
 
        response.sendRedirect("adminAnimalTypeManagement.jsp?success=Animal type updated");
    }
}
