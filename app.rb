require 'rubygems'
Bundler.require :default, (ENV['RACK_ENV'] || 'development').to_sym
require './lib/player_fm'

configure { set :server, :puma }

get '/' do
  content_type 'application/rss+xml; charset=utf-8'

  cache_control :public, max_age: 360

  feeds = PlayerFM.all

  feeds.xpath('rss//channel//atom:link').first.attributes['href'].value = 'https://mikerogers.io/images/mike-rogers.jpg'

  feeds.xpath('rss//channel//itunes:author').first.inner_html = 'Podcast Queue - Mike Rogers'
  feeds.xpath('rss//channel//itunes:name').first.inner_html = 'Podcast Queue - Mike Rogers'
  feeds.xpath('rss//channel//itunes:email').first.inner_html = 'me+podcasts@mikerogers.io'
  feeds.xpath('rss//channel//itunes:image').first.attributes['href'].value = 'https://mikerogers.io/images/mike-rogers.jpg'

  feeds.xpath('rss//channel//title').first.inner_html = 'Podcast Queue - Mike Rogers'
  feeds.xpath('rss//channel//link').first.inner_html = 'https://podcasts.mikerogers.io/'

  feeds.xpath('rss//channel//image//url').first.inner_html = 'https://mikerogers.io/images/mike-rogers.jpg'
  feeds.xpath('rss//channel//image//title').first.inner_html = 'Podcast Queue - Mike Rogers'
  feeds.xpath('rss//channel//image//link').first.inner_html = 'https://podcasts.mikerogers.io/'

  feeds.to_xml
end
