# frozen_string_literal: true

require 'cuprum/error'

require 'ksp/errors'

module Ksp::Errors
  # An error returned when attempting to launch without an application path.
  class UnknownApplicationPath < Cuprum::Error
    # Short string used to identify the type of error.
    TYPE = 'ksp.errors.unknown_application_path'

    def initialize
      super(message: default_message)
    end

    # @return [String] short string used to identify the type of error.
    def type
      TYPE
    end

    private

    def default_message
      'Application path not specified.' \
      "\n" \
      "\nPlease set the path to the KSP directory in the KSP_PATH environment" \
      ' variable or run `ksp initialize` and specify the application directory.'
    end
  end
end
