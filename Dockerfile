FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y postgresql-client
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler
RUN bundle install
RUN apt-get install -y npm --silent
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install yarn
RUN apt update && apt install --no-install-recommends yarn
COPY . /myapp
RUN yarn install
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
