# coding: utf-8
require 'spec_helper'

RSpec.describe Youzan::KdtItemSkuUpdateArr do
  describe 'ItemsArr#items_arr' do
    before(:example) do
      @items_arr = Youzan::ItemsArr.new({:api_type => "kdt_items_onsale_get", :base_url => "get"}).items_arr
    end
    
    it 'http get and return items array, each one is a product' do
      expect(@items_arr.count).to be > 0
    end

    it 'check skus array properties_name' do
      # binding.pry
      skus_arr = Youzan::KdtItemSkuUpdateArr.new( @items_arr, {:api_type => "kdt_item_sku_update"}).parse_json
      
      @month = `date "+%m"`.to_i
      @day =  `date "+%d"`.to_i
      
      # p "date now: #{@month}月#{@day}日"
      # p "skus arr count: #{skus_arr.count}"
      skus_arr.each do |sku|
        # binding.pry
        # p sku["properties_name"]
        expect( ood?(sku["properties_name"], @month, @day) ).to be true
      end 
    end

    #out of date
    def ood?(sku, month, day)
      if  /出行日期/.match(sku) ||  /出行时间/.match(sku)
        /(\d+)月/.match(sku)
        month_schedule = $1.to_i
        /(\d+)日/.match(sku)
        # nil.to_i is 0.   other string can't convert to integer is 0.
        day_schedule = $1.to_i

        case DateTime.new(2017, month_schedule, day_schedule) -1 <=> DateTime.now
        when -1
          return true
        else
          return false
        end        

      end
    end
    
  end 
end
