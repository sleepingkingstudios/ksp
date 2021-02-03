# frozen_string_literal: true

require 'cuprum/error'

require 'ksp/errors'

module Ksp::Errors
  # Error returned when attempting to launch with an invalid application path.
  class InvalidApplicationPath < Cuprum::Error
    # Short string used to identify the type of error.
    TYPE = 'ksp.errors.invalid_application_path'

    # @param application_path [String] The given path for the Kerbal Space
    #   Program application.
    def initialize(application_path:)
      @application_path = application_path

      super(message: default_message)
    end

    # @return [String] The given path for the Kerbal Space Program application.
    attr_reader :application_path

    # @return [String] short string used to identify the type of error.
    def type
      TYPE
    end

    private

    def default_message
      "Application not found at #{application_path.inspect}."\
      "\n" \
      "\nPlease set the path to the KSP directory in the KSP_PATH environment" \
      ' variable or run `ksp initialize` and specify the application directory.'
    end
  end
end
