# frozen_string_literal: true

require 'ksp/cli/error_handling'

RSpec.describe Ksp::Cli::ErrorHandling do
  subject(:command) { command_class.new }

  let(:implementation) { -> {} }
  let(:command_class) do
    Class
      .new(Cuprum::Command) { prepend Ksp::Cli::ErrorHandling }
      .tap { |klass| klass.define_method(:process, &implementation) }
  end

  describe '#call' do
    before(:example) do
      allow(Kernel).to receive(:exit)

      allow(Kernel).to receive(:warn)
    end

    context 'when the command returns a passing result' do
      let(:value) { 'value' }
      let(:implementation) do
        str = value

        -> { Cuprum::Result.new(value: str) }
      end

      it { expect(command.call).to be_a_passing_result.with_value(value) }

      it 'should not trigger a manual exit' do
        command.call

        expect(Kernel).not_to have_received(:exit)
      end
    end

    context 'when the command returns a failing result' do
      let(:message) { 'Something went wrong.' }
      let(:error)   { Cuprum::Error.new(message: message) }
      let(:implementation) do
        err = error

        -> { Cuprum::Result.new(error: err) }
      end

      it 'should write the error message to STDERR' do
        allow(Kernel).to receive(:warn).and_call_original

        expect { command.call }.to output("#{message}\n").to_stderr
      end

      it 'should exit with status code 1' do
        command.call

        expect(Kernel).to have_received(:exit).with(1)
      end
    end

    context 'when the command raises an uncaught exception' do
      let(:message) { 'Something went wrong.' }
      let(:error) do
        Ksp::Errors::UncaughtException.new(
          exception: RuntimeError.new(message)
        )
      end
      let(:implementation) do
        msg = message

        -> { raise msg }
      end

      it 'should write the error message to STDERR' do
        allow(Kernel).to receive(:warn).and_call_original

        expect { command.call }.to output("#{error.message}\n").to_stderr
      end

      it 'should exit with status code 1' do
        command.call

        expect(Kernel).to have_received(:exit).with(1)
      end
    end
  end
end
