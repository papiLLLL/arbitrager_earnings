document.addEventListener('DOMContentLoaded', function(event) {
  const ctx1 = document.getElementById("jpy_balance").getContext("2d");
  const jpy_balance = new Chart(ctx1, {
    type: "line",
    data: {
      labels: gon.created_on,
      datasets: [{
        data: gon.total_balance,
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

