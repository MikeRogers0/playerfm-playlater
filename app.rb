require 'rubygems'
require 'sinatra'

configure { set :server, :puma }

get '/' do
  content_type 'application/rss+xml; charset=utf-8'

  uri = URI('https://player.fm/mikerogers0/play-later.rss')
  req = Net::HTTP::Get.new(uri)
  cookie = '__cfduid=df2f693b90124597373423238eca85df31457863692; pfm-session=BAh7CUkiD3Nlc3Npb25faWQGOgZFVEkiJTExOTFmNWQ3YzBjMjQ2N2FiNDkwZjg3YzE1YjYxNjgzBjsAVEkiEF9jc3JmX3Rva2VuBjsARkkiMUsxTnFESURVTWtEaFhsMlptaUpSVWZ4M05NWnRXdWxHN1V3UzVHdHRGN009BjsARkkiGXdhcmRlbi51c2VyLnVzZXIua2V5BjsAVFsHWwZpA2jaAkkiAAY7AFRJIh13YXJkZW4udXNlci51c2VyLnNlc3Npb24GOwBUewZJIhRsYXN0X3JlcXVlc3RfYXQGOwBUbCsHggUNWA%3D%3D--0ebf6ccf68f7fda75bde0dd601b47772b28d13a2'
  req['Cookie'] = cookie

  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: ( uri.scheme == 'https' )) {|http|
    http.request(req)
  }

  res.body
end
