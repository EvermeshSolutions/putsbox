class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :owner?

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :redirect_from_preview_subdomain

  protected

  def redirect_from_preview_subdomain
    # To avoid XSS the email preview is under the preview subdomain,
    # which does not share the session with the root domain
    # This check makes sure users don't navigate on other pages than preview using the preview subdomain
    if request.url =~ /^#{request.protocol}preview\./
      redirect_to request.url.gsub(/#{request.protocol}preview\./, request.protocol)
    end
  end

  def check_ownership!
    unless owner?(bucket)
      redirect_to bucket_path(bucket.token), alert: 'Only the bucket owner can perform this operation'
    end
  end

  def owner?(bucket)
    return true unless bucket.user

    owner_token == bucket.owner_token || (user_signed_in? && bucket.user == current_user)
  end

  def owner_token
    cookies[:owner_token] ||= { value: SecureRandom.hex(24), expires: 1.year.from_now }
  end

  def bucket
    @bucket ||= CreateOrRetrieveBucket.call!(
      token: params[:token],
      owner_token: owner_token,
      user_id: (current_user.id if user_signed_in?)
    ).bucket
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:name, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password) }
  end
end
