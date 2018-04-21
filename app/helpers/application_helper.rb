module ApplicationHelper
  def dispatcher_route
    controller_name = controller_path.gsub(/\//, '_')
    "#{controller_name}##{action_name}"
  end

  def token_email(token)
    "#{token}@putsbox.com"
  end
end
