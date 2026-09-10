/**
 * 
 */var ctx = document.getElementById('deliveryTimeChart').getContext('2d');
    
    var deliveryTimeChart = new Chart(ctx, {
        type: 'line', // 캐치테이블 스타일의 부드러운 꺾은선 그래프
        data: {
            labels: ['11시', '12시 (점심)', '13시', '15시', '17시', '18시 (저녁)', '19시', '20시', '21시'],
            datasets: [{
                label: '평균 소요시간 (분)',
                data: [25, 42, 32, 26, 30, 48, 52, 38, 28], // 나중에 백엔드 데이터(List 등)와 동적으로 연결 가능
                borderColor: '#FF5722', // 묵자 시그니처 주황색
                backgroundColor: 'rgba(255, 87, 34, 0.08)',
                borderWidth: 3,
                pointBackgroundColor: '#FF5722',
                pointRadius: 4,
                tension: 0.3, // 선을 부드럽게 곡선으로 처리
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false // 범례 숨김 (깔끔한 UI 연출)
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    max: 70,
                    grid: {
                        color: '#f0f0f0'
                    },
                    ticks: {
                        stepSize: 10,
                        font: { size: 11 }
                    }
                },
                x: {
                    grid: {
                        display: false
                    },
                    ticks: {
                        font: { size: 11 }
                    }
                }
            }
        }
    });