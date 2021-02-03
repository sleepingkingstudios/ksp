# frozen_string_literal: true

require 'ksp/errors/invalid_application_path'

RSpec.describe Ksp::Errors::InvalidApplicationPath do
  subject(:error) { described_class.new(application_path: application_path) }

  let(:application_path) { '/path/to/application' }

  describe '::TYPE' do
    include_examples 'should define immutable constant',
      :TYPE,
      'ksp.errors.invalid_application_path'
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class)
        .to respond_to(:new)
        .with(0).arguments
        .and_keywords(:application_path)
    end
  end

  describe '#application_path' do
    include_examples 'should define reader',
      :application_path,
      -> { be == application_path }
  end

  describe '#message' do
    let(:expected) do
      "Application not found at #{application_path.inspect}."\
      "\n" \
      "\nPlease set the path to the KSP directory in the KSP_PATH environment" \
      ' variable or run `ksp initialize` and specify the application directory.'
    end

    include_examples 'should define reader', :message, -> { be == expected }
  end

  describe '#type' do
    include_examples 'should define reader', :type, described_class::TYPE
  end
end
