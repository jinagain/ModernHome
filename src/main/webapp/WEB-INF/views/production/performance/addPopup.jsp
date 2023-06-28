<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>

<link href="/resources/img/favicon.ico" rel="icon">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&display=swap" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
<link href="/resources/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
<link href="/resources/lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />
<link href="/resources/css/bootstrap.min.css" rel="stylesheet">
<link href="/resources/css/style.css" rel="stylesheet">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" />
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$("tr").click(function() {
			var work_id = $(this).find("td:eq(0)").text();
			var work_num = $(this).find("td:eq(1)").text();
			var pro_id = $(this).find("td:eq(2)").text();
			var pro_num = $(this).find("td:eq(3)").text();
			var pro_name = $(this).find("td:eq(4)").text();
			var line_id = $(this).find("td:eq(5)").text();
			var line_num = $(this).find("td:eq(6)").text();
			var work_cnt = $(this).find("td:eq(7)").text();
			
			opener.document.getElementsByName("work_id")[0].value = work_id;
			opener.document.getElementById("wnumPop").value = work_num;
			opener.document.getElementsByName("pro_id")[0].value = pro_id;
			opener.document.getElementsByName("pro_num")[0].value = pro_num;
			opener.document.getElementsByName("pro_name")[0].value = pro_name;
			opener.document.getElementsByName("line_id")[0].value = line_id;
			opener.document.getElementsByName("line_num")[0].value = line_num;
			opener.document.getElementsByName("work_cnt")[0].value = work_cnt;
			
			window.close();
		});
	});
</script>

<body>
	
<%-- 	${qiList} <hr> --%>
	
	<table border="1">
		<tr>
			<th colspan="8">작업지시</th>
		</tr>
		<c:forEach var="qi" items="${qiList}">
			<tr>
				<td>${qi.work_id}</td>
				<td>${qi.work_num}</td>
				<td style="display: none">${qi.pro_id}</td>
				<td style="display: none">${qi.pro_num}</td>
				<td style="display: none">${qi.pro_name}</td>
				<td style="display: none">${qi.line_id}</td>
				<td style="display: none">${qi.line_num}</td>
				<td style="display: none">${qi.work_cnt}</td>
			</tr>
		</c:forEach>
	</table>
	
</body>
</html>