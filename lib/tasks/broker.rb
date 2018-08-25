require_relative "calculation.rb"
require_relative "database_operation.rb"
require_relative "coincheck.rb"
require_relative "quoinex.rb"

class Broker
  def initialize
    @exchange = %W(Coincheck Quoinex)
    @today_data = Array.new
  end

  def start
    puts "broker start"
    start_exchange_api
    start_database_operation
    puts "broker end"
  end

  def start_exchange_api
    threads = []
    @exchange.each do |ex|
      threads << Thread.new do
        @today_data.push(Object.const_get(ex).new.start)
      end
    end

    threads.each { |t| t.join }
  end

  def start_calculation
    calc = Calculation.new
    calc.start
  end

  def start_database_operation
    dbo = DatabaseOperation.new
    dbo.insert_data_to_exchange_information(@today_data)
    total_jpy_balance, total_balance, profit, profit_rate = start_calculation
    dbo.insert_data_to_profit(total_jpy_balance, total_balance, profit, profit_rate)
  end
end

br = Broker.new
br.start