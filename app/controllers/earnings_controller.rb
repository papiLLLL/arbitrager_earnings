class EarningsController < ApplicationController
  def dashboard
    ei = ExchangeInformation.all
    pr = Profit.all

    today = Time.current
    yesterday = today - 1.day
    thirty_days_ago = today - 30.day
    sixty_days_ago = thirty_days_ago - 30.day

    @total_balance, @total_balance_difference, @total_balance_ratio = calculate_item(*pr.last(2).pluck(:total_balance))
    @profit, @profit_difference, @profit_ratio = calculate_item(*pr.last(2).pluck(:profit))
    @profit_thirty_days,
    @profit_thirty_days_difference,
    @profit_thirty_days_ratio = calculate_item(
                                  pr.where(created_at: sixty_days_ago...thirty_days_ago).sum(:profit),
                                  pr.where(created_at: thirty_days_ago...today).sum(:profit))
    @profit_rate, @profit_rate_difference, @profit_rate_ratio = calculate_item(*pr.last(2).pluck(:profit_rate))
    @profit_rate_thirty_days,
    @profit_rate_thirty_days_difference,
    @profit_rate_thirty_days_ratio = calculate_item(
                                      pr.where(created_at: sixty_days_ago...thirty_days_ago).sum(:profit_rate),
                                      pr.where(created_at: thirty_days_ago...today).sum(:profit_rate))

    gon.created_on = ei.pluck(:created_on).uniq
    gon.coincheck_jpy_balance = ei.where("name = 'Coincheck'").pluck(:jpy_balance)
    gon.quoinex_jpy_balance = ei.where("name = 'Quoinex'").pluck(:jpy_balance)
    gon.total_balance = pr.pluck(:total_balance)
  end

  private

    def calculate_item(to, from)
      difference = (from * 1000 - to * 1000) / 1000
      difference = difference.zero? ? "±0" : sprintf("%+g", difference)
      ratio = to.zero? ? "±0" : sprintf("%+g", ((from / to.to_f * 100) - 100).round)
      return from, difference, ratio
    end
end
