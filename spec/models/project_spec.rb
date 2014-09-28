require 'rails_helper'

describe Project do

  describe '#access_token' do
    describe 'default token exists' do
      it { expect(Rails.configuration.default_project_access_token).to eq('test-access-token') }
    end

    context 'with empty token' do
      let(:token) { described_class.new(path: 'some/path').access_token }

      it { expect(token).to eq(Rails.configuration.default_project_access_token)}
    end

    context 'with not empty token' do
      let(:token) { described_class.new(path: 'some/path', access_token: 'custom').access_token }

      it { expect(token).to eq('custom') }
    end
  end

end