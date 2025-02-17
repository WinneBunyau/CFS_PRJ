package servlet;

import db.DBConnection;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/UpdateCropServlet")
public class UpdateCropServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve and validate the crop_id parameter
        String cropIdStr = request.getParameter("crop_id");
        if(cropIdStr == null || cropIdStr.trim().isEmpty()){
            response.sendRedirect("adminCropManagement.jsp?error=Crop ID missing");
            return;
        }
        int cropId = Integer.parseInt(cropIdStr);

        // Retrieve other parameters
        String cropName = request.getParameter("crop_name");
        String farmerIdStr = request.getParameter("farmer_id");
        if(farmerIdStr == null || farmerIdStr.trim().isEmpty()){
            response.sendRedirect("adminCropManagement.jsp?error=Farmer ID missing");
            return;
        }
        int farmerId = Integer.parseInt(farmerIdStr);
        
        String plantingDate = request.getParameter("planting_date");
        String harvestDate = request.getParameter("harvest_date");
        String yieldStr = request.getParameter("yield");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE crops SET crop_name=?, farmer_id=?, planting_date=?, harvest_date=?, yield=? WHERE crop_id=?")) {
            ps.setString(1, cropName);
            ps.setInt(2, farmerId);
            ps.setDate(3, java.sql.Date.valueOf(plantingDate));
            if (harvestDate == null || harvestDate.trim().isEmpty()) {
                ps.setNull(4, java.sql.Types.DATE);
            } else {
                ps.setDate(4, java.sql.Date.valueOf(harvestDate));
            }
            if (yieldStr == null || yieldStr.trim().isEmpty()) {
                ps.setNull(5, java.sql.Types.DECIMAL);
            } else {
                ps.setBigDecimal(5, new BigDecimal(yieldStr));
            }
            ps.setInt(6, cropId);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        // Redirect based on user type: if admin is logged in, go to admin page; otherwise, go to farmer page.
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminId") != null) {
            response.sendRedirect("adminCropManagement.jsp?success=Crop updated");
        } else {
            response.sendRedirect("farmerCropManagement.jsp?success=Crop updated");
        }
    }
}
