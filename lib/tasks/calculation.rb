class Calculation
  def initialize
    @today = Time.now.strftime("%Y-%m-%d")
    @yesterday = 15.hours.ago.strftime("%Y-%m-%d")
  end

  def start
    puts "calculation start"
    today_data, yesterday_data = select_exchange_information
    calculate_profit(today_data, yesterday_data)
    puts "calculation end"
  end

  def select_exchange_information
    today_data = ExchangeInformation.where("date = '#{@today}'")
    yesterday_data = ExchangeInformation.where("date = '#{@yesterday}'")
    return today_data, yesterday_data
  end

  def calculate_profit(today_data, yesterday_data)
    total_jpy_balance = today_data.sum(:jpy_balance)
    total_btc_balance = today_data.sum(:btc_balance)
    average_btc_price = today_data.average(:btc_price)
    total_balance = total_jpy_balance + total_btc_balance * average_btc_price
    if yesterday_data
      yesterday_total_jpy_balance = yesterday_data.sum(:jpy_balance)
      yesterday_total_btc_balance = yesterday_data.sum(:btc_balance)
      yesterday_average_btc_price = yesterday_data.average(:btc_price)
      btc_difference = total_btc_balance * average_btc_price - yesterday_total_btc_balance * yesterday_average_btc_price
      profit = (total_jpy_balance - yesterday_total_jpy_balance + btc_difference).floor.to_f
      profit_rate = (profit / total_jpy_balance * 100).truncate(3)
    end

    insert_data_to_profit(total_jpy_balance, total_btc_balance,
                            average_btc_price, total_balance, profit, profit_rate)
  end

  def insert_data_to_profit(total_jpy_balance, total_btc_balance,
                              average_btc_price, total_balance, profit, profit_rate)
    pr = Profit.new
    pr.date = @today
    pr.total_jpy_balance = total_jpy_balance
    pr.total_btc_balance = total_btc_balance
    pr.average_btc_price = average_btc_price
    pr.total_balance = total_balance
    pr.profit = profit
    pr.profit_rate = profit_rate
    pr.save
  end
end