# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AlfredResponseCollection do
  let(:list) do
    {
      'en' => 'Insane',
      'fr' => 'Insensé',
      'pl' => 'Szalony'
    }
  end

  let(:subtitle) { false }

  subject { described_class.new(list, subtitle: subtitle) }

  context 'when subtitle is off' do
    let(:expected_result) do
      %(
        <items>
          <item uid="en" arg="Insane">
            <title>Insane</title>
            <subtitle></subtitle>
            <icon>flags/en.png</icon>
          </item>

          <item uid="fr" arg="Insensé">
            <title>Insensé</title>
            <subtitle></subtitle>
            <icon>flags/fr.png</icon>
          </item>

          <item uid="pl" arg="Szalony">
            <title>Szalony</title>
            <subtitle></subtitle>
            <icon>flags/pl.png</icon>
          </item>
        </items>
      ).gsub(/[[:space:]]+/, ' ').strip
    end

    it 'result' do
      result = subject.result.gsub(/[[:space:]]+/, ' ').strip
      expect(result).to eq(expected_result)
    end
  end
end
