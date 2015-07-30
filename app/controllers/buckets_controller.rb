class BucketsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :record

  before_filter :check_ownership!, only: %i[clear destroy update]

  def create
    result = CreateOrRetrieveBucket.call(owner_token: owner_token,
                                         user_id: current_user.try(:id),
                                         token: params[:token])

    redirect_to bucket_path(result.bucket.token)
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
    @emails = bucket.emails.page(params[:page]).per(5)
  end

  def record
    JSON.parse(params['mandrill_events']).select { |event| event['event'] == 'inbound' }.each do |event|
      email_params = event['msg'].slice(*%w(headers from_email from_name to email subject text html raw_msg))

      email_params['created_at'] = Time.at(event['ts'])

      RecordEmail.call(token: email_params[:email].gsub(/\@.*/, ''), email: Email.new(email_params))
    end

    notify_count

    head :ok
  end

  private

  def notify_count
    return unless ENV['PUSHER_SECRET'] || ENV['PUSHER_APP_ID']

    Pusher.url = "http://3466d56fe2ef1fdd2943:#{ENV['PUSHER_SECRET']}@api.pusherapp.com/apps/#{ENV['PUSHER_APP_ID']}"

    Pusher["channel_#{bucket.token}"].trigger 'update_count', bucket.emails_count
  end

  def render_request_not_found
    respond_to do |format|
      format.html { redirect_to bucket_path(bucket.token), alert: 'Please submit a request first' }
      format.json { render nothing: true, status: 404 }
    end
  end

  def bucket_params
    params.require(:bucket).permit(:name)
  end
end
