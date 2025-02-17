package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/UpdateAnimalServlet")
public class UpdateAnimalServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int animalId = Integer.parseInt(request.getParameter("animal_id"));
        int farmerId = Integer.parseInt(request.getParameter("farmer_id"));
        String animalName = request.getParameter("animal_name");
        int animalTypeId = Integer.parseInt(request.getParameter("animal_type_id"));
        String birthDate = request.getParameter("birth_date");
        double weight = Double.parseDouble(request.getParameter("weight"));
 
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                "UPDATE Animals SET farmer_id=?, animal_name=?, animal_type_id=?, birth_date=?, weight=? WHERE animal_id=?")) {
            ps.setInt(1, farmerId);
            ps.setString(2, animalName);
            ps.setInt(3, animalTypeId);
            ps.setDate(4, java.sql.Date.valueOf(birthDate));
            ps.setDouble(5, weight);
            ps.setInt(6, animalId);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
 
        HttpSession session = request.getSession(false);
        if(session != null && session.getAttribute("adminId") != null) {
            response.sendRedirect("adminAnimalManagement.jsp?success=Animal updated");
        } else {
            response.sendRedirect("farmerAnimalManagement.jsp?success=Animal updated");
        }
    }
}
