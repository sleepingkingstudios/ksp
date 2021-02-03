# frozen_string_literal: true

require 'ksp/commands'

module Ksp::Commands
  # Command to output the current launcher version.
  class Version < Ksp::Cli::Command
    private

    def process
      Kernel.puts Ksp.version
    end
  end
end
