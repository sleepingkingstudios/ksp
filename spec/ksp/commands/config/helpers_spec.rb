# frozen_string_literal: true

require 'ksp/commands/config/helpers'

RSpec.describe Ksp::Commands::Config::Helpers do
  subject(:helpers) { Object.new.extend(described_class) }

  describe '#config_dir' do
    context 'when ENV[KSP_CONFIG] is not set' do
      let(:expected) { File.expand_path('~/.ksp') }

      around(:example) do |example|
        stub_env('KSP_CONFIG', nil) { example.call }
      end

      it 'should return the default configuration path' do
        expect(helpers.config_dir).to be == expected
      end
    end

    context 'when ENV[KSP_CONFIG] is set' do
      let(:expected) { File.expand_path('~/KSP Launcher') }

      around(:example) do |example|
        stub_env('KSP_CONFIG', '~/KSP Launcher') { example.call }
      end

      it 'should return the configuration path' do
        expect(helpers.config_dir).to be == expected
      end
    end
  end

  describe '#config_file' do
    context 'when ENV[KSP_CONFIG] is not set' do
      let(:expected) { File.join(File.expand_path('~/.ksp'), 'config.yml') }

      around(:example) do |example|
        stub_env('KSP_CONFIG', nil) { example.call }
      end

      it 'should return the default configuration file' do
        expect(helpers.config_file).to be == expected
      end
    end

    context 'when ENV[KSP_CONFIG] is set' do
      let(:expected) do
        File.join(File.expand_path('~/KSP Launcher'), 'config.yml')
      end

      around(:example) do |example|
        stub_env('KSP_CONFIG', '~/KSP Launcher') { example.call }
      end

      it 'should return the configuration path' do
        expect(helpers.config_file).to be == expected
      end
    end
  end

  describe '#config_file_exists?' do
    let(:file_exists) { false }

    before(:example) do
      allow(Dry::CLI::Utils::Files)
        .to receive(:exist?)
        .with(helpers.config_file)
        .and_return(file_exists)
    end

    it 'should check for the presence of the file' do
      helpers.config_file_exists?

      expect(Dry::CLI::Utils::Files)
        .to have_received(:exist?)
        .with(helpers.config_file)
    end

    context 'when the file does not exist' do
      it { expect(helpers.config_file_exists?).to be false }
    end

    context 'when the file exists' do
      let(:file_exists) { true }

      it { expect(helpers.config_file_exists?).to be true }
    end
  end
end
