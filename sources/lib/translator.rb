# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class Translator
  def initialize(api_key)
    @api_key = api_key
  end

  def translate(query, target = 'en')
    extract_translation(request(query, target))
  end

  private

  attr_reader :api_key

  def request(query, target)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri, headers)
    req.body = { q: query, target: target }.to_json
    http.request(req)
  end

  def extract_translation(response)
    translations = JSON.parse(response.body).dig('data', 'translations') || [{}]
    translations.first['translatedText']
  end

  def uri
    @uri ||= URI.parse("https://translation.googleapis.com/language/translate/v2?key=#{api_key}&format=text")
  end

  def headers
    @headers ||= {
      'Host': 'translation.googleapis.com',
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    }
  end
end
