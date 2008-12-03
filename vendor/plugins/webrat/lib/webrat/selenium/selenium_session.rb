module Webrat
  class TimeoutError < WebratError
  end
  
  class SeleniumResponse
    attr_reader :body
    attr_reader :session
    
    def initialize(session, body)
      @session = session
      @body = body
    end
    
    def selenium
      session.selenium
    end
  end
  
  class SeleniumSession
    
    def initialize(*args) # :nodoc:
    end
    
    def visit(url)
      selenium.open(url)
    end
    
    webrat_deprecate :visits, :visit
    
    def fill_in(field_identifier, options)
      locator = "webrat=#{Regexp.escape(field_identifier)}"
      selenium.wait_for_element locator, 5
      selenium.type(locator, "#{options[:with]}")
    end
    
    webrat_deprecate :fills_in, :fill_in
    
    def response
      SeleniumResponse.new(self, response_body)
    end
    
    def response_body #:nodoc:
      selenium.get_html_source
    end
    
    def click_button(button_text_or_regexp = nil, options = {})
      if button_text_or_regexp.is_a?(Hash) && options == {}
        pattern, options = nil, button_text_or_regexp
      else
        pattern = adjust_if_regexp(button_text_or_regexp)
      end
      pattern ||= '*'
      locator = "button=#{pattern}"
      
      selenium.wait_for_element locator, 5
      selenium.click locator
    end
    
    webrat_deprecate :clicks_button, :click_button

    def click_link(link_text_or_regexp, options = {})
      pattern = adjust_if_regexp(link_text_or_regexp)
      locator = "webratlink=#{pattern}"
      selenium.wait_for_element locator, 5
      selenium.click locator
    end
    
    webrat_deprecate :clicks_link, :click_link
    
    def click_link_within(selector, link_text, options = {})
      locator = "webratlinkwithin=#{selector}|#{link_text}"
      selenium.wait_for_element locator, 5
      selenium.click locator
    end
    
    webrat_deprecate :clicks_link_within, :click_link_within
    
    def select(option_text, options = {})
      id_or_name_or_label = options[:from]
      
      if id_or_name_or_label
        select_locator = "webrat=#{id_or_name_or_label}"
      else
        select_locator = "webratselectwithoption=#{option_text}"
      end
      
      selenium.wait_for_element select_locator, 5
      selenium.select(select_locator, option_text)
    end
    
    webrat_deprecate :selects, :select
    
    def choose(label_text)
      locator = "webrat=#{label_text}"
      selenium.wait_for_element locator, 5
      selenium.click locator
    end
    
    webrat_deprecate :chooses, :choose
        
    def check(label_text)
      locator = "webrat=#{label_text}"
      selenium.wait_for_element locator, 5
      selenium.check locator
    end
    
    webrat_deprecate :checks, :check

    def fire_event(field_identifier, event)
      locator = "webrat=#{Regexp.escape(field_identifier)}"
      selenium.fire_event(locator, "#{event}")
    end
    
    def key_down(field_identifier, key_code)
      locator = "webrat=#{Regexp.escape(field_identifier)}"
      selenium.key_down(locator, key_code)
    end

    def key_up(field_identifier, key_code)
      locator = "webrat=#{Regexp.escape(field_identifier)}"
      selenium.key_up(locator, key_code)
    end
    
    def wait_for(params={})
      timeout = params[:timeout] || 5
      message = params[:message] || "Timeout exceeded"

      begin_time = Time.now

      while (Time.now - begin_time) < timeout
        value = nil

        begin
          value = yield
        rescue ::Spec::Expectations::ExpectationNotMetError, ::Selenium::CommandError, Webrat::WebratError
          value = nil
        end

        return value if value

        sleep 0.25
      end

      raise Webrat::TimeoutError.new(message + " (after #{timeout} sec)")
      true
    end
    
    def selenium
      return $browser if $browser
      setup
      $browser
    end
    
    webrat_deprecate :browser, :selenium
    
  protected
    
    def setup #:nodoc:
      silence_stream(STDOUT) do
        Webrat.start_selenium_server
        Webrat.start_app_server
      end
      
      $browser = ::Selenium::Client::Driver.new("localhost", 4444, "*firefox", "http://0.0.0.0:3001")
      $browser.set_speed(0)
      $browser.start
      teardown_at_exit
      
      extend_selenium
      define_location_strategies
    end
    
    def teardown_at_exit #:nodoc:
      at_exit do
        silence_stream(STDOUT) do
          $browser.stop
          Webrat.stop_app_server
          Webrat.stop_selenium_server
        end
      end
    end
    
    def adjust_if_regexp(text_or_regexp) #:nodoc:
      if text_or_regexp.is_a?(Regexp)
        "evalregex:#{text_or_regexp.inspect}"
      else
        text_or_regexp
      end 
    end
    
    def extend_selenium #:nodoc:
      extensions_file = File.join(File.dirname(__FILE__), "selenium_extensions.js")
      extenions_js = File.read(extensions_file)
      selenium.get_eval(extenions_js)
    end
    
    def define_location_strategies #:nodoc:
      Dir[File.join(File.dirname(__FILE__), "location_strategy_javascript", "*.js")].sort.each do |file|
        strategy_js = File.read(file)
        strategy_name = File.basename(file, '.js')
        selenium.add_location_strategy(strategy_name, strategy_js)
      end
    end
  end
end