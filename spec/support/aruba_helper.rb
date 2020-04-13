# frozen_string_literal: true

RSpec.shared_context 'aruba setup', shared_context: :aruba_setup do
  let(:binary) { ::TreeName::BINARY }
  let(:args) { [] }
  let(:command) { "#{binary} #{args.join(' ')}" }

  before { run_command_and_stop(command) }

  let(:cmd) { last_command_started }
  let(:output) { cmd.stdout.chomp }

  subject { output }
end

RSpec.shared_context 'directories', shared_context: :aruba_setup do
  let(:root_directory) { 'tree' }
  let(:extension) { 'txt' }
  let(:files) do
    {
      'directory-1' => %W(file1.#{extension} file2.#{extension}),
      'directory-2' => %W(file3.#{extension})
    }
  end

  let(:extra_files) { {} }
  let(:file_paths) { [] }

  before do
    files.merge!(extra_files)
    files.each_pair do |sub_directory, file_list|
      dir = File.join(root_directory, sub_directory)
      create_directory(dir)
      file_list.each do |file|
        file_path = File.join(dir, file)
        touch(file_path)
        file_paths << file_path unless file_paths.include?(file_path)
      end
    end
  end

  context 'verify created temporary folders' do
    it 'should have created the files' do
      expect(file_paths).to_not be_empty
      expect(file_paths.first).to be_an_existing_file
      expect(file_paths.last).to be_an_existing_file
    end

    context 'glob the root' do
      subject(:glob_files) { Dir.glob("#{expand_path(root_directory)}/**/*.txt").map(&:to_s).sort }

      its(:size) { should_not eq 0 }
      its(:size) { should eq file_paths.size }
      it { is_expected.to eq(file_paths.sort.map { |f| expand_path(f) }) }
    end

    it('should have first subdirectory') { expect(root_directory).to have_sub_directory files.keys.first }
    it('should have second subdirectory') { expect(root_directory).to have_sub_directory files.keys.last }
  end
end

RSpec.configure do |rspec|
  rspec.include_context 'aruba setup', include_shared: true
end
