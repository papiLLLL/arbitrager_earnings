require "net/http"
require "uri"
require "openssl"
require "json"
require "jwt"

class Quoinex
  def initialize
    @today = Time.now.strftime("%Y-%m-%d")
    @name = "Quoinex"
    @key = Settings.quoinex[:key]
    @secret = Settings.quoinex[:secret]
    @base_url = "https://api.quoine.com"
  end

  def start
    puts "#{@name} start"
    btc_price = get_ticker
    jpy_balance, btc_balance = get_balance
    #insert_data_to_exchange_information(jpy_balance, btc_balance, btc_price)
    puts "#{@name} end "
  end

  def get_ticker
    uri = URI.parse(@base_url)
    path = "/products/5"
    signature = get_signature(path, @key, @secret)
    response = request_http(uri, path, signature)
    response["last_traded_price"].to_i.floor
  end

  def get_balance
    uri = URI.parse(@base_url)
    path = "/accounts/balance"
    signature = get_signature(path, @key, @secret)
    response = request_http(uri, path, signature)
    extract_balance(response)
  end

  def get_signature(path, key, secret)
    timestamp = Time.now.to_i.to_s
    auth_payload = {
      path: path,
      nonce: timestamp,
      token_id: key
    }

    JWT.encode(auth_payload, secret, "HS256")
  end

  def request_http(uri, path, signature)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(path)
    request.add_field("X-Quoine-API-Version", "2")
    request.add_field("X-Quoine-AUth", signature)
    request.add_field("Content-Type", "application/json")

    response = https.request(request)
    JSON.parse(response.body)
  end

  def insert_data_to_exchange_information(jpy_balance, btc_balance, btc_price)
    ei = ExchangeInformation.new
    ei.date = @today
    ei.name = @name
    ei.jpy_balance = jpy_balance
    ei.btc_balance = btc_balance
    ei.btc_price = btc_price
    ei.balance = (jpy_balance + btc_balance * btc_price).floor
    ei.save
  end
end

def extract_balance(response)
  jpy_balance, btc_balance = nil
  response.each do |hash|
    jpy_balance = hash["balance"].to_i.floor if hash.has_value?("JPY")
    btc_balance = hash["balance"].to_f.truncate(3) if hash.has_value?("BTC")
  end

  return jpy_balance, btc_balance
end

qu = Quoinex.new
qu.start