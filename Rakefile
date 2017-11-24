require 'rubygems'
require 'dotenv/load'
Bundler.require :default, (ENV['RACK_ENV'] || 'development').to_sym
require './lib/player_fm'

namespace :cdn do
  desc 'Will clear CloudFlare if newer podcast has appeared.'
  task :clear do

    cache = Dalli::Client.new(ENV['MEMCACHEDCLOUD_SERVERS'].split(','), {
      username: ENV['MEMCACHEDCLOUD_USERNAME'],
      password: ENV['MEMCACHEDCLOUD_PASSWORD'],
      namespace: ENV.fetch('CACHE_PREFIX') { 'playerfm_' },
      expires_in: 86_400, # 12 hour default cache.
      compress: true
    })

    Cloudflair.configure do |config|
      config.cloudflare.auth.key = ENV['CLOUDFLARE_KEY']
      config.cloudflare.auth.email = ENV['CLOUDFLARE_EMAIL']
    end

    feeds = PlayerFM.all

    items_count = feeds.xpath('rss//item//title').count
    first_item_title = feeds.xpath('rss//item//title').first.inner_text

    # Set something easy to compare again in memcache.
    current_response = "#{items_count} - #{first_item_title}"

    # Get the current cache value and set the current one.
    cached_response = cache.get('player_keys', 3_600) || current_response
    cache.set('player_keys', current_response, 3_600)

    # If the feed has updated, clear the CDN.
    if cached_response != current_response
      puts 'Clearing podcast zone'
      Cloudflair.zone(ENV['CLOUDFLARE_ZONE_ID']).purge_cache.selective({
        files: ['https://podcasts.mikerogers.io/']
      }).inspect
    else
      puts 'No worries'
    end
  end
end
