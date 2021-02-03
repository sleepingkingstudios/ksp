# frozen_string_literal: true

require 'psych'

require 'dry/cli/utils/files'

require 'ksp/commands'

module Ksp::Commands
  # Sets up the launcher configuration files.
  class Initialize < Ksp::Cli::Command
    desc 'Initializes the KSP launcher and local configuration.'

    argument :application_path,
      desc: 'The path to the Kerbal Space Program directory'

    option :dry_run,
      type:    :boolean,
      default: false,
      desc:    'Do not generate the configuration files'

    option :force,
      type:    :boolean,
      default: false,
      desc:    'Overwrite the existing configuration'

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

    def create_configuration_directory(dry_run:)
      if Dry::CLI::Utils::Files.directory?(config_dir)
        Kernel.puts "Configuration directory already exists at #{config_dir}"
        Kernel.puts "\n"

        return
      end

      Kernel.puts "Creating configuration directory at #{config_dir}"

      Dry::CLI::Utils::Files.mkdir(config_dir) unless dry_run

      Kernel.puts '...done!'
      Kernel.puts "\n"
    end

    def create_configuration_file(config:, dry_run:, force:)
      unless force || !config_file_exists?
        Kernel.puts "Configuration file already exists at #{config_file}"

        return
      end

      yaml = Psych.dump config

      Kernel.puts "Creating configuration file at #{config_file}"

      Dry::CLI::Utils::Files.write(config_file, yaml) unless dry_run

      yaml.each_line { |line| Kernel.puts "  #{line}" }

      Kernel.puts '...done!'
    end

    def generate_configuration(application_path:)
      { 'application_path' => application_path }
    end

    def process(application_path: '', args: [], dry_run: false, force: false) # rubocop:disable Lint/UnusedMethodArgument
      step { create_configuration_directory(dry_run: dry_run) }

      config = generate_configuration(application_path: application_path)

      create_configuration_file(config: config, dry_run: dry_run, force: force)
    end
  end
end
