# frozen_string_literal: true

require 'ksp/cli/registry'

RSpec.describe Ksp::Cli::Registry do
  subject(:registry) { Module.new.extend(described_class) }

  describe '.register' do
    let(:command_class) { registry.get(%w[run]).command }

    example_constant 'Spec::Command', Cuprum::Command

    it 'should define the method' do
      expect(registry)
        .to respond_to(:register)
        .with(1..2).arguments
        .and_keywords(:aliases)
        .and_a_block
    end

    it 'should register a subclass of the command', :aggregate_failures do
      registry.register('run', Spec::Command)

      expect(command_class).to be < Spec::Command
      expect(command_class).to be < Ksp::Cli::ErrorHandling
    end

    it 'should prepend error handling to the command' do
      allow(Kernel).to receive(:exit)
      allow(Kernel).to receive(:warn)

      Cuprum::Command.define_method(:process) { raise }

      registry.register('run', Spec::Command)

      expect { command_class.new.call }.not_to raise_error
    end
  end
end
