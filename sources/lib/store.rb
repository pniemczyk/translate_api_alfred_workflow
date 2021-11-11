# frozen_string_literal: true

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
    YAML.safe_load(File.read(file)) || {}
  rescue StandardError => _e
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
