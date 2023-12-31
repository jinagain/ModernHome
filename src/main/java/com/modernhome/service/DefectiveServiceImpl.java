package com.modernhome.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.modernhome.domain.DefectiveVO;
import com.modernhome.domain.PageVO;
import com.modernhome.domain.WijoinVO;
import com.modernhome.persistence.DefectiveDAO;

@Service
public class DefectiveServiceImpl implements DefectiveService {
	
	private static final Logger logger = LoggerFactory.getLogger(DefectiveServiceImpl.class);
	
	// 의존성 주입
	@Autowired
	private DefectiveDAO dao;

	@Override
	public List<WijoinVO> getDefList(PageVO vo) throws Exception {
		logger.debug("defectiveServiceImpl - getDefList() 출력");
		return dao.getDefList(vo);
	}

	@Override
	public int getDfTotalCnt() throws Exception {
		logger.debug("defectiveServiceImpl - getDdfTotalCnt() 출력");
		return dao.getDfTotalCnt();
	}

	@Override
	public List<WijoinVO> creatDefNum() throws Exception {
		logger.debug("defectiveServiceImpl - creatDefNum() 출력");
		return dao.creatDefNum();
	}

	@Override
	public List<WijoinVO> getDefList(String df_type, String nameSearch, PageVO vo) throws Exception {
		logger.debug("defectiveServiceImpl - getDefList() 출력");
		return dao.getDefList(df_type, nameSearch, vo);
	}

	@Override
	public int getDfSearchCnt(String df_type, String nameSearch, PageVO vo) throws Exception {
		logger.debug("defectiveServiceImpl - getDfSearchCnt() 출력");
		return dao.getDfSearchCnt(df_type, nameSearch, vo);
	}

	@Override
	public List<WijoinVO> getQcFinInstr() throws Exception {
		logger.debug("defectiveServiceImpl - getQcFinInstr() 출력");
		return dao.getQcFinInstr();
	}

	@Override
	public List<WijoinVO> getQcFinRec() throws Exception {
		logger.debug("defectiveServiceImpl - getQcFinRec() 출력");
		return dao.getQcFinRec();
	}

	@Override
	public void addDefective(WijoinVO vo) throws Exception {
		logger.debug("defectiveServiceImpl - addDefective() 출력");
		dao.addDefective(vo);
	}
	
	@Override
	public void modifyRec(WijoinVO vo) throws Exception {
		logger.debug("defectiveServiceImpl - modifyRec() 출력");
		dao.modifyRec(vo);
	}
	
	@Override
	public void modifyDefective(WijoinVO vo) throws Exception {
		logger.debug("defectiveServiceImpl - modifyDefective() 출력");
		dao.modifyDefective(vo);
	}

	@Override
	public void delDefective(Integer df_id) throws Exception {
		logger.debug("defectiveServiceImpl - delDefective() 출력");
		dao.delDefective(df_id);
	}

	@Override
	public void modifyProductReAndDis(WijoinVO vo) throws Exception {
		logger.debug("defectiveServiceImpl - modifyProductReAndDis() 출력");
		dao.modifyProductReAndDis(vo);
	}
	
	@Override
	public void modifyMaterialReAndDis(WijoinVO vo) throws Exception {
		logger.debug("defectiveServiceImpl - modifyMaterialReAndDis() 출력");
		dao.modifyMaterialReAndDis(vo);
	}

	@Override
	public void modifyDefective2(WijoinVO vo) throws Exception {
		logger.debug("defectiveServiceImpl - modifyDefective2() 출력");
		dao.modifyDefective2(vo);
	}
	
	@Override
	public List<WijoinVO> getQcFinMrPr() throws Exception {
		logger.debug("defectiveServiceImpl - getQcFinMrPr() 출력");
		return dao.getQcFinMrPr();
	}

	// 불량 그래프 계산용
	@Override
	public DefectiveVO dfCnt() throws Exception {
		return dao.dfCnt();
	}
	
}