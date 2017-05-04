require 'mail'
require 'pry'
require 'json'

#change root path to appropriate working directory
root = File.expand_path("~/nut/sandbox/youzan")

`cd #{root}; rspec spec/skus_arr_spec.rb --format j -o skus_spec_output` 

path = File.expand_path("../../skus_spec_output", __FILE__ )
# binding.pry
f = File.new( path, "r")
@text = String.new
f.each_line { |line| @text << line}
rspec_result = JSON.parse(@text)

Mail.defaults do
  delivery_method :smtp, {
                    :address => "smtp.qq.com",
                    :port => 587,
                    :user_name => 'page_lee@qq.com',
                    :password => 'jjubhvljpnvhbhcj',
                    :authentication => :plain,
                    :enable_starttls_auto => true
                  }
end

mail = Mail.new do
  from 'page_lee@qq.com'
  to 'lizhipeng@dbtrip.com.cn'
  subject 'skus_arr_spec failed'
  body File.read(path)
end

if rspec_result["summary"]["failure_count"].zero?
  `cd #{root}; rspec spec/job_spec.rb`
else
  mail.deliver 
end


