# frozen_string_literal: true

require 'cuprum/error'

require 'ksp/errors'

module Ksp::Errors
  # Error returned when attempting to read a missing configuration file.
  class MissingConfiguration < Cuprum::Error
    # Short string used to identify the type of error.
    TYPE = 'ksp.errors.missing_configuration'

    # @param config_file [String] The path to the expected configuration file.
    def initialize(config_file:)
      @config_file = config_file

      super(message: default_message)
    end

    # @return [String] the path to the expected configuration file.
    attr_reader :config_file

    # @return [String] short string used to identify the type of error.
    def type
      TYPE
    end

    private

    def default_message
      "Configuration file not found at #{config_file}" \
      "\n" \
      "\nPlease run `ksp initialize` to generate the launcher configuration."
    end
  end
end
