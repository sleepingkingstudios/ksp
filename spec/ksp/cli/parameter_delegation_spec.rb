# frozen_string_literal: true

require 'dry/cli'

require 'ksp/cli/parameter_delegation'

RSpec.describe Ksp::Cli::ParameterDelegation do
  example_class 'Spec::BaseCommand', Dry::CLI::Command do |command|
    command.desc 'Create the perfect system'

    command.argument :name, required: true, default: 'Kevin Flynn'

    command.argument :program, default: 'Clu'

    command.example [
      '# Creates the perfect system'
    ]

    command.option :confirm, type: :boolean, desc: 'Are you sure?'
  end

  example_class 'Spec::Command', 'Spec::BaseCommand' do |command|
    command.extend(described_class)
  end

  describe '.arguments' do
    it 'should delegate the arguments' do
      expect(Spec::Command.arguments).to be == Spec::BaseCommand.arguments
    end
  end

  describe '.default_params' do
    it 'should delegate the default parameters' do
      expect(Spec::Command.default_params)
        .to be == Spec::BaseCommand.default_params
    end
  end

  describe '.description' do
    it 'should delegate the description' do
      expect(Spec::Command.description).to be == Spec::BaseCommand.description
    end
  end

  describe '.examples' do
    it 'should delegate the examples' do
      expect(Spec::Command.examples).to be == Spec::BaseCommand.examples
    end
  end

  describe '.options' do
    it 'should delegate the options' do
      expect(Spec::Command.options).to be == Spec::BaseCommand.options
    end
  end

  describe '.optional_arguments' do
    it 'should delegate the optional arguments' do
      expect(Spec::Command.optional_arguments)
        .to be == Spec::BaseCommand.optional_arguments
    end
  end

  describe '.params' do
    it 'should delegate the params' do
      expect(Spec::Command.params)
        .to be == Spec::BaseCommand.params
    end
  end

  describe '.required_arguments' do
    it 'should delegate the required arguments' do
      expect(Spec::Command.required_arguments)
        .to be == Spec::BaseCommand.required_arguments
    end
  end
end
