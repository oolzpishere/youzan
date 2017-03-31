# coding: utf-8
require 'digest/md5'
require 'net/http'
require 'json'
require 'pry'

module Youzan
  class Uri
    def initialize(api)
      date = `date "+%Y-%m-%d %H:%M:%S"`.chomp
      
      @token_args = {
        :timestamp => "#{date}",
        :format => "json",
        :app_id => "a4f2cc760204c6d7c6",
        :v => "1.0",
        :sign_method => "md5"
      }

      @params = params(api)

    end

    def gen_md5
      Digest::MD5.hexdigest "1e0e7082b75b619acd371842219a6a6b#{@params.sort.join}1e0e7082b75b619acd371842219a6a6b"
    end

    def params_hash_with_md5
      @params.merge({:sign => "#{gen_md5}"}) 
    end

    def gen_uri
      uri = URI("https://open.youzan.com/api/entry")
      # uri = URI("https://open.youzan.com/api/entry?sign=#{gen_md5}&timestamp=#{ITEMS[:timestamp]}&v=#{ITEMS[:v]}&app_id=#{ITEMS[:app_id]}&method=#{ITEMS[:method]}&sign_method=md5&format=json&page_size=140")
      uri.query = URI.encode_www_form(params_hash_with_md5)
      uri
    end

    private
    # api eg. kdt.items.onsale.get = items_onsale_get
    def params(api)
      case api
      when "items_onsale_get"
      then
        @token_args.merge({
                            :method => "kdt.items.onsale.get",
                            :page_size => "140"
                          })

      end
    end
      
    
  end
end
