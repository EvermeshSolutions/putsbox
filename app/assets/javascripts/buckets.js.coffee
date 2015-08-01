App.buckets ||= {}

App.buckets['show'] = ->
  ZeroClipboard.config
    moviePath: '/flash/ZeroClipboard.swf'

  window.client = new ZeroClipboard $('#copy-button')
  htmlBridge = '#global-zeroclipboard-html-bridge'

  tipsyConfig = title: 'Copy to Clipboard', copiedHint: 'Copied!'

  $(htmlBridge).tipsy gravity: $.fn.tipsy.autoNS
  $(htmlBridge).attr 'title', tipsyConfig.title

  client.on 'complete', (client, args) ->
    $('#putsbox-token-input').focus().blur()

    $(htmlBridge).prop('title', tipsyConfig.copiedHint).tipsy 'show'
    $(htmlBridge).attr 'original-title', tipsyConfig.title

  EmailCountPoller.start()


EmailCountPoller =
  start: ->
    favicon = new Favico(bgColor: '#6C92C8', animation: 'none')
    favicon.badge($('#bucket-email-count').text())

    bucket = $('#putsbox-token-input').data('token')

    pusher = new Pusher('3466d56fe2ef1fdd2943')
    channel = pusher.subscribe("channel_emails_#{bucket}")
    channel.bind 'update_count', (count) ->
      try
        previousCount = $('#bucket-email-count').text()

        $('#bucket-email-count').text(count)

        favicon.badge(count)
      catch error

      if parseInt(count, 10) > parseInt(previousCount, 10) && $('#new-emails-info #new-emails-received').length == 0
        $('#new-emails-info').hide().append('<em><a id="new-emails-received" href="javascript:window.location.reload();">New emails received. Load newer emails?</a></em>').fadeIn('slow')
