package com.aimae.model;

import lombok.Data;

@Data
public class Product {
	
    private String PRODUCT_ID;
    private String PRODUCT_NAME;
    private int PRICE;
    private String CATEGORY;
    private String PRD_INFO;
    private int STOCK;
    private String PRD_DETAIL;
    private String PHOTO_PATH;
    private String PHOTO_THUMB;
    
}

