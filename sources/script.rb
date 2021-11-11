# frozen_string_literal: true

user_home           = Dir.home
alfred_base         = '/Library/Application Support/Alfred/Alfred.alfredpreferences/workflows/'
alfred_workflow_uid = ENV['alfred_workflow_uid']
source_path         = [user_home, alfred_base, alfred_workflow_uid, '/sources'].join

require "#{source_path}/lib/store"
require "#{source_path}/lib/translator"
require "#{source_path}/lib/alfred_response_collection"

store      = Store.new(name: 'translations')
translator = Translator.new(ENV['GT_API_KEY'])
text       = ARGV[0].gsub(/[[:space:]]+/, ' ').strip
languages  = (ENV['TARGETS'] || 'en, pl').split(',').map(&:strip)
subtitle   = !ENV['SUBTITLE_ENABLED'].to_s.strip.empty?

results = languages.map do |target|
  [
    target,
    store.load(target, text) || store.save(target, text, translator.translate(text, target))
  ]
end

puts AlfredResponseCollection.new(Hash[results], subtitle: subtitle).result
