class EarningsController < ApplicationController
  def dashboard
    ei = ExchangeInformation.all
    pr = Profit.all

    @total_balance = pr.last[:total_balance]
    @profit = pr.last[:profit]
    @profit_rate = pr.last[:profit_rate]
    gon.created_on = ei.pluck(:created_on).uniq
    
    gon.coincheck_jpy_balance = ei.where("name = 'Coincheck'").pluck(:jpy_balance)
    @coincheck_btc_balance = ei.where("name = 'Coincheck'").pluck(:btc_balance)
    @coincheck_btc_price = ei.where("name = 'Coincheck'").pluck(:btc_price)
    gon.coincheck_btc_price = @coincheck_btc_price
    gon.quoinex_jpy_balance = ei.where("name = 'Quoinex'").pluck(:jpy_balance)
    @quoinex_btc_balance = ei.where("name = 'Quoinex'").pluck(:btc_balance)
    @quoinex_btc_price = ei.where("name = 'Quoinex'").pluck(:btc_price)

    gon.total_balance = pr.pluck(:total_balance)
  end
end
