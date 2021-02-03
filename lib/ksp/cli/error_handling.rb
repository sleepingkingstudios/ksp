# frozen_string_literal: true

require 'ksp/cli'
require 'ksp/errors/uncaught_exception'

module Ksp::Cli
  # Mixin to handle failed commands called from a registry.
  module ErrorHandling
    def call(*args, **kwargs, &block)
      result =
        begin
          super
        rescue StandardError => exception
          failure(Ksp::Errors::UncaughtException.new(exception: exception))
        end

      return result if result.success?

      Kernel.warn result.error.message

      Kernel.exit 1
    end
  end
end
