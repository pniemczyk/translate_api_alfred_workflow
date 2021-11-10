require 'net/http'
require 'uri'
require 'json'
require 'yaml'

class Store
  def initialize(name:, file_name: nil, file_path: nil)
    @name = name
    file_name ||= "#{name.to_s.downcase}.yml"
    file_path ||= file_path || Dir.pwd
    @file = File.join(file_path, file_name)
  end

  attr_reader :name, :file

  def current
    YAML.load(File.read(file)) || {}
  rescue => _
    {}
  end

  def load(target, query)
  (current[target] || {})[query.downcase]
  end

  def save(target, query, translation)
    payload = current.merge(target => {query.downcase => translation})
    File.open(file, 'w') { |f| YAML.dump(payload, f) }
  translation
  end
end

class Translator
  def initialize(api_key)
    @api_key = api_key
  end

  def translate(query, target='en')
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
    translations = JSON.parse(response.body)['data']['translations'] || [{}]
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

translator = Translator.new(ENV['GT_API_KEY'])
text       = ARGV[0].gsub(/[[:space:]]+/, " ").strip
target     = ENV['TARGET']

store  = Store.new(name: 'translations')
result = store.load(target, text) || store.save(target, text, translator.translate(text, target))
puts result
