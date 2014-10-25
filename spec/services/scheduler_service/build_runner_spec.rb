require 'rails_helper'

describe SchedulerService::BuildRunner do
  let!(:build) { create(:build) }

  describe '#process' do
    let(:runner) { described_class.new(build) }

    context 'with success status' do
      before do
        expect(runner).to receive(:prepare_libs).and_return(true)
        expect(runner).to receive(:prepare_files).and_return(true)
        expect(runner).to receive(:prepare_gems).and_return(true)
        expect(runner).to receive(:run_specs).and_return(true)

        expect(runner).to receive(:notificate!)

        runner.process
      end

      it { expect(build.reload).to be_success }
    end

    context 'with fail status' do
      before do
        expect(runner).to receive(:prepare_libs).and_return(false)

        expect(runner).to_not receive(:prepare_files)
        expect(runner).to_not receive(:prepare_gems)
        expect(runner).to_not receive(:run_specs)

        expect(runner).to receive(:notificate!)

        runner.process
      end

      it { expect(build.reload).to be_fail }
    end
  end
end