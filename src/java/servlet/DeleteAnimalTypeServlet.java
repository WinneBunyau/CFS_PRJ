package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/DeleteAnimalTypeServlet")
public class DeleteAnimalTypeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int animalTypeId = Integer.parseInt(request.getParameter("id"));
 
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM AnimalTypes WHERE animal_type_id=?")) {
            ps.setInt(1, animalTypeId);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
 
        response.sendRedirect("adminAnimalTypeManagement.jsp?success=Animal type deleted");
    }
}
