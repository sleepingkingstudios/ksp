# frozen_string_literal: true

require 'ksp/commands'

module Ksp::Commands
  # Namespace for dry-cli commands.
  module Config
    autoload :Print,    'ksp/commands/config/print'
    autoload :PrintRaw, 'ksp/commands/config/print_raw'
    autoload :Read,     'ksp/commands/config/read'
  end
end
