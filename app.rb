require 'rubygems'
require 'sinatra'

configure { set :server, :puma }

get '/' do
  "Hello World!"
end
