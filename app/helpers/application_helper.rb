module ApplicationHelper
  def dispatcher_route
    controller_name = controller_path.gsub(/\//, "_")
    "#{controller_name}##{action_name}"
  end

  def token_email(token)
    "#{token}@putsbox.com"
  end

  def show_no_emails_found(bucket)
    content_tag(:p, 'No emails found.')
  end
end
