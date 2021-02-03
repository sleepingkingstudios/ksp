# frozen_string_literal: true

require 'ksp/commands/config'

module Ksp::Commands::Config
  # Prints the raw launcher configuration to STDOUT.
  class PrintRaw < Ksp::Cli::Command
    desc 'Prints the local configuration as raw YAML data.'

    private

    def process
      config = step { read_configuration }

      Kernel.puts(config)
    end

    def read_configuration
      Ksp::Commands::Config::Read.new.call(raw: true)
    end
  end
end
