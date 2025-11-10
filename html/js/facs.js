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
