package com.gauhar.restaurant.model;

public class Restaurant {
    private int id;
    private String name;
    private String address;
    private String phone;
    private String workHours;
    private String description;

    public Restaurant() {}

    public Restaurant(int id, String name, String address, String phone, String workHours, String description) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.phone = phone;
        this.workHours = workHours;
        this.description = description;
    }

    public Restaurant(int id, String name, String address, String phone) {
        this(id, name, address, phone, "", "");
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getWorkHours() { return workHours; }
    public void setWorkHours(String workHours) { this.workHours = workHours; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
