package bean;

import java.sql.Date;
import java.math.BigDecimal;

public class AnimalProduce {
    private int animalProduceId;
    private int animalId;
    private BigDecimal quantity;
    private Date animalProduceDate;
    private String animalStorageLocation;
    private String animalProduceType; // New field

    public AnimalProduce() {}

    public AnimalProduce(int animalProduceId, int animalId, BigDecimal quantity, Date animalProduceDate, String animalStorageLocation, String animalProduceType) {
        this.animalProduceId = animalProduceId;
        this.animalId = animalId;
        this.quantity = quantity;
        this.animalProduceDate = animalProduceDate;
        this.animalStorageLocation = animalStorageLocation;
        this.animalProduceType = animalProduceType;
    }

    public int getAnimalProduceId() {
        return animalProduceId;
    }
    public void setAnimalProduceId(int animalProduceId) {
        this.animalProduceId = animalProduceId;
    }
    public int getAnimalId() {
        return animalId;
    }
    public void setAnimalId(int animalId) {
        this.animalId = animalId;
    }
    public BigDecimal getQuantity() {
        return quantity;
    }
    public void setQuantity(BigDecimal quantity) {
        this.quantity = quantity;
    }
    public Date getAnimalProduceDate() {
        return animalProduceDate;
    }
    public void setAnimalProduceDate(Date animalProduceDate) {
        this.animalProduceDate = animalProduceDate;
    }
    public String getAnimalStorageLocation() {
        return animalStorageLocation;
    }
    public void setAnimalStorageLocation(String animalStorageLocation) {
        this.animalStorageLocation = animalStorageLocation;
    }
    public String getAnimalProduceType() {
        return animalProduceType;
    }
    public void setAnimalProduceType(String animalProduceType) {
        this.animalProduceType = animalProduceType;
    }
}
