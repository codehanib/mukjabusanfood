/* 리뷰 작성폼과 수정폼의 별점 적용 스크립트 */

const stars = document.querySelectorAll('.star');
const rvPoint = document.getElementById('rv_point');

stars.forEach(star => {
    star.addEventListener('click', function(e) {

        const rect = this.getBoundingClientRect();
        const x = e.clientX - rect.left;

        let value = Number(this.dataset.value);

        // 별의 왼쪽 클릭 → 0.5
        if (x < rect.width / 2) {
            value -= 0.5;
        }
        // 별 초기화
        stars.forEach(s => {
            s.classList.remove('full');
            s.classList.remove('half');
        });
        // 별 채우기
        stars.forEach(s => {

            const starValue = Number(s.dataset.value);

            if (starValue <= value) {
                s.classList.add('full');
            }
            else if (starValue - 0.5 === value) {
                s.classList.add('half');
            }
        });
        // 서버로 전송할 평점
        rvPoint.value = value.toFixed(1);
    });
});