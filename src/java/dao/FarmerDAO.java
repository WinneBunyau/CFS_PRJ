package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import beans.Farmer;
import db.DBConnection;

public class FarmerDAO {
    public static List<Farmer> getAllFarmers() {
        List<Farmer> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM Farmers");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Farmer(
                    rs.getInt("farmerId"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("phone"),
                    rs.getString("address")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
