# frozen_string_literal: true

require 'ksp/commands/config/application_path'

RSpec.describe Ksp::Commands::Config::ApplicationPath do
  subject(:command) { described_class.new }

  describe '.new' do
    it { expect(described_class).to respond_to(:new).with(0).arguments }
  end

  describe '#call' do
    let(:application_dir)    { '/path/to/application' }
    let(:application_path)   { "#{application_dir}/KSP.app" }
    let(:application_exists) { false }
    let(:env_path)           { nil }
    let(:read_result)        { Cuprum::Result.new(status: :failure) }
    let(:read_command) do
      instance_double(Ksp::Commands::Config::Read, call: read_result)
    end

    before(:example) do
      allow(Ksp::Commands::Config::Read)
        .to receive(:new)
        .and_return(read_command)

      allow(Dry::CLI::Utils::Files)
        .to receive(:exist?)
        .with(application_path)
        .and_return(application_exists)
    end

    around(:example) do |example|
      stub_env('KSP_PATH', env_path) { example.call }
    end

    context 'when the application path is undefined' do
      let(:expected_error) do
        Ksp::Errors::UnknownApplicationPath.new
      end

      it 'should return a failing result' do
        expect(command.call).to be_a_failing_result.with_error(expected_error)
      end
    end

    context 'when the application path is defined in ENV' do
      let(:env_path) { application_dir }

      context 'when the application does not exist' do
        let(:expected_error) do
          Ksp::Errors::InvalidApplicationPath
            .new(application_path: application_path)
        end

        it 'should return a failing result' do
          expect(command.call).to be_a_failing_result.with_error(expected_error)
        end
      end

      context 'when the application exists' do
        let(:application_exists) { true }

        it 'should return a passing result' do
          expect(command.call)
            .to be_a_passing_result
            .with_value(application_path)
        end
      end
    end

    context 'when the application path is defined in configuration' do
      let(:config)      { { 'application_path' => application_dir } }
      let(:read_result) { Cuprum::Result.new(value: config) }

      context 'when the application does not exist' do
        let(:expected_error) do
          Ksp::Errors::InvalidApplicationPath
            .new(application_path: application_path)
        end

        it 'should return a failing result' do
          expect(command.call).to be_a_failing_result.with_error(expected_error)
        end
      end

      context 'when the application exists' do
        let(:application_exists) { true }

        it 'should return a passing result' do
          expect(command.call)
            .to be_a_passing_result
            .with_value(application_path)
        end
      end
    end
  end
end
