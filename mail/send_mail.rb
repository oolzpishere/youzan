require 'mail'
require 'pry'

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
  subject 'Test ruby mail'
  body 'Test body'
end
binding.pry
mail.to_s
