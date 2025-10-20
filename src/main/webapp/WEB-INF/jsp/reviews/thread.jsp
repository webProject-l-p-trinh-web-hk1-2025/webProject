<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
  <head>
    <title>Review thread</title>
  </head>
  <body>
    <c:if test="${not empty review}">
      <h2>Review by ${review.userId}</h2>
      <div>Rating: ${review.rating}</div>
      <div>${review.comment}</div>
      <h3>Replies</h3>
      <c:if test="${not empty review.childReviewIds}">
        <ul>
          <c:forEach var="cid" items="${review.childReviewIds}">
            <li>Reply id: ${cid} (view detail via /reviews/${cid})</li>
          </c:forEach>
        </ul>
      </c:if>
      <div>
        <a
          href="/products/${review.productId}/reviews/new?parentReviewId=${review.reviewId}"
          >Reply</a
        >
      </div>
    </c:if>
  </body>
</html>
