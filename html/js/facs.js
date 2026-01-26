document.addEventListener('DOMContentLoaded', function() {
  const source = document.getElementById("url").textContent;

  // Automatically load the viewer on large screens (d-lg-block)
  if (window.innerWidth >= 992) {  // This is the breakpoint for large screens (lg)
    loadOpenSeadragonViewer(source);
  }

  // Load OpenSeadragon on button click for small screens
  document.getElementById('btn-facsimile').addEventListener('click', function() {
    loadOpenSeadragonViewer(source);
  });

  // Function to initialize OpenSeadragon viewer
  function loadOpenSeadragonViewer(imageSource) {
    var viewer = OpenSeadragon({
      id: "osd_viewer",
      tileSources: {
        type: "image",
        url: imageSource
      },
      prefixUrl: "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/images/"
    });

    // Show the facsimile container if it was hidden (on small screens before button click)
    document.getElementById("facs-container").classList.toggle('d-none');
  }
});

// Toggle facsimile visibility on large screens


document.addEventListener("DOMContentLoaded", function () {
  const toggleBtn = document.getElementById("toggle-facs");
  const label = document.getElementById("toggle-facs-label");
  const facs = document.getElementById("facs-content");
  const trans = document.getElementById("pdf-transcript");
  const facsContainer = document.getElementById("facs-container");
  const icon = toggleBtn.querySelector("i");

  toggleBtn.addEventListener("click", () => {
    // toggle facsimile content
    facs.classList.toggle("d-none");

    // toggle transcript width
    trans.classList.toggle("col-lg-4");
    trans.classList.toggle("col-lg-9");

    // toggle facsimile column width
    facsContainer.classList.toggle("col-lg-6");
    facsContainer.classList.toggle("col-lg-1");

    // toggle icon direction
    icon.classList.toggle("bi-caret-left-fill");
    icon.classList.toggle("bi-caret-right-fill");

     // toggle label text
    label.textContent = facs.classList.contains("d-none") ? "Show facsimile" : "Hide facsimile";
  });
});

