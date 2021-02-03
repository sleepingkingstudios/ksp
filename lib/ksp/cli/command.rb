# frozen_string_literal: true

require 'cuprum/processing'
require 'dry/cli'

require 'ksp/cli'

module Ksp::Cli
  class Command < Dry::CLI::Command
    include Cuprum::Processing
  end
end
