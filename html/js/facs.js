document.addEventListener('DOMContentLoaded', function () {

  // function to initialize ONE viewer
  function initViewer(el) {
    if (el.classList.contains('osd-loaded')) return; // duplicate init

    OpenSeadragon({
      element: el,
      tileSources: {
        type: "image",
        url: el.dataset.image
      },
      prefixUrl: "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/images/"
    });

    el.classList.add('osd-loaded');
  }

  // LARGE SCREENS: load all immediately
  if (window.innerWidth >= 992) {
    document.querySelectorAll('[id^="osd_viewer_"]').forEach(initViewer);
  }

  // SMALL SCREENS: load on button click
  document.querySelectorAll('.btn-facsimile, .toggle-facs').forEach(function (btn) {
    btn.addEventListener('click', function () {

      const container = this.closest('.facs-container');
      const viewer = container.querySelector('[id^="osd_viewer_"]');

      if (viewer) {
        initViewer(viewer);
      }

      // optional toggle
      container.classList.toggle('d-none');
    });
  });

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

