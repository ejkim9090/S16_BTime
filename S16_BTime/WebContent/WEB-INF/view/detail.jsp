<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상세 도서</title>
<script src='./js/jquery-3.6.1.js'></script>
</head>
<body>
	<div>
		<h3>도서 상세 페이지</h3>
		<p>도서 DB 제공 : 알라딘 인터넷서점( www.aladin.co.kr)</p>
		<img src="${bookdetail.thum_img }" alt="${bookdetail.book_name }">
		<div>
			<p id="book_name">${bookdetail.book_name }</p>
			<p id="isbn">${bookdetail.isbn }</p>
			<p id="author">${bookdetail.author }</p>
			<p id="publisher">${bookdetail.publisher }</p>
			<p id="category">${bookdetail.category }</p>
			<br>
			<hr>
			<div>
				<p id="book_intro">${bookdetail.book_intro }</p>
			</div>
			<br>
			<div>
				<p id="total_grade">
					<c:choose>
						<c:when test="${(bookdetail.total_grade lt 1)}">
							☆☆☆☆☆
						</c:when>
						<c:when test="${(bookdetail.total_grade ge 1) && (bookdetail.total_grade lt 2 )}">
							★☆☆☆☆
						</c:when>
						<c:when test="${(bookdetail.total_grade ge 2) && (bookdetail.total_grade lt 3 ) }">
							★★☆☆☆
						</c:when>
						<c:when test="${(bookdetail.total_grade ge 3) && (bookdetail.total_grade lt 4 ) }">
							★★★☆☆
						</c:when>
						<c:when test="${(bookdetail.total_grade ge 4) && (bookdetail.total_grade lt 5 ) }">
							★★★★☆
						</c:when>
						<c:otherwise>
							★★★★★
						</c:otherwise>
					</c:choose>
					${bookdetail.total_grade }
				</p>
				<p id="grade_peo">(${bookdetail.grade_peo }명)</p>
			</div>
		</div>
		<br>
		<div>
			<p id="book_intro">${book.detail.book_intro }</p>
		</div>
		<div>
			<c:choose>
				<c:when test="${empty addChk }">
					<button type="button" id="loveadd" class="add">찜</button>
				</c:when>
				<c:otherwise>
					<button type="button" id="loveadd">찜 해제</button>
				</c:otherwise>
			</c:choose>
			<button type="button" id="btn_reading">도서 읽기</button>
			<!-- 여기서는 버튼을 누르면 마이페이지에 추가+새창 띄우기만 되도록 구현 -->
		</div>
		<br>
		<div>
			<div>
				<div class="star_grade">
					<label class="startRadio__box"> <input type="radio"
						name="grade" value="1"> <input type="radio" name="grade"
						value="2"> <input type="radio" name="grade" value="3">
						<input type="radio" name="grade" value="4"> <input
						type="radio" name="grade" value="5">
					</label>
				</div>
				<input type="text" name="review_add" value="추천합니다!">
				<button type="submit" id="btn_review_add">리뷰 작성</button>
			</div>
			<div>
				<div>리뷰목록</div>
				<div>
					<c:forEach items="${reviewlist }" var="review">
						<p class="id">${review.id }</p>
						<p class="each_grade">
							<c:choose>
								<c:when test="${review.each_grade eq 1 }">
									★☆☆☆☆
								</c:when>
								<c:when test="${review.each_grade eq 2 }">
									★★☆☆☆
								</c:when>
								<c:when test="${review.each_grade eq 3 }">
									★★★☆☆
								</c:when>
								<c:when test="${review.each_grade eq 4 }">
									★★★★☆
								</c:when>
								<c:otherwise>
									★★★★★
								</c:otherwise>
							</c:choose>
						</p>
						<p class="rev_txt">${review.rev_txt }</p>
						<p class="rev_date">${review.rev_date }</p>
					</c:forEach>
				</div>
			</div>
		</div>
	</div>
	<script>
		$(loadedHandler);
		function loadedHandler(){
			$("#loveadd").on("click", loveAddClickHandler);
			$("#btn_review_add").on("click", reviewAddClickHandler);
			$("#btn_reading").on("click", readingClickHandler);
		}
		function loveAddClickHandler(){
			var id = '<%=(String)request.getSession().getAttribute("id")%>';
			var isbn = $("#isbn").text();
			var add = null;
			if($("#loveadd").hasClass("add")){
				add = "no";
				$(this).text("찜 해제");
				$(this).removeClass("add");
			}else{
				add = "yes";
				$(this).text("찜");
				$(this).addClass("add");
			}
			$.ajax({
				type : "post",
				url : "loveadd.ajax",
				data : {
					id : id,
					isbn : isbn,
					add : add
				},
				success : btnSendSuccessCb,
				error : ajaxErrorCb
			});
		}
		function reviewAddClickHandler(){
			var isbn = $("#isbn").text();
			var rev_txt = $(this).prev().val();
			var each_grade = $("input[type=radio][name=grade]:checked").val();
			if(each_grade == null){
				alert("별점을 남겨주세요!");
				return;
			}
			$.ajax({
				type : "post"
				, url : "ReviewInsert.ajax"
				, data : {
					isbn : isbn
					,rev_txt : rev_txt
					,each_grade : each_grade
				}
				,success : btnSendSuccessCb
				,error : ajaxErrorCb
			});
			$(this).prev().val("추천합니다!");
			document.location.reload();
		}
		function readingClickHandler(){
			var isbn = $("#isbn").text();
			$.ajax({
				type : "post"
				, url : "readingnow.ajax"
				, data : {
					isbn : isbn
				}
				,success : btnSendSuccessCb
				,error : ajaxErrorCb
			});
			var w = window.open("about:blank", "_blank", "width=800, height=700, resizable=yes" );
			w. location.href = "<%=request.getContextPath()%>/reading?isbn="+ isbn;
		}
		function btnSendSuccessCb(loveAdd) {
			console.log(loveAdd);
			console.log(loveAdd.result);
			console.log(loveAdd["result"]);
		}
		function ajaxErrorCb(request, status, error) {
			alert("code:" + request.status + "\n" + "message"
					+ request.responseText + "\n" + "error" + error);
		}
	</script>
</body>
</html>