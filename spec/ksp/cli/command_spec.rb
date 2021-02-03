# frozen_string_literal: true

require 'ksp/cli/command'

RSpec.describe Ksp::Cli::Command do
  subject(:command) { described_class.new }

  it { expect(command).to be_a Dry::CLI::Command }

  it { expect(command).to be_a_kind_of Cuprum::Processing }
end
