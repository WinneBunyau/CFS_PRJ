package bean;

import java.math.BigDecimal;

public class Tools {
    private int toolId;
    private String toolName;
    private String toolType;
    private String rentalDuration;
    private BigDecimal rentalAmt;
    private String status;
    private int rentedBy; // Optional: stores the renting farmer's ID

    public Tools() {}

    public Tools(int toolId, String toolName, String toolType, String rentalDuration, BigDecimal rentalAmt, String status, int rentedBy) {
        this.toolId = toolId;
        this.toolName = toolName;
        this.toolType = toolType;
        this.rentalDuration = rentalDuration;
        this.rentalAmt = rentalAmt;
        this.status = status;
        this.rentedBy = rentedBy;
    }

    public int getToolId() { return toolId; }
    public void setToolId(int toolId) { this.toolId = toolId; }

    public String getToolName() { return toolName; }
    public void setToolName(String toolName) { this.toolName = toolName; }

    public String getToolType() { return toolType; }
    public void setToolType(String toolType) { this.toolType = toolType; }

    public String getRentalDuration() { return rentalDuration; }
    public void setRentalDuration(String rentalDuration) { this.rentalDuration = rentalDuration; }

    public BigDecimal getRentalAmt() { return rentalAmt; }
    public void setRentalAmt(BigDecimal rentalAmt) { this.rentalAmt = rentalAmt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getRentedBy() { return rentedBy; }
    public void setRentedBy(int rentedBy) { this.rentedBy = rentedBy; }
}
