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
      Sku.new(items_arr).skus_arr  
    end

  end

  class Sku
    attr_reader :items_arr
    def initialize(items_arr)
      @items_arr = items_arr 
    end

    def filter_items
      #binding.pry
      arr = []
      @skus_arr
      items_arr.each do |item|
        item["skus"].each do |sku|
          arr.push(item) if out_of_date?( sku["properties_name"] )
        end
      end
      arr
    end

    def skus_arr
      arr = []
      filter_items.each do |item|
        item["skus"].each { |sku| arr.push(sku.merge({"title" => item["title"]}) )  if out_of_date?( sku["properties_name"] ) }
      end
      # binding.pry
      arr
    end
    
    def out_of_date? sku
      #out of date?
      if  /出行日期/.match(sku)
        #chineseMonth = `date "+%m月"`.chomp
        month = `date "+%m"`.to_i
        day =  `date "+%d"`.to_i
        # binding.pry
        /(\d+)月/.match(sku)
        month_schedule = $1.to_i
        /(\d+)日/.match(sku)
        # nil.to_i is 0.   other string can't convert to integer is 0.
        day_schedule = $1.to_i

        # schedule = (month_schedule + day_schedule).to_i

        # return true if now > schedule
        if month > month_schedule
          return true
        elsif month = month_schedule && day_schedule > 0 && day >= day_schedule
          return true 
        end
        
      end
    end
  end

  # class DateString
    
  # end
  # class MatchDateString
  #   def initialize(str)
  #   end

  #   def match
  #     /出行日期/.match(sku) && str
  #   end
    
  #   def find
  #     str.match
  #   end
  # end

  # class MissingDateString
    
  # end 
  
end






