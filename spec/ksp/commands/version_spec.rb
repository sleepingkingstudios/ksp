# frozen_string_literal: true

require 'ksp/commands/version'

RSpec.describe Ksp::Commands::Version do
  subject(:command) { described_class.new }

  describe '.new' do
    it { expect(described_class).to respond_to(:new).with(0).arguments }
  end

  describe '#call' do
    before(:example) do
      allow(command).to receive(:puts) # rubocop:disable RSpec/SubjectStub
    end

    it { expect(command.call).to be_a_passing_result }

    it 'should print the launcher version to stdout' do
      allow(command).to receive(:puts).and_call_original # rubocop:disable RSpec/SubjectStub

      expect { command.call }.to output("#{Ksp::VERSION}\n").to_stdout
    end
  end
end
