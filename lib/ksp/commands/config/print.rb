# frozen_string_literal: true

require 'json'

require 'ksp/commands/config'

module Ksp::Commands::Config
  # Prints the launcher configuration to STDOUT.
  class Print < Ksp::Cli::Command
    desc 'Prints the local configuration.'

    private

    def process
      config = step { read_configuration }
      pretty = JSON.pretty_generate(config)

      Kernel.puts(pretty)
    end

    def read_configuration
      Ksp::Commands::Config::Read.new.call(raw: false)
    end
  end
end
