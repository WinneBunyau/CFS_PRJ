package bean;

import java.math.BigDecimal;
import java.sql.Date;

public class Animal {
    private int animalId;
    private int farmerId;
    private String animalName;
    private int animalTypeId;
    private Date birthDate;
    private BigDecimal weight;
    
    public Animal() {}
    
    // Getters and setters
    public int getAnimalId() { return animalId; }
    public void setAnimalId(int animalId) { this.animalId = animalId; }
    
    public int getFarmerId() { return farmerId; }
    public void setFarmerId(int farmerId) { this.farmerId = farmerId; }
    
    public String getAnimalName() { return animalName; }
    public void setAnimalName(String animalName) { this.animalName = animalName; }
    
    public int getAnimalTypeId() { return animalTypeId; }
    public void setAnimalTypeId(int animalTypeId) { this.animalTypeId = animalTypeId; }
    
    public Date getBirthDate() { return birthDate; }
    public void setBirthDate(Date birthDate) { this.birthDate = birthDate; }
    
    public BigDecimal getWeight() { return weight; }
    public void setWeight(BigDecimal weight) { this.weight = weight; }
}
