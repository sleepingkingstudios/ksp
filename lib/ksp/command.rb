# frozen_string_literal: true

require 'cuprum/processing'
require 'dry/cli'

require 'ksp'

module Ksp
  class Command < Dry::CLI::Command
    include Cuprum::Processing
  end
end
