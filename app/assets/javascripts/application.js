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
//= require_tree .


$(document).ready(function(){
	// only use dropzone when there is a class = dropzone on the page
	if ($('.dropzone').length) {
		Dropzone.autoDiscover = false;
		var dropzone = new Dropzone ("#my-dropzone", {
		    maxFiles: 50,
		    maxFilesize: 30,
		    paramName: "album[images][]",
		    addRemoveLinks: true,
				uploadMultiple: true,
		    autoProcessQueue: false,
				parallelUploads: 10,
				init: function(){
					// .edit class to initialize mockfiles on edit path
					if ($('.edit').length) {
						var thisDropZone = this;
						// http://someurl.com/albums/1/image_list.json
			      $.getJSON('image_list', function(data) {
			        $.each(data, function(index, val) {
			          var mockFile = { name: val.name, size: val.size };
								thisDropZone.emit("addedfile", mockFile);
								// thisDropZone.emit("thumbnail",
								// mockFile, "/uploads/picture/image/38/test_thumb.jpg");
								// val.path is defined by the path in album model
								thisDropZone.emit("thumbnail", mockFile, val.path);
								thisDropZone.emit("complete", mockFile);

								// add picture id to element attribute
								$(".dz-remove").eq(index).attr("id", val.id);
								// add album id to element attribute
								$(".dz-remove").eq(index).attr("albumid", val.album_id);
							});
						});
					}
				},
				processing: function(){
					dropzone.options.autoProcessQueue = true;
				},
				success: function (file, response) {
					// redirect to root_path after a successful upload
					window.location.href= ("/")
				},
				removedfile: function(file) {
					var id = $(file.previewTemplate).find('.dz-remove').attr('id');
					var albumid = $(file.previewTemplate).find('.dz-remove').attr('albumid');
					console.log(albumid)
					if (confirm("Are you sure?")){
						$.ajax({
							type: "DELETE",
							url: "/albums/" + albumid + "/pictures/" + id,
							success: function(data) {
								console.log(data.message);
							}
						})
					}
					var previewElement;
					return (previewElement = file.previewElement) != null ? (previewElement.parentNode.removeChild(file.previewElement)) : ( void 0 )
				}
		  });
			$(".item-submit").click(function (e) {
		    e.preventDefault();
		    e.stopPropagation();
		    dropzone.processQueue();
		    }
		  );
		}
});

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
