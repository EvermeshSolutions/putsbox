[![Build Status](https://travis-ci.org/phstc/putsbox.svg)](https://travis-ci.org/phstc/putsbox)
[![Code Climate](https://codeclimate.com/github/phstc/putsbox/badges/gpa.svg)](https://codeclimate.com/github/phstc/putsbox)
[![Test Coverage](https://codeclimate.com/github/phstc/putsbox/badges/coverage.svg)](https://codeclimate.com/github/phstc/putsbox/coverage)

## PutsBox

PutsBox makes email integration tests easy. [Try it now](http://putsbox.com).

Have a look at [Test emails with automated testing tools](http://www.pablocantero.com/blog/2015/08/05/test-emails-with-automated-testing-tools/) for some examples.

## Getting started

PutsBox uses [SendGrid Inbound Email Parse Webhook](https://sendgrid.com/docs/API_Reference/Parse_Webhook/inbound_email.html) for receiving e-mails, therefore for running PutsBox in development or your server, you will need to setup a SendGrid account and configure an Inbound Parse within SendGrid admin.

Have a look at this post [Test SendGrid Webhooks with ngrok](https://sendgrid.com/blog/test-webhooks-ngrok/) for receiving Webhook calls in your localhost.

### Steps to run PutsBox in development

For following the instructions below, you will need to install [Docker](https://www.docker.com/get-docker).

```shell
cd ~/workspace

git clone git@github.com:phstc/putsbox.git

docker-compose up -d

open http://localhost:3000

docker-compose logs --follow --tail=100 app
```

#### Running tests

```shell
docker-compose run app bundle exec rspec
```

### Production

Putsbox auto expires (removes) inactive buckets in 1 day and emails in 15 minutes.

For enabling this behavior, PutsBox uses [MongoDB TTL](https://docs.mongodb.com/manual/tutorial/expire-data/).

```
db.buckets.createIndex({ "updated_at": 1 }, { expireAfterSeconds: 86400 })
db.emails.createIndex({ "created_at": 1 }, { expireAfterSeconds: 600 })
```

### License

Please see [LICENSE](https://github.com/phstc/putsbox/blob/master/LICENSE) for licensing details.
