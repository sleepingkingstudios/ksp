# frozen_string_literal: true

require 'ksp/errors/unknown_application_path'

RSpec.describe Ksp::Errors::UnknownApplicationPath do
  subject(:error) { described_class.new }

  describe '::TYPE' do
    include_examples 'should define immutable constant',
      :TYPE,
      'ksp.errors.unknown_application_path'
  end

  describe '.new' do
    it 'should define the constructor' do
      expect(described_class).to respond_to(:new).with(0).arguments
    end
  end

  describe '#message' do
    let(:expected) do
      'Application path not specified.' \
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
