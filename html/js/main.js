/**
 * Toggles highlight for elements based on a checkbox state
 * @param {HTMLInputElement} checkbox - The checkbox element
 */
function toggleHighlight(checkbox) {
    // Use the checkbox's value as the data-bs-target
    const dataTarget = checkbox.value;

    // Select all elements with the specified data-bs-target
    const elements = document.querySelectorAll(`[data-bs-target="#${dataTarget}"]`);
    console.log(elements)
    
    // Add or remove the highlight class based on the checkbox state
    if (checkbox.checked) {
        elements.forEach(element => element.classList.add('highlight'));
    } else {
        elements.forEach(element => element.classList.remove('highlight'));
    }
}

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
  
  document.querySelector('#btn-facsimile').addEventListener('click', function() {
    document.getElementById('facs-container').classList.toggle('d-none');
  });
  
  document.querySelector('#btn-entities').addEventListener('click', function() {
    document.getElementById('pdf-entities').classList.toggle('d-none');
  });