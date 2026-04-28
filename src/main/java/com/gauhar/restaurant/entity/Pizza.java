package com.gauhar.restaurant.entity;

import java.util.ArrayList;
import java.util.List;

public class Pizza {

    private final String size;
    private final String dough;
    private final boolean cheese;
    private final boolean pepperoni;
    private final boolean mushrooms;
    private final boolean olives;

    private Pizza(Builder builder) {
        this.size = builder.size;
        this.dough = builder.dough;
        this.cheese = builder.cheese;
        this.pepperoni = builder.pepperoni;
        this.mushrooms = builder.mushrooms;
        this.olives = builder.olives;
    }

    public String getSize() { return size; }
    public String getDough() { return dough; }
    public boolean isCheese() { return cheese; }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("Пицца");
        List<String> details = new ArrayList<>();
        if (size != null) details.add("Размер: " + size);
        if (dough != null) details.add("Тесто: " + dough);
        if (cheese) details.add("Сыр");
        if (pepperoni) details.add("Пепперони");
        if (mushrooms) details.add("Грибы");
        if (olives) details.add("Оливки");

        if (!details.isEmpty()) {
            sb.append(" (").append(String.join(", ", details)).append(")");
        }
        return sb.toString();
    }

    public static class Builder {
        private String size;
        private String dough;
        private boolean cheese;
        private boolean pepperoni;
        private boolean mushrooms;
        private boolean olives;

        public Builder(String size, String dough) {
            this.size = size;
            this.dough = dough;
        }

        public Builder cheese(boolean cheese) {
            this.cheese = cheese;
            return this;
        }

        public Builder pepperoni(boolean pepperoni) {
            this.pepperoni = pepperoni;
            return this;
        }

        public Builder mushrooms(boolean mushrooms) {
            this.mushrooms = mushrooms;
            return this;
        }

        public Builder olives(boolean olives) {
            this.olives = olives;
            return this;
        }

        public Pizza build() {
            return new Pizza(this);
        }
    }
}