# frozen_string_literal: true

require 'dry/cli'

require 'ksp/cli'

module Ksp::Cli
  # Abstract registry for Dry::CLI commands built on Cuprum.
  module Registry
    include Dry::CLI::Registry

    class << self
      private

      def extended(other)
        super

        Dry::CLI::Registry.extended(other)
      end
    end

    def register(name, command = nil, aliases: [], &block)
      command = Class.new(command) do
        prepend Ksp::Cli::ErrorHandling
        extend  Ksp::Cli::ParameterDelegation
      end

      super(name, command, aliases: aliases, &block)
    end
  end
end
