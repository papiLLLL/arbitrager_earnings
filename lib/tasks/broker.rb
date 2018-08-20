require_relative "calculation.rb"
require_relative "coincheck.rb"
require_relative "quoinex.rb"

class Broker
  def initialize
    @exchange = %W(Coincheck Quoinex)
  end

  def start
    puts "broker start"
    start_exchange_api(@exchange)
    start_calculation
    puts "broker end"
  end

  def start_exchange_api(exchange)
    threads = []
    exchange.each do |ex|
      threads << Thread.new do
        Object.const_get(ex).new.start
      end
    end

    threads.each { |t| t.join }
  end

  def start_calculation
    calc = Calculation.new
    calc.start
  end
end

br = Broker.new
br.start