function goPopup(){
	var pop = window.open("/jusoPopup","pop","width=570,height=420, scrollbars=yes, resizable=yes");
}

function jusoCallBack(u_addr, u_addr2, u_zipno){
    // 주소 팝업에서 넘어온 3개 값을 부모창 input에 세팅
    document.users.u_addr.value  = u_addr;   // 도로명 주소
    document.users.u_addr2.value = u_addr2;  // 상세 주소
    document.users.u_zipno.value = u_zipno;  // 우편번호
}

function check1() {
    let uid          = document.users.u_id;
    let upasswd      = document.users.u_passwd;
    let upasswd2     = document.users.u_passwd2;
    let uname        = document.users.u_name;
    let uzipno       = document.users.u_zipno;
    let uaddrRoad    = document.users.u_addr_road;
    let uaddrExtra   = document.users.u_addr_extra;
    let utelPrefix   = document.users.u_tel_prefix;
    let utelMid      = document.users.u_tel_mid;
    let utelLast     = document.users.u_tel_last;
    let uemailId     = document.users.u_email_id;
    let uemailDomain = document.users.u_email_domain;

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

    if (!uaddrRoad.value){
        alert("주소를 입력해주세요.");
        return false;
    }

    if (!utelMid.value){
        alert("전화번호를 입력해주세요.");
        utelMid.focus();
        return false;
    }

    if (!utelLast.value){
        alert("전화번호를 입력해주세요.");
        utelLast.focus();
        return false;
    }

    if (!uemailId.value){
        alert("이메일을 입력해주세요.");
        uemailId.focus();
        return false;
    }

    if (uemailDomain.value === ""){
        alert("이메일주소를 선택하세요.");
        return false;
    }

    // ▼ DB 컬럼(u_addr, u_tel, u_email)은 하나씩이라, 여러 입력값을 합쳐서
    //    실제 전송될 hidden 필드에 채워 넣습니다.
    document.users.u_addr.value  = uaddrRoad.value + " " + uaddrExtra.value;
    document.users.u_tel.value   = utelPrefix.value + "-" + utelMid.value + "-" + utelLast.value;
    document.users.u_email.value = uemailId.value + "@" + uemailDomain.value;

    return true;
}