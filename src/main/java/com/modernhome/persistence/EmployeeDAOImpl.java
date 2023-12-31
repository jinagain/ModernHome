package com.modernhome.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.modernhome.domain.EmployeeVO;
import com.modernhome.domain.PageVO;

@Repository
public class EmployeeDAOImpl implements EmployeeDAO{
	
	@Inject
	private SqlSession sqlSession;
	
	private static final String NAMESPACE = "com.modernhome.mapper.EmployeeMapper";
	
	
	private static final Logger logger = LoggerFactory.getLogger(EmployeeDAOImpl.class);
	
	
	// 로그인
	@Override
	public EmployeeVO loginMember(EmployeeVO vo) {
		logger.debug(" 테스트 -> DAO 호출 : 로그인 동작 수행 ");

	
		logger.debug(" DAO -> mapper 사용 -> SQL 실행");
		EmployeeVO resultVO = sqlSession.selectOne(NAMESPACE + ".login", vo); // id,pw 전달

		logger.debug(" SQL 실행결과를 리턴 -> 테스트 ");
		
		logger.debug(resultVO + "");

		return resultVO;
	}
	
	
	// 로그인
//	@Override
//	public EmployeeVO loginMember(int id, String pw) {
//	
//		Map<String, Object> params = new HashMap<String, Object>();
//		
//			
//		params.put("emp_id", id);	
//		params.put("emp_pw", pw);
//		
//		// SQL 호출,실행
//		sqlSession.selectOne(NAMESPACE + ".login", params);
//		
//		return null;
//	}
	
	// -------------------------------------------- 로그인
	
	
	
	// 총 사원수 계산
	@Override
	public int empTotalCnt() throws Exception {
		return sqlSession.selectOne(NAMESPACE + ".empTotalCnt");
	}


	// 사원조회
	@Override
	public List<EmployeeVO> employeeList(PageVO pvo) {
		logger.debug("DAO -> mapper호출 -> SQL 실행 (사원조회)");
		
		return sqlSession.selectList(NAMESPACE + ".employeeList", pvo);
	}
	
	
	
	
	
	
	// 사원조회(검색)
	@Override
	public List<EmployeeVO> employeeListSearch(EmployeeVO evo, PageVO pvo) {
		logger.debug("DAO -> mapper호출 -> SQL 실행 (사원조회 - 검색된 데이터만 출력)");
		
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("evo", evo);
		paramMap.put("pvo", pvo);
		logger.debug("paramMap : " + paramMap);
		return sqlSession.selectList(NAMESPACE + ".employeeListSearch", paramMap);
	}
	
	
	// 사원 검색결과수 계산
	@Override
	public int empSearchCnt(EmployeeVO evo) throws Exception {
		logger.debug(sqlSession.selectOne(NAMESPACE + ".empSearchCnt", evo) + "@@@@@@@@@");
		return sqlSession.selectOne(NAMESPACE + ".empSearchCnt", evo);
	}


	
	
	
	
	
	
	
	// 사원등록
	@Override
	public void regEmployee(EmployeeVO evo) {
		logger.debug("DAO -> mapper호출 -> SQL 실행 (사원등록)");
		
		sqlSession.insert(NAMESPACE + ".regEmployee", evo);  
		
	}
	
	
	// 사원삭제
	@Override
	public void deleteEmployee(int emp_id) {
		logger.debug("DAO -> mapper호출 -> SQL 실행(사원삭제)");
		
		sqlSession.delete(NAMESPACE + ".deleteEmployee", emp_id);
	}

	// 사원업데이트(수정)
	@Override
	public void updateEmployee(EmployeeVO evo) {
		logger.debug("DAO -> mapper호출 -> SQL 실행(사원업데이트)");
		
		sqlSession.update(NAMESPACE + ".updateEmployee", evo);
	}

	
	
	
	
	
	
}
