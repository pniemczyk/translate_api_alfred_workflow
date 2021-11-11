# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Translator do
  let('gt_api_key') { 'nice_try' }
  subject { described_class.new(gt_api_key) }

  it '#translate', :vcr do
    result = subject.translate('Szalony')
    expect(result).to eq('Insane')
  end

  it '#translate with target fr', :vcr do
    result = subject.translate('Szalony', 'fr')
    expect(result).to eq('Insensé')
  end
end
