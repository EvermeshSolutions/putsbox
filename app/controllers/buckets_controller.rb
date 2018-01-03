class BucketsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i(record create)

  before_action :check_ownership!, only: %i(clear destroy)

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
    email_params = params.slice(*%w(headers subject text html))

    # http://stackoverflow.com/a/14011481
    from = params['from'].match(/(?:"?([^"]*)"?\s)?(?:<?(.+@[^>]+)>?)/)
    email_params['from_name']  = from[1]
    email_params['from_email'] = from[2]

    envelope = JSON.parse(params['envelope'])
    email_params['to']    = envelope['to'].to_a.dup
    email_params['email'] = envelope['to'].select { |to| to.downcase.end_with? '@putsbox.com' }.first

    if params['attachment-info'].present?
      email_params['attachments'] = JSON.parse(params['attachment-info']).values
    end

    email_params = email_params.permit(
      :headers,
      :from_email,
      :from_name,
      :subject,
      :text,
      :html,
      :subject,
      :email,
      :charsets,
      to: [],
      attachments: [:filename, :name, :type]
    )

    # See https://rollbar.com/putsbox/putsbox/items/15
    # request.POST.charsets	{"to":"UTF-8","html":"us-ascii","subject":"UTF-8","from":"UTF-8","text":"us-ascii"}
    set_encoding!(email_params, :text)
    set_encoding!(email_params, :html)

    RecordEmail.call(token: email_params['email'].gsub(/\@.*/, ''),
                     email: Email.new(email_params),
                     request: request)

    head :ok
  end

  def set_encoding!(params, key)
    return if params[key].nil? || params[:charsets].to_h[key].nil?

    params[key] = params[key].encode(params[:charsets][key]).force_encoding(Encoding::UTF_8)
  end
end
