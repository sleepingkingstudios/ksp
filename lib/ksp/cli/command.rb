# frozen_string_literal: true

require 'cuprum/processing'
require 'cuprum/steps'
require 'dry/cli'

require 'ksp/cli'

module Ksp::Cli
  # Abstract Dry::CLI command implemented using Cuprum.
  class Command < Dry::CLI::Command
    include Cuprum::Processing
    include Cuprum::Steps

    def call(*args, **kwargs, &block)
      steps { super }
    end
  end
end
