require 'mail'
require 'pry'
require 'json'

#change root path to appropriate working directory


class SendMail
  attr_reader :report, :root, :failure_count, :mail
  
  def initialize
    @root = gen_root_path
    @report = gen_report
    @failure_count = @report["summary"]["failure_count"]
  end

  def run
    if  failure_count.zero?
      gen_mail
      mail.deliver 
      `cd #{root}; rspec spec/job_spec.rb`
    else
      gen_mail
      mail.deliver 
    end
  end

  def gen_root_path
    os_name = `uname -s`
    if os_name =~ /Darwin/
      File.expand_path("~/nut/sandbox/youzan")
    elsif os_name =~ /Linux/
      File.expand_path("~/youzan")
    end
    
  end

  def gen_mail
    set_mail
    @mail = Mail.new
    @mail.from =  'page_lee@qq.com'
    @mail.to = 'lizhipeng@dbtrip.com.cn'
    @mail.body = report
    if failure_count.zero?
      @mail.subject = 'skus success report'
    else
      @mail.subject = 'skus_arr_spec failed'
    end
  end


  def set_mail
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
  end

  def gen_report
    text = `cd #{root}; rspec spec/skus_arr_spec.rb --format j`
    JSON.parse( text )
  end

end

SendMail.new.run
