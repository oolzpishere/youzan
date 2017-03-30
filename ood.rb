# coding: utf-8
require 'digest/md5'
require 'net/http'
require 'json'
require 'pry'
require_relative 'uri'
require_relative 'filter_json'

module Youzan
  class ParseWorker

    
    def http_get(api)
      uri = Youzan::Uri.new(api).gen_uri

      #binding.pry
      Net::HTTP.get(uri)
    end

    
    def write_to_file(api)
      binding.pry
      json = Youzan::FilterJson.new(http_get(api))
      json = json.parse_json
      
      File.write("yz_parse_json", JSON.pretty_generate(json))
    end
    #binding.pry
    
  end
end

# api eg. kdt.items.onsale.get = items_onsale_get
Youzan::ParseWorker.new.write_to_file("items_onsale_get")