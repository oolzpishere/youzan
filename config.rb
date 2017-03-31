# coding: utf-8
require 'digest/md5'
require 'net/http'
require 'json'
require 'pry'
require 'yaml'

module Youzan
  class Config
    attr_reader :data, :token_args
    def initialize(opts)
      date = `date "+%Y-%m-%d %H:%M:%S"`.chomp
      
      @token_args = {
        "timestamp" => "#{date}",
        "format" => "json",
        "app_id" => "a4f2cc760204c6d7c6",
        "v" => "1.0",
        "sign_method" => "md5"
      }
      
      filename = opts[:filename]
      api = opts[:api]
      # binding.pry
      @data = YAML.load_file(File.join(filename))[api]

    end

    def params
      #merge all params
      token_args.merge(data).merge("sign" => "#{gen_md5}")
    end

    def gen_md5
      #binding.pry
      Digest::MD5.hexdigest "1e0e7082b75b619acd371842219a6a6b#{token_args.merge(data).sort.join}1e0e7082b75b619acd371842219a6a6b"
    end

    
  end
end
