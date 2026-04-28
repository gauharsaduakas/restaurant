package com.gauhar.restaurant;

import com.gauhar.restaurant.entity.Pizza;

public class Main {
    public static void main(String[] args) {

        Pizza pizza1 = new Pizza.Builder("Large", "Thin")
                .cheese(true)
                .pepperoni(true)
                .build();

        Pizza pizza2 = new Pizza.Builder("Medium", "Thick")
                .mushrooms(true)
                .olives(true)
                .build();

        System.out.println(pizza1);
        System.out.println(pizza2);
    }
}