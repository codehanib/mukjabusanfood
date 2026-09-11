<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 리스트</title>
<style>
    /* 리뷰 이미지 */
    .review-img {
        width: 100px;
        height: 100px;
        object-fit: cover;
        cursor: pointer;
    }
    .image-modal {
        display: none;
        position: fixed;
        z-index: 9999;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.8);

        justify-content: center;
        align-items: center;
    }
    /* 크게 보여줄 이미지 */
    .image-modal img {
        max-width: 70%;
        max-height: 70%;
        object-fit: contain;
    }
    /* 닫기 버튼 */
    .close-modal {
        position: absolute;
        top: 20px;
        right: 30px;
        color: white;
        font-size: 40px;
        font-weight: bold;
        cursor: pointer;
    }
</style>
</head>
<body>
	 <h2>식당 리뷰</h2>
	 전체 ${rvcount} 개
	 <br>
	 <br>
	 <c:choose>
	 	<c:when test="${not empty rvList}">
	 		<c:forEach var="rv" items="${rvList}">
	 			<table>
	 				<tr>
	 					<td colspan="2">${rv.u_name}
	 					<c:if test="${loginUserNo == rv.u_no}">
	 					<a href="/users/reviewUpdateForm?rv_no=${rv.rv_no}">수정</a>
	 					 <a href="/restaurant/reviewDelete?rv_no=${rv.rv_no}&r_no=${rv.r_no}">삭제</a>
	 					</c:if>
	 					</td>
	 				</tr>
	 				<tr>
	 					<td width="70">★ ${rv.rv_point}</td>
	 					<td><fmt:formatDate value="${rv.rv_reg_date}" pattern="yy/MM/dd"/></td>
	 				</tr>
	 				<tr>
	 					<td colspan="2">
	 						<c:forEach var="rg" items="${rv.reviewImages}">
	 						<c:choose>
	 							<c:when test="${rg.rvimg_img == null || rg.rvimg_img == ''}">
        								<!-- 이미지 없음 -->
    							</c:when>
	 							<c:when test="${fn:startsWith(rg.rvimg_img, 'http://')
                      							 or fn:startsWith(rg.rvimg_img, 'https://')}">
	 								<img src="${rg.rvimg_img}" width="100" height="100" class="review-img"
								     onclick="showImage(this.src)">
	 							</c:when>
	 							<c:otherwise>
	 								<img src="/upload/${rg.rvimg_img}" width="100" height="100" class="review-img"
 								    onclick="showImage(this.src)">
	 							</c:otherwise>
	 						</c:choose>
	 						</c:forEach>
	 					</td>
	 				</tr>
	 				<tr>
	 					<td colspan="2">${rv.rv_content}</td>
	 				</tr>
	 			</table>
	 			<hr>
	 		</c:forEach>
	 	</c:when>
	 	<c:otherwise>
	 		<p>리뷰가 없습니다.</p>
	 	</c:otherwise>
	 </c:choose>
	 <a href="/restaurant/detail?r_no=${r_no}">돌아가기</a>
<div id="imageModal" class="image-modal" onclick="closeImage()">
    <span class="close-modal">&times;</span>
    <img id="modalImage" src="" alt="리뷰 이미지">
</div>
<script>
	// 이미지 팝업
    function showImage(src) {
        const modal = document.getElementById("imageModal");
        const modalImage = document.getElementById("modalImage");
        modalImage.src = src;
        modal.style.display = "flex";
    }

    function closeImage() {
        const modal = document.getElementById("imageModal");
        modal.style.display = "none";
    }
</script>
</body>
</html>