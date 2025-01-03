//Replaces every class="currentDate" element with the current date in the format "DD.MM.YYYY".
function replaceCurrentDate() {
  var currentDate = new Date();
  var elements = document.getElementsByClassName("currentDate");
  for (var i = 0; i < elements.length; i++) {
    elements[i].innerHTML =
      currentDate.getDate() + "." + (currentDate.getMonth() + 1) + "." + currentDate.getFullYear();
  }
}

//Replaces every class="currentDateYYYYMMDD" element with the current date in the format "YYYY-MM-DD".
function replaceCurrentDateYYYYMMDD() {
  var currentDate = new Date();
  var elements = document.getElementsByClassName("currentDateYYYYMMDD");
  for (var i = 0; i < elements.length; i++) {
    elements[i].innerHTML =
      currentDate.getFullYear() + "-" + (currentDate.getMonth() + 1) + "-" + currentDate.getDate();
  }
}

document.addEventListener("DOMContentLoaded", function () {
  replaceCurrentDate();
  replaceCurrentDateYYYYMMDD();
});
