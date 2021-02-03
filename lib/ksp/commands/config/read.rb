# frozen_string_literal: true

require 'psych'

require 'ksp/commands/config'
require 'ksp/errors/invalid_configuration'
require 'ksp/errors/missing_configuration'

module Ksp::Commands::Config
  # Command to read the stored launcher configuration.
  class Read < Cuprum::Command
    private

    def config_dir
      File.expand_path(ENV.fetch('KSP_CONFIG', '~/.ksp'))
    end

    def config_file
      File.join(config_dir, 'config.yml')
    end

    def config_file_exists?
      Dry::CLI::Utils::Files.exist?(config_file)
    end

    def parse_configuration(config:)
      Psych.safe_load(config)
    rescue Psych::SyntaxError
      error = Ksp::Errors::InvalidConfiguration.new(
        config:      config,
        config_file: config_file
      )
      failure(error)
    end

    def process(raw: false)
      config = step { read_config_file }

      return config if raw

      parse_configuration(config: config)
    end

    def read_config_file
      unless config_file_exists?
        error = Ksp::Errors::MissingConfiguration.new(config_file: config_file)

        return failure(error)
      end

      File.read(config_file)
    end
  end
end
