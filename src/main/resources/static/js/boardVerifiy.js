function noticeFormVerifi() {
    const nttitle = document.getElementById("nt_title");
    const ntcontent = document.getElementById("nt_content");

    if(!nt_title.value) {
        alert("공지 제목을 입력해주세요.");
        nttitle.focus();
        return false;
    }
    if(!nt_content.value) {
        alert("공지 내용을 입력해주세요.");
        ntcontent.focus();
        return false;
    }
	
    return true;
}

function reviewFormVerifi() {
	const rvpoint = document.getElementById("rv_point");
    const rvcontent = document.getElementById("rv_content");

	if(!rvpoint.value) {
	    alert("평점을 선택해주세요.");
	    rvpoint.focus();
	    return false;
	}
	
    if(!rvcontent.value) {
        alert("리뷰 내용을 입력해주세요.");
        rvcontent.focus();
        return false;
    }
	
    return true;
}

function inquiryFormVerifi() {
	const mititle = document.getElementById("mi_title");
    const micontent = document.getElementById("mi_content");

	if(!mititle.value) {
	    alert("문의 제목을 입력해주세요.");
	    mititle.focus();
	    return false;
	}
	
    if(!micontent.value) {
        alert("문의 내용을 입력해주세요.");
        micontent.focus();
        return false;
    }
	
    return true;
}

function answerFormVerifi() {
	const mianswer = document.getElementById("mi_answer");

	if(!mianswer.value) {
	    alert("답변을 입력해주세요.");
	    mianswer.focus();
	    return false;
	}
	
    return true;
}