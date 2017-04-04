# coding: utf-8
require 'digest/md5'
require 'net/http'
require 'json'
require 'pry'
require 'yaml'

module Youzan
  class Uri
    attr_reader :data, :base_url
    def initialize(opts)
      date = `date "+%Y-%m-%d %H:%M:%S"`.chomp

      timestamp = {
        "timestamp" => "#{date}"
      }
      
      filename = opts[:filename] ||= 'config.yml'
      api_type = opts[:api_type]
      base_url = opts[:base_url]
      params = opts[:params] ||= {}
      #binding.pry
      @data = YAML.load_file(File.join(filename))[api_type]
      @data = @data.merge(timestamp).merge(params)
      @base_url = YAML.load_file(File.join(filename))['base_url'][base_url]
    end

    def final_params
      #merge all params
      h_md5 = {"sign" => "#{gen_md5}"}
      data.merge(h_md5)
    end

    def gen_md5
      #binding.pry
      Digest::MD5.hexdigest "1e0e7082b75b619acd371842219a6a6b#{data.sort.join}1e0e7082b75b619acd371842219a6a6b"
    end
    
    def gen_uri
      #binding.pry
      uri = URI(base_url)
      uri.query = URI.encode_www_form(final_params)
      uri
    end
    
  end
end
