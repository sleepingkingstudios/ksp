# frozen_string_literal: true

require 'ksp/errors/missing_configuration'

RSpec.describe Ksp::Errors::MissingConfiguration do
  subject(:error) { described_class.new(config_file: config_file) }

  let(:config_file) { '/path/to/config_file' }

  describe '::TYPE' do
    include_examples 'should define immutable constant',
      :TYPE,
      'ksp.errors.missing_configuration'
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to respond_to(:new)
        .with(0).arguments
        .and_keywords(:config_file)
    end
  end

  describe '#config_file' do
    include_examples 'should define reader',
      :config_file,
      -> { be == config_file }
  end

  describe '#message' do
    let(:expected) do
      "Configuration file not found at #{config_file}" \
      "\n" \
      "\nPlease run `ksp initialize` to generate the launcher configuration."
    end

    include_examples 'should define reader', :message, -> { be == expected }
  end

  describe '#type' do
    include_examples 'should define reader', :type, described_class::TYPE
  end
end
