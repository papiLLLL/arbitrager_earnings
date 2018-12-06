/* Chart.js setting */
Chart.defaults.global.defaultFontColor = "#73879C";
Chart.defaults.global.defaultFontFamily = "Quicksand, '游ゴシック Medium', 'Yu Gothic Medium', 游ゴシック体, 'Yu Gothic', YuGothic, 'ヒラギノ角ゴシック Pro', 'Hiragino Kaku Gothic Pro', メイリオ, Meiryo, Osaka, 'ＭＳ Ｐゴシック', 'MS PGothic', sans-serif";

/* graph color */
const coincheck_color = "#91DBB9";
const quoinex_color = "#97D3E3";
const total_color = "#F2F5AA";
const profit_color = "#EAA8BF";
const profit_rate_color = "#DFECAA";

document.addEventListener('DOMContentLoaded', function(event) {
  const ctx1 = document.getElementById("jpy_balance").getContext("2d");
  const jpy_balance = new Chart(ctx1, {
    type: "bar",
    data: {
      labels: gon.created_on,
      datasets: [{
        type: "line",
        label: "Coincheck",
        data: gon.coincheck_jpy_balance,
        borderColor: coincheck_color,
        backgroundColor: coincheck_color,
        pointBackgroundColor: coincheck_color,
        yAxisID: "left",
        fill: false
      }, {
        type: "line",
        label: "Quoinex",
        data: gon.quoinex_jpy_balance,
        borderColor: quoinex_color,
        backgroundColor: quoinex_color,
        pointBackgroundColor: quoinex_color,
        yAxisID: "left",
        fill: false
      }, {
        label: "Total",
        data: gon.total_balance,
        backgroundColor: total_color,
        yAxisID: "right",
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      legend: {
        position: "bottom",
      },
      scales: {
        yAxes: [{
          id: "left",
          type: "linear",
          position: "left",
          ticks: {
            max: 350000,
            min: 230000,
            stepSize: 10000,
          }
        }, {
          id: "right",
          type: "linear",
          position: "right",
          ticks: {
            max: 1000000,
            min: 700000,
            stepSize: 100000,
          },
          gridLines: {
            drawOnChartArea: false,
          }
        }]
      }
    }
  });

  const ctx2 = document.getElementById("profit").getContext("2d");
  const profit = new Chart(ctx2, {
    type: "line",
    data: {
      labels: gon.created_on,
      datasets: [{
        label: "profit",
        data: gon.profit,
        borderColor: profit_color,
        backgroundColor: profit_color,
        pointBackgroundColor: profit_color,
        yAxisID: "left",
        fill: false
      }, {
        label: "profit_rate",
        data: gon.profit_rate,
        borderColor: profit_rate_color,
        backgroundColor: profit_rate_color,
        pointBackgroundColor: profit_rate_color,
        yAxisID: "right",
        fill: false
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      legend: {
        position: "bottom",
      },
      scales: {
        yAxes: [{
          id: "left",
          type: "linear",
          position: "left",
          ticks: {
            max: 5000,
            min: 0,
            stepSize: 1000,
          }
        }, {
          id: "right",
          type: "linear",
          position: "right",
          ticks: {
            max: 0.5,
            min: 0.1,
            stepSize: 0.1,
          },
          gridLines: {
            drawOnChartArea: false,
          }
        }]
      }
    }
  });
}); 

