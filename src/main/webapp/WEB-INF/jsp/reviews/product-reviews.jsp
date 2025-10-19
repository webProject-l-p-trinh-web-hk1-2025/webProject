<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib
uri="http://www.springframework.org/tags/form" prefix="form" %>
<html>
  <head>
    <title>Reviews for product ${productId}</title>
  </head>
  <body>
    <h1>Reviews for product ${productId}</h1>

    <c:if test="${not empty error}">
      <div style="color: red">${error}</div>
    </c:if>

    <c:forEach var="review" items="${reviewsPage.content}">
      <div style="border: 1px solid #ccc; padding: 8px; margin: 8px 0">
        <div><strong>User:</strong> ${review.userId}</div>
        <div><strong>Rating:</strong> ${review.rating}</div>
        <div><strong>Comment:</strong> ${review.comment}</div>
        <div><a href="/reviews/${review.reviewId}">View thread</a></div>
        <div>
          <a
            href="/products/${productId}/reviews/new?parentReviewId=${review.reviewId}"
            >Reply</a
          >
        </div>

        <!-- child replies (level 1) -->
        <c:if test="${not empty review.childReviews}">
          <div style="margin-left: 24px; margin-top: 8px">
            <c:forEach var="child" items="${review.childReviews}">
              <div
                style="border-left: 2px solid #ddd; padding: 6px; margin: 6px 0"
              >
                <div><strong>User:</strong> ${child.userId}</div>
                <div><strong>Comment:</strong> ${child.comment}</div>
                <div>
                  <a
                    href="/products/${productId}/reviews/new?parentReviewId=${child.reviewId}"
                    >Reply</a
                  >
                </div>

                <!-- grandchildren (level 2) -->
                <c:if test="${not empty child.childReviews}">
                  <div style="margin-left: 20px; margin-top: 6px">
                    <c:forEach var="gc" items="${child.childReviews}">
                      <div
                        style="
                          border-left: 2px dashed #eee;
                          padding: 4px;
                          margin: 4px 0;
                        "
                      >
                        <div><strong>User:</strong> ${gc.userId}</div>
                        <div><strong>Comment:</strong> ${gc.comment}</div>
                      </div>
                    </c:forEach>
                  </div>
                </c:if>
              </div>
            </c:forEach>
          </div>
        </c:if>
      </div>
    </c:forEach>

    <div>
      <c:if test="${reviewsPage.totalPages > 1}">
        <c:forEach var="i" begin="0" end="${reviewsPage.totalPages - 1}">
          <a href="?page=${i}&size=${pageSize}">${i + 1}</a>
        </c:forEach>
      </c:if>
    </div>

    <div>
      <a href="/products/${productId}/reviews/new">Add review</a>
    </div>
  </body>
</html>
