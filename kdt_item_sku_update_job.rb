# coding: utf-8
require 'digest/md5'
require 'net/http'
require 'json'
require 'pry'
require_relative 'kdt_item_sku_update_arr'

module Youzan
  class KdtItemSkuUpdateJob
    ## generate json for out of date skus
    attr_reader :api_type, :items_arr, :parsed_arr
    
    def initialize(items_arr, opts)
      @items_arr = items_arr
      @api_type = opts[:api_type]
      @parsed_arr = Youzan::KdtItemSkuUpdateArr.new(items_arr, opts).parse_json
      #parse_json

      write_to_file @parsed_arr
    end

    def run
      parsed_arr.each do |sku|
        # binding.pry
        params = { "num_iid"  => "#{sku["num_iid"]}", "sku_id" =>  "#{sku["sku_id"]}",  "quantity" => '0' }

        post_update({:api_type => api_type, :base_url => api_type, :params => params})

      end
    end
    
    def post_update(args)
      uri = Youzan::Uri.new(args).gen_uri
      # binding.pry
      post = Net::HTTP.post_form( uri, args[:params] )
      post.body
    end

    def write_to_file(json)
      #binding.pry
      File.write("yz_parse_json", JSON.pretty_generate(json))
    end
    
    
  end
end
