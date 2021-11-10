require 'net/http'
require 'uri'
require 'json'
require 'yaml'


class AlfredResponseCollection
  def initialize(list, subtitle: false)
    @list          = list
    @show_subtitle = subtitle
  end

  def result
    items = list.map do |target, text| 
      item_builder(
        uid: target, 
        arg: text, 
        title: text,
        subtitle: subtitle(target),
        icon: icon(target)
      )
    end
    "<items>#{items.join('')}</items>"
  end

  private

  attr_reader :list, :show_subtitle

  def subtitle(target)
    "Translation to #{target.upcase}"
  end

  def icon(target)
    "flags/#{target}.png"
  end

  def item_builder(uid:, arg:, title:, subtitle:, icon:)
    %{
      <item uid="#{uid}" arg="#{arg}">
        <title>#{title}</title>
        <subtitle>#{(subtitle if show_subtitle)}</subtitle>
        <icon>#{icon}</icon>
      </item>
    }
  end
end

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
    payload = current.merge(
      target => (current[target] || {}).merge(
        query.downcase => translation
      )
    )
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

store      = Store.new(name: 'translations')
translator = Translator.new(ENV['GT_API_KEY'])
text       = ARGV[0].gsub(/[[:space:]]+/, " ").strip
languages  = (ENV['TARGETS'] || "en, pl").split(',').map(&:strip)
subtitle   = !ENV['SUBTITLE_ENABLED'].to_s.strip.empty?

results = languages.map do |target|
  [
    target,
    store.load(target, text) || store.save(target, text, translator.translate(text, target))
  ]
end

puts AlfredResponseCollection.new(Hash[results], subtitle: subtitle).result
