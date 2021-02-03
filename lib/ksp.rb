# frozen_string_literal: true

require 'ksp/version'

# Custom launch script for Kerbal Space Program.
module Ksp
  autoload :Cli,      'ksp/cli'
  autoload :Commands, 'ksp/commands'

  class << self
    # @return [String] The current version of the gem.
    def version
      VERSION
    end
  end
end
