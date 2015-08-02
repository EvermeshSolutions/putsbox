@EmailsCounter = React.createClass
  propTypes:
    initialEmailsCount: React.PropTypes.number.isRequired

  getInitialState: ->
    emailsCount: @props.initialEmailsCount

  componentDidMount: ->
    $('body').on 'new-email', that: @, (e, data) ->
      that = e.data.that
      that.setState emailsCount: data.emailsCount

  componentWillUnmount: ->
    $('body').off 'new-email'

  render: ->
    `<h3>{this.state.emailsCount}</h3>`
