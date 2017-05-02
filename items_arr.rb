# coding: utf-8
require 'digest/md5'
require 'net/http'
require 'json'
require 'pry'
require_relative 'uri'
require 'uri'

module Youzan
  class ItemsArr
    attr_reader  :uri
         
    def initialize(opts)
      @uri = Youzan::Uri.new(opts).gen_uri
      #parse_json
    end

    def http_get
      #binding.pry
      Net::HTTP.get(uri)
    end

    def yz_arr
      JSON.parse(http_get)
      #binding.pry
    end
    
    def items_arr
      yz_arr["response"]["items"]
    end

    # def write_to_file(json)
    #   #binding.pry
    #   File.write("yz_parse_json", JSON.pretty_generate(json))
    # end
    
  end
end
