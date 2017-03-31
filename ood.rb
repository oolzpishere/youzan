# coding: utf-8
require 'digest/md5'
require 'net/http'
require 'json'
require 'pry'
require_relative 'config'
require_relative 'filter_json'

module Youzan
  class ParseWorker
    attr_reader :config
    
    def initialize(opts)
      @config = Youzan::Config.new(opts).params
    end

    def run
      downloader = http_get
      json = Youzan::FilterJson.new(downloader)
      json = json.parse_json
      write_to_file json
    end

    def gen_uri
      uri = URI("https://open.youzan.com/api/entry")
      uri.query = URI.encode_www_form(config)
      uri
    end
    
    def http_get
      #binding.pry
      Net::HTTP.get(gen_uri)
    end

    
    def write_to_file(json)
      #binding.pry
      File.write("yz_parse_json", JSON.pretty_generate(json))
    end
    #binding.pry
    
  end
end

# api eg. kdt.items.onsale.get = kdt_items_onsale_get
Youzan::ParseWorker.new({:filename => "config.yml", :api => "kdt_items_onsale_get"}).run
