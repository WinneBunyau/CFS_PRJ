package dao;

import beans.Farm;
import db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FarmDAO {
    public static List<Farm> getAllFarms() {
        List<Farm> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM Farms");
             ResultSet rs = ps.executeQuery()) {
            while(rs.next()) {
                Farm f = new Farm();
                f.setFarmId(rs.getInt("farmId"));
                f.setFarmName(rs.getString("farm_name"));
                f.setFarmLocation(rs.getString("farm_location"));
                f.setFarmSize(rs.getBigDecimal("farm_size"));
                f.setWaterSource(rs.getString("water_source"));
                f.setRentDuration(rs.getString("rent_duration"));
                f.setRentAmt(rs.getBigDecimal("rent_amt"));
                f.setStatus(rs.getString("status"));
                f.setRentedBy(rs.getInt("rented_by"));
                list.add(f);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
