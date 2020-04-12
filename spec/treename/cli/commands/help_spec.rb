# frozen_string_literal: true

require 'spec_helper'

require 'treename'
require 'aruba/rspec'

RSpec.describe 'TreeName::CLI::Commands', type: :aruba do
  include_context 'aruba setup'

  context '--help' do
    let(:args) { %w(--help) }
    subject { output }
    it { should match /TreeName/ }
    it { should match /#{TreeName::VERSION}/ }
    it { should match /MIT License/ }
  end
end
