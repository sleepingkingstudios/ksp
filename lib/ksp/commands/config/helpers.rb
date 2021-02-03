# frozen_string_literal: true

require 'ksp/commands/config'

module Ksp::Commands::Config
  # Shared helper methods for accessing the local configuration.
  module Helpers
    def config_dir
      return @config_dir if @config_dir

      config_path = ENV['KSP_CONFIG']
      config_path = '~/.ksp' if config_path.nil? || config_path.empty?

      @config_dir = File.expand_path(config_path)
    end

    def config_file
      File.join(config_dir, 'config.yml')
    end

    def config_file_exists?
      Dry::CLI::Utils::Files.exist?(config_file)
    end
  end
end
