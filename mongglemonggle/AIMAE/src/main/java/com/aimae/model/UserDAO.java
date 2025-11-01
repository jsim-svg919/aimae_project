package com.aimae.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import com.aimae.model.UserInfo;
import com.aimae.util.SqlSessionManager;

public class UserDAO {
	
	SqlSessionFactory sqlSessionFactory
	=SqlSessionManager.getsqlSessionFactory();

	public int join(UserInfo user) {
		// JoinService에서 보낸 데이터 MavenMember를 받아오기
			//openSession(true) --> 자동 auto commint
			// ex) join을 통해서 DB에 데이터 저장하는 경우 
			//		수동으로 commit(x), 자동으로 commit됨
			// 2.1.1 factory를 통해서 sqlsession 생성
			 SqlSession sqlsession
			= sqlSessionFactory.openSession(true); 
			// 2.1.2 sqlsession을 이용해서 db에서 기능 작업
			// sqlsession.insert(statement, parameter);
//			 					(mapper내의 쿼리문의 id, 쿼리문 실행시에 필요한 데이터)
			 //insert메서드의 리턴값 : insert 구문 실행시에 영향 받는 행의 개수!
			int cnt = sqlsession.insert("join", user);

			System.out.println("결과값 출력 : "+cnt);

			sqlsession.close();
			return cnt;
		}
	
	public boolean UserIdComplet(String userId) {
		
		SqlSession sqlsession
		= sqlSessionFactory.openSession(true); 
		
		String result = sqlsession.selectOne("checkUserId", userId);
	    sqlsession.close();
	    return result != null;
	}
	
	
//	public UserInfo login(UserInfo loginUser) {
//		
//		SqlSession sqlsession
//		= sqlSessionFactory.openSession(true);
//		
//		UserInfo sUser = sqlsession.selectOne("login", loginUser);
//		
//		sqlsession.close();
//		
//		return sUser;
//		
//	}
	
	public UserInfo login(String userId) {
	    SqlSession sqlsession = sqlSessionFactory.openSession(true);
	    UserInfo sUser = sqlsession.selectOne("com.aimae.util.UserMapper.login", userId);
	    sqlsession.close();
	    return sUser;
	}
	
	public int unregister(String userId) {
		
		SqlSession sqlsession
		= sqlSessionFactory.openSession(true);
		
		int cnt = sqlsession.delete("unregister", userId);
		
		return cnt;
	}
	
	public String findId(String email) {
		
		SqlSession sqlsession
		= sqlSessionFactory.openSession(true);
		
		String findId = sqlsession.selectOne("findId", email);
		
		sqlsession.close();
		
		return findId;
	}
	
	public UserInfo findPw(String userId, String email) {
		
	    UserInfo findPw = null;
		
		SqlSession sqlsession
		= sqlSessionFactory.openSession(true);
		
		Map<String, String> params = new HashMap<>();
        params.put("userId", userId);
        params.put("email", email);
		
        findPw = sqlsession.selectOne("findPw", params);
		
		sqlsession.close();
		
		return findPw;
	}
	
	public int update(UserInfo updateUser) {
		
		SqlSession sqlsession
		= sqlSessionFactory.openSession(true);
		
		int cnt = sqlsession.update("update", updateUser);
		
		sqlsession.close();
		
		return cnt;
		
	}
	
	public List<UserInfo> select() {
		
		SqlSession sqlsession
		= sqlSessionFactory.openSession(true);
		
		List<UserInfo> result = sqlsession.selectList("select");
		
		sqlsession.close();
		
		return result;
		
		
	}

	public UserInfo findByNaverId(String naverId) {
		
		SqlSession sqlsession
		= sqlSessionFactory.openSession(true);
		
		UserInfo findByNaverId = sqlsession.selectOne("checkUserId", naverId);
		
		sqlsession.close();
		
		return findByNaverId;
		
	}
	
	public String findGrade(String Grade) {
		
		SqlSession sqlsession
		= sqlSessionFactory.openSession(true);
		
		String findGrade = sqlsession.selectOne("checkUserGrade", Grade);
		
		sqlsession.close();
		
		return findGrade;
		
	}
	
	public int updatePassword(UserInfo user) {
	    SqlSession sqlsession = sqlSessionFactory.openSession(true);
	    int result = sqlsession.update("com.aimae.util.UserMapper.updatePassword", user);
	    System.out.println("USER_ID: " + user.getUSER_ID());
	    sqlsession.close();
	    return result;
	}
	
	public int findEmail(String email) {
	      int count = 0;
	      SqlSession sqlSession = sqlSessionFactory.openSession();
	      try {
	         count = sqlSession.selectOne("findEmail", email);
	      } finally {
	         sqlSession.close();
	      }
	      return count;
	   }

	
}
