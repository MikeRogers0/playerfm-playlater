require 'rubygems'
require 'net/http'
require 'nokogiri'
require 'sinatra'

configure { set :server, :puma }

get '/' do
  content_type 'application/rss+xml; charset=utf-8'

  # Cache for 24 hours at a time.
  response.headers['Cache-Control'] = 'public, max-age=86400'

  uri = URI('https://player.fm/mikerogers0/play-later.rss')
  req = Net::HTTP::Get.new(uri)
  req['Cookie'] = ENV['PLAYERFM_COOKIE']

  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: ( uri.scheme == 'https' )) {|http|
    http.request(req)
  }

  feeds = Nokogiri::XML(res.body)

  feeds.xpath('rss//channel//itunes:author').first.inner_html = 'MikeRogers0 Player Later Feed'
  feeds.xpath('rss//channel//itunes:name').first.inner_html = 'MikeRogers0 Player Later Feed'
  feeds.xpath('rss//channel//itunes:email').first.inner_html = 'me+podcasts@mikerogers.io'
  feeds.xpath('rss//channel//url').first.inner_html = 'http://player.fm/assets/logos/bubblemike144.png'
  
  feeds.to_xml
end
