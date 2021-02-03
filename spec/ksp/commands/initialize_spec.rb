# frozen_string_literal: true

require 'ksp/commands/initialize'

RSpec.describe Ksp::Commands::Initialize do
  subject(:command) { described_class.new }

  describe '.new' do
    it { expect(described_class).to respond_to(:new).with(0).arguments }
  end

  describe '#call' do
    let(:application_path) { '' }
    let(:directory_path)   { File.expand_path('~/.ksp') }
    let(:directory_exists) { false }
    let(:file_path)        { File.join(directory_path, 'config.yml') }
    let(:file_exists)      { false }
    let(:config) do
      Psych.dump({ 'application_path' => application_path })
    end
    let(:config_output) do
      config.strip.gsub(/(\n|\A)/) { |match| "#{match}  " }
    end

    before(:example) do
      allow(Kernel).to receive(:puts)

      allow(Dry::CLI::Utils::Files)
        .to receive(:directory?)
        .with(directory_path)
        .and_return(directory_exists)
      allow(Dry::CLI::Utils::Files)
        .to receive(:exist?)
        .with(file_path)
        .and_return(file_exists)
      allow(Dry::CLI::Utils::Files).to receive(:mkdir)
      allow(Dry::CLI::Utils::Files).to receive(:write)
    end

    context 'when the directory does not exist' do
      let(:expected_output) do
        <<~TEXT
          Creating configuration directory at #{directory_path}
          ...done!

          Creating configuration file at #{file_path}
          #{config_output}
          ...done!
        TEXT
      end

      it 'should create the directory' do
        command.call

        expect(Dry::CLI::Utils::Files)
          .to have_received(:mkdir)
          .with(directory_path)
      end

      it 'should create the file' do
        command.call

        expect(Dry::CLI::Utils::Files)
          .to have_received(:write)
          .with(file_path, config)
      end

      it 'should report to STDOUT' do
        allow(Kernel).to receive(:puts).and_call_original

        expect { command.call }.to output(expected_output).to_stdout
      end

      describe 'with application_path: value' do
        let(:application_path) { '/path/to/application_path' }

        it 'should create the file' do
          command.call(application_path: application_path)

          expect(Dry::CLI::Utils::Files)
            .to have_received(:write)
            .with(file_path, config)
        end

        it 'should report to STDOUT' do
          allow(Kernel).to receive(:puts).and_call_original

          expect do
            command.call(application_path: application_path)
          end.to output(expected_output).to_stdout
        end
      end

      describe 'with dry_run: true' do
        it 'should not create the directory' do
          command.call(dry_run: true)

          expect(Dry::CLI::Utils::Files).not_to have_received(:mkdir)
        end

        it 'should not create the file' do
          command.call(dry_run: true)

          expect(Dry::CLI::Utils::Files).not_to have_received(:write)
        end

        it 'should report to STDOUT' do
          allow(Kernel).to receive(:puts).and_call_original

          expect { command.call(dry_run: true) }
            .to output(expected_output).to_stdout
        end
      end
    end

    context 'when the directory exists' do
      let(:directory_exists) { true }
      let(:expected_output) do
        <<~TEXT
          Configuration directory already exists at #{directory_path}

          Creating configuration file at #{file_path}
          #{config_output}
          ...done!
        TEXT
      end

      it 'should not create the directory' do
        command.call

        expect(Dry::CLI::Utils::Files).not_to have_received(:mkdir)
      end

      it 'should create the file' do
        command.call

        expect(Dry::CLI::Utils::Files)
          .to have_received(:write)
          .with(file_path, config)
      end

      it 'should report to STDOUT' do
        allow(Kernel).to receive(:puts).and_call_original

        expect { command.call }.to output(expected_output).to_stdout
      end

      describe 'with application_path: value' do
        let(:application_path) { '/path/to/application_path' }

        it 'should create the file' do
          command.call(application_path: application_path)

          expect(Dry::CLI::Utils::Files)
            .to have_received(:write)
            .with(file_path, config)
        end

        it 'should report to STDOUT' do
          allow(Kernel).to receive(:puts).and_call_original

          expect do
            command.call(application_path: application_path)
          end.to output(expected_output).to_stdout
        end
      end

      describe 'with dry_run: true' do
        it 'should not create the directory' do
          command.call(dry_run: true)

          expect(Dry::CLI::Utils::Files).not_to have_received(:mkdir)
        end

        it 'should not create the file' do
          command.call(dry_run: true)

          expect(Dry::CLI::Utils::Files).not_to have_received(:write)
        end

        it 'should report to STDOUT' do
          allow(Kernel).to receive(:puts).and_call_original

          expect { command.call(dry_run: true) }
            .to output(expected_output).to_stdout
        end
      end
    end

    context 'when the file exists' do
      let(:directory_exists) { true }
      let(:file_exists)      { true }
      let(:expected_output) do
        <<~TEXT
          Configuration directory already exists at #{directory_path}

          Configuration file already exists at #{file_path}
        TEXT
      end

      it 'should not create the directory' do
        command.call

        expect(Dry::CLI::Utils::Files).not_to have_received(:mkdir)
      end

      it 'should not create the file' do
        command.call

        expect(Dry::CLI::Utils::Files).not_to have_received(:write)
      end

      it 'should report to STDOUT' do
        allow(Kernel).to receive(:puts).and_call_original

        expect { command.call }.to output(expected_output).to_stdout
      end

      describe 'with application_path: value and force: true' do
        let(:application_path) { '/path/to/application_path' }
        let(:expected_output) do
          <<~TEXT
            Configuration directory already exists at #{directory_path}

            Creating configuration file at #{file_path}
            #{config_output}
            ...done!
          TEXT
        end

        it 'should create the file' do
          command.call(application_path: application_path, force: true)

          expect(Dry::CLI::Utils::Files)
            .to have_received(:write)
            .with(file_path, config)
        end

        it 'should report to STDOUT' do
          allow(Kernel).to receive(:puts).and_call_original

          expect do
            command.call(application_path: application_path, force: true)
          end.to output(expected_output).to_stdout
        end
      end

      describe 'with dry_run: true' do
        it 'should not create the directory' do
          command.call(dry_run: true)

          expect(Dry::CLI::Utils::Files).not_to have_received(:mkdir)
        end

        it 'should not create the file' do
          command.call(dry_run: true)

          expect(Dry::CLI::Utils::Files).not_to have_received(:write)
        end

        it 'should report to STDOUT' do
          allow(Kernel).to receive(:puts).and_call_original

          expect { command.call(dry_run: true) }
            .to output(expected_output).to_stdout
        end
      end

      describe 'with force: true' do
        let(:expected_output) do
          <<~TEXT
            Configuration directory already exists at #{directory_path}

            Creating configuration file at #{file_path}
            #{config_output}
            ...done!
          TEXT
        end

        it 'should not create the directory' do
          command.call(force: true)

          expect(Dry::CLI::Utils::Files).not_to have_received(:mkdir)
        end

        it 'should create the file' do
          command.call(force: true)

          expect(Dry::CLI::Utils::Files)
            .to have_received(:write)
            .with(file_path, config)
        end

        it 'should report to STDOUT' do
          allow(Kernel).to receive(:puts).and_call_original

          expect { command.call(force: true) }
            .to output(expected_output).to_stdout
        end
      end
    end
  end
end
