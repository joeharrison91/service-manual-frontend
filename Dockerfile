FROM ruby:2.6.3
RUN apt-get update -qq && apt-get upgrade -y

RUN apt-get install -y build-essential nodejs && apt-get clean

ENV GOVUK_APP_NAME service-manual-frontend
ENV PORT 3122
ENV RAILS_ENV development

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
ADD .ruby-version $APP_HOME/
RUN bundle install

ADD . $APP_HOME

CMD bash -c "bundle exec rails s -p $PORT -b '0.0.0.0'"
