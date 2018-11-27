document.addEventListener('DOMContentLoaded', function(event) {
  const ctx1 = document.getElementById("jpy_balance").getContext("2d");
  const jpy_balance = new Chart(ctx1, {
    type: "line",
    data: {
      labels: gon.created_on,
      datasets: [{
        label: "JPY残高",
        data: gon.total_balance,
        borderColor: "rgba(255, 50, 132, 1.0)",
        fill: false,
      }]
    },
  });
}); 

