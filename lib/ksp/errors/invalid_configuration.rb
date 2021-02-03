# frozen_string_literal: true

require 'cuprum/error'

require 'ksp/errors'

module Ksp::Errors
  # Error returned when attempting to parse an invalid configuration file.
  class InvalidConfiguration < Cuprum::Error
    # Short string used to identify the type of error.
    TYPE = 'ksp.errors.invalid_configuration'

    # @param config [String] The unparsed contents of the configuration file.
    # @param config_file [String] The path to the expected configuration file.
    def initialize(config:, config_file:)
      @config      = config
      @config_file = config_file

      super(message: default_message)
    end

    # @return [String] the unparsed contents of the configuration file.
    attr_reader :config

    # @return [String] the path to the expected configuration file.
    attr_reader :config_file

    # @return [String] short string used to identify the type of error.
    def type
      TYPE
    end

    private

    def default_message
      "Unable to parse configuration file at #{config_file}" \
      "\n" \
      "\n#{config}" \
      "\n" \
      "\nPlease run `ksp initialize --force` to regenerate the launcher" \
      ' configuration.'
    end
  end
end
