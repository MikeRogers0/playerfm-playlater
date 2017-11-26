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

    feeds = PlayerFM.all

    items_count = feeds.xpath('rss//item//title').count
    first_item_title = feeds.xpath('rss//item//title').first.inner_text

    # Set something easy to compare again in memcache.
    current_response = "#{items_count} -|- #{first_item_title}"

    # Get the current cache value and set the current one.
    cached_response = cache.get('player_keys', 3_600) || current_response
    cache.set('player_keys', current_response, 3_600)

    # If the feed has updated, clear the CDN.
    if cached_response != current_response
      puts 'Clearing podcast zone'

      cloudfront = Aws::CloudFront::Client.new(region: 'us-east-1', access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
      cloudfront.create_invalidation(distribution_id: ENV['AWS_CLOUDFRONT_DISTRIBUTION_ID'], invalidation_batch: {
        paths: {
          quantity: 1,
          items: ['/*'],
        },
        caller_reference: Time.now.to_s
      })
    else
      puts 'No worries'
    end
  end
end
