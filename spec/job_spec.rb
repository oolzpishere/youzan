require 'spec_helper'

RSpec.describe Youzan::Job do
  describe 'ItemsArr#items_arr' do
    
    it 'update sku success' do
      update_job = Youzan::Job.new({:api_type => "kdt_item_sku_update"}).job
      expect(update_job).to be_truthy
    end
    
  end


  
end
