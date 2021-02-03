# frozen_string_literal: true

require 'ksp/commands'

module Ksp::Commands
  # Registry for dry-cli commands.
  module Registry
    extend Ksp::Cli::Registry

    register 'initialize', Ksp::Commands::Initialize
    register 'launch',     Ksp::Commands::Launch
    register 'version',    Ksp::Commands::Version
  end
end
