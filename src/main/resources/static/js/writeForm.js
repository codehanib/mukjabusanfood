let idChecked = false;  

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
        console.log("중복확인 요청 종료");
    }
}


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

    if (!emailVerified) {
        alert("이메일 인증을 완료해주세요.");
        return false;
    }

    return true;
}


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

// ===== 이메일 인증 (토큰 방식으로 변경) =====
let emailVerified = false;

async function sendEmailCode() {
    const email = document.users.u_email.value;
    const email2 = document.users.u_email2.value;
    if (!email || !email2) {
        alert("이메일을 입력해주세요.");
        return;
    }
    const fullEmail = email + "@" + email2;

    try {
        const res = await fetch("/email/sendCode", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "email=" + encodeURIComponent(fullEmail)
        });
        const data = await res.json();
        if (data.success) {
            alert("인증번호를 발송했습니다.");
            document.getElementById("emailCodeArea").style.display = "table-row";
        } else {
            alert("발송에 실패했습니다.");
        }
    } catch (err) {
        alert("오류가 발생했습니다.");
        console.error(err);
    }
}

async function verifyEmailCode() {
    const fullEmail = document.users.u_email.value + "@" + document.users.u_email2.value;
    const code = document.getElementById("emailCode").value;

    try {
        const res = await fetch("/email/verifyCode", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "email=" + encodeURIComponent(fullEmail) + "&code=" + encodeURIComponent(code)
        });
        const data = await res.json();
        if (data.verified) {
            alert("이메일 인증이 완료되었습니다.");
            emailVerified = true;
            document.getElementById("emailVerifyToken").value = data.token;
        } else {
            alert("인증번호가 일치하지 않습니다.");
        }
    } catch (err) {
        alert("오류가 발생했습니다.");
        console.error(err);
    }
}

// 이메일 입력값 바뀌면 인증 다시 받도록 리셋
document.addEventListener("DOMContentLoaded", function() {
    if (document.users) {
        document.users.u_email.addEventListener("input", function() {
            emailVerified = false;
        });
        document.users.u_email2.addEventListener("change", function() {
            emailVerified = false;
        });
    }
});
function checkSignupError() {
    const params = new URLSearchParams(location.search);
    const error = params.get("error");

    if (error === "emailDuplicate") {
        alert("이미 사용 중인 이메일입니다.");
    } else if (error === "emailNotVerified") {
        alert("이메일 인증을 완료해주세요.");
    }
}

async function sendResetCode() {
    const u_id = document.getElementById("u_id").value;
    const email = document.getElementById("email").value;

    if (!u_id || !email) {
        alert("아이디와 이메일을 입력해주세요.");
        return;
    }

    try {
        const res = await fetch("/email/sendCode", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "email=" + encodeURIComponent(email) + "&u_id=" + encodeURIComponent(u_id)
        });
        const data = await res.json();
        if (data.success) {
            alert("인증번호를 발송했습니다.");
            document.getElementById("codeArea").style.display = "block";
        } else {
            alert(data.message || "발송에 실패했습니다.");
        }
    } catch (err) {
        alert("오류가 발생했습니다.");
        console.error(err);
    }
}

async function verifyResetCode() {
    const email = document.getElementById("email").value;
    const code = document.getElementById("code").value;

    try {
        const res = await fetch("/email/verifyCode", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "email=" + encodeURIComponent(email) + "&code=" + encodeURIComponent(code)
        });
        const data = await res.json();
        if (data.verified) {
            const u_id = document.getElementById("u_id").value;
            location.href = "/login/resetPasswordForm?u_id=" + encodeURIComponent(u_id)
                + "&email=" + encodeURIComponent(email) + "&token=" + encodeURIComponent(data.token);
        } else {
            alert("인증번호가 일치하지 않습니다.");
        }
    } catch (err) {
        alert("오류가 발생했습니다.");
        console.error(err);
    }
}

function checkFindPasswordError() {
    const params = new URLSearchParams(location.search);
    if (params.get("error") === "notVerified") {
        alert("이메일 인증을 먼저 완료해주세요.");
    }
}