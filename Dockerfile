FROM centurylink/alpine-rails

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5 --without development test

# Set Rails to run in production
ENV RAILS_ENV production
ENV RACK_ENV production
ENV SECRET_KEY_BASE a359c47c71b805e70fc85f9b49f8262beba98cdccdc189bc52321c49c1a96fc557dc4ca423bfa56f17a19299b07ef6cb0352802ecc0b6ab7e7b4e6c74f34a3dc

# Copy the main application.
COPY . ./

# Precompile Rails assets
RUN bundle exec rake assets:precompile

# Start puma
CMD bundle exec puma
