$ ->
  $(document).on 'click', 'a.popup', (e) ->
    e.preventDefault()
    that = $(this)
    href = that.attr 'href'
    width = 800
    height = 800
    left = (screen.width/2) - (width/2)
    top = (screen.height/2) - (height/2)
    window.open href, 'Gallery', "menubar=no,toolbar=no,status=no,width=#{width},height=#{height},left=#{left},top=#{top}"
    false

  $(document).on 'click', 'button#close-gallery', (e)->
    window.close();
