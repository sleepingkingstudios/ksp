# frozen_string_literal: true

require 'ksp/commands/config'
require 'ksp/errors/invalid_application_path'
require 'ksp/errors/unknown_application_path'

module Ksp::Commands::Config
  # Finds and returns the configured application path.
  class ApplicationPath < Cuprum::Command
    include Ksp::Commands::Config::Helpers

    private

    def check_configuration
      result = Ksp::Commands::Config::Read.new.call

      return unless result.success?

      config = result.value
      value  = config['application_path']

      return value unless value.nil? || value.empty?

      nil
    end

    def check_environment
      value = ENV['KSP_PATH']

      return value unless value.nil? || value.empty?

      nil
    end

    def find_application_path
      value = check_environment || check_configuration

      if value.nil? || value.empty?
        error = Ksp::Errors::UnknownApplicationPath.new

        return failure(error)
      end

      value
    end

    def process
      application_dir  = step { find_application_path }
      application_path = File.join(application_dir, 'KSP.app')

      step { validate_application_path(application_path) }

      application_path
    end

    def validate_application_path(application_path)
      return if Dry::CLI::Utils::Files.exist?(application_path)

      error =
        Ksp::Errors::InvalidApplicationPath
        .new(application_path: application_path)
      failure(error)
    end
  end
end
