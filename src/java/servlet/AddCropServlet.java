package servlet;

import db.DBConnection;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/AddCropServlet")
public class AddCropServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // crop_name is selected from a dropdown and holds the crop type name.
        String cropName = request.getParameter("crop_name");
        int farmerId = Integer.parseInt(request.getParameter("farmer_id"));
        String plantingDate = request.getParameter("planting_date");
        String harvestDate = request.getParameter("harvest_date"); // may be empty
        String yieldStr = request.getParameter("yield");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "INSERT INTO crops (crop_name, farmer_id, planting_date, harvest_date, yield) VALUES (?, ?, ?, ?, ?)")) {
            ps.setString(1, cropName);
            ps.setInt(2, farmerId);
            ps.setDate(3, java.sql.Date.valueOf(plantingDate));
            if (harvestDate == null || harvestDate.isEmpty()) {
                ps.setNull(4, java.sql.Types.DATE);
            } else {
                ps.setDate(4, java.sql.Date.valueOf(harvestDate));
            }
            if (yieldStr == null || yieldStr.isEmpty()) {
                ps.setNull(5, java.sql.Types.DECIMAL);
            } else {
                ps.setBigDecimal(5, new BigDecimal(yieldStr));
            }
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        HttpSession session = request.getSession(false);
        if(session != null && session.getAttribute("adminId") != null) {
            response.sendRedirect("adminCropManagement.jsp?success=Crop added");
        } else {
            response.sendRedirect("farmerCropManagement.jsp?success=Crop added");
        }
    }
}
