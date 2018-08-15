require "net/http"
require "uri"
require "openssl"
require "json"

class BitcoinInformation
  def initialize
    @key = Settings.coincheck[:key]
    @secret = Settings.coincheck[:secret]
    @base_url = "https://coincheck.com"
  end

  def start
    get_ticker
    get_balance
  end

  def get_ticker
    uri = URI.parse(@base_url + "/api/ticker")
    headers = get_signature(uri, @key, @secret)
    response = request_http(uri, headers)
    puts response["last"]
  end

  def get_balance
    uri = URI.parse(@base_url + "/api/accounts/balance")
    headers = get_signature(uri, @key, @secret)
    response = request_http(uri, headers)
    puts response["jpy"].to_i.floor
    puts response["btc"].to_f.truncate(3)
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
end

bi = BitcoinInformation.new
bi.start