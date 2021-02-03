# frozen_string_literal: true

require 'ksp'

module Ksp
  # Namespace for integrations between Cuprum and Dry::CLI.
  module Cli
    autoload :Command,             'ksp/cli/command'
    autoload :ErrorHandling,       'ksp/cli/error_handling'
    autoload :ParameterDelegation, 'ksp/cli/parameter_delegation'
    autoload :Registry,            'ksp/cli/registry'
  end
end
