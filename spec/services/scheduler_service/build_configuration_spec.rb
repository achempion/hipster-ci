require 'rails_helper'

describe SchedulerService::BuildConfiguration do

  let!(:build_folder) { Pathname.new('path_to_build_folder') }

  let(:configuration) { described_class.new build_folder }

  context 'with configuration file' do
    let!(:fake_configuration_file) do
      YAML.load_file(Rails.root.join('spec', 'support', 'scheduler_service', 'hipster_ci.yml'))
    end

    before do
      expect_any_instance_of(Pathname).to receive(:exist?).and_return(true)

      expect(YAML).to receive(:load_file).with(build_folder.join('config', 'hipster_ci.yml')).and_return(fake_configuration_file)
    end

    describe '#requirements' do
      it { expect(configuration.requirements).to eq(['xfvb', 'curl', 'mysql-server']) }
    end

    describe '#spec_command' do
      it { expect(configuration.spec_command).to eq('xvfb-run rspec') }
    end

    describe '#database' do
      context 'allowed database' do
        it { expect(configuration.database.name).to eq('mysql') }
      end

      context 'not allowed database' do
        before { fake_configuration_file[:database] = 'awful database' }

        it { expect { configuration.database.name }.to raise_error(SchedulerService::BuildConfiguration::BuildConfigurationError, 'Can\'t use awful database as custom database') }
      end
    end

    describe '#test_environment' do
      it { expect(configuration.test_environment).to eq('test') }
    end
  end

  context 'without configuration file' do
    describe '#requirements' do
      it { expect(configuration.requirements).to eq([]) }
    end

    describe '#database' do
      it { expect(configuration.database.name).to eq('sqlite') }
    end

    describe '#spec_command' do
      context 'project with spec folder' do
        before do
          expect(File).to receive(:directory?).with(build_folder.join('spec')).and_return(true)
        end

        it { expect(configuration.spec_command).to eq('rspec') }
      end

      context 'project without spec folder' do
        it { expect(configuration.spec_command).to eq('rake') }
      end
    end

    describe '#test_environment' do
      it { expect(configuration.test_environment).to eq('test') }
    end
  end

end