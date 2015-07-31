class BucketsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i(record create)

  before_filter :check_ownership!, only: %i[clear destroy]

  def create
    result = CreateOrRetrieveBucket.call(owner_token: owner_token,
                                         user_id: current_user.try(:id),
                                         token: params[:token])
    if result.success?
      redirect_to bucket_path(result.bucket.token)
    else
      redirect_to root_path, alert: result.message
    end
  end

  def clear
    bucket = Bucket.find_by(token: params[:token])
    bucket.clear_history

    redirect_to bucket_path(bucket.token)
  end

  def destroy
    bucket.destroy

    redirect_to root_path
  end

  def show
    @emails = bucket.emails.page(params[:page]).per(5)
  end

  def record
    JSON.parse(params['mandrill_events']).select { |event| event['event'] == 'inbound' }.each do |event|
      email_params = event['msg'].slice(*%w(headers from_email from_name to email subject text html raw_msg))

      email_params['created_at'] = Time.at(event['ts'])

      RecordEmail.call(token: email_params['email'].gsub(/\@.*/, ''), email: Email.new(email_params))
    end

    head :ok
  end

  private

  def bucket_params
    params.require(:bucket).permit(:name)
  end
end
