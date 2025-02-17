package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/DeleteAnimalServlet")
public class DeleteAnimalServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int animalId = Integer.parseInt(request.getParameter("id"));
 
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM Animals WHERE animal_id=?")) {
            ps.setInt(1, animalId);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
 
        HttpSession session = request.getSession(false);
        if(session != null && session.getAttribute("adminId") != null) {
            response.sendRedirect("adminAnimalManagement.jsp?success=Animal deleted");
        } else {
            response.sendRedirect("farmerAnimalManagement.jsp?success=Animal deleted");
        }
    }
}
