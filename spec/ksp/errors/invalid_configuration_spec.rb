# frozen_string_literal: true

require 'ksp/errors/invalid_configuration'

RSpec.describe Ksp::Errors::InvalidConfiguration do
  subject(:error) do
    described_class.new(config: config, config_file: config_file)
  end

  let(:config)      { "---\ninvalid yaml" }
  let(:config_file) { '/path/to/config_file' }

  describe '::TYPE' do
    include_examples 'should define immutable constant',
      :TYPE,
      'ksp.errors.invalid_configuration'
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to respond_to(:new)
        .with(0).arguments
        .and_keywords(:config, :config_file)
    end
  end

  describe '#config' do
    include_examples 'should define reader', :config, -> { be == config }
  end

  describe '#config_file' do
    include_examples 'should define reader',
      :config_file,
      -> { be == config_file }
  end

  describe '#message' do
    let(:expected) do
      "Unable to parse configuration file at #{config_file}" \
      "\n" \
      "\n#{config}" \
      "\n" \
      "\nPlease run `ksp initialize --force` to regenerate the launcher" \
      ' configuration.'
    end

    include_examples 'should define reader', :message, -> { be == expected }
  end

  describe '#type' do
    include_examples 'should define reader', :type, described_class::TYPE
  end
end
