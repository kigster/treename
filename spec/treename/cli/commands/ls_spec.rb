# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TreeName::CLI::Commands::LS, type: :aruba do

  context 'command ls' do
    include_context 'aruba setup'
    let(:args) { %w(ls --help) }

    subject { output }

    it { should match /Usage/ }
    it { should match /Command:/ }
    it { should include 'treename ls [FOLDER] [PATTERN]' }

  end

  context 'listing directory' do
    include_context 'directories'
    include_context 'aruba setup'

    let(:pattern) { '**/*.txt' }
    let(:args) { %W[ls #{root_directory} #{pattern}] }

    subject { output }

    it { should include 'directory-1/file1.txt' }
    it { should include 'directory-1/file2.txt' }
    it { should include 'directory-2/file3.txt' }
  end
end
