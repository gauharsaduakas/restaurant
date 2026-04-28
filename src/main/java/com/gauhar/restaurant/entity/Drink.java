package com.gauhar.restaurant.entity;

import java.util.ArrayList;
import java.util.List;

public class Drink {
    private final boolean ice;
    private final boolean lemon;
    private final boolean mint;

    private Drink(Builder builder) {
        this.ice = builder.ice;
        this.lemon = builder.lemon;
        this.mint = builder.mint;
    }

    public boolean isIce() { return ice; }
    public boolean isLemon() { return lemon; }
    public boolean isMint() { return mint; }

    public static class Builder {
        private boolean ice;
        private boolean lemon;
        private boolean mint;

        public Builder ice(boolean ice) {
            this.ice = ice;
            return this;
        }

        public Builder lemon(boolean lemon) {
            this.lemon = lemon;
            return this;
        }

        public Builder mint(boolean mint) {
            this.mint = mint;
            return this;
        }

        public Drink build() {
            return new Drink(this);
        }
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("Напиток");
        List<String> details = new ArrayList<>();
        if (ice) details.add("Со льдом");
        if (lemon) details.add("С сахаром");
        if (mint) details.add("Мята");
        if (!details.isEmpty()) {
            sb.append(" (").append(String.join(", ", details)).append(")");
        }
        return sb.toString();
    }
}
