# frozen_string_literal: true

require 'ksp/commands/launch'

RSpec.describe Ksp::Commands::Launch do
  subject(:command) { described_class.new }

  def stub_env(key, value)
    previous = ENV[key]
    ENV[key] = value

    yield
  ensure
    ENV[key] = previous
  end

  describe '.new' do
    it { expect(described_class).to respond_to(:new).with(0).arguments }
  end

  describe '#call' do
    let(:application_path)   { '/path/to/application' }
    let(:application_exists) { false }

    before(:example) do
      allow(Kernel).to receive(:puts)

      allow(Kernel).to receive(:system)

      allow(Dry::CLI::Utils::Files)
        .to receive(:exist?)
        .with("#{application_path}/KSP.app")
        .and_return(application_exists)
    end

    context 'when the application path is undefined' do
      let(:expected_error) do
        Ksp::Errors::UnknownApplicationPath.new
      end

      around(:example) do |example|
        stub_env('KSP_PATH', nil) { example.call }
      end

      it 'should return a failing result' do
        expect(command.call).to be_a_failing_result.with_error(expected_error)
      end

      it 'should not launch the application' do
        command.call

        expect(Kernel).not_to have_received(:system)
      end

      describe 'with dry_run: true' do
        it 'should return a failing result' do
          expect(command.call).to be_a_failing_result.with_error(expected_error)
        end

        it 'should not launch the application' do
          command.call(dry_run: true)

          expect(Kernel).not_to have_received(:system)
        end
      end
    end

    context 'when the application path is invalid' do
      let(:expected_error) do
        Ksp::Errors::InvalidApplicationPath
          .new(application_path: "#{application_path}/KSP.app")
      end

      around(:example) do |example|
        stub_env('KSP_PATH', application_path) { example.call }
      end

      it 'should return a failing result' do
        expect(command.call).to be_a_failing_result.with_error(expected_error)
      end

      it 'should not launch the application' do
        command.call

        expect(Kernel).not_to have_received(:system)
      end

      describe 'with dry_run: true' do
        it 'should return a failing result' do
          expect(command.call).to be_a_failing_result.with_error(expected_error)
        end

        it 'should not launch the application' do
          command.call(dry_run: true)

          expect(Kernel).not_to have_received(:system)
        end
      end
    end

    context 'when the application launch fails' do
      let(:application_exists) { true }
      let(:expected_error) do
        Cuprum::Error.new(message: 'Unable to launch application.')
      end

      before(:example) do
        allow(Kernel).to receive(:system).and_return(false)
      end

      around(:example) do |example|
        stub_env('KSP_PATH', application_path) { example.call }
      end

      it 'should return a failing result' do
        expect(command.call).to be_a_failing_result.with_error(expected_error)
      end

      it 'should attempt to launch the application' do
        command.call

        expect(Kernel)
          .to have_received(:system)
          .with(%(open "#{application_path}/KSP.app"))
      end

      describe 'with dry_run: true' do
        it 'should return a passing result' do
          expect(command.call(dry_run: true)).to be_a_passing_result
        end

        it 'should not launch the application' do
          command.call(dry_run: true)

          expect(Kernel).not_to have_received(:system)
        end
      end
    end

    context 'when the application launch succeeds' do
      let(:application_exists) { true }

      before(:example) do
        allow(Kernel).to receive(:system).and_return(true)
      end

      around(:example) do |example|
        stub_env('KSP_PATH', application_path) { example.call }
      end

      it 'should return a passing result' do
        expect(command.call).to be_a_passing_result
      end

      it 'should launch the application' do
        command.call

        expect(Kernel)
          .to have_received(:system)
          .with(%(open "#{application_path}/KSP.app"))
      end

      describe 'with dry_run: true' do
        it 'should return a passing result' do
          expect(command.call(dry_run: true)).to be_a_passing_result
        end

        it 'should not launch the application' do
          command.call(dry_run: true)

          expect(Kernel).not_to have_received(:system)
        end
      end
    end
  end
end
