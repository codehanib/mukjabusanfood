<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>

	 <!--  회원가입 스크립트 -->
	<script src="/js/writeForm.js"></script>
      <!-- 메인 CSS(회원가입폼) -->
    <link rel="stylesheet" href="/css/writeForm.css">
    

    	

</head>
<body>

	
	<main class="join-main">
		    <div class="join-dot dot-left"></div>
    		<div class="join-dot dot-right"></div>
		<div class="join-box">
		
			<div class="join-title">
			    <h2 class="join-main-title">회원가입</h2>
			    <p class="join-main-text">MUKJA에 오신 것을 환영합니다. </p>
			</div>    
			<!-- 회원가입 form -->		
				<form action="/usersInsert" method="post" name="users" class="join-form" onsubmit="return check1();" >
					<table width="500">
						<tr>
							<td>아이디 </td>
							<td><input type="text" name="u_id" placeholder="아이디는 영문과 숫자 조합으로 4~16자리"></td>
						</tr>
						<tr>
							<td>비밀번호 </td>
							<td><input type="password" name="u_passwd" placeholder="영문, 숫자, 특수문자를 포함하여 8~16자리"></td>
						</tr>
						<tr>
							<td>비밀번호 확인</td>
							<td><input type="password" name="u_passwd2" placeholder="영문, 숫자, 특수문자를 포함하여 8~16자리"></td>
						</tr>
						<tr>
							<td>이름 </td>
							<td><input type="text" name="u_name" placeholder="이름을 입력해주세요"></td>
						</tr>
						<tr class="join-address">
							<td>주소 </td>
							<td><input type="text" name="u_zipno" readonly> - <input type="button" onclick="goPopup();" value="우편번호"></td>
						</tr>
						<tr>
							<td></td>
							<td><input type="text" name="u_addr" readonly></td>
						</tr>
						<tr>
							<td></td>
							<td><input type="text" name="u_addr2" readonly></td>
						</tr>
						<tr class="join-phone">
							<td>휴대전화 </td>
							<td>
							<select name="u_tel">
									<option value="010">010</option>
									<option value="011">011</option>
									<option value="016">016</option>
									<option value="017">017</option>
									<option value="018">018</option>
									<option value="019">019</option>
							</select> -
								<input type="text" name="u_tel2" size="4" maxlength="4" placeholder="0000"> - 
								<input type="text" name="u_tel3" size="4" maxlength="4" placeholder="0000">
							</td>
						</tr>
						<tr class="join-email">
							<td>이메일 </td>
							<td>
								<input type="text" name="u_email" placeholder="이메일을 입력해주세요">@
								<select name="u_email2">
									<option value="">선택</option>
									<option value="naver.com">naver.com</option>
									<option value="gmail.com">gmail.com</option>
									<option value="daum.com">daum.com</option>
									<option value="nate.com">nate.com</option>
								</select>
							</td>
						</tr>
					</table>
					<div>
						<input type="submit" value="✓ 회원가입">
					 	<input type="reset" value="✕ 취소">			    
					</div>
					
				</form>
			
		</div>
		
	</main>

</body>

</html>