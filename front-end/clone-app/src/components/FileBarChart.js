import React from 'react';
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, Title,
        Tooltip, Legend } from 'chart.js';
import { Bar } from 'react-chartjs-2';

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
);

const labels = [1,2,3];

export const data = {
  labels,
  datasets: [
    {
      barPercentage: 1,
      categoryPercentage: 1,
      label: 'Dataset 1',
      // data: labels.map(() => [0,    100]),
      data: [20,20],
      borderColor: 'rgb(255, 99, 132)',
      backgroundColor: 'rgba(255, 99, 132, 0.5)',
    }
  ],
};

export default function App(props) {
    const options = {
        indexAxis: 'y',
        elements: {
          bar: {
            borderWidth: 2,
          },
        },
        scales: {
          x: {
              display: false,
          },
          y: {
            grid: {
              display: false
            },
          },
        },
        responsive: true,
        plugins: {
          legend: {
            position: 'right',
          },
          title: {
            display: true,
            text: props.fileName
          },
        },
      };

  return <Bar options={options} data={data} />;
}
