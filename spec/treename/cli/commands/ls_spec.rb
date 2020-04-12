# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TreeName::CLI::Commands::LS, type: :aruba do
  include_context 'aruba setup'

  context 'command ls' do
    let(:args) { %w(ls --help) }

    subject { output }

    it { should match /Usage/ }
    it { should match /Command:/ }
  end
end
