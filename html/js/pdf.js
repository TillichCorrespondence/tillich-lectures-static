document.getElementById("download-pdf").addEventListener("click", function () {
  var filename = document.getElementById("filename").textContent;
  
  console.log(`saving pdf as ${filename}`);
  var container = document.createElement("div");
  var pdfTitle = document.getElementById("pdf-title").cloneNode(true);
  pdfTitle.classList.add("fs-5");
  var pdfTranscript = document.getElementById("pdf-transcript").cloneNode(true);
  // container.style.fontSize = "12px";
  // container.style.lineHeight = "1.5";
  var pdfEntities = document.getElementById("pdf-entities").cloneNode(true);
  pdfEntities.classList.remove("visually-hidden");
  container.appendChild(pdfTitle);
  container.appendChild(pdfTranscript);
  var registerSeparator = document.createElement("hr");
  container.appendChild(registerSeparator);
  container.appendChild(pdfEntities);
  document.body.appendChild(container);
  var footnoteMarkers = container.getElementsByClassName("pdf-entitiy-footnote-markers");
  for (var i = 0; i < footnoteMarkers.length; i++) {
    footnoteMarkers[i].classList.remove("visually-hidden");
  }

  html2pdf(container, {
    margin: 1,
    pagebreak: { mode: ["avoid-all", "css", "legacy"] },
    filename: filename,
    image: { type: "jpeg", quality: 0.8 },
    html2canvas: { scale: 2 },
    jsPDF: { unit: "in", format: "letter", orientation: "portrait" },
  }).then(function () {
    // Remove the temporary container after PDF generation
    document.body.removeChild(container);
  });
});
