package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

//@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Retrieve form parameters
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        try (Connection conn = DBConnection.getConnection()) {
            // Check if the email already exists
            String checkSql = "SELECT farmerId FROM Farmers WHERE email = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, email);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if(rs.next()){
                        response.sendRedirect("register.jsp?error=Email already registered");
                        return;
                    }
                }
            }
            
            // Insert new farmer record
            String sql = "INSERT INTO Farmers (name, email, password, phone, address) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setString(4, phone);
                ps.setString(5, address);
                ps.executeUpdate();
            }
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=Registration failed due to a database error");
            return;
        }
        
        // Redirect to login page with a success message
        response.sendRedirect("login.jsp?success=Registration successful. Please log in.");
    }
}
