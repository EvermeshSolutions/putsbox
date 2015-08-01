module ApplicationHelper
  def dispatcher_route
    controller_name = controller_path.gsub(/\//, "_")
    "#{controller_name}##{action_name}"
  end

  def token_email(token)
    "#{token}@putsbox.com"
  end

  def show_no_emails_found(bucket)
    if bucket.emails_count > 0
      content_tag(:p, "Oops... You received #{bucket.emails_count} emails, but they have expired.")
    else
      content_tag(:p, 'No emails received.')
    end
  end
end
