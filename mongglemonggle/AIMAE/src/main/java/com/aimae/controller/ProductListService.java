package com.aimae.controller;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import javax.servlet.*;
import javax.servlet.http.*;
import com.aimae.model.Product;
import com.aimae.model.ProductDAO;

public class ProductListService extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        List<Product> products = new ProductDAO().searchAll();
        List<Product> stockProducts = new ProductDAO().searchStockProducts();
        
        request.setAttribute("products", products);
        request.setAttribute("stockProducts", stockProducts);
        
        System.out.println("상품 개수: " + products.size());
        for(Product p : products) {
            System.out.println(p.getPRODUCT_NAME());
        }
        
        System.out.println("인기 상품 개수: " + stockProducts.size());
        for(Product s : stockProducts) {
            System.out.println("재고: " + s.getPRODUCT_NAME());
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
        
        
    }
}