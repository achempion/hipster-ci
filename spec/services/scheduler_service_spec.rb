require 'rails_helper'

describe SchedulerService do
  describe '.process' do
    context 'without ready build' do
      before { expect(described_class::BuildRunner).to_not receive(:new) }

      it { expect(described_class.process).to eq(false) }
    end

    context 'with ready build' do
      let(:build) { create(:build) }

      before do
        fake_obj = double

        expect(described_class::BuildRunner).to receive(:new).with(build).and_return(fake_obj)

        expect(fake_obj).to receive(:process).and_return(true)
      end

      it { expect(described_class.process).to be(true) }
    end
  end
end