# frozen_string_literal: true

require 'ksp'

module Ksp
  # Namespace for dry-cli commands.
  module Commands
    autoload :Launch,   'ksp/commands/launch'
    autoload :Registry, 'ksp/commands/registry'
    autoload :Version,  'ksp/commands/version'
  end
end
