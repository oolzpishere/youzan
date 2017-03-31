# coding: utf-8
require 'digest/md5'
require 'net/http'
require 'json'
require 'pry'

module Youzan
  class FilterJson
    def initialize(raw_json)
      @raw_json = raw_json
      #parse_json
    end

    def yz_arr
      JSON.parse(@raw_json)
    end
    
    def items_arr
      yz_arr["response"]["items"]
    end

    def parse_json 
      skus_array = Array.new
      items_arr.each do |item|
        item["skus"].each do |sku|
          if date_comp?(sku["properties_name"])
            skus_array.push item["title"], item["detail_url"], sku_filter(item["skus"])
            break;
          end
        end 
      end
      #for check items number ritht
      skus_array.push items_arr.count
      skus_array
    end

    private
    def sku_filter skus
      selectedSku = %w[properties_name]

      filteredSku = Array.new
      skus.each do |sku|
        filteredSku << sku.select{ |k,v| selectedSku.include? k }
      end
      filteredSku
    end
    
    #out of date?
    def date_comp? sku
      #chineseMonth = `date "+%m月"`.chomp
      month = `date "+%m"`.to_i
      day =  `date "+%d"`.to_i
      sku =~  /(\d+)月(\d+)/

      return month >= $1.to_i && day > $2.to_i && sku  =~ /出行日期/ 
    end
    
    
  end
end






