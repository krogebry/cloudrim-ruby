FROM ruby:latest

RUN mkdir -p /opt/edos/cloudrim/ui

COPY Gemfile /opt/edos/cloudrim/ui/
WORKDIR /opt/edos/cloudrim/ui/
RUN gem install bundler && bundle update

COPY ./ /opt/edos/cloudrim/ui/

WORKDIR /opt/edos/cloudrim/ui/

CMD ["./bin/entry_point.sh"]