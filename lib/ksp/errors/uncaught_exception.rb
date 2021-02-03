# frozen_string_literal: true

require 'cuprum/error'

require 'ksp/errors'

module Ksp::Errors
  # An error returned when a command encounters an unhandled exception.
  class UncaughtException < Cuprum::Error
    # Short string used to identify the type of error.
    TYPE = 'ksp.errors.uncaught_exception'

    # @param exception [StandardError] The exception that was raised.
    # @param message [String] A message to display. Will be annotated with
    #   details on the exception and the exception's cause (if any).
    def initialize(exception:, message: 'uncaught exception')
      @exception = exception
      @cause     = exception.cause

      super(message: generate_message(message))
    end

    # @return [StandardError] the exception that was raised.
    attr_reader :exception

    # @return [String] short string used to identify the type of error.
    def type
      TYPE
    end

    private

    attr_reader :cause

    def generate_message(message)
      message = "#{message} #{exception.class}: #{exception.message}"

      return message unless cause

      message + " caused by #{cause.class}: #{cause.message}"
    end
  end
end
