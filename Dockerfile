FROM ruby:2.3.3-onbuild
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs mongodb
RUN chmod +x /usr/src/app/start_putsbox.sh
CMD /bin/bash -c 'service mongodb start & bundle exec unicorn -p 8081 -c /usr/src/app/config/unicorn.rb'
