# frozen_string_literal: true

require 'ksp/commands/config/read'

RSpec.describe Ksp::Commands::Config::Read do
  subject(:command) { described_class.new }

  describe '.new' do
    it { expect(described_class).to respond_to(:new).with(0).arguments }
  end

  describe '#call' do
    let(:directory_path) { File.expand_path('~/.ksp') }
    let(:file_path)      { File.join(directory_path, 'config.yml') }
    let(:file_exists)    { false }

    before(:example) do
      allow(Dry::CLI::Utils::Files)
        .to receive(:exist?)
        .with(file_path)
        .and_return(file_exists)

      allow(File).to receive(:read).with(file_path)
    end

    context 'when the configuration does not exist' do
      let(:expected_error) do
        Ksp::Errors::MissingConfiguration.new(config_file: file_path)
      end

      it 'should return a failing result' do
        expect(command.call).to be_a_failing_result.with_error(expected_error)
      end
    end

    context 'when the configuration fails parsing' do
      let(:file_exists) { true }
      let(:config) do
        <<~YAML
          "
        YAML
      end
      let(:expected_error) do
        Ksp::Errors::InvalidConfiguration
          .new(config: config, config_file: file_path)
      end

      before(:example) do
        allow(File).to receive(:read).with(file_path).and_return(config)
      end

      it 'should return a failing result' do
        expect(command.call).to be_a_failing_result.with_error(expected_error)
      end
    end

    context 'when the configuration exists' do
      let(:file_exists) { true }
      let(:config) do
        <<~YAML
          ---
          key: value
        YAML
      end
      let(:expected) { Psych.safe_load(config) }

      before(:example) do
        allow(File).to receive(:read).with(file_path).and_return(config)
      end

      it 'should return a passing result' do
        expect(command.call).to be_a_passing_result.with_value(expected)
      end

      it 'should read the file' do
        command.call

        expect(File).to have_received(:read).with(file_path)
      end

      describe 'with raw: true' do
        it 'should return a passing result' do
          expect(command.call(raw: true))
            .to be_a_passing_result.with_value(config)
        end
      end
    end
  end
end
