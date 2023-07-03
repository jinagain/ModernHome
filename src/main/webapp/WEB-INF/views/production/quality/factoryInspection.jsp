<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../../inc/header.jsp"%>
<%@ include file="../../inc/sidebar.jsp"%>
<%@ include file="../../inc/nav.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" />
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
    <script>
    var pageStatus = "";
	    $(document).ready(function() {
	    	
	    	updateSelectedCheckboxCount();
	    	
	        // 수정 버튼 누를 시 (updateButton)
	        $("#updateButton").click(function(){
	            var selectedCheckbox = $("input[name='selectedQcId']:checked");

	            // 체크된 체크박스가 하나인 경우에만 수정 기능 작동
	            if(selectedCheckbox.length === 1) {
	                var empId = selectedCheckbox.val();
	                var row = selectedCheckbox.closest("tr");
	                
	                // input type의 name 값 지정
                	var cellNames = [
                		"work_num",
                		"qc_num",
                		"wh_name",
                		"ma_num",
                		"ma_name",
                		"update_emp_id",
                		"update_date",
                		"qc_cnt",
                		"mr_cnt",
                		"df_cnt",
                		"qc_yn"
                	];

	                // 각 셀을 수정 가능한 텍스트 입력 필드로 변경
	                row.find("td:not(:first-child)").each(function(index){
	                	
	                	var cellValue = $(this).text();
// 	                	var cellType = index === 7? "date" : "text";
	                	var cellReadonly = [0,1,2,3,4,5,9].includes(index) ? "readonly='readonly'" : "";
	                	var cellName = cellNames[index];
	                	var cellContent;

	                    if (index === 11 ) { // 검수상태 (qc_yn) 열인 경우에만 드롭다운으로 변경
	                        cellContent = '<td>' +
	                            '<select name="' + cellName + '">' +
	                            '<option value="대기" ' + (cellValue === '대기' ? 'selected' : '') + '>대기</option>' +
	                            '<option value="진행중" ' + (cellValue === '진행중' ? 'selected' : '') + '>진행중</option>' +
	                            '<option value="완료" ' + (cellValue === '완료' ? 'selected' : '') + '>완료</option>' +
	                            '</select>' +
	                            '</td>';
	                    }else if (index === 6){
	                    	cellContent = '<td><input type="'+ cellType +  '" name="' + cellName + '" value="' + ${sessionScope.emp_id} + '"' + cellReadonly + '></td>';
	                    }else {
	                    	cellContent = '<td><input type="'+  cellType + '" name="' + cellName + '" value="' + cellValue + '"' + cellReadonly + '></td>';
	                    }

	                    $(this).html(cellContent);

	                    // 버튼 활성화
	                    $("#updateButton").attr("disabled", "disabled");
	                    
						$("#cancelButton").removeAttr("disabled"); 
	                    $("#submitButton").removeAttr("disabled");
	                    
	                    pageStatus = "update";
	                });
	                
	            }else if (selectedCheckbox.length === 0){
	                alert("수정할 행을 선택해주세요!");
	            }else {
	                alert("수정은 하나의 행만 가능합니다!");
	            }
	        });
	        
            // 취소 버튼 누를 시 
			$("#cancelButton").click(function(){
	        
				// 수정버튼 취소
				if(pageStatus == "update"){
					// 모든행에 대해 반복작업, 테이블 이름에 맞게 수정
					$("#table-fiList tr").each(function() {
					var row = $(this);
						
					// 폼 초기화(기존내용으로)
// 					$("#qualityList")[0].reset();
					
					// 각 셀의 값을 원래 상태로 되돌림
				row.find("td:not(:first-child)").each(function(index) {
					var cellValue = $(this).find("input").val();
					var cellValueSelect = $(this).find("select").val();
					$(this).html(cellValue);
					$(this).html(cellValueSelect);
				});
					
					// selected 클래스를 없앰 (css 없애기)
					$("#table-fiList tr").removeClass("selected");
					
					// 추가버튼, 수정버튼 활성화, 취소버튼 비활성화
					$("#updateButton").removeAttr("disabled");
					$("#cancelButton").attr("disabled", "disabled"); 
					$("#submitButton").attr("disabled", "disabled");
					
					
					pageStatus = "";
					
					});
				} // if(update)문
			
				updateSelectedCheckboxCount();
				
			}); // 취소버튼
		


        // <th> 쪽 체크박스 클릭 시 해당 열의 <td> 부분의 행들을 선택하고 배경색 지정
        $("#table-fiList th input[type='checkbox']").click(function() {
            var checkbox = $(this);
            var isChecked = checkbox.prop('checked');
            var columnIndex = checkbox.parent().index() + 1; // 체크박스의 열 인덱스
            var table = checkbox.closest('table');
            var rows = table.find('tr');

            // <td> 부분의 행들을 선택하고 배경색 지정
            rows.each(function() {
                var checkboxTd = $(this).find('td:nth-child(' + columnIndex + ') input[type="checkbox"]');
                if (checkboxTd.length > 0) {
                    checkboxTd.prop('checked', isChecked);
                    $(this).toggleClass('selected', isChecked);
                }
            });

            updateSelectedCheckboxCount();
        });

        // <td> 쪽 체크박스 클릭 시 행 선택
        $("#table-fiList td input[type='checkbox']").click(function() {
            var checkbox = $(this);
            var isChecked = checkbox.prop('checked');
            checkbox.closest('tr').toggleClass('selected', isChecked);

            updateSelectedCheckboxCount(); 
        });

        function updateSelectedCheckboxCount() {
            var totalCheckboxes = $("#table-fiList td input[type='checkbox']").length;
            var selectedCheckboxes = $("#table-fiList td input[type='checkbox']:checked").length;
            $("#selectedCheckboxCount").text("전체 ("+selectedCheckboxes + '/' + totalCheckboxes+")");
        }  // 체크박스 선택 시 체크박스 개수 구하기
        
        
	     }); 
    </script>
    
    <style>
		.selected { 
             background-color: #b3ccff; 
         } 
	</style>
</head>
<body>

	<div class="col-sm-12 col-xl-6">
		<h2 class="mb-0">품질현황 조회</h2>
		<form name="search" method="get"> 
			<div class="row mb-3">
			<label for="qc_nameSearch" class="col-sm-2 col-form-label">품질검사코드</label> 
				<div class="col-sm-10">
					<input type="text" name="qc_num" class="form-control" placeholder="품질검사코드를 입력하세요">
				</div>
			</div>
			품질검사여부
				<select name="qc_yn">
					<option>전체</option>
					<option>대기</option>
					<option>진행중</option>
					<option>완료</option>
				</select>
			<div>
				<label>검수일자</label>
				<input type="date" name="startDate">
					~
				<input type="date" name="endDate">
			</div>
			<button type="submit" class="btn btn-primary">조회</button>
		</form>
	</div>
		
			
	<h2>출고검사 목록</h2>
	
	<form id="fiList">
	
	<button type="button" class="btn btn-primary m-2" id="cancelButton" disabled>X 취소</button>
	<button type="button" class="btn btn-primary m-2" id="updateButton"><i class="fa fa-edit"></i> 수정</button>
	<button type="submit" class="btn btn-primary m-2" id="submitButton" formaction="updateQuality" formmethod="post" disabled><i class="fa fa-download"></i> 저장</button>
	
	<br>
		
		
	<span id="selectedCheckboxCount">0</span>
		
		
	<div class="bg-light text-center rounded p-4">
		<div class="d-flex align-items-center justify-content-between mb-4">

		</div>
		<div class="table-responsive">
			<table id="table-fiList" class="table text-start align-middle table-bordered table-hover mb-0">
					<tr class="text-dark">
						<th scope="col"><input class="form-check-input"	type="checkbox" id="cbx_chkAll"></th>
						<th scope="col">품질검사코드</th>
						<th scope="col">출고검사 타입</th>
						<th scope="col">출고코드</th>
						<th scope="col">창고</th>
						<th scope="col">품목코드</th>
						<th scope="col">품목명</th>
						<th scope="col">검수자</th>
						<th scope="col">검수일자</th>
						<th scope="col">검수량</th>
						<th scope="col">주문수량</th>
						<th scope="col">불량수량</th>
						<th scope="col">검수상태</th>
					</tr>
					<c:forEach var="vo" items="${mrList}" varStatus="status">
						<tr>
							<td><input class="form-check-input" type="checkbox" name="selectedQcId" value="${vo.qc_id}"></td>
							<td>${vo.qc_num}</td>
							<td>${vo.fi_type}</td>
							<td>${vo.fi_type == '자재' ? vo.mr_num : vo.pr_num}</td>
							<td>${vo.wh_name}</td>
							<td>${vo.fi_type == '자재' ? vo.ma_num : vo.pro_num}</td>
							<td>${vo.fi_type == '자재' ? vo.ma_name : vo.pro_name}</td>
							<td>${vo.emp_name}</td>
							<td>
								<c:if test="${!empty vo.update_date}">${fn:substring(vo.update_date, 0, 10)}</c:if>
								<c:if test="${empty vo.update_date}">${fn:substring(vo.qc_date, 0, 10)}</c:if>
							</td>
							<td>${vo.qc_cnt}</td>
							<td>${vo.fi_type == '자재' ? vo.mr_cnt : vo.pr_cnt}</td>
							<td>${vo.df_cnt}</td>
							<td>${vo.qc_yn}</td>
						</tr>
					</c:forEach>
			</table>
		</div>
	</div>
	</form>
	
			<!-- 페이지 이동 버튼 -->
	
			<nav aria-label="Page navigation example">
		  		<ul class="pagination justify-content-center pagination-sm">
		  		
		  			<c:if test="${pm.prev }">
					<li class="page-item">
						<a class="page-link" href="/production/quality/qualitylist?page=${pm.startPage-1 }&qc_num=${qc_num}&startDate=${startDate}&endDate=${endDate}&qc_yn=${qc_yn}" aria-label="Previous">
		       			<span aria-hidden="true">&laquo;</span>
		      			</a>
		    		</li>
		    		</c:if>
		    		
		    		<c:forEach begin="${pm.startPage }" end="${pm.endPage }" step="1" var="idx">
		    		<li 
		    			<c:out value="${pm.pageVO.page == idx ? 'class=page-item active': 'class=page-item'}" />
		    		>
		    				<a class="page-link" href="/production/quality/qualitylist?page=${idx}&qc_num=${qc_num}&startDate=${startDate}&endDate=${endDate}&qc_yn=${qc_yn}">${idx }</a>
		    		</li>
		    		</c:forEach>
					
					<c:if test="${pm.next && pm.endPage > 0}">
					<li class="page-item">
		      			<a class="page-link" href="/production/quality/qualitylist?page=${pm.endPage+1 }&qc_num=${qc_num}&startDate=${startDate}&endDate=${endDate}&qc_yn=${qc_yn}" aria-label="Next">
		        		<span aria-hidden="true">&raquo;</span>
		      			</a>
		    		</li>
		    		</c:if>
		    		
		  		</ul>
			</nav>
			
			<!-- 페이지 이동 버튼 -->
		

</body>
</html>

<%@ include file="../../inc/footer.jsp"%>