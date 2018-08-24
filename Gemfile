source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'carrierwave'
gem 'mini_magick', '~> 4.8'
gem 'rubycue'
gem 'taglib-ruby'

gem 'dry-configurable'
gem 'dry-transaction'
gem 'dry-validation'
gem 'multi_json'
gem 'representable'

gem 'rails', '~> 5.2.0'
gem 'sqlite3'
# gem 'rack-cors'
# gem 'redis', '~> 4.0'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'dotenv-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec-json_expectations', '~> 2.1.0'
  gem 'shoulda-matchers', '~> 3.0'
  gem 'factory_bot_rails', '~> 4.8.2'
end

# group :deploy, :development do
#   gem 'capistrano', '~> 3.8'
#   gem 'capistrano-rbenv', '~> 2.0.4'
#   gem 'capistrano-bundler', '~> 1.1'
#   gem 'capistrano-rails', '~> 1.1'
#   gem 'capistrano-rails-collection', '~> 0.0.3'
#   gem 'capistrano-faster-assets', '~> 1.0.2'
#   gem 'capistrano-yarn'
#   gem 'capistrano-passenger', '~> 0.2.0'
#   gem 'capistrano-sidekiq', '~> 0.5.4'
#   gem 'capistrano-ssh-doctor', '~> 1.0.0'
#   gem 'airbrussh', '~> 1.1.0', require: false
# end

group :production do
  gem 'passenger'
end
