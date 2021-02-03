# frozen_string_literal: true

require 'ksp/cli'

module Ksp::Cli
  # Delegates Dry::CLI parameter class methods to the superclass.
  module ParameterDelegation
    def arguments
      superclass.arguments
    end

    def description
      superclass.description
    end

    def examples
      superclass.examples
    end

    def options
      superclass.options
    end

    def params
      superclass.params
    end
  end
end
