package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/AddAnimalTypeServlet")
public class AddAnimalTypeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String animalTypeName = request.getParameter("animal_type_name");
 
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("INSERT INTO AnimalTypes (animal_type_name) VALUES (?)")) {
            ps.setString(1, animalTypeName);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
 
        response.sendRedirect("adminAnimalTypeManagement.jsp?success=Animal type added");
    }
}
