document.addEventListener('DOMContentLoaded', function(event) {
  /* Chart.js setting */
  Chart.defaults.global.defaultFontColor = "#73879C";
  Chart.defaults.global.defaultFontFamily = "Quicksand, '游ゴシック Medium', 'Yu Gothic Medium', 游ゴシック体, 'Yu Gothic', YuGothic, 'ヒラギノ角ゴシック Pro', 'Hiragino Kaku Gothic Pro', メイリオ, Meiryo, Osaka, 'ＭＳ Ｐゴシック', 'MS PGothic', sans-serif";
  

  const ctx1 = document.getElementById("jpy_balance").getContext("2d");
  const jpy_balance = new Chart(ctx1, {
    type: "line",
    data: {
      labels: gon.created_on,
      datasets: [{
        data: gon.total_balance,
        borderColor: "#CCB3DD",
        pointBackgroundColor: "#CCB3DD",
        yAxisID: "total",
        fill: false
      }, {
        data: gon.coincheck_jpy_balance,
        borderColor: "#91DBB9",
        pointBackgroundColor: "#91DBB9",
        yAxisID: "each",
        fill: false
      }, {
        data: gon.quoinex_jpy_balance,
        borderColor: "#97D3E3",
        pointBackgroundColor: "#97D3E3",
        yAxisID: "each",
        fill: false
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      legend: {
        display: false
      },
      scales: {
        yAxes: [{
          id: "each",
          type: "linear",
          position: "left",
          ticks: {
            max: 255000,
            min: 225000,
            stepSize: 5000,
          }
        }, {
          id: "total",
          type: "linear",
          position: "right",
          ticks: {
            max: 770000,
            min: 730000,
            stepSize: 10000,
          },
          gridLines: {
            drawOnChartArea: false,
          }
        }]
      }
    }
  });
/*
  const ctx2 = document.getElementById("btc_price").getContext("2d");
  const btc_price = new Chart(ctx2, {
    type: "line",
    data: {
      labels: gon.created_on,
      datasets: [{
        data: gon.coincheck_btc_price,
        borderColor: "rgba(255, 50, 132, 1.0)",
        fill: false,
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      legend: {
        display: false
      }
    }
  });
*/
}); 

