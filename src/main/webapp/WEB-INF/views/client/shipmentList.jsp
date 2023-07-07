<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../inc/header.jsp"%>
<%@ include file="../inc/sidebar.jsp"%>
<%@ include file="../inc/nav.jsp"%>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

var pageStatus = "";

$(document).ready(function() {
	
	updateSelectedCheckboxCount();

	// <th> 쪽 체크박스 클릭 시 해당 열의 <td> 부분의 행들을 선택하고 배경색 지정
	$(".table-shipmentList th input[type='checkbox']").click(function() {
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
				if (isChecked) {
					$(this).addClass('selected');
				} else {
					$(this).removeClass('selected');
				}
			}
		});
		updateSelectedCheckboxCount();
	});
	
	// <td> 쪽 체크박스 클릭 시 행 선택
	$(".table-shipmentList td input[type='checkbox']").click(function() {
		var checkbox = $(this);
		var isChecked = checkbox.prop('checked');
		checkbox.closest('tr').toggleClass('selected', isChecked);
		
		updateSelectedCheckboxCount();
	});
	
	// ------------------ 체크박스
	
		// 출고 코드 입력란 클릭 시 팝업창 열기
	    $(document).on("click", "input[name='pr_num']", function() {
	    	var left = (screen.width - 600) / 2;
			var top = (screen.height - 680) / 2;
	    	window.open('/client/addPopup?txt=clt2', 'popup', 'width=600, height=680, top=' + top + ', left=' + left + ', location=no, status=no, scrollbars=yes');
	    });
	
	
	    // 출하 처리 버튼
 		$(".release").click(function () {
 			var shp_num = $(this).closest("tr").find('td:eq(0)').find('input').val();
 			var shp_state = $(this).closest("tr").find('td:eq(10)').text();
 			
 			if(result = window.confirm("출하 하시겠습니까? (출하 후 변경이 불가능합니다.)")) {
 				location.href = "/client/acceptRelease?txt=mr&shp_num=" + shp_num + "&shp_state=" + shp_state; 				
 			}
 			
 		});
	
	// 추가 버튼 클릭 시 행 추가
	// 추가버튼 1번 누르면 추가버튼 비활성화
	$("#addRowButton").click(function() {
		
	
		
	    var currentDate = new Date();  // 현재 날짜 및 시간을 가져옴
	    var formattedDate = currentDate.toISOString().split('T')[0];  // 날짜 형식으로 변환 (YYYY-MM-DD)

		
		var newRow = '<tr>' +
		'<td><input type="checkbox" class="form-check-input"></td>' +
		'<td><input type="text" disabled="disabled" value="(자동으로 부여)"></td>' +
		'<td><input type="text" name="emp_id" value="' + '${sessionScope.emp_id}' + '" readonly></td>' +
		'<td><input type="text" name="pr_num" id="pr_num" placeholder="여기를 눌러 검색하세요"></td>' +
		'<td><input type="text" name="oo_num" id="oo_num" readonly></td>' +
		'<td><input type="text" name="clt_name" id="clt_name" readonly></td>' +
		'<td><input type="text" name="pro_name" id="pro_name" readonly></td>' +
		'<td><input type="text" name="oo_cnt" id="oo_cnt" readonly></td>' +
		'<td><input type="text" name="oo_end_date" id="oo_end_date" readonly></td>' +
	    '<td><input type="date" name="shp_date" id="shp_date" value="' + formattedDate + '"></td>' +
		'<td><input type="text" name="shp_state" id="shp_state" value="출하준비" readonly></td>' +
		'<td><input type="text" name="shp_reg_date" readonly disabled></td>' +	
		'</td>' +
		'</tr>';
		
		// 첫번째 자식<tr> 뒤에서 부터 행을 추가함
		$(".table-shipmentList tr:nth-child(1)").after(newRow);
		
		// 버튼 활성화, 비활성화
		$("#addRowButton").attr("disabled", "disabled");
		$("#updateButton").attr("disabled", "disabled");
		$("#deleteShipmentButton").attr("disabled", "disabled");
		
		$("#cancleButton").removeAttr("disabled");
		$("#submitButton").removeAttr("disabled");
		
		pageStatus = "reg";
		
		updateSelectedCheckboxCount();
		
	}); // 여기까지 추가 버튼
	
	
    
    
 // 취소버튼
	$("#cancleButton").click(function(){
		
		$(document).off("click", "input[name='clt_name']");
	
		// 등록버튼 취소
		if(pageStatus == "reg"){
			// 두번째 tr (추가된 행)을 삭제함
			$(".table-shipmentList tr:nth-child(2)").remove();

			// 모든 체크박스의 체크 해제
			$(".table-shipmentList input[type='checkbox']").prop("checked", false);
			
			// selected 클래스를 없앰 (css 없애기)
			$(".table-shipmentList tr").removeClass("selected");
			
			
			// 버튼 활성화, 비활성화
			$("#addRowButton").removeAttr("disabled");
			$("#updateButton").removeAttr("disabled");
			$("#deleteButton").removeAttr("disabled");
			
			$("#cancleButton").attr("disabled", "disabled");
			$("#submitButton").attr("disabled", "disabled");
			
			pageStatus = "";
		}
		
		// 수정버튼 취소
		if(pageStatus == "update"){
			
			// 모든행에 대해 반복작업, 테이블 이름에 맞게 수정
			$(".table-shipmentList tr").each(function() {
			var row = $(this);
			
			// 폼 초기화(기존내용으로)
			// 가져가서 쓰는 경우 폼에 이름 지정해줘야해요
			$("#shipmentList")[0].reset();
			
			// 각 셀의 값을 원래 상태로 되돌림
			row.find("td:not(:first-child)").each(function(index) {
				
				var cellValue = $(this).data('prevValue'); // 수정 전의 기존값을 가져옴
				
				
				if ($(this).find("select").length) {
					// <select>가 있는 경우 선택된 옵션의 텍스트로 변경
					var selectedOptionText = $(this).find("select option:selected").text();
					$(this).html(selectedOptionText);
				}else {
					// <select>가 없는 경우 셀 값을 그대로 표시
					$(this).html(cellValue);
				}
			});
			
			
			
			// selected 클래스를 없앰 (css 없애기)
			$(".table-shipmentList tr").removeClass("selected");
			
			// 추가버튼, 수정버튼 활성화, 취소버튼 비활성화
			$("#addRowButton").removeAttr("disabled");
			$("#updateButton").removeAttr("disabled");
			$("#deleteButton").removeAttr("disabled");
			
			$("#cancleButton").attr("disabled", "disabled");
			$("#submitButton").attr("disabled", "disabled");
			
			
			pageStatus = "";
			
			});
		} // if(update)문
	
		updateSelectedCheckboxCount();
	}); // 취소버튼
	
	
	
	
	
    // 수정 버튼 누를 시
	$("#updateButton").click(function(){
		 
		var selectedCheckbox = $("input[name='selected']:checked");
		
		
		// 체크된 체크박스가 하나인 경우에만 수정 기능 작동
		if (selectedCheckbox.length === 1) {
			var empId = selectedCheckbox.val();
			var row = selectedCheckbox.closest("tr");
			
			
			
// 			var ooNumInput = '<input type="hidden" name="shp_num" value="' + shp_num + '">';
// 			$(this).closest("form").append(shpNumInput);
			
			// input type의 name 값 지정
			var cellNames = [
	            "shp_num",
	            "update_emp_id",
	            "pr_num",
	            "oo_num",
	            "clt_name",
	            "pro_name",
	            "oo_cnt",
	            "oo_end_date",
	            "shp_date",
	            "shp_state",
	            "update_shp_date",
			];
			
			
			// 각 셀을 수정 가능한 텍스트 입력 필드로 변경
			row.find("td:not(:first-child)").each(function(index) {
				//
				var cellValue = $(this).text();
				var cellType = [8].includes(index) ? "date" : "text"; // 날짜 타입은 date로 설정
				var cellReadonly = [0, 1, 3, 4, 5, 6, 7, 9, 10].includes(index) ? "readonly='readonly'" : "";
				var cellName = cellNames[index];
				var cellDisabled = [].includes(index)? "disabled" : "";
				var cellContent;
				

				if (index === 1){
					cellContent = '<td><input type="' + cellType + '" name="' + cellName + '" value="' + ${sessionScope.emp_id} + '"' + cellReadonly + '></td>';
				}
				else if (index === 9){
					return;
				}
				else {
					cellContent = '<td><input type="' + cellType + '" name="' + cellName + '" id="' + cellName + '"' + '" value="' + cellValue + '"'
// 					+ cellReadonly + '></td>';
					+ cellReadonly + ' ' + cellDisabled + '></td>';
				}
				
				
				// 기존 값을 임시 변수에 저장 -> 수정 후 취소버튼 시 담당자 칸에 세션값이 나오는 문제 해결위해
				$(this).data('prevValue', cellValue);
				
				
				$(this).html(cellContent);
				
				// 버튼 활성화, 비활성화
				$("#updateButton").attr("disabled", "disabled");
				$("#addRowButton").attr("disabled", "disabled");
				$("#deleteButton").attr("disabled", "disabled");
				
				$("#cancleButton").removeAttr("disabled");
				$("#submitButton").removeAttr("disabled");
				
				pageStatus = "update";
			});
			
		}else if (selectedCheckbox.length === 0){
			alert("수정할 행을 선택해주세요!")
			
		}else {
			alert("수정은 하나의 행만 가능합니다!");
		}
	}); 
	
	// 삭제버튼
	$("#deleteButton").click(function(){
		
		var selectedCheckbox = $("input[name='selected']:checked");
		
		// 체크된 체크박스가 하나인 경우에만 수정 기능 작동
		if (selectedCheckbox.length === 0){
			alert("삭제할 행을 선택하세요!");
			
			// 선택안하면 submit을 막음
			event.preventDefault();
		}
		
	});
	
	// submit버튼 유효성
	$("#submitButton").click(function() {
		
		var form = $("#shipmentList");
		form.attr("method", "post");
		form.attr("action", "/client/regShipment");
		var clt_num = $("#pr_num").val();
		var shp_date = $("#shp_date").val();
		
			// 등록할 때
			if(pageStatus == "reg"){
			
				if(pr_num == null || pr_num == "") {
					$("#pr_num").focus();
					alert("출고 코드를 입력하세요!");
					return;
				}
				if(shp_date == null || shp_date == "") {
					$("#shp_date").focus();
					alert("출하일자를 입력하세요!");
					return;
				}
				
				
			} //if문
			
			
			// 업데이트할 때
			if(pageStatus == "update"){
				if(pr_num == null || pr_num == "") {
					$("#pr_num").focus();
					alert("출고 코드를 입력하세요!");
					return;
				}
				if(shp_date == null || shp_date == "") {
					$("#shp_date").focus();
					alert("출하일자를 입력하세요!");
					return;
				}
			} //if문
			
			
		
		
		form.submit();
	}); //submit버튼 유효성
	
	// 체크박스 선택 시 체크박스 개수 구하기
	function updateSelectedCheckboxCount() {
		var totalCheckboxes = $(".table-shipmentList td input[type='checkbox']").length;
		var selectedCheckboxes = $(".table-shipmentList td input[type='checkbox']:checked").length;
		$("#selectedCheckboxCount").text("전체 ("+selectedCheckboxes + '/' + totalCheckboxes+")");
	}
	


}); //jQuery
</script>





<style>
.selected {
   background-color: #b3ccff;
}
</style>

<!-- http://localhost:8088/client/shipmentList -->
<body>
		<form method="get" name="search" action="" class="bg-light rounded p-3 m-3">
	
	<div class="row mb-3">
		<label for="ioSearch" class="col-sm-2 col-form-label"><b>출하일자</b></label>
			
			<div class="col-sm-2">
    			<div class="col-auto">
     			<input type="date" name="startDate" class="form-control">
     			</div>
   			</div>
   			
   				<div class="col-auto">
   				~
   				</div>
   				
     		<div class="col-sm-2">
    			<div class="col-auto">
    				<input type="date" name="endDate" class="form-control">
   				</div>
    		</div>
    		
   	</div>
   	
	
	<div class="row mb-3">
		<label for="ioSearch" class="col-sm-2 col-form-label"><b>거래처명</b></label>
		<div class="col-sm-4">
			<input type="text" name="clt_name" value="${svo.clt_name}" placeholder="거래처명을 입력하세요" class="form-control">
		</div>
	</div>
			
	<div class="row mb-3">
		<label for="ioSearch" class="col-sm-2 col-form-label"><b>담당자</b></label>
		<div class="col-sm-4">
			<input type="text" name="emp_name" value="${svo.emp_name}" placeholder="담당자를 입력하세요" class="form-control">
		</div>
		
		<div class="col-auto">
			<button class="btn btn-primary m-3" type="submit" style="width:70px;">조회</button>
		</div>
	</div>		
</form>
<!-- 검색칸 -->
             
		<form id="shipmentList" method="post">		
	<div class="d-flex align-items-center justify-content-between mb-2">             
		<h3 class="m-4">출하 목록</h3>
		<div>
			<c:if test="${(sessionScope.emp_dept eq '영업' && sessionScope.emp_auth == 2) || sessionScope.emp_auth == 3}">
			<button type="button" class="btn btn-primary m-2" id="addRowButton"><i class="fa fa-plus"></i> 추가</button>
			<button type="button" class="btn btn-primary m-2" id="cancleButton" disabled>X 취소</button>
			<button type="button" class="btn btn-primary m-2" id="updateButton"><i class="fa fa-edit"></i> 수정</button>
			<button type="submit" class="btn btn-primary m-2" id="deleteButton" formaction="deleteShipment" formmethod="post">
			<i class="fa fa-trash"></i> 삭제</button>
			<button type="submit" class="btn btn-primary m-2" id="submitButton" formaction="regShipment" formmethod="post" disabled>
			<i class="fa fa-download"></i> 저장</button>
		</c:if>
		</div>
	</div>
	
	<div class="bg-light text-center rounded p-4 m-3">
		<div class="d-flex align-items-center justify-content-between mb-4">	
			<span id="selectedCheckboxCount">0</span>
		</div>
	

		
		<div class="table-responsive">	
			<table class="table-shipmentList table align-middle table-bordered table-hover mb-0">
					<tr>
						<th style="background-color: rgba(0,0,0,0.075);"><input type="checkbox" class="form-check-input"></th>
				    	<th style="background-color: rgba(0,0,0,0.075);">출하<br>코드</th>
				    	<th style="background-color: rgba(0,0,0,0.075);">담당자</th>
				    	<th style="background-color: rgba(0,0,0,0.075);">출고<br>코드</th>
				    	<th style="background-color: rgba(0,0,0,0.075);">수주<br>코드</th>
				    	<th style="background-color: rgba(0,0,0,0.075);">거래처<br>이름</th>
				    	<th style="background-color: rgba(0,0,0,0.075);">완제품명</th>
				    	<th style="background-color: rgba(0,0,0,0.075);">출하량</th>
				    	<th style="background-color: rgba(0,0,0,0.075);">납기<br>예정일</th>
				    	<th style="background-color: rgba(0,0,0,0.075);">출하일자</th>
				    	<th style="background-color: rgba(0,0,0,0.075);">진행상황</th>
				    	<th style="background-color: rgba(0,0,0,0.075);">등록일</th>
					</tr>
					
				  	<c:forEach var="shipmentList" items="${shipmentList }">
						<tr>
							<td><input type="checkbox" name="selected" value="${shipmentList.shp_num}" class="form-check-input"></td>
							
							<td>${shipmentList.shp_num}</td>
							
							<td>${shipmentList.emp_name}</td>
					
				    		<td>${shipmentList.pr_num}</td>
				    		<td>${shipmentList.oo_num}</td>
				    		<td>${shipmentList.clt_name}</td>
				    		<td>${shipmentList.pro_name}</td>
				    		<td>${shipmentList.oo_cnt}</td>
				    		<td>${fn:substring(shipmentList.oo_end_date, 0, 10)}</td>
				    		<td>${fn:substring(shipmentList.shp_date, 0, 10)}</td>
				    		
				    		<td>
				    			<c:choose>
								<c:when test="${shipmentList.shp_state eq '출하준비' }">
								<c:if test="${(sessionScope.emp_dept eq '영업' && sessionScope.emp_auth == 2) || sessionScope.emp_auth == 3}">
								<button type="button" class="btn btn-sm btn-success release">출하<br>준비</button>
								</c:if>
								<c:if test="${(sessionScope.emp_dept ne '영업' || sessionScope.emp_auth ne 2) && sessionScope.emp_auth ne 3}">
								${shipmentList.shp_state}
								</c:if>
								</c:when>
								<c:when test="${shipmentList.shp_state eq '출하완료'}">
								<c:if test="${(sessionScope.emp_dept eq '영업' && sessionScope.emp_auth == 2) || sessionScope.emp_auth == 3}">
								<button type="button" class="btn btn-sm btn-primary">출하<br>완료</button> 
								</c:if>
								<c:if test="${(sessionScope.emp_dept ne '영업' || sessionScope.emp_auth ne 2) && sessionScope.emp_auth ne 3}">
								${shipmentList.shp_state}
								</c:if>
								</c:when>
								</c:choose>
				    		</td>
				    		<td>${fn:substring(shipmentList.shp_reg_date, 0, 10)}</td>
						</tr>
								<input type="hidden" name="pro_id" id="pro_id">
								<input type="hidden" name="clt_id" id="clt_id">
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
				<a class="page-link" href="/client/shipmentList?page=${pm.startPage-1 }&startDate=${svo.startDate}&endDate=${svo.endDate}&clt_name=${cvo.clt_name}&emp_name=${cvo.emp_name}" aria-label="Previous">
       			<span aria-hidden="true">&laquo;</span>
      			</a>
    		</li>
    		</c:if>
    		
    		<c:forEach begin="${pm.startPage }" end="${pm.endPage }" step="1" var="idx">
    		<li 
    			<c:out value="${pm.pageVO.page == idx ? 'class=page-item active': 'class=page-item'}" />
    		>
    				<a class="page-link" href="/client/shipmentList?page=${idx}&startDate=${svo.startDate}&endDate=${svo.endDate}&clt_name=${cvo.clt_name}&emp_name=${cvo.emp_name}">${idx }</a>
    		</li>
    		</c:forEach>
			
			<c:if test="${pm.next && pm.endPage > 0}">
			<li class="page-item">
      			<a class="page-link" href="/client/shipmentList?page=${pm.endPage+1 }&startDate=${svo.startDate}&endDate=${svo.endDate}&clt_name=${cvo.clt_name}&emp_name=${cvo.emp_name}" aria-label="Next">
        		<span aria-hidden="true">&raquo;</span>
      			</a>
    		</li>
    		</c:if>
    		
  		</ul>
	</nav>
	
	<!-- 페이지 이동 버튼 -->
</body>
</html>

<%@ include file="../inc/footer.jsp"%>