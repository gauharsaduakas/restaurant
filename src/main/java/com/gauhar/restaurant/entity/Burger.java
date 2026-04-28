package com.gauhar.restaurant.entity;

import java.util.ArrayList;
import java.util.List;

public class Burger {
    private final boolean onion;
    private final boolean extraPatty;
    private final boolean cheese;
    private final int quantity;

    private Burger(Builder builder) {
        this.onion = builder.onion;
        this.extraPatty = builder.extraPatty;
        this.cheese = builder.cheese;
        this.quantity = builder.quantity;
    }

    public boolean isOnion() { return onion; }
    public boolean isExtraPatty() { return extraPatty; }
    public boolean isCheese() { return cheese; }
    public int getQuantity() { return quantity; }

    public static class Builder {
        private boolean onion;
        private boolean extraPatty;
        private boolean cheese;
        private int quantity = 1;

        public Builder onion(boolean onion) {
            this.onion = onion;
            return this;
        }

        public Builder extraPatty(boolean extraPatty) {
            this.extraPatty = extraPatty;
            return this;
        }

        public Builder cheese(boolean cheese) {
            this.cheese = cheese;
            return this;
        }

        public Builder quantity(int quantity) {
            this.quantity = quantity;
            return this;
        }

        public Burger build() {
            return new Burger(this);
        }
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("Бургер");
        List<String> details = new ArrayList<>();
        if (onion) details.add("Лук");
        if (extraPatty) details.add("Доп. котлета");
        if (cheese) details.add("Сыр");
        if (!details.isEmpty()) {
            sb.append(" (").append(String.join(", ", details)).append(")");
        }
        return sb.toString();
    }
}
