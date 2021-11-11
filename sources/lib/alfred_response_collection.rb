# frozen_string_literal: true

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
        title: text || "#{target.upcase} language is not supported :(",
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
    %(
      <item uid="#{uid}" arg="#{arg}">
        <title>#{title}</title>
        <subtitle>#{subtitle if show_subtitle}</subtitle>
        <icon>#{icon}</icon>
      </item>
    )
  end
end
