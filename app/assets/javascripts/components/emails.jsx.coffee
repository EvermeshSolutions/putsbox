@Emails = createReactClass
  propTypes:
    initialEmails: PropTypes.array.isRequired
    bucketId: PropTypes.string.isRequired
    bucketToken: PropTypes.string.isRequired
    bucketEmailsCount: PropTypes.number.isRequired
    previewURLtemplate: PropTypes.string.isRequired

  getInitialState: ->
    emails: @props.initialEmails

  componentDidMount: ->
    $('body').on 'new-email', that: @, (e, data) ->
      that = e.data.that
      that.setState emails: [data.email].concat(that.state.emails)

  componentwillunmount: ->
    $('body').off 'new-email'

  emailRows: ->
    @state.emails.map @emailRow

  emailRow: (email, index) ->
    `<tr key={index}>
      <td>{email.from_email}</td>
      <td>{email.subject}</td>
      <td>{email.created_at}</td>
      <td>
        <a href={this.emailURL(email.id, "text")} target="_blank">Text</a>&nbsp;|&nbsp;
        <a href={this.emailURL(email.id, "html")} target="_blank">HTML</a>&nbsp;|&nbsp;
        <a href={this.emailURL(email.id, "json")} target="_blank">JSON</a>
      </td>
    </tr>`

  emailURL: (id, format) ->
    "#{@props.previewURLtemplate.replace('change-me', id)}.#{format}"

  render: ->
    if @state.emails.length > 0 then @renderEmails() else @renderNoEmailsFound()

  renderNoEmailsFound: ->
    `<p>No emails found.</p>`

  renderEmails: ->
    `<div>
      <p><em>Emails expire in 15 minutes</em></p>
      <table className="requests-header">
        <thead>
          <tr>
            <th>From</th>
            <th>Subject</th>
            <th>Date</th>
            <th>Body</th>
          </tr>
        </thead>
        <tbody>
          {this.emailRows()}
        </tbody>
      </table>
    </div>`
