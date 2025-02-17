package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/DeleteAnimalProduceServlet")
public class DeleteAnimalProduceServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws ServletException, IOException {
        int animalProduceId = Integer.parseInt(request.getParameter("id"));
 
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM AnimalProduce WHERE animal_produce_id=?")) {
            ps.setInt(1, animalProduceId);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
 
        HttpSession session = request.getSession(false);
        if(session != null && session.getAttribute("adminId") != null) {
            response.sendRedirect("adminAnimalProduceManagement.jsp?success=Produce deleted");
        } else {
            response.sendRedirect("farmerAnimalProduceManagement.jsp?success=Produce deleted");
        }
    }
}
