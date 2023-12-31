<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ include file="../../inc/header.jsp"%>
<%@ include file="../../inc/sidebar.jsp"%>
<%@ include file="../../inc/nav.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" />
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
<script>
	$(document).ready(function() {
		var pageStatus = "";
		
		// 체크박스 선택 시 체크박스의 개수 구하기
        updateSelectedCheckboxCount();
		
		// 체크박스 선택 시 체크박스 개수 구하기
        function updateSelectedCheckboxCount() {
            var totalCheckboxes = $(".table-defective td input[type='checkbox']").length;
            var selectedCheckboxes = $(".table-defective td input[type='checkbox']:checked").length;
            $("#selectedCheckboxCount").text("전체 ("+selectedCheckboxes + '/' + totalCheckboxes+")");
        }
		
		// 추가 버튼 클릭 시 행 추가
        $("#addRowButton").click(function() {
        	var now = new Date();
			var today = now.getFullYear() + '-' + ('0' + (now.getMonth() + 1)).slice(-2) + '-' + now.getDate();
        	
			var newRow = '<tr>' +
						 '<td><input type="checkbox" class="form-check-input"></td>' +
						 '<td><input type="text" class="form-control" name="df_num" value="${dfNum[0].df_num}" style="border: none; background: transparent;" readonly></td>' +
						 '<td id="typePop"><input id="dfTypePop" type="text" class="form-control" name="df_type" placeholder="(클릭)" readonly></td>' +
						 '<td><input id="code1" type="text" class="form-control" style="border: none; background: transparent;" readonly>' +
						 '<td><input id="code2" type="text" class="form-control" style="border: none; background: transparent;" readonly>' +
						 '<td><input id="code3" type="text" class="form-control" style="border: none; background: transparent;" readonly>' +
						 '<td>${sessionScope.emp_name}<input type="hidden" class="form-control" name="emp_id" value="${sessionScope.emp_id}" style="border: none; background: transparent;"></td>' +
						 '<td><input type="text" class="form-control" name="reg_date" value="' + today + '" style="border: none; background: transparent;" readonly></td>' +
						 '<td><input id="df_cnt" type="number" class="form-control" name="df_cnt"></td>' +
						 '<td><input id="df_rsns" type="text" class="form-control" name="df_rsns"></td>' +
						 '<td><select id="repair_yn" class="form-control" name="repair_yn">' +
						 '<option value="가능">가능</option>' +
						 '<option value="불가">불가</option>' +
						 '</select></td>' +
						 '<td><input type="text" class="form-control" name="solved_date" style="border: none; background: transparent;" readonly>' +
						 '<input type="hidden" class="form-control" name="df_id" value="${dfNum[0].df_id}">' +
						 '<input type="hidden" class="form-control" name="qc_id">' +
						 '<input type="hidden" class="form-control" name="work_id">' +
						 '<input type="hidden" class="form-control" name="rec_id">' +
						 '<input type="hidden" class="form-control" name="mr_id">' +
						 '<input type="hidden" class="form-control" name="pr_id">' +
						 '<input type="hidden" class="form-control" name="line_id">' +
						 '<input type="hidden" class="form-control" name="pro_id"></td>' +
						 '<input type="hidden" class="form-control" name="ma_id"></td>' +
						 '</tr>';
			
			// 클릭 시 팝업창 열기
			$(document).on("click", "td[id='typePop']", function() {
				window.name = "add";
				var left = (screen.width - 700) / 2;
				var top = (screen.height - 500) / 2;
				window.open('/production/defective/addPopup', 'popup', 'width=700, height=500, top=' + top + ', left=' + left + ', location=no, status=no, scrollbars=yes');
			});
			
			// 첫번째 자식<tr> 뒤에서 부터 행을 추가함
			$(".table-defective tr:nth-child(1)").after(newRow);
			
			// 추가버튼, 취소버튼 활성화
			$("#addRowButton").attr("disabled", "disabled");
			$("#updateButton").attr("disabled", "disabled");
			$("#deleteButton").attr("disabled", "disabled");
			$("#cancleButton").removeAttr("disabled");
			$("#submitButton").removeAttr("disabled");
			
			pageStatus = "reg";
		});
		
		var cellButton = "";

		// 수정 버튼 누를 시
		$("#updateButton").click(function(){
			var dfCheckbox = $("input[name='df_id']:checked");
			
			// 체크된 체크박스가 하나인 경우에만 수정 기능 작동
			if (dfCheckbox.length === 1) {
				var df_id = dfCheckbox.val();
				var row = dfCheckbox.closest("tr");
				
				var rd = row.find("button[type='button']").text();
				cellButton = $(this).find(".reAndDis").html();
				
				if(rd === '완료') {
					alert("수리나 폐기 처리가 완료된 후에는 수정 불가능합니다!");
					return false;
				}
				
				// input type의 name 값 지정
				var cellNames = [
					"df_num",
					"df_type",
					"work_num",
					"pro_num",
					"pro_name",
					"emp_name",
					"reg_date",
					"df_cnt",
					"df_rsns",
					"repair_yn",
					"solved_date"
				];
				
				// 각 셀을 수정 가능한 텍스트 입력 필드로 변경
				row.find("td:not(:first-child)").each(function(index) {
					var cellValue = $(this).text();
					var cellType = "text";
					var cellName = cellNames[index];
					
					if(index === 2) {
						$(this).html('<input id="dfTypePop" class="form-control" type="' + cellType + '" name="' + cellName + '" value="' + cellValue + 
								'" style="border: none; background: transparent;" readonly>');
					} else if(index === 8) {
						$(this).html('<input id="df_rsns" class="form-control" type="' + cellType + '" name="' + cellName + '" value="' + cellValue + '">');
					} else if(index === 9) {
						$(this).html(
							'<select id="repair_yn" class="form-control" name="' + cellName + '">'
							+ '<option value="가능">가능</option>'
							+ '<option value="불가">불가</option>'
							+ '</select>');
					} else if(index === 13) {
// 						var rdClass = rd === '수리' ? "btn btn-sm btn-success reAndDis" : "btn btn-sm btn-danger reAndDis";
// 						$(this).html('<button type="button" class="' + rdClass + '" disabled>' + rd + '</button>');
						$(this).find(".reAndDis").attr("disabled", "disabled");
					} else {
						$(this).html('<input class="form-control" type="' + cellType + '" name="' + cellName + '" value="' + cellValue + 
								'" style="border: none; background: transparent;" disabled>');
					}
					
					$("#updateButton").attr("disabled", "disabled");
					$("#addRowButton").attr("disabled", "disabled");
					$("#deleteButton").attr("disabled", "disabled");
					$("#cancleButton").removeAttr("disabled");
					$("#submitButton").removeAttr("disabled");
					
					pageStatus = "update";
				});
			}else if (dfCheckbox.length === 0){
				alert("수정할 행을 선택하세요!")
				return false;
			}else {
				alert("수정은 하나의 행만 가능합니다!");
				return false;
			}
		});
		
		// 취소 버튼 누를 시 
		$("#cancleButton").click(function(){
			// 등록버튼 취소
			if(pageStatus == "reg"){
				// 두번째 tr (추가된 행)을 삭제함
				$(".table-defective tr:nth-child(2)").remove();
				
				// 추가버튼, 취소버튼 비활성화
				$("#addRowButton").removeAttr("disabled");
				$("#deleteButton").removeAttr("disabled");
				$("#cancleButton").attr("disabled", "disabled");
				$("#submitButton").attr("disabled", "disabled");
				
				pageStatus = "";
			}
			// 수정버튼 취소
			if(pageStatus == "update"){
				
				// 모든행에 대해 반복작업, 테이블 이름에 맞게 수정
				$(".table-defective tr").each(function() {
				var row = $(this);
					
				// 폼 초기화(기존내용으로)
				$("#defList")[0].reset();
				
				// 각 셀의 값을 원래 상태로 되돌림
				row.find("td:not(:first-child)").each(function(index) {
					var cellValue = $(this).find("input").val();
					var cellValueSelect = $(this).find("select").val();
					
					$(this).html(cellValue);
					$(this).html(cellValueSelect);
					
					if(index === 13) {
						$(this).find(".reAndDis").removeAttr("disabled");
					}
				});
				
				// selected 클래스를 없앰 (css 없애기)
				$(".table-defective tr").removeClass("selected");
				
				// 추가버튼, 수정버튼 활성화, 취소버튼 비활성화
				$("#addRowButton").removeAttr("disabled");
				$("#updateButton").removeAttr("disabled");
				$("#deleteButton").removeAttr("disabled");
				
				$("#cancelButton").attr("disabled", "disabled");
				$("#submitButton").attr("disabled", "disabled");
				
				pageStatus = "";
				});
			}
		});
        
		// <th> 쪽 체크박스 클릭 시 해당 열의 <td> 부분의 행들을 선택하고 배경색 지정
		$(".table-defective th input[type='checkbox']").click(function() {
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
		$(".table-defective td input[type='checkbox']").click(function() {
			var checkbox = $(this);
			var isChecked = checkbox.prop('checked');
			checkbox.closest('tr').toggleClass('selected', isChecked);
			
			updateSelectedCheckboxCount();
		});
		
		// 삭제 버튼 누를 시
		$("#deleteButton").click(function(){
			var dfCheckbox = $("input[name='df_id']:checked");
// 			var df_id = dfCheckbox.val();
			
			if(dfCheckbox.length === 0) {
				alert("삭제할 행을 선택해주세요!");
				
				// 선택안하면 submit을 막음
				event.preventDefault();
				return false;
			}
		});
		
		// 엔터키 입력 시 삭제(submit) 버튼 활성화 막기
		$("#defList").on("keydown", function(event) {
			if (event.keyCode === 13) {
				event.preventDefault();
			}
		});
		
	 	// 유효성 검사
	 	$("#submitButton").click(function() {
	 		var form = $("#defList");
	 		form.attr("method", "post");
	 		form.attr("action", "/production/defective/regDef");
			
	 		var df_type = $("#dfTypePop").val();
	 		var df_rsns = $("#df_rsns").val();
	 		var repair_yn = $("#repair_yn").val();
			
	 		if(df_type == null || df_type == "") {
	 			alert("불량 타입을 입력하세요!");
	 			$("#dfTypePop").focus();
	 			return false;
	 		}
	 		if(df_rsns == null || df_rsns == "") {
	 			alert("불량 사유를 입력하세요!");
	 			$("#df_rsns").focus();
	 			return false;
	 		}
	 		if(repair_yn == null || repair_yn == "") {
	 			alert("수리 가능 여부를 선택하세요!");
	 			$("#repair_yn").focus();
	 			return false;
	 		}
	 		form.submit();
	 	});
	 	
		$(".reAndDis").click(function() {
			console.log("클릭함!");
			
			var df_id = $(this).closest('tr').find("input[name='df_id']").val();
			var df_cnt = $(this).closest('tr').find("td:eq(8)").text();
			var pro_id = $(this).closest('tr').find("td:eq(12)").text();
			var ma_id = $(this).closest('tr').find("td:eq(13)").text();
			var empAuth = ${sessionScope.emp_auth};
			var empId = ${sessionScope.emp_id};
			var data = {
							df_id : df_id,
							df_cnt : df_cnt,
							pro_id : pro_id,
							ma_id : ma_id,
							emp_id : empId
						};
			
			var rd = $(this).closest('tr').find("button[type='button']").text();
			
			if(empAuth === 1) {
				alert("권한이 없습니다.");
				return false;
			}
			
			if(rd === "수리") {
				Swal.fire({
					title: '수리 처리 하시겠습니까?',
					text: '처리 후 수정할 수 없습니다.',
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
		            cancelButtonColor: '#d33',
		            confirmButtonText: '승인',
		            cancelButtonText: '취소'
				}).then((result) => {
					if(result.isConfirmed) {
						$.ajax({
							url : "${contextPath}/production/defective/repair",
							type : "POST",
							contentType : "application/json",
							data : JSON.stringify(data),
							success : function() {
								Swal.fire({
									title: '처리 완료되었습니다!',
									icon: 'success',
									confirmButtonColor: '#3085d6'
								}).then((result) => {
									if(result.isConfirmed) {
										location.reload();
									}
								});
							},
							error : function() {
								alert("처리 실패했습니다!");
							}
						});
					}
				});
			}	// 수리 클릭 시
			
			if(rd === "폐기") {
				Swal.fire({
					title: '폐기 처리 하시겠습니까?',
					text: '처리 후 수정할 수 없습니다.',
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
		            cancelButtonColor: '#d33',
		            confirmButtonText: '승인',
		            cancelButtonText: '취소'
				}).then((result) => {
					if(result.isConfirmed) {
						$.ajax({
							url : "${contextPath}/production/defective/discard",
							type : "POST",
							contentType : "application/json",
							data : JSON.stringify(data),
							success : function() {
								Swal.fire({
									title: '처리 완료되었습니다!',
									icon: 'success',
									confirmButtonColor: '#3085d6'
								}).then((result) => {
									if(result.isConfirmed) {
										location.reload();
									}
								});
							},
							error : function() {
								alert("처리 실패했습니다!");
							}
						});
					}
				});
			}	// 폐기 클릭 시
		});
	});
</script>

<style>
.selected {
	background-color: #b3ccff;
}
</style>

<form method="get" class="bg-light rounded p-3 m-3">
	<div class="row mb-3">
		<label class="col-sm-2 col-form-label">불량 타입</label>
		<div class="col-sm-2">
			<select name="df_type" class="form-select" style="background-color: #fff;">
				<option value="all">전체</option>
				<option value="pro">공정검사</option>
				<option value="ma">수입검사</option>
				<option value="re">출고검사</option>
			</select>
		</div>
	</div>
	<div class="row mb-3">
		<label class="col-sm-2 col-form-label">품목명</label>
		<div class="col-sm-4">
			<input type="text" name="nameSearch" placeholder="품목명을 입력하세요" class="form-control" value="${param.nameSearch}">
		</div>
		
		<div class="col-auto">
			<button class="btn btn-primary m-3" type="submit" style="width:70px;">조회</button>
		</div>
	</div>
</form>

<hr>
		
<form id="defList">
	<div class="d-flex align-items-center justify-content-between mb-2">
		<h3 class="m-4">불량 리스트</h3>
		<div class="me-2">
			<c:if test="${sessionScope.emp_dept eq '품질' && sessionScope.emp_auth >= '2' || sessionScope.emp_auth == '3'}">
				<button type="button" class="btn btn-primary m-2" id="addRowButton"><i class="fa fa-plus"></i> 추가</button>
				<button type="button" class="btn btn-primary m-2" id="cancleButton" disabled>X 취소</button>
				<button type="button" class="btn btn-primary m-2" id="updateButton">
						<i class="fa fa-edit"></i> 수정</button>
				<button type="submit" class="btn btn-primary m-2" id="deleteButton" formaction="delDef" formmethod="post">
					<i class="fa fa-trash"></i> 삭제</button>
				<button type="button" class="btn btn-primary m-2" id="submitButton" formaction="regDef" formmethod="post" disabled>
					<i class="fa fa-download"></i> 저장</button>
			</c:if>
		</div>
	</div>
	
	<div class="bg-light text-center rounded p-4 m-3">
		<div class="d-flex align-items-center justify-content-between mb-4">
			<span id="selectedCheckboxCount">0</span>
		</div>
		
		<div class="table-responsive">
			<!-- 불량 리스트 -->
			<table class="table-defective table align-middle table-bordered table-hover mb-0">
				<tr>
					<th style="background-color: rgba(0,0,0,0.075);"><input type="checkbox" class="form-check-input"></th>
					<th style="background-color: rgba(0,0,0,0.075);">불량코드</th>
					<th style="background-color: rgba(0,0,0,0.075);">불량타입</th>
					<th style="background-color: rgba(0,0,0,0.075);">공정코드</th>
					<th style="background-color: rgba(0,0,0,0.075);">품목코드</th>
					<th style="background-color: rgba(0,0,0,0.075);">품목명</th>
					<th style="background-color: rgba(0,0,0,0.075);">검수자</th>
					<th style="background-color: rgba(0,0,0,0.075);">등록일자</th>
					<th style="background-color: rgba(0,0,0,0.075);">불량수량</th>
					<th style="background-color: rgba(0,0,0,0.075);">불량사유</th>
					<th style="background-color: rgba(0,0,0,0.075);">수리가능 여부</th>
					<th style="background-color: rgba(0,0,0,0.075);">처리일</th>
					<th style="background-color: rgba(0,0,0,0.075);">수리/폐기</th>
				</tr>
			
				<c:forEach var="df" items="${dfList}">
					<tr>
						<td><input type="checkbox" class="form-check-input" name="df_id" value="${df.df_id}"></td>
						<td>${df.df_num}</td>
						<td>${df.df_type}</td>
						<c:if test="${df.df_type == '공정검사'}"><td>${df.work_num}</td></c:if>
						<c:if test="${df.df_type == '수입검사'}"><td>${df.rec_num}</td></c:if>
						<c:if test="${df.df_type == '출고검사'}"><td>${!empty df.mr_id ? df.mr_num : df.pr_num}</td></c:if>
						
						<c:if test="${df.df_type == '공정검사'}"><td>${df.pro_num}</td></c:if>
						<c:if test="${df.df_type == '수입검사'}"><td>${df.ma_num}</td></c:if>
						<c:if test="${df.df_type == '출고검사'}"><td>${!empty df.mr_id ? df.ma_num : df.pro_num}</td></c:if>
						
						<c:if test="${df.df_type == '공정검사'}"><td>${df.pro_name}</td></c:if>
						<c:if test="${df.df_type == '수입검사'}"><td>${df.ma_name}</td></c:if>
						<c:if test="${df.df_type == '출고검사'}"><td>${!empty df.mr_id ? df.ma_name : df.pro_name}</td></c:if>
						<td>${df.emp_name}</td>
						<c:if test="${!empty wp.update_date}"><td>${fn:substring(df.update_date, 0, 10)}</td></c:if>
						<c:if test="${empty wp.update_date}"><td>${fn:substring(df.reg_date, 0, 10)}</td></c:if>
						<td>${df.df_cnt}</td>
						<td>${df.df_rsns}</td>
						<td>${df.repair_yn}</td>
						<td>${fn:substring(df.solved_date, 0, 10)}</td>
						<td style="display: none;">${df.pro_id}</td>
						<td style="display: none;">${df.ma_id}</td>
						<c:if test="${df.solved_date == null && !df.df_type.equals('수입검사') && df.repair_yn.equals('가능')}">
							<td><button type="button" class="btn btn-sm btn-success reAndDis">수리</button></td>
						</c:if>
						<c:if test="${df.solved_date == null && !df.df_type.equals('수입검사') && df.repair_yn.equals('불가')}">
							<td><button type="button" class="btn btn-sm btn-danger reAndDis">폐기</button></td>
						</c:if>
						<c:if test="${df.solved_date != null}">
							<td><button type="button" class="btn btn-sm btn-outline-secondary" disabled>완료</button></td>
						</c:if>
					</tr>
				</c:forEach>
			</table>
			<!-- 불량 리스트 -->
		</div>
	</div>
</form>

<!-- 페이지 이동 버튼 -->
<nav aria-label="Page navigation example">
 	<ul class="pagination justify-content-center pagination-sm">
 		<c:if test="${pm.prev}">
			<li class="page-item">
				<a class="page-link" 
				href="/production/defective/list?page=${pm.startPage - 1}&df_type=${df_type}&nameSearch=${nameSearch}&line_num=${line_num}&nameSearch=${nameSearch}" 
				aria-label="Previous">
	      			<span aria-hidden="true">&laquo;</span>
	     		</a>
	   		</li>
   		</c:if>
   		
   		<c:forEach begin="${pm.startPage}" end="${pm.endPage}" step="1" var="idx">
	   		<li class="<c:out value='${pm.pageVO.page == idx ? "page-item active" : "page-item"}' />">
	   			<a class="page-link" href="/production/defective/list?page=${idx}&df_type=${df_type}&nameSearch=${nameSearch}&line_num=${line_num}&nameSearch=${nameSearch}">${idx}</a>
	   		</li>
   		</c:forEach>
		
		<c:if test="${pm.next && pm.endPage > 0}">
			<li class="page-item">
	     		<a class="page-link" 
	     		href="/production/defective/list?page=${pm.endPage + 1}&df_type=${df_type}&nameSearch=${nameSearch}&line_num=${line_num}" 
	     		aria-label="Next">
	       			<span aria-hidden="true">&raquo;</span>
	     		</a>
	   		</li>
   		</c:if>
 	</ul>
</nav>
<!-- 페이지 이동 버튼 -->

<%@ include file="../../inc/footer.jsp"%>