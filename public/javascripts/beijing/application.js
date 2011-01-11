$(function() {
  $('#photography').slideshow()

  function initMap() {
    createMap();
    setMapEvent();
  }
  
  function createMap(){
    var map = new BMap.Map("map", { mapType: BMAP_PERSPECTIVE_MAP });
    var point = new BMap.Point(1 * $("figure").attr('data-lng'), 1 * $("figure").attr('data-lat'));
    map.setCurrentCity("北京");
    map.centerAndZoom(point, 18);
    map.enableScrollWheelZoom(true);
    window.map = map;
  }
  
  function setMapEvent(){
    map.enableDragging();
    map.enableScrollWheelZoom();
    map.enableDoubleClickZoom();
    map.enableKeyboard();
  }
  
  initMap();
});

function planTo(element) {
  map.panTo(new BMap.Point(
     1 * $(element).attr('data-lng'),
     1 * $(element).attr('data-lat')
  ));
}

(function($) {
  $.fn.slideshow = function() {
    var images = $(this).find('figure'), currentImage = 0, imageCount = images.length;
    var showImage = function(nextImage) {
      if (nextImage == imageCount) {
        nextImage = 0;
      }
      else if (nextImage < 0) {
        nextImage = imageCount - 1;
      }
      var current = images.eq(currentImage),
          next = images.eq(nextImage);
      current.css({
        zIndex: 100
      }).fadeOut(1000);
      next.hide().css({
        zIndex: 101
      }).fadeIn(1000, function() {
        current.hide();
      });
      planTo(next);
      currentImage = nextImage;
    };
    images.hide().eq(0).show();
    $('.next').click(function() {
      showImage(currentImage + 1);
      return false;
    });
    $('.previous').click(function() {
      showImage(currentImage - 1);
      return false;
    });
  };
})(jQuery);
