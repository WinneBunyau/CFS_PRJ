package servlet;

import db.DBConnection;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdateCropProduceServlet")
public class UpdateCropProduceServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, javax.servlet.http.HttpServletResponse response) 
            throws ServletException, IOException {
        int cropProduceId = Integer.parseInt(request.getParameter("crop_produce_id"));
        int cropId = Integer.parseInt(request.getParameter("crop_id"));
        BigDecimal quantity = new BigDecimal(request.getParameter("quantity"));
        String produceDate = request.getParameter("crop_produce_date");
        String storageLocation = request.getParameter("crop_storage_location");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE crop_produce SET crop_id=?, quantity=?, crop_produce_date=?, crop_storage_location=? WHERE crop_produce_id=?")) {
            ps.setInt(1, cropId);
            ps.setBigDecimal(2, quantity);
            ps.setDate(3, java.sql.Date.valueOf(produceDate));
            ps.setString(4, storageLocation);
            ps.setInt(5, cropProduceId);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        HttpSession session = request.getSession(false);
        if(session != null && session.getAttribute("adminId") != null) {
            response.sendRedirect("adminCropProduceManagement.jsp?success=Crop produce updated");
        } else {
            response.sendRedirect("farmerCropProduceManagement.jsp?success=Crop produce updated");
        }
    }
}
