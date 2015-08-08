class BucketsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i(record create)

  before_filter :check_ownership!, only: %i(clear destroy)

  def create
    bucket = Bucket.create(owner_token: owner_token,
                           user_id: current_user.try(:id),
                           token: params[:token])

    redirect_to bucket_path(bucket.token)
  end

  def clear
    bucket.clear_history

    redirect_to bucket_path(bucket.token)
  end

  def destroy
    bucket.destroy

    redirect_to root_path
  end

  def show
    @emails = bucket.emails.page(params[:page]).per(50)
  end

  def record
    JSON.parse(params['mandrill_events']).select { |event| event['event'] == 'inbound' }.each do |event|
      email_params = event['msg'].slice(*%w(headers from_email from_name to email subject text html raw_msg))

      RecordEmail.call(token: email_params['email'].gsub(/\@.*/, ''),
                       email: Email.new(email_params),
                       request: request)
    end

    head :ok
  end
end
