package com.aimae.model;

import lombok.Data;

@Data
public class Cart {
    private String CART_ID;
    private String USER_NUM;
    private String PRODUCT_ID;
    private String ORDER_DATE;
    private String DELY_ADDRESS;
    private int STATUS;

    
    // 상품 정보 (JOIN 결과)
    private String PRODUCT_NAME;
    private int PRICE;
    private String PHOTO_PATH;
    
        
    @Override
    public String toString() {
        return "Cart [CART_ID=" + CART_ID + ", USER_NUM=" + USER_NUM + ", PRODUCT_ID=" + PRODUCT_ID + 
               ", ORDER_DATE=" + ORDER_DATE + ", DELY_ADDRESS=" + DELY_ADDRESS + ", STATUS=" + STATUS +
               ", PRODUCT_NAME=" + PRODUCT_NAME + ", PRICE=" + PRICE + "]";
    }
}
