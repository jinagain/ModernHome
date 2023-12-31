package com.modernhome.persistence;

import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.modernhome.domain.LineShutdownVO;
import com.modernhome.domain.LineVO;
import com.modernhome.domain.PageVO;

@Repository
public class LineDAOImpl implements LineDAO {
	
	// 의존성 주입
	@Inject
	private SqlSession sqlSession;
	
	// 로거
	private static final Logger logger = LoggerFactory.getLogger(LineDAOImpl.class);
	
	// 네임스페이스
	private static final String NAMESPACE = "com.modernhome.mapper.LineMapper";

	// 라인 조회
	@Override
	public List<LineVO> getLineList() throws Exception {
		logger.debug("DAO -> mapper호출 -> SQL 실행(라인조회");
		
		return sqlSession.selectList(NAMESPACE + ".getLineList");
	}

	// 라인 조회 + 검색(페이징)
	@Override
	public List<LineVO> getLineListSearch(String line_num, String line_name, String use_yn) throws Exception{
		logger.debug("DAO -> mapper호출 -> SQL 실행 (사원조회 - 검색된 데이터만 출력)");

		HashMap<String, Object> parameterMap = new HashMap<String, Object>();
		parameterMap.put("line_num", line_num);
		parameterMap.put("line_name", line_name);
		parameterMap.put("use_yn", use_yn);
		
		
		return sqlSession.selectList(NAMESPACE +  ".getLineListSearch", parameterMap);
	}

	// 라인 등록
	@Override
	public void regLine(LineVO lvo) throws Exception {
		logger.debug("DAO -> mapper 호출 -> SQL 실행(라인등록)");
		
		sqlSession.insert(NAMESPACE+".regLine",lvo);
		
	}

	// 라인수정
	@Override
	public void updateLine(LineVO lvo) throws Exception {
		logger.debug("DAO -> mapper호출 -> SQL실행(라인수정)");
		
		sqlSession.update(NAMESPACE + ".updateLine",lvo);
		
	}
	
	// 라인 삭제
	@Override
	public void deleteLine(int line_id) throws Exception {
		logger.debug("DAO -> mapper 호출 -> SQL 실행(라인삭제)");
		
		sqlSession.delete(NAMESPACE + ".deleteLine",line_id);
		
	}

	@Override
	public void regLineShutdown(LineShutdownVO lsvo) throws Exception {
		logger.debug("DAO -> mapper 호출 -> SQL 실행(라인수정정보 저장)");
		
		sqlSession.insert(NAMESPACE + ".regLineShutdown", lsvo);
	}

	@Override
	public List<LineShutdownVO> getListLineShutdown(Integer line_id) throws Exception {
		logger.debug("DAO -> mapper 호출 -> SQL 실행(라인수정정보 출력)");
		
		return sqlSession.selectList(NAMESPACE + ".listLineShutdown", line_id);
	}

	
	
	
	// 월별 평균 고장 건수
	@Override
	public List<LineVO> shutdownCnt() throws Exception {
		return sqlSession.selectList(NAMESPACE + ".shutdownCnt");
	}



} // LineDAOImpl