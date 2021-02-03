# frozen_string_literal: true

require 'dry/cli'

require 'ksp'

module Ksp
  # Registry and namespace for dry-cli commands.
  module Commands
    extend Dry::CLI::Registry

    # Command to return the current launcher version.
    class Version < Dry::CLI::Command
      def call
        puts Ksp.version
      end
    end

    register 'version', Version
  end
end
