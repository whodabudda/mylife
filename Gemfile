source 'https://rubygems.org'

gem 'rails', '~> 6.0'
gem 'webpacker', '~> 6.x'
gem 'mysql2'
# Use Puma as the app server
# security issue requires > 3.12.2
gem "puma", ">= 3.12.2"
#####################################
# my ppk installed gems
#gem 'highstock-rails'
gem 'devise'
gem 'sassc-rails'
gem 'coffee-script'
gem 'rinruby', git: 'https://github.com/clbustos/rinruby' , branch: 'master'

#Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

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
  gem 'listen', '~> 3.0.5'

  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
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


