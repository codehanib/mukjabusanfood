let idChecked = false;  // 아이디 중복확인 통과 여부

function goPopup(){
	var pop = window.open("/jusoPopup","pop","width=570,height=420, scrollbars=yes, resizable=yes");
}

function jusoCallBack(u_addr, u_addr2, u_zipno){
    document.users.u_addr.value  = u_addr;
    document.users.u_addr2.value = u_addr2;
    document.users.u_zipno.value = u_zipno;
}

async function checkId() {
    let uid = document.users.u_id.value;
    let regid = /^[A-Za-z0-9]{4,16}$/;

    if (!uid) {
        alert("아이디를 입력해주세요.");
        document.users.u_id.focus();
        return;
    }
    if (!regid.test(uid)) {
        alert("아이디는 영문과 숫자 조합으로 4~16자리로 입력해주세요.");
        document.users.u_id.focus();
        return;
    }

    try {
        const res = await fetch("/checkId?u_id=" + encodeURIComponent(uid));
        const data = await res.json();

        if (data.duplicate) {
            alert("이미 사용중인 아이디입니다.");
            idChecked = false;
        } else {
            alert("사용 가능한 아이디입니다.");
            idChecked = true;
        }
    } catch (err) {
        alert("중복확인 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        console.error(err);
    } finally {
        console.log("중복확인 요청 종료");  // 성공하든 실패하든 항상 실행
    }
}

// 회원가입
function check1() {
    let uid          = document.users.u_id;
    let upasswd      = document.users.u_passwd;
    let upasswd2     = document.users.u_passwd2;
    let uname        = document.users.u_name;
    let uzipno       = document.users.u_zipno;
    let uaddr        = document.users.u_addr;

    let regid       = /^[A-Za-z0-9]{4,16}$/;
    let regpasswd   = /^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,16}$/;

    if (!uid.value){
        alert("아이디를 영문과 숫자 조합으로 4~16자리 입력해주세요.");
        uid.focus();
        return false;
    }

    if (!regid.test(uid.value)) {
        alert("아이디는 영문과 숫자 조합으로 4~16자리 입력해주세요.");
        uid.focus();
        return false;
    }

    if (!idChecked) {
        alert("아이디 중복확인을 해주세요.");
        uid.focus();
        return false;
    }

    if (!upasswd.value){
        alert("비밀번호를 영문, 숫자, 특수문자를 포함하여 8~16자리로 입력해주세요.");
        upasswd.focus();
        return false;
    }

    if (!regpasswd.test(upasswd.value)) {
        alert("비밀번호는 영문, 숫자, 특수문자를 포함하여 8~16자리로 입력해주세요.");
        upasswd.focus();
        return false;
    }

    if (upasswd.value != upasswd2.value){
        alert("비밀번호와 비밀번호 확인은 일치해야됩니다.");
        upasswd.focus();
        upasswd.value = "";
        upasswd2.value = "";
        return false;
    }

    if (!uname.value){
        alert("이름을 입력해주세요.");
        uname.focus();
        return false;
    }

    if (!uzipno.value){
        alert("주소를 입력해주세요.");
        return false;
    }

    if (!uaddr.value){
        alert("주소를 입력해주세요.");
        return false;
    }

    if (!document.users.u_tel2.value){
        alert("전화번호를 입력해주세요.");
        document.users.u_tel2.focus();
        return false;
    }

    if (!document.users.u_tel3.value){
        alert("전화번호를 입력해주세요.");
        document.users.u_tel3.focus();
        return false;
    }

    if (!document.users.u_email.value){
        alert("이메일을 입력해주세요.");
        document.users.u_email.focus();
        return false;
    }

    if (document.users.u_email2.value === ""){
        alert("이메일주소를 선택하세요.");
        return false;
    }

    return true;
}

//  회원정보수정
function check() {
    let uzipno = document.users.u_zipno;
    let uaddr  = document.users.u_addr;

    if (!uzipno.value) {
        alert("주소를 입력해주세요.");
        return false;
    }

    if (!uaddr.value) {
        alert("주소를 입력해주세요.");
        return false;
    }

    if (!document.users.u_tel2.value) {
        alert("전화번호를 입력해주세요.");
        document.users.u_tel2.focus();
        return false;
    }

    if (!document.users.u_tel3.value) {
        alert("전화번호를 입력해주세요.");
        document.users.u_tel3.focus();
        return false;
    }

    if (!document.users.u_email.value) {
        alert("이메일을 입력해주세요.");
        document.users.u_email.focus();
        return false;
    }

    if (document.users.u_email2.value === "") {
        alert("이메일주소를 선택하세요.");
        return false;
    }

    return true;
}
function checkPasswd() {
    let upasswd  = document.pwForm.u_passwd;
    let upasswd2 = document.pwForm.u_passwd2;
    let regpasswd = /^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,16}$/;

    if (!regpasswd.test(upasswd.value)) {
        alert("비밀번호는 영문, 숫자, 특수문자를 포함하여 8~16자리로 입력해주세요.");
        upasswd.focus();
        return false;
    }
    if (upasswd.value != upasswd2.value) {
        alert("새 비밀번호가 일치하지 않습니다.");
        upasswd.value = "";
        upasswd2.value = "";
        return false;
    }
    return true;
}