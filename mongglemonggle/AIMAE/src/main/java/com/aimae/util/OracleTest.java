package com.aimae.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class OracleTest {
	
    public static void main(String[] args) {
        
        String url = "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe"; 
        String username = "campus_24IS_CLOUD3_p2_5"; 
        String password = "smhrd5"; 

        Connection conn = null;

        try {
            
            Class.forName("oracle.jdbc.driver.OracleDriver");

            conn = DriverManager.getConnection(url, username, password);

            if (conn != null) {
            	
                System.out.println("✅ Oracle DB 연결 성공!");
            
            }else {
            	
                System.out.println("❌ Oracle DB 연결 실패!");
            
            }

        } catch (ClassNotFoundException e) {
        	
            System.out.println("❌ Oracle JDBC 드라이버를 찾을 수 없습니다.");
            e.printStackTrace();
            
        } catch (SQLException e) {
        	
            System.out.println("❌ DB 연결 중 오류 발생:");
            e.printStackTrace();
            
        } finally {
            
            try {
            	
                if (conn != null && !conn.isClosed()) {
                	
                    conn.close();
                    System.out.println("🔒 DB 연결 종료됨.");
                    
                }
                
            } catch (SQLException e) {
            	
                e.printStackTrace();
                
            }
        }
    }
}

