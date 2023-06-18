package com.modernhome.controller;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.modernhome.domain.EmployeeVO;
import com.modernhome.domain.InorderVO;
import com.modernhome.domain.WarehouseVO;
import com.modernhome.service.InorderService;
import com.modernhome.service.WarehouseService;

@Controller
@RequestMapping(value = "/wms/*")
public class WmsController {

	WarehouseVO wvo = null;
	
    private static final Logger logger = LoggerFactory.getLogger(WmsController.class);
    
    // 의존성 주입
    @Inject
    private WarehouseService wService;
    
    @Inject
    private InorderService ioService;
    
    
    
    // 창고 조회
    // http://localhost:8088/wms/warehouse/warehouselist
    @RequestMapping(value = "/warehouse/warehouselist", method = RequestMethod.GET)
    public void warehouseGET(Model model, WarehouseVO wvo) throws Exception{
    	logger.debug(" warehouseGET() 호출 ");
    	
    	// 검색어가 하나라도 있으면 if문 실행, 아닐경우 else문 실행 
    	if(wvo.getWh_type() != null || wvo.getWh_name() != null) {
    		logger.debug("검색어 O, 검색된 데이터만 출력 " + wvo);
    		// 서비스 -> 창고 목록 가져오기
        	List<WarehouseVO> warehouseList = wService.warehouseListSearch(wvo);
        	// Model 객체에 저장
        	model.addAttribute("warehouseList", warehouseList);
    	}else {
    		logger.debug("검색어 X, 전체 데이터 출력 " + wvo);
    		// 서비스 -> 창고 목록 가져오기
        	List<WarehouseVO> warehouseList = wService.warehouseList();
        	// Model 객체에 저장
        	model.addAttribute("warehouseList", warehouseList);
    	}
    }
    
    // 발주 조회
    // http://localhost:8088/wms/inorder/inorderlist
    @RequestMapping(value = "/inorder/inorderlist",method = RequestMethod.GET)
    public void inorderGET(Model model) {
    	logger.debug(" inorderGET() 호출 ");
    	
    	List<InorderVO> inorderList = ioService.getInorderList();
    	// Model 객체에 저장
    	model.addAttribute("inorderList", inorderList);
    }
    
}