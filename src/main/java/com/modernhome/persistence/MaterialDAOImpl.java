package com.modernhome.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.modernhome.domain.MaterialVO;

@Repository
public class MaterialDAOImpl implements MaterialDAO {

	// 로거
	private static final Logger logger = LoggerFactory.getLogger(MaterialDAOImpl.class);
	
	// 의존성 주입
	@Inject
	private SqlSession sqlSession;
	
	// 네임스페이스
	private static final String NAMESPACRE = "com.modernhome.mapper.MaterialMapper";
	
	// 자재 목록 조회
	@Override
	public List<MaterialVO> getMaterialList() {
		logger.debug("자재 목록 조회!");
		return sqlSession.selectList(NAMESPACRE + ".materialList");
	}

	// 자재 검색 결과
	@Override
	public List<MaterialVO> getMaterialList(String itemOption, String search) {

		Map<String, Object> parameterMap = new HashMap();
		 parameterMap.put("itemOption", itemOption);
		 parameterMap.put("search", search);
		 
		 return sqlSession.selectList(NAMESPACRE + ".maSearchList", parameterMap);

	}
	

}