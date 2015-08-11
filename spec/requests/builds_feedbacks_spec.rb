require 'rails_helper'

describe 'check for updates' do
  let!(:build) { create(:build) }

  describe 'all is actual' do
    before { get '/builds_feedback', {from: build.updated_at + 1.second} }

    it { expect(response.status).to eq(200) }

    it { expect(response.body).to eq('') }
  end

  describe 'have new events' do
    let!(:current_time) { Time.parse('2014-12-07T02:03:00.000+00:00') }

    before { allow(Time).to receive(:now).and_return(current_time) }

    before { get '/builds_feedback', {from: build.updated_at - 1.second} }

    it { expect(response.status).to eq(400) }

    it { expect(JSON.parse(response.body)['from']).to eq('2014-12-07T02:03:00.000+00:00') }
  end
end