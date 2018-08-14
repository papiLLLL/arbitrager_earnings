require "net/http"
require "uri"
require "openssl"
require "json"

class EarningsController < ApplicationController
  def initialize
    @key = ""
    @secret = ""
    @base_url = "https://coincheck.com"
    @version = "0.3.0"
  end

  def index
    uri = URI.parse(@base_url + "/api/ticker")
    headers = get_signature(uri, @key, @secret)
    @response = request_for_get(uri, headers = {})
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

  def request_for_get(uri, headers = {})
    request = Net::HTTP::Get.new(uri.request_uri, initheader = custom_header(headers))
    request_http(uri, request)
  end

  def custom_header(headers = {})
    headers.merge!({
      "Content-Type" => "application/json",
      "User-Agent" => "RubyCoincheckClient" + @version
    })
  end

  def request_http(uri, request)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.request(request)
    JSON.parse(response.body)
  end
end
