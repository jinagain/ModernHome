<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
		<h1>사원조회</h1>
		

	<table border="1">
		<tr>
			<td>사진</td>
			<td>사원번호</td>
			<td>이름</td>
			<td>성별</td>
			<td>생년월일</td>
			<td>부서</td>
			<td>직급</td>
			<td>권한</td>
			<td>상태</td>
			<td>전화번호</td>
			<td>입사날짜</td>
			<td>퇴사날짜</td>
			<td>휴직날짜</td>
		</tr>
		<c:forEach var="employeeList" items="${employeeList }">
		<tr>
			<td>사진</td>
			<td>${employeeList.emp_id }</td>
			<td>${employeeList.emp_name }</td>
			<td>${employeeList.emp_gender }</td>
			<td>${employeeList.emp_birth }</td>
			<td>${employeeList.emp_dept }</td>
			<td>${employeeList.emp_rank }</td>
			<td>${employeeList.emp_auth }</td>
			<td>${employeeList.emp_state }</td>
			<td>${employeeList.emp_tel }</td>
			<td>${employeeList.emp_hire_date }</td>
			<td>${employeeList.emp_rsgnt_date }</td>
			<td>${employeeList.emp_start_leave_date }</td>
		</tr>
		</c:forEach>
	</table>


</body>
</html>