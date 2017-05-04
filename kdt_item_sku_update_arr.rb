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
          arr.push(item) if Youzan::out_of_date?( sku["properties_name"] )
        end
      end
      arr
    end

    def skus_arr
      arr = []
      filter_items.each do |item|
        item["skus"].each do |sku|
          if Youzan::out_of_date?( sku["properties_name"] ) && sku["quantity"].to_i.nonzero?
            arr.push(sku.merge({"title" => item["title"]}) )  
          end
        end
      end
      # binding.pry
      arr
    end

    private

    
  end

  def self.out_of_date?(sku)
    #out of date?
    if  /出行日期/.match(sku) ||  /出行时间/.match(sku)
      #chineseMonth = `date "+%m月"`.chomp
      # month = `date "+%m"`.to_i
      # day =  `date "+%d"`.to_i
      
      /(\d+)月/.match(sku)
      month_schedule = $1.to_i
      /(\d+)日/.match(sku)
      # nil.to_i is 0.   other string can't convert to integer is 0.
      day_schedule = $1.to_i

      unless month_schedule.zero? || day_schedule.zero?
        case DateTime.new(2017, month_schedule, day_schedule) -1 <=> DateTime.now
        when -1
          return true
        else
          return false
        end        
    end

      # schedule = (month_schedule + day_schedule).to_i

      # return true if now > schedule
      # if month_schedule > 0 && month > month_schedule
      #   return true
      # elsif month < month_schedule
      #   return false
      # elsif month = month_schedule && day_schedule > 0 && day >= day_schedule + 5
      #   return true
      # else
      #   return false
      # end 
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






