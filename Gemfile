ruby File.read('.ruby-version').chomp

source 'https://rubygems.org' do
  gem 'dotenv'

  gem 'rake'

  gem 'puma'

  gem 'sinatra'
  gem 'nokogiri'
  gem 'dalli'
  gem 'aws-sdk-cloudfront'


  group :development do
    gem 'capistrano', '~> 3.11'
    gem 'capistrano-bundler', '~> 1.3'
    gem 'capistrano-rbenv', '~> 2.1'
    gem 'capistrano-yarn'
    gem 'capistrano3-puma'
  end
end
