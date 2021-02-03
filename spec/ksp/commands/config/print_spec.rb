# frozen_string_literal: true

require 'ksp/commands/config/print'

RSpec.describe Ksp::Commands::Config::Print do
  subject(:command) { described_class.new }

  describe '.new' do
    it { expect(described_class).to respond_to(:new).with(0).arguments }
  end

  describe '#call' do
    let(:read_command) { Ksp::Commands::Config::Read.new }
    let(:read_result)  { Cuprum::Result.new(value: read_value) }
    let(:read_value)   { { 'key' => 'value' } }
    let(:expected)     { "#{JSON.pretty_generate(read_value)}\n" }

    before(:example) do
      allow(Kernel).to receive(:puts)

      allow(Ksp::Commands::Config::Read)
        .to receive(:new)
        .and_return(read_command)

      allow(read_command)
        .to receive(:call)
        .with(raw: false)
        .and_return(read_result)
    end

    it 'should return a passing result' do
      expect(command.call).to be_a_passing_result
    end

    it 'should print the configuration to STDOUT' do
      allow(Kernel).to receive(:puts).and_call_original

      expect { command.call }.to output(expected).to_stdout
    end
  end
end
