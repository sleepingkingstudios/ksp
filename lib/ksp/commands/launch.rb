# frozen_string_literal: true

require 'dry/cli/utils/files'

require 'ksp/commands'
require 'ksp/errors/invalid_application_path'
require 'ksp/errors/unknown_application_path'

module Ksp::Commands
  # Launches the KSP application.
  class Launch < Ksp::Cli::Command
    desc 'Launches Kerbal Space Program.'

    option :dry_run,
      type:    :boolean,
      default: false,
      desc:    'Skip launching the application'

    private

    def find_application(directory:)
      app_path = File.join(directory, 'KSP.app')

      return app_path if Dry::CLI::Utils::Files.exist?(app_path)

      error = Ksp::Errors::InvalidApplicationPath.new(
        application_path: app_path
      )
      failure(error)
    end

    def find_application_directory
      return ENV['KSP_PATH'] if ENV['KSP_PATH']

      error = Ksp::Errors::UnknownApplicationPath.new
      failure(error)
    end

    def launch_application(application_path:, dry_run:)
      return if dry_run

      return if Kernel.system(%(open "#{application_path}"))

      error = Cuprum::Error.new(message: 'Unable to launch application.')
      failure(error)
    end

    def process(dry_run: false)
      application_directory = step { find_application_directory }
      application_path      = step do
        find_application(directory: application_directory)
      end

      Kernel.puts "Launching Kerbal Space Program from #{application_path}..."

      launch_application(application_path: application_path, dry_run: dry_run)
    end
  end
end
