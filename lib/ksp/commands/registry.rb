# frozen_string_literal: true

require 'dry/cli'

require 'ksp/commands'

module Ksp::Commands
  # Registry for dry-cli commands.
  module Registry
    extend Dry::CLI::Registry

    register 'version', Ksp::Commands::Version
  end
end
