# coding: utf-8
require 'digest/md5'
require 'net/http'
require 'json'
require 'pry'
require 'yaml'

module Youzan
  class Uri
    attr_reader :data, :timestamp
    def initialize(opts)
      date = `date "+%Y-%m-%d %H:%M:%S"`.chomp
      
      @timestamp = {
        "timestamp" => "#{date}"
      }
      
      filename = opts[:filename]
      api = opts[:api]
      # binding.pry
      @data = YAML.load_file(File.join(filename))[api]

    end

    def params
      #merge all params
      h_md5 = {"sign" => "#{gen_md5}"}
      timestamp.merge(data).merge(h_md5)
    end

    def gen_md5
      #binding.pry
      Digest::MD5.hexdigest "1e0e7082b75b619acd371842219a6a6b#{timestamp.merge(data).sort.join}1e0e7082b75b619acd371842219a6a6b"
    end
    
    def gen_uri
      uri = URI("https://open.youzan.com/api/entry")
      uri.query = URI.encode_www_form(params)
      uri
    end
    
  end
end
