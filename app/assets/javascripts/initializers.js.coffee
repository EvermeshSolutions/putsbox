window.App ||= {}

$ ->
  Dispatcher.run App, $('body').data('route')
