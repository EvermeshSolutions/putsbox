# if ENV['SENDGRID_USERNAME'] && ENV['SENDGRID_PASSWORD']
  # ActionMailer::Base.smtp_settings = {
    # address:               'smtp.sendgrid.net',
    # port:                  '587',
    # authentication:        :plain,
    # user_name:             ENV['SENDGRID_USERNAME'],
    # password:              ENV['SENDGRID_PASSWORD'],
    # domain:                'heroku.com',
    # enable_starttls_auto:  true
  # }
  # ActionMailer::Base.delivery_method = :smtp
# end

if ENV['MANDRILL_USERNAME'] && ENV['MANDRILL_APIKEY']
  ActionMailer::Base.smtp_settings = {
    port:            '587',
    address:         'smtp.mandrillapp.com',
    user_name:       ENV['MANDRILL_USERNAME'],
    password:        ENV['MANDRILL_APIKEY'],
    domain:          'heroku.com',
    authentication:  :plain
  }
  ActionMailer::Base.delivery_method = :smtp
end
