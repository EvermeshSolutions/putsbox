class EmailsController < ApplicationController
  respond_to :html, :text, :json

  skip_before_action :redirect_from_preview_subdomain

  before_action :redirect_from_root_domain

  def show
    TrackPageView.call(request: request)

    email = if params[:id] == 'last'
              bucket.emails.order(:created_at.desc).first
            else
              bucket.emails.find(params[:id])
            end

    respond_to do |format|
      format.html { render inline: email.html }
      format.text { render text: email.text }
      format.json { render json: email }
    end
  end

  protected

  def redirect_from_root_domain
    # To avoid XSS the email preview is under the preview subdomain,
    # which does not share the session with the root domain
    # This check makes sure users don't navigate on preview using the root domain
    unless request.url =~ /^#{request.protocol}preview\./
      redirect_to request.url.gsub(request.protocol, "#{request.protocol}preview.")
    end
  end
end
