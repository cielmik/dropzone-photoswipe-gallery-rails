$ ->
  $('.upload, .edit').on 'ajax:success', ->
    instance = $('[data-remodal-id=modal]').remodal()
    instance.open()
  # only use dropzone when there is a class = dropzone on the page
    if $('.dropzone').length
      Dropzone.autoDiscover = false
      dropzone = new Dropzone('#my-dropzone',
        maxFiles: 50
        maxFilesize: 30
        paramName: 'album[images]'
        addRemoveLinks: true
        uploadMultiple: true
        autoProcessQueue: false
        parallelUploads: 10
        init: ->
          # .edit class to initialize mockfiles on edit path
          if $('.edit').length
            thisDropZone = this
            # http://someurl.com/albums/1/image_list.json
            url = this.element.action
            $.getJSON url + '/image_list', (data) ->
              $.each data, (index, val) ->
                mockFile =
                  name: val.name
                  size: val.size
                thisDropZone.emit 'addedfile', mockFile
                # thisDropZone.emit("thumbnail",
                # mockFile, "/uploads/picture/image/38/test_thumb.jpg");
                # val.path is defined by the path in album model
                thisDropZone.emit 'thumbnail', mockFile, val.path
                thisDropZone.emit 'complete', mockFile
                # add picture id to element attribute
                $('.dz-remove').eq(index).attr 'id', val.id
                # add album id to element attribute
                $('.dz-remove').eq(index).attr 'albumid', val.album_id
                return
              return
          return
        processing: ->
          dropzone.options.autoProcessQueue = true
          return
        success: (file, response) ->
          # redirect to root_path after a successful upload
          window.location.href = '/'
          return
        removedfile: (file) ->
          id = $(file.previewTemplate).find('.dz-remove').attr('id')
          albumid = $(file.previewTemplate).find('.dz-remove').attr('albumid')
          console.log albumid
          if confirm('Are you sure?')
            $.ajax
              type: 'DELETE'
              url: '/albums/' + albumid + '/pictures/' + id
              success: (data) ->
                console.log data.message
                return
          previewElement = undefined
          if (previewElement = file.previewElement) != null then previewElement.parentNode.removeChild(file.previewElement) else undefined
  )
      $('.item-submit').click (e) ->
        e.preventDefault()
        e.stopPropagation()
        dropzone.processQueue()
        return
    return
