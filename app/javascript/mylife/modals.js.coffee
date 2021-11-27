# app/assets/javascripts/modals.js.coffee
$ ->
  modal_holder_selector = '#modal-holder'
  modal_selector = '.modal'

  $(document).on 'click', 'a[data-modal]', ->
    console.log "modal.js.coffee click: "
    location = $(this).attr('href')
    #Load modal dialog from server
    $.get location, (data)->
      $(modal_holder_selector).html(data).
      find(modal_selector).modal()
    false

  $(document).on 'ajax:success',
    'form[data-modal]', (event, data, status, xhr)->
      console.log "modal.js.coffee ajax:success " 
      url = xhr.getResponseHeader('Location')
      if url
        console.log "modal.js.coffee ajax:success redirect to url " 
        # Redirect to url
        window.location = url
      else
        console.log "modal.js.coffee ajax:success replace modal " 
        # Remove old modal backdrop
        $('.modal-backdrop').remove()

        # Replace old modal with new one
        $(modal_holder_selector).html(data).
        find(modal_selector).modal()

      false