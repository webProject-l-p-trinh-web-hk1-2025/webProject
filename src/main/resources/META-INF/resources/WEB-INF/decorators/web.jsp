<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Trang User</title>
    <sitemesh:write property="head" />
  </head>

  <body>
    <%@ include file="/common/header.jsp" %>

    <sitemesh:write property="body" />

    <%@ include file="/common/footer.jsp" %>
  </body>
</html>
