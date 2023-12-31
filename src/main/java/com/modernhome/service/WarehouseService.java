package com.modernhome.service;

import java.util.List;

import com.modernhome.domain.WarehouseVO;

public interface WarehouseService {
	
	// 창고 조회
	public List<WarehouseVO> warehouseList();
	
	// 창고 조회 + 검색
	public List<WarehouseVO> warehouseListSearch(WarehouseVO wvo);
	
	// 창고 등록
	public void regWarehouse(WarehouseVO wvo);
	
	// 창고 수정
	public void updateWarehouse(WarehouseVO wvo);
	
	// 창고 삭제
	public void deleteWarehouse(int wh_id);
	
}