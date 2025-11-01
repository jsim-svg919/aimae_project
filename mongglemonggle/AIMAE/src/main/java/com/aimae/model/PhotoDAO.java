package com.aimae.model;

import org.apache.ibatis.session.SqlSession;
import com.aimae.util.SqlSessionManager;

public class PhotoDAO {
    
    // 상품 이미지 등록
    public int insertPhoto(Photo photo) {
        SqlSession sqlSession = SqlSessionManager.getsqlSessionFactory().openSession(true);
        int result = sqlSession.insert("com.aimae.mapper.photoMapper.insertPhoto", photo);
        sqlSession.close();
        return result;
    }
}


