const tableRows = document.getElementById('result-table-body').getElementsByTagName('tr');
let numberOfRows = tableRows.length;
let created_times = [];
let values = [];
for (let i = 0; i < numberOfRows; i++) {
  created_times.push(tableRows[i].getElementsByClassName('created_at')[0].innerHTML);
  const created_time = created_times[i]
  const frequency = (tableRows[i].getElementsByClassName('frequency')[0].innerHTML.split('秒')[0]);
  const valueset = {x:created_time, y:frequency};
  values.push(valueset);
}

const ctx = document.getElementById('frequencyChart');
const chartColor = 'rgba(255, 99, 132, 0.5)';
const data = {
  labels: created_times,
  datasets: [
    {
      label: 'Frequency',
      data: values,
      borderColor: chartColor,
      backgroundColor: chartColor,
      pointStyle: 'circle',
      pointRadius: 10,
      pointHoverRadius: 15
    }
  ]
};

const config = {
  type: 'line',
  data: data,
  options: {
    responsive: true,
    layout: {
      padding: {
        left: 75,
        right: 75,
      },
    },
    plugins: {
      title: {
        display: true,
      }
    },
    scales: {
      x: {
        reverse: true,
        title: {
          display: true,
          text: '日時'
        }
      },
      y: {
        title: {
          display: true,
          text: 'フィラー頻度'
        },
        ticks: {
          display: false,
          // stepSize: 0.1
        }
      }
    },
  }
};

const actions = [
  {
    name: 'pointStyle: circle (default)',
    handler: (chart) => {
      chart.data.datasets.forEach(dataset => {
        dataset.pointStyle = 'cirlce';
      });
      chart.update();
    }
  },
];

const myChart = new Chart(ctx, config);
