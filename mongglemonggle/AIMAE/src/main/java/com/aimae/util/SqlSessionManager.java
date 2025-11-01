package com.aimae.util;

import java.io.IOException;
import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class SqlSessionManager {
	// 사용하는 DB의 기본정보(driver, url, username, pw)를
	// 가지고 여러개의 sqlSession을 생성할 수 있는
	// sqlSessionFactory를 생성하고 관리하는 클래스
	// *  sqlSession : DB에 접근할 수 있는 권한, 입장권
	
	public static SqlSessionFactory sqlSessionFactory;
	// 클래스 로딩 시 (실행 시), 딱 한번만 실행하고 더이상 실행X
	static{
		// db의 정보가 담긴 xml파일 주소를 변수에 담아준다.
		// mybatis-config에 작성된 DB정보를 가져와서 factory생성
		String resource = "com/aimae/util/mybatis-config.xml";
		// reader를 사용해서 정보를 읽어와서 factory생성
		try {
			Reader reader = Resources.getResourceAsReader(resource);
			// mybatis-config.xml에 담긴 정보를 reader를 통해 넘긴다.
			sqlSessionFactory = new SqlSessionFactoryBuilder()
					.build(reader);
			
		} catch (IOException e) {
			e.printStackTrace();
		}	
	}
	// 다른 클래스에서 sqlSessionFactory를 가져오고 싶을때, 사용할 메서드
	// 리턴 값으로는 상단의 static 블럭에서 생성된 sqlSessionFactory반환!
	public static SqlSessionFactory getsqlSessionFactory() {
		return sqlSessionFactory;
	}
	
	
}
