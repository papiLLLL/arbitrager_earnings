require "net/http"
require "uri"
require "openssl"
require "json"

class BitcoinInformation
  def initialize
    @today = Time.now.strftime("%Y-%m-%d")
    @name = "Coincheck"
    @key = Settings.coincheck[:key]
    @secret = Settings.coincheck[:secret]
    @base_url = "https://coincheck.com"
  end

  def start
    btc_price = get_ticker
    jpy_balance, btc_balance = get_balance
    insert_data_to_profit(jpy_balance, btc_balance, btc_price)
    insert_data_to_exchange_information(jpy_balance, btc_balance, btc_price)
  end

  def get_ticker
    uri = URI.parse(@base_url + "/api/ticker")
    headers = get_signature(uri, @key, @secret)
    response = request_http(uri, headers)
    response["last"]
  end

  def get_balance
    uri = URI.parse(@base_url + "/api/accounts/balance")
    headers = get_signature(uri, @key, @secret)
    response = request_http(uri, headers)
    return response["jpy"].to_i.floor, response["btc"].to_f.truncate(3)
  end

  def get_signature(uri, key, secret, body = "")
    timestamp = Time.now.to_i.to_s
    message = timestamp + uri.to_s + body
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, message)
    headers = {
      "ACCESS-KEY" => key,
      "ACCESS-NONCE" => timestamp,
      "ACCESS-SIGNATURE" => signature
    }
  end

  def request_http(uri, headers)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.start {
      https.get(uri.request_uri, headers)
    }
    JSON.parse(response.body)
  end

  def insert_data_to_exchange_information(jpy_balance, btc_balance, btc_price)
    ei = ExchangeInformation.new
    ei.date = @today
    ei.name = @name
    ei.jpy_balance = jpy_balance
    ei.btc_balance = btc_balance
    ei.btc_price = btc_price
    ei.save
  end

  def insert_data_to_profit(jpy_balance, btc_balance, btc_price)
    total_jpy_balance, profit, profit_rate = calculate_profit(jpy_balance, btc_balance, btc_price, get_data_yesterday)
    pr = Profit.new
    pr.date = @today
    pr.total_jpy_balance = total_jpy_balance
    pr.profit = profit
    pr.profit_rate = profit_rate
    pr.save
  end

  def get_data_yesterday
    ExchangeInformation.last
  end

  def calculate_profit(jpy_balance, btc_balance, btc_price, data_yesterday)
    btc_difference = btc_balance * btc_price - data_yesterday.btc_balance * data_yesterday.btc_price
    total_jpy_balance = (jpy_balance + btc_balance * btc_price).floor
    profit = (jpy_balance - data_yesterday.jpy_balance + btc_difference).floor.to_f
    profit_rate = (profit / total_jpy_balance * 100).truncate(2)
    return total_jpy_balance, profit, profit_rate
  end
end

bi = BitcoinInformation.new
bi.start