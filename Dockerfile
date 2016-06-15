FROM ruby:2.3.1

RUN apt-get update
RUN apt-get install -y streamer

ADD ./ /src
WORKDIR /src
RUN gem install bundler
RUN bundle install
ENTRYPOINT ["bundle","exec"]
CMD ["./app", "-p", "80", "-o", "0.0.0.0"]

EXPOSE 80
