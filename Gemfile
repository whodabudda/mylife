ruby '~> 3.2'
source 'https://rubygems.org'

#gem 'logger', '~> 1.3.0'
gem 'bigdecimal'
gem 'mutex_m'
gem 'base64'
gem 'logger', '~> 1.5'
gem 'drb'
gem 'ostruct'

# Gemfile - add these at the very top, before gem 'rails'
gem 'rails', '~> 7.0.0'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jsbundling-rails'
gem 'cssbundling-rails'
gem 'sprockets-rails'

gem 'mysql2'
# Use Puma as the app server
# security issue requires > 3.12.2
gem "puma", ">= 3.12.2"
#####################################
# my ppk installed gems
#gem 'highstock-rails'
#scary message for devise when running bundle install
#will need to upgrade
gem 'devise', '~>4.9'
#gem 'sassc-rails'
gem 'dartsass-rails'
gem 'coffee-script'
gem 'rinruby', git: 'https://github.com/clbustos/rinruby' , branch: 'master'
gem 'rserve-client'
#todo install rserve-client from git as the rubysource version doesn't have Fixnum changes.  Right
# now it is handled by a hack in config/initializers
#gem "rserve-client", git: "https://github.com/clbustos/Rserve-Ruby-client.git"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'factory_bot_rails'
  gem 'pry-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.8'

  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  # optional for Rails 7
#  gem 'spring'
#  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver", '>= 4.11'
#  gem "webdrivers"
  gem 'faker', '~> 2.20', group: :test
  gem 'rails-controller-testing'
  gem 'minitest-rails'
  gem 'minitest-hooks'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "actionview", ">= 5.0.7.2"
gem "activejob", ">= 5.0.7.1"
gem 'responders'  #responders gem is needed to use 'respond_with' after rails 4.x


