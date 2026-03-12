package com.gauhar.restaurant;

import com.gauhar.restaurant.util.PasswordUtil;

public class TestHash {
    public static void main(String[] args) {
        System.out.println(PasswordUtil.hash("admin123"));
    }
}