class EarningsController < ApplicationController
  def index
    ei = ExchangeInformation.all
    pr = Profit.all

    @created_on = ei.pluck(:created_on).uniq
    @coincheck_jpy_balance = ei.where("name = 'Coincheck'").pluck(:jpy_balance)
    @coincheck_btc_balance = ei.where("name = 'Coincheck'").pluck(:btc_balance)
    @coincheck_btc_price = ei.where("name = 'Coincheck'").pluck(:btc_price)
    @quoinex_jpy_balance = ei.where("name = 'Quoinex'").pluck(:jpy_balance)
    @quoinex_btc_balance = ei.where("name = 'Quoinex'").pluck(:btc_balance)
    @quoinex_btc_price = ei.where("name = 'Quoinex'").pluck(:btc_price)

    @total_balance = pr.pluck(:total_balance)
    @profit = pr.pluck(:profit)
    @profit_rate = pr.pluck(:profit_rate)
  end
end
