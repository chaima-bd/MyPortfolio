document.addEventListener('DOMContentLoaded', function () {
    //const ctxWebDev = document.getElementById('webDevChart').getContext('2d');
    const ctxML = document.getElementById('mlChart').getContext('2d');
    const ctxDataAnalysis = document.getElementById('dataAnalysisChart').getContext('2d');

    //const webDevData = [10, 9, 8, 8, 8];
    const mlData = [80, 70, 70, 50];
    const dataAnalysisData = [10, 15, 20, 25, 30, 35, 30];

   /* new Chart(ctxWebDev, {
        type: 'line',
        data: {
            labels: ['HTML', 'CSS', 'JS', 'React', 'MongoDB'],
            datasets: [{
                label: 'Web Development',
                data: webDevData,
                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            }]
        }
    }); */

    new Chart(ctxML, {
        type: 'radar',
        data: {
            labels: ['Supervised', 'Unsupervised', 'Neural Networks', 'Optimization', 'Finetuning'],
            datasets: [{
                label: 'Machine Learning',
                data: [20, 30, 40, 50, 60], // Replace with your actual mlData
                backgroundColor: 'rgba(255, 206, 86, 0.2)',
                borderColor: 'rgba(255, 206, 86, 1)',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                r: {
                    angleLines: {
                        display: false
                    },
                    suggestedMin: 0,
                    suggestedMax: 100
                }
            }
        }
    });
    new Chart(ctxDataAnalysis, {
        type: 'bar',
        data: {
            labels: ['Data Cleaning', 'Transformation', 'Visualization', 'Modeling', 'Reporting', 'Decision Making'],
            datasets: [{
                label: 'Data Analysis',
                data: [25, 30, 40, 35, 50, 45], // Replace with your actual dataAnalysisData
                backgroundColor: 'rgba(153, 102, 255, 0.2)',
                borderColor: 'rgba(153, 102, 255, 1)',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    suggestedMax: 100
                }
            }
        }
    });
});

document.querySelectorAll('.service-box').forEach(box => {
    box.addEventListener('mouseenter', () => {
        box.style.boxShadow = '0 4px 8px rgba(0, 0, 0, 0.2)';
    });

    box.addEventListener('mouseleave', () => {
        box.style.boxShadow = '0 2px 4px rgba(0, 0, 0, 0.1)';
    });
});
