class EmailsController < ApplicationController
  respond_to :html, :text, :json

  skip_before_action :redirect_from_preview_subdomain

  before_action :redirect_from_root_domain

  def show
    TrackPageView.call!(request: request, bucket: bucket)

    email = if params[:id] == 'last'
              bucket.emails.order(:created_at.desc).first or raise Mongoid::Errors::DocumentNotFound.new(Email, {})
            else
              bucket.emails.find(params[:id])
            end

    respond_to do |format|
      format.html { render_or_404(:html, email) }
      format.text { render_or_404(:text, email) }
      format.json { render_or_404(:json, email) }
    end
  end

  protected

  def render_or_404(format, email)
    case format
    when :html
      email.html ? render(inline: email.html) : render_404(format)
    when :text
      email.text ? render(plain: email.text) : render_404(format)
    when :json
      render(json: email)
    end
  end

  def render_404(format)
    render inline: "This email does not have a #{format} version", status: 404
  end

  def redirect_from_root_domain
    # To avoid XSS the email preview is under the preview subdomain,
    # which does not share the session with the root domain
    # This check makes sure users don't navigate on preview using the root domain
    unless /^#{request.protocol}preview\./.match?(request.url)
      redirect_to request.url.gsub(request.protocol, "#{request.protocol}preview.")
    end
  end
end
