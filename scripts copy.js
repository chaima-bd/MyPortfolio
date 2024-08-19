document.addEventListener('DOMContentLoaded', function () {
    const ctxCollect = document.getElementById('collectChart').getContext('2d');
    const ctxProcess = document.getElementById('processChart').getContext('2d');
    const ctxVisualise = document.getElementById('visualiseChart').getContext('2d');
    const ctxML = document.getElementById('mlChart').getContext('2d');

    const collectData = [12, 19, 3, 5, 2, 3]; // Example data, replace with actual data from CSV
    const processData = [7, 11, 5, 8, 3, 7]; // Example data, replace with actual data from CSV
    const visualiseData = [15, 10, 7, 12, 8, 15]; // Example data, replace with actual data from CSV
    const mlData = [8, 15, 10, 6, 4, 12]; // Example data, replace with actual data from CSV

    new Chart(ctxCollect, {
        type: 'bar',
        data: {
            labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'], // Replace with your labels
            datasets: [{
                label: 'Collect Data',
                data: collectData,
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        }
    });

    new Chart(ctxProcess, {
        type: 'line',
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'], // Replace with your labels
            datasets: [{
                label: 'Process Data',
                data: processData,
                backgroundColor: 'rgba(153, 102, 255, 0.2)',
                borderColor: 'rgba(153, 102, 255, 1)',
                borderWidth: 1
            }]
        }
    });

    new Chart(ctxVisualise, {
        type: 'pie',
        data: {
            labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'], // Replace with your labels
            datasets: [{
                label: 'Visualise Data',
                data: visualiseData,
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)'
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)'
                ],
                borderWidth: 1
            }]
        }
    });

    new Chart(ctxML, {
        type: 'radar',
        data: {
            labels: ['Accuracy', 'Precision', 'Recall', 'F1 Score', 'ROC AUC', 'MSE'], // Replace with your labels
            datasets: [{
                label: 'Machine Learning Metrics',
                data: mlData,
                backgroundColor: 'rgba(255, 206, 86, 0.2)',
                borderColor: 'rgba(255, 206, 86, 1)',
                borderWidth: 1
            }]
        }
    });
});
