# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ctx1 = document.getElementById("jpy_balance").getContext("2d")
jpy_balance = new Chart(ctx1, {
type: "line",
data: {
    labels: <%= @created_on.to_json.html_safe %>,
    datasets: [{
    label: "JPY残高",
    data: <%= @total_balance %>,
    borderColor: "rgba(255, 50, 132, 1.0)",
    fill: false,
    }]
},
})