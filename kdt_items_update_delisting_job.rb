# coding: utf-8
require 'digest/md5'
require 'net/http'
require 'json'
require 'pry'
require_relative 'kdt_item_sku_update_arr'

module Youzan
  class KdtItemsUpdateDelistingJob
    ## generate json for out of date skus
    attr_reader :items_arr, :parsed_arr, :api_type
    
    def initialize(items_arr, opts)
      @api_type = opts[:api_type]
      @items_arr = items_arr
      @parsed_arr = Youzan::KdtItemSkuUpdateArr.new(items_arr).parse_json
      #parse_json
    end

    def run
      parsed_arr[0,1].each do |sku|
        #binding.pry
        params = { "num_iids"  => "#{sku["num_iid"]}" }
        #binding.pry
        run_update({:api_type => api_type, :base_url => api_type, :params => params})

      end
    end
    
    def run_update(args)
      uri = Youzan::Uri.new(args).gen_uri
      # binding.pry
      post = Net::HTTP.post_form( uri, args[:params] )
      post.body
    end
    
    
  end
end






