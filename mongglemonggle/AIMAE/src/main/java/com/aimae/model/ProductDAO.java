package com.aimae.model;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import com.aimae.util.SqlSessionManager;
import com.aimae.model.Photo;

public class ProductDAO {
    
	    SqlSessionFactory sqlSessionFactory = SqlSessionManager.getsqlSessionFactory();
	    
	    // 조회 기능
	    public List<Product> searchAll() {
        	SqlSession sqlSession = sqlSessionFactory.openSession(true);
        	List<Product> list = sqlSession.selectList("com.aimae.mapper.productMapper.selectAllProduct");
        	sqlSession.close();
        	return list;
	   }
	   
	        // 전체 상품 조회 (제한 없음)
    public List<Product> searchAllProducts() {
        SqlSession sqlSession = sqlSessionFactory.openSession(true);
        List<Product> list = sqlSession.selectList("com.aimae.mapper.productMapper.selectAllProducts");
        sqlSession.close();
        return list;
   }
	    // 재고 낮은순으로 조회
	    public List<Product> searchStockProducts() {
	        SqlSession sqlSession = sqlSessionFactory.openSession(true);
	        List<Product> list = sqlSession.selectList("com.aimae.mapper.productMapper.selectStockProducts");
	        sqlSession.close();
	        return list;
	    }
	    
	    // 상품 ID로 조회
	    public Product searchProductId(String productId) {
	        SqlSession sqlSession = sqlSessionFactory.openSession(true);
	        Product product = sqlSession.selectOne("com.aimae.mapper.productMapper.selectProductById", productId);
	        sqlSession.close();
	        return product;
	    }
	    // 상세 조회
	    public Product_Detail searchProductDetail(String productId) {
	        SqlSession sqlSession = sqlSessionFactory.openSession(true);
	        Product_Detail productDetail = sqlSession.selectOne("com.aimae.mapper.productMapper.selectProductDetail", productId);
	        sqlSession.close();
	        return productDetail;
	    }
	    
	    // 야채 카테고리 조회
	    public List<Product> searchVegetableProducts() {
	        SqlSession sqlSession = sqlSessionFactory.openSession(true);
	        List<Product> list = sqlSession.selectList("com.aimae.mapper.productMapper.selectVegetableProducts");
	        sqlSession.close();
	        return list;
	    }
	    
	    // 가전제품 카테고리 조회
	    public List<Product> searchElectronicProducts() {
	        SqlSession sqlSession = sqlSessionFactory.openSession(true);
	        List<Product> list = sqlSession.selectList("com.aimae.mapper.productMapper.selectElectronicProducts");
	        sqlSession.close();
	        return list;
	    }
	    
	    // 과일 카테고리 조회
	    public List<Product> searchFruitProducts() {
	        SqlSession sqlSession = sqlSessionFactory.openSession(true);
	        List<Product> list = sqlSession.selectList("com.aimae.mapper.productMapper.selectFruitProducts");
	        sqlSession.close();
	        return list;
	    }
	    
	    // 상품 수정
	    public int updateProduct(Product product) {
	        SqlSession sqlSession = sqlSessionFactory.openSession(true);
	        int result = sqlSession.update("com.aimae.mapper.productMapper.updateProduct", product);
	        sqlSession.close();
	        return result;
	    }
	    
	    	// 상품 등록
	public int insertProduct(Product product) {
		SqlSession sqlSession = sqlSessionFactory.openSession(true);
		int result = sqlSession.insert("com.aimae.mapper.productMapper.insertProduct", product);
		sqlSession.close();
		return result;
	}
	
	// 상품 등록 후 생성된 ID 반환
	public String insertProductAndGetId(Product product) {
		SqlSession sqlSession = sqlSessionFactory.openSession(true);
		int result = sqlSession.insert("com.aimae.mapper.productMapper.insertProduct", product);
		String productId = null;
		
		if (result > 0) {
			// 방금 등록된 상품의 ID 조회
			List<Product> latestProducts = sqlSession.selectList("com.aimae.mapper.productMapper.selectAllProducts");
			if (!latestProducts.isEmpty()) {
				productId = latestProducts.get(0).getPRODUCT_ID();
			}
		}
		
		sqlSession.close();
		return productId;
	}
	    
	    // 상품 삭제
	    public int deleteProduct(String productId) {
	        SqlSession sqlSession = sqlSessionFactory.openSession(true);
	        int result = sqlSession.delete("com.aimae.mapper.productMapper.deleteProduct", productId);
	        sqlSession.close();
	        return result;
	    }
	    
	    // 상품 이미지 조회
	    public List<Photo> searchProductPhotos(String productId) {
	        SqlSession sqlSession = sqlSessionFactory.openSession(true);
	        List<Photo> photos = sqlSession.selectList("com.aimae.mapper.productMapper.selectProductPhotos", productId);
	        sqlSession.close();
	        return photos;
	    }
	    
}