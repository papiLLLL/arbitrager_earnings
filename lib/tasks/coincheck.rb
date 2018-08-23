require "net/http"
require "uri"
require "openssl"
require "json"

class Coincheck
  def initialize
    @today = Time.now.strftime("%Y-%m-%d")
    @name = "Coincheck"
    @key = Settings.coincheck[:key]
    @secret = Settings.coincheck[:secret]
    @base_url = "https://coincheck.com"
  end

  def start
    puts "#{@name} start"
    btc_price = get_ticker
    jpy_balance, btc_balance = get_balance
    insert_data_to_exchange_information(jpy_balance, btc_balance, btc_price)
    puts "#{@name} end"
  end

  def get_ticker
    uri = URI.parse(@base_url + "/api/ticker")
    headers = get_signature(uri, @key, @secret)
    response = request_http(uri, headers)
    response["last"].to_i.floor
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
    ei.created_on = @today
    ei.name = @name
    ei.jpy_balance = jpy_balance
    ei.btc_balance = btc_balance
    ei.btc_price = btc_price
    ei.btc_to_jpy_balance = (btc_balance * btc_price).floor
    ei.save
  end
end