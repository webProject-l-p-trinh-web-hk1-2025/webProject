<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/css/header.css" var="headerCss" />
<link rel="stylesheet" href="${headerCss}" />

<header class="site-header">
  <div class="site-header-inner">
    <a href="${pageContext.request.contextPath}/home" class="brand">
      <img src="${pageContext.request.contextPath}/image/cellphone-store-logo.svg" alt="Logo" class="brand-logo">
      <span class="brand-text">CellPhone Store</span>
    </a>
  </div>
</header>
