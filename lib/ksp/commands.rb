# frozen_string_literal: true

require 'ksp'

module Ksp
  # Namespace for dry-cli commands.
  module Commands
    autoload :Config,     'ksp/commands/config'
    autoload :Initialize, 'ksp/commands/initialize'
    autoload :Launch,     'ksp/commands/launch'
    autoload :Registry,   'ksp/commands/registry'
    autoload :Version,    'ksp/commands/version'
  end
end
