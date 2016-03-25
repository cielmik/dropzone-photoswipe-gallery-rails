$ ->
  $('.upload, .edit').on 'ajax:success', ->
    instance = $('[data-remodal-id=modal]').remodal()
    instance.open()
    $(document).on 'closed', '.remodal', ->
      instance.destroy()
  # only use dropzone when there is a class = dropzone on the page
    # previewNode = document.querySelector("")
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
        previewTemplate: document.getElementById('template').innerHTML

        # addedfile: (file) ->
        #   alert("Hello world")

        init: ->
          this.on 'addedfile', (file) ->
            # console.log("success")
            # $(".dz-remove").append("hello world")
          # .edit class to initialize mockfiles on edit path
          if $('.update').length > 0
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
          # window.location.href = '/'

          # add albumid attribute to dz-remove for deletion
          # $(file.previewTemplate).find('.dz-remove').attr('albumid', response.fileID);
          # $(file.previewElement).addClass('dz.success');

          #get url for image_list which is located at somehost.com/albums/albumid/image_list
          # albumid = $(file.previewTemplate).find('.dz-remove').attr('albumid')
          # url = this.element.action + "/" + albumid + '/image_list'
          # $.getJSON url, (data) ->
          #   $.each data, (index, val) ->
          #     # add picture id
          #     $('.dz-remove').eq(index).attr 'id', val.id

          # close the remodal if success
          $('[data-remodal-id=modal]').remodal().close()
          location.reload()
        removedfile: (file) ->
          id = $(file.previewTemplate).find('.dz-remove').attr('id')
          albumid = $(file.previewTemplate).find('.dz-remove').attr('albumid')
          $.ajax
            type: 'DELETE'
            url: '/pictures/' + id
            success: (data) ->
              console.log data.message
              return
          previewElement = undefined
          if (previewElement = file.previewElement) != null then previewElement.parentNode.removeChild(file.previewElement) else undefined
  )
      submitnoimage = (url, data) ->
        $.ajax
          type: "POST"
          url: url
          data: data
          dataType: "JSON"
          success: (data) ->
            $('[data-remodal-id=modal]').remodal().close()
            location.reload()

      $('.item-submit').on 'click', (e) ->
        e.preventDefault()
        e.stopPropagation()
        if dropzone.getQueuedFiles().length > 0
          dropzone.processQueue()
        else
          url = $(this).context.form.action
          formdata = $("form").serialize()
          submitnoimage(url, formdata)
