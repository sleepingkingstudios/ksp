# frozen_string_literal: true

require 'cuprum/error'

require 'ksp/errors'

module Ksp::Errors
  # An error returned when a command encounters an unhandled exception.
  class UncaughtException < Cuprum::Error
    # Short string used to identify the type of error.
    TYPE = 'cuprum.collections.errors.uncaught_exception'

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

    # @return [Hash] a serializable hash representation of the error.
    def as_json
      {
        'data'    => json_data,
        'message' => message,
        'type'    => type
      }
    end

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

    def json_data # rubocop:disable Metrics/MethodLength
      data = {
        'exception_backtrace' => exception.backtrace,
        'exception_class'     => exception.class,
        'exception_message'   => exception.message
      }

      return data unless cause

      data.update(
        {
          'cause_backtrace' => cause.backtrace,
          'cause_class'     => cause.class,
          'cause_message'   => cause.message
        }
      )
    end
  end
end
