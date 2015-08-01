@Emails = React.createClass
  propTypes:
    initialEmails: React.PropTypes.array.isRequired
    bucketId: React.PropTypes.string.isRequired
    bucketToken: React.PropTypes.string.isRequired
    previewURLtemplate: React.PropTypes.string.isRequired

  getInitialState: ->
    emails: @props.initialEmails

  emailRow: (email, index) ->
    `<tr key={index}>
      <td>{email.from_email}</td>
      <td>{email.subject}</td>
      <td>{email.created_at}</td>
      <td>
        <a href={this.emailURL(email._id.$oid, "text")} target="_blank">Text</a>&nbsp;|&nbsp;
        <a href={this.emailURL(email._id.$oid, "html")} target="_blank">HTML</a>&nbsp;|&nbsp;
        <a href={this.emailURL(email._id.$oid, "json")} target="_blank">JSON</a>
      </td>
    </tr>`

  emailURL: (id, format) ->
    "#{@props.previewURLtemplate.replace('change-me', id)}.#{format}"

  render: ->
    `<table className="requests-header">
      <thead>
        <tr>
          <th>From</th>
          <th>Subject</th>
          <th>Date</th>
          <th>&nbsp;</th>
        </tr>
      </thead>
      <tbody>
        {this.state.emails.map(function(email, index) {
          return this.emailRow(email, index);
        }, this)}
      </tbody>
    </table>`
