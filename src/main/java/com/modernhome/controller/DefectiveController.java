package com.modernhome.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.modernhome.domain.PageMaker;
import com.modernhome.domain.PageVO;
import com.modernhome.domain.WijoinVO;
import com.modernhome.service.DefectiveService;

@Controller
@RequestMapping(value = "/production/defective")
public class DefectiveController {
	
	private static final Logger logger = LoggerFactory.getLogger(DefectiveController.class);
	
	// ===========================================
	
	
	// 의존성 주입
	@Autowired
	private DefectiveService dfService;
	
	
	// ===========================================
	
	
	// http://localhost:8088/production/defective/list
	// 불량 목록 출력 (+ 검색)
	@RequestMapping(value = "/list")
	public void getDefList(Model model, WijoinVO wjvo, PageVO pvo, 
			@ModelAttribute(value = "df_type") String df_type, @ModelAttribute(value = "nameSearch") String nameSearch) throws Exception {
		logger.debug("getDefList() 호출");
		
		PageMaker pm = new PageMaker();
		
		// 불량 목록
		List<WijoinVO> dfList = null;
		
		if(df_type != null || nameSearch != null) {
			logger.debug("검색어 O");
			dfList = dfService.getDefList(df_type, nameSearch, pvo);
			
			// 페이징 정보 전달
			pm.setPageVO(pvo);
			pm.setTotalCount(dfService.getDfTotalCnt());
		} else {
			logger.debug("검색어 X. 전체 출력");
			dfList = dfService.getDefList(pvo);
			
			// 페이징 정보 전달
			pm.setPageVO(pvo);
			pm.setTotalCount(dfService.getDfTotalCnt());
		}
		
		// 불량코드 자동 생성
		List<WijoinVO> dfNum = dfService.creatDefNum();
		
		// 정보 전달
		model.addAttribute("dfList", dfList);
		model.addAttribute("dfNum", dfNum);
		model.addAttribute("pm", pm);
	}
	
	
	// ===========================================
	
	
	// 팝업창
	@RequestMapping(value = "/addPopup")
	public String getAddPopup(Model model) throws Exception {
		logger.debug("addPopup() 호출");
		
		// 품질검사 상태가 '완료'이면서 불량이 아직 등록되지 않은 작업지시 목록
		List<WijoinVO> wiList = dfService.getQcFinInstr();
		
		// 품질검사 상태가 '완료'이면서 불량이 아직 등록되지 않은 입고 목록
		List<WijoinVO> recList = dfService.getQcFinRec();
		
		// 품질검사 상태가 '완료'이면서 불량이 아직 등록되지 않은 출고 목록
		List<WijoinVO> mrprList = dfService.getQcFinMrPr();
		
		// 정보 전달
		model.addAttribute("wiList", wiList);
		model.addAttribute("recList", recList);
		model.addAttribute("mrprList", mrprList);
		
		return "/production/defective/addPopup";
	}
	
	
	// ===========================================
	
	
	// 불량 등록 & 수정
	@RequestMapping(value = "/regDef")
	public String addDefective(WijoinVO vo) throws Exception {
		logger.debug("regDefective() 호출");
		logger.debug("#############################vo : {}", vo);
		
		if(vo.getDf_num() != null) {
			// 불량 등록
			dfService.addDefective(vo);
			// 불량 개수가 1개 이상인 자재(입고) -> 자재 입고수량 차감
//			dfService.modifyRec(vo);
		} else {
			dfService.modifyDefective(vo);
			dfService.modifyRec(vo);
		}
		
		return "redirect:/production/defective/list";
	}
	
	
	// ===========================================
	
	
	// 불량 삭제
	@RequestMapping(value = "/delDef")
	public String delDefective(@RequestParam(value = "df_id", required = false) Integer[] df_id) throws Exception {
		logger.debug("delDefective() 호출");
		
		if(df_id != null) {
			for(int dfId : df_id) {
				dfService.delDefective(dfId);
			}
		}
		
		return "redirect:/production/defective/list";
	}
	
	
	// ===========================================
	
	

	// 수리 처리
	@RequestMapping(value = "/repair", method = RequestMethod.POST)
	@ResponseBody
	public void repairPOST(@RequestBody WijoinVO vo) throws Exception {
		logger.debug("repairPOST() 호출");
		
		logger.debug("vo.getPro_id - " + vo.getPro_id());
		logger.debug("vo.getMa_id - " + vo.getMa_id());
		
		// 수리한 완제품을 재고에 반영
		if(vo.getPro_id() != null) dfService.modifyProductReAndDis(vo);
		
		// 수리한 자재를 재고에 반영 (출고검사 시)
		if(vo.getMa_id() != null) dfService.modifyMaterialReAndDis(vo);
		
		dfService.modifyDefective2(vo);
	}
	
	// 폐기 처리
	@RequestMapping(value = "/discard", method = RequestMethod.POST)
	@ResponseBody
	public void discardPOST(@RequestBody WijoinVO vo) throws Exception {
		logger.debug("discardPOST() 호출");
		
		logger.debug("vo.getPro_id - " + vo.getPro_id());
		logger.debug("vo.getMa_id - " + vo.getMa_id());
		
		int discardCnt = vo.getDf_cnt() * -1;
		vo.setDf_cnt(discardCnt);
		
		// 폐기한 완제품을 재고에서 삭제
		if(vo.getPro_id() != null) dfService.modifyProductReAndDis(vo);
		
		// 폐기한 자재를 재고에서 삭제
		if(vo.getMa_id() != null) dfService.modifyMaterialReAndDis(vo);
		
		dfService.modifyDefective2(vo);
		
	}
	
}

