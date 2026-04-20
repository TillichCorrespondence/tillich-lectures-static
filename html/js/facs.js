document.addEventListener('DOMContentLoaded', function () {

  function initViewer(el) {
    if (el.classList.contains('osd-loaded')) return;

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

  // init all on large screens
  if (window.innerWidth >= 992) {
    document.querySelectorAll('[id^="osd_viewer"]').forEach(initViewer);
  }

  // toggle + lazy load
  document.querySelectorAll('.toggle-facs').forEach(btn => {
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

  const toggleBtn = document.querySelector("#toggle-facs");
  if (!toggleBtn) return;
  
  let isHidden = false 
  const icon = toggleBtn.querySelector("i");
  const label = toggleBtn.querySelector(".toggle-facs-label");

  toggleBtn.addEventListener("click", () => {
    isHidden = !isHidden;
    const facsContents = document.querySelectorAll(".facs-content");
    const facsContainers = document.querySelectorAll(".facs-container");
    const transcripts = document.querySelectorAll(".pdf-transcript");

    // toggle all facsimiles
    facsContents.forEach(el => el.classList.toggle("d-none"));

    // adjust all layout columns
    facsContainers.forEach(el => {
      el.classList.toggle("col-lg-6");
      el.classList.toggle("col-lg-1");
    });

    transcripts.forEach(el => {
      el.classList.toggle("col-lg-6");
      el.classList.toggle("col-lg-9");
    });

    // toggle icon
    icon.classList.toggle("bi-caret-left-fill");
    icon.classList.toggle("bi-caret-right-fill");

    // update label (based on FIRST element state)
    label.textContent = isHidden ? "Show facsimile" : "Hide facsimile";
  });

});
