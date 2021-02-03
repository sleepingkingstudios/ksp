# frozen_string_literal: true

require 'ksp/commands/launch'

RSpec.describe Ksp::Commands::Launch do
  subject(:command) { described_class.new }

  describe '.new' do
    it { expect(described_class).to respond_to(:new).with(0).arguments }
  end

  describe '#call' do
    let(:application_path) { '/path/to/application/KSP.app' }
    let(:find_command)     { Ksp::Commands::Config::ApplicationPath.new }
    let(:find_result)      { Cuprum::Result.new(value: application_path) }

    before(:example) do
      allow(Kernel).to receive(:puts)

      allow(Kernel).to receive(:system)

      allow(Ksp::Commands::Config::ApplicationPath)
        .to receive(:new)
        .and_return(find_command)

      allow(find_command).to receive(:call).and_return(find_result)
    end

    context 'when the application cannot be found' do
      let(:find_result) do
        error = Cuprum::Error.new(message: 'Something went wrong.')

        Cuprum::Result.new(error: error)
      end
      let(:expected_error) { find_result.error }

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
      let(:expected_error) do
        Cuprum::Error.new(message: 'Unable to launch application.')
      end

      before(:example) do
        allow(Kernel).to receive(:system).and_return(false)
      end

      it 'should return a failing result' do
        expect(command.call).to be_a_failing_result.with_error(expected_error)
      end

      it 'should attempt to launch the application' do
        command.call

        expect(Kernel)
          .to have_received(:system)
          .with(%(open "#{application_path}"))
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
      before(:example) do
        allow(Kernel).to receive(:system).and_return(true)
      end

      it 'should return a passing result' do
        expect(command.call).to be_a_passing_result
      end

      it 'should launch the application' do
        command.call

        expect(Kernel)
          .to have_received(:system)
          .with(%(open "#{application_path}"))
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
