require 'net/http'

class PlayerFM
  def self.all
    uri = URI('https://player.fm/mikerogers0/play-later.rss')
    req = Net::HTTP::Get.new(uri)
    req['Cookie'] = ENV['PLAYERFM_COOKIE']

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: ( uri.scheme == 'https' )) {|http|
      http.request(req)
    }

    feeds = Nokogiri::XML(res.body)
  end
end
