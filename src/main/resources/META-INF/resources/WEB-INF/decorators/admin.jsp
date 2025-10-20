<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<title>Trang admin</title>
	</head>

	<body>
		<%@ include file="/common/headerAdmin.jsp" %>

			<sitemesh:write property="body" />

			<%@ include file="/common/footer.jsp" %>
	</body>

	</html>