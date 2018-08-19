require_relative "calculation.rb"
require_relative "coincheck.rb"
require_relative "quoinex.rb"

class Broker
  def initialize
    @exchange = %W(Coincheck Quoinex)
  end

  def start
    puts "broker start"
    #get_exchange_information(@exchange)
    calc = Calculation.new
    calc.calculate_profit
    puts "broker end"
  end

  def get_exchange_information(exchange)
    threads = []
    exchange.each do |ex|
      threads << Thread.new do
        Object.const_get(ex).new.start
      end
    end

    threads.each { |t| t.join }
  end
end

br = Broker.new
br.start