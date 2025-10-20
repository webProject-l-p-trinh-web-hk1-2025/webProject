<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <div class="navbar navbar-expand-lg navbar-dark" style="background-color: #dcda60;">
            <div class="container-fluid">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/">My bài làm giữa kì</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                        <c:choose>
                            <c:when test="${sessionScope.user == null}">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                                </li>
                            </c:when>

                            <c:when test="${sessionScope.user.admin}">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/admin">Trang quản
                                        trị</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                                </li>
                            </c:when>

                            <c:otherwise>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </div>