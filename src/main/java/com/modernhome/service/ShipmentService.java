package com.modernhome.service;

import java.util.List;

import com.modernhome.domain.ShipmentJoinVO;
import com.modernhome.domain.ShipmentVO;

public interface ShipmentService {
	
	// 출하 조회
	public List<ShipmentJoinVO> shipmentList() throws Exception;
	
	// 출하조회 + 검색
	public List<ShipmentJoinVO> shipmentListSearch(ShipmentJoinVO svo);
	
	// 출하정보 등록
	public void regShipment(ShipmentVO svo);
	
	// 수주정보 삭제
	public void deleteShipment(String shp_num);
		
	// 수주정보 수정
	public void updateShipment(ShipmentVO svo);

}
