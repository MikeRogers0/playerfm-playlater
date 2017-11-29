require 'rubygems'
Bundler.require :default, (ENV['RACK_ENV'] || 'development').to_sym
require './lib/player_fm'

configure { set :server, :puma }

get '/' do
  content_type 'application/rss+xml; charset=utf-8'

  # Cache for 1 hour
  cache_control :public, max_age: 360

  feeds = PlayerFM.all

  feeds.xpath('rss//channel//itunes:author').first.inner_html = 'MikeRogers0 Player Later Feed'
  feeds.xpath('rss//channel//itunes:name').first.inner_html = 'MikeRogers0 Player Later Feed'
  feeds.xpath('rss//channel//itunes:email').first.inner_html = 'me+podcasts@mikerogers.io'
  feeds.xpath('rss//channel//url').first.inner_html = 'http://player.fm/assets/logos/bubblemike144.png'
  
  feeds.to_xml
end
