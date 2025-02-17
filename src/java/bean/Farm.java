package beans;

import java.math.BigDecimal;

public class Farm {
    private int farmId;
    private String farmName;
    private String farmLocation;
    private BigDecimal farmSize;
    private String waterSource;
    private String rentDuration;
    private BigDecimal rentAmt;
    private String status;
    private int rentedBy; // Optional: stores the farmerId if rented

    public Farm() {}

    public Farm(int farmId, String farmName, String farmLocation, BigDecimal farmSize, String waterSource, String rentDuration, BigDecimal rentAmt, String status, int rentedBy) {
        this.farmId = farmId;
        this.farmName = farmName;
        this.farmLocation = farmLocation;
        this.farmSize = farmSize;
        this.waterSource = waterSource;
        this.rentDuration = rentDuration;
        this.rentAmt = rentAmt;
        this.status = status;
        this.rentedBy = rentedBy;
    }

    public int getFarmId() { return farmId; }
    public void setFarmId(int farmId) { this.farmId = farmId; }

    public String getFarmName() { return farmName; }
    public void setFarmName(String farmName) { this.farmName = farmName; }

    public String getFarmLocation() { return farmLocation; }
    public void setFarmLocation(String farmLocation) { this.farmLocation = farmLocation; }

    public BigDecimal getFarmSize() { return farmSize; }
    public void setFarmSize(BigDecimal farmSize) { this.farmSize = farmSize; }

    public String getWaterSource() { return waterSource; }
    public void setWaterSource(String waterSource) { this.waterSource = waterSource; }

    public String getRentDuration() { return rentDuration; }
    public void setRentDuration(String rentDuration) { this.rentDuration = rentDuration; }

    public BigDecimal getRentAmt() { return rentAmt; }
    public void setRentAmt(BigDecimal rentAmt) { this.rentAmt = rentAmt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getRentedBy() { return rentedBy; }
    public void setRentedBy(int rentedBy) { this.rentedBy = rentedBy; }
}
