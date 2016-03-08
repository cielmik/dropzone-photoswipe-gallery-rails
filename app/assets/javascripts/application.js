// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require photoswipe
//= require turbolinks
//= require dropzone
//= require_tree .

(function($) {
  var $pswp, image;
  $pswp = $('.pswp')[0];
  image = [];
  $('.picture').each(function() {
    var $id, $pic, getItems, item2, items;
    $pic = $(this);
    $id = $(this).data('id');
    getItems = function() {
      var items;
      items = [];
      $id = $(this).data('id');
      $pic.find('a').each(function() {
        var $height, $href, $size, $width, item;
        $href = $(this).attr('href');
        $size = $(this).data('size').split('x');
        $width = $size[0];
        $height = $size[1];
        item = {
          src: $href,
          w: $width,
          h: $height
        };
        items.push(item);
      });
      return items;
    };
    item2 = getItems();
    items = item2;
    $.each(items, function(index, value) {
      image[index] = new Image;
      image[index].src = value['src'];
    });
    $pic.on('click', 'figure', function(event) {
      var $index, lightBox, options;
      event.preventDefault();
      $index = $(this).index();
      options = {
        index: $index,
        bgOpacity: 0.7,
        showHideOpacity: true
      };
      lightBox = new PhotoSwipe($pswp, PhotoSwipeUI_Default, items, options);
      lightBox.init();
    });
  });
})(jQuery);
