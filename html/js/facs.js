const source = document.getElementById("url").textContent;
var viewer = OpenSeadragon({
  id: "osd_viewer",
  tileSources: {
    type: "image",
    url: source
  },
  prefixUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/images/"
});
