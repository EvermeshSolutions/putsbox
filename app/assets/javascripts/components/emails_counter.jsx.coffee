@EmailsCounter = React.createClass
  propTypes:
    initialEmailsCount: React.PropTypes.number.isRequired

  getInitialState: ->
    emailsCount: @props.initialEmailsCount

  componentDidMount: ->
    $('body').on 'new-email', that: @, (e, data) ->
      that = e.data.that
      that.setState emailsCount: data.emailsCount

  componentwillunmount: ->
    $('body').off 'new-email'

  updateFavicon: ->
    @favicon ||= new Favico(bgColor: '#6C92C8', animation: 'none')
    @favicon.badge @state.emailsCount

  render: ->
    @updateFavicon()

    `<h3>{this.state.emailsCount}</h3>`
