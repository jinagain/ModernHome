package com.modernhome.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.modernhome.domain.WijoinVO;

@Repository
public class QualityDAOImpl implements QualityDAO{
	
	// 의존성 주입
	@Inject
	private SqlSession sqlSession;
	
	// 네임스페이스
	private static final String NAMESPACE = "com.modernhome.mapper.QualityMapper";
	
	// 로거
	private static final Logger logger = LoggerFactory.getLogger(QualityDAOImpl.class);
	

	// 품질검사(완제품) 목록 조회
	@Override
	public List<WijoinVO> getQualityList() throws Exception {
		logger.debug("QualityDAOImpl_getQualityList 실행");
		return sqlSession.selectList(NAMESPACE+".getQualityList");
	}

	// 품질검사(완제품) 목록 조회 + 검색
	@Override
	public List<WijoinVO> getQualitySearch(String qc_num, String startDate, String endDate, String qc_yn) throws Exception {
		logger.debug("QualityDAOImpl_getQualityList(검색) 실행");
		
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("qc_num", qc_num);
		parameterMap.put("startDate", startDate);
		parameterMap.put("endDate", endDate);
		parameterMap.put("qc_yn", qc_yn);
		
		return sqlSession.selectList(NAMESPACE+".getQualitySearch",parameterMap);
	}


	// 품질검사(완제품) 수정
	@Override
	public void updateQuality(WijoinVO wvo) {
		logger.debug("DAO -> mapper 호출 -> SQL 실행(품질등록)");
		
		sqlSession.update(NAMESPACE+".updateQuality",wvo);
		
	}

	// 품질검사(자재) 목록 조회
	@Override
	public List<WijoinVO> getMaterialQualityList() throws Exception {
		logger.debug("QualityDAOImpl_getMaterialQualityList 실행");
		
		return sqlSession.selectList(NAMESPACE + ".getMaterialQualityList");
	}

	// 품질검사(자재) 목록 조회 + 검색
	@Override
	public List<WijoinVO> getMaterialQualitySearch(String qc_num, String startDate, String endDate, String qc_yn) throws Exception {
		logger.debug("QualityDAOImpl_getQualityList(검색) 실행");
		
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("qc_num", qc_num);
		parameterMap.put("startDate", startDate);
		parameterMap.put("endDate", endDate);
		parameterMap.put("qc_yn", qc_yn);
		
		return sqlSession.selectList(NAMESPACE+".getMaterialQualitySearch", parameterMap);
	}




}
