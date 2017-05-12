# coding: utf-8
require 'digest/md5'
require 'net/http'
require 'json'
require 'pry'
# require_relative 'uri'

require_relative 'kdt_item_sku_update_job'
require_relative 'items_arr'


module Youzan
  class Job
    attr_reader :opts, :items_arr, :params, :api_type
    
    def initialize(opts)
      @opts = opts
      @api_type  = opts[:api_type]
      @params = opts[:params]
      @items_arr = Youzan::ItemsArr.new({:api_type => "kdt_items_onsale_get", :base_url => "get"}).items_arr
    end


    def job
      class_name = 'Youzan::' +  api_type.split('_').map(&:capitalize).join + 'Job'
      Object.const_get(class_name).new(items_arr, opts).run
    end


  end
end

# Youzan::Job.new({:api_type => "kdt_item_sku_update"}).job

# Youzan::Job.new({:api_type => "kdt_items_update_delisting"}).job

# api eg. kdt.items.onsale.get = kdt_items_onsale_get

