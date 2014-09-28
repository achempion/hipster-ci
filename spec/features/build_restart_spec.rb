require 'rails_helper'

describe 'restart build' do
  let!(:build) { create(:build) }

  describe 'restart button' do
    context 'with :sheduled status' do
      before { build.scheduled!; visit builds_path }

      it { expect(page).to_not have_selector("a[href='#{restart_build_path(build)}']") }
    end

    context 'with :in_progress status' do
      before { build.in_progress!; visit builds_path }

      it { expect(page).to_not have_selector("a[href='#{restart_build_path(build)}']") }
    end

    context 'with :fail status' do
      before { build.fail!; visit builds_path }

      it { expect(page).to have_selector("a[href='#{restart_build_path(build)}']") }
    end

    context 'with :success status' do
      before { build.success!; visit builds_path }

      it { expect(page).to have_selector("a[href='#{restart_build_path(build)}']") }
    end
  end

  describe 'click restart button' do
    before do
      build.result = 'some result'
      build.success!

      visit builds_path

      click_link('restart')
    end

    context 'ready to start again' do
      before { build.reload }

      it do
        expect(build.result).to be(nil)
        expect(build.scheduled?).to be(true)
      end
    end
  end
end