App.buckets ||= {}

App.buckets['show'] = ->
  App.buckets.initializeAce()

  ZeroClipboard.config
    moviePath: '/flash/ZeroClipboard.swf'

  window.client = new ZeroClipboard $('#copy-button')
  htmlBridge = '#global-zeroclipboard-html-bridge'

  tipsyConfig = title: 'Copy to Clipboard', copiedHint: 'Copied!'

  $(htmlBridge).tipsy gravity: $.fn.tipsy.autoNS
  $(htmlBridge).attr 'title', tipsyConfig.title

  client.on 'complete', (client, args) ->
    $('#putsbox-url-input').focus().blur()

    $(htmlBridge).prop('title', tipsyConfig.copiedHint).tipsy 'show'
    $(htmlBridge).attr 'original-title', tipsyConfig.title

  EmailCountPoller.start()


EmailCountPoller =
  start: ->
    favicon = new Favico(bgColor: '#6C92C8', animation: 'none')
    favicon.badge($('#bucket-email-count').text())

    bucket = $('#putsbox-url-input').val().split('/')
    bucket = bucket[bucket.length - 1]

    pusher = new Pusher('3466d56fe2ef1fdd2943')
    channel = pusher.subscribe("channel_#{bucket}")
    channel.bind 'update_count', (count) ->
      try
        previousCount = $('#bucket-email-count').text()

        $('#bucket-email-count').text(count)

        favicon.badge(count)
      catch


      if parseInt(count, 10) > parseInt(previousCount, 10) && $('#new-requests-info #new-requests-received').length == 0
        $('#new-requests-info').hide().append('<em><a id="new-requests-received" href="javascript:window.location.reload();">New requests received. Load newer requests?</a></em>').fadeIn('slow')
