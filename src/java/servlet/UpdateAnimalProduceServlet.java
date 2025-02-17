package servlet;

import db.DBConnection;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/UpdateAnimalProduceServlet")
public class UpdateAnimalProduceServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int animalProduceId = Integer.parseInt(request.getParameter("animal_produce_id"));
        int animalId = Integer.parseInt(request.getParameter("animal_id"));
        BigDecimal quantity = new BigDecimal(request.getParameter("quantity"));
        String produceDate = request.getParameter("animal_produce_date");
        String storageLocation = request.getParameter("animal_storage_location");
        String produceType = request.getParameter("animal_produce_type"); // New field
 
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE AnimalProduce SET animal_id=?, quantity=?, animal_produce_date=?, animal_storage_location=?, animal_produce_type=? WHERE animal_produce_id=?")) {
            ps.setInt(1, animalId);
            ps.setBigDecimal(2, quantity);
            ps.setDate(3, java.sql.Date.valueOf(produceDate));
            ps.setString(4, storageLocation);
            ps.setString(5, produceType);
            ps.setInt(6, animalProduceId);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
 
        HttpSession session = request.getSession(false);
        if(session != null && session.getAttribute("adminId") != null) {
            response.sendRedirect("adminAnimalProduceManagement.jsp?success=Produce updated");
        } else {
            response.sendRedirect("farmerAnimalProduceManagement.jsp?success=Produce updated");
        }
    }
}
