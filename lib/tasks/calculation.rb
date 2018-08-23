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
    total_btc_to_jpy_balance = today_data.sum(:btc_to_jpy_balance)
    total_balance = total_jpy_balance + total_btc_to_jpy_balance
    if yesterday_data
      yesterday_total_jpy_balance = yesterday_data.sum(:jpy_balance)
      yesterday_total_btc_to_jpy_balance = yesterday_data.sum(:btc_to_jpy_balance)
      btc_difference = total_btc_to_jpy_balance - yesterday_total_btc_to_jpy_balance
      profit = (total_jpy_balance - yesterday_total_jpy_balance + btc_difference).floor.to_f
      profit_rate = (profit / total_balance * 100).truncate(3)
    end

    insert_data_to_profit(total_jpy_balance, total_balance, profit, profit_rate)
  end

  def insert_data_to_profit(total_jpy_balance, total_balance, profit, profit_rate)
    pr = Profit.new
    pr.created_on = @today
    pr.total_jpy_balance = total_jpy_balance
    pr.total_balance = total_balance
    pr.profit = profit ||= 0
    pr.profit_rate = profit_rate ||= 0
    pr.save
  end
end