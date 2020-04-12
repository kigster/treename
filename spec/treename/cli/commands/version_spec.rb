# frozen_string_literal: true

require 'spec_helper'

require 'treename'
require 'aruba/rspec'

RSpec.describe TreeName::CLI::Commands::Version, type: :aruba do
  include_context 'aruba setup'

  context 'treename version' do
    let(:args) { %w(version) }
    subject { output }
    it { should_not match /TreeName/ }
    it { should match /#{TreeName::VERSION}/ }
  end
end
