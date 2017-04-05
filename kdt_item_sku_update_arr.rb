# coding: utf-8
require 'digest/md5'
require 'net/http'
require 'json'
require 'pry'

module Youzan
  class KdtItemSkuUpdateArr
    ## generate json for out of date skus
    attr_reader :items_arr, :api_type
    
    def initialize(items_arr, opts)
      # binding.pry
      @items_arr = items_arr
      @api_type = opts[:api_type]
      #parse_json
    end

    def parse_json 
      skus_array = Array.new
      items_arr.each do |item|
        item["skus"].each do |sku|
          if out_of_date?(sku["properties_name"])
            if api_type =~ /kdt_item_sku_update/
              skus_array.push sku.merge({"title" => item["title"]})
            end
            #item["num_iid"], item["title"], item["detail_url"], item["skus"] #sku_filter(item["skus"])
            # break;
          end
        end 
      end
      #for check items number ritht
      # skus_array.push items_arr.count
      skus_array
    end

    private
    
    #out of date?
    def out_of_date? sku
      if  sku  =~ /出行日期/
        #chineseMonth = `date "+%m月"`.chomp
        month = `date "+%m"`.to_i
        day =  `date "+%d"`.to_i
        ### bug hidden. $1 change depend on proccess order
        # binding.pry
        sku =~  /(\d+)月/
        month_schedule = $1.to_i
        sku =~  /(\d+)日/
        # nil.to_i is 0.   other string can't convert to integer is 0.
        day_schedule = $1.to_i
        
        if month > month_schedule
          return true
        elsif month = month_schedule && day_schedule > 0 && day > day_schedule
          return true
        
        end
      end
    end
    
    
  end
end






